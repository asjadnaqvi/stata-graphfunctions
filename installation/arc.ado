*! arc v1.3 (18 Nov 2025)
*! Asjad Naqvi (asjadnaqvi@gmail.com)

* v1.3 (18 Nov 2025): dropbase added. clean ups
* v1.2 (20 Nov 2024): append/stack added
* v1.1 (11 Oct 2024): Minor bug fixes.
* v1.0 (08 Oct 2024): first release.


cap program drop arc

program define arc, rclass sortpreserve
 
version 11
 
	syntax, ///
		x1(numlist max=1) y1(numlist max=1) ///  //  from
		x2(numlist max=1) y2(numlist max=1) ///  //  to
		[ n(real 40) RADius(numlist max=1 >0) major swap ]	///
		[ genx(string) geny(string) genid(string) genorder(string) ] ///
		[ replace append stack dropbase ]
	

    if `n' < 5 {
        display in red "The number of points n() must be greater or equal to 5."
        exit
    }

	
*quietly {	
	
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
	
	
	// observations to add
	if "`dropbase'" != "" {
		local base = `n'		
	}
	else {
		local base = `n' + 1
	}	
	

	
	if "`stack'" != "" | "`append'" !="" {
		
		tempvar temp
		gen `temp' = _n if !missing(`idvar')
		
		summ `temp', meanonly
		
			
		if r(N)!= 0 {			
			local start = `r(max)' + 1
			local end   = `r(max)' + `base'
			
			
			if _N < `end' set obs `end'
		}
		else {
			local start = 1
			local end 	= `base'
			if _N < `n' set obs `end'			
		}
		
	} 
	else {
		local start = 1
		local end 	= `base'
		if _N < `n' set obs `end'
	}	
	
	// last point for estimation = base if dropbase specified
	local last = `start' + `n' - 1
	
	*noisily di "Base = `base', Last = `last', Start = `start', End = `end'"
	
	
	summ `idvar', meanonly
		
	if `r(N)'==0 {
		local k = 1
	}
	else {
		local k = `r(max)' + 1
	}	
	
	*noi di "Arc: start = `start', end = `end'"
	
	// id
	*summ `ordervar', meanonly
	replace `idvar' = `k' in  `start'/`end' 
	
	// order
	tempvar _temp _temp2 _seq _angle
	gen `_temp' = 1
	replace `ordervar' = sum(`_temp') if `idvar'==`k'		
	
	**** core routines below ****
	
	// mid points
    local xm = (`x1' + `x2') / 2
    local ym = (`y1' + `y2') / 2

    // slope
    local dx = `x2' - `x1'
    local dy = `y2' - `y1'
	local L = sqrt(abs(`dx')^2 + abs(`dy')^2) // check why this square is not working without abs()
    
	*noisily display "`dx', `dy', `L'"
    
    // radius
	if "`radius'" == "" {
		local radius = `L'   // radius = chord length 
		display in yellow "Radius of `radius' assumed."
	}
	
    // validate the radius
    if `radius' <= `L'/2 {
		local mychord = `L' / 2
        di as error "Radius must be greater than half the chord length. Half chord length for given coordinates = `mychord'"
        exit
    }	

    // distance from midpoint to center
    local h_dist = sqrt(`radius'^2 - (`L'/2)^2)	
	
	
    // direction of the perpendicular bisector
    local ux_perp = -`dy' / `L'
    local uy_perp =  `dx' / `L'	
	
	local cross_prod = `dx' * `uy_perp' - `dy' * `ux_perp'
	
	// swap left to right orientation
    if "`swap'" == "" {
		local h = `xm' + `h_dist' * `ux_perp'
		local k = `ym' + `h_dist' * `uy_perp'
	}
	else {
		local h = `xm' - `h_dist' * `ux_perp'
		local k = `ym' - `h_dist' * `uy_perp'
	}

	
   // get the angles in order
   local angle_start = atan2(`y1' - `k', `x1' - `h')
   local angle_end   = atan2(`y2' - `k', `x2' - `h')
	
    // bound angles between 0, 2pi
    if `angle_start' < 0	local angle_start = `angle_start' + 2 * _pi
    if `angle_end'   < 0	local angle_end   = `angle_end'   + 2 * _pi
    

	// correct for minor vs major arc
	
	if "`swap'"!= ""  {
		if "`major'" != "" {
			if (`angle_end' - `angle_start') < _pi local angle_end = `angle_end' + 2 * _pi
		}
		else {
			if (`angle_end' - `angle_start') > _pi local angle_end = `angle_end' - 2 * _pi
		}		
	}
	else {
		if "`major'" != "" {
			if (`angle_end' - `angle_start') > _pi 	local angle_end = `angle_end' - 2 * _pi
		}
		else {
			if (`angle_end' - `angle_start') < _pi 	local angle_end = `angle_end' + 2 * _pi	
		}
		if (`angle_end' - `angle_start') > 2 * _pi 	local angle_end = `angle_end' - 2 * _pi		
	}

    local delta_theta = (`angle_end' - `angle_start') / (`n' - 1)
    
	if _N < `n' set obs `n'
	
	tempvar theta
	gen double `theta' = `angle_start' + (`ordervar' - 1) * `delta_theta' in `start'/`last'

	
	replace `xvar' = `h' + `radius' * cos(`theta') in  `start'/`last'
	replace `yvar' = `k' + `radius' * sin(`theta') in  `start'/`last'		

*}		
		
	*if "`dropbase'" != "" drop if `xvar'==.	
		
	return local chord  = `L'
	return local radius = `radius'
	return local xcirc  = `h'
	return local ycirc  = `k'
	
end

