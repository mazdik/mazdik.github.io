(window.webpackJsonp=window.webpackJsonp||[]).push([[42],{55:function(e,t,n){"use strict";n.r(t),n.d(t,"default",(function(){return i}));var s=n(65),a=n(66);class l{constructor(){this.elements=new Map,this.listeners=[]}create(e){const{table:t,column:n}=e,s=document.createDocumentFragment(),a=document.createElement("img");a.classList.add("dt-pointer","dt-template-demo-img"),a.src="assets/asmodian.png",a.title="ASMODIANS",s.append(a);const l=document.createElement("strong");l.classList.add("dt-pointer"),l.title=t.messages.clearFilters,l.textContent=n.title,s.append(l);const r=document.createElement("img");return r.classList.add("dt-pointer","dt-template-demo-img"),r.src="assets/elyos.png",r.title="ELYOS",s.append(r),this.addListener({eventName:"click",target:a,handler:this.onClickRaceFilter.bind(this,t,"ASMODIANS")}),this.addListener({eventName:"click",target:l,handler:this.onClickRaceFilter.bind(this,t,null)}),this.addListener({eventName:"click",target:r,handler:this.onClickRaceFilter.bind(this,t,"ELYOS")}),this.elements.set(n,s),s}destroy(){this.removeEventListeners(),this.elements.clear()}refresh(e){const{table:t,column:n}=e;this.elements.get(n)}addListener(e){this.listeners.push(e),e.target.addEventListener(e.eventName,e.handler)}removeEventListeners(){this.listeners.forEach(e=>{e.target.removeEventListener(e.eventName,e.handler)})}onClickRaceFilter(e,t){e.dataFilter.setFilter(t,"race",s.FilterOperator.EQUALS),e.events.emitFilter()}}class r{constructor(){this.elements=new Map}create(e){const{cell:t}=e,n=document.createDocumentFragment(),s=document.createElement("img");s.classList.add("dt-template-demo-img"),s.src="ASMODIANS"===t.value?"assets/asmodian.png":"assets/elyos.png",s.title=t.viewValue,n.append(s);const a=document.createTextNode(t.viewValue);return n.append(a),this.elements.set(t,n),n}destroy(){this.elements.clear()}refresh(e){const{cell:t}=e;this.elements.get(t)}}class i{get template(){return"<web-data-table></web-data-table>"}load(){const e=document.querySelector("web-data-table"),t=Object(a.b)();t.forEach(e=>e.frozen=!1);t.unshift({name:"rn",title:"#",sortable:!1,filter:!1,frozen:!0,resizeable:!1,width:40,minWidth:40,formHidden:!0,cellClass:"action-cell",headerCellClass:"action-cell"});let n=t.find(e=>"race"===e.name);n.headerCellTemplate=new l,n.cellTemplate=new r,n=t.find(e=>"rn"===e.name),n.headerCellTemplate=new s.HeaderActionRenderer,n.cellTemplate=new s.CellRowNumberRenderer;const i=new s.Settings({rowHeight:40}),c=new s.DataTable(t,i);e.table=c,c.events.emitLoading(!0),fetch("assets/players.json").then(e=>e.json()).then(e=>{c.rows=e,c.events.emitLoading(!1)})}}}}]);