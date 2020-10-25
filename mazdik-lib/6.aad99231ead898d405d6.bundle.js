(window.webpackJsonp=window.webpackJsonp||[]).push([[6],{119:function(e,t,n){"use strict";n.d(t,"a",(function(){return i}));class i{constructor(){this.url="assets/tree.json"}getNodes(e){const t=[{id:"MALE",name:"MALE",data:{column:"gender"},leaf:!1},{id:"FEMALE",name:"FEMALE",data:{column:"gender"}}];return e?(t[0].id="MALE"+e.$$level,t[0].name="MALE"+e.$$level,t[0].leaf=10===e.$$level,t[1].id="FEMALE"+e.$$level,t[1].name="FEMALE"+e.$$level,new Promise(e=>{setTimeout(()=>e(t),500)})):this.get()}searchNodes(e){return new Promise(e=>{setTimeout(()=>e(["ELYOS","MALE","LAZY"]),500)})}get(){return fetch(this.url).then(e=>e.json())}}},58:function(e,t,n){"use strict";n.r(t),n.d(t,"default",(function(){return a}));var i=n(78),s=n(0);function r(e,t){t.style.display=e?"block":"none"}class o{constructor(e,t){this.node=e,this.getIconFunc=t,this.createNodeElement(),this.updateStyles()}createNodeElement(){const e=document.createElement("li");e.dataset.id=this.node.$$id.toString(),this.expanderIconElement=document.createElement("i"),e.append(this.expanderIconElement),this.nodeContentElement=document.createElement("span"),this.iconElement=document.createElement("i"),this.nodeContentElement.append(this.iconElement);const t=document.createTextNode(this.node.name);this.nodeContentElement.append(t),e.append(this.nodeContentElement),this.element=e}getIcon(){return this.getIconFunc?this.getIconFunc(this.node):this.node.icon}getExpanderIcon(){return i.e.getExpanderIcon(this.node)}nodeClass(){let e="treenode";return this.node.$$filterState===i.a.NOT_FOUND&&(e+=" filter-not-found"),e}nodeContentClass(){let e="treenode-content";return this.node.$$filterState===i.a.FOUND?e+=" filter-found":this.node.$$filterState===i.a.ON_FOUND_PATH&&(e+=" filter-on-path"),this.node.isSelected&&(e+=" highlight"),e}updateStyles(){this.element.className=this.nodeClass(),this.expanderIconElement.className=this.getExpanderIcon(),this.nodeContentElement.className=this.nodeContentClass(),this.iconElement.className=this.getIcon();const e=this.nodeContentElement.nextElementSibling;e&&r(this.node.expanded,e)}}class d extends HTMLElement{constructor(){super(),this.filterDelay=500,this.tree=new i.b,this.listeners=[],this.treeViewNodes=[]}get service(){return this.tree.service}set service(e){this.tree.service=e,this.tree.nodes=[],this.initGetNodes()}set serverSideFiltering(e){this.tree.serverSideFiltering=e,this.tree.filterLoadingFunc=this.updateFilterLoadingStyles.bind(this)}connectedCallback(){this.isInitialized||(this.onInit(),this.isInitialized=!0)}disconnectedCallback(){this.removeEventListeners()}onInit(){const e=(~~(1e3*Math.random())).toString(),t=document.createElement("template");t.innerHTML=function(e){return`\n<div class="tree-header">\n  <i class="dt-tree-icon dt-icon-shrink large" id="collapseAllIcon${e}"></i>\n  <i class="dt-tree-icon dt-icon-reload large" id="refreshIcon${e}"></i>\n  <div class="dt-clearable-input tree-filter-input">\n    <input class="dt-input" id="filterInput${e}">\n    <span class="dt-loader dt-tree-filter-loading" id="filterLoading${e}"></span>\n    <span id="clearSearchIcon${e}">&times;</span>\n  </div>\n</div>\n<div class="tree-body">\n  <div id="loadingIcon${e}" class="tree-loading-content"><i class="dt-loader"></i></div>\n  <ul class="tree-container" id="treeContainer${e}" style="padding-left: 0;"></ul>\n</div>\n  `}(e),this.append(t.content.cloneNode(!0)),this.treeContainer=this.querySelector("#treeContainer"+e),this.loadingIcon=this.querySelector("#loadingIcon"+e),this.filterInput=this.querySelector("#filterInput"+e),this.filterLoading=this.querySelector("#filterLoading"+e),this.clearSearchIcon=this.querySelector("#clearSearchIcon"+e),this.collapseAllIcon=this.querySelector("#collapseAllIcon"+e),this.refreshIcon=this.querySelector("#refreshIcon"+e),this.loading(!1),this.filterInput.placeholder="Search",this.addEventListeners()}addEventListeners(){this.listeners=[{eventName:"click",target:this,handler:this.onClick.bind(this)},{eventName:"dblclick",target:this,handler:this.onDblClick.bind(this)},{eventName:"contextmenu",target:this,handler:this.onContextMenu.bind(this)},{eventName:"input",target:this.filterInput,handler:this.onInputFilter.bind(this)},{eventName:"click",target:this.clearSearchIcon,handler:this.onClickClearSearch.bind(this)},{eventName:"click",target:this.collapseAllIcon,handler:this.collapseAll.bind(this)},{eventName:"click",target:this.refreshIcon,handler:this.refresh.bind(this)}],this.listeners.forEach(e=>{e.target.addEventListener(e.eventName,e.handler)})}removeEventListeners(){this.listeners.forEach(e=>{e.target.removeEventListener(e.eventName,e.handler)})}initGetNodes(){this.loading(!0),this.tree.initLoadNodes().then(()=>{this.render()}).finally(()=>{this.loading(!1)})}loading(e){this.loadingIcon.style.display=e?"block":"none"}render(){const e=document.createDocumentFragment();this.tree.nodes.forEach(t=>{const n=this.createTreeDom(t);e.append(n)}),this.treeContainer.innerHTML="",this.treeContainer.append(e)}createTreeDom(e,t){const n=t||new o(e,this.getIconFunc);if(this.treeViewNodes.push(n),e.hasChildren){const t=document.createElement("ul");t.classList.add("tree-container"),n.element.append(t),r(e.expanded,t),e.children.forEach(e=>{const n=this.createTreeDom(e);t.append(n)})}return n.element}updateAllItemsStyles(){this.treeViewNodes.forEach(e=>e.updateStyles())}updateClearSearchIconStyles(){this.clearSearchIcon.style.display=this.filterInput.value.length>0&&!this.tree.filterLoading?"block":"none"}updateFilterLoadingStyles(e){this.updateClearSearchIconStyles(),this.filterLoading.style.display=e?"block":"none"}onExpand(e){const t=e.node,n=this.needCreateElements(t);t.expanded=!t.expanded,t.expanded&&(t.$$loading=!0,e.updateStyles(),t.tree.loadNode(t).then(()=>{n&&this.createTreeDom(e.node,e)}).finally(()=>{t.$$loading=!1,e.updateStyles()})),this.updateAllItemsStyles()}needCreateElements(e){if(!e.hasChildren)return!0;return!e.children.some(e=>this.treeViewNodes.find(t=>t.node.$$id===e.$$id))}getTreeViewNode(e,t){const n=e.target,i=n.classList.contains(t)?n:n.closest("."+t);if(i&&i.parentElement){const t=i.parentElement.dataset.id;if(Object(s.isBlank)(t))return;e.stopPropagation();return this.treeViewNodes.find(e=>e.node.$$id.toString()===t)}}onClick(e){this.onClickTreenodeContent(e),this.onClickExpanderIcon(e)}onClickTreenodeContent(e){const t=this.getTreeViewNode(e,"treenode-content");t&&(this.selectNode(t),this.updateAllItemsStyles())}onClickExpanderIcon(e){const t=this.getTreeViewNode(e,"dt-icon-node");t&&this.onExpand(t)}onDblClick(e){const t=this.getTreeViewNode(e,"treenode-content");t&&this.onExpand(t)}onContextMenu(e){const t=this.getTreeViewNode(e,"treenode-content");if(t){this.selectNode(t),this.updateAllItemsStyles();const n={originalEvent:e,data:t.node};this.dispatchEvent(new CustomEvent("nodeRightClick",{detail:n}))}}selectNode(e){this.tree.selectedNode!==e.node&&(e.node.setSelected(),this.dispatchEvent(new CustomEvent("selectedChanged",{detail:e.node})))}onInputFilter(){this.filterTimeout&&clearTimeout(this.filterTimeout),this.filterTimeout=setTimeout(()=>{this.updateClearSearchIconStyles(),this.tree.filterTree(this.filterInput.value).then(()=>{this.updateAllItemsStyles()}),this.filterTimeout=null},this.filterDelay)}onClickClearSearch(){this.filterInput.value="",this.updateClearSearchIconStyles(),this.tree.filterTree(this.filterInput.value).then(()=>{this.updateAllItemsStyles()})}collapseAll(){this.tree.collapseAll(),this.updateAllItemsStyles()}refresh(){this.tree.nodes=[],this.initGetNodes(),this.tree.selectedNode=null,this.filterInput.value=null}}customElements.define("web-tree-view",d);var l=n(119);n(90);class a{get template(){return'<web-tree-view class="tree-view-demo"></web-tree-view>\n    <web-context-menu id="contextMenu"></web-context-menu>'}load(){const e=new l.a,t=document.querySelector("web-tree-view");t.getIconFunc=e=>e.isLeaf()?"dt-icon-file":"dt-icon-folder",t.serverSideFiltering=!0,t.service=e;const n=[{label:"View Task",command:e=>console.log("View "+e)},{label:"Edit Task",command:e=>console.log("Edit "+e)},{label:"Delete Task",command:e=>console.log("Delete "+e),disabled:!0}],i=document.querySelector("#contextMenu");i.menu=n,t.addEventListener("selectedChanged",e=>{console.log(e.detail)}),t.addEventListener("nodeRightClick",e=>{i.show({originalEvent:e.detail.originalEvent,data:e.detail.data})})}}},74:function(e,t,n){"use strict";n.d(t,"a",(function(){return s})),n.d(t,"b",(function(){return o}));var i=n(0);class s{constructor(e){this.element=e,this.addEventListeners()}addEventListeners(){this.clickListener=this.onClick.bind(this),this.element.addEventListener("click",this.clickListener),this.windowClickListener=this.onWindowClick.bind(this),window.document.addEventListener("click",this.windowClickListener),this.windowKeydownListener=this.onKeyDown.bind(this),window.document.addEventListener("keydown",this.windowKeydownListener)}removeEventListeners(){this.element.removeEventListener("click",this.clickListener),window.document.removeEventListener("click",this.windowClickListener),window.document.removeEventListener("keydown",this.windowKeydownListener)}onClick(){this.selectContainerClicked=!0}onWindowClick(){this.selectContainerClicked||this.closeDropdown(),this.selectContainerClicked=!1}onKeyDown(e){e.keyCode!==i.Keys.ESCAPE&&"Escape"!==e.key||this.closeDropdown()}toggleDropdown(){this.isOpen?this.closeDropdown():this.openDropdown()}openDropdown(){this.isOpen||(this.isOpen=!0,this.element.dispatchEvent(new CustomEvent("open",{detail:this.isOpen})))}closeDropdown(){this.isOpen&&(this.isOpen=!1,this.element.dispatchEvent(new CustomEvent("open",{detail:this.isOpen})))}}class r{constructor(e){this.element=e,this.isOpen=!1,this.listeners=[],this.addEventListeners()}set clickedElement(e){e!==this.element&&this.isOpen&&(this.isOpen=!1,this.updateStyles())}addEventListeners(){this.listeners=[{eventName:"click",target:this.element,handler:this.toggleDropdown.bind(this)}],this.listeners.forEach(e=>{e.target.addEventListener(e.eventName,e.handler)})}removeEventListeners(){this.listeners.forEach(e=>{e.target.removeEventListener(e.eventName,e.handler)})}toggle(){this.isOpen=!this.isOpen}toggleDropdown(e){e.stopPropagation(),this.toggle(),this.updateStyles(),this.element.dispatchEvent(new CustomEvent("clickElement",{detail:this.element}))}onWindowClick(e){const t=e.target;if(!t)return;this.element.contains(t)||(this.isOpen=!1),this.updateStyles()}updateStyles(){this.isOpen?this.element.classList.add("open"):this.element.classList.remove("open")}}class o{constructor(e){this.dropdowns=[],this.listeners=[],e.forEach(e=>{this.dropdowns.push(new r(e))}),this.addEventListeners(e)}destroy(){this.removeEventListeners(),this.dropdowns.forEach(e=>{e.removeEventListeners()})}addEventListeners(e){this.listeners=[{eventName:"click",target:window,handler:this.onWindowClick.bind(this)}],e.forEach(e=>{this.listeners.push({eventName:"clickElement",target:e,handler:this.onClickElement.bind(this)})}),this.listeners.forEach(e=>{e.target.addEventListener(e.eventName,e.handler)})}removeEventListeners(){this.listeners.forEach(e=>{e.target.removeEventListener(e.eventName,e.handler)})}onWindowClick(e){this.dropdowns.forEach(t=>{t.onWindowClick(e)})}onClickElement(e){this.dropdowns.forEach(t=>{t.clickedElement=e.detail})}}},78:function(e,t,n){"use strict";n.d(t,"d",(function(){return i})),n.d(t,"b",(function(){return d})),n.d(t,"c",(function(){return l})),n.d(t,"e",(function(){return a})),n.d(t,"a",(function(){return r}));class i{constructor(e){this.transformFunction=e}_flattenNode(e,t,n,i){const s=this.transformFunction(e,t);if(n.push(s),s.expandable){const s=e.children;Array.isArray(s)?this._flattenChildren(s,t,n,i):this._flattenChildren(s[0],t,n,i)}return n}_flattenChildren(e,t,n,i){e.forEach((s,r)=>{const o=i.slice();o.push(r!==e.length-1),this._flattenNode(s,t+1,n,o)})}flattenNodes(e){const t=[];return e.forEach(e=>this._flattenNode(e,0,t,[])),t}}class s{constructor(e,t,n){this.tree=n,this.id=e.id,this.name=e.name,this.data=e.data,this.icon=e.icon,this.expanded=e.expanded,this.leaf=e.leaf,this.parent=t,this.$$id=this.tree.generateId(),this.$$level=t?t.$$level+1:0,this.children=e.children}get children(){return this._children}set children(e){this._children=[],e&&(this._children=e.map(e=>new s(e,this,this.tree)))}get path(){return this.parent?[...this.parent.path,this.id]:[]}get hasChildren(){return this.children&&this.children.length>0}get isSelected(){return this===this.tree.selectedNode}setSelected(){this.tree.selectedNode=this}isLeaf(){return!1!==this.leaf&&!this.hasChildren}ensureVisible(){return this.parent&&(this.parent.expanded=!0,this.parent.ensureVisible()),this}}var r;!function(e){e[e.FOUND=0]="FOUND",e[e.ON_FOUND_PATH=1]="ON_FOUND_PATH",e[e.NOT_FOUND=2]="NOT_FOUND"}(r||(r={}));var o=n(0);class d{constructor(){this.uidNode=0}get nodes(){return this._nodes}set nodes(e){this._nodes=[];for(const t of e)this._nodes.push(new s(t,null,this))}generateId(){return this.uidNode++}initLoadNodes(){return!this.service||this.nodes&&this.nodes.length?Promise.resolve():this.service.getNodes().then(e=>{this.nodes=e})}loadNode(e){return e.children&&0!==e.children.length||!1!==e.leaf?Promise.resolve():this.service?this.service.getNodes(e).then(t=>{this.addNode(e.$$id,t)}):void 0}addNode(e,t){this.nodes.forEach(n=>{this._addNode(n,e,t)})}_addNode(e,t,n){if(e.$$id===t)return e.children=n,!0;e.children&&e.children.forEach(e=>{this._addNode(e,t,n)})}doForAll(e){return this.doForEach(this.nodes,e)}filterTree(e){return this.serverSideFiltering?this.filterServerSide(e):(this.filterClientSide(e),Promise.resolve())}filterClientSide(e){if(!e.trim())return void this.clearSearchState();const t=n=>{let i=!1;if(n.name.toLowerCase().indexOf(e.toLowerCase())>=0?(n.$$filterState=r.FOUND,i=!0):(n.$$filterState=r.NOT_FOUND,n.expanded=!1,i=!1),n.children){n.children.map(t).find(e=>e)&&(n.$$filterState!==r.FOUND&&(n.$$filterState=r.ON_FOUND_PATH),n.expanded=!0,i=!0)}return i};this.nodes&&this.nodes.forEach(t)}clearSearchState(){return this.doForAll(e=>{e.$$filterState=null,e.expanded=!1})}getNodeById(e){return this.getNodeBy(t=>t.id&&t.id.toString()===e.toString())}getNodeBy(e,t=null){if(!(t=t||{children:this.nodes}).children)return null;const n=t.children.find(e);if(n)return n;for(const n of t.children){const t=this.getNodeBy(e,n);if(t)return t}}getChildren(e){return e.children&&0!==e.children.length||!1!==e.leaf?Promise.resolve():this.service.getNodes(e).then(t=>{e.children=t})}doForEach(e,t){return Promise.all(e.map(e=>Promise.resolve(t(e)).then(()=>{if(e.children)return this.doForEach(e.children,t)}),this))}expandAll(){this.doForEach(this.nodes,e=>(e.expanded=!0,this.getChildren(e))).then()}collapseAll(){this.doForEach(this.nodes,e=>{e.expanded=!1}).then()}loadPath(e){return e&&e.length?Promise.all(e.map(e=>this.doForEach(this.nodes,t=>{if(t.id===e)return this.getChildren(t)}),this)).then(()=>(e.shift(),this.loadPath(e))):Promise.resolve()}filterServerSide(e){return Object(o.isBlank)(e)?this.clearSearchState():this.service?(this.filterLoading=!0,this.filterLoadingFunc&&this.filterLoadingFunc(!0),this.service.searchNodes(e).then(t=>this.loadPath(t).then(()=>{this.filterClientSide(e),this.filterLoading=!1,this.filterLoadingFunc&&this.filterLoadingFunc(!1)}))):void 0}}class l{static rowsToTree(e,t,n){const i={},s=[];for(const t of e){const e=t[n];i[e]={id:e,name:t.name?t.name:null,data:Object.assign({},t),icon:t.icon?t.icon:null,children:[]}}for(const r of e){const e=i[r[n]],o=e.data[t];0!==o?i[o].children.push(e):s.push(e)}return s}}class a{static getExpanderIcon(e){let t;return e.$$loading&&!e.isLeaf()?"dt-loader":(e.isLeaf()||e.expanded?e.isLeaf()||(t="dt-icon-node"):t="dt-icon-node dt-icon-collapsed",t)}}},82:function(e,t,n){"use strict";var i=n(74),s=n(0);class r extends HTMLElement{constructor(){super(),this._menu=[],this.listeners=[]}get menu(){return this._menu}set menu(e){this._menu=e,this.render()}connectedCallback(){this.isInitialized||(this.onInit(),this.isInitialized=!0)}disconnectedCallback(){this.dropdown.removeEventListeners(),this.removeEventListeners()}onInit(){this.listMenu=document.createElement("ul"),this.append(this.listMenu),this.classList.add("dt-context-menu"),this.dropdown=new i.a(this),this.addEventListeners()}addEventListeners(){this.listeners=[{eventName:"open",target:this,handler:this.onOpenChange.bind(this)},{eventName:"resize",target:window,handler:this.onWindowResize.bind(this)},{eventName:"click",target:this.listMenu,handler:this.onClickListMenu.bind(this)}],this.listeners.forEach(e=>{e.target.addEventListener(e.eventName,e.handler)})}removeEventListeners(){this.listeners.forEach(e=>{e.target.removeEventListener(e.eventName,e.handler)})}onWindowResize(){this.dropdown.closeDropdown()}getPositionMenu(e,t){const{height:n,width:i}=this.getHiddenElementOuterSizes(this);return e+i-window.pageXOffset>window.innerWidth&&(e-=i),t+n-window.pageYOffset>window.innerHeight&&(t-=n),{left:e,top:t}}getHiddenElementOuterSizes(e){if(e.offsetParent)return{height:e.offsetHeight,width:e.offsetWidth};e.style.visibility="hidden",e.style.display="block";const t=e.offsetHeight,n=e.offsetWidth;return e.style.display="none",e.style.visibility="visible",{height:t,width:n}}show(e){let t;this.eventArgs=e,Object(s.isBlank)(e.left)||Object(s.isBlank)(e.top)?t=this.getPositionMenu(e.originalEvent.pageX+1,e.originalEvent.pageY+1):(t=this.getPositionMenu(e.left,e.top),this.dropdown.selectContainerClicked=!0),e.originalEvent.preventDefault(),this.top===t.top&&this.left===t.left?this.dropdown.toggleDropdown():(this.top=t.top,this.left=t.left,this.dropdown.closeDropdown(),this.dropdown.openDropdown())}hide(){this.dropdown.closeDropdown()}itemClick(e,t){t.disabled?e.preventDefault():(t.url||e.preventDefault(),t.command&&t.command(this.eventArgs.data),this.dropdown.closeDropdown())}updateStyles(){this.style.left=this.left+"px",this.style.top=this.top+"px",this.style.display=this.dropdown.isOpen&&this.menu.length>0?"block":"none"}onOpenChange(){this.updateStyles()}render(){const e=this.createListContent();this.listMenu.textContent="",this.listMenu.append(...e),this.updateStyles()}createListContent(){const e=[];return this.menu.forEach((t,n)=>{const i=document.createElement("li");t.disabled&&i.classList.add("disabled");const s=document.createElement("a");s.href=t.url||"#",s.textContent=t.label,s.dataset.id=n.toString(),i.append(s);const r=document.createElement("span");r.classList.add("context-menu-sep"),s.prepend(r);const o=document.createElement("i");t.icon&&o.classList.add(...t.icon),s.prepend(o),e.push(i)}),e}getDataId(e){const t="A"===e.tagName?e:e.closest("a");return t&&t.dataset.id?t.dataset.id:null}onClickListMenu(e){const t=this.getDataId(e.target);if(null!=t){const n=parseInt(t,10);this.itemClick(e,this.menu[n])}}}customElements.define("web-context-menu",r)},83:function(e,t){},90:function(e,t,n){"use strict";n(82),n(83)}}]);