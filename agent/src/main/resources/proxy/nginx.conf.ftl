[#assign proxy = container.proxy/]
user nginx;
worker_processes auto;
worker_rlimit_nofile 65535;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

include /usr/share/nginx/modules/*.conf;

events {
    worker_connections ${proxy.maxconn};
    multi_accept on;
    use epoll;
}

http {
    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;
    types_hash_bucket_size 1024;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

[#if proxy.https??]
    ssl_session_cache   shared:SSL:10m;
    ssl_session_timeout 10m;
[/#if]
    include /etc/nginx/conf.d/*.conf;

    [#list proxy.backends?sort_by("name") as backend]
    upstream ${backend.name}{
[#if backend.options??]${addMargin(backend.options)}[/#if][#t]
    [#list backend.servers as server]
        server ${server.ip}:${server.port} ${server.options!};
    [/#list]
    }
    [/#list]

    [#if proxy.https?? && proxy.https.forceHttps][#--跳转到https--]
    server {
        listen ${proxy.httpPort} default_server;
        listen [::]:${proxy.httpPort} default_server;
        [#if proxy.hostname??]
        server_name  ${proxy.hostname};
        [/#if]
        return 301 https://$server_name$request_uri;
    }
    [/#if]

    server {
        [#if !(proxy.https?? && proxy.https.forceHttps)]
        listen ${proxy.httpPort};
        [/#if]
        [#if proxy.https??]
        listen ${proxy.https.port} ssl;
        [/#if]
        [#if proxy.hostname??]
        server_name  ${proxy.hostname};
        [/#if]
        [#if proxy.https??]
        ssl_certificate ${proxy.https.certificate!"/etc/nginx/${proxy.hostname}.crt"};
        ssl_certificate_key ${proxy.https.certificateKey!"/etc/nginx/${proxy.hostname}.key"};
        ssl_protocols     ${proxy.https.protocols!"TLSv1 TLSv1.1 TLSv1.2"};
        ssl_ciphers       ${proxy.https.ciphers!"HIGH:!aNULL:!MD5"};
        keepalive_timeout   70;
        [/#if]
        root         /usr/share/nginx/html;
        access_log off;
        proxy_set_header  X-Real-IP  $remote_addr;
        proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header  X-Forwarded-Proto  $scheme;
        proxy_set_header  Host $host:$server_port;

        include /etc/nginx/default.d/*.conf;
        [#if proxy.status??]
        location ${proxy.status.uri} {
            stub_status on;
            access_log off;
        }
        [/#if]
    [#list container.runnableWebapps as webapp]
    [#if webapp.contextPath?length>1]
        location ${webapp.contextPath} {
            proxy_pass http://${webapp.entryPoint.name};
        }
    [/#if]
    [/#list]
    }
}

[#function addMargin(text)]
  [#assign lines=text?split('\n')]
  [#assign res =""/]
  [#list lines as line]
  [#assign res = res + ("        " + line?trim)]
  [#if line_has_next]
  [#assign res = res + "\n"]
  [/#if]
  [/#list]
  [#return res/]
[/#function]
