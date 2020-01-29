global
${addMargin(container.haproxy.global)}
${addMargin(container.haproxy.genStat)}

defaults
${addMargin(container.haproxy.defaults)}

frontend main
${addMargin(container.haproxy.frontend)}

[#assign max_path_len=1]
[#assign max_proxy_len=1]
[#list container.deployments as deployment]
   [#if deployment.path?length > max_path_len]
     [#assign max_path_len=deployment.path?length]
   [/#if]
   [#if deployment.on?length > max_proxy_len]
     [#assign max_proxy_len=deployment.on?length]
   [/#if]
[/#list]

[#list container.deployments?sort_by('path') as deployment]
    [#if deployment.path?length>0]
    acl url${deployment.path?replace('/','_')?right_pad(max_path_len)} path_beg ${deployment.path}
    [/#if]
[/#list]

    [#assign use_backends=[]]
    [#list container.deployments?sort_by('path') as deployment]
    [#if deployment.path?length>0]
    [#assign this_backend]    use_backend ${container.haproxy.getBackend(deployment.on).name?right_pad(max_proxy_len)}  if url${deployment.path?replace('/','_')}[/#assign]
    [#assign use_backends=use_backends+[this_backend]/]
    [#else]
      [#assign default_server=container.haproxy.getBackend(deployment.on).name/]
    [/#if]
    [/#list]

[#list use_backends?sort as use_backend]
${use_backend}
[/#list]

[#if default_server??]
    default_backend ${default_server}
[/#if]

    [#list container.haproxy.backends?keys?sort as name]
    [#assign backend=container.haproxy.backends[name]/]
backend ${name}
${addMargin(backend.options)}
    [#list backend.getServers(container) as server]
    server ${server.farm.host.ip?replace('.','_')}_${server.http} localhost:${server.http} check
    [/#list]

    [/#list]

[#function addMargin(text)]
  [#assign lines=text?split('\n')]
  [#assign res =""/]
  [#list lines as line]
  [#assign res = res + ("    " + line?trim)]
  [#if line_has_next]
  [#assign res = res + "\n"]
  [/#if]
  [/#list]
  [#return res/]
[/#function]
