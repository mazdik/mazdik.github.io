/* Calculate text width with JavaScript */
function getTextWidth(text, font) {
    // if given, use cached canvas for better performance
    // else, create new canvas
    var canvas = getTextWidth.canvas || (getTextWidth.canvas = document.createElement("canvas"));
    var context = canvas.getContext("2d");
    context.font = font;
    var metrics = context.measureText(text);
    return metrics.width;
};

function getTextWidthDOM(text, font) {
  var f = font || '12px arial',
      o = $('<span>' + text + '</span>')
            .css({'font': f, 'float': 'left', 'white-space': 'nowrap'})
            //.css({'visibility': 'hidden'})
            .appendTo($('body')),
      w = o.width();

  o.remove();

  return w;
}

// a bit more than 86 (sub-pixel accurate)
console.log(getTextWidth("hello there!", "bold 12pt arial"));
// just 86 (sub-pixel accuracy has been dropped)
console.log(getTextWidthDOM("hello there!", "bold 12pt arial"));
