use "\\smb-isl01.fsu.edu\citrix\jm18f\Documents\Industrial_Leadership\trade_Feenstra.dta", clear
destring import_val, replace force
destring export_val, replace force
destring export_rca, replace force
edit
keep if sitc4==7810
sort year
by year: egen world_export = total (export_val)
encode origin, gen(country_id)
by world_export, sort: egen market_share = pc(export_val)
gsort year -market_share
keep if origin=="deu" | origin=="jpn" | origin == "chn" | origin == "kor"
xtline market_share, t(year) i(origin) overlay 