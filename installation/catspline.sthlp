{smcl}
{* 04Oct2024}{...}
{hi:help catspline}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-graphfunctions":graphfunctions (GitHub)}}

{hline}

{title:catspline}: A program for generating {browse "https://en.wikipedia.org/wiki/Centripetal_Catmull%E2%80%93Rom_spline":Catmull-Rom splines}.

The program inputs ({it:x, y}) numeric variables and outputs three variables ({it:_id, _x, _y}).
The {it:_id} variable represents the drawing sequence and {it:_x, _y} contains coordinates for pair-wise spline segments.


{marker syntax}{title:Syntax}

{p 8 15 2}
{cmd:catspline} {it:y x}, {cmd:[} {cmd:rho}({it:num [0,1]}) {cmd:n}({it:int}) {cmd:close} {cmdab:genx}({it:newvar}) {cmdab:geny}({it:newvar}) {cmd:]}


{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p2coldent : {opt catspline} y x}Input a coordinate pair.{p_end}

{p2coldent : {opt rho(num)}}Smoothing parameter bounded between 0 and 1. Default is {opt rho(0.5)}.{p_end}

{p2coldent : {opt n(int)}}Number of points to generate for each spline. Default is {opt n(40)}.{p_end}

{p2coldent : {opt close}}Close the loop between the starting and the ending points.{p_end}

{p2coldent : {opt genx(newvar)} {opt geny(newvar)}}Custom names for the generated {it:x,y} variables.
Defaults are {it: _x, _y}.{p_end}

{synoptline}
{p2colreset}{...}


{title:Examples}

Generate data:
{stata clear}
{stata set obs 5}
{stata set seed 2021}
{stata gen x = runiformint(1,5)}
{stata gen y = runiformint(1,5)}

Run the program:
{stata catspline y x, close rho(0.4)}

Plot the data:
{stata twoway (scatter y x) (line _y _x,  cmissing(n))}
	
More examples on {browse "https://github.com/asjadnaqvi/stata-graphfunctions":GitHub}.


{title:Package details}

Version      : {bf:catspline} v1.0 in {stata help graphfunctions:graphfunctions}
This release : 04 Oct 2024
First release: 04 Oct 2024
Repository   : {browse "https://github.com/asjadnaqvi/stata-graphfunctions":GitHub}
Keywords     : Stata, graph, splines, catmull rom function
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter/X    : {browse "https://x.com/AsjadNaqvi":@AsjadNaqvi}


{title:Feedback}

Please submit bugs, errors, feature requests on {browse "https://github.com/asjadnaqvi/stata-graphfunctions/issues":GitHub} by opening a new issue.


{title:Citation guidelines}

See {stata help graphfunctions:graphfunctions}.


{title:Other packages}

{psee}
    {helpb arcplot}, {helpb alluvial}, {helpb bimap}, {helpb bumparea}, {helpb bumpline}, {helpb circlebar}, {helpb circlepack}, {helpb clipgeo}, {helpb delaunay}, {helpb graphfunctions}, {helpb joyplot}, 
	{helpb marimekko}, {helpb polarspike}, {helpb sankey}, {helpb schemepack}, {helpb spider}, {helpb splinefit}, {helpb streamplot}, {helpb sunburst}, {helpb ternary}, {helpb treecluster}, {helpb treemap}, {helpb trimap}, {helpb waffle}

or visit {browse "https://github.com/asjadnaqvi":GitHub}.



