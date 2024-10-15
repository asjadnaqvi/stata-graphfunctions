*! shapes v1.2 (15 Oct 2024)
*! Asjad Naqvi (asjadnaqvi@gmail.com)

* v1.2 (15 Oct 2024): added support for generating pies. added x0,y0 to control center points.
* v1.1 (13 Oct 2024): Fixed a bug where an existing _N was resulting in additional rows being added below. This version tracks indices much better.
* v1.0 (11 Oct 2024): first release.


cap program drop shapes

program define shapes
 
version 11
	gettoken left 0: 0, parse(", ")

	if "`left'" == "circle" {
		_circle `0'
	}
	
	if "`left'" == "pie" {
		_pie `0'
	}	
	
end



program define _circle 
 version 11

 	syntax [, x0(real 0) y0(real 0) n(real 6) ROtate(real 0) RADius(real 10) genx(string) geny(string) genid(string) genorder(string) replace stack  ] // order noid

	
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
		cap generate `idvar' = .
		cap generate `ordervar' = .
	
	
	if "`stack'" != ""  {
		
		tempvar temp
		gen `temp' = _n if !missing(`ordervar')
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
	
	summ `idvar', meanonly
		
	if `r(N)'==0 {
		local k = 1
	}
	else {
		local k = `r(max)' + 1
	}
	
	summ `ordervar', meanonly
	replace `idvar' = `k' in  `start'/`end' 

		
	// generate the indices
	tempvar _temp _temp2 _seq _angle
	gen `_temp' = 1
	replace `ordervar' = sum(`_temp') if `idvar'==`k'	
	
	gen `_temp2' = _n
	
	
	summ `_temp2' if `idvar'==`k', meanonly
	local end = `end' - 2
 
	// add shape
	local rotate = `rotate' * _pi / 180  	
		
	gen double `_angle' = (`ordervar' * 2 * _pi / `n') + `rotate' in `start'/`end'

	replace `xvar' = `x0' + `radius' * cos(`_angle') in  `start'/`end' 
	replace `yvar' = `y0' + `radius' * sin(`_angle') in  `start'/`end'	


	// duplicate first row to complete the shape
	summ `xvar' in `start', meanonly
	replace `xvar' = `r(min)' in `=`end' + 1'

	summ `yvar' in `start', meanonly
	replace `yvar' = `r(min)' in `=`end' + 1'
	

	*/
	
}


end



program define _pie
 version 11
 
    syntax, [ x0(real 0) y0(real 0) RADius(real 10) start(real 0) end(real 30) n(real 30) ROtate(real 0) ] ///
			[ genx(string) geny(string) genid(string) genorder(string) replace stack  ]

    
	// prepare the variables
	local xvar _x
	local yvar _y
	local idvar _id
	local ordervar _order
	
	if `n' < 2 {
		display as error "n() should be greater or equal to 2."
		exit
	}
	
	if "`genx'" 	!= "" local xvar 	 `genx'
	if "`geny'" 	!= "" local yvar 	 `geny'				
	if "`genid'" 	!= "" local idvar 	 `genid'				
	if "`genorder'" != "" local ordervar `genorder'		
	
quietly {	
	
	if "`replace'" != "" {
		cap drop `xvar'
		cap drop `yvar'
		cap drop `idvar'
		cap drop `ordervar'
	}	
	
	cap generate double `xvar' = .
	cap generate double `yvar' = .
	cap generate `idvar' = .
	cap generate `ordervar' = .
	
	
	// Calculate the range of angles from the starting angle to the ending angle in radians
    
    local theta_start = (`start' + `rotate') * _pi / 180
    local theta_end   = (`end'   + `rotate') * _pi / 180
	
	
	if "`stack'" != ""  {
		
		tempvar temp
		gen `temp' = _n if !missing(`ordervar')
		summ `temp', meanonly
		
		if r(N)!= 0 {			
			local start = `=`r(max)' + 1'
			local end   = `=`r(max)' + `n' + 4'
			
			if _N < `=`r(max)'+`n'+4' set obs `end'
		}
		else {
			local start = 1
			local end = `=`n' + 4'
			if _N < `n' set obs `end'			
		}
		
	} 
	else {
		local start = 1
		local end = `=`n' + 4'
		if _N < `n' set obs `end'
	}
	
	summ `idvar', meanonly
		
	if `r(N)'==0 {
		local k = 1
	}
	else {
		local k = `r(max)' + 1
	}
	
	replace `idvar' = `k' in  `start'/`end' 	
	
	
	// generate the indices
	tempvar _temp _temp2 _seq _angle
	gen `_temp' = 1
	replace `ordervar' = sum(`_temp') if `idvar'==`k'	
	
	gen `_temp2' = _n	
	
	summ `_temp2' if `idvar'==`k', meanonly
	local end = `end' - 3
	
	tempvar theta
	gen double `theta' = `theta_start' + ((`ordervar'-1) /`n') * (`theta_end' - `theta_start')  in `start'/`end'

	// Calculate the x and y coordinates for this angle
	replace `xvar' = `x0' + `radius' * cos(`theta')  in `start'/`end'
	replace `yvar' = `y0' + `radius' * sin(`theta')  in `start'/`end'
		
	// pad the centers
	replace `xvar' = `x0' in `=`end'+1'
	replace `yvar' = `y0' in `=`end'+1'
	
	
	// pad the starting value
	sum `xvar' if `ordervar'==1 & `idvar'==`k', meanonly
	replace `xvar' = `r(min)' in `=`end'+2'
		
	sum `yvar' if `ordervar'==1 & `idvar'==`k', meanonly
	replace `yvar' = `r(min)' in `=`end'+2'
		
		*/

}
		
end



