/* Динамическая загрузка файла JS через промис */
function loadScript(url) {
  if (Array.from(document.querySelectorAll('script')).some(elm => elm.src === url)) {
    return Promise.resolve();
  }
  return new Promise(function(resolve, reject) {
    var script = document.createElement('script');
    script.async = true;
    script.src = url;
    // trigger fulfilled state when script is ready
    script.onload = resolve;
    // trigger rejected state when script is not found
    script.onerror = reject;
    document.head.appendChild(script);   
  });
}
// вызов
loadScript(window.location.origin+'/assets/scripts/app.js').then(initApp);

/* Динамическая загрузка файла JS через колбэк */
function loadScript(url, callback)
{
    var script = document.createElement('script');
    script.async = true;
    script.src = url;
    // Then bind the event to the callback function.
    // There are several events for cross browser compatibility.
    script.onreadystatechange = callback;
    script.onload = callback;
    document.body.appendChild(script);
}
