import os
import sys
import unittest
from contextlib import redirect_stdout
from dataclasses import dataclass
from typing import List, Optional, Union, Tuple, Set

import requests

from rdflib import Namespace, URIRef

if __name__ == '__main__':
    sys.path.append(os.path.join(os.path.dirname(__file__), '..', '..'))
    print(sys.path)

# Configuration
#   FAIL_ON_ERROR -- True means stop on first error. False says plod on through
#   W3ID_SERVER -- from server base
#   SERVER_DIR  -- from server directory
FAIL_ON_ERROR = True
W3ID_SERVER = "https://w3id.org/"
FROM_SERVER_DIR = "linkml"

TO_SERVER_BASE = "https://linkml.github.io/linkml-model/"
DOCS_DIR = "docs"
SOURCE_DIR = "linkml_model"
DEFAULT_HEADER = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"

# Once you've got stuff working, uncomment the line below and comment out the DEFAULT_SERVER
DEFAULT_SERVER = W3ID_SERVER
SKIP_REWRITE_RULES = True

# DEFAULT_SERVER = "http://localhost:8091/"
# SKIP_REWRITE_RULES = False


@dataclass
class TestEntry:
    """ Entry to be tested.  Map input_url w/ accept_header to expected_url """
    input_url: Union[str, URIRef, Namespace]
    expected_url: str
    accept_header: Optional[str] = None


def build_test_entry_set(input_url: Namespace, model: str) -> List[TestEntry]:
    """ Build a set of test entries for different permutations of input URL """
    return [
        TestEntry(input_url, f'{DOCS_DIR}/{model}', 'text/html'),
        TestEntry(input_url, f'{SOURCE_DIR}/model/schema/{model}.yaml', 'text/yaml'),
        TestEntry(input_url, f'{SOURCE_DIR}/rdf/{model}.ttl', 'text/turtle'),
        TestEntry(input_url, f'{SOURCE_DIR}/json/{model}.json', 'application/json'),
        TestEntry(input_url, f'{SOURCE_DIR}/shex/{model}.shex', 'text/shex'),
        TestEntry(input_url['.context.jsonld'], f'{SOURCE_DIR}/jsonld/{model}.context.jsonld'),
        TestEntry(input_url['.owl'], f'{SOURCE_DIR}/owl/{model}.owl.ttl'),
        TestEntry(input_url['/'], f'{model}/'),
        TestEntry(input_url['/abc'], f'{DOCS_DIR}/{model}/abc')
    ]


class TestLists:
    def __init__(self, server: str) -> None:
        if not server.endswith(('#', '/')):
            server += '/'
        # This is the server base -- it corresponds to the parent directory
        self.linkml = server + FROM_SERVER_DIR + '/'

        # Base directories for the various sources (plural means the entire module)
        self.types_base = Namespace(self.linkml + 'types')
        self.mappings_base = Namespace(self.linkml)
        self.extensions_base = Namespace(self.linkml)
        self.annotations_base = Namespace(self.linkml)
        self.metas_base = Namespace(self.linkml)

        # Singular base directories (type / mapping / meta) (singular means an element within)
        self.type_base = Namespace(self.linkml)
        self.meta_base = Namespace(self.linkml)

        # meta_entries - test various module types and permutations
        self.meta_entries = build_test_entry_set(self.types_base, 'types')

        self.vocab_entries: List[TestEntry] = [
            TestEntry(self.type_base.Boolean, f'{DOCS_DIR}/Boolean'),
        ]
        # Test for various metamodel sources
        self.meta_model_entries: List[TestEntry] = [
            TestEntry(self.metas_base, f'{DOCS_DIR}/'),
            TestEntry(self.metas_base.meta, f'{SOURCE_DIR}/model/schema/meta.yaml', 'text/yaml'),
            TestEntry(self.metas_base.meta, f'{SOURCE_DIR}/rdf/meta.ttl', 'text/turtle'),
            TestEntry(self.metas_base.meta, f'{SOURCE_DIR}/json/meta.json', 'application/json'),
            TestEntry(self.metas_base.meta, f'{SOURCE_DIR}/shex/meta.shex', 'text/shex'),
            TestEntry(self.metas_base['meta.owl'], f'{SOURCE_DIR}/owl/meta.owl.ttl'),
            TestEntry(self.metas_base['meta.foo'], f'meta.foo'),
            TestEntry(self.linkml + 'context.jsonld', f'{SOURCE_DIR}/jsonld/context.jsonld'),
            TestEntry(self.linkml + 'meta.context.jsonld', f'{SOURCE_DIR}/jsonld/meta.context.jsonld'),
            TestEntry(self.linkml + 'meta.model.context.jsonld', f'{SOURCE_DIR}/jsonld/meta.model.context.jsonld')
        ]
        # Test for metamodel slots and classes
        self.meta_vocab_entries: List[TestEntry] = [
            TestEntry(self.meta_base.Element, f'{DOCS_DIR}/Element'),
            TestEntry(self.meta_base.Element, f'{DOCS_DIR}/Element', 'text/html'),
            TestEntry(self.meta_base.meaning, f'{DOCS_DIR}/meaning'),
            TestEntry(self.type_base.Boolean, f'{DOCS_DIR}/Boolean'),
            TestEntry(self.meta_base.meta, f'{SOURCE_DIR}/model/schema/meta.yaml', 'text/yaml'),
            TestEntry(self.meta_base.meta, f'{SOURCE_DIR}/rdf/meta.ttl', 'text/turtle'),
            TestEntry(self.meta_base.meta, f'{SOURCE_DIR}/json/meta.json', 'application/json'),
            TestEntry(self.meta_base.meta, f'{SOURCE_DIR}/shex/meta.shex', 'text/shex'),
            TestEntry(self.meta_base.meta, f'{SOURCE_DIR}/jsonld/meta.context.jsonld', 'application/ld+json'),
            # We don't know where this should go.  At the moment it gots through to "Element"
            TestEntry(self.meta_base.meta, f'meta', 'text/foo'),
        ]


@unittest.skipIf(SKIP_REWRITE_RULES, "W3ID Rewrite rules are not tested")
class RewriteRuleTestCase(unittest.TestCase):
    SERVER = DEFAULT_SERVER         # Can be overwritten with a startup parameter
    results: Set[Tuple[str, str, str]] = None

    @classmethod
    def setUpClass(cls):
        cls.tests = TestLists(cls.SERVER)
        print(f"Server: {cls.SERVER}")
        cls.results = set()   # from, to, format

    @classmethod
    def tearDownClass(cls):
        """ Print the mapping as documentation """
        with open('MAPPING.md', 'w') as outf:
            with redirect_stdout(outf):
                print('# Test Mapping Output')
                print('Mappings generated by test_rewrite_rules.py')
                print()
                print('| Input URL | Accept | Output URL |')
                print('| ----- | ----- | ----- |')
                for from_url, to_url, hdr in sorted(list(cls.results)):
                    fmt = '' if hdr == 'text/html' else f" ({hdr})"
                    if DEFAULT_SERVER != W3ID_SERVER:
                        from_url = from_url.replace(DEFAULT_SERVER, W3ID_SERVER)
                    print(f"| {from_url} | {hdr} | {to_url} |")
        print("OUTPUT saved in MAPPING.md")

    def record_results(self, from_url: str, accept_header, to_url: str) -> None:
        self.results.add((from_url, to_url, accept_header.split(',')[0]))

    def rule_test(self, entries: List[TestEntry]) -> None:

        def test_it(e: TestEntry, accept_header: str) -> bool:
            expected = TO_SERVER_BASE + e.expected_url
            resp = requests.head(e.input_url, headers={'accept': accept_header}, verify=False)

            # w3id.org uses a 301 to go from http: to https:
            if resp.status_code == 301 and 'location' in resp.headers:
                resp = requests.head(resp.headers['location'], headers={'accept': accept_header}, verify=False)
            actual = resp.headers['location'] \
                if resp.status_code == 302 and 'location' in resp.headers \
                else f"Error: {resp.status_code}"
            if FAIL_ON_ERROR:
                self.assertEqual(expected, actual, f"redirect for: {resp.url}({accept_header})")
                self.record_results(e.input_url, accept_header, actual)
                return True
            elif expected != actual:
                print(f"{e.input_url} ({accept_header}):\n expected {expected} - got {actual}")
                return False
            self.record_results(e.input_url, accept_header, actual)
            return True

        def ev_al(entry: TestEntry) -> bool:
            if not entry.accept_header:
                return test_it(entry, DEFAULT_HEADER)
            else:
                r1 = test_it(entry, entry.accept_header)
                return test_it(entry, entry.accept_header + ',' + DEFAULT_HEADER) and r1

        self.assertTrue(all([ev_al(entry) for entry in entries]))

    def test_type_meta(self):
        self.rule_test(self.tests.meta_entries)

    def test_type_entry(self):
        self.rule_test(self.tests.vocab_entries)

    def test_meta_meta(self):
        self.rule_test(self.tests.meta_model_entries)

    def test_meta_entry(self):
        """ Future expansion -- meta_vocab_entries  """
        self.rule_test(self.tests.meta_vocab_entries)


if __name__ == '__main__':
    RewriteRuleTestCase.SERVER = os.environ.get('SERVER', RewriteRuleTestCase.SERVER)
    unittest.main()
