### svgPanZoom - [htmlwidget](http://htmlwidgets.org) to Pan / Zoom R graphics

**Note:  this is very early alpha and highly experimental**

`svgPanZoom` is a [`htmlwidgets`](http://htmlwidgets.org) wrapper for [`svg-pan-zoom.js`](https://github.com/ariutta/svg-pan-zoom).  `svgPanZoom` gives `R` users an easy way to add panning and zooming to any `R` graphics (base, ggplot2, lattice, and lots more).  It prioritizes ease and simplicity, but does offer some ability to tailor the experience and enhance the interactivity.

### Install It
For now (`svgPanZoom` not on CRAN) to get started, you will need to use `devtools::install_github` as shown below.  If you do not have `devtools`, please install with `install.packages("devtools")`.

```
devtools::install_github("timelyportfolio/svgPanZoom")
```

### Use It
As stated in the introduction `svgPanZoom` works with almost all `R` graphics types.  For `base` graphics, we'll need the `SVGAnnotation` package.

```
library(svgPanZoom) # see install step above
library(SVGAnnotation)

svgPanZoom(
  svgPlot(
    plot(1:10)
  )
)
```

Although `SVGAnnotation` works with `grid` graphics, such as `ggplot2` and `lattice`, we will **need to change the default** `addInfo` to `addInfo = F`.  Before I show an example though, I **highly recommend** using `gridSVG` for `ggplot2` and `lattice`.  For some good reasons, please see [this](http://stattech.wordpress.fos.auckland.ac.nz/2013-4-generating-structured-and-labelled-svg/) from Paul Murrell and Simon Potter.  If you are making big graphics--think maps, multiple graphs, etc.--for **speed stick with `svgPlot`**. Here is a simple example using `ggplot2` with `SVGAnnotation` and `svgPlot`.

```
library(svgPanZoom)
library(SVGAnnotation)
library(ggplot2)

svgPanZoom(
  svgPlot(
    #will put on separate line but also need show
    show(
      ggplot(data.frame(x=1:10,y=1:10),aes(x=x,y=y)) + geom_line()

    )
    # this is critical with svgPlot and grid graphics
    , addInfo = F
  )
)
```

Now let's do that same plot with `gridSVG`.

```
svgPanZoom(
  ggplot(data.frame(x=1:10,y=1:10),aes(x=x,y=y)) + geom_line()
)
```

You might notice right off that sizing is better handled, but more importantly, the resulting `SVG` is much better structured `XML`.  That small time lag will really start to hurt if you are using `gridSVG` with large or complicated graphics.  So if speed is important, ignore the better structure from `gridSVG` and stick with `svgPlot`.

As promised, `lattice` (yes, I still use it and like it) works just as nicely.

```
library(svgPanZoom)
library(SVGAnnotation)
library(lattice)
 
# with gridSVG
svgPanZoom(
  xyplot( y~x, data.frame(x=1:10,y=1:10), type = "b" )
)

# with svgPlot
svgPanZoom(
  svgPlot(
    show(xyplot( y~x, data.frame(x=1:10,y=1:10), type = "b" ))
    , height = 6
    , width = 10
  )
)
```

If you are not impressed yet, then maybe the graphics were not compelling enough.  Let's add `svgPanZoom` to some more complicated visualizations.

```
library(choroplethr)
# from chorplethr documetation
data(df_pop_state)
m = state_choropleth(
  df_pop_state
  , title="US 2012 State Population Estimates"
  , legend="Population"
)
# take a peek
m
# would be so much more fun with pan and zoom
svgPanZoom( m )
# if your map is big and hairy do this instead
svgPanZoom(
  svgPlot(
    show(m )
    # will have to manually size the svg device
    , height = 10, width = 16 )
)

```

How about using [`ggfortify`](https://github.com/sinhrks/ggfortify)?  Here are some great [examples](http://rpubs.com/sinhrks).  Let's make some pan and zoom.

```
# devtools::install_github('sinhrks/ggfortify')
library(ggfortify)
svgPanZoom(
  autoplot(lm(Petal.Width ~ Petal.Length, data = iris))
)

library(survival)
svgPanZoom(
  autoplot(survfit(Surv(time, status) ~ sex, data = lung))
)
```