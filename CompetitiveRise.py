import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn import linear_model
import math

df = pd.read_csv("CompetitiveData.csv")

df = df[df.origin == 'JPN']
df = df.dropna()
df = df[df.year < 2010]
df = df[(df != 0).all(1)]

#changing to natural log
df['gdppercapitaconstantlcunygdppcap'] = np.log(df.gdppercapitaconstantlcunygdppcap)


print(df.head())

plt.xlabel("Competitive Rise")
plt.ylabel("GDP per Capita (constant LCU)")
plt.scatter(df.Competitive_Rise_Country, df.gdppercapitaconstantlcunygdppcap)

reg = linear_model.LinearRegression()
reg.fit(df[['Competitive_Rise_Country']], df.gdppercapitaconstantlcunygdppcap)
plt.plot(df.Competitive_Rise_Country, reg.predict(df[['Competitive_Rise_Country']]))

print(reg.predict([[0.084159523]]))

##Using the pre-2010 data, the competitive index predicts gdp growth very well