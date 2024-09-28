
![StataMin](https://img.shields.io/badge/stata-2011-blue) ![issues](https://img.shields.io/github/issues/asjadnaqvi/stata-graphfunctions) ![license](https://img.shields.io/github/license/asjadnaqvi/stata-graphfunctions) ![Stars](https://img.shields.io/github/stars/asjadnaqvi/stata-graphfunctions) ![version](https://img.shields.io/github/v/release/asjadnaqvi/stata-graphfunctions) ![release](https://img.shields.io/github/release-date/asjadnaqvi/stata-graphfunctions)

[Installation](#Installation) | [labsplit](#labsplit) | [Feedback](#Feedback) | [Change log](#Change-log)

---



# graphfunctions v1.0
*(28 Sep 2025)*

A suite of programs to help enhance figures in Stata. The program is designed to be called by other programs. But it can be used as a standalone as well. The page will provide some minimum examples but for the full scope of each program, see the help file.

## Installation

The package can be installed via SSC or GitHub. The GitHub version, *might* be more recent due to bug fixes, feature updates etc, and *may* contain syntax improvements and changes in *default* values. See version numbers below. Eventually the GitHub version is published on SSC.

SSC (**coming soon**):

```stata

```

GitHub (**v1.0**):

```stata
net install graphfunctions, from("https://raw.githubusercontent.com/asjadnaqvi/stata-graphfunctions/main/installation/") replace
```

See the help file `help graphfunctions` for details. Currently, this package contains:

```
|
|--- labsplit.ado
```


If you want to make a clean figure, then it is advisable to load a clean scheme. These are several available and I personally use the following:


Additional options used in the examples below:

```stata
ssc install schemepack, replace
set scheme white_tableau  
graph set window fontface "Arial Narrow"
```


## labsplit 
*(v1.0: 28 Sep 2024)*


Set up the data

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



## Feedback

Please open an [issue](https://github.com/asjadnaqvi/stata-graphfunctions/issues) to report errors, feature enhancements, and/or other requests.


## Change log


**v1.0 (28 Sep 2024)**
- Public release.
- `labsplit()` added.







