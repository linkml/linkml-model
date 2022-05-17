# Translation of instance graphs

This section describes how a conceptual LinkML instance graph is translated to different concrete representations.

The reference implementation is the [linkml-runtime](https://github.com/linkml/linkml-runtime/) but other implementations that conform to this specification are valid.

The translations fall into three categories:

 - translations to other tree representations (JSON, YAML, and OO)
 - translations to graph representations (RDF, RDF*/Property Graphs)
 - translations to relational or tabular representations

For translation to RDF graphs, we provide two normative equivalent specifications. (1) A direct translation (2) a translation via two intermediates (i) a JSON file which is identical to the JSON transformation (ii) a JSON-LD context that is merged with the JSON file

## Translation of instance graphs to JSON or YAML

|condition `Tr(i)`|translation|
|---|---|
|`i` is a List|[Tr(i1), ..., Tr(i_n)] OR dict, see below|
|`instantiates(i) ∈ MC`|CompoundInstance(i)|
|`instantiates(i) ∈ Ref(MC)`|Type(IdentifierSlot(MC).range)|
|`instantiates(i) ∈ EC`|Type(string)|
|`instantiates(i) ∈ TC`|Type(TC)|

Type function:

|Input|YAML|JSON|
|---|---|---|
|integer|integer|integer|
...

When translating a CompoundInstance:

 * Create an empty dict `{}`
 * For each `s,V in A(i)`
    * Add a key-value (s, Tr(V)) to dict

TODO: describe lossiness when instantiation info is lost

### Lists vs Dicts

 * All lists are translated to lists or dicts
 * Only lists of instances, where instances have identifiers, may be translated to dicts
 * If `inlined_as_list` is set this forces inlining as lists of instances


### Inlining

## Translation of instance graphs to Instance Oriented representation

### Inlining

## Translation of instance graphs to RDF graphs (direct)

### Collapsing of References

## Translation of instance graphs to RDF graphs (via JSON-LD)

## Translation of instance graphs to RDF* and property graphs

# Generation of prefixmaps from LinkML instances and schemas



Values for schema element slots _may_ be IRIs, and these _may_ be specified as CURIEs. CURIEs are shortform representations of URIs, and _must_ be specified as `PREFIX:LocalID`, where the prefix has an associated URI base. The prefix _must_ be declared in one of several ways:

 * a [prefixes](https://w3id.org/linkml/meta/prefixes) dictionary, where the keys are prefixes and the values are URI bases.

Example (Informative):

```yaml
prefixes:
  linkml: https://w3id.org/linkml/
  wgs: http://www.w3.org/2003/01/geo/wgs84_pos#
  qud: http://qudt.org/1.1/schema/qudt#
```

The CURIE `wgs:lat` will exand to http://www.w3.org/2003/01/geo/wgs84_pos#lat.

* an external CURIE map specified via a [default_curi_maps](https://w3id.org/linkml/meta/default_curi_maps) section.

Example (Informative):

```
default_curi_maps:
  - semweb_context
```

* prefixes from public standard global namespaces used in the model (e.g. rdf) are indicated under the [emit_prefixes](https://w3id.org/linkml/meta/emit_prefixes) section.

Example (Informative):

```
emit_prefixes:
  - rdf
  - rdfs
  - xsd
  - skos
```

* a default prefix within a given schema is generally also declared by a value for the [default_prefix](https://w3id.org/linkml/meta/default_prefix) tag:

Example (Informative):

```
default_prefix: ex
```
