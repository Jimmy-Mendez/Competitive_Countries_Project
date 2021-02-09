use "\\smb-isl01.fsu.edu\citrix\jm18f\Documents\Industrial_Leadership\Data\Industry_Data.dta", clear
sort year
by year: egen world_annual_total = total (export_val)
bysort year sitc4: egen world_market = total (export_val)
bysort year origin: egen Trade_Value = total (export_val)
gen total_market_share = Trade_Value/world_annual_total
gen market_share = export_val/world_market
gen industry_market_share = world_market/world_annual_total
save "\\smb-isl01.fsu.edu\citrix\jm18f\Documents\Industrial_Leadership\Data\Trade_Data.dta"