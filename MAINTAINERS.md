# How to make a release

See the instructions at the top of [Makefile](Makefile)

First install the linkml python package and mkdocs:

```bash
. environment.sh
pip install -r requirements.txt
```

Then every time you change the source schema, run:

```bash
make all
```

This will generate files in:

 * [docs]
 * [jsonschema]
 * [shex]
 * [owl]
 * [rdf]

Do **not** git add the files in docs

Once the files are generated, run

```bash
make gh-deploy
```

Your documentation will be available from a URL https://my_org_or_name.github.io/my_schema/

