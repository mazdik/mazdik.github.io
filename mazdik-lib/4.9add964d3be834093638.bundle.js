(window.webpackJsonp=window.webpackJsonp||[]).push([[4],{13:function(e,n,s){"use strict";s.r(n),s.d(n,"default",(function(){return a}));var t=s(47),i=s.n(t),o=s(35);class a{get template(){return i.a}load(){const e=document.querySelectorAll(".dropdown-directive-demo .dropdown");this.dropdown=new o.b(e)}onDestroy(){this.dropdown.destroy()}}},35:function(e,n,s){"use strict";var t=s(0);class i{constructor(e){this.element=e,this.addEventListeners()}addEventListeners(){this.clickListener=this.onClick.bind(this),this.element.addEventListener("click",this.clickListener),this.windowClickListener=this.onWindowClick.bind(this),window.document.addEventListener("click",this.windowClickListener),this.windowKeydownListener=this.onKeyDown.bind(this),window.document.addEventListener("keydown",this.windowKeydownListener)}removeEventListeners(){this.element.removeEventListener("click",this.clickListener),window.document.removeEventListener("click",this.windowClickListener),window.document.removeEventListener("keydown",this.windowKeydownListener)}onClick(){this.selectContainerClicked=!0}onWindowClick(){this.selectContainerClicked||this.closeDropdown(),this.selectContainerClicked=!1}onKeyDown(e){e.keyCode!==t.a.ESCAPE&&"Escape"!==e.key||this.closeDropdown()}toggleDropdown(){this.isOpen?this.closeDropdown():this.openDropdown()}openDropdown(){this.isOpen||(this.isOpen=!0,this.element.dispatchEvent(new CustomEvent("open",{detail:this.isOpen})))}closeDropdown(){this.isOpen&&(this.isOpen=!1,this.element.dispatchEvent(new CustomEvent("open",{detail:this.isOpen})))}}class o{constructor(e){this.element=e,this.isOpen=!1,this.listeners=[],this.addEventListeners()}set clickedElement(e){e!==this.element&&this.isOpen&&(this.isOpen=!1,this.updateStyles())}addEventListeners(){this.listeners=[{eventName:"click",target:this.element,handler:this.toggleDropdown.bind(this)}],this.listeners.forEach(e=>{e.target.addEventListener(e.eventName,e.handler)})}removeEventListeners(){this.listeners.forEach(e=>{e.target.removeEventListener(e.eventName,e.handler)})}toggle(){this.isOpen=!this.isOpen}toggleDropdown(e){e.stopPropagation(),this.toggle(),this.updateStyles(),this.element.dispatchEvent(new CustomEvent("clickElement",{detail:this.element}))}onWindowClick(e){const n=e.target;n&&(this.element.contains(n)||(this.isOpen=!1),this.updateStyles())}updateStyles(){this.isOpen?this.element.classList.add("open"):this.element.classList.remove("open")}}class a{constructor(e){this.dropdowns=[],this.listeners=[],e.forEach(e=>{this.dropdowns.push(new o(e))}),this.addEventListeners(e)}destroy(){this.removeEventListeners(),this.dropdowns.forEach(e=>{e.removeEventListeners()})}addEventListeners(e){this.listeners=[{eventName:"click",target:window,handler:this.onWindowClick.bind(this)}],e.forEach(e=>{this.listeners.push({eventName:"clickElement",target:e,handler:this.onClickElement.bind(this)})}),this.listeners.forEach(e=>{e.target.addEventListener(e.eventName,e.handler)})}removeEventListeners(){this.listeners.forEach(e=>{e.target.removeEventListener(e.eventName,e.handler)})}onWindowClick(e){this.dropdowns.forEach(n=>{n.onWindowClick(e)})}onClickElement(e){this.dropdowns.forEach(n=>{n.clickedElement=e.detail})}}s.d(n,"a",(function(){return i})),s.d(n,"b",(function(){return a}))},47:function(e,n){e.exports='<div class="dropdown-directive-demo">\n  <nav class="navbar">\n    <a href="#" class="logo">Home</a>\n    <ul class="main-nav">\n      <li class="dropdown">\n        <a class="nav-links">Menu 1 &nbsp;<span class="caret">▼</span></a>\n        <div class="dropdown-menu">\n          <a class="nav-links">test 1</a>\n          <a class="nav-links">test 2</a>\n          <a class="nav-links">test 3</a>\n        </div>\n      </li>\n      <li class="dropdown">\n        <a class="nav-links">Menu 2 &nbsp;<span class="caret">▼</span></a>\n        <div class="dropdown-menu">\n          <a class="nav-links">test 1</a>\n          <a class="nav-links">test 2</a>\n          <a class="nav-links">test 3</a>\n        </div>\n      </li>\n      <li class="dropdown">\n        <a class="nav-links">Menu 3 &nbsp;<span class="caret">▼</span></a>\n        <div class="dropdown-menu">\n          <a class="nav-links">test 1</a>\n          <a class="nav-links">test 2</a>\n          <a class="nav-links">test 3</a>\n        </div>\n      </li>\n    </ul>\n  </nav>\n</div>\n'}}]);