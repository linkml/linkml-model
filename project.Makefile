
# ---------------------------------------
# CUSTOM VALIDATION
# ---------------------------------------
EXAMPLES = relational-roles rules slot-group path unique-key inlining-union

all-validate: $(patsubst %, validate-%, $(EXAMPLES))
validate-%: examples/%-example.yaml
	$(RUN) linkml-validate -C SchemaDefinition -s linkml_model/model/schema/meta.yaml $<


TITLE = "LinkML Specification"
SPEC = target/SPECIFICATION.md
target/0%.md: specification/0%.md
	(cat $< && echo) > $@.tmp && mv $@.tmp $@

$(SPEC): $(wildcard specification/0*.md)
	cat specification/0*.md > $@.tmp && mv $@.tmp $@
SPECIFICATION.pdf: $(SPEC)
	pandoc -T $(TITLE) --pdf-engine=xelatex --toc -s $< -o $@
SPECIFICATION.html: $(SPEC)
	pandoc --metadata pagetitle=$(TITLE) -f gfm --toc -s $< -o $@
