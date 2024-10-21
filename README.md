
![StataMin](https://img.shields.io/badge/stata-2011-blue) ![issues](https://img.shields.io/github/issues/asjadnaqvi/stata-graphfunctions) ![license](https://img.shields.io/github/license/asjadnaqvi/stata-graphfunctions) ![Stars](https://img.shields.io/github/stars/asjadnaqvi/stata-graphfunctions) ![version](https://img.shields.io/github/v/release/asjadnaqvi/stata-graphfunctions) ![release](https://img.shields.io/github/release-date/asjadnaqvi/stata-graphfunctions)

[Installation](#Installation) | [Examples](#Examples) | [Feedback](#Feedback) | [Change log](#Change-log)

---



# graphfunctions v1.4
*(15 Oct 2024)*

A suite of graph functions for Stata. The program is designed to be called by other programs, but it can be used as a standalone as well. The page will provide some minimum examples, but for the full scope, see the relevant help files.

Currently, this package contains:


|Program|Version|Updated|Description|
|----| ---- | ---- | ----- |
| [labsplit](#labsplit) | 1.1 | 08 Oct 2024 | Text wrapping |
| [catspline](#catspline) | 1.0 | 04 Oct 2024 | Catmull-Rom splines |
| [arc](#arc) | 1.1 | 11 Oct 2024 | Draw arcs between two points |
| [shapes](#shapes) | 1.2 | 15 Oct 2024 | Draw shapes: circle, pie, arc |


The programs here are designed/upgraded/bug-fixed on a needs basis, mostly to support other packages. If you have specific requests, or find major bugs, then please open an [issue](https://github.com/asjadnaqvi/stata-graphfunctions/issues).

## Installation

The package can be installed via SSC or GitHub. The GitHub version, *might* be more recent due to bug fixes, feature updates etc, and *may* contain syntax improvements and changes in *default* values. See version numbers below. Eventually the GitHub version is published on SSC.

SSC (**v1.4**):

```stata
ssc install graphfunctions, replace
```

GitHub (**v1.4**):

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

## Examples

### labsplit 
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

### catspline
*(v1.0: 04 Oct 2024)*


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


### arc
*(v1.1: 11 Oct 2024)*

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


### shapes
*(v1.2: 15 Oct 2024)*

**Circles**


Syntax: 
```stata
shape circle, [ n(int) rotate(degrees) radius(num) x0(num) y0(num) genx(newvar) geny(newvar) genorder(newvar) genid(newvar) replace stack ]
```


Examples:
```stata
shapes circle  // defaults: n = 6 points, radius = 10, rotation = 0

twoway (connected _y _x, mlabel(_id)) ///
		, xsize(1) ysize(1) aspect(1) xlabel(-10 10) ylabel(-10 10)
```

<img src="/figures/shapes1.png" width="75%">

```stata
shapes circle, rotate(30) replace

twoway (connected _y _x, mlabel(_id)) ///
		, xsize(1) ysize(1) aspect(1) xlabel(-10 10) ylabel(-10 10)
```

<img src="/figures/shapes2.png" width="75%">


```stata
shapes circle, rotate(45) rad(8) n(4) replace	

twoway (connected _y _x, mlabel(_id)) ///
		, xsize(1) ysize(1) aspect(1) xlabel(-10 10) ylabel(-10 10)
```

<img src="/figures/shapes3.png" width="75%">


```stata
shapes circle, n(100) replace	

twoway (connected _y _x, mlabel(_id)) ///
		, xsize(1) ysize(1) aspect(1) xlabel(-10 10) ylabel(-10 10)
```

<img src="/figures/shapes4.png" width="75%">


```stata
shapes circle, replace 
shapes circle, rotate(30) rad(8) stack 
shapes circle, rotate(30) n(4) rad(3)  x0(1) y0(1) stack 


twoway (connected _y _x, cmissing(n)), aspect(1)
```

<img src="/figures/shapes5.png" width="75%">

This can be used to generate a group of shapes.


**Pies**

Syntax:

```stata
shape pie, [ n(int) start(degrees) end(degrees) rotate(degrees) radius(num) x0(num) y0(num) genx(newvar) geny(newvar) genorder(newvar) genid(newvar) dropbase replace stack ]
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
shapes pie, start(0) end(250) rad(10) rotate(90) n(200) dropbase replace
shapes pie, start(0) end(230) rad(9)  rotate(90) n(200) dropbase stack
shapes pie, start(0) end(200) rad(8)  rotate(90) n(200) dropbase stack
shapes pie, start(0) end(180) rad(7)  rotate(90) n(200) dropbase stack
shapes pie, start(0) end(160) rad(6)  rotate(90) n(200) dropbase stack

twoway (line _y _x, cmissing(n) nodropbase)	///
	, xlabel(-10 10) ylabel(-10 10) xsize(1) ysize(1) aspect(1)
```

<img src="/figures/pie4.png" width="75%">

## Feedback

Please open an [issue](https://github.com/asjadnaqvi/stata-graphfunctions/issues) to report errors, feature enhancements, and/or other requests.


## Change log

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







