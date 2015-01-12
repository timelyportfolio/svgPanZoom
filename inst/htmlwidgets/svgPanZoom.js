HTMLWidgets.widget({

  name: 'svgPanZoom',

  type: 'output',

  initialize: function(el, width, height) {

    return {
      // TODO: add instance fields as required
    }

  },

  renderValue: function(el, x, instance) {

    el.innerHTML = x.svg;

    var svg = el.getElementsByTagName("svg")[0]

    instance = svgPanZoom(svg);

  },

  resize: function(el, width, height, instance) {

  }

});
