(window.webpackJsonp=window.webpackJsonp||[]).push([[16],{52:function(t,e,s){"use strict";s.r(e),s.d(e,"default",(function(){return a}));s(87);class a{get template(){return'<web-pagination class="pagination-demo"></web-pagination>'}load(){const t=document.querySelector("web-pagination");t.totalItems=100,t.perPage=10,t.currentPage=1,t.pageSizeOptions=[10,20,30,50],t.addEventListener("pageChanged",t=>{console.log(t.detail)})}}},76:function(t,e){},78:function(t,e,s){"use strict";var a=s(0);class i{static getTotalPages(t,e){const s=e<1?1:Math.ceil(t/e);return Math.max(s||0,1)}static getPages(t,e){const s=[];let a=1,i=e;3<e&&(a=Math.max(t-Math.floor(1.5),1),i=a+3-1,i>e&&(i=e,a=i-3+1));for(let t=a;t<=i;t++)s.push(t);return s}}i.getRangeLabel=(t,e,s)=>{if(0===s||0===e)return"0 of "+s;const a=(t-1)*e;return`${a+1} - ${a<(s=Math.max(s,0))?Math.min(a+e,s):a+e} of ${s}`};class n extends HTMLElement{constructor(){super(),this._perPage=10,this._totalItems=0,this._currentPage=1,this._pageSizeOptions=[],this.listeners=[],this.pageElements=[]}get perPage(){return this._perPage}set perPage(t){this._perPage=t,this.totalPages=i.getTotalPages(this.totalItems,this.perPage),this.pages=i.getPages(this.currentPage,this.totalPages),this.renderPages(),this.setSelectedIndex()}get totalItems(){return this._totalItems}set totalItems(t){this._totalItems=t,this.totalPages=i.getTotalPages(this.totalItems,this.perPage),this.pages=i.getPages(this.currentPage,this.totalPages),this.renderPages()}get currentPage(){return this._currentPage}set currentPage(t){this._currentPage=t>this.totalPages?this.totalPages:t||1,this.pages=i.getPages(this.currentPage,this.totalPages),this.renderPages()}get pageSizeOptions(){return this._pageSizeOptions}set pageSizeOptions(t){this._pageSizeOptions=(t||[]).sort((t,e)=>t-e),this.loadSelect(),this.select.style.display=Object(a.isBlank)(t)?"none":"block"}connectedCallback(){this.isInitialized||(this.onInit(),this.isInitialized=!0)}disconnectedCallback(){this.removeEventListeners()}onInit(){this.classList.add("pagination"),this.render(),this.addEventListeners()}addEventListeners(){this.listeners=[{eventName:"change",target:this.select,handler:this.onChangePageSize.bind(this)},{eventName:"click",target:this.navigation,handler:this.onClick.bind(this)}],this.listeners.forEach(t=>{t.target.addEventListener(t.eventName,t.handler)})}removeEventListeners(){this.listeners.forEach(t=>{t.target.removeEventListener(t.eventName,t.handler)})}setPage(t){t>0&&t<=this.totalPages&&t!==this.currentPage&&(this.currentPage=t,this.emitEvent())}onChangePageSize(t){this.perPage=parseInt(t.target.value,10),this.currentPage=this._currentPage,this.emitEvent()}emitEvent(){const t={currentPage:this.currentPage,perPage:this.perPage};this.dispatchEvent(new CustomEvent("pageChanged",{detail:t}))}render(){this.pageSize=document.createElement("div"),this.pageSize.classList.add("pagination-page-size"),this.select=document.createElement("select"),this.select.classList.add("pagination-page-size-select"),this.select.style.display="none",this.pageSize.append(this.select),this.rangeLabel=document.createElement("div"),this.rangeLabel.classList.add("pagination-range-label"),this.navigation=document.createElement("div"),this.navigation.classList.add("pagination-navigation"),this.append(this.pageSize),this.append(this.rangeLabel),this.append(this.navigation)}renderPages(){const t=[];t.push(this.createActionLink("first","&laquo;")),t.push(this.createActionLink("prev","&lsaquo;")),this.pages.forEach(e=>{const s=document.createElement("a");s.dataset.id=e.toString(),s.textContent=e.toString(),s.href="",t.push(s)}),t.push(this.createActionLink("next","&rsaquo;")),t.push(this.createActionLink("last","&raquo;")),this.navigation.innerHTML="",this.navigation.append(...t),this.pageElements=t,this.updateStyles(),this.setRangeLabel()}createActionLink(t,e){const s=document.createElement("a");return s.dataset.action=t,s.innerHTML=e,s.href="",s}loadSelect(){this.select.style.display="block",this.select.innerHTML="",this.pageSizeOptions.forEach(t=>{const e=t.toString();this.select.options.add(new Option(e,e))}),this.setSelectedIndex()}setSelectedIndex(){if(this.pageSizeOptions&&this.pageSizeOptions.length){const t=this.pageSizeOptions.findIndex(t=>t===this.perPage);this.select.selectedIndex=t}}onClick(t){const e=t.target,s="A"===e.tagName?e:e.closest("a");if(s)if(t.stopPropagation(),t.preventDefault(),s.blur(),Object(a.isBlank)(s.dataset.id))"first"===s.dataset.action?this.setPage(1):"prev"===s.dataset.action?this.setPage(this.currentPage-1):"next"===s.dataset.action?this.setPage(this.currentPage+1):"last"===s.dataset.action&&this.setPage(this.totalPages);else{const t=parseInt(s.dataset.id,10);this.setPage(t)}}updateStyles(){this.pageElements.forEach(t=>{Object(a.toggleClass)(t,"active",this.currentPage.toString()===t.dataset.id),"first"!==t.dataset.action&&"prev"!==t.dataset.action||Object(a.toggleClass)(t,"disabled",1===this.currentPage),"next"!==t.dataset.action&&"last"!==t.dataset.action||Object(a.toggleClass)(t,"disabled",this.currentPage===this.totalPages)})}setRangeLabel(){this.rangeLabel.textContent=i.getRangeLabel(this.currentPage,this.perPage,this.totalItems)}}customElements.define("web-pagination",n)},87:function(t,e,s){"use strict";s(78),s(76)}}]);