/* Get all event listeners on the page in Google Chrome */
var items = Array.prototype.slice.call(
  document.querySelectorAll('*')
).map(function(element) {
  var listeners = getEventListeners(element);
  return {
    element: element,
    listeners: Object.keys(listeners).map(function(k) {
      return { event: k, listeners: listeners[k] };
    })
  };
}).filter(function(item) {
  return item.listeners.length;
});
// 1. log them to the console
console.log(items);
// 2. Put a red border around the elements
items.forEach(function(item) {
  item.element.style.outline = '1px solid red';
});