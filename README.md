
![StataMin](https://img.shields.io/badge/stata-2011-blue) ![issues](https://img.shields.io/github/issues/asjadnaqvi/stata-graphfunctions) ![license](https://img.shields.io/github/license/asjadnaqvi/stata-graphfunctions) ![Stars](https://img.shields.io/github/stars/asjadnaqvi/stata-graphfunctions) ![version](https://img.shields.io/github/v/release/asjadnaqvi/stata-graphfunctions) ![release](https://img.shields.io/github/release-date/asjadnaqvi/stata-graphfunctions)

[Installation](#Installation) | [Examples](#Examples) | [Feedback](#Feedback) | [Change log](#Change-log)

---



# graphfunctions v1.6
*(19 Nov 2025)*

A suite of graph functions for Stata. The program is designed to be called by other programs, but it can be used as a standalone as well. The page will provide some minimum examples, but for the full scope, see the relevant help files.

Currently, this package contains:


|Program|Version|Updated|Description|
|----| ---- | ---- | ----- |
| [shapes](#shapes) | 1.4 | 19 Nov 2025 | Contains `shapes circle`, `shapes pie`, `shapes square`, `shapes rotate`, `shapes area`, `shapes translate`, `shapes dilate`, `shapes stretch`, `shapes round` |
| [arc](#arc) | 1.3 | 19 Nov 2025 | Draw major and minor arcs between two points |
| [radscatter](#radscatter) | 1.0 | 19 Nov 2025 | Generate scatter points on arcs |
| [labsplit](#labsplit) | 1.1 | 08 Oct 2024 | Generic text wrapper |
| [catspline](#catspline) | 1.2 | 18 Feb 2025 | Catmull-Rom splines |



The programs here are designed/upgraded/bug-fixed on a needs basis, mostly to support other packages. If you have specific requests, or find major bugs, then please open an [issue](https://github.com/asjadnaqvi/stata-graphfunctions/issues).

## Installation

The package can be installed via SSC or GitHub. The GitHub version, *might* be more recent due to bug fixes, feature updates etc, and *may* contain syntax improvements and changes in *default* values. See version numbers below. Eventually the GitHub version is published on SSC.

SSC (**v1.52**):

```stata
ssc install graphfunctions, replace
```

GitHub (**v1.6**):

```stata
net install graphfunctions, from("https://raw.githubusercontent.com/asjadnaqvi/stata-graphfunctions/main/installation/") replace
```

See the help file `help graphfunctions` for details. 


If you want to make a clean figure, then it is advisable to load a clean scheme, especially if you are not using newer Stata versions. My own setting is the following:

```stata
ssc install schemepack, replace
set scheme white_tableau  
graph set window fontface "Arial Narrow"
```


## labsplit 
*(v1.1: 08 Oct 2024)*

The program allows users to split text labels based on flexible or fixed character length or word positions.

Syntax:
```stata
labsplit variable, [ wrap(int) word(int) strict generate(newvar) ]
```

Examples:

```stata
clear
set obs 5
gen x = 1
gen y = _n

gen mylab = ""

replace mylab = "Test this really-hyphenated label." in 1
replace mylab = "Yet another label to test." in 2
replace mylab = "This is the third label" in 3
replace mylab = "How about we test this label as well" in 4
replace mylab = "Finally we are at the fifth label" in 5

```

Let's test the `labsplit` command:

```stata
labsplit mylab, wrap(10) gen(newlab1)
labsplit mylab, wrap(10) gen(newlab2) strict
labsplit mylab, word(2) gen(newlab3)
```

Code for figures:

```
twoway (scatter y x, mlabel(mylab)   mlabsize(3)), title("Standard")
twoway (scatter y x, mlabel(newlab1) mlabsize(3)), title("Wrapping")

twoway (scatter y x, mlabel(newlab2) mlabsize(3)), title("Wrapping strict") 
twoway (scatter y x, mlabel(newlab3) mlabsize(3)), title("Word wrap")
```

<img src="/figures/labsplit0.png" width="50%"><img src="/figures/labsplit1.png" width="50%">
<img src="/figures/labsplit2.png" width="50%"><img src="/figures/labsplit3.png" width="50%">

## catspline
*(v1.2: 18 Feb 2025)*


The program allows users to generate splines based on the [Catmull-Rom algorithm](https://en.wikipedia.org/wiki/Centripetal_Catmull%E2%80%93Rom_spline).

Syntax:
```stata
catspline y x, [ rho(num [0,1]) obs(int) close genx(newvar) geny(newvar) ]
```

Examples:

```stata
clear
set obs 5
set seed 2021

gen x = runiformint(1,5)
gen y = runiformint(1,5)


catspline y x

twoway ///
	(scatter y x) ///
	(line _y _x,  cmissing(n))
```

<img src="/figures/catspline1.png" width="75%">

```stata
cap drop _id _x _y
catspline y x, close 

twoway ///
	(scatter y x) ///
	(line _y _x,  cmissing(n))
```

<img src="/figures/catspline2.png" width="75%">


## arc
*(v1.3: 19 Nov 2025)*

Draw minor or major arcs between two points. The arc orientation and be switched using `swap`, and major arcs can be drawn using `major`.

Syntax:

```stata
arc, x1(num) y1(num) x2(num) y2(num) [ radius(num) n(int) swap major genx(newvar) geny(newvar) replace ]
```

Examples:


```stata
arc, y1(-2) x1(-4) y2(4) x2(2) rad(6) replace

twoway ///
	(scatteri -2 -4)  (scatteri 4 2) ///
	(scatteri `r(ycirc)' `r(xcirc)') ///
	(line _y _x)  ///
	, legend(order(1 "Point 1" 2 "Point 2" 3 "Circumcenter" 4 "Arc") pos(6) row(1)) ///
	xlabel(-10(2)10) ylabel(-10(2)10) aspect(1) xsize(1) ysize(1) ///
	title("Right of starting point - minor")
```

<img src="/figures/arc1.png" width="75%">

```stata
arc, y1(-2) x1(-4) y2(4) x2(2) rad(6) major replace		

twoway ///
	(scatteri -2 -4)  (scatteri 4 2) ///
	(scatteri `r(ycirc)' `r(xcirc)') ///
	(line _y _x)  ///
	, legend(order(1 "Point 1" 2 "Point 2" 3 "Circumcenter" 4 "Arc") pos(6) row(1)) ///
	xlabel(-10(2)10) ylabel(-10(2)10) aspect(1) xsize(1) ysize(1) ///
	title("Right of starting point - major")	
	
```

<img src="/figures/arc2.png" width="75%">

```stata
arc, y1(-2) x1(-4) y2(4) x2(2) rad(6) swap replace		

twoway ///
	(scatteri -2 -4)  (scatteri 4 2) ///
	(scatteri `r(ycirc)' `r(xcirc)') ///
	(line _y _x)  ///
	, legend(order(1 "Point 1" 2 "Point 2" 3 "Circumcenter" 4 "Arc") pos(6) row(1)) ///
	xlabel(-10(2)10) ylabel(-10(2)10) aspect(1) xsize(1) ysize(1) ///
	title("Left of starting point - minor")
```

<img src="/figures/arc3.png" width="75%">

```stata
arc, y1(-2) x1(-4) y2(4) x2(2) rad(6) swap major replace

twoway ///
	(scatteri -2 -4)  (scatteri 4 2) ///
	(scatteri `r(ycirc)' `r(xcirc)') ///
	(line _y _x)  ///
	, legend(order(1 "Point 1" 2 "Point 2" 3 "Circumcenter" 4 "Arc") pos(6) row(1)) ///
	xlabel(-10(2)10) ylabel(-10(2)10) aspect(1) xsize(1) ysize(1) ///
	title("Left of starting point - Major")
```

<img src="/figures/arc4.png" width="75%">


## shapes
*(v1.4: 19 Nov 2025)*

### shapes circle


Syntax: 
```stata
shapes circle, radius(num) [ x0(num) y0(num) n(int) rotate(degrees) genx(var) geny(var) genid(var) genorder(var) replace append ]
```


Examples:
```stata
shapes circle, replace

twoway /// 
		(connected _y _x, mlabel(_order)) ///
		, xsize(1) ysize(1) aspect(1)	///
		xlabel(-10 10) ylabel(-10 10)
```

<img src="/figures/circle1.png" width="75%">

```stata
shapes circle, n(6) replace


twoway /// 
		(connected _y _x, mlabel(_order)) ///
		, xsize(1) ysize(1) aspect(1)	///
		xlabel(-10 10) ylabel(-10 10)
```

<img src="/figures/circle2.png" width="75%">


```stata
shapes circle, n(6) rotate(30) replace

twoway /// 
		(connected _y _x, mlabel(_order)) ///
		, xsize(1) ysize(1) aspect(1)	///
		xlabel(-10 10) ylabel(-10 10)
```

<img src="/figures/circle3.png" width="75%">


```stata
shapes circle, rotate(45) rad(8) n(4) replace		

twoway /// 
		(connected _y _x, mlabel(_order)) ///
		, xsize(1) ysize(1) aspect(1)	///
		xlabel(-10 10) ylabel(-10 10)
```

<img src="/figures/circle4.png" width="75%">


```stata
shapes circle, n(100) replace	

twoway /// 
		(line _y _x) ///
		, xsize(1) ysize(1) aspect(1)	///
		xlabel(-10 10) ylabel(-10 10)
```

<img src="/figures/circle5.png" width="75%">


```stata
shapes circle,    	      n(8) replace
shapes circle, rotate(30) n(6) rad(8) append 
shapes circle, rotate(60) n(4) rad(3)  x0(1) y0(1) append

twoway (connected _y _x, cmissing(n)), aspect(1)
```

<img src="/figures/circle6.png" width="75%">

### shapes pie

Syntax:

```stata
shapes pie, radius(num) end(degrees) [ start(degrees) x0(num) y0(num) n(int) rotate(degrees) dropbase flip genx(var) geny(var) genid(var) genorder(var) replace append ]
```

Examples:
```stata
shapes pie, end(60) replace

twoway (area _y _x), xlabel(-10 10) ylabel(-10 10) xsize(1) ysize(1) aspect(1)
```

<img src="/figures/pie1.png" width="75%">


```stata
shapes pie, start(0) end(270) n(200) replace

twoway (area _y _x), xlabel(-10 10) ylabel(-10 10) xsize(1) ysize(1) aspect(1)
```

<img src="/figures/pie2.png" width="75%">

```stata
clear
shapes pie, start(0) end(45) ro(0)		rad(5) 	replace
shapes pie, start(0) end(45) ro(30) 	rad(6)  stack
shapes pie, start(0) end(45) ro(60) 	rad(7)  stack
shapes pie, start(0) end(45) ro(90) 	rad(8)  stack
shapes pie, start(0) end(45) ro(120) 	rad(9)  stack
shapes pie, start(0) end(45) ro(150) 	rad(10) stack


twoway (area _y _x, fcolor(%90) cmissing(n) nodropbase)	///
	, xlabel(-10 10) ylabel(-10 10) xsize(1) ysize(1) aspect(1)
```

<img src="/figures/pie3.png" width="75%">


without base:

```stata
shapes pie, start(0) end(230) rad(10) rotate(90) n(200) dropbase replace
shapes pie, start(0) end(230) rad(9)  rotate(90) n(200) dropbase append
shapes pie, start(0) end(200) rad(8)  rotate(90) n(200) dropbase append
shapes pie, start(0) end(180) rad(7)  rotate(90) n(200) dropbase append
shapes pie, start(0) end(160) rad(6)  rotate(90) n(200) dropbase append

twoway (line _y _x, cmissing(n) nodropbase)	///
	, xlabel(-10 10) ylabel(-10 10) xsize(1) ysize(1) aspect(1)
```

<img src="/figures/pie4.png" width="75%">

without base flipped direction:

```stata
shapes pie, start(0) end(350) rad(10) rotate(90) n(200) dropbase flip replace
shapes pie, start(0) end(150) rad(9)  rotate(90) n(200) dropbase flip append
shapes pie, start(0) end(130) rad(8)  rotate(90) n(200) dropbase flip append
shapes pie, start(0) end(80) rad(7)  rotate(90) n(200) dropbase flip append
shapes pie, start(0) end(60) rad(6)  rotate(90) n(200) dropbase flip append

twoway (line _y _x, cmissing(n) nodropbase)	///
	, xlabel(-10 10) ylabel(-10 10) xsize(1) ysize(1) aspect(1)
```

<img src="/figures/pie5.png" width="75%">


### shapes square

Syntax:

```stata
shapes square, [ length(num) x0(num) y0(num) rotate(degrees) genx(var) geny(var) genid(var) genorder(var) replace append ]
```

Examples:

```stata
shapes square, len(8) rotate(90) replace

twoway ///
	(area _y _x, nodropbase fcolor(%50))	///
	(scatter _y _x, mlab(_order))	///
		, ///
		legend(off) ///
		xlabel(-10(2)10) ylabel(-10(2)10) xsize(1) ysize(1) aspect(1)
```

<img src="/figures/square1.png" width="75%">


```stata
shapes square, x0(1) y0(1) len(10) rotate(40) replace
shapes square, x0(1) y0(1) len(9) rotate(30) append
shapes square, x0(1) y0(1) len(8) rotate(20) append
shapes square, x0(1) y0(1) len(7) rotate(10) append
shapes square, x0(1) y0(1) len(6) rotate(0)  append		


twoway ///
	(area _y _x, cmissing(n) nodropbase fcolor(%100) lw(0.1) lc(white))	///
		, ///
		legend(off) ///
		xlabel(-10(2)10) ylabel(-10(2)10) xsize(1) ysize(1) aspect(1)
```		

<img src="/figures/square2.png" width="75%">


### shapes translate

Syntax:

```stata
shapes translate <yvar> <xvar> [if] [in], [ x(num) y(num) genx(var) geny(var) replace ]
```

### shapes dilate

Syntax:

```stata
shapes dilate <yvar> <xvar> [if] [in], [ factor(num) genx(var) geny(var) replace ]
```


### shapes stretch

Syntax:

```stata
shapes stretch <yvar> <xvar> [if] [in], [ x(num) y(num) replace ]
```


### shapes rotate

Syntax:

```stata
shapes rotate <yvar> <xvar> [if] [in], [ rotate(degrees) x0(num) y0(num) center genx(var) geny(var) replace ]
```


Let's generate a basic shape:

```stata
shapes square, x0( 5) y0(0) len(5) replace
shapes square, x0(-5) y0(0) len(5) append

twoway ///
	(area _y _x, cmissing(n) nodropbase fcolor(%80) lw(0.1) lc(white))	///
	(scatteri 0 0) ///
		, ///
		legend(off) ///
		xlabel(-10(2)10) ylabel(-10(2)10) xsize(1) ysize(1) aspect(1)	
```

<img src="/figures/rotate1.png" width="75%">



```stata
shapes rotate _y _x, rotate(30)


twoway ///
	(area _y _x, cmissing(n) nodropbase fcolor(%80) lw(0.1) lc(white))	///
	(area ynew  xnew, cmissing(n) nodropbase fcolor(%80) lw(0.1) lc(white))	///
	(scatteri 0 0) ///
		, ///
		legend(off) ///
		xlabel(-10(2)10) ylabel(-10(2)10) xsize(1) ysize(1) aspect(1)	
```

<img src="/figures/rotate2.png" width="75%">


```stata
shapes rotate _y _x, rotate(30) x0(5) y0(5) genx(xnew) geny(ynew)

twoway ///
	(area _y _x, cmissing(n) nodropbase fcolor(%80) lw(0.1) lc(white))	///
	(area ynew  xnew, cmissing(n) nodropbase fcolor(%80) lw(0.1) lc(white))	///
	(scatteri 0 0) ///
		, ///
		legend(off) ///
		xlabel(-10(2)10) ylabel(-10(2)10) xsize(1) ysize(1) aspect(1)	
```

<img src="/figures/rotate2_1.png" width="75%">


```stata
shapes rotate _y _x, rotate(60) center genx(xnew2) geny(ynew2)		

twoway ///
	(area _y _x, cmissing(n) nodropbase fcolor(%80) lw(0.1) lc(white))	///
	(area ynew2  xnew2, cmissing(n) nodropbase fcolor(%80) lw(0.1) lc(white))	///
	(scatteri 0 0) ///
		, ///
		legend(off) ///
		xlabel(-10(2)10) ylabel(-10(2)10) xsize(1) ysize(1) aspect(1)	
```

<img src="/figures/rotate3.png" width="75%">


```stata
shapes rotate _y _x, rotate(30) center by(_id) genx(xnew3) geny(ynew3)			
	
twoway ///
	(area _y _x, cmissing(n) nodropbase fcolor(%80) lw(0.1) lc(white))	///
	(area ynew3  xnew3, cmissing(n) nodropbase fcolor(%80) lw(0.1) lc(white))	///
	(scatteri 0 0) ///
		, ///
		legend(off) ///
		xlabel(-10(2)10) ylabel(-10(2)10) xsize(1) ysize(1) aspect(1)
```

<img src="/figures/rotate4.png" width="75%">


### shapes round

Syntax:

```stata
shapes round <yvar> <xvar> [if] [in], roundness(num) [ n(num) factor(num) genx(var) geny(var) genid(var) genorder(var) gensegvar(var) replace append ]
```


### shapes area

Syntax:

```stata
shapes area <yvar> <xvar>, [ {opt by(var} generate(var) replace ]
```

Examples:
```stata
clear
shapes pie, start(0) end(45) ro(0)		rad(5) 	replace
shapes pie, start(0) end(45) ro(30) 	rad(6)  stack
shapes pie, start(0) end(45) ro(60) 	rad(7)  stack
shapes pie, start(0) end(45) ro(90) 	rad(8)  stack
shapes pie, start(0) end(45) ro(120) 	rad(9)  stack
shapes pie, start(0) end(45) ro(150) 	rad(10) stack


twoway (area _y _x, fcolor(%90) cmissing(n) nodropbase)	///
	, xlabel(-10 10) ylabel(-10 10) xsize(1) ysize(1) aspect(1)
```

<img src="/figures/area1.png" width="75%">


calculate the areas

```stata
shapes area _y _x, by(_id) 
```

Generate some ranking of areas and plot


```stata
xtile grps = _area, n(4)	

levelsof _id, local(lvls)

foreach x of local lvls {
	colorpalette reds, nograph
	local myarea `myarea' (area _y _x if _id==`x', fcolor("`r(p`x')'%90") lc("`r(p`x')'") cmissing(n) nodropbase)	
}



twoway ///
	`myarea'	///
	, ///
		xlabel(-10 10) ylabel(-10 10) ///
		legend(off) ///
		xsize(1) ysize(1) aspect(1)
```


<img src="/figures/area2.png" width="75%">

## radscatter
*(v1.0: 19 Nov 2025)*

Syntax:

```stata
radscatter [ numvar ] [if] [in], [ rotate(angle) radius(num) flip displace(num) genx(str) geny(str) genangle(var) genheight(var) replace ]

```



## Feedback

Please open an [issue](https://github.com/asjadnaqvi/stata-graphfunctions/issues) to report errors, feature enhancements, and/or other requests.


## Change log


**v1.6 (19 Nov 2025)**
- `shapes` updated to v1.4 to include better options for `shapes square`, `shapes pie`, `shapes cirle`, and `shapes rotate`. New commands include `shapes translate`, `shapes dilate`, `shapes stretch`, `shapes round`.
- `arc` updated with better options. `dropbase` added to ensure continuity across stacked arcs.
- New command `radscatter` added.
- Major rehaul of base routines, various bug fixes, better scripts that stack variables.


**v1.52 (18 Feb 2025)**
- `catspline` now generate the stated number of points.
- `catspline` now respects `if/in` conditions.
- Minor corrections and bug fixes.

**v1.51 (28 Nov 2024)**
- Fixed `catspline` to correct generate splines. Added options to replace variables. Change in routine to make it more efficient in computations.
- Added `replace`, `append` to `arc`. Various bug fixes.
- Added `append` as a substitute for `stack` in `shapes`. 
- Added `square` in `shapes.

**v1.5 (05 Nov 2024)**
- `shapes square` added for squares. Note that `shapes circle, n(4)` also returns a square but here we define the center-to-corner length using the radius, where as `shapes square` generates a side with a predefined length. Hence the area of `shapes circle, n(4) rad(5)` > `shapes square, len(5)`.
- `shapes rotate` added for generation rotations at specific points or center of shapes. Note that this is a more advanced rotation than what each individual function provides.
- `shapes area` added for calculating the areas (currently in undefined units) using [Meister's shoelace formula](https://en.wikipedia.org/wiki/Shoelace_formula). 
- Option `append` added as a substitute for `stack`. This is more in line with standard Stata syntax.
- Option `flip` added to change the drawing direction. This flips from counter-clockwise (Stata default) to clockwise.
- Better information added for rotations, orientations, and starting points.
- Cleanup of helpfiles.

**v1.4 (15 Oct 2024)**
- `shapes` is now also mirrored as `shape`.
- `shape circle` updated, and `shape pie` added.
- In `shapes`, users can now also define an origin using `x0()` and `y0()` options.
- More controls and checks.

**v1.3 (13 Oct 2024)**
- `shapes` added. Minor fixes to index tracking.
- `arc` bug fixes plus code cleanup.

**v1.2 (08 Oct 2024)**
- `arc` added.
- Bug fixes in `labsplit`.
- Additional checks in programs.

**v1.1 (04 Oct 2024)**
- `catspline` added.

**v1.0 (28 Sep 2024)**
- `labsplit` added.
- Public release.







