use "\\smb-isl01.fsu.edu\citrix\jm18f\Documents\Industrial_Leadership\Data\Competitive_Indexes_and_GDP_5.dta", clear
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

*5 year growth forecast
eststo clear
eststo: quietly xtreg futgrowth5 Competitive_Rise_Country Competitive_Decline_Country i.year, fe
estadd local fixed "Yes" , replace
eststo: quietly xtreg futgrowth5 Competitive_Rise_Country Competitive_Decline_Country pastgrowth5 i.year, fe
estadd local fixed "Yes" , replace
eststo: xtreg futgrowth5 Competitive_Rise_Country Competitive_Decline_Country pastgrowth5 export_share_of_GDP interaction i.year, fe
estadd local fixed "Yes" , replace
esttab using Table1z.tex, replace label drop(*.year) frag  s(fixed N, label("Country FE")) title(Competitive Rise and Decline with Respect to Future GDP Growth (With Time Effects)\label{tab1}) 

*5 year Competitive Rise Forecast 
eststo clear
eststo: quietly xtreg F5.Competitive_Rise_Country pastgrowth5 i.year, fe
estadd local fixed "Yes" , replace
eststo: quietly xtreg F5.Competitive_Rise_Country pastgrowth5 Competitive_Rise_Country Competitive_Decline_Country i.year, fe
estadd local fixed "Yes" , replace
eststo: xtreg F5.Competitive_Rise_Country pastgrowth5 Competitive_Rise_Country Competitive_Decline_Country export_share_of_GDP interaction i.year, fe
estadd local fixed "Yes" , replace
esttab using Table2z.tex, replace label drop(*.year) frag  s(fixed N, label("Country FE")) title(5 year Competitive Rise Forecast\label{tab2})

*The between R2 is "How much of the variance between seperate panel units does my model account for" The within R2 is "How much of the variance within the panel units does my model account for" and the R2 overall is a weighted average of these two.
