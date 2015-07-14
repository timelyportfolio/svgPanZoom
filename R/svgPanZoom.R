#' Pan and Zoom R graphics
#'
#' Add panning and zooming to almost any R graphics from base graphics,
#'    lattice, and ggplot2 by using the JavaScript library
#'     \href{https://github.com/ariutta/svg-pan-zoom}{svg-pan-zoom}.
#'
#' @param svg one of
#' \itemize{
#'   \item svg - SVG as XML, such as return from \code{\link[SVGAnnotation]{svgPlot}}
#'   \item lattice plot - trellis object, such as \code{l} in \code{l=xyplot(...)}
#'   \item ggplot2 plot - ggplot object, such as \code{g} in \code{g=ggplot(...) + geom_line()}
#'   \item filename or connection of a SVG file
#' }
#' @param ... other configuration options for svg-pan-zoom.js.
#'           See \href{https://github.com/ariutta/svg-pan-zoom#how-to-use}{svg-pan-zoom How To Use}
#'           for a full description of the options available.  As an example to turn on
#'           \code{controlIconsEnabled} and turn ,
#'           do \code{svgPanZoom( ..., controlIconsEnabled = TRUE, panEnabled = FALSE )}.
#' @param width,height valid CSS unit (like "100%", "400px", "auto") or a number,
#'           which will be coerced to a string and have "px" appended
#' @param elementId \code{string} id for the \code{svgPanZoom} container.  Since \code{svgPanZoom}
#'           does not display its container, this is very unlikely to be anything other than the
#'           default \code{NULL}.
#' See \href{How to Use}{https://github.com/ariutta/svg-pan-zoom#how-to-use}.
#' These should be entered like \code{svgPanZoom( svg, controlIconsEnabled = F )}.
#'
#' @examples
#' \dontrun{
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
#' #Of course as a good htmlwidget should, it works with Shiny also.
#' library(shiny)
#' library(SVGAnnotation)
#' library(svgPanZoom)
#' library(ggplot2)
#'
#' ui <- shinyUI(bootstrapPage(
#'   svgPanZoomOutput(outputId = "main_plot")
#' ))
#'
#' server = shinyServer(function(input, output) {
#'   output$main_plot <- renderSvgPanZoom({
#'     p <- ggplot() +
#'      geom_point(
#'        data=data.frame(faithful),aes(x=eruptions,y=waiting)
#'      ) +
#'      stat_density2d(
#'        data=data.frame(faithful)
#'        ,aes(x=eruptions,y=waiting ,alpha =..level..)
#'        ,geom="polygon") +
#'      scale_alpha_continuous(range=c(0.05,0.2))
#'
#'      svgPanZoom(p, controlIconsEnabled = T)
#'   })
#' })
#'
#' runApp(list(ui=ui,server=server))
#' }
#'
#' @export
svgPanZoom <- function(svg, ... , width = NULL, height = NULL, elementId = NULL) {

  # check to see if trellis for lattice or ggplot
  if(inherits(svg,c("trellis","ggplot","ggmultiplot"))){
    # if class is trellis then plot then use grid.export
    # try to use gridSVG if available
    if (requireNamespace("gridSVG", quietly = TRUE)) {
      print(svg)
      svg = gridSVG::grid.export(name=NULL)$svg
    } else {  #use SVGAnnotation
      if(requireNamespace("SVGAnnotation", quietly = TRUE)){
        warning("for best results with ggplot2 and lattice, please install gridSVG")
        svg = SVGAnnotation::svgPlot(svg, addInfo = F)
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

#' Shiny bindings for svgPanZoom
#'
#' @param outputId output variable to read from
#' @param width,height must be a valid CSS unit (like "100%", "400px", "auto") or a number,
#'           which will be coerced to a string and have "px" appended
#' @param expr \code{expression} that generates a svgPanZoom htmlwidget
#' @param env \code{environment} in which to evaluate \code{expr}
#' @param quoted \code{logical} is \code{expr} a quoted \code{expression} (with \code{quote()})?
#'           This is useful if you want to save an \code{expression} in a variable.
#'
#' @name svgPanZoom-shiny
#'
#' @export
svgPanZoomOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'svgPanZoom', width, height, package = 'svgPanZoom')
}

#' @rdname svgPanZoom-shiny
#'
#' @export
renderSvgPanZoom <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, svgPanZoomOutput, env, quoted = TRUE)
}
