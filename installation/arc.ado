*! arc v1.0 (08 Oct 2024)
*! Asjad Naqvi (asjadnaqvi@gmail.com)

* v1.0 (08 Oct 2024): first release.


cap program drop arc

program define arc, rclass
 
	syntax, ///
		x1(numlist max=1) y1(numlist max=1) ///  //  from
		x2(numlist max=1) y2(numlist max=1) ///  //  to
		[ n(real 80) RADius(numlist max=1 >0) major swap ]	///
		[ genx(string) geny(string)	replace ]
	

    if `n' < 5 {
        display in red "The number of points n() must be greater than 5."
        exit
    }

	
	// mid points
    local xm = (`x1' + `x2') / 2
    local ym = (`y1' + `y2') / 2


    // slope
    local dx = `x2' - `x1'
    local dy = `y2' - `y1'
	local L = sqrt(`dx'^2 + `dy'^2)
    
    
    // radius
	if "`radius'" == "" {
		local radius = `L'   // radius = chord length 
		display in yellow "Radius of `radius' assumed."
	}
	
	

    // Check that radius is valid
    if `radius' <= `L'/2 {
		local mychord = `L' / 2
        di as error "Radius must be greater than half the chord length. Half chord length for given coordinates = `mychord'"
        exit
    }	
	
	return local chord `L'
	return local radius `radius'
	
    // Distance from midpoint to center
    local h_dist = sqrt(`radius'^2 - (`L'/2)^2)	
	
	
    // Determine the direction of the perpendicular bisector
    local ux_perp = -`dy' / `L'
    local uy_perp =  `dx' / `L'	
	
	local cross_prod = `dx' * `uy_perp' - `dy' * `ux_perp'
	
	// switch from left to right orientation
    if "`swap'" == "" {
        if `cross_prod' > 0 {
            local h = `xm' + `h_dist' * `ux_perp'
            local k = `ym' + `h_dist' * `uy_perp'
        }
        else {
            local h = `xm' - `h_dist' * `ux_perp'
            local k = `ym' - `h_dist' * `uy_perp'
        }
    }
	else {
        if `cross_prod' < 0 {
            local h = `xm' + `h_dist' * `ux_perp'
            local k = `ym' + `h_dist' * `uy_perp'
        }
        else {
            local h = `xm' - `h_dist' * `ux_perp'
            local k = `ym' - `h_dist' * `uy_perp'
        }
	}
	

   // get the angles in order
   local angle_start = atan2(`y1' - `k', `x1' - `h')
   local angle_end   = atan2(`y2' - `k', `x2' - `h')
	
    // bound angles between 0, 2pi
    if `angle_start' < 0	local angle_start = `angle_start' + 2 * _pi
    if `angle_end'   < 0	local angle_end   = `angle_end'   + 2 * _pi
    


	// minor (smaller arc) vs major (larger arc)
	
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
			if (`angle_end' - `angle_start') > _pi 	 local angle_end = `angle_end' - 2 * _pi
			if (`angle_end' - `angle_start') > 2 * _pi local angle_end = `angle_end' - 2 * _pi			

		}
		else {
			if (`angle_end' - `angle_start') < _pi 		local angle_end = `angle_end' + 2 * _pi	
			if (`angle_end' - `angle_start') > 2 * _pi 	local angle_end = `angle_end' - 2 * _pi
		}
	}
	

    // angle segments
    local delta_theta = (`angle_end' - `angle_start') / (`n' - 1)
    
    
	if _N < `n' set obs `n'
    
    // Calculate coordinates
    
	tempvar theta
	gen double `theta' = `angle_start' + (_n - 1) * `delta_theta'
	
	
	local xvar _x
	local yvar _y
	
	if "`genx'" != "" local xvar `genx'
	if "`geny'" != "" local yvar `geny'		
	
	if "`replace'" != "" {
		capture drop `xvar'
		capture drop `yvar'
	}
	
	gen double `xvar' = `h' + `radius' * cos(`theta')
	gen double `yvar' = `k' + `radius' * sin(`theta') 
	
    
	return local xcirc = `h'
	return local ycirc = `k'
	
end

