*! shapes v1.3 (05 Nov 2024)
*! Asjad Naqvi (asjadnaqvi@gmail.com)

* v1.3 (05 Nov 2024): add append as sub for stack. Added square.
* v1.2 (15 Oct 2024): added support for generating pies. added x0,y0 to control center points.
* v1.1 (13 Oct 2024): Fixed a bug where an existing _N was resulting in additional rows being added below. This version tracks indices much better.
* v1.0 (11 Oct 2024): first release.


cap program drop shapes

program define shapes
 
version 11
	gettoken subcmd 0: 0, parse(", ")

	// draw
	if "`subcmd'" == "circle" 	_circle `0'
	if "`subcmd'" == "pie" 		_pie 	`0'
	if "`subcmd'" == "square" 	_square `0'
	
	// modify
	if "`subcmd'" == "rotate" 	_rotate `0'
	
	// generate
	if "`subcmd'" == "area" 	_area `0'			
	
end

**************
*** circle ***
**************

program define _circle 
 version 11

 	syntax [, x0(real 0) y0(real 0) n(real 100) ROtate(real 0) RADius(real 10) genx(string) geny(string) genid(string) genorder(string) replace stack append  ] 

	
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
	
	
	if "`stack'" != "" | "`append'" !="" {
		
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
	
	
}


end



**************
***   pie  ***
**************

program define _pie
 version 11
 
    syntax, [ x0(real 0) y0(real 0) RADius(real 10) start(real 0) end(real 30) n(real 30) ROtate(real 0) ] ///
			[ genx(string) geny(string) genid(string) genorder(string) replace stack dropbase append flip  ]

    
	// prepare the variables
	local xvar _x
	local yvar _y
	local idvar _id
	local ordervar _order
	
	if `n' < 2 {
		display as error "n() should be greater or equal to 2."
		exit
	}
	
	if "`replace'" != "" {
		cap drop `xvar'
		cap drop `yvar'
		cap drop `idvar'
		cap drop `ordervar'
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
	
	
	if "`flip'" != "" local end = `end' * -1
	
	// Calculate the range of angles from the starting angle to the ending angle in radians
    
    local theta_start = (`start' + `rotate') * _pi / 180
    local theta_end   = (`end'   + `rotate') * _pi / 180
	
	
	if "`stack'" != ""  | "`append'" !=""  {
		
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
		
	
	if "`dropbase'" == "" {
		// pad the centers
		replace `xvar' = `x0' in `=`end'+1'
		replace `yvar' = `y0' in `=`end'+1'
		
		
		// pad the starting value
		sum `xvar' if `ordervar'==1 & `idvar'==`k', meanonly
		replace `xvar' = `r(min)' in `=`end'+2'
			
		sum `yvar' if `ordervar'==1 & `idvar'==`k', meanonly
		replace `yvar' = `r(min)' in `=`end'+2'
	}
}
		
end


*****************
***   square  ***
*****************


program define _square
 version 11

     syntax, [ x0(real 0) y0(real 0) LENgth(real 10) ROtate(real 0) ] ///
			[ genx(string) geny(string) genid(string) genorder(string) replace stack append flip  ]
 
 
 	// prepare the variables
	local xvar _x
	local yvar _y
	local idvar _id
	local ordervar _order
	local n = 4

quietly {	
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
	
	if "`stack'" != ""  | "`append'" !=""  {
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
	
	replace `idvar' = `k' in  `start'/`end' 		
	
	tempvar _temp
	gen `_temp' = 1
	replace `ordervar' = sum(`_temp') if `idvar'==`k'		
	
	
	// add the coordinates
	replace `xvar' = ( `length' / 2) in `start'
	replace `yvar' = ( `length' / 2) in `start'
	
	replace `xvar' = (-`length' / 2) in `=`start' + 1'
	replace `yvar' = ( `length' / 2) in `=`start' + 1'
 
	replace `xvar' = (-`length' / 2) in `=`start' + 2'
	replace `yvar' = (-`length' / 2) in `=`start' + 2' 
	
	replace `xvar' = ( `length' / 2) in `=`start' + 3'
	replace `yvar' = (-`length' / 2) in `=`start' + 3' 	
	
	replace `xvar' = ( `length' / 2) in `=`start' + 4' // duplicate of the first row
	replace `yvar' = ( `length' / 2) in `=`start' + 4' 		
	
	// rotation
	
	tempvar _mymod _angle
	
	gen `_mymod' = mod(`ordervar', 4)	// index
	recode `_mymod' (0=4)
		
	local rotate = (-45 + `rotate') * _pi / 180  	// compensate for square shape
	gen double `_angle' = (`_mymod' * 2 * _pi / `n') + `rotate' in `start'/`end'	
	
	local _radius = sqrt(2) * `length' / 2
	
	replace `xvar' = `x0' + `_radius' * cos(`_angle')  in `start'/`=`start' + 4'
	replace `yvar' = `y0' + `_radius' * sin(`_angle')  in `start'/`=`start' + 4'	
	
 
}
end 



cap program drop _rotate

program _rotate, sortpreserve

version 11
	
	syntax varlist(numeric min=2 max=2),  [ ROtate(real 0) by(varname) x0(real 0) y0(real 0) replace genx(string) geny(string) center ] 
 
	tokenize `varlist'
	local vary `1'
	local varx `2'
	
quietly {

	if "`center'" != "" {
		if "`by'" == "" {
			summ `varx', meanonly
			local x0 = (`r(min)' + `r(max)') / 2

			summ `vary', meanonly
			local y0 = (`r(min)' + `r(max)') / 2
		}
		else {
			tempvar _meanx _meany _minx _miny _maxx _maxy
			sort `by' _id _order
			
			by `by': egen `_minx' = min(`varx')
			by `by': egen `_miny' = min(`vary')
			
			by `by': egen `_maxx' = max(`varx')
			by `by': egen `_maxy' = max(`vary')
			
			gen double `_meanx' = (`_minx' + `_maxx') / 2
			gen double `_meany' = (`_miny' + `_maxy') / 2

		}
	
	}
	

	local angle = `rotate' * _pi / 180

    
	local xvar _x_rot // default names
	local yvar _y_rot	
	
	if "`genx'" 	!= "" local xvar  `genx'
	if "`geny'" 	!= "" local yvar  `geny'				

	
	tempvar _x0 _y0 x_rot_t y_rot_t
	
	if "`by'" != "" {  // by() defined
		local x0 `_meanx'
		local y0 `_meany'
	}
	
		
	gen double `_x0' = `varx' - `x0'
	gen double `_y0' = `vary' - `y0'
		
	gen double `x_rot_t' = `_x0' * cos(`angle') - `_y0' * sin(`angle')
	gen double `y_rot_t' = `_x0' * sin(`angle') + `_y0' * cos(`angle')
		
	if "`replace'" != "" {  // here replace is replacing the original variables. use carefully.
		replace `varx' = `x_rot_t' + `x0' 
		replace `vary' = `y_rot_t' + `y0' 
	}
	else {
		cap drop `xvar'
		cap drop `yvar'
		
		generate `xvar' = `x_rot_t' + `x0' 
		generate `yvar' = `y_rot_t' + `y0'
	}
	

}	
	
end



cap program drop _area

program _area, sortpreserve


// apply the Meister's shoelace formula (shoelace formula: https://en.wikipedia.org/wiki/Shoelace_formula)

version 11
	syntax varlist(numeric min=2 max=2), by(varname) [ replace GENerate(string) ] 
	
	tokenize `varlist'
	local y `1'
	local x `2'	
	
quietly {	
	local myvar _area
	
	if "`generate'" != "" local myvar `generate'
	if "`replace'"  != "" capture drop `myvar'
			
	tempvar _values
	
	bysort `by': gen double `_values' = ((`y' * `x'[_n+1]) - (`y'[_n+1] * `x')) /2
	bysort `by': replace    `_values' = ((`y' * `x'[2])    - (`y'[2]    * `x')) /2 if `_values'!=.
	
	bysort `by': egen double `myvar' = sum(`_values')
}
	
end

*********************************
******** END OF PROGRAM *********
*********************************







