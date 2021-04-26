use "\\smb-isl01.fsu.edu\citrix\jm18f\Documents\Industrial_Leadership\Data\Industry_Data.dta", clear
sort year
by year: egen world_annual_total = total (export_val)
bysort year sitc4: egen world_market = total (export_val)
bysort year origin: egen Trade_Value = total (export_val)
gen total_market_share = Trade_Value/world_annual_total
gen market_share = export_val/world_market
keep if year== 1980 | year == 2000
sort origin sitc4 year
encode origin, gen(country)
gen panelid = sitc4 * 254 + country
duplicates drop panelid year, force
xtset panelid year
gen market_gain = market_share - L20.market_share if year == 2000
gen world_market_gain = world_market - L20.world_market if year == 2000
keep if year == 2000
gsort -market_gain
order origin sitc4 sitc4name market_share market_gain
keep if world_market>1.0+10
gen int_marg = market_share * world_market_gain
gen ext_marg = market_gain * world_market
bysort sitc4: egen Mobility_Industry_ext = total(abs(market_gain))
gen industry_market_share = world_market/world_annual_total
bysort origin: egen Mobility_Country_ext = total (abs(market_gain) * (industry_market_share / total_market_share))
bysort origin: gen marketShareGain = abs(market_gain)
replace marketShareGain = 0 if market_gain <= 0
bysort origin: gen marketShareLoss = abs(market_gain)
replace marketShareLoss = 0 if market_gain >= 0
bysort origin: egen Competitive_Rise_Country = total(marketShareGain * (industry_market_share / total_market_share))
bysort origin: egen Competitive_Decline_Country = total(marketShareLoss * (industry_market_share / total_market_share))
*Keeping only big economies
bysort origin: keep if _n ==1
gsort -total_market_share
keep in 1/20