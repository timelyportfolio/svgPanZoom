#' Pan and Zoom R graphics
#'
#' Add panning and zooming to almost any R graphics and
#' hopefully and eventually other htmlwidgets.
#'
#' @import htmlwidgets
#'
#' @export
svgPanZoom <- function(svg, ... , width = NULL, height = NULL) {

  # check to see if trellis for lattice or ggplot
  if(inherits(svg,c("trellis","ggplot"))){
    # if class is trellis then plot then use grid.export
    # try to use gridSVG if available
    if(require("gridSVG")) {
      show(svg)
      svg = grid.export(name=NULL)$svg
    } else {  #use SVGAnnotation
      if(require(SVGAnnotation)){
        warning("for best results with ggplot2 and lattice, please install gridSVG")
        svg = svgPlot(svg, addInfo = F)
      } else { # if
        stop("SVGAnnotation or gridSVG required with lattice or trellis objects")
      }
    }
  }

  # check to see if svg is XML and saveXML if so
  if(inherits(svg,c("XMLAbstractDocument","XMLAbstractNode"))){
    # should we add check for svg element?
    svg = XML::saveXML(svg)
  }

  # use SVG file if provided
  # thanks @jjallaire for code from https://github.com/rich-iannone/DiagrammeR
  # to use file or connection
  if ( inherits(svg, "connection") || ( class(svg) == "character" && file.exists(svg) ) ){
    # might want to parse to insure validity
    svg <- readLines(diagram, warn = FALSE)
  }


  # forward options using x
  x = list(
    svg = svg
    ,config = list(...)
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'svgPanZoom',
    x,
    width = width,
    height = height,
    package = 'svgPanZoom'
  )
}

#' Widget output function for use in Shiny
#'
#' @export
svgPanZoomOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'svgPanZoom', width, height, package = 'svgPanZoom')
}

#' Widget render function for use in Shiny
#'
#' @export
renderSvgPanZoom <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, svgPanZoomOutput, env, quoted = TRUE)
}
