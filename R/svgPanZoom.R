#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
svgPanZoom <- function(message, width = NULL, height = NULL) {

  # forward options using x
  x = list(
    message = message
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
