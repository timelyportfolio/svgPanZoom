HTMLWidgets.widget({

  name: 'svgPanZoom',

  type: 'output',

  initialize: function(el, width, height) {

    return {
      // TODO: add instance fields as required
    }

  },

  renderValue: function(el, x, instance) {
    // set innerHTML equal to the SVG provided by R as x.svg
    //  for better robustness, create DOM element separately
    //  and add to the htmlwidgets container el
    el.innerHTML = x.svg;

    var svg = el.getElementsByTagName("svg")[0]

    instance.zoomWidget = svgPanZoom(svg, x.config);
    //  use expando property so we can access later
    //    somewhere saw where expando can cause memory leak in IE
    //    could also set in HTMLWidgets.widgets[x] where matches el
    el.zoomWidget = instance.zoomWidget;

  },

  resize: function(el, width, height, instance) {

  }

});
