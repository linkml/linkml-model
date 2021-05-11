import os
import unittest
import re

import linkml_model.linkml_files as fileloc
from linkml_model.linkml_files import URL_FOR, Format, Source, LOCAL_PATH_FOR, GITHUB_IO_PATH_FOR, GITHUB_PATH_FOR, \
    ReleaseTag
from tests import abspath

root_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "linkml_model"))

SKIP_GITHUB_API = False              # True means don't do the github API tests


class LinkMLFilesTestCase(unittest.TestCase):
    """ Test that linkml_model/linkml_files.py work """
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
        self.assertEqual("https://raw.githubusercontent.com/linkml/linkml-model/f30637f5a585f3fc4b12fd3dbb3e7e95108d4b42/jsonld/meta.model.context.jsonld",
                         GITHUB_PATH_FOR(Source.META, Format.NATIVE_JSONLD, "v0.0.1"))
        current_loc = re.sub(r'linkml-model/[0-9a-f]*/', 'linkml-model/SHA/', GITHUB_PATH_FOR(Source.TYPES, Format.YAML))
        self.assertEqual("https://raw.githubusercontent.com/linkml/linkml-model/SHA/model/schema/types.yaml", current_loc)
        # TODO: We may want to raise an error here?
        self.assertEqual('https://raw.githubusercontent.com/linkml/linkml-model/missing_branch/owl/mappings.owl.ttl',
                         GITHUB_PATH_FOR(Source.MAPPINGS, Format.OWL, branch="missing_branch"))

        with self.assertRaises(ValueError) as e:
            GITHUB_PATH_FOR(Source.META, Format.RDF, "vv0.0.1")
        self.assertEqual("Tag: vv0.0.1 not found!", str(e.exception))

    def test_shorthand_paths(self):
        self.assertEqual('meta', str(fileloc.meta))
        self.assertEqual('meta.yaml', str(fileloc.meta.yaml))
        self.assertEqual('meta.py', str(fileloc.meta.python))
        self.assertEqual(abspath('linkml_model/model/schema/meta.yaml'), str(fileloc.meta.yaml.file))
        self.assertEqual('https://linkml.github.io/linkml-model/model/schema/meta.yaml', str(fileloc.meta.yaml.github_loc()))
        self.assertEqual('https://raw.githubusercontent.com/linkml/linkml-model/f30637f5a585f3fc4b12fd3dbb3e7e95108d4b42/model/schema/meta.yaml', str(fileloc.meta.yaml.github_loc('v0.0.1')))


if __name__ == '__main__':
    unittest.main()
