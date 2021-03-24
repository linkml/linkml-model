
# ----------------------------------------
# Model documentation and schema directory
# ----------------------------------------
SRC_DIR = model
PKG_DIR = linkml_model
SCHEMA_DIR = $(SRC_DIR)/schema
MODEL_DOCS_DIR = $(SRC_DIR)/docs
SOURCE_FILES := $(shell find $(SCHEMA_DIR) -name '*.yaml')
SCHEMA_NAMES = $(patsubst $(SCHEMA_DIR)/%.yaml, %, $(SOURCE_FILES))
RUN = pipenv run

SCHEMA_NAME = meta
SCHEMA_SRC = $(SCHEMA_DIR)/$(SCHEMA_NAME).yaml
PKG_TGTS = graphql json jsonld jsonschema owl rdf shex
TGTS = docs python $(PKG_TGTS)

# Global generation options
GEN_OPTS =

# ----------------------------------------
# TOP LEVEL TARGETS
# ----------------------------------------
all: env.lock gen move-model unlock

# ---------------------------------------
# env.lock:  set up pipenv
# ---------------------------------------
export PIPENV_VERBOSITY = -1
env.lock:
	pipenv install --dev
	cp /dev/null env.lock
unlock:
#	pipenv --rm
	rm env.lock

# ---------------------------------------
# GEN: run generator for each target
# ---------------------------------------
gen: $(patsubst %,gen-%,$(TGTS))

# ---------------------------------------
# CLEAN: clear out all of the targets
# ---------------------------------------
clean:
	rm -rf target/
	rm -f env.lock
#	pipenv --rm
.PHONY: clean

# ---------------------------------------
# SQUEAKY_CLEAN: remove all of the final targets to make sure we don't leave old artifacts around
# ---------------------------------------
squeaky_clean: clean $(patsubst %,squeaky_clean-%,$(PKG_TGTS))
	find docs  ! -name 'README.*' -type f -exec rm -f {} +
	find $(PKG_DIR)/model/schema  ! -name 'README.*' -type f -exec rm -f {} +
	find $(PKG_DIR) -name "*.py" ! -name "__init__.py" ! -name "linkml_files.py" -exec rm -f {} +

squeaky_clean-%: clean
	find $(PKG_DIR)/$* ! -name 'README.*' ! -name $*  -type f -exec rm -f {} +

# ---------------------------------------
# T: List files to generate
# ---------------------------------------
t:
	echo $(SCHEMA_NAMES)

# ---------------------------------------
# ECHO: List all targets
# ---------------------------------------
echo:
	echo $(patsubst %,gen-%,$(TGTS))


tdir-%:
	mkdir -p target/$*

docs:
	mkdir -p $@


# ---------------------------------------
# Move the model across
# ---------------------------------------
move-model:
	mkdir -p $(PKG_DIR)/model/schema
	cp -r model/schema/* $(PKG_DIR)/model/schema


# ---------------------------------------
# MARKDOWN DOCS
#      Generate documentation ready for mkdocs
# ---------------------------------------
gen-docs: docs/index.md env.lock
.PHONY: gen-docs

docs/index.md: target/docs/index.md
	cp -R $(MODEL_DOCS_DIR)/*.md docs
	cp -R target/docs/* docs
	rm -rf target/docs
target/docs/index.md: $(SCHEMA_DIR)/$(SCHEMA_NAME).yaml tdir-docs env.lock
	$(RUN) gen-markdown $(GEN_OPTS) --no-mergeimports --dir target/docs $<

# ---------------------------------------
# PYTHON Source
# ---------------------------------------
gen-python: gen-linkml_model
.PHONY: gen-python

gen-linkml_model: $(patsubst %, $(PKG_DIR)/%.py, $(SCHEMA_NAMES))
	cp -r model/schema $(PKG_DIR)

$(PKG_DIR)/%.py: target/python/%.py
	cp $< $@
target/python/%.py: $(SCHEMA_DIR)/%.yaml  tdir-python env.lock
	$(RUN) gen-py-classes $(GEN_OPTS) --genmeta --no-slots --no-mergeimports $< > $@

# ---------------------------------------
# GRAPHQL Source
# ---------------------------------------
# TODO: modularize imports. For now imports are merged.
gen-graphql: $(PKG_DIR)/graphql/$(SCHEMA_NAME).graphql
.PHONY: gen-graphql

$(PKG_DIR)/graphql/%.graphql: target/graphql/%.graphql
	cp $< $@
target/graphql/%.graphql: $(SCHEMA_DIR)/%.yaml tdir-graphql env.lock
	$(RUN) gen-graphql $(GEN_OPTS) $< > $@

# ---------------------------------------
# JSON Schema
# ---------------------------------------
gen-jsonschema: $(patsubst %, $(PKG_DIR)/jsonschema/%.schema.json, $(SCHEMA_NAMES))
.PHONY: gen-jsonschema
$(PKG_DIR)/jsonschema/%.schema.json: target/jsonschema/%.schema.json
	cp $< $@
target/jsonschema/%.schema.json: $(SCHEMA_DIR)/%.yaml tdir-jsonschema env.lock
	$(RUN) gen-json-schema $(GEN_OPTS) -t transaction $< > $@

# ---------------------------------------
# ShEx
# ---------------------------------------
gen-shex: $(patsubst %, $(PKG_DIR)/shex/%.shex, $(SCHEMA_NAMES)) $(patsubst %, $(PKG_DIR)/shex/%.shexj, $(SCHEMA_NAMES))
.PHONY: gen-shex

$(PKG_DIR)/shex/%.shex: target/shex/%.shex
	cp $< $@
$(PKG_DIR)/shex/%.shexj: target/shex/%.shexj
	cp $< $@

target/shex/%.shex: $(SCHEMA_DIR)/%.yaml tdir-shex env.lock
	$(RUN) gen-shex --no-mergeimports $(GEN_OPTS) $< > $@
target/shex/%.shexj: $(SCHEMA_DIR)/%.yaml tdir-shex env.lock
	$(RUN) gen-shex --no-mergeimports $(GEN_OPTS) -f json $< > $@

# ---------------------------------------
# OWL
# ---------------------------------------
# TODO: modularize imports. For now imports are merged.
gen-owl: $(PKG_DIR)/owl/$(SCHEMA_NAME).owl.ttl
.PHONY: gen-owl

$(PKG_DIR)/owl/%.owl.ttl: target/owl/%.owl.ttl
	cp $< $@
target/owl/%.owl.ttl: $(SCHEMA_DIR)/%.yaml tdir-owl env.lock
	$(RUN) gen-owl $(GEN_OPTS) $< > $@

# ---------------------------------------
# JSON-LD Context
# ---------------------------------------
gen-jsonld: $(patsubst %, $(PKG_DIR)/jsonld/%.context.jsonld, $(SCHEMA_NAMES)) $(patsubst %, $(PKG_DIR)/jsonld/%.model.context.jsonld, $(SCHEMA_NAMES)) $(PKG_DIR)/jsonld/context.jsonld
.PHONY: gen-jsonld

$(PKG_DIR)/jsonld/%.context.jsonld: target/jsonld/%.context.jsonld
	cp $< $@

$(PKG_DIR)/jsonld/%.model.context.jsonld: target/jsonld/%.model.context.jsonld
	cp $< $@

$(PKG_DIR)/jsonld/context.jsonld: target/jsonld/meta.context.jsonld
	cp $< $@

target/jsonld/%.context.jsonld: $(SCHEMA_DIR)/%.yaml tdir-jsonld env.lock
	$(RUN) gen-jsonld-context $(GEN_OPTS) --no-mergeimports $< > $@
target/jsonld/%.model.context.jsonld: $(SCHEMA_DIR)/%.yaml tdir-jsonld env.lock
	$(RUN) gen-jsonld-context $(GEN_OPTS) --no-mergeimports $< > $@

# ---------------------------------------
# Plain Old (PO) JSON
# ---------------------------------------
gen-json: $(patsubst %, $(PKG_DIR)/json/%.json, $(SCHEMA_NAMES))
.PHONY: gen-json

$(PKG_DIR)/json/%.json: target/json/%.json
	cp $< $@
target/json/%.json: $(SCHEMA_DIR)/%.yaml tdir-json env.lock
	$(RUN) gen-jsonld $(GEN_OPTS) --no-mergeimports $< > $@

# ---------------------------------------
# RDF
# ---------------------------------------
gen-rdf: gen-jsonld $(patsubst %, $(PKG_DIR)/rdf/%.ttl, $(SCHEMA_NAMES)) $(patsubst %, $(PKG_DIR)/rdf/%.model.ttl, $(SCHEMA_NAMES))
.PHONY: gen-rdf

$(PKG_DIR)/rdf/%.ttl: target/rdf/%.ttl
	cp $< $@
$(PKG_DIR)/rdf/%.model.ttl: target/rdf/%.model.ttl
	cp $< $@

target/rdf/%.ttl: $(SCHEMA_DIR)/%.yaml $(PKG_DIR)/jsonld/%.context.jsonld tdir-rdf env.lock
	$(RUN) gen-rdf $(GEN_OPTS) --context $(realpath $(word 2,$^)) $< > $@
target/rdf/%.model.ttl: $(SCHEMA_DIR)/%.yaml $(PKG_DIR)/jsonld/%.model.context.jsonld tdir-rdf env.lock
	$(RUN) gen-rdf $(GEN_OPTS) --context $(realpath $(word 2,$^)) $< > $@


# test docs locally.
#docserve:
#	mkdocs serve
#
#gh-deploy:
#	mkdocs gh-deploy
