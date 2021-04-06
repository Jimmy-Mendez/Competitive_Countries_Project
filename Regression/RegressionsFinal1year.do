use "\\smb-isl01.fsu.edu\citrix\jm18f\Documents\Industrial_Leadership\Data\Competitive_Indexes_and_GDP_1.dta", clear
bysort country year: keep if _n == 1
drop if year > 2017 
drop if year < 1972
*For some countries, Competitive_Rise Index is better at predicting the GDP growth rate
*This means that some countries are more reliant on market shares than others
gen gdp = GDP_US_Current
gen export_share_of_GDP = Trade_Value/GDP_US_Current
gen interaction = export_share_of_GDP*Competitive_Rise_Country
xtset country year 
sort country year
gen loggdp = log(gdp)

*future average 5 year gdp growth
gen futgrowth5 = (log(F5.gdp/gdp))/5
*future 1 year gdp growth
gen futgrowth1 = log(F1.gdp/gdp)
*past 1 year gdp growth
gen pastgrowth1 = (log(gdp / L.gdp))
*past average 5 year gdp growth
gen pastgrowth5 = (log(gdp / L5.gdp))/ 5


***************************RUNNING REGRESSIONS***********************************

*1 year growth forecast
eststo clear
eststo: quietly xtreg futgrowth1 Competitive_Rise_Country Competitive_Decline_Country pastgrowth1 L.pastgrowth1 i.year, fe
estadd local fixed "Yes" , replace
eststo: quietly xtreg futgrowth1 Competitive_Rise_Country Competitive_Decline_Country pastgrowth1 L.pastgrowth1 L2.pastgrowth1 i.year, fe
estadd local fixed "Yes" , replace
eststo: xtreg futgrowth1 Competitive_Rise_Country Competitive_Decline_Country pastgrowth1 L.pastgrowth1 L2.pastgrowth1 pastgrowth5 export_share_of_GDP interaction i.year, fe
estadd local fixed "Yes" , replace
esttab using Table3z.tex, replace label drop(*.year) frag  s(fixed N, label("Country FE")) title(1 year growth forecast\label{tab3})

*1 year Competitive Rise Forecast
eststo clear
eststo: quietly xtreg F1.Competitive_Rise_Country pastgrowth1 i.year, fe
estadd local fixed "Yes" , replace
eststo: quietly xtreg F1.Competitive_Rise_Country pastgrowth1 Competitive_Rise_Country L.Competitive_Rise_Country L2.Competitive_Rise_Country Competitive_Decline_Country L.Competitive_Decline_Country L2.Competitive_Decline_Country i.year, fe
estadd local fixed "Yes" , replace
eststo: xtreg F1.Competitive_Rise_Country pastgrowth1 Competitive_Rise_Country L.Competitive_Rise_Country L2.Competitive_Rise_Country L3.Competitive_Rise_Country Competitive_Decline_Country  L.Competitive_Decline_Country L2.Competitive_Decline_Country L3.Competitive_Decline_Country export_share_of_GDP interaction i.year, fe
estadd local fixed "Yes" , replace
esttab using Table4z.tex, replace label drop(*.year) frag  s(fixed N, label("Country FE")) title(1 year Competitive Rise Forecast\label{tab4})