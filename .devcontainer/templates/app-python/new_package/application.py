""" File: src/{package_name}/application.py """


def run() -> None:  # pylint: disable=unused-variable
    """
    The `run` function calls the `hello` function and prints the returned message.
    """
    message: str = hello()
    print(message)


def hello(name: str = "John Doe") -> str:
    """
    The function `hello` takes an optional `name` parameter and returns a greeting message with the
    provided name or a default name if none is provided.

    Args:
    name (str): The `name` parameter is a string that represents a person's name.
    It has a default value of "John Doe" if no value is provided when calling the `hello` function.

    Returns:
    the string "Hello {name} from example_one_one_one! How are you today!"
    """

    return f"Hello {name} from {package_name}! How are you today?"
