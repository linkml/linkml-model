# w3id.org rewrite rules
We use [w3id.org](https://github.com/perma-id/w3id.org) identifiers throughout the model. The current mappings are as
follows:

| FROM | TO | ACCEPT | Description | 
| :---------------------------------- | :------------------------------------ | ----- | ------- |
| https://w3id.org/linkml/meta.yaml | https://linkml.github.io/model/schema/meta.yaml | | Core LinkML model YAML source | 
| https://w3id.org/linkml/annotations.yaml | https://linkml.github.io/model/schema/annotations.yaml | |  LinkML Annotations YAML source |
| https://w3id.org/linkml/extensions.yaml | https://linkml.github.io/model/schema/extensions.yaml |  | LinkML Extensions YAML source |  
| https://w3id.org/linkml/mappings.yaml | https://linkml.github.io/model/schema/mappings.yaml |  | LinkML Mappings YAML source | 
| https://w3id.org/linkml/types.yaml | https://linkml.github.io/model/schema/types.yaml |  | LinkML Type YAML source | 
| https://w3id.org/linkml/meta.json | https://linkml.github.io/json/meta.json | |  Model source in json |
|   |  | |  (Same pattern for annotations, extensions, mappings and types) |
| https://w3id.org/linkml/context.jsonld | https://linkml.github.io/jsonld/context.jsonld | | Complete JSON-LD 1.0 Context for type, class, slot URI's | 
| https://w3id.org/linkml/model.context.jsonld | https://linkml.github.io/jsonld/model.context.jsonld | | Complete JSON-LD 1.0 Context for straight model URI's|
| https://w3id.org/linkml/meta.schema.jsonld | https://w3id.org/linkml/jsonschema/meta.schema.jsonld |  | JSON Schema | 
|   |  | |  (Same pattern for annotations, extensions, mappings and types) |
| https://w3id.org/linkml/meta.owl.ttl | https://w3id.org/linkml/owl/meta.owl.ttl |  |  OWL Turtle rendering of model |
|   |  | |  (Same pattern for annotations, extensions, mappings and types) |
| https://w3id.org/linkml/meta.ttl | https://w3id.org/linkml/rdf/meta.ttl |  | RDF Turtle rendering of model |
|   |  | |  (Same pattern for annotations, extensions, mappings and types) |
| https://w3id.org/linkml/meta.shex | https://w3id.org/linkml/shex/meta.shex |  | ShExC rendering of model |
|   |  | |  (Same pattern for annotations, extensions, mappings and types) |
| https://w3id.org/linkml/meta.shexj | https://w3id.org/linkml/shex/meta.shexj |  | ShExJ rendering of model |
|   |  | |  (Same pattern for annotations, extensions, mappings and types) |
| meta.schema.jsonld | jsonschema/meta.schema.jsonld |  | JSON Schema | 
| ... .context.jsonld | ... .context/jsonld | |

## Testing the rewrite rules

1) Uncomment and change the following lines in test_rewrite_rules.py:
```python
# DEFAULT_SERVER = "http://localhost:8091/"
# SKIP_REWRITE_RULES = False
```
2) Change the port if necessary -- note that this change has to be reflected in the instructions below
3) Run the unit tests

```bash
> cd httpd
> docker image build . -t w3id
> docker run --rm -d -p 8091:80 --name w3id -v `pwd`/linkml:/w3id/linkml w3id  
> cd ../../..
> pipenv install
> pipenv shell
(linkml) > cd tests/test_rewrite_rules
(linkml) > export SERVER="http://localhost:8091"
(linkml) > python test_rewrite_rules.py
ssss
----------------------------------------------------------------------
Ran 4 tests in 0.000s

OK (skipped=6)
(linkml) > exit
> docker stop w3id
```

7. ** If necessary, make a pull request to w3id.org w/ changes **


