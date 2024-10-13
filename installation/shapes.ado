*! shapes v1.1 (13 Oct 2024)
*! Asjad Naqvi (asjadnaqvi@gmail.com)

* v1.1 (13 Oct 2024): Fixed a bug where an existing _N was resulting in additional rows being added below. This version tracks indices much better.
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

 	syntax [, n(real 6) ROtate(real 0) RADius(real 10) genx(string) geny(string) genid(string) genorder(string) replace stack  ] // order noid

	
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

		cap generate double `xvar' = .
		cap generate double `yvar' = .
		cap generate double `idvar' = .
		cap generate double `ordervar' = .
	
	
	if "`stack'" != ""  {
		
		tempvar temp
		gen `temp' = _n if !missing(`idvar')
		summ `temp', meanonly
		
		if r(N)!= 0 {			
			local start = `=`r(max)' + 1'
			local end   = `=`r(max)' + `n' + 2'
			
			if _N < `=`r(max)'+`n'+2' set obs `end'
		}
		else {
			local start = 1
			local end = `=`n' + 2'
			if _N < `n' set obs `end'			
		}
		
	} 
	else {
		local start = 1
		local end = `=`n' + 2'
		if _N < `n' set obs `end'
	}
	
	summ `ordervar', meanonly
		
	if `r(N)'==0 {
		local k = 1
	}
	else {
		local k = `r(max)' + 1
	}
	
	summ `idvar', meanonly
	replace `ordervar' = `k' in  `start'/`end' 

		
	// generate the indices
	tempvar _temp _temp2 _seq _angle
	gen `_temp' = 1
	replace `idvar' = sum(`_temp') if `ordervar'==`k'	
	
	gen `_temp2' = _n
	
	
	summ `_temp2' if `ordervar'==`k', meanonly
	local end = `end' - 2
 
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







