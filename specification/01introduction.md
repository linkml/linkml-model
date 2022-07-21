# Introduction

This document is a functional draft specification for the Linked Data Modeling Language (LinkML).

LinkML is a data modeling language for describing the structure of a collection of *instances*, where instances are tree-like object-oriented structures. Instances are pieces of information that represent things of interest in a particular domain, such as individual people, biological samples, places, events, or abstract entities. 

Instances are either primitive *types* such as numbers or strings, or objects that are typed using *classes* from a LinkML *schema*. Classes are categories or groupings of things in the domain of interest; for example, "Person", "Medical History", "Data file", or "Country". Instances can be inter-related by assigning *slot values*; for example, an instance of a Person may have values for slots "name" or "country of birth".

LinkML schemas also specify *rules* for determining if instances conform to the schema, and for *inference* adding additional implicit slot values.

LinkML is independent of any programming language, database technology, and is independent of any concrete form for serializing instances of schemas. Mappings are provided for serializing instances as JSON, YAML, RDF, flat tables, or relational models, or for mapping to programming language structures. However, the structure and semantics of LinkML are independent from any of these. Schemas are typically expressed using the YAML serialization, but this specification is defined independent of that particular serialization.

LinkML is self-describing, and any LinkML schema is itself a collection instances that instantiates elements in a special schema called the *LinkML metamodel*.

## Audience

This document is intended for LinkML tool and framework implementors, and is intended to provide formal clarity about
the structure and semantics of LinkML.

For a more lightweight introduction, consult the material on the main [LinkML site](https://linkml.io),
including the LinkML tutorial.

## Conventions and terminology

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

## BNF

Grammars in this document are written using the BNF notation, summarized below:

Construct | Syntax |
|---|---|
terminal symbols | enclosed in single quotes |
a set of terminal symbols described in English | italic |
nonterminal symbols | boldface |
zero or more | curly braces |
zero or one | square brackets |
alternative | vertical bar |

We also include a meta-production rule for expressing comma-delimited lists

```
<NT>List ::= [ <NT> { ',' <NT>List } ]
```

## Outline

The specification is organized in 6 parts. The parts cannot be read independently, as each part builds on
concepts introduced in previous parts.

### Part 1: Introduction

This section. Provides background information and preliminary definitions

### Part 2: Structure and Syntax of Instances

Specification of the data model for instances in LinkML.

The data model shown as UML for informative purposes. A normative functional-style syntax is provided for instances, and this syntax is used throughout the specification.

This section also introduces a **path accessor** syntax for specifying how to traverse LinkML instances.

### Part 3: Structure of Schemas

Specification of the core elements of a LinkML schema: ClassDefinitions, TypeDefinitions, SlotDefinitions, EnumDefinitions, as well as ancillary structures.

### Part 4: Derived Schemas and Schema Semantics

Specification of inference procedures for **derived schemas**, which can be used for purposes such as validation.

### Part 5: Validation of Instance Data

Specification of the procedure for **validating** LinkML instances using a derived schema

### Part 6: Mapping of Instance Data

Specification of how LinkML instances are mapped to other data models and syntaxes:

- JSON/YAML
- RDF and JSON-LD
