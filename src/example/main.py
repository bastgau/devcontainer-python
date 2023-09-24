"""..."""

from typing import Any, Dict

import pandas as pd

toto: Dict[str, str] = {
    "un": "one",
    "deux": "two",
    "trois": "three",
    "eee": "eee",
}

print(toto)

d: Any = {"col1": [0, 1, 2, 3], "col2": pd.Series([2, 3], index=[2, 3])}
pd.DataFrame(data=d, index=[0, 1, 2, 3])
