#' Pan and Zoom R graphics
#'
#' Add panning and zooming to almost any R graphics and
#' hopefully and eventually other htmlwidgets.
#'
#' @import htmlwidgets
#'
#' @export
svgPanZoom <- function(svg, width = NULL, height = NULL) {

  # check to see if svg is XML and saveXML if so
  if(inherits(s,"XMLAbstractDocument")){
    # should we add check for svg element?
    svg = XML::saveXML(s)
  }

  # forward options using x
  x = list(
    svg = svg
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
