# Contributing to this repository

## Contributing to the metamodel

* [linkml_model/model/schema](linkml_model/model/schema)

## Contributing to the specification

The source lives in

* [linkml_model/model/docs/specification](linkml_model/model/docs/specification)

## Building the site

The site https://linkml.io/linkml-model/ is hosted on GitHub pages.

Note: unlike most LinkML schema sites, this one *does not* use the
gh-pages branch. The docs are served directly from the root folder of
the main branch.

The [docs](docs) folder houses the built schema index.

To build the docs:

```
make gen-doc
```

This stages the documentation in target/docs

You can test this:

```
make serve
```

## Model versioning and releases

See the [metamodel docs](https://linkml.io/linkml/schemas/metamodel.html) for a
description of the versioning scheme.

MINOR versions should be synchronized with all code frameworks such as linkml-runtime.

To sync the minor version with linkml-runtime, see:

- https://github.com/linkml/linkml-runtime/blob/main/Makefile
- https://github.com/linkml/linkml/issues/1065
