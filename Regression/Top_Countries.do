use "\\smb-isl01.fsu.edu\citrix\jm18f\Documents\Industrial_Leadership\Data\Competitive_Indexes_and_GDP_1.dta", clear
bysort country year: keep if _n == 1
*replace Competitive_Rise_Country = log(Competitive_Rise_Country)
drop if year > 2017 
drop if year < 1972
*For some countries, Competitive_Rise Index is better at predicting the GDP growth rate
*This means that some countries are more reliant on market shares than others
gen gdp = GDP_US_Current
gen export_share_of_GDP = Trade_Value/GDP_US_Current
gen interaction = export_share_of_GDP*Competitive_Rise_Country
gen Competitive_Gain = Competitive_Rise_Country - Competitive_Decline_Country
xtset country year 
sort country year
gen loggdp = log(gdp)
gen growth5 = F5.loggdp - loggdp
gen growth1 = F1.loggdp - loggdp
gen avgGrowthLast5 = (L1.loggdp + L2.loggdp + L3.loggdp + L4.loggdp + L5.loggdp)/ 5

keep if gdp > 5000


*************************************RUNNING REGRESSIONS*******************************************

*5 year growth forecast
eststo clear
eststo: quietly xtreg growth5 Competitive_Rise_Country Competitive_Decline_Country, fe
estadd local fixed "Yes" , replace
eststo: quietly xtreg growth5 Competitive_Rise_Country Competitive_Decline_Country avgGrowthLast5, fe
estadd local fixed "Yes" , replace
eststo: xtreg growth5 Competitive_Rise_Country Competitive_Decline_Country avgGrowthLast5 export_share_of_GDP interaction, fe
estadd local fixed "Yes" , replace
esttab using Table1a.tex, replace label frag  s(fixed N, label("Country FE")) title(Competitive Rise and Net Gain with Respect to Future GDP Growth\label{tab1}) 

*5 year growth forecast w time effects
eststo clear
eststo: quietly xtreg growth5 Competitive_Rise_Country Competitive_Decline_Country i.year, fe
estadd local fixed "Yes" , replace
eststo: quietly xtreg growth5 Competitive_Rise_Country Competitive_Decline_Country avgGrowthLast5 i.year, fe
estadd local fixed "Yes" , replace
eststo: xtreg growth5 Competitive_Rise_Country Competitive_Decline_Country avgGrowthLast5 export_share_of_GDP interaction i.year, fe
estadd local fixed "Yes" , replace
esttab using Table2a.tex, replace label drop(*.year) frag  s(fixed N, label("Country FE")) title(Competitive Rise and Gain with Respect to Future GDP Growth (With Time Effects)\label{tab2}) 

*5 year Competitive Rise Forecast
eststo: quietly xtreg F5.Competitive_Rise_Country loggdp, fe
eststo: quietly xtreg F5.Competitive_Rise_Country loggdp Competitive_Rise_Country Competitive_Decline_Country, fe
estadd local fixed "Yes" , replace
eststo: xtreg F5.Competitive_Rise_Country loggdp Competitive_Rise_Country Competitive_Decline_Country export_share_of_GDP interaction, fe
estadd local fixed "Yes" , replace
esttab using Table3a.tex, replace label frag  s(fixed N, label("Country FE")) title(GDP Growth with Respect to Future Competitive Rise\label{tab3}) 

*5 year Competitive Rise Forecast w time effects
eststo: quietly xtreg F5.Competitive_Rise_Country loggdp i.year, fe
eststo: quietly xtreg F5.Competitive_Rise_Country loggdp Competitive_Rise_Country Competitive_Decline_Country i.year, fe
estadd local fixed "Yes" , replace
eststo: xtreg F5.Competitive_Rise_Country loggdp Competitive_Rise_Country Competitive_Decline_Country export_share_of_GDP interaction i.year, fe
estadd local fixed "Yes" , replace
esttab using Table4a.tex, replace label drop(*.year) frag  s(fixed N, label("Country FE")) title(5 year Competitive Rise Forecast w time effects\label{tab4})

*1 year growth forecast
eststo clear
eststo: quietly xtreg growth1 Competitive_Rise_Country Competitive_Decline_Country L.growth1 L2.growth1, fe
estadd local fixed "Yes" , replace
eststo: quietly xtreg growth1 Competitive_Rise_Country Competitive_Decline_Country L.growth1 L2.growth1 avgGrowthLast5, fe
estadd local fixed "Yes" , replace
eststo: xtreg growth1 Competitive_Rise_Country Competitive_Decline_Country L.growth1 L2.growth1 avgGrowthLast5 export_share_of_GDP interaction, fe
estadd local fixed "Yes" , replace
esttab using Table5a.tex, replace label frag  s(fixed N, label("Country FE")) title(Competitive Rise and Net Gain with Respect to Future GDP Growth\label{tab5}) 

*1 year growth forecast w time effects
eststo clear
eststo: quietly xtreg growth1 Competitive_Rise_Country Competitive_Decline_Country L.growth1 L2.growth1 i.year, fe
estadd local fixed "Yes" , replace
eststo: quietly xtreg growth1 Competitive_Rise_Country Competitive_Decline_Country L.growth1 L2.growth1 avgGrowthLast5 i.year, fe
estadd local fixed "Yes" , replace
eststo: xtreg growth1 Competitive_Rise_Country Competitive_Decline_Country L.growth1 L2.growth1 avgGrowthLast5 export_share_of_GDP interaction i.year, fe
estadd local fixed "Yes" , replace
esttab using Table6a.tex, replace label drop(*.year) frag  s(fixed N, label("Country FE")) title(1 year growth forecast w time effects\label{tab6})

*1 year Competitive Rise Forecast
eststo: quietly xtreg F1.Competitive_Rise_Country loggdp, fe
eststo: quietly xtreg F1.Competitive_Rise_Country loggdp Competitive_Rise_Country Competitive_Decline_Country, fe
estadd local fixed "Yes" , replace
eststo: xtreg F1.Competitive_Rise_Country loggdp Competitive_Rise_Country Competitive_Decline_Country export_share_of_GDP interaction, fe
estadd local fixed "Yes" , replace
esttab using Table7a.tex, replace label frag  s(fixed N, label("Country FE")) title(GDP Growth with Respect to Future Competitive Rise\label{tab7}) 

*1 year Competitive Rise Forecast w time effects
eststo: quietly xtreg F1.Competitive_Rise_Country loggdp i.year, fe
eststo: quietly xtreg F1.Competitive_Rise_Country loggdp Competitive_Rise_Country Competitive_Decline_Country i.year, fe
estadd local fixed "Yes" , replace
eststo: xtreg F1.Competitive_Rise_Country loggdp Competitive_Rise_Country Competitive_Decline_Country export_share_of_GDP interaction i.year, fe
estadd local fixed "Yes" , replace
esttab using Table8a.tex, replace label drop(*.year) frag  s(fixed N, label("Country FE")) title(1 year Competitive Rise Forecast w time effects\label{tab8})


********************************ADDING GROWTH INDICATORS**************************************


*1 year growth forecast w time effects and patent growth
eststo clear
eststo: quietly xtreg growth1 Competitive_Rise_Country Competitive_Decline_Country L.growth1 L2.growth1 i.year, fe
estadd local fixed "Yes" , replace
eststo: quietly xtreg growth1 Competitive_Rise_Country Competitive_Decline_Country L.growth1 L2.growth1 avgGrowthLast5 i.year, fe
estadd local fixed "Yes" , replace
eststo: quietly xtreg growth1 Competitive_Rise_Country Competitive_Decline_Country L.growth1 L2.growth1 avgGrowthLast5 export_share_of_GDP interaction i.year, fe
estadd local fixed "Yes" , replace
eststo: xtreg growth1 Competitive_Rise_Country Competitive_Decline_Country L.growth1 L2.growth1 avgGrowthLast5 export_share_of_GDP interaction logPatents i.year, fe
estadd local fixed "Yes" , replace
esttab using Table9a.tex, replace label drop(*.year) frag  s(fixed N, label("Country FE")) title(1 year growth forecast w time effects\label{tab9})