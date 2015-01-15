#' Pan and Zoom R graphics
#'
#' Add panning and zooming to almost any R graphics and
#' hopefully and eventually other htmlwidgets.
#'
#' @param svg one of
#' \itemize{
#'   \item svg - SVG as XML, such as return from \code{\link[SVGAnnotation]{svgPlot}}
#'   \item lattice plot - trellis object, such as \code{l} in \code{l=xyplot(...)}
#'   \item ggplot2 plot - ggplot object, such as \code{g} in \code{g=ggplot(...) + geom_line()}
#'   \item filename or connection of a SVG file
#' }
#' @param ... other configuration options for svg-pan-zoom.js.
#' See \href{How to Use}{https://github.com/ariutta/svg-pan-zoom#how-to-use}.
#' These should be entered like \code{svgPanZoom( svg, controlIconsEnabled = F )}.
#'
#' @examples
#' library(svgPanZoom)
#'
#' # first let's demonstrate a base plot
#' # use svgPlot for now
#' library(SVGAnnotation)
#' svgPanZoom( svgPlot( plot(1:10) ) )
#'
#' svgPanZoom( svgPlot(show( xyplot( y~x, data.frame(x=1:10,y=1:10) ) ) )
#'
#' # the package gridSVG is highly recommended for lattice and ggplot2
#' # second let's demonstrate a lattice plot
#' library(lattice)
#' svgPanZoom( xyplot( y~x, data.frame(x=1:10,y=1:10) ) )
#'
#' # third with a ggplot2 plot
#' library(ggplot2)
#' svgPanZoom( ggplot( data.frame(x=1:10,y=1:10), aes(x=x,y=y) ) + geom_line() )
#'
#' @import htmlwidgets
#'
#' @export
svgPanZoom <- function(svg, ... , width = NULL, height = NULL, elementId = NULL) {

  # check to see if trellis for lattice or ggplot
  if(inherits(svg,c("trellis","ggplot","ggmultiplot"))){
    # if class is trellis then plot then use grid.export
    # try to use gridSVG if available
    if (requireNamespace("gridSVG", quietly = TRUE)) {
      show(svg)
      svg = gridSVG::grid.export(name=NULL)$svg
    } else {  #use SVGAnnotation
      if(requireNamespace("SVGAnnotation", quietly = TRUE)){
        warning("for best results with ggplot2 and lattice, please install gridSVG")
        svg = svgPlot(svg, addInfo = F)
      } else { # if
        stop(
          "SVGAnnotation or gridSVG required with lattice or trellis objects",
           call. = FALSE
        )
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
    svg <- readLines(svg, warn = FALSE)
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
    package = 'svgPanZoom',
    elementId = elementId
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
