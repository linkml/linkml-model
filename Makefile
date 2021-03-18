# All artifacts of the build should be preserved
.SECONDARY:

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
TGTS = docs graphql json jsonld jsonschema owl linkml_model rdf shex

# Global generation options
GEN_OPTS =

# ----------------------------------------
# TOP LEVEL TARGETS
# ----------------------------------------
all: gen stage unlock

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
# GEN: generate the new output into the target directory
# ---------------------------------------
gen: $(patsubst %,gen-%,$(TGTS))

# ---------------------------------------
# CLEAN: clear out all of the target directories
# ---------------------------------------
clean:
	rm -rf target/
	rm -f env.lock
	pipenv --rm

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

# ---------------------------------------
# STAGE: Copy the newly generated targets to their destinations
# ---------------------------------------
stage: $(patsubst %,stage-%,$(TGTS))
stage-%: gen-%
	find $* ! -name 'README.*' ! -name $* ! -name __init__.py -type f -exec rm -f {} +
	cp -pR target/$* .

tdir-%:
	mkdir -p target/$*

docs:
	mkdir -p $@


# ---------------------------------------
# MARKDOWN DOCS
#      Generate documentation ready for mkdocs
#      Note: phony means that even IF gen-docs exists as a file, we run this
# ---------------------------------------
gen-docs:  $(patsubst %, target/docs/%.md, $(SCHEMA_NAMES)) env.lock copy-src-docs
.PHONY: gen-docs
copy-src-docs:
	cp -R $(MODEL_DOCS_DIR)/*md target/docs/
target/docs/%.md: $(SCHEMA_DIR)/%.yaml tdir-docs env.lock
	$(RUN) gen-markdown $(GEN_OPTS) --no-mergeimports --dir target/docs $<

# ---------------------------------------
# PYTHON Source
# ---------------------------------------
gen-linkml_model: $(patsubst %, target/$(PKG_DIR)/%.py, $(SCHEMA_NAMES))
.PHONY: gen-linkml_model
target/$(PKG_DIR)/%.py: $(SCHEMA_DIR)/%.yaml  tdir-linkml_model env.lock
	$(RUN) gen-py-classes $(GEN_OPTS) --genmeta --no-slots --no-mergeimports $< > $@

# ---------------------------------------
# GRAPHQL Source
# ---------------------------------------
# TODO: modularize imports. For now imports are merged.
gen-graphql:target/graphql/$(SCHEMA_NAME).graphql $(patsubst %, target/graphql/%.graphql, $(SCHEMA_NAMES))
.PHONY: gen-graphql
target/graphql/%.graphql: $(SCHEMA_DIR)/%.yaml tdir-graphql env.lock
	$(RUN) gen-graphql $(GEN_OPTS) $< > $@

# ---------------------------------------
# JSON Schema
# ---------------------------------------
gen-jsonschema: target/jsonschema/$(SCHEMA_NAME).schema.json $(patsubst %, target/jsonschema/%.schema.json, $(SCHEMA_NAMES))
.PHONY: gen-jsonschema
target/jsonschema/%.schema.json: $(SCHEMA_DIR)/%.yaml tdir-jsonschema env.lock
	$(RUN) gen-json-schema $(GEN_OPTS) -t transaction $< > $@

# ---------------------------------------
# ShEx
# ---------------------------------------
gen-shex: $(patsubst %, target/shex/%.shex, $(SCHEMA_NAMES)) $(patsubst %, target/shex/%.shexj, $(SCHEMA_NAMES))
.PHONY: gen-shex
target/shex/%.shex: $(SCHEMA_DIR)/%.yaml tdir-shex env.lock
	$(RUN) gen-shex --no-mergeimports $(GEN_OPTS) $< > $@
target/shex/%.shexj: $(SCHEMA_DIR)/%.yaml tdir-shex env.lock
	$(RUN) gen-shex --no-mergeimports $(GEN_OPTS) -f json $< > $@

# ---------------------------------------
# OWL
# ---------------------------------------
# TODO: modularize imports. For now imports are merged.
gen-owl: target/owl/$(SCHEMA_NAME).owl.ttl
.PHONY: gen-owl
target/owl/%.owl.ttl: $(SCHEMA_DIR)/%.yaml tdir-owl env.lock
	$(RUN) gen-owl $(GEN_OPTS) $< > $@

# ---------------------------------------
# JSON-LD Context
# ---------------------------------------
gen-jsonld: $(patsubst %, target/jsonld/%.context.jsonld, $(SCHEMA_NAMES)) $(patsubst %, target/jsonld/%.model.context.jsonld, $(SCHEMA_NAMES)) target/jsonld/context.jsonld
.PHONY: gen-jsonld
target/jsonld/%.context.jsonld: $(SCHEMA_DIR)/%.yaml tdir-jsonld env.lock
	$(RUN) gen-jsonld-context $(GEN_OPTS) --no-mergeimports $< > $@
target/jsonld/%.model.context.jsonld: $(SCHEMA_DIR)/%.yaml tdir-jsonld env.lock
	$(RUN) gen-jsonld-context $(GEN_OPTS) --no-mergeimports $< > $@
target/jsonld/context.jsonld: target/jsonld/meta.context.jsonld
	cp target/jsonld/meta.context.jsonld target/jsonld/context.jsonld

# ---------------------------------------
# PO JSON
# ---------------------------------------
gen-json: $(patsubst %, target/json/%.json, $(SCHEMA_NAMES))
.PHONY: gen-json
target/json/%.json: $(SCHEMA_DIR)/%.yaml tdir-json env.lock
	$(RUN) gen-jsonld $(GEN_OPTS) --no-mergeimports $< > $@

# ---------------------------------------
# RDF
# ---------------------------------------
#gen-rdf: $(patsubst %, target/rdf/%.ttl, $(SCHEMA_NAMES)) $(patsubst %, target/rdf/%.model.ttl, $(SCHEMA_NAMES))
gen-rdf: tdir-rdf
.PHONY: gen-rdf
#target/rdf/%.ttl: $(SCHEMA_DIR)/%.yaml target/jsonld/%.context.jsonld tdir-rdf env.lock
#	$(RUN) gen-rdf $(GEN_OPTS) --context $(subst target/jsonld/,,$(word 2,$^)) $< > $@
#target/rdf/%.model.ttl: $(SCHEMA_DIR)/%.yaml target/jsonld/%.model.context.jsonld tdir-rdf env.lock
#	$(RUN) gen-rdf $(GEN_OPTS) --context $(subst target/jsonld/,,$(word 2,$^)) $< > $@


# test docs locally.
docserve:
	mkdocs serve

gh-deploy:
	mkdocs gh-deploy
