""" File : tests/{package_name}/test_application.py """

from typing import Any

import {package_name}.application as app


def test_hello() -> None:  # pylint: disable=unused-variable
    """..."""

    assert app.hello() == "Hello John Doe from {package_name}! How are you today?"
    assert app.hello("Jane Doe") == "Hello Jane Doe from {package_name}! How are you today?"


def test_run(capsys: Any) -> None:  # pylint: disable=unused-variable
    """..."""

    app.run()
    capured = capsys.readouterr()
    assert capured.out == "Hello John Doe from {package_name}! How are you today?\n"
