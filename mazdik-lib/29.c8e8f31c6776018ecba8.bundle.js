(window.webpackJsonp=window.webpackJsonp||[]).push([[29],{18:function(e,t,n){"use strict";n.r(t),n.d(t,"default",(function(){return o}));var l=n(52),a=n(53);class o{get template(){return'<button class="dt-button">Clear all selections</button>\n    <p>Selection type: multiple. Selection mode: checkbox</p>\n    <web-data-table id="table1"></web-data-table>\n    <p>Selection type: multiple. Selection mode: radio</p>\n    <web-data-table id="table2"></web-data-table>'}load(){const e=this.createTable("#table1","checkbox"),t=this.createTable("#table2","radio");e.events.emitLoading(!0),fetch("assets/players.json").then(e=>e.json()).then(n=>{e.rows=n,t.rows=n,e.events.emitLoading(!1)}),document.querySelector("button").addEventListener("click",()=>{e.selection.clearSelection(),t.selection.clearSelection()})}createTable(e,t){const n=document.querySelector(e),o=Object(a.b)(),c=new l.e({selectionMultiple:!0,selectionMode:t}),i=new l.b(o,c);return n.table=i,i}}}}]);