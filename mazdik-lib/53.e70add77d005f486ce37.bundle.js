(window.webpackJsonp=window.webpackJsonp||[]).push([[53],{26:function(d,e,t){"use strict";t.r(e),t.d(e,"default",(function(){return o}));var s=t(3);class o{constructor(){this.draggableElements=[]}get template(){return'<div class="draggable-directive-demo">\n    <div class="dd-box box1" id="box1"></div>\n    <div class="dd-box box2" id="box2"></div>\n  </div>'}load(){this.add("#box1"),this.add("#box2")}onDestroy(){this.draggableElements.forEach(d=>d.destroy())}add(d){const e=document.querySelector(d),t=new s.a(e);e.addEventListener("mousedown",d=>{t.start(d)}),this.draggableElements.push(t)}}}}]);