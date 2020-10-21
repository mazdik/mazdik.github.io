(window.webpackJsonp=window.webpackJsonp||[]).push([[28],{64:function(e,t,i){"use strict";i.r(t),i.d(t,"default",(function(){return r}));var n=i(68),a=i(69);class l{constructor(){this.elements=new Map}create(e){const t=document.createElement("div");t.classList.add("datatable-header-row");const i=this.createElement(t,"Group 1",[0,2]);return i.classList.add("dt-sticky"),i.style.left="0",this.createElement(t,"Group 2",[2,5]),this.createElement(t,"Group 3",[5,8]),this.createElement(t,"Group 4",[8,12]),this.createElement(t,"Group 5",[12,17]),this.refresh(e),t}destroy(){this.elements.clear()}refresh(e){const{table:t}=e;this.elements.forEach((e,i)=>{e.style.width=this.getWidth(t,i[0],i[1])+"px"})}createElement(e,t,i){const n=document.createElement("div");return n.classList.add("datatable-header-cell"),n.textContent=t,e.append(n),this.elements.set(i,n),n}getWidth(e,t,i){let n=0;for(let a=t;a<i;a++)n+=e.columns[a].width;return n}}class r{get template(){return'<web-data-table class="dt-column-group-demo"></web-data-table>'}load(){const e=document.querySelector("web-data-table"),t=Object(a.b)();t.splice(17);const i=new n.Settings({columnGroupTemplate:new l}),r=new n.DataTable(t,i);e.table=r,r.events.emitLoading(!0),fetch("assets/players.json").then(e=>e.json()).then(e=>{r.rows=e,r.events.emitLoading(!1)})}}},69:function(e,t,i){"use strict";i.d(t,"b",(function(){return a})),i.d(t,"c",(function(){return l})),i.d(t,"a",(function(){return r}));var n=i(0);function a(){return[{title:"Id",name:"id",sortable:!0,filter:!0,frozen:!0,width:100,formHidden:!0,type:"number"},{title:"Name",name:"name",sortable:!0,filter:!0,frozen:!0,width:200,validatorFunc:n.Validators.get({required:!0,minLength:2,pattern:"^[a-zA-Z ]+$"})},{title:"Race",name:"race",sortable:!0,filter:!0,type:"select",options:[{id:"ASMODIANS",name:"ASMODIANS"},{id:"ELYOS",name:"ELYOS"}],validatorFunc:n.Validators.get({required:!0})},{title:"Cascading Select",name:"note",type:"select-dropdown",options:[{id:"ASM1",name:"ASM note 1",parentId:"ASMODIANS"},{id:"ASM2",name:"ASM note 2",parentId:"ASMODIANS"},{id:"ASM3",name:"ASM note 3",parentId:"ASMODIANS"},{id:"ASM4",name:"ASM note 4",parentId:"ASMODIANS"},{id:"ELY1",name:"ELY note 1",parentId:"ELYOS"},{id:"ELY2",name:"ELY note 2",parentId:"ELYOS"},{id:"ELY3",name:"ELY note 3",parentId:"ELYOS"}],dependsColumn:"race",multiSelectFilter:!0},{title:"Gender",name:"gender",sortable:!0,filter:!0,type:"radio",options:[{id:"MALE",name:"MALE"},{id:"FEMALE",name:"FEMALE"}]},{title:"Exp",name:"exp",sortable:!0,filter:!0,type:"number",validatorFunc:n.Validators.get({required:!0,maxLength:10,pattern:"^[0-9]+$"})},{title:"Last online",name:"last_online",sortable:!0,filter:!0,type:"datetime-local"},{title:"Account name",name:"account_name",type:"select-modal",optionsUrl:"assets/accounts.json",keyColumn:"account_id"},{title:"Account id",name:"account_id"},{title:"Player class",name:"player_class"},{title:"Online",name:"online",type:"checkbox",options:[{id:"1",name:"Online"}]},{title:"Cube size",name:"cube_size",type:"number"},{title:"Broker Kinah",name:"brokerKinah"},{title:"Bind point",name:"bind_point"},{title:"X",name:"x"},{title:"Y",name:"y"},{title:"Z",name:"z"},{title:"Recoverexp",name:"recoverexp"},{title:"Heading",name:"heading"},{title:"World id",name:"world_id"},{title:"Creation date",name:"creation_date",type:"datetime-local"},{title:"Stigma slot size",name:"advanced_stigma_slot_size"},{title:"Warehouse size",name:"warehouse_size"},{title:"Mailbox Letters",name:"mailboxLetters"},{title:"Mailbox Unread",name:"mailboxUnReadLetters"},{title:"Title id",name:"title_id"},{title:"Repletion state",name:"repletionstate"},{title:"Rebirth id",name:"rebirth_id"},{title:"Member points",name:"memberpoints"},{title:"Quest status",name:"quest.status"}]}function l(){return[{title:"player_id",name:"player_id",width:100},{title:"daily_ap",name:"daily_ap",width:100},{title:"weekly_ap",name:"weekly_ap",width:100},{title:"ap",name:"ap",width:100},{title:"rank",name:"rank",width:100},{title:"top_ranking",name:"top_ranking",width:100},{title:"old_ranking",name:"old_ranking",width:100},{title:"daily_kill",name:"old_ranking",width:100},{title:"weekly_kill",name:"weekly_kill",width:100},{title:"all_kill",name:"all_kill",width:100},{title:"max_rank",name:"max_rank",width:100},{title:"last_kill",name:"last_kill",width:100},{title:"last_ap",name:"last_ap",width:100},{title:"last_update",name:"last_update",width:120}]}function r(){return[{title:"itemUniqueId",name:"itemUniqueId",width:100},{title:"itemId",name:"itemId",width:100},{title:"itemCount",name:"itemCount",width:100},{title:"itemColor",name:"itemColor",width:100},{title:"itemOwner",name:"itemOwner",width:100},{title:"itemCreationTime",name:"itemCreationTime"},{title:"itemExistTime",name:"itemExistTime"},{title:"itemTradeTime",name:"itemTradeTime"},{title:"isEquiped",name:"isEquiped"},{title:"isSoulBound",name:"isSoulBound"},{title:"slot",name:"slot"},{title:"sealEndTime",name:"sealEndTime"}]}}}]);