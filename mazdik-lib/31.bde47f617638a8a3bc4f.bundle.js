(window.webpackJsonp=window.webpackJsonp||[]).push([[31],{27:function(e,t,a){"use strict";a.r(t),a.d(t,"default",(function(){return s}));var n=a(65),o=a(66);class s{get template(){return"<p>Editable condition per row. If row.exp > 1000000 and column editable</p>\n    <web-data-table></web-data-table>"}load(){const e=document.querySelector("web-data-table"),t=Object(o.b)();t.forEach((e,t)=>e.editable=t>0);const a=new n.Settings({isEditableCellProp:"$$editable"}),s=new n.DataTable(t,a);e.table=s,s.events.emitLoading(!0),fetch("assets/players.json").then(e=>e.json()).then(e=>{for(const t of e)t.$$editable=t.exp>1e6;s.rows=e,s.events.emitLoading(!1)})}}}}]);