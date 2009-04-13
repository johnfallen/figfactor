<cfabort />
[system]
system_mode=production
commonspot_dsn=commonspot-site-viewframework
reload=false
url_reload_key=init
url_reload_key_value=true
page_type_metadata_form_name=Page-Type
page_type_metadata_form_field_name=page_type
production_server_ip_list=129.34.123.4,168.111.12.166,168.111.12.167
administrator_email=pcorey@nist.gov
webmaster_email=pcorey@nist.gov,john.allen@nist.gov
developer_email=john.allen@nist.gov,jallen@figleaf.com,johnfallen@gmail.com
mail_server=localhost
mail_username=
mail_password=
input_presidence=form
system_version=RCV2 .05
fig_leaf_system_version=RCV2 0.5

[ui]
default_css=home
default_css_class=home
web_path_to_admin=/customcf/com/figleaf/figfactor/admin/

[logger]
enable_external_logger=true
commonspot_path=C:\Inetpub\wwwroot\commonspot\

[cacheService]
default_cache=softcache
default_cache_type=softcache
cache_time_span=1000
cache_reap_time=1000
cache_time_value=s
url_cache_reload_key=recache
url_cache_reload_value=true


[fleet]
commonspot_support_dsn=ViewFramework_Fleet
fleet_meta_data_field_name=fic_page_meta_data
fleet_Controll_ID=0

enable_fleet=true
enable_fileasset=false
enable_metadata=true
enable_releated_links=false
enable_site_ripper=false

meta_data_ui_support_edit_directory=/admin/metadata

site_ripper_url=http://localhost/viewframework/shared/figleaf/siteripper/
site_ripper_cfurl=/fleet/com/siteripper/
fleet_version=0.3 Alpha

[dataservice]
implement_dataservice=true
gateway_runtime_mode=production
store_xml_disk_cache=false
support_datasource_1=some-data-source-name-one
support_datasource_2=some-data-source-name-two
dataservice_version=1.0
force_pass=true

[authentication]
enable_authentication=true
realm=GENA
authentication_url=https://webapp01.nist.gov:7101/axis/services/AuthWSv1?wsdl
authentication_test_url=https://webapp03.nist.gov:7101/axis/services/AuthWSv1?wsdl
authentication_mode=test
authentication_force_pass=true
authentication_version=alpha


[search]
enable_google=true
search_type=google
google_url=http://search.nist.gov/search
google_site_scope=
google_results_number=10
google_getfields=*
google_client=default_frontend
google_access=p
google_buttonText=Search
google_Ie=UTF-8
google_output=xml_no_dtd
google_filter=1
google_sortType=L
google_proxyreload=1
google_display_sort_options=true
google_display_numbers=true
google_output_format=HTML
search_form_action=http://localhost/viewframework/search-results.cfm
search_form_break_button=false
search_form_class=GoogleSearchFromClass
search_form_id=GoogleSearchFromID
search_form_name=GoogleSearchForm
search_mode=production

[multimedia]
enable_multimedia=true
media_management_group_id=20
video_platfrom=external
video_platform_service=youtube

[validator]
enable_validator=true

[framework_deployment_security]
destroy_admin=false
