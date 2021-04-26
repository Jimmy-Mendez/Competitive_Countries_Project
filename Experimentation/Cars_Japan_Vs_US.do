use "\\smb-isl01.fsu.edu\citrix\jm18f\Documents\Industrial_Leadership\trade_Feenstra.dta", clear
edit
drop if origin!="usa"&&origin!="jpn"
drop if sitc4!=7810
xtline export_rca, t(year) i(origin) overlay