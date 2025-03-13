MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
.DELETE_ON_ERROR:
.SUFFIXES:
.SECONDARY:

RUN = poetry run
# get values from about.yaml file
SCHEMA_NAME = linkml_model
SOURCE_SCHEMA_PATH = $(shell sh ./utils/get-value.sh source_schema_path)
SRC = .
DEST = staging
PYMODEL = linkml_model
DOCDIR = docs/source

$(PYMODEL):
	mkdir -p $@

$(DEST):
	mkdir -p $@

# basename of a YAML file in model/
.PHONY: all clean

help: status
	@echo ""
	@echo "make all -- makes site locally"
	@echo "make install -- install dependencies"
	@echo "make setup -- initial setup"
	@echo "make test -- runs tests"
	@echo "make testdoc -- builds docs and runs local test server"
	@echo "make deploy -- deploys site"
	@echo "make update -- updates linkml version"
	@echo "make help -- show this help"
	@echo ""

status: check-config
	@echo "Project: $(SCHEMA_NAME)"
	@echo "Source: $(SOURCE_SCHEMA_PATH)"

setup: install gen-project gen-doc git-init-add

install:
	poetry install
.PHONY: install

all: gen-project gen-doc
%.yaml: gen-project
deploy: gen-doc mkd-gh-deploy

# generates all project files
# and updates the artifacts in linkml-model
gen-project: $(PYMODEL) gen-py
	$(RUN) gen-project -d $(DEST) --config-file gen_project_config.yaml $(SOURCE_SCHEMA_PATH)
	cp -r $(DEST)/* $(PYMODEL)

gen-py: $(DEST)
	# for all the files in the schema folder, run the gen-python command and output the result to the top
	# level of the project.  In other repos, we'd include mergeimports=True, but we don't do that with
	# linkml-model.
	@for file in $(wildcard $(PYMODEL)/model/schema/*.yaml); do \
		base=$$(basename $$file); \
		filename_without_suffix=$${base%.*}; \
		$(RUN) gen-python --genmeta $$file > $(DEST)/$$filename_without_suffix.py; \
	done
	cp $(DEST)/*.py $(PYMODEL)

gen-doc:
	$(RUN) gen-doc --genmeta --sort-by rank -d $(DOCDIR)/docs $(SOURCE_SCHEMA_PATH)
	cp -r linkml_model/model/docs/* $(DOCDIR)/docs
	cp -r $(PYMODEL) $(DOCDIR)/$(PYMODEL)
	rm -rf $(DOCDIR)/$(PYMODEL)/model/docs
	cp README.md $(DOCDIR)

test: test-schema test-python test-validate-schema test-examples
test-schema:
	$(RUN) gen-project -d tmp $(SOURCE_SCHEMA_PATH)

test-python:
	$(RUN) python -m unittest discover

# TODO: switch to linkml-run-examples when normalize is implemented
test-examples: $(SOURCE_SCHEMA_PATH)
	$(RUN) linkml-validate -s $(SOURCE_SCHEMA_PATH) tests/input/examples/schema_definition-*.yaml
#	$(RUN) linkml-run-examples -s $(SOURCE_SCHEMA_PATH) -e tests/input/examples -d /tmp/
#	find tests/input/examples | ./utils/run-examples.pl

test-validate-schema:
	$(RUN) linkml-normalize -s $(SOURCE_SCHEMA_PATH) $(SOURCE_SCHEMA_PATH) -o /tmp/schema

check-config:
	@(grep my-datamodel about.yaml > /dev/null && printf "\n**Project not configured**:\n\n  - Remember to edit 'about.yaml'\n\n" || exit 0)

convert-examples-to-%:
	$(patsubst %, $(RUN) linkml-convert  % -s $(SOURCE_SCHEMA_PATH) -C Person, $(shell find src/data/examples -name "*.yaml")) 

examples/%.yaml: src/data/examples/%.yaml
	$(RUN) linkml-convert -s $(SOURCE_SCHEMA_PATH) -C Person $< -o $@
examples/%.json: src/data/examples/%.yaml
	$(RUN) linkml-convert -s $(SOURCE_SCHEMA_PATH) -C Person $< -o $@
examples/%.ttl: src/data/examples/%.yaml
	$(RUN) linkml-convert -P EXAMPLE=http://example.org/ -s $(SOURCE_SCHEMA_PATH) -C Person $< -o $@

upgrade:
	poetry add -D linkml@latest

# Test documentation locally
serve: mkd-serve

testdoc: gen-doc serve

builddoc:
	$(RUN) mkdocs build

MKDOCS = $(RUN) mkdocs
mkd-%:
	$(MKDOCS) $*

PROJECT_FOLDERS = sqlschema shex shacl protobuf prefixmap owl jsonschema jsonld graphql excel
git-init-add: git-init git-add git-commit git-status
git-init:
	git init
git-add:
	git add .gitignore .github Makefile LICENSE *.md examples utils about.yaml mkdocs.yml poetry.lock project.Makefile pyproject.toml src/linkml/*yaml src/*/datamodel/*py src/data
	git add $(patsubst %, project/%, $(PROJECT_FOLDERS))
git-commit:
	git commit -m 'Initial commit' -a
git-status:
	git status

clean:
	rm -rf $(DEST)
	rm -rf docs
	rm -rf tmp

spell:
	poetry run codespell

lint:
	poetry run yamllint -c .yamllint-config linkml_model/model/schema/*.yaml

include project.Makefile

