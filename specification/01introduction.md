# Introduction

This document specifies LinkML instance data and LinkML models (schemas). LinkML is a data modeling language for describing the structure of a collection of *instances*, where instances are tree-like object oriented structures. Each instance instantiates a class from the LinkML *metamodel*. This is either a *primitive* class such as a scalar type, reference, enumeration, or a *class* class, which is associated with slot-value *assignments*.

LinkML schemas also specify *rules* for determining if instances conform to a the schema, and for adding additional implicit information to an instance collection.

LinkML is independent of any programming language, and independent of
any concrete form for serializing instances of schemas. Mappings are
provided for serializing instances as JSON, YAML, RDF, flat tables, or
relational models, or for mapping to programming language structures,
but are independent of any of these. Schemas are typically expressed
using the YAML serialization, but this specification is independent of
that serialization.

LinkML is self-describing, and any LinkML schema is itself a collection instances that instantiates elements in a special schema called the *LinkML metamodel*.

## Conventions and terminology

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://datatracker.ietf.org/doc/html/rfc2119).

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
