
# ---------------------------------------
# CUSTOM VALIDATION
# ---------------------------------------
# TODO: use linkml-run-examples
EXAMPLES = relational-roles rules slot-group path unique-key inlining-union

all-validate: $(patsubst %, validate-%, $(EXAMPLES))
validate-%: examples/%-example.yaml
	$(RUN) linkml-validate -C SchemaDefinition -s linkml_model/model/schema/meta.yaml $<

all-examples:
	$(RUN) linkml-run-examples -s $(SOURCE_SCHEMA_PATH) -e tests/input/examples/ -d /tmp/TODO

# ---------------------------------------
# SPECIFICATION
# ---------------------------------------

#all-spec: $(SPEC)

TITLE = "LinkML Specification"
SPEC = target/SPECIFICATION.md
#target/docs/0%.md: specification/0%.md
#	(cat $< && echo) > $@.tmp && mv $@.tmp $@

$(SPEC): $(wildcard linkml_model/model/docs/specification/0*.md)

# See https://github.com/raghur/mermaid-filter
# doesn't work with pdf? https://github.com/raghur/mermaid-filter/issues/89
SPECIFICATION.pdf: $(SPEC)
	pandoc -T $(TITLE) -F mermaid-filter --pdf-engine=xelatex --toc -s $< -o $@
SPECIFICATION.html: $(SPEC)
	pandoc  -F mermaid-filter --metadata pagetitle=$(TITLE) -f gfm --toc -s $< -o $@
