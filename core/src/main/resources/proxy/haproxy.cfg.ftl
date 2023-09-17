[#assign proxy = container.proxy/]
global
    log         127.0.0.1 local2
    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
    maxconn     ${proxy.maxconn}
    user        haproxy
    group       haproxy
    daemon
    tune.ssl.default-dh-param 2048
    ssl-default-bind-options no-sslv3 no-tlsv10
    ssl-default-bind-ciphers PROFILE=SYSTEM
    ssl-default-server-ciphers PROFILE=SYSTEM
[#if proxy.status??]
    stats socket /var/lib/haproxy/stats
[/#if]

defaults
    mode                    http
    log                     global
    option                  httplog
    option                  dontlognull
    option http-server-close
    option forwardfor       except 127.0.0.0/8
    option                  redispatch
    retries                 3
    timeout http-request    2m
    timeout queue           1m
    timeout connect         30s
    timeout client          2m
    timeout server          10m
    timeout http-keep-alive 60s
    timeout check           60s
    maxconn                 ${proxy.maxconn}

[#if proxy.status??]
    stats refresh 30s
    stats uri ${proxy.status.uri}
    stats realm haproxy-user
    stats auth ${proxy.status.auth}
[/#if]

frontend main
    bind *:${proxy.httpPort}
    [#if proxy.enableHttps]
    [#assign https=proxy.https/]
    bind *:${https.port} ssl crt ${https.certificate!"/etc/haproxy/${proxy.hostname}.pem"} [#if https.ciphers??]ciphers ${https.ciphers}[/#if] ${https.protocols!"no-sslv3 no-tlsv10 no-tlsv11"}
    http-request set-header X-Forwarded-Proto https if { ssl_fc }
    http-request set-header X-Forwarded-Port %[dst_port]
    [#if https.forceHttps]
    acl is_me hdr_beg(host) ${proxy.hostname}
    redirect scheme https if !{ ssl_fc } is_me
    [/#if]
    [/#if]

[#assign max_path_len=1]
[#assign max_proxy_len=1]

[#assign runnableWebapps=container.runnableWebapps/]
[#list runnableWebapps as webapp]
  [#if webapp.contextPath?length > max_path_len]
    [#assign max_path_len=webapp.contextPath?length]
  [/#if]
  [#if webapp.entryPoint.name?length > max_proxy_len]
    [#assign max_proxy_len=webapp.entryPoint.name?length]
  [/#if]
[/#list]

[#list runnableWebapps as webapp]
    [#if webapp.contextPath?length>1]
    acl is${webapp.contextPath?replace('/','_')?right_pad(max_path_len)} path_beg ${webapp.contextPath}
    [/#if]
[/#list]

[#assign use_backends=[]]
[#list runnableWebapps as webapp]
[#if webapp.contextPath?length>1]
[#assign this_backend]    use_backend ${webapp.entryPoint.name?right_pad(max_proxy_len)}  if is${webapp.contextPath?replace('/','_')}[/#assign]
[#assign use_backends=use_backends+[this_backend]/]
[#else]
  [#assign default_server=webapp.entryPoint.name/]
[/#if]
[/#list]

[#list use_backends as use_backend]
${use_backend}
[/#list]

[#if default_server??]
    default_backend ${default_server}
[/#if]

    [#list proxy.backends?sort_by('name') as backend]
backend ${backend.name}
${addMargin(backend.options!"balance roundrobin")}
    [#list backend.servers as server]
    server ${server.ip?replace('.','_')?replace(':','_')}_${server.port} ${server.ip}:${server.port} ${server.options!'check'}
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
