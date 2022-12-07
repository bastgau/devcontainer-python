""" Program to check the linters availability and their correct configuration """

# Program has been written to generate six errors...

# Mypy: Missing type parameters for generic type "dict"  [type-arg]
# Pylance: Expected type arguments for generic class "dict"
# > Use Dict[str, str] instead of dict to resolve the issue.

# Mypy: Skipping analyzing "pandas": module is installed, but ... or py.typed marker  [import]
# Mypy: See https://mypy.readthedocs.io/en/stable/running_mypy.html#missing-imports
# > Check setup.cfg  to resolve the issue.

# Pylint: Line too long (110/100)
# Pylama: Line too long (110 > 100 characters) [pycodestyle]
# > Change the configuration or the code to resolve the issue.

import pandas as pd

my_unused_variable: dict = {
    "foo":
        "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789"
}

del my_unused_variable

df = pd.DataFrame()
del df
