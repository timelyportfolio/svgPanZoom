### svgPanZoom - [htmlwidget](http://htmlwidgets.org) to Pan / Zoom R graphics

[![Build Status](https://travis-ci.org/timelyportfolio/svgPanZoom.png?branch=master)](https://travis-ci.org/timelyportfolio/svgPanZoom)

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

### Use It in Shiny

There are lots more examples below, but real quickly here is how we can use it in Shiny.

```R
library(shiny)
library(SVGAnnotation)
library(svgPanZoom)
library(ggplot2)

ui <- shinyUI(bootstrapPage(
  
  svgPanZoomOutput(outputId = "main_plot")
  
))

server = shinyServer(function(input, output) {
  output$main_plot <- renderSvgPanZoom({
    p <- ggplot() + geom_point(data=data.frame(faithful),aes(x=eruptions,y=waiting)) + stat_density2d(data=data.frame(faithful),aes(x=eruptions,y=waiting, alpha =..level..),geom="polygon") + scale_alpha_continuous(range=c(0.05,0.2))
    svgPanZoom(p, controlIconsEnabled = T)
  })
})
  
runApp(list(ui=ui,server=server))
```

### Use It With Grid and More

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

If ternary diagrams excite you, let's do this [USDA soil example](http://www.ggtern.com/2014/01/15/usda-textural-soil-classification/) from [`ggtern`](http://www.ggtern.com).

```
install.packages("ggtern")
library(ggtern)

# Load the required libraries
library(ggtern)
library(plyr)
library(grid)
 
# Load the Data. (Available in ggtern 1.0.3.0 next version)
data(USDA)
 
# Put tile labels at the midpoint of each tile.
USDA.LAB = ddply(USDA, 'Label', function(df) {
    apply(df[, 1:3], 2, mean)
})
 
# Tweak
USDA.LAB$Angle = 0
USDA.LAB$Angle[which(USDA.LAB$Label == 'Loamy Sand')] = -35

# Construct the plot.
gTern <- ggplot(data = USDA, aes(y=Clay, x=Sand, z=Silt,
                        color = Label,
                        fill = Label)) +
  coord_tern(L="x",T="y",R="z") +
  geom_polygon(alpha = 0.75, size = 0.5, color = 'black') +
  geom_text(data = USDA.LAB,
            aes(label = Label, angle = Angle),
            color = 'black',
            size = 3.5) +
  theme_rgbw() +
  theme_showsecondary() +
  theme_showarrows() +
  custom_percent("Percent") +
  theme(axis.tern.padding    = unit(0.15, 'npc')) +
  labs(title = 'USDA Textural Classification Chart',
       fill  = 'Textural Class',
       color = 'Textural Class')
       
svgPanZoom(gTern)
```


The true test for me though will be financial time series plots.  Will `svgPanZoom` pass the test?

```
library(svgPanZoom)
library(SVGAnnotation)
library(PerformanceAnalytics)

data(edhec)

svgPanZoom(
  svgPlot(
    charts.PerformanceSummary(
      edhec
      ,main = "Performance of EDHEC Indicies"
    )
  )
)

library(quantmod)
getSymbols("JPM", from = "2013-12-31")
svgPanZoom(
  svgPlot(
    chartSeries(JPM, theme = chartTheme('white'),
        multi.col=T,TA="addVo();addBBands();addCCI()")
    ,height = 7
    ,width = 12
  )
)
```


Tal Galili's [`dendextend`](https://github.com/talgalili/dendextend) offers another great use case for pan and zoom interaction.  Let's look at one of the examples from the package vignette.

```
# install.packages("dendextend")
library(dendextend)
library(SVGAnnotation)
library(svgPanZoom)

data(iris) 
d_iris <- dist(iris[,-5]) # method="man" # is a bit better
hc_iris <- hclust(d_iris)
dend_iris <- as.dendrogram(hc_iris)
iris_species <- rev(levels(iris[,5]))
dend_iris <- color_branches(dend_iris,k=3, groupLabels=iris_species)
# have the labels match the real classification of the flowers:
labels_colors(dend_iris) <-
   rainbow_hcl(3)[sort_levels_values(
      as.numeric(iris[,5])[order.dendrogram(dend_iris)]
   )]

# We'll add the flower type
labels(dend_iris) <- paste(as.character(iris[,5])[order.dendrogram(dend_iris)],
                           "(",labels(dend_iris),")", 
                           sep = "")

dend_iris <- hang.dendrogram(dend_iris,hang_height=0.1)

# reduce the size of the labels:
dend_iris <- assign_values_to_leaves_nodePar(dend_iris, 0.5, "lab.cex")

par(mar = c(3,3,3,7))
svgPlot(
  {
    plot(dend_iris, 
         main = "Clustered Iris dataset
         (the labels give the true flower species)", 
         horiz =  TRUE,  nodePar = list(cex = .007))
    legend("topleft", legend = iris_species, fill = rainbow_hcl(3))
  }
  , height = 12, width = 14
) %>% svgPanZoom
```

For what I consider the ultimate test, will it work with `HiveR`?

```
# from HiveR documentation ?plotHive 
library(HiveR)
library(grid)
library(SVGAnnotation)
library(svgPanZoom)

data(HEC)
svgPanZoom(
  svgPlot(
    {
      data(HEC)
      currDir = getwd()
      setwd(system.file("extdata", "Misc", package = "HiveR"))
      plotHive(HEC, ch = 0.1, bkgnd = "white",
               axLabs = c("hair\ncolor", "eye\ncolor"),
               axLab.pos = c(1, 1),
               axLab.gpar = gpar(fontsize = 14),
               anNodes = "HECnodes.txt",
               anNode.gpar = gpar(col = "black"),
               grInfo = "HECgraphics.txt",
               arrow = c("more\ncommon", 0.0, 2, 4, 1, -2))
      
      grid.text("males", x = 0, y = 2.3, default.units = "native")
      grid.text("females", x = 0, y = -2.3, default.units = "native")
      grid.text("Pairing of Eye Color with Hair Color", x = 0, y = 3.75,
                default.units = "native", gp = gpar(fontsize = 18))
      grid.text("A test of plotHive annotation options", x = 0, y = 3.25,
                default.units = "native", gp = gpar(fontsize = 12))
      grid.text("Images from Wikipedia Commons", x = 0, y = -3.5,
                default.units = "native", gp = gpar(fontsize = 9))
      setwd(currDir)
    }
  , height = 20
  , width = 30)
)
```
