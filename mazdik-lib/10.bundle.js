(window.webpackJsonp=window.webpackJsonp||[]).push([[10],{12:function(t,e,n){"use strict";n.r(e),n.d(e,"default",(function(){return o}));var a=n(30),l=n.n(a);class o{get template(){return l.a}load(){const t=document.querySelector("#panel1");t.backdrop=!1,document.querySelector("#button-panel1").addEventListener("click",()=>t.show());const e=document.querySelector("#panel2");e.backdrop=!1,document.querySelector("#button-panel2").addEventListener("click",()=>e.show());const n=document.querySelector("#panel3");n.backdrop=!1,document.querySelector("#button-panel3").addEventListener("click",()=>n.show()),document.querySelector("#close-panel1").addEventListener("click",()=>t.hide()),document.querySelector("#close-panel2").addEventListener("click",()=>e.hide()),document.querySelector("#close-panel3").addEventListener("click",()=>n.hide())}}},30:function(t,e){t.exports='<p>Panels demo</p>\n\n<button id="button-panel1" class="dt-button">Open panel 1</button>\n<button id="button-panel2" class="dt-button">Open panel 2</button>\n<button id="button-panel3" class="dt-button">Open panel 3</button>\n\n<web-modal id="panel1" class="panel-demo1">\n  <template select="app-modal-header">\n    <span>Panel 1</span>\n  </template>\n  <template select="app-modal-body">\n    <h3>MODAL DIALOG</h3>\n    <p>Lorem Ipsum is simply dummy text of the printing and typesetting industry.\n      Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s.</p>\n  </template>\n  <template select="app-modal-footer">\n    <button class="dt-button dt-red">Delete</button>&nbsp;\n    <button class="dt-button dt-green">Save</button>\n    <button id="close-panel1" class="dt-button dt-blue" style="float: right;">Close</button>\n  </template>\n</web-modal>\n\n<web-modal id="panel2" class="panel-demo2">\n  <template select="app-modal-header">\n    <span>Panel 2</span>\n  </template>\n  <template select="app-modal-body">\n    <h3>MODAL DIALOG</h3>\n    <p>Lorem Ipsum is simply dummy text of the printing and typesetting industry.\n      Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s.</p>\n  </template>\n  <template select="app-modal-footer">\n    <button class="dt-button dt-red">Delete</button>&nbsp;\n    <button class="dt-button dt-green">Save</button>\n    <button id="close-panel2" class="dt-button dt-blue" style="float: right;">Close</button>\n  </template>\n</web-modal>\n\n<web-modal id="panel3" class="panel-demo3">\n  <template select="app-modal-header">\n    <span>Panel 3</span>\n  </template>\n  <template select="app-modal-body">\n    <h3>MODAL DIALOG</h3>\n    <p>Lorem Ipsum is simply dummy text of the printing and typesetting industry.\n      Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s.</p>\n  </template>\n  <template select="app-modal-footer">\n    <button class="dt-button dt-red">Delete</button>&nbsp;\n    <button class="dt-button dt-green">Save</button>\n    <button id="close-panel3" class="dt-button dt-blue" style="float: right;">Close</button>\n  </template>\n</web-modal>\n'}}]);
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIndlYnBhY2s6Ly8vLi9zcmMvcGFnZXMvbW9kYWwtcGFuZWxzLnRzIiwid2VicGFjazovLy8uL3NyYy9wYWdlcy9tb2RhbC1wYW5lbHMuaHRtbCJdLCJuYW1lcyI6WyJNb2RhbFBhbmVsc0RlbW8iLCJwYW5lbDEiLCJkb2N1bWVudCIsInF1ZXJ5U2VsZWN0b3IiLCJiYWNrZHJvcCIsImFkZEV2ZW50TGlzdGVuZXIiLCJzaG93IiwicGFuZWwyIiwicGFuZWwzIiwiaGlkZSIsIm1vZHVsZSIsImV4cG9ydHMiXSwibWFwcGluZ3MiOiIwRkFFQSxvRUFFZSxNQUFNQSxFQUVuQixlQUF5QixPQUFPLElBRWhDLE9BQ0UsTUFBTUMsRUFBU0MsU0FBU0MsY0FBYyxXQUN0Q0YsRUFBT0csVUFBVyxFQUNsQkYsU0FBU0MsY0FBYyxrQkFBa0JFLGlCQUFpQixRQUFTLElBQU1KLEVBQU9LLFFBRWhGLE1BQU1DLEVBQVNMLFNBQVNDLGNBQWMsV0FDdENJLEVBQU9ILFVBQVcsRUFDbEJGLFNBQVNDLGNBQWMsa0JBQWtCRSxpQkFBaUIsUUFBUyxJQUFNRSxFQUFPRCxRQUVoRixNQUFNRSxFQUFTTixTQUFTQyxjQUFjLFdBQ3RDSyxFQUFPSixVQUFXLEVBQ2xCRixTQUFTQyxjQUFjLGtCQUFrQkUsaUJBQWlCLFFBQVMsSUFBTUcsRUFBT0YsUUFFaEZKLFNBQVNDLGNBQWMsaUJBQWlCRSxpQkFBaUIsUUFBUyxJQUFNSixFQUFPUSxRQUMvRVAsU0FBU0MsY0FBYyxpQkFBaUJFLGlCQUFpQixRQUFTLElBQU1FLEVBQU9FLFFBQy9FUCxTQUFTQyxjQUFjLGlCQUFpQkUsaUJBQWlCLFFBQVMsSUFBTUcsRUFBT0MsVyxpQkN2Qm5GQyxFQUFPQyxRQUFVIiwiZmlsZSI6IjEwLmJ1bmRsZS5qcyIsInNvdXJjZXNDb250ZW50IjpbImltcG9ydCB7IFBhZ2UgfSBmcm9tICcuLi9wYWdlJztcbmltcG9ydCB7IE1vZGFsQ29tcG9uZW50IH0gZnJvbSAnQG1hemRpay1saWIvbW9kYWwnO1xuaW1wb3J0IGh0bWwgZnJvbSAnLi9tb2RhbC1wYW5lbHMuaHRtbCc7XG5cbmV4cG9ydCBkZWZhdWx0IGNsYXNzIE1vZGFsUGFuZWxzRGVtbyBpbXBsZW1lbnRzIFBhZ2Uge1xuXG4gIGdldCB0ZW1wbGF0ZSgpOiBzdHJpbmcgeyByZXR1cm4gaHRtbDsgfVxuXG4gIGxvYWQoKSB7XG4gICAgY29uc3QgcGFuZWwxID0gZG9jdW1lbnQucXVlcnlTZWxlY3RvcignI3BhbmVsMScpIGFzIE1vZGFsQ29tcG9uZW50O1xuICAgIHBhbmVsMS5iYWNrZHJvcCA9IGZhbHNlO1xuICAgIGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJyNidXR0b24tcGFuZWwxJykuYWRkRXZlbnRMaXN0ZW5lcignY2xpY2snLCAoKSA9PiBwYW5lbDEuc2hvdygpKTtcblxuICAgIGNvbnN0IHBhbmVsMiA9IGRvY3VtZW50LnF1ZXJ5U2VsZWN0b3IoJyNwYW5lbDInKSBhcyBNb2RhbENvbXBvbmVudDtcbiAgICBwYW5lbDIuYmFja2Ryb3AgPSBmYWxzZTtcbiAgICBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCcjYnV0dG9uLXBhbmVsMicpLmFkZEV2ZW50TGlzdGVuZXIoJ2NsaWNrJywgKCkgPT4gcGFuZWwyLnNob3coKSk7XG5cbiAgICBjb25zdCBwYW5lbDMgPSBkb2N1bWVudC5xdWVyeVNlbGVjdG9yKCcjcGFuZWwzJykgYXMgTW9kYWxDb21wb25lbnQ7XG4gICAgcGFuZWwzLmJhY2tkcm9wID0gZmFsc2U7XG4gICAgZG9jdW1lbnQucXVlcnlTZWxlY3RvcignI2J1dHRvbi1wYW5lbDMnKS5hZGRFdmVudExpc3RlbmVyKCdjbGljaycsICgpID0+IHBhbmVsMy5zaG93KCkpO1xuXG4gICAgZG9jdW1lbnQucXVlcnlTZWxlY3RvcignI2Nsb3NlLXBhbmVsMScpLmFkZEV2ZW50TGlzdGVuZXIoJ2NsaWNrJywgKCkgPT4gcGFuZWwxLmhpZGUoKSk7XG4gICAgZG9jdW1lbnQucXVlcnlTZWxlY3RvcignI2Nsb3NlLXBhbmVsMicpLmFkZEV2ZW50TGlzdGVuZXIoJ2NsaWNrJywgKCkgPT4gcGFuZWwyLmhpZGUoKSk7XG4gICAgZG9jdW1lbnQucXVlcnlTZWxlY3RvcignI2Nsb3NlLXBhbmVsMycpLmFkZEV2ZW50TGlzdGVuZXIoJ2NsaWNrJywgKCkgPT4gcGFuZWwzLmhpZGUoKSk7XG4gIH1cblxufVxuIiwibW9kdWxlLmV4cG9ydHMgPSBcIjxwPlBhbmVscyBkZW1vPC9wPlxcblxcbjxidXR0b24gaWQ9XFxcImJ1dHRvbi1wYW5lbDFcXFwiIGNsYXNzPVxcXCJkdC1idXR0b25cXFwiPk9wZW4gcGFuZWwgMTwvYnV0dG9uPlxcbjxidXR0b24gaWQ9XFxcImJ1dHRvbi1wYW5lbDJcXFwiIGNsYXNzPVxcXCJkdC1idXR0b25cXFwiPk9wZW4gcGFuZWwgMjwvYnV0dG9uPlxcbjxidXR0b24gaWQ9XFxcImJ1dHRvbi1wYW5lbDNcXFwiIGNsYXNzPVxcXCJkdC1idXR0b25cXFwiPk9wZW4gcGFuZWwgMzwvYnV0dG9uPlxcblxcbjx3ZWItbW9kYWwgaWQ9XFxcInBhbmVsMVxcXCIgY2xhc3M9XFxcInBhbmVsLWRlbW8xXFxcIj5cXG4gIDx0ZW1wbGF0ZSBzZWxlY3Q9XFxcImFwcC1tb2RhbC1oZWFkZXJcXFwiPlxcbiAgICA8c3Bhbj5QYW5lbCAxPC9zcGFuPlxcbiAgPC90ZW1wbGF0ZT5cXG4gIDx0ZW1wbGF0ZSBzZWxlY3Q9XFxcImFwcC1tb2RhbC1ib2R5XFxcIj5cXG4gICAgPGgzPk1PREFMIERJQUxPRzwvaDM+XFxuICAgIDxwPkxvcmVtIElwc3VtIGlzIHNpbXBseSBkdW1teSB0ZXh0IG9mIHRoZSBwcmludGluZyBhbmQgdHlwZXNldHRpbmcgaW5kdXN0cnkuXFxuICAgICAgTG9yZW0gSXBzdW0gaGFzIGJlZW4gdGhlIGluZHVzdHJ54oCZcyBzdGFuZGFyZCBkdW1teSB0ZXh0IGV2ZXIgc2luY2UgdGhlIDE1MDBzLjwvcD5cXG4gIDwvdGVtcGxhdGU+XFxuICA8dGVtcGxhdGUgc2VsZWN0PVxcXCJhcHAtbW9kYWwtZm9vdGVyXFxcIj5cXG4gICAgPGJ1dHRvbiBjbGFzcz1cXFwiZHQtYnV0dG9uIGR0LXJlZFxcXCI+RGVsZXRlPC9idXR0b24+Jm5ic3A7XFxuICAgIDxidXR0b24gY2xhc3M9XFxcImR0LWJ1dHRvbiBkdC1ncmVlblxcXCI+U2F2ZTwvYnV0dG9uPlxcbiAgICA8YnV0dG9uIGlkPVxcXCJjbG9zZS1wYW5lbDFcXFwiIGNsYXNzPVxcXCJkdC1idXR0b24gZHQtYmx1ZVxcXCIgc3R5bGU9XFxcImZsb2F0OiByaWdodDtcXFwiPkNsb3NlPC9idXR0b24+XFxuICA8L3RlbXBsYXRlPlxcbjwvd2ViLW1vZGFsPlxcblxcbjx3ZWItbW9kYWwgaWQ9XFxcInBhbmVsMlxcXCIgY2xhc3M9XFxcInBhbmVsLWRlbW8yXFxcIj5cXG4gIDx0ZW1wbGF0ZSBzZWxlY3Q9XFxcImFwcC1tb2RhbC1oZWFkZXJcXFwiPlxcbiAgICA8c3Bhbj5QYW5lbCAyPC9zcGFuPlxcbiAgPC90ZW1wbGF0ZT5cXG4gIDx0ZW1wbGF0ZSBzZWxlY3Q9XFxcImFwcC1tb2RhbC1ib2R5XFxcIj5cXG4gICAgPGgzPk1PREFMIERJQUxPRzwvaDM+XFxuICAgIDxwPkxvcmVtIElwc3VtIGlzIHNpbXBseSBkdW1teSB0ZXh0IG9mIHRoZSBwcmludGluZyBhbmQgdHlwZXNldHRpbmcgaW5kdXN0cnkuXFxuICAgICAgTG9yZW0gSXBzdW0gaGFzIGJlZW4gdGhlIGluZHVzdHJ54oCZcyBzdGFuZGFyZCBkdW1teSB0ZXh0IGV2ZXIgc2luY2UgdGhlIDE1MDBzLjwvcD5cXG4gIDwvdGVtcGxhdGU+XFxuICA8dGVtcGxhdGUgc2VsZWN0PVxcXCJhcHAtbW9kYWwtZm9vdGVyXFxcIj5cXG4gICAgPGJ1dHRvbiBjbGFzcz1cXFwiZHQtYnV0dG9uIGR0LXJlZFxcXCI+RGVsZXRlPC9idXR0b24+Jm5ic3A7XFxuICAgIDxidXR0b24gY2xhc3M9XFxcImR0LWJ1dHRvbiBkdC1ncmVlblxcXCI+U2F2ZTwvYnV0dG9uPlxcbiAgICA8YnV0dG9uIGlkPVxcXCJjbG9zZS1wYW5lbDJcXFwiIGNsYXNzPVxcXCJkdC1idXR0b24gZHQtYmx1ZVxcXCIgc3R5bGU9XFxcImZsb2F0OiByaWdodDtcXFwiPkNsb3NlPC9idXR0b24+XFxuICA8L3RlbXBsYXRlPlxcbjwvd2ViLW1vZGFsPlxcblxcbjx3ZWItbW9kYWwgaWQ9XFxcInBhbmVsM1xcXCIgY2xhc3M9XFxcInBhbmVsLWRlbW8zXFxcIj5cXG4gIDx0ZW1wbGF0ZSBzZWxlY3Q9XFxcImFwcC1tb2RhbC1oZWFkZXJcXFwiPlxcbiAgICA8c3Bhbj5QYW5lbCAzPC9zcGFuPlxcbiAgPC90ZW1wbGF0ZT5cXG4gIDx0ZW1wbGF0ZSBzZWxlY3Q9XFxcImFwcC1tb2RhbC1ib2R5XFxcIj5cXG4gICAgPGgzPk1PREFMIERJQUxPRzwvaDM+XFxuICAgIDxwPkxvcmVtIElwc3VtIGlzIHNpbXBseSBkdW1teSB0ZXh0IG9mIHRoZSBwcmludGluZyBhbmQgdHlwZXNldHRpbmcgaW5kdXN0cnkuXFxuICAgICAgTG9yZW0gSXBzdW0gaGFzIGJlZW4gdGhlIGluZHVzdHJ54oCZcyBzdGFuZGFyZCBkdW1teSB0ZXh0IGV2ZXIgc2luY2UgdGhlIDE1MDBzLjwvcD5cXG4gIDwvdGVtcGxhdGU+XFxuICA8dGVtcGxhdGUgc2VsZWN0PVxcXCJhcHAtbW9kYWwtZm9vdGVyXFxcIj5cXG4gICAgPGJ1dHRvbiBjbGFzcz1cXFwiZHQtYnV0dG9uIGR0LXJlZFxcXCI+RGVsZXRlPC9idXR0b24+Jm5ic3A7XFxuICAgIDxidXR0b24gY2xhc3M9XFxcImR0LWJ1dHRvbiBkdC1ncmVlblxcXCI+U2F2ZTwvYnV0dG9uPlxcbiAgICA8YnV0dG9uIGlkPVxcXCJjbG9zZS1wYW5lbDNcXFwiIGNsYXNzPVxcXCJkdC1idXR0b24gZHQtYmx1ZVxcXCIgc3R5bGU9XFxcImZsb2F0OiByaWdodDtcXFwiPkNsb3NlPC9idXR0b24+XFxuICA8L3RlbXBsYXRlPlxcbjwvd2ViLW1vZGFsPlxcblwiOyJdLCJzb3VyY2VSb290IjoiIn0=