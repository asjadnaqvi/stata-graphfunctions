{smcl}
{* 28Sep2024}{...}
{hi:help labsplit}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-graphfunctions":graphfunctions v1.0 (GitHub)}}

{hline}

{title:labsplit}: A program for text and word wrapping. 



{marker syntax}{title:Syntax}

{p 8 15 2}
{cmd:labsplit} {it:variable}, {cmd:[} {cmd:wrap}({it:int}) {cmd:word}({it:int}) {cmd:strict} {cmdab:gen:erate}({it:newvar}) {cmd:]}


{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p2coldent : {opt labsplit} variable}The command requires a string variable.{p_end}

{p2coldent : {opt wrap(int)}}Wrap after {it:int} characters. The program will repect word boundaries and will not cut them off
unless {opt strict} is specified.{p_end}

{p2coldent : {opt strict}}This option will chop off words defined by {opt wrap()} to maintain a strict text length per line.{p_end}

{p2coldent : {opt word(int)}}Wrap at the {it:int-th} word.{p_end}

{p2coldent : {opt gen:erate(newvar)}}Generate a new variable name with wrapped labels. If not specified, the program will 
save a new variable called {it:_labsplit}.{p_end}

{synoptline}
{p2colreset}{...}


{title:Examples}

See {browse "https://github.com/asjadnaqvi/stata-graphfunctions":GitHub}.


{title:Package details}

Version      : {bf:labsplit} v1.0 in {stata help graphfunctions:graphfunctions}
This release : 28 Sep 2024
First release: 28 Sep 2024
Repository   : {browse "https://github.com/asjadnaqvi/stata-graphfunctions":GitHub}
Keywords     : Stata, graph, label wrap, text wrap, word wrap
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



