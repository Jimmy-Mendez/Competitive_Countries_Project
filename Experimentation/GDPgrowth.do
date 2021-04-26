use "\\smb-isl01.fsu.edu\citrix\jm18f\Documents\Industrial_Leadership\Data\Competitive_Indexes_and_GDP_20.dta", clear
gen Competitive_Gain = Competitive_Rise_Country - Competitive_Decline_Country
bysort country year: keep if _n == 1
drop if year > 2017 
drop if year < 1972
gen gdp = GDP_US_Current
xtset country year 
sort country year
gen GDP_growth_last20 = (log(gdp / L20.gdp))/ 20
keep country countryName year GDP_growth_last20 Competitive_Rise_Country Competitive_Gain
keep if year == 2000
keep if countryName == "China" || countryName == "India" || countryName == "Mexico" || countryName == "South Korea" || countryName == "Australia" || countryName == "Spain" || countryName == "Brazil" || countryName == "Italy" || countryName == "Canada" || countryName == "France" || countryName == "United Kingdom" || countryName == "United States" || countryName == "Japan" || countryName == "Germany" 
gsort -Competitive_Rise