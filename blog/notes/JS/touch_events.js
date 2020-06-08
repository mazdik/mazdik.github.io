if ('ontouchstart' in document.documentElement) {
  //...
}
var hasTouchStartEvent = 'ontouchstart' in document.createElement('div');

document.addEventListener( hasTouchStartEvent ? 'touchstart' : 'mousedown', function( e ) {
    console.log( e.touches ? 'TouchEvent' : 'MouseEvent' );
}, false );
/*
touchstart - mousedown
touchmove - mousemove
touchend - mouseup
touchcancel
*/
