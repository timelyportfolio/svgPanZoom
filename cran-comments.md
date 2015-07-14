## Resubmission
This is a resubmission. In this version I have:

* Converted the DESCRIPTION title to title case - htmlwidget now is Htmlwidget

* Changed to MIT + file License to follow MIT template exactly, but I do not know how to handle
    the BSD license for the component JavaScript svg-pan-zoom.js.  For now, I have included a copy of
    its license within the inst/htmlwidgets/lib/svg-pan-zoom directory and also
    included BSD in the Authors section.  I saw in some of the RStudio
    htmlwidgets more explanation of other licenses but in this case was not a MIT license.  Another 
    version that does not follow the template is https://github.com/timelyportfolio/svgPanZoom/blob/dbfb21142e83b93b7e7cca9775f1a9c6dec22c6d/LICENSE.
    


## Test environments
* local Windows install, R 3.1.2
* ubuntu (on travis-ci), R 3.2.1
* win-builder (devel and release)

## R CMD check results
There were no ERRORs or WARNINGs.

There were 2 notes:

* checking CRAN incoming feasibility ... NOTE

Yes this is a new submission

* checking package dependencies ... NOTE
  
No repository set, so cyclic dependency check skipped
