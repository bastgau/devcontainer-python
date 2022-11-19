"""..."""

import pandas as pd

ssss: str = 'RRR'

notes = {
    "Mathématiques": 19,
    "Français": 12,
    "Dessin": 15
}
ser: "pd.Series[str]" = pd.Series(notes, index=["Mathématiques", "Français", "Sciences Physiques", "Dessin"])

print(str(ser))
