*! radscatter (v1.0) (18 Nov 2025)
*! Asjad Naqvi (asjadnaqvi@gmail.com)

* v1.0 (17 Nov 2025): first release. Mark points and generate angles for a circle.


**********************
***   radscatter   *** // radial scatter points 
**********************


capture program drop radscatter

program define radscatter

	version 11

    syntax [ varlist(max=1 default=none numeric) ] [if] [in], [ ROtate(real 0) RADius(numlist max=1 >=0) flip DISplace(real 0) labangle genid(string) genx(string) geny(string) GENAngle(string) GENHeight(string) replace]


	marksample touse, strok novarlist
	
	
    // Parse inputs

	local xvar 	_radx
	local yvar 	_rady
	local avar 	_rada
	local hvar 	_radh
	local idvar _radid

	if "`genid'" 		!= "" local idvar `genid'
	if "`genx'" 		!= "" local xvar  `genx'
	if "`geny'" 		!= "" local yvar  `geny'				
	if "`genangle'" 	!= "" local avar  `genangle'			
	if "`genheight'" 	!= "" local avar  `genheight'		

	
quietly {	
	
	if "`replace'" != "" {
		cap drop `idvar'
		cap drop `xvar'
		cap drop `yvar'
		cap drop `avar'
		cap drop `hvar'
	}	

	cap generate double `idvar' = .
	cap generate double `xvar' = .
	cap generate double `yvar' = .
	cap generate double `avar' = .
	cap generate double `hvar' = .
	

	replace `idvar' = _n if !missing(`varlist')
	

	if "`varlist'" != "" {    
		count if !missing(`varlist') & `touse'
		local items = `r(N)'
	}
	else {
		count if !missing(`idvar')
		local items = `r(N)'
	}


	local ro = (`rotate') * _pi / 180  	
	replace `avar' = ((`idvar' - 1) * 2 * _pi / `items') + `ro'  if `touse'

	if "`radius'" == "" local radius = 5
	
	// note displace is absolute and done after transformation to get consistent results. In percentage terms we get different displacements
	
	if "`varlist'" != "" {
		summ `varlist', meanonly
		replace `hvar' = (`radius' * (`varlist' / `r(max)')) + `displace'  if `touse'
	}
	else {
		replace `hvar' = (`radius' + `displace')  if `touse'
	}
	
	
	replace `xvar' = `hvar' * cos(`avar')	 if `touse'
	replace `yvar' = `hvar' * sin(`avar')	 if `touse'
	
	
	if "`labangle'" != "" { // ray angles from origin

		tempvar quad
		gen int `quad' = .  // quadrants
		replace `quad' = 1 if `xvar' >= 0 & `yvar' >= 0  & `touse'
		replace `quad' = 2 if `xvar' <  0 & `yvar' >= 0  & `touse'
		replace `quad' = 3 if `xvar' <  0 & `yvar' <  0  & `touse'
		replace `quad' = 4 if `xvar' >= 0 & `yvar' <  0  & `touse'
		

		cap gen double _labangle = .

		replace _labangle = (`avar'  * (180 / _pi)) - 180 if `avar' >  _pi   & `touse'
		replace _labangle = (`avar'  * (180 / _pi))  	  if `avar' <= _pi   & `touse'
		
		// correct rotations
		replace _labangle = (`avar'  * (180 / _pi))       if `quad'==4  	& `touse'
		replace _labangle = (`avar'  * (180 / _pi)) - 180 if `quad'==2  	& `touse'
	
	}
	
	
}
	
	*/
	
end	
