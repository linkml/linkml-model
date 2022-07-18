# Translation of instance graphs

This section describes how LinkML instances are translated to different formats and data models.

- Conversion *from* LinkML instances to another format is called *serialization* or *dumping*
- Conversion *to* LinkML instances from another format is called *parsing*, *loading*, or *deserialization*

The reference implementation is the [linkml-runtime](https://github.com/linkml/linkml-runtime/) but other implementations that conform to this specification are valid.

## Translation of instances to JSON or YAML

Here we define a mapping of LinkML instances to JSON.

As JSON is a subset of YAML, this can also be used to load and dump from YAML. This is the canonical YAML mapping. We leave open
the possibility of a *direct* YAML conversion in future which makes use of YAML tags to encode typing information.

- Serialization to JSON takes as input:
    - a (root) instance
- Parsing from JSON takes as input:
    - a JSON document
    - a target ClassDefinitionName
    - a SchemaDefinition

### Instances of ClassDefinition

Given an instance `i` of a ClassDefinition:

*ClassDefinitionName*( `s1=v1`, ..., `sn=vn` )

This is translated to a JSON *object*

```json
{
   Tr(s1) = Tr(v1),
   Tr(s2) = Tr(v2)
  ...,
   Tr(sn) = Tr(vn)           
}
```

Note this is potentially lossy, as the type is dropped

When parsing, if this is the root instance, then the target ClassDefinition is used

If this is not the root instance, then the type is inferred from the root of the parent slot in the derived schema

Optionally, this type is deepened if `C.type_designator` is not None - the value of this slot is used to
set the target ClassDefinitionName

### Instances of None

None is mapped to JSON nulls.

It is conventional to omit an assignment whose value is None/null when serializing. The canonical serialization MUST omit these, but a parser MUST accept None/null values that are explicitly provided

### Instances of Collections of InstancesOfClass

If the parent slot `s.inlined_as_list=True`

```
{
   IdVal(member1): 
      Tr(member1) - IdField(member1)
   ...
   IdVal(memberN): 
      Tr(memberN) - IdField(memberN)
}
```

otherwise:

```json
[
   Tr(member_1),
   ...
   Tr(member_n),
]
```

### Instances of other Collections

These are always translated to lists:

```
[
   Tr(member_1),
   ...
   Tr(member_n),
]
```


### Instances of TypeDefinition

The direct value is used

### Instances of EnumDefinition

The direct value is used

### Instances of ClassDefinitionReference

The direct value is used

## Translation to RDF

Two RDF translations are provided:

- A *direct* translation
- Translation via JSON-LD, which combines
    1. Translation of a LinkML **SchemaDefinition** to a **JSON-LD Context**
    2. The standard translation of LinkML instances to JSON
   
Both translations make use of the **prefixes** provided in the schema

The semantic content of both is equivalent. 

### Mapping of CURIEs to URIs

LinkML provides standard types:

- Curie
- Uri
- Curieoruri

The syntax for a CURIE is defined by [W3C CURIE Syntax 1.0](https://www.w3.org/TR/curie/)

> **curie**       :=   [ [ **prefix** ] ':' ] **reference**

> **prefix**      :=   **[NCName](https://www.w3.org/TR/1999/REC-xml-names-19990114/#NT-NCName)**

> **reference**   :=   **[irelative-ref](https://www.ietf.org/rfc/rfc3987.txt)**

We define a function **CurieToUri**(`x`) that maps (expands) a CurieOrUri to a Uri

If `x` is already a Uri, then `x` is returned, otherwise the following procedure is followed

To expand a CURIE with an explicit prefix to a URI using a schema `m`, first `m.prefixes` is consulted for `m.prefixes[prefix]`.

If this is present, then `m.prefixes[prefix].prefix_reference` is uses as the **Base URI**

If this is not present, then `m.prefixes[m.default_prefix].prefix_reference` is used as the Base URI

to obtain the URI, the Base URI is concatenated with the **reference**

If the CURIE has no explicit prefix, and the CURIE is value of a slot `s`, then `s.implicit_prefix` is used

### Direct Translation of instance graphs to RDF

A translation **Tr** operates on an instance `i`, in the context of a derived schema `m*`

#### Instances of ClassDefinition

If `i` is an instance of a ClassDefinition, then **Tr**(i) is as follows:

*ClassDefinitionName*( `s1=v1`, ..., `sn=v2` )

We assign a value to `subject` which will be either an IRI, or a **blank node**

- If **IdVal**(`i`) is None, the subject is assigned a blank node
- Otherwise `subject` = **CurieToUri**(**IdVal**(`i`)) 

We assign a value `object` for the type of `i`. This will be equivalent to the `c.class_uri` in `m*`

This is used to generate a triple (`subject` rdf:type **CurieToUri**(`object`))   

For each `s=v` in the assignments where `s.identifier=True` does not hold, and `v` is not **None**, we generate a triple

(`subject` TrSlot(s) Tr(v))

Here **TrSlot**(`s`) = **CurieToUri**(`s.slot_uri`)

#### Instances of TypeDefinition

If `i` is an instance of a TypeDefinition of type `t`
then **Tr**(i) is translated to an RDF literal, with datatype  **CurieToUri**(t.uri)

#### Instances of EnumDefinition

If `i` is an instance of a EnumDefinition, then **Tr**(i) is as follows:

If i corresponds to a PermissibleValue with `pv.meaning` that is not None, then
**Tr**(i) = **CurieToUri**(pv.meaning)

#### Instances of ClassDefinitionReference

If `i` is an instance of a ClassDefinitionReference
then **Tr**(i) = **CurieToUri**(i.value)

### Translation of instance graphs to RDF graphs (via JSON-LD)

To be specified

### Translation of instance graphs to RDF* and property graphs

To be specified