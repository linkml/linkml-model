# Validation using Schemas

*Validation* is a procedure that takes as input

* A parsed LinkML instance structure `i`
* A *derived* schema `m*`

And determines if the instance is *structurally and semanticaly valid* according to the schema.

A validation procedure MUST yield minimally a boolean indicating success or failure.

A validation procedure SHOULD also yield additional information about the nature of all problems encountered. This information SHOULD be provided according to the LinkML validation datamodel.

Some validation procedures MAY also be combined with parsing to yield the precise location (i.e. line numbers) in the source serialization document.

Prior to validation, derivation rules are applied on the schema to produce a derived model `m*`.


## Validation of ClassDefinitions

Given an instance `i` of a class definition:

 * *C*( <*Assignment1*>, <*Assignment2*>, ..., <*AssignmentN*> )

Where each assignment is a slot-value pair `slot_i=value_i`, the following rules apply:

### Rule: ClassDefinition instances must instantiate a class in the schema

*C* MUST be the name of a class in `m`

*C* SHOULD have the following properties:

- it SHOULD NOT be deprecated
- it SHOULD NOT be abstract
- it SHOULD NOT be a mixin

### Rule: identifiers must be unique

There should be no two distinct instances `i1` and `i2` where `IdVal(i1)=IdVal(i2)`

### Rule: All assignments must be to permitted slots

For each `s=SlotValue` assignment in <*Assignment1*>, <*Assignment2*>, ..., <*AssignmentN*>:

- `s` must be a SlotDefinition in *m*
- `s` must be permitted for *C*, i.e. it must be in the derived slot list for *C*

### Rule: All required slots should be specified

If *C* has a required slot *s* then there must be an assignment for *s*, and the value must not be none

### Rule: Assigned values must conform to multivalued cardinality


 * if `s.multivalued` is True, then `V` must be a list
 * If `s.multivalued` is False, then `V` must be a single value

### Rule: values should be within stated bounds

 * if `c!s.maximum_value` is assigned, then `V` must be a singular integer and must be less that or equal to the maximum value
 * if `c!s.minimum_value` is assigned, then `V` must be a singular integer and must be greater that or equal to the minimum value


### All assignments must be to permitted range

Depending on the range of `c!s` a particular check is applied on each `c ∈ V` (if V is multivalued) or `v=V`

|condition|check|
|---|---|
|`c!s.range ∈ MC`|class instantiation check|
|`c!s.range ∈ MT`|type check|
|`c!s.range ∈ ME`|enum check|



### Range class instantiation check

if `s.range ∈ MC`: `v` must be either:
 * an object that instantiates a class `c ∈ DESC*(s.range)`
 * a reference to an object that instantiates a class `c ∈ DESC*(s.range)`

Here `DESC*` is the reflexive closure of the `child` function, where `child(p) = { c : c.is_a = p or p ∈  c.mixins }`

Additional checks MAY be performed based on whether `s.inlined` is True

 * if `s.inlined`, then `v` SHOULD NOT be a Reference
 * if `s.inlined` is False, then EITHER:
     * `v` SHOULD be a Reference
     * OR `v` instantiates a class `R` such that R has no slot `rs` that is declared to be an identifier. i.e. `rs.identifier = True`

### Range type check

if `s.range ∈ MT`: `v` must be a literal of type `MT`

### Range enum check

if `s.range ∈ MO`: `v` must be a member of the permissible value in `MO`

TODO: other enum types

### abstract classes and slots

a class instance SHOULD not instantiate a class that is declared abstract. 

an assignment s,V SHOULD not have s declared abstract. 

### Required value checks

 * For each `o ∈ O`, where `o` directly instantiates `C`:
    * For each `s ∈ C.slots`:
        * If `s.required` is True, then there MUST exist a value `o.s`
        * If `s.recommended` is True, then there SHOULD exist a value `o.s`

### Constraints on instantiation of classes

* For each `o ∈ O`, where `o` directly instantiates `C`:
   * `c.abstract` MUST be false
   * `c.mixin` SHOULD be false

Note in future versions we may introduce model level metaslots that allow these to be relaxred

## Validation of TypeDefinitions

Given an instance `i` of a TypeDefinition:

 * *T*( **AtomicValue** )

then the type of AtomicValue must be consistent with the xsd type specified in `m*.types[T].uri`

- for xsd floats, doubles, and decimals, AtomicValue must be a decimal
- for xsd strings, AtomicValue must be a string
- for xsd dates, datetimes, and times, AtomicValue must be a string conforming to the relevant ISO type
- for xsd booleans, AtomicValue must be True or False

## Validation of EnumDefinitions

Given an instance `i` of an EnumDefinition:

 * *E*( **AtomicValue** )

then the type of AtomicValue must be consistent with the EnumDefinition `m*.enums[E]`.

- if this enum `e` is *closed* and *static* then AtomicValue must correspond to `pv.text` for exactly one PerissibleValue `pv` in `e.permissible_values`
- ...

## Validation of ClassDefinitionReferences

Given an instance `i` of an ClassDefinitionReference:

 * *R*( **AtomicValue** )

Where R is a reference to ClassDefinition `C`, then

- `C` must have an identifier slot `s=ClassIdentifier(C)`
- AtomicValue must be consistent with `s.range`
- There MAY be an instance `j` in the instance tree (TODO: define) where `j` instantiates `C` and `j.<s> = AtomicValue`
    - if this holds, then `i` is said to be locally resolvable
    - if this does not hold, then `i` is said to be "dangling"

