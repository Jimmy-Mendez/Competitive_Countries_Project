use "\\smb-isl01.fsu.edu\citrix\jm18f\Documents\Industrial_Leadership\Data\Trade_Data_Clean.dta",clear
sort origin sitc4 year
encode origin, gen(country)
gen panelid = sitc4 * 254 + country
duplicates drop panelid year, force
xtset panelid year
**********************************************************
gen market_gain = market_share - L5.market_share
gen world_market_gain = world_market - L5.world_market
gsort -market_gain
gen int_marg = market_share * world_market_gain
gen ext_marg = market_gain * world_market
bysort sitc4 year: egen Mobility_Industry_ext = total(abs(market_gain))
bysort origin year: egen Mobility_Country_ext = total (abs(market_gain) * (industry_market_share / total_market_share))
bysort origin year: gen marketShareGain = abs(market_gain)
replace marketShareGain = 0 if market_gain <= 0
bysort origin year: gen marketShareLoss = abs(market_gain)
replace marketShareLoss = 0 if market_gain >= 0
bysort origin year: egen Competitive_Rise_Country = total(marketShareGain * (industry_market_share / total_market_share))
bysort origin year: egen Competitive_Decline_Country = total(marketShareLoss * (industry_market_share / total_market_share))

sort countryName year

merge countryName year using "\\smb-isl01.fsu.edu\citrix\jm18f\Documents\Industrial_Leadership\Data\Original_Data\World_Bank_Data.dta"

gen relative_share = export_val/Trade_Value
gen RCA = relative_share/industry_market_share

sort origin year

drop if missing(country)
drop _merge

save "\\smb-isl01.fsu.edu\citrix\jm18f\Documents\Industrial_Leadership\Data\Competitive_Indexes_and_GDP_5.dta", replace