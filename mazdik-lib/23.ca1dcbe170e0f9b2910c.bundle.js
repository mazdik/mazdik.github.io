(window.webpackJsonp=window.webpackJsonp||[]).push([[23],{68:function(e,t,n){"use strict";n.r(t),n.d(t,"default",(function(){return d}));var i=n(74),s=n(75),a=n(81);class r{constructor(e,t,n){this.getIconFunc=e,this.getExpanderIconFunc=t,this.onExpandFunc=n,this.elements=new Map,this.contentIcons=new Map,this.listeners=[],this.indent=10}create(e){const{cell:t}=e,n=document.createElement("div");n.classList.add("datatable-tree-node");const i=document.createElement("i");n.append(i);const s=document.createElement("span");s.classList.add("datatable-tree-node-content"),n.append(s);const a=document.createElement("i");s.append(a);const r=document.createTextNode(t.row.name);return s.append(r),this.addListener({eventName:"click",target:i,handler:this.onExpand.bind(this,e)}),this.addListener({eventName:"dblclick",target:s,handler:this.onExpand.bind(this,e)}),this.elements.set(t,n),this.contentIcons.set(t,a),this.refresh(e),n}destroy(){this.removeEventListeners(),this.elements.forEach(e=>e.remove()),this.elements.clear()}refresh(e){const{cell:t}=e,n=this.elements.get(t);n&&(n.style.paddingLeft=this.paddingIndent(t.row)+"px",n.firstElementChild.className=this.getExpanderIcon(t.row));this.contentIcons.get(t).className=this.getIcon(t.row)}addListener(e){this.listeners.push(e),e.target.addEventListener(e.eventName,e.handler)}removeEventListeners(){this.listeners.forEach(e=>{e.target.removeEventListener(e.eventName,e.handler)})}getExpanderIcon(e){return this.getExpanderIconFunc?this.getExpanderIconFunc(e):""}getIcon(e){return this.getIconFunc?this.getIconFunc(e):""}paddingIndent(e){return e.$$level*this.indent}onExpand(e){const{cell:t}=e;this.onExpandFunc(t.row),this.refresh(e)}}class l{constructor(e){this.columnIndex=e,this.elements=new Map,this.listeners=[]}create(e){const{cell:t,table:n}=e,i=document.createElement("span");return i.textContent=this.getSum(t,n),this.addListener({eventName:"cell",target:n.events.element,handler:this.onCell.bind(this,e)}),this.elements.set(t,i),i}destroy(){this.removeEventListeners(),this.elements.forEach(e=>e.remove()),this.elements.clear()}refresh(e){const{cell:t,table:n}=e;this.elements.get(t).textContent=this.getSum(t,n)}addListener(e){this.listeners.push(e),e.target.addEventListener(e.eventName,e.handler)}removeEventListeners(){this.listeners.forEach(e=>{e.target.removeEventListener(e.eventName,e.handler)})}getSum(e,t){if(e.value)return e.value;const n=this.getDescendants(e.row,t.rows);if(n&&n.length){let t=0;return n.forEach(n=>t+=parseFloat(n[e.column.name]||0)),t}}getDescendants(e,t){const n=[];for(let i=e.$$index+1;i<t.length&&e.$$level<t[i].$$level;i++)n.push(t[i]);return n}onCell(e,t){const n=t.detail;n.type===i.CellEventType.ValueChanged&&n.columnIndex===this.columnIndex&&this.refresh(e)}}class d{constructor(){this.listeners=[],this.transformer=(e,t)=>{const n={expandable:!0,$$level:t,expanded:!1,hasChildren:e.children&&e.children.length>0};return Object.assign(n,e.data)}}get template(){return"<p>Editable if last level. Summed column Cube size if has children rows</p>\n    <web-data-table></web-data-table>"}load(){this.dt=document.querySelector("web-data-table");const e=new i.Settings({paginator:!1,filter:!1,sortable:!1,rowClass:this.getRowClass,isEditableCellProp:"$$editable",rowHeightProp:"$$height",selectionMultiple:!0,selectionMode:"checkbox"}),t=Object(s.d)(),n=new r(this.getIcon,this.getExpanderIcon,this.onExpand.bind(this));t[0].cellTemplate=n,t[3].cellTemplate=new l(4),this.table=new i.DataTable(t,e),this.table.pager.perPage=1e3,this.treeFlattener=new a.d(this.transformer),this.dt.table=this.table,this.table.events.emitLoading(!0),fetch("assets/tree.json").then(e=>e.json()).then(e=>{this.table.rows=this.prepareTreeData(e),this.table.events.emitLoading(!1)}),this.addEventListeners()}onDestroy(){this.removeEventListeners()}prepareTreeData(e){const t=new a.b;t.nodes=e;const n=this.treeFlattener.flattenNodes(t.nodes);return n.forEach(e=>{e.$$height=e.$$level>1?0:null,e.expanded=!(e.$$level>0),e.$$editable=!e.hasChildren,e.cube_size=e.hasChildren?null:e.cube_size}),n}getRowClass(e){return{"row-warrior":e.$$editable,"row-sorcerer":0===e.$$level}}onExpand(e){if(e.expanded=!e.expanded,e.expanded){this.getDescendantsByLevel(e,this.table.rows,e.$$level+1).forEach(e=>{e.$$height=null,e.expanded=!1})}else{const t=this.getDescendants(e,this.table.rows);t&&t.length&&t.forEach(e=>{e.$$height=0,e.expanded=!0})}this.dt.updateAllStyles()}getDescendants(e,t){const n=[];for(let i=e.$$index+1;i<t.length&&e.$$level<t[i].$$level;i++)n.push(t[i]);return n}getDescendantsByLevel(e,t,n){const i=[];for(let s=e.$$index+1;s<t.length&&e.$$level<t[s].$$level;s++)t[s].$$level===n&&i.push(t[s]);return i}addEventListeners(){this.listeners=[{eventName:"checkbox",target:this.table.events.element,handler:this.onCheckbox.bind(this)}],this.listeners.forEach(e=>{e.target.addEventListener(e.eventName,e.handler)})}removeEventListeners(){this.listeners.forEach(e=>{e.target.removeEventListener(e.eventName,e.handler)})}onCheckbox(e){this.selectionToggle(e.detail)}selectionToggle(e){let t=this.getDescendants(e,this.table.rows);t=t.map(e=>e.$$index),this.table.selection.isSelected(e.$$index)?this.table.selection.select(...t):this.table.selection.deselect(...t)}getExpanderIcon(e){return e.hasChildren&&!e.expanded?"dt-icon-node dt-icon-collapsed":e.hasChildren?"dt-icon-node":void 0}getIcon(e){return e.hasChildren?"dt-icon-folder":"dt-icon-file"}}},75:function(e,t,n){"use strict";n.d(t,"b",(function(){return s})),n.d(t,"c",(function(){return a})),n.d(t,"a",(function(){return r})),n.d(t,"d",(function(){return l}));var i=n(0);function s(){return[{title:"Id",name:"id",sortable:!0,filter:!0,frozen:!0,width:100,formHidden:!0,type:"number"},{title:"Name",name:"name",sortable:!0,filter:!0,frozen:!0,width:200,validatorFunc:i.Validators.get({required:!0,minLength:2,pattern:"^[a-zA-Z ]+$"})},{title:"Race",name:"race",sortable:!0,filter:!0,type:"select",options:[{id:"ASMODIANS",name:"ASMODIANS"},{id:"ELYOS",name:"ELYOS"}],validatorFunc:i.Validators.get({required:!0})},{title:"Cascading Select",name:"note",type:"select-dropdown",options:[{id:"ASM1",name:"ASM note 1",parentId:"ASMODIANS"},{id:"ASM2",name:"ASM note 2",parentId:"ASMODIANS"},{id:"ASM3",name:"ASM note 3",parentId:"ASMODIANS"},{id:"ASM4",name:"ASM note 4",parentId:"ASMODIANS"},{id:"ELY1",name:"ELY note 1",parentId:"ELYOS"},{id:"ELY2",name:"ELY note 2",parentId:"ELYOS"},{id:"ELY3",name:"ELY note 3",parentId:"ELYOS"}],dependsColumn:"race",multiSelectFilter:!0},{title:"Gender",name:"gender",sortable:!0,filter:!0,type:"radio",options:[{id:"MALE",name:"MALE"},{id:"FEMALE",name:"FEMALE"}]},{title:"Exp",name:"exp",sortable:!0,filter:!0,type:"number",validatorFunc:i.Validators.get({required:!0,maxLength:10,pattern:"^[0-9]+$"})},{title:"Last online",name:"last_online",sortable:!0,filter:!0,type:"datetime-local"},{title:"Account name",name:"account_name",type:"select-modal",optionsUrl:"assets/accounts.json",keyColumn:"account_id"},{title:"Account id",name:"account_id"},{title:"Player class",name:"player_class"},{title:"Online",name:"online",type:"checkbox",options:[{id:"1",name:"Online"}]},{title:"Cube size",name:"cube_size",type:"number"},{title:"Broker Kinah",name:"brokerKinah"},{title:"Bind point",name:"bind_point"},{title:"X",name:"x"},{title:"Y",name:"y"},{title:"Z",name:"z"},{title:"Recoverexp",name:"recoverexp"},{title:"Heading",name:"heading"},{title:"World id",name:"world_id"},{title:"Creation date",name:"creation_date",type:"datetime-local"},{title:"Stigma slot size",name:"advanced_stigma_slot_size"},{title:"Warehouse size",name:"warehouse_size"},{title:"Mailbox Letters",name:"mailboxLetters"},{title:"Mailbox Unread",name:"mailboxUnReadLetters"},{title:"Title id",name:"title_id"},{title:"Repletion state",name:"repletionstate"},{title:"Rebirth id",name:"rebirth_id"},{title:"Member points",name:"memberpoints"},{title:"Quest status",name:"quest.status"}]}function a(){return[{title:"player_id",name:"player_id",width:100},{title:"daily_ap",name:"daily_ap",width:100},{title:"weekly_ap",name:"weekly_ap",width:100},{title:"ap",name:"ap",width:100},{title:"rank",name:"rank",width:100},{title:"top_ranking",name:"top_ranking",width:100},{title:"old_ranking",name:"old_ranking",width:100},{title:"daily_kill",name:"old_ranking",width:100},{title:"weekly_kill",name:"weekly_kill",width:100},{title:"all_kill",name:"all_kill",width:100},{title:"max_rank",name:"max_rank",width:100},{title:"last_kill",name:"last_kill",width:100},{title:"last_ap",name:"last_ap",width:100},{title:"last_update",name:"last_update",width:120}]}function r(){return[{title:"itemUniqueId",name:"itemUniqueId",width:100},{title:"itemId",name:"itemId",width:100},{title:"itemCount",name:"itemCount",width:100},{title:"itemColor",name:"itemColor",width:100},{title:"itemOwner",name:"itemOwner",width:100},{title:"itemCreationTime",name:"itemCreationTime"},{title:"itemExistTime",name:"itemExistTime"},{title:"itemTradeTime",name:"itemTradeTime"},{title:"isEquiped",name:"isEquiped"},{title:"isSoulBound",name:"isSoulBound"},{title:"slot",name:"slot"},{title:"sealEndTime",name:"sealEndTime"}]}function l(){return[{title:"Node",name:"node",frozen:!0,width:250},{title:"Name",name:"name",editable:!0,validatorFunc:i.Validators.get({required:!0,minLength:2,pattern:"^[a-zA-Z ]+$"}),width:250},{title:"Gender",name:"gender",editable:!0,type:"radio",options:[{id:"MALE",name:"MALE"},{id:"FEMALE",name:"FEMALE"}],width:250},{title:"Cube size",name:"cube_size",editable:!0,width:250,type:"number"},{title:"Exp",name:"exp",editable:!0,width:250}]}},81:function(e,t,n){"use strict";n.d(t,"d",(function(){return i})),n.d(t,"b",(function(){return l})),n.d(t,"c",(function(){return d})),n.d(t,"e",(function(){return o})),n.d(t,"a",(function(){return a}));class i{constructor(e){this.transformFunction=e}_flattenNode(e,t,n,i){const s=this.transformFunction(e,t);if(n.push(s),s.expandable){const s=e.children;Array.isArray(s)?this._flattenChildren(s,t,n,i):this._flattenChildren(s[0],t,n,i)}return n}_flattenChildren(e,t,n,i){e.forEach((s,a)=>{const r=i.slice();r.push(a!==e.length-1),this._flattenNode(s,t+1,n,r)})}flattenNodes(e){const t=[];return e.forEach(e=>this._flattenNode(e,0,t,[])),t}}class s{constructor(e,t,n){this.tree=n,this.id=e.id,this.name=e.name,this.data=e.data,this.icon=e.icon,this.expanded=e.expanded,this.leaf=e.leaf,this.parent=t,this.$$id=this.tree.generateId(),this.$$level=t?t.$$level+1:0,this.children=e.children}get children(){return this._children}set children(e){this._children=[],e&&(this._children=e.map(e=>new s(e,this,this.tree)))}get path(){return this.parent?[...this.parent.path,this.id]:[]}get hasChildren(){return this.children&&this.children.length>0}get isSelected(){return this===this.tree.selectedNode}setSelected(){this.tree.selectedNode=this}isLeaf(){return!1!==this.leaf&&!this.hasChildren}ensureVisible(){return this.parent&&(this.parent.expanded=!0,this.parent.ensureVisible()),this}}var a;!function(e){e[e.FOUND=0]="FOUND",e[e.ON_FOUND_PATH=1]="ON_FOUND_PATH",e[e.NOT_FOUND=2]="NOT_FOUND"}(a||(a={}));var r=n(0);class l{constructor(){this.uidNode=0}get nodes(){return this._nodes}set nodes(e){this._nodes=[];for(const t of e)this._nodes.push(new s(t,null,this))}generateId(){return this.uidNode++}initLoadNodes(){return!this.service||this.nodes&&this.nodes.length?Promise.resolve():this.service.getNodes().then(e=>{this.nodes=e})}loadNode(e){return e.children&&0!==e.children.length||!1!==e.leaf?Promise.resolve():this.service?this.service.getNodes(e).then(t=>{this.addNode(e.$$id,t)}):void 0}addNode(e,t){this.nodes.forEach(n=>{this._addNode(n,e,t)})}_addNode(e,t,n){if(e.$$id===t)return e.children=n,!0;e.children&&e.children.forEach(e=>{this._addNode(e,t,n)})}doForAll(e){return this.doForEach(this.nodes,e)}filterTree(e){return this.serverSideFiltering?this.filterServerSide(e):(this.filterClientSide(e),Promise.resolve())}filterClientSide(e){if(!e.trim())return void this.clearSearchState();const t=n=>{let i=!1;if(n.name.toLowerCase().indexOf(e.toLowerCase())>=0?(n.$$filterState=a.FOUND,i=!0):(n.$$filterState=a.NOT_FOUND,n.expanded=!1,i=!1),n.children){n.children.map(t).find(e=>e)&&(n.$$filterState!==a.FOUND&&(n.$$filterState=a.ON_FOUND_PATH),n.expanded=!0,i=!0)}return i};this.nodes&&this.nodes.forEach(t)}clearSearchState(){return this.doForAll(e=>{e.$$filterState=null,e.expanded=!1})}getNodeById(e){return this.getNodeBy(t=>t.id&&t.id.toString()===e.toString())}getNodeBy(e,t=null){if(!(t=t||{children:this.nodes}).children)return null;const n=t.children.find(e);if(n)return n;for(const n of t.children){const t=this.getNodeBy(e,n);if(t)return t}}getChildren(e){return e.children&&0!==e.children.length||!1!==e.leaf?Promise.resolve():this.service.getNodes(e).then(t=>{e.children=t})}doForEach(e,t){return Promise.all(e.map(e=>Promise.resolve(t(e)).then(()=>{if(e.children)return this.doForEach(e.children,t)}),this))}expandAll(){this.doForEach(this.nodes,e=>(e.expanded=!0,this.getChildren(e))).then()}collapseAll(){this.doForEach(this.nodes,e=>{e.expanded=!1}).then()}loadPath(e){return e&&e.length?Promise.all(e.map(e=>this.doForEach(this.nodes,t=>{if(t.id===e)return this.getChildren(t)}),this)).then(()=>(e.shift(),this.loadPath(e))):Promise.resolve()}filterServerSide(e){return Object(r.isBlank)(e)?this.clearSearchState():this.service?(this.filterLoading=!0,this.filterLoadingFunc&&this.filterLoadingFunc(!0),this.service.searchNodes(e).then(t=>this.loadPath(t).then(()=>{this.filterClientSide(e),this.filterLoading=!1,this.filterLoadingFunc&&this.filterLoadingFunc(!1)}))):void 0}}class d{static rowsToTree(e,t,n){const i={},s=[];for(const t of e){const e=t[n];i[e]={id:e,name:t.name?t.name:null,data:Object.assign({},t),icon:t.icon?t.icon:null,children:[]}}for(const a of e){const e=i[a[n]],r=e.data[t];0!==r?i[r].children.push(e):s.push(e)}return s}}class o{static getExpanderIcon(e){let t;return e.$$loading&&!e.isLeaf()?"dt-loader":(e.isLeaf()||e.expanded?e.isLeaf()||(t="dt-icon-node"):t="dt-icon-node dt-icon-collapsed",t)}}}}]);