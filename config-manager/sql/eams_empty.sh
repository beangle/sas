#!/bin/bash
# 防止中文乱码
export NLS_LANG="Simplified Chinese_CHINA.AL32UTF8";
# 删除用户、新建用户
sqlplus sys/1 as sysdba @new_user.sql
# 导入package和function
sqlplus eams_empty/1 @function.sql
# 创建表
sqlplus eams_empty/1 @create.sql
# 创建sequence
sqlplus eams_empty/1 @sequence.sql
# 导入基础数据
sqlplus eams_empty/1 @insert.sql

