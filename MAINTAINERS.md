# How to make a release

Make an

1) Make changes to the source schema
2) run `make all`
3) run `make tests`
4) run `make gh-deploy`

Your documentation will be available from a URL https://my_org_or_name.github.io/my_schema/

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

