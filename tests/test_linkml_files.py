import os
import unittest

from linkml_model.linkml_files import URL_FOR, Format, Source, LOCAL_PATH_FOR, GITHUB_IO_PATH_FOR, GITHUB_PATH_FOR, \
    ReleaseTag

root_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "linkml_model"))

SKIP_GITHUB_API = True              # True means don't do the github API tests


class LinkMLFilesTestCase(unittest.TestCase):
    def test_basic_rules(self):
        self.assertEqual("https://w3id.org/linkml/annotations.yaml",
                         URL_FOR(Source.ANNOTATIONS, Format.YAML))
        self.assertEqual("https://w3id.org/linkml/meta.model.context.jsonld",
                         URL_FOR(Source.META, Format.NATIVE_JSONLD))
        self.assertEqual(os.path.join(root_path, "model/schema/meta.yaml"),
                         LOCAL_PATH_FOR(Source.META, Format.YAML))
        print(LOCAL_PATH_FOR(Source.META, Format.YAML))
        self.assertEqual(os.path.join(root_path, "jsonld/types.model.context.jsonld"),
                         LOCAL_PATH_FOR(Source.TYPES, Format.NATIVE_JSONLD))
        self.assertEqual("https://linkml.github.io/linkml-model/model/schema/meta.yaml",
                         GITHUB_IO_PATH_FOR(Source.META, Format.YAML))
        self.assertEqual("https://linkml.github.io/linkml-model/jsonld/types.model.context.jsonld",
                         GITHUB_IO_PATH_FOR(Source.TYPES, Format.NATIVE_JSONLD))
        self.assertEqual("https://raw.githubusercontent.com/linkml/linkml-model/main/jsonld/meta.model.context.jsonld",
                         GITHUB_PATH_FOR(Source.META, Format.NATIVE_JSONLD, ReleaseTag.LATEST))
        self.assertEqual("https://raw.githubusercontent.com/linkml/linkml-model/testing_branch/owl/mappings.owl.ttl",
                         GITHUB_PATH_FOR(Source.MAPPINGS, Format.OWL, branch="testing_branch"))

    @unittest.skipIf(SKIP_GITHUB_API, "Github API tests skipped")
    def test_github_specific_rules(self):
        """
        Test accesses that require github API to access
        This is separate because we can only do so many tests per hour w/o getting a 403
        """
        # TODO - figure out how to get from a particular commit to the state of a file IN that commit
        self.assertEqual("https://raw.githubusercontent.com/linkml/linkml-model/blob/f30637f5a585f3fc4b12fd3dbb3e7e95108d4b42/jsonld/meta.model.context.jsonld",
                         GITHUB_PATH_FOR(Source.META, Format.NATIVE_JSONLD, "v0.0.1"))
        self.assertEqual("https://raw.githubusercontent.com/linkml/linkml-model/blob/f4bf90dcd38dd2d81e420147b91a4bfc7a8ffba4/model/schema/types.yaml",
                         GITHUB_PATH_FOR(Source.TYPES, Format.YAML))
        print(GITHUB_PATH_FOR(Source.MAPPINGS, Format.OWL, branch="missing_branch"))

        with self.assertRaises(ValueError) as e:
            GITHUB_PATH_FOR(Source.META, Format.RDF, "vv0.0.1")
        self.assertEqual("Tag: vv0.0.1 not found!", str(e.exception))


if __name__ == '__main__':
    unittest.main()
