# All artifacts of the build should be preserved
.SECONDARY:

# ----------------------------------------
# Model documentation and schema directory
# ----------------------------------------
SRC_DIR = model
SCHEMA_DIR = $(SRC_DIR)/schema
MODEL_DOCS_DIR = $(SRC_DIR)/docs
SOURCE_FILES := $(shell find $(SCHEMA_DIR) -name '*.yaml')
SCHEMA_NAMES = $(patsubst $(SCHEMA_DIR)/%.yaml, %, $(SOURCE_FILES))

SCHEMA_NAME = meta
SCHEMA_SRC = $(SCHEMA_DIR)/$(SCHEMA_NAME).yaml
TGTS = docs graphql json jsonld jsonschema owl python rdf shex

# Global generation options
GEN_OPTS =

# ----------------------------------------
# TOP LEVEL TARGETS
# ----------------------------------------
all: env.lock gen stage

# ---------------------------------------
# env.lock:  set up pipenv
# ---------------------------------------
export PIPENV_VERBOSITY = -1
env.lock:
	pipenv install --dev
	cp /dev/null env.lock

# ---------------------------------------
# GEN: generate the new output into the target directory
# ---------------------------------------
gen: $(patsubst %,gen-%,$(TGTS))

# ---------------------------------------
# CLEAN: clear out all of the target directories
# ---------------------------------------
clean: $(patsubst %,clean-%,$(TGTS))
	rm -rf target/
	rm -f env.lock
	pipenv --rm

clean-%:
	find $* ! -name 'README.*' -exec rm -rf {} +

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
	find $* ! -name 'README.*' -type f -exec rm -f {} +
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
gen-docs: $(patsubst %, target/python/%.md, $(SCHEMA_NAMES)) copy-src-docs
.PHONY: gen-docs
copy-src-docs:
	cp -R $(MODEL_DOCS_DIR)/docs/*md target/docs/
target/docs/%.md: $(SCHEMA_SRC) tdir-docs
	$(RUN) gen-markdown $(GEN_OPTS) --no-mergeimports --dir target/docs $<

# ---------------------------------------
# PYTHON Source
# ---------------------------------------
gen-python: $(patsubst %, target/python/%.py, $(SCHEMA_NAMES))
.PHONY: gen-python
target/python/%.py: $(SCHEMA_DIR)/%.yaml  tdir-python
	$(RUN) gen-py-classes $(GEN_OPTS) --gen-meta --no-slots --no-mergeimports $< > $@

# ---------------------------------------
# GRAPHQL Source
# ---------------------------------------
# TODO: modularize imports. For now imports are merged.
gen-graphql:target/graphql/$(SCHEMA_NAME).graphql $(patsubst %, target/graphql/%.graphql, $(SCHEMA_NAMES))
.PHONY: gen-graphql
target/graphql/%.graphql: $(SCHEMA_DIR)/%.yaml tdir-graphql
	$(RUN) gen-graphql $(GEN_OPTS) $< > $@

# ---------------------------------------
# JSON Schema
# ---------------------------------------
gen-jsonschema: target/jsonschema/$(SCHEMA_NAME).schema.json $(patsubst %, target/jsonschema/%.schema.json, $(SCHEMA_NAMES))
.PHONY: gen-jsonschema
target/jsonschema/%.schema.json: $(SCHEMA_DIR)/%.yaml tdir-jsonschema
	$(RUN) gen-json-schema $(GEN_OPTS) -t transaction $< > $@

# ---------------------------------------
# ShEx
# ---------------------------------------
gen-shex: $(patsubst %, target/shex/%.shex, $(SCHEMA_NAMES))
.PHONY: gen-shex
target/shex/%.shex: $(SCHEMA_DIR)/%.yaml tdir-shex
	$(RUN) gen-shex --no-mergeimports $(GEN_OPTS) $< > $@

# ---------------------------------------
# OWL
# ---------------------------------------
# TODO: modularize imports. For now imports are merged.
gen-owl: target/owl/$(SCHEMA_NAME).owl.ttl
.PHONY: gen-owl
target/owl/%.owl.ttl: $(SCHEMA_DIR)/%.yaml tdir-owl
	$(RUN) gen-owl $(GEN_OPTS) $< > $@

# ---------------------------------------
# JSON-LD Context
# ---------------------------------------
gen-jsonld: $(patsubst %, target/jsonld/%.context.jsonld, $(SCHEMA_NAMES)) $(patsubst %, target/jsonld/%.model.context.jsonld, $(SCHEMA_NAMES))
.PHONY: gen-jsonld
target/jsonld/%.context.jsonld: $(SCHEMA_DIR)/%.yaml tdir-jsonld
	$(RUN) gen-jsonld-context $(GEN_OPTS) $< > $@
target/jsonld/%.model.context.jsonld: $(SCHEMA_DIR)/%.yaml tdir-jsonld
	$(RUN) gen-jsonld-context $(GEN_OPTS) --metauris $< > $@

# ---------------------------------------
# PO JSON
# ---------------------------------------
gen-json: $(patsubst %, target/json/%.json, $(SCHEMA_NAMES))
.PHONY: gen-json
target/json/%.json: $(SCHEMA_DIR)/%.yaml tdir-json
	$(RUN) gen-jsonld $(GEN_OPTS) $< > $@

# ---------------------------------------
# RDF
# ---------------------------------------
# TODO: modularize imports. For now imports are merged.
gen-rdf: target/rdf/$(SCHEMA_NAME).ttl
.PHONY: gen-rdf
target/rdf/%.ttl: $(SCHEMA_DIR)/%.yaml tdir-rdf
	$(RUN) gen-rdf $(GEN_OPTS) $< > $@


# test docs locally.
docserve:
	mkdocs serve

gh-deploy:
	mkdocs gh-deploy
