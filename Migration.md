# Migrating from BiolinkML to LinkML

## RDF URI's

| From | To | Notes |
| ---- | ----- | ----- |
| https://w3id.org/biolink/biolinkml/meta/ | https://w3id.org/linkml/ | The metamodel root has been shortened |
| https://w3id.org/biolink/biolinkml/meta/types/Bool | https://w3id.org/linkml/Bool | Type  - types have been moved to base namespace |
| https://w3id.org/biolink/biolinkml/meta/SlotDefinition | https://w3id.org/linkml/SlotDefinition | Class  |
| https://w3id.org/biolink/biolinkml/meta/inverse | https://w3id.org/linkml/inverse | Slot  |
| https://w3id.org/biolink/biolinkml/meta/Annotation | https://w3id.org/linkml/Annotation | Annotation |
| https://w3id.org/biolink/biolinkml/meta/Extension | https://w3id.org/linkml/Extension | Extension |
| https://w3id.org/biolink/biolinkml/meta/EnumDefinition | https://w3id.org/linkml/EnumDefinition | Enumeration |
| https://w3id.org/biolink/biolinkml/meta/mappings | https://w3id.org/linkml/mappings | Mapping |
| https://w3id.org/biolink/biolinkml/meta/Owl | https://w3id.org/linkml/Owl | Subset |

## Permanent FILE URIs
| From | To | Notes |
| ---- | ----- | ----- |
| https://w3id.org/biolink/biolinkml/meta | https://w3id.org/linkml/meta | metamodel |
| https://w3id.org/biolink/biolinkml/annotations | https://w3id.org/linkml/annotations | annotations  |
| https://w3id.org/biolink/biolinkml/extensions | https://w3id.org/linkml/extensions | extensions  |
| https://w3id.org/biolink/biolinkml/mappings | https://w3id.org/linkml/mappings | mappings  |
| https://w3id.org/biolink/biolinkml/types | https://w3id.org/linkml/types | types  |

## Suffixes and Conneg
| mime type | suffix | Notes |
| ---- | ----- | ----- |
| text/yaml | .yaml | |
| text/turtle | .ttl | In the future, we will switch to an RDF mime type and use the [profile link relation type](https://tools.ietf.org/html/rfc6906) |
| application/json | .json | We use ".json" to identify "plain old" JSON and ".jsonld" to identify contexts and expanded JSON-LD |
|   | .owl | Need to get an appropriate mime type and look at [profiles](https://tools.ietf.org/html/rfc6906) for format |
| text/shex | .shex | Same as owl for format. ".shex" is ShExC (ShEx Language) format |
|           | .shexj | ".shexj" is ShExJ (Shex JSON) format
| application/ld+json | .context.jsonld | JSON-LD context that uses link, class, slot, etc. URI's |
|        | .contextn.jsonld | JSON-LD context that uses only the native (default) model URI's |
| text/html | .html | This goes to the actual model documentation.  Still needs to be implemented |
| | .graphql | |

## Suffix mapping
| suffix | biolinkml uri | biolink location | linkml uri | linkml location |
| ----- | ----- | ----- | ----- | ----- | 
| .yaml | https://w3id.org/biolink/biolinkml/meta.yaml | https://biolink.github.io/biolinkml/meta.yaml | https://w3id.org/linkml/meta.yaml | https://linkml.github.io/linkml-model/model/schema/meta.yaml |
|       | https://w3id.org/biolink/biolinkml/types.yaml | https://biolink.github.io/biolinkml/includes/types.yaml | https://w3id.org/linkml/types.yaml | https://linkml.github.io/linkml-model/model/schema/types.yaml |
|       | https://w3id.org/biolink/biolinkml/annotations.yaml | https://biolink.github.io/biolinkml/includes/annotations.yaml | https://w3id.org/linkml/annotations.yaml | https://linkml.github.io/linkml-model/model/schema/annotations.yaml |
|       | https://w3id.org/biolink/biolinkml/extensions.yaml | https://biolink.github.io/biolinkml/includes/extensions.yaml | https://w3id.org/linkml/extensions.yaml | https://linkml.github.io/linkml-model/model/schema/extensions.yaml |
|       | https://w3id.org/biolink/biolinkml/mappings.yaml | https://biolink.github.io/biolinkml/includes/mappings.yaml | https://w3id.org/linkml/mappings.yaml | https://linkml.github.io/linkml-model/model/schema/mappings.yaml |
| .ttl | https://w3id.org/biolink/biolinkml/meta.ttl | https://biolink.github.io/biolinkml/meta.ttl | https://w3id.org/linkml/meta.ttl | https://linkml.github.io/linkml-model/rdf/meta.ttl |
| .json | https://w3id.org/biolink/biolinkml/meta.json | https://biolink.github.io/biolinkml/meta.json | https://w3id.org/linkml/meta.json | https://linkml.github.io/linkml-model/json/meta.json |
| .owl | https://w3id.org/biolink/biolinkml/meta.owl | https://biolink.github.io/biolinkml/meta.owl | https://w3id.org/linkml/meta.owl | https://linkml.github.io/linkml-model/owl/meta.owl |
| .shex | https://w3id.org/biolink/biolinkml/meta.shex | https://biolink.github.io/biolinkml/meta.shex | https://w3id.org/linkml/meta.shex | https://linkml.github.io/linkml-model/shex/meta.shex |
| .context.jsonld | https://w3id.org/biolink/biolinkml/context.jsonld | https://biolink.github.io/biolinkml/context.jsonld | https://w3id.org/linkml/meta.context.jsonld | https://linkml.github.io/linkml-model/jsonld/meta.context.jsonld |
|  | https://w3id.org/biolink/biolinkml/types.context.jsonld | https://biolink.github.io/biolinkml/includes/types.context.jsonld | https://w3id.org/linkml/types.context.jsonld | https://linkml.github.io/linkml-model/jsonld/types.context.jsonld |
| .contextn.jsonld | https://w3id.org/biolink/biolinkml/contextn.jsonld | https://biolink.github.io/biolinkml/contextn.jsonld | | | 
| .model.context.jsonld | | | https://w3id.org/linkml/meta.model.context.jsonld | https://linkml.github.io/linkml-model/jsonld/meta.model.context.jsonld |

## Notes
The make file currently generates a plain `context.jsonld` in the jsonld directory to address some issues in the linkml build...
