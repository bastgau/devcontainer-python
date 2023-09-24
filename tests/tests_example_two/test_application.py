"""..."""

import example_two.application as app


def test_hello() -> None:  # pylint: disable=unused-variable
    """..."""

    assert app.hello() == "Hello John Doe! How are you today?"
    assert app.hello("Jane Doe") == "Hello Jane Doe! How are you today?"
