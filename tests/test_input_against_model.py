import os
import unittest

from linkml_runtime.loaders import yaml_loader, json_loader, rdf_loader

from linkml_model import SchemaDefinition

CWD = os.path.abspath(os.path.dirname(__file__))
INPUT_DIR = os.path.join(CWD, 'input')


class InputFileTestCase(unittest.TestCase):
    """ Test the input files against the model"""
    def test_input_files(self):
        """ Iterate over the input directory loading any test files """
        def gen_detail(total: int, passed: int, typ: str) -> str:
            return f"{total} {typ} files tested - {total-passed} failures"

        nyaml, njson, nttl = 0, 0, 0
        pyaml, pjson, pttl = 0, 0, 0
        nunk = 0
        nread, nfailures = 0, 0
        failures = []
        for dpath, _, files in os.walk(INPUT_DIR):
            for fname in files:
                full_fname = os.path.join(dpath, fname)
                nread += 1
                try:
                    if fname.endswith('.yaml'):
                        nyaml += 1
                        o: SchemaDefinition = yaml_loader.load(full_fname, SchemaDefinition)
                        pyaml += 1
                    elif fname.endswith('.json'):
                        njson += 1
                        o: SchemaDefinition = json_loader.load(full_fname, SchemaDefinition)
                        pjson += 1
                    elif fname.endswith('.ttl'):
                        nttl += 1
                        o: SchemaDefinition = rdf_loader.load(full_fname, SchemaDefinition)
                        pttl += 1
                    elif fname.endswith('.md'):
                        pass
                    else:
                        nunk += 1
                except Exception as e:
                    nfailures += 1
                    failures.append(f"{os.path.relpath(full_fname, INPUT_DIR)}: {e}")

        print(f"{nread} files tested")
        print(f"\t{nread - nfailures} tests passed ({nfailures} failed)")
        print("\tDetails:")
        print(f"\t\t{gen_detail(nyaml, pyaml, 'YAML')}")
        print(f"\t\t{gen_detail(njson, pjson, 'JSON')}")
        print(f"\t\t{gen_detail(nttl, pttl, 'TTL')}")
        if nunk:
            print(f"{nunk} files of unrecognized type")
        self.assertEqual(nfailures, 0, f"{nfailures} input file(s) failed to load:\n" + "\n".join(failures))


if __name__ == '__main__':
    unittest.main()
