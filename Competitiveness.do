use "\\smb-isl01.fsu.edu\citrix\jm18f\Documents\Industrial_Leadership\new files\Country_Data_Set.dta", clear
bysort country year: keep if _n == 1
drop if year > 2017 
drop if year < 1972
*For some countries, Competitive_Rise Index is better at predicting the GDP growth rate
*This means that some countries are more reliant on market shares than others
xtset country year 
sort country year
gen growth5 = log(F5.gdppercapitaconstantlcunygdppcap) - log(gdppercapitaconstantlcunygdppcap)
xtreg growth5 Competitive_Rise_Country Competitive_Decline_Country L5.growth5, fe
