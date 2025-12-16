import os
from unittest import mock

from rich_objects.console import TEST_TERMINAL_WIDTH
from rich_objects.console import console_factory


def test_console_factory_arg():
    uut = console_factory(width=23)
    assert 23 == uut._width


def test_console_factory_env():
    with mock.patch.dict(os.environ, {"TERMINAL_WIDTH": "37"}, clear=True):
        uut = console_factory()
        assert 37 == uut._width


def test_console_factory_pytest():
    uut = console_factory()
    assert TEST_TERMINAL_WIDTH == uut._width
