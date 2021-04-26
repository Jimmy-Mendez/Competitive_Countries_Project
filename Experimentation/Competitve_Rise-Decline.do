use "\\smb-isl01.fsu.edu\citrix\jm18f\Documents\Industrial_Leadership\Data\Competitve_Rise-Decline_2000.dta",clear
bysort origin: egen Mobility_Country = mean ((market_gain)^2) 
gen Competitive_Rise_Country = Mobility_Country_ext if market_gain > 0
replace Competitive_Rise_Country = 0 if market_gain <= 0
gen Competitive_Decline_Country = Mobility_Country_ext if market_gain < 0
replace Competitive_Decline_Country = 0 if market_gain >= 0
*Keeping only big economies
bysort origin: keep if _n ==1
gsort -world_market_share
keep in 1/20