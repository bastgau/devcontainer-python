"""..."""

from typing import Any, Dict

import pandas as pd

totos: Dict[str, str] = {
    "un": "one",
    "deux": "two",
    "trois": "three",
    "eee": "eee",
}

print(totos)

d: Any = {"col1": [0, 1, 2, 3], "col2": pd.Series([2, 3], index=[2, 3])}
pd.DataFrame(data=d, index=[0, 1, 2, 3])
