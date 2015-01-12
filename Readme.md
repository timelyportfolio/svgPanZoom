### svgPanZoom - [htmlwidget](http://htmlwidgets.org) to Pan / Zoom R graphics

**Note:  this is very early alpha and highly experimental**

`svgPanZoom` is a [`htmlwidgets`](http://htmlwidgets.org) wrapper for [`svg-pan-zoom.js`](https://github.com/ariutta/svg-pan-zoom).  `svgPanZoom` gives `R` users an easy way to add panning and zooming to any `R` graphics (base, ggplot2, lattice, and lots more).

### Install It
For now (not on CRAN) to get started, you will need to use `devtools::install_github` as shown below.  If you do not have `devtools`, please install with `install.packages("devtools")`.

```
devtools::install_github("timelyportfolio/svgPanZoom")
```

### Use It
As stated in the introduction `svgPanZoom` works with almost all `R` graphics types.  For `base` graphics, we'll need the `svgAnnotation` package.

```
library(svgPanZoom) # see install step above
library(svgAnnotation)

svgPanZoom(
  svgPlot(
    plot(1:10)
  )
)
```
