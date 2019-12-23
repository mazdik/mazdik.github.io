export function isLeftButton(event) {
    if (event.type === 'touchstart') {
        return true;
    }
    return (event.type === 'mousedown' && event.button === 0);
}
export function getEvent(event) {
    if (event.type === 'touchend' || event.type === 'touchcancel') {
        return event.changedTouches[0];
    }
    return event.type.startsWith('touch') ? event.targetTouches[0] : event;
}
export function maxZIndex(selectors = 'body *') {
    return Array.from(document.querySelectorAll(selectors))
        .map(a => parseFloat(window.getComputedStyle(a).zIndex))
        .filter(a => !isNaN(a))
        .sort((a, b) => a - b)
        .pop() || 0;
}
