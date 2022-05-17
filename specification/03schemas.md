# LinkML Schemas

## Schema Basics

A LinkML **schema** specifies rules and structural conformance conditions for instances. Schemas allows for:

- parsing of instance serializations to LinkML instance structures
- structurally and semantically validating LinkML instance structures
- inferring missing values in LinkML instance structures

Every LinkML schema `m` is itself an instance of a special class `SchemaDefinition` that forms part of a special schema called the *LinkML metamodel*

The metamodel is itself expressed in LinkML, and the latest version can be browsed online

* [SchemaDefinition](https://w3id.org/linkml/SchemaDefinition)

Formally a schema `m` consists of the following metamodel *elements*:

 * class definitions `MC = {c1,...}`, which group *instances*
 * slot definitions `MS = {s1, ...}`, which describe how instances relate to other instances
 * enum definitions `ME = {e1, ...}`, enumerated values (value sets)
 * type definitions `MT = {t1, ...}`, scalar/atomic types, such as integers, strings
 * subset definitions `MP = {ss1, ..}`, which partition model elements into groupings or views
 * URI prefixes `MU = {prefix1, ..}`, which partition model elements into groupings or views
 * imports `MI = {imp1, ..}`, which reference schemas that are reused
 * class definition references `MR = {r1,...}`, which group *pointers to instances*
 * model-level metadata

These are stored in the SchemaDefinition instance as follows:

|Path|Element|
|---|---|
| `m.classes` | `MC` |
| `m.slots` | `MS` |
| `m.enums` | `ME` |
| `m.types` | `MT` |
| `m.subsets` | `MP` |
| `m.imports` | `MI` |
| `m.prefixes` | `MU` |
| `m.<metaslot>` | model-level metadata |


For example, consider a schema that models representations of individual people and organizations they belong to may include a class definition `Person`, and slot definitions for `name`, `address`, `relationships` and so on. This schema may be serialized in functional syntax as follows:

```
SchemaDefinition(
  id=String('http://example.org/organization'),
  classes=[
    ClassDefinition(
      name=String("Person"),
      slots=[
        String("id"),
        String("name"),
        String("height"),
        String("age"),
        ...
      ]
    ),
    ClassDefinition(
      name=String("Organization"),
      slots=[
        String("id"),
        ...
      ]
    ),
    ...
  ],
  slots=[
    SlotDefinition(
      name=String("id"),
      identifier=True,
      description=String("..."),
      range=String("String"),
      ...
    ),
    SlotDefinition(
      name=String("name"),
      description=String("..."),
      range=String("String"),
      ...
    )
  ],
  enums=[
     EnumDefinition(
       name=String("JobCode"),
       permissible_values=[...],
     )
  ],
  types=[
     TypeDefinition(
       name=String("Date"),
       ...
     ),
     TypeDefinition(
       name=String("String"),
       ...
     ),
  ]
)  
```

This maps to:

|Example Model: Organization Schema|
|---|
|`MC` Classes: *Person*, *Organization*, *Address*, ...|
|`MS` Slots: *id*, *name*, *date_of_birth*, *employed_at*, *lives_at*, ...|
|`ME` Enums: *JobCode*, ...|
|`MT` Types: *Date*, *String*, ...|

To help understand the basic concepts, it can be helpful to think about analogous structures in other frameworks. However, it should be understood these are not equivalents.

 * ClassDefinitions are analogous to *classes* in object-oriented languages, tables in relational databases and spreadsheets, and owl:Class entities in RDFS/OWL
 * SlotDefinitions are analogous to *attributes* in object oriented languages, columns or fields in relational databases and spreadsheets, properties in JSON-Schema, and rdf:Property entities in RDFS/OWL
 * EnumDefinitions are analogous to *enums* in programming languages and some relational systems. However, in LinkML enums are optionally backed by stronger semantics with enum elements (permissible values) mapped to vocabularies or ontologies
 * TypeDefinitions are analogous to builtin types in most OO languages and database systems, or extensible types in some systems. They correspond to rdf:Literals in RDF/OWL


## Schema Elements

The following describes the structure and base semantics for schema elements.

* `m` refers to the base or *asserted* schema
* `m*` references to the *derived* schema, obtained using the rules below


### ClassDefinitions

Instances that instantiate ClassDefinitions have zero to many slot-value assignments. ClassDefinitions constrain the structure of these assignments

`m.classes` is a collection of all ClassDefinitions `c1, ...` in the schema. Each such ClassDefintion `c` must conform to the rules below:

- `c` must have a unique name `c.name`, and this name must not be shared by any other class or element in `m*`
- `c` lists permissible slots in `c.slots`, the range of this is a reference to a SlotDefinition in `m*.slots`
- `c` defines how slots are used in the context of `c` via a collection of SlotDefinitions specified in `c.slot_usage`
- `c` may define local slots using `c.attributes`, the value of this is a. collection of SlotDefinitions
- `c` may have certain boolean properties defined such as `c.mixin` and `c.abstract`
- `c` must have exactly one value for `c.class_uri` in `m*`, and the value must be an instance of the builtin type UriOrCurie
- `c` may have parent ClassDefinitions defined via `c.is_a` and `c.mixins`
    - the value of `c.is_a` must be a ClassDefinitonReference
    - the value of `c.mixins` must be a collection of ClassDefinitonReferences
    - For any parent `p` of `c`, if `p.mixin` is True, then `c.mixin` SHOULD be True
- `c` includes additional rules in `c.rules` and `c.classificiation_rules`
- `c` may have any number of additional slot-value assignments consistent with the validation rules provided here with the metamodel `MM`

An example collection of ClassDefinitions in a schema specified using the functional syntax might be:

```python
ClassDefinition(
    name=String("NamedThing"),
    abstract=True,
    slots=[
        String("id"),
        String("name"),
        ...
      ]
    ),
ClassDefinition(
    name=String("Person"),
    description=String("A person, living or dead"),
    is_a=String("NamedThing"),
    attributes=[
        SlotDefinition(
            name=String("height"),
            ...),
        SlotDefinition(
            name=String("age"),
            ...)
    ],
    ...
    )
```

### SlotDefinitions

`m.slots` is a collection of all SlotDefinitions `s1, ...` in the schema. Each `s` must conform to the rules below:

- `s` must have a unique name `s.name`, and this name must not be shared by any other type or element
- `s` must have a range specified via `s.range` in `m*`
- `s` may have an assignment `s.identifier` which is True if `s` plays the role of a unique identifier
- `s` may have certain boolean properties defined such as `s.mixin` and `s.abstract`
- `s` must have exactly one value for `s.slot_uri` in `m*`, and the value must be an instance of the builtin type UriOrCurie
- `s` may have parent SlotDefinitions defined via `s.is_a` and `s.mixins`
    - the value of `s.is_a` must be a SlotDefinitonReference
    - the value of `s.mixins` must be a collection of SlotDefinitonReferences
    - For any parent `p` of `s`, if `p.mixin` is True, then `s.mixin` SHOULD be True
- `s` may have any number of additional slot-value assignments consistent with the validation rules provided here with the metamodel `MM`

An example collection of SlotDefinitions in `m.slots` might be:

```python
SlotDefinition(
    name=String("id"),
    identifier=True,
    description=String("A unique identifier for an object"),
    range=String("String"),
    ...
    ),
SlotDefinition(
    name=String("name"),
    description=String("..."),
    range=String("String"),
    ...
    )
```

### TypeDefinitions

`m.types` is a collection of all TypeDefinitions `t1, ...` in the schema. Each `t` must conform to the rules below:

- `t` must have a unique name `t.name`, and this name must not be shared by any other type or element
- `t` must have a mapping to an xsd type provided via `t.uri` in `m*`
- `t` may have a parent type declared via `t.typeof`
- `t` may have any number of additional slot-value assignments consistent with the validation rules provided here with the metamodel `MM`

### EnumDefinitions

`m.enums` is a collection of all EnumDefinitions `e1, ...` in the schema. Each `e` must conform to the rules below:

- `e` must have a unique name `e.name`, and this name must not be shared by any other enum or element
- `e` lists all static permissible values via `e.permissible_values`, the value of which is a list of instances of the MM class PermissibleValue
- `e` may have any number of additional slot-value assignments consistent with the validation rules provided here with the metamodel `MM`

### ClassDefinitionReferences

The set of all class definition references `r1, ...` is not asserted in the schema `m`. It is derived using the derivation rules stated below and found in the derived schema `m*`; every ClassDefinition `c` which has an identifier slot `pk(c)` generates a ClassDefinitionReference `ref(c)` whose name is the concatenation of `c.name` plus `pc(c).name`.

