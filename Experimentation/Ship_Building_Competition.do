use "\\smb-isl01.fsu.edu\citrix\jm18f\Documents\Industrial_Leadership\Data\Original_Data\trade_Feenstra.dta", clear
edit
keep if sitc4==7930
sort year
by year: egen world_export = total (export_val)
encode origin, gen(country_id)
by world_export, sort: egen market_share = pc(export_val)
gsort year -market_share
keep if origin=="gbr" | origin=="jpn" | origin == "chn" | origin == "kor"
xtline market_share, t(year) i(origin) overlay 
*line market_share year if origin=="gbr"