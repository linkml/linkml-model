"""Tests for the `is_open` slot on enum expressions.

`is_open` is declared on `enum_expression`, so it is inherited by
`enum_definition`, `anonymous_enum_expression`, and any anonymous enum
expression appearing under `enum_range`, `include`, or `minus`.

These tests round-trip tests/input/examples/schema_definition-open-enums.yaml
through the generated metamodel to confirm the slot is present on every one of
those classes and carries the declared value. `make test-examples` separately
validates the same file against meta.yaml itself.
"""

import pytest
from linkml_runtime.loaders import yaml_loader

from linkml_model import SchemaDefinition
from tests import abspath

EXAMPLE = abspath("tests/input/examples/schema_definition-open-enums.yaml")


@pytest.fixture(scope="module")
def schema() -> SchemaDefinition:
    return yaml_loader.load(EXAMPLE, SchemaDefinition)


@pytest.mark.parametrize(
    "enum_name,expected",
    [
        ("JobTitleEnum", True),
        ("MaritalStatusEnum", False),
        ("HumanDiseaseEnum", True),
        ("InheritedOpenEnum", True),
        # is_open is not declared; there is no ifabsent, so it loads as None and
        # the closed-by-default behaviour is applied by the runtime, not the model.
        ("DefaultedEnum", None),
    ],
)
def test_is_open_on_enum_definition(schema, enum_name, expected):
    """is_open is readable on a named enum, and absent means None (not False)."""
    assert schema.enums[enum_name].is_open == expected


@pytest.mark.parametrize(
    "slot_name,expected",
    [
        ("eye_color", True),
        ("primary_language", None),
    ],
)
def test_is_open_on_anonymous_enum_range(schema, slot_name, expected):
    """is_open is readable on an anonymous enum expression under enum_range."""
    assert schema.slots[slot_name].enum_range.is_open == expected


def test_is_open_in_slot_usage(schema):
    """A slot_usage may narrow an open enum to a closed anonymous expression."""
    slot_usage = schema.classes["Researcher"].slot_usage["marital_status"]
    assert slot_usage.enum_range.is_open is False


def test_is_open_on_composed_expressions(schema):
    """is_open applies independently to each composed enum expression."""
    enum = schema.enums["InheritedOpenEnum"]
    assert enum.is_open is True
    assert enum.include[0].is_open is False


def test_is_open_is_coerced_to_bool(schema):
    """Values load as booleans rather than the raw YAML strings."""
    assert isinstance(schema.enums["JobTitleEnum"].is_open, bool)
    assert isinstance(schema.enums["MaritalStatusEnum"].is_open, bool)


def test_is_open_declared_on_enum_expression():
    """The slot is declared on enum_expression, hence available to its descendants."""
    from linkml_model.meta import AnonymousEnumExpression, EnumDefinition, EnumExpression

    for cls in (EnumExpression, EnumDefinition, AnonymousEnumExpression):
        assert "is_open" in cls.__annotations__, f"is_open missing from {cls.__name__}"
