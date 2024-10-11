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

 	syntax [,  n(real 6) ROtate(real 0) RADius(real 10) ]

	
quietly {	
	if _N < `n' set obs `n'

		local rotate = `rotate' * _pi / 180  	
		
		tempvar _seq _angle
		
		gen `_seq' = _n
		gen double `_angle' = (`_seq' * 2 * _pi / `n') + `rotate'

		gen double _x = `radius' * cos(`_angle')	
		gen double _y = `radius' * sin(`_angle')	


	expand 2 if `_seq'== 1
	set obs `=_N+1'  // pad a row in case more rows are added.
	gen _id = _n
	
	order _id
}


end






