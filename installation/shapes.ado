*! shapes v1.0 (11 Oct 2024)
*! Asjad Naqvi (asjadnaqvi@gmail.com)

* v1.0 (11 Oct 2024): first release.


cap program drop shapes

program define shapes
 
version 11
	gettoken left 0: 0, parse(", ")

	if "`left'" == "circle" {
		_circle `0'
	}
	
end



program define _circle 
 version 11

 	syntax [,  n(real 6) ROtate(real 0) RADius(real 10) genx(string) geny(string) genid(string) genorder(string) replace stack  ] // order noid

	
quietly {	
	
	
	// prepare the variables
	local xvar _x
	local yvar _y
	local idvar _id
	local ordervar _order
	
	if "`genx'" 	!= "" local xvar 	 `genx'
	if "`geny'" 	!= "" local yvar 	 `geny'				
	if "`genid'" 	!= "" local idvar 	 `genid'				
	if "`genorder'" != "" local ordervar `genorder'				
	
	if "`replace'" != "" {
		cap drop `xvar'
		cap drop `yvar'
		cap drop `idvar'
		cap drop `ordervar'
	}		
	

	if "`stack'" != "" {
		set obs `=_N+`n'+2'
	} 
	else {
		if _N < `n' set obs `=`n'+2'
	}
	

	capture confirm variable `ordervar'
	if _rc!=0 { 
		local k = 1
		gen `ordervar' = 1
	}
	else { 
	 	summ `ordervar', meanonly
		local k = `r(max)' + 1
		replace `ordervar' = `k' if missing(`ordervar')
	}	

		
	capture confirm variable `idvar'
	if _rc!=0 gen `idvar' = _n
		
	cap gen double `xvar' = .
	cap gen double `yvar' = .
			
		
	// generate the indices
	tempvar _temp _temp2 _seq _angle
	gen `_temp' = 1
	replace `idvar' = sum(`_temp') if `ordervar'==`k'	
	
	gen `_temp2' = _n
	summ `_temp2' if `ordervar'==`k', meanonly
	
	local start = 	`r(min)'
	local end = 	`r(max)' - 2
 
	// add shape
	local rotate = `rotate' * _pi / 180  	
		

	gen double `_angle' = (`idvar' * 2 * _pi / `n') + `rotate' in `start'/`end'

	replace `xvar' = `radius' * cos(`_angle') in  `start'/`end' 
	replace `yvar' = `radius' * sin(`_angle') in  `start'/`end'	


	// duplicate first row to complete the shape
	summ `xvar' in `start', meanonly
	replace `xvar' = `r(min)' in `=`end' + 1'

	summ `yvar' in `start', meanonly
	replace `yvar' = `r(min)' in `=`end' + 1'
	

	*/
	
}


end







