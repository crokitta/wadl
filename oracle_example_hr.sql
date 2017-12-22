prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_default_workspace_id=>13804723309278094991
);
end;
/
begin
wwv_flow_api.remove_restful_service(
 p_id=>wwv_flow_api.id(41246636747851610365)
,p_name=>'oracle.example.hr'
);
 
end;
/
prompt --application/restful_services/oracle_example_hr
begin
wwv_flow_api.create_restful_module(
 p_id=>wwv_flow_api.id(41246636747851610365)
,p_name=>'oracle.example.hr'
,p_uri_prefix=>'hr/'
,p_parsing_schema=>'FIFAPEX'
,p_items_per_page=>10
,p_status=>'PUBLISHED'
,p_row_version_number=>50
);
wwv_flow_api.create_restful_template(
 p_id=>wwv_flow_api.id(41246638744091610370)
,p_module_id=>wwv_flow_api.id(41246636747851610365)
,p_uri_template=>'empinfo/'
,p_priority=>0
,p_etag_type=>'HASH'
);
wwv_flow_api.create_restful_handler(
 p_id=>wwv_flow_api.id(41246638863589610370)
,p_template_id=>wwv_flow_api.id(41246638744091610370)
,p_source_type=>'QUERY'
,p_format=>'CSV'
,p_method=>'GET'
,p_require_https=>'NO'
,p_source=>'select * from emp'
);
wwv_flow_api.create_restful_template(
 p_id=>wwv_flow_api.id(41246637028588610368)
,p_module_id=>wwv_flow_api.id(41246636747851610365)
,p_uri_template=>'employees/'
,p_priority=>0
,p_etag_type=>'HASH'
);
wwv_flow_api.create_restful_handler(
 p_id=>wwv_flow_api.id(41246637101811610368)
,p_template_id=>wwv_flow_api.id(41246637028588610368)
,p_source_type=>'QUERY'
,p_format=>'DEFAULT'
,p_method=>'GET'
,p_items_per_page=>7
,p_require_https=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select empno "$uri", rn, empno, ename, job, hiredate, mgr, sal, comm, deptno',
'  from (',
'       select emp.*',
'            , row_number() over (order by empno) rn',
'         from emp',
'       ) tmp'))
);
wwv_flow_api.create_restful_template(
 p_id=>wwv_flow_api.id(41246637285237610368)
,p_module_id=>wwv_flow_api.id(41246636747851610365)
,p_uri_template=>'employees/{id}'
,p_priority=>0
,p_etag_type=>'HASH'
);
wwv_flow_api.create_restful_handler(
 p_id=>wwv_flow_api.id(41246637399301610368)
,p_template_id=>wwv_flow_api.id(41246637285237610368)
,p_source_type=>'QUERY_1_ROW'
,p_format=>'DEFAULT'
,p_method=>'GET'
,p_require_https=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select * from emp',
' where empno = :id'))
);
wwv_flow_api.create_restful_param(
 p_id=>wwv_flow_api.id(41246637406110610368)
,p_handler_id=>wwv_flow_api.id(41246637399301610368)
,p_name=>'id'
,p_bind_variable_name=>'id'
,p_source_type=>'URI'
,p_access_method=>'IN'
,p_param_type=>'INT'
);
wwv_flow_api.create_restful_handler(
 p_id=>wwv_flow_api.id(41246637570969610369)
,p_template_id=>wwv_flow_api.id(41246637285237610368)
,p_source_type=>'PLSQL'
,p_format=>'DEFAULT'
,p_method=>'PUT'
,p_require_https=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    update emp set ename = :ename, job = :job, hiredate = :hiredate, mgr = :mgr, sal = :sal, comm = :comm, deptno = :deptno',
'    where empno = :id;',
'    :status := 200;',
'    :location := :id;',
'exception',
'    when others then',
'        :status := 400;',
'end;'))
);
wwv_flow_api.create_restful_param(
 p_id=>wwv_flow_api.id(41246637846140610369)
,p_handler_id=>wwv_flow_api.id(41246637570969610369)
,p_name=>'X-APEX-FORWARD'
,p_bind_variable_name=>'location'
,p_source_type=>'HEADER'
,p_access_method=>'OUT'
,p_param_type=>'STRING'
);
wwv_flow_api.create_restful_param(
 p_id=>wwv_flow_api.id(41246637727215610369)
,p_handler_id=>wwv_flow_api.id(41246637570969610369)
,p_name=>'X-APEX-STATUS-CODE'
,p_bind_variable_name=>'status'
,p_source_type=>'HEADER'
,p_access_method=>'OUT'
,p_param_type=>'INT'
);
wwv_flow_api.create_restful_param(
 p_id=>wwv_flow_api.id(41246637647984610369)
,p_handler_id=>wwv_flow_api.id(41246637570969610369)
,p_name=>'id'
,p_bind_variable_name=>'id'
,p_source_type=>'URI'
,p_access_method=>'IN'
,p_param_type=>'INT'
);
wwv_flow_api.create_restful_template(
 p_id=>wwv_flow_api.id(41246637979609610369)
,p_module_id=>wwv_flow_api.id(41246636747851610365)
,p_uri_template=>'employeesfeed/'
,p_priority=>0
,p_etag_type=>'HASH'
);
wwv_flow_api.create_restful_handler(
 p_id=>wwv_flow_api.id(41246638040314610369)
,p_template_id=>wwv_flow_api.id(41246637979609610369)
,p_source_type=>'FEED'
,p_format=>'DEFAULT'
,p_method=>'GET'
,p_items_per_page=>25
,p_require_https=>'NO'
,p_source=>'select empno, ename from emp order by deptno, ename'
);
wwv_flow_api.create_restful_template(
 p_id=>wwv_flow_api.id(41246638129837610369)
,p_module_id=>wwv_flow_api.id(41246636747851610365)
,p_uri_template=>'employeesfeed/{id}'
,p_priority=>0
,p_etag_type=>'HASH'
);
wwv_flow_api.create_restful_handler(
 p_id=>wwv_flow_api.id(41246638266602610369)
,p_template_id=>wwv_flow_api.id(41246638129837610369)
,p_source_type=>'QUERY'
,p_format=>'CSV'
,p_method=>'GET'
,p_require_https=>'NO'
,p_source=>'select * from emp where empno = :id'
);
wwv_flow_api.create_restful_param(
 p_id=>wwv_flow_api.id(41345869991750981222)
,p_handler_id=>wwv_flow_api.id(41246638266602610369)
,p_name=>'id'
,p_bind_variable_name=>'id'
,p_source_type=>'URI'
,p_access_method=>'IN'
,p_param_type=>'INT'
);
wwv_flow_api.create_restful_template(
 p_id=>wwv_flow_api.id(41246638346611610369)
,p_module_id=>wwv_flow_api.id(41246636747851610365)
,p_uri_template=>'empsec/{empname}'
,p_priority=>0
,p_etag_type=>'HASH'
);
wwv_flow_api.create_restful_handler(
 p_id=>wwv_flow_api.id(41246638410861610369)
,p_template_id=>wwv_flow_api.id(41246638346611610369)
,p_source_type=>'QUERY'
,p_format=>'DEFAULT'
,p_method=>'GET'
,p_require_https=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select empno, ename, deptno, job from emp ',
'	where ((select job from emp where ename = :empname) IN (''PRESIDENT'', ''MANAGER'')) ',
'    OR  ',
'    (deptno = (select deptno from emp where ename = :empname)) ',
'order by deptno, ename',
''))
);
wwv_flow_api.create_restful_param(
 p_id=>wwv_flow_api.id(41345875968453987143)
,p_handler_id=>wwv_flow_api.id(41246638410861610369)
,p_name=>'empname'
,p_bind_variable_name=>'empname'
,p_source_type=>'URI'
,p_access_method=>'IN'
,p_param_type=>'STRING'
);
wwv_flow_api.create_restful_template(
 p_id=>wwv_flow_api.id(41246638599559610369)
,p_module_id=>wwv_flow_api.id(41246636747851610365)
,p_uri_template=>'empsecformat/{empname}'
,p_priority=>0
,p_etag_type=>'HASH'
);
wwv_flow_api.create_restful_handler(
 p_id=>wwv_flow_api.id(41246638651306610370)
,p_template_id=>wwv_flow_api.id(41246638599559610369)
,p_source_type=>'PLSQL'
,p_format=>'DEFAULT'
,p_method=>'GET'
,p_require_https=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  prevdeptno     number;',
'  total_rows     number;',
'  deptloc        varchar2(20);',
'  deptname       varchar2(20);',
'  ',
'  CURSOR         getemps is select * from emp ',
'                             start with ename = :empname',
'                           connect by prior empno = mgr',
'                             order siblings by deptno, ename;',
'BEGIN',
'  sys.htp.htmlopen;',
'  sys.htp.headopen;',
'  sys.htp.title(''Hierarchical Department Report for Employee ''||apex_escape.html(:empname));',
'  sys.htp.headclose;',
'  sys.htp.bodyopen;',
' ',
'  for l_employee in getemps ',
'  loop',
'      if l_employee.deptno != prevdeptno or prevdeptno is null then',
'          select dname, loc ',
'            into deptname, deptloc ',
'            from dept ',
'           where deptno = l_employee.deptno;',
'           ',
'          if prevdeptno is not null then',
'              sys.htp.print(''</ul>'');',
'          end if;',
'',
'          sys.htp.print(''Department '' || apex_escape.html(deptname) || '' located in '' || apex_escape.html(deptloc) || ''<p/>'');',
'          sys.htp.print(''<ul>'');',
'      end if;',
'',
'      sys.htp.print(''<li>'' || apex_escape.html(l_employee.ename) || '', ''  || apex_escape.html(l_employee.empno) || '', '' || ',
'                        apex_escape.html(l_employee.job) || '', '' || apex_escape.html(l_employee.sal) || ''</li>'');',
'',
'      prevdeptno := l_employee.deptno;',
'      total_rows := getemps%ROWCOUNT;',
'      ',
'  end loop;',
'',
'  if total_rows > 0 then',
'      sys.htp.print(''</ul>'');',
'  end if;',
'',
'  sys.htp.bodyclose;',
'  sys.htp.htmlclose;',
'END;'))
);
wwv_flow_api.create_restful_param(
 p_id=>wwv_flow_api.id(41346000134938991018)
,p_handler_id=>wwv_flow_api.id(41246638651306610370)
,p_name=>'empname'
,p_bind_variable_name=>'empname'
,p_source_type=>'URI'
,p_access_method=>'IN'
,p_param_type=>'STRING'
);
wwv_flow_api.create_restful_template(
 p_id=>wwv_flow_api.id(41246636824283610367)
,p_module_id=>wwv_flow_api.id(41246636747851610365)
,p_uri_template=>'version/'
,p_priority=>0
,p_etag_type=>'HASH'
);
wwv_flow_api.create_restful_handler(
 p_id=>wwv_flow_api.id(41246636967097610367)
,p_template_id=>wwv_flow_api.id(41246636824283610367)
,p_source_type=>'PLSQL'
,p_format=>'DEFAULT'
,p_method=>'GET'
,p_require_https=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    sys.htp.p( ''{ "version": "5.1" }'' );',
'end;'))
);
wwv_flow_api.create_restful_template(
 p_id=>wwv_flow_api.id(41247797318745688351)
,p_module_id=>wwv_flow_api.id(41246636747851610365)
,p_uri_template=>'wadl/'
,p_priority=>0
,p_etag_type=>'HASH'
);
wwv_flow_api.create_restful_handler(
 p_id=>wwv_flow_api.id(41247841637989471385)
,p_template_id=>wwv_flow_api.id(41247797318745688351)
,p_source_type=>'PLSQL'
,p_format=>'DEFAULT'
,p_method=>'GET'
,p_require_https=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'   wadl(''oracle.example.hr'');',
'end;'))
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
