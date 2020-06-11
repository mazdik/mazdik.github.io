(window.webpackJsonp=window.webpackJsonp||[]).push([[8],{30:function(e,t,i){"use strict";i.r(t);var n=i(45),s=i.n(n),l=i(0);class a extends HTMLElement{constructor(){super(),this.selectPlaceholder="",this.type="text",this.listeners=[],this.initValue=!1,this.classList.add("dt-inline-editor"),this.inlineDataView=document.createElement("div"),this.inlineDataView.classList.add("dt-inline-data"),this.append(this.inlineDataView),this.select=document.createElement("select"),this.input=document.createElement("input"),this.addEventListeners()}get editing(){return this._editing}set editing(e){this._editing=e,this.renderInput()}get value(){return this._value}set value(e){this._value=e,this.firstInitValue(),this.setViewValue()}get options(){return this._options}set options(e){this._options=e,this.loadSelect(),this.setViewValue()}get isDateType(){return Object(l.k)(this.type)}disconnectedCallback(){this.removeEventListeners()}addEventListeners(){this.listeners=[{eventName:"input",target:this.input,handler:this.onInput.bind(this)},{eventName:"focus",target:this.input,handler:this.onInputFocus.bind(this)},{eventName:"blur",target:this.input,handler:this.onInputBlur.bind(this)},{eventName:"change",target:this.select,handler:this.onInput.bind(this)},{eventName:"focus",target:this.select,handler:this.onInputFocus.bind(this)},{eventName:"blur",target:this.select,handler:this.onInputBlur.bind(this)}],this.listeners.forEach(e=>{e.target.addEventListener(e.eventName,e.handler)})}removeEventListeners(){this.listeners.forEach(e=>{e.target.removeEventListener(e.eventName,e.handler)})}onInput(e){"number"===this.type?this.value=Object(l.l)(e.target.value)?null:parseFloat(e.target.value):this.isDateType?Object(l.f)(e.target.value)&&(this.value=new Date(e.target.value)):this.value=e.target.value,this.dispatchEvent(new CustomEvent("valueChange",{detail:this.value}))}onInputFocus(){this.dispatchEvent(new CustomEvent("focusChange"))}onInputBlur(){this.dispatchEvent(new CustomEvent("blurChange"))}appendInput(){"select"===this.type?(this.append(this.select),this.select.focus()):(this.input.type=this.type,"number"===this.type&&(this.input.step="any"),this.input.value=this.getInputFormattedValue(),this.append(this.input),this.input.focus())}removeInput(){this.contains(this.input)&&(this.input=this.removeChild(this.input)),this.contains(this.select)&&(this.select=this.removeChild(this.select))}renderInput(){this.editing?(this.inlineDataView.style.display="none",this.appendInput()):(this.inlineDataView.style.display="block",this.removeInput())}firstInitValue(){this.initValue||(this.input.value=this.getInputFormattedValue(),this.setSelectedIndex(),this.initValue=!0)}loadSelect(){const e=new Option(this.selectPlaceholder,"",!1,!0);e.disabled=!0,e.hidden=!0,this.select.options.add(e);for(const e of this.options)this.select.options.add(new Option(e.name,e.id));this.setSelectedIndex()}setSelectedIndex(){if(this.options&&this.options.length){let e=this.options.findIndex(e=>e.id===this.value.toString());e=e>=0?e+1:e,this.select.selectedIndex=e}}getInputFormattedValue(){const e=this.isDateType?Object(l.j)(this.type,this.value):this.value;return Object(l.l)(e)?null:e}setViewValue(){let e="";if(this.options&&this.options.length){const t=this.options.find(e=>e.id===this.value.toString());e=t?t.name:""}else if(this.value instanceof Date)if("date"===this.type)e=this.value.toLocaleDateString();else{const t=this.value.toLocaleTimeString();e=this.value.toLocaleDateString()+" "+t}else e=this.value.toString();this.inlineDataView.innerText=e}}customElements.define("web-inline-edit",a),i.d(t,"default",(function(){return d}));class d{get template(){return s.a}load(){this.demo1(),this.demo2(),this.demo3()}demo1(){const e=document.querySelector("#inline-edit1");e.type="text",e.value="string";const t=document.querySelector("#button1");t.addEventListener("click",()=>{e.editing=!e.editing,t.innerText=e.editing?"View":"Edit"}),e.addEventListener("valueChange",e=>{console.log(e.detail)})}demo2(){const e=document.querySelector("#inline-edit2");e.type="select",e.value=2;e.selectPlaceholder="placeholder",e.options=[{id:"1",name:"Select 1"},{id:"2",name:"Select 2"},{id:"3",name:"Select 3"},{id:"4",name:"Select 4"},{id:"5",name:"Select 5"},{id:"6",name:"Select 6"}];const t=document.querySelector("#button2");t.addEventListener("click",()=>{e.editing=!e.editing,t.innerText=e.editing?"View":"Edit"}),e.addEventListener("valueChange",e=>{console.log(e.detail)})}demo3(){const e=document.querySelector("#inline-edit3");e.type="date",e.value=new Date;const t=document.querySelector("#button3");t.addEventListener("click",()=>{e.editing=!e.editing,t.innerText=e.editing?"View":"Edit"}),e.addEventListener("valueChange",e=>{console.log(e.detail)})}}},45:function(e,t){e.exports='<p>Input. Type: text</p>\n<div class="inline-edit-demo">\n  <web-inline-edit class="inline-edit-demo-cell" id="inline-edit1"></web-inline-edit>\n  &nbsp;\n  <button class="dt-button" id="button1">Edit</button>\n</div>\n\n<p>Select. Type: number</p>\n<div class="inline-edit-demo">\n  <web-inline-edit class="inline-edit-demo-cell" id="inline-edit2"></web-inline-edit>\n  &nbsp;\n  <button class="dt-button" id="button2">Edit</button>\n</div>\n\n<p>Input. Type: date</p>\n<div class="inline-edit-demo">\n  <web-inline-edit class="inline-edit-demo-cell" id="inline-edit3"></web-inline-edit>\n  &nbsp;\n  <button class="dt-button" id="button3">Edit</button>\n</div>\n'}}]);