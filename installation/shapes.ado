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

 	syntax [,  n(real 6) ROtate(real 0) RADius(real 10) genx(string) geny(string) replace ]

	
quietly {	
	
	local xvar _x
	local yvar _y
	
	if "`genx'" != "" local xvar `genx'
	if "`geny'" != "" local yvar `geny'				
	
	if "`replace'" != "" {
		cap drop `xvar'
		cap drop `yvar'
		cap drop _id
	}		
	
	cap gen double `xvar' = .
	cap gen double `yvar' = .
	
	drop if missing(`xvar')
	
	
	if _N < `n' set obs `n'

	local rotate = `rotate' * _pi / 180  	
		
	tempvar _seq _angle
		
	gen `_seq' = _n in 1/`n'
	gen double `_angle' = (`_seq' * 2 * _pi / `n') + `rotate' in 1/`n'

	replace `xvar' = `radius' * cos(`_angle') in 1/`n'	 
	replace `yvar' = `radius' * sin(`_angle') in 1/`n'	

	expand 2 if `_seq'== 1
	set obs `=_N+1'  // pad a row in case more rows are added.
	gen _id = _n
	
	order _id
}


end






