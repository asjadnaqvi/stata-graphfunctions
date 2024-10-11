{smcl}
{* 11Oct2024}{...}
{hi:help shapes}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-graphfunctions":graphfunctions (GitHub)}}

{hline}

{title:shapes}: A program for generating shapes. 



{marker syntax}{title:Syntax}

Generic syntax:

{p 8 15 2}
{cmd:shapes} circle, {cmd:[} {cmd:n}({it:int}) {cmd:n}({it:int}) {cmdab:ro:tate}({it:degrees}) {cmdab:rad:ius}({it:num}) {cmdab:genx}({it:newvar}) {cmdab:geny}({it:newvar}) {cmd:replace} {cmd:]} 

Generates three variables {it:_id}, {it:_x}, {it:_y}.


{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p2coldent : {opt rad:ius(num)}}Specify the radius length. Default is {opt rad(10)}.{p_end}

{p2coldent : {opt n(int)}}Number of equi distant points in a circle. Default is {opt n(6)} which generate a hexagon. Option {opt n(4)} will yield a square.{p_end}

{p2coldent : {opt ro:tate(degrees)}}Rotate the shape by {it:degrees}. Default is {opt ro(0)}.{p_end}

{p2coldent : {opt genx(newvar)} {opt geny(newvar)}}Custom names for the generated coordinates. Defaults are {it: _x, _y}.{p_end}

{p2coldent : {opt replace}}Overwrite the generated variables if they exist. Use carefully.{p_end}

{synoptline}
{p2colreset}{...}


{title:Examples}

Generate data:
{stata shapes circle, n(8) ro(22.5) rad(8)}

{stata twoway (connected _y _x), xsize(1) ysize(1) aspect(1) xlabel(-10 10) ylabel(-10 10)}

More examples on {browse "https://github.com/asjadnaqvi/stata-graphfunctions":GitHub}.


{title:Package details}

Version      : {bf:shapes} v1.0 in {stata help graphfunctions:graphfunctions}
This release : 11 Oct 2024
First release: 11 Oct 2024
Repository   : {browse "https://github.com/asjadnaqvi/stata-graphfunctions":GitHub}
Keywords     : Stata, graph, shapes
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



