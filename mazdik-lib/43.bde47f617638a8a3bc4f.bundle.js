(window.webpackJsonp=window.webpackJsonp||[]).push([[43],{36:function(e,t,a){"use strict";a.r(t),a.d(t,"default",(function(){return n}));var d=a(65),s=a(66);class n{get template(){return'\n    <div class="vertical-group-demo">\n      <div class="datatable vertical">\n        <div class="datatable-header-cell">\n            <span class="column-title">Race</span>\n        </div>\n        <div id="dtv1" class="datatable-body"></div>\n      </div>\n      <div class="datatable vertical">\n        <div class="datatable-header-cell">\n            <span class="column-title">Gender</span>\n        </div>\n        <div id="dtv2" class="datatable-body"></div>\n      </div>\n      <web-data-table class="tab2 fixed-header"></web-data-table>\n    </div>'}load(){const e=document.querySelector("web-data-table");this.dtv1=document.querySelector("#dtv1"),this.dtv2=document.querySelector("#dtv2");const t=Object(s.b)();t[2].tableHidden=!0,t[4].tableHidden=!0;const a=new d.DataTable(t,new d.Settings({filter:!1,paginator:!1}));a.pager.perPage=50,e.table=a;const n=new d.DataAggregation;a.events.emitLoading(!0),fetch("assets/players.json").then(e=>e.json()).then(e=>{a.sorter.multiple=!0,a.sorter.set(["race","gender"]),a.rows=a.sorter.sortRows(e),a.sorter.set(["race","gender"]),this.raceGroupMetadata=n.groupMetaData(a.rows,["race"]),this.genderGroupMetadata=n.groupMetaData(a.rows,["race","gender"]),this.render(a),a.events.emitLoading(!1)});document.querySelector("web-data-table .datatable").addEventListener("scroll",e=>{const t=e.currentTarget;this.dtv1.scrollTop=t.scrollTop,this.dtv2.scrollTop=t.scrollTop})}render(e){this.dtv1.innerHTML="",this.dtv2.innerHTML="";let t=[];Object.keys(this.raceGroupMetadata).forEach(a=>{const d=document.createElement("div");d.classList.add("datatable-body-cell"),d.style.height=e.dimensions.rowHeight*this.raceGroupMetadata[a].size+"px";const s=document.createElement("div");s.classList.add("cell-data"),s.textContent=a,d.append(s),t.push(d)}),this.dtv1.append(...t),t=[],Object.keys(this.genderGroupMetadata).forEach(a=>{const d=document.createElement("div");d.classList.add("datatable-body-cell"),d.style.height=e.dimensions.rowHeight*this.genderGroupMetadata[a].size+"px";const s=document.createElement("div");s.classList.add("cell-data"),s.textContent=a.split(",")[1],d.append(s),t.push(d)}),this.dtv2.append(...t)}}}}]);