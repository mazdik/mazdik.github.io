/* Динамический список с иконками */
declare
id number:=1;
sname varchar2(100);
begin
    sys.htp.p('<ul class="icon-blocks" id="reports_list">');
        sys.htp.p('<li data-id="'||id||'">');
        sys.htp.prn('<a href="'
            ||apex_util.prepare_url('f?p='||:APP_ID||':19:'||:APP_SESSION||'::::P19_ID:'||id)
            ||'" class="icon-block-item">');
        sys.htp.p('<span class="icon-container"><img src="#IMAGE_PREFIX#f_spacer.gif" alt="" class="dr-icon" /></span>');
        sys.htp.p('<h3>'||apex_escape.html(sname)||'</h3>');
        sys.htp.p('<p>'||apex_escape.html(sname)||'</p>');
        sys.htp.p('<p>'||apex_escape.html(sname)||'</p>');
        sys.htp.p('</a>');
        sys.htp.p('</li>');
    sys.htp.p('</ul>');
end;
------------------------------------------------------------------
/* Отчет с динамическими колонками */

--Processes -> Before Header
if apex_collection.collection_exists('DBA_TOTAL') = false then
APEX_COLLECTION.CREATE_COLLECTION_FROM_QUERY(
p_collection_name => 'DBA_TOTAL',
p_query => rad_pkg_total.f_query_for_report,
p_generate_md5 => 'YES');
end if;

--Interactive Report
select * from apex_collections 
where collection_name = 'DBA_TOTAL';
/*
Показывать колонку с условием
Column Attributes -> Conditional Display -> Exists (SQL query returns at least one row)
select 1 from apex_collections where c001 is not null;

Переименовать атрибуты колонок &P1_COL_HEAD1. до &P1_COL_HEAD50. (не забудьте точку)
*/
------------------------------------------------------------------
/* Oбновить название колонок в отчете с динамическими колонками */

grant select on APEX_040200.WWV_FLOW_WORKSHEETS to TEST;
grant select, update on APEX_040200.WWV_FLOW_WORKSHEET_COLUMNS to TEST;

--Processes -> Before Header
begin
  P_UPDATE_REPORT_COLUMN_ALL;
end;

--Пример для 1ой колонки:
  procedure P_UPDATE_REPORT_COLUMN(sLABEL         in varchar2,
                                   sREPORT        in varchar2 default 'total_report',
                                   nDISPLAY_ORDER in number) as
    PRAGMA AUTONOMOUS_TRANSACTION;
  begin
    begin
      update APEX_040200.WWV_FLOW_WORKSHEET_COLUMNS
         set column_label = sLABEL, report_label = sLABEL
       where id =
             (select t.id
                from APEX_040200.WWV_FLOW_WORKSHEET_COLUMNS t
               where t.worksheet_id = (select id
                                         from APEX_040200.WWV_FLOW_WORKSHEETS
                                        where name = sREPORT
                                          and flow_id = NV('APP_ID')
                                          and page_id = NV('APP_PAGE_ID'))
                 and t.display_order = nDISPLAY_ORDER /*13- C011*/
              );
    exception
      when others then
        null;
    end;
    COMMIT;
  end P_UPDATE_REPORT_COLUMN;

------------------------------------------------------------------
/*
Новые строки в <br> (New line to br)
htp.p(replace(l_text, chr(10), '<br>'));
*/
------------------------------------------------------------------
/* Cелекторы */
--Region Source:
select apex_item.checkbox(1,DB_LINK) a, d.* from dba_db_links d
/*
Column Attributes:
<input type="checkbox" onclick="$f_CheckFirstColumn(this);" >
Column Definition -> Allow Users To: убрать все
*/
--Процесс для теста:
DECLARE
   v_rowno NUMBER;
BEGIN
   for i in 1..apex_application.g_f01.count
   loop
      v_rowno := apex_application.g_f01(i);
      apex_debug_message.log_message('row# selected: '||v_rowno);
      apex_debug_message.log_message('Employee: '||apex_application.g_f03(v_rowno));
   end loop;
END;
apex_item.checkbox(1,''#ROW_NUM#'') --не проверял
apex_item.text(2,NAME) NAME
------------------------------------------------------------------
/*
Обновить отчет созданный на APEX_COLLECTION
Create Page Process -> Session State -> Type:
Clear Cache For Current Session (removes all state for current session)
When Button Pressed -> Привязать к кнопке
*/
------------------------------------------------------------------
/*
Для статуса цветные круги 16px на 16px
Page -> CSS -> Inline ->
.statusIcon {
	width: 16px;
	height: 16px;
	display: block;
	margin: 0 auto;
	background-image: url(#IMAGE_PREFIX#cloud/img/apps/cl_sprite.png);
	background-repeat: none;
	}
.statusIcon.clStatusRed {
		background-position: -78px 0;
	}
.statusIcon.clStatusYellow {
	background-position: -78px -16px;
	}
.statusIcon.clStatusGreen {
	background-position: -78px -32px;
	}
.statusIcon.clStatusBlack {
	background-position: -78px -48px;
	}
.statusIcon.clStatusNull {
	background-position: -94px 0;
   }
*/
select apex_item.checkbox(1, T.NAME) A,
       T.NAME,
       T.TEST_DATE,
       (case
         when T.TEST_STATUS = 1 then
          '<img src="#IMAGE_PREFIX#f_spacer.gif" alt="" class="statusIcon clStatusGreen" />'
         when T.TEST_STATUS = 0 then
          '<img src="#IMAGE_PREFIX#f_spacer.gif" alt="" class="statusIcon clStatusRed" />'
         else
          '<img src="#IMAGE_PREFIX#f_spacer.gif" alt="" class="statusIcon clStatusNull" />'
       end) TEST_STATUS
  from RAD_LINKS T
------------------------------------------------------------------
/* Выгрузка в EXCEL
1.Создать кнопку на странице
	тип кнопки "Redirect to Page in this App."
	PAGE -> 1 (на ту же самую страницу)
	REQUEST -> EXCEL
2.На странице процесс OnLoad - Before Header
	Condition Type -> Requesе = Expression 1
	Expression 1 -> EXCEL
3.Вставить этот текст в тело процесса
*/
begin
  P_DOWNLOAD_REPORT_XLSX;
end;

  procedure P_DOWNLOAD_REPORT_XLSX AS
    myfile_name VARCHAR2(64);
    myfile      BLOB;
  BEGIN
    begin
      as_xlsx.query2sheet('select * from dual');
      myfile := as_xlsx.finish;
    end;
    myfile_name := 'report_databases.xlsx';
    owa_util.mime_header(wwv_flow_utilities.get_excel_mime_type, false);
    htp.p('Content-Length: ' || dbms_lob.getlength(myfile));
    htp.p('Content-disposition: attachment; filename="' || myfile_name || '";');
    owa_util.http_header_close;
    wpg_docload.download_file(myfile);
  
  end P_DOWNLOAD_REPORT_XLSX;
------------------------------------------------------------------
/* Поиск с автокомплитом

Create Item -> 
Name: P3_SEARCH
Display As:	Text Field with autocomplete
Template: Hidden Label (Read by Screen Readers)
Lazy Loading: Yes
Maximum Values in List: 2
List of values definition: sql запрос для автоподстановки (union all - колонки в строки)
Value Placeholder: Поиск
HTML Form Element Attributes: style="margin-right: 8px;"
Source Type: Static Assignment (value equals source attribute)
Restricted Characters: Blacklist HTML command characters (<>")

Create Button ->
Position: Create a button displayed among this region's items
Button Name: P3_GO
Button Template: Button - Icon Only
CSS Classes: search

Edit Page->
CSS: #P3_SEARCH_CONTAINER {float: left;}

SQL Query (updateable report):
where
   (
   :P3_SEARCH is null or
   (instr(upper(e.ename),upper(:P3_SEARCH) ) > 0 or
    instr(upper(e.job),upper(:P3_SEARCH) ) > 0 or
    instr(upper(e.deptno),upper(:P3_SEARCH) ) > 0 )
   )
*/
------------------------------------------------------------------
/* APEX_MAIL
Настройки SMTP -> войти под ADMIN -> Workspace: INTERNAL
Instance Settings -> Email
*/
--Отправка email без сессии apex
DECLARE
    l_body CLOB;
BEGIN
   l_body := 'Тест 1.'||utl_tcp.crlf||utl_tcp.crlf;
   wwv_flow_api.set_security_group_id;
   apex_mail.send(
        p_to       => 'TO@AAA.COM',
        p_from     => 'FROM@AAA.COM',
        p_body     => l_body,
        p_subj     => 'тест 1');
END;
------------------------------------------------------------------
/* Сообщение после выполнения процесса: */
declare
nROWCOUNT number;
begin
rad_pkg_total.p_dba_db_links_into_rad_links(nROWCOUNT);
apex_application.g_print_success_message := '<span class="notification">Импортировано строк: '||nROWCOUNT||'</span>';
end;
------------------------------------------------------------------
/* Динамический процес,JS ставка данных в форму
Create Item -> Hidden
Item Name: P11_SAMPLE_DATA

Edit Page -> Function and Global Variable Declaration:
function set_item()
{
$s('P11_IMPORT_FROM', 'PASTE');
$s('P11_SEPARATOR',',');
$s('P11_FIRST_ROW', 'Y');
$('#P11_COPY_PASTE').val($('#P11_SAMPLE_DATA').val());
}

Create Button ->
PASTE_SAMPLE_DATA

Dynamic Action ->
Event: Click
Selection Type: Button (PASTE_SAMPLE_DATA)
Action: Execute JavaScript Code
Code: set_item();
Fire On Page Load: No  
*/
------------------------------------------------------------------
/*
Передать несколько параметров (item1,item2:val,val)
apex_util.prepare_url('f?p='||:APP_ID||':32:'||:APP_SESSION||'::::P32_LINK,P32_TBS:'||T.LINK||','||:P26_TBS) LINK,
*/
------------------------------------------------------------------
/* Кнопка с подтверждением
Action When Button Clicked ->
Action: Redirect to URL
URL Target:
javascript:apex.confirm('Would you like to perform this delete action?','DELETE');
javascript:apex.confirm(htmldb_delete_message,'DELETE');
*/
------------------------------------------------------------------
/* Значение Checkbox
Number of Checkbox Columns: 1
Display Extra Values: NO
Display Null Value: NO
List of values definition: STATIC:;TRUE
Source Type: SQL Query (return single value)
Source value or expression: select value from dual
*/
--Process
begin
    RAD_PKG_TOTAL.P_SET_PREFERENCE_VALUE (
    p_preference_name  => 'BCHECK_SYSDATE',
    p_preference_value => (case when :P19_BCHECK_SYSDATE is null then 'FLASE' else :P19_BCHECK_SYSDATE end));
end;
------------------------------------------------------------------
/* Understanding the APEX url
f?p=appid:pageid:session:request:debug:clearcache:params:paramvalues:printerfriendly&p_trace=YES&cs=...

In the clear cache section you have a couple of options, specifying the below will clear the cache for : 
- APP: whole application
- SESSION: current user session
- RIR: reset interactive report to primary report
- CIR: reset to primary report but with custom columns
- RP: reset pagination
- 12: page 12
- P12_ID: item P12_ID
*/
------------------------------------------------------------------
/* Ссылка на отчет с фильтром
IR<operator>_<target column alias>
Операторы:
EQ = equals (this is the default)
NEQ = not equals
LT = less than
LTE = less than or equal to
GT = greater than
GTE = greater than or equal to
LIKE = SQL like operator
N = null
NN = not null
C = contains
NC = not contain
Пример:
::::IREQ_SQLCODE:OK (SQLCODE - колонка таблицы, OK-значение)
f?p=&APP_ID.:21:&APP_SESSION.::&DEBUG.:RP,RIR,6:IREQ_SQLCODE:&LABEL.
*/
------------------------------------------------------------------
/*
Column Link с фильтром
Link Text: #LINK#
Page: 20
Clear Cache: RIR,20
Item 1: IREQ_NAME
Value: #LINK#
*/
------------------------------------------------------------------
/* APEX Значение по умолчанию */
DECLARE default_value number;
BEGIN 
select WELL_ID into default_value
from (select T.WELL_ID from WELL T order by to_number(regexp_substr(T.WELL_NAME, '[[:digit:]]*')))
where rownum = 1;
RETURN default_value; 
END;
/* APEX Значение по умолчанию sysdate*/
DECLARE default_value date;
BEGIN 
select sysdate into default_value from dual;
RETURN default_value; 
END;
------------------------------------------------------------------
/* Apex elapsed time */
declare
  l_cpu number;
  l_ela number;
begin
  l_cpu := DBMS_UTILITY.GET_CPU_TIME;
  l_ela := DBMS_UTILITY.GET_TIME;
  apex_application.g_print_success_message := ' Elapsed time: ' || to_char((DBMS_UTILITY.GET_TIME - l_ela)/100) ||' seconds';
end;
------------------------------------------------------------------
/* APEX сохранить значение в сессии */
APEX_UTIL.SET_SESSION_STATE(p_name => 'P24_QUALITY_CONTROL_ID', p_value => :P5_MASTER_ID);
------------------------------------------------------------------
/* APEX Значение по умолчанию из сессии из предыдущей страницы */
DECLARE default_value number;
BEGIN 
default_value := APEX_UTIL.GET_SESSION_STATE('P5_MASTER_ID');
RETURN default_value; 
END;
------------------------------------------------------------------
/* APEX download url */
javascript:w=window.open('http://10.48.178.254:8081/ReportExportXlsxHandler.ashx?ds=arm&report=40000000400&type.id='+apex.item("P40_REPORT_TYPE").getValue()+'&dat.BeginDate='+apex.item("P40_DATE").getValue()+'&org.org_id='+apex.item("P40_COMPANY").getValue());
------------------------------------------------------------------
/* Interactive grid dynamic action установить значение из выбранной ячейки */
Event - Change
Region - 
Selection Type - Column(s)
Column(s) - MGR

Action - Set Value
SQL Statement - select deptno from eba_demo_ig_emp where empno = :MGR
Items to Submit - MGR
Selection Type - Column(s)
Column(s) - DEPTNO
------------------------------------------------------------------
/* How to manually process Interactive Grid data using PL/SQL */
/*
Attributes > Edit > Enabled = Yes
Settings for your Save Interactive Grid Data process:
Settings > Set Target Type = PL/SQL Code
Settings > PL/SQL Code to Insert/Update/Delete =
*/
begin  
     case :APEX$ROW_STATUS  
     when 'C' then -- Note: In EA2 this has been changed from I to C for consistency with Tabular Forms  
         insert into emp ( empno, ename, deptno )  
         values ( :EMPNO, :ENAME, :DEPTNO )  
         returning rowid into :ROWID;  
     when 'U' then  
         update emp  
            set ename  = :ENAME,  
                deptno = :DEPTNO  
          where rowid  = :ROWID;  
     when 'D' then  
         delete emp  
         where rowid = :ROWID;  
     end case;  
end;
------------------------------------------------------------------
/* JS установить значение итемов из Interactive Grid */
-- Event - Selection Change [Interactive Grid]
var V_LEVEL_ID = this.data.selectedRecords.length != 1 ? '': this.data.model.getValue(this.data.selectedRecords[0], "LEVEL_ID");
var V_COMPANY_ID = this.data.selectedRecords.length != 1 ? '': this.data.model.getValue(this.data.selectedRecords[0], "COMPANY_ID");
apex.item("P49_LEVEL_ID").setValue(V_LEVEL_ID); /* Если справочник, то V_LEVEL_ID['v'] */
apex.item("P49_COMPANY_ID").setValue(V_COMPANY_ID);
/* Сохранить значение в сессии (процесс не нужен) */
apex.server.process("SAVE_HIDDEN_VALUE_IN_SESSION_STATE", {
    x01: "set_session_state",
    pageItems: "#P49_LEVEL_ID"
}, { dataType: 'text' });
apex.server.process("SAVE_HIDDEN_VALUE_IN_SESSION_STATE", {
    x01: "set_session_state",
    pageItems: "#P49_COMPANY_ID"
}, { dataType: 'text' });
------------------------------------------------------------------
-- APEX 5: fixed IR column width
-- Задать колонке static ID: colHiredate. Если несколько репортов, то задать static ID: regionStaticId
-- Добавить CSS
#regionStaticId th#colHiredate, #regionStaticId td[headers=colHiredate]{min-width:100px}
------------------------------------------------------------------
--Interactive grid - Disable column actions (Execute when Page Loads)
apex.region("test2").widget().interactiveGrid("getViews").grid.view$.grid("getColumns").forEach(function(col) { 
	col.noHeaderActivate = true;
	col.canHide = false;
	col.canSort = false;
});
--2й вариант
function(config) {
    config.columns.forEach(function(col) {
        console.log(col);
        col.features = { aggregate: false, canHide: false, compute: false, controlBreak: false, groupBy: false, highlight: false, pivot: false, sort: false };
    });
    return config;
}
------------------------------------------------------------------
-- get/set selected records in Interactive Grid
apex.region("myig").widget().interactiveGrid("getSelectedRecords");
apex.region("myig").widget().interactiveGrid("setSelectedRecords", []);

apex.region("myig").widget().interactiveGrid("getViews","grid").view$.grid("getSelectedRecords");  
------------------------------------------------------------------
-- Checkbox source (для установки добавить Processes After Header)
DECLARE
  default_value varchar2(10);
BEGIN
  if (PKG_METERING.iCHECK_MEASURE_END_DATE > 0) then
    default_value := '1';
  else
    default_value := null;
  end if;
  RETURN default_value;
END;
------------------------------------------------------------------
--После закрытия модального окна
/*
Dynamic Actions
Name: Edit Dialog closed.
Event: Dialog closed
Selection Type: JavaScript Expression
JavaScript Expression: window
Type: JavaScript Expression
JavaScript Expression: this.data && this.data.dialogPageId === 55

Действия: обновить грид и вывести сообщение
1) Action: Refresh
2) Action: Execute JavaScript Code
apex.message.showPageSuccess( "Changes successfully saved.");
*/
------------------------------------------------------------------
-- APEX tree - get selected value
select case
         when connect_by_isleaf = 1 then
          0
         when level = 1 then
          1
         else
          -1
       end as status,
       level,
       "ENAME" as title,
       'fa-folder' as icon,
       empno as value,
       empno as tooltip,
       'javascript:$s(''P1_SELECTED_EMP'', ''' || EMPNO || ''')' as link
  from EMP
 start with "MGR" is null
connect by prior "EMPNO" = "MGR"
 order siblings by "ENAME"
-- или через функцию
function pageItemValue(node) {
    $s('P11_SELECTED_NODE', node);
    apex.server.process("SAVE_HIDDEN_VALUE_IN_SESSION_STATE", {
        x01: "set_session_state",
        pageItems: "#P11_SELECTED_NODE"
    }, { dataType: 'text' });
}
--
'javascript:pageItemValue('''||EMPNO||''')' as link
------------------------------------------------------------------
-- Tab Container error 5.1 удалить после 5.2!!!!!
-- Function and Global Variable Declaration
$(function() {
  $(document.body).off("atabsactivate");
});
------------------------------------------------------------------
-- Tree css (inline)
#v-tree .a-TreeView-content {
    font-size: 16px;
}
#v-tree .a-TreeView-content.is-selected {
    background-color: #2D7BBB;
}
#v-tree .a-TreeView-content.is-selected a {
    	color: #FFF;
}
------------------------------------------------------------------
-- Refresh interactive grid using code (Apex 5.1)
apex.region("myig").widget().interactiveGrid("getActions").invoke("refresh");
------------------------------------------------------------------
-- Execute when Page Loads
$(".t-LinksList-link").click(function(e) {
  e.preventDefault();
  var urlReport;
  var str = $(this).attr('href');
  if(!isNaN(str)) {
	urlReport = apex.item("P40_REPORTS_URL").getValue()+'&report='+str+'&type.id='+apex.item("P40_REPORT_TYPE").getValue()+'&dat.BeginDate='+apex.item("P40_DATE").getValue()+'&org.org_id='+apex.item("P40_ENTERPRISE_ID").getValue()+'&company.company_id='+apex.item("P40_COMPANY").getValue()+'&balance.id='+apex.item("P40_BALANCE").getValue();
  } else {
	urlReport = 'f?p='+apex.item("P40_APP_ID").getValue()+':40:'+apex.item("P40_APP_SESSION").getValue()+':REPORT::1:P40_CODE,P40_REPORT_TYPE,P40_DATE,P40_ENTERPRISE_ID,P40_COMPANY,P40_OBJ_LEVEL_LIST,P40_BALANCE,P40_PURPOSE_LIST:'+str+','+apex.item("P40_REPORT_TYPE").getValue()+','+apex.item("P40_DATE").getValue()+','+apex.item("P40_ENTERPRISE_ID").getValue()+','+apex.item("P40_COMPANY").getValue()+','+apex.item("P40_OBJ_LEVEL").getValue().join('-')+','+apex.item("P40_BALANCE").getValue()+','+apex.item("P40_PURPOSES").getValue().join('-')+':';
  }
  //console.log(urlReport);
  window.open(urlReport, '_blank');
});
------------------------------------------------------------------
-- Refresh region
 $('#ig-shop').trigger('apexrefresh');
------------------------------------------------------------------
-- Колонка IG
-- Advanced
function(config) {
    config.features = {
        aggregate: false,
        canHide: false,
        compute: false,
        controlBreak: false,
        groupBy: false,
        highlight: false,
        pivot: false,
        sort: false
    };
    return config;
}
------------------------------------------------------------------
-- JS go to page
var href = 'f?p=&APP_ID.:41:&SESSION.::::P41_ITEM:' +  $("#P40_ITEM").val();
window.location = href;
------------------------------------------------------------------
-- Модальные окна из JS 
-- Добавить процесс с названием PREPARE_URL
-- Type: PL/SQL Code
-- Point: AJAX CAllback
declare
  v_url varchar2(2000);
begin
  v_url := apex_application.g_x01;
  begin
    v_url := apex_util.prepare_url(p_url => v_url, p_checksum_type => 'SESSION', p_triggering_element => '$("#add-button")');
  exception
    when others then
      v_url := sqlerrm;
  end;
  htp.prn(v_url);
end;
-- JS apex.server.process – вызывает PL/SQL (обертка jQuery.ajax)
apex.server.process("PREPARE_URL", { x01: href }, {
	dataType: "text",
	success: function(pData) {
		apex.navigation.redirect(pData);
	}
});
-- На кнопку задать Static ID: add-button (Влияет на dialogclose)
------------------------------------------------------------------
-- APEX 5 DA when cancelling modal dialog
When:
Event: Custom
Custom Event: dialogclose
Selection Type: JavaScript Expression
JavaScript Expression: document
------------------------------------------------------------------
-- width IR first column
#i-object table > tbody > tr > th:nth-child(1) {width:30px}
------------------------------------------------------------------
-- Событие закрытия модального окна
$(window).on('apexafterclosedialog', function(e, data) {
	if (data && data.dialogPageId === 65) {
		apex.message.showPageSuccess("Changes successfully saved.");
	}
});
------------------------------------------------------------------
-- Статические файлы JS, CSS
-- Shared ComponentsStatic Application Files
-- HTML Header section
<script src="#APP_IMAGES#treeModule.js" type="text/javascript"></script>
<script async src="#APP_IMAGES#treeModule.js" type="text/javascript"></script>
<link rel="stylesheet" href="#APP_IMAGES#style.min.css" type="text/css">
------------------------------------------------------------------
-- Переменные из JS
$v('pFlowId') // APP_ID
$v('pFlowStepId') // APP_PAGE_ID
$v('pInstance') // SESSION
$v('pdebug') // p_debug
$v("pSalt") // p_json:{"salt":"35017434674395871144267697204061936809"}
------------------------------------------------------------------
-- Иерархический SQL в JSON (полный без lazy)
begin
  htp.p('[');
  for cur in (select case
                        when (T.LVL = 1 and rownum <> 1) then
                         ',{'
                      /* the top dog gets a left curly brace to start things off */
                        when T.LVL = 1 then
                         '{'
                      /* when the last level is lower (shallower) than the current level, start a "children" array */
                        when T.LVL - lag(T.LVL) over(order by rownum) = 1 then
                         ',"children" : [{'
                        else
                         ',{'
                      end || ' "id": ' || APEX_JSON.STRINGIFY(T.VALUE) || ',' || ' "text": ' || APEX_JSON.STRINGIFY(T.TITLE) || ',' ||
                      ' "tooltip": ' || APEX_JSON.STRINGIFY(T.TOOLTIP) || ',' || ' "icon": ' || APEX_JSON.STRINGIFY(T.ICON) || ',' ||
                      ' "link": ' || APEX_JSON.STRINGIFY(T.LINK) || ' '
                     /* when the next level lower (shallower) than the current level, close a "children" array */
                      || case
                        when lead(T.LVL, 1, 1) over(order by rownum) - T.LVL <= 0 then
                         '}' || rpad(' ', 1 + (-2 * (lead(T.LVL, 1, 1) over(order by rownum) - T.LVL)), ']}')
                        else
                         null
                      end as JSON
                from ERA_MER.V_TREE_ADM_OBJ T
               order by rownum) loop
    htp.p(cur.JSON);
  end loop;
  htp.p(']');
end;
-- lazy
begin
  htp.p('[');
  for cur in (select case
                       when (rownum <> 1) then
                        ',{'
                       else
                        '{'
                     end || ' "id": ' || APEX_JSON.STRINGIFY(T.ID) || ',' || ' "text": ' || APEX_JSON.STRINGIFY(T.TITLE) || ',' ||
                     ' "tooltip": ' || APEX_JSON.STRINGIFY(T.TOOLTIP) || ',' || ' "icon": ' || APEX_JSON.STRINGIFY(T.ICON) || ',' ||
                     ' "children": ' || decode(T.STATUS, 0, 'false', 'true') || ',' || ' "data": {"obj_level":' ||
                     APEX_JSON.STRINGIFY(T.OBJ_LEVEL) || ', "tooltip": ' || APEX_JSON.STRINGIFY(T.TOOLTIP) || '} ' || '}' as JSON
                from (select *
                        from (select case
                                       when connect_by_isleaf = 1 then
                                        0
                                       when level = 1 then
                                        1
                                       else
                                        -1
                                     end as STATUS,
                                     level as LVL,
                                     T.NAME as TITLE,
                                     nvl(PARENT, '#') as PARENT_ID,
                                     '' as ICON,
                                     T.ID,
                                     decode(T.LABEL, null, null, T.LABEL || ': ') || name as TOOLTIP,
                                     T.OBJ_LEVEL
                                from ERA_MER.V_ADM_OBJ T
                               start with PARENT is null
                              connect by prior id = parent
                               order siblings by name)
                       where nvl(PARENT_ID, '#') = nvl(APEX_APPLICATION.G_X01, '#')) T
               order by rownum) loop
    htp.p(cur.JSON);
  end loop;
  htp.p(']');
end;
------------------------------------------------------------------
-- AJAX через jQuery
$.post('wwv_flow.show', {
        "p_request": "APPLICATION_PROCESS=GET_NODE_DATA",
        "p_flow_id": $v('pFlowId'),
        "p_flow_step_id": $v('pFlowStepId'),
        "p_instance": $v('pInstance'),
        "x01": 'GET_EXISTING_FILTER'
    },
    function(data) {
        console.log(data);
    }
);

var ajaxData = {
    "p_request": "APPLICATION_PROCESS=GET_NODE_DATA",
    "p_flow_id": $v('pFlowId'),
    "p_flow_step_id": $v('pFlowStepId'),
    "p_instance": $v('pInstance'),
    "x01": 'GET_EXISTING_FILTER'
};

$.ajax({
    url: 'wwv_flow.show',
    data: ajaxData,
    settings: { "type": "GET", "dataType": "json" }
}).done(function(data) {
    console.log(data);
});
------------------------------------------------------------------
-- Загрузка файла (blob)
declare
  L_FILEROW APEX_APPLICATION_TEMP_FILES%rowtype;
begin
  if (:P10_XLSX is not null) then
    select * into L_FILEROW from APEX_APPLICATION_TEMP_FILES where NAME = :P10_XLSX;
    PKG_INCLINOMETRY.IMP_FROM_XLSX(BXLSX => L_FILEROW.BLOB_CONTENT, NWELLBORE_NUM => :P10_WELLBORE_NUM, NWELL_ID => :P10_WELL_ID);
    delete from APEX_APPLICATION_FILES where name = :P10_XLSX;
  end if;
end;
------------------------------------------------------------------
-- Получение данных из модального окна
/*
On your modal page you have a Submit button (Action: Submit Page). Then create process
Type: Close Dialog
Settings => Item(s) to Return: P2_RETURN_ITEM
Point: After Submit

On page 1 create a dynamic action on your triggering region or button:
DA Event: Dialog closed (Selection Type: Region)
True action
Action: Set Value
Set Type: Dialog Return Item
Return Item: P2_RETURN_ITEM
Affected Element(s):
Selection Type: Item(s)
Item(s): P1_RETURNED_ITEM

Please, see the demo application on https://apex.oracle.com/pls/apex/f?p=4550
workspace: testing
user: test
pwd: test
Application 2766 - returned_item

Получение данных из 1го модального окна в 2е модальное окно
Для 2го модального окна
Chained: No
*/
-- Для IG Event - Selection Change [Interactive Grid]
var V_ID = this.data.selectedRecords.length > 0 ? this.data.model.getValue(this.data.selectedRecords[0], "CODE") : '';
apex.item("P47_RETURN_ITEM").setValue(V_ID); /* Если справочник, то V_ID['v'] */
apex.server.process("SAVE_HIDDEN_VALUE_IN_SESSION_STATE", {
    x01: "set_session_state",
    pageItems: "#P47_RETURN_ITEM"
}, { dataType: 'text' });
-- Если нужно обновить справочник и установить значение (Action: Execute JavaScript Code вместо Set Value)
$('#P71_CODE').trigger('apexrefresh');
if (this.data.P47_RETURN_ITEM) {
    (function(that) {
        setTimeout(function() {
            apex.item("P71_CODE").setValue(that.data.P47_RETURN_ITEM);
        }, 100);
    })(this);
}
------------------------------------------------------------------
-- Apex X-Frame-Options
Shared Components > Security Attributes > Browser Security -> Embed in Frames
------------------------------------------------------------------
--APEX LDAP
/* Shared Components -> Authentication Schemes
Host: ldap.domain.com
Distinguished Name (DN) String: domain\%LDAP_USER%

Или через пользовательскую функцию 
https://oracle-base.com/articles/misc/oracle-application-express-apex-ldap-authentication
*/
BEGIN
  DBMS_NETWORK_ACL_ADMIN.CREATE_ACL (
    acl          => 'ldap_acl_file.xml', 
    description  => 'ACL to grant access to LDAP server',
    principal    => 'APEX_050100',
    is_grant     => TRUE, 
    privilege    => 'connect',
    start_date   => SYSTIMESTAMP,
    end_date     => NULL);
  DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (
    acl         => 'ldap_acl_file.xml',
    host        => 'nis.local', 
    lower_port  => 389,
    upper_port  => NULL);
-- добавление еще одного пользователя в созданный список
  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE (
    acl          => 'ldap_acl_file.xml', 
    principal    => 'ERA_MER',
    is_grant     => TRUE, 
    privilege    => 'connect');
  COMMIT;
END;
------------------------------------------------------------------
