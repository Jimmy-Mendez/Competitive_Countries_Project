use "\\smb-isl01.fsu.edu\citrix\jm18f\Documents\Industrial_Leadership\Data\Competitive_Indexes_and_GDP_5.dta", clear
bysort country year: keep if _n == 1
*replace Competitive_Rise_Country = log(Competitive_Rise_Country)
drop if year > 2017 
drop if year < 1972
*For some countries, Competitive_Rise Index is better at predicting the GDP growth rate
*This means that some countries are more reliant on market shares than others
gen export_share_of_GDP = Trade_Value/GDP_US_Current
gen interaction = export_share_of_GDP*Competitive_Rise_Country
xtset country year 
sort country year
gen growth5 = log(F5.GDP_Capita_Constant_LCU) - log(GDP_Capita_Constant_LCU)
xtreg growth5 Competitive_Rise_Country Competitive_Decline_Country L5.growth5 export_share_of_GDP interaction, fe
*line growth5 GDP_Capita_Constant_LCU year, legend(size(medsmall))
