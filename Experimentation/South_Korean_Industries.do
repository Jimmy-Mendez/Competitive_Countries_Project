use "\\smb-isl01.fsu.edu\citrix\jm18f\Documents\Industrial_Leadership\clean_Feenstra_data.dta",clear
edit
sort year
by year: egen world_annual_total = total (export_val)
bysort year sitc4: egen world_market = total (export_val)
keep if origin=="kor" 
by year: egen Trade_Value = total (export_val)
gen total_market_share = Trade_Value/world_annual_total
gen market_share = export_val/world_market
keep sitc4 year market_share world_market export_val sitc4name
keep if year== 1980 | year == 2000
sort sitc4
drop if sitc4 == 121| sitc4==111 | sitc4==541 | sitc4==582 | sitc4==583 | sitc4==585 | sitc4==612 | sitc4==711 | sitc4==722 | sitc4==723 | sitc4==752 | sitc4==812
reshape wide sitc4name market_share world_market export_val, i(sitc4) j(year) 
replace market_share1980 =0 if missing(market_share1980)
replace market_share2000 = 0 if missing(market_share2000)
gen market_gain = market_share2000-market_share1980
gsort -market_gain
bysort sitc4: gen Mobility = 1/_N * sum((market_gain)^2)
gsort -Mobility