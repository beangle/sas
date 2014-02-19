prompt 开始安装存储过程

prompt 安装更新sequence起始值的脚本...

CREATE OR REPLACE package SEQ_UTIL
IS
        PROCEDURE update_sequence(v_table_name varchar2, v_seq_name varchar2);
END SEQ_UTIL;
/

CREATE OR REPLACE package body SEQ_UTIL
IS
        -- 更新单个sequence的起始值
        PROCEDURE update_sequence(v_table_name varchar2, v_seq_name varchar2)
        IS
                v_sql varchar2(200) := '';
                v_id NUMBER(19) := 0;
                v_errcode NUMBER;
                v_errmsg  varchar2(200);
        BEGIN
                BEGIN
                        v_sql := 'DROP SEQUENCE ' || v_seq_name;
                        dbms_output.put_line(v_sql);
                        EXECUTE IMMEDIATE v_sql;
                exception
                WHEN others THEN
                        v_errcode := sqlcode;
                        v_errmsg := substr(sqlerrm,1,200);
                        dbms_output.put_line( 'error code is ' || v_errcode || ' error message is ' || v_errmsg);
                END;
                v_sql := 'select nvl(max(id), 0) from ' || v_table_name;
                EXECUTE immediate v_sql INTO v_id;
                v_id := v_id + 1;
                v_sql := 'CREATE SEQUENCE ' || v_seq_name || ' START WITH ' || v_id;
                dbms_output.put_line(v_sql);
                EXECUTE immediate v_sql;
        END update_sequence;
END SEQ_UTIL;
/

prompt 安装外键脚本套件...
CREATE OR REPLACE TYPE fk_stats_row AS object (
  child_table                   varchar2(32),
  child_table_fk_col    varchar2(32),
  parent_table                  varchar2(32),
  parent_table_pk_col   varchar2(32)
);
/

CREATE OR REPLACE TYPE fk_stats AS TABLE OF fk_stats_row;
/

CREATE OR REPLACE TYPE fk_refered_count_row AS object (
  child_table                   varchar2(32),
  parent_id                             NUMBER(19),
  refer_count                   NUMBER(19)
);
/

CREATE OR REPLACE TYPE fk_refered_count AS TABLE OF fk_refered_count_row;
/

CREATE OR REPLACE TYPE id_array AS TABLE OF NUMBER(19);
/

CREATE OR REPLACE package FK_UTIL
IS
        FUNCTION get_refering_stats(v_table_name varchar2) RETURN fk_stats;
        FUNCTION get_refered_stats(v_table_name varchar2) RETURN fk_stats;
        FUNCTION get_refered_count(v_parent_table varchar2, v_parent_id NUMBER) RETURN fk_refered_count;
        FUNCTION get_refered_count_cond(v_parent_table varchar2, v_cond_col varchar2, v_cond varchar2) RETURN fk_refered_count;
END FK_UTIL;
/

CREATE OR REPLACE package body FK_UTIL
IS
        FUNCTION get_refering_stats(v_table_name varchar2) RETURN fk_stats
        IS
                v_ret fk_stats := fk_stats();
        BEGIN
                SELECT CAST(
                        multiset(
                                SELECT a.TABLE_NAME 从表, a.column_name 外键列,  b.TABLE_NAME 主表, b.column_name 被引用列
                                FROM (
                                        SELECT  uc.TABLE_NAME, ucc.column_name, uc.r_constraint_name
                                        FROM    user_constraints uc
                                        JOIN    user_cons_columns ucc
                                        ON      uc.constraint_name = ucc.constraint_name
                                        WHERE uc.constraint_type='R'
                                        ) a,
                                        (
                                        SELECT  uc.TABLE_NAME, ucc.column_name, uc.constraint_name
                                        FROM    user_constraints uc
                                        JOIN    user_cons_columns ucc
                                        ON      uc.constraint_name = ucc.constraint_name
                                        ) b
                                WHERE
                                        a.r_constraint_name = b.constraint_name
                                        AND a.TABLE_NAME = UPPER(v_table_name)
                        ) AS fk_stats
                ) INTO v_ret FROM dual;
                RETURN v_ret;
        END get_refering_stats;
       
        FUNCTION get_refered_stats(v_table_name varchar2) RETURN fk_stats
        IS
                v_ret fk_stats := fk_stats();
        BEGIN
                SELECT CAST(
                        multiset(
                                SELECT a.TABLE_NAME 从表, a.column_name 外键列,  b.TABLE_NAME 主表, b.column_name 被引用列
                                FROM (
                                        SELECT  uc.TABLE_NAME, ucc.column_name, uc.r_constraint_name
                                        FROM    user_constraints uc
                                        JOIN    user_cons_columns ucc
                                        ON      uc.constraint_name = ucc.constraint_name
                                        WHERE uc.constraint_type='R'
                                        ) a,
                                        (
                                        SELECT  uc.TABLE_NAME, ucc.column_name, uc.constraint_name
                                        FROM    user_constraints uc
                                        JOIN    user_cons_columns ucc
                                        ON      uc.constraint_name = ucc.constraint_name
                                        ) b
                                WHERE
                                        a.r_constraint_name = b.constraint_name
                                        AND b.TABLE_NAME = UPPER(v_table_name)
                        ) AS fk_stats
                ) INTO v_ret FROM dual;
                RETURN v_ret;
        END get_refered_stats;
       
        FUNCTION get_refered_count(v_parent_table varchar2, v_parent_id NUMBER) RETURN fk_refered_count
        IS
                v_ret fk_refered_count := fk_refered_count();
                v_count NUMBER := 0;
                v_sql varchar2(2000) := '';
        BEGIN
                FOR v_row IN (SELECT * FROM TABLE(get_refered_stats(v_parent_table))) loop
                        v_sql := 'select count(*) from '|| v_row.child_table ||' where ' || v_row.child_table_fk_col || ' = ' || v_parent_id;
                        EXECUTE immediate v_sql INTO v_count;
                        v_ret.extend(1);
                        v_ret(v_ret.COUNT) := fk_refered_count_row(v_row.child_table, v_parent_id, v_count);
                END loop;
                RETURN v_ret;
        END get_refered_count;
   
        FUNCTION get_refered_count_cond(v_parent_table varchar2, v_cond_col varchar2, v_cond varchar2) RETURN fk_refered_count
        IS
                v_ret fk_refered_count := fk_refered_count();
                v_id_array id_array := id_array();
                v_sql varchar2(2000) := '';
        BEGIN
                IF UPPER(v_cond_col) LIKE '%ID' THEN
                        v_sql := 'select cast(multiset(select id from ' || v_parent_table || ' where '|| v_cond_col ||'=' || v_cond || ') as id_array) from dual';
                ELSE
                        v_sql := 'select cast(multiset(select id from ' || v_parent_table || ' where '|| v_cond_col ||'=''' || v_cond || ''') as id_array) from dual';
                END IF;
                EXECUTE immediate v_sql INTO v_id_array;
                FOR id_row IN (SELECT * FROM TABLE(v_id_array)) loop
                        FOR count_row IN (SELECT * FROM TABLE(get_refered_count(v_parent_table, id_row.column_value))) loop
                                v_ret.extend(1);
                                v_ret(v_ret.COUNT) := fk_refered_count_row(count_row.child_table, count_row.parent_id, count_row.refer_count);
                        END loop;
                END loop;
                RETURN v_ret;
        END get_refered_count_cond;
END FK_UTIL;
/


prompt 字符串分割脚本套件...

CREATE OR REPLACE TYPE string_array AS TABLE OF varchar2(2000);
/

CREATE OR REPLACE package STRING_UTIL
IS
        -- 分割字符串为数组
        FUNCTION split_string (p_str IN varchar2, p_sep IN varchar2 DEFAULT ',') RETURN string_array;
        -- 两个字符串数组合并
        FUNCTION string_array_add(p_array1 string_array, p_array2 string_array) RETURN string_array;
END STRING_UTIL;
/

CREATE OR REPLACE package body STRING_UTIL
IS
        FUNCTION split_string (
                p_str IN varchar2,
                p_sep IN varchar2 DEFAULT ','
        )
                RETURN string_array
        IS
                l_str long := p_str || p_sep;
                l_str_array string_array := string_array();
                l_element varchar2(2000);
        BEGIN
                while l_str IS NOT NULL loop
                        l_element := rtrim(
                                        substr(
                                   l_str, 1, instr(l_str,p_sep)
                                        ),
                                        p_sep
                        );
                        IF l_element IS NOT NULL THEN
                                l_str_array.extend(1);
                                l_str_array(l_str_array.COUNT) := l_element;
                        END IF;
                        l_str := substr(l_str, instr(l_str,p_sep) + 1);
                END loop;
                RETURN l_str_array;
        END split_string;
       
        FUNCTION string_array_add(p_array1 string_array, p_array2 string_array)
        RETURN string_array
        IS
                l_result string_array := string_array();
                l_ele1 varchar2(4000);
                l_ele2 varchar2(4000);
                v_count NUMBER := 0;
                cursor cur_array1 IS SELECT * FROM TABLE(p_array1);
                cursor cur_array2 IS SELECT * FROM TABLE(p_array2);
        BEGIN
                OPEN cur_array1;
                OPEN cur_array2;
               
                fetch cur_array1 INTO l_ele1;
                fetch cur_array2 INTO l_ele2;
               
                while cur_array1%found loop
                        IF l_ele1 IS NOT NULL THEN
                                l_result.extend(1);
                                l_result(l_result.COUNT) := l_ele1;
                        END IF;
                fetch cur_array1 INTO l_ele1;
                END loop;
       
                v_count := 0;
                while cur_array2%found loop
                IF l_ele2 IS NOT NULL THEN
                                v_count := v_count + 1;
                        IF v_count > l_result.COUNT THEN
                                l_result.extend(1);
                        END IF;
                                l_result(v_count) := to_char(to_number(nvl(l_result(v_count), '0')) + to_number(nvl(l_ele2, '0')));
                END IF;
                        fetch cur_array2 INTO l_ele2;
                END loop;
       
                close cur_array2;
                close cur_array1;
               
                RETURN l_result;
        END string_array_add;
END STRING_UTIL;
/

prompt  JOIN函数...
CREATE OR REPLACE FUNCTION JOIN
(
    p_cursor sys_refcursor,
    p_del varchar2 := ','
) RETURN varchar2
IS
    l_value   varchar2(32767);
    l_result  varchar2(32767);
BEGIN
    loop
        fetch p_cursor INTO l_value;
        exit WHEN p_cursor%notfound;
        IF l_result IS NOT NULL THEN
            l_result := l_result || p_del;
        END IF;
        l_result := l_result || l_value;
    END loop;
    close p_cursor;
    RETURN l_result;
END JOIN;
/

prompt 添加字符串聚合函数...

CREATE OR REPLACE TYPE T_LINK_STR AS OBJECT (
    STR VARCHAR2(30000),
    STATIC FUNCTION ODCIAGGREGATEINITIALIZE(SCTX IN OUT T_LINK_STR) RETURN NUMBER,
    MEMBER FUNCTION ODCIAGGREGATEITERATE(SELF IN OUT T_LINK_STR, VALUE IN VARCHAR2) RETURN NUMBER,
    MEMBER FUNCTION ODCIAGGREGATETERMINATE(SELF IN T_LINK_STR, RETURNVALUE OUT VARCHAR2, FLAGS IN NUMBER) RETURN NUMBER,
    MEMBER FUNCTION ODCIAGGREGATEMERGE(SELF IN OUT T_LINK_STR, CTX2 IN T_LINK_STR) RETURN NUMBER
    );
/

CREATE OR REPLACE TYPE BODY T_LINK_STR IS 
 STATIC FUNCTION ODCIAGGREGATEINITIALIZE(SCTX IN OUT T_LINK_STR) RETURN NUMBER IS
   BEGIN
     SCTX := T_LINK_STR(NULL);
     RETURN ODCICONST.SUCCESS;
   END; 
  MEMBER FUNCTION ODCIAGGREGATEITERATE(SELF IN OUT T_LINK_STR, VALUE IN VARCHAR2) RETURN NUMBER IS
   BEGIN
     SELF.STR := SELF.STR || VALUE||';';
     RETURN ODCICONST.SUCCESS;
   END; 
  MEMBER FUNCTION ODCIAGGREGATETERMINATE(SELF IN T_LINK_STR, RETURNVALUE OUT VARCHAR2, FLAGS IN NUMBER) RETURN NUMBER IS
   BEGIN
     RETURNVALUE := SELF.STR;
     RETURN ODCICONST.SUCCESS;
   END;
 
   MEMBER FUNCTION ODCIAGGREGATEMERGE(SELF IN OUT T_LINK_STR, CTX2 IN T_LINK_STR) RETURN NUMBER IS
    BEGIN
      NULL;
      RETURN ODCICONST.SUCCESS;
    END;
END;
/

CREATE OR REPLACE FUNCTION STR_SUM(P_STR VARCHAR2) RETURN VARCHAR2
 PARALLEL_ENABLE AGGREGATE USING T_LINK_STR;
/

prompt 进制转换函数...
CREATE OR REPLACE FUNCTION to_base( p_dec IN NUMBER, p_base IN NUMBER )
RETURN varchar2
IS
        l_str varchar2(255) DEFAULT NULL;
        l_num NUMBER DEFAULT p_dec;
        l_hex varchar2(16) DEFAULT '0123456789ABCDEF';
BEGIN
        IF ( p_dec IS NULL OR p_base IS NULL ) THEN
                RETURN NULL;
        END IF;
        IF ( trunc(p_dec) <> p_dec OR p_dec < 0 ) THEN
                raise PROGRAM_ERROR;
        END IF;
        loop
                l_str := substr( l_hex, MOD(l_num,p_base)+1, 1 ) || l_str;
                l_num := trunc( l_num/p_base );
                exit WHEN ( l_num = 0 );
        END loop;
        RETURN l_str;
END to_base;
/

CREATE OR REPLACE FUNCTION to_dec(
        p_str IN varchar2,
        p_from_base IN NUMBER DEFAULT 16 )
RETURN NUMBER
IS
        l_num   NUMBER DEFAULT 0;
        l_hex   varchar2(16) DEFAULT '0123456789ABCDEF';
BEGIN
        IF ( p_str IS NULL OR p_from_base IS NULL ) THEN
                RETURN NULL;
        END IF;
        FOR i IN 1 .. LENGTH(p_str) loop
                l_num := l_num * p_from_base + instr(l_hex,UPPER(substr(p_str,i,1)))-1;
        END loop;
        RETURN l_num;
END to_dec;
/

CREATE OR REPLACE FUNCTION to_hex( p_dec IN NUMBER ) RETURN varchar2
IS
BEGIN
 RETURN to_base( p_dec, 16 );
END to_hex;
/

CREATE OR REPLACE FUNCTION to_bin( p_dec IN NUMBER ) RETURN varchar2
IS
BEGIN
 RETURN to_base( p_dec, 2 );
END to_bin;
/

CREATE OR REPLACE FUNCTION to_oct( p_dec IN NUMBER ) RETURN varchar2
IS
BEGIN
 RETURN to_base( p_dec, 8 );
END to_oct;
/

prompt MD5函数...
CREATE OR REPLACE FUNCTION MD5(input_string VARCHAR2) RETURN varchar2
IS
    raw_input RAW(128);
    decrypted_raw RAW(2048);
    error_in_input_buffer_length EXCEPTION;
    BEGIN
    IF input_string IS NULL OR LENGTH(TRIM(input_string)) = 0then
      RETURN NULL;
    END IF;
    raw_input := UTL_RAW.CAST_TO_RAW(input_string);
    sys.dbms_obfuscation_toolkit.MD5(INPUT => raw_input, checksum => decrypted_raw);
    RETURN LOWER(rawtohex(decrypted_raw));
END MD5;
/

prompt 10进制转2进制...
CREATE OR REPLACE FUNCTION dec2bin (N IN NUMBER) RETURN VARCHAR2 IS
  binval VARCHAR2(64);
  N2     NUMBER := N;
BEGIN
  WHILE ( N2 > 0 ) LOOP
     binval := MOD(N2, 2) || binval;
     N2 := TRUNC( N2 / 2 );
  END LOOP;
  RETURN binval;
END dec2bin;
/

prompt 2进制转10进制...
CREATE OR REPLACE FUNCTION f_bin_to_dec(p_str IN VARCHAR2) RETURN VARCHAR2 IS
    v_return  VARCHAR2(4000);
  BEGIN
    SELECT SUM(data1) INTO v_return
      FROM (SELECT substr(p_str, rownum, 1) * power(2, length(p_str) - rownum) data1
              FROM dual
            CONNECT BY rownum <= length(p_str));
    RETURN v_return;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END f_bin_to_dec;
/

prompt weekstate...
CREATE OR REPLACE FUNCTION week_state_weeks (week_state IN NUMBER,start_week IN NUMBER) RETURN NUMBER IS
  weeks NUMBER(2);
  bin_str VARCHAR(64) := dec2bin(week_state);
  start_week2 NUMBER := length(bin_str) - start_week;
BEGIN
  IF start_week2 > 0 THEN
    weeks := length(replace(substr(bin_str,0,start_week2),'0',''));
  END IF;
  RETURN weeks;
END week_state_weeks;
/
set feedback on
prompt 脚本执行完成...
exit
