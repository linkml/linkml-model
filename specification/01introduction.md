# Introduction

This document is a functional draft specification for the Linked Data Modeling Language (LinkML).

LinkML is a data modeling language for describing the structure of a collection of *instances*, 
where instances are tree-like object oriented structures. Each instance instantiates a class from the LinkML *metamodel*. This is either a *primitive* class such as a scalar type, reference, enumeration, or a *class* class, which is associated with slot-value *assignments*.

LinkML schemas also specify *rules* for determining if instances conform to a the schema, and for adding additional implicit information to an instance collection.

LinkML is independent of any programming language, and independent of
any concrete form for serializing instances of schemas. Mappings are
provided for serializing instances as JSON, YAML, RDF, flat tables, or
relational models, or for mapping to programming language structures,
but are independent of any of these. Schemas are typically expressed
using the YAML serialization, but this specification is independent of
that serialization.

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

This specifies what an instance is in the context of LinkML.

The instance data model is shown as UML. A normative functional-style syntax is provided for instances, and this syntax is used throughout the
specification.

This also introduces a path accessor syntax for specifying how to traverse LinkML instances.

### Part 3: Structure of Schemas

This section specifies the core elements of a LinkML schema.

### Part 4: Derived Schemas and Schema Semantics

This section specifies rules for inferring derived schemas, which can be used for purposes such as validation.

### Part 5: Validation of Instance Data

This section specifies the procedure for validating LinkML instances using a derived schema

### Part 6: Mapping of Instance Data

This section specifies how LinkML instances are mapped to other data models and syntaxes, including:

- JSON/YAML
- RDF
