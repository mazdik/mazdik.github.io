(window.webpackJsonp=window.webpackJsonp||[]).push([[13],{20:function(t,e,s){"use strict";s.r(e),s.d(e,"default",(function(){return i}));s(31);class i{get template(){return'<div class="select-list-demo">\n    <web-select-list class="sl-column" id="select-list-demo1"></web-select-list>\n    <web-select-list class="sl-column" id="select-list-demo2"></web-select-list>\n  </div>'}load(){const t=document.querySelector("#select-list-demo1"),e=document.querySelector("#select-list-demo2"),s=[{id:"1",name:"Select 1"},{id:"2",name:"Select 2"},{id:"3",name:"Select 3"},{id:"4",name:"Select 4"},{id:"5",name:"Select 5"},{id:"6",name:"Select 6"}];t.settings={multiple:!0},t.options=s,t.model=["2","4"],e.options=s,e.model=["3"]}}},31:function(t,e,s){"use strict";class i{constructor(t){this.multiple=!1,this.selectAllMessage="Select all",this.cancelMessage="Cancel",this.clearMessage="Clear",this.searchMessage="Search...",this.enableSelectAll=!0,this.enableFilterInput=!0,t&&Object.assign(this,t)}}class n extends HTMLElement{constructor(){super(),this._settings=new i,this._model=[],this.selectedOptions=[],this.listeners=[];const t=(~~(1e3*Math.random())).toString(),e=document.createElement("template");e.innerHTML=function(t){return`\n  <input class="dt-input dt-form-group" id="filterInput${t}">\n  <ul class="dt-list-menu dt-list-menu-scroll" id="listMenu${t}">\n    <li class="dt-list-menu-item" id="selectAll${t}" data-id="-1">\n      <span class="dt-checkbox">\n        <input type="checkbox" id="checkboxAll${t}"/>\n        <label></label>\n      </span>\n    </li>\n    <li class="dt-list-divider"></li>\n  </ul>\n  <div class="dt-list-menu-row">\n    <button class="dt-button dt-button-sm" id="okButton${t}"></button>\n    <button class="dt-button dt-button-sm" id="cancelButton${t}"></button>\n    <button class="dt-button dt-button-sm" id="clearButton${t}"></button>\n  </div>\n  `}(t),this.appendChild(e.content.cloneNode(!0)),this.filterInput=this.querySelector("#filterInput"+t),this.selectAll=this.querySelector("#selectAll"+t),this.checkboxAll=this.querySelector("#checkboxAll"+t),this.listMenu=this.querySelector("#listMenu"+t),this.okButton=this.querySelector("#okButton"+t),this.cancelButton=this.querySelector("#cancelButton"+t),this.clearButton=this.querySelector("#clearButton"+t),this.contentInit(),this.addEventListeners()}get settings(){return this._settings}set settings(t){this._settings=new i(t),this.contentInit()}get options(){return this._options}set options(t){this._options=t,this.render()}get model(){return this._model}set model(t){this._model=t,this.selectedOptions=t&&t.length?t.slice(0):[],this.refreshStyles()}get isOpen(){return this._isOpen}set isOpen(t){this._isOpen=t,!0===t&&(this.setFocus(),this.filterInput.value="",this.render())}disconnectedCallback(){this.removeEventListeners()}addEventListeners(){this.listeners=[{eventName:"input",target:this.filterInput,handler:this.onInputFilter.bind(this)},{eventName:"click",target:this.okButton,handler:this.onClickOk.bind(this)},{eventName:"click",target:this.cancelButton,handler:this.onClickCancel.bind(this)},{eventName:"click",target:this.clearButton,handler:this.onClickClear.bind(this)},{eventName:"click",target:this.listMenu,handler:this.onClickListMenu.bind(this)}],this.listeners.forEach(t=>{t.target.addEventListener(t.eventName,t.handler)})}removeEventListeners(){this.listeners.forEach(t=>{t.target.removeEventListener(t.eventName,t.handler)})}setSelectedOptions(t){const e=this.selectedOptions.indexOf(t);e>-1?this.selectedOptions.splice(e,1):(this.settings.multiple||(this.selectedOptions=[]),this.selectedOptions.push(t))}setSelected(t){this.setSelectedOptions(t),this.settings.multiple||this.selectionChangeEmit()}setSelectedAll(){this.allSelected?this.selectedOptions=[]:this.checkAll()}checkAll(){this.selectedOptions=this.options.map(t=>t.id),this.settings.multiple||this.selectionChangeEmit()}isSelected(t){return this.selectedOptions.indexOf(t)>-1}setFocus(){this.filterInput&&setTimeout(()=>{this.filterInput.focus()},1)}onClickOk(t){t.stopPropagation(),this.selectionChangeEmit()}onClickCancel(t){t.stopPropagation(),this.selectedOptions=this.model.slice(0),this.dispatchEvent(new CustomEvent("selectionCancel",{detail:!0})),this.refreshStyles()}onClickClear(t){t.stopPropagation(),this.selectedOptions.length>0&&(this.selectedOptions=[]),this.selectionChangeEmit(),this.refreshStyles()}get allSelected(){return this.options&&0!==this.options.length&&this.selectedOptions&&this.selectedOptions.length===this.options.length}get partiallySelected(){return 0!==this.selectedOptions.length&&!this.allSelected}selectionChangeEmit(){this.model.length===this.selectedOptions.length&&this.model.every((t,e)=>t===this.selectedOptions[e])?this.dispatchEvent(new CustomEvent("selectionCancel",{detail:!0})):(this.model=this.selectedOptions.slice(0),this.dispatchEvent(new CustomEvent("selectionChange",{detail:this.model})))}onInputFilter(){this.filteredOptions=this.filterOptionsByName(this.filterInput.value),this.render()}get viewOptions(){return this.filterInput.value?this.filteredOptions:this.options}filterOptionsByName(t){return t&&this.options?this.options.filter(e=>e.name.toLowerCase().indexOf(t.toLowerCase())>-1):this.options}contentInit(){this.filterInput.placeholder=this.settings.searchMessage,this.okButton.textContent="OK",this.cancelButton.textContent=this.settings.cancelMessage,this.clearButton.textContent=this.settings.clearMessage,this.checkboxAll.nextElementSibling.textContent=this.settings.selectAllMessage,this.okButton.style.display=this.settings.multiple?"block":"none",this.selectAll.style.display=this.settings.multiple&&this.settings.enableSelectAll?"block":"none",this.filterInput.style.display=this.settings.enableFilterInput?"block":"none"}render(){this.removeListContent();const t=this.createListContent().join("");this.listMenu.insertAdjacentHTML("beforeend",t),this.refreshStyles()}createListContent(){const t=[];return this.viewOptions.forEach(e=>{let s;s=this.settings.multiple?function(t){return`\n  <li class="dt-list-menu-item" data-id="${t.id}">\n    <span class="dt-checkbox">\n      <input type="checkbox"/>\n      <label>${t.name}</label>\n    </span>\n  </li>`}(e):function(t){return`\n  <li class="dt-list-menu-item" data-id="${t.id}">\n    <i class="dt-icon"></i>${t.name}\n  </li>`}(e),t.push(s)}),t}getDataId(t){const e="LI"===t.tagName?t:t.closest("li");return e&&e.dataset.id?e.dataset.id:null}get listContent(){return Array.from(this.listMenu.children)}onClickListMenu(t){const e=this.getDataId(t.target);null!=e&&(t.stopPropagation(),"-1"===e?this.setSelectedAll():this.setSelected(e),this.refreshStyles())}refreshStyles(){this.listContent.forEach(t=>{const e=this.getDataId(t);this.isSelected(e)?this.addActiveStyles(t):this.removeActiveStyles(t)}),this.checkboxAll.checked=this.allSelected,this.checkboxAll.indeterminate=this.partiallySelected}addActiveStyles(t){t.firstElementChild&&(this.settings.multiple?this.setInputChecked(t,!0):(t.classList.add("active"),t.firstElementChild.classList.add("dt-icon-ok")))}removeActiveStyles(t){t.firstElementChild&&(this.settings.multiple?this.setInputChecked(t,!1):(t.classList.remove("active"),t.firstElementChild.classList.remove("dt-icon-ok")))}setInputChecked(t,e){t.firstElementChild.firstElementChild.checked=e}removeListContent(){this.listContent.forEach(t=>{const e=this.getDataId(t);null!=e&&"-1"!==e&&t.remove()})}}customElements.define("web-select-list",n),s.d(e,"a",(function(){return i}))}}]);