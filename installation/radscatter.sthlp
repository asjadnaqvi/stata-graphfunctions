{smcl}
{* 19Nov2025}{...}
{hi:help radscatter (v1.0): 19 Nov 2025}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-graphfunctions":graphfunctions (GitHub)}}

{hline}

{title:radscatter}: A program for radial scatter points. 


{marker syntax}{title:Syntax}

{p 8 15 2}
{cmd:radscatter} {opt [} {opt numvar} {opt ]} {ifin}, {opt [} {opt ro:tate(angle)} {opt rad:ius(num)} {opt flip} {opt dis:place(num)} {opt genx(str)} {opt geny(str)} {opt gena:ngle(var)} {opt genh:eight(var)} {opt replace} {opt ]}

{p 8 15 2}
If a numerical variable is specified after {cmd:radscatter}, then scatter heights will based on the values of the variable.
If scatter height is supposed to be fixed for all points then use the {opt if} or {opt in} options.

{synoptset 28 tabbed}{...}
{synopthdr}
{synoptline}
{p2coldent : {opt rad:ius(num)}}Radius determines the height of the points.{p_end}

{p2coldent : {opt ro:tate(angle)}}Rotate the points.{p_end}

{p2coldent : {opt flip}}Flip the draw order to clockwise.{p_end}

{p2coldent : {opt dis:place(num)}}Displace the scatter points by {it:num} pixels. This option is useful for finetuning scatter points for label positions.{p_end}

{p2coldent : {opt gena:ngle(str)}}Custom name for the {it:_rada} variable. The angle variable gives angle values
that can be used to plot labels rotated along the ray from the origin.{p_end}

{p2coldent : {opt genx(str)}, {opt geny(str)}}Custom names for the generated coordinates. Defaults are {it:_radx, _rady}.{p_end}

{p2coldent : {opt genid(str)}}Custom name for the {it:_radid} variable.{p_end}

{p2coldent : {opt genh:eight(str)}}Custom name for the {it:_radh} variable.{p_end}

{p2coldent : {opt replace}}Overwrite the generated variables if they exist.{p_end}

{synoptline}
{p2colreset}{...}


{title:Examples}

More examples on {browse "https://github.com/asjadnaqvi/stata-graphfunctions":GitHub}.


{title:Package details}

Version      : {bf:radscatter} v1.0 in {stata help graphfunctions:graphfunctions}
This release : 19 Nov 2025
First release: 19 Nov 2025
Repository   : {browse "https://github.com/asjadnaqvi/stata-graphfunctions":GitHub}
Keywords     : Stata, graph, arcs
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter/X    : {browse "https://x.com/AsjadNaqvi":@AsjadNaqvi}


{title:Feedback}

Please submit bugs, errors, feature requests on {browse "https://github.com/asjadnaqvi/stata-graphfunctions/issues":GitHub} by opening a new issue.


{title:Citation guidelines}

Visit {browse "https://ideas.repec.org/c/boc/bocode/s459379.html"} for the official SSC citation. 
Please note that the GitHub version might be newer than the SSC version.


{title:Other packages}

{psee}
    {helpb arcplot}, {helpb alluvial}, {helpb bimap}, {helpb bumparea}, {helpb bumpline}, {helpb circlebar}, {helpb circlepack}, {helpb clipgeo}, {helpb delaunay}, {helpb graphfunctions}, {helpb joyplot}, 
	{helpb marimekko}, {helpb polarspike}, {helpb sankey}, {helpb schemepack}, {helpb spider}, {helpb splinefit}, {helpb streamplot}, {helpb sunburst}, {helpb ternary}, {helpb treecluster}, {helpb treemap}, {helpb trimap}, {helpb waffle}

or visit {browse "https://github.com/asjadnaqvi":GitHub}.



