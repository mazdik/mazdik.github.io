(window.webpackJsonp=window.webpackJsonp||[]).push([[55],{50:function(n,e,i){"use strict";i.r(e),i.d(e,"default",(function(){return a}));i(13);class a{get template(){return'<web-nav-menu class="nav-menu-demo1" id="nav-menu1"></web-nav-menu>\n    <p>Minimize: true</p>\n    <web-nav-menu class="nav-menu-demo2" id="nav-menu2"></web-nav-menu>'}load(){const n=[{name:"First menu",expanded:!0,children:[{id:"/page1",name:"Menu 1 link 1"},{id:"/page2",name:"Menu 1 link 2"},{name:"Submenu ",children:[{id:"/page3",name:"Submenu link 1"},{id:"/page4",name:"Submenu link 2"},{id:"/page5",name:"Submenu link 3"}]}]},{name:"Second menu",children:[{id:"/page6",name:"Menu 2 link 1"},{id:"/page7",name:"Menu 2 link 2"},{id:"/page8",name:"Menu 2 link 3"}]},{name:"With icons",icon:"dt-icon-reload",children:[{id:"/page9",name:"Menu 2 link 1",icon:"dt-icon-shrink"},{id:"/page10",name:"Menu 2 link 2",icon:"dt-icon-reload"},{id:"/page11",name:"Menu 2 link 3",icon:"dt-icon-shrink"}]}],e=document.querySelector("#nav-menu1");e.minimize=!1,e.nodes=n;const i=document.querySelector("#nav-menu2");i.minimize=!0,i.nodes=n,e.addEventListener("linkClicked",n=>{console.log(n.detail)}),e.ensureVisible("/page4")}}}}]);