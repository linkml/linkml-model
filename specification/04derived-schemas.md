# Derived Schemas

Rules can be applied to a schema to obtain a *derived* (aka *induced*) schema. The derived schema can be materialized, or it be present as a *view* onto a schema.

Derivations happen via *rules* that are specified below, using a set of convenience functions

## Function: ClassIdentifier

The function `ClassIdentifier(c)` takes a ClassDefinition or ClassDefinitionName as input and returns:

- the name of a slot `s` in `c` where `s.identifier` is True in `m*`
- `None` if there is no such slot
- An error if there are multiple such slots

## Rule: Model Imports

Each model imports zero to many imports, indicated by the [imports](https://w3id.org/linkml/imports) metaslot on the schema.

When deriving a model `m*` from `m`, the imports closure is copied to `m*`

- `m` is copied to `m*`
- for each `m'` is `m.imports`, all elements are copied to `m*`, including imports slot-value assignments
- this is repeated until saturation (i.e. the closure has been copied)

When copying an element `x` from an import into `m*`, the name `x.name` must be unique - if the same name has been used in another model, the derivation procedure fails, and an error is thrown.

**Note**: If two or more models import the same target (e.g. `m1` imports `m2` and `m3` and `m2` imports `m3`), `m3` will be only be resolved once.

**Note**: Two models are considered to be "identical" if they both 
have the same `id`.  If `m2` and `m3` both have `id: http://models-r.us/modelA`, it is assumed that, despite the different location, they represent the same thing.  LinkML _will_ check the model `version` field and will raise an error if `m2` has `version: 1.0.0` and `m3` has `version: 1.0.1`

Resolution of models is defined in the Import Resolution section

## Rule: Derived Attributes

Each class `c` has zero to many SlotDefinitions stored in `c.attributes`. These may be asserted directly in the base model, but they may also be derived from inheritance and overrides, as follows:

- attributes asserted directly in `c.attributes` in the base schema
- attributes derived from each SlotDefinitionReference `s` in `c.slots` by
    - looking up `s` in `m*.slots` and copying the slot-value assigments from these SlotDefinitions
    - overriding these slot-value assigments with any slot-value assignments provided by `c.slot_usage[s]`
- inheriting from parents of `c` using precedence rules
- inheriting from slot-value assignments of any parents of the derived attribute

The precedence rules for derived attributes are as follows:

If a metaslot `s` is declared `multivalued` then when copying `s` from a parent to a child, the values are appended.

If a metaslot `s` is declared `multivalued` 

if a slot is multi valued then copying will append, unless the element already exists.

if the slot is single valued, and intersection rules can be applied to the slot, then these are performed on all values

if the slot is single valued, and intersection rules cannot be applied to the slot, then the following precedence rules are applied:

 * metaslot values from slot_usage take the highest priority
 * metaslot values from the slot definition take the next highest priority
 * direct mixins take the next highest priority. where multiple direct mixins are provided as a list, the last element takes highest priority
 * direct is_as take the next highest priority
 * the above two rules are applied one level up, and then recursively applied

Intersection rules

|metaslot|rule|
|---|---|
|`maximum_value`|`min(v1,v2)`|
|`minimum_value`|`max(v1,v2)`|
|`pattern`|TBD|
|`range`|`IF subsumes(v1,v2) then v2` <br/> `ELSE IF subsumes(v2,v1) then v2 ELSE UNDEFINED` |

If the result of applying any intersection rule is UNDEFINED then we fall back on precedence rules

## Rule: Derived Class and Slot URIs

For each class or slot, if a class_uri or slot_uri is not specified, then this is derived by concatenating `m.default_prefix` with the CURIE separator `:` followed by the SafeUpperCamelCase encoding of the name of that class or slot definition

## Rule: Each referenced entity must be present

Every ClassDefinitionReference, SlotDefinitionReference, EnumDefinitionReference, and TypeDefinitionReference must be resolvable within `m*`

However, not every element needs to be referenced. For example, it is valid to have a list of SlotDefinitions that are never used in `m*`.

