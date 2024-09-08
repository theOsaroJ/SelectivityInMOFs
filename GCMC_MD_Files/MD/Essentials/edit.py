#!/usr/env python3
import pandas as pd

data = pd.read_csv('fourth.csv', header=None)
val = data.iloc[:, 0].values

val = val - chg

# put val in a dataframe
val = pd.DataFrame(val)

val.to_csv('fifth.csv', index=False, header=None)
