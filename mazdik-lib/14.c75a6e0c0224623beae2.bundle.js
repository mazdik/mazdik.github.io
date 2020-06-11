(window.webpackJsonp=window.webpackJsonp||[]).push([[14],{31:function(e,t,n){"use strict";n.r(t);n(4);var s=n(37);n(42);class i extends HTMLElement{constructor(){super(),this.item={},this.listeners=[]}set dynElements(e){this.dynamicForm.dynElements=e}set modalTitle(e){this.modalEditFormTitle.textContent=e}set saveMessage(e){this.modalEditFormSave.textContent=e}set closeMessage(e){this.modalEditFormClose.textContent=e}connectedCallback(){this.onInit()}disconnectedCallback(){this.removeEventListeners()}onInit(){const e=(~~(1e3*Math.random())).toString(),t=document.createElement("template");t.innerHTML=function(e){return`\n  <web-modal>\n    <template select="app-modal-header">\n      <span id="modalEditFormTitle${e}">Modal</span>\n    </template>\n    <template select="app-modal-body">\n      <web-dynamic-form></web-dynamic-form>\n      <web-row-view></web-row-view>\n    </template>\n    <template select="app-modal-footer">\n      <button class="dt-button" id="modalEditFormSave${e}">Save</button>\n      <button class="dt-button dt-green" id="modalEditFormClose${e}" style="float: right;">Close</button>\n    </ng-container>\n    </template>\n  </web-modal>\n  `}(e),this.append(t.content.cloneNode(!0)),this.modalEditFormTitle=this.querySelector("#modalEditFormTitle"+e),this.modalEditFormSave=this.querySelector("#modalEditFormSave"+e),this.modalEditFormClose=this.querySelector("#modalEditFormClose"+e),this.modal=this.querySelector("web-modal"),this.dynamicForm=this.querySelector("web-dynamic-form"),this.rowView=this.querySelector("web-row-view"),this.dynamicForm.style.display="none",this.rowView.style.display="none",this.addEventListeners()}addEventListeners(){this.listeners=[{eventName:"valid",target:this.dynamicForm,handler:this.onFormValid.bind(this)},{eventName:"click",target:this.modalEditFormSave,handler:this.onClickSave.bind(this)},{eventName:"click",target:this.modalEditFormClose,handler:this.onClickClose.bind(this)}],this.listeners.forEach(e=>{e.target.addEventListener(e.eventName,e.handler)})}removeEventListeners(){this.listeners.forEach(e=>{e.target.removeEventListener(e.eventName,e.handler)})}onClickSave(){this.isNewItem?this.dispatchEvent(new CustomEvent("create",{detail:this.item})):this.dispatchEvent(new CustomEvent("update",{detail:this.item})),this.modal.hide()}onClickClose(){this.modal.hide()}onFormValid(e){this.modalEditFormSave.disabled=!e.detail}create(){this.rowView.style.display="none",this.dynamicForm.style.display="block",this.modalEditFormSave.style.visibility="visible",this.dynamicForm.item={},this.isNewItem=!0,this.modal.show()}update(){this.rowView.style.display="none",this.dynamicForm.style.display="block",this.modalEditFormSave.style.visibility="visible",this.dynamicForm.item=this.item,this.isNewItem=!1,this.modal.show()}view(){this.rowView.style.display="block",this.dynamicForm.style.display="none",this.modalEditFormSave.style.visibility="hidden",this.rowView.data=this.getData(),this.modal.show()}getData(){const e=[];return Object.keys(this.item).forEach(t=>{e.push({key:t,value:this.item[t]})}),e}}customElements.define("web-modal-edit-form",i);var a=n(0);n.d(t,"default",(function(){return d}));class d{constructor(){this.dynElements=[new s.a({title:"Id",name:"id",type:"number"}),new s.a({title:"Name",name:"name",validatorFunc:a.b.get({required:!0,minLength:2,pattern:"^[a-zA-Z ]+$"})}),new s.a({title:"Race",name:"race",type:"select",options:[{id:"ASMODIANS",name:"ASMODIANS"},{id:"ELYOS",name:"ELYOS"}],validatorFunc:a.b.get({required:!0})}),new s.a({title:"Cascading Select",name:"note",type:"select-dropdown",getOptionsFunc:this.getOptions,optionsUrl:"assets/options.json",dependsElement:"race"}),new s.a({title:"Gender",name:"gender",type:"radio",options:[{id:"MALE",name:"MALE"},{id:"FEMALE",name:"FEMALE"}]}),new s.a({title:"Exp",name:"exp",type:"number",validatorFunc:a.b.get({required:!0,maxLength:10,pattern:"^[0-9]+$"})}),new s.a({title:"Last online",name:"last_online",type:"datetime-local"}),new s.a({title:"Account name",name:"account_name",type:"select-modal",getOptionsFunc:this.getOptions,optionsUrl:"assets/accounts.json",keyElement:"account_id"}),new s.a({title:"Account id",name:"account_id"}),new s.a({title:"Player class",name:"player_class",validatorFunc:this.customValidation}),new s.a({title:"Online",name:"online",type:"checkbox",options:[{id:"1",name:"Online"}]}),new s.a({title:"Comment",name:"comment",type:"textarea"})],this.item={id:96491,name:"Defunct",race:"ASMODIANS",note:"ASM2",gender:"MALE",exp:7734770,last_online:"2013-04-14T22:51:14",account_name:"berserk",account_id:19,player_class:"CLERIC",online:1,comment:"test comment"}}get template(){return'<web-modal-edit-form></web-modal-edit-form>\n    <button class="dt-button" id="createButton">Create</button>&nbsp;\n    <button class="dt-button" id="updateButton">Edit</button>&nbsp;\n    <button class="dt-button" id="viewButton">View</button>\n    '}load(){const e=document.querySelector("web-modal-edit-form");e.dynElements=this.dynElements,e.item=this.item,e.saveMessage="Save!",e.closeMessage="Close!",e.addEventListener("create",e=>{console.log(e.detail)}),e.addEventListener("update",e=>{console.log(e.detail)}),document.querySelector("#createButton").addEventListener("click",()=>{e.modalTitle="Create new item",e.create()}),document.querySelector("#updateButton").addEventListener("click",()=>{e.modalTitle="Edite item",e.update()}),document.querySelector("#viewButton").addEventListener("click",()=>{e.modalTitle="View item",e.view()})}customValidation(e,t){return null==t||0===t.length?["Custom validator "+e]:[]}getOptions(e,t){return fetch(e).then(e=>e.json()).then(e=>{const n=e.filter(e=>e.parentId===t);return new Promise(e=>{setTimeout(()=>e(n),1e3)})})}}},42:function(e,t,n){"use strict";var s=n(0);class i extends HTMLElement{constructor(){super(),this.headerKeyMessage="Key",this.headerValueMessage="Value",this.reverse=!0,this.listeners=[],this.renderTable(),this.addEventListeners()}get data(){return this._data}set data(e){this._data=e,this.renderRows()}disconnectedCallback(){this.removeEventListeners()}addEventListeners(){this.listeners=[{eventName:"click",target:this.headerKey,handler:this.onClickHeaderKey.bind(this)},{eventName:"click",target:this.headerValue,handler:this.onClickHeaderValue.bind(this)}],this.listeners.forEach(e=>{e.target.addEventListener(e.eventName,e.handler)})}removeEventListeners(){this.listeners.forEach(e=>{e.target.removeEventListener(e.eventName,e.handler)})}renderTable(){const e=document.createElement("table");e.classList.add("dt-detail-view");const t=document.createElement("thead");e.append(t);const n=document.createElement("tr");t.append(n);const s=document.createElement("th");s.textContent="№",n.append(s),this.headerKey=document.createElement("th"),this.headerKey.classList.add("sortable"),this.headerKey.textContent=this.headerKeyMessage,n.append(this.headerKey),this.headerValue=document.createElement("th"),this.headerValue.classList.add("sortable"),this.headerValue.textContent=this.headerValueMessage,n.append(this.headerValue),this.tbody=document.createElement("tbody"),e.append(this.tbody),this.append(e)}renderRows(){const e=this.orderedData?this.orderedData:this.data,t=[];e.forEach((e,n)=>{const s=document.createElement("tr"),i=document.createElement("td");i.textContent=(n+1).toString(),s.append(i);const a=document.createElement("td");a.textContent=e.key,s.append(a);const d=document.createElement("td");d.textContent=e.value,s.append(d),t.push(s)}),this.tbody.innerHTML="",this.tbody.append(...t)}onClickHeaderKey(){this.setOrder("key"),this.renderRows(),this.updateStyles()}onClickHeaderValue(){this.setOrder("value"),this.renderRows(),this.updateStyles()}setOrder(e){this.order===e&&(this.reverse=!this.reverse),this.order=e,this.orderedData=this.orderBy(this.data,this.order,this.reverse)}orderBy(e,t,n){return e&&t?(e.sort((e,n)=>e[t]>n[t]?1:e[t]<n[t]?-1:0),!1===n?e.reverse():e):e}isOrder(e){return this.order===e&&this.reverse}isOrderReverse(e){return this.order===e&&!this.reverse}updateStyles(){Object(s.p)(this.headerKey,"asc",this.isOrder("key")),Object(s.p)(this.headerKey,"desc",this.isOrderReverse("key")),Object(s.p)(this.headerValue,"asc",this.isOrder("value")),Object(s.p)(this.headerValue,"desc",this.isOrderReverse("value"))}}customElements.define("web-row-view",i)}}]);