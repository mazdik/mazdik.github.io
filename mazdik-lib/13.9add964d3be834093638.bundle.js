(window.webpackJsonp=window.webpackJsonp||[]).push([[13],{29:function(t,e,s){"use strict";s.r(e);var n=s(0),i=s(40);class r extends HTMLElement{constructor(){super(),this.sourceElements=[],this.targetElements=[],this.listeners=[];const t=(~~(1e3*Math.random())).toString(),e=document.createElement("template");e.innerHTML=function(t){return`\n<div class="dt-listbox-panel">\n  <label></label>\n  <div class="dt-list-menu" id="sourceList${t}"></div>\n</div>\n<div class="dt-listbox-panel">\n  <button class="dt-button" id="moveRightAllButton${t}" title="move all to the right">\n    <i class="dt-icon-quotation-r large"></i>\n  </button>\n  <button class="dt-button" id="moveRightButton${t}" title="move selected to the right">\n    <i class="dt-icon-arrow-right large"></i>\n  </button>\n  <button class="dt-button" id="moveLeftButton${t}" title="move selected to the left">\n    <i class="dt-icon-arrow-left large"></i>\n  </button>\n  <button class="dt-button" id="moveLeftAllButton${t}" title="move all to the left">\n    <i class="dt-icon-quotation-l large"></i>\n  </button>\n</div>\n<div class="dt-listbox-panel">\n  <label></label>\n  <div class="dt-list-menu" id="targetList${t}"></div>\n</div>\n<div class="dt-listbox-panel">\n  <button class="dt-button" id="moveTopButton${t}" title="move top">\n    <i class="dt-icon-tab-up large"></i>\n  </button>\n  <button class="dt-button" id="moveUpButton${t}" title="move up">\n    <i class="dt-icon-arrow-up large"></i>\n  </button>\n  <button class="dt-button" id="moveDownButton${t}" title="move down">\n    <i class="dt-icon-arrow-down large"></i>\n  </button>\n  <button class="dt-button" id="moveBottomButton${t}" title="move bottom">\n    <i class="dt-icon-tab-down large"></i>\n  </button>\n</div>\n  `}(t),this.append(e.content.cloneNode(!0)),this.sourceList=this.querySelector("#sourceList"+t),this.targetList=this.querySelector("#targetList"+t),this.moveRightAllButton=this.querySelector("#moveRightAllButton"+t),this.moveRightButton=this.querySelector("#moveRightButton"+t),this.moveLeftButton=this.querySelector("#moveLeftButton"+t),this.moveLeftAllButton=this.querySelector("#moveLeftAllButton"+t),this.moveTopButton=this.querySelector("#moveTopButton"+t),this.moveUpButton=this.querySelector("#moveUpButton"+t),this.moveDownButton=this.querySelector("#moveDownButton"+t),this.moveBottomButton=this.querySelector("#moveBottomButton"+t),this.classList.add("dt-listbox"),this.dragDrop=new i.a([this.sourceList,this.targetList],[]),this.addEventListeners()}set sourceTitle(t){this.sourceList.previousSibling.textContent=t}set targetTitle(t){this.targetList.previousSibling.textContent=t}get source(){return this._source}set source(t){this._source=t,this.filterSource(),this.sourceElements=this.createListContent(t),this.renderSourceList(),this.dragDrop.registerDraggableElements(this.sourceElements)}get target(){return this._target}set target(t){this._target=t,this.filterSource(),this.targetElements=this.createListContent(t),this.renderTargetList(),this.dragDrop.registerDraggableElements(this.targetElements)}disconnectedCallback(){this.removeEventListeners(),this.dragDrop.destroy()}addEventListeners(){this.listeners=[{eventName:"click",target:this.sourceList,handler:this.onClickSourceList.bind(this)},{eventName:"click",target:this.targetList,handler:this.onClickTargetList.bind(this)},{eventName:"droppableElementChange",target:this.sourceList,handler:this.onDroppableElementChange.bind(this)},{eventName:"droppableElementChange",target:this.targetList,handler:this.onDroppableElementChange.bind(this)},{eventName:"click",target:this.moveRightAllButton,handler:this.moveRightAll.bind(this)},{eventName:"click",target:this.moveRightButton,handler:this.moveRight.bind(this)},{eventName:"click",target:this.moveLeftButton,handler:this.moveLeft.bind(this)},{eventName:"click",target:this.moveLeftAllButton,handler:this.moveLeftAll.bind(this)},{eventName:"click",target:this.moveTopButton,handler:this.moveTop.bind(this)},{eventName:"click",target:this.moveUpButton,handler:this.moveUp.bind(this)},{eventName:"click",target:this.moveDownButton,handler:this.moveDown.bind(this)},{eventName:"click",target:this.moveBottomButton,handler:this.moveBottom.bind(this)}],this.listeners.forEach(t=>{t.target.addEventListener(t.eventName,t.handler)})}removeEventListeners(){this.listeners.forEach(t=>{t.target.removeEventListener(t.eventName,t.handler)})}moveRight(){if(!Object(n.m)(this.sourceModel)&&!Object(n.m)(this.sourceElements)){const t=this.sourceElements.findIndex(t=>t.dataset.id===this.sourceModel);Object(n.f)(this.sourceElements,this.targetElements,t,this.targetElements.length),this.sourceModel=null,this.emitEvent()}}moveRightAll(){Object(n.m)(this.sourceElements)||(this.targetElements=[...this.targetElements,...this.sourceElements],this.sourceElements=[],this.sourceModel=null,this.emitEvent())}moveLeft(){if(!Object(n.m)(this.targetModel)&&!Object(n.m)(this.targetElements)){const t=this.targetElements.findIndex(t=>t.dataset.id===this.targetModel);Object(n.f)(this.targetElements,this.sourceElements,t,this.sourceElements.length),this.targetModel=null,this.emitEvent()}}moveLeftAll(){Object(n.m)(this.targetElements)||(this.targetElements.forEach(t=>this.sourceElements.push(t)),this.targetElements=[],this.targetModel=null,this.emitEvent())}moveUp(){if(!Object(n.m)(this.targetModel)&&this.targetElements.length>1){const t=this.targetElements.findIndex(t=>t.dataset.id===this.targetModel);0!==t&&(Object(n.d)(this.targetElements,t,t-1),this.targetList.children[t]&&this.targetList.children[t].scrollIntoView({block:"center",behavior:"smooth"}),this.emitEvent())}}moveTop(){if(!Object(n.m)(this.targetModel)&&this.targetElements.length>1){const t=this.targetElements.findIndex(t=>t.dataset.id===this.targetModel);0!==t&&(Object(n.d)(this.targetElements,t,0),this.targetList.scrollTop=0,this.emitEvent())}}moveDown(){if(!Object(n.m)(this.targetModel)&&this.targetElements.length>1){const t=this.targetElements.findIndex(t=>t.dataset.id===this.targetModel);t!==this.targetElements.length-1&&(Object(n.d)(this.targetElements,t,t+1),this.targetList.children[t]&&this.targetList.children[t].scrollIntoView({block:"center",behavior:"smooth"}),this.emitEvent())}}moveBottom(){if(!Object(n.m)(this.targetModel)&&this.targetElements.length>1){const t=this.targetElements.findIndex(t=>t.dataset.id===this.targetModel);t!==this.targetElements.length-1&&(Object(n.d)(this.targetElements,t,this.targetElements.length),this.targetList.scrollTop=this.targetList.scrollHeight,this.emitEvent())}}filterSource(){this.source&&this.source.length&&this.target&&this.target.length&&(this._source=this.source.filter(t=>this.target.every(e=>e.id!==t.id)))}emitEvent(t=!0){t&&this.renderLists();const e=[...this.source,...this.target],s=this.targetElements.map(t=>e.find(e=>e.id===t.dataset.id));this.dispatchEvent(new CustomEvent("targetChange",{detail:s}))}createListContent(t){const e=[];return t.forEach(t=>{const s=document.createElement("div");s.classList.add("dt-list-menu-item"),s.textContent=t.name,s.dataset.id=t.id,e.push(s)}),e}renderSourceList(){this.sourceList.innerHTML="",this.sourceList.append(...this.sourceElements),this.updateStyles()}renderTargetList(){this.targetList.innerHTML="",this.targetList.append(...this.targetElements),this.updateStyles()}renderLists(){this.renderSourceList(),this.renderTargetList()}onClickSourceList(t){const e=this.getListItemElement(t);e&&(t.stopPropagation(),this.sourceModel=e.dataset.id,this.updateStyles())}onClickTargetList(t){const e=this.getListItemElement(t);e&&(t.stopPropagation(),this.targetModel=e.dataset.id,this.updateStyles())}getListItemElement(t){const e=t.target;return e.classList.contains("dt-list-menu-item")?e:e.closest(".dt-list-menu-item")}updateStyles(){this.sourceElements.forEach(t=>{Object(n.q)(t,"active",t.dataset.id===this.sourceModel)}),this.targetElements.forEach(t=>{Object(n.q)(t,"active",t.dataset.id===this.targetModel)});const t=Object(n.m)(this.targetModel);this.moveRightButton.disabled=Object(n.m)(this.sourceModel),this.moveLeftButton.disabled=t,this.moveTopButton.disabled=t,this.moveUpButton.disabled=t,this.moveDownButton.disabled=t,this.moveBottomButton.disabled=t}onDroppableElementChange(){this.sourceElements=Array.from(this.sourceList.children),this.targetElements=Array.from(this.targetList.children),this.sourceModel=null,this.targetModel=null,this.updateStyles(),this.emitEvent(!1)}}customElements.define("web-dual-list-box",r),s.d(e,"default",(function(){return o}));class o{get template(){return'<web-dual-list-box class="dual-list-box-demo"></web-dual-list-box>'}load(){const t=document.querySelector("web-dual-list-box");t.sourceTitle="Source title",t.targetTitle="Target title",t.source=[{id:"1",name:"name 1"},{id:"2",name:"name 2"},{id:"3",name:"name 3"},{id:"4",name:"name 4"},{id:"5",name:"name 5"},{id:"6",name:"name 6"},{id:"7",name:"name 7"},{id:"8",name:"name 8"}],t.target=[{id:"9",name:"name 9"},{id:"10",name:"name 10"},{id:"11",name:"name 11"},{id:"12",name:"name 12"}],t.addEventListener("targetChange",t=>{console.log(t.detail)})}}},40:function(t,e,s){"use strict";class n{constructor(t){this.element=t,this.listeners=[],this.addEventListeners()}addEventListeners(){this.listeners=[{eventName:"dragenter",target:this.element,handler:this.onDragEnter.bind(this)},{eventName:"dragover",target:this.element,handler:this.onDragOver.bind(this)},{eventName:"dragleave",target:this.element,handler:this.onDragLeave.bind(this)},{eventName:"drop",target:this.element,handler:this.onDrop.bind(this)}],this.listeners.forEach(t=>{t.target.addEventListener(t.eventName,t.handler)})}removeEventListeners(){this.listeners.forEach(t=>{t.target.removeEventListener(t.eventName,t.handler)})}onDragEnter(t){t.preventDefault()}onDragOver(t){t.preventDefault()}onDragLeave(t){t.preventDefault()}onDrop(t){t.preventDefault();const e=this.dragElementEvent.event.target.parentElement,s=Math.max(0,this.getNumberPosition(t.target));let n;n=e===this.element?{previousIndex:this.dragElementEvent.index,currentIndex:s,type:"reorder"}:{previousIndex:this.dragElementEvent.index,currentIndex:s,type:"move"},this.element.dispatchEvent(new CustomEvent("dropElement",{detail:n}))}getNumberPosition(t){const e=this.dragElementEvent.event.target.parentElement,s=this.element;if(t===e)return e.children?e.children.length:0;if(t===s)return s.children?s.children.length:0;let n=0;for(;t=t.previousSibling;)n++;return n-1}}var i=s(0);class r{constructor(t,e){this.droppables=[],this.listeners=[],this.draggableElements=[],this.registerDroppableElements(t),this.registerDraggableElements(e)}destroy(){this.removeEventListeners(),this.droppables.forEach(t=>{t.removeEventListeners()})}registerDroppableElements(t){const e=[];t.forEach(t=>{this.droppables.push(new n(t)),e.push({eventName:"dropElement",target:t,handler:e=>{this.onDrop(e.detail,t)}})}),e.forEach(t=>{t.target.addEventListener(t.eventName,t.handler)}),this.listeners=[...this.listeners,...e]}registerDraggableElements(t){const e=[];t.forEach(t=>{t.draggable=!0,e.push({eventName:"dragstart",target:t,handler:this.onDragStart.bind(this)}),this.draggableElements.push(t)}),this.draggableElements.forEach((t,e)=>t.dataset.index=e.toString()),e.forEach(t=>{t.target.addEventListener(t.eventName,t.handler)}),this.listeners=[...this.listeners,...e]}removeEventListeners(){this.listeners.forEach(t=>{t.target.removeEventListener(t.eventName,t.handler)})}onDragStart(t){const e=t.target.dataset.index;t.dataTransfer.setData("text",e),t.dataTransfer.effectAllowed="move";const s={event:t,index:parseInt(e,10)};this.droppables.forEach(t=>t.dragElementEvent=s),this.source=t.target.parentElement}onDrop(t,e){const s=Array.from(this.source.children),n=Array.from(e.children);"reorder"===t.type?(Object(i.d)(n,t.previousIndex,t.currentIndex),n.forEach((t,e)=>t.dataset.index=e.toString()),e.append(...n)):(Object(i.f)(s,n,t.previousIndex,t.currentIndex),s.forEach((t,e)=>t.dataset.index=e.toString()),n.forEach((t,e)=>t.dataset.index=e.toString()),this.source.append(...s),e.append(...n)),e.dispatchEvent(new CustomEvent("droppableElementChange"))}}s.d(e,"a",(function(){return r}))}}]);