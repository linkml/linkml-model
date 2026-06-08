import os
import re
from pathlib import Path

import pytest

import linkml_model.linkml_files as fileloc
from linkml_model.linkml_files import (
    URL_FOR,
    Format,
    Source,
    LOCAL_PATH_FOR,
    GITHUB_IO_PATH_FOR,
    GITHUB_PATH_FOR,
    ReleaseTag,
)
from tests import abspath

root_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "linkml_model"))

# The GitHub API tests resolve tags/releases to commits via the live GitHub API,
# which is rate-limited and flaky in CI, so they are opt-in.
# Set LINKML_TEST_GITHUB_API=1 to run them.
RUN_GITHUB_API = os.environ.get("LINKML_TEST_GITHUB_API", "").lower() in {"1", "true", "yes", "on"}


def test_url_for():
    """URL_FOR builds w3id.org URLs from the format extension."""
    assert URL_FOR(Source.ANNOTATIONS, Format.YAML) == "https://w3id.org/linkml/annotations.yaml"
    assert URL_FOR(Source.META, Format.NATIVE_JSONLD) == "https://w3id.org/linkml/meta.model.context.jsonld"


def test_local_path_for():
    """LOCAL_PATH_FOR points at the on-disk file inside the linkml_model package."""
    assert LOCAL_PATH_FOR(Source.META, Format.YAML) == os.path.join(root_path, "model/schema/meta.yaml")
    assert LOCAL_PATH_FOR(Source.TYPES, Format.NATIVE_JSONLD) == os.path.join(
        root_path, "jsonld/types.model.context.jsonld"
    )


def test_github_io_path_for():
    """GitHub Pages URLs are versioned and live under <version>/linkml_model/."""
    assert (
        GITHUB_IO_PATH_FOR(Source.META, Format.YAML)
        == "https://linkml.github.io/linkml-model/latest/linkml_model/model/schema/meta.yaml"
    )
    assert (
        GITHUB_IO_PATH_FOR(Source.TYPES, Format.NATIVE_JSONLD)
        == "https://linkml.github.io/linkml-model/latest/linkml_model/jsonld/types.model.context.jsonld"
    )
    # the version segment is overridable
    assert (
        GITHUB_IO_PATH_FOR(Source.META, Format.YAML, version="v1.11.0")
        == "https://linkml.github.io/linkml-model/v1.11.0/linkml_model/model/schema/meta.yaml"
    )


def test_github_path_for_branch():
    """Branch / LATEST raw URLs are pure string formatting (no network)."""
    assert (
        GITHUB_PATH_FOR(Source.META, Format.NATIVE_JSONLD, ReleaseTag.LATEST)
        == "https://raw.githubusercontent.com/linkml/linkml-model/main/linkml_model/jsonld/meta.model.context.jsonld"
    )
    assert (
        GITHUB_PATH_FOR(Source.MAPPINGS, Format.OWL, branch="testing_branch")
        == "https://raw.githubusercontent.com/linkml/linkml-model/testing_branch/linkml_model/owl/mappings.owl.ttl"
    )
    # TODO: a non-existent branch is not validated and yields a non-resolving URL
    assert (
        GITHUB_PATH_FOR(Source.MAPPINGS, Format.OWL, branch="missing_branch")
        == "https://raw.githubusercontent.com/linkml/linkml-model/missing_branch/linkml_model/owl/mappings.owl.ttl"
    )


def test_github_path_for_release_and_branch_conflict():
    """Specifying both a release and a non-main branch is an error (no network)."""
    with pytest.raises(ValueError):
        GITHUB_PATH_FOR(Source.META, Format.RDF, ReleaseTag.LATEST, branch="some_branch")


@pytest.mark.skipif(
    not RUN_GITHUB_API,
    reason="set LINKML_TEST_GITHUB_API=1 to run rate-limited GitHub API tests",
)
def test_github_specific_rules():
    """Tag / release resolution via the GitHub API.

    Note: the builder applies the current ``linkml_model/`` layout uniformly to
    all tags. Pre-restructure tags (e.g. v0.0.1) stored artifacts at the repo
    root, so the URL generated for those very old tags uses the current layout
    rather than their historical one and will not resolve.
    """
    assert GITHUB_PATH_FOR(Source.META, Format.NATIVE_JSONLD, "v0.0.1") == (
        "https://raw.githubusercontent.com/linkml/linkml-model/"
        "f30637f5a585f3fc4b12fd3dbb3e7e95108d4b42/linkml_model/jsonld/meta.model.context.jsonld"
    )
    current_loc = re.sub(
        r"linkml-model/[0-9a-f]{40}/", "linkml-model/SHA/", GITHUB_PATH_FOR(Source.TYPES, Format.YAML)
    )
    assert current_loc == (
        "https://raw.githubusercontent.com/linkml/linkml-model/SHA/linkml_model/model/schema/types.yaml"
    )
    with pytest.raises(ValueError, match="Tag: vv0.0.1 not found!"):
        GITHUB_PATH_FOR(Source.META, Format.RDF, "vv0.0.1")


def test_shorthand_paths():
    """The ModelFile shorthand accessors mirror the underlying functions."""
    assert str(fileloc.meta) == "meta"
    assert str(fileloc.meta.yaml) == "meta.yaml"
    assert str(fileloc.meta.python) == "meta.py"
    assert Path(fileloc.meta.yaml.file) == Path(abspath("linkml_model/model/schema/meta.yaml"))
    assert (
        str(fileloc.meta.yaml.github_loc())
        == "https://linkml.github.io/linkml-model/latest/linkml_model/model/schema/meta.yaml"
    )
