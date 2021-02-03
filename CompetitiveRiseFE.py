import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn import linear_model
import econtools.metrics as mt

df = pd.read_csv("CompetitiveData.csv")

df.drop_duplicates(subset=['year', 'origin'])
print(df.head())


df = df.dropna()
df = df[(df != 0).all(1)]
df = df[df.year < 2017]
df = df[df.year > 1972]

print(df.head())

df['leadGDP'] = np.log(df.gdppercapitaconstantlcunygdppcap.shift(-5))

print(df.head())

#creatiing growth10 var
df['growth5'] = (df.leadGDP) - np.log(df.gdppercapitaconstantlcunygdppcap)

y = 'growth5'
X = ['Competitive_Rise_Country','Competitive_Decline_Country']
fe_var = 'country'


print(df.head())


results = mt.reg(
    df,                     # DataFrame
    y,                      # Dependent var (string)
    X,                      # Independent var(s) (string or list of strings)
    fe_name = fe_var,
    addcons=True            # Adds a constant term
)

print(results)