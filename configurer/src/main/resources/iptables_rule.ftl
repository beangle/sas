[#ftl]
[#list ports as port]
-A INPUT -m state --state NEW -m tcp -p tcp --dport ${port} -j ACCEPT
[/#list]