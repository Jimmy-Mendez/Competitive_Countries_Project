use "\\smb-isl01.fsu.edu\citrix\jm18f\Documents\Industrial_Leadership\Trade_Data.dta",clear
*keep if origin == "gbr" || origin == "fra"
*keep if countryName == "Congo, the Democratic Republic of the"  || countryName == "Congo" 
*keep if countryName == "Nigeria" || countryName == "Uganda" || countryName == "Mozambique" || countryName == "Ethiopia" || countryName == "Congo, the Democratic Republic of the" 
*keep if countryName == "Singapore" || countryName == "China" || countryName == "Malaysia" || countryName == "Indonesia" 
*keep if countryName == "Mexico" || countryName == "El Salvador" || countryName == "Guatemala" || countryName == "Honduras" 
*keep if countryName == "India" || countryName == "Australia" || countryName == "Brazil"
*keep if origin == "fra" || origin == "gbr" || origin == "ita" || origin == "nld" || origin == "can"
keep if origin == "ind"
sort origin sitc4 year
encode origin, gen(country)
gen panelid = sitc4 * 254 + country
duplicates drop panelid year, force
xtset panelid year
**********************************************************
gen market_gain = market_share - L10.market_share
gen world_market_gain = world_market - L10.world_market
gsort -market_gain
gen int_marg = market_share * world_market_gain
gen ext_marg = market_gain * world_market
bysort sitc4: egen Mobility_Industry_ext = total(abs(market_gain))
bysort origin year: egen Mobility_Country_ext = total (abs(market_gain) * (industry_market_share / total_market_share))
bysort origin year: gen marketShareGain = abs(market_gain)
replace marketShareGain = 0 if market_gain <= 0
bysort origin year: gen marketShareLoss = abs(market_gain)
replace marketShareLoss = 0 if market_gain >= 0
bysort origin year: egen Competitive_Rise_Country = total(marketShareGain * (industry_market_share / total_market_share))
bysort origin year: egen Competitive_Decline_Country = total(marketShareLoss * (industry_market_share / total_market_share))
keep year sitc4 sitc4name marketShareGain marketShareLoss Competitive_Decline_Country Competitive_Rise_Country
bysort sitc4: egen aggregateGain = total(marketShareGain) 
bysort sitc4: egen aggregateLoss = total(marketShareLoss) 
by sitc4: keep if _n==1
gen aggregateNetGain = aggregateGain - aggregateLoss
keep sitc4 sitc4name aggregateGain aggregateLoss aggregateNetGain
gsort -aggregateNetGain
*drop if year < 1972
*xtline Competitive_Rise_Country, t(year) i(countryName) overlay