create or replace procedure wadl (p_module_name in varchar2) is
   l_resource_base varchar2 (32767) := owa_util.get_cgi_env ('REQUEST_PROTOCOL') || '://' || owa_util.get_cgi_env ('HTTP_HOST');
   l_script_name   varchar2 (32767) := owa_util.get_cgi_env ('SCRIPT_NAME');

   cursor resources is
        select distinct t.uri_template
          from apex_rest_resource_templates t
         where t.module_name = p_module_name
           and t.uri_template not in ('wadl', 'wadl/')
      order by t.uri_template;

   cursor handlers (p_uri_template varchar2) is
        select decode (h.format, 'Default', 'app/json', h.format) format, h.method, h.handler_id
          from apex_rest_resource_templates t, apex_rest_resource_handlers h
         where t.module_name = p_module_name
           and t.uri_template = p_uri_template
           and h.template_id = t.template_id
           and t.uri_template not in ('wadl', 'wadl/')
      order by h.method;

   cursor resource_params (p_uri_template varchar2) is
      select distinct p.parameter_name, p.param_type
        from apex_rest_resource_handlers h, apex_rest_resource_parameters p, apex_rest_resource_templates t
       where h.handler_id = p.handler_id
         and h.template_id = t.template_id
         and t.module_name = p_module_name
         and t.uri_template = p_uri_template
         and p.source_type = 'URI';

   cursor method_params (p_handler_id number) is
      select distinct p.parameter_name, p.param_type
        from apex_rest_resource_parameters p
       where source_type = 'HTTP Header'
         and handler_id = p_handler_id;
begin
   if instr (l_script_name, '/wadl', -1) > 0
   then
      l_script_name      :=
         substr (l_script_name
                ,1
                ,  instr (l_script_name
                         ,'/wadl'
                         ,-1
                         ,1)
                 - 1);
   end if;

   owa_util.mime_header ('text/plain');
   sys.htp.p (
      '<application xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="http://wadl.dev.java.net/2009/02" xsi:schemaLocation="http://wadl.dev.java.net/2009/02">');
   sys.htp.p ('  <doc title="' || p_module_name || '"/>');

   -- Base defines the domain and base path of the endpoint
   sys.htp.p ('  <resources base="' || l_resource_base || '">');

   for r in resources
   loop
      sys.htp.p ('    <resource path="' || l_script_name || '/' || r.uri_template || '" id="' || r.uri_template || '">');
      sys.htp.p ('    <doc title="' || r.uri_template || '"/>');

      -- ORDS resource template parameter
      for p in resource_params (r.uri_template)
      loop
         null;
         sys.htp.p ('    <param name="' || p.parameter_name || '" required="true" type="xsd:' || lower (p.param_type) || '" style="template"/>');
      end loop; -- params

      for h in handlers (r.uri_template)
      loop
         sys.htp.p ('    <method name="' || h.method || '" id="' || lower (h.method) || '_' || r.uri_template || '">');

         sys.htp.p ('      <doc title="' || r.uri_template || '"/>');

         sys.htp.p ('      <request>');

         for p in method_params (h.handler_id)
         loop
            null;
            sys.htp.p ('        <param name="' || p.parameter_name || '" required="true" type="xsd:' || lower (p.param_type) || '" style="header"/>');
         end loop; -- params

         sys.htp.p ('      </request>');
         sys.htp.p ('      <response>');
         sys.htp.p ('         <representation mediaType="' || h.format || '"/>');
         sys.htp.p ('      </response>');
         sys.htp.p ('    </method>');
      end loop; -- handlers

      sys.htp.p ('    </resource>');
   end loop; -- resources

   sys.htp.p ('  </resources>');
   sys.htp.prn ('</application>');
end wadl;