prompt PL/SQL Developer import file
prompt Created on 2014年2月11日 by zd
prompt Creating JB_INSTITUTIONS...
set feedback off
create table JB_INSTITUTIONS
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table JB_INSTITUTIONS
  is '高等学校/科研机构';
comment on column JB_INSTITUTIONS.id
  is '非业务主键';
comment on column JB_INSTITUTIONS.code
  is '代码';
comment on column JB_INSTITUTIONS.created_at
  is '创建时间';
comment on column JB_INSTITUTIONS.effective_at
  is '生效时间';
comment on column JB_INSTITUTIONS.eng_name
  is '英文名称';
comment on column JB_INSTITUTIONS.invalid_at
  is '失效时间';
comment on column JB_INSTITUTIONS.name
  is '名称';
comment on column JB_INSTITUTIONS.updated_at
  is '修改时间';
alter table JB_INSTITUTIONS
  add primary key (ID);
alter table JB_INSTITUTIONS
  add constraint UK_MN4JILPCQFF59LRT68YEVH5DP unique (CODE);

prompt Creating C_SCHOOLS...
create table C_SCHOOLS
(
  id             NUMBER(19) not null,
  institution_id NUMBER(10)
)
;
comment on table C_SCHOOLS
  is '学校信息';
comment on column C_SCHOOLS.id
  is '非业务主键';
comment on column C_SCHOOLS.institution_id
  is '研究机构 ID ###引用表名是JB_INSTITUTIONS### ';
alter table C_SCHOOLS
  add primary key (ID);
alter table C_SCHOOLS
  add constraint FK_15MCVK7O7SOA95WM76VLAS9VQ foreign key (INSTITUTION_ID)
  references JB_INSTITUTIONS (ID);

prompt Creating C_CAMPUSES...
create table C_CAMPUSES
(
  id           NUMBER(10) not null,
  created_at   TIMESTAMP(6),
  updated_at   TIMESTAMP(6),
  abbreviation VARCHAR2(255 CHAR),
  code         VARCHAR2(100 CHAR) not null,
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(500 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(255 CHAR) not null,
  remark       VARCHAR2(500 CHAR),
  school_id    NUMBER(19) not null
)
;
comment on table C_CAMPUSES
  is '校区信息';
comment on column C_CAMPUSES.id
  is '非业务主键';
comment on column C_CAMPUSES.created_at
  is '创建时间';
comment on column C_CAMPUSES.updated_at
  is '更新时间';
comment on column C_CAMPUSES.abbreviation
  is '基础信息简称';
comment on column C_CAMPUSES.code
  is '基础信息编码';
comment on column C_CAMPUSES.effective_at
  is '生效时间';
comment on column C_CAMPUSES.eng_name
  is '基础信息英文名';
comment on column C_CAMPUSES.invalid_at
  is '失效时间';
comment on column C_CAMPUSES.name
  is '基础信息名称';
comment on column C_CAMPUSES.remark
  is '备注';
comment on column C_CAMPUSES.school_id
  is '学校 ID ###引用表名是C_SCHOOLS### ';
alter table C_CAMPUSES
  add primary key (ID);
alter table C_CAMPUSES
  add constraint UK_LK6YWE1508GV52KPJOTE9M2SY unique (CODE);
alter table C_CAMPUSES
  add constraint FK_M9PHVIODH4RP1UJ35VLKJGL25 foreign key (SCHOOL_ID)
  references C_SCHOOLS (ID);

prompt Creating C_DEPARTMENTS...
create table C_DEPARTMENTS
(
  id           NUMBER(10) not null,
  created_at   TIMESTAMP(6),
  updated_at   TIMESTAMP(6),
  abbreviation VARCHAR2(255 CHAR),
  code         VARCHAR2(100 CHAR) not null,
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(500 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(255 CHAR) not null,
  remark       VARCHAR2(500 CHAR),
  college      NUMBER(1) not null,
  indexno      VARCHAR2(30 CHAR) not null,
  teaching     NUMBER(1) not null,
  school_id    NUMBER(19) not null,
  parent_id    NUMBER(10)
)
;
comment on table C_DEPARTMENTS
  is '部门组织机构信息';
comment on column C_DEPARTMENTS.id
  is '非业务主键';
comment on column C_DEPARTMENTS.created_at
  is '创建时间';
comment on column C_DEPARTMENTS.updated_at
  is '更新时间';
comment on column C_DEPARTMENTS.abbreviation
  is '基础信息简称';
comment on column C_DEPARTMENTS.code
  is '基础信息编码';
comment on column C_DEPARTMENTS.effective_at
  is '生效时间';
comment on column C_DEPARTMENTS.eng_name
  is '基础信息英文名';
comment on column C_DEPARTMENTS.invalid_at
  is '失效时间';
comment on column C_DEPARTMENTS.name
  is '基础信息名称';
comment on column C_DEPARTMENTS.remark
  is '备注';
comment on column C_DEPARTMENTS.college
  is '是否是院系';
comment on column C_DEPARTMENTS.indexno
  is '索引号';
comment on column C_DEPARTMENTS.teaching
  is '是否开课';
comment on column C_DEPARTMENTS.school_id
  is '学校 ID ###引用表名是C_SCHOOLS### ';
comment on column C_DEPARTMENTS.parent_id
  is '上级单位 ID ###引用表名是C_DEPARTMENTS### ';
alter table C_DEPARTMENTS
  add primary key (ID);
alter table C_DEPARTMENTS
  add constraint UK_HJ5YCLGK27J1EAUFO4UGLEYXU unique (CODE);
alter table C_DEPARTMENTS
  add constraint FK_4J0M4RE0LY2JJ0CLNLYMFDKJW foreign key (SCHOOL_ID)
  references C_SCHOOLS (ID);
alter table C_DEPARTMENTS
  add constraint FK_SND4R2E07C3KSQGXUQKDBLU69 foreign key (PARENT_ID)
  references C_DEPARTMENTS (ID);

prompt Creating C_CALENDARS...
create table C_CALENDARS
(
  id           NUMBER(10) not null,
  created_at   TIMESTAMP(6),
  updated_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(50 CHAR) not null,
  school_id    NUMBER(19) not null
)
;
comment on table C_CALENDARS
  is '日历方案';
comment on column C_CALENDARS.id
  is '非业务主键';
comment on column C_CALENDARS.created_at
  is '创建时间';
comment on column C_CALENDARS.updated_at
  is '更新时间';
comment on column C_CALENDARS.effective_at
  is '生效时间';
comment on column C_CALENDARS.invalid_at
  is '失效时间';
comment on column C_CALENDARS.name
  is '名称';
comment on column C_CALENDARS.school_id
  is '学校 ID ###引用表名是C_SCHOOLS### ';
alter table C_CALENDARS
  add primary key (ID);
alter table C_CALENDARS
  add constraint UK_B087U2SDUYX0EBLPAQFEK5P2S unique (NAME);
alter table C_CALENDARS
  add constraint FK_6KHSKD3PR54U73STF9TTC1G12 foreign key (SCHOOL_ID)
  references C_SCHOOLS (ID);

prompt Creating C_PROJECTS...
create table C_PROJECTS
(
  id           NUMBER(10) not null,
  created_at   TIMESTAMP(6),
  updated_at   TIMESTAMP(6),
  description  VARCHAR2(500 CHAR),
  effective_at TIMESTAMP(6) not null,
  invalid_at   TIMESTAMP(6),
  minor        NUMBER(1) not null,
  name         VARCHAR2(100 CHAR) not null,
  calendar_id  NUMBER(10),
  school_id    NUMBER(19) not null
)
;
comment on table C_PROJECTS
  is '项目';
comment on column C_PROJECTS.id
  is '非业务主键';
comment on column C_PROJECTS.created_at
  is '创建时间';
comment on column C_PROJECTS.updated_at
  is '更新时间';
comment on column C_PROJECTS.description
  is '描述';
comment on column C_PROJECTS.effective_at
  is '生效时间';
comment on column C_PROJECTS.invalid_at
  is '失效时间';
comment on column C_PROJECTS.minor
  is '是否辅修';
comment on column C_PROJECTS.name
  is '名称';
comment on column C_PROJECTS.calendar_id
  is '使用校历 ID ###引用表名是C_CALENDARS### ';
comment on column C_PROJECTS.school_id
  is '适用学校 ID ###引用表名是C_SCHOOLS### ';
alter table C_PROJECTS
  add primary key (ID);
alter table C_PROJECTS
  add constraint UK_7MVKQ699LKBEF30QCTUPOHDVI unique (NAME);
alter table C_PROJECTS
  add constraint FK_7YKY1N6K0UXJ79WJ7D2RO8IFQ foreign key (CALENDAR_ID)
  references C_CALENDARS (ID);
alter table C_PROJECTS
  add constraint FK_HC83P932DB640PPI91NBE0JY foreign key (SCHOOL_ID)
  references C_SCHOOLS (ID);

prompt Creating C_SEMESTERS...
create table C_SEMESTERS
(
  id            NUMBER(10) not null,
  archived      NUMBER(1) not null,
  begin_on      DATE not null,
  code          VARCHAR2(32 CHAR) not null,
  end_on        DATE not null,
  first_weekday NUMBER(10) not null,
  name          VARCHAR2(100 CHAR) not null,
  remark        VARCHAR2(200 CHAR),
  school_year   VARCHAR2(50 CHAR) not null,
  calendar_id   NUMBER(10) not null
)
;
comment on table C_SEMESTERS
  is '学年学期';
comment on column C_SEMESTERS.id
  is '非业务主键';
comment on column C_SEMESTERS.archived
  is '是否归档';
comment on column C_SEMESTERS.begin_on
  is '起始日期';
comment on column C_SEMESTERS.code
  is '编码';
comment on column C_SEMESTERS.end_on
  is '截止日期';
comment on column C_SEMESTERS.first_weekday
  is '星期中第一天,默认星期天';
comment on column C_SEMESTERS.name
  is '学期名称';
comment on column C_SEMESTERS.remark
  is '备注';
comment on column C_SEMESTERS.school_year
  is '学年度,格式2005-2006';
comment on column C_SEMESTERS.calendar_id
  is '教学日历方案类别 ID ###引用表名是C_CALENDARS### ';
alter table C_SEMESTERS
  add primary key (ID);
alter table C_SEMESTERS
  add constraint UK_AAAGHUJRYX6R752AYURT1EMT1 unique (CALENDAR_ID, CODE);
alter table C_SEMESTERS
  add constraint FK_49DMTLGMJH2CTV8QXJFM6NDR4 foreign key (CALENDAR_ID)
  references C_CALENDARS (ID);

prompt Creating HB_ROOM_USAGES...
create table HB_ROOM_USAGES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_ROOM_USAGES
  is '教室占用情况';
comment on column HB_ROOM_USAGES.id
  is '非业务主键';
comment on column HB_ROOM_USAGES.code
  is '代码';
comment on column HB_ROOM_USAGES.created_at
  is '创建时间';
comment on column HB_ROOM_USAGES.effective_at
  is '生效时间';
comment on column HB_ROOM_USAGES.eng_name
  is '英文名称';
comment on column HB_ROOM_USAGES.invalid_at
  is '失效时间';
comment on column HB_ROOM_USAGES.name
  is '名称';
comment on column HB_ROOM_USAGES.updated_at
  is '修改时间';
alter table HB_ROOM_USAGES
  add primary key (ID);
alter table HB_ROOM_USAGES
  add constraint UK_6BRH5YUJYLYFSR6KAIJPVQBNJ unique (CODE);

prompt Creating SE_USERS...
create table SE_USERS
(
  dtype                    VARCHAR2(31 CHAR) not null,
  id                       NUMBER(19) not null,
  created_at               TIMESTAMP(6),
  updated_at               TIMESTAMP(6),
  effective_at             TIMESTAMP(6) not null,
  enabled                  NUMBER(1) not null,
  fullname                 VARCHAR2(50 CHAR) not null,
  invalid_at               TIMESTAMP(6),
  mail                     VARCHAR2(100 CHAR) not null,
  name                     VARCHAR2(40 CHAR) not null,
  password                 VARCHAR2(100 CHAR) not null,
  password_expired_at      TIMESTAMP(6),
  remark                   VARCHAR2(200 CHAR),
  default_password_updated NUMBER(1),
  mail_verified            NUMBER(1),
  creator_id               NUMBER(19)
)
;
comment on table SE_USERS
  is '系统用户';
comment on column SE_USERS.id
  is '非业务主键';
comment on column SE_USERS.created_at
  is '创建时间';
comment on column SE_USERS.updated_at
  is '更新时间';
comment on column SE_USERS.effective_at
  is '账户生效日期';
comment on column SE_USERS.enabled
  is '是否启用';
comment on column SE_USERS.fullname
  is '用户姓名';
comment on column SE_USERS.invalid_at
  is '账户失效日期';
comment on column SE_USERS.mail
  is '用户联系email';
comment on column SE_USERS.name
  is '名称';
comment on column SE_USERS.password
  is '用户密文';
comment on column SE_USERS.password_expired_at
  is '密码失效日期';
comment on column SE_USERS.remark
  is '备注';
comment on column SE_USERS.default_password_updated
  is '默认密码更新';
comment on column SE_USERS.mail_verified
  is '是否邮件验证';
comment on column SE_USERS.creator_id
  is '创建人 ID ###引用表名是SE_USERS### ';
alter table SE_USERS
  add primary key (ID);
alter table SE_USERS
  add constraint UK_IINIU79AUE79A8G2T0H2LBMA8 unique (NAME);
alter table SE_USERS
  add constraint FK_J4KTBFLY4IQIAW4BPOK9YXUJY foreign key (CREATOR_ID)
  references SE_USERS (ID);

prompt Creating CL_ROOM_APPLIES...
create table CL_ROOM_APPLIES
(
  id                     NUMBER(19) not null,
  created_at             TIMESTAMP(6),
  updated_at             TIMESTAMP(6),
  attendance             NUMBER(10) not null,
  attendee               VARCHAR2(255 CHAR),
  name                   VARCHAR2(255 CHAR),
  speaker                VARCHAR2(255 CHAR),
  date_begin             TIMESTAMP(6),
  date_end               TIMESTAMP(6),
  approve_at             TIMESTAMP(6),
  approved_remark        VARCHAR2(255 CHAR),
  addr                   VARCHAR2(255 CHAR),
  applicant              VARCHAR2(255 CHAR),
  email                  VARCHAR2(255 CHAR),
  mobile                 VARCHAR2(255 CHAR),
  depart_approve_at      TIMESTAMP(6),
  depart_approved_remark VARCHAR2(255 CHAR),
  hours                  FLOAT,
  is_approved            NUMBER(1),
  is_depart_approved     NUMBER(1),
  is_free                NUMBER(1),
  is_multimedia          NUMBER(1),
  money                  FLOAT,
  room_request           VARCHAR2(255 CHAR),
  time_request           VARCHAR2(255 CHAR),
  unit_attendance        NUMBER(10) not null,
  water_fee              FLOAT,
  project_id             NUMBER(10),
  approve_by_id          NUMBER(19),
  audit_depart_id        NUMBER(10),
  campus_id              NUMBER(10),
  depart_approve_by_id   NUMBER(19),
  semester_id            NUMBER(10),
  usage_id               NUMBER(10),
  user_id                NUMBER(19)
)
;
comment on table CL_ROOM_APPLIES
  is '教室申请记录';
comment on column CL_ROOM_APPLIES.id
  is '非业务主键';
comment on column CL_ROOM_APPLIES.created_at
  is '创建时间';
comment on column CL_ROOM_APPLIES.updated_at
  is '更新时间';
comment on column CL_ROOM_APPLIES.attendance
  is '出席人数';
comment on column CL_ROOM_APPLIES.attendee
  is '出席人员';
comment on column CL_ROOM_APPLIES.name
  is '名称';
comment on column CL_ROOM_APPLIES.speaker
  is '主讲人';
comment on column CL_ROOM_APPLIES.date_begin
  is '开始日期';
comment on column CL_ROOM_APPLIES.date_end
  is '结束日期';
comment on column CL_ROOM_APPLIES.approve_at
  is '物管审核时间';
comment on column CL_ROOM_APPLIES.approved_remark
  is '物管审核情况';
comment on column CL_ROOM_APPLIES.addr
  is '联系地址';
comment on column CL_ROOM_APPLIES.applicant
  is '申请人签名';
comment on column CL_ROOM_APPLIES.email
  is '电子邮件';
comment on column CL_ROOM_APPLIES.mobile
  is '手机';
comment on column CL_ROOM_APPLIES.depart_approve_at
  is '归口审核时间';
comment on column CL_ROOM_APPLIES.depart_approved_remark
  is '归口审核情况';
comment on column CL_ROOM_APPLIES.hours
  is '小时数';
comment on column CL_ROOM_APPLIES.is_approved
  is '物管审核情况';
comment on column CL_ROOM_APPLIES.is_depart_approved
  is '归口审核情况';
comment on column CL_ROOM_APPLIES.is_free
  is '是否具有营利性';
comment on column CL_ROOM_APPLIES.is_multimedia
  is '是否使用多媒体设备';
comment on column CL_ROOM_APPLIES.money
  is '金额';
comment on column CL_ROOM_APPLIES.room_request
  is '借用场所要求';
comment on column CL_ROOM_APPLIES.time_request
  is '借用时间要求';
comment on column CL_ROOM_APPLIES.unit_attendance
  is '每个教室单元需要的座位数';
comment on column CL_ROOM_APPLIES.water_fee
  is '水费';
comment on column CL_ROOM_APPLIES.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column CL_ROOM_APPLIES.approve_by_id
  is '物管审核人 ID ###引用表名是SE_USERS### ';
comment on column CL_ROOM_APPLIES.audit_depart_id
  is '归口部门 ID ###引用表名是C_DEPARTMENTS### ';
comment on column CL_ROOM_APPLIES.campus_id
  is '借用校区 ID ###引用表名是C_CAMPUSES### ';
comment on column CL_ROOM_APPLIES.depart_approve_by_id
  is '归口审核人 ID ###引用表名是SE_USERS### ';
comment on column CL_ROOM_APPLIES.semester_id
  is '学期 ID ###引用表名是C_SEMESTERS### ';
comment on column CL_ROOM_APPLIES.usage_id
  is '活动类型 ID ###引用表名是HB_ROOM_USAGES### ';
comment on column CL_ROOM_APPLIES.user_id
  is '操作人 ID ###引用表名是SE_USERS### ';
alter table CL_ROOM_APPLIES
  add primary key (ID);
alter table CL_ROOM_APPLIES
  add constraint FK_1FJI66SHMO1MF1PHCLMS7UF24 foreign key (USAGE_ID)
  references HB_ROOM_USAGES (ID);
alter table CL_ROOM_APPLIES
  add constraint FK_5JJ8ECA0ABW5K9A9DNP6KPC3Q foreign key (APPROVE_BY_ID)
  references SE_USERS (ID);
alter table CL_ROOM_APPLIES
  add constraint FK_8F4ARRGC149NOW8PFNY3VQBRI foreign key (USER_ID)
  references SE_USERS (ID);
alter table CL_ROOM_APPLIES
  add constraint FK_GY9I89MVDPSLNKOSFG4CBWSM0 foreign key (AUDIT_DEPART_ID)
  references C_DEPARTMENTS (ID);
alter table CL_ROOM_APPLIES
  add constraint FK_H3L8KP64RIVNA2O1YM088J6HS foreign key (CAMPUS_ID)
  references C_CAMPUSES (ID);
alter table CL_ROOM_APPLIES
  add constraint FK_IQKO14H33MREYUTCNUMM4JM2X foreign key (DEPART_APPROVE_BY_ID)
  references SE_USERS (ID);
alter table CL_ROOM_APPLIES
  add constraint FK_IVNWI1VUBD5V3GSR370LRUD9V foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table CL_ROOM_APPLIES
  add constraint FK_PIJ3MFE6KL6D18CJM74M9KUA3 foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);

prompt Creating CL_APPLY_TIME_UNITS...
create table CL_APPLY_TIME_UNITS
(
  id             NUMBER(19) not null,
  end_unit       NUMBER(10) not null,
  start_unit     NUMBER(10) not null,
  end_time       NUMBER(10) not null,
  start_time     NUMBER(10) not null,
  week_state     VARCHAR2(255 CHAR),
  week_state_num NUMBER(19) not null,
  weekday        NUMBER(10) not null,
  year           NUMBER(10) not null,
  apply_id       NUMBER(19)
)
;
comment on table CL_APPLY_TIME_UNITS
  is '申请时间段';
comment on column CL_APPLY_TIME_UNITS.id
  is '非业务主键';
comment on column CL_APPLY_TIME_UNITS.end_unit
  is '结束小节';
comment on column CL_APPLY_TIME_UNITS.start_unit
  is '开始小节';
comment on column CL_APPLY_TIME_UNITS.end_time
  is '结束时间';
comment on column CL_APPLY_TIME_UNITS.start_time
  is '开始时间';
comment on column CL_APPLY_TIME_UNITS.week_state
  is '时间按排在哪些教学周内 每年共53个周，该有效周也采用了长度为53的字符串表示.';
comment on column CL_APPLY_TIME_UNITS.week_state_num
  is '教学周占用的数表示';
comment on column CL_APPLY_TIME_UNITS.weekday
  is '安排在星期几. 数字取值在[1..7]范围内';
comment on column CL_APPLY_TIME_UNITS.year
  is '年份';
comment on column CL_APPLY_TIME_UNITS.apply_id
  is '教室申请 ID ###引用表名是CL_ROOM_APPLIES### ';
alter table CL_APPLY_TIME_UNITS
  add primary key (ID);
alter table CL_APPLY_TIME_UNITS
  add constraint FK_JXR2CXUPGNT2Q73SFI8ERCGG7 foreign key (APPLY_ID)
  references CL_ROOM_APPLIES (ID);

prompt Creating XB_CLASSROOM_TYPES...
create table XB_CLASSROOM_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table XB_CLASSROOM_TYPES
  is '教室类型';
comment on column XB_CLASSROOM_TYPES.id
  is '非业务主键';
comment on column XB_CLASSROOM_TYPES.code
  is '代码';
comment on column XB_CLASSROOM_TYPES.created_at
  is '创建时间';
comment on column XB_CLASSROOM_TYPES.effective_at
  is '生效时间';
comment on column XB_CLASSROOM_TYPES.eng_name
  is '英文名称';
comment on column XB_CLASSROOM_TYPES.invalid_at
  is '失效时间';
comment on column XB_CLASSROOM_TYPES.name
  is '名称';
comment on column XB_CLASSROOM_TYPES.updated_at
  is '修改时间';
alter table XB_CLASSROOM_TYPES
  add primary key (ID);
alter table XB_CLASSROOM_TYPES
  add constraint UK_49WIOFQXJ66BHOLAF0D47HHP7 unique (CODE);

prompt Creating C_BUILDINGS...
create table C_BUILDINGS
(
  id            NUMBER(10) not null,
  created_at    TIMESTAMP(6),
  updated_at    TIMESTAMP(6),
  abbreviation  VARCHAR2(255 CHAR),
  code          VARCHAR2(100 CHAR) not null,
  effective_at  TIMESTAMP(6) not null,
  eng_name      VARCHAR2(500 CHAR),
  invalid_at    TIMESTAMP(6),
  name          VARCHAR2(255 CHAR) not null,
  remark        VARCHAR2(500 CHAR),
  school_id     NUMBER(19) not null,
  campus_id     NUMBER(10) not null,
  department_id NUMBER(10)
)
;
comment on table C_BUILDINGS
  is '学校教学楼';
comment on column C_BUILDINGS.id
  is '非业务主键';
comment on column C_BUILDINGS.created_at
  is '创建时间';
comment on column C_BUILDINGS.updated_at
  is '更新时间';
comment on column C_BUILDINGS.abbreviation
  is '基础信息简称';
comment on column C_BUILDINGS.code
  is '基础信息编码';
comment on column C_BUILDINGS.effective_at
  is '生效时间';
comment on column C_BUILDINGS.eng_name
  is '基础信息英文名';
comment on column C_BUILDINGS.invalid_at
  is '失效时间';
comment on column C_BUILDINGS.name
  is '基础信息名称';
comment on column C_BUILDINGS.remark
  is '备注';
comment on column C_BUILDINGS.school_id
  is '学校 ID ###引用表名是C_SCHOOLS### ';
comment on column C_BUILDINGS.campus_id
  is '所在校区 ID ###引用表名是C_CAMPUSES### ';
comment on column C_BUILDINGS.department_id
  is '管理部门 ID ###引用表名是C_DEPARTMENTS### ';
alter table C_BUILDINGS
  add primary key (ID);
alter table C_BUILDINGS
  add constraint UK_CJFS8JU3JLVVH7S7TISVWS9MD unique (CODE);
alter table C_BUILDINGS
  add constraint FK_8IO7JILW04J325RPJYMCROEGT foreign key (CAMPUS_ID)
  references C_CAMPUSES (ID);
alter table C_BUILDINGS
  add constraint FK_HWWC8X4OU3FUKEKND7UCDE1F1 foreign key (SCHOOL_ID)
  references C_SCHOOLS (ID);
alter table C_BUILDINGS
  add constraint FK_T47U25Y4FKI9XILUW8FCN0FGK foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);

prompt Creating C_CLASSROOMS...
create table C_CLASSROOMS
(
  id            NUMBER(10) not null,
  created_at    TIMESTAMP(6),
  updated_at    TIMESTAMP(6),
  abbreviation  VARCHAR2(255 CHAR),
  code          VARCHAR2(100 CHAR) not null,
  effective_at  TIMESTAMP(6) not null,
  eng_name      VARCHAR2(500 CHAR),
  invalid_at    TIMESTAMP(6),
  name          VARCHAR2(255 CHAR) not null,
  remark        VARCHAR2(500 CHAR),
  capacity      NUMBER(10) not null,
  floor         NUMBER(10) not null,
  virtual       NUMBER(1) not null,
  school_id     NUMBER(19) not null,
  building_id   NUMBER(10),
  campus_id     NUMBER(10) not null,
  department_id NUMBER(10),
  type_id       NUMBER(10)
)
;
comment on table C_CLASSROOMS
  is '教室基本信息';
comment on column C_CLASSROOMS.id
  is '非业务主键';
comment on column C_CLASSROOMS.created_at
  is '创建时间';
comment on column C_CLASSROOMS.updated_at
  is '更新时间';
comment on column C_CLASSROOMS.abbreviation
  is '基础信息简称';
comment on column C_CLASSROOMS.code
  is '基础信息编码';
comment on column C_CLASSROOMS.effective_at
  is '生效时间';
comment on column C_CLASSROOMS.eng_name
  is '基础信息英文名';
comment on column C_CLASSROOMS.invalid_at
  is '失效时间';
comment on column C_CLASSROOMS.name
  is '基础信息名称';
comment on column C_CLASSROOMS.remark
  is '备注';
comment on column C_CLASSROOMS.capacity
  is '实际容量';
comment on column C_CLASSROOMS.floor
  is '教室所处楼层';
comment on column C_CLASSROOMS.virtual
  is '虚拟教室';
comment on column C_CLASSROOMS.school_id
  is '学校 ID ###引用表名是C_SCHOOLS### ';
comment on column C_CLASSROOMS.building_id
  is '所在教学楼 ID ###引用表名是C_BUILDINGS### ';
comment on column C_CLASSROOMS.campus_id
  is '所在校区 ID ###引用表名是C_CAMPUSES### ';
comment on column C_CLASSROOMS.department_id
  is '管理部门 ID ###引用表名是C_DEPARTMENTS### ';
comment on column C_CLASSROOMS.type_id
  is '设备配置代码 ID ###引用表名是XB_CLASSROOM_TYPES### ';
alter table C_CLASSROOMS
  add primary key (ID);
alter table C_CLASSROOMS
  add constraint UK_PHNHTC6XHRO0M4XFE1F7G6XOR unique (CODE);
alter table C_CLASSROOMS
  add constraint FK_2CNGJTH4ADF8Y45286JJSL8Y8 foreign key (CAMPUS_ID)
  references C_CAMPUSES (ID);
alter table C_CLASSROOMS
  add constraint FK_8G7V8YNSRILMRJEVSASWFXR0W foreign key (SCHOOL_ID)
  references C_SCHOOLS (ID);
alter table C_CLASSROOMS
  add constraint FK_J63MO0WDHU1HJ2P0EJNH1KJCN foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table C_CLASSROOMS
  add constraint FK_ND5SXJ0172YEDUN2MSQ7CKT72 foreign key (TYPE_ID)
  references XB_CLASSROOM_TYPES (ID);
alter table C_CLASSROOMS
  add constraint FK_S1RO5YDA7BHR6WUINNHGD7OVT foreign key (BUILDING_ID)
  references C_BUILDINGS (ID);

prompt Creating CL_OCCUPANCIES...
create table CL_OCCUPANCIES
(
  id             NUMBER(19) not null,
  comments       VARCHAR2(500 CHAR) not null,
  end_time       NUMBER(10) not null,
  start_time     NUMBER(10) not null,
  week_state     VARCHAR2(255 CHAR),
  week_state_num NUMBER(19) not null,
  weekday        NUMBER(10) not null,
  year           NUMBER(10) not null,
  userid         VARCHAR2(255 CHAR) not null,
  room_id        NUMBER(10),
  usage_id       NUMBER(10) not null
)
;
comment on table CL_OCCUPANCIES
  is '教室时间占用';
comment on column CL_OCCUPANCIES.id
  is '非业务主键';
comment on column CL_OCCUPANCIES.comments
  is '说明';
comment on column CL_OCCUPANCIES.end_time
  is '结束时间';
comment on column CL_OCCUPANCIES.start_time
  is '开始时间';
comment on column CL_OCCUPANCIES.week_state
  is '时间按排在哪些教学周内 每年共53个周，该有效周也采用了长度为53的字符串表示.';
comment on column CL_OCCUPANCIES.week_state_num
  is '教学周占用的数表示';
comment on column CL_OCCUPANCIES.weekday
  is '安排在星期几. 数字取值在[1..7]范围内';
comment on column CL_OCCUPANCIES.year
  is '年份';
comment on column CL_OCCUPANCIES.userid
  is '使用者';
comment on column CL_OCCUPANCIES.room_id
  is '教室 ID ###引用表名是C_CLASSROOMS### ';
comment on column CL_OCCUPANCIES.usage_id
  is '用途 ID ###引用表名是HB_ROOM_USAGES### ';
alter table CL_OCCUPANCIES
  add primary key (ID);
alter table CL_OCCUPANCIES
  add constraint FK_6AP480KN3NTRMA9W9Q55XB98 foreign key (USAGE_ID)
  references HB_ROOM_USAGES (ID);
alter table CL_OCCUPANCIES
  add constraint FK_C37C4WCVG68PWXVV5F99UHH84 foreign key (ROOM_ID)
  references C_CLASSROOMS (ID);

prompt Creating CL_PRICE_CATALOGS...
create table CL_PRICE_CATALOGS
(
  id            NUMBER(19) not null,
  published_on  DATE not null,
  remark        VARCHAR2(255 CHAR),
  campus_id     NUMBER(10),
  department_id NUMBER(10) not null
)
;
comment on table CL_PRICE_CATALOGS
  is '价目表';
comment on column CL_PRICE_CATALOGS.id
  is '非业务主键';
comment on column CL_PRICE_CATALOGS.published_on
  is '发布日期';
comment on column CL_PRICE_CATALOGS.remark
  is '备注';
comment on column CL_PRICE_CATALOGS.campus_id
  is '校区 ID ###引用表名是C_CAMPUSES### ';
comment on column CL_PRICE_CATALOGS.department_id
  is '发布部门 ID ###引用表名是C_DEPARTMENTS### ';
alter table CL_PRICE_CATALOGS
  add primary key (ID);
alter table CL_PRICE_CATALOGS
  add constraint FK_GGS1J5UROG7HHTND0LEQGGJ5S foreign key (CAMPUS_ID)
  references C_CAMPUSES (ID);
alter table CL_PRICE_CATALOGS
  add constraint FK_QSBFD7Q88ELYR3LJYARNOFYGD foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);

prompt Creating CL_PRICE_CONFIGS...
create table CL_PRICE_CONFIGS
(
  id                  NUMBER(19) not null,
  max_seats           NUMBER(10) not null,
  min_seats           NUMBER(10) not null,
  price               FLOAT not null,
  catalog_id          NUMBER(19) not null,
  room_config_type_id NUMBER(10) not null
)
;
comment on table CL_PRICE_CONFIGS
  is '各类教室的收费价格';
comment on column CL_PRICE_CONFIGS.id
  is '非业务主键';
comment on column CL_PRICE_CONFIGS.max_seats
  is '最大座位数';
comment on column CL_PRICE_CONFIGS.min_seats
  is '最小座位数';
comment on column CL_PRICE_CONFIGS.price
  is '价格';
comment on column CL_PRICE_CONFIGS.catalog_id
  is '价目表 ID ###引用表名是CL_PRICE_CATALOGS### ';
comment on column CL_PRICE_CONFIGS.room_config_type_id
  is '教室类型 ID ###引用表名是XB_CLASSROOM_TYPES### ';
alter table CL_PRICE_CONFIGS
  add primary key (ID);
alter table CL_PRICE_CONFIGS
  add constraint FK_1A0APW3T47HVRUOF4MU7RYKW3 foreign key (ROOM_CONFIG_TYPE_ID)
  references XB_CLASSROOM_TYPES (ID);
alter table CL_PRICE_CONFIGS
  add constraint FK_2B2MJSD3XT8DE2VP2TRR2AAOO foreign key (CATALOG_ID)
  references CL_PRICE_CATALOGS (ID);

prompt Creating CL_PRICE_CATALOGS_PRICES...
create table CL_PRICE_CATALOGS_PRICES
(
  price_catalog_id NUMBER(19) not null,
  price_config_id  NUMBER(19) not null
)
;
comment on table CL_PRICE_CATALOGS_PRICES
  is '价目表-校区';
comment on column CL_PRICE_CATALOGS_PRICES.price_catalog_id
  is '价目表 ID ###引用表名是CL_PRICE_CATALOGS### ';
comment on column CL_PRICE_CATALOGS_PRICES.price_config_id
  is '各类教室的收费价格 ID ###引用表名是CL_PRICE_CONFIGS### ';
alter table CL_PRICE_CATALOGS_PRICES
  add primary key (PRICE_CATALOG_ID, PRICE_CONFIG_ID);
alter table CL_PRICE_CATALOGS_PRICES
  add constraint UK_L3XUGC1J70CYVCFR3FPKRRR4N unique (PRICE_CONFIG_ID);
alter table CL_PRICE_CATALOGS_PRICES
  add constraint FK_38D9RVJQ1EYDIX81P9J5WGGWH foreign key (PRICE_CATALOG_ID)
  references CL_PRICE_CATALOGS (ID);
alter table CL_PRICE_CATALOGS_PRICES
  add constraint FK_L3XUGC1J70CYVCFR3FPKRRR4N foreign key (PRICE_CONFIG_ID)
  references CL_PRICE_CONFIGS (ID);

prompt Creating CL_PR_CATALOGS_AUDIT_DEPARTS...
create table CL_PR_CATALOGS_AUDIT_DEPARTS
(
  price_catalog_id NUMBER(19) not null,
  department_id    NUMBER(10) not null
)
;
comment on table CL_PR_CATALOGS_AUDIT_DEPARTS
  is '价目表-审核部门';
comment on column CL_PR_CATALOGS_AUDIT_DEPARTS.price_catalog_id
  is '价目表 ID ###引用表名是CL_PRICE_CATALOGS### ';
comment on column CL_PR_CATALOGS_AUDIT_DEPARTS.department_id
  is '部门组织机构信息 ID ###引用表名是C_DEPARTMENTS### ';
alter table CL_PR_CATALOGS_AUDIT_DEPARTS
  add primary key (PRICE_CATALOG_ID, DEPARTMENT_ID);
alter table CL_PR_CATALOGS_AUDIT_DEPARTS
  add constraint UK_ONR5BY5QEB69O12FXFXKDTH8R unique (DEPARTMENT_ID);
alter table CL_PR_CATALOGS_AUDIT_DEPARTS
  add constraint FK_ONR5BY5QEB69O12FXFXKDTH8R foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table CL_PR_CATALOGS_AUDIT_DEPARTS
  add constraint FK_QXYJGHIBXJF7XX15GW51G8UAF foreign key (PRICE_CATALOG_ID)
  references CL_PRICE_CATALOGS (ID);

prompt Creating CL_ROOM_APPLIES_CLASSROOMS...
create table CL_ROOM_APPLIES_CLASSROOMS
(
  room_apply_id NUMBER(19) not null,
  classroom_id  NUMBER(10) not null
)
;
comment on table CL_ROOM_APPLIES_CLASSROOMS
  is '教室申请记录-对应的教室记录';
comment on column CL_ROOM_APPLIES_CLASSROOMS.room_apply_id
  is '教室申请记录 ID ###引用表名是CL_ROOM_APPLIES### ';
comment on column CL_ROOM_APPLIES_CLASSROOMS.classroom_id
  is '教室基本信息 ID ###引用表名是C_CLASSROOMS### ';
alter table CL_ROOM_APPLIES_CLASSROOMS
  add constraint FK_JEFOLMNLE3IPP7XKAVTN441NU foreign key (CLASSROOM_ID)
  references C_CLASSROOMS (ID);
alter table CL_ROOM_APPLIES_CLASSROOMS
  add constraint FK_SFUDUXLW1BXXUUXYCMPPGUI07 foreign key (ROOM_APPLY_ID)
  references CL_ROOM_APPLIES (ID);

prompt Creating CL_ROOM_APPLIES_OCCUPATIONS...
create table CL_ROOM_APPLIES_OCCUPATIONS
(
  room_apply_id NUMBER(19) not null,
  occupancy_id  NUMBER(19) not null
)
;
comment on table CL_ROOM_APPLIES_OCCUPATIONS
  is '教室申请记录-对应的教室占用记录';
comment on column CL_ROOM_APPLIES_OCCUPATIONS.room_apply_id
  is '教室申请记录 ID ###引用表名是CL_ROOM_APPLIES### ';
comment on column CL_ROOM_APPLIES_OCCUPATIONS.occupancy_id
  is '教室时间占用 ID ###引用表名是CL_OCCUPANCIES### ';
alter table CL_ROOM_APPLIES_OCCUPATIONS
  add primary key (ROOM_APPLY_ID, OCCUPANCY_ID);
alter table CL_ROOM_APPLIES_OCCUPATIONS
  add constraint FK_2G9P8EDUOYS29TB83O5YA9BTG foreign key (ROOM_APPLY_ID)
  references CL_ROOM_APPLIES (ID);
alter table CL_ROOM_APPLIES_OCCUPATIONS
  add constraint FK_MPL1QGUFY7QBXPY70C23FE8CP foreign key (OCCUPANCY_ID)
  references CL_OCCUPANCIES (ID);

prompt Creating CL_ROOM_USAGE_CAPACITIES...
create table CL_ROOM_USAGE_CAPACITIES
(
  id           NUMBER(19) not null,
  capacity     NUMBER(10) not null,
  max_capacity NUMBER(10) not null,
  room_id      NUMBER(10),
  usage_id     NUMBER(10)
)
;
comment on table CL_ROOM_USAGE_CAPACITIES
  is '教室各用途容量';
comment on column CL_ROOM_USAGE_CAPACITIES.id
  is '非业务主键';
comment on column CL_ROOM_USAGE_CAPACITIES.capacity
  is '容量';
comment on column CL_ROOM_USAGE_CAPACITIES.max_capacity
  is '最大容量';
comment on column CL_ROOM_USAGE_CAPACITIES.room_id
  is '教室 ID ###引用表名是C_CLASSROOMS### ';
comment on column CL_ROOM_USAGE_CAPACITIES.usage_id
  is '用途 ID ###引用表名是HB_ROOM_USAGES### ';
alter table CL_ROOM_USAGE_CAPACITIES
  add primary key (ID);
alter table CL_ROOM_USAGE_CAPACITIES
  add constraint FK_B5HOFF3D984MU1S9IKHWD5HGB foreign key (USAGE_ID)
  references HB_ROOM_USAGES (ID);
alter table CL_ROOM_USAGE_CAPACITIES
  add constraint FK_PY7VMLPWULR2DS59GURRYUC7Q foreign key (ROOM_ID)
  references C_CLASSROOMS (ID);

prompt Creating HB_EDUCATIONS...
create table HB_EDUCATIONS
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_EDUCATIONS
  is '学历层次';
comment on column HB_EDUCATIONS.id
  is '非业务主键';
comment on column HB_EDUCATIONS.code
  is '代码';
comment on column HB_EDUCATIONS.created_at
  is '创建时间';
comment on column HB_EDUCATIONS.effective_at
  is '生效时间';
comment on column HB_EDUCATIONS.eng_name
  is '英文名称';
comment on column HB_EDUCATIONS.invalid_at
  is '失效时间';
comment on column HB_EDUCATIONS.name
  is '名称';
comment on column HB_EDUCATIONS.updated_at
  is '修改时间';
alter table HB_EDUCATIONS
  add primary key (ID);
alter table HB_EDUCATIONS
  add constraint UK_C2II5R7VQY2H6W771EYAO1KET unique (CODE);

prompt Creating HB_EXAM_MODES...
create table HB_EXAM_MODES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_EXAM_MODES
  is '考核方式';
comment on column HB_EXAM_MODES.id
  is '非业务主键';
comment on column HB_EXAM_MODES.code
  is '代码';
comment on column HB_EXAM_MODES.created_at
  is '创建时间';
comment on column HB_EXAM_MODES.effective_at
  is '生效时间';
comment on column HB_EXAM_MODES.eng_name
  is '英文名称';
comment on column HB_EXAM_MODES.invalid_at
  is '失效时间';
comment on column HB_EXAM_MODES.name
  is '名称';
comment on column HB_EXAM_MODES.updated_at
  is '修改时间';
alter table HB_EXAM_MODES
  add primary key (ID);
alter table HB_EXAM_MODES
  add constraint UK_7FGHCEN2Y5KW2LOC0W97IDYXW unique (CODE);

prompt Creating XB_STD_TYPES...
create table XB_STD_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table XB_STD_TYPES
  is '学生类别';
comment on column XB_STD_TYPES.id
  is '非业务主键';
comment on column XB_STD_TYPES.code
  is '代码';
comment on column XB_STD_TYPES.created_at
  is '创建时间';
comment on column XB_STD_TYPES.effective_at
  is '生效时间';
comment on column XB_STD_TYPES.eng_name
  is '英文名称';
comment on column XB_STD_TYPES.invalid_at
  is '失效时间';
comment on column XB_STD_TYPES.name
  is '名称';
comment on column XB_STD_TYPES.updated_at
  is '修改时间';
alter table XB_STD_TYPES
  add primary key (ID);
alter table XB_STD_TYPES
  add constraint UK_9CN9Q5SO7T2XWCUEFKC1P3D26 unique (CODE);

prompt Creating COURSE_MODIFIEDS...
create table COURSE_MODIFIEDS
(
  id            NUMBER(19) not null,
  code          VARCHAR2(255 CHAR),
  credits       FLOAT not null,
  name          VARCHAR2(255 CHAR),
  period        NUMBER(10),
  weeks         NUMBER(10),
  department_id NUMBER(10),
  education_id  NUMBER(10),
  exam_mode_id  NUMBER(10),
  std_type_id   NUMBER(10)
)
;
alter table COURSE_MODIFIEDS
  add primary key (ID);
alter table COURSE_MODIFIEDS
  add constraint FK_9GGJX8E61V5540BFQ7Y7QDQD7 foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);
alter table COURSE_MODIFIEDS
  add constraint FK_I84R87SMFNFGMC554HXICH97K foreign key (STD_TYPE_ID)
  references XB_STD_TYPES (ID);
alter table COURSE_MODIFIEDS
  add constraint FK_OBYMSM9GU3UH1LYXRLG4NO38M foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table COURSE_MODIFIEDS
  add constraint FK_QRRBP2CFXCAFYJVQ4PMW3VDNQ foreign key (EXAM_MODE_ID)
  references HB_EXAM_MODES (ID);

prompt Creating XB_COURSE_CATEGORIES...
create table XB_COURSE_CATEGORIES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table XB_COURSE_CATEGORIES
  is '课程种类';
comment on column XB_COURSE_CATEGORIES.id
  is '非业务主键';
comment on column XB_COURSE_CATEGORIES.code
  is '代码';
comment on column XB_COURSE_CATEGORIES.created_at
  is '创建时间';
comment on column XB_COURSE_CATEGORIES.effective_at
  is '生效时间';
comment on column XB_COURSE_CATEGORIES.eng_name
  is '英文名称';
comment on column XB_COURSE_CATEGORIES.invalid_at
  is '失效时间';
comment on column XB_COURSE_CATEGORIES.name
  is '名称';
comment on column XB_COURSE_CATEGORIES.updated_at
  is '修改时间';
alter table XB_COURSE_CATEGORIES
  add primary key (ID);
alter table XB_COURSE_CATEGORIES
  add constraint UK_CU61LOXOEBW859G5BME5F1D6H unique (CODE);

prompt Creating XB_COURSE_TYPES...
create table XB_COURSE_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6),
  theoretical  NUMBER(1) not null
)
;
comment on table XB_COURSE_TYPES
  is '课程类别';
comment on column XB_COURSE_TYPES.id
  is '非业务主键';
comment on column XB_COURSE_TYPES.code
  is '代码';
comment on column XB_COURSE_TYPES.created_at
  is '创建时间';
comment on column XB_COURSE_TYPES.effective_at
  is '生效时间';
comment on column XB_COURSE_TYPES.eng_name
  is '英文名称';
comment on column XB_COURSE_TYPES.invalid_at
  is '失效时间';
comment on column XB_COURSE_TYPES.name
  is '名称';
comment on column XB_COURSE_TYPES.updated_at
  is '修改时间';
comment on column XB_COURSE_TYPES.theoretical
  is '是否理论课:true:理论课 false:实践课';
alter table XB_COURSE_TYPES
  add primary key (ID);
alter table XB_COURSE_TYPES
  add constraint UK_MBMLWQOVI6R42DD77FSCSVN8I unique (CODE);

prompt Creating HB_SCORE_MARK_STYLES...
create table HB_SCORE_MARK_STYLES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6),
  num_style    NUMBER(1) not null
)
;
comment on table HB_SCORE_MARK_STYLES
  is '成绩记录方式';
comment on column HB_SCORE_MARK_STYLES.id
  is '非业务主键';
comment on column HB_SCORE_MARK_STYLES.code
  is '代码';
comment on column HB_SCORE_MARK_STYLES.created_at
  is '创建时间';
comment on column HB_SCORE_MARK_STYLES.effective_at
  is '生效时间';
comment on column HB_SCORE_MARK_STYLES.eng_name
  is '英文名称';
comment on column HB_SCORE_MARK_STYLES.invalid_at
  is '失效时间';
comment on column HB_SCORE_MARK_STYLES.name
  is '名称';
comment on column HB_SCORE_MARK_STYLES.updated_at
  is '修改时间';
comment on column HB_SCORE_MARK_STYLES.num_style
  is '是否为数字类型';
alter table HB_SCORE_MARK_STYLES
  add primary key (ID);
alter table HB_SCORE_MARK_STYLES
  add constraint UK_C73T2911U4WV31W788GE9LWCO unique (CODE);

prompt Creating T_COURSES...
create table T_COURSES
(
  id             NUMBER(19) not null,
  created_at     TIMESTAMP(6),
  updated_at     TIMESTAMP(6),
  code           VARCHAR2(32 CHAR) not null,
  credits        FLOAT not null,
  enabled        NUMBER(1) not null,
  eng_name       VARCHAR2(300 CHAR),
  establish_on   TIMESTAMP(6),
  exchange       NUMBER(1) not null,
  name           VARCHAR2(255 CHAR) not null,
  period         NUMBER(10) not null,
  remark         VARCHAR2(500 CHAR),
  week_hour      NUMBER(10) not null,
  weeks          NUMBER(10),
  project_id     NUMBER(10),
  category_id    NUMBER(10),
  course_type_id NUMBER(10),
  department_id  NUMBER(10),
  education_id   NUMBER(10),
  exam_mode_id   NUMBER(10),
  mark_style_id  NUMBER(10)
)
;
comment on table T_COURSES
  is '课程基本信息';
comment on column T_COURSES.id
  is '非业务主键';
comment on column T_COURSES.created_at
  is '创建时间';
comment on column T_COURSES.updated_at
  is '更新时间';
comment on column T_COURSES.code
  is '课程代码';
comment on column T_COURSES.credits
  is '学分';
comment on column T_COURSES.enabled
  is '课程使用状态';
comment on column T_COURSES.eng_name
  is '课程英文名';
comment on column T_COURSES.establish_on
  is '设立时间';
comment on column T_COURSES.exchange
  is '是否外校交流课程';
comment on column T_COURSES.name
  is '课程名称';
comment on column T_COURSES.period
  is '学时/总课时';
comment on column T_COURSES.remark
  is '课程备注';
comment on column T_COURSES.week_hour
  is '周课时';
comment on column T_COURSES.weeks
  is '周数';
comment on column T_COURSES.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column T_COURSES.category_id
  is '课程种类代码 ID ###引用表名是XB_COURSE_CATEGORIES### ';
comment on column T_COURSES.course_type_id
  is '建议课程类别 ID ###引用表名是XB_COURSE_TYPES### ';
comment on column T_COURSES.department_id
  is '院系 ID ###引用表名是C_DEPARTMENTS### ';
comment on column T_COURSES.education_id
  is '学历层次 ID ###引用表名是HB_EDUCATIONS### ';
comment on column T_COURSES.exam_mode_id
  is '考试方式 ID ###引用表名是HB_EXAM_MODES### ';
comment on column T_COURSES.mark_style_id
  is '成绩记录方式 ID ###引用表名是HB_SCORE_MARK_STYLES### ';
alter table T_COURSES
  add primary key (ID);
alter table T_COURSES
  add constraint UK_391Y9IVX62SC27NY8QIY1ATGT unique (CODE);
alter table T_COURSES
  add constraint FK_7FOS1HCTP3WMRR4HJJ6WV6UGI foreign key (MARK_STYLE_ID)
  references HB_SCORE_MARK_STYLES (ID);
alter table T_COURSES
  add constraint FK_B11GNR4EUADCRKYM33A3H9OCL foreign key (EXAM_MODE_ID)
  references HB_EXAM_MODES (ID);
alter table T_COURSES
  add constraint FK_CBV2X85E274UA5YCF8HPUJWBW foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table T_COURSES
  add constraint FK_DLY2GW9251WC67S93XMBYV4JK foreign key (COURSE_TYPE_ID)
  references XB_COURSE_TYPES (ID);
alter table T_COURSES
  add constraint FK_DX8YNIWIIREUDL7439AUS8FV3 foreign key (CATEGORY_ID)
  references XB_COURSE_CATEGORIES (ID);
alter table T_COURSES
  add constraint FK_G952L84BCNG1LKUK53GHT0QSS foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table T_COURSES
  add constraint FK_SRG32XXJ4UHC662IVD0YL8IIV foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);

prompt Creating COURSE_MODIFIED_RECORDS...
create table COURSE_MODIFIED_RECORDS
(
  id              NUMBER(19) not null,
  apply_at        TIMESTAMP(6),
  reason          VARCHAR2(500 CHAR) not null,
  reply_at        TIMESTAMP(6),
  status          NUMBER(1),
  apply_user_id   NUMBER(19),
  course_id       NUMBER(19),
  new_modified_id NUMBER(19),
  reply_user_id   NUMBER(19)
)
;
alter table COURSE_MODIFIED_RECORDS
  add primary key (ID);
alter table COURSE_MODIFIED_RECORDS
  add constraint FK_CSLCCLIN8WAYNOU34V4XK4N9R foreign key (APPLY_USER_ID)
  references SE_USERS (ID);
alter table COURSE_MODIFIED_RECORDS
  add constraint FK_IUA3P3VWYWIPOXRIYYFS4O3TV foreign key (NEW_MODIFIED_ID)
  references COURSE_MODIFIEDS (ID);
alter table COURSE_MODIFIED_RECORDS
  add constraint FK_L2YYMX57FCUNL80WK552C6B6W foreign key (COURSE_ID)
  references T_COURSES (ID);
alter table COURSE_MODIFIED_RECORDS
  add constraint FK_N9YRON5ULLCTX6W5UU0G4AU7J foreign key (REPLY_USER_ID)
  references SE_USERS (ID);

prompt Creating JB_DISCIPLINE_CATEGORIES...
create table JB_DISCIPLINE_CATEGORIES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table JB_DISCIPLINE_CATEGORIES
  is '学科门类';
comment on column JB_DISCIPLINE_CATEGORIES.id
  is '非业务主键';
comment on column JB_DISCIPLINE_CATEGORIES.code
  is '代码';
comment on column JB_DISCIPLINE_CATEGORIES.created_at
  is '创建时间';
comment on column JB_DISCIPLINE_CATEGORIES.effective_at
  is '生效时间';
comment on column JB_DISCIPLINE_CATEGORIES.eng_name
  is '英文名称';
comment on column JB_DISCIPLINE_CATEGORIES.invalid_at
  is '失效时间';
comment on column JB_DISCIPLINE_CATEGORIES.name
  is '名称';
comment on column JB_DISCIPLINE_CATEGORIES.updated_at
  is '修改时间';
alter table JB_DISCIPLINE_CATEGORIES
  add primary key (ID);
alter table JB_DISCIPLINE_CATEGORIES
  add constraint UK_RLO2Y0BUECORK146VLT66EKEY unique (CODE);

prompt Creating C_MAJORS...
create table C_MAJORS
(
  id           NUMBER(10) not null,
  created_at   TIMESTAMP(6),
  updated_at   TIMESTAMP(6),
  abbreviation VARCHAR2(30 CHAR),
  code         VARCHAR2(32 CHAR) not null,
  duration     FLOAT not null,
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(255 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  remark       VARCHAR2(500 CHAR),
  category_id  NUMBER(10),
  project_id   NUMBER(10) not null
)
;
comment on table C_MAJORS
  is '专业';
comment on column C_MAJORS.id
  is '非业务主键';
comment on column C_MAJORS.created_at
  is '创建时间';
comment on column C_MAJORS.updated_at
  is '更新时间';
comment on column C_MAJORS.abbreviation
  is '简称';
comment on column C_MAJORS.code
  is '专业编码';
comment on column C_MAJORS.duration
  is '修读年限';
comment on column C_MAJORS.effective_at
  is '生效时间';
comment on column C_MAJORS.eng_name
  is '专业英文名';
comment on column C_MAJORS.invalid_at
  is '失效时间';
comment on column C_MAJORS.name
  is '专业名称';
comment on column C_MAJORS.remark
  is '备注';
comment on column C_MAJORS.category_id
  is '学科门类 ID ###引用表名是JB_DISCIPLINE_CATEGORIES### ';
comment on column C_MAJORS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
alter table C_MAJORS
  add primary key (ID);
alter table C_MAJORS
  add constraint UK_P513EH36YI1HK4VPM3UV1ABEK unique (CODE);
alter table C_MAJORS
  add constraint FK_456GCC452OLI7VKD7RIKNK38X foreign key (CATEGORY_ID)
  references JB_DISCIPLINE_CATEGORIES (ID);
alter table C_MAJORS
  add constraint FK_JV2BEBNBIWN50SUCLQYRXNWDN foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating C_DIRECTIONS...
create table C_DIRECTIONS
(
  id           NUMBER(10) not null,
  created_at   TIMESTAMP(6),
  updated_at   TIMESTAMP(6),
  code         VARCHAR2(32 CHAR) not null,
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(255 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  remark       VARCHAR2(500 CHAR),
  major_id     NUMBER(10) not null
)
;
comment on table C_DIRECTIONS
  is '方向信息 专业领域.';
comment on column C_DIRECTIONS.id
  is '非业务主键';
comment on column C_DIRECTIONS.created_at
  is '创建时间';
comment on column C_DIRECTIONS.updated_at
  is '更新时间';
comment on column C_DIRECTIONS.code
  is '专业方向编码';
comment on column C_DIRECTIONS.effective_at
  is '生效时间';
comment on column C_DIRECTIONS.eng_name
  is '专业方向英文名';
comment on column C_DIRECTIONS.invalid_at
  is '失效时间';
comment on column C_DIRECTIONS.name
  is '专业方向名称';
comment on column C_DIRECTIONS.remark
  is '备注';
comment on column C_DIRECTIONS.major_id
  is '所属专业 ID ###引用表名是C_MAJORS### ';
alter table C_DIRECTIONS
  add primary key (ID);
alter table C_DIRECTIONS
  add constraint UK_8HCLWWMS1LTWNY5HNR6R7PEYC unique (CODE);
alter table C_DIRECTIONS
  add constraint FK_NWAGQ1KB0EX0CGBE0G3TCG7SV foreign key (MAJOR_ID)
  references C_MAJORS (ID);

prompt Creating C_ADMINCLASSES...
create table C_ADMINCLASSES
(
  id            NUMBER(10) not null,
  created_at    TIMESTAMP(6),
  updated_at    TIMESTAMP(6),
  abbreviation  VARCHAR2(50 CHAR),
  code          VARCHAR2(32 CHAR) not null,
  effective_at  TIMESTAMP(6) not null,
  grade         VARCHAR2(10 CHAR) not null,
  invalid_at    TIMESTAMP(6),
  name          VARCHAR2(50 CHAR) not null,
  plan_count    NUMBER(10) not null,
  remark        VARCHAR2(500 CHAR),
  std_count     NUMBER(10) not null,
  project_id    NUMBER(10),
  education_id  NUMBER(10) not null,
  department_id NUMBER(10),
  direction_id  NUMBER(10),
  major_id      NUMBER(10),
  std_type_id   NUMBER(10)
)
;
comment on table C_ADMINCLASSES
  is '学生行政班级信息';
comment on column C_ADMINCLASSES.id
  is '非业务主键';
comment on column C_ADMINCLASSES.created_at
  is '创建时间';
comment on column C_ADMINCLASSES.updated_at
  is '更新时间';
comment on column C_ADMINCLASSES.abbreviation
  is '简称';
comment on column C_ADMINCLASSES.code
  is '编码代码';
comment on column C_ADMINCLASSES.effective_at
  is '开始日期';
comment on column C_ADMINCLASSES.grade
  is '年级,形式为yyyy-p';
comment on column C_ADMINCLASSES.invalid_at
  is '结束日期 结束日期包括在有效期内';
comment on column C_ADMINCLASSES.name
  is '名称';
comment on column C_ADMINCLASSES.plan_count
  is '计划人数';
comment on column C_ADMINCLASSES.remark
  is '备注';
comment on column C_ADMINCLASSES.std_count
  is '学籍有效人数';
comment on column C_ADMINCLASSES.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column C_ADMINCLASSES.education_id
  is '学历层次 ID ###引用表名是HB_EDUCATIONS### ';
comment on column C_ADMINCLASSES.department_id
  is '院系 ID ###引用表名是C_DEPARTMENTS### ';
comment on column C_ADMINCLASSES.direction_id
  is '方向 ID ###引用表名是C_DIRECTIONS### ';
comment on column C_ADMINCLASSES.major_id
  is '专业 ID ###引用表名是C_MAJORS### ';
comment on column C_ADMINCLASSES.std_type_id
  is '学生类别 ID ###引用表名是XB_STD_TYPES### ';
alter table C_ADMINCLASSES
  add primary key (ID);
alter table C_ADMINCLASSES
  add constraint UK_TDHGNK2G7FRTI7ATYWJKKMF2T unique (CODE);
alter table C_ADMINCLASSES
  add constraint FK_GBKP2WGWA4UC8PHF9YIE4ATYV foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table C_ADMINCLASSES
  add constraint FK_GRRYC1CBE8EHRMYE1M9UI0DL6 foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);
alter table C_ADMINCLASSES
  add constraint FK_ITIYOEHTL4SDYVWM84BD3RS3R foreign key (MAJOR_ID)
  references C_MAJORS (ID);
alter table C_ADMINCLASSES
  add constraint FK_LJJ7NI56FOGDK53KAX4T4NXX2 foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table C_ADMINCLASSES
  add constraint FK_T15VBHTVPR7S0TQGJYUD773GY foreign key (DIRECTION_ID)
  references C_DIRECTIONS (ID);
alter table C_ADMINCLASSES
  add constraint FK_TD34E18J586OPRRST37HH2N0H foreign key (STD_TYPE_ID)
  references XB_STD_TYPES (ID);

prompt Creating GB_DEGREES...
create table GB_DEGREES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table GB_DEGREES
  is '学位';
comment on column GB_DEGREES.id
  is '非业务主键';
comment on column GB_DEGREES.code
  is '代码';
comment on column GB_DEGREES.created_at
  is '创建时间';
comment on column GB_DEGREES.effective_at
  is '生效时间';
comment on column GB_DEGREES.eng_name
  is '英文名称';
comment on column GB_DEGREES.invalid_at
  is '失效时间';
comment on column GB_DEGREES.name
  is '名称';
comment on column GB_DEGREES.updated_at
  is '修改时间';
alter table GB_DEGREES
  add primary key (ID);
alter table GB_DEGREES
  add constraint UK_2LNFLKFLJRD9JDCQGMHK896RW unique (CODE);

prompt Creating GB_TEACHER_TITLE_LEVELS...
create table GB_TEACHER_TITLE_LEVELS
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table GB_TEACHER_TITLE_LEVELS
  is '教师职称等级';
comment on column GB_TEACHER_TITLE_LEVELS.id
  is '非业务主键';
comment on column GB_TEACHER_TITLE_LEVELS.code
  is '代码';
comment on column GB_TEACHER_TITLE_LEVELS.created_at
  is '创建时间';
comment on column GB_TEACHER_TITLE_LEVELS.effective_at
  is '生效时间';
comment on column GB_TEACHER_TITLE_LEVELS.eng_name
  is '英文名称';
comment on column GB_TEACHER_TITLE_LEVELS.invalid_at
  is '失效时间';
comment on column GB_TEACHER_TITLE_LEVELS.name
  is '名称';
comment on column GB_TEACHER_TITLE_LEVELS.updated_at
  is '修改时间';
alter table GB_TEACHER_TITLE_LEVELS
  add primary key (ID);
alter table GB_TEACHER_TITLE_LEVELS
  add constraint UK_1R6EIF1R6MOTBFJM0TC8L0HN2 unique (CODE);

prompt Creating GB_TEACHER_TITLES...
create table GB_TEACHER_TITLES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6),
  level_id     NUMBER(10),
  parent_id    NUMBER(10)
)
;
comment on table GB_TEACHER_TITLES
  is '教师职称';
comment on column GB_TEACHER_TITLES.id
  is '非业务主键';
comment on column GB_TEACHER_TITLES.code
  is '代码';
comment on column GB_TEACHER_TITLES.created_at
  is '创建时间';
comment on column GB_TEACHER_TITLES.effective_at
  is '生效时间';
comment on column GB_TEACHER_TITLES.eng_name
  is '英文名称';
comment on column GB_TEACHER_TITLES.invalid_at
  is '失效时间';
comment on column GB_TEACHER_TITLES.name
  is '名称';
comment on column GB_TEACHER_TITLES.updated_at
  is '修改时间';
comment on column GB_TEACHER_TITLES.level_id
  is '职称等级 ID ###引用表名是GB_TEACHER_TITLE_LEVELS### ';
comment on column GB_TEACHER_TITLES.parent_id
  is '职称系列 ID ###引用表名是GB_TEACHER_TITLES### ';
alter table GB_TEACHER_TITLES
  add primary key (ID);
alter table GB_TEACHER_TITLES
  add constraint UK_HGGWYJ3X32GEDJHMXDIAT76EF unique (CODE);
alter table GB_TEACHER_TITLES
  add constraint FK_I22JRN9S3W0FT8RF1P48YL1IJ foreign key (PARENT_ID)
  references GB_TEACHER_TITLES (ID);
alter table GB_TEACHER_TITLES
  add constraint FK_IHUHCNX1OKLTE2IC6BS7R1FCF foreign key (LEVEL_ID)
  references GB_TEACHER_TITLE_LEVELS (ID);

prompt Creating HB_TEACHER_STATES...
create table HB_TEACHER_STATES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_TEACHER_STATES
  is '教师在职状态';
comment on column HB_TEACHER_STATES.id
  is '非业务主键';
comment on column HB_TEACHER_STATES.code
  is '代码';
comment on column HB_TEACHER_STATES.created_at
  is '创建时间';
comment on column HB_TEACHER_STATES.effective_at
  is '生效时间';
comment on column HB_TEACHER_STATES.eng_name
  is '英文名称';
comment on column HB_TEACHER_STATES.invalid_at
  is '失效时间';
comment on column HB_TEACHER_STATES.name
  is '名称';
comment on column HB_TEACHER_STATES.updated_at
  is '修改时间';
alter table HB_TEACHER_STATES
  add primary key (ID);
alter table HB_TEACHER_STATES
  add constraint UK_6OLA94IV3B0Q5MA9EKYDAVCWN unique (CODE);

prompt Creating HB_TEACHER_TYPES...
create table HB_TEACHER_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6),
  external     NUMBER(1) not null,
  parttime     NUMBER(1) not null
)
;
comment on table HB_TEACHER_TYPES
  is '教职工类别';
comment on column HB_TEACHER_TYPES.id
  is '非业务主键';
comment on column HB_TEACHER_TYPES.code
  is '代码';
comment on column HB_TEACHER_TYPES.created_at
  is '创建时间';
comment on column HB_TEACHER_TYPES.effective_at
  is '生效时间';
comment on column HB_TEACHER_TYPES.eng_name
  is '英文名称';
comment on column HB_TEACHER_TYPES.invalid_at
  is '失效时间';
comment on column HB_TEACHER_TYPES.name
  is '名称';
comment on column HB_TEACHER_TYPES.updated_at
  is '修改时间';
comment on column HB_TEACHER_TYPES.external
  is '是否外聘';
comment on column HB_TEACHER_TYPES.parttime
  is '是否兼职';
alter table HB_TEACHER_TYPES
  add primary key (ID);
alter table HB_TEACHER_TYPES
  add constraint UK_2WLV912IBU4TVK0OJKB3WJCNV unique (CODE);

prompt Creating HB_TEACHER_UNIT_TYPES...
create table HB_TEACHER_UNIT_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_TEACHER_UNIT_TYPES
  is '外聘教师单位类别';
comment on column HB_TEACHER_UNIT_TYPES.id
  is '非业务主键';
comment on column HB_TEACHER_UNIT_TYPES.code
  is '代码';
comment on column HB_TEACHER_UNIT_TYPES.created_at
  is '创建时间';
comment on column HB_TEACHER_UNIT_TYPES.effective_at
  is '生效时间';
comment on column HB_TEACHER_UNIT_TYPES.eng_name
  is '英文名称';
comment on column HB_TEACHER_UNIT_TYPES.invalid_at
  is '失效时间';
comment on column HB_TEACHER_UNIT_TYPES.name
  is '名称';
comment on column HB_TEACHER_UNIT_TYPES.updated_at
  is '修改时间';
alter table HB_TEACHER_UNIT_TYPES
  add primary key (ID);
alter table HB_TEACHER_UNIT_TYPES
  add constraint UK_RF91UX9TR8KU3Y647NHLWW8HL unique (CODE);

prompt Creating HB_TUTOR_TYPES...
create table HB_TUTOR_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_TUTOR_TYPES
  is '导师类型';
comment on column HB_TUTOR_TYPES.id
  is '非业务主键';
comment on column HB_TUTOR_TYPES.code
  is '代码';
comment on column HB_TUTOR_TYPES.created_at
  is '创建时间';
comment on column HB_TUTOR_TYPES.effective_at
  is '生效时间';
comment on column HB_TUTOR_TYPES.eng_name
  is '英文名称';
comment on column HB_TUTOR_TYPES.invalid_at
  is '失效时间';
comment on column HB_TUTOR_TYPES.name
  is '名称';
comment on column HB_TUTOR_TYPES.updated_at
  is '修改时间';
alter table HB_TUTOR_TYPES
  add primary key (ID);
alter table HB_TUTOR_TYPES
  add constraint UK_AM336652AM2K92MUEDEYGCSBN unique (CODE);

prompt Creating GB_COUNTRIES...
create table GB_COUNTRIES
(
  id             NUMBER(10) not null,
  code           VARCHAR2(32 CHAR) not null,
  created_at     TIMESTAMP(6),
  effective_at   TIMESTAMP(6) not null,
  eng_name       VARCHAR2(100 CHAR),
  invalid_at     TIMESTAMP(6),
  name           VARCHAR2(100 CHAR) not null,
  updated_at     TIMESTAMP(6),
  short_code     VARCHAR2(255 CHAR),
  short_eng_name VARCHAR2(255 CHAR),
  short_name     VARCHAR2(255 CHAR)
)
;
comment on table GB_COUNTRIES
  is '国家地区';
comment on column GB_COUNTRIES.id
  is '非业务主键';
comment on column GB_COUNTRIES.code
  is '代码';
comment on column GB_COUNTRIES.created_at
  is '创建时间';
comment on column GB_COUNTRIES.effective_at
  is '生效时间';
comment on column GB_COUNTRIES.eng_name
  is '英文名称';
comment on column GB_COUNTRIES.invalid_at
  is '失效时间';
comment on column GB_COUNTRIES.name
  is '名称';
comment on column GB_COUNTRIES.updated_at
  is '修改时间';
comment on column GB_COUNTRIES.short_code
  is '简码（三位）';
comment on column GB_COUNTRIES.short_eng_name
  is '英文简称';
comment on column GB_COUNTRIES.short_name
  is '中文简称';
alter table GB_COUNTRIES
  add primary key (ID);
alter table GB_COUNTRIES
  add constraint UK_95APW228BF91TDO1NC04F71FV unique (CODE);

prompt Creating GB_GENDERS...
create table GB_GENDERS
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table GB_GENDERS
  is '性别';
comment on column GB_GENDERS.id
  is '非业务主键';
comment on column GB_GENDERS.code
  is '代码';
comment on column GB_GENDERS.created_at
  is '创建时间';
comment on column GB_GENDERS.effective_at
  is '生效时间';
comment on column GB_GENDERS.eng_name
  is '英文名称';
comment on column GB_GENDERS.invalid_at
  is '失效时间';
comment on column GB_GENDERS.name
  is '名称';
comment on column GB_GENDERS.updated_at
  is '修改时间';
alter table GB_GENDERS
  add primary key (ID);
alter table GB_GENDERS
  add constraint UK_BE2U8SBVMT8SVDLW9HQ7G8T1F unique (CODE);

prompt Creating GB_NATIONS...
create table GB_NATIONS
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table GB_NATIONS
  is '民族';
comment on column GB_NATIONS.id
  is '非业务主键';
comment on column GB_NATIONS.code
  is '代码';
comment on column GB_NATIONS.created_at
  is '创建时间';
comment on column GB_NATIONS.effective_at
  is '生效时间';
comment on column GB_NATIONS.eng_name
  is '英文名称';
comment on column GB_NATIONS.invalid_at
  is '失效时间';
comment on column GB_NATIONS.name
  is '名称';
comment on column GB_NATIONS.updated_at
  is '修改时间';
alter table GB_NATIONS
  add primary key (ID);
alter table GB_NATIONS
  add constraint UK_E4MMA9182A3KWDVBDR9F177X4 unique (CODE);

prompt Creating GB_POLITIC_VISAGES...
create table GB_POLITIC_VISAGES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table GB_POLITIC_VISAGES
  is '政治面貌';
comment on column GB_POLITIC_VISAGES.id
  is '非业务主键';
comment on column GB_POLITIC_VISAGES.code
  is '代码';
comment on column GB_POLITIC_VISAGES.created_at
  is '创建时间';
comment on column GB_POLITIC_VISAGES.effective_at
  is '生效时间';
comment on column GB_POLITIC_VISAGES.eng_name
  is '英文名称';
comment on column GB_POLITIC_VISAGES.invalid_at
  is '失效时间';
comment on column GB_POLITIC_VISAGES.name
  is '名称';
comment on column GB_POLITIC_VISAGES.updated_at
  is '修改时间';
alter table GB_POLITIC_VISAGES
  add primary key (ID);
alter table GB_POLITIC_VISAGES
  add constraint UK_D96CSOTHGR17LHN07B9S77QUR unique (CODE);

prompt Creating HB_IDCARD_TYPES...
create table HB_IDCARD_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_IDCARD_TYPES
  is '证件类型';
comment on column HB_IDCARD_TYPES.id
  is '非业务主键';
comment on column HB_IDCARD_TYPES.code
  is '代码';
comment on column HB_IDCARD_TYPES.created_at
  is '创建时间';
comment on column HB_IDCARD_TYPES.effective_at
  is '生效时间';
comment on column HB_IDCARD_TYPES.eng_name
  is '英文名称';
comment on column HB_IDCARD_TYPES.invalid_at
  is '失效时间';
comment on column HB_IDCARD_TYPES.name
  is '名称';
comment on column HB_IDCARD_TYPES.updated_at
  is '修改时间';
alter table HB_IDCARD_TYPES
  add primary key (ID);
alter table HB_IDCARD_TYPES
  add constraint UK_DLLRY112AK5093BKTPVR3IGRG unique (CODE);

prompt Creating C_STAFFS...
create table C_STAFFS
(
  id                NUMBER(19) not null,
  created_at        TIMESTAMP(6),
  updated_at        TIMESTAMP(6),
  account           VARCHAR2(255 CHAR),
  bank              VARCHAR2(255 CHAR),
  birthday          DATE,
  charactor         VARCHAR2(4000 CHAR),
  code              VARCHAR2(30 CHAR) not null,
  idcard            VARCHAR2(255 CHAR),
  name              VARCHAR2(80 CHAR) not null,
  country_id        NUMBER(10),
  department_id     NUMBER(10) not null,
  gender_id         NUMBER(10) not null,
  idcard_type_id    NUMBER(10),
  nation_id         NUMBER(10),
  politic_visage_id NUMBER(10)
)
;
comment on table C_STAFFS
  is '教职工人员基本信息';
comment on column C_STAFFS.id
  is '非业务主键';
comment on column C_STAFFS.created_at
  is '创建时间';
comment on column C_STAFFS.updated_at
  is '更新时间';
comment on column C_STAFFS.account
  is '账户';
comment on column C_STAFFS.bank
  is '银行';
comment on column C_STAFFS.birthday
  is '出生年月';
comment on column C_STAFFS.charactor
  is '特长爱好以及个人说明';
comment on column C_STAFFS.code
  is '人员编码';
comment on column C_STAFFS.idcard
  is '身份证';
comment on column C_STAFFS.name
  is '姓名';
comment on column C_STAFFS.country_id
  is '国家地区 ID ###引用表名是GB_COUNTRIES### ';
comment on column C_STAFFS.department_id
  is '部门 ID ###引用表名是C_DEPARTMENTS### ';
comment on column C_STAFFS.gender_id
  is '性别 ID ###引用表名是GB_GENDERS### ';
comment on column C_STAFFS.idcard_type_id
  is '证件类型 身份证/护照等 ID ###引用表名是HB_IDCARD_TYPES### ';
comment on column C_STAFFS.nation_id
  is '民族 ID ###引用表名是GB_NATIONS### ';
comment on column C_STAFFS.politic_visage_id
  is '政治面貌 ID ###引用表名是GB_POLITIC_VISAGES### ';
alter table C_STAFFS
  add primary key (ID);
alter table C_STAFFS
  add constraint UK_LWVW892NIBOK64FLVX6Q89AQA unique (ACCOUNT);
alter table C_STAFFS
  add constraint FK_6OMMRWSV65067COUC467KRSR5 foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table C_STAFFS
  add constraint FK_BBING1FKE3A9BV7WEKKQ3BNXA foreign key (POLITIC_VISAGE_ID)
  references GB_POLITIC_VISAGES (ID);
alter table C_STAFFS
  add constraint FK_GSKVURMCA1B7K5RSUBXYS7F63 foreign key (IDCARD_TYPE_ID)
  references HB_IDCARD_TYPES (ID);
alter table C_STAFFS
  add constraint FK_I285U4BK1GCL7RG0FD66OKTG6 foreign key (NATION_ID)
  references GB_NATIONS (ID);
alter table C_STAFFS
  add constraint FK_PYTLVQ9H7CG2NTG18CAQS687V foreign key (GENDER_ID)
  references GB_GENDERS (ID);
alter table C_STAFFS
  add constraint FK_QYQR5VOPYIDUE3LSXJ2M14ODL foreign key (COUNTRY_ID)
  references GB_COUNTRIES (ID);

prompt Creating C_TEACHERS...
create table C_TEACHERS
(
  id                 NUMBER(19) not null,
  created_at         TIMESTAMP(6),
  updated_at         TIMESTAMP(6),
  code               VARCHAR2(32 CHAR),
  degree_award_on    TIMESTAMP(6),
  effective_at       TIMESTAMP(6) not null,
  graduate_on        TIMESTAMP(6),
  invalid_at         TIMESTAMP(6),
  name               VARCHAR2(100 CHAR) not null,
  remark             VARCHAR2(500 CHAR),
  school             VARCHAR2(255 CHAR),
  teaching           NUMBER(1) not null,
  tutor_award_on     TIMESTAMP(6),
  unit               VARCHAR2(255 CHAR),
  degree_id          NUMBER(10),
  department_id      NUMBER(10) not null,
  education_id       NUMBER(10),
  parttime_depart_id NUMBER(10),
  staff_id           NUMBER(19) not null,
  state_id           NUMBER(10) not null,
  teacher_type_id    NUMBER(10) not null,
  title_id           NUMBER(10),
  tutor_type_id      NUMBER(10),
  unit_type_id       NUMBER(10)
)
;
comment on table C_TEACHERS
  is '教师信息默认实现';
comment on column C_TEACHERS.id
  is '非业务主键';
comment on column C_TEACHERS.created_at
  is '创建时间';
comment on column C_TEACHERS.updated_at
  is '更新时间';
comment on column C_TEACHERS.code
  is '编码 职工号';
comment on column C_TEACHERS.degree_award_on
  is '学位授予年月';
comment on column C_TEACHERS.effective_at
  is '任职开始日期';
comment on column C_TEACHERS.graduate_on
  is '毕业日期';
comment on column C_TEACHERS.invalid_at
  is '任职结束日期';
comment on column C_TEACHERS.name
  is '名称';
comment on column C_TEACHERS.remark
  is '备注';
comment on column C_TEACHERS.school
  is '毕业学校';
comment on column C_TEACHERS.teaching
  is '是否任课';
comment on column C_TEACHERS.tutor_award_on
  is '研导任职年月';
comment on column C_TEACHERS.unit
  is '从何单位聘任';
comment on column C_TEACHERS.degree_id
  is '学位 ID ###引用表名是GB_DEGREES### ';
comment on column C_TEACHERS.department_id
  is '部门 ID ###引用表名是C_DEPARTMENTS### ';
comment on column C_TEACHERS.education_id
  is '学历层次 ID ###引用表名是HB_EDUCATIONS### ';
comment on column C_TEACHERS.parttime_depart_id
  is '兼职部门 ID ###引用表名是C_DEPARTMENTS### ';
comment on column C_TEACHERS.staff_id
  is '人员信息 ID ###引用表名是C_STAFFS### ';
comment on column C_TEACHERS.state_id
  is '教师在职状态 ID ###引用表名是HB_TEACHER_STATES### ';
comment on column C_TEACHERS.teacher_type_id
  is '教职工类别 ID ###引用表名是HB_TEACHER_TYPES### ';
comment on column C_TEACHERS.title_id
  is '职称 ID ###引用表名是GB_TEACHER_TITLES### ';
comment on column C_TEACHERS.tutor_type_id
  is '导师类别 ID ###引用表名是HB_TUTOR_TYPES### ';
comment on column C_TEACHERS.unit_type_id
  is '聘任单位的类别 ID ###引用表名是HB_TEACHER_UNIT_TYPES### ';
alter table C_TEACHERS
  add primary key (ID);
alter table C_TEACHERS
  add constraint UK_DSG0RYAUY0FQ3FA9PFSGQASRT unique (CODE);
alter table C_TEACHERS
  add constraint FK_824WKM4WXE7P5317W3ETVRVPA foreign key (DEGREE_ID)
  references GB_DEGREES (ID);
alter table C_TEACHERS
  add constraint FK_9DML6BQA9XX7YRBCNXVUM0VS4 foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);
alter table C_TEACHERS
  add constraint FK_ALUE1LYJ7NL2264OOGAXP7L4A foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table C_TEACHERS
  add constraint FK_AO7906MAI8VQ26X59B0MDCDQU foreign key (UNIT_TYPE_ID)
  references HB_TEACHER_UNIT_TYPES (ID);
alter table C_TEACHERS
  add constraint FK_C232RD8988HEB40WBE4U4J4N1 foreign key (STAFF_ID)
  references C_STAFFS (ID);
alter table C_TEACHERS
  add constraint FK_EE9UXB1LRQRXGULRAH8TCGRUB foreign key (TITLE_ID)
  references GB_TEACHER_TITLES (ID);
alter table C_TEACHERS
  add constraint FK_M3XJLV7YS2NDA8D2YHTUOT5VH foreign key (STATE_ID)
  references HB_TEACHER_STATES (ID);
alter table C_TEACHERS
  add constraint FK_P5JXP3GC9MMIJ0X05T7LRBEFX foreign key (TUTOR_TYPE_ID)
  references HB_TUTOR_TYPES (ID);
alter table C_TEACHERS
  add constraint FK_Q97OJMCLE5X0C29R7MG0EEVM foreign key (TEACHER_TYPE_ID)
  references HB_TEACHER_TYPES (ID);
alter table C_TEACHERS
  add constraint FK_QHMAMHYRHRWBUFE6O8XXG2C29 foreign key (PARTTIME_DEPART_ID)
  references C_DEPARTMENTS (ID);

prompt Creating C_ADMINCLASSES_INSTRUCTORS...
create table C_ADMINCLASSES_INSTRUCTORS
(
  adminclass_id NUMBER(10) not null,
  teacher_id    NUMBER(19) not null
)
;
comment on table C_ADMINCLASSES_INSTRUCTORS
  is '学生行政班级信息-辅导员';
comment on column C_ADMINCLASSES_INSTRUCTORS.adminclass_id
  is '学生行政班级信息 ID ###引用表名是C_ADMINCLASSES### ';
comment on column C_ADMINCLASSES_INSTRUCTORS.teacher_id
  is '教师信息默认实现 ID ###引用表名是C_TEACHERS### ';
alter table C_ADMINCLASSES_INSTRUCTORS
  add constraint FK_CH3P25VOE8PVFDEE544RM6U7Q foreign key (TEACHER_ID)
  references C_TEACHERS (ID);
alter table C_ADMINCLASSES_INSTRUCTORS
  add constraint FK_LUSJNTYNN2KMDDFSSJ98PHKWQ foreign key (ADMINCLASS_ID)
  references C_ADMINCLASSES (ID);

prompt Creating C_ADMINCLASSES_TUTORS...
create table C_ADMINCLASSES_TUTORS
(
  adminclass_id NUMBER(10) not null,
  teacher_id    NUMBER(19) not null
)
;
comment on table C_ADMINCLASSES_TUTORS
  is '学生行政班级信息-班导师';
comment on column C_ADMINCLASSES_TUTORS.adminclass_id
  is '学生行政班级信息 ID ###引用表名是C_ADMINCLASSES### ';
comment on column C_ADMINCLASSES_TUTORS.teacher_id
  is '教师信息默认实现 ID ###引用表名是C_TEACHERS### ';
alter table C_ADMINCLASSES_TUTORS
  add constraint FK_14KPGI5WB19X3KKHC991DBW6S foreign key (ADMINCLASS_ID)
  references C_ADMINCLASSES (ID);
alter table C_ADMINCLASSES_TUTORS
  add constraint FK_BOAEXY6M00HE77MCOVYX72GTM foreign key (TEACHER_ID)
  references C_TEACHERS (ID);

prompt Creating C_TIME_SETTINGS...
create table C_TIME_SETTINGS
(
  id          NUMBER(10) not null,
  name        VARCHAR2(100 CHAR) not null,
  campus_id   NUMBER(10),
  school_id   NUMBER(19) not null,
  semester_id NUMBER(10)
)
;
comment on table C_TIME_SETTINGS
  is '每个小节的时间设置';
comment on column C_TIME_SETTINGS.id
  is '非业务主键';
comment on column C_TIME_SETTINGS.name
  is '名称';
comment on column C_TIME_SETTINGS.campus_id
  is '校区 ID ###引用表名是C_CAMPUSES### ';
comment on column C_TIME_SETTINGS.school_id
  is '学校 ID ###引用表名是C_SCHOOLS### ';
comment on column C_TIME_SETTINGS.semester_id
  is '学期 ID ###引用表名是C_SEMESTERS### ';
alter table C_TIME_SETTINGS
  add primary key (ID);
alter table C_TIME_SETTINGS
  add constraint FK_EARDA2563E4EX8R9CCBNNDUST foreign key (SCHOOL_ID)
  references C_SCHOOLS (ID);
alter table C_TIME_SETTINGS
  add constraint FK_LAGRK9YC1QMR2YDV3MG6D0C3U foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table C_TIME_SETTINGS
  add constraint FK_RL6H0Y79YOOTF6BU92PIT2P9A foreign key (CAMPUS_ID)
  references C_CAMPUSES (ID);

prompt Creating C_DEFAULT_COURSE_UNITS...
create table C_DEFAULT_COURSE_UNITS
(
  id              NUMBER(10) not null,
  color           VARCHAR2(20 CHAR) not null,
  end_time        NUMBER(10) not null,
  eng_name        VARCHAR2(50 CHAR) not null,
  indexno         NUMBER(10) not null,
  name            VARCHAR2(10 CHAR) not null,
  start_time      NUMBER(10) not null,
  time_setting_id NUMBER(10) not null
)
;
comment on table C_DEFAULT_COURSE_UNITS
  is '默认作息时间';
comment on column C_DEFAULT_COURSE_UNITS.id
  is '非业务主键';
comment on column C_DEFAULT_COURSE_UNITS.color
  is '上午/中午/下午/晚上';
comment on column C_DEFAULT_COURSE_UNITS.end_time
  is '结束时间';
comment on column C_DEFAULT_COURSE_UNITS.eng_name
  is '小节对应的英文名';
comment on column C_DEFAULT_COURSE_UNITS.indexno
  is '小节编号';
comment on column C_DEFAULT_COURSE_UNITS.name
  is '小节对应的名字';
comment on column C_DEFAULT_COURSE_UNITS.start_time
  is '开始时间';
comment on column C_DEFAULT_COURSE_UNITS.time_setting_id
  is '时间设置 ID ###引用表名是C_TIME_SETTINGS### ';
alter table C_DEFAULT_COURSE_UNITS
  add primary key (ID);
alter table C_DEFAULT_COURSE_UNITS
  add constraint FK_5B1NXFF1ALFFLFWB2TBSQVPYS foreign key (TIME_SETTING_ID)
  references C_TIME_SETTINGS (ID);

prompt Creating C_BUILDING_COURSE_UNITS...
create table C_BUILDING_COURSE_UNITS
(
  id              NUMBER(10) not null,
  end_time        NUMBER(10) not null,
  start_time      NUMBER(10) not null,
  building_id     NUMBER(10) not null,
  time_setting_id NUMBER(10) not null,
  unit_id         NUMBER(10) not null
)
;
comment on table C_BUILDING_COURSE_UNITS
  is '教学楼时间小节设置';
comment on column C_BUILDING_COURSE_UNITS.id
  is '非业务主键';
comment on column C_BUILDING_COURSE_UNITS.end_time
  is '结束时间';
comment on column C_BUILDING_COURSE_UNITS.start_time
  is '开始时间';
comment on column C_BUILDING_COURSE_UNITS.building_id
  is '对应教学楼 ID ###引用表名是C_BUILDINGS### ';
comment on column C_BUILDING_COURSE_UNITS.time_setting_id
  is '时间设置 ID ###引用表名是C_TIME_SETTINGS### ';
comment on column C_BUILDING_COURSE_UNITS.unit_id
  is '对应小结 ID ###引用表名是C_DEFAULT_COURSE_UNITS### ';
alter table C_BUILDING_COURSE_UNITS
  add primary key (ID);
alter table C_BUILDING_COURSE_UNITS
  add constraint FK_ESPU7EVO191WTBS28YPUQ2OVU foreign key (TIME_SETTING_ID)
  references C_TIME_SETTINGS (ID);
alter table C_BUILDING_COURSE_UNITS
  add constraint FK_MKWO6HLI2Y9EJ0M08DS8EHS1R foreign key (BUILDING_ID)
  references C_BUILDINGS (ID);
alter table C_BUILDING_COURSE_UNITS
  add constraint FK_NEBTJUR3TYM2XBYLW6HLMB0W1 foreign key (UNIT_ID)
  references C_DEFAULT_COURSE_UNITS (ID);

prompt Creating C_CLASSROOMS_DEPARTMENTS...
create table C_CLASSROOMS_DEPARTMENTS
(
  classroom_id  NUMBER(10) not null,
  department_id NUMBER(10) not null
)
;
comment on table C_CLASSROOMS_DEPARTMENTS
  is '教室基本信息-固定使用部门';
comment on column C_CLASSROOMS_DEPARTMENTS.classroom_id
  is '教室基本信息 ID ###引用表名是C_CLASSROOMS### ';
comment on column C_CLASSROOMS_DEPARTMENTS.department_id
  is '部门组织机构信息 ID ###引用表名是C_DEPARTMENTS### ';
alter table C_CLASSROOMS_DEPARTMENTS
  add primary key (CLASSROOM_ID, DEPARTMENT_ID);
alter table C_CLASSROOMS_DEPARTMENTS
  add constraint FK_2B3ERJX67VY3QIMIFMTMARIHQ foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table C_CLASSROOMS_DEPARTMENTS
  add constraint FK_QBHHYFX1231HE2RB4Q6WPQD81 foreign key (CLASSROOM_ID)
  references C_CLASSROOMS (ID);

prompt Creating C_DIRECTION_JOURNALS...
create table C_DIRECTION_JOURNALS
(
  id           NUMBER(10) not null,
  effective_at TIMESTAMP(6) not null,
  invalid_at   TIMESTAMP(6),
  remark       VARCHAR2(255 CHAR),
  depart_id    NUMBER(10) not null,
  direction_id NUMBER(10) not null,
  education_id NUMBER(10) not null
)
;
comment on table C_DIRECTION_JOURNALS
  is '专业方向建设过程';
comment on column C_DIRECTION_JOURNALS.id
  is '非业务主键';
comment on column C_DIRECTION_JOURNALS.effective_at
  is '生效时间';
comment on column C_DIRECTION_JOURNALS.invalid_at
  is '失效时间';
comment on column C_DIRECTION_JOURNALS.remark
  is '备注';
comment on column C_DIRECTION_JOURNALS.depart_id
  is '部门 ID ###引用表名是C_DEPARTMENTS### ';
comment on column C_DIRECTION_JOURNALS.direction_id
  is '专业方向 ID ###引用表名是C_DIRECTIONS### ';
comment on column C_DIRECTION_JOURNALS.education_id
  is '培养层次 ID ###引用表名是HB_EDUCATIONS### ';
alter table C_DIRECTION_JOURNALS
  add primary key (ID);
alter table C_DIRECTION_JOURNALS
  add constraint FK_74YOSQYSBY0QUTIDH42KHP3IH foreign key (DEPART_ID)
  references C_DEPARTMENTS (ID);
alter table C_DIRECTION_JOURNALS
  add constraint FK_C3XKT48HXDJUQJJ33MQ5CO5BX foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);
alter table C_DIRECTION_JOURNALS
  add constraint FK_RDCA8M0I41CSMMHVEVGDDPN5P foreign key (DIRECTION_ID)
  references C_DIRECTIONS (ID);

prompt Creating C_HABILITATIONS...
create table C_HABILITATIONS
(
  id           NUMBER(10) not null,
  created_at   TIMESTAMP(6),
  updated_at   TIMESTAMP(6),
  effective_on TIMESTAMP(6),
  invalid_on   TIMESTAMP(6),
  qualified    NUMBER(1) not null,
  project_id   NUMBER(10),
  teacher_id   NUMBER(19)
)
;
comment on table C_HABILITATIONS
  is '授课资格';
comment on column C_HABILITATIONS.id
  is '非业务主键';
comment on column C_HABILITATIONS.created_at
  is '创建时间';
comment on column C_HABILITATIONS.updated_at
  is '更新时间';
comment on column C_HABILITATIONS.effective_on
  is '生效日期';
comment on column C_HABILITATIONS.invalid_on
  is '失效日期';
comment on column C_HABILITATIONS.qualified
  is '是否合格';
comment on column C_HABILITATIONS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column C_HABILITATIONS.teacher_id
  is '教师 ID ###引用表名是C_TEACHERS### ';
alter table C_HABILITATIONS
  add primary key (ID);
alter table C_HABILITATIONS
  add constraint FK_CY9V7N0AUBFKBW8HWCP5E389Y foreign key (TEACHER_ID)
  references C_TEACHERS (ID);
alter table C_HABILITATIONS
  add constraint FK_DXFDJGHM8HT3S55JJGPH2CI27 foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating C_HOLIDAYS...
create table C_HOLIDAYS
(
  id       NUMBER(10) not null,
  end_on   DATE not null,
  name     VARCHAR2(20 CHAR) not null,
  start_on DATE not null
)
;
comment on table C_HOLIDAYS
  is '法定假日';
comment on column C_HOLIDAYS.id
  is '非业务主键';
comment on column C_HOLIDAYS.end_on
  is '结束日期';
comment on column C_HOLIDAYS.name
  is '名称';
comment on column C_HOLIDAYS.start_on
  is '起始日期';
alter table C_HOLIDAYS
  add primary key (ID);

prompt Creating C_MAJORS_EDUCATIONS...
create table C_MAJORS_EDUCATIONS
(
  major_id     NUMBER(10) not null,
  education_id NUMBER(10) not null
)
;
comment on table C_MAJORS_EDUCATIONS
  is '专业-培养层次';
comment on column C_MAJORS_EDUCATIONS.major_id
  is '专业 ID ###引用表名是C_MAJORS### ';
comment on column C_MAJORS_EDUCATIONS.education_id
  is '学历层次 ID ###引用表名是HB_EDUCATIONS### ';
alter table C_MAJORS_EDUCATIONS
  add primary key (MAJOR_ID, EDUCATION_ID);
alter table C_MAJORS_EDUCATIONS
  add constraint FK_6A6SFPKXCJ0XBRCNW4UMNUX3F foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);
alter table C_MAJORS_EDUCATIONS
  add constraint FK_977WQJS0CL1L4WL93OVDNCBJW foreign key (MAJOR_ID)
  references C_MAJORS (ID);

prompt Creating C_MAJOR_JOURNALS...
create table C_MAJOR_JOURNALS
(
  id              NUMBER(10) not null,
  code            VARCHAR2(30 CHAR),
  discipline_code VARCHAR2(50 CHAR),
  duration        FLOAT not null,
  effective_at    TIMESTAMP(6) not null,
  eng_name        VARCHAR2(255 CHAR),
  invalid_at      TIMESTAMP(6),
  name            VARCHAR2(50 CHAR),
  remark          VARCHAR2(255 CHAR),
  category_id     NUMBER(10) not null,
  depart_id       NUMBER(10) not null,
  education_id    NUMBER(10) not null,
  major_id        NUMBER(10) not null
)
;
comment on table C_MAJOR_JOURNALS
  is '专业建设过程';
comment on column C_MAJOR_JOURNALS.id
  is '非业务主键';
comment on column C_MAJOR_JOURNALS.code
  is '代码';
comment on column C_MAJOR_JOURNALS.discipline_code
  is '教育部代码';
comment on column C_MAJOR_JOURNALS.duration
  is '修读年限';
comment on column C_MAJOR_JOURNALS.effective_at
  is '生效时间';
comment on column C_MAJOR_JOURNALS.eng_name
  is '英文名';
comment on column C_MAJOR_JOURNALS.invalid_at
  is '失效时间';
comment on column C_MAJOR_JOURNALS.name
  is '名称';
comment on column C_MAJOR_JOURNALS.remark
  is '备注';
comment on column C_MAJOR_JOURNALS.category_id
  is '学科门类 ID ###引用表名是JB_DISCIPLINE_CATEGORIES### ';
comment on column C_MAJOR_JOURNALS.depart_id
  is '部门 ID ###引用表名是C_DEPARTMENTS### ';
comment on column C_MAJOR_JOURNALS.education_id
  is '培养层次 ID ###引用表名是HB_EDUCATIONS### ';
comment on column C_MAJOR_JOURNALS.major_id
  is '专业 ID ###引用表名是C_MAJORS### ';
alter table C_MAJOR_JOURNALS
  add primary key (ID);
alter table C_MAJOR_JOURNALS
  add constraint FK_8SQWE8XA5VTS1DBXXXUO3MJGI foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);
alter table C_MAJOR_JOURNALS
  add constraint FK_F237APHJ961C39XGRCJ1XQPSE foreign key (DEPART_ID)
  references C_DEPARTMENTS (ID);
alter table C_MAJOR_JOURNALS
  add constraint FK_IY6N1MHOK9RY62YH3LVWQK4JV foreign key (CATEGORY_ID)
  references JB_DISCIPLINE_CATEGORIES (ID);
alter table C_MAJOR_JOURNALS
  add constraint FK_M4A7VOY13MOEDT79QAETFYE4C foreign key (MAJOR_ID)
  references C_MAJORS (ID);

prompt Creating C_PROJECTS_CAMPUSES...
create table C_PROJECTS_CAMPUSES
(
  project_id NUMBER(10) not null,
  campus_id  NUMBER(10) not null
)
;
comment on table C_PROJECTS_CAMPUSES
  is '项目-校区列表';
comment on column C_PROJECTS_CAMPUSES.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column C_PROJECTS_CAMPUSES.campus_id
  is '校区信息 ID ###引用表名是C_CAMPUSES### ';
alter table C_PROJECTS_CAMPUSES
  add constraint FK_5DACE9VUMD1G9UEPOEPKTBIM0 foreign key (CAMPUS_ID)
  references C_CAMPUSES (ID);
alter table C_PROJECTS_CAMPUSES
  add constraint FK_KLF66CE14U60VT3F8B7GPQ0H7 foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating C_PROJECTS_DEPARTMENTS...
create table C_PROJECTS_DEPARTMENTS
(
  project_id    NUMBER(10) not null,
  department_id NUMBER(10) not null,
  index_no      NUMBER(10) not null
)
;
comment on table C_PROJECTS_DEPARTMENTS
  is '项目-部门列表';
comment on column C_PROJECTS_DEPARTMENTS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column C_PROJECTS_DEPARTMENTS.department_id
  is '部门组织机构信息 ID ###引用表名是C_DEPARTMENTS### ';
alter table C_PROJECTS_DEPARTMENTS
  add primary key (PROJECT_ID, INDEX_NO);
alter table C_PROJECTS_DEPARTMENTS
  add constraint FK_9CK854F1J5V6V0D59K6YF3SMG foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table C_PROJECTS_DEPARTMENTS
  add constraint FK_IE1KDJYV2MIHXQ9DR04QHI2ES foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);

prompt Creating C_PROJECTS_EDUCATIONS...
create table C_PROJECTS_EDUCATIONS
(
  project_id   NUMBER(10) not null,
  education_id NUMBER(10) not null
)
;
comment on table C_PROJECTS_EDUCATIONS
  is '项目-学历层次列表';
comment on column C_PROJECTS_EDUCATIONS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column C_PROJECTS_EDUCATIONS.education_id
  is '学历层次 ID ###引用表名是HB_EDUCATIONS### ';
alter table C_PROJECTS_EDUCATIONS
  add constraint FK_NCIJ1ASAOLRAX7NY9DFNTQU7G foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table C_PROJECTS_EDUCATIONS
  add constraint FK_NOOS8PLJ2W3MSK11IJMWH154T foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);

prompt Creating XB_STD_LABEL_TYPES...
create table XB_STD_LABEL_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table XB_STD_LABEL_TYPES
  is '学生分类标签类型';
comment on column XB_STD_LABEL_TYPES.id
  is '非业务主键';
comment on column XB_STD_LABEL_TYPES.code
  is '代码';
comment on column XB_STD_LABEL_TYPES.created_at
  is '创建时间';
comment on column XB_STD_LABEL_TYPES.effective_at
  is '生效时间';
comment on column XB_STD_LABEL_TYPES.eng_name
  is '英文名称';
comment on column XB_STD_LABEL_TYPES.invalid_at
  is '失效时间';
comment on column XB_STD_LABEL_TYPES.name
  is '名称';
comment on column XB_STD_LABEL_TYPES.updated_at
  is '修改时间';
alter table XB_STD_LABEL_TYPES
  add primary key (ID);
alter table XB_STD_LABEL_TYPES
  add constraint UK_QD4AAAE5KN765LT23LQ05L3M1 unique (CODE);

prompt Creating XB_STD_LABELS...
create table XB_STD_LABELS
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6),
  type_id      NUMBER(10)
)
;
comment on table XB_STD_LABELS
  is '学生分类标签';
comment on column XB_STD_LABELS.id
  is '非业务主键';
comment on column XB_STD_LABELS.code
  is '代码';
comment on column XB_STD_LABELS.created_at
  is '创建时间';
comment on column XB_STD_LABELS.effective_at
  is '生效时间';
comment on column XB_STD_LABELS.eng_name
  is '英文名称';
comment on column XB_STD_LABELS.invalid_at
  is '失效时间';
comment on column XB_STD_LABELS.name
  is '名称';
comment on column XB_STD_LABELS.updated_at
  is '修改时间';
comment on column XB_STD_LABELS.type_id
  is '类型 ID ###引用表名是XB_STD_LABEL_TYPES### ';
alter table XB_STD_LABELS
  add primary key (ID);
alter table XB_STD_LABELS
  add constraint UK_PH3O8143K8TG2SDPUQ5TN335 unique (CODE);
alter table XB_STD_LABELS
  add constraint FK_GQ70SY62TDHAIIGOIM7DC4E7Q foreign key (TYPE_ID)
  references XB_STD_LABEL_TYPES (ID);

prompt Creating C_PROJECTS_LABELS...
create table C_PROJECTS_LABELS
(
  project_id   NUMBER(10) not null,
  std_label_id NUMBER(10) not null
)
;
comment on table C_PROJECTS_LABELS
  is '项目-学生分类列表';
comment on column C_PROJECTS_LABELS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column C_PROJECTS_LABELS.std_label_id
  is '学生分类标签 ID ###引用表名是XB_STD_LABELS### ';
alter table C_PROJECTS_LABELS
  add constraint FK_EOMKABKVW0E2GI56RPJLX4NU9 foreign key (STD_LABEL_ID)
  references XB_STD_LABELS (ID);
alter table C_PROJECTS_LABELS
  add constraint FK_LYUA3LV46L6FSS171410RH8D2 foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating C_PROJECTS_TIME_SETTINGS...
create table C_PROJECTS_TIME_SETTINGS
(
  project_id      NUMBER(10) not null,
  time_setting_id NUMBER(10) not null
)
;
comment on table C_PROJECTS_TIME_SETTINGS
  is '项目-小节设置';
comment on column C_PROJECTS_TIME_SETTINGS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column C_PROJECTS_TIME_SETTINGS.time_setting_id
  is '每个小节的时间设置 ID ###引用表名是C_TIME_SETTINGS### ';
alter table C_PROJECTS_TIME_SETTINGS
  add constraint FK_BBUTVQXBRI8YLHKVSJWURQNBX foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table C_PROJECTS_TIME_SETTINGS
  add constraint FK_QAM4KB7FYYL07BJJRMM6246UF foreign key (TIME_SETTING_ID)
  references C_TIME_SETTINGS (ID);

prompt Creating C_PROJECTS_TYPES...
create table C_PROJECTS_TYPES
(
  project_id  NUMBER(10) not null,
  std_type_id NUMBER(10) not null
)
;
comment on table C_PROJECTS_TYPES
  is '项目-学生类别列表';
comment on column C_PROJECTS_TYPES.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column C_PROJECTS_TYPES.std_type_id
  is '学生类别 ID ###引用表名是XB_STD_TYPES### ';
alter table C_PROJECTS_TYPES
  add constraint FK_A5FHHKV137J1IQA9VH9SC46GG foreign key (STD_TYPE_ID)
  references XB_STD_TYPES (ID);
alter table C_PROJECTS_TYPES
  add constraint FK_CSAB8E1EX93YEKGJ6UDIL0UI9 foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating C_PROJECT_CLASSROOMS...
create table C_PROJECT_CLASSROOMS
(
  id         NUMBER(10) not null,
  created_at TIMESTAMP(6),
  updated_at TIMESTAMP(6),
  project_id NUMBER(10),
  room_id    NUMBER(10) not null
)
;
comment on table C_PROJECT_CLASSROOMS
  is '项目教室配置';
comment on column C_PROJECT_CLASSROOMS.id
  is '非业务主键';
comment on column C_PROJECT_CLASSROOMS.created_at
  is '创建时间';
comment on column C_PROJECT_CLASSROOMS.updated_at
  is '更新时间';
comment on column C_PROJECT_CLASSROOMS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column C_PROJECT_CLASSROOMS.room_id
  is '教室 ID ###引用表名是C_CLASSROOMS### ';
alter table C_PROJECT_CLASSROOMS
  add primary key (ID);
alter table C_PROJECT_CLASSROOMS
  add constraint FK_4QG33EKNVNIP9GYSDSVCHIRXF foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table C_PROJECT_CLASSROOMS
  add constraint FK_DNW8674GYVMIGJP9TTIW2GF4G foreign key (ROOM_ID)
  references C_CLASSROOMS (ID);

prompt Creating C_PROJECT_CLASSROOMS_DEPARTS...
create table C_PROJECT_CLASSROOMS_DEPARTS
(
  project_classroom_id NUMBER(10) not null,
  department_id        NUMBER(10) not null
)
;
comment on table C_PROJECT_CLASSROOMS_DEPARTS
  is '项目教室配置-固定使用部门';
comment on column C_PROJECT_CLASSROOMS_DEPARTS.project_classroom_id
  is '项目教室配置 ID ###引用表名是C_PROJECT_CLASSROOMS### ';
comment on column C_PROJECT_CLASSROOMS_DEPARTS.department_id
  is '部门组织机构信息 ID ###引用表名是C_DEPARTMENTS### ';
alter table C_PROJECT_CLASSROOMS_DEPARTS
  add primary key (PROJECT_CLASSROOM_ID, DEPARTMENT_ID);
alter table C_PROJECT_CLASSROOMS_DEPARTS
  add constraint FK_AYBWC1XSHFDQDI37Q5UA7XQT4 foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table C_PROJECT_CLASSROOMS_DEPARTS
  add constraint FK_S558DJLYIWY7PHRWISSGJ3W32 foreign key (PROJECT_CLASSROOM_ID)
  references C_PROJECT_CLASSROOMS (ID);

prompt Creating C_PROJECT_CLASSROOMS_RESERVED...
create table C_PROJECT_CLASSROOMS_RESERVED
(
  project_classroom_id NUMBER(10) not null,
  end_time             NUMBER(10) not null,
  start_time           NUMBER(10) not null,
  week_state           VARCHAR2(255 CHAR),
  week_state_num       NUMBER(19) not null,
  weekday              NUMBER(10) not null,
  year                 NUMBER(10) not null
)
;
comment on table C_PROJECT_CLASSROOMS_RESERVED
  is '项目教室配置-保留时间';
comment on column C_PROJECT_CLASSROOMS_RESERVED.project_classroom_id
  is '项目教室配置 ID ###引用表名是C_PROJECT_CLASSROOMS### ';
comment on column C_PROJECT_CLASSROOMS_RESERVED.end_time
  is '结束时间';
comment on column C_PROJECT_CLASSROOMS_RESERVED.start_time
  is '开始时间';
comment on column C_PROJECT_CLASSROOMS_RESERVED.week_state
  is '时间按排在哪些教学周内 每年共53个周，该有效周也采用了长度为53的字符串表示.';
comment on column C_PROJECT_CLASSROOMS_RESERVED.week_state_num
  is '教学周占用的数表示';
comment on column C_PROJECT_CLASSROOMS_RESERVED.weekday
  is '安排在星期几. 数字取值在[1..7]范围内';
comment on column C_PROJECT_CLASSROOMS_RESERVED.year
  is '年份';
alter table C_PROJECT_CLASSROOMS_RESERVED
  add constraint FK_5SEGQGYI1OFX0T3LPIIPBYOR3 foreign key (PROJECT_CLASSROOM_ID)
  references C_PROJECT_CLASSROOMS (ID);

prompt Creating SYS_CODE_CATEGORIES...
create table SYS_CODE_CATEGORIES
(
  id        NUMBER(10) not null,
  indexno   VARCHAR2(30 CHAR) not null,
  name      VARCHAR2(50 CHAR) not null,
  parent_id NUMBER(10)
)
;
comment on table SYS_CODE_CATEGORIES
  is '代码分类';
comment on column SYS_CODE_CATEGORIES.id
  is '非业务主键';
comment on column SYS_CODE_CATEGORIES.indexno
  is '顺序号';
comment on column SYS_CODE_CATEGORIES.name
  is '类别名称';
comment on column SYS_CODE_CATEGORIES.parent_id
  is '上级 ID ###引用表名是SYS_CODE_CATEGORIES### ';
alter table SYS_CODE_CATEGORIES
  add primary key (ID);
alter table SYS_CODE_CATEGORIES
  add constraint UK_G4A9M154KDBGBF4TBW1C7YRS2 unique (NAME);
alter table SYS_CODE_CATEGORIES
  add constraint FK_7LA64BJIPYQSC34SQ2AT2I11C foreign key (PARENT_ID)
  references SYS_CODE_CATEGORIES (ID);

prompt Creating SYS_CODE_METAS...
create table SYS_CODE_METAS
(
  id          NUMBER(10) not null,
  class_name  VARCHAR2(100 CHAR) not null,
  name        VARCHAR2(50 CHAR) not null,
  title       VARCHAR2(100 CHAR) not null,
  category_id NUMBER(10) not null
)
;
comment on table SYS_CODE_METAS
  is '登记系统使用的基础代码';
comment on column SYS_CODE_METAS.id
  is '非业务主键';
comment on column SYS_CODE_METAS.class_name
  is '类名';
comment on column SYS_CODE_METAS.name
  is '代码名称';
comment on column SYS_CODE_METAS.title
  is '中文名称';
comment on column SYS_CODE_METAS.category_id
  is '所在分类 ID ###引用表名是SYS_CODE_CATEGORIES### ';
alter table SYS_CODE_METAS
  add primary key (ID);
alter table SYS_CODE_METAS
  add constraint UK_T2Q1DXLOGSPIYGOMA1OTEKLR6 unique (NAME);
alter table SYS_CODE_METAS
  add constraint FK_SWGAHYNKG9QPH4Y8KWRVE2LGW foreign key (CATEGORY_ID)
  references SYS_CODE_CATEGORIES (ID);

prompt Creating C_PROJECT_CODES...
create table C_PROJECT_CODES
(
  id         NUMBER(19) not null,
  code_id    NUMBER(10),
  meta_id    NUMBER(10),
  project_id NUMBER(10)
)
;
comment on table C_PROJECT_CODES
  is '项目基础代码配置';
comment on column C_PROJECT_CODES.id
  is '非业务主键';
comment on column C_PROJECT_CODES.code_id
  is '代码ID';
comment on column C_PROJECT_CODES.meta_id
  is '代码元 ID ###引用表名是SYS_CODE_METAS### ';
comment on column C_PROJECT_CODES.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
alter table C_PROJECT_CODES
  add primary key (ID);
alter table C_PROJECT_CODES
  add constraint FK_9KLL6S0I536EJRSK4A48UE5Q4 foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table C_PROJECT_CODES
  add constraint FK_I0HAQF1XJD3VUBWH78XNON0KI foreign key (META_ID)
  references SYS_CODE_METAS (ID);

prompt Creating C_PROJECT_CONFIGS...
create table C_PROJECT_CONFIGS
(
  id         NUMBER(19) not null,
  created_at TIMESTAMP(6),
  updated_at TIMESTAMP(6),
  project_id NUMBER(10)
)
;
comment on table C_PROJECT_CONFIGS
  is '项目配置';
comment on column C_PROJECT_CONFIGS.id
  is '非业务主键';
comment on column C_PROJECT_CONFIGS.created_at
  is '创建时间';
comment on column C_PROJECT_CONFIGS.updated_at
  is '更新时间';
comment on column C_PROJECT_CONFIGS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
alter table C_PROJECT_CONFIGS
  add primary key (ID);
alter table C_PROJECT_CONFIGS
  add constraint FK_QA3XIMP3DV5DD0CXPXOOJ6M97 foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating C_PROJECT_PROPERTIES...
create table C_PROJECT_PROPERTIES
(
  id        NUMBER(19) not null,
  name      VARCHAR2(100 CHAR) not null,
  value     VARCHAR2(4000 CHAR) not null,
  config_id NUMBER(19)
)
;
comment on table C_PROJECT_PROPERTIES
  is '项目配置属性';
comment on column C_PROJECT_PROPERTIES.id
  is '非业务主键';
comment on column C_PROJECT_PROPERTIES.name
  is '配置项';
comment on column C_PROJECT_PROPERTIES.value
  is '值';
comment on column C_PROJECT_PROPERTIES.config_id
  is '项目配置 ID ###引用表名是C_PROJECT_CONFIGS### ';
alter table C_PROJECT_PROPERTIES
  add primary key (ID);
alter table C_PROJECT_PROPERTIES
  add constraint FK_7UQ26CPU2TPQN4S1VD2VMDH4H foreign key (CONFIG_ID)
  references C_PROJECT_CONFIGS (ID);

prompt Creating C_SEMESTER_STAGES...
create table C_SEMESTER_STAGES
(
  id          NUMBER(10) not null,
  end_week    NUMBER(10) not null,
  name        VARCHAR2(40 CHAR) not null,
  remark      VARCHAR2(255 CHAR),
  start_week  NUMBER(10) not null,
  semester_id NUMBER(10) not null
)
;
comment on table C_SEMESTER_STAGES
  is '学期阶段';
comment on column C_SEMESTER_STAGES.id
  is '非业务主键';
comment on column C_SEMESTER_STAGES.end_week
  is '结束周';
comment on column C_SEMESTER_STAGES.name
  is '名称';
comment on column C_SEMESTER_STAGES.remark
  is '说明';
comment on column C_SEMESTER_STAGES.start_week
  is '起始周';
comment on column C_SEMESTER_STAGES.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
alter table C_SEMESTER_STAGES
  add primary key (ID);
alter table C_SEMESTER_STAGES
  add constraint FK_8I8E10IPJ29G15DOTX1LQ6DT7 foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);

prompt Creating GB_DIVISIONS...
create table GB_DIVISIONS
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6),
  parent_id    NUMBER(10)
)
;
comment on table GB_DIVISIONS
  is '行政区划';
comment on column GB_DIVISIONS.id
  is '非业务主键';
comment on column GB_DIVISIONS.code
  is '代码';
comment on column GB_DIVISIONS.created_at
  is '创建时间';
comment on column GB_DIVISIONS.effective_at
  is '生效时间';
comment on column GB_DIVISIONS.eng_name
  is '英文名称';
comment on column GB_DIVISIONS.invalid_at
  is '失效时间';
comment on column GB_DIVISIONS.name
  is '名称';
comment on column GB_DIVISIONS.updated_at
  is '修改时间';
comment on column GB_DIVISIONS.parent_id
  is '上级区划 ID ###引用表名是GB_DIVISIONS### ';
alter table GB_DIVISIONS
  add primary key (ID);
alter table GB_DIVISIONS
  add constraint UK_LSWJNJGRIC9XHISL1BAV8NEWO unique (CODE);
alter table GB_DIVISIONS
  add constraint FK_C99JM51EHA7YA0CMG6PYWAI80 foreign key (PARENT_ID)
  references GB_DIVISIONS (ID);

prompt Creating GB_MARITAL_STATUSES...
create table GB_MARITAL_STATUSES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table GB_MARITAL_STATUSES
  is '婚姻状况';
comment on column GB_MARITAL_STATUSES.id
  is '非业务主键';
comment on column GB_MARITAL_STATUSES.code
  is '代码';
comment on column GB_MARITAL_STATUSES.created_at
  is '创建时间';
comment on column GB_MARITAL_STATUSES.effective_at
  is '生效时间';
comment on column GB_MARITAL_STATUSES.eng_name
  is '英文名称';
comment on column GB_MARITAL_STATUSES.invalid_at
  is '失效时间';
comment on column GB_MARITAL_STATUSES.name
  is '名称';
comment on column GB_MARITAL_STATUSES.updated_at
  is '修改时间';
alter table GB_MARITAL_STATUSES
  add primary key (ID);
alter table GB_MARITAL_STATUSES
  add constraint UK_57OBY2GPAS08PGGY1L0E7L6L8 unique (CODE);

prompt Creating C_STD_PEOPLE...
create table C_STD_PEOPLE
(
  id                NUMBER(19) not null,
  created_at        TIMESTAMP(6),
  updated_at        TIMESTAMP(6),
  account           VARCHAR2(255 CHAR),
  bank              VARCHAR2(255 CHAR),
  birthday          DATE,
  charactor         VARCHAR2(2000 CHAR),
  code              VARCHAR2(32 CHAR) not null,
  eng_name          VARCHAR2(255 CHAR) not null,
  idcard            VARCHAR2(255 CHAR),
  join_on           DATE,
  name              VARCHAR2(255 CHAR) not null,
  oldname           VARCHAR2(255 CHAR),
  ancestral_addr_id NUMBER(10),
  country_id        NUMBER(10),
  gender_id         NUMBER(10) not null,
  idcard_type_id    NUMBER(10),
  marital_status_id NUMBER(10),
  nation_id         NUMBER(10),
  politic_visage_id NUMBER(10)
)
;
comment on table C_STD_PEOPLE
  is '学生基本信息';
comment on column C_STD_PEOPLE.id
  is '非业务主键';
comment on column C_STD_PEOPLE.created_at
  is '创建时间';
comment on column C_STD_PEOPLE.updated_at
  is '更新时间';
comment on column C_STD_PEOPLE.account
  is '账户';
comment on column C_STD_PEOPLE.bank
  is '银行';
comment on column C_STD_PEOPLE.birthday
  is '出生年月';
comment on column C_STD_PEOPLE.charactor
  is '特长爱好以及个人说明';
comment on column C_STD_PEOPLE.code
  is '人员编码';
comment on column C_STD_PEOPLE.eng_name
  is '英文名';
comment on column C_STD_PEOPLE.idcard
  is '身份证';
comment on column C_STD_PEOPLE.join_on
  is '入团(党)时间';
comment on column C_STD_PEOPLE.name
  is '姓名';
comment on column C_STD_PEOPLE.oldname
  is '曾用名';
comment on column C_STD_PEOPLE.ancestral_addr_id
  is '籍贯 ID ###引用表名是GB_DIVISIONS### ';
comment on column C_STD_PEOPLE.country_id
  is '国家地区 ID ###引用表名是GB_COUNTRIES### ';
comment on column C_STD_PEOPLE.gender_id
  is '性别 ID ###引用表名是GB_GENDERS### ';
comment on column C_STD_PEOPLE.idcard_type_id
  is '证件类型 身份证/护照等 ID ###引用表名是HB_IDCARD_TYPES### ';
comment on column C_STD_PEOPLE.marital_status_id
  is '婚姻状况 ID ###引用表名是GB_MARITAL_STATUSES### ';
comment on column C_STD_PEOPLE.nation_id
  is '民族 留学生使用外国民族 ID ###引用表名是GB_NATIONS### ';
comment on column C_STD_PEOPLE.politic_visage_id
  is '政治面貌 不适用留学生 ID ###引用表名是GB_POLITIC_VISAGES### ';
alter table C_STD_PEOPLE
  add primary key (ID);
alter table C_STD_PEOPLE
  add constraint UK_SEU4RBWM9GRSMCHY49WOPMP17 unique (ACCOUNT);
alter table C_STD_PEOPLE
  add constraint FK_1WX8VIHPU3XYQVBSFFMUI53UC foreign key (IDCARD_TYPE_ID)
  references HB_IDCARD_TYPES (ID);
alter table C_STD_PEOPLE
  add constraint FK_4020H5DDUN82ES63842IXK5PR foreign key (NATION_ID)
  references GB_NATIONS (ID);
alter table C_STD_PEOPLE
  add constraint FK_4AOA872KUO3TEADC9H558CRLV foreign key (GENDER_ID)
  references GB_GENDERS (ID);
alter table C_STD_PEOPLE
  add constraint FK_5IQEEK94XQACAJK6RKL5QBQ28 foreign key (MARITAL_STATUS_ID)
  references GB_MARITAL_STATUSES (ID);
alter table C_STD_PEOPLE
  add constraint FK_ENOSF9FREFGN3J4CW3MRW47FJ foreign key (COUNTRY_ID)
  references GB_COUNTRIES (ID);
alter table C_STD_PEOPLE
  add constraint FK_MN0BU5LW2UQ1V9CO6YIISRBF1 foreign key (POLITIC_VISAGE_ID)
  references GB_POLITIC_VISAGES (ID);
alter table C_STD_PEOPLE
  add constraint FK_Q7YBGUPEJOBAJ76GU1V0Y7LGK foreign key (ANCESTRAL_ADDR_ID)
  references GB_DIVISIONS (ID);

prompt Creating GB_STUDY_TYPES...
create table GB_STUDY_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table GB_STUDY_TYPES
  is '学习形式';
comment on column GB_STUDY_TYPES.id
  is '非业务主键';
comment on column GB_STUDY_TYPES.code
  is '代码';
comment on column GB_STUDY_TYPES.created_at
  is '创建时间';
comment on column GB_STUDY_TYPES.effective_at
  is '生效时间';
comment on column GB_STUDY_TYPES.eng_name
  is '英文名称';
comment on column GB_STUDY_TYPES.invalid_at
  is '失效时间';
comment on column GB_STUDY_TYPES.name
  is '名称';
comment on column GB_STUDY_TYPES.updated_at
  is '修改时间';
alter table GB_STUDY_TYPES
  add primary key (ID);
alter table GB_STUDY_TYPES
  add constraint UK_DDOWYYFHCOBAGELFT8LE1SJRD unique (CODE);

prompt Creating C_STUDENTS...
create table C_STUDENTS
(
  id              NUMBER(19) not null,
  created_at      TIMESTAMP(6),
  updated_at      TIMESTAMP(6),
  code            VARCHAR2(32 CHAR) not null,
  duration        FLOAT not null,
  eng_name        VARCHAR2(255 CHAR) not null,
  enroll_on       DATE not null,
  grade           VARCHAR2(10 CHAR) not null,
  graduate_on     DATE not null,
  name            VARCHAR2(50 CHAR) not null,
  regist_on       DATE not null,
  registed        NUMBER(1) not null,
  remark          VARCHAR2(2000 CHAR),
  project_id      NUMBER(10),
  education_id    NUMBER(10) not null,
  adminclass_id   NUMBER(10),
  campus_id       NUMBER(10),
  department_id   NUMBER(10) not null,
  direction_id    NUMBER(10),
  gender_id       NUMBER(10) not null,
  major_id        NUMBER(10) not null,
  major_depart_id NUMBER(10) not null,
  person_id       NUMBER(19),
  study_type_id   NUMBER(10),
  tutor_id        NUMBER(19),
  type_id         NUMBER(10)
)
;
comment on table C_STUDENTS
  is '学籍信息实现';
comment on column C_STUDENTS.id
  is '非业务主键';
comment on column C_STUDENTS.created_at
  is '创建时间';
comment on column C_STUDENTS.updated_at
  is '更新时间';
comment on column C_STUDENTS.code
  is '学号';
comment on column C_STUDENTS.duration
  is '学制 学习年限（允许0.5年出现）';
comment on column C_STUDENTS.eng_name
  is '英文名';
comment on column C_STUDENTS.enroll_on
  is '入学报到日期';
comment on column C_STUDENTS.grade
  is '年级 表示现在年级，不同于入学时间';
comment on column C_STUDENTS.graduate_on
  is '应毕业时间 预计毕业日期';
comment on column C_STUDENTS.name
  is '姓名';
comment on column C_STUDENTS.regist_on
  is '学籍生效日期';
comment on column C_STUDENTS.registed
  is '是否有学籍';
comment on column C_STUDENTS.remark
  is '备注';
comment on column C_STUDENTS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column C_STUDENTS.education_id
  is '学历层次 ID ###引用表名是HB_EDUCATIONS### ';
comment on column C_STUDENTS.adminclass_id
  is '行政班级 ID ###引用表名是C_ADMINCLASSES### ';
comment on column C_STUDENTS.campus_id
  is '校区 ID ###引用表名是C_CAMPUSES### ';
comment on column C_STUDENTS.department_id
  is '管理院系 行政管理院系 ID ###引用表名是C_DEPARTMENTS### ';
comment on column C_STUDENTS.direction_id
  is '方向 当前修读方向 ID ###引用表名是C_DIRECTIONS### ';
comment on column C_STUDENTS.gender_id
  is '性别 ID ###引用表名是GB_GENDERS### ';
comment on column C_STUDENTS.major_id
  is '专业 当前修读专业 ID ###引用表名是C_MAJORS### ';
comment on column C_STUDENTS.major_depart_id
  is '专业所在院系 ID ###引用表名是C_DEPARTMENTS### ';
comment on column C_STUDENTS.person_id
  is '基本信息 ID ###引用表名是C_STD_PEOPLE### ';
comment on column C_STUDENTS.study_type_id
  is '学习形式 全日制/业余/函授 ID ###引用表名是GB_STUDY_TYPES### ';
comment on column C_STUDENTS.tutor_id
  is '导师 ID ###引用表名是C_TEACHERS### ';
comment on column C_STUDENTS.type_id
  is '学生类别 所在项目内的学生类别 ID ###引用表名是XB_STD_TYPES### ';
alter table C_STUDENTS
  add primary key (ID);
alter table C_STUDENTS
  add constraint UK_LSJJCNY1IAF5XUDSSMGKDRN0E unique (CODE);
alter table C_STUDENTS
  add constraint FK_1FP5YICJT9UBN6EXJ6TWR3G1E foreign key (DIRECTION_ID)
  references C_DIRECTIONS (ID);
alter table C_STUDENTS
  add constraint FK_2IHSX3BSVAU19N53FS718CRTS foreign key (MAJOR_ID)
  references C_MAJORS (ID);
alter table C_STUDENTS
  add constraint FK_6SSPULWCUECHXLQMXED88Q07H foreign key (ADMINCLASS_ID)
  references C_ADMINCLASSES (ID);
alter table C_STUDENTS
  add constraint FK_91MIICMCC1JX1ILM446AJ0L3H foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);
alter table C_STUDENTS
  add constraint FK_9E3LGUWOXRQWW1DC8VEA73CQ7 foreign key (TYPE_ID)
  references XB_STD_TYPES (ID);
alter table C_STUDENTS
  add constraint FK_FNVFY3ULSI73J6OKLWS3VU60P foreign key (GENDER_ID)
  references GB_GENDERS (ID);
alter table C_STUDENTS
  add constraint FK_IK8N1Q8K1YYM1B4EX23EFDQ92 foreign key (TUTOR_ID)
  references C_TEACHERS (ID);
alter table C_STUDENTS
  add constraint FK_LKBJQDDW37C74TELYFBL46WH foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table C_STUDENTS
  add constraint FK_MMLOM35WCY997NRLXBG6WRUXS foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table C_STUDENTS
  add constraint FK_MRVF4WOHJ7HGK9DF5YUNPDNCO foreign key (CAMPUS_ID)
  references C_CAMPUSES (ID);
alter table C_STUDENTS
  add constraint FK_QKBAX9RSTA5H8YRQXUPMO4O3Y foreign key (PERSON_ID)
  references C_STD_PEOPLE (ID);
alter table C_STUDENTS
  add constraint FK_RH7TF9RCUGKJN8H788QWI26P4 foreign key (MAJOR_DEPART_ID)
  references C_DEPARTMENTS (ID);
alter table C_STUDENTS
  add constraint FK_TJW5WVF0BB3EBE2DHJPUFYODP foreign key (STUDY_TYPE_ID)
  references GB_STUDY_TYPES (ID);

prompt Creating C_STUDENTS_LABELS...
create table C_STUDENTS_LABELS
(
  student_id   NUMBER(19) not null,
  std_label_id NUMBER(10) not null,
  type_id      NUMBER(10) not null
)
;
comment on table C_STUDENTS_LABELS
  is '学籍信息实现-学生分类标签';
comment on column C_STUDENTS_LABELS.student_id
  is '学籍信息实现 ID ###引用表名是C_STUDENTS### ';
comment on column C_STUDENTS_LABELS.std_label_id
  is '学生分类标签 ID ###引用表名是XB_STD_LABELS### ';
comment on column C_STUDENTS_LABELS.type_id
  is '学生分类标签类型 ID ###引用表名是XB_STD_LABEL_TYPES### ';
alter table C_STUDENTS_LABELS
  add primary key (STUDENT_ID, TYPE_ID);
alter table C_STUDENTS_LABELS
  add constraint FK_1OBMIMFYU58MNJT1EX9GC78PT foreign key (STD_LABEL_ID)
  references XB_STD_LABELS (ID);
alter table C_STUDENTS_LABELS
  add constraint FK_EJ28666ALOWLWDHMEHMUBATGX foreign key (TYPE_ID)
  references XB_STD_LABEL_TYPES (ID);
alter table C_STUDENTS_LABELS
  add constraint FK_LIPVAYOP9VG6GHOTHFU0SR6A4 foreign key (STUDENT_ID)
  references C_STUDENTS (ID);

prompt Creating HB_STD_STATUSES...
create table HB_STD_STATUSES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_STD_STATUSES
  is '学生学籍状态';
comment on column HB_STD_STATUSES.id
  is '非业务主键';
comment on column HB_STD_STATUSES.code
  is '代码';
comment on column HB_STD_STATUSES.created_at
  is '创建时间';
comment on column HB_STD_STATUSES.effective_at
  is '生效时间';
comment on column HB_STD_STATUSES.eng_name
  is '英文名称';
comment on column HB_STD_STATUSES.invalid_at
  is '失效时间';
comment on column HB_STD_STATUSES.name
  is '名称';
comment on column HB_STD_STATUSES.updated_at
  is '修改时间';
alter table HB_STD_STATUSES
  add primary key (ID);
alter table HB_STD_STATUSES
  add constraint UK_L4LN0JKQP3U84CBNXBNSYFNY1 unique (CODE);

prompt Creating C_STUDENT_JOURNALS...
create table C_STUDENT_JOURNALS
(
  id            NUMBER(19) not null,
  begin_on      DATE not null,
  end_on        DATE,
  grade         VARCHAR2(255 CHAR) not null,
  inschool      NUMBER(1) not null,
  remark        VARCHAR2(255 CHAR),
  adminclass_id NUMBER(10),
  department_id NUMBER(10) not null,
  direction_id  NUMBER(10),
  major_id      NUMBER(10) not null,
  status_id     NUMBER(10) not null,
  std_id        NUMBER(19) not null
)
;
comment on table C_STUDENT_JOURNALS
  is '学籍状态日志';
comment on column C_STUDENT_JOURNALS.id
  is '非业务主键';
comment on column C_STUDENT_JOURNALS.begin_on
  is '起始日期';
comment on column C_STUDENT_JOURNALS.end_on
  is '结束日期';
comment on column C_STUDENT_JOURNALS.grade
  is '年级';
comment on column C_STUDENT_JOURNALS.inschool
  is '是否在校';
comment on column C_STUDENT_JOURNALS.remark
  is '备注';
comment on column C_STUDENT_JOURNALS.adminclass_id
  is '行政班级 ID ###引用表名是C_ADMINCLASSES### ';
comment on column C_STUDENT_JOURNALS.department_id
  is '管理院系 ID ###引用表名是C_DEPARTMENTS### ';
comment on column C_STUDENT_JOURNALS.direction_id
  is '方向 ID ###引用表名是C_DIRECTIONS### ';
comment on column C_STUDENT_JOURNALS.major_id
  is '专业 ID ###引用表名是C_MAJORS### ';
comment on column C_STUDENT_JOURNALS.status_id
  is '学籍状态 ID ###引用表名是HB_STD_STATUSES### ';
comment on column C_STUDENT_JOURNALS.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table C_STUDENT_JOURNALS
  add primary key (ID);
alter table C_STUDENT_JOURNALS
  add constraint FK_1GQ8WU2VTQGWEI5T78E0TJVJR foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table C_STUDENT_JOURNALS
  add constraint FK_2T8N1FI4CWRP4DSJI55BL5NLM foreign key (DIRECTION_ID)
  references C_DIRECTIONS (ID);
alter table C_STUDENT_JOURNALS
  add constraint FK_7X43572M4OQB1OJ3U7FUM0FTR foreign key (STATUS_ID)
  references HB_STD_STATUSES (ID);
alter table C_STUDENT_JOURNALS
  add constraint FK_FEIBFQR3VU8IRP9YRPVO1C6VC foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table C_STUDENT_JOURNALS
  add constraint FK_NDY61GHAYCO5WXWROPLKW6E63 foreign key (ADMINCLASS_ID)
  references C_ADMINCLASSES (ID);
alter table C_STUDENT_JOURNALS
  add constraint FK_TR3YDLV6WOICHAM05BC47R162 foreign key (MAJOR_ID)
  references C_MAJORS (ID);

prompt Creating C_TEACHER_JOURNALS...
create table C_TEACHER_JOURNALS
(
  id            NUMBER(19) not null,
  begin_on      DATE not null,
  end_on        DATE,
  remark        VARCHAR2(255 CHAR),
  degree_id     NUMBER(10),
  department_id NUMBER(10) not null,
  education_id  NUMBER(10),
  teacher_id    NUMBER(19) not null,
  title_id      NUMBER(10),
  tutor_type_id NUMBER(10)
)
;
comment on table C_TEACHER_JOURNALS
  is '教师日志信息';
comment on column C_TEACHER_JOURNALS.id
  is '非业务主键';
comment on column C_TEACHER_JOURNALS.begin_on
  is '起始日期';
comment on column C_TEACHER_JOURNALS.end_on
  is '结束日期';
comment on column C_TEACHER_JOURNALS.remark
  is '备注';
comment on column C_TEACHER_JOURNALS.degree_id
  is '学位 ID ###引用表名是GB_DEGREES### ';
comment on column C_TEACHER_JOURNALS.department_id
  is '部门 ID ###引用表名是C_DEPARTMENTS### ';
comment on column C_TEACHER_JOURNALS.education_id
  is '学历 ID ###引用表名是HB_EDUCATIONS### ';
comment on column C_TEACHER_JOURNALS.teacher_id
  is '教师 ID ###引用表名是C_TEACHERS### ';
comment on column C_TEACHER_JOURNALS.title_id
  is '职称 ID ###引用表名是GB_TEACHER_TITLES### ';
comment on column C_TEACHER_JOURNALS.tutor_type_id
  is '导师类别 ID ###引用表名是HB_TUTOR_TYPES### ';
alter table C_TEACHER_JOURNALS
  add primary key (ID);
alter table C_TEACHER_JOURNALS
  add constraint FK_1X9CGJ1J1EJL3M5GASE6L4LRJ foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table C_TEACHER_JOURNALS
  add constraint FK_6HRFRX5TD2WAR32O67RPTF2LB foreign key (TEACHER_ID)
  references C_TEACHERS (ID);
alter table C_TEACHER_JOURNALS
  add constraint FK_6R2ASTSMT6YOXR2NPRYPH00P0 foreign key (TUTOR_TYPE_ID)
  references HB_TUTOR_TYPES (ID);
alter table C_TEACHER_JOURNALS
  add constraint FK_9P9ML5750BF1HNHKCSPCERJH6 foreign key (DEGREE_ID)
  references GB_DEGREES (ID);
alter table C_TEACHER_JOURNALS
  add constraint FK_H58PN7WLRVEIMKVJQREYPBHJ5 foreign key (TITLE_ID)
  references GB_TEACHER_TITLES (ID);
alter table C_TEACHER_JOURNALS
  add constraint FK_N1GFQ2H96FO03QR3BD1U9QDW foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);

prompt Creating D_THESIS_PROCESSES...
create table D_THESIS_PROCESSES
(
  id        NUMBER(19) not null,
  education RAW(255) not null,
  effected  NUMBER(1) not null,
  name      VARCHAR2(255 CHAR) not null,
  project   RAW(255) not null,
  remark    VARCHAR2(800 CHAR)
)
;
alter table D_THESIS_PROCESSES
  add primary key (ID);

prompt Creating D_THESIS_RANKS...
create table D_THESIS_RANKS
(
  id          NUMBER(19) not null,
  code        VARCHAR2(255 CHAR) not null,
  enabled     NUMBER(1) not null,
  eng_name    VARCHAR2(255 CHAR),
  name        VARCHAR2(255 CHAR) not null,
  update_date TIMESTAMP(6)
)
;
alter table D_THESIS_RANKS
  add primary key (ID);

prompt Creating D_GOOD_THESISES...
create table D_GOOD_THESISES
(
  id         NUMBER(19) not null,
  file_name  VARCHAR2(255 CHAR),
  point      FLOAT,
  title      VARCHAR2(255 CHAR) not null,
  year       VARCHAR2(255 CHAR),
  process_id NUMBER(19) not null,
  rank_id    NUMBER(19) not null,
  std_id     NUMBER(19) not null
)
;
alter table D_GOOD_THESISES
  add primary key (ID);
alter table D_GOOD_THESISES
  add constraint FK_3D6AUQ5INUGUWJ6955PY3KFUU foreign key (RANK_ID)
  references D_THESIS_RANKS (ID);
alter table D_GOOD_THESISES
  add constraint FK_3KH72OUKSIV39RPXTUOF20PMT foreign key (PROCESS_ID)
  references D_THESIS_PROCESSES (ID);
alter table D_GOOD_THESISES
  add constraint FK_FFD8MGTEVVSQA2IHODCEWSESX foreign key (STD_ID)
  references C_STUDENTS (ID);

prompt Creating D_THESIS_ACTIVE_TYPES...
create table D_THESIS_ACTIVE_TYPES
(
  id           RAW(255) not null,
  code         VARCHAR2(32 CHAR) not null,
  name         VARCHAR2(100 CHAR) not null,
  eng_name     VARCHAR2(100 CHAR),
  effective_at TIMESTAMP(6) not null,
  invalid_at   TIMESTAMP(6),
  enabled      NUMBER(1),
  remark       VARCHAR2(255 CHAR)
)
;
alter table D_THESIS_ACTIVE_TYPES
  add primary key (ID);
alter table D_THESIS_ACTIVE_TYPES
  add constraint UK_RAQIB61C9AKTUW5MQL63W3CEB unique (CODE);

prompt Creating D_THESIS_ANNOTATE_ACTIVES...
create table D_THESIS_ANNOTATE_ACTIVES
(
  id                RAW(255) not null,
  name              VARCHAR2(255 CHAR),
  active_type       RAW(255),
  start_date        TIMESTAMP(6),
  end_date          TIMESTAMP(6),
  effected          NUMBER(1),
  tutor_audited     NUMBER(1),
  remark            VARCHAR2(800 CHAR),
  allow_apply_count NUMBER(10),
  process           NUMBER(19),
  number_year       NUMBER(10),
  start_number      NUMBER(10),
  expert_suffix     VARCHAR2(30 CHAR),
  effect_count      NUMBER(10),
  repeat_seq        VARCHAR2(20 CHAR)
)
;
alter table D_THESIS_ANNOTATE_ACTIVES
  add primary key (ID);
alter table D_THESIS_ANNOTATE_ACTIVES
  add constraint FK_O61AN5PILSS9U6H2EP1L1M16 foreign key (ACTIVE_TYPE)
  references D_THESIS_ACTIVE_TYPES (ID);
alter table D_THESIS_ANNOTATE_ACTIVES
  add constraint FK_SB3DDYAHX7134W5NDXCY9UVBF foreign key (PROCESS)
  references D_THESIS_PROCESSES (ID);

prompt Creating D_THESIS_ANNOTATES...
create table D_THESIS_ANNOTATES
(
  id                  RAW(255) not null,
  std                 NUMBER(19),
  title               VARCHAR2(255 CHAR),
  apply_count         NUMBER(10),
  tutor_audited       NUMBER(10),
  passed              NUMBER(1),
  overed              NUMBER(1),
  active              RAW(255),
  file_name           VARCHAR2(255 CHAR),
  department_validate NUMBER(1),
  tutor_validate      NUMBER(1),
  is_double_blind     NUMBER(1),
  avg_mark            FLOAT,
  remark              VARCHAR2(1000 CHAR),
  sub_date            TIMESTAMP(6),
  type                RAW(255),
  thesis_lack         VARCHAR2(1000 CHAR),
  active_id           RAW(255)
)
;
alter table D_THESIS_ANNOTATES
  add primary key (ID);
alter table D_THESIS_ANNOTATES
  add constraint FK_2O6DRP0CEIPKG5JUL9FL5WSYV foreign key (TYPE)
  references D_THESIS_ACTIVE_TYPES (ID);
alter table D_THESIS_ANNOTATES
  add constraint FK_4VHJS8WWGJ3PYLGBLYH40DIU9 foreign key (STD)
  references C_STUDENTS (ID);
alter table D_THESIS_ANNOTATES
  add constraint FK_GAUFJ1PCA9G1PIHEVY4F2LNPL foreign key (ACTIVE_ID)
  references D_THESIS_ANNOTATE_ACTIVES (ID);
alter table D_THESIS_ANNOTATES
  add constraint FK_H50E001V8KQI2LT3WWXSYUNYX foreign key (ACTIVE)
  references D_THESIS_ANNOTATE_ACTIVES (ID);

prompt Creating D_THESIS_ANNOTATE_TEACHERS...
create table D_THESIS_ANNOTATE_TEACHERS
(
  id                 RAW(255) not null,
  name               VARCHAR2(255 CHAR),
  id_card            VARCHAR2(255 CHAR),
  school             VARCHAR2(255 CHAR),
  tel                VARCHAR2(255 CHAR),
  expert_title       VARCHAR2(255 CHAR),
  research_direction VARCHAR2(255 CHAR),
  email              VARCHAR2(255 CHAR)
)
;
alter table D_THESIS_ANNOTATE_TEACHERS
  add primary key (ID);

prompt Creating D_THESIS_ANNOTATE_BOOKS...
create table D_THESIS_ANNOTATE_BOOKS
(
  id                         RAW(255) not null,
  serial                     VARCHAR2(32 CHAR),
  thesis_appraise            VARCHAR2(2000 CHAR),
  lack_teacher               VARCHAR2(1 CHAR),
  teacher_professional_level VARCHAR2(1 CHAR),
  point                      FLOAT,
  login_name                 VARCHAR2(20 CHAR),
  pwd                        VARCHAR2(10 CHAR),
  end_date                   TIMESTAMP(6),
  annotate                   RAW(255),
  teacher                    RAW(255),
  overed                     NUMBER(1),
  annotate_id                RAW(255)
)
;
alter table D_THESIS_ANNOTATE_BOOKS
  add primary key (ID);
alter table D_THESIS_ANNOTATE_BOOKS
  add constraint FK_14T4L0H1OU4JW0VXFKN3UDMJK foreign key (ANNOTATE_ID)
  references D_THESIS_ANNOTATES (ID);
alter table D_THESIS_ANNOTATE_BOOKS
  add constraint FK_BTK30YRT5T04L06I51HU3NOGA foreign key (TEACHER)
  references D_THESIS_ANNOTATE_TEACHERS (ID);
alter table D_THESIS_ANNOTATE_BOOKS
  add constraint FK_DFBPARDSQ71HNC0879WN9HN8S foreign key (ANNOTATE)
  references D_THESIS_ANNOTATES (ID);

prompt Creating D_THESIS_EVALUATE_PROJECTS...
create table D_THESIS_EVALUATE_PROJECTS
(
  id          RAW(255) not null,
  code        VARCHAR2(255 CHAR) not null,
  name        VARCHAR2(255 CHAR) not null,
  eng_name    VARCHAR2(255 CHAR),
  update_date TIMESTAMP(6),
  enabled     NUMBER(1),
  explain     VARCHAR2(550 CHAR)
)
;
alter table D_THESIS_EVALUATE_PROJECTS
  add primary key (ID);

prompt Creating D_THESIS_ANNOTATE_EVALUATES...
create table D_THESIS_ANNOTATE_EVALUATES
(
  active_id           RAW(255) not null,
  evaluate_project_id RAW(255) not null
)
;
alter table D_THESIS_ANNOTATE_EVALUATES
  add primary key (ACTIVE_ID, EVALUATE_PROJECT_ID);
alter table D_THESIS_ANNOTATE_EVALUATES
  add constraint FK_3VTEEFUMIJIDLOVBBII2KEALA foreign key (ACTIVE_ID)
  references D_THESIS_ANNOTATE_ACTIVES (ID);
alter table D_THESIS_ANNOTATE_EVALUATES
  add constraint FK_MI812DT14JJOG3NWD1VMYED3X foreign key (EVALUATE_PROJECT_ID)
  references D_THESIS_EVALUATE_PROJECTS (ID);

prompt Creating D_THESIS_ANNOTATE_FILTERS...
create table D_THESIS_ANNOTATE_FILTERS
(
  id            RAW(255) not null,
  property_name VARCHAR2(10 CHAR),
  content       VARCHAR2(80 CHAR),
  operate       VARCHAR2(10 CHAR),
  active        RAW(255)
)
;
alter table D_THESIS_ANNOTATE_FILTERS
  add primary key (ID);
alter table D_THESIS_ANNOTATE_FILTERS
  add constraint FK_FF722X94FREHFDFJFRVPDWU2B foreign key (ACTIVE)
  references D_THESIS_ANNOTATE_ACTIVES (ID);

prompt Creating D_THESIS_ANSWER_ACTIVES...
create table D_THESIS_ANSWER_ACTIVES
(
  id                RAW(255) not null,
  name              VARCHAR2(255 CHAR),
  active_type       RAW(255),
  start_date        TIMESTAMP(6),
  end_date          TIMESTAMP(6),
  effected          NUMBER(1),
  tutor_audited     NUMBER(1),
  remark            VARCHAR2(800 CHAR),
  allow_apply_count NUMBER(10),
  process           NUMBER(19)
)
;
alter table D_THESIS_ANSWER_ACTIVES
  add primary key (ID);
alter table D_THESIS_ANSWER_ACTIVES
  add constraint FK_7X8TUIEK3FL0X3XQLSMI2CAWF foreign key (PROCESS)
  references D_THESIS_PROCESSES (ID);
alter table D_THESIS_ANSWER_ACTIVES
  add constraint FK_EC2LF9BHNQXW65QGC7MG5PCHG foreign key (ACTIVE_TYPE)
  references D_THESIS_ACTIVE_TYPES (ID);

prompt Creating D_THESIS_ANSWERS...
create table D_THESIS_ANSWERS
(
  id            RAW(255) not null,
  std           NUMBER(19),
  title         VARCHAR2(255 CHAR),
  apply_count   NUMBER(10),
  tutor_audited NUMBER(10),
  passed        NUMBER(1),
  overed        NUMBER(1),
  added         NUMBER(1),
  active        RAW(255),
  file_name     VARCHAR2(255 CHAR),
  answer_date   TIMESTAMP(6),
  answer_place  VARCHAR2(255 CHAR),
  sub_date      TIMESTAMP(6),
  point         FLOAT,
  applyed       NUMBER(1),
  sub_final     NUMBER(1),
  active_id     RAW(255)
)
;
alter table D_THESIS_ANSWERS
  add primary key (ID);
alter table D_THESIS_ANSWERS
  add constraint FK_2D4OC0H1M8J02YO9K8MYMCIRW foreign key (ACTIVE_ID)
  references D_THESIS_ANSWER_ACTIVES (ID);
alter table D_THESIS_ANSWERS
  add constraint FK_4HWSYNLJDXAI827F6C8XTCXRW foreign key (ACTIVE)
  references D_THESIS_ANSWER_ACTIVES (ID);
alter table D_THESIS_ANSWERS
  add constraint FK_G2T2UOUPAXQAONJ8H9D0RIOLL foreign key (STD)
  references C_STUDENTS (ID);

prompt Creating D_THESIS_ANSWER_FILTERS...
create table D_THESIS_ANSWER_FILTERS
(
  id            RAW(255) not null,
  property_name VARCHAR2(10 CHAR),
  content       VARCHAR2(80 CHAR),
  operate       VARCHAR2(10 CHAR),
  active        RAW(255)
)
;
alter table D_THESIS_ANSWER_FILTERS
  add primary key (ID);
alter table D_THESIS_ANSWER_FILTERS
  add constraint FK_73QYT2UPTNPSERL3BSVWKKS9T foreign key (ACTIVE)
  references D_THESIS_ANSWER_ACTIVES (ID);

prompt Creating D_THESIS_CODERS...
create table D_THESIS_CODERS
(
  id         RAW(255) not null,
  name       VARCHAR2(255 CHAR),
  eng_name   VARCHAR2(255 CHAR),
  class_name VARCHAR2(255 CHAR)
)
;
alter table D_THESIS_CODERS
  add primary key (ID);

prompt Creating D_THESIS_DOCUMENTS...
create table D_THESIS_DOCUMENTS
(
  id          NUMBER(19) not null,
  accessory   NUMBER(1) not null,
  file_name   VARCHAR2(255 CHAR) not null,
  title       VARCHAR2(255 CHAR) not null,
  upload_date TIMESTAMP(6) not null,
  upload_user RAW(255) not null
)
;
alter table D_THESIS_DOCUMENTS
  add primary key (ID);

prompt Creating D_THESIS_NOTICES...
create table D_THESIS_NOTICES
(
  id           NUMBER(19) not null,
  content      VARCHAR2(2000 CHAR) not null,
  enabled      NUMBER(1) not null,
  publish_date TIMESTAMP(6) not null,
  title        VARCHAR2(255 CHAR) not null
)
;
alter table D_THESIS_NOTICES
  add primary key (ID);

prompt Creating D_THESIS_DOCUMENT_NOTICES...
create table D_THESIS_DOCUMENT_NOTICES
(
  document_id NUMBER(19) not null,
  notice_id   NUMBER(19) not null
)
;
alter table D_THESIS_DOCUMENT_NOTICES
  add primary key (DOCUMENT_ID, NOTICE_ID);
alter table D_THESIS_DOCUMENT_NOTICES
  add constraint FK_4XYAWUJJFRBQKQLAMABTE9ROF foreign key (NOTICE_ID)
  references D_THESIS_NOTICES (ID);
alter table D_THESIS_DOCUMENT_NOTICES
  add constraint FK_FMNQAR559N6SF1Q812U7XKGRT foreign key (DOCUMENT_ID)
  references D_THESIS_DOCUMENTS (ID);

prompt Creating D_THESIS_DOCUMENT_TACHES...
create table D_THESIS_DOCUMENT_TACHES
(
  id             NUMBER(19) not null,
  active_id      NUMBER(19) not null,
  active_type_id RAW(255) not null,
  document_id    NUMBER(19) not null
)
;
alter table D_THESIS_DOCUMENT_TACHES
  add primary key (ID);
alter table D_THESIS_DOCUMENT_TACHES
  add constraint FK_4SGRM4BP6UJGKUJ1UDICNTERA foreign key (ACTIVE_TYPE_ID)
  references D_THESIS_ACTIVE_TYPES (ID);
alter table D_THESIS_DOCUMENT_TACHES
  add constraint FK_9Y9PG7IMBYR5LTNM5581MXT3R foreign key (DOCUMENT_ID)
  references D_THESIS_DOCUMENTS (ID);

prompt Creating D_THESIS_NOTICES_DOCUMENTS...
create table D_THESIS_NOTICES_DOCUMENTS
(
  thesis_notice_bean_id NUMBER(19) not null,
  thesis_document_id    NUMBER(19) not null
)
;
alter table D_THESIS_NOTICES_DOCUMENTS
  add primary key (THESIS_NOTICE_BEAN_ID, THESIS_DOCUMENT_ID);
alter table D_THESIS_NOTICES_DOCUMENTS
  add constraint FK_29R0OMSUGG655QDP9BFANU0EX foreign key (THESIS_DOCUMENT_ID)
  references D_THESIS_DOCUMENTS (ID);
alter table D_THESIS_NOTICES_DOCUMENTS
  add constraint FK_G8YKP44R5P1Q3KN2363HLII10 foreign key (THESIS_NOTICE_BEAN_ID)
  references D_THESIS_NOTICES (ID);

prompt Creating D_THESIS_NOTICE_DEPARTS...
create table D_THESIS_NOTICE_DEPARTS
(
  notice_id NUMBER(19) not null,
  depart_id NUMBER(10) not null
)
;
alter table D_THESIS_NOTICE_DEPARTS
  add primary key (NOTICE_ID, DEPART_ID);
alter table D_THESIS_NOTICE_DEPARTS
  add constraint FK_BCST0F6VGWH36P2ABF3VX3J3T foreign key (NOTICE_ID)
  references D_THESIS_NOTICES (ID);
alter table D_THESIS_NOTICE_DEPARTS
  add constraint FK_L9PC8FDWGCSIT7HXUQA4DYFX7 foreign key (DEPART_ID)
  references C_DEPARTMENTS (ID);

prompt Creating D_THESIS_PRE_ANS_ACTIVES...
create table D_THESIS_PRE_ANS_ACTIVES
(
  id                RAW(255) not null,
  name              VARCHAR2(255 CHAR),
  active_type       RAW(255),
  start_date        TIMESTAMP(6),
  end_date          TIMESTAMP(6),
  effected          NUMBER(1),
  tutor_audited     NUMBER(1),
  remark            VARCHAR2(800 CHAR),
  allow_apply_count NUMBER(10),
  process           NUMBER(19)
)
;
alter table D_THESIS_PRE_ANS_ACTIVES
  add primary key (ID);
alter table D_THESIS_PRE_ANS_ACTIVES
  add constraint FK_EP80EV095QADT2FINQB2N8XFJ foreign key (PROCESS)
  references D_THESIS_PROCESSES (ID);
alter table D_THESIS_PRE_ANS_ACTIVES
  add constraint FK_NH4W3E2P97JG3CNVTQ86PX2BR foreign key (ACTIVE_TYPE)
  references D_THESIS_ACTIVE_TYPES (ID);

prompt Creating D_THESIS_PRE_ANSWERS...
create table D_THESIS_PRE_ANSWERS
(
  id              RAW(255) not null,
  std             NUMBER(19),
  title           VARCHAR2(255 CHAR),
  apply_count     NUMBER(10),
  tutor_audited   NUMBER(10),
  overed          NUMBER(1),
  passed          NUMBER(1),
  file_name       VARCHAR2(255 CHAR),
  added           NUMBER(1),
  point           FLOAT,
  active          RAW(255),
  meeting_date    TIMESTAMP(6),
  meeting_place   VARCHAR2(255 CHAR),
  expert_comments VARCHAR2(900 CHAR),
  finish_date     TIMESTAMP(6),
  apply_date      TIMESTAMP(6),
  sub_final       NUMBER(1),
  active_id       RAW(255)
)
;
alter table D_THESIS_PRE_ANSWERS
  add primary key (ID);
alter table D_THESIS_PRE_ANSWERS
  add constraint FK_290VKNQBCDSCN2TB1XLDL0NMJ foreign key (ACTIVE)
  references D_THESIS_PRE_ANS_ACTIVES (ID);
alter table D_THESIS_PRE_ANSWERS
  add constraint FK_LR7RQCE4EEBW6ABAN3H5D2413 foreign key (STD)
  references C_STUDENTS (ID);
alter table D_THESIS_PRE_ANSWERS
  add constraint FK_NSAEA3YW5TEW9DKYVF939JGFY foreign key (ACTIVE_ID)
  references D_THESIS_PRE_ANS_ACTIVES (ID);

prompt Creating D_THESIS_PRE_ANS_FILTERS...
create table D_THESIS_PRE_ANS_FILTERS
(
  id            RAW(255) not null,
  property_name VARCHAR2(10 CHAR),
  content       VARCHAR2(80 CHAR),
  operate       VARCHAR2(10 CHAR),
  active        RAW(255)
)
;
alter table D_THESIS_PRE_ANS_FILTERS
  add primary key (ID);
alter table D_THESIS_PRE_ANS_FILTERS
  add constraint FK_RY266FPEH3082GLCRHCY5UXOO foreign key (ACTIVE)
  references D_THESIS_PRE_ANS_ACTIVES (ID);

prompt Creating D_THESIS_PROCESS_ACTIVETYPE...
create table D_THESIS_PROCESS_ACTIVETYPE
(
  process_id    NUMBER(19) not null,
  activetype_id RAW(255) not null,
  xl            NUMBER(10) not null
)
;
alter table D_THESIS_PROCESS_ACTIVETYPE
  add primary key (PROCESS_ID, XL);
alter table D_THESIS_PROCESS_ACTIVETYPE
  add constraint FK_K3792O6S1QGY1I3QAEIDOOA0V foreign key (ACTIVETYPE_ID)
  references D_THESIS_ACTIVE_TYPES (ID);
alter table D_THESIS_PROCESS_ACTIVETYPE
  add constraint FK_R9ARNURXVPEG20RWP14T0BVEO foreign key (PROCESS_ID)
  references D_THESIS_PROCESSES (ID);

prompt Creating D_THESIS_PROCESS_STDS...
create table D_THESIS_PROCESS_STDS
(
  process_id NUMBER(19) not null,
  student_id NUMBER(19) not null
)
;
alter table D_THESIS_PROCESS_STDS
  add primary key (PROCESS_ID, STUDENT_ID);
alter table D_THESIS_PROCESS_STDS
  add constraint FK_3QWAXS70CHLKGYN90VFJ4WFQC foreign key (STUDENT_ID)
  references C_STUDENTS (ID);
alter table D_THESIS_PROCESS_STDS
  add constraint FK_L95I6HHJ4RHXGT98CD69P2SUH foreign key (PROCESS_ID)
  references D_THESIS_PROCESSES (ID);

prompt Creating D_THESIS_SH_ANNOTATES...
create table D_THESIS_SH_ANNOTATES
(
  id          RAW(255) not null,
  thesis_seq  VARCHAR2(32 CHAR),
  title       VARCHAR2(200 CHAR),
  major       NUMBER(10),
  point       FLOAT,
  familiarity VARCHAR2(255 CHAR),
  teacher     RAW(255)
)
;
alter table D_THESIS_SH_ANNOTATES
  add primary key (ID);
alter table D_THESIS_SH_ANNOTATES
  add constraint FK_CV7280VFNVVSIMNMV0QCC0Y9T foreign key (TEACHER)
  references D_THESIS_ANNOTATE_TEACHERS (ID);
alter table D_THESIS_SH_ANNOTATES
  add constraint FK_T92ROUYUTJH2FBYGB9ECQHQ55 foreign key (MAJOR)
  references C_MAJORS (ID);

prompt Creating D_THESIS_SH_EVALUATIONS...
create table D_THESIS_SH_EVALUATIONS
(
  id               RAW(255) not null,
  content          VARCHAR2(1 CHAR),
  evaluate_project RAW(255),
  annotate         RAW(255),
  annotate_id      RAW(255)
)
;
alter table D_THESIS_SH_EVALUATIONS
  add primary key (ID);
alter table D_THESIS_SH_EVALUATIONS
  add constraint FK_8WN6T9LXUCUQO0GIUTYM82BX6 foreign key (EVALUATE_PROJECT)
  references D_THESIS_EVALUATE_PROJECTS (ID);
alter table D_THESIS_SH_EVALUATIONS
  add constraint FK_DB6MCHHQIRVYMRUL0506DG09V foreign key (ANNOTATE)
  references D_THESIS_SH_ANNOTATES (ID);
alter table D_THESIS_SH_EVALUATIONS
  add constraint FK_JEYIV7V2GVF221AX5T25SJFOC foreign key (ANNOTATE_ID)
  references D_THESIS_SH_ANNOTATES (ID);

prompt Creating D_THESIS_STD_INNOVATES...
create table D_THESIS_STD_INNOVATES
(
  id          RAW(255) not null,
  content     VARCHAR2(200 CHAR),
  annotate    RAW(255),
  xh          NUMBER(10),
  annotate_id RAW(255)
)
;
alter table D_THESIS_STD_INNOVATES
  add primary key (ID);
alter table D_THESIS_STD_INNOVATES
  add constraint FK_7KO0MVFUV9MWMMTXG7QBT1U83 foreign key (ANNOTATE)
  references D_THESIS_ANNOTATES (ID);
alter table D_THESIS_STD_INNOVATES
  add constraint FK_JTXC7SQM5F2S1S86LXP50C foreign key (ANNOTATE_ID)
  references D_THESIS_ANNOTATES (ID);

prompt Creating D_THESIS_TEACHER_EVALS...
create table D_THESIS_TEACHER_EVALS
(
  id               RAW(255) not null,
  content          VARCHAR2(1 CHAR),
  evaluate_project RAW(255),
  book             RAW(255),
  book_id          RAW(255)
)
;
alter table D_THESIS_TEACHER_EVALS
  add primary key (ID);
alter table D_THESIS_TEACHER_EVALS
  add constraint FK_9EGCLJR9B2YEF8PSSD4HS20Q0 foreign key (BOOK)
  references D_THESIS_ANNOTATE_BOOKS (ID);
alter table D_THESIS_TEACHER_EVALS
  add constraint FK_ALVMYW1MVNFFDKP0MRLXTMM5Q foreign key (BOOK_ID)
  references D_THESIS_ANNOTATE_BOOKS (ID);
alter table D_THESIS_TEACHER_EVALS
  add constraint FK_CJPJ8O3R6TXTT49BQE58VNT6I foreign key (EVALUATE_PROJECT)
  references D_THESIS_EVALUATE_PROJECTS (ID);

prompt Creating D_THESIS_TEACHER_INNOVATES...
create table D_THESIS_TEACHER_INNOVATES
(
  id      RAW(255) not null,
  mark    VARCHAR2(2 CHAR),
  book    RAW(255),
  xh      NUMBER(10),
  book_id RAW(255)
)
;
alter table D_THESIS_TEACHER_INNOVATES
  add primary key (ID);
alter table D_THESIS_TEACHER_INNOVATES
  add constraint FK_2AG9NNLK76I3E7H6IH17AT88D foreign key (BOOK_ID)
  references D_THESIS_ANNOTATE_BOOKS (ID);
alter table D_THESIS_TEACHER_INNOVATES
  add constraint FK_DBGNPWYWYNVDNK8U5XXOUGQB6 foreign key (BOOK)
  references D_THESIS_ANNOTATE_BOOKS (ID);

prompt Creating D_THESIS_TOPIC_OPN_ACTIVES...
create table D_THESIS_TOPIC_OPN_ACTIVES
(
  id                RAW(255) not null,
  name              VARCHAR2(255 CHAR),
  active_type       RAW(255),
  start_date        TIMESTAMP(6),
  end_date          TIMESTAMP(6),
  effected          NUMBER(1),
  tutor_audited     NUMBER(1),
  remark            VARCHAR2(800 CHAR),
  allow_apply_count NUMBER(10),
  process           NUMBER(19)
)
;
alter table D_THESIS_TOPIC_OPN_ACTIVES
  add primary key (ID);
alter table D_THESIS_TOPIC_OPN_ACTIVES
  add constraint FK_4SFFQ41RFBKY2PP1NSGDAVU7G foreign key (ACTIVE_TYPE)
  references D_THESIS_ACTIVE_TYPES (ID);
alter table D_THESIS_TOPIC_OPN_ACTIVES
  add constraint FK_CHF2T5QL915CV800ASQBBAM47 foreign key (PROCESS)
  references D_THESIS_PROCESSES (ID);

prompt Creating D_THESIS_TOPIC_ORIGINS...
create table D_THESIS_TOPIC_ORIGINS
(
  id          RAW(255) not null,
  code        VARCHAR2(255 CHAR) not null,
  name        VARCHAR2(255 CHAR) not null,
  eng_name    VARCHAR2(255 CHAR),
  update_date TIMESTAMP(6),
  enabled     NUMBER(1)
)
;
alter table D_THESIS_TOPIC_ORIGINS
  add primary key (ID);

prompt Creating D_THESIS_TYPES...
create table D_THESIS_TYPES
(
  id          RAW(255) not null,
  code        VARCHAR2(255 CHAR) not null,
  name        VARCHAR2(255 CHAR) not null,
  eng_name    VARCHAR2(255 CHAR),
  update_date TIMESTAMP(6),
  enabled     NUMBER(1)
)
;
alter table D_THESIS_TYPES
  add primary key (ID);

prompt Creating D_THESIS_TOPIC_OPENS...
create table D_THESIS_TOPIC_OPENS
(
  id                  RAW(255) not null,
  std                 NUMBER(19),
  title               VARCHAR2(255 CHAR),
  apply_count         NUMBER(10),
  tutor_audited       NUMBER(10),
  passed              NUMBER(1),
  overed              NUMBER(1),
  file_name           VARCHAR2(255 CHAR),
  added               NUMBER(1),
  point               FLOAT,
  active              RAW(255),
  key_words           VARCHAR2(2000 CHAR),
  title_origin        RAW(255),
  project_title_name  VARCHAR2(200 CHAR),
  titile_level        VARCHAR2(200 CHAR),
  title_type          RAW(255),
  meeting_date        TIMESTAMP(6),
  meeting_place       VARCHAR2(255 CHAR),
  situation           VARCHAR2(3000 CHAR),
  reference           VARCHAR2(3000 CHAR),
  theoretical_value   VARCHAR2(3000 CHAR),
  research_status     VARCHAR2(3000 CHAR),
  ideas_method        VARCHAR2(3000 CHAR),
  innovation          VARCHAR2(3000 CHAR),
  expect_result       VARCHAR2(3000 CHAR),
  content_range       VARCHAR2(3000 CHAR),
  approve_unit        VARCHAR2(200 CHAR),
  funds_origin        VARCHAR2(200 CHAR),
  submit_date         TIMESTAMP(6),
  words_count         FLOAT,
  finish_date         TIMESTAMP(6),
  save_or_sub         NUMBER(10),
  sub_final           NUMBER(1),
  final_tutor_audited NUMBER(10),
  expert_comments     VARCHAR2(1000 CHAR),
  active_id           RAW(255)
)
;
alter table D_THESIS_TOPIC_OPENS
  add primary key (ID);
alter table D_THESIS_TOPIC_OPENS
  add constraint FK_1MQBL2LW3K70JBUC3PPF0MLRT foreign key (STD)
  references C_STUDENTS (ID);
alter table D_THESIS_TOPIC_OPENS
  add constraint FK_25N65Y0HJRE03OULE4HIUH90P foreign key (TITLE_ORIGIN)
  references D_THESIS_TOPIC_ORIGINS (ID);
alter table D_THESIS_TOPIC_OPENS
  add constraint FK_8REGGHLJ3KPJBFUFFT2P4CI9R foreign key (ACTIVE_ID)
  references D_THESIS_TOPIC_OPN_ACTIVES (ID);
alter table D_THESIS_TOPIC_OPENS
  add constraint FK_D282IOYYDAIPWX7GX2SFURXQ9 foreign key (TITLE_TYPE)
  references D_THESIS_TYPES (ID);
alter table D_THESIS_TOPIC_OPENS
  add constraint FK_I2LLQO690Q33EP4G2E7XUD6FQ foreign key (ACTIVE)
  references D_THESIS_TOPIC_OPN_ACTIVES (ID);

prompt Creating D_THESIS_TOPIC_OPN_FILTERS...
create table D_THESIS_TOPIC_OPN_FILTERS
(
  id            RAW(255) not null,
  property_name VARCHAR2(10 CHAR),
  content       VARCHAR2(80 CHAR),
  operate       VARCHAR2(10 CHAR),
  active        RAW(255)
)
;
alter table D_THESIS_TOPIC_OPN_FILTERS
  add primary key (ID);
alter table D_THESIS_TOPIC_OPN_FILTERS
  add constraint FK_O1BMKO4YG2I8XF64X9SR41G5F foreign key (ACTIVE)
  references D_THESIS_TOPIC_OPN_ACTIVES (ID);

prompt Creating D_THESIS_UG_ACTIVES...
create table D_THESIS_UG_ACTIVES
(
  id                RAW(255) not null,
  name              VARCHAR2(255 CHAR),
  active_type       RAW(255),
  start_date        TIMESTAMP(6),
  end_date          TIMESTAMP(6),
  effected          NUMBER(1),
  tutor_audited     NUMBER(1),
  remark            VARCHAR2(800 CHAR),
  allow_apply_count NUMBER(10),
  process           NUMBER(19)
)
;
alter table D_THESIS_UG_ACTIVES
  add primary key (ID);
alter table D_THESIS_UG_ACTIVES
  add constraint FK_479ON5646JE4SYN46Q65M0J7B foreign key (PROCESS)
  references D_THESIS_PROCESSES (ID);
alter table D_THESIS_UG_ACTIVES
  add constraint FK_SU9GFD27GK5MPKV6DWF979D6V foreign key (ACTIVE_TYPE)
  references D_THESIS_ACTIVE_TYPES (ID);

prompt Creating D_THESIS_UG_FILTERS...
create table D_THESIS_UG_FILTERS
(
  id            RAW(255) not null,
  property_name VARCHAR2(10 CHAR),
  content       VARCHAR2(80 CHAR),
  operate       VARCHAR2(10 CHAR),
  active        RAW(255)
)
;
alter table D_THESIS_UG_FILTERS
  add primary key (ID);
alter table D_THESIS_UG_FILTERS
  add constraint FK_GJE9WKB5ABS53SXD8SF3MQYMR foreign key (ACTIVE)
  references D_THESIS_UG_ACTIVES (ID);

prompt Creating D_THESIS_UNDERGRADUATES...
create table D_THESIS_UNDERGRADUATES
(
  id            RAW(255) not null,
  std           NUMBER(19),
  title         VARCHAR2(255 CHAR),
  apply_count   NUMBER(10),
  tutor_audited NUMBER(10),
  passed        NUMBER(1),
  overed        NUMBER(1),
  active        RAW(255),
  tutor         NUMBER(19),
  file_name     VARCHAR2(200 CHAR),
  point         FLOAT,
  remark        VARCHAR2(900 CHAR),
  active_id     RAW(255)
)
;
alter table D_THESIS_UNDERGRADUATES
  add primary key (ID);
alter table D_THESIS_UNDERGRADUATES
  add constraint FK_5NO0Q4MN980OJDCE41XQ0R4O1 foreign key (ACTIVE_ID)
  references D_THESIS_UG_ACTIVES (ID);
alter table D_THESIS_UNDERGRADUATES
  add constraint FK_EL2UJ8TEWD89IIED2DIKO88U3 foreign key (TUTOR)
  references C_TEACHERS (ID);
alter table D_THESIS_UNDERGRADUATES
  add constraint FK_ES2JRAA6LRITTHMH7UJFJSK8M foreign key (STD)
  references C_STUDENTS (ID);
alter table D_THESIS_UNDERGRADUATES
  add constraint FK_Q3SET7FAMNHYUA40IMFG913V0 foreign key (ACTIVE)
  references D_THESIS_UG_ACTIVES (ID);

prompt Creating HB_PAY_STATES...
create table HB_PAY_STATES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6),
  abbreviation VARCHAR2(255 CHAR),
  remark       VARCHAR2(255 CHAR)
)
;
comment on table HB_PAY_STATES
  is '支付状态';
comment on column HB_PAY_STATES.id
  is '非业务主键';
comment on column HB_PAY_STATES.code
  is '代码';
comment on column HB_PAY_STATES.created_at
  is '创建时间';
comment on column HB_PAY_STATES.effective_at
  is '生效时间';
comment on column HB_PAY_STATES.eng_name
  is '英文名称';
comment on column HB_PAY_STATES.invalid_at
  is '失效时间';
comment on column HB_PAY_STATES.name
  is '名称';
comment on column HB_PAY_STATES.updated_at
  is '修改时间';
comment on column HB_PAY_STATES.abbreviation
  is '简称';
comment on column HB_PAY_STATES.remark
  is '备注';
alter table HB_PAY_STATES
  add primary key (ID);
alter table HB_PAY_STATES
  add constraint UK_53CTDW0U8FM24ETLXDDJTBWKD unique (CODE);

prompt Creating XB_FEE_TYPES...
create table XB_FEE_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table XB_FEE_TYPES
  is '收费项目';
comment on column XB_FEE_TYPES.id
  is '非业务主键';
comment on column XB_FEE_TYPES.code
  is '代码';
comment on column XB_FEE_TYPES.created_at
  is '创建时间';
comment on column XB_FEE_TYPES.effective_at
  is '生效时间';
comment on column XB_FEE_TYPES.eng_name
  is '英文名称';
comment on column XB_FEE_TYPES.invalid_at
  is '失效时间';
comment on column XB_FEE_TYPES.name
  is '名称';
comment on column XB_FEE_TYPES.updated_at
  is '修改时间';
alter table XB_FEE_TYPES
  add primary key (ID);
alter table XB_FEE_TYPES
  add constraint UK_9QV7GABQ66TJ2F4B5X6518MVG unique (CODE);

prompt Creating F_BILLS...
create table F_BILLS
(
  id           NUMBER(19) not null,
  created_at   TIMESTAMP(6),
  updated_at   TIMESTAMP(6),
  amount       NUMBER(10),
  begin_pay_at TIMESTAMP(6),
  code         VARCHAR2(32 CHAR) not null,
  creator      VARCHAR2(255 CHAR) not null,
  end_pay_at   TIMESTAMP(6),
  exempt       NUMBER(10),
  fullname     VARCHAR2(255 CHAR) not null,
  paid         NUMBER(10),
  remark       VARCHAR2(255 CHAR),
  username     VARCHAR2(255 CHAR) not null,
  fee_type_id  NUMBER(10) not null,
  semester_id  NUMBER(10) not null,
  state_id     NUMBER(10) not null
)
;
comment on table F_BILLS
  is '账单';
comment on column F_BILLS.id
  is '非业务主键';
comment on column F_BILLS.created_at
  is '创建时间';
comment on column F_BILLS.updated_at
  is '更新时间';
comment on column F_BILLS.amount
  is '应付金额';
comment on column F_BILLS.begin_pay_at
  is '支付起始时间';
comment on column F_BILLS.code
  is '账单流水号码';
comment on column F_BILLS.creator
  is '创建用户';
comment on column F_BILLS.end_pay_at
  is '支付截止时间';
comment on column F_BILLS.exempt
  is '减免';
comment on column F_BILLS.fullname
  is '账单用户姓名';
comment on column F_BILLS.paid
  is '已付金额';
comment on column F_BILLS.remark
  is '备注';
comment on column F_BILLS.username
  is '账单用户帐号';
comment on column F_BILLS.fee_type_id
  is '收费项目 ID ###引用表名是XB_FEE_TYPES### ';
comment on column F_BILLS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
comment on column F_BILLS.state_id
  is '支付状态 ID ###引用表名是HB_PAY_STATES### ';
alter table F_BILLS
  add primary key (ID);
alter table F_BILLS
  add constraint FK_2NGLDD3RMBK67GSVBDD277JG foreign key (STATE_ID)
  references HB_PAY_STATES (ID);
alter table F_BILLS
  add constraint FK_7Y3ELVBKHOCUITC7LBO1O9GVN foreign key (FEE_TYPE_ID)
  references XB_FEE_TYPES (ID);
alter table F_BILLS
  add constraint FK_NBPG4D67AV8VNYBDD5MNFI40J foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);

prompt Creating F_BILL_LOGS...
create table F_BILL_LOGS
(
  id          NUMBER(19) not null,
  amount      NUMBER(10),
  bill_code   VARCHAR2(255 CHAR) not null,
  created_at  TIMESTAMP(6) not null,
  creator     VARCHAR2(255 CHAR) not null,
  log_type    VARCHAR2(255 CHAR) not null,
  paid        NUMBER(10),
  remark      VARCHAR2(4000 CHAR),
  remote_addr VARCHAR2(255 CHAR) not null,
  username    VARCHAR2(255 CHAR) not null,
  fee_type_id NUMBER(10) not null,
  semester_id NUMBER(10) not null,
  state_id    NUMBER(10) not null
)
;
comment on table F_BILL_LOGS
  is '账单日志';
comment on column F_BILL_LOGS.id
  is '非业务主键';
comment on column F_BILL_LOGS.amount
  is '应付金额';
comment on column F_BILL_LOGS.bill_code
  is '账单号';
comment on column F_BILL_LOGS.created_at
  is '创建时间';
comment on column F_BILL_LOGS.creator
  is '创建者';
comment on column F_BILL_LOGS.log_type
  is '订单行为状态';
comment on column F_BILL_LOGS.paid
  is '已付金额';
comment on column F_BILL_LOGS.remark
  is '备注';
comment on column F_BILL_LOGS.remote_addr
  is '创建地址';
comment on column F_BILL_LOGS.username
  is '账单用户帐号';
comment on column F_BILL_LOGS.fee_type_id
  is '收费项目 ID ###引用表名是XB_FEE_TYPES### ';
comment on column F_BILL_LOGS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
comment on column F_BILL_LOGS.state_id
  is '支付状态 ID ###引用表名是HB_PAY_STATES### ';
alter table F_BILL_LOGS
  add primary key (ID);
alter table F_BILL_LOGS
  add constraint FK_AU049GYCB4XGU0YUYD8C0HDUL foreign key (FEE_TYPE_ID)
  references XB_FEE_TYPES (ID);
alter table F_BILL_LOGS
  add constraint FK_GGQ7AKGU5A7LWKPSGMMI6DTB9 foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table F_BILL_LOGS
  add constraint FK_MMFMVNVQ3HQWACFKHHR2V2PL4 foreign key (STATE_ID)
  references HB_PAY_STATES (ID);

prompt Creating F_CHECK_FEE_TYPES...
create table F_CHECK_FEE_TYPES
(
  id          NUMBER(19) not null,
  fee_type_id NUMBER(10)
)
;
comment on table F_CHECK_FEE_TYPES
  is '检测收费类型';
comment on column F_CHECK_FEE_TYPES.id
  is '非业务主键';
comment on column F_CHECK_FEE_TYPES.fee_type_id
  is '费用类型 ID ###引用表名是XB_FEE_TYPES### ';
alter table F_CHECK_FEE_TYPES
  add primary key (ID);
alter table F_CHECK_FEE_TYPES
  add constraint FK_TMY9K631O8DM8R00GWF2ILUPQ foreign key (FEE_TYPE_ID)
  references XB_FEE_TYPES (ID);

prompt Creating HB_PAY_TYPES...
create table HB_PAY_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6),
  abbreviation VARCHAR2(255 CHAR),
  remark       VARCHAR2(255 CHAR)
)
;
comment on table HB_PAY_TYPES
  is '支付方式';
comment on column HB_PAY_TYPES.id
  is '非业务主键';
comment on column HB_PAY_TYPES.code
  is '代码';
comment on column HB_PAY_TYPES.created_at
  is '创建时间';
comment on column HB_PAY_TYPES.effective_at
  is '生效时间';
comment on column HB_PAY_TYPES.eng_name
  is '英文名称';
comment on column HB_PAY_TYPES.invalid_at
  is '失效时间';
comment on column HB_PAY_TYPES.name
  is '名称';
comment on column HB_PAY_TYPES.updated_at
  is '修改时间';
comment on column HB_PAY_TYPES.abbreviation
  is '简称';
comment on column HB_PAY_TYPES.remark
  is '备注';
alter table HB_PAY_TYPES
  add primary key (ID);
alter table HB_PAY_TYPES
  add constraint UK_7T73M63E97DSSIP75XLP52LUI unique (CODE);

prompt Creating F_PAYS...
create table F_PAYS
(
  id          NUMBER(19) not null,
  create_at   TIMESTAMP(6) not null,
  creator     VARCHAR2(255 CHAR) not null,
  invoice     VARCHAR2(255 CHAR),
  paid        NUMBER(10),
  pay_at      TIMESTAMP(6),
  remark      VARCHAR2(255 CHAR),
  bill_id     NUMBER(19) not null,
  pay_type_id NUMBER(10)
)
;
comment on table F_PAYS
  is '支付信息';
comment on column F_PAYS.id
  is '非业务主键';
comment on column F_PAYS.create_at
  is '创建时间';
comment on column F_PAYS.creator
  is '操作用户';
comment on column F_PAYS.invoice
  is '发票信息';
comment on column F_PAYS.paid
  is '已付金额';
comment on column F_PAYS.pay_at
  is '支付时间';
comment on column F_PAYS.remark
  is '备注';
comment on column F_PAYS.bill_id
  is '账单信息 ID ###引用表名是F_BILLS### ';
comment on column F_PAYS.pay_type_id
  is '支付方式 ID ###引用表名是HB_PAY_TYPES### ';
alter table F_PAYS
  add primary key (ID);
alter table F_PAYS
  add constraint FK_3BC16GM5J9JMBRKXRWTMKPIU1 foreign key (BILL_ID)
  references F_BILLS (ID);
alter table F_PAYS
  add constraint FK_636VMLKW6RJO3KH2VQKL9G9HG foreign key (PAY_TYPE_ID)
  references HB_PAY_TYPES (ID);

prompt Creating F_TUITIONS...
create table F_TUITIONS
(
  id          NUMBER(19) not null,
  completed   NUMBER(1) not null,
  fee         FLOAT,
  remark      VARCHAR2(255 CHAR),
  semester_id NUMBER(10) not null,
  std_id      NUMBER(19) not null
)
;
comment on table F_TUITIONS
  is '学费';
comment on column F_TUITIONS.id
  is '非业务主键';
comment on column F_TUITIONS.completed
  is '是否交费完成';
comment on column F_TUITIONS.fee
  is '学费';
comment on column F_TUITIONS.remark
  is '备注';
comment on column F_TUITIONS.semester_id
  is '教学日历 ID ###引用表名是C_SEMESTERS### ';
comment on column F_TUITIONS.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table F_TUITIONS
  add primary key (ID);
alter table F_TUITIONS
  add constraint UK_K35R4W3WSFE0DN8KS2EPH7FM1 unique (SEMESTER_ID, STD_ID);
alter table F_TUITIONS
  add constraint FK_3KYBSIHKT99Y7FBK1KY2PR9T8 foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table F_TUITIONS
  add constraint FK_9UI6TMO50LFTV6U88UP32P73H foreign key (STD_ID)
  references C_STUDENTS (ID);

prompt Creating GB_LANGUAGES...
create table GB_LANGUAGES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table GB_LANGUAGES
  is '语种代码';
comment on column GB_LANGUAGES.id
  is '非业务主键';
comment on column GB_LANGUAGES.code
  is '代码';
comment on column GB_LANGUAGES.created_at
  is '创建时间';
comment on column GB_LANGUAGES.effective_at
  is '生效时间';
comment on column GB_LANGUAGES.eng_name
  is '英文名称';
comment on column GB_LANGUAGES.invalid_at
  is '失效时间';
comment on column GB_LANGUAGES.name
  is '名称';
comment on column GB_LANGUAGES.updated_at
  is '修改时间';
alter table GB_LANGUAGES
  add primary key (ID);
alter table GB_LANGUAGES
  add constraint UK_KR9U3DI9MHVTO7OPXTTHYS9N1 unique (CODE);

prompt Creating GB_SOCIAL_RELATIONS...
create table GB_SOCIAL_RELATIONS
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table GB_SOCIAL_RELATIONS
  is '社会关系';
comment on column GB_SOCIAL_RELATIONS.id
  is '非业务主键';
comment on column GB_SOCIAL_RELATIONS.code
  is '代码';
comment on column GB_SOCIAL_RELATIONS.created_at
  is '创建时间';
comment on column GB_SOCIAL_RELATIONS.effective_at
  is '生效时间';
comment on column GB_SOCIAL_RELATIONS.eng_name
  is '英文名称';
comment on column GB_SOCIAL_RELATIONS.invalid_at
  is '失效时间';
comment on column GB_SOCIAL_RELATIONS.name
  is '名称';
comment on column GB_SOCIAL_RELATIONS.updated_at
  is '修改时间';
alter table GB_SOCIAL_RELATIONS
  add primary key (ID);
alter table GB_SOCIAL_RELATIONS
  add constraint UK_49CSTS36S5O25PMNR2NQBQIJB unique (CODE);

prompt Creating HB_ADMISSION_TYPES...
create table HB_ADMISSION_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_ADMISSION_TYPES
  is '录取类别';
comment on column HB_ADMISSION_TYPES.id
  is '非业务主键';
comment on column HB_ADMISSION_TYPES.code
  is '代码';
comment on column HB_ADMISSION_TYPES.created_at
  is '创建时间';
comment on column HB_ADMISSION_TYPES.effective_at
  is '生效时间';
comment on column HB_ADMISSION_TYPES.eng_name
  is '英文名称';
comment on column HB_ADMISSION_TYPES.invalid_at
  is '失效时间';
comment on column HB_ADMISSION_TYPES.name
  is '名称';
comment on column HB_ADMISSION_TYPES.updated_at
  is '修改时间';
alter table HB_ADMISSION_TYPES
  add primary key (ID);
alter table HB_ADMISSION_TYPES
  add constraint UK_T9I8DBS1BVOOEK77XM42RPOV5 unique (CODE);

prompt Creating HB_BOOK_AWARD_TYPES...
create table HB_BOOK_AWARD_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_BOOK_AWARD_TYPES
  is '图书获奖类型';
comment on column HB_BOOK_AWARD_TYPES.id
  is '非业务主键';
comment on column HB_BOOK_AWARD_TYPES.code
  is '代码';
comment on column HB_BOOK_AWARD_TYPES.created_at
  is '创建时间';
comment on column HB_BOOK_AWARD_TYPES.effective_at
  is '生效时间';
comment on column HB_BOOK_AWARD_TYPES.eng_name
  is '英文名称';
comment on column HB_BOOK_AWARD_TYPES.invalid_at
  is '失效时间';
comment on column HB_BOOK_AWARD_TYPES.name
  is '名称';
comment on column HB_BOOK_AWARD_TYPES.updated_at
  is '修改时间';
alter table HB_BOOK_AWARD_TYPES
  add primary key (ID);
alter table HB_BOOK_AWARD_TYPES
  add constraint UK_EU01P7NII3KY2YQSGCQ3CGU30 unique (CODE);

prompt Creating HB_COURSE_TAKE_TYPES...
create table HB_COURSE_TAKE_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6),
  exam         NUMBER(1) not null,
  retake       NUMBER(1) not null
)
;
comment on table HB_COURSE_TAKE_TYPES
  is '修课类别';
comment on column HB_COURSE_TAKE_TYPES.id
  is '非业务主键';
comment on column HB_COURSE_TAKE_TYPES.code
  is '代码';
comment on column HB_COURSE_TAKE_TYPES.created_at
  is '创建时间';
comment on column HB_COURSE_TAKE_TYPES.effective_at
  is '生效时间';
comment on column HB_COURSE_TAKE_TYPES.eng_name
  is '英文名称';
comment on column HB_COURSE_TAKE_TYPES.invalid_at
  is '失效时间';
comment on column HB_COURSE_TAKE_TYPES.name
  is '名称';
comment on column HB_COURSE_TAKE_TYPES.updated_at
  is '修改时间';
comment on column HB_COURSE_TAKE_TYPES.exam
  is '是否考核';
comment on column HB_COURSE_TAKE_TYPES.retake
  is '是否重修';
alter table HB_COURSE_TAKE_TYPES
  add primary key (ID);
alter table HB_COURSE_TAKE_TYPES
  add constraint UK_5HPXFNTRIYOPIDQS1Y6UDJ6ED unique (CODE);

prompt Creating HB_EDUCATION_MODES...
create table HB_EDUCATION_MODES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_EDUCATION_MODES
  is '培养方式';
comment on column HB_EDUCATION_MODES.id
  is '非业务主键';
comment on column HB_EDUCATION_MODES.code
  is '代码';
comment on column HB_EDUCATION_MODES.created_at
  is '创建时间';
comment on column HB_EDUCATION_MODES.effective_at
  is '生效时间';
comment on column HB_EDUCATION_MODES.eng_name
  is '英文名称';
comment on column HB_EDUCATION_MODES.invalid_at
  is '失效时间';
comment on column HB_EDUCATION_MODES.name
  is '名称';
comment on column HB_EDUCATION_MODES.updated_at
  is '修改时间';
alter table HB_EDUCATION_MODES
  add primary key (ID);
alter table HB_EDUCATION_MODES
  add constraint UK_SOKOGTN1HF8MVH0S7MM9897N unique (CODE);

prompt Creating HB_ELECTION_MODES...
create table HB_ELECTION_MODES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_ELECTION_MODES
  is '选课方式';
comment on column HB_ELECTION_MODES.id
  is '非业务主键';
comment on column HB_ELECTION_MODES.code
  is '代码';
comment on column HB_ELECTION_MODES.created_at
  is '创建时间';
comment on column HB_ELECTION_MODES.effective_at
  is '生效时间';
comment on column HB_ELECTION_MODES.eng_name
  is '英文名称';
comment on column HB_ELECTION_MODES.invalid_at
  is '失效时间';
comment on column HB_ELECTION_MODES.name
  is '名称';
comment on column HB_ELECTION_MODES.updated_at
  is '修改时间';
alter table HB_ELECTION_MODES
  add primary key (ID);
alter table HB_ELECTION_MODES
  add constraint UK_T5PDCWEQA4EQB8QCP10TMGMD4 unique (CODE);

prompt Creating HB_ENROLL_MODES...
create table HB_ENROLL_MODES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_ENROLL_MODES
  is '入学方式';
comment on column HB_ENROLL_MODES.id
  is '非业务主键';
comment on column HB_ENROLL_MODES.code
  is '代码';
comment on column HB_ENROLL_MODES.created_at
  is '创建时间';
comment on column HB_ENROLL_MODES.effective_at
  is '生效时间';
comment on column HB_ENROLL_MODES.eng_name
  is '英文名称';
comment on column HB_ENROLL_MODES.invalid_at
  is '失效时间';
comment on column HB_ENROLL_MODES.name
  is '名称';
comment on column HB_ENROLL_MODES.updated_at
  is '修改时间';
alter table HB_ENROLL_MODES
  add primary key (ID);
alter table HB_ENROLL_MODES
  add constraint UK_S09V6X5BRCW8NDOU4IK9TETO8 unique (CODE);

prompt Creating HB_EXAMINEE_TYPES...
create table HB_EXAMINEE_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_EXAMINEE_TYPES
  is '生源类别';
comment on column HB_EXAMINEE_TYPES.id
  is '非业务主键';
comment on column HB_EXAMINEE_TYPES.code
  is '代码';
comment on column HB_EXAMINEE_TYPES.created_at
  is '创建时间';
comment on column HB_EXAMINEE_TYPES.effective_at
  is '生效时间';
comment on column HB_EXAMINEE_TYPES.eng_name
  is '英文名称';
comment on column HB_EXAMINEE_TYPES.invalid_at
  is '失效时间';
comment on column HB_EXAMINEE_TYPES.name
  is '名称';
comment on column HB_EXAMINEE_TYPES.updated_at
  is '修改时间';
alter table HB_EXAMINEE_TYPES
  add primary key (ID);
alter table HB_EXAMINEE_TYPES
  add constraint UK_7PI3QJTE5XQMMLWIMGC0TE6VJ unique (CODE);

prompt Creating HB_EXAM_STATUSES...
create table HB_EXAM_STATUSES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6),
  attend       NUMBER(1) not null
)
;
comment on table HB_EXAM_STATUSES
  is '考试情况';
comment on column HB_EXAM_STATUSES.id
  is '非业务主键';
comment on column HB_EXAM_STATUSES.code
  is '代码';
comment on column HB_EXAM_STATUSES.created_at
  is '创建时间';
comment on column HB_EXAM_STATUSES.effective_at
  is '生效时间';
comment on column HB_EXAM_STATUSES.eng_name
  is '英文名称';
comment on column HB_EXAM_STATUSES.invalid_at
  is '失效时间';
comment on column HB_EXAM_STATUSES.name
  is '名称';
comment on column HB_EXAM_STATUSES.updated_at
  is '修改时间';
comment on column HB_EXAM_STATUSES.attend
  is '是否参加考试';
alter table HB_EXAM_STATUSES
  add primary key (ID);
alter table HB_EXAM_STATUSES
  add constraint UK_14MYM2PS9RATSJ3YWR9NLHAN6 unique (CODE);

prompt Creating HB_EXAM_TYPES...
create table HB_EXAM_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_EXAM_TYPES
  is '考试类型';
comment on column HB_EXAM_TYPES.id
  is '非业务主键';
comment on column HB_EXAM_TYPES.code
  is '代码';
comment on column HB_EXAM_TYPES.created_at
  is '创建时间';
comment on column HB_EXAM_TYPES.effective_at
  is '生效时间';
comment on column HB_EXAM_TYPES.eng_name
  is '英文名称';
comment on column HB_EXAM_TYPES.invalid_at
  is '失效时间';
comment on column HB_EXAM_TYPES.name
  is '名称';
comment on column HB_EXAM_TYPES.updated_at
  is '修改时间';
alter table HB_EXAM_TYPES
  add primary key (ID);
alter table HB_EXAM_TYPES
  add constraint UK_HTQKXOFD8NDN8KDR127PDSR3J unique (CODE);

prompt Creating HB_FAMILY_ECONOMIC_STATES...
create table HB_FAMILY_ECONOMIC_STATES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_FAMILY_ECONOMIC_STATES
  is '家庭经济状况';
comment on column HB_FAMILY_ECONOMIC_STATES.id
  is '非业务主键';
comment on column HB_FAMILY_ECONOMIC_STATES.code
  is '代码';
comment on column HB_FAMILY_ECONOMIC_STATES.created_at
  is '创建时间';
comment on column HB_FAMILY_ECONOMIC_STATES.effective_at
  is '生效时间';
comment on column HB_FAMILY_ECONOMIC_STATES.eng_name
  is '英文名称';
comment on column HB_FAMILY_ECONOMIC_STATES.invalid_at
  is '失效时间';
comment on column HB_FAMILY_ECONOMIC_STATES.name
  is '名称';
comment on column HB_FAMILY_ECONOMIC_STATES.updated_at
  is '修改时间';
alter table HB_FAMILY_ECONOMIC_STATES
  add primary key (ID);
alter table HB_FAMILY_ECONOMIC_STATES
  add constraint UK_M6SMC703YIMW70HS9A361SNJF unique (CODE);

prompt Creating HB_FEE_ORIGINS...
create table HB_FEE_ORIGINS
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_FEE_ORIGINS
  is '招生信息之费用来源';
comment on column HB_FEE_ORIGINS.id
  is '非业务主键';
comment on column HB_FEE_ORIGINS.code
  is '代码';
comment on column HB_FEE_ORIGINS.created_at
  is '创建时间';
comment on column HB_FEE_ORIGINS.effective_at
  is '生效时间';
comment on column HB_FEE_ORIGINS.eng_name
  is '英文名称';
comment on column HB_FEE_ORIGINS.invalid_at
  is '失效时间';
comment on column HB_FEE_ORIGINS.name
  is '名称';
comment on column HB_FEE_ORIGINS.updated_at
  is '修改时间';
alter table HB_FEE_ORIGINS
  add primary key (ID);
alter table HB_FEE_ORIGINS
  add constraint UK_A12UIJIIFY81B80R6TII814BV unique (CODE);

prompt Creating HB_GRADE_TYPES...
create table HB_GRADE_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6),
  short_name   VARCHAR2(255 CHAR),
  exam_type_id NUMBER(10)
)
;
comment on table HB_GRADE_TYPES
  is '成绩类型';
comment on column HB_GRADE_TYPES.id
  is '非业务主键';
comment on column HB_GRADE_TYPES.code
  is '代码';
comment on column HB_GRADE_TYPES.created_at
  is '创建时间';
comment on column HB_GRADE_TYPES.effective_at
  is '生效时间';
comment on column HB_GRADE_TYPES.eng_name
  is '英文名称';
comment on column HB_GRADE_TYPES.invalid_at
  is '失效时间';
comment on column HB_GRADE_TYPES.name
  is '名称';
comment on column HB_GRADE_TYPES.updated_at
  is '修改时间';
comment on column HB_GRADE_TYPES.short_name
  is '简名';
comment on column HB_GRADE_TYPES.exam_type_id
  is '对应的考试类型 ID ###引用表名是HB_EXAM_TYPES### ';
alter table HB_GRADE_TYPES
  add primary key (ID);
alter table HB_GRADE_TYPES
  add constraint UK_KRFF7WIYXCC3OHFLS30NXVOVK unique (CODE);
alter table HB_GRADE_TYPES
  add constraint FK_P8E77NMRNKQF448FW4OWM3W6K foreign key (EXAM_TYPE_ID)
  references HB_EXAM_TYPES (ID);

prompt Creating HB_GRADUATE_STATES...
create table HB_GRADUATE_STATES
(
  id            NUMBER(10) not null,
  code          VARCHAR2(32 CHAR) not null,
  created_at    TIMESTAMP(6),
  effective_at  TIMESTAMP(6) not null,
  eng_name      VARCHAR2(100 CHAR),
  invalid_at    TIMESTAMP(6),
  name          VARCHAR2(100 CHAR) not null,
  updated_at    TIMESTAMP(6),
  std_status_id NUMBER(10)
)
;
comment on table HB_GRADUATE_STATES
  is '毕结业结论';
comment on column HB_GRADUATE_STATES.id
  is '非业务主键';
comment on column HB_GRADUATE_STATES.code
  is '代码';
comment on column HB_GRADUATE_STATES.created_at
  is '创建时间';
comment on column HB_GRADUATE_STATES.effective_at
  is '生效时间';
comment on column HB_GRADUATE_STATES.eng_name
  is '英文名称';
comment on column HB_GRADUATE_STATES.invalid_at
  is '失效时间';
comment on column HB_GRADUATE_STATES.name
  is '名称';
comment on column HB_GRADUATE_STATES.updated_at
  is '修改时间';
comment on column HB_GRADUATE_STATES.std_status_id
  is '学籍状态 ID ###引用表名是HB_STD_STATUSES###';
alter table HB_GRADUATE_STATES
  add primary key (ID);
alter table HB_GRADUATE_STATES
  add constraint UK_6ICB878B5YLNAPODTCBQGCQ5U unique (CODE);
alter table HB_GRADUATE_STATES
  add constraint FK_N5NBYYD0CG11N0BPL03GVEBM4 foreign key (STD_STATUS_ID)
  references HB_STD_STATUSES (ID);

prompt Creating HB_HSCH_GRADE_TYPES...
create table HB_HSCH_GRADE_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_HSCH_GRADE_TYPES
  is '高考成绩类型';
comment on column HB_HSCH_GRADE_TYPES.id
  is '非业务主键';
comment on column HB_HSCH_GRADE_TYPES.code
  is '代码';
comment on column HB_HSCH_GRADE_TYPES.created_at
  is '创建时间';
comment on column HB_HSCH_GRADE_TYPES.effective_at
  is '生效时间';
comment on column HB_HSCH_GRADE_TYPES.eng_name
  is '英文名称';
comment on column HB_HSCH_GRADE_TYPES.invalid_at
  is '失效时间';
comment on column HB_HSCH_GRADE_TYPES.name
  is '名称';
comment on column HB_HSCH_GRADE_TYPES.updated_at
  is '修改时间';
alter table HB_HSCH_GRADE_TYPES
  add primary key (ID);
alter table HB_HSCH_GRADE_TYPES
  add constraint UK_CSJ25OWRTWQJNJ80LYARTLMK unique (CODE);

prompt Creating HB_HSKDEGREES...
create table HB_HSKDEGREES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6),
  grade        NUMBER(10)
)
;
comment on table HB_HSKDEGREES
  is '留学生HSK等级';
comment on column HB_HSKDEGREES.id
  is '非业务主键';
comment on column HB_HSKDEGREES.code
  is '代码';
comment on column HB_HSKDEGREES.created_at
  is '创建时间';
comment on column HB_HSKDEGREES.effective_at
  is '生效时间';
comment on column HB_HSKDEGREES.eng_name
  is '英文名称';
comment on column HB_HSKDEGREES.invalid_at
  is '失效时间';
comment on column HB_HSKDEGREES.name
  is '名称';
comment on column HB_HSKDEGREES.updated_at
  is '修改时间';
comment on column HB_HSKDEGREES.grade
  is '等级';
alter table HB_HSKDEGREES
  add primary key (ID);
alter table HB_HSKDEGREES
  add constraint UK_SVY9Y0HUWRV67YMPTEY8WBNI7 unique (CODE);

prompt Creating HB_OTHER_EXAM_CATEGORIES...
create table HB_OTHER_EXAM_CATEGORIES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_OTHER_EXAM_CATEGORIES
  is '校外考试类型';
comment on column HB_OTHER_EXAM_CATEGORIES.id
  is '非业务主键';
comment on column HB_OTHER_EXAM_CATEGORIES.code
  is '代码';
comment on column HB_OTHER_EXAM_CATEGORIES.created_at
  is '创建时间';
comment on column HB_OTHER_EXAM_CATEGORIES.effective_at
  is '生效时间';
comment on column HB_OTHER_EXAM_CATEGORIES.eng_name
  is '英文名称';
comment on column HB_OTHER_EXAM_CATEGORIES.invalid_at
  is '失效时间';
comment on column HB_OTHER_EXAM_CATEGORIES.name
  is '名称';
comment on column HB_OTHER_EXAM_CATEGORIES.updated_at
  is '修改时间';
alter table HB_OTHER_EXAM_CATEGORIES
  add primary key (ID);
alter table HB_OTHER_EXAM_CATEGORIES
  add constraint UK_9AQ3KJL0WKSWDNP1K5WW3KY02 unique (CODE);

prompt Creating HB_OTHER_EXAM_SUBJECTS...
create table HB_OTHER_EXAM_SUBJECTS
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6),
  category_id  NUMBER(10) not null
)
;
comment on table HB_OTHER_EXAM_SUBJECTS
  is '其他校外考试科目';
comment on column HB_OTHER_EXAM_SUBJECTS.id
  is '非业务主键';
comment on column HB_OTHER_EXAM_SUBJECTS.code
  is '代码';
comment on column HB_OTHER_EXAM_SUBJECTS.created_at
  is '创建时间';
comment on column HB_OTHER_EXAM_SUBJECTS.effective_at
  is '生效时间';
comment on column HB_OTHER_EXAM_SUBJECTS.eng_name
  is '英文名称';
comment on column HB_OTHER_EXAM_SUBJECTS.invalid_at
  is '失效时间';
comment on column HB_OTHER_EXAM_SUBJECTS.name
  is '名称';
comment on column HB_OTHER_EXAM_SUBJECTS.updated_at
  is '修改时间';
comment on column HB_OTHER_EXAM_SUBJECTS.category_id
  is '其他校外考试类型 ID ###引用表名是HB_OTHER_EXAM_CATEGORIES### ';
alter table HB_OTHER_EXAM_SUBJECTS
  add primary key (ID);
alter table HB_OTHER_EXAM_SUBJECTS
  add constraint UK_JGYC2BI8UJSHK3TN8N9FL63B5 unique (CODE);
alter table HB_OTHER_EXAM_SUBJECTS
  add constraint FK_6G00IHRJMBB3B5GNR18CUHF2E foreign key (CATEGORY_ID)
  references HB_OTHER_EXAM_CATEGORIES (ID);

prompt Creating HB_PASSPORT_TYPES...
create table HB_PASSPORT_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_PASSPORT_TYPES
  is '护照类别';
comment on column HB_PASSPORT_TYPES.id
  is '非业务主键';
comment on column HB_PASSPORT_TYPES.code
  is '代码';
comment on column HB_PASSPORT_TYPES.created_at
  is '创建时间';
comment on column HB_PASSPORT_TYPES.effective_at
  is '生效时间';
comment on column HB_PASSPORT_TYPES.eng_name
  is '英文名称';
comment on column HB_PASSPORT_TYPES.invalid_at
  is '失效时间';
comment on column HB_PASSPORT_TYPES.name
  is '名称';
comment on column HB_PASSPORT_TYPES.updated_at
  is '修改时间';
alter table HB_PASSPORT_TYPES
  add primary key (ID);
alter table HB_PASSPORT_TYPES
  add constraint UK_DYTV1MD9BQKPBAC2EXRXK3ERA unique (CODE);

prompt Creating HB_PRESS_LEVELS...
create table HB_PRESS_LEVELS
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_PRESS_LEVELS
  is '出版社级别';
comment on column HB_PRESS_LEVELS.id
  is '非业务主键';
comment on column HB_PRESS_LEVELS.code
  is '代码';
comment on column HB_PRESS_LEVELS.created_at
  is '创建时间';
comment on column HB_PRESS_LEVELS.effective_at
  is '生效时间';
comment on column HB_PRESS_LEVELS.eng_name
  is '英文名称';
comment on column HB_PRESS_LEVELS.invalid_at
  is '失效时间';
comment on column HB_PRESS_LEVELS.name
  is '名称';
comment on column HB_PRESS_LEVELS.updated_at
  is '修改时间';
alter table HB_PRESS_LEVELS
  add primary key (ID);
alter table HB_PRESS_LEVELS
  add constraint UK_6L763HPMDH892F43VNX9IS1EK unique (CODE);

prompt Creating HB_PRESSES...
create table HB_PRESSES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6),
  level_id     NUMBER(10)
)
;
comment on table HB_PRESSES
  is '出版社信息';
comment on column HB_PRESSES.id
  is '非业务主键';
comment on column HB_PRESSES.code
  is '代码';
comment on column HB_PRESSES.created_at
  is '创建时间';
comment on column HB_PRESSES.effective_at
  is '生效时间';
comment on column HB_PRESSES.eng_name
  is '英文名称';
comment on column HB_PRESSES.invalid_at
  is '失效时间';
comment on column HB_PRESSES.name
  is '名称';
comment on column HB_PRESSES.updated_at
  is '修改时间';
comment on column HB_PRESSES.level_id
  is '级别 ID ###引用表名是HB_PRESS_LEVELS### ';
alter table HB_PRESSES
  add primary key (ID);
alter table HB_PRESSES
  add constraint UK_IMQ90H3ERGT5M2AE660APD4JN unique (CODE);
alter table HB_PRESSES
  add constraint FK_6H7OLJWRY6DAFYH3LF3C5V8IN foreign key (LEVEL_ID)
  references HB_PRESS_LEVELS (ID);

prompt Creating HB_PUBLICATION_GRADES...
create table HB_PUBLICATION_GRADES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_PUBLICATION_GRADES
  is '刊物级别';
comment on column HB_PUBLICATION_GRADES.id
  is '非业务主键';
comment on column HB_PUBLICATION_GRADES.code
  is '代码';
comment on column HB_PUBLICATION_GRADES.created_at
  is '创建时间';
comment on column HB_PUBLICATION_GRADES.effective_at
  is '生效时间';
comment on column HB_PUBLICATION_GRADES.eng_name
  is '英文名称';
comment on column HB_PUBLICATION_GRADES.invalid_at
  is '失效时间';
comment on column HB_PUBLICATION_GRADES.name
  is '名称';
comment on column HB_PUBLICATION_GRADES.updated_at
  is '修改时间';
alter table HB_PUBLICATION_GRADES
  add primary key (ID);
alter table HB_PUBLICATION_GRADES
  add constraint UK_E1DVEDH3DILF8PAFX2HHF00BA unique (CODE);

prompt Creating HB_PUBLICATIONS...
create table HB_PUBLICATIONS
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6),
  grade_id     NUMBER(10)
)
;
comment on table HB_PUBLICATIONS
  is '刊物';
comment on column HB_PUBLICATIONS.id
  is '非业务主键';
comment on column HB_PUBLICATIONS.code
  is '代码';
comment on column HB_PUBLICATIONS.created_at
  is '创建时间';
comment on column HB_PUBLICATIONS.effective_at
  is '生效时间';
comment on column HB_PUBLICATIONS.eng_name
  is '英文名称';
comment on column HB_PUBLICATIONS.invalid_at
  is '失效时间';
comment on column HB_PUBLICATIONS.name
  is '名称';
comment on column HB_PUBLICATIONS.updated_at
  is '修改时间';
comment on column HB_PUBLICATIONS.grade_id
  is '级别 ID ###引用表名是HB_PUBLICATION_GRADES### ';
alter table HB_PUBLICATIONS
  add primary key (ID);
alter table HB_PUBLICATIONS
  add constraint UK_4U2VKXW979AFKB12IEIN9YWRG unique (CODE);
alter table HB_PUBLICATIONS
  add constraint FK_G1W64K1V435ILPEQ5XV99R12N foreign key (GRADE_ID)
  references HB_PUBLICATION_GRADES (ID);

prompt Creating HB_RAILWAY_STATIONS...
create table HB_RAILWAY_STATIONS
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6),
  division_id  NUMBER(10)
)
;
comment on table HB_RAILWAY_STATIONS
  is '火车站';
comment on column HB_RAILWAY_STATIONS.id
  is '非业务主键';
comment on column HB_RAILWAY_STATIONS.code
  is '代码';
comment on column HB_RAILWAY_STATIONS.created_at
  is '创建时间';
comment on column HB_RAILWAY_STATIONS.effective_at
  is '生效时间';
comment on column HB_RAILWAY_STATIONS.eng_name
  is '英文名称';
comment on column HB_RAILWAY_STATIONS.invalid_at
  is '失效时间';
comment on column HB_RAILWAY_STATIONS.name
  is '名称';
comment on column HB_RAILWAY_STATIONS.updated_at
  is '修改时间';
comment on column HB_RAILWAY_STATIONS.division_id
  is '行政区划 ID ###引用表名是GB_DIVISIONS### ';
alter table HB_RAILWAY_STATIONS
  add primary key (ID);
alter table HB_RAILWAY_STATIONS
  add constraint UK_8NGGF0WJNP8AX9ELX3PG20WJ unique (CODE);
alter table HB_RAILWAY_STATIONS
  add constraint FK_VQDOUL5VGJHPGLFV1PCVP8AD foreign key (DIVISION_ID)
  references GB_DIVISIONS (ID);

prompt Creating HB_RESIDENCES...
create table HB_RESIDENCES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_RESIDENCES
  is '户籍性质';
comment on column HB_RESIDENCES.id
  is '非业务主键';
comment on column HB_RESIDENCES.code
  is '代码';
comment on column HB_RESIDENCES.created_at
  is '创建时间';
comment on column HB_RESIDENCES.effective_at
  is '生效时间';
comment on column HB_RESIDENCES.eng_name
  is '英文名称';
comment on column HB_RESIDENCES.invalid_at
  is '失效时间';
comment on column HB_RESIDENCES.name
  is '名称';
comment on column HB_RESIDENCES.updated_at
  is '修改时间';
alter table HB_RESIDENCES
  add primary key (ID);
alter table HB_RESIDENCES
  add constraint UK_56TR4W0POH05VRLI10I446LTJ unique (CODE);

prompt Creating HB_STD_ALTER_TYPES...
create table HB_STD_ALTER_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6),
  inschool     NUMBER(1) not null,
  status_id    NUMBER(10) not null
)
;
comment on table HB_STD_ALTER_TYPES
  is '学籍变动类别';
comment on column HB_STD_ALTER_TYPES.id
  is '非业务主键';
comment on column HB_STD_ALTER_TYPES.code
  is '代码';
comment on column HB_STD_ALTER_TYPES.created_at
  is '创建时间';
comment on column HB_STD_ALTER_TYPES.effective_at
  is '生效时间';
comment on column HB_STD_ALTER_TYPES.eng_name
  is '英文名称';
comment on column HB_STD_ALTER_TYPES.invalid_at
  is '失效时间';
comment on column HB_STD_ALTER_TYPES.name
  is '名称';
comment on column HB_STD_ALTER_TYPES.updated_at
  is '修改时间';
comment on column HB_STD_ALTER_TYPES.inschool
  is '是否在校';
comment on column HB_STD_ALTER_TYPES.status_id
  is '学籍状态 ID ###引用表名是HB_STD_STATUSES### ';
alter table HB_STD_ALTER_TYPES
  add primary key (ID);
alter table HB_STD_ALTER_TYPES
  add constraint UK_GSDWMGKIKU0W6U6FQQWXJCK4S unique (CODE);
alter table HB_STD_ALTER_TYPES
  add constraint FK_L08Q9AA1H65UIUMWWPUKP5MYV foreign key (STATUS_ID)
  references HB_STD_STATUSES (ID);

prompt Creating HB_STD_ALTER_REASONS...
create table HB_STD_ALTER_REASONS
(
  id            NUMBER(10) not null,
  code          VARCHAR2(32 CHAR) not null,
  created_at    TIMESTAMP(6),
  effective_at  TIMESTAMP(6) not null,
  eng_name      VARCHAR2(100 CHAR),
  invalid_at    TIMESTAMP(6),
  name          VARCHAR2(100 CHAR) not null,
  updated_at    TIMESTAMP(6),
  alter_mode_id NUMBER(10) not null
)
;
comment on table HB_STD_ALTER_REASONS
  is '学籍变动原因';
comment on column HB_STD_ALTER_REASONS.id
  is '非业务主键';
comment on column HB_STD_ALTER_REASONS.code
  is '代码';
comment on column HB_STD_ALTER_REASONS.created_at
  is '创建时间';
comment on column HB_STD_ALTER_REASONS.effective_at
  is '生效时间';
comment on column HB_STD_ALTER_REASONS.eng_name
  is '英文名称';
comment on column HB_STD_ALTER_REASONS.invalid_at
  is '失效时间';
comment on column HB_STD_ALTER_REASONS.name
  is '名称';
comment on column HB_STD_ALTER_REASONS.updated_at
  is '修改时间';
comment on column HB_STD_ALTER_REASONS.alter_mode_id
  is '学籍变动类别. ID ###引用表名是HB_STD_ALTER_TYPES### ';
alter table HB_STD_ALTER_REASONS
  add primary key (ID);
alter table HB_STD_ALTER_REASONS
  add constraint UK_BREYOP7XKP4LCHHEHX3BDM3ST unique (CODE);
alter table HB_STD_ALTER_REASONS
  add constraint FK_6N664LMFJG6QJ0799KX5G7FYX foreign key (ALTER_MODE_ID)
  references HB_STD_ALTER_TYPES (ID);

prompt Creating HB_STD_AWARD_TYPES...
create table HB_STD_AWARD_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6),
  grade        NUMBER(10)
)
;
comment on table HB_STD_AWARD_TYPES
  is '学生奖励类别';
comment on column HB_STD_AWARD_TYPES.id
  is '非业务主键';
comment on column HB_STD_AWARD_TYPES.code
  is '代码';
comment on column HB_STD_AWARD_TYPES.created_at
  is '创建时间';
comment on column HB_STD_AWARD_TYPES.effective_at
  is '生效时间';
comment on column HB_STD_AWARD_TYPES.eng_name
  is '英文名称';
comment on column HB_STD_AWARD_TYPES.invalid_at
  is '失效时间';
comment on column HB_STD_AWARD_TYPES.name
  is '名称';
comment on column HB_STD_AWARD_TYPES.updated_at
  is '修改时间';
comment on column HB_STD_AWARD_TYPES.grade
  is '类型等级';
alter table HB_STD_AWARD_TYPES
  add primary key (ID);
alter table HB_STD_AWARD_TYPES
  add constraint UK_G3PVFTN5N36IFC83E6QT7RXOE unique (CODE);

prompt Creating HB_STD_PUNISH_TYPES...
create table HB_STD_PUNISH_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6),
  grade        NUMBER(10)
)
;
comment on table HB_STD_PUNISH_TYPES
  is '处分名称';
comment on column HB_STD_PUNISH_TYPES.id
  is '非业务主键';
comment on column HB_STD_PUNISH_TYPES.code
  is '代码';
comment on column HB_STD_PUNISH_TYPES.created_at
  is '创建时间';
comment on column HB_STD_PUNISH_TYPES.effective_at
  is '生效时间';
comment on column HB_STD_PUNISH_TYPES.eng_name
  is '英文名称';
comment on column HB_STD_PUNISH_TYPES.invalid_at
  is '失效时间';
comment on column HB_STD_PUNISH_TYPES.name
  is '名称';
comment on column HB_STD_PUNISH_TYPES.updated_at
  is '修改时间';
comment on column HB_STD_PUNISH_TYPES.grade
  is '处分等级值';
alter table HB_STD_PUNISH_TYPES
  add primary key (ID);
alter table HB_STD_PUNISH_TYPES
  add constraint UK_IRH0EPTFXK73522NQGYPNE81H unique (CODE);

prompt Creating HB_TEACH_LANG_TYPES...
create table HB_TEACH_LANG_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_TEACH_LANG_TYPES
  is '授课语言类型';
comment on column HB_TEACH_LANG_TYPES.id
  is '非业务主键';
comment on column HB_TEACH_LANG_TYPES.code
  is '代码';
comment on column HB_TEACH_LANG_TYPES.created_at
  is '创建时间';
comment on column HB_TEACH_LANG_TYPES.effective_at
  is '生效时间';
comment on column HB_TEACH_LANG_TYPES.eng_name
  is '英文名称';
comment on column HB_TEACH_LANG_TYPES.invalid_at
  is '失效时间';
comment on column HB_TEACH_LANG_TYPES.name
  is '名称';
comment on column HB_TEACH_LANG_TYPES.updated_at
  is '修改时间';
alter table HB_TEACH_LANG_TYPES
  add primary key (ID);
alter table HB_TEACH_LANG_TYPES
  add constraint UK_7TSE0IN0V3RC9BAPUM6RV3ENO unique (CODE);

prompt Creating HB_UNCHECKIN_REASONS...
create table HB_UNCHECKIN_REASONS
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6),
  leave        NUMBER(1) not null
)
;
comment on table HB_UNCHECKIN_REASONS
  is '未报到原因';
comment on column HB_UNCHECKIN_REASONS.id
  is '非业务主键';
comment on column HB_UNCHECKIN_REASONS.code
  is '代码';
comment on column HB_UNCHECKIN_REASONS.created_at
  is '创建时间';
comment on column HB_UNCHECKIN_REASONS.effective_at
  is '生效时间';
comment on column HB_UNCHECKIN_REASONS.eng_name
  is '英文名称';
comment on column HB_UNCHECKIN_REASONS.invalid_at
  is '失效时间';
comment on column HB_UNCHECKIN_REASONS.name
  is '名称';
comment on column HB_UNCHECKIN_REASONS.updated_at
  is '修改时间';
comment on column HB_UNCHECKIN_REASONS.leave
  is '是否请假';
alter table HB_UNCHECKIN_REASONS
  add primary key (ID);
alter table HB_UNCHECKIN_REASONS
  add constraint UK_IYK5DIB0RX0LO3RGDP8R4F4RT unique (CODE);

prompt Creating HB_UNREGISTER_REASONS...
create table HB_UNREGISTER_REASONS
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_UNREGISTER_REASONS
  is '未注册原因';
comment on column HB_UNREGISTER_REASONS.id
  is '非业务主键';
comment on column HB_UNREGISTER_REASONS.code
  is '代码';
comment on column HB_UNREGISTER_REASONS.created_at
  is '创建时间';
comment on column HB_UNREGISTER_REASONS.effective_at
  is '生效时间';
comment on column HB_UNREGISTER_REASONS.eng_name
  is '英文名称';
comment on column HB_UNREGISTER_REASONS.invalid_at
  is '失效时间';
comment on column HB_UNREGISTER_REASONS.name
  is '名称';
comment on column HB_UNREGISTER_REASONS.updated_at
  is '修改时间';
alter table HB_UNREGISTER_REASONS
  add primary key (ID);
alter table HB_UNREGISTER_REASONS
  add constraint UK_9UOBD245NMFI0FRXR1YV2TAKM unique (CODE);

prompt Creating HB_VISA_TYPES...
create table HB_VISA_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table HB_VISA_TYPES
  is '签证类别';
comment on column HB_VISA_TYPES.id
  is '非业务主键';
comment on column HB_VISA_TYPES.code
  is '代码';
comment on column HB_VISA_TYPES.created_at
  is '创建时间';
comment on column HB_VISA_TYPES.effective_at
  is '生效时间';
comment on column HB_VISA_TYPES.eng_name
  is '英文名称';
comment on column HB_VISA_TYPES.invalid_at
  is '失效时间';
comment on column HB_VISA_TYPES.name
  is '名称';
comment on column HB_VISA_TYPES.updated_at
  is '修改时间';
alter table HB_VISA_TYPES
  add primary key (ID);
alter table HB_VISA_TYPES
  add constraint UK_4NKI8CSKGMEIO3W7SGNW3XHQ5 unique (CODE);

prompt Creating JB_DISCIPLINE_CATALOGS...
create table JB_DISCIPLINE_CATALOGS
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table JB_DISCIPLINE_CATALOGS
  is '学科目录';
comment on column JB_DISCIPLINE_CATALOGS.id
  is '非业务主键';
comment on column JB_DISCIPLINE_CATALOGS.code
  is '代码';
comment on column JB_DISCIPLINE_CATALOGS.created_at
  is '创建时间';
comment on column JB_DISCIPLINE_CATALOGS.effective_at
  is '生效时间';
comment on column JB_DISCIPLINE_CATALOGS.eng_name
  is '英文名称';
comment on column JB_DISCIPLINE_CATALOGS.invalid_at
  is '失效时间';
comment on column JB_DISCIPLINE_CATALOGS.name
  is '名称';
comment on column JB_DISCIPLINE_CATALOGS.updated_at
  is '修改时间';
alter table JB_DISCIPLINE_CATALOGS
  add primary key (ID);
alter table JB_DISCIPLINE_CATALOGS
  add constraint UK_H73AX5361T7SPWJDFCJMVCD1V unique (CODE);

prompt Creating JB_DISCIPLINES...
create table JB_DISCIPLINES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6),
  catalog_id   NUMBER(10),
  category_id  NUMBER(10),
  parent_id    NUMBER(10)
)
;
comment on table JB_DISCIPLINES
  is '学科';
comment on column JB_DISCIPLINES.id
  is '非业务主键';
comment on column JB_DISCIPLINES.code
  is '代码';
comment on column JB_DISCIPLINES.created_at
  is '创建时间';
comment on column JB_DISCIPLINES.effective_at
  is '生效时间';
comment on column JB_DISCIPLINES.eng_name
  is '英文名称';
comment on column JB_DISCIPLINES.invalid_at
  is '失效时间';
comment on column JB_DISCIPLINES.name
  is '名称';
comment on column JB_DISCIPLINES.updated_at
  is '修改时间';
comment on column JB_DISCIPLINES.catalog_id
  is '所属学科目录 ID ###引用表名是JB_DISCIPLINE_CATALOGS### ';
comment on column JB_DISCIPLINES.category_id
  is '所属学科门类 ID ###引用表名是JB_DISCIPLINE_CATEGORIES### ';
comment on column JB_DISCIPLINES.parent_id
  is '上级学科 ID ###引用表名是JB_DISCIPLINES### ';
alter table JB_DISCIPLINES
  add primary key (ID);
alter table JB_DISCIPLINES
  add constraint UK_ASN7HXG32LWYFM5ISCXCN8HSN unique (CODE, CATALOG_ID);
alter table JB_DISCIPLINES
  add constraint FK_65XEG7YKTYH0VPJ1PQUCFWLKV foreign key (PARENT_ID)
  references JB_DISCIPLINES (ID);
alter table JB_DISCIPLINES
  add constraint FK_8VXGE5FNGVHG7Y51TVDC3ORI1 foreign key (CATEGORY_ID)
  references JB_DISCIPLINE_CATEGORIES (ID);
alter table JB_DISCIPLINES
  add constraint FK_B8U99L8W80146FUMSS473G6IJ foreign key (CATALOG_ID)
  references JB_DISCIPLINE_CATALOGS (ID);

prompt Creating Q_OPTION_GROUPS...
create table Q_OPTION_GROUPS
(
  id        NUMBER(19) not null,
  name      VARCHAR2(255 CHAR),
  oppo_val  FLOAT not null,
  depart_id NUMBER(10) not null
)
;
comment on table Q_OPTION_GROUPS
  is '选项组';
comment on column Q_OPTION_GROUPS.id
  is '非业务主键';
comment on column Q_OPTION_GROUPS.name
  is '名称';
comment on column Q_OPTION_GROUPS.oppo_val
  is '倾向性权重 必须在0和1之间';
comment on column Q_OPTION_GROUPS.depart_id
  is '创建部门 ID ###引用表名是C_DEPARTMENTS### ';
alter table Q_OPTION_GROUPS
  add primary key (ID);
alter table Q_OPTION_GROUPS
  add constraint FK_CY20SB04E33IP1LSRLBWTNUFG foreign key (DEPART_ID)
  references C_DEPARTMENTS (ID);

prompt Creating Q_OPTIONS...
create table Q_OPTIONS
(
  id              NUMBER(19) not null,
  name            VARCHAR2(255 CHAR),
  proportion      FLOAT,
  option_group_id NUMBER(19) not null
)
;
comment on table Q_OPTIONS
  is '选项';
comment on column Q_OPTIONS.id
  is '非业务主键';
comment on column Q_OPTIONS.name
  is '选项名';
comment on column Q_OPTIONS.proportion
  is '选项所占比重（权重）';
comment on column Q_OPTIONS.option_group_id
  is '选项组 ID ###引用表名是Q_OPTION_GROUPS### ';
alter table Q_OPTIONS
  add primary key (ID);
alter table Q_OPTIONS
  add constraint FK_517Q9N0YJCSQ6X9ICNKFK6RCM foreign key (OPTION_GROUP_ID)
  references Q_OPTION_GROUPS (ID);

prompt Creating Q_QUESTION_TYPES...
create table Q_QUESTION_TYPES
(
  id           NUMBER(19) not null,
  created_at   TIMESTAMP(6) not null,
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  priority     NUMBER(10) not null,
  remark       VARCHAR2(500 CHAR),
  state        NUMBER(1) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table Q_QUESTION_TYPES
  is '问题类型';
comment on column Q_QUESTION_TYPES.id
  is '非业务主键';
comment on column Q_QUESTION_TYPES.created_at
  is '创建时间';
comment on column Q_QUESTION_TYPES.effective_at
  is '生效时间';
comment on column Q_QUESTION_TYPES.eng_name
  is '英文名称';
comment on column Q_QUESTION_TYPES.invalid_at
  is '失效时间';
comment on column Q_QUESTION_TYPES.name
  is '中文名称';
comment on column Q_QUESTION_TYPES.priority
  is '优先级 ,越大越靠前';
comment on column Q_QUESTION_TYPES.remark
  is '备注';
comment on column Q_QUESTION_TYPES.state
  is '状态';
comment on column Q_QUESTION_TYPES.updated_at
  is '更新时间';
alter table Q_QUESTION_TYPES
  add primary key (ID);

prompt Creating Q_QUESTIONS...
create table Q_QUESTIONS
(
  id              NUMBER(19) not null,
  addition        NUMBER(1),
  content         VARCHAR2(300 CHAR) not null,
  created_at      TIMESTAMP(6) not null,
  effective_at    TIMESTAMP(6) not null,
  invalid_at      TIMESTAMP(6),
  priority        NUMBER(10) not null,
  remark          VARCHAR2(500 CHAR),
  score           FLOAT not null,
  state           NUMBER(1),
  updated_at      TIMESTAMP(6),
  depart_id       NUMBER(10) not null,
  option_group_id NUMBER(19) not null,
  type_id         NUMBER(19) not null
)
;
comment on table Q_QUESTIONS
  is '评教问题';
comment on column Q_QUESTIONS.id
  is '非业务主键';
comment on column Q_QUESTIONS.addition
  is '是否附加题';
comment on column Q_QUESTIONS.content
  is '问题内容';
comment on column Q_QUESTIONS.created_at
  is '创建时间';
comment on column Q_QUESTIONS.effective_at
  is '生效时间';
comment on column Q_QUESTIONS.invalid_at
  is '失效时间';
comment on column Q_QUESTIONS.priority
  is '优先级';
comment on column Q_QUESTIONS.remark
  is '注释';
comment on column Q_QUESTIONS.score
  is '分值';
comment on column Q_QUESTIONS.state
  is '使用状态';
comment on column Q_QUESTIONS.updated_at
  is '更新时间';
comment on column Q_QUESTIONS.depart_id
  is '问题所对应的使用部门 ID ###引用表名是C_DEPARTMENTS### ';
comment on column Q_QUESTIONS.option_group_id
  is '选项组 ID ###引用表名是Q_OPTION_GROUPS### ';
comment on column Q_QUESTIONS.type_id
  is '问题类型 ID ###引用表名是Q_QUESTION_TYPES### ';
alter table Q_QUESTIONS
  add primary key (ID);
alter table Q_QUESTIONS
  add constraint FK_OMTIXXKCQPAF797G2HIOWQ4QQ foreign key (OPTION_GROUP_ID)
  references Q_OPTION_GROUPS (ID);
alter table Q_QUESTIONS
  add constraint FK_PO7YV0KGMQATF3HV1GK0C54KS foreign key (DEPART_ID)
  references C_DEPARTMENTS (ID);
alter table Q_QUESTIONS
  add constraint FK_TQQ76LPY72HM3N2QM5MFWGDWK foreign key (TYPE_ID)
  references Q_QUESTION_TYPES (ID);

prompt Creating Q_QUESTIONNAIRES...
create table Q_QUESTIONNAIRES
(
  id           NUMBER(19) not null,
  create_by    VARCHAR2(255 CHAR),
  created_at   TIMESTAMP(6) not null,
  description  VARCHAR2(255 CHAR),
  effective_at TIMESTAMP(6),
  invalid_at   TIMESTAMP(6),
  remark       VARCHAR2(500 CHAR),
  state        NUMBER(1),
  title        VARCHAR2(500 CHAR),
  updated_at   TIMESTAMP(6),
  depart_id    NUMBER(10)
)
;
comment on table Q_QUESTIONNAIRES
  is '评教问卷';
comment on column Q_QUESTIONNAIRES.id
  is '非业务主键';
comment on column Q_QUESTIONNAIRES.create_by
  is '创建者';
comment on column Q_QUESTIONNAIRES.created_at
  is '创建时间';
comment on column Q_QUESTIONNAIRES.description
  is '简单描述';
comment on column Q_QUESTIONNAIRES.effective_at
  is '生效时间';
comment on column Q_QUESTIONNAIRES.invalid_at
  is '失效时间';
comment on column Q_QUESTIONNAIRES.remark
  is '备注';
comment on column Q_QUESTIONNAIRES.state
  is '使用状态';
comment on column Q_QUESTIONNAIRES.title
  is '问卷标题';
comment on column Q_QUESTIONNAIRES.updated_at
  is '更新时间';
comment on column Q_QUESTIONNAIRES.depart_id
  is '创建部门 ID ###引用表名是C_DEPARTMENTS### ';
alter table Q_QUESTIONNAIRES
  add primary key (ID);
alter table Q_QUESTIONNAIRES
  add constraint FK_HLGRD0TJ75M4439GQF3S4KPW2 foreign key (DEPART_ID)
  references C_DEPARTMENTS (ID);

prompt Creating T_LESSON_GROUPS...
create table T_LESSON_GROUPS
(
  id              NUMBER(19) not null,
  created_at      TIMESTAMP(6),
  updated_at      TIMESTAMP(6),
  lesson_size     NUMBER(10) not null,
  name            VARCHAR2(255 CHAR) not null,
  project_id      NUMBER(10),
  semester_id     NUMBER(10) not null,
  teach_depart_id NUMBER(10) not null
)
;
comment on table T_LESSON_GROUPS
  is '教学任务组';
comment on column T_LESSON_GROUPS.id
  is '非业务主键';
comment on column T_LESSON_GROUPS.created_at
  is '创建时间';
comment on column T_LESSON_GROUPS.updated_at
  is '更新时间';
comment on column T_LESSON_GROUPS.lesson_size
  is '教学任务数目';
comment on column T_LESSON_GROUPS.name
  is '组名称';
comment on column T_LESSON_GROUPS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column T_LESSON_GROUPS.semester_id
  is '学期 ID ###引用表名是C_SEMESTERS### ';
comment on column T_LESSON_GROUPS.teach_depart_id
  is '开课部门 ID ###引用表名是C_DEPARTMENTS### ';
alter table T_LESSON_GROUPS
  add primary key (ID);
alter table T_LESSON_GROUPS
  add constraint FK_87T1SXFYVHS8S8ELJ6QEHHK48 foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_LESSON_GROUPS
  add constraint FK_PLTWEQMCWCV8DVJGMPC7H46AX foreign key (TEACH_DEPART_ID)
  references C_DEPARTMENTS (ID);
alter table T_LESSON_GROUPS
  add constraint FK_S1236L4BJD9KUN6IIWA2AQRYX foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating T_LESSONS...
create table T_LESSONS
(
  id              NUMBER(19) not null,
  created_at      TIMESTAMP(6),
  updated_at      TIMESTAMP(6),
  audit_status    VARCHAR2(255 CHAR) not null,
  end_week        NUMBER(10) not null,
  period          NUMBER(10) not null,
  start_week      NUMBER(10) not null,
  status          VARCHAR2(255 CHAR),
  week_state      NUMBER(19),
  no              VARCHAR2(32 CHAR),
  remark          VARCHAR2(500 CHAR),
  fullname        VARCHAR2(255 CHAR),
  grade           VARCHAR2(255 CHAR),
  limit_count     NUMBER(10) not null,
  limit_locked    NUMBER(1) not null,
  name            VARCHAR2(255 CHAR),
  reserved_count  NUMBER(10) not null,
  std_count       NUMBER(10) not null,
  project_id      NUMBER(10),
  campus_id       NUMBER(10),
  course_id       NUMBER(19) not null,
  room_type_id    NUMBER(10),
  course_type_id  NUMBER(10) not null,
  exam_mode_id    NUMBER(10),
  group_id        NUMBER(19),
  lang_type_id    NUMBER(10),
  semester_id     NUMBER(10) not null,
  depart_id       NUMBER(10),
  teach_depart_id NUMBER(10) not null
)
;
comment on table T_LESSONS
  is '教学任务';
comment on column T_LESSONS.id
  is '非业务主键';
comment on column T_LESSONS.created_at
  is '创建时间';
comment on column T_LESSONS.updated_at
  is '更新时间';
comment on column T_LESSONS.audit_status
  is '审核状态';
comment on column T_LESSONS.end_week
  is '结束周';
comment on column T_LESSONS.period
  is '已安排课时';
comment on column T_LESSONS.start_week
  is '起始周';
comment on column T_LESSONS.status
  is '状态';
comment on column T_LESSONS.no
  is '课程序号';
comment on column T_LESSONS.remark
  is '备注';
comment on column T_LESSONS.grade
  is '入学年份';
comment on column T_LESSONS.limit_count
  is '最大人数';
comment on column T_LESSONS.limit_locked
  is '是否锁定人数上限';
comment on column T_LESSONS.name
  is '教学班名称';
comment on column T_LESSONS.reserved_count
  is '保留人数';
comment on column T_LESSONS.std_count
  is '学生人数';
comment on column T_LESSONS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column T_LESSONS.campus_id
  is '开课校区 ID ###引用表名是C_CAMPUSES### ';
comment on column T_LESSONS.course_id
  is '课程 ID ###引用表名是T_COURSES### ';
comment on column T_LESSONS.room_type_id
  is '教室类型 ID ###引用表名是XB_CLASSROOM_TYPES### ';
comment on column T_LESSONS.course_type_id
  is '课程类别 ID ###引用表名是XB_COURSE_TYPES### ';
comment on column T_LESSONS.exam_mode_id
  is '考试方式 ID ###引用表名是HB_EXAM_MODES### ';
comment on column T_LESSONS.group_id
  is '所属课程组 ID ###引用表名是T_LESSON_GROUPS### ';
comment on column T_LESSONS.lang_type_id
  is '授课语言类型 ID ###引用表名是HB_TEACH_LANG_TYPES### ';
comment on column T_LESSONS.semester_id
  is '教学日历 ID ###引用表名是C_SEMESTERS### ';
comment on column T_LESSONS.depart_id
  is '学生所在部门 ID ###引用表名是C_DEPARTMENTS### ';
comment on column T_LESSONS.teach_depart_id
  is '开课院系 ID ###引用表名是C_DEPARTMENTS### ';
alter table T_LESSONS
  add primary key (ID);
alter table T_LESSONS
  add constraint UK_RSGFLJJ90YVGEN496BCKMKBRW unique (NO, SEMESTER_ID, PROJECT_ID);
alter table T_LESSONS
  add constraint FK_1BD33EJLROG5BACVNXLKY8K6Y foreign key (LANG_TYPE_ID)
  references HB_TEACH_LANG_TYPES (ID);
alter table T_LESSONS
  add constraint FK_1V7I774QJD5IM0352H6XPVLP3 foreign key (DEPART_ID)
  references C_DEPARTMENTS (ID);
alter table T_LESSONS
  add constraint FK_1VQ8GHXDUDK7FIEFIJOO7SQ8I foreign key (COURSE_TYPE_ID)
  references XB_COURSE_TYPES (ID);
alter table T_LESSONS
  add constraint FK_AJTA5POLS0JL7J1AKEVBY2RJ1 foreign key (ROOM_TYPE_ID)
  references XB_CLASSROOM_TYPES (ID);
alter table T_LESSONS
  add constraint FK_BLIWI0D8UE92HRT9B6O2991TG foreign key (COURSE_ID)
  references T_COURSES (ID);
alter table T_LESSONS
  add constraint FK_L3AHFGMCPXYJ4AWWAAECOF9N1 foreign key (GROUP_ID)
  references T_LESSON_GROUPS (ID);
alter table T_LESSONS
  add constraint FK_NHJ97LYQ94PWCR7EHNCF6M33V foreign key (CAMPUS_ID)
  references C_CAMPUSES (ID);
alter table T_LESSONS
  add constraint FK_OCGQ8MQNPB2ASQ8RIPC1NEB5N foreign key (EXAM_MODE_ID)
  references HB_EXAM_MODES (ID);
alter table T_LESSONS
  add constraint FK_QXL98QM0N9WNEJF775Y067XG7 foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table T_LESSONS
  add constraint FK_RBDB2DJ4QHOS7022J8JHE19F7 foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_LESSONS
  add constraint FK_RTS9WQUJRDUPKV0DPTJI4LM6C foreign key (TEACH_DEPART_ID)
  references C_DEPARTMENTS (ID);

prompt Creating Q_QUESTIONNAIRE_STATS...
create table Q_QUESTIONNAIRE_STATS
(
  dtype            VARCHAR2(31 CHAR) not null,
  id               NUMBER(19) not null,
  add_score        FLOAT,
  all_tickets      NUMBER(10),
  depart_rank      NUMBER(10),
  percent          FLOAT not null,
  rank             NUMBER(10),
  release          NUMBER(10),
  score            FLOAT,
  stat_at          TIMESTAMP(6),
  valid_score      FLOAT,
  valid_tickets    NUMBER(10),
  count            NUMBER(10),
  lesson_id        NUMBER(19),
  questionnaire_id NUMBER(19),
  semester_id      NUMBER(10),
  teacher_id       NUMBER(19),
  department_id    NUMBER(10)
)
;
comment on table Q_QUESTIONNAIRE_STATS
  is '院系问题评教统计';
comment on column Q_QUESTIONNAIRE_STATS.id
  is '非业务主键';
comment on column Q_QUESTIONNAIRE_STATS.add_score
  is '附加题总分';
comment on column Q_QUESTIONNAIRE_STATS.all_tickets
  is '所有样本';
comment on column Q_QUESTIONNAIRE_STATS.depart_rank
  is '院系排名';
comment on column Q_QUESTIONNAIRE_STATS.percent
  is '百分比';
comment on column Q_QUESTIONNAIRE_STATS.rank
  is '全校排名';
comment on column Q_QUESTIONNAIRE_STATS.release
  is '是否发布';
comment on column Q_QUESTIONNAIRE_STATS.score
  is '总得分';
comment on column Q_QUESTIONNAIRE_STATS.stat_at
  is '统计时间';
comment on column Q_QUESTIONNAIRE_STATS.valid_score
  is '有效总分';
comment on column Q_QUESTIONNAIRE_STATS.valid_tickets
  is '有效票数';
comment on column Q_QUESTIONNAIRE_STATS.count
  is '人数';
comment on column Q_QUESTIONNAIRE_STATS.lesson_id
  is '教学任务 ID ###引用表名是T_LESSONS### ';
comment on column Q_QUESTIONNAIRE_STATS.questionnaire_id
  is '问卷 ID ###引用表名是Q_QUESTIONNAIRES### ';
comment on column Q_QUESTIONNAIRE_STATS.semester_id
  is '教学日历 ID ###引用表名是C_SEMESTERS### ';
comment on column Q_QUESTIONNAIRE_STATS.teacher_id
  is '任课教师 ID ###引用表名是C_TEACHERS### ';
comment on column Q_QUESTIONNAIRE_STATS.department_id
  is '部门 ID ###引用表名是C_DEPARTMENTS### ';
alter table Q_QUESTIONNAIRE_STATS
  add primary key (ID);
alter table Q_QUESTIONNAIRE_STATS
  add constraint FK_1GT0TXO6PFVRWKOFU0JIG9KYV foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table Q_QUESTIONNAIRE_STATS
  add constraint FK_CQ3RKRONOXAC3L7I68FIOGS54 foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table Q_QUESTIONNAIRE_STATS
  add constraint FK_D6F021IX50R8P65GF60GOVLRL foreign key (LESSON_ID)
  references T_LESSONS (ID);
alter table Q_QUESTIONNAIRE_STATS
  add constraint FK_KWLVFUK6MYYOABNBFIDQH9816 foreign key (QUESTIONNAIRE_ID)
  references Q_QUESTIONNAIRES (ID);
alter table Q_QUESTIONNAIRE_STATS
  add constraint FK_O7RGGCLU6RQLBOLFCTCD93MKJ foreign key (TEACHER_ID)
  references C_TEACHERS (ID);

prompt Creating Q_QUESTION_DETAIL_STATS...
create table Q_QUESTION_DETAIL_STATS
(
  dtype                       VARCHAR2(31 CHAR) not null,
  id                          NUMBER(19) not null,
  average                     FLOAT,
  stddev                      FLOAT,
  sum_count                   NUMBER(10) not null,
  total                       FLOAT,
  question_id                 NUMBER(19),
  evaluate_teacher_stat_id    NUMBER(19),
  evaluate_department_stat_id NUMBER(19),
  evaluate_college_stat_id    NUMBER(19)
)
;
comment on table Q_QUESTION_DETAIL_STATS
  is '评教统计';
comment on column Q_QUESTION_DETAIL_STATS.id
  is '非业务主键';
comment on column Q_QUESTION_DETAIL_STATS.average
  is '平均得分';
comment on column Q_QUESTION_DETAIL_STATS.stddev
  is '标准差';
comment on column Q_QUESTION_DETAIL_STATS.sum_count
  is '该问题所有选项总和，不做映射使用';
comment on column Q_QUESTION_DETAIL_STATS.total
  is '总得分';
comment on column Q_QUESTION_DETAIL_STATS.question_id
  is '具体问题 ID ###引用表名是Q_QUESTIONS### ';
comment on column Q_QUESTION_DETAIL_STATS.evaluate_teacher_stat_id
  is '教师评教统计 ID ###引用表名是Q_QUESTIONNAIRE_STATS### ';
comment on column Q_QUESTION_DETAIL_STATS.evaluate_department_stat_id
  is '院系统计 ID ###引用表名是Q_QUESTIONNAIRE_STATS### ';
comment on column Q_QUESTION_DETAIL_STATS.evaluate_college_stat_id
  is '全校统计 ID ###引用表名是Q_QUESTIONNAIRE_STATS### ';
alter table Q_QUESTION_DETAIL_STATS
  add primary key (ID);
alter table Q_QUESTION_DETAIL_STATS
  add constraint FK_A7NC5KQF65EHJBQ7O2L6XVYFJ foreign key (EVALUATE_COLLEGE_STAT_ID)
  references Q_QUESTIONNAIRE_STATS (ID);
alter table Q_QUESTION_DETAIL_STATS
  add constraint FK_B2051SB5NQRH0RL01YE28OFMD foreign key (QUESTION_ID)
  references Q_QUESTIONS (ID);
alter table Q_QUESTION_DETAIL_STATS
  add constraint FK_DSBRYH5TGYBGMYKA0CGY3L1O2 foreign key (EVALUATE_TEACHER_STAT_ID)
  references Q_QUESTIONNAIRE_STATS (ID);
alter table Q_QUESTION_DETAIL_STATS
  add constraint FK_PULBLXOT8OHIG3SU2XYDF3RN9 foreign key (EVALUATE_DEPARTMENT_STAT_ID)
  references Q_QUESTIONNAIRE_STATS (ID);

prompt Creating Q_COLLEGE_OPTION_STATS...
create table Q_COLLEGE_OPTION_STATS
(
  id        NUMBER(19) not null,
  amount    NUMBER(10) not null,
  option_id NUMBER(19),
  state_id  NUMBER(19)
)
;
comment on table Q_COLLEGE_OPTION_STATS
  is '评教统计';
comment on column Q_COLLEGE_OPTION_STATS.id
  is '非业务主键';
comment on column Q_COLLEGE_OPTION_STATS.amount
  is '数量';
comment on column Q_COLLEGE_OPTION_STATS.option_id
  is '选项 ID ###引用表名是Q_OPTIONS### ';
comment on column Q_COLLEGE_OPTION_STATS.state_id
  is '统计状态 ID ###引用表名是Q_QUESTION_DETAIL_STATS### ';
alter table Q_COLLEGE_OPTION_STATS
  add primary key (ID);
alter table Q_COLLEGE_OPTION_STATS
  add constraint FK_GM3QLNDX9QRQ2R3SRL8FHQL8C foreign key (STATE_ID)
  references Q_QUESTION_DETAIL_STATS (ID);
alter table Q_COLLEGE_OPTION_STATS
  add constraint FK_RF2F0NWU1V2TGB9T7VSVLGY31 foreign key (OPTION_ID)
  references Q_OPTIONS (ID);

prompt Creating Q_DEPARTMENT_OPTION_STATS...
create table Q_DEPARTMENT_OPTION_STATS
(
  id        NUMBER(19) not null,
  amount    NUMBER(10) not null,
  option_id NUMBER(19),
  state_id  NUMBER(19)
)
;
comment on table Q_DEPARTMENT_OPTION_STATS
  is '评教统计';
comment on column Q_DEPARTMENT_OPTION_STATS.id
  is '非业务主键';
comment on column Q_DEPARTMENT_OPTION_STATS.amount
  is '人数';
comment on column Q_DEPARTMENT_OPTION_STATS.option_id
  is '选项 ID ###引用表名是Q_OPTIONS### ';
comment on column Q_DEPARTMENT_OPTION_STATS.state_id
  is '部门明细统计 ID ###引用表名是Q_QUESTION_DETAIL_STATS### ';
alter table Q_DEPARTMENT_OPTION_STATS
  add primary key (ID);
alter table Q_DEPARTMENT_OPTION_STATS
  add constraint FK_CEC420233ARAQLX7O6B2MGLND foreign key (OPTION_ID)
  references Q_OPTIONS (ID);
alter table Q_DEPARTMENT_OPTION_STATS
  add constraint FK_RPD617WRDN7OGDCCWQOJ25CNO foreign key (STATE_ID)
  references Q_QUESTION_DETAIL_STATS (ID);

prompt Creating Q_DEPART_EVALUATIONS...
create table Q_DEPART_EVALUATIONS
(
  id          NUMBER(19) not null,
  score       FLOAT not null,
  update_at   TIMESTAMP(6) not null,
  user_name   VARCHAR2(255 CHAR) not null,
  semester_id NUMBER(10) not null,
  teacher_id  NUMBER(19) not null
)
;
comment on table Q_DEPART_EVALUATIONS
  is '部门评教结果';
comment on column Q_DEPART_EVALUATIONS.id
  is '非业务主键';
comment on column Q_DEPART_EVALUATIONS.score
  is '得分';
comment on column Q_DEPART_EVALUATIONS.update_at
  is '评测日期';
comment on column Q_DEPART_EVALUATIONS.user_name
  is '评测人';
comment on column Q_DEPART_EVALUATIONS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
comment on column Q_DEPART_EVALUATIONS.teacher_id
  is '被评教师 ID ###引用表名是C_TEACHERS### ';
alter table Q_DEPART_EVALUATIONS
  add primary key (ID);
alter table Q_DEPART_EVALUATIONS
  add constraint FK_4V1I07T318VWI5HYWMBJXIKOK foreign key (TEACHER_ID)
  references C_TEACHERS (ID);
alter table Q_DEPART_EVALUATIONS
  add constraint FK_IW4X7CW2NFQDWF07VUJF0LJ8J foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);

prompt Creating Q_EVALUATE_RESULTS...
create table Q_EVALUATE_RESULTS
(
  id               NUMBER(19) not null,
  evaluate_at      TIMESTAMP(6),
  remark           VARCHAR2(255 CHAR),
  stat_state       NUMBER(1),
  stat_type        NUMBER(10),
  department_id    NUMBER(10) not null,
  lesson_id        NUMBER(19),
  questionnaire_id NUMBER(19) not null,
  student_id       NUMBER(19) not null,
  teacher_id       NUMBER(19)
)
;
comment on table Q_EVALUATE_RESULTS
  is '问卷评教结果';
comment on column Q_EVALUATE_RESULTS.id
  is '非业务主键';
comment on column Q_EVALUATE_RESULTS.evaluate_at
  is '评教时间';
comment on column Q_EVALUATE_RESULTS.remark
  is '备注';
comment on column Q_EVALUATE_RESULTS.stat_state
  is '统计状态';
comment on column Q_EVALUATE_RESULTS.stat_type
  is '1正常 2 无效 3异常(互斥)';
comment on column Q_EVALUATE_RESULTS.department_id
  is '开课院系 ID ###引用表名是C_DEPARTMENTS### ';
comment on column Q_EVALUATE_RESULTS.lesson_id
  is '教学任务 ID ###引用表名是T_LESSONS### ';
comment on column Q_EVALUATE_RESULTS.questionnaire_id
  is '问卷信息 ID ###引用表名是Q_QUESTIONNAIRES### ';
comment on column Q_EVALUATE_RESULTS.student_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
comment on column Q_EVALUATE_RESULTS.teacher_id
  is '教师 ID ###引用表名是C_TEACHERS### ';
alter table Q_EVALUATE_RESULTS
  add primary key (ID);
alter table Q_EVALUATE_RESULTS
  add constraint FK_9NJK15Q9J51FOKGTEKF4HP8YL foreign key (TEACHER_ID)
  references C_TEACHERS (ID);
alter table Q_EVALUATE_RESULTS
  add constraint FK_AE65VS8F8UV543232PWOHJSFH foreign key (LESSON_ID)
  references T_LESSONS (ID);
alter table Q_EVALUATE_RESULTS
  add constraint FK_DHK73TEQFI7U5UUPVYH6LROU3 foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table Q_EVALUATE_RESULTS
  add constraint FK_HDIDTXWOCSSO646KIG7K02O60 foreign key (STUDENT_ID)
  references C_STUDENTS (ID);
alter table Q_EVALUATE_RESULTS
  add constraint FK_IAMA79W10MA9PBN052B7O6V foreign key (QUESTIONNAIRE_ID)
  references Q_QUESTIONNAIRES (ID);

prompt Creating Q_EVALUATE_SWITCHES...
create table Q_EVALUATE_SWITCHES
(
  id          NUMBER(19) not null,
  created_at  TIMESTAMP(6),
  updated_at  TIMESTAMP(6),
  close_at    TIMESTAMP(6),
  is_open     NUMBER(1),
  open_at     TIMESTAMP(6),
  project_id  NUMBER(10),
  semester_id NUMBER(10)
)
;
comment on table Q_EVALUATE_SWITCHES
  is '评教开关';
comment on column Q_EVALUATE_SWITCHES.id
  is '非业务主键';
comment on column Q_EVALUATE_SWITCHES.created_at
  is '创建时间';
comment on column Q_EVALUATE_SWITCHES.updated_at
  is '更新时间';
comment on column Q_EVALUATE_SWITCHES.close_at
  is '关闭时间';
comment on column Q_EVALUATE_SWITCHES.is_open
  is '开关状态';
comment on column Q_EVALUATE_SWITCHES.open_at
  is '开始时间';
comment on column Q_EVALUATE_SWITCHES.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column Q_EVALUATE_SWITCHES.semester_id
  is '教学日历 ID ###引用表名是C_SEMESTERS### ';
alter table Q_EVALUATE_SWITCHES
  add primary key (ID);
alter table Q_EVALUATE_SWITCHES
  add constraint FK_ALGMSPVKGTI39DPPTXLMPNS51 foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table Q_EVALUATE_SWITCHES
  add constraint FK_O1V14R0EBN6ATWLOVO052LFOV foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating Q_EVALUATION_CRITERIAS...
create table Q_EVALUATION_CRITERIAS
(
  id        NUMBER(19) not null,
  name      VARCHAR2(255 CHAR),
  depart_id NUMBER(10)
)
;
comment on table Q_EVALUATION_CRITERIAS
  is '评教对照标准';
comment on column Q_EVALUATION_CRITERIAS.id
  is '非业务主键';
comment on column Q_EVALUATION_CRITERIAS.name
  is '名称';
comment on column Q_EVALUATION_CRITERIAS.depart_id
  is '制作部门 ID ###引用表名是C_DEPARTMENTS### ';
alter table Q_EVALUATION_CRITERIAS
  add primary key (ID);
alter table Q_EVALUATION_CRITERIAS
  add constraint FK_T31KV4Y54ECD9KFM6S99S37S4 foreign key (DEPART_ID)
  references C_DEPARTMENTS (ID);

prompt Creating Q_EVAL_CRITERIA_ITEMS...
create table Q_EVAL_CRITERIA_ITEMS
(
  id          NUMBER(19) not null,
  max         FLOAT,
  min         FLOAT,
  name        VARCHAR2(255 CHAR),
  criteria_id NUMBER(19) not null
)
;
comment on table Q_EVAL_CRITERIA_ITEMS
  is '评价名称对应项';
comment on column Q_EVAL_CRITERIA_ITEMS.id
  is '非业务主键';
comment on column Q_EVAL_CRITERIA_ITEMS.max
  is '最大分值';
comment on column Q_EVAL_CRITERIA_ITEMS.min
  is '最小分值';
comment on column Q_EVAL_CRITERIA_ITEMS.name
  is '对应的评价名称';
comment on column Q_EVAL_CRITERIA_ITEMS.criteria_id
  is '评价 ID ###引用表名是Q_EVALUATION_CRITERIAS### ';
alter table Q_EVAL_CRITERIA_ITEMS
  add primary key (ID);
alter table Q_EVAL_CRITERIA_ITEMS
  add constraint FK_FYQF61GHGQ9F4XD4TJKHWTE0O foreign key (CRITERIA_ID)
  references Q_EVALUATION_CRITERIAS (ID);

prompt Creating Q_TEXT_EVALUATIONS...
create table Q_TEXT_EVALUATIONS
(
  id            NUMBER(19) not null,
  context       VARCHAR2(255 CHAR),
  evaluation_at TIMESTAMP(6),
  is_affirm     NUMBER(1),
  is_for_course NUMBER(1),
  lesson_id     NUMBER(19) not null,
  semester_id   NUMBER(10) not null,
  std_id        NUMBER(19) not null,
  teacher_id    NUMBER(19)
)
;
comment on table Q_TEXT_EVALUATIONS
  is '文字评教';
comment on column Q_TEXT_EVALUATIONS.id
  is '非业务主键';
comment on column Q_TEXT_EVALUATIONS.context
  is '评教内容';
comment on column Q_TEXT_EVALUATIONS.evaluation_at
  is '评教时间';
comment on column Q_TEXT_EVALUATIONS.is_affirm
  is '是否确认';
comment on column Q_TEXT_EVALUATIONS.is_for_course
  is '是否课程评教';
comment on column Q_TEXT_EVALUATIONS.lesson_id
  is '教学任务 ID ###引用表名是T_LESSONS### ';
comment on column Q_TEXT_EVALUATIONS.semester_id
  is '教学日历 ID ###引用表名是C_SEMESTERS### ';
comment on column Q_TEXT_EVALUATIONS.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
comment on column Q_TEXT_EVALUATIONS.teacher_id
  is '教师 ID ###引用表名是C_TEACHERS### ';
alter table Q_TEXT_EVALUATIONS
  add primary key (ID);
alter table Q_TEXT_EVALUATIONS
  add constraint FK_5U8MGQAVTVMNHUUB9MNXEXKM5 foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table Q_TEXT_EVALUATIONS
  add constraint FK_AGTRSBW2NF04BLFQ8JL9EB565 foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table Q_TEXT_EVALUATIONS
  add constraint FK_HDB70L4B93KXPV4IP86NDIH43 foreign key (TEACHER_ID)
  references C_TEACHERS (ID);
alter table Q_TEXT_EVALUATIONS
  add constraint FK_PXQ9DCHGHEELP1E2SP5SAWH5E foreign key (LESSON_ID)
  references T_LESSONS (ID);

prompt Creating Q_EVA_TEACH_REMESSAGE...
create table Q_EVA_TEACH_REMESSAGE
(
  id                 NUMBER(19) not null,
  created_at         TIMESTAMP(6),
  updated_at         TIMESTAMP(6),
  remessage          VARCHAR2(255 CHAR),
  visible            NUMBER(1) not null,
  text_evaluation_id NUMBER(19)
)
;
comment on table Q_EVA_TEACH_REMESSAGE
  is '文字评教教师回复';
comment on column Q_EVA_TEACH_REMESSAGE.id
  is '非业务主键';
comment on column Q_EVA_TEACH_REMESSAGE.created_at
  is '创建时间';
comment on column Q_EVA_TEACH_REMESSAGE.updated_at
  is '更新时间';
comment on column Q_EVA_TEACH_REMESSAGE.remessage
  is '回复信息';
comment on column Q_EVA_TEACH_REMESSAGE.visible
  is '显示状态';
comment on column Q_EVA_TEACH_REMESSAGE.text_evaluation_id
  is '文字评教 ID ###引用表名是Q_TEXT_EVALUATIONS### ';
alter table Q_EVA_TEACH_REMESSAGE
  add primary key (ID);
alter table Q_EVA_TEACH_REMESSAGE
  add constraint FK_DOQ7GXS6AE69IM207N2QF7674 foreign key (TEXT_EVALUATION_ID)
  references Q_TEXT_EVALUATIONS (ID);

prompt Creating Q_EVA_TEA_REM_STDS...
create table Q_EVA_TEA_REM_STDS
(
  q_eva_teach_remessage_id NUMBER(19) not null,
  student_id               NUMBER(19) not null
)
;
comment on table Q_EVA_TEA_REM_STDS
  is '文字评教教师回复-回复对象';
comment on column Q_EVA_TEA_REM_STDS.q_eva_teach_remessage_id
  is '文字评教教师回复 ID ###引用表名是Q_EVA_TEACH_REMESSAGE### ';
comment on column Q_EVA_TEA_REM_STDS.student_id
  is '学籍信息实现 ID ###引用表名是C_STUDENTS### ';
alter table Q_EVA_TEA_REM_STDS
  add primary key (Q_EVA_TEACH_REMESSAGE_ID, STUDENT_ID);
alter table Q_EVA_TEA_REM_STDS
  add constraint FK_CU9GQ3RCPVLXAIAXWTI2EIGU9 foreign key (STUDENT_ID)
  references C_STUDENTS (ID);
alter table Q_EVA_TEA_REM_STDS
  add constraint FK_HJGDK8H540J0BSSOQUPL3MY9T foreign key (Q_EVA_TEACH_REMESSAGE_ID)
  references Q_EVA_TEACH_REMESSAGE (ID);

prompt Creating Q_NOT_EVALUATE_STUDENTS...
create table Q_NOT_EVALUATE_STUDENTS
(
  id          NUMBER(19) not null,
  semester_id NUMBER(10),
  std_id      NUMBER(19)
)
;
comment on table Q_NOT_EVALUATE_STUDENTS
  is '不参评学生';
comment on column Q_NOT_EVALUATE_STUDENTS.id
  is '非业务主键';
comment on column Q_NOT_EVALUATE_STUDENTS.semester_id
  is '学期 ID ###引用表名是C_SEMESTERS### ';
comment on column Q_NOT_EVALUATE_STUDENTS.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table Q_NOT_EVALUATE_STUDENTS
  add primary key (ID);
alter table Q_NOT_EVALUATE_STUDENTS
  add constraint FK_KP2R9VK5YKYGBMVQ7D0EYVE00 foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table Q_NOT_EVALUATE_STUDENTS
  add constraint FK_SJ0U8KQKXQBNKBNHNCVNC9PWU foreign key (STD_ID)
  references C_STUDENTS (ID);

prompt Creating Q_OPPOSITE_QUESTIONS...
create table Q_OPPOSITE_QUESTIONS
(
  id                NUMBER(19) not null,
  oppo_question_id  NUMBER(19) not null,
  orgin_question_id NUMBER(19) not null
)
;
comment on table Q_OPPOSITE_QUESTIONS
  is '对立问题';
comment on column Q_OPPOSITE_QUESTIONS.id
  is '非业务主键';
comment on column Q_OPPOSITE_QUESTIONS.oppo_question_id
  is '对立问题 ID ###引用表名是Q_QUESTIONS### ';
comment on column Q_OPPOSITE_QUESTIONS.orgin_question_id
  is '原始问题 ID ###引用表名是Q_QUESTIONS### ';
alter table Q_OPPOSITE_QUESTIONS
  add primary key (ID);
alter table Q_OPPOSITE_QUESTIONS
  add constraint FK_6BT6AFY00DPHFI9YWTHY3USV foreign key (ORGIN_QUESTION_ID)
  references Q_QUESTIONS (ID);
alter table Q_OPPOSITE_QUESTIONS
  add constraint FK_GUTNL3F9GS293V6YKWRC8XE1T foreign key (OPPO_QUESTION_ID)
  references Q_QUESTIONS (ID);

prompt Creating Q_OPTION_STATS...
create table Q_OPTION_STATS
(
  id        NUMBER(19) not null,
  amount    NUMBER(10) not null,
  option_id NUMBER(19),
  state_id  NUMBER(19)
)
;
comment on table Q_OPTION_STATS
  is '评教统计';
comment on column Q_OPTION_STATS.id
  is '非业务主键';
comment on column Q_OPTION_STATS.amount
  is '人数';
comment on column Q_OPTION_STATS.option_id
  is '选项 ID ###引用表名是Q_OPTIONS### ';
comment on column Q_OPTION_STATS.state_id
  is '问题统计明细 ID ###引用表名是Q_QUESTION_DETAIL_STATS### ';
alter table Q_OPTION_STATS
  add primary key (ID);
alter table Q_OPTION_STATS
  add constraint FK_7GOXAG2VGBNTQYD09ISA39IWH foreign key (STATE_ID)
  references Q_QUESTION_DETAIL_STATS (ID);
alter table Q_OPTION_STATS
  add constraint FK_9P76KEB5YE5S88CXSUN6D8MI9 foreign key (OPTION_ID)
  references Q_OPTIONS (ID);

prompt Creating Q_QUESTIONNAIRES_OPPO_QS...
create table Q_QUESTIONNAIRES_OPPO_QS
(
  questionnaire_id     NUMBER(19) not null,
  opposite_question_id NUMBER(19) not null
)
;
comment on table Q_QUESTIONNAIRES_OPPO_QS
  is '评教问卷-对立问题';
comment on column Q_QUESTIONNAIRES_OPPO_QS.questionnaire_id
  is '评教问卷 ID ###引用表名是Q_QUESTIONNAIRES### ';
comment on column Q_QUESTIONNAIRES_OPPO_QS.opposite_question_id
  is '对立问题 ID ###引用表名是Q_OPPOSITE_QUESTIONS### ';
alter table Q_QUESTIONNAIRES_OPPO_QS
  add primary key (QUESTIONNAIRE_ID, OPPOSITE_QUESTION_ID);
alter table Q_QUESTIONNAIRES_OPPO_QS
  add constraint FK_1E3GNG0EKKXB13P4J9MX996GB foreign key (OPPOSITE_QUESTION_ID)
  references Q_OPPOSITE_QUESTIONS (ID);
alter table Q_QUESTIONNAIRES_OPPO_QS
  add constraint FK_9A7GM0H3X81RHXPK7TBBPQ56Y foreign key (QUESTIONNAIRE_ID)
  references Q_QUESTIONNAIRES (ID);

prompt Creating Q_QUESTIONNAIRES_QUESTIONS...
create table Q_QUESTIONNAIRES_QUESTIONS
(
  questionnaire_id NUMBER(19) not null,
  question_id      NUMBER(19) not null
)
;
comment on table Q_QUESTIONNAIRES_QUESTIONS
  is '评教问卷-相关联的问题';
comment on column Q_QUESTIONNAIRES_QUESTIONS.questionnaire_id
  is '评教问卷 ID ###引用表名是Q_QUESTIONNAIRES### ';
comment on column Q_QUESTIONNAIRES_QUESTIONS.question_id
  is '评教问题 ID ###引用表名是Q_QUESTIONS### ';
alter table Q_QUESTIONNAIRES_QUESTIONS
  add primary key (QUESTIONNAIRE_ID, QUESTION_ID);
alter table Q_QUESTIONNAIRES_QUESTIONS
  add constraint FK_4IBGBUK2BP6KO8N67FYFAUNMQ foreign key (QUESTIONNAIRE_ID)
  references Q_QUESTIONNAIRES (ID);
alter table Q_QUESTIONNAIRES_QUESTIONS
  add constraint FK_E0U1K3S43M3I9T6XDXSX669M6 foreign key (QUESTION_ID)
  references Q_QUESTIONS (ID);

prompt Creating Q_QUESTIONNAIRE_LESSONS...
create table Q_QUESTIONNAIRE_LESSONS
(
  id                  NUMBER(19) not null,
  evaluate_by_teacher NUMBER(1) not null,
  lesson_id           NUMBER(19),
  questionnaire_id    NUMBER(19)
)
;
comment on table Q_QUESTIONNAIRE_LESSONS
  is '问卷课程配置';
comment on column Q_QUESTIONNAIRE_LESSONS.id
  is '非业务主键';
comment on column Q_QUESTIONNAIRE_LESSONS.evaluate_by_teacher
  is '是否教师评教';
comment on column Q_QUESTIONNAIRE_LESSONS.lesson_id
  is '教学任务 ID ###引用表名是T_LESSONS### ';
comment on column Q_QUESTIONNAIRE_LESSONS.questionnaire_id
  is '问卷 ID ###引用表名是Q_QUESTIONNAIRES### ';
alter table Q_QUESTIONNAIRE_LESSONS
  add primary key (ID);
alter table Q_QUESTIONNAIRE_LESSONS
  add constraint UK_8GS887KU5V97PPLV4X6HF8C3N unique (LESSON_ID, QUESTIONNAIRE_ID);
alter table Q_QUESTIONNAIRE_LESSONS
  add constraint FK_DXKUJ7ATH067HKG1Q0KSTSLP4 foreign key (QUESTIONNAIRE_ID)
  references Q_QUESTIONNAIRES (ID);
alter table Q_QUESTIONNAIRE_LESSONS
  add constraint FK_GJQYBON31H1E2P2XBJKIT1EQO foreign key (LESSON_ID)
  references T_LESSONS (ID);

prompt Creating Q_QUESTIONNAIRE_STATS_DETAILS...
create table Q_QUESTIONNAIRE_STATS_DETAILS
(
  questionnaire_stat_id   NUMBER(19) not null,
  question_detail_stat_id NUMBER(19) not null
)
;
comment on table Q_QUESTIONNAIRE_STATS_DETAILS
  is '评教问卷统计结果-问题详细信息统计';
comment on column Q_QUESTIONNAIRE_STATS_DETAILS.questionnaire_stat_id
  is '评教问卷统计结果 ID ###引用表名是Q_QUESTIONNAIRE_STATS### ';
comment on column Q_QUESTIONNAIRE_STATS_DETAILS.question_detail_stat_id
  is '评教统计 ID ###引用表名是Q_QUESTION_DETAIL_STATS### ';
alter table Q_QUESTIONNAIRE_STATS_DETAILS
  add primary key (QUESTIONNAIRE_STAT_ID, QUESTION_DETAIL_STAT_ID);
alter table Q_QUESTIONNAIRE_STATS_DETAILS
  add constraint FK_7BFGCLRCNAN1UOJWAMBBR5MM0 foreign key (QUESTION_DETAIL_STAT_ID)
  references Q_QUESTION_DETAIL_STATS (ID);
alter table Q_QUESTIONNAIRE_STATS_DETAILS
  add constraint FK_HEIO71OF1E2PVR1N6JO6K4MMU foreign key (QUESTIONNAIRE_STAT_ID)
  references Q_QUESTIONNAIRE_STATS (ID);

prompt Creating Q_QUESTION_TYPE_STATS...
create table Q_QUESTION_TYPE_STATS
(
  id                    NUMBER(19) not null,
  score                 FLOAT,
  questionnaire_stat_id NUMBER(19),
  type_id               NUMBER(19)
)
;
comment on table Q_QUESTION_TYPE_STATS
  is '评教问题统计结果';
comment on column Q_QUESTION_TYPE_STATS.id
  is '非业务主键';
comment on column Q_QUESTION_TYPE_STATS.score
  is '问题类别统计的分值(百分制)';
comment on column Q_QUESTION_TYPE_STATS.questionnaire_stat_id
  is '问卷评教结果 ID ###引用表名是Q_QUESTIONNAIRE_STATS### ';
comment on column Q_QUESTION_TYPE_STATS.type_id
  is '问题类别 ID ###引用表名是Q_QUESTION_TYPES### ';
alter table Q_QUESTION_TYPE_STATS
  add primary key (ID);
alter table Q_QUESTION_TYPE_STATS
  add constraint FK_AAE099VFROX2FBSULM6NCKD36 foreign key (TYPE_ID)
  references Q_QUESTION_TYPES (ID);
alter table Q_QUESTION_TYPE_STATS
  add constraint FK_IMMIT82IASL8O6Q0FN5OWGIRE foreign key (QUESTIONNAIRE_STAT_ID)
  references Q_QUESTIONNAIRE_STATS (ID);

prompt Creating Q_QUESTIONNAIRE_STATS_SCORES...
create table Q_QUESTIONNAIRE_STATS_SCORES
(
  questionnaire_stat_id NUMBER(19) not null,
  question_type_stat_id NUMBER(19) not null
)
;
comment on table Q_QUESTIONNAIRE_STATS_SCORES
  is '评教问卷统计结果-问题类别得分';
comment on column Q_QUESTIONNAIRE_STATS_SCORES.questionnaire_stat_id
  is '评教问卷统计结果 ID ###引用表名是Q_QUESTIONNAIRE_STATS### ';
comment on column Q_QUESTIONNAIRE_STATS_SCORES.question_type_stat_id
  is '评教问题统计结果 ID ###引用表名是Q_QUESTION_TYPE_STATS### ';
alter table Q_QUESTIONNAIRE_STATS_SCORES
  add primary key (QUESTIONNAIRE_STAT_ID, QUESTION_TYPE_STAT_ID);
alter table Q_QUESTIONNAIRE_STATS_SCORES
  add constraint FK_A0D4KKKEY8TT775JJ63V03JUD foreign key (QUESTION_TYPE_STAT_ID)
  references Q_QUESTION_TYPE_STATS (ID);
alter table Q_QUESTIONNAIRE_STATS_SCORES
  add constraint FK_SEMXWSK7GLNEWYHCCDL4DGJYK foreign key (QUESTIONNAIRE_STAT_ID)
  references Q_QUESTIONNAIRE_STATS (ID);

prompt Creating Q_QUESTION_RESULTS...
create table Q_QUESTION_RESULTS
(
  id          NUMBER(19) not null,
  score       FLOAT not null,
  option_id   NUMBER(19),
  question_id NUMBER(19),
  result_id   NUMBER(19) not null
)
;
comment on table Q_QUESTION_RESULTS
  is '问题评教结果';
comment on column Q_QUESTION_RESULTS.id
  is '非业务主键';
comment on column Q_QUESTION_RESULTS.score
  is '得分';
comment on column Q_QUESTION_RESULTS.option_id
  is '问题选项 ID ###引用表名是Q_OPTIONS### ';
comment on column Q_QUESTION_RESULTS.question_id
  is '问题 ID ###引用表名是Q_QUESTIONS### ';
comment on column Q_QUESTION_RESULTS.result_id
  is '评教结果 ID ###引用表名是Q_EVALUATE_RESULTS### ';
alter table Q_QUESTION_RESULTS
  add primary key (ID);
alter table Q_QUESTION_RESULTS
  add constraint FK_6DMVEPRUXXXTI6X16O3A89PO5 foreign key (QUESTION_ID)
  references Q_QUESTIONS (ID);
alter table Q_QUESTION_RESULTS
  add constraint FK_9YDL6T6G4EGQ0Q05CLW1W1VCN foreign key (OPTION_ID)
  references Q_OPTIONS (ID);
alter table Q_QUESTION_RESULTS
  add constraint FK_SAIV79DEPJQHWSYGGUU90DDGH foreign key (RESULT_ID)
  references Q_EVALUATE_RESULTS (ID);

prompt Creating Q_TEACHER_OPTION_STATS...
create table Q_TEACHER_OPTION_STATS
(
  id        NUMBER(19) not null,
  amount    NUMBER(10) not null,
  option_id NUMBER(19),
  state_id  NUMBER(19)
)
;
comment on table Q_TEACHER_OPTION_STATS
  is '评教统计';
comment on column Q_TEACHER_OPTION_STATS.id
  is '非业务主键';
comment on column Q_TEACHER_OPTION_STATS.amount
  is '人数';
comment on column Q_TEACHER_OPTION_STATS.option_id
  is '选项 ID ###引用表名是Q_OPTIONS### ';
comment on column Q_TEACHER_OPTION_STATS.state_id
  is '教师统计明细 ID ###引用表名是Q_QUESTION_DETAIL_STATS### ';
alter table Q_TEACHER_OPTION_STATS
  add primary key (ID);
alter table Q_TEACHER_OPTION_STATS
  add constraint FK_45C8U46JYMJUKDGQ9WMG1RBWA foreign key (STATE_ID)
  references Q_QUESTION_DETAIL_STATS (ID);
alter table Q_TEACHER_OPTION_STATS
  add constraint FK_5DXYYIVDCJYFR8A7MB5GERBHR foreign key (OPTION_ID)
  references Q_OPTIONS (ID);

prompt Creating Q_TEXT_EVAL_SWITCHES...
create table Q_TEXT_EVAL_SWITCHES
(
  id                   NUMBER(19) not null,
  close_at             TIMESTAMP(6),
  open_at              TIMESTAMP(6),
  opened               NUMBER(1) not null,
  opened_teacher       NUMBER(1) not null,
  text_evaluate_opened NUMBER(1) not null
)
;
comment on table Q_TEXT_EVAL_SWITCHES
  is '文字评教开关';
comment on column Q_TEXT_EVAL_SWITCHES.id
  is '非业务主键';
comment on column Q_TEXT_EVAL_SWITCHES.close_at
  is '结束时间';
comment on column Q_TEXT_EVAL_SWITCHES.open_at
  is '开始时间';
comment on column Q_TEXT_EVAL_SWITCHES.opened
  is '是否开放';
comment on column Q_TEXT_EVAL_SWITCHES.opened_teacher
  is '是否开放(教师查询)';
comment on column Q_TEXT_EVAL_SWITCHES.text_evaluate_opened
  is '是否开放(文字评教)';
alter table Q_TEXT_EVAL_SWITCHES
  add primary key (ID);

prompt Creating SE_DATA_RESOURCES...
create table SE_DATA_RESOURCES
(
  id      NUMBER(10) not null,
  actions VARCHAR2(100 CHAR),
  enabled NUMBER(1) not null,
  name    VARCHAR2(100 CHAR) not null,
  remark  VARCHAR2(100 CHAR),
  title   VARCHAR2(100 CHAR) not null
)
;
comment on table SE_DATA_RESOURCES
  is '系统数据资源';
comment on column SE_DATA_RESOURCES.id
  is '非业务主键';
comment on column SE_DATA_RESOURCES.actions
  is '允许的操作';
comment on column SE_DATA_RESOURCES.enabled
  is '模块是否可用';
comment on column SE_DATA_RESOURCES.name
  is '类型/名称';
comment on column SE_DATA_RESOURCES.remark
  is '简单描述';
comment on column SE_DATA_RESOURCES.title
  is '标题';
alter table SE_DATA_RESOURCES
  add primary key (ID);
alter table SE_DATA_RESOURCES
  add constraint UK_PGFRY8KHX8RB3XXQ33OTCWVQW unique (NAME);

prompt Creating SE_DATA_FIELDS...
create table SE_DATA_FIELDS
(
  id          NUMBER(10) not null,
  name        VARCHAR2(50 CHAR) not null,
  title       VARCHAR2(50 CHAR) not null,
  type_name   VARCHAR2(100 CHAR) not null,
  resource_id NUMBER(10) not null
)
;
comment on table SE_DATA_FIELDS
  is '系统数据属性';
comment on column SE_DATA_FIELDS.id
  is '非业务主键';
comment on column SE_DATA_FIELDS.name
  is '名称';
comment on column SE_DATA_FIELDS.title
  is '标题';
comment on column SE_DATA_FIELDS.resource_id
  is '数据资源 ID ###引用表名是SE_DATA_RESOURCES### ';
alter table SE_DATA_FIELDS
  add primary key (ID);
alter table SE_DATA_FIELDS
  add constraint FK_H56K6DSDFHCPIG80ETWYN8GR5 foreign key (RESOURCE_ID)
  references SE_DATA_RESOURCES (ID);

prompt Creating SE_FUNC_RESOURCES...
create table SE_FUNC_RESOURCES
(
  id      NUMBER(10) not null,
  actions VARCHAR2(100 CHAR),
  enabled NUMBER(1) not null,
  entry   NUMBER(1) not null,
  name    VARCHAR2(100 CHAR) not null,
  remark  VARCHAR2(100 CHAR),
  scope   NUMBER(10) not null,
  title   VARCHAR2(100 CHAR) not null
)
;
comment on table SE_FUNC_RESOURCES
  is '系统功能资源';
comment on column SE_FUNC_RESOURCES.id
  is '非业务主键';
comment on column SE_FUNC_RESOURCES.actions
  is '允许的操作';
comment on column SE_FUNC_RESOURCES.enabled
  is '模块是否可用';
comment on column SE_FUNC_RESOURCES.entry
  is '是否为入口';
comment on column SE_FUNC_RESOURCES.name
  is '模块名字';
comment on column SE_FUNC_RESOURCES.remark
  is '简单描述';
comment on column SE_FUNC_RESOURCES.scope
  is '资源访问范围';
comment on column SE_FUNC_RESOURCES.title
  is '模块标题';
alter table SE_FUNC_RESOURCES
  add primary key (ID);
alter table SE_FUNC_RESOURCES
  add constraint UK_TLBDW34DFLB9XDOUKYJW1265Q unique (NAME);

prompt Creating SE_ROLES...
create table SE_ROLES
(
  id         NUMBER(10) not null,
  indexno    VARCHAR2(30 CHAR) not null,
  created_at TIMESTAMP(6),
  enabled    NUMBER(1) not null,
  name       VARCHAR2(100 CHAR) not null,
  remark     VARCHAR2(100 CHAR),
  updated_at TIMESTAMP(6),
  parent_id  NUMBER(10),
  owner_id   NUMBER(19) not null
)
;
comment on table SE_ROLES
  is '角色信息';
comment on column SE_ROLES.id
  is '非业务主键';
comment on column SE_ROLES.indexno
  is '顺序号';
comment on column SE_ROLES.created_at
  is '创建时间';
comment on column SE_ROLES.enabled
  is '是否启用';
comment on column SE_ROLES.name
  is '名称';
comment on column SE_ROLES.remark
  is '备注';
comment on column SE_ROLES.updated_at
  is '最后修改时间';
comment on column SE_ROLES.parent_id
  is '上级 ID ###引用表名是SE_ROLES### ';
comment on column SE_ROLES.owner_id
  is '创建人 ID ###引用表名是SE_USERS### ';
alter table SE_ROLES
  add primary key (ID);
alter table SE_ROLES
  add constraint UK_9ORWF8TT9X9IFNJ1FVS7B101L unique (NAME);
alter table SE_ROLES
  add constraint FK_1WMFF6Q01PG42V3GBCP27QKQA foreign key (OWNER_ID)
  references SE_USERS (ID);
alter table SE_ROLES
  add constraint FK_FM9K59S6FPD7CFFLG5P23X9RQ foreign key (PARENT_ID)
  references SE_ROLES (ID);

prompt Creating SE_DATA_PERMISSIONS...
create table SE_DATA_PERMISSIONS
(
  id               NUMBER(10) not null,
  actions          VARCHAR2(100 CHAR),
  attrs            VARCHAR2(300 CHAR),
  effective_at     TIMESTAMP(6),
  filters          VARCHAR2(500 CHAR),
  invalid_at       TIMESTAMP(6),
  remark           VARCHAR2(100 CHAR),
  restrictions     VARCHAR2(500 CHAR),
  func_resource_id NUMBER(10),
  resource_id      NUMBER(10) not null,
  role_id          NUMBER(10)
)
;
comment on table SE_DATA_PERMISSIONS
  is '数据授权实体';
comment on column SE_DATA_PERMISSIONS.id
  is '非业务主键';
comment on column SE_DATA_PERMISSIONS.actions
  is '授权的操作';
comment on column SE_DATA_PERMISSIONS.attrs
  is '能够访问哪些属性';
comment on column SE_DATA_PERMISSIONS.effective_at
  is '生效时间';
comment on column SE_DATA_PERMISSIONS.filters
  is '资源过滤器';
comment on column SE_DATA_PERMISSIONS.invalid_at
  is '失效时间';
comment on column SE_DATA_PERMISSIONS.remark
  is '备注';
comment on column SE_DATA_PERMISSIONS.restrictions
  is '访问满足的检查(入口\人员等)';
comment on column SE_DATA_PERMISSIONS.func_resource_id
  is '功能资源 ID ###引用表名是SE_FUNC_RESOURCES### ';
comment on column SE_DATA_PERMISSIONS.resource_id
  is '数据资源 ID ###引用表名是SE_DATA_RESOURCES### ';
comment on column SE_DATA_PERMISSIONS.role_id
  is '角色 ID ###引用表名是SE_ROLES### ';
alter table SE_DATA_PERMISSIONS
  add primary key (ID);
alter table SE_DATA_PERMISSIONS
  add constraint FK_8M06IJSIJ3RG511VDITSJXGPF foreign key (ROLE_ID)
  references SE_ROLES (ID);
alter table SE_DATA_PERMISSIONS
  add constraint FK_9OEN5BBBIAN58LBOX4R8PFD0O foreign key (RESOURCE_ID)
  references SE_DATA_RESOURCES (ID);
alter table SE_DATA_PERMISSIONS
  add constraint FK_AM86BEAHFG34G8WG1S55OS2NA foreign key (FUNC_RESOURCE_ID)
  references SE_FUNC_RESOURCES (ID);

prompt Creating SE_FIELDS...
create table SE_FIELDS
(
  id         NUMBER(10) not null,
  key_name   VARCHAR2(20 CHAR),
  multiple   NUMBER(1) not null,
  name       VARCHAR2(50 CHAR) not null,
  properties VARCHAR2(100 CHAR),
  required   NUMBER(1) not null,
  source     VARCHAR2(200 CHAR),
  title      VARCHAR2(50 CHAR) not null,
  type_name  VARCHAR2(100 CHAR) not null
)
;
comment on table SE_FIELDS
  is '用户属性元信息';
comment on column SE_FIELDS.id
  is '非业务主键';
comment on column SE_FIELDS.key_name
  is '关键字';
comment on column SE_FIELDS.multiple
  is '能够提供多值';
comment on column SE_FIELDS.name
  is '名称';
comment on column SE_FIELDS.properties
  is '其他属性值';
comment on column SE_FIELDS.required
  is '是否必填项';
comment on column SE_FIELDS.source
  is '数据提供描述';
comment on column SE_FIELDS.title
  is '标题';
comment on column SE_FIELDS.type_name
  is '类型';
alter table SE_FIELDS
  add primary key (ID);
alter table SE_FIELDS
  add constraint UK_RX82E88N4DLTV6TSU30RTP11B unique (NAME);

prompt Creating SE_FUNC_PERMISSIONS...
create table SE_FUNC_PERMISSIONS
(
  id           NUMBER(10) not null,
  actions      VARCHAR2(100 CHAR),
  effective_at TIMESTAMP(6),
  invalid_at   TIMESTAMP(6),
  remark       VARCHAR2(100 CHAR),
  restrictions VARCHAR2(200 CHAR),
  resource_id  NUMBER(10) not null,
  role_id      NUMBER(10) not null
)
;
comment on table SE_FUNC_PERMISSIONS
  is '系统授权实体';
comment on column SE_FUNC_PERMISSIONS.id
  is '非业务主键';
comment on column SE_FUNC_PERMISSIONS.actions
  is '授权的操作';
comment on column SE_FUNC_PERMISSIONS.effective_at
  is '生效时间';
comment on column SE_FUNC_PERMISSIONS.invalid_at
  is '失效时间';
comment on column SE_FUNC_PERMISSIONS.remark
  is '备注';
comment on column SE_FUNC_PERMISSIONS.restrictions
  is '访问检查器';
comment on column SE_FUNC_PERMISSIONS.resource_id
  is '功能资源 ID ###引用表名是SE_FUNC_RESOURCES### ';
comment on column SE_FUNC_PERMISSIONS.role_id
  is '角色 ID ###引用表名是SE_ROLES### ';
alter table SE_FUNC_PERMISSIONS
  add primary key (ID);
alter table SE_FUNC_PERMISSIONS
  add constraint FK_9I115AUX58R3CJPWL06JFJLEF foreign key (RESOURCE_ID)
  references SE_FUNC_RESOURCES (ID);
alter table SE_FUNC_PERMISSIONS
  add constraint FK_FY9ICUGI55G32AFDP7DPYA5TL foreign key (ROLE_ID)
  references SE_ROLES (ID);

prompt Creating SE_MEMBERS...
create table SE_MEMBERS
(
  id         NUMBER(10) not null,
  created_at TIMESTAMP(6),
  updated_at TIMESTAMP(6),
  granter    NUMBER(1) not null,
  manager    NUMBER(1) not null,
  member     NUMBER(1) not null,
  role_id    NUMBER(10) not null,
  user_id    NUMBER(19) not null
)
;
comment on table SE_MEMBERS
  is '角色成员关系';
comment on column SE_MEMBERS.id
  is '非业务主键';
comment on column SE_MEMBERS.created_at
  is '创建时间';
comment on column SE_MEMBERS.updated_at
  is '更新时间';
comment on column SE_MEMBERS.granter
  is '用户是否能将该组授权给他人';
comment on column SE_MEMBERS.manager
  is '用户是否是该组的管理者';
comment on column SE_MEMBERS.member
  is '用户是否是该组的成员';
comment on column SE_MEMBERS.role_id
  is '角色 ID ###引用表名是SE_ROLES### ';
comment on column SE_MEMBERS.user_id
  is '用户 ID ###引用表名是SE_USERS### ';
alter table SE_MEMBERS
  add primary key (ID);
alter table SE_MEMBERS
  add constraint FK_7G5E95B6MMM9A70F1ENMK6GU3 foreign key (ROLE_ID)
  references SE_ROLES (ID);
alter table SE_MEMBERS
  add constraint FK_A8DI0SFU8K3KS3BWYWT2UHKLJ foreign key (USER_ID)
  references SE_USERS (ID);

prompt Creating SE_MENU_PROFILES...
create table SE_MENU_PROFILES
(
  id      NUMBER(10) not null,
  enabled NUMBER(1) not null,
  name    VARCHAR2(50 CHAR) not null,
  role_id NUMBER(10) not null
)
;
comment on table SE_MENU_PROFILES
  is '菜单配置';
comment on column SE_MENU_PROFILES.id
  is '非业务主键';
comment on column SE_MENU_PROFILES.enabled
  is '是否启用';
comment on column SE_MENU_PROFILES.name
  is '菜单配置名称';
comment on column SE_MENU_PROFILES.role_id
  is '角色 ID ###引用表名是SE_ROLES### ';
alter table SE_MENU_PROFILES
  add primary key (ID);
alter table SE_MENU_PROFILES
  add constraint UK_FOM97JEHVB7JH0646VCEXWAG unique (NAME);
alter table SE_MENU_PROFILES
  add constraint FK_8Q0PRYLHF9TNL5E8JU2RNSAG4 foreign key (ROLE_ID)
  references SE_ROLES (ID);

prompt Creating SE_MENUS...
create table SE_MENUS
(
  id         NUMBER(10) not null,
  indexno    VARCHAR2(30 CHAR) not null,
  enabled    NUMBER(1) not null,
  entry      VARCHAR2(255 CHAR),
  name       VARCHAR2(100 CHAR) not null,
  remark     VARCHAR2(255 CHAR),
  title      VARCHAR2(100 CHAR) not null,
  parent_id  NUMBER(10),
  profile_id NUMBER(10) not null
)
;
comment on table SE_MENUS
  is '系统菜单';
comment on column SE_MENUS.id
  is '非业务主键';
comment on column SE_MENUS.indexno
  is '顺序号';
comment on column SE_MENUS.enabled
  is '是否启用';
comment on column SE_MENUS.entry
  is '菜单入口';
comment on column SE_MENUS.name
  is '菜单名称';
comment on column SE_MENUS.remark
  is '菜单备注';
comment on column SE_MENUS.title
  is '菜单标题';
comment on column SE_MENUS.parent_id
  is '上级 ID ###引用表名是SE_MENUS### ';
comment on column SE_MENUS.profile_id
  is '菜单配置 ID ###引用表名是SE_MENU_PROFILES### ';
alter table SE_MENUS
  add primary key (ID);
alter table SE_MENUS
  add constraint FK_EPKSU8LGD3H8WADNBBOT7B7RX foreign key (PARENT_ID)
  references SE_MENUS (ID);
alter table SE_MENUS
  add constraint FK_KR1D2WBJWUGMMSLK9TTLQE8HF foreign key (PROFILE_ID)
  references SE_MENU_PROFILES (ID);

prompt Creating SE_MENUS_RESOURCES...
create table SE_MENUS_RESOURCES
(
  menu_id          NUMBER(10) not null,
  func_resource_id NUMBER(10) not null
)
;
comment on table SE_MENUS_RESOURCES
  is '系统菜单-引用资源集合';
comment on column SE_MENUS_RESOURCES.menu_id
  is '系统菜单 ID ###引用表名是SE_MENUS### ';
comment on column SE_MENUS_RESOURCES.func_resource_id
  is '系统功能资源 ID ###引用表名是SE_FUNC_RESOURCES### ';
alter table SE_MENUS_RESOURCES
  add primary key (MENU_ID, FUNC_RESOURCE_ID);
alter table SE_MENUS_RESOURCES
  add constraint FK_40U625N8W9CLBSGGQNKL2E98N foreign key (FUNC_RESOURCE_ID)
  references SE_FUNC_RESOURCES (ID);
alter table SE_MENUS_RESOURCES
  add constraint FK_7E3OKGPHH4XG8FC1B4TJA9Y4C foreign key (MENU_ID)
  references SE_MENUS (ID);

prompt Creating SE_ROLE_PROPERTIES...
create table SE_ROLE_PROPERTIES
(
  id       NUMBER(10) not null,
  value    VARCHAR2(1000 CHAR) not null,
  field_id NUMBER(10) not null,
  role_id  NUMBER(10) not null
)
;
comment on table SE_ROLE_PROPERTIES
  is '角色属性';
comment on column SE_ROLE_PROPERTIES.id
  is '非业务主键';
comment on column SE_ROLE_PROPERTIES.value
  is '值';
comment on column SE_ROLE_PROPERTIES.field_id
  is '属性元 ID ###引用表名是SE_PROFILE_FIELDS### ';
alter table SE_ROLE_PROPERTIES
  add primary key (ID);
alter table SE_ROLE_PROPERTIES
  add constraint FK_ITX1FLC0IAKWU0O0L1DRUEDJS foreign key (FIELD_ID)
  references SE_FIELDS (ID);
alter table SE_ROLE_PROPERTIES
  add constraint FK_SC78BEIW0YV3S757Q8ONMOV28 foreign key (ROLE_ID)
  references SE_ROLES (ID);

prompt Creating SE_SESSION_PROFILES...
create table SE_SESSION_PROFILES
(
  id                NUMBER(10) not null,
  capacity          NUMBER(10) not null,
  inactive_interval NUMBER(5) not null,
  user_max_sessions NUMBER(5) not null,
  role_id           NUMBER(10) not null
)
;
comment on table SE_SESSION_PROFILES
  is '角色会话配置';
comment on column SE_SESSION_PROFILES.id
  is '非业务主键';
comment on column SE_SESSION_PROFILES.capacity
  is '最大在线人数';
comment on column SE_SESSION_PROFILES.inactive_interval
  is '不操作过期时间(以分为单位)';
comment on column SE_SESSION_PROFILES.user_max_sessions
  is '单用户的同时最大会话数';
comment on column SE_SESSION_PROFILES.role_id
  is '角色 ID ###引用表名是SE_ROLES### ';
alter table SE_SESSION_PROFILES
  add primary key (ID);
alter table SE_SESSION_PROFILES
  add constraint FK_9HFU5IDUR1N4NAPH7VTXWWUE2 foreign key (ROLE_ID)
  references SE_ROLES (ID);

prompt Creating SE_USER_PROFILES...
create table SE_USER_PROFILES
(
  id      NUMBER(19) not null,
  user_id NUMBER(19)
)
;
comment on table SE_USER_PROFILES
  is '用户配置';
comment on column SE_USER_PROFILES.id
  is '非业务主键';
comment on column SE_USER_PROFILES.user_id
  is '用户 ID ###引用表名是SE_USERS### ';
alter table SE_USER_PROFILES
  add primary key (ID);
alter table SE_USER_PROFILES
  add constraint FK_PLDW9Q5UI8I2EI0P6W341LBYV foreign key (USER_ID)
  references SE_USERS (ID);

prompt Creating SE_USER_PROPERTIES...
create table SE_USER_PROPERTIES
(
  id         NUMBER(19) not null,
  value      VARCHAR2(4000 CHAR),
  field_id   NUMBER(10) not null,
  profile_id NUMBER(19) not null
)
;
comment on table SE_USER_PROPERTIES
  is '数据限制域';
comment on column SE_USER_PROPERTIES.id
  is '非业务主键';
comment on column SE_USER_PROPERTIES.value
  is '值';
comment on column SE_USER_PROPERTIES.field_id
  is '属性元 ID ###引用表名是SE_PROFILE_FIELDS### ';
comment on column SE_USER_PROPERTIES.profile_id
  is '用户属性配置 ID ###引用表名是SE_USER_PROFILES### ';
alter table SE_USER_PROPERTIES
  add primary key (ID);
alter table SE_USER_PROPERTIES
  add constraint FK_Q90OBLGDOKSU5MIJ7OV9SC8U foreign key (FIELD_ID)
  references SE_FIELDS (ID);
alter table SE_USER_PROPERTIES
  add constraint FK_TBPOX15SFJFPU0EUSPKMEOLUF foreign key (PROFILE_ID)
  references SE_USER_PROFILES (ID);

prompt Creating ST_CHECKINS...
create table ST_CHECKINS
(
  id           NUMBER(19) not null,
  checkin_at   TIMESTAMP(6),
  checkin_by   VARCHAR2(50 CHAR),
  checkin_from VARCHAR2(50 CHAR),
  whereabouts  VARCHAR2(100 CHAR),
  reason_id    NUMBER(10),
  semester_id  NUMBER(10) not null,
  std_id       NUMBER(19) not null
)
;
comment on table ST_CHECKINS
  is '学生报到信息';
comment on column ST_CHECKINS.id
  is '非业务主键';
comment on column ST_CHECKINS.checkin_at
  is '报到时间';
comment on column ST_CHECKINS.checkin_by
  is '操作人';
comment on column ST_CHECKINS.checkin_from
  is '操作ip';
comment on column ST_CHECKINS.whereabouts
  is '未报到去向';
comment on column ST_CHECKINS.reason_id
  is '未报到原因 ID ###引用表名是HB_UNCHECKIN_REASONS### ';
comment on column ST_CHECKINS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
comment on column ST_CHECKINS.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table ST_CHECKINS
  add primary key (ID);
alter table ST_CHECKINS
  add constraint UK_EDMID6P988R6BLXOQVITUMPCX unique (SEMESTER_ID, STD_ID);
alter table ST_CHECKINS
  add constraint FK_DLB8UA8DUH93KFSW4SN1UX0Q9 foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table ST_CHECKINS
  add constraint FK_I3XDND6RA966W988O1JTHC7I8 foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table ST_CHECKINS
  add constraint FK_PRTMY3JJ6EG6Q3YTLTA3MKCHK foreign key (REASON_ID)
  references HB_UNCHECKIN_REASONS (ID);

prompt Creating ST_DA_SEASONS...
create table ST_DA_SEASONS
(
  id           NUMBER(19) not null,
  effective_at TIMESTAMP(6) not null,
  invalid_at   TIMESTAMP(6) not null,
  name         VARCHAR2(255 CHAR) not null,
  remark       VARCHAR2(4000 CHAR),
  grades       VARCHAR2(255 CHAR),
  project_id   NUMBER(10)
)
;
comment on table ST_DA_SEASONS
  is '学位申请批次';
comment on column ST_DA_SEASONS.id
  is '非业务主键';
comment on column ST_DA_SEASONS.effective_at
  is '生效时间';
comment on column ST_DA_SEASONS.invalid_at
  is '失效时间';
comment on column ST_DA_SEASONS.name
  is '名称';
comment on column ST_DA_SEASONS.remark
  is '备注';
comment on column ST_DA_SEASONS.grades
  is '年级';
comment on column ST_DA_SEASONS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
alter table ST_DA_SEASONS
  add primary key (ID);
alter table ST_DA_SEASONS
  add constraint FK_Q0F37SWK58TKRRCAB58RRH9YX foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating ST_DA_APPLIES...
create table ST_DA_APPLIES
(
  id        NUMBER(19) not null,
  apply_at  TIMESTAMP(6) not null,
  passed    NUMBER(1),
  published NUMBER(1) not null,
  remark    VARCHAR2(4000 CHAR),
  season_id NUMBER(19) not null,
  std_id    NUMBER(19) not null
)
;
comment on table ST_DA_APPLIES
  is '学位申请';
comment on column ST_DA_APPLIES.id
  is '非业务主键';
comment on column ST_DA_APPLIES.apply_at
  is '何时申请';
comment on column ST_DA_APPLIES.passed
  is '是否通过';
comment on column ST_DA_APPLIES.published
  is '是否已发布';
comment on column ST_DA_APPLIES.remark
  is '备注';
comment on column ST_DA_APPLIES.season_id
  is '批次 ID ###引用表名是ST_DA_SEASONS### ';
comment on column ST_DA_APPLIES.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table ST_DA_APPLIES
  add primary key (ID);
alter table ST_DA_APPLIES
  add constraint UK_QADIA5C7MOKN8EATXLTVQ2MD3 unique (SEASON_ID, STD_ID);
alter table ST_DA_APPLIES
  add constraint FK_96344C6BMIFA1RJK2Q568OOL7 foreign key (SEASON_ID)
  references ST_DA_SEASONS (ID);
alter table ST_DA_APPLIES
  add constraint FK_QQDTTTQGWXFE9F05NQ1XVKP9W foreign key (STD_ID)
  references C_STUDENTS (ID);

prompt Creating ST_DA_ITEM_RESULTS...
create table ST_DA_ITEM_RESULTS
(
  id       NUMBER(19) not null,
  eng_name VARCHAR2(400 CHAR) not null,
  name     VARCHAR2(255 CHAR) not null,
  passed   NUMBER(1),
  result   VARCHAR2(500 CHAR),
  apply_id NUMBER(19) not null
)
;
comment on table ST_DA_ITEM_RESULTS
  is '学位审核条目结果';
comment on column ST_DA_ITEM_RESULTS.id
  is '非业务主键';
comment on column ST_DA_ITEM_RESULTS.eng_name
  is '项目英文名称';
comment on column ST_DA_ITEM_RESULTS.name
  is '项目名称';
comment on column ST_DA_ITEM_RESULTS.passed
  is '是否通过';
comment on column ST_DA_ITEM_RESULTS.result
  is '具体状态信息';
comment on column ST_DA_ITEM_RESULTS.apply_id
  is '学位申请 ID ###引用表名是ST_DA_APPLIES### ';
alter table ST_DA_ITEM_RESULTS
  add primary key (ID);
alter table ST_DA_ITEM_RESULTS
  add constraint FK_200X66314DPYP6O3BVNC08BBY foreign key (APPLY_ID)
  references ST_DA_APPLIES (ID);

prompt Creating ST_DA_LOGS...
create table ST_DA_LOGS
(
  id            NUMBER(19) not null,
  audit_by      VARCHAR2(255 CHAR) not null,
  detail        VARCHAR2(4000 CHAR),
  ip            VARCHAR2(255 CHAR) not null,
  operate_at    TIMESTAMP(6) not null,
  passed        NUMBER(1) not null,
  season        VARCHAR2(255 CHAR) not null,
  standard_used VARCHAR2(500 CHAR) not null,
  std_id        NUMBER(19) not null
)
;
comment on table ST_DA_LOGS
  is '学位审核日志';
comment on column ST_DA_LOGS.id
  is '非业务主键';
comment on column ST_DA_LOGS.audit_by
  is '审核人';
comment on column ST_DA_LOGS.detail
  is '各项详细审核结果，要包括是否自动';
comment on column ST_DA_LOGS.ip
  is '审核的IP地址';
comment on column ST_DA_LOGS.operate_at
  is '操作时间';
comment on column ST_DA_LOGS.passed
  is '是否通过';
comment on column ST_DA_LOGS.season
  is '学位申请批次名称';
comment on column ST_DA_LOGS.standard_used
  is '学位审核时所用的标准';
comment on column ST_DA_LOGS.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table ST_DA_LOGS
  add primary key (ID);
alter table ST_DA_LOGS
  add constraint FK_ADCOP10SKQ7BOOBUBTKDT7HK7 foreign key (STD_ID)
  references C_STUDENTS (ID);

prompt Creating ST_DA_SEASONS_DEPARTMENTS...
create table ST_DA_SEASONS_DEPARTMENTS
(
  season_id     NUMBER(19) not null,
  department_id NUMBER(10) not null
)
;
comment on table ST_DA_SEASONS_DEPARTMENTS
  is '学位申请批次-部门集合';
comment on column ST_DA_SEASONS_DEPARTMENTS.season_id
  is '学位申请批次 ID ###引用表名是ST_DA_SEASONS### ';
comment on column ST_DA_SEASONS_DEPARTMENTS.department_id
  is '部门组织机构信息 ID ###引用表名是C_DEPARTMENTS### ';
alter table ST_DA_SEASONS_DEPARTMENTS
  add primary key (SEASON_ID, DEPARTMENT_ID);
alter table ST_DA_SEASONS_DEPARTMENTS
  add constraint FK_PNU5LC3YSTT1MIK108OY02EXV foreign key (SEASON_ID)
  references ST_DA_SEASONS (ID);
alter table ST_DA_SEASONS_DEPARTMENTS
  add constraint FK_T9IL5F7FN65R4PQ2G62UWD05H foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);

prompt Creating ST_DA_SEASONS_DIRECTIONS...
create table ST_DA_SEASONS_DIRECTIONS
(
  season_id    NUMBER(19) not null,
  direction_id NUMBER(10) not null
)
;
comment on table ST_DA_SEASONS_DIRECTIONS
  is '学位申请批次-专业方向集合';
comment on column ST_DA_SEASONS_DIRECTIONS.season_id
  is '学位申请批次 ID ###引用表名是ST_DA_SEASONS### ';
comment on column ST_DA_SEASONS_DIRECTIONS.direction_id
  is '方向信息 专业领域. ID ###引用表名是C_DIRECTIONS### ';
alter table ST_DA_SEASONS_DIRECTIONS
  add primary key (SEASON_ID, DIRECTION_ID);
alter table ST_DA_SEASONS_DIRECTIONS
  add constraint FK_7NGYC06NMK6M5EBBGNSL35HPJ foreign key (SEASON_ID)
  references ST_DA_SEASONS (ID);
alter table ST_DA_SEASONS_DIRECTIONS
  add constraint FK_8T4RVJNJJDRHSFFDV9WW704YD foreign key (DIRECTION_ID)
  references C_DIRECTIONS (ID);

prompt Creating ST_DA_SEASONS_EDUCATIONS...
create table ST_DA_SEASONS_EDUCATIONS
(
  season_id    NUMBER(19) not null,
  education_id NUMBER(10) not null
)
;
comment on table ST_DA_SEASONS_EDUCATIONS
  is '学位申请批次-培养层次集合';
comment on column ST_DA_SEASONS_EDUCATIONS.season_id
  is '学位申请批次 ID ###引用表名是ST_DA_SEASONS### ';
comment on column ST_DA_SEASONS_EDUCATIONS.education_id
  is '学历层次 ID ###引用表名是HB_EDUCATIONS### ';
alter table ST_DA_SEASONS_EDUCATIONS
  add primary key (SEASON_ID, EDUCATION_ID);
alter table ST_DA_SEASONS_EDUCATIONS
  add constraint FK_K6ILK1T667BWBQKH8R561HEO9 foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);
alter table ST_DA_SEASONS_EDUCATIONS
  add constraint FK_RFJRXT2C9U310FNL8BVU0IMVJ foreign key (SEASON_ID)
  references ST_DA_SEASONS (ID);

prompt Creating ST_DA_SEASONS_MAJORS...
create table ST_DA_SEASONS_MAJORS
(
  season_id NUMBER(19) not null,
  major_id  NUMBER(10) not null
)
;
comment on table ST_DA_SEASONS_MAJORS
  is '学位申请批次-专业集合';
comment on column ST_DA_SEASONS_MAJORS.season_id
  is '学位申请批次 ID ###引用表名是ST_DA_SEASONS### ';
comment on column ST_DA_SEASONS_MAJORS.major_id
  is '专业 ID ###引用表名是C_MAJORS### ';
alter table ST_DA_SEASONS_MAJORS
  add primary key (SEASON_ID, MAJOR_ID);
alter table ST_DA_SEASONS_MAJORS
  add constraint FK_E0WQ0GNVPLI5TYBKU8N0JESOE foreign key (SEASON_ID)
  references ST_DA_SEASONS (ID);
alter table ST_DA_SEASONS_MAJORS
  add constraint FK_NCUE8DT9QW7TGM0QO5FWOIFGN foreign key (MAJOR_ID)
  references C_MAJORS (ID);

prompt Creating ST_DA_SEASONS_SEASONS...
create table ST_DA_SEASONS_SEASONS
(
  season_id     NUMBER(19) not null,
  old_season_id NUMBER(19) not null
)
;
comment on table ST_DA_SEASONS_SEASONS
  is '学位申请批次-过往的批次';
comment on column ST_DA_SEASONS_SEASONS.season_id
  is '学位申请批次 ID ###引用表名是ST_DA_SEASONS### ';
comment on column ST_DA_SEASONS_SEASONS.old_season_id
  is '学位申请批次 ID ###引用表名是ST_DA_SEASONS### ';
alter table ST_DA_SEASONS_SEASONS
  add primary key (SEASON_ID, OLD_SEASON_ID);
alter table ST_DA_SEASONS_SEASONS
  add constraint FK_8YHFDH5UYFK1F0Q3HYSKC22G5 foreign key (OLD_SEASON_ID)
  references ST_DA_SEASONS (ID);
alter table ST_DA_SEASONS_SEASONS
  add constraint FK_RHA8E3UEM3P2QRF2OPX96TOMM foreign key (SEASON_ID)
  references ST_DA_SEASONS (ID);

prompt Creating ST_DA_SEASONS_STD_TYPES...
create table ST_DA_SEASONS_STD_TYPES
(
  season_id   NUMBER(19) not null,
  std_type_id NUMBER(10) not null
)
;
comment on table ST_DA_SEASONS_STD_TYPES
  is '学位申请批次-学生类别集合';
comment on column ST_DA_SEASONS_STD_TYPES.season_id
  is '学位申请批次 ID ###引用表名是ST_DA_SEASONS### ';
comment on column ST_DA_SEASONS_STD_TYPES.std_type_id
  is '学生类别 ID ###引用表名是XB_STD_TYPES### ';
alter table ST_DA_SEASONS_STD_TYPES
  add primary key (SEASON_ID, STD_TYPE_ID);
alter table ST_DA_SEASONS_STD_TYPES
  add constraint FK_GLRYIM2V54EEO9UTFC7S30QKN foreign key (SEASON_ID)
  references ST_DA_SEASONS (ID);
alter table ST_DA_SEASONS_STD_TYPES
  add constraint FK_PK91HBYD7L42QMS20H4VY1NNF foreign key (STD_TYPE_ID)
  references XB_STD_TYPES (ID);

prompt Creating ST_DA_STANDARDS...
create table ST_DA_STANDARDS
(
  id           NUMBER(19) not null,
  effective_at TIMESTAMP(6) not null,
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(500 CHAR) not null,
  remark       VARCHAR2(4000 CHAR),
  grades       VARCHAR2(255 CHAR),
  project_id   NUMBER(10)
)
;
comment on table ST_DA_STANDARDS
  is '学位审核标准';
comment on column ST_DA_STANDARDS.id
  is '非业务主键';
comment on column ST_DA_STANDARDS.effective_at
  is '生效日期';
comment on column ST_DA_STANDARDS.invalid_at
  is '失效日期';
comment on column ST_DA_STANDARDS.name
  is '名称';
comment on column ST_DA_STANDARDS.remark
  is '备注';
comment on column ST_DA_STANDARDS.grades
  is '年级';
comment on column ST_DA_STANDARDS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
alter table ST_DA_STANDARDS
  add primary key (ID);
alter table ST_DA_STANDARDS
  add constraint FK_T0QO0OV1FGL5ILQIWBXH1J0RW foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating ST_DA_STANDARDS_DEPARTMENTS...
create table ST_DA_STANDARDS_DEPARTMENTS
(
  standard_id   NUMBER(19) not null,
  department_id NUMBER(10) not null
)
;
comment on table ST_DA_STANDARDS_DEPARTMENTS
  is '学位审核标准-部门集合';
comment on column ST_DA_STANDARDS_DEPARTMENTS.standard_id
  is '学位审核标准 ID ###引用表名是ST_DA_STANDARDS### ';
comment on column ST_DA_STANDARDS_DEPARTMENTS.department_id
  is '部门组织机构信息 ID ###引用表名是C_DEPARTMENTS### ';
alter table ST_DA_STANDARDS_DEPARTMENTS
  add primary key (STANDARD_ID, DEPARTMENT_ID);
alter table ST_DA_STANDARDS_DEPARTMENTS
  add constraint FK_FIBHCF0V7Y06MMJYSKL9EJO0W foreign key (STANDARD_ID)
  references ST_DA_STANDARDS (ID);
alter table ST_DA_STANDARDS_DEPARTMENTS
  add constraint FK_MNNUAC7LHGNGFQOFI2VYMH3S0 foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);

prompt Creating ST_DA_STANDARDS_DIRECTIONS...
create table ST_DA_STANDARDS_DIRECTIONS
(
  standard_id  NUMBER(19) not null,
  direction_id NUMBER(10) not null
)
;
comment on table ST_DA_STANDARDS_DIRECTIONS
  is '学位审核标准-专业方向集合';
comment on column ST_DA_STANDARDS_DIRECTIONS.standard_id
  is '学位审核标准 ID ###引用表名是ST_DA_STANDARDS### ';
comment on column ST_DA_STANDARDS_DIRECTIONS.direction_id
  is '方向信息 专业领域. ID ###引用表名是C_DIRECTIONS### ';
alter table ST_DA_STANDARDS_DIRECTIONS
  add primary key (STANDARD_ID, DIRECTION_ID);
alter table ST_DA_STANDARDS_DIRECTIONS
  add constraint FK_5L2DMXI8SXUWQVH7SXTQ1SPTO foreign key (DIRECTION_ID)
  references C_DIRECTIONS (ID);
alter table ST_DA_STANDARDS_DIRECTIONS
  add constraint FK_HTX2IA7R8TT6Q7YRKX7CDISDT foreign key (STANDARD_ID)
  references ST_DA_STANDARDS (ID);

prompt Creating ST_DA_STANDARDS_EDUCATIONS...
create table ST_DA_STANDARDS_EDUCATIONS
(
  standard_id  NUMBER(19) not null,
  education_id NUMBER(10) not null
)
;
comment on table ST_DA_STANDARDS_EDUCATIONS
  is '学位审核标准-培养层次集合';
comment on column ST_DA_STANDARDS_EDUCATIONS.standard_id
  is '学位审核标准 ID ###引用表名是ST_DA_STANDARDS### ';
comment on column ST_DA_STANDARDS_EDUCATIONS.education_id
  is '学历层次 ID ###引用表名是HB_EDUCATIONS### ';
alter table ST_DA_STANDARDS_EDUCATIONS
  add primary key (STANDARD_ID, EDUCATION_ID);
alter table ST_DA_STANDARDS_EDUCATIONS
  add constraint FK_CKMXJ9GCYWXHVQ5I2RCAOMSL8 foreign key (STANDARD_ID)
  references ST_DA_STANDARDS (ID);
alter table ST_DA_STANDARDS_EDUCATIONS
  add constraint FK_LVPBU9P1LQ9ON9TI9X82KX6P0 foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);

prompt Creating ST_DA_STANDARDS_MAJORS...
create table ST_DA_STANDARDS_MAJORS
(
  standard_id NUMBER(19) not null,
  major_id    NUMBER(10) not null
)
;
comment on table ST_DA_STANDARDS_MAJORS
  is '学位审核标准-专业集合';
comment on column ST_DA_STANDARDS_MAJORS.standard_id
  is '学位审核标准 ID ###引用表名是ST_DA_STANDARDS### ';
comment on column ST_DA_STANDARDS_MAJORS.major_id
  is '专业 ID ###引用表名是C_MAJORS### ';
alter table ST_DA_STANDARDS_MAJORS
  add primary key (STANDARD_ID, MAJOR_ID);
alter table ST_DA_STANDARDS_MAJORS
  add constraint FK_8BJAEUJO2PNY6DN0A44JMQMHR foreign key (STANDARD_ID)
  references ST_DA_STANDARDS (ID);
alter table ST_DA_STANDARDS_MAJORS
  add constraint FK_N2LLTU4AHP19EDTDJCFJEISJQ foreign key (MAJOR_ID)
  references C_MAJORS (ID);

prompt Creating SYS_RULES...
create table SYS_RULES
(
  id           NUMBER(10) not null,
  created_at   TIMESTAMP(6),
  updated_at   TIMESTAMP(6),
  business     VARCHAR2(100 CHAR) not null,
  description  VARCHAR2(300 CHAR) not null,
  enabled      NUMBER(1) not null,
  factory      VARCHAR2(50 CHAR) not null,
  name         VARCHAR2(100 CHAR) not null,
  service_name VARCHAR2(80 CHAR) not null
)
;
comment on table SYS_RULES
  is '规则';
comment on column SYS_RULES.id
  is '非业务主键';
comment on column SYS_RULES.created_at
  is '创建时间';
comment on column SYS_RULES.updated_at
  is '更新时间';
comment on column SYS_RULES.business
  is '适用业务';
comment on column SYS_RULES.description
  is '规则描述';
comment on column SYS_RULES.enabled
  is '是否启用';
comment on column SYS_RULES.factory
  is '规则管理容器';
comment on column SYS_RULES.name
  is '规则名称';
comment on column SYS_RULES.service_name
  is '规则服务名';
alter table SYS_RULES
  add primary key (ID);
alter table SYS_RULES
  add constraint UK_4G6D6FYNLY41YWY4QD0QJQ7B0 unique (NAME);

prompt Creating SYS_RULE_CONFIGS...
create table SYS_RULE_CONFIGS
(
  id         NUMBER(10) not null,
  created_at TIMESTAMP(6),
  updated_at TIMESTAMP(6),
  enabled    NUMBER(1) not null,
  name       VARCHAR2(150 CHAR),
  rule_id    NUMBER(10) not null
)
;
comment on table SYS_RULE_CONFIGS
  is '规则配置';
comment on column SYS_RULE_CONFIGS.id
  is '非业务主键';
comment on column SYS_RULE_CONFIGS.created_at
  is '创建时间';
comment on column SYS_RULE_CONFIGS.updated_at
  is '更新时间';
comment on column SYS_RULE_CONFIGS.enabled
  is '是否启用';
comment on column SYS_RULE_CONFIGS.rule_id
  is '业务规则 ID ###引用表名是SYS_RULES### ';
alter table SYS_RULE_CONFIGS
  add primary key (ID);
alter table SYS_RULE_CONFIGS
  add constraint FK_O2H5SP9X9CKT4RGCCSR0005IY foreign key (RULE_ID)
  references SYS_RULES (ID);

prompt Creating ST_DA_STANDARDS_RULE_CFGS...
create table ST_DA_STANDARDS_RULE_CFGS
(
  standard_id    NUMBER(19) not null,
  rule_config_id NUMBER(10) not null
)
;
comment on table ST_DA_STANDARDS_RULE_CFGS
  is '学位审核标准-审核项目';
comment on column ST_DA_STANDARDS_RULE_CFGS.standard_id
  is '学位审核标准 ID ###引用表名是ST_DA_STANDARDS### ';
comment on column ST_DA_STANDARDS_RULE_CFGS.rule_config_id
  is '规则配置 ID ###引用表名是SYS_RULE_CONFIGS### ';
alter table ST_DA_STANDARDS_RULE_CFGS
  add primary key (STANDARD_ID, RULE_CONFIG_ID);
alter table ST_DA_STANDARDS_RULE_CFGS
  add constraint FK_KNIO5NERIT99O9U11IIGSV3XD foreign key (STANDARD_ID)
  references ST_DA_STANDARDS (ID);
alter table ST_DA_STANDARDS_RULE_CFGS
  add constraint FK_O2C56Y5EO1SNXA53DFU84KP3V foreign key (RULE_CONFIG_ID)
  references SYS_RULE_CONFIGS (ID);

prompt Creating ST_DA_STANDARDS_STD_TYPES...
create table ST_DA_STANDARDS_STD_TYPES
(
  standard_id NUMBER(19) not null,
  std_type_id NUMBER(10) not null
)
;
comment on table ST_DA_STANDARDS_STD_TYPES
  is '学位审核标准-学生类别集合';
comment on column ST_DA_STANDARDS_STD_TYPES.standard_id
  is '学位审核标准 ID ###引用表名是ST_DA_STANDARDS### ';
comment on column ST_DA_STANDARDS_STD_TYPES.std_type_id
  is '学生类别 ID ###引用表名是XB_STD_TYPES### ';
alter table ST_DA_STANDARDS_STD_TYPES
  add primary key (STANDARD_ID, STD_TYPE_ID);
alter table ST_DA_STANDARDS_STD_TYPES
  add constraint FK_FGQ64NCG60Q1AXKYKTB5XUQPU foreign key (STD_TYPE_ID)
  references XB_STD_TYPES (ID);
alter table ST_DA_STANDARDS_STD_TYPES
  add constraint FK_J7W7IBPM0DVLW5024MUPVBTL6 foreign key (STANDARD_ID)
  references ST_DA_STANDARDS (ID);

prompt Creating ST_GA_SEASONS...
create table ST_GA_SEASONS
(
  id          NUMBER(19) not null,
  created_at  TIMESTAMP(6),
  updated_at  TIMESTAMP(6),
  graduate_on DATE not null,
  name        VARCHAR2(150 CHAR) not null,
  project_id  NUMBER(10)
)
;
comment on table ST_GA_SEASONS
  is '毕业审核批次';
comment on column ST_GA_SEASONS.id
  is '非业务主键';
comment on column ST_GA_SEASONS.created_at
  is '创建时间';
comment on column ST_GA_SEASONS.updated_at
  is '更新时间';
comment on column ST_GA_SEASONS.graduate_on
  is '预毕业年月';
comment on column ST_GA_SEASONS.name
  is '名称';
comment on column ST_GA_SEASONS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
alter table ST_GA_SEASONS
  add primary key (ID);
alter table ST_GA_SEASONS
  add constraint FK_J0915I6V2FY80499FW0H53FIQ foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating ST_GA_RESULTS...
create table ST_GA_RESULTS
(
  id                NUMBER(19) not null,
  passed            NUMBER(1),
  published         NUMBER(1) not null,
  remark            VARCHAR2(500 CHAR),
  graduate_state_id NUMBER(10),
  season_id         NUMBER(19) not null,
  std_id            NUMBER(19) not null
)
;
comment on table ST_GA_RESULTS
  is '毕业审核结果';
comment on column ST_GA_RESULTS.id
  is '非业务主键';
comment on column ST_GA_RESULTS.passed
  is '是否通过';
comment on column ST_GA_RESULTS.published
  is '是否已发布';
comment on column ST_GA_RESULTS.remark
  is '备注';
comment on column ST_GA_RESULTS.graduate_state_id
  is '毕业结业结论 ID ###引用表名是HB_GRADUATE_STATES### ';
comment on column ST_GA_RESULTS.season_id
  is '所属的毕业审核批次 ID ###引用表名是ST_GA_SEASONS### ';
comment on column ST_GA_RESULTS.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table ST_GA_RESULTS
  add primary key (ID);
alter table ST_GA_RESULTS
  add constraint UK_455H5WI7CUPTJVYDN2K9M44SJ unique (SEASON_ID, STD_ID);
alter table ST_GA_RESULTS
  add constraint FK_ALDVLX8T7OWBVQT4N4SOF0VVB foreign key (SEASON_ID)
  references ST_GA_SEASONS (ID);
alter table ST_GA_RESULTS
  add constraint FK_DPTEYRKWINUMT8671R06EBHT foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table ST_GA_RESULTS
  add constraint FK_NGDVDGTYR9X42PVCF2WRGAJ2U foreign key (GRADUATE_STATE_ID)
  references HB_GRADUATE_STATES (ID);

prompt Creating ST_GA_ITEM_RESULTS...
create table ST_GA_ITEM_RESULTS
(
  id              NUMBER(19) not null,
  eng_name        VARCHAR2(200 CHAR) not null,
  name            VARCHAR2(200 CHAR) not null,
  passed          NUMBER(1),
  result          VARCHAR2(500 CHAR),
  audit_result_id NUMBER(19) not null
)
;
comment on table ST_GA_ITEM_RESULTS
  is '毕业审核各项目审核结果';
comment on column ST_GA_ITEM_RESULTS.id
  is '非业务主键';
comment on column ST_GA_ITEM_RESULTS.eng_name
  is '项目英文名称';
comment on column ST_GA_ITEM_RESULTS.name
  is '项目名称';
comment on column ST_GA_ITEM_RESULTS.passed
  is '是否通过';
comment on column ST_GA_ITEM_RESULTS.result
  is '具体状态信息';
comment on column ST_GA_ITEM_RESULTS.audit_result_id
  is '毕业审核结果 ID ###引用表名是ST_GA_RESULTS### ';
alter table ST_GA_ITEM_RESULTS
  add primary key (ID);
alter table ST_GA_ITEM_RESULTS
  add constraint FK_LG7GJJEFP2GLGTUID2EG4PBBE foreign key (AUDIT_RESULT_ID)
  references ST_GA_RESULTS (ID);

prompt Creating ST_GA_LOGS...
create table ST_GA_LOGS
(
  id            NUMBER(19) not null,
  audit_by      VARCHAR2(255 CHAR) not null,
  detail        VARCHAR2(4000 CHAR),
  ip            VARCHAR2(60 CHAR) not null,
  operate_at    TIMESTAMP(6) not null,
  passed        NUMBER(1) not null,
  season        VARCHAR2(150 CHAR) not null,
  standard_used VARCHAR2(500 CHAR) not null,
  std_id        NUMBER(19) not null
)
;
comment on table ST_GA_LOGS
  is '毕业审核日志';
comment on column ST_GA_LOGS.id
  is '非业务主键';
comment on column ST_GA_LOGS.audit_by
  is '审核人';
comment on column ST_GA_LOGS.detail
  is '各项详细审核结果，要包括是否自动';
comment on column ST_GA_LOGS.ip
  is '审核ip';
comment on column ST_GA_LOGS.operate_at
  is '操作时间';
comment on column ST_GA_LOGS.passed
  is '是否通过';
comment on column ST_GA_LOGS.season
  is '毕业审核批次名称';
comment on column ST_GA_LOGS.standard_used
  is '毕业审核时所用的标准';
comment on column ST_GA_LOGS.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table ST_GA_LOGS
  add primary key (ID);
alter table ST_GA_LOGS
  add constraint FK_4I9GFJNWX757XDIT0D5ADIFBP foreign key (STD_ID)
  references C_STUDENTS (ID);

prompt Creating ST_GA_STANDARDS...
create table ST_GA_STANDARDS
(
  id           NUMBER(19) not null,
  effective_on DATE not null,
  invalid_on   DATE,
  name         VARCHAR2(500 CHAR) not null,
  remark       VARCHAR2(600 CHAR),
  grades       VARCHAR2(255 CHAR),
  project_id   NUMBER(10)
)
;
comment on table ST_GA_STANDARDS
  is '毕业审核规则';
comment on column ST_GA_STANDARDS.id
  is '非业务主键';
comment on column ST_GA_STANDARDS.effective_on
  is '生效日期';
comment on column ST_GA_STANDARDS.invalid_on
  is '失效日期';
comment on column ST_GA_STANDARDS.name
  is '名称';
comment on column ST_GA_STANDARDS.remark
  is '备注';
comment on column ST_GA_STANDARDS.grades
  is '年级';
comment on column ST_GA_STANDARDS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
alter table ST_GA_STANDARDS
  add primary key (ID);
alter table ST_GA_STANDARDS
  add constraint FK_N3KUN4CF7Q4VASAXXV6H8H4BV foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating ST_GA_STANDARDS_DEPARTMENTS...
create table ST_GA_STANDARDS_DEPARTMENTS
(
  standard_id   NUMBER(19) not null,
  department_id NUMBER(10) not null
)
;
comment on table ST_GA_STANDARDS_DEPARTMENTS
  is '毕业审核规则-部门集合';
comment on column ST_GA_STANDARDS_DEPARTMENTS.standard_id
  is '毕业审核规则 ID ###引用表名是ST_GA_STANDARDS### ';
comment on column ST_GA_STANDARDS_DEPARTMENTS.department_id
  is '部门组织机构信息 ID ###引用表名是C_DEPARTMENTS### ';
alter table ST_GA_STANDARDS_DEPARTMENTS
  add primary key (STANDARD_ID, DEPARTMENT_ID);
alter table ST_GA_STANDARDS_DEPARTMENTS
  add constraint FK_P1XJWBA99V4FN7AQJPQ021VNJ foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table ST_GA_STANDARDS_DEPARTMENTS
  add constraint FK_TKC2NRE4GIXV3IPWFED8ARMNX foreign key (STANDARD_ID)
  references ST_GA_STANDARDS (ID);

prompt Creating ST_GA_STANDARDS_DIRECTIONS...
create table ST_GA_STANDARDS_DIRECTIONS
(
  standard_id  NUMBER(19) not null,
  direction_id NUMBER(10) not null
)
;
comment on table ST_GA_STANDARDS_DIRECTIONS
  is '毕业审核规则-专业方向集合';
comment on column ST_GA_STANDARDS_DIRECTIONS.standard_id
  is '毕业审核规则 ID ###引用表名是ST_GA_STANDARDS### ';
comment on column ST_GA_STANDARDS_DIRECTIONS.direction_id
  is '方向信息 专业领域. ID ###引用表名是C_DIRECTIONS### ';
alter table ST_GA_STANDARDS_DIRECTIONS
  add primary key (STANDARD_ID, DIRECTION_ID);
alter table ST_GA_STANDARDS_DIRECTIONS
  add constraint FK_2VNWGLBBB5ILBFIGY2CPBDA6H foreign key (STANDARD_ID)
  references ST_GA_STANDARDS (ID);
alter table ST_GA_STANDARDS_DIRECTIONS
  add constraint FK_CVKBGL3L5EOOWOEQQOT7H63XX foreign key (DIRECTION_ID)
  references C_DIRECTIONS (ID);

prompt Creating ST_GA_STANDARDS_EDUCATIONS...
create table ST_GA_STANDARDS_EDUCATIONS
(
  standard_id  NUMBER(19) not null,
  education_id NUMBER(10) not null
)
;
comment on table ST_GA_STANDARDS_EDUCATIONS
  is '毕业审核规则-培养层次集合';
comment on column ST_GA_STANDARDS_EDUCATIONS.standard_id
  is '毕业审核规则 ID ###引用表名是ST_GA_STANDARDS### ';
comment on column ST_GA_STANDARDS_EDUCATIONS.education_id
  is '学历层次 ID ###引用表名是HB_EDUCATIONS### ';
alter table ST_GA_STANDARDS_EDUCATIONS
  add primary key (STANDARD_ID, EDUCATION_ID);
alter table ST_GA_STANDARDS_EDUCATIONS
  add constraint FK_48I2C5JHO263E9EA2HX13BMP9 foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);
alter table ST_GA_STANDARDS_EDUCATIONS
  add constraint FK_E01C0CG89SQ3VPFEACWFJBAJK foreign key (STANDARD_ID)
  references ST_GA_STANDARDS (ID);

prompt Creating ST_GA_STANDARDS_MAJORS...
create table ST_GA_STANDARDS_MAJORS
(
  standard_id NUMBER(19) not null,
  major_id    NUMBER(10) not null
)
;
comment on table ST_GA_STANDARDS_MAJORS
  is '毕业审核规则-专业集合';
comment on column ST_GA_STANDARDS_MAJORS.standard_id
  is '毕业审核规则 ID ###引用表名是ST_GA_STANDARDS### ';
comment on column ST_GA_STANDARDS_MAJORS.major_id
  is '专业 ID ###引用表名是C_MAJORS### ';
alter table ST_GA_STANDARDS_MAJORS
  add primary key (STANDARD_ID, MAJOR_ID);
alter table ST_GA_STANDARDS_MAJORS
  add constraint FK_6T3BTCFJGOAF1JRROTABEWV3A foreign key (MAJOR_ID)
  references C_MAJORS (ID);
alter table ST_GA_STANDARDS_MAJORS
  add constraint FK_RN1WWRPWLBFY7S9FF3VXONBE4 foreign key (STANDARD_ID)
  references ST_GA_STANDARDS (ID);

prompt Creating ST_GA_STANDARDS_RULE_CFGS...
create table ST_GA_STANDARDS_RULE_CFGS
(
  standard_id    NUMBER(19) not null,
  rule_config_id NUMBER(10) not null
)
;
comment on table ST_GA_STANDARDS_RULE_CFGS
  is '毕业审核规则-审核项目';
comment on column ST_GA_STANDARDS_RULE_CFGS.standard_id
  is '毕业审核规则 ID ###引用表名是ST_GA_STANDARDS### ';
comment on column ST_GA_STANDARDS_RULE_CFGS.rule_config_id
  is '规则配置 ID ###引用表名是SYS_RULE_CONFIGS### ';
alter table ST_GA_STANDARDS_RULE_CFGS
  add primary key (STANDARD_ID, RULE_CONFIG_ID);
alter table ST_GA_STANDARDS_RULE_CFGS
  add constraint FK_4B513BKE9YRAPAWCMD7AB7HUT foreign key (STANDARD_ID)
  references ST_GA_STANDARDS (ID);
alter table ST_GA_STANDARDS_RULE_CFGS
  add constraint FK_OGCODLQXPQH5GP5IYUAX5DOA1 foreign key (RULE_CONFIG_ID)
  references SYS_RULE_CONFIGS (ID);

prompt Creating ST_GA_STANDARDS_STD_TYPES...
create table ST_GA_STANDARDS_STD_TYPES
(
  standard_id NUMBER(19) not null,
  std_type_id NUMBER(10) not null
)
;
comment on table ST_GA_STANDARDS_STD_TYPES
  is '毕业审核规则-学生类别集合';
comment on column ST_GA_STANDARDS_STD_TYPES.standard_id
  is '毕业审核规则 ID ###引用表名是ST_GA_STANDARDS### ';
comment on column ST_GA_STANDARDS_STD_TYPES.std_type_id
  is '学生类别 ID ###引用表名是XB_STD_TYPES### ';
alter table ST_GA_STANDARDS_STD_TYPES
  add primary key (STANDARD_ID, STD_TYPE_ID);
alter table ST_GA_STANDARDS_STD_TYPES
  add constraint FK_AA6WX9B0833XVY0MW13TMCQDH foreign key (STD_TYPE_ID)
  references XB_STD_TYPES (ID);
alter table ST_GA_STANDARDS_STD_TYPES
  add constraint FK_B282EAVO8KYU0OONBTBYAK9PS foreign key (STANDARD_ID)
  references ST_GA_STANDARDS (ID);

prompt Creating ST_PA_RESULTS...
create table ST_PA_RESULTS
(
  id                NUMBER(19) not null,
  created_at        TIMESTAMP(6),
  updated_at        TIMESTAMP(6),
  credits_completed FLOAT not null,
  credits_converted FLOAT not null,
  credits_required  FLOAT not null,
  num_completed     NUMBER(10) not null,
  num_required      NUMBER(10) not null,
  auditor           VARCHAR2(60 CHAR),
  depart_opinion    VARCHAR2(500 CHAR),
  final_opinion     VARCHAR2(500 CHAR),
  gpa               FLOAT,
  partial           NUMBER(1) not null,
  passed            NUMBER(1) not null,
  published         NUMBER(1) not null,
  remark            VARCHAR2(500 CHAR),
  updates           VARCHAR2(500 CHAR),
  std_id            NUMBER(19) not null
)
;
comment on table ST_PA_RESULTS
  is '计划完成审核结果';
comment on column ST_PA_RESULTS.id
  is '非业务主键';
comment on column ST_PA_RESULTS.created_at
  is '创建时间';
comment on column ST_PA_RESULTS.updated_at
  is '更新时间';
comment on column ST_PA_RESULTS.credits_completed
  is '总的通过学分';
comment on column ST_PA_RESULTS.credits_converted
  is '转换学分（例如：非任选课多出的学分可以转换冲抵任选课的学分）';
comment on column ST_PA_RESULTS.credits_required
  is '要求学分';
comment on column ST_PA_RESULTS.num_completed
  is '总的通过门数';
comment on column ST_PA_RESULTS.num_required
  is '要求门数';
comment on column ST_PA_RESULTS.auditor
  is '审核人';
comment on column ST_PA_RESULTS.depart_opinion
  is '院系意见';
comment on column ST_PA_RESULTS.final_opinion
  is '主管部门意见';
comment on column ST_PA_RESULTS.gpa
  is '平均绩点';
comment on column ST_PA_RESULTS.partial
  is '是否部分审核';
comment on column ST_PA_RESULTS.passed
  is '是否通过';
comment on column ST_PA_RESULTS.published
  is '是否发布审核结果';
comment on column ST_PA_RESULTS.remark
  is '备注';
comment on column ST_PA_RESULTS.updates
  is '增量更新内容';
comment on column ST_PA_RESULTS.std_id
  is '对应学生 ID ###引用表名是C_STUDENTS### ';
alter table ST_PA_RESULTS
  add primary key (ID);
alter table ST_PA_RESULTS
  add constraint UK_4S6CGM3QUDF8B5T79MM8G7THG unique (STD_ID);
alter table ST_PA_RESULTS
  add constraint FK_QR7V11WG93RSU3BMLI2DBCVHQ foreign key (STD_ID)
  references C_STUDENTS (ID);

prompt Creating ST_PA_GROUP_RESULTS...
create table ST_PA_GROUP_RESULTS
(
  id                NUMBER(19) not null,
  credits_completed FLOAT not null,
  credits_converted FLOAT not null,
  credits_required  FLOAT not null,
  num_completed     NUMBER(10) not null,
  num_required      NUMBER(10) not null,
  name              VARCHAR2(200 CHAR) not null,
  passed            NUMBER(1) not null,
  relation          VARCHAR2(255 CHAR),
  course_type_id    NUMBER(10) not null,
  parent_id         NUMBER(19),
  plan_result_id    NUMBER(19) not null
)
;
comment on table ST_PA_GROUP_RESULTS
  is '课程组审核结果';
comment on column ST_PA_GROUP_RESULTS.id
  is '非业务主键';
comment on column ST_PA_GROUP_RESULTS.credits_completed
  is '总的通过学分';
comment on column ST_PA_GROUP_RESULTS.credits_converted
  is '转换学分（例如：非任选课多出的学分可以转换冲抵任选课的学分）';
comment on column ST_PA_GROUP_RESULTS.credits_required
  is '要求学分';
comment on column ST_PA_GROUP_RESULTS.num_completed
  is '总的通过门数';
comment on column ST_PA_GROUP_RESULTS.num_required
  is '要求门数';
comment on column ST_PA_GROUP_RESULTS.name
  is '组名';
comment on column ST_PA_GROUP_RESULTS.passed
  is '是否通过';
comment on column ST_PA_GROUP_RESULTS.relation
  is '上下组关系';
comment on column ST_PA_GROUP_RESULTS.course_type_id
  is '课程类别 ID ###引用表名是XB_COURSE_TYPES### ';
comment on column ST_PA_GROUP_RESULTS.parent_id
  is '上级课程组 ID ###引用表名是ST_PA_GROUP_RESULTS### ';
comment on column ST_PA_GROUP_RESULTS.plan_result_id
  is '计划审核结果 ID ###引用表名是ST_PA_RESULTS### ';
alter table ST_PA_GROUP_RESULTS
  add primary key (ID);
alter table ST_PA_GROUP_RESULTS
  add constraint FK_4XHS1WCYAKVSK5MMIMVSGYPXQ foreign key (PLAN_RESULT_ID)
  references ST_PA_RESULTS (ID);
alter table ST_PA_GROUP_RESULTS
  add constraint FK_62MEPHYMC9BBB3KVVI7FSGCUY foreign key (PARENT_ID)
  references ST_PA_GROUP_RESULTS (ID);
alter table ST_PA_GROUP_RESULTS
  add constraint FK_APHGNSE6NNROJTF332DO37C4S foreign key (COURSE_TYPE_ID)
  references XB_COURSE_TYPES (ID);

prompt Creating ST_PA_COURSE_RESULTS...
create table ST_PA_COURSE_RESULTS
(
  id              NUMBER(19) not null,
  compulsory      NUMBER(1) not null,
  passed          NUMBER(1) not null,
  remark          VARCHAR2(500 CHAR),
  scores          VARCHAR2(100 CHAR),
  course_id       NUMBER(19) not null,
  group_result_id NUMBER(19) not null
)
;
comment on table ST_PA_COURSE_RESULTS
  is '培养计划课程审核结果';
comment on column ST_PA_COURSE_RESULTS.id
  is '非业务主键';
comment on column ST_PA_COURSE_RESULTS.compulsory
  is '是否必修';
comment on column ST_PA_COURSE_RESULTS.passed
  is '是否通过';
comment on column ST_PA_COURSE_RESULTS.remark
  is '备注';
comment on column ST_PA_COURSE_RESULTS.scores
  is '成绩';
comment on column ST_PA_COURSE_RESULTS.course_id
  is '课程 ID ###引用表名是T_COURSES### ';
comment on column ST_PA_COURSE_RESULTS.group_result_id
  is '课程组审核结果 ID ###引用表名是ST_PA_GROUP_RESULTS### ';
alter table ST_PA_COURSE_RESULTS
  add primary key (ID);
alter table ST_PA_COURSE_RESULTS
  add constraint FK_7YITPG9921ENG71TBXA916JHX foreign key (GROUP_RESULT_ID)
  references ST_PA_GROUP_RESULTS (ID);
alter table ST_PA_COURSE_RESULTS
  add constraint FK_MLLX768K1FJOVHJEIT416K77B foreign key (COURSE_ID)
  references T_COURSES (ID);

prompt Creating ST_PA_LOGS...
create table ST_PA_LOGS
(
  id            NUMBER(19) not null,
  audit_by      VARCHAR2(255 CHAR) not null,
  detail        VARCHAR2(2000 CHAR),
  ip            VARCHAR2(255 CHAR) not null,
  operate_at    TIMESTAMP(6) not null,
  passed        NUMBER(1) not null,
  standard_used VARCHAR2(500 CHAR),
  std_id        NUMBER(19) not null
)
;
comment on table ST_PA_LOGS
  is '培养计划完成审核日志';
comment on column ST_PA_LOGS.id
  is '非业务主键';
comment on column ST_PA_LOGS.audit_by
  is '审核人';
comment on column ST_PA_LOGS.detail
  is '审核细节';
comment on column ST_PA_LOGS.ip
  is '审核ip';
comment on column ST_PA_LOGS.operate_at
  is '操作时间';
comment on column ST_PA_LOGS.passed
  is '是否通过';
comment on column ST_PA_LOGS.standard_used
  is '审核时所用的规则';
comment on column ST_PA_LOGS.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table ST_PA_LOGS
  add primary key (ID);
alter table ST_PA_LOGS
  add constraint FK_CHMVH4OHSVCDTCP2MC70NXDMB foreign key (STD_ID)
  references C_STUDENTS (ID);

prompt Creating ST_PA_STANDARDS...
create table ST_PA_STANDARDS
(
  id                            NUMBER(19) not null,
  effective_at                  TIMESTAMP(6) not null,
  invalid_at                    TIMESTAMP(6),
  name                          VARCHAR2(500 CHAR) not null,
  remark                        VARCHAR2(600 CHAR),
  grades                        VARCHAR2(255 CHAR),
  convert_target_course_type_id NUMBER(10),
  project_id                    NUMBER(10)
)
;
comment on table ST_PA_STANDARDS
  is '计划完成审核标准';
comment on column ST_PA_STANDARDS.id
  is '非业务主键';
comment on column ST_PA_STANDARDS.effective_at
  is '生效时间';
comment on column ST_PA_STANDARDS.invalid_at
  is '失效时间';
comment on column ST_PA_STANDARDS.name
  is '名称';
comment on column ST_PA_STANDARDS.remark
  is '备注';
comment on column ST_PA_STANDARDS.grades
  is '年级';
comment on column ST_PA_STANDARDS.convert_target_course_type_id
  is '学分转换的目标课程类别 ID ###引用表名是XB_COURSE_TYPES### ';
comment on column ST_PA_STANDARDS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
alter table ST_PA_STANDARDS
  add primary key (ID);
alter table ST_PA_STANDARDS
  add constraint FK_ASV7T88V2CTLPTWWS3Y0LXD8H foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table ST_PA_STANDARDS
  add constraint FK_CCD7GN2W4NOCRWUBH1HHQKG27 foreign key (CONVERT_TARGET_COURSE_TYPE_ID)
  references XB_COURSE_TYPES (ID);

prompt Creating ST_PA_STANDARDS_CONVERTABLES...
create table ST_PA_STANDARDS_CONVERTABLES
(
  standard_id         NUMBER(19) not null,
  convertable_type_id NUMBER(10) not null
)
;
comment on table ST_PA_STANDARDS_CONVERTABLES
  is '计划完成审核标准-冲抵课程类别';
comment on column ST_PA_STANDARDS_CONVERTABLES.standard_id
  is '计划完成审核标准 ID ###引用表名是ST_PA_STANDARDS### ';
comment on column ST_PA_STANDARDS_CONVERTABLES.convertable_type_id
  is '课程类别 ID ###引用表名是XB_COURSE_TYPES### ';
alter table ST_PA_STANDARDS_CONVERTABLES
  add primary key (STANDARD_ID, CONVERTABLE_TYPE_ID);
alter table ST_PA_STANDARDS_CONVERTABLES
  add constraint FK_5FVDP8V30DD5L06BGP09AYWSW foreign key (CONVERTABLE_TYPE_ID)
  references XB_COURSE_TYPES (ID);
alter table ST_PA_STANDARDS_CONVERTABLES
  add constraint FK_B66GUCO5U6T6LMF1E6GKCS0YY foreign key (STANDARD_ID)
  references ST_PA_STANDARDS (ID);

prompt Creating ST_PA_STANDARDS_DEPARTMENTS...
create table ST_PA_STANDARDS_DEPARTMENTS
(
  standard_id   NUMBER(19) not null,
  department_id NUMBER(10) not null
)
;
comment on table ST_PA_STANDARDS_DEPARTMENTS
  is '计划完成审核标准-部门集合';
comment on column ST_PA_STANDARDS_DEPARTMENTS.standard_id
  is '计划完成审核标准 ID ###引用表名是ST_PA_STANDARDS### ';
comment on column ST_PA_STANDARDS_DEPARTMENTS.department_id
  is '部门组织机构信息 ID ###引用表名是C_DEPARTMENTS### ';
alter table ST_PA_STANDARDS_DEPARTMENTS
  add primary key (STANDARD_ID, DEPARTMENT_ID);
alter table ST_PA_STANDARDS_DEPARTMENTS
  add constraint FK_52EM061UKQD0OC8JCTR3MCG6M foreign key (STANDARD_ID)
  references ST_PA_STANDARDS (ID);
alter table ST_PA_STANDARDS_DEPARTMENTS
  add constraint FK_TAIF4K1GQSI39UFF6D7G5OMDH foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);

prompt Creating ST_PA_STANDARDS_DIRECTIONS...
create table ST_PA_STANDARDS_DIRECTIONS
(
  standard_id  NUMBER(19) not null,
  direction_id NUMBER(10) not null
)
;
comment on table ST_PA_STANDARDS_DIRECTIONS
  is '计划完成审核标准-专业方向集合';
comment on column ST_PA_STANDARDS_DIRECTIONS.standard_id
  is '计划完成审核标准 ID ###引用表名是ST_PA_STANDARDS### ';
comment on column ST_PA_STANDARDS_DIRECTIONS.direction_id
  is '方向信息 专业领域. ID ###引用表名是C_DIRECTIONS### ';
alter table ST_PA_STANDARDS_DIRECTIONS
  add primary key (STANDARD_ID, DIRECTION_ID);
alter table ST_PA_STANDARDS_DIRECTIONS
  add constraint FK_4H2YMLIUKY41I9GWNVB5GJ1R3 foreign key (DIRECTION_ID)
  references C_DIRECTIONS (ID);
alter table ST_PA_STANDARDS_DIRECTIONS
  add constraint FK_O644YY0EYYJ26RSDPNQUATW23 foreign key (STANDARD_ID)
  references ST_PA_STANDARDS (ID);

prompt Creating ST_PA_STANDARDS_DISAUDITS...
create table ST_PA_STANDARDS_DISAUDITS
(
  standard_id      NUMBER(19) not null,
  disaudit_type_id NUMBER(10) not null
)
;
comment on table ST_PA_STANDARDS_DISAUDITS
  is '计划完成审核标准-不审核的课程类别';
comment on column ST_PA_STANDARDS_DISAUDITS.standard_id
  is '计划完成审核标准 ID ###引用表名是ST_PA_STANDARDS### ';
comment on column ST_PA_STANDARDS_DISAUDITS.disaudit_type_id
  is '课程类别 ID ###引用表名是XB_COURSE_TYPES### ';
alter table ST_PA_STANDARDS_DISAUDITS
  add primary key (STANDARD_ID, DISAUDIT_TYPE_ID);
alter table ST_PA_STANDARDS_DISAUDITS
  add constraint FK_NH7HMUEV58N7IT5FFFF6NNBWJ foreign key (STANDARD_ID)
  references ST_PA_STANDARDS (ID);
alter table ST_PA_STANDARDS_DISAUDITS
  add constraint FK_PFQEAJXRJ8FWINCBW33X073XG foreign key (DISAUDIT_TYPE_ID)
  references XB_COURSE_TYPES (ID);

prompt Creating ST_PA_STANDARDS_EDUCATIONS...
create table ST_PA_STANDARDS_EDUCATIONS
(
  standard_id  NUMBER(19) not null,
  education_id NUMBER(10) not null
)
;
comment on table ST_PA_STANDARDS_EDUCATIONS
  is '计划完成审核标准-培养层次集合';
comment on column ST_PA_STANDARDS_EDUCATIONS.standard_id
  is '计划完成审核标准 ID ###引用表名是ST_PA_STANDARDS### ';
comment on column ST_PA_STANDARDS_EDUCATIONS.education_id
  is '学历层次 ID ###引用表名是HB_EDUCATIONS### ';
alter table ST_PA_STANDARDS_EDUCATIONS
  add primary key (STANDARD_ID, EDUCATION_ID);
alter table ST_PA_STANDARDS_EDUCATIONS
  add constraint FK_KVR0WYAARSWUF1XC0CHNGPQIS foreign key (STANDARD_ID)
  references ST_PA_STANDARDS (ID);
alter table ST_PA_STANDARDS_EDUCATIONS
  add constraint FK_TH11XT8WUBJ26OJW3NJ89MNOO foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);

prompt Creating ST_PA_STANDARDS_MAJORS...
create table ST_PA_STANDARDS_MAJORS
(
  standard_id NUMBER(19) not null,
  major_id    NUMBER(10) not null
)
;
comment on table ST_PA_STANDARDS_MAJORS
  is '计划完成审核标准-专业集合';
comment on column ST_PA_STANDARDS_MAJORS.standard_id
  is '计划完成审核标准 ID ###引用表名是ST_PA_STANDARDS### ';
comment on column ST_PA_STANDARDS_MAJORS.major_id
  is '专业 ID ###引用表名是C_MAJORS### ';
alter table ST_PA_STANDARDS_MAJORS
  add primary key (STANDARD_ID, MAJOR_ID);
alter table ST_PA_STANDARDS_MAJORS
  add constraint FK_6D3OO5CMMAH2HDCUK8QQJCD2Y foreign key (MAJOR_ID)
  references C_MAJORS (ID);
alter table ST_PA_STANDARDS_MAJORS
  add constraint FK_BX1Y6GQPPOVYJ507GTSYDKVSA foreign key (STANDARD_ID)
  references ST_PA_STANDARDS (ID);

prompt Creating ST_PA_STANDARDS_STD_TYPES...
create table ST_PA_STANDARDS_STD_TYPES
(
  standard_id NUMBER(19) not null,
  std_type_id NUMBER(10) not null
)
;
comment on table ST_PA_STANDARDS_STD_TYPES
  is '计划完成审核标准-学生类别集合';
comment on column ST_PA_STANDARDS_STD_TYPES.standard_id
  is '计划完成审核标准 ID ###引用表名是ST_PA_STANDARDS### ';
comment on column ST_PA_STANDARDS_STD_TYPES.std_type_id
  is '学生类别 ID ###引用表名是XB_STD_TYPES### ';
alter table ST_PA_STANDARDS_STD_TYPES
  add primary key (STANDARD_ID, STD_TYPE_ID);
alter table ST_PA_STANDARDS_STD_TYPES
  add constraint FK_53NRIK95RQWPKG07BQ75WPK1J foreign key (STANDARD_ID)
  references ST_PA_STANDARDS (ID);
alter table ST_PA_STANDARDS_STD_TYPES
  add constraint FK_Q4X2B6I6E3CU16VTRDJCEBM0W foreign key (STD_TYPE_ID)
  references XB_STD_TYPES (ID);

prompt Creating ST_REGISTERS...
create table ST_REGISTERS
(
  id            NUMBER(19) not null,
  checkin       NUMBER(1) not null,
  registed      NUMBER(1) not null,
  register_at   TIMESTAMP(6),
  register_by   VARCHAR2(50 CHAR),
  register_from VARCHAR2(50 CHAR),
  remark        VARCHAR2(50 CHAR),
  tuition_paid  NUMBER(1) not null,
  reason_id     NUMBER(10),
  semester_id   NUMBER(10) not null,
  std_id        NUMBER(19) not null
)
;
comment on table ST_REGISTERS
  is '学生注册信息';
comment on column ST_REGISTERS.id
  is '非业务主键';
comment on column ST_REGISTERS.checkin
  is '是否报到';
comment on column ST_REGISTERS.registed
  is '是否注册';
comment on column ST_REGISTERS.register_at
  is '注册时间';
comment on column ST_REGISTERS.register_by
  is '操作人';
comment on column ST_REGISTERS.register_from
  is '操作ip';
comment on column ST_REGISTERS.remark
  is '未注册说明';
comment on column ST_REGISTERS.tuition_paid
  is '是否缴费';
comment on column ST_REGISTERS.reason_id
  is '未注册原因 ID ###引用表名是HB_UNREGISTER_REASONS### ';
comment on column ST_REGISTERS.semester_id
  is '注册学年学期 ID ###引用表名是C_SEMESTERS### ';
comment on column ST_REGISTERS.std_id
  is '注册学生 ID ###引用表名是C_STUDENTS### ';
alter table ST_REGISTERS
  add primary key (ID);
alter table ST_REGISTERS
  add constraint UK_5L27VM0B94W73DR5W7P6R85Q2 unique (SEMESTER_ID, STD_ID);
alter table ST_REGISTERS
  add constraint FK_3KNNK34U7ASOWY64OHE8J8KD0 foreign key (REASON_ID)
  references HB_UNREGISTER_REASONS (ID);
alter table ST_REGISTERS
  add constraint FK_IM0KMSEADPOTXBRBK5HC8OUI0 foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table ST_REGISTERS
  add constraint FK_S0FATHWUHD05FPEYHIQ5CETHA foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);

prompt Creating ST_REGISTER_USER_GROUPS...
create table ST_REGISTER_USER_GROUPS
(
  id       NUMBER(19) not null,
  begin_at TIMESTAMP(6) not null,
  end_at   TIMESTAMP(6) not null,
  name     VARCHAR2(255 CHAR) not null
)
;
comment on table ST_REGISTER_USER_GROUPS
  is '注册用户组';
comment on column ST_REGISTER_USER_GROUPS.id
  is '非业务主键';
comment on column ST_REGISTER_USER_GROUPS.begin_at
  is '开始时间';
comment on column ST_REGISTER_USER_GROUPS.end_at
  is '结束时间';
comment on column ST_REGISTER_USER_GROUPS.name
  is '名称';
alter table ST_REGISTER_USER_GROUPS
  add primary key (ID);

prompt Creating ST_REGISTER_USER_GROUPS_USERS...
create table ST_REGISTER_USER_GROUPS_USERS
(
  register_user_group_id NUMBER(19) not null,
  user_id                NUMBER(19) not null
)
;
comment on table ST_REGISTER_USER_GROUPS_USERS
  is '注册用户组-成员';
comment on column ST_REGISTER_USER_GROUPS_USERS.register_user_group_id
  is '注册用户组 ID ###引用表名是ST_REGISTER_USER_GROUPS### ';
comment on column ST_REGISTER_USER_GROUPS_USERS.user_id
  is '系统用户 ID ###引用表名是SE_USERS### ';
alter table ST_REGISTER_USER_GROUPS_USERS
  add primary key (REGISTER_USER_GROUP_ID, USER_ID);
alter table ST_REGISTER_USER_GROUPS_USERS
  add constraint FK_NTJRS7MIDUWK6ORVHMCTIK4I8 foreign key (REGISTER_USER_GROUP_ID)
  references ST_REGISTER_USER_GROUPS (ID);
alter table ST_REGISTER_USER_GROUPS_USERS
  add constraint FK_QJ92TIGILSQ4DOQXPYQDG5HX2 foreign key (USER_ID)
  references SE_USERS (ID);

prompt Creating ST_REPORT_LOGIN_SWITCHES...
create table ST_REPORT_LOGIN_SWITCHES
(
  id          NUMBER(19) not null,
  close_at    TIMESTAMP(6),
  open_at     TIMESTAMP(6) not null,
  opened      NUMBER(1) not null,
  semester_id NUMBER(10) not null
)
;
comment on table ST_REPORT_LOGIN_SWITCHES
  is '报道/注册开关';
comment on column ST_REPORT_LOGIN_SWITCHES.id
  is '非业务主键';
comment on column ST_REPORT_LOGIN_SWITCHES.close_at
  is '关闭时间';
comment on column ST_REPORT_LOGIN_SWITCHES.open_at
  is '开始时间';
comment on column ST_REPORT_LOGIN_SWITCHES.opened
  is '开关状态';
comment on column ST_REPORT_LOGIN_SWITCHES.semester_id
  is '教学日历 ID ###引用表名是C_SEMESTERS### ';
alter table ST_REPORT_LOGIN_SWITCHES
  add primary key (ID);
alter table ST_REPORT_LOGIN_SWITCHES
  add constraint FK_H74RHWLARQK6QKM4XVX6ME9DN foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);

prompt Creating ST_STD_ADMISSIONS...
create table ST_STD_ADMISSIONS
(
  id                NUMBER(19) not null,
  created_at        TIMESTAMP(6),
  updated_at        TIMESTAMP(6),
  admission_index   VARCHAR2(20 CHAR),
  letter_no         VARCHAR2(50 CHAR),
  std_id            NUMBER(19),
  admission_type_id NUMBER(10),
  department_id     NUMBER(10) not null,
  fee_origin_id     NUMBER(10),
  major_id          NUMBER(10)
)
;
comment on table ST_STD_ADMISSIONS
  is '学生录取信息';
comment on column ST_STD_ADMISSIONS.id
  is '非业务主键';
comment on column ST_STD_ADMISSIONS.created_at
  is '创建时间';
comment on column ST_STD_ADMISSIONS.updated_at
  is '更新时间';
comment on column ST_STD_ADMISSIONS.admission_index
  is '录取第几志愿';
comment on column ST_STD_ADMISSIONS.letter_no
  is '录取通知书号';
comment on column ST_STD_ADMISSIONS.std_id
  is 'std ID ###引用表名是C_STUDENTS### ';
comment on column ST_STD_ADMISSIONS.admission_type_id
  is '录取类别 ID ###引用表名是HB_ADMISSION_TYPES### ';
comment on column ST_STD_ADMISSIONS.department_id
  is '录取院系 ID ###引用表名是C_DEPARTMENTS### ';
comment on column ST_STD_ADMISSIONS.fee_origin_id
  is '收费类别 ID ###引用表名是HB_FEE_ORIGINS### ';
comment on column ST_STD_ADMISSIONS.major_id
  is '录取专业 ID ###引用表名是C_MAJORS### ';
alter table ST_STD_ADMISSIONS
  add primary key (ID);
alter table ST_STD_ADMISSIONS
  add constraint UK_E9PUC1APEB1FVE7MGMSO9796J unique (STD_ID);
alter table ST_STD_ADMISSIONS
  add constraint FK_7P0A6VLY5F8OH0QFE3AAOTOG6 foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table ST_STD_ADMISSIONS
  add constraint FK_94AJS3K9K45C8PI0Y6OBEQIYR foreign key (ADMISSION_TYPE_ID)
  references HB_ADMISSION_TYPES (ID);
alter table ST_STD_ADMISSIONS
  add constraint FK_GH7298TUR433JDVAQ91CQRK2C foreign key (FEE_ORIGIN_ID)
  references HB_FEE_ORIGINS (ID);
alter table ST_STD_ADMISSIONS
  add constraint FK_OTB0PEGE20SWQ5CQF26REJJID foreign key (MAJOR_ID)
  references C_MAJORS (ID);
alter table ST_STD_ADMISSIONS
  add constraint FK_S9Y4FIDMGPF48Y5TMVUTKRBLT foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);

prompt Creating ST_STD_ADMISSION_MAJORS...
create table ST_STD_ADMISSION_MAJORS
(
  id                     NUMBER(19) not null,
  created_at             TIMESTAMP(6),
  updated_at             TIMESTAMP(6),
  certificate_no         VARCHAR2(255 CHAR),
  degree_award_by        VARCHAR2(255 CHAR),
  degree_award_on        DATE,
  major_code             VARCHAR2(255 CHAR) not null,
  major_name             VARCHAR2(255 CHAR) not null,
  recommend_by           VARCHAR2(255 CHAR),
  std_id                 NUMBER(19),
  degree_id              NUMBER(10),
  discipline_category_id NUMBER(10)
)
;
comment on table ST_STD_ADMISSION_MAJORS
  is '招生入学专业和学位信息';
comment on column ST_STD_ADMISSION_MAJORS.id
  is '非业务主键';
comment on column ST_STD_ADMISSION_MAJORS.created_at
  is '创建时间';
comment on column ST_STD_ADMISSION_MAJORS.updated_at
  is '更新时间';
comment on column ST_STD_ADMISSION_MAJORS.certificate_no
  is '毕业证书编号';
comment on column ST_STD_ADMISSION_MAJORS.degree_award_by
  is '学位授予单位';
comment on column ST_STD_ADMISSION_MAJORS.degree_award_on
  is '学位授予时间';
comment on column ST_STD_ADMISSION_MAJORS.major_code
  is '毕业专业代码';
comment on column ST_STD_ADMISSION_MAJORS.major_name
  is '毕业专业';
comment on column ST_STD_ADMISSION_MAJORS.recommend_by
  is '推荐单位';
comment on column ST_STD_ADMISSION_MAJORS.std_id
  is 'std ID ###引用表名是C_STUDENTS### ';
comment on column ST_STD_ADMISSION_MAJORS.degree_id
  is '学位 ID ###引用表名是GB_DEGREES### ';
comment on column ST_STD_ADMISSION_MAJORS.discipline_category_id
  is '学科门类 ID ###引用表名是JB_DISCIPLINE_CATEGORIES### ';
alter table ST_STD_ADMISSION_MAJORS
  add primary key (ID);
alter table ST_STD_ADMISSION_MAJORS
  add constraint UK_2YLM1VH6HXR91EV0SK476H5N2 unique (STD_ID);
alter table ST_STD_ADMISSION_MAJORS
  add constraint FK_5T7QSVW26ANR7WPPHGJB8CG12 foreign key (DISCIPLINE_CATEGORY_ID)
  references JB_DISCIPLINE_CATEGORIES (ID);
alter table ST_STD_ADMISSION_MAJORS
  add constraint FK_B4S0V514WNAJ15GDGCRBCPA6L foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table ST_STD_ADMISSION_MAJORS
  add constraint FK_C5WEF48D5G76V1XB3VIIUTNE6 foreign key (DEGREE_ID)
  references GB_DEGREES (ID);

prompt Creating ST_STD_ALTERATIONS...
create table ST_STD_ALTERATIONS
(
  id          NUMBER(19) not null,
  created_at  TIMESTAMP(6),
  updated_at  TIMESTAMP(6),
  code        VARCHAR2(255 CHAR),
  effective   NUMBER(1) not null,
  end_on      DATE,
  remark      VARCHAR2(255 CHAR),
  start_on    DATE not null,
  reason_id   NUMBER(10),
  semester_id NUMBER(10) not null,
  std_id      NUMBER(19) not null,
  type_id     NUMBER(10) not null
)
;
comment on table ST_STD_ALTERATIONS
  is '学籍异动';
comment on column ST_STD_ALTERATIONS.id
  is '非业务主键';
comment on column ST_STD_ALTERATIONS.created_at
  is '创建时间';
comment on column ST_STD_ALTERATIONS.updated_at
  is '更新时间';
comment on column ST_STD_ALTERATIONS.code
  is '编号';
comment on column ST_STD_ALTERATIONS.effective
  is '是否生效';
comment on column ST_STD_ALTERATIONS.end_on
  is '变动日期结束日期';
comment on column ST_STD_ALTERATIONS.remark
  is '操作备注（以逗号,分隔的国际化文件的key,记录该变动操作的备注,如培养计划操作和帐号禁用）';
comment on column ST_STD_ALTERATIONS.start_on
  is '变动开始日期';
comment on column ST_STD_ALTERATIONS.reason_id
  is '变动原因 ID ###引用表名是HB_STD_ALTER_REASONS### ';
comment on column ST_STD_ALTERATIONS.semester_id
  is '学期 ID ###引用表名是C_SEMESTERS### ';
comment on column ST_STD_ALTERATIONS.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
comment on column ST_STD_ALTERATIONS.type_id
  is '变动类型 ID ###引用表名是HB_STD_ALTER_TYPES### ';
alter table ST_STD_ALTERATIONS
  add primary key (ID);
alter table ST_STD_ALTERATIONS
  add constraint FK_1X3AYGQOXD1SFG1VCPX9IVWYK foreign key (REASON_ID)
  references HB_STD_ALTER_REASONS (ID);
alter table ST_STD_ALTERATIONS
  add constraint FK_8O86CU31EBQONXE8RQAIBTYED foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table ST_STD_ALTERATIONS
  add constraint FK_AXWX86IQUNUELS2AFCS15TCW2 foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table ST_STD_ALTERATIONS
  add constraint FK_D46JCVA5UPNLFQV6001QH34XS foreign key (TYPE_ID)
  references HB_STD_ALTER_TYPES (ID);

prompt Creating SYS_ENTITY_METAS...
create table SYS_ENTITY_METAS
(
  id       NUMBER(10) not null,
  comments VARCHAR2(255 CHAR) not null,
  name     VARCHAR2(255 CHAR) not null,
  remark   VARCHAR2(500 CHAR)
)
;
comment on table SYS_ENTITY_METAS
  is '实体元信息';
comment on column SYS_ENTITY_METAS.id
  is '非业务主键';
comment on column SYS_ENTITY_METAS.comments
  is '实体别名';
comment on column SYS_ENTITY_METAS.name
  is '实体名称';
comment on column SYS_ENTITY_METAS.remark
  is '实体备注';
alter table SYS_ENTITY_METAS
  add primary key (ID);

prompt Creating SYS_PROPERTY_METAS...
create table SYS_PROPERTY_METAS
(
  id       NUMBER(10) not null,
  comments VARCHAR2(40 CHAR),
  name     VARCHAR2(255 CHAR) not null,
  remark   VARCHAR2(100 CHAR),
  type     VARCHAR2(255 CHAR) not null,
  meta_id  NUMBER(10) not null
)
;
comment on table SYS_PROPERTY_METAS
  is '属性元数据实现';
comment on column SYS_PROPERTY_METAS.id
  is '非业务主键';
comment on column SYS_PROPERTY_METAS.comments
  is '属性说明';
comment on column SYS_PROPERTY_METAS.name
  is '属性名称';
comment on column SYS_PROPERTY_METAS.remark
  is '备注';
comment on column SYS_PROPERTY_METAS.type
  is '类型';
comment on column SYS_PROPERTY_METAS.meta_id
  is '所属元数据 ID ###引用表名是SYS_ENTITY_METAS### ';
alter table SYS_PROPERTY_METAS
  add primary key (ID);
alter table SYS_PROPERTY_METAS
  add constraint FK_PX6TCIHVJH9PS85XTDJYJB8V1 foreign key (META_ID)
  references SYS_ENTITY_METAS (ID);

prompt Creating ST_STD_ALTERATION_ITEMS...
create table ST_STD_ALTERATION_ITEMS
(
  id            NUMBER(19) not null,
  newvalue      VARCHAR2(255 CHAR),
  oldvalue      VARCHAR2(255 CHAR),
  alteration_id NUMBER(19) not null,
  meta_id       NUMBER(10) not null
)
;
comment on table ST_STD_ALTERATION_ITEMS
  is '学籍异动变动项';
comment on column ST_STD_ALTERATION_ITEMS.id
  is '非业务主键';
comment on column ST_STD_ALTERATION_ITEMS.newvalue
  is '变更后';
comment on column ST_STD_ALTERATION_ITEMS.oldvalue
  is '变更前';
comment on column ST_STD_ALTERATION_ITEMS.alteration_id
  is '学籍异动 ID ###引用表名是ST_STD_ALTERATIONS### ';
comment on column ST_STD_ALTERATION_ITEMS.meta_id
  is '属性元信息 ID ###引用表名是SYS_PROPERTY_METAS### ';
alter table ST_STD_ALTERATION_ITEMS
  add primary key (ID);
alter table ST_STD_ALTERATION_ITEMS
  add constraint FK_3PLUU6PPWUKO1TQICFVXEVDH5 foreign key (ALTERATION_ID)
  references ST_STD_ALTERATIONS (ID);
alter table ST_STD_ALTERATION_ITEMS
  add constraint FK_9LQE53G0RHNOGODXA50PQCX45 foreign key (META_ID)
  references SYS_PROPERTY_METAS (ID);

prompt Creating ST_STD_EDIT_RESTRICTIONS...
create table ST_STD_EDIT_RESTRICTIONS
(
  id            NUMBER(19) not null,
  user_group_id NUMBER(10) not null
)
;
comment on table ST_STD_EDIT_RESTRICTIONS
  is '学生基本信息修改限制类';
comment on column ST_STD_EDIT_RESTRICTIONS.id
  is '非业务主键';
comment on column ST_STD_EDIT_RESTRICTIONS.user_group_id
  is '角色 ID ###引用表名是SE_ROLES### ';
alter table ST_STD_EDIT_RESTRICTIONS
  add primary key (ID);
alter table ST_STD_EDIT_RESTRICTIONS
  add constraint UK_C53I6SWD9YK3GMQ1REOVJWJFM unique (USER_GROUP_ID);
alter table ST_STD_EDIT_RESTRICTIONS
  add constraint FK_C6C44TC18JMAFXYPQOJ9TQ60V foreign key (USER_GROUP_ID)
  references SE_ROLES (ID);

prompt Creating ST_STD_EDIT_RESTRICTIONS_METAS...
create table ST_STD_EDIT_RESTRICTIONS_METAS
(
  std_edit_restriction_id NUMBER(19) not null,
  property_meta_id        NUMBER(10) not null
)
;
comment on table ST_STD_EDIT_RESTRICTIONS_METAS
  is '学生基本信息修改限制类-元信息列表';
comment on column ST_STD_EDIT_RESTRICTIONS_METAS.std_edit_restriction_id
  is '学生基本信息修改限制类 ID ###引用表名是ST_STD_EDIT_RESTRICTIONS### ';
comment on column ST_STD_EDIT_RESTRICTIONS_METAS.property_meta_id
  is '属性元数据实现 ID ###引用表名是SYS_PROPERTY_METAS### ';
alter table ST_STD_EDIT_RESTRICTIONS_METAS
  add primary key (STD_EDIT_RESTRICTION_ID, PROPERTY_META_ID);
alter table ST_STD_EDIT_RESTRICTIONS_METAS
  add constraint FK_1A038BDD2AHUQ52FO06UQFGP foreign key (STD_EDIT_RESTRICTION_ID)
  references ST_STD_EDIT_RESTRICTIONS (ID);
alter table ST_STD_EDIT_RESTRICTIONS_METAS
  add constraint FK_OC6OXHK5WJXFBTPKJXNVCXNOK foreign key (PROPERTY_META_ID)
  references SYS_PROPERTY_METAS (ID);

prompt Creating ST_STD_EXAMINEES...
create table ST_STD_EXAMINEES
(
  id                 NUMBER(19) not null,
  created_at         TIMESTAMP(6),
  updated_at         TIMESTAMP(6),
  exam_number        VARCHAR2(255 CHAR),
  examinee_code      VARCHAR2(255 CHAR),
  graduate_on        DATE,
  school_name        VARCHAR2(255 CHAR),
  school_no          VARCHAR2(255 CHAR),
  score              FLOAT,
  std_id             NUMBER(19),
  education_id       NUMBER(10) not null,
  education_mode_id  NUMBER(10),
  enroll_mode_id     NUMBER(10),
  examinee_type_id   NUMBER(10),
  language_id        NUMBER(10),
  origin_division_id NUMBER(10)
)
;
comment on table ST_STD_EXAMINEES
  is '学生考生信息';
comment on column ST_STD_EXAMINEES.id
  is '非业务主键';
comment on column ST_STD_EXAMINEES.created_at
  is '创建时间';
comment on column ST_STD_EXAMINEES.updated_at
  is '更新时间';
comment on column ST_STD_EXAMINEES.exam_number
  is '准考证号';
comment on column ST_STD_EXAMINEES.examinee_code
  is '考生号';
comment on column ST_STD_EXAMINEES.graduate_on
  is '毕业日期';
comment on column ST_STD_EXAMINEES.school_name
  is '毕业学校名称';
comment on column ST_STD_EXAMINEES.school_no
  is '毕业学校编号';
comment on column ST_STD_EXAMINEES.score
  is '招生录取总分';
comment on column ST_STD_EXAMINEES.std_id
  is 'std ID ###引用表名是C_STUDENTS### ';
comment on column ST_STD_EXAMINEES.education_id
  is '学历层次 ID ###引用表名是HB_EDUCATIONS### ';
comment on column ST_STD_EXAMINEES.education_mode_id
  is '培养方式 ID ###引用表名是HB_EDUCATION_MODES### ';
comment on column ST_STD_EXAMINEES.enroll_mode_id
  is '入学方式 ID ###引用表名是HB_ENROLL_MODES### ';
comment on column ST_STD_EXAMINEES.examinee_type_id
  is '生源类别 ID ###引用表名是HB_EXAMINEE_TYPES### ';
comment on column ST_STD_EXAMINEES.language_id
  is '第一外语语种 ID ###引用表名是GB_LANGUAGES### ';
comment on column ST_STD_EXAMINEES.origin_division_id
  is '生源地 ID ###引用表名是GB_DIVISIONS### ';
alter table ST_STD_EXAMINEES
  add primary key (ID);
alter table ST_STD_EXAMINEES
  add constraint UK_3SCP7KN374XPI62JG6MXSTGQT unique (STD_ID);
alter table ST_STD_EXAMINEES
  add constraint FK_59X91N11EK29MT0HDCK7H7TK8 foreign key (LANGUAGE_ID)
  references GB_LANGUAGES (ID);
alter table ST_STD_EXAMINEES
  add constraint FK_6WW63TOFLJ64H3T6TR32AL9NV foreign key (ORIGIN_DIVISION_ID)
  references GB_DIVISIONS (ID);
alter table ST_STD_EXAMINEES
  add constraint FK_84CYP51MM3UY2OR9MCXTLSPFF foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table ST_STD_EXAMINEES
  add constraint FK_D8MMTXECSNG44WPBV7J2V2G2P foreign key (EXAMINEE_TYPE_ID)
  references HB_EXAMINEE_TYPES (ID);
alter table ST_STD_EXAMINEES
  add constraint FK_F5VRLFBKQLP8X7IW5WW1PEKBV foreign key (ENROLL_MODE_ID)
  references HB_ENROLL_MODES (ID);
alter table ST_STD_EXAMINEES
  add constraint FK_GIW1XIPCJ24WHV2N7102S9IH2 foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);
alter table ST_STD_EXAMINEES
  add constraint FK_M9D6NFXTATEHV40FOYD6H9D6H foreign key (EDUCATION_MODE_ID)
  references HB_EDUCATION_MODES (ID);

prompt Creating ST_STD_EXAMINEES_SCORES...
create table ST_STD_EXAMINEES_SCORES
(
  std_examinee_id NUMBER(19) not null,
  score           FLOAT,
  type_id         NUMBER(10) not null
)
;
comment on table ST_STD_EXAMINEES_SCORES
  is '学生考生信息-各科分数 科目->浮点数';
comment on column ST_STD_EXAMINEES_SCORES.std_examinee_id
  is '学生考生信息 ID ###引用表名是ST_STD_EXAMINEES### ';
alter table ST_STD_EXAMINEES_SCORES
  add primary key (STD_EXAMINEE_ID, TYPE_ID);
alter table ST_STD_EXAMINEES_SCORES
  add constraint FK_OXQ49WQ0G4LI3TIQQYTQ5RVMC foreign key (STD_EXAMINEE_ID)
  references ST_STD_EXAMINEES (ID);

prompt Creating ST_STD_GRADUATIONS...
create table ST_STD_GRADUATIONS
(
  id                NUMBER(19) not null,
  created_at        TIMESTAMP(6),
  updated_at        TIMESTAMP(6),
  certificate_no    VARCHAR2(255 CHAR),
  credits           FLOAT,
  degree_award_on   VARCHAR2(255 CHAR),
  diploma_no        VARCHAR2(255 CHAR),
  gpa               FLOAT,
  no_grade_credits  FLOAT,
  required_credits  FLOAT,
  std_id            NUMBER(19),
  degree_id         NUMBER(10),
  graduate_state_id NUMBER(10) not null
)
;
comment on table ST_STD_GRADUATIONS
  is '毕业信息实现';
comment on column ST_STD_GRADUATIONS.id
  is '非业务主键';
comment on column ST_STD_GRADUATIONS.created_at
  is '创建时间';
comment on column ST_STD_GRADUATIONS.updated_at
  is '更新时间';
comment on column ST_STD_GRADUATIONS.certificate_no
  is '毕业证书编号';
comment on column ST_STD_GRADUATIONS.credits
  is '获得学分';
comment on column ST_STD_GRADUATIONS.degree_award_on
  is '学位授予日期';
comment on column ST_STD_GRADUATIONS.diploma_no
  is '学位证书号';
comment on column ST_STD_GRADUATIONS.gpa
  is 'GPA';
comment on column ST_STD_GRADUATIONS.no_grade_credits
  is '没有成绩的选课学分';
comment on column ST_STD_GRADUATIONS.required_credits
  is '要求学分';
comment on column ST_STD_GRADUATIONS.std_id
  is 'std ID ###引用表名是C_STUDENTS### ';
comment on column ST_STD_GRADUATIONS.degree_id
  is '学位 ID ###引用表名是GB_DEGREES### ';
comment on column ST_STD_GRADUATIONS.graduate_state_id
  is '毕结业情况 ID ###引用表名是HB_GRADUATE_STATES### ';
alter table ST_STD_GRADUATIONS
  add primary key (ID);
alter table ST_STD_GRADUATIONS
  add constraint UK_5KOPVWRU4IDCSRRSUPLPTNCCU unique (STD_ID);
alter table ST_STD_GRADUATIONS
  add constraint FK_30MGQYLOCSL8S1U6EGSN7XHOF foreign key (DEGREE_ID)
  references GB_DEGREES (ID);
alter table ST_STD_GRADUATIONS
  add constraint FK_3F0KQPRYN2TS9FHX7QTO6LK4W foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table ST_STD_GRADUATIONS
  add constraint FK_AWCNQSJ6JX0AYTSK4QNTT8MKN foreign key (GRADUATE_STATE_ID)
  references HB_GRADUATE_STATES (ID);

prompt Creating ST_STD_PROPERTY_EDITORS...
create table ST_STD_PROPERTY_EDITORS
(
  id          NUMBER(19) not null,
  description VARCHAR2(255 CHAR),
  multi_value NUMBER(1) not null,
  name        VARCHAR2(255 CHAR) not null,
  property    VARCHAR2(255 CHAR) not null,
  source      VARCHAR2(255 CHAR),
  type        VARCHAR2(255 CHAR) not null
)
;
comment on table ST_STD_PROPERTY_EDITORS
  is '异动属性编辑器';
comment on column ST_STD_PROPERTY_EDITORS.id
  is '非业务主键';
comment on column ST_STD_PROPERTY_EDITORS.description
  is '描述';
comment on column ST_STD_PROPERTY_EDITORS.multi_value
  is '是否多项';
comment on column ST_STD_PROPERTY_EDITORS.name
  is '姓名';
comment on column ST_STD_PROPERTY_EDITORS.property
  is '属性';
comment on column ST_STD_PROPERTY_EDITORS.source
  is '来源';
comment on column ST_STD_PROPERTY_EDITORS.type
  is '类型';
alter table ST_STD_PROPERTY_EDITORS
  add primary key (ID);

prompt Creating ST_USER_STUDENT_CONDITIONS...
create table ST_USER_STUDENT_CONDITIONS
(
  id             NUMBER(19) not null,
  created_at     TIMESTAMP(6),
  updated_at     TIMESTAMP(6),
  condition_name VARCHAR2(255 CHAR),
  conditions     VARCHAR2(255 CHAR),
  user_id        NUMBER(19)
)
;
comment on table ST_USER_STUDENT_CONDITIONS
  is '查询学生条件';
comment on column ST_USER_STUDENT_CONDITIONS.id
  is '非业务主键';
comment on column ST_USER_STUDENT_CONDITIONS.created_at
  is '创建时间';
comment on column ST_USER_STUDENT_CONDITIONS.updated_at
  is '更新时间';
comment on column ST_USER_STUDENT_CONDITIONS.condition_name
  is '条件名称';
comment on column ST_USER_STUDENT_CONDITIONS.conditions
  is '条件内容';
comment on column ST_USER_STUDENT_CONDITIONS.user_id
  is '用户 ID ###引用表名是SE_USERS### ';
alter table ST_USER_STUDENT_CONDITIONS
  add primary key (ID);
alter table ST_USER_STUDENT_CONDITIONS
  add constraint FK_7RI3NDKAR09S04VL97LQX6N3O foreign key (USER_ID)
  references SE_USERS (ID);

prompt Creating SYS_BUSINESS_LOGS...
create table SYS_BUSINESS_LOGS
(
  id         NUMBER(19) not null,
  agent      VARCHAR2(100 CHAR),
  entry      VARCHAR2(200 CHAR) not null,
  ip         VARCHAR2(100 CHAR),
  operate_at TIMESTAMP(6) not null,
  operation  VARCHAR2(200 CHAR) not null,
  operator   VARCHAR2(50 CHAR) not null,
  resrc      VARCHAR2(100 CHAR) not null,
  detail_id  NUMBER(19)
)
;
comment on table SYS_BUSINESS_LOGS
  is '业务日志实现';
comment on column SYS_BUSINESS_LOGS.id
  is '非业务主键';
comment on column SYS_BUSINESS_LOGS.agent
  is '操作客户端代理';
comment on column SYS_BUSINESS_LOGS.entry
  is '操作资源';
comment on column SYS_BUSINESS_LOGS.ip
  is '操作IP';
comment on column SYS_BUSINESS_LOGS.operate_at
  is '操作时间';
comment on column SYS_BUSINESS_LOGS.operation
  is '操作内容';
comment on column SYS_BUSINESS_LOGS.operator
  is '操作用户';
comment on column SYS_BUSINESS_LOGS.resrc
  is '操作资源';
comment on column SYS_BUSINESS_LOGS.detail_id
  is '操作明细 ID ###引用表名是SYS_BUSINESS_LOG_DETAILS### ';
alter table SYS_BUSINESS_LOGS
  add primary key (ID);

prompt Creating SYS_BUSINESS_LOG_DETAILS...
create table SYS_BUSINESS_LOG_DETAILS
(
  id      NUMBER(19) not null,
  content CLOB,
  log_id  NUMBER(19)
);
comment on table SYS_BUSINESS_LOG_DETAILS
  is '业务日志明细';
comment on column SYS_BUSINESS_LOG_DETAILS.id
  is '非业务主键';
comment on column SYS_BUSINESS_LOG_DETAILS.content
  is '操作参数';
comment on column SYS_BUSINESS_LOG_DETAILS.log_id
  is '操作日志 ID ###引用表名是SYS_BUSINESS_LOGS### ';
alter table SYS_BUSINESS_LOG_DETAILS
  add primary key (ID);
alter table SYS_BUSINESS_LOG_DETAILS
  add constraint FK_GPTATPW33C10H5JG6WBFY302U foreign key (LOG_ID)
  references SYS_BUSINESS_LOGS (ID);
alter table SYS_BUSINESS_LOGS
  add constraint FK_KGP0TFA5AS07OBRNTAW1MXRCM foreign key (DETAIL_ID)
  references SYS_BUSINESS_LOG_DETAILS (ID);

prompt Creating SYS_CODE_SCRIPTS...
create table SYS_CODE_SCRIPTS
(
  id              NUMBER(10) not null,
  created_at      TIMESTAMP(6),
  updated_at      TIMESTAMP(6),
  attr            VARCHAR2(20 CHAR) not null,
  code_class_name VARCHAR2(100 CHAR) not null,
  code_name       VARCHAR2(40 CHAR) not null,
  description     VARCHAR2(100 CHAR) not null,
  script          VARCHAR2(1000 CHAR) not null
)
;
comment on table SYS_CODE_SCRIPTS
  is '系统编码规则';
comment on column SYS_CODE_SCRIPTS.id
  is '非业务主键';
comment on column SYS_CODE_SCRIPTS.created_at
  is '创建时间';
comment on column SYS_CODE_SCRIPTS.updated_at
  is '更新时间';
comment on column SYS_CODE_SCRIPTS.attr
  is '编码属性';
comment on column SYS_CODE_SCRIPTS.code_class_name
  is '编码对象的类名';
comment on column SYS_CODE_SCRIPTS.code_name
  is '编码对象';
comment on column SYS_CODE_SCRIPTS.description
  is '编码简要描述';
comment on column SYS_CODE_SCRIPTS.script
  is '编码脚本';
alter table SYS_CODE_SCRIPTS
  add primary key (ID);

prompt Creating SYS_MANAGER_DOCUMENTS...
create table SYS_MANAGER_DOCUMENTS
(
  id        NUMBER(19) not null,
  name      VARCHAR2(255 CHAR),
  path      VARCHAR2(255 CHAR),
  remark    VARCHAR2(255 CHAR),
  upload_by VARCHAR2(255 CHAR),
  upload_on DATE
)
;
comment on table SYS_MANAGER_DOCUMENTS
  is '面向管理人员的文档';
comment on column SYS_MANAGER_DOCUMENTS.id
  is '非业务主键';
comment on column SYS_MANAGER_DOCUMENTS.name
  is '名称';
comment on column SYS_MANAGER_DOCUMENTS.path
  is '路径';
comment on column SYS_MANAGER_DOCUMENTS.remark
  is '备注';
comment on column SYS_MANAGER_DOCUMENTS.upload_by
  is '上传人';
comment on column SYS_MANAGER_DOCUMENTS.upload_on
  is '上传时间';
alter table SYS_MANAGER_DOCUMENTS
  add primary key (ID);

prompt Creating SYS_NOTICE_CONTENTS...
create table SYS_NOTICE_CONTENTS
(
  id      NUMBER(19) not null,
  content VARCHAR2(4000 CHAR)
)
;
comment on table SYS_NOTICE_CONTENTS
  is '公告内容';
comment on column SYS_NOTICE_CONTENTS.id
  is '非业务主键';
comment on column SYS_NOTICE_CONTENTS.content
  is '内容';
alter table SYS_NOTICE_CONTENTS
  add primary key (ID);

prompt Creating SYS_MANAGER_NOTICES...
create table SYS_MANAGER_NOTICES
(
  id         NUMBER(19) not null,
  publisher  VARCHAR2(255 CHAR),
  title      VARCHAR2(255 CHAR),
  updated_at DATE,
  content_id NUMBER(19)
)
;
comment on table SYS_MANAGER_NOTICES
  is '面向管理人员的公告';
comment on column SYS_MANAGER_NOTICES.id
  is '非业务主键';
comment on column SYS_MANAGER_NOTICES.publisher
  is '发布人';
comment on column SYS_MANAGER_NOTICES.title
  is '标题';
comment on column SYS_MANAGER_NOTICES.updated_at
  is '修改时间';
comment on column SYS_MANAGER_NOTICES.content_id
  is '公告内容 ID ###引用表名是SYS_NOTICE_CONTENTS### ';
alter table SYS_MANAGER_NOTICES
  add primary key (ID);
alter table SYS_MANAGER_NOTICES
  add constraint FK_DIK1FO99L278W0CXTRYIU5V7L foreign key (CONTENT_ID)
  references SYS_NOTICE_CONTENTS (ID);

prompt Creating SYS_MESSAGE_CONTENTS...
create table SYS_MESSAGE_CONTENTS
(
  id            NUMBER(19) not null,
  active_on     TIMESTAMP(6),
  created_at    TIMESTAMP(6),
  invalidate_on TIMESTAMP(6),
  subject       VARCHAR2(255 CHAR),
  text          VARCHAR2(4000 CHAR),
  sender_id     NUMBER(19)
)
;
comment on table SYS_MESSAGE_CONTENTS
  is '系统消息';
comment on column SYS_MESSAGE_CONTENTS.id
  is '非业务主键';
comment on column SYS_MESSAGE_CONTENTS.active_on
  is '激活日期';
comment on column SYS_MESSAGE_CONTENTS.created_at
  is '消息创建日期';
comment on column SYS_MESSAGE_CONTENTS.invalidate_on
  is '失效日期';
comment on column SYS_MESSAGE_CONTENTS.subject
  is '标题';
comment on column SYS_MESSAGE_CONTENTS.text
  is '内容';
comment on column SYS_MESSAGE_CONTENTS.sender_id
  is '发送人 ID ###引用表名是SE_USERS### ';
alter table SYS_MESSAGE_CONTENTS
  add primary key (ID);
alter table SYS_MESSAGE_CONTENTS
  add constraint FK_PTUTHN89X78LS09107IQ5JR6E foreign key (SENDER_ID)
  references SE_USERS (ID);

prompt Creating SYS_SYSTEM_MESSAGE_CONFIGS...
create table SYS_SYSTEM_MESSAGE_CONFIGS
(
  id         NUMBER(19) not null,
  created_at TIMESTAMP(6),
  updated_at TIMESTAMP(6),
  begin_at   TIMESTAMP(6) not null,
  end_at     TIMESTAMP(6),
  opened     NUMBER(1) not null,
  project_id NUMBER(10)
)
;
comment on table SYS_SYSTEM_MESSAGE_CONFIGS
  is '系统消息配置';
comment on column SYS_SYSTEM_MESSAGE_CONFIGS.id
  is '非业务主键';
comment on column SYS_SYSTEM_MESSAGE_CONFIGS.created_at
  is '创建时间';
comment on column SYS_SYSTEM_MESSAGE_CONFIGS.updated_at
  is '更新时间';
comment on column SYS_SYSTEM_MESSAGE_CONFIGS.begin_at
  is '开始时间';
comment on column SYS_SYSTEM_MESSAGE_CONFIGS.end_at
  is '结束时间';
comment on column SYS_SYSTEM_MESSAGE_CONFIGS.opened
  is '是否开放';
comment on column SYS_SYSTEM_MESSAGE_CONFIGS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
alter table SYS_SYSTEM_MESSAGE_CONFIGS
  add primary key (ID);
alter table SYS_SYSTEM_MESSAGE_CONFIGS
  add constraint FK_KGRPRVH6PCO42Q874IOIOY49O foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating SYS_MSG_CFG_CATEGORIES...
create table SYS_MSG_CFG_CATEGORIES
(
  sys_msg_cfg_id NUMBER(19) not null,
  category_id    NUMBER(10) not null
)
;
comment on table SYS_MSG_CFG_CATEGORIES
  is '系统消息配置-适用角色';
comment on column SYS_MSG_CFG_CATEGORIES.sys_msg_cfg_id
  is '系统消息配置 ID ###引用表名是SYS_SYSTEM_MESSAGE_CONFIGS### ';
comment on column SYS_MSG_CFG_CATEGORIES.category_id
  is '角色信息 ID ###引用表名是SE_ROLES### ';
alter table SYS_MSG_CFG_CATEGORIES
  add primary key (SYS_MSG_CFG_ID, CATEGORY_ID);
alter table SYS_MSG_CFG_CATEGORIES
  add constraint FK_JPU4FSSPG0XJJQ2XVAM4B04V2 foreign key (SYS_MSG_CFG_ID)
  references SYS_SYSTEM_MESSAGE_CONFIGS (ID);
alter table SYS_MSG_CFG_CATEGORIES
  add constraint FK_NPS1L8RR0QHNDODUSTFEQX75P foreign key (CATEGORY_ID)
  references SE_ROLES (ID);

prompt Creating SYS_PROPERTY_CONFIG_ITEMS...
create table SYS_PROPERTY_CONFIG_ITEMS
(
  id          NUMBER(10) not null,
  description VARCHAR2(1000 CHAR) not null,
  name        VARCHAR2(100 CHAR) not null,
  type        VARCHAR2(200 CHAR) not null,
  value       VARCHAR2(1000 CHAR) not null
)
;
comment on table SYS_PROPERTY_CONFIG_ITEMS
  is '系统配置项';
comment on column SYS_PROPERTY_CONFIG_ITEMS.id
  is '非业务主键';
comment on column SYS_PROPERTY_CONFIG_ITEMS.description
  is '描述';
comment on column SYS_PROPERTY_CONFIG_ITEMS.name
  is '名称';
comment on column SYS_PROPERTY_CONFIG_ITEMS.type
  is '类型';
comment on column SYS_PROPERTY_CONFIG_ITEMS.value
  is '值';
alter table SYS_PROPERTY_CONFIG_ITEMS
  add primary key (ID);

prompt Creating SYS_REPORT_TEMPLATES...
create table SYS_REPORT_TEMPLATES
(
  id          NUMBER(19) not null,
  created_at  TIMESTAMP(6),
  updated_at  TIMESTAMP(6),
  category    VARCHAR2(255 CHAR) not null,
  code        VARCHAR2(50 CHAR) not null,
  name        VARCHAR2(100 CHAR) not null,
  options     VARCHAR2(500 CHAR),
  orientation VARCHAR2(255 CHAR),
  page_size   VARCHAR2(255 CHAR) not null,
  remark      VARCHAR2(500 CHAR),
  template    VARCHAR2(200 CHAR) not null,
  project_id  NUMBER(10)
)
;
comment on table SYS_REPORT_TEMPLATES
  is '报表模板默认实现';
comment on column SYS_REPORT_TEMPLATES.id
  is '非业务主键';
comment on column SYS_REPORT_TEMPLATES.created_at
  is '创建时间';
comment on column SYS_REPORT_TEMPLATES.updated_at
  is '更新时间';
comment on column SYS_REPORT_TEMPLATES.category
  is '类别';
comment on column SYS_REPORT_TEMPLATES.code
  is '代码(项目内重复)';
comment on column SYS_REPORT_TEMPLATES.name
  is '名称';
comment on column SYS_REPORT_TEMPLATES.options
  is '选项';
comment on column SYS_REPORT_TEMPLATES.orientation
  is '横向Portrait/纵向Landscape';
comment on column SYS_REPORT_TEMPLATES.page_size
  is '纸张大小';
comment on column SYS_REPORT_TEMPLATES.remark
  is '备注';
comment on column SYS_REPORT_TEMPLATES.template
  is '模板路径';
comment on column SYS_REPORT_TEMPLATES.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
alter table SYS_REPORT_TEMPLATES
  add primary key (ID);
alter table SYS_REPORT_TEMPLATES
  add constraint FK_81QBPD1FLBA12MGJEYKV1UMRN foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating SYS_RULE_PARAMETERS...
create table SYS_RULE_PARAMETERS
(
  id          NUMBER(10) not null,
  description VARCHAR2(100 CHAR) not null,
  name        VARCHAR2(100 CHAR) not null,
  title       VARCHAR2(100 CHAR) not null,
  type        VARCHAR2(100 CHAR) not null,
  parent_id   NUMBER(10),
  rule_id     NUMBER(10)
)
;
comment on table SYS_RULE_PARAMETERS
  is '规则参数';
comment on column SYS_RULE_PARAMETERS.id
  is '非业务主键';
comment on column SYS_RULE_PARAMETERS.description
  is '参数描述';
comment on column SYS_RULE_PARAMETERS.name
  is '参数名称';
comment on column SYS_RULE_PARAMETERS.title
  is '参数标题';
comment on column SYS_RULE_PARAMETERS.type
  is '参数类型';
comment on column SYS_RULE_PARAMETERS.parent_id
  is '上级参数 ID ###引用表名是SYS_RULE_PARAMETERS### ';
comment on column SYS_RULE_PARAMETERS.rule_id
  is '业务规则 ID ###引用表名是SYS_RULES### ';
alter table SYS_RULE_PARAMETERS
  add primary key (ID);
alter table SYS_RULE_PARAMETERS
  add constraint FK_8WB2BL8LYPBV58KKJVYPFNAPE foreign key (PARENT_ID)
  references SYS_RULE_PARAMETERS (ID);
alter table SYS_RULE_PARAMETERS
  add constraint FK_OO3H7TPTSJXTB884JA2UYI16E foreign key (RULE_ID)
  references SYS_RULES (ID);

prompt Creating SYS_RULE_CONFIG_PARAMS...
create table SYS_RULE_CONFIG_PARAMS
(
  id        NUMBER(10) not null,
  value     VARCHAR2(500 CHAR) not null,
  config_id NUMBER(10) not null,
  param_id  NUMBER(10) not null
)
;
comment on table SYS_RULE_CONFIG_PARAMS
  is '规则参数配置';
comment on column SYS_RULE_CONFIG_PARAMS.id
  is '非业务主键';
comment on column SYS_RULE_CONFIG_PARAMS.value
  is '参数值';
comment on column SYS_RULE_CONFIG_PARAMS.config_id
  is '标准-规则 ID ###引用表名是SYS_RULE_CONFIGS### ';
comment on column SYS_RULE_CONFIG_PARAMS.param_id
  is '规则参数 ID ###引用表名是SYS_RULE_PARAMETERS### ';
alter table SYS_RULE_CONFIG_PARAMS
  add primary key (ID);
alter table SYS_RULE_CONFIG_PARAMS
  add constraint FK_8MX5CYLYU6H65OKVI54TGOY7U foreign key (PARAM_ID)
  references SYS_RULE_PARAMETERS (ID);
alter table SYS_RULE_CONFIG_PARAMS
  add constraint FK_IC6U2JTGJV1V7H9W6SFBXOK0S foreign key (CONFIG_ID)
  references SYS_RULE_CONFIGS (ID);

prompt Creating SYS_STUDENT_DOCUMENTS...
create table SYS_STUDENT_DOCUMENTS
(
  id        NUMBER(19) not null,
  name      VARCHAR2(255 CHAR),
  path      VARCHAR2(255 CHAR),
  remark    VARCHAR2(255 CHAR),
  upload_by VARCHAR2(255 CHAR),
  upload_on DATE
)
;
comment on table SYS_STUDENT_DOCUMENTS
  is '面向学生的文档';
comment on column SYS_STUDENT_DOCUMENTS.id
  is '非业务主键';
comment on column SYS_STUDENT_DOCUMENTS.name
  is '名称';
comment on column SYS_STUDENT_DOCUMENTS.path
  is '路径';
comment on column SYS_STUDENT_DOCUMENTS.remark
  is '备注';
comment on column SYS_STUDENT_DOCUMENTS.upload_by
  is '上传人';
comment on column SYS_STUDENT_DOCUMENTS.upload_on
  is '上传时间';
alter table SYS_STUDENT_DOCUMENTS
  add primary key (ID);

prompt Creating SYS_STD_DOCS_STD_TYPES...
create table SYS_STD_DOCS_STD_TYPES
(
  student_document_id NUMBER(19) not null,
  std_type_id         NUMBER(10) not null
)
;
comment on table SYS_STD_DOCS_STD_TYPES
  is '面向学生的文档-学生类型列表';
comment on column SYS_STD_DOCS_STD_TYPES.student_document_id
  is '面向学生的文档 ID ###引用表名是SYS_STUDENT_DOCUMENTS### ';
comment on column SYS_STD_DOCS_STD_TYPES.std_type_id
  is '学生类别 ID ###引用表名是XB_STD_TYPES### ';
alter table SYS_STD_DOCS_STD_TYPES
  add primary key (STUDENT_DOCUMENT_ID, STD_TYPE_ID);
alter table SYS_STD_DOCS_STD_TYPES
  add constraint FK_8TOVC7HIXWSULIRVVFQI8TMRM foreign key (STUDENT_DOCUMENT_ID)
  references SYS_STUDENT_DOCUMENTS (ID);
alter table SYS_STD_DOCS_STD_TYPES
  add constraint FK_DTOUFKJIX4HMPRQBVBO02V6CN foreign key (STD_TYPE_ID)
  references XB_STD_TYPES (ID);

prompt Creating SYS_STUDENT_DOCUMENTS_DEPARTS...
create table SYS_STUDENT_DOCUMENTS_DEPARTS
(
  student_document_id NUMBER(19) not null,
  department_id       NUMBER(10) not null
)
;
comment on table SYS_STUDENT_DOCUMENTS_DEPARTS
  is '面向学生的文档-部门列表';
comment on column SYS_STUDENT_DOCUMENTS_DEPARTS.student_document_id
  is '面向学生的文档 ID ###引用表名是SYS_STUDENT_DOCUMENTS### ';
comment on column SYS_STUDENT_DOCUMENTS_DEPARTS.department_id
  is '部门组织机构信息 ID ###引用表名是C_DEPARTMENTS### ';
alter table SYS_STUDENT_DOCUMENTS_DEPARTS
  add primary key (STUDENT_DOCUMENT_ID, DEPARTMENT_ID);
alter table SYS_STUDENT_DOCUMENTS_DEPARTS
  add constraint FK_14AKFP730D7RWGB6UNY56FCLB foreign key (STUDENT_DOCUMENT_ID)
  references SYS_STUDENT_DOCUMENTS (ID);
alter table SYS_STUDENT_DOCUMENTS_DEPARTS
  add constraint FK_AAD5OCWLEG6N7UVDN6IRXGVQO foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);

prompt Creating SYS_STUDENT_NOTICES...
create table SYS_STUDENT_NOTICES
(
  id         NUMBER(19) not null,
  publisher  VARCHAR2(255 CHAR),
  title      VARCHAR2(255 CHAR),
  updated_at DATE,
  content_id NUMBER(19)
)
;
comment on table SYS_STUDENT_NOTICES
  is '面向学生的公告';
comment on column SYS_STUDENT_NOTICES.id
  is '非业务主键';
comment on column SYS_STUDENT_NOTICES.publisher
  is '发布人';
comment on column SYS_STUDENT_NOTICES.title
  is '标题';
comment on column SYS_STUDENT_NOTICES.updated_at
  is '修改时间';
comment on column SYS_STUDENT_NOTICES.content_id
  is '公告内容 ID ###引用表名是SYS_NOTICE_CONTENTS### ';
alter table SYS_STUDENT_NOTICES
  add primary key (ID);
alter table SYS_STUDENT_NOTICES
  add constraint FK_5FB85H1M3B1F2QEE9JYT6RV2I foreign key (CONTENT_ID)
  references SYS_NOTICE_CONTENTS (ID);

prompt Creating SYS_STUDENT_NOTICES_DEPARTS...
create table SYS_STUDENT_NOTICES_DEPARTS
(
  student_notice_id NUMBER(19) not null,
  department_id     NUMBER(10) not null
)
;
comment on table SYS_STUDENT_NOTICES_DEPARTS
  is '面向学生的公告-面向的部门';
comment on column SYS_STUDENT_NOTICES_DEPARTS.student_notice_id
  is '面向学生的公告 ID ###引用表名是SYS_STUDENT_NOTICES### ';
comment on column SYS_STUDENT_NOTICES_DEPARTS.department_id
  is '部门组织机构信息 ID ###引用表名是C_DEPARTMENTS### ';
alter table SYS_STUDENT_NOTICES_DEPARTS
  add primary key (STUDENT_NOTICE_ID, DEPARTMENT_ID);
alter table SYS_STUDENT_NOTICES_DEPARTS
  add constraint FK_4YD0CB5XX3YS941YCLWBN6Y5N foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table SYS_STUDENT_NOTICES_DEPARTS
  add constraint FK_9YEYWWP1DQN8A1DGUYL9EJNTJ foreign key (STUDENT_NOTICE_ID)
  references SYS_STUDENT_NOTICES (ID);

prompt Creating SYS_STUDENT_NOTICES_STD_TYPES...
create table SYS_STUDENT_NOTICES_STD_TYPES
(
  student_notice_id NUMBER(19) not null,
  std_type_id       NUMBER(10) not null
)
;
comment on table SYS_STUDENT_NOTICES_STD_TYPES
  is '面向学生的公告-面向的学生类别';
comment on column SYS_STUDENT_NOTICES_STD_TYPES.student_notice_id
  is '面向学生的公告 ID ###引用表名是SYS_STUDENT_NOTICES### ';
comment on column SYS_STUDENT_NOTICES_STD_TYPES.std_type_id
  is '学生类别 ID ###引用表名是XB_STD_TYPES### ';
alter table SYS_STUDENT_NOTICES_STD_TYPES
  add primary key (STUDENT_NOTICE_ID, STD_TYPE_ID);
alter table SYS_STUDENT_NOTICES_STD_TYPES
  add constraint FK_BSI8OJBA8YR38RQV5I4QHVRE9 foreign key (STUDENT_NOTICE_ID)
  references SYS_STUDENT_NOTICES (ID);
alter table SYS_STUDENT_NOTICES_STD_TYPES
  add constraint FK_PXB11QWW0DKM7FYDP4UKVTQJA foreign key (STD_TYPE_ID)
  references XB_STD_TYPES (ID);

prompt Creating SYS_SYSTEM_MESSAGES...
create table SYS_SYSTEM_MESSAGES
(
  id           NUMBER(19) not null,
  read_at      TIMESTAMP(6),
  status       NUMBER(10),
  visit_ip     VARCHAR2(255 CHAR),
  content_id   NUMBER(19) not null,
  recipient_id NUMBER(19)
)
;
comment on table SYS_SYSTEM_MESSAGES
  is '系统消息';
comment on column SYS_SYSTEM_MESSAGES.id
  is '非业务主键';
comment on column SYS_SYSTEM_MESSAGES.read_at
  is '阅读时间';
comment on column SYS_SYSTEM_MESSAGES.status
  is '消息状态';
comment on column SYS_SYSTEM_MESSAGES.visit_ip
  is '访问IP';
comment on column SYS_SYSTEM_MESSAGES.content_id
  is '消息主题 ID ###引用表名是SYS_MESSAGE_CONTENTS### ';
comment on column SYS_SYSTEM_MESSAGES.recipient_id
  is '接受者 ID ###引用表名是SE_USERS### ';
alter table SYS_SYSTEM_MESSAGES
  add primary key (ID);
alter table SYS_SYSTEM_MESSAGES
  add constraint UK_JCRPLNK4UXU629V3RCD6L2PA8 unique (CONTENT_ID, RECIPIENT_ID);
alter table SYS_SYSTEM_MESSAGES
  add constraint FK_NL1F4G0AUHQLME8A0W0Y5DNEY foreign key (RECIPIENT_ID)
  references SE_USERS (ID);
alter table SYS_SYSTEM_MESSAGES
  add constraint FK_TLSO104QPM7TIV4FGD63I4TVT foreign key (CONTENT_ID)
  references SYS_MESSAGE_CONTENTS (ID);

prompt Creating SYS_TEACHER_DOCUMENTS...
create table SYS_TEACHER_DOCUMENTS
(
  id        NUMBER(19) not null,
  name      VARCHAR2(255 CHAR),
  path      VARCHAR2(255 CHAR),
  remark    VARCHAR2(255 CHAR),
  upload_by VARCHAR2(255 CHAR),
  upload_on DATE
)
;
comment on table SYS_TEACHER_DOCUMENTS
  is '面向教师的文档';
comment on column SYS_TEACHER_DOCUMENTS.id
  is '非业务主键';
comment on column SYS_TEACHER_DOCUMENTS.name
  is '名称';
comment on column SYS_TEACHER_DOCUMENTS.path
  is '路径';
comment on column SYS_TEACHER_DOCUMENTS.remark
  is '备注';
comment on column SYS_TEACHER_DOCUMENTS.upload_by
  is '上传人';
comment on column SYS_TEACHER_DOCUMENTS.upload_on
  is '上传时间';
alter table SYS_TEACHER_DOCUMENTS
  add primary key (ID);

prompt Creating SYS_TEACHER_NOTICES...
create table SYS_TEACHER_NOTICES
(
  id         NUMBER(19) not null,
  publisher  VARCHAR2(255 CHAR),
  title      VARCHAR2(255 CHAR),
  updated_at DATE,
  content_id NUMBER(19)
)
;
comment on table SYS_TEACHER_NOTICES
  is '面向老师的公告';
comment on column SYS_TEACHER_NOTICES.id
  is '非业务主键';
comment on column SYS_TEACHER_NOTICES.publisher
  is '发布人';
comment on column SYS_TEACHER_NOTICES.title
  is '标题';
comment on column SYS_TEACHER_NOTICES.updated_at
  is '修改时间';
comment on column SYS_TEACHER_NOTICES.content_id
  is '公告内容 ID ###引用表名是SYS_NOTICE_CONTENTS### ';
alter table SYS_TEACHER_NOTICES
  add primary key (ID);
alter table SYS_TEACHER_NOTICES
  add constraint FK_FVM8N978V9KCF4GQIIKTHA0RI foreign key (CONTENT_ID)
  references SYS_NOTICE_CONTENTS (ID);

prompt Creating S_AWARDS...
create table S_AWARDS
(
  id          NUMBER(19) not null,
  doc_seq     VARCHAR2(255 CHAR) not null,
  name        VARCHAR2(255 CHAR) not null,
  present_on  DATE not null,
  reason      VARCHAR2(500 CHAR),
  remark      VARCHAR2(500 CHAR),
  valid       NUMBER(1) not null,
  withdraw_on DATE,
  depart_id   NUMBER(10),
  semester_id NUMBER(10),
  std_id      NUMBER(19) not null,
  type_id     NUMBER(10) not null
)
;
comment on table S_AWARDS
  is '奖励记录';
comment on column S_AWARDS.id
  is '非业务主键';
comment on column S_AWARDS.doc_seq
  is '奖励文号';
comment on column S_AWARDS.name
  is '奖励名称';
comment on column S_AWARDS.present_on
  is '日期';
comment on column S_AWARDS.reason
  is '奖励原因';
comment on column S_AWARDS.remark
  is '备注';
comment on column S_AWARDS.valid
  is '是否有效';
comment on column S_AWARDS.withdraw_on
  is '撤销日期';
comment on column S_AWARDS.depart_id
  is '部门 ID ###引用表名是C_DEPARTMENTS### ';
comment on column S_AWARDS.semester_id
  is '教学日历 ID ###引用表名是C_SEMESTERS### ';
comment on column S_AWARDS.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
comment on column S_AWARDS.type_id
  is '奖励类型 ID ###引用表名是HB_STD_AWARD_TYPES### ';
alter table S_AWARDS
  add primary key (ID);
alter table S_AWARDS
  add constraint FK_8DC03GU838AMKURNT9K4O1UVG foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table S_AWARDS
  add constraint FK_B2RP9T513013K6DFBCOGR7DGK foreign key (DEPART_ID)
  references C_DEPARTMENTS (ID);
alter table S_AWARDS
  add constraint FK_IY5C1HBP9I8IEKXEY9DG134JD foreign key (TYPE_ID)
  references HB_STD_AWARD_TYPES (ID);
alter table S_AWARDS
  add constraint FK_TI41CNKP1JJY5B1V25009J709 foreign key (STD_ID)
  references C_STUDENTS (ID);

prompt Creating S_PUNISHMENTS...
create table S_PUNISHMENTS
(
  id          NUMBER(19) not null,
  doc_seq     VARCHAR2(255 CHAR),
  name        VARCHAR2(255 CHAR) not null,
  present_on  DATE not null,
  reason      VARCHAR2(500 CHAR),
  remark      VARCHAR2(500 CHAR),
  valid       NUMBER(1) not null,
  withdraw_on DATE,
  depart_id   NUMBER(10),
  semester_id NUMBER(10),
  std_id      NUMBER(19) not null,
  type_id     NUMBER(10) not null
)
;
comment on table S_PUNISHMENTS
  is '处分记录';
comment on column S_PUNISHMENTS.id
  is '非业务主键';
comment on column S_PUNISHMENTS.doc_seq
  is '处分文号';
comment on column S_PUNISHMENTS.name
  is '处分名称';
comment on column S_PUNISHMENTS.present_on
  is '日期';
comment on column S_PUNISHMENTS.reason
  is '处分原因';
comment on column S_PUNISHMENTS.remark
  is '备注';
comment on column S_PUNISHMENTS.valid
  is '是否有效';
comment on column S_PUNISHMENTS.withdraw_on
  is '撤销日期';
comment on column S_PUNISHMENTS.depart_id
  is '部门 ID ###引用表名是C_DEPARTMENTS### ';
comment on column S_PUNISHMENTS.semester_id
  is '教学日历 ID ###引用表名是C_SEMESTERS### ';
comment on column S_PUNISHMENTS.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
comment on column S_PUNISHMENTS.type_id
  is '处分类别 ID ###引用表名是HB_STD_PUNISH_TYPES### ';
alter table S_PUNISHMENTS
  add primary key (ID);
alter table S_PUNISHMENTS
  add constraint FK_FE75IAWJ8SCJ8N2J0O0T88KY2 foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table S_PUNISHMENTS
  add constraint FK_ID9CELGC5BVX58ESHYO1OMYA0 foreign key (TYPE_ID)
  references HB_STD_PUNISH_TYPES (ID);
alter table S_PUNISHMENTS
  add constraint FK_K0QXBPDWQV2P3QJ4DDARCJIDQ foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table S_PUNISHMENTS
  add constraint FK_NSNSP28M0GLHUAABO7K6TDAP1 foreign key (DEPART_ID)
  references C_DEPARTMENTS (ID);

prompt Creating S_STD_ABROADS...
create table S_STD_ABROADS
(
  id                     NUMBER(19) not null,
  created_at             TIMESTAMP(6),
  updated_at             TIMESTAMP(6),
  cscno                  VARCHAR2(255 CHAR),
  passport_expired_on    DATE,
  passport_no            VARCHAR2(255 CHAR),
  reside_caed_expired_on DATE,
  reside_caed_no         VARCHAR2(255 CHAR),
  visa_expired_on        DATE,
  visa_no                VARCHAR2(255 CHAR),
  person_id              NUMBER(19),
  hskdegree_id           NUMBER(10),
  passport_type_id       NUMBER(10),
  visa_type_id           NUMBER(10)
)
;
comment on table S_STD_ABROADS
  is '留学生信息';
comment on column S_STD_ABROADS.id
  is '非业务主键';
comment on column S_STD_ABROADS.created_at
  is '创建时间';
comment on column S_STD_ABROADS.updated_at
  is '更新时间';
comment on column S_STD_ABROADS.cscno
  is 'CSC编号';
comment on column S_STD_ABROADS.passport_expired_on
  is '护照到期时间';
comment on column S_STD_ABROADS.passport_no
  is '护照编号';
comment on column S_STD_ABROADS.reside_caed_expired_on
  is '居住许可证到期时间';
comment on column S_STD_ABROADS.reside_caed_no
  is '居住许可证编号';
comment on column S_STD_ABROADS.visa_expired_on
  is '签证到期时间';
comment on column S_STD_ABROADS.visa_no
  is '签证编号';
comment on column S_STD_ABROADS.person_id
  is 'person ID ###引用表名是C_STD_PEOPLE### ';
comment on column S_STD_ABROADS.hskdegree_id
  is '留学生HSK等级 ID ###引用表名是HB_HSKDEGREES### ';
comment on column S_STD_ABROADS.passport_type_id
  is '护照类别 ID ###引用表名是HB_PASSPORT_TYPES### ';
comment on column S_STD_ABROADS.visa_type_id
  is '签证类别 ID ###引用表名是HB_VISA_TYPES### ';
alter table S_STD_ABROADS
  add primary key (ID);
alter table S_STD_ABROADS
  add constraint UK_SGVV4YJLVWS3VKFS8L2BA8H65 unique (PERSON_ID);
alter table S_STD_ABROADS
  add constraint FK_AEP33ADWMGL4BC3HB7K2HKRBQ foreign key (PERSON_ID)
  references C_STD_PEOPLE (ID);
alter table S_STD_ABROADS
  add constraint FK_B62P7IJ6DQJOCANNEVSEIUV86 foreign key (VISA_TYPE_ID)
  references HB_VISA_TYPES (ID);
alter table S_STD_ABROADS
  add constraint FK_E8G50AFOAICDA6F67FC0E8PN5 foreign key (PASSPORT_TYPE_ID)
  references HB_PASSPORT_TYPES (ID);
alter table S_STD_ABROADS
  add constraint FK_G17RW7LRFBFNSF731E6NWH8TL foreign key (HSKDEGREE_ID)
  references HB_HSKDEGREES (ID);

prompt Creating S_STD_APPLY_EDIT_NOTESES...
create table S_STD_APPLY_EDIT_NOTESES
(
  id             NUMBER(19) not null,
  address        VARCHAR2(255 CHAR),
  birthday       DATE,
  idcard         VARCHAR2(255 CHAR),
  mail           VARCHAR2(255 CHAR),
  mobile         VARCHAR2(255 CHAR),
  name           VARCHAR2(255 CHAR),
  phone          VARCHAR2(255 CHAR),
  idcard_type_id NUMBER(10)
)
;
comment on table S_STD_APPLY_EDIT_NOTESES
  is '学生申请修改内容表';
comment on column S_STD_APPLY_EDIT_NOTESES.id
  is '非业务主键';
comment on column S_STD_APPLY_EDIT_NOTESES.address
  is '地址';
comment on column S_STD_APPLY_EDIT_NOTESES.birthday
  is '出生年月';
comment on column S_STD_APPLY_EDIT_NOTESES.idcard
  is '身份证';
comment on column S_STD_APPLY_EDIT_NOTESES.mail
  is '邮件';
comment on column S_STD_APPLY_EDIT_NOTESES.mobile
  is '移动电话';
comment on column S_STD_APPLY_EDIT_NOTESES.name
  is '姓名';
comment on column S_STD_APPLY_EDIT_NOTESES.phone
  is '电话';
comment on column S_STD_APPLY_EDIT_NOTESES.idcard_type_id
  is '证件类型 ID ###引用表名是HB_IDCARD_TYPES### ';
alter table S_STD_APPLY_EDIT_NOTESES
  add primary key (ID);
alter table S_STD_APPLY_EDIT_NOTESES
  add constraint FK_NC7W5RUGG5RPVA5KBH2S9EE8R foreign key (IDCARD_TYPE_ID)
  references HB_IDCARD_TYPES (ID);

prompt Creating S_STD_CONTACTS...
create table S_STD_CONTACTS
(
  id         NUMBER(19) not null,
  created_at TIMESTAMP(6),
  updated_at TIMESTAMP(6),
  address    VARCHAR2(255 CHAR),
  mail       VARCHAR2(255 CHAR),
  mobile     VARCHAR2(255 CHAR),
  phone      VARCHAR2(255 CHAR),
  person_id  NUMBER(19)
)
;
comment on table S_STD_CONTACTS
  is '学生联系信息';
comment on column S_STD_CONTACTS.id
  is '非业务主键';
comment on column S_STD_CONTACTS.created_at
  is '创建时间';
comment on column S_STD_CONTACTS.updated_at
  is '更新时间';
comment on column S_STD_CONTACTS.address
  is '地址 入校后联系地址';
comment on column S_STD_CONTACTS.mail
  is '电子邮箱';
comment on column S_STD_CONTACTS.mobile
  is '移动电话';
comment on column S_STD_CONTACTS.phone
  is '电话';
comment on column S_STD_CONTACTS.person_id
  is 'person ID ###引用表名是C_STD_PEOPLE### ';
alter table S_STD_CONTACTS
  add primary key (ID);
alter table S_STD_CONTACTS
  add constraint UK_2L6692QJPL33FNKRIN2TK8RTU unique (PERSON_ID);
alter table S_STD_CONTACTS
  add constraint FK_7871HCHM05RPQMISVC16F7APY foreign key (PERSON_ID)
  references C_STD_PEOPLE (ID);

prompt Creating S_STD_HOMES...
create table S_STD_HOMES
(
  id                 NUMBER(19) not null,
  created_at         TIMESTAMP(6),
  updated_at         TIMESTAMP(6),
  address            VARCHAR2(255 CHAR),
  former_addr        VARCHAR2(255 CHAR),
  phone              VARCHAR2(255 CHAR),
  police             VARCHAR2(255 CHAR),
  police_phone       VARCHAR2(255 CHAR),
  postcode           VARCHAR2(255 CHAR),
  person_id          NUMBER(19),
  economic_state_id  NUMBER(10),
  railway_station_id NUMBER(10)
)
;
comment on table S_STD_HOMES
  is '学生家庭信息';
comment on column S_STD_HOMES.id
  is '非业务主键';
comment on column S_STD_HOMES.created_at
  is '创建时间';
comment on column S_STD_HOMES.updated_at
  is '更新时间';
comment on column S_STD_HOMES.address
  is '家庭地址';
comment on column S_STD_HOMES.former_addr
  is '户籍';
comment on column S_STD_HOMES.phone
  is '家庭电话';
comment on column S_STD_HOMES.police
  is '派出所';
comment on column S_STD_HOMES.police_phone
  is '派出所电话';
comment on column S_STD_HOMES.postcode
  is '家庭地址邮编';
comment on column S_STD_HOMES.person_id
  is 'person ID ###引用表名是C_STD_PEOPLE### ';
comment on column S_STD_HOMES.economic_state_id
  is '家庭经济状况 ID ###引用表名是HB_FAMILY_ECONOMIC_STATES### ';
comment on column S_STD_HOMES.railway_station_id
  is '火车站 用于打印学生证 ID ###引用表名是HB_RAILWAY_STATIONS### ';
alter table S_STD_HOMES
  add primary key (ID);
alter table S_STD_HOMES
  add constraint UK_U9LUF7DW4UE9PIEX66BNPV3L unique (PERSON_ID);
alter table S_STD_HOMES
  add constraint FK_54H4UXXROY245HLRN8G3LQHMO foreign key (RAILWAY_STATION_ID)
  references HB_RAILWAY_STATIONS (ID);
alter table S_STD_HOMES
  add constraint FK_BGSWKAN14E30VR3EBUSB44BE5 foreign key (ECONOMIC_STATE_ID)
  references HB_FAMILY_ECONOMIC_STATES (ID);
alter table S_STD_HOMES
  add constraint FK_DFU9I88WXFXEESS2ARISDQN42 foreign key (PERSON_ID)
  references C_STD_PEOPLE (ID);

prompt Creating S_STD_HOME_MEMBERS...
create table S_STD_HOME_MEMBERS
(
  id          NUMBER(19) not null,
  address     VARCHAR2(255 CHAR),
  duty        VARCHAR2(255 CHAR),
  idcard      VARCHAR2(255 CHAR),
  name        VARCHAR2(255 CHAR) not null,
  phone       VARCHAR2(255 CHAR),
  postcode    VARCHAR2(255 CHAR),
  workplace   VARCHAR2(255 CHAR),
  home_id     NUMBER(19) not null,
  relation_id NUMBER(10) not null
)
;
comment on table S_STD_HOME_MEMBERS
  is '家庭成员信息实现';
comment on column S_STD_HOME_MEMBERS.id
  is '非业务主键';
comment on column S_STD_HOME_MEMBERS.address
  is '工作地址';
comment on column S_STD_HOME_MEMBERS.duty
  is '职务';
comment on column S_STD_HOME_MEMBERS.idcard
  is '证件号码';
comment on column S_STD_HOME_MEMBERS.name
  is '姓名 成员姓名';
comment on column S_STD_HOME_MEMBERS.phone
  is '联系电话';
comment on column S_STD_HOME_MEMBERS.postcode
  is '工作单位邮编';
comment on column S_STD_HOME_MEMBERS.workplace
  is '工作单位';
comment on column S_STD_HOME_MEMBERS.home_id
  is '家庭信息 ID ###引用表名是S_STD_HOMES### ';
comment on column S_STD_HOME_MEMBERS.relation_id
  is '与本人关系 父子/夫妻/母子/兄弟/姐妹/兄妹 ID ###引用表名是GB_SOCIAL_RELATIONS### ';
alter table S_STD_HOME_MEMBERS
  add primary key (ID);
alter table S_STD_HOME_MEMBERS
  add constraint FK_5MEHOUT88GL0Q9JA3HV12N46A foreign key (HOME_ID)
  references S_STD_HOMES (ID);
alter table S_STD_HOME_MEMBERS
  add constraint FK_SYOX2AKCMG61KSJRPQK5SH8N1 foreign key (RELATION_ID)
  references GB_SOCIAL_RELATIONS (ID);

prompt Creating S_STUDENT_APPLY_EDITS...
create table S_STUDENT_APPLY_EDITS
(
  id         NUMBER(19) not null,
  audit_time TIMESTAMP(6),
  status     NUMBER(10),
  time       TIMESTAMP(6),
  before_id  NUMBER(19),
  now_id     NUMBER(19),
  std_id     NUMBER(19)
)
;
comment on table S_STUDENT_APPLY_EDITS
  is '学生申请修改资料表';
comment on column S_STUDENT_APPLY_EDITS.id
  is '非业务主键';
comment on column S_STUDENT_APPLY_EDITS.audit_time
  is '审核时间';
comment on column S_STUDENT_APPLY_EDITS.status
  is '审核状态';
comment on column S_STUDENT_APPLY_EDITS.time
  is '申请时间';
comment on column S_STUDENT_APPLY_EDITS.before_id
  is '申请前内容 ID ###引用表名是S_STD_APPLY_EDIT_NOTESES### ';
comment on column S_STUDENT_APPLY_EDITS.now_id
  is '申请后内容 ID ###引用表名是S_STD_APPLY_EDIT_NOTESES### ';
comment on column S_STUDENT_APPLY_EDITS.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table S_STUDENT_APPLY_EDITS
  add primary key (ID);
alter table S_STUDENT_APPLY_EDITS
  add constraint FK_32R8FDWAT9V46NA193TKVE5M2 foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table S_STUDENT_APPLY_EDITS
  add constraint FK_C3BP2805HHC1GD4V0YH5NX36W foreign key (NOW_ID)
  references S_STD_APPLY_EDIT_NOTESES (ID);
alter table S_STUDENT_APPLY_EDITS
  add constraint FK_FXKVNQAI2RT2L97OH4QGXQJ74 foreign key (BEFORE_ID)
  references S_STD_APPLY_EDIT_NOTESES (ID);

prompt Creating S_STUDENT_EQUIVALENTS...
create table S_STUDENT_EQUIVALENTS
(
  id                        NUMBER(19) not null,
  created_at                TIMESTAMP(6),
  updated_at                TIMESTAMP(6),
  admin_duty                VARCHAR2(255 CHAR),
  apply_no                  VARCHAR2(255 CHAR),
  apply_on                  DATE,
  exam                      VARCHAR2(255 CHAR),
  exam_certificate_no       VARCHAR2(255 CHAR),
  exam_on                   VARCHAR2(255 CHAR),
  exam_score                VARCHAR2(255 CHAR),
  language                  VARCHAR2(255 CHAR),
  language_certificate_no   VARCHAR2(255 CHAR),
  language_on               VARCHAR2(255 CHAR),
  language_score            VARCHAR2(255 CHAR),
  recommender1              VARCHAR2(255 CHAR),
  recommender1_company      VARCHAR2(255 CHAR),
  recommender1_special_duty VARCHAR2(255 CHAR),
  recommender2              VARCHAR2(255 CHAR),
  recommender2_company      VARCHAR2(255 CHAR),
  recommender2_special_duty VARCHAR2(255 CHAR),
  special_duty              VARCHAR2(255 CHAR),
  work_time                 VARCHAR2(255 CHAR),
  person_id                 NUMBER(19)
)
;
comment on table S_STUDENT_EQUIVALENTS
  is '同等学力 学历学位信息';
comment on column S_STUDENT_EQUIVALENTS.id
  is '非业务主键';
comment on column S_STUDENT_EQUIVALENTS.created_at
  is 'createdAt';
comment on column S_STUDENT_EQUIVALENTS.updated_at
  is 'updatedAt';
comment on column S_STUDENT_EQUIVALENTS.admin_duty
  is '行政职务';
comment on column S_STUDENT_EQUIVALENTS.apply_no
  is '申请编号';
comment on column S_STUDENT_EQUIVALENTS.apply_on
  is '申请时间';
comment on column S_STUDENT_EQUIVALENTS.exam
  is '综合考试名称';
comment on column S_STUDENT_EQUIVALENTS.exam_certificate_no
  is '综合考试证书号';
comment on column S_STUDENT_EQUIVALENTS.exam_on
  is '综合考试日期';
comment on column S_STUDENT_EQUIVALENTS.exam_score
  is '综合考试分数';
comment on column S_STUDENT_EQUIVALENTS.language
  is '外语统考名称';
comment on column S_STUDENT_EQUIVALENTS.language_certificate_no
  is '外语统考证书号';
comment on column S_STUDENT_EQUIVALENTS.language_on
  is '外语统考日期';
comment on column S_STUDENT_EQUIVALENTS.language_score
  is '外语统考分数';
comment on column S_STUDENT_EQUIVALENTS.recommender1
  is '推荐人1';
comment on column S_STUDENT_EQUIVALENTS.recommender1_company
  is '推荐人1工作单位';
comment on column S_STUDENT_EQUIVALENTS.recommender1_special_duty
  is '推荐人1专业职务';
comment on column S_STUDENT_EQUIVALENTS.recommender2
  is '推荐人2';
comment on column S_STUDENT_EQUIVALENTS.recommender2_company
  is '推荐人2工作单位';
comment on column S_STUDENT_EQUIVALENTS.recommender2_special_duty
  is '推荐人2专业职务';
comment on column S_STUDENT_EQUIVALENTS.special_duty
  is '技能职务';
comment on column S_STUDENT_EQUIVALENTS.work_time
  is '工作年限';
comment on column S_STUDENT_EQUIVALENTS.person_id
  is 'person ID ###引用表名是C_STD_PEOPLE### ';
alter table S_STUDENT_EQUIVALENTS
  add primary key (ID);
alter table S_STUDENT_EQUIVALENTS
  add constraint UK_G8KKRFUFTD5YW5JFC7399USDG unique (PERSON_ID);
alter table S_STUDENT_EQUIVALENTS
  add constraint FK_1H3QSNA67FTABVQ7E41SIUTUI foreign key (PERSON_ID)
  references C_STD_PEOPLE (ID);

prompt Creating S_STUDENT_LOGS...
create table S_STUDENT_LOGS
(
  id         NUMBER(19) not null,
  ip         VARCHAR2(255 CHAR) not null,
  operation  VARCHAR2(2000 CHAR) not null,
  time       TIMESTAMP(6) not null,
  type       NUMBER(10) not null,
  student_id NUMBER(19),
  user_id    NUMBER(19) not null
)
;
comment on table S_STUDENT_LOGS
  is '学籍修改记录';
comment on column S_STUDENT_LOGS.id
  is '非业务主键';
comment on column S_STUDENT_LOGS.ip
  is 'ip';
comment on column S_STUDENT_LOGS.operation
  is '操作';
comment on column S_STUDENT_LOGS.time
  is '时间';
comment on column S_STUDENT_LOGS.type
  is '日志类型（0：学籍变化总体日志；1：学生学籍变化个人日志）';
comment on column S_STUDENT_LOGS.student_id
  is '被操作学生 ID ###引用表名是C_STUDENTS### ';
comment on column S_STUDENT_LOGS.user_id
  is '操作用户 ID ###引用表名是SE_USERS### ';
alter table S_STUDENT_LOGS
  add primary key (ID);
alter table S_STUDENT_LOGS
  add constraint FK_B1RGEXFE3HO8ASBJK2A7H5H4L foreign key (USER_ID)
  references SE_USERS (ID);
alter table S_STUDENT_LOGS
  add constraint FK_B8CAE6DHI0T5PPD76RS59LMJC foreign key (STUDENT_ID)
  references C_STUDENTS (ID);

prompt Creating TC_EXTERNAL_PEOPLE...
create table TC_EXTERNAL_PEOPLE
(
  id                NUMBER(19) not null,
  created_at        TIMESTAMP(6),
  updated_at        TIMESTAMP(6),
  account           VARCHAR2(255 CHAR),
  bank              VARCHAR2(255 CHAR),
  birthday          DATE,
  charactor         VARCHAR2(500 CHAR),
  idcard            VARCHAR2(255 CHAR),
  name              VARCHAR2(255 CHAR) not null,
  unit              VARCHAR2(255 CHAR),
  country_id        NUMBER(10),
  department_id     NUMBER(10) not null,
  gender_id         NUMBER(10) not null,
  idcard_type_id    NUMBER(10),
  nation_id         NUMBER(10),
  politic_visage_id NUMBER(10),
  unit_type_id      NUMBER(10)
)
;
comment on table TC_EXTERNAL_PEOPLE
  is '外聘教师基本信息';
comment on column TC_EXTERNAL_PEOPLE.id
  is '非业务主键';
comment on column TC_EXTERNAL_PEOPLE.created_at
  is '创建时间';
comment on column TC_EXTERNAL_PEOPLE.updated_at
  is '更新时间';
comment on column TC_EXTERNAL_PEOPLE.account
  is '账户';
comment on column TC_EXTERNAL_PEOPLE.bank
  is '银行';
comment on column TC_EXTERNAL_PEOPLE.birthday
  is '出生年月';
comment on column TC_EXTERNAL_PEOPLE.charactor
  is '特长爱好以及个人说明';
comment on column TC_EXTERNAL_PEOPLE.idcard
  is '身份证';
comment on column TC_EXTERNAL_PEOPLE.name
  is '姓名';
comment on column TC_EXTERNAL_PEOPLE.unit
  is '教师单位';
comment on column TC_EXTERNAL_PEOPLE.country_id
  is '国家地区 ID ###引用表名是GB_COUNTRIES### ';
comment on column TC_EXTERNAL_PEOPLE.department_id
  is '部门 ID ###引用表名是C_DEPARTMENTS### ';
comment on column TC_EXTERNAL_PEOPLE.gender_id
  is '性别 ID ###引用表名是GB_GENDERS### ';
comment on column TC_EXTERNAL_PEOPLE.idcard_type_id
  is '证件类型 身份证/护照等 ID ###引用表名是HB_IDCARD_TYPES### ';
comment on column TC_EXTERNAL_PEOPLE.nation_id
  is '民族 ID ###引用表名是GB_NATIONS### ';
comment on column TC_EXTERNAL_PEOPLE.politic_visage_id
  is '政治面貌 ID ###引用表名是GB_POLITIC_VISAGES### ';
comment on column TC_EXTERNAL_PEOPLE.unit_type_id
  is '外聘教师单位类别 ID ###引用表名是HB_TEACHER_UNIT_TYPES### ';
alter table TC_EXTERNAL_PEOPLE
  add primary key (ID);
alter table TC_EXTERNAL_PEOPLE
  add constraint UK_B99776UMAIJC7MYVB8UQ7RIVF unique (ACCOUNT);
alter table TC_EXTERNAL_PEOPLE
  add constraint FK_18I3GGYY5MJJ4MHCMQDT4XA4I foreign key (IDCARD_TYPE_ID)
  references HB_IDCARD_TYPES (ID);
alter table TC_EXTERNAL_PEOPLE
  add constraint FK_2EVLRNX53ARHO0W1VKWJ45UV9 foreign key (UNIT_TYPE_ID)
  references HB_TEACHER_UNIT_TYPES (ID);
alter table TC_EXTERNAL_PEOPLE
  add constraint FK_3YE0KBRCJPBJU3DW5WB3B2M2K foreign key (POLITIC_VISAGE_ID)
  references GB_POLITIC_VISAGES (ID);
alter table TC_EXTERNAL_PEOPLE
  add constraint FK_55IITI66FIOBTA3F0NFG1OLTK foreign key (COUNTRY_ID)
  references GB_COUNTRIES (ID);
alter table TC_EXTERNAL_PEOPLE
  add constraint FK_5DLE3PI0XE7YGMYJ4S1U3SEED foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table TC_EXTERNAL_PEOPLE
  add constraint FK_5EGD1ODOHJC022ROHN07GAWNV foreign key (NATION_ID)
  references GB_NATIONS (ID);
alter table TC_EXTERNAL_PEOPLE
  add constraint FK_M85SF7M0BQQTN1D6IPWF9WEF3 foreign key (GENDER_ID)
  references GB_GENDERS (ID);

prompt Creating TC_EXTERNAL_CONTACTS...
create table TC_EXTERNAL_CONTACTS
(
  id              NUMBER(19) not null,
  email           VARCHAR2(255 CHAR),
  mobile_phone    VARCHAR2(255 CHAR),
  phone_of_home   VARCHAR2(255 CHAR),
  phone_of_office VARCHAR2(255 CHAR),
  person_id       NUMBER(19) not null
)
;
comment on table TC_EXTERNAL_CONTACTS
  is '外聘教师联系信息';
comment on column TC_EXTERNAL_CONTACTS.id
  is '非业务主键';
comment on column TC_EXTERNAL_CONTACTS.email
  is '电子邮箱';
comment on column TC_EXTERNAL_CONTACTS.mobile_phone
  is '移动电话';
comment on column TC_EXTERNAL_CONTACTS.phone_of_home
  is '家庭电话';
comment on column TC_EXTERNAL_CONTACTS.phone_of_office
  is '单位电话 办公电话';
comment on column TC_EXTERNAL_CONTACTS.person_id
  is '教师 ID ###引用表名是TC_EXTERNAL_PEOPLE### ';
alter table TC_EXTERNAL_CONTACTS
  add primary key (ID);
alter table TC_EXTERNAL_CONTACTS
  add constraint UK_LKHDB2NRBM0P3EVN2SNMKSQ6W unique (PERSON_ID);
alter table TC_EXTERNAL_CONTACTS
  add constraint FK_MDBOPK1FTKITJA9PDI136NSW5 foreign key (PERSON_ID)
  references TC_EXTERNAL_PEOPLE (ID);

prompt Creating TC_EXTERNAL_TEACHERS...
create table TC_EXTERNAL_TEACHERS
(
  id              NUMBER(19) not null,
  created_at      TIMESTAMP(6),
  updated_at      TIMESTAMP(6),
  code            VARCHAR2(32 CHAR),
  degree_award_on DATE,
  effective_at    DATE not null,
  graduate_on     DATE,
  invalid_at      DATE,
  name            VARCHAR2(100 CHAR) not null,
  passed          NUMBER(1) not null,
  remark          VARCHAR2(500 CHAR),
  reply           VARCHAR2(255 CHAR),
  school          VARCHAR2(255 CHAR),
  tutor_award_on  DATE,
  degree_id       NUMBER(10),
  department_id   NUMBER(10) not null,
  education_id    NUMBER(10),
  person_id       NUMBER(19) not null,
  state_id        NUMBER(10) not null,
  teacher_type_id NUMBER(10) not null,
  title_id        NUMBER(10),
  tutor_type_id   NUMBER(10)
)
;
comment on table TC_EXTERNAL_TEACHERS
  is '外聘教师信息默认实现';
comment on column TC_EXTERNAL_TEACHERS.id
  is '非业务主键';
comment on column TC_EXTERNAL_TEACHERS.created_at
  is '创建时间';
comment on column TC_EXTERNAL_TEACHERS.updated_at
  is '更新时间';
comment on column TC_EXTERNAL_TEACHERS.code
  is '编码 职工号';
comment on column TC_EXTERNAL_TEACHERS.degree_award_on
  is '学位授予年月';
comment on column TC_EXTERNAL_TEACHERS.effective_at
  is '任职开始日期';
comment on column TC_EXTERNAL_TEACHERS.graduate_on
  is '毕业日期';
comment on column TC_EXTERNAL_TEACHERS.invalid_at
  is '任职结束日期';
comment on column TC_EXTERNAL_TEACHERS.name
  is '名称';
comment on column TC_EXTERNAL_TEACHERS.passed
  is '是否审核通过';
comment on column TC_EXTERNAL_TEACHERS.remark
  is '备注';
comment on column TC_EXTERNAL_TEACHERS.reply
  is '不通过回复';
comment on column TC_EXTERNAL_TEACHERS.school
  is '毕业学校';
comment on column TC_EXTERNAL_TEACHERS.tutor_award_on
  is '研导任职年月';
comment on column TC_EXTERNAL_TEACHERS.degree_id
  is '学位 ID ###引用表名是GB_DEGREES### ';
comment on column TC_EXTERNAL_TEACHERS.department_id
  is '部门 ID ###引用表名是C_DEPARTMENTS### ';
comment on column TC_EXTERNAL_TEACHERS.education_id
  is '学历 ID ###引用表名是HB_EDUCATIONS### ';
comment on column TC_EXTERNAL_TEACHERS.person_id
  is '基本信息 ID ###引用表名是TC_EXTERNAL_PEOPLE### ';
comment on column TC_EXTERNAL_TEACHERS.state_id
  is '教师在职状态 ID ###引用表名是HB_TEACHER_STATES### ';
comment on column TC_EXTERNAL_TEACHERS.teacher_type_id
  is '教职工类别 ID ###引用表名是HB_TEACHER_TYPES### ';
comment on column TC_EXTERNAL_TEACHERS.title_id
  is '职称 ID ###引用表名是GB_TEACHER_TITLES### ';
comment on column TC_EXTERNAL_TEACHERS.tutor_type_id
  is '导师类别 ID ###引用表名是HB_TUTOR_TYPES### ';
alter table TC_EXTERNAL_TEACHERS
  add primary key (ID);
alter table TC_EXTERNAL_TEACHERS
  add constraint UK_J4HY8VN7W7QUF0P2GMJL642U unique (CODE);
alter table TC_EXTERNAL_TEACHERS
  add constraint FK_1U4KB4D2E93AIR06600KAKYTM foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table TC_EXTERNAL_TEACHERS
  add constraint FK_3BBWDKU808KOI7CPQ65QTLVJW foreign key (TITLE_ID)
  references GB_TEACHER_TITLES (ID);
alter table TC_EXTERNAL_TEACHERS
  add constraint FK_3J819LO9YSG3YFAX4N42F18H3 foreign key (DEGREE_ID)
  references GB_DEGREES (ID);
alter table TC_EXTERNAL_TEACHERS
  add constraint FK_7FH666MV6598N4OF7URQP8XHK foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);
alter table TC_EXTERNAL_TEACHERS
  add constraint FK_CLOLK8QHPJJSDI94BSI154JPM foreign key (PERSON_ID)
  references TC_EXTERNAL_PEOPLE (ID);
alter table TC_EXTERNAL_TEACHERS
  add constraint FK_F0B83MEGVJ02D7SVLJ5PN13TS foreign key (TUTOR_TYPE_ID)
  references HB_TUTOR_TYPES (ID);
alter table TC_EXTERNAL_TEACHERS
  add constraint FK_JIPVNMVEPCD55YG1HB5GA07K3 foreign key (TEACHER_TYPE_ID)
  references HB_TEACHER_TYPES (ID);
alter table TC_EXTERNAL_TEACHERS
  add constraint FK_O8LFCYWRNGUBALFXSPKR1SR60 foreign key (STATE_ID)
  references HB_TEACHER_STATES (ID);

prompt Creating TC_PARTTIME_PEOPLE...
create table TC_PARTTIME_PEOPLE
(
  id                NUMBER(19) not null,
  created_at        TIMESTAMP(6),
  updated_at        TIMESTAMP(6),
  account           VARCHAR2(255 CHAR),
  bank              VARCHAR2(255 CHAR),
  birthday          DATE,
  charactor         VARCHAR2(500 CHAR),
  idcard            VARCHAR2(255 CHAR),
  name              VARCHAR2(255 CHAR) not null,
  country_id        NUMBER(10),
  department_id     NUMBER(10) not null,
  gender_id         NUMBER(10) not null,
  idcard_type_id    NUMBER(10),
  nation_id         NUMBER(10),
  politic_visage_id NUMBER(10)
)
;
comment on table TC_PARTTIME_PEOPLE
  is '兼职教师基本信息';
comment on column TC_PARTTIME_PEOPLE.id
  is '非业务主键';
comment on column TC_PARTTIME_PEOPLE.created_at
  is '创建时间';
comment on column TC_PARTTIME_PEOPLE.updated_at
  is '更新时间';
comment on column TC_PARTTIME_PEOPLE.account
  is '账户';
comment on column TC_PARTTIME_PEOPLE.bank
  is '银行';
comment on column TC_PARTTIME_PEOPLE.birthday
  is '出生年月';
comment on column TC_PARTTIME_PEOPLE.charactor
  is '特长爱好以及个人说明';
comment on column TC_PARTTIME_PEOPLE.idcard
  is '身份证';
comment on column TC_PARTTIME_PEOPLE.name
  is '姓名';
comment on column TC_PARTTIME_PEOPLE.country_id
  is '国家地区 ID ###引用表名是GB_COUNTRIES### ';
comment on column TC_PARTTIME_PEOPLE.department_id
  is '部门 ID ###引用表名是C_DEPARTMENTS### ';
comment on column TC_PARTTIME_PEOPLE.gender_id
  is '性别 ID ###引用表名是GB_GENDERS### ';
comment on column TC_PARTTIME_PEOPLE.idcard_type_id
  is '证件类型 身份证/护照等 ID ###引用表名是HB_IDCARD_TYPES### ';
comment on column TC_PARTTIME_PEOPLE.nation_id
  is '民族 ID ###引用表名是GB_NATIONS### ';
comment on column TC_PARTTIME_PEOPLE.politic_visage_id
  is '政治面貌 ID ###引用表名是GB_POLITIC_VISAGES### ';
alter table TC_PARTTIME_PEOPLE
  add primary key (ID);
alter table TC_PARTTIME_PEOPLE
  add constraint UK_F7O439C828AR5W07BO2C7H0TU unique (ACCOUNT);
alter table TC_PARTTIME_PEOPLE
  add constraint FK_AD19X4QQ2CSIQU3SGGDJVCIDE foreign key (IDCARD_TYPE_ID)
  references HB_IDCARD_TYPES (ID);
alter table TC_PARTTIME_PEOPLE
  add constraint FK_H5SINNM1IEFC5SXXWTRGKUEIW foreign key (COUNTRY_ID)
  references GB_COUNTRIES (ID);
alter table TC_PARTTIME_PEOPLE
  add constraint FK_ICUEW2S20BHQ05AC5NY7UBYUD foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table TC_PARTTIME_PEOPLE
  add constraint FK_LHFE1J3ECGCAQT5NGPJCFTEOA foreign key (GENDER_ID)
  references GB_GENDERS (ID);
alter table TC_PARTTIME_PEOPLE
  add constraint FK_OGH97W2K3JETQFQ7T74R0VKQ8 foreign key (POLITIC_VISAGE_ID)
  references GB_POLITIC_VISAGES (ID);
alter table TC_PARTTIME_PEOPLE
  add constraint FK_P91OVOC6SPQ3B9PCKIQUK2CWN foreign key (NATION_ID)
  references GB_NATIONS (ID);

prompt Creating TC_PARTTIME_CONTACTS...
create table TC_PARTTIME_CONTACTS
(
  id              NUMBER(19) not null,
  email           VARCHAR2(255 CHAR),
  mobile_phone    VARCHAR2(255 CHAR),
  phone_of_home   VARCHAR2(255 CHAR),
  phone_of_office VARCHAR2(255 CHAR),
  person_id       NUMBER(19) not null
)
;
comment on table TC_PARTTIME_CONTACTS
  is '兼职教师联系信息';
comment on column TC_PARTTIME_CONTACTS.id
  is '非业务主键';
comment on column TC_PARTTIME_CONTACTS.email
  is '电子邮箱';
comment on column TC_PARTTIME_CONTACTS.mobile_phone
  is '移动电话';
comment on column TC_PARTTIME_CONTACTS.phone_of_home
  is '家庭电话';
comment on column TC_PARTTIME_CONTACTS.phone_of_office
  is '单位电话 办公电话';
comment on column TC_PARTTIME_CONTACTS.person_id
  is '教师 ID ###引用表名是TC_PARTTIME_PEOPLE### ';
alter table TC_PARTTIME_CONTACTS
  add primary key (ID);
alter table TC_PARTTIME_CONTACTS
  add constraint UK_BR9XX43RW9PVV0VUFLOCO9XM7 unique (PERSON_ID);
alter table TC_PARTTIME_CONTACTS
  add constraint FK_8NV8UT61T3QTDFR12C5LSOI4K foreign key (PERSON_ID)
  references TC_PARTTIME_PEOPLE (ID);

prompt Creating TC_PARTTIME_TEACHERS...
create table TC_PARTTIME_TEACHERS
(
  id                 NUMBER(19) not null,
  created_at         TIMESTAMP(6),
  updated_at         TIMESTAMP(6),
  code               VARCHAR2(32 CHAR),
  degree_award_on    DATE,
  effective_at       DATE not null,
  graduate_on        DATE,
  invalid_at         DATE,
  name               VARCHAR2(100 CHAR) not null,
  passed             NUMBER(1) not null,
  remark             VARCHAR2(500 CHAR),
  reply              VARCHAR2(255 CHAR),
  school             VARCHAR2(255 CHAR),
  tutor_award_on     DATE,
  degree_id          NUMBER(10),
  department_id      NUMBER(10) not null,
  education_id       NUMBER(10),
  parttime_depart_id NUMBER(10) not null,
  person_id          NUMBER(19) not null,
  state_id           NUMBER(10) not null,
  teacher_type_id    NUMBER(10) not null,
  title_id           NUMBER(10),
  tutor_type_id      NUMBER(10)
)
;
comment on table TC_PARTTIME_TEACHERS
  is '兼职教师信息默认实现';
comment on column TC_PARTTIME_TEACHERS.id
  is '非业务主键';
comment on column TC_PARTTIME_TEACHERS.created_at
  is '创建时间';
comment on column TC_PARTTIME_TEACHERS.updated_at
  is '更新时间';
comment on column TC_PARTTIME_TEACHERS.code
  is '编码 职工号';
comment on column TC_PARTTIME_TEACHERS.degree_award_on
  is '学位授予年月';
comment on column TC_PARTTIME_TEACHERS.effective_at
  is '任职开始日期';
comment on column TC_PARTTIME_TEACHERS.graduate_on
  is '毕业日期';
comment on column TC_PARTTIME_TEACHERS.invalid_at
  is '任职结束日期';
comment on column TC_PARTTIME_TEACHERS.name
  is '名称';
comment on column TC_PARTTIME_TEACHERS.passed
  is '是否审核通过';
comment on column TC_PARTTIME_TEACHERS.remark
  is '备注';
comment on column TC_PARTTIME_TEACHERS.reply
  is '不通过回复';
comment on column TC_PARTTIME_TEACHERS.school
  is '毕业学校';
comment on column TC_PARTTIME_TEACHERS.tutor_award_on
  is '研导任职年月';
comment on column TC_PARTTIME_TEACHERS.degree_id
  is '学位 ID ###引用表名是GB_DEGREES### ';
comment on column TC_PARTTIME_TEACHERS.department_id
  is '部门 ID ###引用表名是C_DEPARTMENTS### ';
comment on column TC_PARTTIME_TEACHERS.education_id
  is '学历 ID ###引用表名是HB_EDUCATIONS### ';
comment on column TC_PARTTIME_TEACHERS.parttime_depart_id
  is '兼职部门 ID ###引用表名是C_DEPARTMENTS### ';
comment on column TC_PARTTIME_TEACHERS.person_id
  is '基本信息 ID ###引用表名是TC_PARTTIME_PEOPLE### ';
comment on column TC_PARTTIME_TEACHERS.state_id
  is '教师在职状态 ID ###引用表名是HB_TEACHER_STATES### ';
comment on column TC_PARTTIME_TEACHERS.teacher_type_id
  is '教职工类别 ID ###引用表名是HB_TEACHER_TYPES### ';
comment on column TC_PARTTIME_TEACHERS.title_id
  is '职称 ID ###引用表名是GB_TEACHER_TITLES### ';
comment on column TC_PARTTIME_TEACHERS.tutor_type_id
  is '导师类别 ID ###引用表名是HB_TUTOR_TYPES### ';
alter table TC_PARTTIME_TEACHERS
  add primary key (ID);
alter table TC_PARTTIME_TEACHERS
  add constraint UK_OICBMG97LS87YFC6LBRJX6R8C unique (CODE);
alter table TC_PARTTIME_TEACHERS
  add constraint FK_1Q4LWX5QPEGML0GD0239XNOW2 foreign key (STATE_ID)
  references HB_TEACHER_STATES (ID);
alter table TC_PARTTIME_TEACHERS
  add constraint FK_6DOFG818VB0RLG2FVXI9XJGGH foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table TC_PARTTIME_TEACHERS
  add constraint FK_8734H08AJMS33RJICOWNHGL5O foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);
alter table TC_PARTTIME_TEACHERS
  add constraint FK_ANXQRRBQK44SU5BVXWXT4KUTS foreign key (TUTOR_TYPE_ID)
  references HB_TUTOR_TYPES (ID);
alter table TC_PARTTIME_TEACHERS
  add constraint FK_B1I2UEPMAE5UW7FLAG2EYXMY foreign key (TITLE_ID)
  references GB_TEACHER_TITLES (ID);
alter table TC_PARTTIME_TEACHERS
  add constraint FK_ETPWALN94UXSJFI7VHD7REREI foreign key (PARTTIME_DEPART_ID)
  references C_DEPARTMENTS (ID);
alter table TC_PARTTIME_TEACHERS
  add constraint FK_L2N0U83HBBO4P8Y82Q8429RUL foreign key (DEGREE_ID)
  references GB_DEGREES (ID);
alter table TC_PARTTIME_TEACHERS
  add constraint FK_M85O9V9OXVW48EXD6UH625RS2 foreign key (TEACHER_TYPE_ID)
  references HB_TEACHER_TYPES (ID);
alter table TC_PARTTIME_TEACHERS
  add constraint FK_PHUI3RJF1XO41024QGFD388E foreign key (PERSON_ID)
  references TC_PARTTIME_PEOPLE (ID);

prompt Creating TC_TEACHER_CONTACTS...
create table TC_TEACHER_CONTACTS
(
  id              NUMBER(19) not null,
  address         VARCHAR2(500 CHAR),
  email           VARCHAR2(255 CHAR),
  mobile_phone    VARCHAR2(255 CHAR),
  phone_of_home   VARCHAR2(255 CHAR),
  phone_of_office VARCHAR2(255 CHAR),
  staff_id        NUMBER(19) not null
)
;
comment on table TC_TEACHER_CONTACTS
  is '教师联系信息';
comment on column TC_TEACHER_CONTACTS.id
  is '非业务主键';
comment on column TC_TEACHER_CONTACTS.address
  is '联系地址';
comment on column TC_TEACHER_CONTACTS.email
  is '电子邮箱';
comment on column TC_TEACHER_CONTACTS.mobile_phone
  is '移动电话';
comment on column TC_TEACHER_CONTACTS.phone_of_home
  is '家庭电话';
comment on column TC_TEACHER_CONTACTS.phone_of_office
  is '单位电话 办公电话';
comment on column TC_TEACHER_CONTACTS.staff_id
  is '教师 ID ###引用表名是C_STAFFS### ';
alter table TC_TEACHER_CONTACTS
  add primary key (ID);
alter table TC_TEACHER_CONTACTS
  add constraint UK_N8FMIC5VG9FRRNAS8GBR2BS52 unique (STAFF_ID);
alter table TC_TEACHER_CONTACTS
  add constraint FK_JC7EOWR2BO255VQOCI76Y92OQ foreign key (STAFF_ID)
  references C_STAFFS (ID);

prompt Creating T_ARRANGE_SUGGESTS...
create table T_ARRANGE_SUGGESTS
(
  id        NUMBER(19) not null,
  remark    VARCHAR2(500 CHAR),
  lesson_id NUMBER(19) not null
)
;
comment on table T_ARRANGE_SUGGESTS
  is '排课建议';
comment on column T_ARRANGE_SUGGESTS.id
  is '非业务主键';
comment on column T_ARRANGE_SUGGESTS.remark
  is '文字建议(其他建议)';
comment on column T_ARRANGE_SUGGESTS.lesson_id
  is '教学任务 ID ###引用表名是T_LESSONS### ';
alter table T_ARRANGE_SUGGESTS
  add primary key (ID);
alter table T_ARRANGE_SUGGESTS
  add constraint UK_M14O9LIXGVKCFOYSBONL0BXTP unique (LESSON_ID);
alter table T_ARRANGE_SUGGESTS
  add constraint FK_PIKR2PD05IT4J0RY66LRFKX3C foreign key (LESSON_ID)
  references T_LESSONS (ID);

prompt Creating T_ARRANGE_SUGGESTS_ROOMS...
create table T_ARRANGE_SUGGESTS_ROOMS
(
  arrange_suggest_id NUMBER(19) not null,
  classroom_id       NUMBER(10) not null
)
;
comment on table T_ARRANGE_SUGGESTS_ROOMS
  is '排课建议-建议使用教室';
comment on column T_ARRANGE_SUGGESTS_ROOMS.arrange_suggest_id
  is '排课建议 ID ###引用表名是T_ARRANGE_SUGGESTS### ';
comment on column T_ARRANGE_SUGGESTS_ROOMS.classroom_id
  is '教室基本信息 ID ###引用表名是C_CLASSROOMS### ';
alter table T_ARRANGE_SUGGESTS_ROOMS
  add primary key (ARRANGE_SUGGEST_ID, CLASSROOM_ID);
alter table T_ARRANGE_SUGGESTS_ROOMS
  add constraint FK_B8HQK8VGFQ5H7U7Y7K8MSCCRE foreign key (CLASSROOM_ID)
  references C_CLASSROOMS (ID);
alter table T_ARRANGE_SUGGESTS_ROOMS
  add constraint FK_JDUW53MK0JSCNN1XNFO3UB3IQ foreign key (ARRANGE_SUGGEST_ID)
  references T_ARRANGE_SUGGESTS (ID);

prompt Creating T_AVAILABLE_TIMES...
create table T_AVAILABLE_TIMES
(
  id        NUMBER(19) not null,
  available VARCHAR2(200 CHAR) not null,
  remark    VARCHAR2(200 CHAR),
  struct    VARCHAR2(20 CHAR) not null,
  units     NUMBER(10) not null
)
;
comment on table T_AVAILABLE_TIMES
  is '可用时间.主要为教师和教室配置排课中的可用时间.';
comment on column T_AVAILABLE_TIMES.id
  is '非业务主键';
comment on column T_AVAILABLE_TIMES.available
  is '可用时间描述';
comment on column T_AVAILABLE_TIMES.remark
  is '备注';
comment on column T_AVAILABLE_TIMES.struct
  is '节数：每个分段的起始小节';
comment on column T_AVAILABLE_TIMES.units
  is '节次';
alter table T_AVAILABLE_TIMES
  add primary key (ID);

prompt Creating T_TEXTBOOK_ORDER_CONFIGS...
create table T_TEXTBOOK_ORDER_CONFIGS
(
  id           NUMBER(19) not null,
  begin_at     TIMESTAMP(6),
  ebank_opened NUMBER(1) not null,
  end_at       TIMESTAMP(6),
  order_limit  NUMBER(10)
)
;
comment on table T_TEXTBOOK_ORDER_CONFIGS
  is '学生订购教材开关';
comment on column T_TEXTBOOK_ORDER_CONFIGS.id
  is '非业务主键';
comment on column T_TEXTBOOK_ORDER_CONFIGS.begin_at
  is '开始时间';
comment on column T_TEXTBOOK_ORDER_CONFIGS.ebank_opened
  is '网银开关';
comment on column T_TEXTBOOK_ORDER_CONFIGS.end_at
  is '结束时间';
comment on column T_TEXTBOOK_ORDER_CONFIGS.order_limit
  is '订购限制';
alter table T_TEXTBOOK_ORDER_CONFIGS
  add primary key (ID);

prompt Creating T_BOOKORDER_CONFIGS_SEMESTERS...
create table T_BOOKORDER_CONFIGS_SEMESTERS
(
  textbook_order_config_id NUMBER(19) not null,
  semester_id              NUMBER(10) not null
)
;
comment on table T_BOOKORDER_CONFIGS_SEMESTERS
  is '学生订购教材开关-开放学期';
comment on column T_BOOKORDER_CONFIGS_SEMESTERS.textbook_order_config_id
  is '学生订购教材开关 ID ###引用表名是T_TEXTBOOK_ORDER_CONFIGS### ';
comment on column T_BOOKORDER_CONFIGS_SEMESTERS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
alter table T_BOOKORDER_CONFIGS_SEMESTERS
  add primary key (TEXTBOOK_ORDER_CONFIG_ID, SEMESTER_ID);
alter table T_BOOKORDER_CONFIGS_SEMESTERS
  add constraint UK_SB1TNN9E745330L7NTEEDPNC0 unique (SEMESTER_ID);
alter table T_BOOKORDER_CONFIGS_SEMESTERS
  add constraint FK_RBHWCH5HNH7DUS2KYJTPMTP78 foreign key (TEXTBOOK_ORDER_CONFIG_ID)
  references T_TEXTBOOK_ORDER_CONFIGS (ID);
alter table T_BOOKORDER_CONFIGS_SEMESTERS
  add constraint FK_SB1TNN9E745330L7NTEEDPNC0 foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);

prompt Creating T_BOOK_REQUIRE_CONFIGS...
create table T_BOOK_REQUIRE_CONFIGS
(
  id       NUMBER(19) not null,
  begin_at TIMESTAMP(6),
  end_at   TIMESTAMP(6)
)
;
comment on table T_BOOK_REQUIRE_CONFIGS
  is '教材选用开关';
comment on column T_BOOK_REQUIRE_CONFIGS.id
  is '非业务主键';
comment on column T_BOOK_REQUIRE_CONFIGS.begin_at
  is '开始时间';
comment on column T_BOOK_REQUIRE_CONFIGS.end_at
  is '结束时间';
alter table T_BOOK_REQUIRE_CONFIGS
  add primary key (ID);

prompt Creating T_BOOK_REQ_CONFIGS_SEMESTERS...
create table T_BOOK_REQ_CONFIGS_SEMESTERS
(
  book_require_config_bean_id NUMBER(19) not null,
  semester_id                 NUMBER(10) not null
)
;
comment on table T_BOOK_REQ_CONFIGS_SEMESTERS
  is '教材选用开关-开放学期';
comment on column T_BOOK_REQ_CONFIGS_SEMESTERS.book_require_config_bean_id
  is '教材选用开关 ID ###引用表名是T_BOOK_REQUIRE_CONFIGS### ';
comment on column T_BOOK_REQ_CONFIGS_SEMESTERS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
alter table T_BOOK_REQ_CONFIGS_SEMESTERS
  add primary key (BOOK_REQUIRE_CONFIG_BEAN_ID, SEMESTER_ID);
alter table T_BOOK_REQ_CONFIGS_SEMESTERS
  add constraint UK_6T15HHP920JSTVQSOMEV7C4D8 unique (SEMESTER_ID);
alter table T_BOOK_REQ_CONFIGS_SEMESTERS
  add constraint FK_6T15HHP920JSTVQSOMEV7C4D8 foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_BOOK_REQ_CONFIGS_SEMESTERS
  add constraint FK_ARD8KP6B2M1RNGO8RJW47N16Q foreign key (BOOK_REQUIRE_CONFIG_BEAN_ID)
  references T_BOOK_REQUIRE_CONFIGS (ID);

prompt Creating T_COLLISION_RESOURCES...
create table T_COLLISION_RESOURCES
(
  id            NUMBER(19) not null,
  resource_id   VARCHAR2(255 CHAR),
  resource_type VARCHAR2(255 CHAR),
  lesson_id     NUMBER(19),
  semester_id   NUMBER(10)
)
;
comment on table T_COLLISION_RESOURCES
  is '排课冲突临时对象';
comment on column T_COLLISION_RESOURCES.id
  is '非业务主键';
comment on column T_COLLISION_RESOURCES.resource_id
  is '资源ID';
comment on column T_COLLISION_RESOURCES.resource_type
  is '资源类型';
comment on column T_COLLISION_RESOURCES.lesson_id
  is '教学任务 ID ###引用表名是T_LESSONS### ';
comment on column T_COLLISION_RESOURCES.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
alter table T_COLLISION_RESOURCES
  add primary key (ID);
alter table T_COLLISION_RESOURCES
  add constraint UK_JYPDKW7E03SMOXOY4FSSOSB3D unique (LESSON_ID, RESOURCE_ID, RESOURCE_TYPE, SEMESTER_ID);
alter table T_COLLISION_RESOURCES
  add constraint FK_34ED51D278SWLRKMO1NG8M88P foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_COLLISION_RESOURCES
  add constraint FK_PLVFQCRFOQSDFQJNJKD2FRST5 foreign key (LESSON_ID)
  references T_LESSONS (ID);

prompt Creating T_CONSTRAINT_LOGGERS...
create table T_CONSTRAINT_LOGGERS
(
  id              NUMBER(19) not null,
  constraint_type VARCHAR2(255 CHAR) not null,
  created_at      TIMESTAMP(6) not null,
  key             VARCHAR2(255 CHAR) not null,
  operator        VARCHAR2(255 CHAR) not null,
  type            VARCHAR2(30 CHAR) not null,
  value           VARCHAR2(255 CHAR),
  semester_id     NUMBER(10)
)
;
comment on table T_CONSTRAINT_LOGGERS
  is '学分限制操作日志';
comment on column T_CONSTRAINT_LOGGERS.id
  is '非业务主键';
comment on column T_CONSTRAINT_LOGGERS.constraint_type
  is '限制类型';
comment on column T_CONSTRAINT_LOGGERS.created_at
  is '创建时间';
comment on column T_CONSTRAINT_LOGGERS.key
  is '关键字';
comment on column T_CONSTRAINT_LOGGERS.operator
  is '操作者';
comment on column T_CONSTRAINT_LOGGERS.type
  is '类型';
comment on column T_CONSTRAINT_LOGGERS.value
  is '值';
comment on column T_CONSTRAINT_LOGGERS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
alter table T_CONSTRAINT_LOGGERS
  add primary key (ID);
alter table T_CONSTRAINT_LOGGERS
  add constraint FK_2QL7M6MYLY1K84AL2HDV8SK1X foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);

prompt Creating T_STD_COURSE_COUNT_CONS...
create table T_STD_COURSE_COUNT_CONS
(
  id               NUMBER(19) not null,
  max_course_count NUMBER(10),
  semester_id      NUMBER(10) not null,
  std_id           NUMBER(19) not null
)
;
comment on table T_STD_COURSE_COUNT_CONS
  is '学生个人选课门数上限';
comment on column T_STD_COURSE_COUNT_CONS.id
  is '非业务主键';
comment on column T_STD_COURSE_COUNT_CONS.max_course_count
  is '当前学期选课的总门数上限，总门数中不包括重修的';
comment on column T_STD_COURSE_COUNT_CONS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
comment on column T_STD_COURSE_COUNT_CONS.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table T_STD_COURSE_COUNT_CONS
  add primary key (ID);
alter table T_STD_COURSE_COUNT_CONS
  add constraint UK_SCQ5I6A8UP47WCNCUC7LGQO72 unique (SEMESTER_ID, STD_ID);
alter table T_STD_COURSE_COUNT_CONS
  add constraint FK_H7SQXSAEWPDDUBSOCLNBW5JWB foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_STD_COURSE_COUNT_CONS
  add constraint FK_JWWMH5VUC3F5T1B9IY0VXBWDD foreign key (STD_ID)
  references C_STUDENTS (ID);

prompt Creating T_CONS_COURS_TYPE_MAX_COUNT...
create table T_CONS_COURS_TYPE_MAX_COUNT
(
  std_course_count_constraint_id NUMBER(19) not null,
  course_count                   NUMBER(10),
  course_type_id                 NUMBER(10) not null
)
;
comment on table T_CONS_COURS_TYPE_MAX_COUNT
  is '学生个人选课门数上限-某个课程类别能够选课的门数上限，不包括重修的';
comment on column T_CONS_COURS_TYPE_MAX_COUNT.std_course_count_constraint_id
  is '学生个人选课门数上限 ID ###引用表名是T_STD_COURSE_COUNT_CONS### ';
comment on column T_CONS_COURS_TYPE_MAX_COUNT.course_type_id
  is '课程类别 ID ###引用表名是XB_COURSE_TYPES### ';
alter table T_CONS_COURS_TYPE_MAX_COUNT
  add primary key (STD_COURSE_COUNT_CONSTRAINT_ID, COURSE_TYPE_ID);
alter table T_CONS_COURS_TYPE_MAX_COUNT
  add constraint FK_2X8U1MJDHPE662GL5LA764V62 foreign key (STD_COURSE_COUNT_CONSTRAINT_ID)
  references T_STD_COURSE_COUNT_CONS (ID);
alter table T_CONS_COURS_TYPE_MAX_COUNT
  add constraint FK_IJ2VUUHE8K5TI3V0MDMYRGRNY foreign key (COURSE_TYPE_ID)
  references XB_COURSE_TYPES (ID);

prompt Creating XB_COURSE_ABILITY_RATES...
create table XB_COURSE_ABILITY_RATES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table XB_COURSE_ABILITY_RATES
  is '课程能力等级';
comment on column XB_COURSE_ABILITY_RATES.id
  is '非业务主键';
comment on column XB_COURSE_ABILITY_RATES.code
  is '代码';
comment on column XB_COURSE_ABILITY_RATES.created_at
  is '创建时间';
comment on column XB_COURSE_ABILITY_RATES.effective_at
  is '生效时间';
comment on column XB_COURSE_ABILITY_RATES.eng_name
  is '英文名称';
comment on column XB_COURSE_ABILITY_RATES.invalid_at
  is '失效时间';
comment on column XB_COURSE_ABILITY_RATES.name
  is '名称';
comment on column XB_COURSE_ABILITY_RATES.updated_at
  is '修改时间';
alter table XB_COURSE_ABILITY_RATES
  add primary key (ID);
alter table XB_COURSE_ABILITY_RATES
  add constraint UK_81S0434JGQQT1DXS53CB33BKK unique (CODE);

prompt Creating T_COURSES_ABILITY_RATES...
create table T_COURSES_ABILITY_RATES
(
  course_id              NUMBER(19) not null,
  course_ability_rate_id NUMBER(10) not null
)
;
comment on table T_COURSES_ABILITY_RATES
  is '课程基本信息-能力等级';
comment on column T_COURSES_ABILITY_RATES.course_id
  is '课程基本信息 ID ###引用表名是T_COURSES### ';
comment on column T_COURSES_ABILITY_RATES.course_ability_rate_id
  is '课程能力等级 ID ###引用表名是XB_COURSE_ABILITY_RATES### ';
alter table T_COURSES_ABILITY_RATES
  add primary key (COURSE_ID, COURSE_ABILITY_RATE_ID);
alter table T_COURSES_ABILITY_RATES
  add constraint FK_6CC3P1PRCX11UXREAOCIN85P7 foreign key (COURSE_ID)
  references T_COURSES (ID);
alter table T_COURSES_ABILITY_RATES
  add constraint FK_98TP5QB5GK15YNYIT0339OGEO foreign key (COURSE_ABILITY_RATE_ID)
  references XB_COURSE_ABILITY_RATES (ID);

prompt Creating T_COURSES_MAJORS...
create table T_COURSES_MAJORS
(
  course_id NUMBER(19) not null,
  major_id  NUMBER(10) not null
)
;
comment on table T_COURSES_MAJORS
  is '课程基本信息-针对专业';
comment on column T_COURSES_MAJORS.course_id
  is '课程基本信息 ID ###引用表名是T_COURSES### ';
comment on column T_COURSES_MAJORS.major_id
  is '专业 ID ###引用表名是C_MAJORS### ';
alter table T_COURSES_MAJORS
  add primary key (COURSE_ID, MAJOR_ID);
alter table T_COURSES_MAJORS
  add constraint FK_3UJ1O1E0Y1P3OFQLOWERXBCL6 foreign key (COURSE_ID)
  references T_COURSES (ID);
alter table T_COURSES_MAJORS
  add constraint FK_99OOJ2WSJYKXCSLMHVVQE6WQP foreign key (MAJOR_ID)
  references C_MAJORS (ID);

prompt Creating T_COURSES_PREREQUISITES...
create table T_COURSES_PREREQUISITES
(
  course_id    NUMBER(19) not null,
  precourse_id NUMBER(19) not null
)
;
comment on table T_COURSES_PREREQUISITES
  is '课程基本信息-先修课程';
comment on column T_COURSES_PREREQUISITES.course_id
  is '课程基本信息 ID ###引用表名是T_COURSES### ';
comment on column T_COURSES_PREREQUISITES.precourse_id
  is '课程基本信息 ID ###引用表名是T_COURSES### ';
alter table T_COURSES_PREREQUISITES
  add primary key (COURSE_ID, PRECOURSE_ID);
alter table T_COURSES_PREREQUISITES
  add constraint FK_ALR390X5L4RMG6VM16V0BY2A8 foreign key (PRECOURSE_ID)
  references T_COURSES (ID);
alter table T_COURSES_PREREQUISITES
  add constraint FK_H8CKHJJCWY9QJF49XDUTWVUGS foreign key (COURSE_ID)
  references T_COURSES (ID);

prompt Creating XB_BOOK_TYPES...
create table XB_BOOK_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table XB_BOOK_TYPES
  is '教材类型';
comment on column XB_BOOK_TYPES.id
  is '非业务主键';
comment on column XB_BOOK_TYPES.code
  is '代码';
comment on column XB_BOOK_TYPES.created_at
  is '创建时间';
comment on column XB_BOOK_TYPES.effective_at
  is '生效时间';
comment on column XB_BOOK_TYPES.eng_name
  is '英文名称';
comment on column XB_BOOK_TYPES.invalid_at
  is '失效时间';
comment on column XB_BOOK_TYPES.name
  is '名称';
comment on column XB_BOOK_TYPES.updated_at
  is '修改时间';
alter table XB_BOOK_TYPES
  add primary key (ID);
alter table XB_BOOK_TYPES
  add constraint UK_6XMIA4FO35YHUBEUNQ6IJEQ57 unique (CODE);

prompt Creating T_TEXTBOOKS...
create table T_TEXTBOOKS
(
  id            NUMBER(19) not null,
  author        VARCHAR2(100 CHAR),
  description   VARCHAR2(500 CHAR),
  effective_at  TIMESTAMP(6) not null,
  invalid_at    TIMESTAMP(6),
  isbn          VARCHAR2(50 CHAR),
  name          VARCHAR2(200 CHAR) not null,
  price         NUMBER(10),
  published     NUMBER(1) not null,
  published_on  DATE,
  remark        VARCHAR2(500 CHAR),
  version       VARCHAR2(255 CHAR),
  award_type_id NUMBER(10),
  book_type_id  NUMBER(10) not null,
  press_id      NUMBER(10) not null
)
;
comment on table T_TEXTBOOKS
  is '教材';
comment on column T_TEXTBOOKS.id
  is '非业务主键';
comment on column T_TEXTBOOKS.author
  is '作者';
comment on column T_TEXTBOOKS.description
  is '说明';
comment on column T_TEXTBOOKS.effective_at
  is '生效时间';
comment on column T_TEXTBOOKS.invalid_at
  is '失效时间';
comment on column T_TEXTBOOKS.isbn
  is 'isbn号';
comment on column T_TEXTBOOKS.name
  is '名称';
comment on column T_TEXTBOOKS.price
  is '价格';
comment on column T_TEXTBOOKS.published
  is '是否出版教材';
comment on column T_TEXTBOOKS.published_on
  is '出版年月';
comment on column T_TEXTBOOKS.remark
  is '备注';
comment on column T_TEXTBOOKS.version
  is '版本';
comment on column T_TEXTBOOKS.award_type_id
  is '获奖等级 ID ###引用表名是HB_BOOK_AWARD_TYPES### ';
comment on column T_TEXTBOOKS.book_type_id
  is '教材类型 ID ###引用表名是XB_BOOK_TYPES### ';
comment on column T_TEXTBOOKS.press_id
  is '出版社 ID ###引用表名是HB_PRESSES### ';
alter table T_TEXTBOOKS
  add primary key (ID);
alter table T_TEXTBOOKS
  add constraint UK_2G6D3VXVSDNGR0QPN80FNSGQQ unique (ISBN);
alter table T_TEXTBOOKS
  add constraint FK_8LXQ4C2R4T5TX8OK0C2TALTU6 foreign key (PRESS_ID)
  references HB_PRESSES (ID);
alter table T_TEXTBOOKS
  add constraint FK_DS5QW7CY8EJYVHQQM8MPQGDR4 foreign key (BOOK_TYPE_ID)
  references XB_BOOK_TYPES (ID);
alter table T_TEXTBOOKS
  add constraint FK_RO40M8616494GG5F1H57KVEGP foreign key (AWARD_TYPE_ID)
  references HB_BOOK_AWARD_TYPES (ID);

prompt Creating T_COURSES_REFERBOOKS...
create table T_COURSES_REFERBOOKS
(
  course_id   NUMBER(19) not null,
  textbook_id NUMBER(19) not null
)
;
comment on table T_COURSES_REFERBOOKS
  is '课程基本信息-参考书目';
comment on column T_COURSES_REFERBOOKS.course_id
  is '课程基本信息 ID ###引用表名是T_COURSES### ';
comment on column T_COURSES_REFERBOOKS.textbook_id
  is '教材 ID ###引用表名是T_TEXTBOOKS### ';
alter table T_COURSES_REFERBOOKS
  add primary key (COURSE_ID, TEXTBOOK_ID);
alter table T_COURSES_REFERBOOKS
  add constraint FK_7VJTJIFEFBFS7CP7UDJ1B66X3 foreign key (COURSE_ID)
  references T_COURSES (ID);
alter table T_COURSES_REFERBOOKS
  add constraint FK_JXPMG3J50K27LNJCU7H5L3RKE foreign key (TEXTBOOK_ID)
  references T_TEXTBOOKS (ID);

prompt Creating T_COURSES_TEXTBOOKS...
create table T_COURSES_TEXTBOOKS
(
  course_id   NUMBER(19) not null,
  textbook_id NUMBER(19) not null
)
;
comment on table T_COURSES_TEXTBOOKS
  is '课程基本信息-常用教材';
comment on column T_COURSES_TEXTBOOKS.course_id
  is '课程基本信息 ID ###引用表名是T_COURSES### ';
comment on column T_COURSES_TEXTBOOKS.textbook_id
  is '教材 ID ###引用表名是T_TEXTBOOKS### ';
alter table T_COURSES_TEXTBOOKS
  add primary key (COURSE_ID, TEXTBOOK_ID);
alter table T_COURSES_TEXTBOOKS
  add constraint FK_5AUKGQAMNLNXXPS50TWG1G9K6 foreign key (COURSE_ID)
  references T_COURSES (ID);
alter table T_COURSES_TEXTBOOKS
  add constraint FK_FVC0NJ9UV9EKPNR1EERLDH7QI foreign key (TEXTBOOK_ID)
  references T_TEXTBOOKS (ID);

prompt Creating T_COURSES_XMAJORS...
create table T_COURSES_XMAJORS
(
  course_id NUMBER(19) not null,
  major_id  NUMBER(10) not null
)
;
comment on table T_COURSES_XMAJORS
  is '课程基本信息-排除专业';
comment on column T_COURSES_XMAJORS.course_id
  is '课程基本信息 ID ###引用表名是T_COURSES### ';
comment on column T_COURSES_XMAJORS.major_id
  is '专业 ID ###引用表名是C_MAJORS### ';
alter table T_COURSES_XMAJORS
  add primary key (COURSE_ID, MAJOR_ID);
alter table T_COURSES_XMAJORS
  add constraint FK_P3FLF4NBTC0YATGJUQD4JXKRD foreign key (MAJOR_ID)
  references C_MAJORS (ID);
alter table T_COURSES_XMAJORS
  add constraint FK_PEEFUSM6UTHCK48SYS3U0XFBS foreign key (COURSE_ID)
  references T_COURSES (ID);

prompt Creating T_COURSE_ACTIVITIES...
create table T_COURSE_ACTIVITIES
(
  id             NUMBER(19) not null,
  remark         VARCHAR2(500 CHAR),
  end_time       NUMBER(10),
  end_unit       NUMBER(10),
  start_time     NUMBER(10),
  start_unit     NUMBER(10),
  week_state     VARCHAR2(255 CHAR),
  week_state_num NUMBER(19),
  weekday        NUMBER(10),
  lesson_id      NUMBER(19) not null
)
;
comment on table T_COURSE_ACTIVITIES
  is '教学活动';
comment on column T_COURSE_ACTIVITIES.id
  is '非业务主键';
comment on column T_COURSE_ACTIVITIES.remark
  is '排课备注';
comment on column T_COURSE_ACTIVITIES.end_time
  is '结束时间';
comment on column T_COURSE_ACTIVITIES.end_unit
  is '结束小节';
comment on column T_COURSE_ACTIVITIES.start_time
  is '开始时间';
comment on column T_COURSE_ACTIVITIES.start_unit
  is '开始小节';
comment on column T_COURSE_ACTIVITIES.week_state
  is '周状态';
comment on column T_COURSE_ACTIVITIES.week_state_num
  is '周状态数字';
comment on column T_COURSE_ACTIVITIES.weekday
  is '星期几';
comment on column T_COURSE_ACTIVITIES.lesson_id
  is '教学任务 ID ###引用表名是T_LESSONS### ';
alter table T_COURSE_ACTIVITIES
  add primary key (ID);
alter table T_COURSE_ACTIVITIES
  add constraint FK_95HLG2G6HWAFDK7FES8JV8X56 foreign key (LESSON_ID)
  references T_LESSONS (ID);

prompt Creating T_COURSE_ACTIVITIES_ROOMS...
create table T_COURSE_ACTIVITIES_ROOMS
(
  course_activity_id NUMBER(19) not null,
  classroom_id       NUMBER(10) not null
)
;
comment on table T_COURSE_ACTIVITIES_ROOMS
  is '教学活动-教室列表';
comment on column T_COURSE_ACTIVITIES_ROOMS.course_activity_id
  is '教学活动 ID ###引用表名是T_COURSE_ACTIVITIES### ';
comment on column T_COURSE_ACTIVITIES_ROOMS.classroom_id
  is '教室基本信息 ID ###引用表名是C_CLASSROOMS### ';
alter table T_COURSE_ACTIVITIES_ROOMS
  add primary key (COURSE_ACTIVITY_ID, CLASSROOM_ID);
alter table T_COURSE_ACTIVITIES_ROOMS
  add constraint FK_OGBAXSWOFC4AWY4MVF4I90XFL foreign key (COURSE_ACTIVITY_ID)
  references T_COURSE_ACTIVITIES (ID);
alter table T_COURSE_ACTIVITIES_ROOMS
  add constraint FK_YR7W0Y8906PLLSONW48GKDJ6 foreign key (CLASSROOM_ID)
  references C_CLASSROOMS (ID);

prompt Creating T_COURSE_ACTIVITIES_TEACHERS...
create table T_COURSE_ACTIVITIES_TEACHERS
(
  course_activity_id NUMBER(19) not null,
  teacher_id         NUMBER(19) not null
)
;
comment on table T_COURSE_ACTIVITIES_TEACHERS
  is '教学活动-授课教师列表';
comment on column T_COURSE_ACTIVITIES_TEACHERS.course_activity_id
  is '教学活动 ID ###引用表名是T_COURSE_ACTIVITIES### ';
comment on column T_COURSE_ACTIVITIES_TEACHERS.teacher_id
  is '教师信息默认实现 ID ###引用表名是C_TEACHERS### ';
alter table T_COURSE_ACTIVITIES_TEACHERS
  add primary key (COURSE_ACTIVITY_ID, TEACHER_ID);
alter table T_COURSE_ACTIVITIES_TEACHERS
  add constraint FK_GC8HU217V0S9K863FDNJ4771B foreign key (TEACHER_ID)
  references C_TEACHERS (ID);
alter table T_COURSE_ACTIVITIES_TEACHERS
  add constraint FK_RJ6TEWARL9AWEP8HFQXB1ITOY foreign key (COURSE_ACTIVITY_ID)
  references T_COURSE_ACTIVITIES (ID);

prompt Creating T_COURSE_ARRANGE_ALTERS...
create table T_COURSE_ARRANGE_ALTERS
(
  id                NUMBER(19) not null,
  alter_from        VARCHAR2(100 CHAR),
  alteration_after  VARCHAR2(500 CHAR),
  alteration_at     TIMESTAMP(6) not null,
  alteration_before VARCHAR2(500 CHAR),
  lesson_id         NUMBER(19) not null,
  alter_by_id       NUMBER(19) not null,
  semester_id       NUMBER(10) not null
)
;
comment on table T_COURSE_ARRANGE_ALTERS
  is '排课变更信息';
comment on column T_COURSE_ARRANGE_ALTERS.id
  is '非业务主键';
comment on column T_COURSE_ARRANGE_ALTERS.alter_from
  is '访问路径';
comment on column T_COURSE_ARRANGE_ALTERS.alteration_after
  is '调课后信息';
comment on column T_COURSE_ARRANGE_ALTERS.alteration_at
  is '调课发生时间';
comment on column T_COURSE_ARRANGE_ALTERS.alteration_before
  is '调课前信息';
comment on column T_COURSE_ARRANGE_ALTERS.lesson_id
  is '教学任务ID';
comment on column T_COURSE_ARRANGE_ALTERS.alter_by_id
  is '调课人 ID ###引用表名是SE_USERS### ';
comment on column T_COURSE_ARRANGE_ALTERS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
alter table T_COURSE_ARRANGE_ALTERS
  add primary key (ID);
alter table T_COURSE_ARRANGE_ALTERS
  add constraint FK_46L57JJ83DDATQCX1A53K2ABI foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_COURSE_ARRANGE_ALTERS
  add constraint FK_MWW7G0VL0BQ6CWDV0LNYBPTV6 foreign key (ALTER_BY_ID)
  references SE_USERS (ID);

prompt Creating T_COURSE_ARRANGE_SWITCHES...
create table T_COURSE_ARRANGE_SWITCHES
(
  id          NUMBER(19) not null,
  published   NUMBER(1) not null,
  project_id  NUMBER(10),
  semester_id NUMBER(10)
)
;
comment on table T_COURSE_ARRANGE_SWITCHES
  is '学期排课发布';
comment on column T_COURSE_ARRANGE_SWITCHES.id
  is '非业务主键';
comment on column T_COURSE_ARRANGE_SWITCHES.published
  is '是否发布';
comment on column T_COURSE_ARRANGE_SWITCHES.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column T_COURSE_ARRANGE_SWITCHES.semester_id
  is '学期 ID ###引用表名是C_SEMESTERS### ';
alter table T_COURSE_ARRANGE_SWITCHES
  add primary key (ID);
alter table T_COURSE_ARRANGE_SWITCHES
  add constraint UK_78VMSF4QTFY2PKJ0X7X0KR4V6 unique (PROJECT_ID, SEMESTER_ID);
alter table T_COURSE_ARRANGE_SWITCHES
  add constraint FK_4KBHIV8R0S5PCH4WHTLUK0U78 foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table T_COURSE_ARRANGE_SWITCHES
  add constraint FK_R7ULXROS5U0D48C2L0OQH89LU foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);

prompt Creating T_COURSE_CODE_STANDARDS...
create table T_COURSE_CODE_STANDARDS
(
  id         NUMBER(19) not null,
  created_at TIMESTAMP(6),
  updated_at TIMESTAMP(6),
  name       VARCHAR2(50 CHAR) not null,
  prefix     VARCHAR2(20 CHAR) not null,
  remark     VARCHAR2(100 CHAR),
  seq_length NUMBER(10) not null,
  project_id NUMBER(10)
)
;
comment on table T_COURSE_CODE_STANDARDS
  is '课程代码的编码规范';
comment on column T_COURSE_CODE_STANDARDS.id
  is '非业务主键';
comment on column T_COURSE_CODE_STANDARDS.created_at
  is '创建时间';
comment on column T_COURSE_CODE_STANDARDS.updated_at
  is '更新时间';
comment on column T_COURSE_CODE_STANDARDS.name
  is '名称';
comment on column T_COURSE_CODE_STANDARDS.prefix
  is '前缀';
comment on column T_COURSE_CODE_STANDARDS.remark
  is '备注';
comment on column T_COURSE_CODE_STANDARDS.seq_length
  is '流水号长度';
comment on column T_COURSE_CODE_STANDARDS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
alter table T_COURSE_CODE_STANDARDS
  add primary key (ID);
alter table T_COURSE_CODE_STANDARDS
  add constraint FK_P5AHQ4H8X8PKPNGPC9TMWUOLC foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating T_COURSE_EXT_INFOES...
create table T_COURSE_EXT_INFOES
(
  id              NUMBER(19) not null,
  compulsory      NUMBER(1) not null,
  description     VARCHAR2(4000 CHAR),
  eng_description VARCHAR2(4000 CHAR),
  requirement     VARCHAR2(500 CHAR),
  course_id       NUMBER(19)
)
;
comment on table T_COURSE_EXT_INFOES
  is '课程扩展信息';
comment on column T_COURSE_EXT_INFOES.id
  is '非业务主键';
comment on column T_COURSE_EXT_INFOES.compulsory
  is '是否必修';
comment on column T_COURSE_EXT_INFOES.description
  is '课程描述';
comment on column T_COURSE_EXT_INFOES.eng_description
  is '英文课程描述';
comment on column T_COURSE_EXT_INFOES.requirement
  is '课程要求';
comment on column T_COURSE_EXT_INFOES.course_id
  is '课程 ID ###引用表名是T_COURSES### ';
alter table T_COURSE_EXT_INFOES
  add primary key (ID);
alter table T_COURSE_EXT_INFOES
  add constraint FK_M2EYBVA2AAF2OQHO5Y4A1EJU3 foreign key (COURSE_ID)
  references T_COURSES (ID);

prompt Creating T_COURSE_EXT_INFOES_TEACHERS...
create table T_COURSE_EXT_INFOES_TEACHERS
(
  course_ext_info_id NUMBER(19) not null,
  teacher_id         NUMBER(19) not null
)
;
comment on table T_COURSE_EXT_INFOES_TEACHERS
  is '课程扩展信息-授课教师';
comment on column T_COURSE_EXT_INFOES_TEACHERS.course_ext_info_id
  is '课程扩展信息 ID ###引用表名是T_COURSE_EXT_INFOES### ';
comment on column T_COURSE_EXT_INFOES_TEACHERS.teacher_id
  is '教师信息默认实现 ID ###引用表名是C_TEACHERS### ';
alter table T_COURSE_EXT_INFOES_TEACHERS
  add constraint FK_F5SEDQEBC1M6V2A4AOLX407CK foreign key (COURSE_EXT_INFO_ID)
  references T_COURSE_EXT_INFOES (ID);
alter table T_COURSE_EXT_INFOES_TEACHERS
  add constraint FK_LQN2RO354P8O134EQ18OPDXRO foreign key (TEACHER_ID)
  references C_TEACHERS (ID);

prompt Creating T_COURSE_GRADES...
create table T_COURSE_GRADES
(
  id                  NUMBER(19) not null,
  created_at          TIMESTAMP(6),
  updated_at          TIMESTAMP(6),
  operator            VARCHAR2(50 CHAR),
  passed              NUMBER(1) not null,
  score               FLOAT,
  score_text          VARCHAR2(255 CHAR),
  status              NUMBER(10) not null,
  gp                  FLOAT,
  lesson_no           VARCHAR2(255 CHAR),
  remark              VARCHAR2(255 CHAR),
  mark_style_id       NUMBER(10) not null,
  project_id          NUMBER(10) not null,
  semester_id         NUMBER(10) not null,
  std_id              NUMBER(19) not null,
  course_id           NUMBER(19) not null,
  course_take_type_id NUMBER(10),
  course_type_id      NUMBER(10) not null,
  exam_mode_id        NUMBER(10),
  lesson_id           NUMBER(19)
)
;
comment on table T_COURSE_GRADES
  is '课程成绩实现';
comment on column T_COURSE_GRADES.id
  is '非业务主键';
comment on column T_COURSE_GRADES.created_at
  is '创建时间';
comment on column T_COURSE_GRADES.updated_at
  is '更新时间';
comment on column T_COURSE_GRADES.operator
  is '操作者';
comment on column T_COURSE_GRADES.passed
  is '是否合格';
comment on column T_COURSE_GRADES.score
  is '得分';
comment on column T_COURSE_GRADES.score_text
  is '得分等级/等分文本内容';
comment on column T_COURSE_GRADES.status
  is '状态';
comment on column T_COURSE_GRADES.gp
  is '绩点';
comment on column T_COURSE_GRADES.lesson_no
  is '课程序号';
comment on column T_COURSE_GRADES.remark
  is '备注';
comment on column T_COURSE_GRADES.mark_style_id
  is '成绩记录方式 ID ###引用表名是HB_SCORE_MARK_STYLES### ';
comment on column T_COURSE_GRADES.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column T_COURSE_GRADES.semester_id
  is '教学日历 ID ###引用表名是C_SEMESTERS### ';
comment on column T_COURSE_GRADES.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
comment on column T_COURSE_GRADES.course_id
  is '课程 ID ###引用表名是T_COURSES### ';
comment on column T_COURSE_GRADES.course_take_type_id
  is '上课信息 修读类别 ID ###引用表名是HB_COURSE_TAKE_TYPES### ';
comment on column T_COURSE_GRADES.course_type_id
  is '课程类别 ID ###引用表名是XB_COURSE_TYPES### ';
comment on column T_COURSE_GRADES.exam_mode_id
  is '考核方式 ID ###引用表名是HB_EXAM_MODES### ';
comment on column T_COURSE_GRADES.lesson_id
  is '教学任务 ID ###引用表名是T_LESSONS### ';
alter table T_COURSE_GRADES
  add primary key (ID);
alter table T_COURSE_GRADES
  add constraint UK_7MWE79CTIHUBDNTH895ET77C4 unique (PROJECT_ID, SEMESTER_ID, STD_ID, COURSE_ID);
alter table T_COURSE_GRADES
  add constraint FK_1NP0QVEMY17I6DB6OD3H3XGFC foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table T_COURSE_GRADES
  add constraint FK_20FDN44PX3K146K5LCBS69IKW foreign key (LESSON_ID)
  references T_LESSONS (ID);
alter table T_COURSE_GRADES
  add constraint FK_3VK3Q266KVHPI4DR22S44IL5Y foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table T_COURSE_GRADES
  add constraint FK_8XHQ6SNHO466RN6JN60GFD1LM foreign key (EXAM_MODE_ID)
  references HB_EXAM_MODES (ID);
alter table T_COURSE_GRADES
  add constraint FK_EXCYN57GSI1DEMB7KMWAQVNR3 foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_COURSE_GRADES
  add constraint FK_LVQWJ4PKJ28O21L554SQO9X8W foreign key (COURSE_TYPE_ID)
  references XB_COURSE_TYPES (ID);
alter table T_COURSE_GRADES
  add constraint FK_NULTG958RRSXYSPEW0UP5DNND foreign key (COURSE_TAKE_TYPE_ID)
  references HB_COURSE_TAKE_TYPES (ID);
alter table T_COURSE_GRADES
  add constraint FK_S8WL5S1CJ10NDJ6XP5FH8G53T foreign key (MARK_STYLE_ID)
  references HB_SCORE_MARK_STYLES (ID);
alter table T_COURSE_GRADES
  add constraint FK_TAAMV61QGB66WRI98XD0G7FDB foreign key (COURSE_ID)
  references T_COURSES (ID);

prompt Creating T_EXCHANGE_SCHOOLS...
create table T_EXCHANGE_SCHOOLS
(
  id           NUMBER(19) not null,
  created_at   TIMESTAMP(6),
  updated_at   TIMESTAMP(6),
  code         VARCHAR2(32 CHAR) not null,
  effective_at TIMESTAMP(6),
  eng_name     VARCHAR2(255 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  country_id   NUMBER(10)
)
;
comment on table T_EXCHANGE_SCHOOLS
  is '交流学校';
comment on column T_EXCHANGE_SCHOOLS.id
  is '非业务主键';
comment on column T_EXCHANGE_SCHOOLS.created_at
  is '创建时间';
comment on column T_EXCHANGE_SCHOOLS.updated_at
  is '更新时间';
comment on column T_EXCHANGE_SCHOOLS.code
  is '编号';
comment on column T_EXCHANGE_SCHOOLS.effective_at
  is '开始时间';
comment on column T_EXCHANGE_SCHOOLS.eng_name
  is '英文名称';
comment on column T_EXCHANGE_SCHOOLS.invalid_at
  is '结束时间';
comment on column T_EXCHANGE_SCHOOLS.name
  is '名称';
comment on column T_EXCHANGE_SCHOOLS.country_id
  is '国家地区 ID ###引用表名是GB_COUNTRIES### ';
alter table T_EXCHANGE_SCHOOLS
  add primary key (ID);
alter table T_EXCHANGE_SCHOOLS
  add constraint FK_6A4389IEA0TBOGWVT65XVJQ1H foreign key (COUNTRY_ID)
  references GB_COUNTRIES (ID);

prompt Creating T_EXCHANGE_COURSES...
create table T_EXCHANGE_COURSES
(
  id           NUMBER(19) not null,
  created_at   TIMESTAMP(6),
  updated_at   TIMESTAMP(6),
  code         VARCHAR2(32 CHAR),
  credits      FLOAT,
  effective_at TIMESTAMP(6),
  eng_name     VARCHAR2(255 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  period       VARCHAR2(255 CHAR),
  remark       VARCHAR2(255 CHAR),
  school_id    NUMBER(19)
)
;
comment on table T_EXCHANGE_COURSES
  is '交流课程库';
comment on column T_EXCHANGE_COURSES.id
  is '非业务主键';
comment on column T_EXCHANGE_COURSES.created_at
  is '创建时间';
comment on column T_EXCHANGE_COURSES.updated_at
  is '更新时间';
comment on column T_EXCHANGE_COURSES.code
  is '编号';
comment on column T_EXCHANGE_COURSES.credits
  is '学分';
comment on column T_EXCHANGE_COURSES.effective_at
  is '开始时间';
comment on column T_EXCHANGE_COURSES.eng_name
  is '英文名称';
comment on column T_EXCHANGE_COURSES.invalid_at
  is '结束时间';
comment on column T_EXCHANGE_COURSES.name
  is '名称';
comment on column T_EXCHANGE_COURSES.period
  is '学时';
comment on column T_EXCHANGE_COURSES.remark
  is '备注';
comment on column T_EXCHANGE_COURSES.school_id
  is '交流学校 ID ###引用表名是T_EXCHANGE_SCHOOLS### ';
alter table T_EXCHANGE_COURSES
  add primary key (ID);
alter table T_EXCHANGE_COURSES
  add constraint FK_5SQ741XV167KHCCP48U8JR4I5 foreign key (SCHOOL_ID)
  references T_EXCHANGE_SCHOOLS (ID);

prompt Creating T_COURSE_GRADES_EXCHANGES...
create table T_COURSE_GRADES_EXCHANGES
(
  course_grade_id    NUMBER(19) not null,
  exchange_course_id NUMBER(19) not null
)
;
comment on table T_COURSE_GRADES_EXCHANGES
  is '课程成绩实现-对应交换成绩';
comment on column T_COURSE_GRADES_EXCHANGES.course_grade_id
  is '课程成绩实现 ID ###引用表名是T_COURSE_GRADES### ';
comment on column T_COURSE_GRADES_EXCHANGES.exchange_course_id
  is '交流课程库 ID ###引用表名是T_EXCHANGE_COURSES### ';
alter table T_COURSE_GRADES_EXCHANGES
  add primary key (COURSE_GRADE_ID, EXCHANGE_COURSE_ID);
alter table T_COURSE_GRADES_EXCHANGES
  add constraint FK_58F9XQVN0NA9XHIRMVGBJ5OSE foreign key (COURSE_GRADE_ID)
  references T_COURSE_GRADES (ID);
alter table T_COURSE_GRADES_EXCHANGES
  add constraint FK_OU5IUQF7E9TG2B6PN3YTEHIL8 foreign key (EXCHANGE_COURSE_ID)
  references T_EXCHANGE_COURSES (ID);

prompt Creating T_COURSE_GRADE_STATES...
create table T_COURSE_GRADE_STATES
(
  id                  NUMBER(19) not null,
  inputed_at          TIMESTAMP(6),
  operator            VARCHAR2(50 CHAR),
  precision           NUMBER(10) not null,
  status              NUMBER(10) not null,
  audit_reason        VARCHAR2(255 CHAR),
  audit_status        VARCHAR2(255 CHAR),
  score_mark_style_id NUMBER(10) not null,
  extra_inputer_id    NUMBER(19),
  lesson_id           NUMBER(19)
)
;
comment on table T_COURSE_GRADE_STATES
  is '成绩状态表';
comment on column T_COURSE_GRADE_STATES.id
  is '非业务主键';
comment on column T_COURSE_GRADE_STATES.inputed_at
  is '上次成绩录入时间';
comment on column T_COURSE_GRADE_STATES.operator
  is '操作者';
comment on column T_COURSE_GRADE_STATES.precision
  is '小数点后保留几位';
comment on column T_COURSE_GRADE_STATES.status
  is '成绩录入状态';
comment on column T_COURSE_GRADE_STATES.audit_reason
  is '审核理由';
comment on column T_COURSE_GRADE_STATES.audit_status
  is '个人百分比审核状态';
comment on column T_COURSE_GRADE_STATES.score_mark_style_id
  is '成绩记录方式 ID ###引用表名是HB_SCORE_MARK_STYLES### ';
comment on column T_COURSE_GRADE_STATES.extra_inputer_id
  is '其他录入人 ID ###引用表名是SE_USERS### ';
comment on column T_COURSE_GRADE_STATES.lesson_id
  is '教学任务 ID ###引用表名是T_LESSONS### ';
alter table T_COURSE_GRADE_STATES
  add primary key (ID);
alter table T_COURSE_GRADE_STATES
  add constraint FK_5X7ICADIIBCD3QSI9WTDD29F8 foreign key (LESSON_ID)
  references T_LESSONS (ID);
alter table T_COURSE_GRADE_STATES
  add constraint FK_KFP7L8GLS2986X3MG3N96RFEV foreign key (EXTRA_INPUTER_ID)
  references SE_USERS (ID);
alter table T_COURSE_GRADE_STATES
  add constraint FK_QBD4MJTEL76Q5WD9VW6WP70R2 foreign key (SCORE_MARK_STYLE_ID)
  references HB_SCORE_MARK_STYLES (ID);

prompt Creating XB_COURSE_HOUR_TYPES...
create table XB_COURSE_HOUR_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table XB_COURSE_HOUR_TYPES
  is '课时类别代码';
comment on column XB_COURSE_HOUR_TYPES.id
  is '非业务主键';
comment on column XB_COURSE_HOUR_TYPES.code
  is '代码';
comment on column XB_COURSE_HOUR_TYPES.created_at
  is '创建时间';
comment on column XB_COURSE_HOUR_TYPES.effective_at
  is '生效时间';
comment on column XB_COURSE_HOUR_TYPES.eng_name
  is '英文名称';
comment on column XB_COURSE_HOUR_TYPES.invalid_at
  is '失效时间';
comment on column XB_COURSE_HOUR_TYPES.name
  is '名称';
comment on column XB_COURSE_HOUR_TYPES.updated_at
  is '修改时间';
alter table XB_COURSE_HOUR_TYPES
  add primary key (ID);
alter table XB_COURSE_HOUR_TYPES
  add constraint UK_DY755DI98FI71GW66JRY1RI7O unique (CODE);

prompt Creating T_COURSE_HOURS...
create table T_COURSE_HOURS
(
  id        NUMBER(19) not null,
  period    NUMBER(10) not null,
  week_hour NUMBER(10),
  weeks     NUMBER(10),
  course_id NUMBER(19) not null,
  type_id   NUMBER(10) not null
)
;
comment on table T_COURSE_HOURS
  is '课程分类课时信息';
comment on column T_COURSE_HOURS.id
  is '非业务主键';
comment on column T_COURSE_HOURS.period
  is '学时/总课时';
comment on column T_COURSE_HOURS.week_hour
  is '周课时';
comment on column T_COURSE_HOURS.weeks
  is '周数';
comment on column T_COURSE_HOURS.course_id
  is '课程 ID ###引用表名是T_COURSES### ';
comment on column T_COURSE_HOURS.type_id
  is '课时类型 ID ###引用表名是XB_COURSE_HOUR_TYPES### ';
alter table T_COURSE_HOURS
  add primary key (ID);
alter table T_COURSE_HOURS
  add constraint FK_IXEBHUK8MXESJT0JETFAR9V8U foreign key (TYPE_ID)
  references XB_COURSE_HOUR_TYPES (ID);
alter table T_COURSE_HOURS
  add constraint FK_TPEU0EEJ2DQ4PBEQO7OCEA5D4 foreign key (COURSE_ID)
  references T_COURSES (ID);

prompt Creating T_COURSE_LIMIT_GROUPS...
create table T_COURSE_LIMIT_GROUPS
(
  id        NUMBER(19) not null,
  cur_count NUMBER(10) not null,
  for_class NUMBER(1) not null,
  max_count NUMBER(10) not null,
  lesson_id NUMBER(19) not null
)
;
comment on table T_COURSE_LIMIT_GROUPS
  is '课程限制条件组';
comment on column T_COURSE_LIMIT_GROUPS.id
  is '非业务主键';
comment on column T_COURSE_LIMIT_GROUPS.cur_count
  is '当前人数';
comment on column T_COURSE_LIMIT_GROUPS.for_class
  is '授课对象还是选课对象';
comment on column T_COURSE_LIMIT_GROUPS.max_count
  is '最大人数';
comment on column T_COURSE_LIMIT_GROUPS.lesson_id
  is '教学任务 ID ###引用表名是T_LESSONS### ';
alter table T_COURSE_LIMIT_GROUPS
  add primary key (ID);
alter table T_COURSE_LIMIT_GROUPS
  add constraint FK_T4GSB4NBQERTRF0OKETFDY38J foreign key (LESSON_ID)
  references T_LESSONS (ID);

prompt Creating T_COURSE_LIMIT_METAS...
create table T_COURSE_LIMIT_METAS
(
  id     NUMBER(19) not null,
  name   VARCHAR2(255 CHAR) not null,
  remark VARCHAR2(255 CHAR) not null
)
;
comment on table T_COURSE_LIMIT_METAS
  is '课程限制元信息';
comment on column T_COURSE_LIMIT_METAS.id
  is '非业务主键';
comment on column T_COURSE_LIMIT_METAS.name
  is '名称';
comment on column T_COURSE_LIMIT_METAS.remark
  is '备注';
alter table T_COURSE_LIMIT_METAS
  add primary key (ID);

prompt Creating T_COURSE_LIMIT_ITEMS...
create table T_COURSE_LIMIT_ITEMS
(
  id       NUMBER(19) not null,
  content  VARCHAR2(255 CHAR) not null,
  operator VARCHAR2(255 CHAR) not null,
  group_id NUMBER(19) not null,
  meta_id  NUMBER(19) not null
)
;
comment on table T_COURSE_LIMIT_ITEMS
  is '课程限制项';
comment on column T_COURSE_LIMIT_ITEMS.id
  is '非业务主键';
comment on column T_COURSE_LIMIT_ITEMS.content
  is '限制内容';
comment on column T_COURSE_LIMIT_ITEMS.operator
  is '操作符';
comment on column T_COURSE_LIMIT_ITEMS.group_id
  is '所在限制组 ID ###引用表名是T_COURSE_LIMIT_GROUPS### ';
comment on column T_COURSE_LIMIT_ITEMS.meta_id
  is '限制具体项目 ID ###引用表名是T_COURSE_LIMIT_METAS### ';
alter table T_COURSE_LIMIT_ITEMS
  add primary key (ID);
alter table T_COURSE_LIMIT_ITEMS
  add constraint FK_9AY9WE57FR399KJ78EK70LKLH foreign key (META_ID)
  references T_COURSE_LIMIT_METAS (ID);
alter table T_COURSE_LIMIT_ITEMS
  add constraint FK_IAU92QTHQW8DGOYY73YC45FSW foreign key (GROUP_ID)
  references T_COURSE_LIMIT_GROUPS (ID);

prompt Creating T_COURSE_MAIL_SETTINGS...
create table T_COURSE_MAIL_SETTINGS
(
  id         NUMBER(19) not null,
  created_at TIMESTAMP(6),
  updated_at TIMESTAMP(6),
  module     VARCHAR2(3000 CHAR) not null,
  name       VARCHAR2(255 CHAR) not null,
  title      VARCHAR2(255 CHAR) not null,
  creator_id NUMBER(19) not null
)
;
comment on table T_COURSE_MAIL_SETTINGS
  is '课表邮件';
comment on column T_COURSE_MAIL_SETTINGS.id
  is '非业务主键';
comment on column T_COURSE_MAIL_SETTINGS.created_at
  is '创建时间';
comment on column T_COURSE_MAIL_SETTINGS.updated_at
  is '更新时间';
comment on column T_COURSE_MAIL_SETTINGS.module
  is '邮件模板';
comment on column T_COURSE_MAIL_SETTINGS.name
  is '邮件设置描述';
comment on column T_COURSE_MAIL_SETTINGS.title
  is '邮件标题';
comment on column T_COURSE_MAIL_SETTINGS.creator_id
  is '创建者 ID ###引用表名是SE_USERS### ';
alter table T_COURSE_MAIL_SETTINGS
  add primary key (ID);
alter table T_COURSE_MAIL_SETTINGS
  add constraint UK_9G5WTVXNCOFJDDYHGIB51EED0 unique (NAME);
alter table T_COURSE_MAIL_SETTINGS
  add constraint FK_L2S79NBIJTAMEAASLO7RMOMOF foreign key (CREATOR_ID)
  references SE_USERS (ID);

prompt Creating T_COURSE_MATERIALS...
create table T_COURSE_MATERIALS
(
  id              NUMBER(19) not null,
  audit_at        TIMESTAMP(6),
  extra           VARCHAR2(500 CHAR),
  passed          NUMBER(1),
  reference_books VARCHAR2(500 CHAR),
  remark          VARCHAR2(500 CHAR),
  status          VARCHAR2(255 CHAR) not null,
  use_explain     VARCHAR2(500 CHAR),
  course_id       NUMBER(19),
  department_id   NUMBER(10),
  semester_id     NUMBER(10)
)
;
comment on table T_COURSE_MATERIALS
  is '教学资料';
comment on column T_COURSE_MATERIALS.id
  is '非业务主键';
comment on column T_COURSE_MATERIALS.audit_at
  is '审核时间';
comment on column T_COURSE_MATERIALS.extra
  is '其它资料';
comment on column T_COURSE_MATERIALS.passed
  is '是否审核通过';
comment on column T_COURSE_MATERIALS.reference_books
  is '参考书';
comment on column T_COURSE_MATERIALS.remark
  is '其它说明';
comment on column T_COURSE_MATERIALS.status
  is '教材指定状态';
comment on column T_COURSE_MATERIALS.use_explain
  is '选用说明';
comment on column T_COURSE_MATERIALS.course_id
  is '课程 ID ###引用表名是T_COURSES### ';
comment on column T_COURSE_MATERIALS.department_id
  is '院系 ID ###引用表名是C_DEPARTMENTS### ';
comment on column T_COURSE_MATERIALS.semester_id
  is '学期 ID ###引用表名是C_SEMESTERS### ';
alter table T_COURSE_MATERIALS
  add primary key (ID);
alter table T_COURSE_MATERIALS
  add constraint UK_K9RVKGMQ8OQBRDYBQOFXT3MVL unique (COURSE_ID, DEPARTMENT_ID, SEMESTER_ID);
alter table T_COURSE_MATERIALS
  add constraint FK_9N0HM5YN4XAKM71RYHHTX19LT foreign key (COURSE_ID)
  references T_COURSES (ID);
alter table T_COURSE_MATERIALS
  add constraint FK_FJI1RAU1QHF6EV9U4AWNPTJT3 foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table T_COURSE_MATERIALS
  add constraint FK_RFMHECV45YWTFWCHTEIA16IFN foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);

prompt Creating T_COURSE_MATERIALS_BOOKS...
create table T_COURSE_MATERIALS_BOOKS
(
  course_material_id NUMBER(19) not null,
  textbook_id        NUMBER(19) not null
)
;
comment on table T_COURSE_MATERIALS_BOOKS
  is '教学资料-教材列表';
comment on column T_COURSE_MATERIALS_BOOKS.course_material_id
  is '教学资料 ID ###引用表名是T_COURSE_MATERIALS### ';
comment on column T_COURSE_MATERIALS_BOOKS.textbook_id
  is '教材 ID ###引用表名是T_TEXTBOOKS### ';
alter table T_COURSE_MATERIALS_BOOKS
  add constraint FK_P3FKTBNB8I8HNM3RMM6TIB1W7 foreign key (COURSE_MATERIAL_ID)
  references T_COURSE_MATERIALS (ID);
alter table T_COURSE_MATERIALS_BOOKS
  add constraint FK_S9Y2W2K2JM5GVW03BY74M3E00 foreign key (TEXTBOOK_ID)
  references T_TEXTBOOKS (ID);

prompt Creating T_COURSE_TABLE_CHECKS...
create table T_COURSE_TABLE_CHECKS
(
  id          NUMBER(19) not null,
  confirm     NUMBER(1) not null,
  confirm_at  TIMESTAMP(6),
  course_num  NUMBER(10) not null,
  credits     FLOAT not null,
  remark      VARCHAR2(500 CHAR),
  semester_id NUMBER(10) not null,
  std_id      NUMBER(19) not null
)
;
comment on table T_COURSE_TABLE_CHECKS
  is '学生课表核对记录';
comment on column T_COURSE_TABLE_CHECKS.id
  is '非业务主键';
comment on column T_COURSE_TABLE_CHECKS.confirm
  is '是否确认';
comment on column T_COURSE_TABLE_CHECKS.confirm_at
  is '核对确认时间';
comment on column T_COURSE_TABLE_CHECKS.course_num
  is '该学期的课程总数';
comment on column T_COURSE_TABLE_CHECKS.credits
  is '该学期的学分总数';
comment on column T_COURSE_TABLE_CHECKS.remark
  is '填写备注';
comment on column T_COURSE_TABLE_CHECKS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
comment on column T_COURSE_TABLE_CHECKS.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table T_COURSE_TABLE_CHECKS
  add primary key (ID);
alter table T_COURSE_TABLE_CHECKS
  add constraint FK_6L44NBJIN46O1UQPT1G9P5XSU foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table T_COURSE_TABLE_CHECKS
  add constraint FK_APMRRU9HL1657TUPXEB7UR8F8 foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);

prompt Creating T_COURSE_TAKES...
create table T_COURSE_TAKES
(
  id                  NUMBER(19) not null,
  created_at          TIMESTAMP(6),
  updated_at          TIMESTAMP(6),
  attend              NUMBER(1) not null,
  paid                NUMBER(1) not null,
  remark              VARCHAR2(255 CHAR),
  turn                NUMBER(10),
  bill_id             NUMBER(19),
  course_take_type_id NUMBER(10) not null,
  election_mode_id    NUMBER(10) not null,
  lesson_id           NUMBER(19) not null,
  limit_group_id      NUMBER(19),
  std_id              NUMBER(19) not null
)
;
comment on table T_COURSE_TAKES
  is '学生修读课程信息';
comment on column T_COURSE_TAKES.id
  is '非业务主键';
comment on column T_COURSE_TAKES.created_at
  is '创建时间';
comment on column T_COURSE_TAKES.updated_at
  is '更新时间';
comment on column T_COURSE_TAKES.attend
  is '是否上课';
comment on column T_COURSE_TAKES.paid
  is '重修费是否支付';
comment on column T_COURSE_TAKES.remark
  is '备注';
comment on column T_COURSE_TAKES.turn
  is '选课轮次';
comment on column T_COURSE_TAKES.bill_id
  is '重修账单 ID ###引用表名是F_BILLS### ';
comment on column T_COURSE_TAKES.course_take_type_id
  is '修读类别 ID ###引用表名是HB_COURSE_TAKE_TYPES### ';
comment on column T_COURSE_TAKES.election_mode_id
  is '选课方式 ID ###引用表名是HB_ELECTION_MODES### ';
comment on column T_COURSE_TAKES.lesson_id
  is '教学任务 ID ###引用表名是T_LESSONS### ';
comment on column T_COURSE_TAKES.limit_group_id
  is '授课对象组 ID ###引用表名是T_COURSE_LIMIT_GROUPS### ';
comment on column T_COURSE_TAKES.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table T_COURSE_TAKES
  add primary key (ID);
alter table T_COURSE_TAKES
  add constraint UK_MSGTXVEQ9XQ6TDRWS3ENTFT57 unique (LESSON_ID, STD_ID);
alter table T_COURSE_TAKES
  add constraint FK_8XP17AEO2HR60BTTRKK72TK22 foreign key (ELECTION_MODE_ID)
  references HB_ELECTION_MODES (ID);
alter table T_COURSE_TAKES
  add constraint FK_APIRN2C61K102TYEKTEKODBDD foreign key (LESSON_ID)
  references T_LESSONS (ID);
alter table T_COURSE_TAKES
  add constraint FK_DFRJH70RQOB0OYPSSFMYHEQE2 foreign key (COURSE_TAKE_TYPE_ID)
  references HB_COURSE_TAKE_TYPES (ID);
alter table T_COURSE_TAKES
  add constraint FK_ETM5EFRR6NCG31TSV6CC2FQLM foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table T_COURSE_TAKES
  add constraint FK_KGVUSTU26I9YPEH6L4K9G4EF8 foreign key (BILL_ID)
  references F_BILLS (ID);
alter table T_COURSE_TAKES
  add constraint FK_R0LQW0JBMVUKL237XS2554SSJ foreign key (LIMIT_GROUP_ID)
  references T_COURSE_LIMIT_GROUPS (ID);

prompt Creating T_COURSE_TYPE_CREDIT_CONS...
create table T_COURSE_TYPE_CREDIT_CONS
(
  id             NUMBER(19) not null,
  grades         VARCHAR2(255 CHAR) not null,
  limit_credit   FLOAT not null,
  course_type_id NUMBER(10) not null,
  education_id   NUMBER(10) not null,
  semester_id    NUMBER(10) not null
)
;
comment on table T_COURSE_TYPE_CREDIT_CONS
  is '课程类型学分限制';
comment on column T_COURSE_TYPE_CREDIT_CONS.id
  is '非业务主键';
comment on column T_COURSE_TYPE_CREDIT_CONS.grades
  is '年级';
comment on column T_COURSE_TYPE_CREDIT_CONS.limit_credit
  is '限选学分';
comment on column T_COURSE_TYPE_CREDIT_CONS.course_type_id
  is '课程性质 ID ###引用表名是XB_COURSE_TYPES### ';
comment on column T_COURSE_TYPE_CREDIT_CONS.education_id
  is '培养类型 ID ###引用表名是HB_EDUCATIONS### ';
comment on column T_COURSE_TYPE_CREDIT_CONS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
alter table T_COURSE_TYPE_CREDIT_CONS
  add primary key (ID);
alter table T_COURSE_TYPE_CREDIT_CONS
  add constraint FK_LCVO18GQFK4QIGT8DY79K2A9W foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);
alter table T_COURSE_TYPE_CREDIT_CONS
  add constraint FK_LPQET9RQO4B8NPTV5VUF4BNE foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_COURSE_TYPE_CREDIT_CONS
  add constraint FK_TQOOCNXV1L0MTVET0M59VHAME foreign key (COURSE_TYPE_ID)
  references XB_COURSE_TYPES (ID);

prompt Creating T_CREDIT_AWARD_CRITERIAS...
create table T_CREDIT_AWARD_CRITERIAS
(
  id              NUMBER(19) not null,
  award_credits   FLOAT not null,
  ceil_avg_grade  FLOAT not null,
  floor_avg_grade FLOAT not null
)
;
comment on table T_CREDIT_AWARD_CRITERIAS
  is '奖励学分标准';
comment on column T_CREDIT_AWARD_CRITERIAS.id
  is '非业务主键';
comment on column T_CREDIT_AWARD_CRITERIAS.award_credits
  is '奖励学分';
comment on column T_CREDIT_AWARD_CRITERIAS.ceil_avg_grade
  is '平均绩点上限(不包含)';
comment on column T_CREDIT_AWARD_CRITERIAS.floor_avg_grade
  is '平均绩点下限(包含)';
alter table T_CREDIT_AWARD_CRITERIAS
  add primary key (ID);

prompt Creating T_CURRICULUM_CHANGE_APPLYS...
create table T_CURRICULUM_CHANGE_APPLYS
(
  id           NUMBER(19) not null,
  passed       NUMBER(1),
  remark       VARCHAR2(2000 CHAR),
  requisition  VARCHAR2(300 CHAR),
  school_hours FLOAT not null,
  time         TIMESTAMP(6) not null,
  lesson_id    NUMBER(19),
  teacher_id   NUMBER(19)
)
;
comment on table T_CURRICULUM_CHANGE_APPLYS
  is '上课调整变更申请';
comment on column T_CURRICULUM_CHANGE_APPLYS.id
  is '非业务主键';
comment on column T_CURRICULUM_CHANGE_APPLYS.passed
  is '审核是否通过';
comment on column T_CURRICULUM_CHANGE_APPLYS.remark
  is '备注';
comment on column T_CURRICULUM_CHANGE_APPLYS.requisition
  is '变更具体内容';
comment on column T_CURRICULUM_CHANGE_APPLYS.school_hours
  is '牵涉的课时数';
comment on column T_CURRICULUM_CHANGE_APPLYS.time
  is '更新时间';
comment on column T_CURRICULUM_CHANGE_APPLYS.lesson_id
  is '教学任务 ID ###引用表名是T_LESSONS### ';
comment on column T_CURRICULUM_CHANGE_APPLYS.teacher_id
  is '教师 ID ###引用表名是C_TEACHERS### ';
alter table T_CURRICULUM_CHANGE_APPLYS
  add primary key (ID);
alter table T_CURRICULUM_CHANGE_APPLYS
  add constraint FK_3G8YNFWMNRKHDHC11DCR87CXN foreign key (LESSON_ID)
  references T_LESSONS (ID);
alter table T_CURRICULUM_CHANGE_APPLYS
  add constraint FK_SNGRSMYKEQ9TTDU6MXQ1KON82 foreign key (TEACHER_ID)
  references C_TEACHERS (ID);

prompt Creating T_ELECTION_PROFILES...
create table T_ELECTION_PROFILES
(
  id                NUMBER(19) not null,
  created_at        TIMESTAMP(6),
  updated_at        TIMESTAMP(6),
  begin_at          TIMESTAMP(6) not null,
  elect_begin_at    TIMESTAMP(6),
  elect_end_at      TIMESTAMP(6),
  end_at            TIMESTAMP(6) not null,
  name              VARCHAR2(255 CHAR) not null,
  notice            VARCHAR2(255 CHAR) not null,
  open_election     NUMBER(1) not null,
  open_withdraw     NUMBER(1) not null,
  profile_type      VARCHAR2(255 CHAR) not null,
  turn              NUMBER(10) not null,
  withdraw_begin_at TIMESTAMP(6),
  withdraw_end_at   TIMESTAMP(6),
  project_id        NUMBER(10),
  semester_id       NUMBER(10) not null
)
;
comment on table T_ELECTION_PROFILES
  is '选课参数';
comment on column T_ELECTION_PROFILES.id
  is '非业务主键';
comment on column T_ELECTION_PROFILES.created_at
  is '创建时间';
comment on column T_ELECTION_PROFILES.updated_at
  is '更新时间';
comment on column T_ELECTION_PROFILES.begin_at
  is '开始时间';
comment on column T_ELECTION_PROFILES.elect_begin_at
  is '选课开始时间';
comment on column T_ELECTION_PROFILES.elect_end_at
  is '选课结束时间';
comment on column T_ELECTION_PROFILES.end_at
  is '结束时间';
comment on column T_ELECTION_PROFILES.name
  is '名称';
comment on column T_ELECTION_PROFILES.notice
  is '注意事项';
comment on column T_ELECTION_PROFILES.open_election
  is '选课是否开放';
comment on column T_ELECTION_PROFILES.open_withdraw
  is '退课是否开放';
comment on column T_ELECTION_PROFILES.profile_type
  is '参数类型';
comment on column T_ELECTION_PROFILES.turn
  is '选课轮次';
comment on column T_ELECTION_PROFILES.withdraw_begin_at
  is '退课开始时间';
comment on column T_ELECTION_PROFILES.withdraw_end_at
  is '退课结束时间';
comment on column T_ELECTION_PROFILES.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column T_ELECTION_PROFILES.semester_id
  is '教学日历 ID ###引用表名是C_SEMESTERS### ';
alter table T_ELECTION_PROFILES
  add primary key (ID);
alter table T_ELECTION_PROFILES
  add constraint FK_ELSXOWFE7JXYVHWXOOYL9CSLU foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_ELECTION_PROFILES
  add constraint FK_PSKG6P52SQJ7ONW0Y88U9EA4A foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating T_ELECTION_PROFILES_DEPARTS...
create table T_ELECTION_PROFILES_DEPARTS
(
  election_profile_id NUMBER(19) not null,
  depart_id           NUMBER(10) not null
)
;
comment on table T_ELECTION_PROFILES_DEPARTS
  is '选课参数-参数内允许选课的学生所在院系';
comment on column T_ELECTION_PROFILES_DEPARTS.election_profile_id
  is '选课参数 ID ###引用表名是T_ELECTION_PROFILES### ';
alter table T_ELECTION_PROFILES_DEPARTS
  add primary key (ELECTION_PROFILE_ID, DEPART_ID);
alter table T_ELECTION_PROFILES_DEPARTS
  add constraint FK_P0UOPUSYI0YX930EH68BM3UYK foreign key (ELECTION_PROFILE_ID)
  references T_ELECTION_PROFILES (ID);

prompt Creating T_ELECTION_PROFILES_DIRECTIONS...
create table T_ELECTION_PROFILES_DIRECTIONS
(
  election_profile_id NUMBER(19) not null,
  direction_id        NUMBER(10) not null
)
;
comment on table T_ELECTION_PROFILES_DIRECTIONS
  is '选课参数-参数允许的方向';
comment on column T_ELECTION_PROFILES_DIRECTIONS.election_profile_id
  is '选课参数 ID ###引用表名是T_ELECTION_PROFILES### ';
alter table T_ELECTION_PROFILES_DIRECTIONS
  add primary key (ELECTION_PROFILE_ID, DIRECTION_ID);
alter table T_ELECTION_PROFILES_DIRECTIONS
  add constraint FK_CKD9U8JUNA4Y0VXPKJ5GMBC1C foreign key (ELECTION_PROFILE_ID)
  references T_ELECTION_PROFILES (ID);

prompt Creating T_ELECTION_PROFILES_GRADES...
create table T_ELECTION_PROFILES_GRADES
(
  election_profile_id NUMBER(19) not null,
  grade               VARCHAR2(255 CHAR) not null
)
;
comment on table T_ELECTION_PROFILES_GRADES
  is '选课参数-参数内允许选课的年级';
comment on column T_ELECTION_PROFILES_GRADES.election_profile_id
  is '选课参数 ID ###引用表名是T_ELECTION_PROFILES### ';
alter table T_ELECTION_PROFILES_GRADES
  add primary key (ELECTION_PROFILE_ID, GRADE);
alter table T_ELECTION_PROFILES_GRADES
  add constraint FK_A3L5SKF7O47PN29PV391MRI99 foreign key (ELECTION_PROFILE_ID)
  references T_ELECTION_PROFILES (ID);

prompt Creating T_ELECTION_PROFILES_MAJORS...
create table T_ELECTION_PROFILES_MAJORS
(
  election_profile_id NUMBER(19) not null,
  major_id            NUMBER(10) not null
)
;
comment on table T_ELECTION_PROFILES_MAJORS
  is '选课参数-参数允许的专业';
comment on column T_ELECTION_PROFILES_MAJORS.election_profile_id
  is '选课参数 ID ###引用表名是T_ELECTION_PROFILES### ';
alter table T_ELECTION_PROFILES_MAJORS
  add primary key (ELECTION_PROFILE_ID, MAJOR_ID);
alter table T_ELECTION_PROFILES_MAJORS
  add constraint FK_OCFRWPSYEFDFNH002MA97VKD6 foreign key (ELECTION_PROFILE_ID)
  references T_ELECTION_PROFILES (ID);

prompt Creating T_ELECTION_PROFILES_STDS...
create table T_ELECTION_PROFILES_STDS
(
  election_profile_id NUMBER(19) not null,
  std_id              NUMBER(19) not null
)
;
comment on table T_ELECTION_PROFILES_STDS
  is '选课参数-参数内允许的特殊学生';
comment on column T_ELECTION_PROFILES_STDS.election_profile_id
  is '选课参数 ID ###引用表名是T_ELECTION_PROFILES### ';
alter table T_ELECTION_PROFILES_STDS
  add primary key (ELECTION_PROFILE_ID, STD_ID);
alter table T_ELECTION_PROFILES_STDS
  add constraint FK_S3CYFCB4JU3POELYXK6J7RR94 foreign key (ELECTION_PROFILE_ID)
  references T_ELECTION_PROFILES (ID);

prompt Creating T_ELECTION_PROFILES_STD_TYPES...
create table T_ELECTION_PROFILES_STD_TYPES
(
  election_profile_id NUMBER(19) not null,
  std_type_id         NUMBER(10) not null
)
;
comment on table T_ELECTION_PROFILES_STD_TYPES
  is '选课参数-参数内允许选课的学生类别';
comment on column T_ELECTION_PROFILES_STD_TYPES.election_profile_id
  is '选课参数 ID ###引用表名是T_ELECTION_PROFILES### ';
alter table T_ELECTION_PROFILES_STD_TYPES
  add primary key (ELECTION_PROFILE_ID, STD_TYPE_ID);
alter table T_ELECTION_PROFILES_STD_TYPES
  add constraint FK_D2YU0B250QXTVLBRU9NAVT2A5 foreign key (ELECTION_PROFILE_ID)
  references T_ELECTION_PROFILES (ID);

prompt Creating T_ELECT_LOGGERS...
create table T_ELECT_LOGGERS
(
  id                  NUMBER(19) not null,
  created_at          TIMESTAMP(6),
  updated_at          TIMESTAMP(6),
  course_code         VARCHAR2(255 CHAR) not null,
  course_name         VARCHAR2(255 CHAR) not null,
  course_type         VARCHAR2(255 CHAR) not null,
  credits             FLOAT not null,
  ip_address          VARCHAR2(255 CHAR) not null,
  lesson_no           VARCHAR2(255 CHAR) not null,
  operator_code       VARCHAR2(255 CHAR) not null,
  operator_name       VARCHAR2(255 CHAR) not null,
  std_code            VARCHAR2(255 CHAR) not null,
  std_name            VARCHAR2(255 CHAR) not null,
  turn                NUMBER(10),
  type                NUMBER(10) not null,
  course_take_type_id NUMBER(10) not null,
  election_mode_id    NUMBER(10) not null,
  project_id          NUMBER(10) not null,
  semester_id         NUMBER(10) not null
)
;
comment on table T_ELECT_LOGGERS
  is '选课日志';
comment on column T_ELECT_LOGGERS.id
  is '非业务主键';
comment on column T_ELECT_LOGGERS.created_at
  is '创建时间';
comment on column T_ELECT_LOGGERS.updated_at
  is '更新时间';
comment on column T_ELECT_LOGGERS.course_code
  is '课程代码';
comment on column T_ELECT_LOGGERS.course_name
  is '课程名称';
comment on column T_ELECT_LOGGERS.course_type
  is '课程类型';
comment on column T_ELECT_LOGGERS.credits
  is '学分';
comment on column T_ELECT_LOGGERS.ip_address
  is 'IP';
comment on column T_ELECT_LOGGERS.lesson_no
  is '课程序号';
comment on column T_ELECT_LOGGERS.operator_code
  is '操作者工号';
comment on column T_ELECT_LOGGERS.operator_name
  is '操作者姓名';
comment on column T_ELECT_LOGGERS.std_code
  is '学号';
comment on column T_ELECT_LOGGERS.std_name
  is '姓名';
comment on column T_ELECT_LOGGERS.turn
  is '轮次';
comment on column T_ELECT_LOGGERS.type
  is '类型';
comment on column T_ELECT_LOGGERS.course_take_type_id
  is '修读类别 ID ###引用表名是HB_COURSE_TAKE_TYPES### ';
comment on column T_ELECT_LOGGERS.election_mode_id
  is '选课方式 ID ###引用表名是HB_ELECTION_MODES### ';
comment on column T_ELECT_LOGGERS.project_id
  is '教学项目 ID ###引用表名是C_PROJECTS### ';
comment on column T_ELECT_LOGGERS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
alter table T_ELECT_LOGGERS
  add primary key (ID);
alter table T_ELECT_LOGGERS
  add constraint FK_AD0E2PWHURN8OA3968U6LFFE9 foreign key (ELECTION_MODE_ID)
  references HB_ELECTION_MODES (ID);
alter table T_ELECT_LOGGERS
  add constraint FK_D3068VOQR5HCE09X1LNY9X58E foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_ELECT_LOGGERS
  add constraint FK_N4X2U7O5PKCIUKSDDM28CXS1R foreign key (COURSE_TAKE_TYPE_ID)
  references HB_COURSE_TAKE_TYPES (ID);
alter table T_ELECT_LOGGERS
  add constraint FK_RCPUM31C1G6VE7HC0APM53FNP foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating T_ELECT_MAIL_TEMPLATES...
create table T_ELECT_MAIL_TEMPLATES
(
  id      NUMBER(19) not null,
  content VARCHAR2(255 CHAR) not null,
  title   VARCHAR2(255 CHAR) not null
)
;
comment on table T_ELECT_MAIL_TEMPLATES
  is '邮件模版';
comment on column T_ELECT_MAIL_TEMPLATES.id
  is '非业务主键';
comment on column T_ELECT_MAIL_TEMPLATES.content
  is '内容';
comment on column T_ELECT_MAIL_TEMPLATES.title
  is '主题';
alter table T_ELECT_MAIL_TEMPLATES
  add primary key (ID);

prompt Creating T_ELECT_PLANS...
create table T_ELECT_PLANS
(
  id          NUMBER(19) not null,
  created_at  TIMESTAMP(6),
  updated_at  TIMESTAMP(6),
  description VARCHAR2(255 CHAR),
  name        VARCHAR2(255 CHAR) not null
)
;
comment on table T_ELECT_PLANS
  is '选课方案';
comment on column T_ELECT_PLANS.id
  is '非业务主键';
comment on column T_ELECT_PLANS.created_at
  is '创建时间';
comment on column T_ELECT_PLANS.updated_at
  is '更新时间';
comment on column T_ELECT_PLANS.description
  is '描述';
comment on column T_ELECT_PLANS.name
  is '名称';
alter table T_ELECT_PLANS
  add primary key (ID);

prompt Creating T_ELECT_PLANS_RULE_CONFIGS...
create table T_ELECT_PLANS_RULE_CONFIGS
(
  elect_plan_id  NUMBER(19) not null,
  rule_config_id NUMBER(10) not null
)
;
comment on table T_ELECT_PLANS_RULE_CONFIGS
  is '选课方案-规则列表';
comment on column T_ELECT_PLANS_RULE_CONFIGS.elect_plan_id
  is '选课方案 ID ###引用表名是T_ELECT_PLANS### ';
comment on column T_ELECT_PLANS_RULE_CONFIGS.rule_config_id
  is '规则配置 ID ###引用表名是SYS_RULE_CONFIGS### ';
alter table T_ELECT_PLANS_RULE_CONFIGS
  add primary key (ELECT_PLAN_ID, RULE_CONFIG_ID);
alter table T_ELECT_PLANS_RULE_CONFIGS
  add constraint FK_FQ8TNL70RG5WQJ9IR266VJVWX foreign key (RULE_CONFIG_ID)
  references SYS_RULE_CONFIGS (ID);
alter table T_ELECT_PLANS_RULE_CONFIGS
  add constraint FK_MFW983HCTQDYHKJGKQXYWNT4Y foreign key (ELECT_PLAN_ID)
  references T_ELECT_PLANS (ID);

prompt Creating T_ELECT_PROFIES_ELECT_CFGS...
create table T_ELECT_PROFIES_ELECT_CFGS
(
  election_profile_id NUMBER(19) not null,
  rule_config_id      NUMBER(10) not null
)
;
comment on table T_ELECT_PROFIES_ELECT_CFGS
  is '选课参数-选课规则';
comment on column T_ELECT_PROFIES_ELECT_CFGS.election_profile_id
  is '选课参数 ID ###引用表名是T_ELECTION_PROFILES### ';
comment on column T_ELECT_PROFIES_ELECT_CFGS.rule_config_id
  is '规则配置 ID ###引用表名是SYS_RULE_CONFIGS### ';
alter table T_ELECT_PROFIES_ELECT_CFGS
  add primary key (ELECTION_PROFILE_ID, RULE_CONFIG_ID);
alter table T_ELECT_PROFIES_ELECT_CFGS
  add constraint FK_6KPP21OQW0W78UKSG7NBA8PYK foreign key (ELECTION_PROFILE_ID)
  references T_ELECTION_PROFILES (ID);
alter table T_ELECT_PROFIES_ELECT_CFGS
  add constraint FK_PXPOW7MNY1AAG6CJ6P3MKQE4C foreign key (RULE_CONFIG_ID)
  references SYS_RULE_CONFIGS (ID);

prompt Creating T_ELECT_PROFIES_ELECT_LESSONS...
create table T_ELECT_PROFIES_ELECT_LESSONS
(
  election_profile_id NUMBER(19) not null,
  lesson_id           NUMBER(19) not null
)
;
comment on table T_ELECT_PROFIES_ELECT_LESSONS
  is '选课参数-开放选课的教学任务';
comment on column T_ELECT_PROFIES_ELECT_LESSONS.election_profile_id
  is '选课参数 ID ###引用表名是T_ELECTION_PROFILES### ';
alter table T_ELECT_PROFIES_ELECT_LESSONS
  add primary key (ELECTION_PROFILE_ID, LESSON_ID);
alter table T_ELECT_PROFIES_ELECT_LESSONS
  add constraint FK_G1GFDT9FL1SA8OAP02L8TT7CD foreign key (ELECTION_PROFILE_ID)
  references T_ELECTION_PROFILES (ID);

prompt Creating T_ELECT_PROFIES_GENERAL_CFGS...
create table T_ELECT_PROFIES_GENERAL_CFGS
(
  election_profile_id NUMBER(19) not null,
  rule_config_id      NUMBER(10) not null
)
;
comment on table T_ELECT_PROFIES_GENERAL_CFGS
  is '选课参数-全局规则';
comment on column T_ELECT_PROFIES_GENERAL_CFGS.election_profile_id
  is '选课参数 ID ###引用表名是T_ELECTION_PROFILES### ';
comment on column T_ELECT_PROFIES_GENERAL_CFGS.rule_config_id
  is '规则配置 ID ###引用表名是SYS_RULE_CONFIGS### ';
alter table T_ELECT_PROFIES_GENERAL_CFGS
  add primary key (ELECTION_PROFILE_ID, RULE_CONFIG_ID);
alter table T_ELECT_PROFIES_GENERAL_CFGS
  add constraint FK_KVVYC1587EXKBSSAEDQM6RV30 foreign key (RULE_CONFIG_ID)
  references SYS_RULE_CONFIGS (ID);
alter table T_ELECT_PROFIES_GENERAL_CFGS
  add constraint FK_LUXIV04WWIX4NFEPGDCCKFL34 foreign key (ELECTION_PROFILE_ID)
  references T_ELECTION_PROFILES (ID);

prompt Creating T_ELECT_PROFIES_WD_LESSONS...
create table T_ELECT_PROFIES_WD_LESSONS
(
  election_profile_id NUMBER(19) not null,
  lesson_id           NUMBER(19) not null
)
;
comment on table T_ELECT_PROFIES_WD_LESSONS
  is '选课参数-开放退课的教学任务';
comment on column T_ELECT_PROFIES_WD_LESSONS.election_profile_id
  is '选课参数 ID ###引用表名是T_ELECTION_PROFILES### ';
alter table T_ELECT_PROFIES_WD_LESSONS
  add primary key (ELECTION_PROFILE_ID, LESSON_ID);
alter table T_ELECT_PROFIES_WD_LESSONS
  add constraint FK_78P5OUI2P1TUQVJX8GDN9W4A8 foreign key (ELECTION_PROFILE_ID)
  references T_ELECTION_PROFILES (ID);

prompt Creating T_ELECT_PROFIES_WITHDRAW_CFGS...
create table T_ELECT_PROFIES_WITHDRAW_CFGS
(
  election_profile_id NUMBER(19) not null,
  rule_config_id      NUMBER(10) not null
)
;
comment on table T_ELECT_PROFIES_WITHDRAW_CFGS
  is '选课参数-退课规则';
comment on column T_ELECT_PROFIES_WITHDRAW_CFGS.election_profile_id
  is '选课参数 ID ###引用表名是T_ELECTION_PROFILES### ';
comment on column T_ELECT_PROFIES_WITHDRAW_CFGS.rule_config_id
  is '规则配置 ID ###引用表名是SYS_RULE_CONFIGS### ';
alter table T_ELECT_PROFIES_WITHDRAW_CFGS
  add primary key (ELECTION_PROFILE_ID, RULE_CONFIG_ID);
alter table T_ELECT_PROFIES_WITHDRAW_CFGS
  add constraint FK_3BLWG75HGFJ1KF0LPS3MUBMOR foreign key (RULE_CONFIG_ID)
  references SYS_RULE_CONFIGS (ID);
alter table T_ELECT_PROFIES_WITHDRAW_CFGS
  add constraint FK_GF4CFTDSTGT05PSOC417T1JFA foreign key (ELECTION_PROFILE_ID)
  references T_ELECTION_PROFILES (ID);

prompt Creating T_ELECT_PROFILES_EDUCATIONS...
create table T_ELECT_PROFILES_EDUCATIONS
(
  election_profile_id NUMBER(19) not null,
  education_id        NUMBER(10) not null
)
;
comment on table T_ELECT_PROFILES_EDUCATIONS
  is '选课参数-参数内允许选课的培养类型';
comment on column T_ELECT_PROFILES_EDUCATIONS.election_profile_id
  is '选课参数 ID ###引用表名是T_ELECTION_PROFILES### ';
alter table T_ELECT_PROFILES_EDUCATIONS
  add primary key (ELECTION_PROFILE_ID, EDUCATION_ID);
alter table T_ELECT_PROFILES_EDUCATIONS
  add constraint FK_F36YWGP2P2FYDPH45W8W6FTNJ foreign key (ELECTION_PROFILE_ID)
  references T_ELECTION_PROFILES (ID);

prompt Creating T_ELECT_PROFILES_PROJECTS...
create table T_ELECT_PROFILES_PROJECTS
(
  election_profile_id NUMBER(19) not null,
  project_id          NUMBER(10) not null
)
;
comment on table T_ELECT_PROFILES_PROJECTS
  is '选课参数-批次适用于哪些教学项目下的学生';
comment on column T_ELECT_PROFILES_PROJECTS.election_profile_id
  is '选课参数 ID ###引用表名是T_ELECTION_PROFILES### ';
comment on column T_ELECT_PROFILES_PROJECTS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
alter table T_ELECT_PROFILES_PROJECTS
  add primary key (ELECTION_PROFILE_ID, PROJECT_ID);
alter table T_ELECT_PROFILES_PROJECTS
  add constraint UK_LQLMTBIS9FEWEU4J05OLX8K8B unique (PROJECT_ID);
alter table T_ELECT_PROFILES_PROJECTS
  add constraint FK_LQLMTBIS9FEWEU4J05OLX8K8B foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table T_ELECT_PROFILES_PROJECTS
  add constraint FK_TP6P4M51HB1W22E9JXMLEA62P foreign key (ELECTION_PROFILE_ID)
  references T_ELECTION_PROFILES (ID);

prompt Creating T_EXAM_ACTIVITIES...
create table T_EXAM_ACTIVITIES
(
  id           NUMBER(19) not null,
  end_at       TIMESTAMP(6),
  remark       VARCHAR2(255 CHAR),
  start_at     TIMESTAMP(6),
  state        NUMBER(10) not null,
  exam_type_id NUMBER(10) not null,
  lesson_id    NUMBER(19) not null,
  semester_id  NUMBER(10) not null
)
;
comment on table T_EXAM_ACTIVITIES
  is '排考活动';
comment on column T_EXAM_ACTIVITIES.id
  is '非业务主键';
comment on column T_EXAM_ACTIVITIES.end_at
  is '结束时间';
comment on column T_EXAM_ACTIVITIES.remark
  is '备注';
comment on column T_EXAM_ACTIVITIES.start_at
  is '开始时间';
comment on column T_EXAM_ACTIVITIES.state
  is '审核状态';
comment on column T_EXAM_ACTIVITIES.exam_type_id
  is '考试类型 ID ###引用表名是HB_EXAM_TYPES### ';
comment on column T_EXAM_ACTIVITIES.lesson_id
  is '教学任务 ID ###引用表名是T_LESSONS### ';
comment on column T_EXAM_ACTIVITIES.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
alter table T_EXAM_ACTIVITIES
  add primary key (ID);
alter table T_EXAM_ACTIVITIES
  add constraint UK_7FDILTE8LIIAF57VX28FSOHRQ unique (EXAM_TYPE_ID, LESSON_ID);
alter table T_EXAM_ACTIVITIES
  add constraint FK_7BT5GP2HTB4SWCK2U0AKHVQAN foreign key (EXAM_TYPE_ID)
  references HB_EXAM_TYPES (ID);
alter table T_EXAM_ACTIVITIES
  add constraint FK_B66E9F714EC540H0MR7T1AMGE foreign key (LESSON_ID)
  references T_LESSONS (ID);
alter table T_EXAM_ACTIVITIES
  add constraint FK_QGXU9TI23DS0W1XPPETNO8SQG foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);

prompt Creating T_EXAM_ROOMS...
create table T_EXAM_ROOMS
(
  id            NUMBER(19) not null,
  end_at        TIMESTAMP(6),
  room_apply_id NUMBER(19),
  start_at      TIMESTAMP(6),
  department_id NUMBER(10),
  examiner_id   NUMBER(19),
  room_id       NUMBER(10) not null,
  semester_id   NUMBER(10) not null
)
;
comment on table T_EXAM_ROOMS
  is '考场';
comment on column T_EXAM_ROOMS.id
  is '非业务主键';
comment on column T_EXAM_ROOMS.end_at
  is '结束时间';
comment on column T_EXAM_ROOMS.room_apply_id
  is '教室申请流水号';
comment on column T_EXAM_ROOMS.start_at
  is '开始时间';
comment on column T_EXAM_ROOMS.department_id
  is '主考教师院系 ID ###引用表名是C_DEPARTMENTS### ';
comment on column T_EXAM_ROOMS.examiner_id
  is '主考教师 ID ###引用表名是C_TEACHERS### ';
comment on column T_EXAM_ROOMS.room_id
  is '教室 ID ###引用表名是C_CLASSROOMS### ';
comment on column T_EXAM_ROOMS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
alter table T_EXAM_ROOMS
  add primary key (ID);
alter table T_EXAM_ROOMS
  add constraint FK_1MM0WCO0H1TEDSUJ3B2KBJXQ foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table T_EXAM_ROOMS
  add constraint FK_B4N9F375XAIN079XRVWCTB7P2 foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_EXAM_ROOMS
  add constraint FK_BJV0CTOP2GVKIMK3L5I0YAW4Q foreign key (EXAMINER_ID)
  references C_TEACHERS (ID);
alter table T_EXAM_ROOMS
  add constraint FK_P4YA584DGFCA9PXIF8GGGDVI2 foreign key (ROOM_ID)
  references C_CLASSROOMS (ID);

prompt Creating T_EXAM_ACTIVITIES_EXAM_ROOMS...
create table T_EXAM_ACTIVITIES_EXAM_ROOMS
(
  exam_activity_id NUMBER(19) not null,
  exam_room_id     NUMBER(19) not null
)
;
comment on table T_EXAM_ACTIVITIES_EXAM_ROOMS
  is '考场-考试活动';
comment on column T_EXAM_ACTIVITIES_EXAM_ROOMS.exam_activity_id
  is '排考活动 ID ###引用表名是T_EXAM_ACTIVITIES### ';
comment on column T_EXAM_ACTIVITIES_EXAM_ROOMS.exam_room_id
  is '考场 ID ###引用表名是T_EXAM_ROOMS### ';
alter table T_EXAM_ACTIVITIES_EXAM_ROOMS
  add primary key (EXAM_ACTIVITY_ID, EXAM_ROOM_ID);
alter table T_EXAM_ACTIVITIES_EXAM_ROOMS
  add constraint FK_JENCO3CE80NVGBVB55TNFVO26 foreign key (EXAM_ROOM_ID)
  references T_EXAM_ROOMS (ID);
alter table T_EXAM_ACTIVITIES_EXAM_ROOMS
  add constraint FK_TQCMVCFX9FNMOEVWMQBKW7IS4 foreign key (EXAM_ACTIVITY_ID)
  references T_EXAM_ACTIVITIES (ID);

prompt Creating T_EXAM_TAKES...
create table T_EXAM_TAKES
(
  id             NUMBER(19) not null,
  remark         VARCHAR2(255 CHAR),
  exam_room_id   NUMBER(19),
  exam_status_id NUMBER(10) not null,
  exam_type_id   NUMBER(10) not null,
  lesson_id      NUMBER(19) not null,
  semester_id    NUMBER(10) not null,
  std_id         NUMBER(19) not null
)
;
comment on table T_EXAM_TAKES
  is '应考记录';
comment on column T_EXAM_TAKES.id
  is '非业务主键';
comment on column T_EXAM_TAKES.remark
  is '缓考申请原因/记录处分';
comment on column T_EXAM_TAKES.exam_room_id
  is '考场 ID ###引用表名是T_EXAM_ROOMS### ';
comment on column T_EXAM_TAKES.exam_status_id
  is '考试情况 ID ###引用表名是HB_EXAM_STATUSES### ';
comment on column T_EXAM_TAKES.exam_type_id
  is '考试类型 ID ###引用表名是HB_EXAM_TYPES### ';
comment on column T_EXAM_TAKES.lesson_id
  is '教学任务 ID ###引用表名是T_LESSONS### ';
comment on column T_EXAM_TAKES.semester_id
  is '教学日历 ID ###引用表名是C_SEMESTERS### ';
comment on column T_EXAM_TAKES.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table T_EXAM_TAKES
  add primary key (ID);
alter table T_EXAM_TAKES
  add constraint UK_5G8QT52KH3DKGAYX7Q1B7IPCR unique (EXAM_TYPE_ID, LESSON_ID, STD_ID);
alter table T_EXAM_TAKES
  add constraint FK_4EEFR232VAYJDLJ4IOD1MXWE foreign key (EXAM_STATUS_ID)
  references HB_EXAM_STATUSES (ID);
alter table T_EXAM_TAKES
  add constraint FK_BWUVYT0NW30TWGN58YVAHXCXW foreign key (EXAM_TYPE_ID)
  references HB_EXAM_TYPES (ID);
alter table T_EXAM_TAKES
  add constraint FK_EEDTYSI0305M0BYP66U0KUS2A foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table T_EXAM_TAKES
  add constraint FK_GT7SSJ9NVO40LD7O35LC7JL4O foreign key (LESSON_ID)
  references T_LESSONS (ID);
alter table T_EXAM_TAKES
  add constraint FK_LJTRVCDG3SCGIN6AI132U5CGJ foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_EXAM_TAKES
  add constraint FK_QJN6FM41TNLPCU68AXUJ7FE1O foreign key (EXAM_ROOM_ID)
  references T_EXAM_ROOMS (ID);

prompt Creating T_EXAM_APPLIES...
create table T_EXAM_APPLIES
(
  id              NUMBER(19) not null,
  apply_at        TIMESTAMP(6) not null,
  exam_apply_type VARCHAR2(255 CHAR) not null,
  passed          NUMBER(1),
  remark          VARCHAR2(255 CHAR),
  exam_take_id    NUMBER(19) not null
)
;
comment on table T_EXAM_APPLIES
  is '补缓考申请信息';
comment on column T_EXAM_APPLIES.id
  is '非业务主键';
comment on column T_EXAM_APPLIES.apply_at
  is '申请时间';
comment on column T_EXAM_APPLIES.exam_apply_type
  is '申请类型';
comment on column T_EXAM_APPLIES.passed
  is '是否通过';
comment on column T_EXAM_APPLIES.remark
  is '申请原因';
comment on column T_EXAM_APPLIES.exam_take_id
  is '考生记录 ID ###引用表名是T_EXAM_TAKES### ';
alter table T_EXAM_APPLIES
  add primary key (ID);
alter table T_EXAM_APPLIES
  add constraint FK_46BMYS7A0X30759TP9YBGSIC2 foreign key (EXAM_TAKE_ID)
  references T_EXAM_TAKES (ID);

prompt Creating T_EXAM_APPLY_PARAM...
create table T_EXAM_APPLY_PARAM
(
  id               NUMBER(19) not null,
  finish_date      TIMESTAMP(6),
  is_open_election NUMBER(1),
  notice           VARCHAR2(255 CHAR),
  start_date       TIMESTAMP(6),
  project_id       NUMBER(10),
  semester_id      NUMBER(10)
)
;
comment on table T_EXAM_APPLY_PARAM
  is '补考申请开关';
comment on column T_EXAM_APPLY_PARAM.id
  is '非业务主键';
comment on column T_EXAM_APPLY_PARAM.finish_date
  is '结束日期';
comment on column T_EXAM_APPLY_PARAM.is_open_election
  is '是否打开开关';
comment on column T_EXAM_APPLY_PARAM.notice
  is '注意事项';
comment on column T_EXAM_APPLY_PARAM.start_date
  is '开始日期';
comment on column T_EXAM_APPLY_PARAM.project_id
  is '教学项目 ID ###引用表名是C_PROJECTS### ';
comment on column T_EXAM_APPLY_PARAM.semester_id
  is '教学日历 ID ###引用表名是C_SEMESTERS### ';
alter table T_EXAM_APPLY_PARAM
  add primary key (ID);
alter table T_EXAM_APPLY_PARAM
  add constraint FK_1083T5DOB3UMMVPIQPEOUSEVH foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table T_EXAM_APPLY_PARAM
  add constraint FK_O8N69LG5TOKAK0RY8QTRQQGXA foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);

prompt Creating T_EXAM_APPLY_SWITCHES...
create table T_EXAM_APPLY_SWITCHES
(
  id              NUMBER(19) not null,
  close_at        TIMESTAMP(6),
  enabled         NUMBER(1) not null,
  exam_apply_type VARCHAR2(255 CHAR) not null,
  open_at         TIMESTAMP(6),
  project_id      NUMBER(10) not null,
  semester_id     NUMBER(10) not null
)
;
comment on table T_EXAM_APPLY_SWITCHES
  is '补缓考申请开关';
comment on column T_EXAM_APPLY_SWITCHES.id
  is '非业务主键';
comment on column T_EXAM_APPLY_SWITCHES.close_at
  is '结束时间';
comment on column T_EXAM_APPLY_SWITCHES.enabled
  is '是否启用';
comment on column T_EXAM_APPLY_SWITCHES.exam_apply_type
  is '申请类型';
comment on column T_EXAM_APPLY_SWITCHES.open_at
  is '开始时间';
comment on column T_EXAM_APPLY_SWITCHES.project_id
  is '教学项目 ID ###引用表名是C_PROJECTS### ';
comment on column T_EXAM_APPLY_SWITCHES.semester_id
  is '教学日历 ID ###引用表名是C_SEMESTERS### ';
alter table T_EXAM_APPLY_SWITCHES
  add primary key (ID);
alter table T_EXAM_APPLY_SWITCHES
  add constraint FK_9D5PXH6ULO5IIA1W8XMDCXNIG foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_EXAM_APPLY_SWITCHES
  add constraint FK_FO2DHTJ5FRTLH5STYYY6X9R5 foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating T_EXAM_GRADES...
create table T_EXAM_GRADES
(
  id              NUMBER(19) not null,
  created_at      TIMESTAMP(6),
  updated_at      TIMESTAMP(6),
  operator        VARCHAR2(50 CHAR),
  passed          NUMBER(1) not null,
  percent         NUMBER(10),
  score           FLOAT,
  score_text      VARCHAR2(255 CHAR),
  status          NUMBER(10) not null,
  course_grade_id NUMBER(19) not null,
  exam_status_id  NUMBER(10) not null,
  grade_type_id   NUMBER(10) not null,
  mark_style_id   NUMBER(10) not null
)
;
comment on table T_EXAM_GRADES
  is '考试成绩';
comment on column T_EXAM_GRADES.id
  is '非业务主键';
comment on column T_EXAM_GRADES.created_at
  is '创建时间';
comment on column T_EXAM_GRADES.updated_at
  is '更新时间';
comment on column T_EXAM_GRADES.operator
  is '操作者';
comment on column T_EXAM_GRADES.passed
  is '是否通过';
comment on column T_EXAM_GRADES.percent
  is '百分比描述';
comment on column T_EXAM_GRADES.score
  is '得分';
comment on column T_EXAM_GRADES.score_text
  is '得分字面值';
comment on column T_EXAM_GRADES.status
  is '成绩状态';
comment on column T_EXAM_GRADES.course_grade_id
  is '对应的课程成绩 ID ###引用表名是T_COURSE_GRADES### ';
comment on column T_EXAM_GRADES.exam_status_id
  is '考试情况 ID ###引用表名是HB_EXAM_STATUSES### ';
comment on column T_EXAM_GRADES.grade_type_id
  is '成绩类型 ID ###引用表名是HB_GRADE_TYPES### ';
comment on column T_EXAM_GRADES.mark_style_id
  is '成绩记录方式 ID ###引用表名是HB_SCORE_MARK_STYLES### ';
alter table T_EXAM_GRADES
  add primary key (ID);
alter table T_EXAM_GRADES
  add constraint UK_L7V4WEHOX3AXAJ6H5TXUBESC8 unique (COURSE_GRADE_ID, GRADE_TYPE_ID);
alter table T_EXAM_GRADES
  add constraint FK_4TQVYOJ4YN2DI17TBJC5MYQ1H foreign key (MARK_STYLE_ID)
  references HB_SCORE_MARK_STYLES (ID);
alter table T_EXAM_GRADES
  add constraint FK_ADD854VRVDTYL6UCBMLNTMYNJ foreign key (GRADE_TYPE_ID)
  references HB_GRADE_TYPES (ID);
alter table T_EXAM_GRADES
  add constraint FK_FMWYK8XH4YSKU7OCXB227J9XM foreign key (COURSE_GRADE_ID)
  references T_COURSE_GRADES (ID);
alter table T_EXAM_GRADES
  add constraint FK_PMC9SNNB900VIJWM1WL4WMAQV foreign key (EXAM_STATUS_ID)
  references HB_EXAM_STATUSES (ID);

prompt Creating T_EXAM_GRADE_STATES...
create table T_EXAM_GRADE_STATES
(
  id                  NUMBER(19) not null,
  inputed_at          TIMESTAMP(6),
  operator            VARCHAR2(50 CHAR),
  precision           NUMBER(10) not null,
  status              NUMBER(10) not null,
  percent             FLOAT,
  remark              VARCHAR2(255 CHAR),
  score_mark_style_id NUMBER(10) not null,
  grade_state_id      NUMBER(19) not null,
  grade_type_id       NUMBER(10) not null
)
;
comment on table T_EXAM_GRADE_STATES
  is '考试成绩状态';
comment on column T_EXAM_GRADE_STATES.id
  is '非业务主键';
comment on column T_EXAM_GRADE_STATES.inputed_at
  is '上次成绩录入时间';
comment on column T_EXAM_GRADE_STATES.operator
  is '操作者';
comment on column T_EXAM_GRADE_STATES.precision
  is '小数点后保留几位';
comment on column T_EXAM_GRADE_STATES.status
  is '成绩录入状态';
comment on column T_EXAM_GRADE_STATES.percent
  is '百分比描述';
comment on column T_EXAM_GRADE_STATES.remark
  is '备注';
comment on column T_EXAM_GRADE_STATES.score_mark_style_id
  is '成绩记录方式 ID ###引用表名是HB_SCORE_MARK_STYLES### ';
comment on column T_EXAM_GRADE_STATES.grade_state_id
  is '总成绩状态 ID ###引用表名是T_COURSE_GRADE_STATES### ';
comment on column T_EXAM_GRADE_STATES.grade_type_id
  is '成绩类型 ID ###引用表名是HB_GRADE_TYPES### ';
alter table T_EXAM_GRADE_STATES
  add primary key (ID);
alter table T_EXAM_GRADE_STATES
  add constraint FK_95FUHMN5I6U99L29VT6CV3K7B foreign key (GRADE_STATE_ID)
  references T_COURSE_GRADE_STATES (ID);
alter table T_EXAM_GRADE_STATES
  add constraint FK_BTVTW2G23NN7N0OTU6B5YB50T foreign key (SCORE_MARK_STYLE_ID)
  references HB_SCORE_MARK_STYLES (ID);
alter table T_EXAM_GRADE_STATES
  add constraint FK_T1LAGLA3QPFNC2MV759ED2DQ0 foreign key (GRADE_TYPE_ID)
  references HB_GRADE_TYPES (ID);

prompt Creating T_EXAM_ROOM_PROGRAMS...
create table T_EXAM_ROOM_PROGRAMS
(
  id   NUMBER(19) not null,
  name VARCHAR2(255 CHAR) not null
)
;
comment on table T_EXAM_ROOM_PROGRAMS
  is '考务教室方案管理';
comment on column T_EXAM_ROOM_PROGRAMS.id
  is '非业务主键';
comment on column T_EXAM_ROOM_PROGRAMS.name
  is '方案名称';
alter table T_EXAM_ROOM_PROGRAMS
  add primary key (ID);

prompt Creating T_EXAM_TURN_SCHEMES...
create table T_EXAM_TURN_SCHEMES
(
  id           NUMBER(19) not null,
  name         VARCHAR2(100 CHAR) not null,
  exam_type_id NUMBER(10),
  project_id   NUMBER(10)
)
;
comment on table T_EXAM_TURN_SCHEMES
  is '场次组方案';
comment on column T_EXAM_TURN_SCHEMES.id
  is '非业务主键';
comment on column T_EXAM_TURN_SCHEMES.name
  is '场次组名称';
comment on column T_EXAM_TURN_SCHEMES.exam_type_id
  is '考试类型 ID ###引用表名是HB_EXAM_TYPES### ';
comment on column T_EXAM_TURN_SCHEMES.project_id
  is '教学项目 ID ###引用表名是C_PROJECTS### ';
alter table T_EXAM_TURN_SCHEMES
  add primary key (ID);
alter table T_EXAM_TURN_SCHEMES
  add constraint FK_732BPC17CB5QU1VRPYU0FKXLJ foreign key (EXAM_TYPE_ID)
  references HB_EXAM_TYPES (ID);
alter table T_EXAM_TURN_SCHEMES
  add constraint FK_K96EO9JRMS8KVN0XE48K928S0 foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating T_EXAM_GROUPS...
create table T_EXAM_GROUPS
(
  id              NUMBER(19) not null,
  end_date        TIMESTAMP(6),
  name            VARCHAR2(255 CHAR) not null,
  published       NUMBER(1) not null,
  start_date      TIMESTAMP(6),
  exam_type_id    NUMBER(10) not null,
  project_id      NUMBER(10) not null,
  room_program_id NUMBER(19),
  scheme_id       NUMBER(19),
  semester_id     NUMBER(10) not null
)
;
comment on table T_EXAM_GROUPS
  is '排考组';
comment on column T_EXAM_GROUPS.id
  is '非业务主键';
comment on column T_EXAM_GROUPS.end_date
  is '考试结束日期';
comment on column T_EXAM_GROUPS.name
  is '课程组名称';
comment on column T_EXAM_GROUPS.published
  is '排考结果是否发布';
comment on column T_EXAM_GROUPS.start_date
  is '考试开始日期';
comment on column T_EXAM_GROUPS.exam_type_id
  is '考试类别 ID ###引用表名是HB_EXAM_TYPES### ';
comment on column T_EXAM_GROUPS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column T_EXAM_GROUPS.room_program_id
  is '考试教室方案 ID ###引用表名是T_EXAM_ROOM_PROGRAMS### ';
comment on column T_EXAM_GROUPS.scheme_id
  is '场次组 ID ###引用表名是T_EXAM_TURN_SCHEMES### ';
comment on column T_EXAM_GROUPS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
alter table T_EXAM_GROUPS
  add primary key (ID);
alter table T_EXAM_GROUPS
  add constraint FK_1YL615ME49OO7GAK98JKXK4TW foreign key (SCHEME_ID)
  references T_EXAM_TURN_SCHEMES (ID);
alter table T_EXAM_GROUPS
  add constraint FK_5WV6JLQWO7YJIGWCBCT33V3EQ foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table T_EXAM_GROUPS
  add constraint FK_62HG2C326LYGTJQDFF06KPUBD foreign key (EXAM_TYPE_ID)
  references HB_EXAM_TYPES (ID);
alter table T_EXAM_GROUPS
  add constraint FK_7FFRJJNEOF6YARI3QA16UGYTY foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_EXAM_GROUPS
  add constraint FK_MP4GA0BD2ILFXJTNYJIFV1HWT foreign key (ROOM_PROGRAM_ID)
  references T_EXAM_ROOM_PROGRAMS (ID);

prompt Creating T_EXAM_GROUPS_LESSONS...
create table T_EXAM_GROUPS_LESSONS
(
  exam_group_id NUMBER(19) not null,
  lesson_id     NUMBER(19) not null
)
;
comment on table T_EXAM_GROUPS_LESSONS
  is '排考组-组内任务';
comment on column T_EXAM_GROUPS_LESSONS.exam_group_id
  is '排考组 ID ###引用表名是T_EXAM_GROUPS### ';
comment on column T_EXAM_GROUPS_LESSONS.lesson_id
  is '教学任务 ID ###引用表名是T_LESSONS### ';
alter table T_EXAM_GROUPS_LESSONS
  add primary key (EXAM_GROUP_ID, LESSON_ID);
alter table T_EXAM_GROUPS_LESSONS
  add constraint FK_7UNWA3081OG7REMV7UQFO281H foreign key (LESSON_ID)
  references T_LESSONS (ID);
alter table T_EXAM_GROUPS_LESSONS
  add constraint FK_GV4RCX7Q83BWQG6QFT6ODN1YK foreign key (EXAM_GROUP_ID)
  references T_EXAM_GROUPS (ID);

prompt Creating T_EXAM_MONITORS...
create table T_EXAM_MONITORS
(
  id            NUMBER(19) not null,
  teacher_name  VARCHAR2(255 CHAR),
  department_id NUMBER(10) not null,
  exam_room_id  NUMBER(19) not null,
  teacher_id    NUMBER(19)
)
;
comment on table T_EXAM_MONITORS
  is '监考信息';
comment on column T_EXAM_MONITORS.id
  is '非业务主键';
comment on column T_EXAM_MONITORS.teacher_name
  is '自定义监考';
comment on column T_EXAM_MONITORS.department_id
  is '监考院系 ID ###引用表名是C_DEPARTMENTS### ';
comment on column T_EXAM_MONITORS.exam_room_id
  is '排考活动 ID ###引用表名是T_EXAM_ROOMS### ';
comment on column T_EXAM_MONITORS.teacher_id
  is '监考老师 ID ###引用表名是C_TEACHERS### ';
alter table T_EXAM_MONITORS
  add primary key (ID);
alter table T_EXAM_MONITORS
  add constraint FK_1D4L1O29UV2UPLSSDVLKY392Y foreign key (EXAM_ROOM_ID)
  references T_EXAM_ROOMS (ID);
alter table T_EXAM_MONITORS
  add constraint FK_GYLQSVX9HHCUTY9JFLVK8UR4P foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table T_EXAM_MONITORS
  add constraint FK_JJGX1BUWSFXTROPRQ7AVBNY9M foreign key (TEACHER_ID)
  references C_TEACHERS (ID);

prompt Creating T_EXAM_PAPERS...
create table T_EXAM_PAPERS
(
  id           NUMBER(19) not null,
  code         VARCHAR2(255 CHAR) not null,
  is_submit    NUMBER(1) not null,
  operate_user VARCHAR2(255 CHAR) not null,
  exam_type_id NUMBER(10) not null,
  project_id   NUMBER(10) not null,
  semester_id  NUMBER(10) not null
)
;
comment on table T_EXAM_PAPERS
  is '考试试卷';
comment on column T_EXAM_PAPERS.id
  is '非业务主键';
comment on column T_EXAM_PAPERS.code
  is '试卷代码';
comment on column T_EXAM_PAPERS.is_submit
  is '是否 提交';
comment on column T_EXAM_PAPERS.operate_user
  is '操作用户';
comment on column T_EXAM_PAPERS.exam_type_id
  is '考试类型 ID ###引用表名是HB_EXAM_TYPES### ';
comment on column T_EXAM_PAPERS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column T_EXAM_PAPERS.semester_id
  is '学期 ID ###引用表名是C_SEMESTERS### ';
alter table T_EXAM_PAPERS
  add primary key (ID);
alter table T_EXAM_PAPERS
  add constraint FK_2RYA6R3TF5YITJDX2MNLDLE5A foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table T_EXAM_PAPERS
  add constraint FK_62V9BCSNT5BITAX5NB8ONV066 foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_EXAM_PAPERS
  add constraint FK_9L0VGTKVQD5MYFWIBU37WCT0S foreign key (EXAM_TYPE_ID)
  references HB_EXAM_TYPES (ID);

prompt Creating T_EXAM_PAPERS_LESSONS...
create table T_EXAM_PAPERS_LESSONS
(
  exam_paper_id NUMBER(19) not null,
  lesson_id     NUMBER(19) not null
)
;
comment on table T_EXAM_PAPERS_LESSONS
  is '考试试卷-包含任务';
comment on column T_EXAM_PAPERS_LESSONS.exam_paper_id
  is '考试试卷 ID ###引用表名是T_EXAM_PAPERS### ';
comment on column T_EXAM_PAPERS_LESSONS.lesson_id
  is '教学任务 ID ###引用表名是T_LESSONS### ';
alter table T_EXAM_PAPERS_LESSONS
  add constraint UK_FEA9BHUW77V9K4SI70EU9FOO7 unique (LESSON_ID);
alter table T_EXAM_PAPERS_LESSONS
  add constraint FK_DLQLLVF2XL0IW2DJQLJSEKTXD foreign key (EXAM_PAPER_ID)
  references T_EXAM_PAPERS (ID);
alter table T_EXAM_PAPERS_LESSONS
  add constraint FK_FEA9BHUW77V9K4SI70EU9FOO7 foreign key (LESSON_ID)
  references T_LESSONS (ID);

prompt Creating T_EXAM_ROOM_PROGRAMS_ROOMS...
create table T_EXAM_ROOM_PROGRAMS_ROOMS
(
  exam_room_program_id NUMBER(19) not null,
  classroom_id         NUMBER(10) not null
)
;
comment on table T_EXAM_ROOM_PROGRAMS_ROOMS
  is '考务教室方案管理-教室列表';
comment on column T_EXAM_ROOM_PROGRAMS_ROOMS.exam_room_program_id
  is '考务教室方案管理 ID ###引用表名是T_EXAM_ROOM_PROGRAMS### ';
comment on column T_EXAM_ROOM_PROGRAMS_ROOMS.classroom_id
  is '教室基本信息 ID ###引用表名是C_CLASSROOMS### ';
alter table T_EXAM_ROOM_PROGRAMS_ROOMS
  add primary key (EXAM_ROOM_PROGRAM_ID, CLASSROOM_ID);
alter table T_EXAM_ROOM_PROGRAMS_ROOMS
  add constraint FK_66QQEPEPEPTW1HTXCE0CLJ3FN foreign key (CLASSROOM_ID)
  references C_CLASSROOMS (ID);
alter table T_EXAM_ROOM_PROGRAMS_ROOMS
  add constraint FK_FDHGCULF35WBF7SXPRACBDF3K foreign key (EXAM_ROOM_PROGRAM_ID)
  references T_EXAM_ROOM_PROGRAMS (ID);

prompt Creating T_EXAM_TURNS...
create table T_EXAM_TURNS
(
  id         NUMBER(19) not null,
  begin_time NUMBER(10),
  end_time   NUMBER(10),
  eng_name   VARCHAR2(100 CHAR),
  name       VARCHAR2(100 CHAR),
  seq_no     NUMBER(10) not null,
  scheme_id  NUMBER(19)
)
;
comment on table T_EXAM_TURNS
  is '考试场次';
comment on column T_EXAM_TURNS.id
  is '非业务主键';
comment on column T_EXAM_TURNS.begin_time
  is '开始时间';
comment on column T_EXAM_TURNS.end_time
  is '结束时间';
comment on column T_EXAM_TURNS.eng_name
  is '场次英文名';
comment on column T_EXAM_TURNS.name
  is '场次中文名';
comment on column T_EXAM_TURNS.seq_no
  is '序号';
comment on column T_EXAM_TURNS.scheme_id
  is '场次组方案 ID ###引用表名是T_EXAM_TURN_SCHEMES### ';
alter table T_EXAM_TURNS
  add primary key (ID);
alter table T_EXAM_TURNS
  add constraint FK_F7FJPAMA7CI09KD4X1C22K6GU foreign key (SCHEME_ID)
  references T_EXAM_TURN_SCHEMES (ID);

prompt Creating T_EXCHANGE_CONFIGS...
create table T_EXCHANGE_CONFIGS
(
  id                    NUMBER(19) not null,
  created_at            TIMESTAMP(6),
  updated_at            TIMESTAMP(6),
  depart_audit_begin_at TIMESTAMP(6) not null,
  depart_audit_end_at   TIMESTAMP(6) not null,
  grade_input_begin_at  TIMESTAMP(6) not null,
  grade_input_end_at    TIMESTAMP(6) not null,
  opened                NUMBER(1) not null,
  semester_id           NUMBER(10) not null
)
;
comment on table T_EXCHANGE_CONFIGS
  is '交换成绩认定配置';
comment on column T_EXCHANGE_CONFIGS.id
  is '非业务主键';
comment on column T_EXCHANGE_CONFIGS.created_at
  is '创建时间';
comment on column T_EXCHANGE_CONFIGS.updated_at
  is '更新时间';
comment on column T_EXCHANGE_CONFIGS.depart_audit_begin_at
  is '部门开始审核时间';
comment on column T_EXCHANGE_CONFIGS.depart_audit_end_at
  is '部门结束审核时间';
comment on column T_EXCHANGE_CONFIGS.grade_input_begin_at
  is '成绩开始录入时间';
comment on column T_EXCHANGE_CONFIGS.grade_input_end_at
  is '成绩结束录入时间';
comment on column T_EXCHANGE_CONFIGS.opened
  is '是否开放';
comment on column T_EXCHANGE_CONFIGS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
alter table T_EXCHANGE_CONFIGS
  add primary key (ID);
alter table T_EXCHANGE_CONFIGS
  add constraint FK_GR1H1I4JYQA23XWS3DOK3O7B6 foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);

prompt Creating T_EXCHANGE_COURSE_GRADES...
create table T_EXCHANGE_COURSE_GRADES
(
  id             NUMBER(19) not null,
  passed         NUMBER(1) not null,
  score          FLOAT,
  score_text     VARCHAR2(255 CHAR),
  course_id      NUMBER(19),
  course_type_id NUMBER(10),
  mark_style_id  NUMBER(10),
  semester_id    NUMBER(10)
)
;
comment on table T_EXCHANGE_COURSE_GRADES
  is '交流成绩';
comment on column T_EXCHANGE_COURSE_GRADES.id
  is '非业务主键';
comment on column T_EXCHANGE_COURSE_GRADES.passed
  is '是否通过';
comment on column T_EXCHANGE_COURSE_GRADES.score
  is '分数';
comment on column T_EXCHANGE_COURSE_GRADES.score_text
  is '分数值';
comment on column T_EXCHANGE_COURSE_GRADES.course_id
  is '课程 ID ###引用表名是T_COURSES### ';
comment on column T_EXCHANGE_COURSE_GRADES.course_type_id
  is '课程类型 ID ###引用表名是XB_COURSE_TYPES### ';
comment on column T_EXCHANGE_COURSE_GRADES.mark_style_id
  is '记录方式 ID ###引用表名是HB_SCORE_MARK_STYLES### ';
comment on column T_EXCHANGE_COURSE_GRADES.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
alter table T_EXCHANGE_COURSE_GRADES
  add primary key (ID);
alter table T_EXCHANGE_COURSE_GRADES
  add constraint FK_7KSHL1PKND11TOWMSGYX2KQCC foreign key (COURSE_TYPE_ID)
  references XB_COURSE_TYPES (ID);
alter table T_EXCHANGE_COURSE_GRADES
  add constraint FK_92W1ETPE7AKO4L6T6TGCEFND3 foreign key (COURSE_ID)
  references T_COURSES (ID);
alter table T_EXCHANGE_COURSE_GRADES
  add constraint FK_L2TEX2EQUQYNER2R33FO9K0TQ foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_EXCHANGE_COURSE_GRADES
  add constraint FK_PWCY22IK3UQX0VSSA0IXG58H3 foreign key (MARK_STYLE_ID)
  references HB_SCORE_MARK_STYLES (ID);

prompt Creating XB_EXCHANGE_TYPES...
create table XB_EXCHANGE_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table XB_EXCHANGE_TYPES
  is '交流类别代码';
comment on column XB_EXCHANGE_TYPES.id
  is '非业务主键';
comment on column XB_EXCHANGE_TYPES.code
  is '代码';
comment on column XB_EXCHANGE_TYPES.created_at
  is '创建时间';
comment on column XB_EXCHANGE_TYPES.effective_at
  is '生效时间';
comment on column XB_EXCHANGE_TYPES.eng_name
  is '英文名称';
comment on column XB_EXCHANGE_TYPES.invalid_at
  is '失效时间';
comment on column XB_EXCHANGE_TYPES.name
  is '名称';
comment on column XB_EXCHANGE_TYPES.updated_at
  is '修改时间';
alter table XB_EXCHANGE_TYPES
  add primary key (ID);
alter table XB_EXCHANGE_TYPES
  add constraint UK_QT6T86INTKBMFXFXCOMAV9HS unique (CODE);

prompt Creating XB_EXCH_SCHOOL_TYPES...
create table XB_EXCH_SCHOOL_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table XB_EXCH_SCHOOL_TYPES
  is '交流学校类别代码';
comment on column XB_EXCH_SCHOOL_TYPES.id
  is '非业务主键';
comment on column XB_EXCH_SCHOOL_TYPES.code
  is '代码';
comment on column XB_EXCH_SCHOOL_TYPES.created_at
  is '创建时间';
comment on column XB_EXCH_SCHOOL_TYPES.effective_at
  is '生效时间';
comment on column XB_EXCH_SCHOOL_TYPES.eng_name
  is '英文名称';
comment on column XB_EXCH_SCHOOL_TYPES.invalid_at
  is '失效时间';
comment on column XB_EXCH_SCHOOL_TYPES.name
  is '名称';
comment on column XB_EXCH_SCHOOL_TYPES.updated_at
  is '修改时间';
alter table XB_EXCH_SCHOOL_TYPES
  add primary key (ID);
alter table XB_EXCH_SCHOOL_TYPES
  add constraint UK_GGCIX27XU9PXVUIKPO6G6IAQU unique (CODE);

prompt Creating T_EXCHANGE_PROJECTS...
create table T_EXCHANGE_PROJECTS
(
  id             NUMBER(19) not null,
  created_at     TIMESTAMP(6),
  updated_at     TIMESTAMP(6),
  code           VARCHAR2(32 CHAR) not null,
  effective_at   TIMESTAMP(6),
  invalid_at     TIMESTAMP(6),
  name           VARCHAR2(255 CHAR) not null,
  remark         VARCHAR2(255 CHAR),
  education_id   NUMBER(10),
  school_id      NUMBER(19),
  school_type_id NUMBER(10),
  type_id        NUMBER(10)
)
;
comment on table T_EXCHANGE_PROJECTS
  is '交流项目';
comment on column T_EXCHANGE_PROJECTS.id
  is '非业务主键';
comment on column T_EXCHANGE_PROJECTS.created_at
  is '创建时间';
comment on column T_EXCHANGE_PROJECTS.updated_at
  is '更新时间';
comment on column T_EXCHANGE_PROJECTS.code
  is '编号';
comment on column T_EXCHANGE_PROJECTS.effective_at
  is '生效日期';
comment on column T_EXCHANGE_PROJECTS.invalid_at
  is '失效日期';
comment on column T_EXCHANGE_PROJECTS.name
  is '名称';
comment on column T_EXCHANGE_PROJECTS.remark
  is '备注';
comment on column T_EXCHANGE_PROJECTS.education_id
  is '学历层次 ID ###引用表名是HB_EDUCATIONS### ';
comment on column T_EXCHANGE_PROJECTS.school_id
  is '交流学校 ID ###引用表名是T_EXCHANGE_SCHOOLS### ';
comment on column T_EXCHANGE_PROJECTS.school_type_id
  is '交流学校类别代码 ID ###引用表名是XB_EXCH_SCHOOL_TYPES### ';
comment on column T_EXCHANGE_PROJECTS.type_id
  is '交流类别代码 ID ###引用表名是XB_EXCHANGE_TYPES### ';
alter table T_EXCHANGE_PROJECTS
  add primary key (ID);
alter table T_EXCHANGE_PROJECTS
  add constraint FK_4Q7LDW2H0434H7T88S7J30VK foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);
alter table T_EXCHANGE_PROJECTS
  add constraint FK_ACU4U81SSAAW3Q00D0GL4P7W3 foreign key (TYPE_ID)
  references XB_EXCHANGE_TYPES (ID);
alter table T_EXCHANGE_PROJECTS
  add constraint FK_IUPTNCPG8SH9DPCJ7F7O0VQ8D foreign key (SCHOOL_TYPE_ID)
  references XB_EXCH_SCHOOL_TYPES (ID);
alter table T_EXCHANGE_PROJECTS
  add constraint FK_PTJR4P7I3M58UWMXQVS0X6TQ7 foreign key (SCHOOL_ID)
  references T_EXCHANGE_SCHOOLS (ID);

prompt Creating T_EXCHANGE_SESSIONS...
create table T_EXCHANGE_SESSIONS
(
  id           NUMBER(19) not null,
  created_at   TIMESTAMP(6),
  updated_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6),
  invalid_at   TIMESTAMP(6),
  project_id   NUMBER(19) not null,
  semester_id  NUMBER(10) not null
)
;
comment on table T_EXCHANGE_SESSIONS
  is '交换批次';
comment on column T_EXCHANGE_SESSIONS.id
  is '非业务主键';
comment on column T_EXCHANGE_SESSIONS.created_at
  is '创建时间';
comment on column T_EXCHANGE_SESSIONS.updated_at
  is '更新时间';
comment on column T_EXCHANGE_SESSIONS.effective_at
  is '开始时间';
comment on column T_EXCHANGE_SESSIONS.invalid_at
  is '结束时间';
comment on column T_EXCHANGE_SESSIONS.project_id
  is '交流项目 ID ###引用表名是T_EXCHANGE_PROJECTS### ';
comment on column T_EXCHANGE_SESSIONS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
alter table T_EXCHANGE_SESSIONS
  add primary key (ID);
alter table T_EXCHANGE_SESSIONS
  add constraint FK_4S1HVRAO4TU6PRNJBQX7VV6RT foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_EXCHANGE_SESSIONS
  add constraint FK_9UHHJQM8WWTVN8JWE31YFMSFC foreign key (PROJECT_ID)
  references T_EXCHANGE_PROJECTS (ID);

prompt Creating T_EXCHANGE_GRADES...
create table T_EXCHANGE_GRADES
(
  id          NUMBER(19) not null,
  created_at  TIMESTAMP(6),
  updated_at  TIMESTAMP(6),
  enabled     NUMBER(1) not null,
  remark      VARCHAR2(255 CHAR),
  score_text  VARCHAR2(255 CHAR),
  course_id   NUMBER(19),
  semester_id NUMBER(10),
  session_id  NUMBER(19),
  std_id      NUMBER(19)
)
;
comment on table T_EXCHANGE_GRADES
  is '交流学生课程成绩';
comment on column T_EXCHANGE_GRADES.id
  is '非业务主键';
comment on column T_EXCHANGE_GRADES.created_at
  is '创建时间';
comment on column T_EXCHANGE_GRADES.updated_at
  is '更新时间';
comment on column T_EXCHANGE_GRADES.enabled
  is '是否启用';
comment on column T_EXCHANGE_GRADES.remark
  is '备注';
comment on column T_EXCHANGE_GRADES.score_text
  is '外校成绩';
comment on column T_EXCHANGE_GRADES.course_id
  is '交流课程 ID ###引用表名是T_EXCHANGE_COURSES### ';
comment on column T_EXCHANGE_GRADES.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
comment on column T_EXCHANGE_GRADES.session_id
  is '交流批次 ID ###引用表名是T_EXCHANGE_SESSIONS### ';
comment on column T_EXCHANGE_GRADES.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table T_EXCHANGE_GRADES
  add primary key (ID);
alter table T_EXCHANGE_GRADES
  add constraint FK_2QGV5GIE1FSGPACK24S0X378Y foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table T_EXCHANGE_GRADES
  add constraint FK_BYYIRGI4THJ1EEHX57S7Q73SL foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_EXCHANGE_GRADES
  add constraint FK_CC8QXSN09A8E0NEXRXTDG0WII foreign key (COURSE_ID)
  references T_EXCHANGE_COURSES (ID);
alter table T_EXCHANGE_GRADES
  add constraint FK_O3N9UPER63PWMU5KGSXU2CUHW foreign key (SESSION_ID)
  references T_EXCHANGE_SESSIONS (ID);

prompt Creating T_EXCHANGE_GRADES_CONVERTS...
create table T_EXCHANGE_GRADES_CONVERTS
(
  exchange_grade_id        NUMBER(19) not null,
  exchange_course_grade_id NUMBER(19) not null
)
;
comment on table T_EXCHANGE_GRADES_CONVERTS
  is '交流学生课程成绩-转换结果';
comment on column T_EXCHANGE_GRADES_CONVERTS.exchange_grade_id
  is '交流学生课程成绩 ID ###引用表名是T_EXCHANGE_GRADES### ';
comment on column T_EXCHANGE_GRADES_CONVERTS.exchange_course_grade_id
  is '交流成绩 ID ###引用表名是T_EXCHANGE_COURSE_GRADES### ';
alter table T_EXCHANGE_GRADES_CONVERTS
  add primary key (EXCHANGE_GRADE_ID, EXCHANGE_COURSE_GRADE_ID);
alter table T_EXCHANGE_GRADES_CONVERTS
  add constraint FK_7HW8X4UUEMC5XTVC9XHE7V03Q foreign key (EXCHANGE_GRADE_ID)
  references T_EXCHANGE_GRADES (ID);
alter table T_EXCHANGE_GRADES_CONVERTS
  add constraint FK_N53XSN74D1A6YPSIW2B1QX0XD foreign key (EXCHANGE_COURSE_GRADE_ID)
  references T_EXCHANGE_COURSE_GRADES (ID);

prompt Creating T_EXCHANGE_LOGS...
create table T_EXCHANGE_LOGS
(
  id          NUMBER(19) not null,
  action_name VARCHAR2(255 CHAR),
  content     VARCHAR2(255 CHAR),
  ip          VARCHAR2(255 CHAR),
  operate_at  TIMESTAMP(6),
  user_id     NUMBER(19)
)
;
comment on table T_EXCHANGE_LOGS
  is '校外交流成绩操作日志';
comment on column T_EXCHANGE_LOGS.id
  is '非业务主键';
comment on column T_EXCHANGE_LOGS.action_name
  is '操作';
comment on column T_EXCHANGE_LOGS.content
  is '内容';
comment on column T_EXCHANGE_LOGS.ip
  is 'IP';
comment on column T_EXCHANGE_LOGS.operate_at
  is '操作时间';
comment on column T_EXCHANGE_LOGS.user_id
  is '操作用户 ID ###引用表名是SE_USERS### ';
alter table T_EXCHANGE_LOGS
  add primary key (ID);
alter table T_EXCHANGE_LOGS
  add constraint FK_JYAG5B0HAR9F0B1V00VJDL2I6 foreign key (USER_ID)
  references SE_USERS (ID);

prompt Creating T_EXCHANGE_STUDENTS...
create table T_EXCHANGE_STUDENTS
(
  id           NUMBER(19) not null,
  created_at   TIMESTAMP(6),
  updated_at   TIMESTAMP(6),
  admin_audit  VARCHAR2(500 CHAR),
  depart_audit VARCHAR2(500 CHAR),
  effective_at TIMESTAMP(6),
  invalid_at   TIMESTAMP(6),
  state        NUMBER(10) not null,
  session_id   NUMBER(19),
  std_id       NUMBER(19)
)
;
comment on table T_EXCHANGE_STUDENTS
  is '交流项目学生';
comment on column T_EXCHANGE_STUDENTS.id
  is '非业务主键';
comment on column T_EXCHANGE_STUDENTS.created_at
  is '创建时间';
comment on column T_EXCHANGE_STUDENTS.updated_at
  is '更新时间';
comment on column T_EXCHANGE_STUDENTS.admin_audit
  is '主管部门审核意见';
comment on column T_EXCHANGE_STUDENTS.depart_audit
  is '院系审核意见';
comment on column T_EXCHANGE_STUDENTS.effective_at
  is '失效日期';
comment on column T_EXCHANGE_STUDENTS.invalid_at
  is '失效日期';
comment on column T_EXCHANGE_STUDENTS.state
  is '交流状态';
comment on column T_EXCHANGE_STUDENTS.session_id
  is '交流项目 ID ###引用表名是T_EXCHANGE_SESSIONS### ';
comment on column T_EXCHANGE_STUDENTS.std_id
  is '学生信息 ID ###引用表名是C_STUDENTS### ';
alter table T_EXCHANGE_STUDENTS
  add primary key (ID);
alter table T_EXCHANGE_STUDENTS
  add constraint UK_E3NG5FRLKMO0TVTD8ODSCDNXS unique (SESSION_ID, STD_ID);
alter table T_EXCHANGE_STUDENTS
  add constraint FK_NNW1BQ5ARTUL77NV4ND7RO533 foreign key (SESSION_ID)
  references T_EXCHANGE_SESSIONS (ID);
alter table T_EXCHANGE_STUDENTS
  add constraint FK_QXDPDC2BS2QAJY06BFNHRGE0 foreign key (STD_ID)
  references C_STUDENTS (ID);

prompt Creating T_OTHER_EXAM_CONFIGS...
create table T_OTHER_EXAM_CONFIGS
(
  id          NUMBER(19) not null,
  begin_at    TIMESTAMP(6) not null,
  code        VARCHAR2(255 CHAR) not null,
  end_at      TIMESTAMP(6) not null,
  name        VARCHAR2(255 CHAR) not null,
  notice      VARCHAR2(2000 CHAR),
  opened      NUMBER(1) not null,
  remark      VARCHAR2(255 CHAR),
  category_id NUMBER(10) not null,
  project_id  NUMBER(10) not null,
  semester_id NUMBER(10) not null
)
;
comment on table T_OTHER_EXAM_CONFIGS
  is '校外考试报名设置（期号）';
comment on column T_OTHER_EXAM_CONFIGS.id
  is '非业务主键';
comment on column T_OTHER_EXAM_CONFIGS.begin_at
  is '开始时间';
comment on column T_OTHER_EXAM_CONFIGS.code
  is '期号';
comment on column T_OTHER_EXAM_CONFIGS.end_at
  is '结束时间';
comment on column T_OTHER_EXAM_CONFIGS.name
  is '期号名称';
comment on column T_OTHER_EXAM_CONFIGS.notice
  is '通知';
comment on column T_OTHER_EXAM_CONFIGS.opened
  is '在规定的时间段内,是否可以开放';
comment on column T_OTHER_EXAM_CONFIGS.remark
  is '备注';
comment on column T_OTHER_EXAM_CONFIGS.category_id
  is '考试类型 ID ###引用表名是HB_OTHER_EXAM_CATEGORIES### ';
comment on column T_OTHER_EXAM_CONFIGS.project_id
  is '教学项目 ID ###引用表名是C_PROJECTS### ';
comment on column T_OTHER_EXAM_CONFIGS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
alter table T_OTHER_EXAM_CONFIGS
  add primary key (ID);
alter table T_OTHER_EXAM_CONFIGS
  add constraint FK_4IEB54LU1T0KX4PHQ79B501ES foreign key (CATEGORY_ID)
  references HB_OTHER_EXAM_CATEGORIES (ID);
alter table T_OTHER_EXAM_CONFIGS
  add constraint FK_A2I5R29QUUUNUAK6UPT0GPJB8 foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_OTHER_EXAM_CONFIGS
  add constraint FK_QH6UP6ULCL4M4JQREYC0T5DJU foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating T_EXCLUSIVE_SUBJECTS...
create table T_EXCLUSIVE_SUBJECTS
(
  id             NUMBER(19) not null,
  config_id      NUMBER(19) not null,
  subject_one_id NUMBER(10) not null,
  subject_two_id NUMBER(10) not null
)
;
comment on table T_EXCLUSIVE_SUBJECTS
  is '校外考试报名冲突科目表';
comment on column T_EXCLUSIVE_SUBJECTS.id
  is '非业务主键';
comment on column T_EXCLUSIVE_SUBJECTS.config_id
  is '报名设置(期号) ID ###引用表名是T_OTHER_EXAM_CONFIGS### ';
comment on column T_EXCLUSIVE_SUBJECTS.subject_one_id
  is '冲突的科目一方 ID ###引用表名是HB_OTHER_EXAM_SUBJECTS### ';
comment on column T_EXCLUSIVE_SUBJECTS.subject_two_id
  is '冲突的科目另一方 ID ###引用表名是HB_OTHER_EXAM_SUBJECTS### ';
alter table T_EXCLUSIVE_SUBJECTS
  add primary key (ID);
alter table T_EXCLUSIVE_SUBJECTS
  add constraint FK_K38UFYAFDFUHH0MKD75H1BWL3 foreign key (CONFIG_ID)
  references T_OTHER_EXAM_CONFIGS (ID);
alter table T_EXCLUSIVE_SUBJECTS
  add constraint FK_P2L0L94RURWRBR3N6P4RUMW57 foreign key (SUBJECT_TWO_ID)
  references HB_OTHER_EXAM_SUBJECTS (ID);
alter table T_EXCLUSIVE_SUBJECTS
  add constraint FK_RWJ1X9CXPISNEWFS4SOVBOEHK foreign key (SUBJECT_ONE_ID)
  references HB_OTHER_EXAM_SUBJECTS (ID);

prompt Creating T_GRADE_INPUT_SWITCHES...
create table T_GRADE_INPUT_SWITCHES
(
  id            NUMBER(19) not null,
  end_at        TIMESTAMP(6),
  need_validate NUMBER(1) not null,
  opened        NUMBER(1) not null,
  remark        VARCHAR2(255 CHAR),
  start_at      TIMESTAMP(6),
  project_id    NUMBER(10) not null,
  semester_id   NUMBER(10) not null
)
;
comment on table T_GRADE_INPUT_SWITCHES
  is '成绩录入开关';
comment on column T_GRADE_INPUT_SWITCHES.id
  is '非业务主键';
comment on column T_GRADE_INPUT_SWITCHES.end_at
  is '关闭时间';
comment on column T_GRADE_INPUT_SWITCHES.need_validate
  is '成绩录入验证开关';
comment on column T_GRADE_INPUT_SWITCHES.opened
  is '成绩录入开关';
comment on column T_GRADE_INPUT_SWITCHES.remark
  is '备注';
comment on column T_GRADE_INPUT_SWITCHES.start_at
  is '开始时间';
comment on column T_GRADE_INPUT_SWITCHES.project_id
  is '教学项目 ID ###引用表名是C_PROJECTS### ';
comment on column T_GRADE_INPUT_SWITCHES.semester_id
  is '教学日历 ID ###引用表名是C_SEMESTERS### ';
alter table T_GRADE_INPUT_SWITCHES
  add primary key (ID);
alter table T_GRADE_INPUT_SWITCHES
  add constraint FK_AKXGPYUE56S1BTJS8PD4YJF1L foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_GRADE_INPUT_SWITCHES
  add constraint FK_FV9B6XLVWHG0C61OGXJ3QJN7S foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating T_GRADE_INPUT_SWITCHES_TYPES...
create table T_GRADE_INPUT_SWITCHES_TYPES
(
  grade_input_switch_id NUMBER(19) not null,
  grade_type_id         NUMBER(10) not null
)
;
comment on table T_GRADE_INPUT_SWITCHES_TYPES
  is '成绩录入开关-允许录入成绩类型';
comment on column T_GRADE_INPUT_SWITCHES_TYPES.grade_input_switch_id
  is '成绩录入开关 ID ###引用表名是T_GRADE_INPUT_SWITCHES### ';
comment on column T_GRADE_INPUT_SWITCHES_TYPES.grade_type_id
  is '成绩类型 ID ###引用表名是HB_GRADE_TYPES### ';
alter table T_GRADE_INPUT_SWITCHES_TYPES
  add primary key (GRADE_INPUT_SWITCH_ID, GRADE_TYPE_ID);
alter table T_GRADE_INPUT_SWITCHES_TYPES
  add constraint FK_9NJGYCQUROW35YOWISNSKC30C foreign key (GRADE_TYPE_ID)
  references HB_GRADE_TYPES (ID);
alter table T_GRADE_INPUT_SWITCHES_TYPES
  add constraint FK_DQI1JO0VQM2DMG288P3028C2R foreign key (GRADE_INPUT_SWITCH_ID)
  references T_GRADE_INPUT_SWITCHES (ID);

prompt Creating T_GRADE_MODIFY_APPLIES...
create table T_GRADE_MODIFY_APPLIES
(
  id                    NUMBER(19) not null,
  created_at            TIMESTAMP(6),
  updated_at            TIMESTAMP(6),
  apply_reason          VARCHAR2(255 CHAR),
  applyer               VARCHAR2(50 CHAR),
  audit_reason          VARCHAR2(255 CHAR),
  auditer               VARCHAR2(50 CHAR),
  final_auditer         VARCHAR2(50 CHAR),
  orig_score            FLOAT,
  orig_score_text       VARCHAR2(255 CHAR),
  score                 FLOAT,
  score_text            VARCHAR2(255 CHAR),
  status                VARCHAR2(255 CHAR) not null,
  course_id             NUMBER(19) not null,
  exam_status_id        NUMBER(10) not null,
  exam_status_before_id NUMBER(10) not null,
  grade_type_id         NUMBER(10) not null,
  project_id            NUMBER(10) not null,
  semester_id           NUMBER(10) not null,
  std_id                NUMBER(19) not null
)
;
comment on table T_GRADE_MODIFY_APPLIES
  is '成绩修改申请';
comment on column T_GRADE_MODIFY_APPLIES.id
  is '非业务主键';
comment on column T_GRADE_MODIFY_APPLIES.created_at
  is '创建时间';
comment on column T_GRADE_MODIFY_APPLIES.updated_at
  is '更新时间';
comment on column T_GRADE_MODIFY_APPLIES.apply_reason
  is '申请理由';
comment on column T_GRADE_MODIFY_APPLIES.applyer
  is '申请人';
comment on column T_GRADE_MODIFY_APPLIES.audit_reason
  is '审核理由';
comment on column T_GRADE_MODIFY_APPLIES.auditer
  is '审核人';
comment on column T_GRADE_MODIFY_APPLIES.final_auditer
  is '最终审核人';
comment on column T_GRADE_MODIFY_APPLIES.orig_score
  is '原得分';
comment on column T_GRADE_MODIFY_APPLIES.orig_score_text
  is '原得分字面值';
comment on column T_GRADE_MODIFY_APPLIES.score
  is '得分';
comment on column T_GRADE_MODIFY_APPLIES.score_text
  is '得分字面值';
comment on column T_GRADE_MODIFY_APPLIES.status
  is '审核状态';
comment on column T_GRADE_MODIFY_APPLIES.course_id
  is '课程 ID ###引用表名是T_COURSES### ';
comment on column T_GRADE_MODIFY_APPLIES.exam_status_id
  is '考试情况 ID ###引用表名是HB_EXAM_STATUSES### ';
comment on column T_GRADE_MODIFY_APPLIES.exam_status_before_id
  is '原考试情况 ID ###引用表名是HB_EXAM_STATUSES### ';
comment on column T_GRADE_MODIFY_APPLIES.grade_type_id
  is '成绩类型 ID ###引用表名是HB_GRADE_TYPES### ';
comment on column T_GRADE_MODIFY_APPLIES.project_id
  is '教学项目 ID ###引用表名是C_PROJECTS### ';
comment on column T_GRADE_MODIFY_APPLIES.semester_id
  is '教学日历 ID ###引用表名是C_SEMESTERS### ';
comment on column T_GRADE_MODIFY_APPLIES.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table T_GRADE_MODIFY_APPLIES
  add primary key (ID);
alter table T_GRADE_MODIFY_APPLIES
  add constraint FK_6HFEQE8P64HKUWEKMFXBRVYIR foreign key (EXAM_STATUS_ID)
  references HB_EXAM_STATUSES (ID);
alter table T_GRADE_MODIFY_APPLIES
  add constraint FK_BU4GCJ5A6HMEUDLS72ABP09SB foreign key (GRADE_TYPE_ID)
  references HB_GRADE_TYPES (ID);
alter table T_GRADE_MODIFY_APPLIES
  add constraint FK_FMCIWAUEUBERNKIJ5SV2CT67O foreign key (COURSE_ID)
  references T_COURSES (ID);
alter table T_GRADE_MODIFY_APPLIES
  add constraint FK_G9IY2HQNVTTU5TDITNWO4VW01 foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table T_GRADE_MODIFY_APPLIES
  add constraint FK_RT4INW1Y2D8S37RKKQJNXP3Y foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_GRADE_MODIFY_APPLIES
  add constraint FK_SQNU9S2O73NQOPTIB7H0I2BDM foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table T_GRADE_MODIFY_APPLIES
  add constraint FK_STP60XQCI2VRS35VV4C83OK1O foreign key (EXAM_STATUS_BEFORE_ID)
  references HB_EXAM_STATUSES (ID);

prompt Creating T_GRADE_RATE_CONFIGS...
create table T_GRADE_RATE_CONFIGS
(
  id                  NUMBER(19) not null,
  pass_score          FLOAT not null,
  project_id          NUMBER(10) not null,
  score_mark_style_id NUMBER(10) not null
)
;
comment on table T_GRADE_RATE_CONFIGS
  is '成绩分级配置';
comment on column T_GRADE_RATE_CONFIGS.id
  is '非业务主键';
comment on column T_GRADE_RATE_CONFIGS.pass_score
  is '及格线';
comment on column T_GRADE_RATE_CONFIGS.project_id
  is '对应培养类型(默认為空) ID ###引用表名是C_PROJECTS### ';
comment on column T_GRADE_RATE_CONFIGS.score_mark_style_id
  is '成绩记录方式 ID ###引用表名是HB_SCORE_MARK_STYLES### ';
alter table T_GRADE_RATE_CONFIGS
  add primary key (ID);
alter table T_GRADE_RATE_CONFIGS
  add constraint UK_PUSF5CLQIWDKFA6THH31O1NMO unique (PROJECT_ID, SCORE_MARK_STYLE_ID);
alter table T_GRADE_RATE_CONFIGS
  add constraint FK_1R1FRN594NOEJII08FBHUAK5V foreign key (SCORE_MARK_STYLE_ID)
  references HB_SCORE_MARK_STYLES (ID);
alter table T_GRADE_RATE_CONFIGS
  add constraint FK_HLAKMSPLAJC5EMYJKVFB5E7QF foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating T_GRADE_RATE_ITEMS...
create table T_GRADE_RATE_ITEMS
(
  id            NUMBER(19) not null,
  default_score FLOAT,
  gp_exp        VARCHAR2(255 CHAR),
  grade         VARCHAR2(255 CHAR),
  max_score     FLOAT,
  min_score     FLOAT,
  config_id     NUMBER(19)
)
;
comment on table T_GRADE_RATE_ITEMS
  is '成绩分级配置项';
comment on column T_GRADE_RATE_ITEMS.id
  is '非业务主键';
comment on column T_GRADE_RATE_ITEMS.default_score
  is '默认分数';
comment on column T_GRADE_RATE_ITEMS.gp_exp
  is '绩点表达式';
comment on column T_GRADE_RATE_ITEMS.grade
  is '显示名称';
comment on column T_GRADE_RATE_ITEMS.max_score
  is '最高分';
comment on column T_GRADE_RATE_ITEMS.min_score
  is '最低分';
comment on column T_GRADE_RATE_ITEMS.config_id
  is '成绩配置 ID ###引用表名是T_GRADE_RATE_CONFIGS### ';
alter table T_GRADE_RATE_ITEMS
  add primary key (ID);
alter table T_GRADE_RATE_ITEMS
  add constraint FK_68OKO4767QE0M9DMSBLT04G28 foreign key (CONFIG_ID)
  references T_GRADE_RATE_CONFIGS (ID);

prompt Creating T_GRADE_VIEW_SCOPES...
create table T_GRADE_VIEW_SCOPES
(
  id               NUMBER(19) not null,
  check_evaluation NUMBER(1) not null,
  enroll_years     VARCHAR2(255 CHAR)
)
;
comment on table T_GRADE_VIEW_SCOPES
  is '查看成绩范围';
comment on column T_GRADE_VIEW_SCOPES.id
  is '非业务主键';
comment on column T_GRADE_VIEW_SCOPES.check_evaluation
  is '是否检查评教';
comment on column T_GRADE_VIEW_SCOPES.enroll_years
  is '入学年份集合';
alter table T_GRADE_VIEW_SCOPES
  add primary key (ID);

prompt Creating T_GRADE_VIEW_SCOPES_EDUCATIONS...
create table T_GRADE_VIEW_SCOPES_EDUCATIONS
(
  grade_view_scope_id NUMBER(19) not null,
  education_id        NUMBER(10) not null
)
;
comment on table T_GRADE_VIEW_SCOPES_EDUCATIONS
  is '查看成绩范围-培养层次';
comment on column T_GRADE_VIEW_SCOPES_EDUCATIONS.grade_view_scope_id
  is '查看成绩范围 ID ###引用表名是T_GRADE_VIEW_SCOPES### ';
comment on column T_GRADE_VIEW_SCOPES_EDUCATIONS.education_id
  is '学历层次 ID ###引用表名是HB_EDUCATIONS### ';
alter table T_GRADE_VIEW_SCOPES_EDUCATIONS
  add primary key (GRADE_VIEW_SCOPE_ID, EDUCATION_ID);
alter table T_GRADE_VIEW_SCOPES_EDUCATIONS
  add constraint FK_1SOIS1GEE59IPRWDY3V12AN4W foreign key (GRADE_VIEW_SCOPE_ID)
  references T_GRADE_VIEW_SCOPES (ID);
alter table T_GRADE_VIEW_SCOPES_EDUCATIONS
  add constraint FK_E1SF0FT9P65GGEU2O5BYDAN09 foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);

prompt Creating T_GRADE_VIEW_SCOPES_PROJECTS...
create table T_GRADE_VIEW_SCOPES_PROJECTS
(
  grade_view_scope_id NUMBER(19) not null,
  project_id          NUMBER(10) not null
)
;
comment on table T_GRADE_VIEW_SCOPES_PROJECTS
  is '查看成绩范围-教学项目';
comment on column T_GRADE_VIEW_SCOPES_PROJECTS.grade_view_scope_id
  is '查看成绩范围 ID ###引用表名是T_GRADE_VIEW_SCOPES### ';
comment on column T_GRADE_VIEW_SCOPES_PROJECTS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
alter table T_GRADE_VIEW_SCOPES_PROJECTS
  add primary key (GRADE_VIEW_SCOPE_ID, PROJECT_ID);
alter table T_GRADE_VIEW_SCOPES_PROJECTS
  add constraint FK_I1HHMSM4TTO6NW8AN8JHVLTIM foreign key (GRADE_VIEW_SCOPE_ID)
  references T_GRADE_VIEW_SCOPES (ID);
alter table T_GRADE_VIEW_SCOPES_PROJECTS
  add constraint FK_IKGK5KM5Y9I6PY8NVBYCK9GBB foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating T_GRADE_VIEW_SCOPES_STD_TYPES...
create table T_GRADE_VIEW_SCOPES_STD_TYPES
(
  grade_view_scope_id NUMBER(19) not null,
  std_type_id         NUMBER(10) not null
)
;
comment on table T_GRADE_VIEW_SCOPES_STD_TYPES
  is '查看成绩范围-学生类别集合';
comment on column T_GRADE_VIEW_SCOPES_STD_TYPES.grade_view_scope_id
  is '查看成绩范围 ID ###引用表名是T_GRADE_VIEW_SCOPES### ';
comment on column T_GRADE_VIEW_SCOPES_STD_TYPES.std_type_id
  is '学生类别 ID ###引用表名是XB_STD_TYPES### ';
alter table T_GRADE_VIEW_SCOPES_STD_TYPES
  add primary key (GRADE_VIEW_SCOPE_ID, STD_TYPE_ID);
alter table T_GRADE_VIEW_SCOPES_STD_TYPES
  add constraint FK_IRYE7YDE4TL3RKUX7PMKQS1M6 foreign key (STD_TYPE_ID)
  references XB_STD_TYPES (ID);
alter table T_GRADE_VIEW_SCOPES_STD_TYPES
  add constraint FK_LJTE76YXCUE7BGKF4VWYY3CEA foreign key (GRADE_VIEW_SCOPE_ID)
  references T_GRADE_VIEW_SCOPES (ID);

prompt Creating T_LAST_MAKEUP_TASKS...
create table T_LAST_MAKEUP_TASKS
(
  id           NUMBER(19) not null,
  created_at   TIMESTAMP(6),
  updated_at   TIMESTAMP(6),
  input_at     TIMESTAMP(6),
  published    NUMBER(1) not null,
  seq_no       VARCHAR2(50 CHAR) not null,
  std_count    NUMBER(10) not null,
  submit_grade NUMBER(1) not null,
  project_id   NUMBER(10),
  course_id    NUMBER(19) not null,
  depart_id    NUMBER(10) not null,
  semester_id  NUMBER(10) not null,
  teacher_id   NUMBER(19)
)
;
comment on table T_LAST_MAKEUP_TASKS
  is '毕业清考任务';
comment on column T_LAST_MAKEUP_TASKS.id
  is '非业务主键';
comment on column T_LAST_MAKEUP_TASKS.created_at
  is '创建时间';
comment on column T_LAST_MAKEUP_TASKS.updated_at
  is '更新时间';
comment on column T_LAST_MAKEUP_TASKS.input_at
  is '录入日期';
comment on column T_LAST_MAKEUP_TASKS.published
  is '是否发布成绩';
comment on column T_LAST_MAKEUP_TASKS.seq_no
  is '清考序号';
comment on column T_LAST_MAKEUP_TASKS.std_count
  is '学生人数';
comment on column T_LAST_MAKEUP_TASKS.submit_grade
  is '是否提交成绩';
comment on column T_LAST_MAKEUP_TASKS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column T_LAST_MAKEUP_TASKS.course_id
  is '课程 ID ###引用表名是T_COURSES### ';
comment on column T_LAST_MAKEUP_TASKS.depart_id
  is '开课院系 ID ###引用表名是C_DEPARTMENTS### ';
comment on column T_LAST_MAKEUP_TASKS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
comment on column T_LAST_MAKEUP_TASKS.teacher_id
  is '阅卷老师 ID ###引用表名是C_TEACHERS### ';
alter table T_LAST_MAKEUP_TASKS
  add primary key (ID);
alter table T_LAST_MAKEUP_TASKS
  add constraint FK_1V887AF94XK432KLW2BCC64S9 foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_LAST_MAKEUP_TASKS
  add constraint FK_2DXTDHWB2OUCCI40QFHJIH1U6 foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table T_LAST_MAKEUP_TASKS
  add constraint FK_55USRYC9P65GB6HDAGF9XYLXH foreign key (COURSE_ID)
  references T_COURSES (ID);
alter table T_LAST_MAKEUP_TASKS
  add constraint FK_AS16H29AKX2PYTR7BWO2CV6T1 foreign key (DEPART_ID)
  references C_DEPARTMENTS (ID);
alter table T_LAST_MAKEUP_TASKS
  add constraint FK_JVM00S5IB35PA79JKLYP7T8XO foreign key (TEACHER_ID)
  references C_TEACHERS (ID);

prompt Creating T_LAST_MAKEUP_TAKES...
create table T_LAST_MAKEUP_TAKES
(
  id             NUMBER(19) not null,
  course_type_id NUMBER(10),
  std_id         NUMBER(19) not null,
  task_id        NUMBER(19) not null
)
;
comment on table T_LAST_MAKEUP_TAKES
  is '毕业清考名单';
comment on column T_LAST_MAKEUP_TAKES.id
  is '非业务主键';
comment on column T_LAST_MAKEUP_TAKES.course_type_id
  is '课程类型 ID ###引用表名是XB_COURSE_TYPES### ';
comment on column T_LAST_MAKEUP_TAKES.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
comment on column T_LAST_MAKEUP_TAKES.task_id
  is '清考任务 ID ###引用表名是T_LAST_MAKEUP_TASKS### ';
alter table T_LAST_MAKEUP_TAKES
  add primary key (ID);
alter table T_LAST_MAKEUP_TAKES
  add constraint FK_8ETD68HGNXYYYL01A1BQWPQL4 foreign key (TASK_ID)
  references T_LAST_MAKEUP_TASKS (ID);
alter table T_LAST_MAKEUP_TAKES
  add constraint FK_L1N68YKX38W1XQSJWMBH39IUU foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table T_LAST_MAKEUP_TAKES
  add constraint FK_TMII468RUATQYGI74MVYHBYCU foreign key (COURSE_TYPE_ID)
  references XB_COURSE_TYPES (ID);

prompt Creating T_LAST_MAKEUP_TASKS_CLASSES...
create table T_LAST_MAKEUP_TASKS_CLASSES
(
  last_makeup_task_id NUMBER(19) not null,
  adminclass_id       NUMBER(10) not null
)
;
comment on table T_LAST_MAKEUP_TASKS_CLASSES
  is '毕业清考任务-行政班列表';
comment on column T_LAST_MAKEUP_TASKS_CLASSES.last_makeup_task_id
  is '毕业清考任务 ID ###引用表名是T_LAST_MAKEUP_TASKS### ';
comment on column T_LAST_MAKEUP_TASKS_CLASSES.adminclass_id
  is '学生行政班级信息 ID ###引用表名是C_ADMINCLASSES### ';
alter table T_LAST_MAKEUP_TASKS_CLASSES
  add primary key (LAST_MAKEUP_TASK_ID, ADMINCLASS_ID);
alter table T_LAST_MAKEUP_TASKS_CLASSES
  add constraint FK_RAAYV80H5IM2YW984MNSMECTU foreign key (LAST_MAKEUP_TASK_ID)
  references T_LAST_MAKEUP_TASKS (ID);
alter table T_LAST_MAKEUP_TASKS_CLASSES
  add constraint FK_S9UCKN89MBRRRA1T6MVQUEUTY foreign key (ADMINCLASS_ID)
  references C_ADMINCLASSES (ID);

prompt Creating T_LESSONS_EXAM_TYPES...
create table T_LESSONS_EXAM_TYPES
(
  lesson_id    NUMBER(19) not null,
  exam_type_id NUMBER(10) not null
)
;
comment on table T_LESSONS_EXAM_TYPES
  is '教学任务-考试类型';
comment on column T_LESSONS_EXAM_TYPES.lesson_id
  is '教学任务 ID ###引用表名是T_LESSONS### ';
comment on column T_LESSONS_EXAM_TYPES.exam_type_id
  is '考试类型 ID ###引用表名是HB_EXAM_TYPES### ';
alter table T_LESSONS_EXAM_TYPES
  add primary key (LESSON_ID, EXAM_TYPE_ID);
alter table T_LESSONS_EXAM_TYPES
  add constraint FK_61RXK9J7559AOHAK6YSENABAO foreign key (EXAM_TYPE_ID)
  references HB_EXAM_TYPES (ID);
alter table T_LESSONS_EXAM_TYPES
  add constraint FK_I8KER9PT4XQP1IX57YN8QRO37 foreign key (LESSON_ID)
  references T_LESSONS (ID);

prompt Creating T_LESSON_TAGS...
create table T_LESSON_TAGS
(
  id         NUMBER(19) not null,
  created_at TIMESTAMP(6),
  updated_at TIMESTAMP(6),
  color      VARCHAR2(50 CHAR) not null,
  eng_name   VARCHAR2(200 CHAR) not null,
  name       VARCHAR2(50 CHAR) not null,
  project_id NUMBER(10)
)
;
comment on table T_LESSON_TAGS
  is '教学任务标签';
comment on column T_LESSON_TAGS.id
  is '非业务主键';
comment on column T_LESSON_TAGS.created_at
  is '创建时间';
comment on column T_LESSON_TAGS.updated_at
  is '更新时间';
comment on column T_LESSON_TAGS.color
  is '颜色';
comment on column T_LESSON_TAGS.eng_name
  is '英文名称';
comment on column T_LESSON_TAGS.name
  is '名称';
comment on column T_LESSON_TAGS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
alter table T_LESSON_TAGS
  add primary key (ID);
alter table T_LESSON_TAGS
  add constraint UK_KH2LMWECR6VB5JPQY29EWHA4X unique (NAME, PROJECT_ID);
alter table T_LESSON_TAGS
  add constraint UK_NR2T4SRVL1DS0TUG2CSM9OT60 unique (ENG_NAME, PROJECT_ID);
alter table T_LESSON_TAGS
  add constraint FK_8V4CX4KN38IRLOL6XQKWOVS4Y foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating T_LESSONS_TAGS...
create table T_LESSONS_TAGS
(
  lesson_id     NUMBER(19) not null,
  lesson_tag_id NUMBER(19) not null
)
;
comment on table T_LESSONS_TAGS
  is '教学任务-教学任务标签';
comment on column T_LESSONS_TAGS.lesson_id
  is '教学任务 ID ###引用表名是T_LESSONS### ';
comment on column T_LESSONS_TAGS.lesson_tag_id
  is '教学任务标签 ID ###引用表名是T_LESSON_TAGS### ';
alter table T_LESSONS_TAGS
  add constraint FK_3YF2PHLEK3Y567MRVRUOAQXEH foreign key (LESSON_TAG_ID)
  references T_LESSON_TAGS (ID);
alter table T_LESSONS_TAGS
  add constraint FK_42VHBQQW63WDI61A4JUY4I9O0 foreign key (LESSON_ID)
  references T_LESSONS (ID);

prompt Creating T_LESSONS_TEACHERS...
create table T_LESSONS_TEACHERS
(
  lesson_id  NUMBER(19) not null,
  teacher_id NUMBER(19) not null
)
;
comment on table T_LESSONS_TEACHERS
  is '教学任务-授课教师';
comment on column T_LESSONS_TEACHERS.lesson_id
  is '教学任务 ID ###引用表名是T_LESSONS### ';
comment on column T_LESSONS_TEACHERS.teacher_id
  is '教师信息默认实现 ID ###引用表名是C_TEACHERS### ';
alter table T_LESSONS_TEACHERS
  add constraint FK_8ED9YHH692TE8O7J6FM4G5YXG foreign key (LESSON_ID)
  references T_LESSONS (ID);
alter table T_LESSONS_TEACHERS
  add constraint FK_HQFPGSYX0HS2PNHR2FYYL7YPE foreign key (TEACHER_ID)
  references C_TEACHERS (ID);

prompt Creating T_LESSON_COLLEGE_SWITCHES...
create table T_LESSON_COLLEGE_SWITCHES
(
  id          NUMBER(19) not null,
  open        NUMBER(1) not null,
  project_id  NUMBER(10),
  semester_id NUMBER(10)
)
;
comment on table T_LESSON_COLLEGE_SWITCHES
  is '院系任务开关';
comment on column T_LESSON_COLLEGE_SWITCHES.id
  is '非业务主键';
comment on column T_LESSON_COLLEGE_SWITCHES.open
  is '是否开放';
comment on column T_LESSON_COLLEGE_SWITCHES.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column T_LESSON_COLLEGE_SWITCHES.semester_id
  is '学期 ID ###引用表名是C_SEMESTERS### ';
alter table T_LESSON_COLLEGE_SWITCHES
  add primary key (ID);
alter table T_LESSON_COLLEGE_SWITCHES
  add constraint UK_ILAWEKOD8MHMKOIOSTEBEY4RP unique (PROJECT_ID, SEMESTER_ID);
alter table T_LESSON_COLLEGE_SWITCHES
  add constraint FK_7FLTQWA6MYN0I6GAQOCAICHBD foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table T_LESSON_COLLEGE_SWITCHES
  add constraint FK_FRVS69KFMJ7M7ITM3AFQPBU5Q foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);

prompt Creating T_LESSON_FOR_DEPARTS...
create table T_LESSON_FOR_DEPARTS
(
  id            NUMBER(19) not null,
  begin_at      TIMESTAMP(6),
  end_at        TIMESTAMP(6),
  department_id NUMBER(10),
  project_id    NUMBER(10),
  semester_id   NUMBER(10)
)
;
comment on table T_LESSON_FOR_DEPARTS
  is '院系排课权限分配';
comment on column T_LESSON_FOR_DEPARTS.id
  is '非业务主键';
comment on column T_LESSON_FOR_DEPARTS.begin_at
  is '开始时间';
comment on column T_LESSON_FOR_DEPARTS.end_at
  is '结束时间';
comment on column T_LESSON_FOR_DEPARTS.department_id
  is '开课院系 ID ###引用表名是C_DEPARTMENTS### ';
comment on column T_LESSON_FOR_DEPARTS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column T_LESSON_FOR_DEPARTS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
alter table T_LESSON_FOR_DEPARTS
  add primary key (ID);
alter table T_LESSON_FOR_DEPARTS
  add constraint UK_LDQXH83N9O1PYHL41VX8846ES unique (DEPARTMENT_ID, PROJECT_ID, SEMESTER_ID);
alter table T_LESSON_FOR_DEPARTS
  add constraint FK_2PIG7TOF2CGU3UHGSITFBDBM7 foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table T_LESSON_FOR_DEPARTS
  add constraint FK_7I84LD1K8X94T44YP8QKQWAGM foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_LESSON_FOR_DEPARTS
  add constraint FK_LQIMSUS0B5UEU91ESXTINJ6GP foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);

prompt Creating T_LESSON_FOR_D_L_IDS...
create table T_LESSON_FOR_D_L_IDS
(
  lesson_for_depart_id NUMBER(19) not null,
  lesson_id            NUMBER(19)
)
;
comment on table T_LESSON_FOR_D_L_IDS
  is '院系排课权限分配-教学任务IDs';
comment on column T_LESSON_FOR_D_L_IDS.lesson_for_depart_id
  is '院系排课权限分配 ID ###引用表名是T_LESSON_FOR_DEPARTS### ';
alter table T_LESSON_FOR_D_L_IDS
  add constraint UK_5RHNDVP788TIH34UU2UG54KT8 unique (LESSON_ID);
alter table T_LESSON_FOR_D_L_IDS
  add constraint FK_I72K1JBH3YWW1RQAX4CYW53BO foreign key (LESSON_FOR_DEPART_ID)
  references T_LESSON_FOR_DEPARTS (ID);

prompt Creating T_LESSON_MATERIALS...
create table T_LESSON_MATERIALS
(
  id              NUMBER(19) not null,
  audit_at        TIMESTAMP(6),
  extra           VARCHAR2(500 CHAR),
  passed          NUMBER(1),
  reference_books VARCHAR2(500 CHAR),
  remark          VARCHAR2(200 CHAR),
  status          VARCHAR2(255 CHAR) not null,
  use_explain     VARCHAR2(500 CHAR),
  lesson_id       NUMBER(19)
)
;
comment on table T_LESSON_MATERIALS
  is '教学资料';
comment on column T_LESSON_MATERIALS.id
  is '非业务主键';
comment on column T_LESSON_MATERIALS.audit_at
  is '审核时间';
comment on column T_LESSON_MATERIALS.extra
  is '其它资料';
comment on column T_LESSON_MATERIALS.passed
  is '是否审核通过';
comment on column T_LESSON_MATERIALS.reference_books
  is '参考书';
comment on column T_LESSON_MATERIALS.remark
  is '其它说明';
comment on column T_LESSON_MATERIALS.status
  is '教材指定状态';
comment on column T_LESSON_MATERIALS.use_explain
  is '选用说明';
comment on column T_LESSON_MATERIALS.lesson_id
  is '教学任务 ID ###引用表名是T_LESSONS### ';
alter table T_LESSON_MATERIALS
  add primary key (ID);
alter table T_LESSON_MATERIALS
  add constraint UK_SAVWR2PPWWWSGVGOS91LGVO5V unique (LESSON_ID);
alter table T_LESSON_MATERIALS
  add constraint FK_VLSB3DUYMIILPRIS2EPF7YU9 foreign key (LESSON_ID)
  references T_LESSONS (ID);

prompt Creating T_LESSON_MATERIALS_BOOKS...
create table T_LESSON_MATERIALS_BOOKS
(
  lesson_material_id NUMBER(19) not null,
  textbook_id        NUMBER(19) not null
)
;
comment on table T_LESSON_MATERIALS_BOOKS
  is '教学资料-教材列表';
comment on column T_LESSON_MATERIALS_BOOKS.lesson_material_id
  is '教学资料 ID ###引用表名是T_LESSON_MATERIALS### ';
comment on column T_LESSON_MATERIALS_BOOKS.textbook_id
  is '教材 ID ###引用表名是T_TEXTBOOKS### ';
alter table T_LESSON_MATERIALS_BOOKS
  add constraint FK_5TGDBFQBLP3O3KUU64GLR28PU foreign key (TEXTBOOK_ID)
  references T_TEXTBOOKS (ID);
alter table T_LESSON_MATERIALS_BOOKS
  add constraint FK_JCQTPFXV7DPXDUK6HMULPMDVR foreign key (LESSON_MATERIAL_ID)
  references T_LESSON_MATERIALS (ID);

prompt Creating T_PROGRAMS...
create table T_PROGRAMS
(
  id            NUMBER(19) not null,
  created_at    TIMESTAMP(6),
  updated_at    TIMESTAMP(6),
  audit_state   VARCHAR2(255 CHAR) not null,
  duration      FLOAT not null,
  effective_on  DATE not null,
  grade         VARCHAR2(255 CHAR) not null,
  invalid_on    DATE,
  name          VARCHAR2(200 CHAR) not null,
  remark        VARCHAR2(800 CHAR),
  degree_id     NUMBER(10),
  department_id NUMBER(10) not null,
  direction_id  NUMBER(10),
  education_id  NUMBER(10),
  major_id      NUMBER(10),
  std_type_id   NUMBER(10),
  study_type_id NUMBER(10)
)
;
comment on table T_PROGRAMS
  is '专业培养方案';
comment on column T_PROGRAMS.id
  is '非业务主键';
comment on column T_PROGRAMS.created_at
  is '创建时间';
comment on column T_PROGRAMS.updated_at
  is '更新时间';
comment on column T_PROGRAMS.audit_state
  is '审核状态';
comment on column T_PROGRAMS.duration
  is '学制';
comment on column T_PROGRAMS.effective_on
  is '开始日期';
comment on column T_PROGRAMS.grade
  is '年级';
comment on column T_PROGRAMS.invalid_on
  is '结束日期 结束日期包括在有效期内';
comment on column T_PROGRAMS.name
  is '名称';
comment on column T_PROGRAMS.remark
  is '备注';
comment on column T_PROGRAMS.degree_id
  is '毕业授予学位 ID ###引用表名是GB_DEGREES### ';
comment on column T_PROGRAMS.department_id
  is '部门 ID ###引用表名是C_DEPARTMENTS### ';
comment on column T_PROGRAMS.direction_id
  is '专业方向 ID ###引用表名是C_DIRECTIONS### ';
comment on column T_PROGRAMS.education_id
  is '培养层次 ID ###引用表名是HB_EDUCATIONS### ';
comment on column T_PROGRAMS.major_id
  is '专业 ID ###引用表名是C_MAJORS### ';
comment on column T_PROGRAMS.std_type_id
  is '学生类别 ID ###引用表名是XB_STD_TYPES### ';
comment on column T_PROGRAMS.study_type_id
  is '学习形式 ID ###引用表名是GB_STUDY_TYPES### ';
alter table T_PROGRAMS
  add primary key (ID);
alter table T_PROGRAMS
  add constraint FK_3JT371GRUJNWIKIPWXG32SD96 foreign key (MAJOR_ID)
  references C_MAJORS (ID);
alter table T_PROGRAMS
  add constraint FK_722JVH5EL9LM56NJ4VEUXX5OG foreign key (STD_TYPE_ID)
  references XB_STD_TYPES (ID);
alter table T_PROGRAMS
  add constraint FK_7BWN5QNJF6PNP2BNBR4CEXB6S foreign key (DEGREE_ID)
  references GB_DEGREES (ID);
alter table T_PROGRAMS
  add constraint FK_7Y65FKE9F4YG4P7IBLKTOJXQB foreign key (DIRECTION_ID)
  references C_DIRECTIONS (ID);
alter table T_PROGRAMS
  add constraint FK_JOEYFO69K5TUDU0Y4KMW8GLI7 foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table T_PROGRAMS
  add constraint FK_QWBQIK02NY7AJ5LT13W3ADF28 foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);
alter table T_PROGRAMS
  add constraint FK_R9XT7W1A96T6STJK02SFGEJ32 foreign key (STUDY_TYPE_ID)
  references GB_STUDY_TYPES (ID);

prompt Creating T_MA_PLANS...
create table T_MA_PLANS
(
  id          NUMBER(19) not null,
  credits     FLOAT not null,
  terms_count NUMBER(10) not null,
  end_term    NUMBER(10),
  start_term  NUMBER(10),
  program_id  NUMBER(19) not null
)
;
comment on table T_MA_PLANS
  is '专业计划';
comment on column T_MA_PLANS.id
  is '非业务主键';
comment on column T_MA_PLANS.credits
  is '要求学分';
comment on column T_MA_PLANS.terms_count
  is '学期数量';
comment on column T_MA_PLANS.end_term
  is '结束学期';
comment on column T_MA_PLANS.start_term
  is '起始学期';
comment on column T_MA_PLANS.program_id
  is '培养方案 ID ###引用表名是T_PROGRAMS### ';
alter table T_MA_PLANS
  add primary key (ID);
alter table T_MA_PLANS
  add constraint FK_RX9D0LPL6RL3A7VDHFWTL4DC2 foreign key (PROGRAM_ID)
  references T_PROGRAMS (ID);

prompt Creating T_LESSON_PLAN_RELATIONS...
create table T_LESSON_PLAN_RELATIONS
(
  id         NUMBER(19) not null,
  created_at TIMESTAMP(6),
  updated_at TIMESTAMP(6),
  lesson_id  NUMBER(19) not null,
  plan_id    NUMBER(19)
)
;
comment on table T_LESSON_PLAN_RELATIONS
  is '教学任务和专业培养计划关系';
comment on column T_LESSON_PLAN_RELATIONS.id
  is '非业务主键';
comment on column T_LESSON_PLAN_RELATIONS.created_at
  is '创建时间';
comment on column T_LESSON_PLAN_RELATIONS.updated_at
  is '更新时间';
comment on column T_LESSON_PLAN_RELATIONS.lesson_id
  is '教学任务 ID ###引用表名是T_LESSONS### ';
comment on column T_LESSON_PLAN_RELATIONS.plan_id
  is '专业计划 ID ###引用表名是T_MA_PLANS### ';
alter table T_LESSON_PLAN_RELATIONS
  add primary key (ID);
alter table T_LESSON_PLAN_RELATIONS
  add constraint FK_6GR7O48I70H8BQLAJOUOB0J0X foreign key (PLAN_ID)
  references T_MA_PLANS (ID);
alter table T_LESSON_PLAN_RELATIONS
  add constraint FK_OK2ODT2SW8TY47OAQTY44KA9H foreign key (LESSON_ID)
  references T_LESSONS (ID);

prompt Creating T_MAJOR_PLAN_CG_MOD_AFTERS...
create table T_MAJOR_PLAN_CG_MOD_AFTERS
(
  id                  NUMBER(19) not null,
  course_num          NUMBER(10) not null,
  credits             FLOAT not null,
  group_id            NUMBER(19),
  relation            VARCHAR2(255 CHAR),
  remark              VARCHAR2(500 CHAR),
  term_credits        VARCHAR2(50 CHAR),
  course_type_id      NUMBER(10),
  fake_course_type_id NUMBER(10)
)
;
comment on table T_MAJOR_PLAN_CG_MOD_AFTERS
  is '专业计划课程组修改后信息';
comment on column T_MAJOR_PLAN_CG_MOD_AFTERS.id
  is '非业务主键';
comment on column T_MAJOR_PLAN_CG_MOD_AFTERS.course_num
  is '要求门数';
comment on column T_MAJOR_PLAN_CG_MOD_AFTERS.credits
  is '总学分';
comment on column T_MAJOR_PLAN_CG_MOD_AFTERS.group_id
  is '课程组ID';
comment on column T_MAJOR_PLAN_CG_MOD_AFTERS.relation
  is '子组要求';
comment on column T_MAJOR_PLAN_CG_MOD_AFTERS.remark
  is '备注';
comment on column T_MAJOR_PLAN_CG_MOD_AFTERS.term_credits
  is '课程组每学期对应学分';
comment on column T_MAJOR_PLAN_CG_MOD_AFTERS.course_type_id
  is '课程组类别 ID ###引用表名是XB_COURSE_TYPES### ';
comment on column T_MAJOR_PLAN_CG_MOD_AFTERS.fake_course_type_id
  is '课程类别 ID ###引用表名是XB_COURSE_TYPES### ';
alter table T_MAJOR_PLAN_CG_MOD_AFTERS
  add primary key (ID);
alter table T_MAJOR_PLAN_CG_MOD_AFTERS
  add constraint FK_5SWXVGO5PIT2LCDNPJJNNWORC foreign key (FAKE_COURSE_TYPE_ID)
  references XB_COURSE_TYPES (ID);
alter table T_MAJOR_PLAN_CG_MOD_AFTERS
  add constraint FK_6AE7DWD6R769PNNVV9BAML70J foreign key (COURSE_TYPE_ID)
  references XB_COURSE_TYPES (ID);

prompt Creating T_MAJOR_PLAN_CG_MOD_BEFORS...
create table T_MAJOR_PLAN_CG_MOD_BEFORS
(
  id                  NUMBER(19) not null,
  course_num          NUMBER(10) not null,
  credits             FLOAT not null,
  group_id            NUMBER(19),
  relation            VARCHAR2(255 CHAR),
  remark              VARCHAR2(500 CHAR),
  term_credits        VARCHAR2(50 CHAR),
  course_type_id      NUMBER(10),
  fake_course_type_id NUMBER(10)
)
;
comment on table T_MAJOR_PLAN_CG_MOD_BEFORS
  is '专业计划课程组修改前信息';
comment on column T_MAJOR_PLAN_CG_MOD_BEFORS.id
  is '非业务主键';
comment on column T_MAJOR_PLAN_CG_MOD_BEFORS.course_num
  is '要求门数';
comment on column T_MAJOR_PLAN_CG_MOD_BEFORS.credits
  is '总学分';
comment on column T_MAJOR_PLAN_CG_MOD_BEFORS.group_id
  is '课程组ID';
comment on column T_MAJOR_PLAN_CG_MOD_BEFORS.relation
  is '子组要求';
comment on column T_MAJOR_PLAN_CG_MOD_BEFORS.remark
  is '备注';
comment on column T_MAJOR_PLAN_CG_MOD_BEFORS.term_credits
  is '课程组每学期对应学分';
comment on column T_MAJOR_PLAN_CG_MOD_BEFORS.course_type_id
  is '课程组类别 ID ###引用表名是XB_COURSE_TYPES### ';
comment on column T_MAJOR_PLAN_CG_MOD_BEFORS.fake_course_type_id
  is '课程类别 ID ###引用表名是XB_COURSE_TYPES### ';
alter table T_MAJOR_PLAN_CG_MOD_BEFORS
  add primary key (ID);
alter table T_MAJOR_PLAN_CG_MOD_BEFORS
  add constraint FK_JVM4FWAIGCCVR4T0470YL6JT2 foreign key (FAKE_COURSE_TYPE_ID)
  references XB_COURSE_TYPES (ID);
alter table T_MAJOR_PLAN_CG_MOD_BEFORS
  add constraint FK_QW88KSC9TT841RW14H0SWIQUO foreign key (COURSE_TYPE_ID)
  references XB_COURSE_TYPES (ID);

prompt Creating T_MAJOR_PLAN_CG_MODIFIES...
create table T_MAJOR_PLAN_CG_MODIFIES
(
  id                       NUMBER(19) not null,
  apply_date               TIMESTAMP(6),
  dep_opinion              VARCHAR2(255 CHAR),
  dep_sign                 VARCHAR2(255 CHAR),
  flag                     NUMBER(10),
  plan_id                  NUMBER(19),
  practice_sign            VARCHAR2(255 CHAR),
  reason                   VARCHAR2(255 CHAR),
  reply_date               TIMESTAMP(6),
  requisition_type         VARCHAR2(255 CHAR),
  teach_opinion            VARCHAR2(255 CHAR),
  teach_sign               VARCHAR2(255 CHAR),
  assessor_id              NUMBER(19),
  department_id            NUMBER(10),
  new_plan_course_group_id NUMBER(19),
  old_plan_course_group_id NUMBER(19),
  proposer_id              NUMBER(19)
)
;
comment on table T_MAJOR_PLAN_CG_MODIFIES
  is '专业计划课程组变更申请';
comment on column T_MAJOR_PLAN_CG_MODIFIES.id
  is '非业务主键';
comment on column T_MAJOR_PLAN_CG_MODIFIES.apply_date
  is '申请时间';
comment on column T_MAJOR_PLAN_CG_MODIFIES.dep_opinion
  is '学院、系、部审核意见';
comment on column T_MAJOR_PLAN_CG_MODIFIES.dep_sign
  is '学院（部）会签';
comment on column T_MAJOR_PLAN_CG_MODIFIES.flag
  is '申请单状态';
comment on column T_MAJOR_PLAN_CG_MODIFIES.plan_id
  is '所属计划';
comment on column T_MAJOR_PLAN_CG_MODIFIES.practice_sign
  is '实践学科会签';
comment on column T_MAJOR_PLAN_CG_MODIFIES.reason
  is '更改原因';
comment on column T_MAJOR_PLAN_CG_MODIFIES.reply_date
  is '答复时间';
comment on column T_MAJOR_PLAN_CG_MODIFIES.requisition_type
  is '更改类型';
comment on column T_MAJOR_PLAN_CG_MODIFIES.teach_opinion
  is '教务处审核意见';
comment on column T_MAJOR_PLAN_CG_MODIFIES.teach_sign
  is '教学研究科会签';
comment on column T_MAJOR_PLAN_CG_MODIFIES.assessor_id
  is '审核员 ID ###引用表名是SE_USERS### ';
comment on column T_MAJOR_PLAN_CG_MODIFIES.department_id
  is '部门 ID ###引用表名是C_DEPARTMENTS### ';
comment on column T_MAJOR_PLAN_CG_MODIFIES.new_plan_course_group_id
  is '更改后的状态 ID ###引用表名是T_MAJOR_PLAN_CG_MOD_AFTERS### ';
comment on column T_MAJOR_PLAN_CG_MODIFIES.old_plan_course_group_id
  is '更改前的状态 ID ###引用表名是T_MAJOR_PLAN_CG_MOD_BEFORS### ';
comment on column T_MAJOR_PLAN_CG_MODIFIES.proposer_id
  is '申请人 ID ###引用表名是SE_USERS### ';
alter table T_MAJOR_PLAN_CG_MODIFIES
  add primary key (ID);
alter table T_MAJOR_PLAN_CG_MODIFIES
  add constraint FK_51T956L4QCYQ3FH40SOA9P98O foreign key (NEW_PLAN_COURSE_GROUP_ID)
  references T_MAJOR_PLAN_CG_MOD_AFTERS (ID);
alter table T_MAJOR_PLAN_CG_MODIFIES
  add constraint FK_89TOF7H6A3TPXBEQX1GOXBBUR foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table T_MAJOR_PLAN_CG_MODIFIES
  add constraint FK_93R2OWNC01U7KQ6QOYWT6LFP5 foreign key (PROPOSER_ID)
  references SE_USERS (ID);
alter table T_MAJOR_PLAN_CG_MODIFIES
  add constraint FK_HYQC86PW9DJ0DLFV3DDY1YAJT foreign key (OLD_PLAN_COURSE_GROUP_ID)
  references T_MAJOR_PLAN_CG_MOD_BEFORS (ID);
alter table T_MAJOR_PLAN_CG_MODIFIES
  add constraint FK_R7BLY431E48QCMSE82QVR36BC foreign key (ASSESSOR_ID)
  references SE_USERS (ID);

prompt Creating T_MAJOR_PLAN_COMMENTS...
create table T_MAJOR_PLAN_COMMENTS
(
  id            NUMBER(19) not null,
  created_at    TIMESTAMP(6),
  updated_at    TIMESTAMP(6),
  reason        VARCHAR2(200 CHAR) not null,
  major_plan_id NUMBER(19)
)
;
comment on table T_MAJOR_PLAN_COMMENTS
  is '专业培养计划审核说明';
comment on column T_MAJOR_PLAN_COMMENTS.id
  is '非业务主键';
comment on column T_MAJOR_PLAN_COMMENTS.created_at
  is '创建时间';
comment on column T_MAJOR_PLAN_COMMENTS.updated_at
  is '更新时间';
comment on column T_MAJOR_PLAN_COMMENTS.reason
  is '审核不通过原因';
comment on column T_MAJOR_PLAN_COMMENTS.major_plan_id
  is '培养计划 ID ###引用表名是T_MA_PLANS### ';
alter table T_MAJOR_PLAN_COMMENTS
  add primary key (ID);
alter table T_MAJOR_PLAN_COMMENTS
  add constraint FK_R2JFX9SE9EN1W0I25S2HFDJDS foreign key (MAJOR_PLAN_ID)
  references T_MA_PLANS (ID);

prompt Creating T_MAJOR_PLAN_C_MOD_AFTERS...
create table T_MAJOR_PLAN_C_MOD_AFTERS
(
  id                  NUMBER(19) not null,
  compulsory          NUMBER(1) not null,
  group_id            NUMBER(19),
  remark              VARCHAR2(255 CHAR),
  terms               VARCHAR2(255 CHAR),
  course_id           NUMBER(19),
  department_id       NUMBER(10),
  fake_course_type_id NUMBER(10)
)
;
comment on table T_MAJOR_PLAN_C_MOD_AFTERS
  is '专业计划课程修改后信息';
comment on column T_MAJOR_PLAN_C_MOD_AFTERS.id
  is '非业务主键';
comment on column T_MAJOR_PLAN_C_MOD_AFTERS.compulsory
  is '是否必修';
comment on column T_MAJOR_PLAN_C_MOD_AFTERS.group_id
  is '课程组ID';
comment on column T_MAJOR_PLAN_C_MOD_AFTERS.remark
  is '备注';
comment on column T_MAJOR_PLAN_C_MOD_AFTERS.terms
  is '开课的学期';
comment on column T_MAJOR_PLAN_C_MOD_AFTERS.course_id
  is '课程 ID ###引用表名是T_COURSES### ';
comment on column T_MAJOR_PLAN_C_MOD_AFTERS.department_id
  is '院系所 ID ###引用表名是C_DEPARTMENTS### ';
comment on column T_MAJOR_PLAN_C_MOD_AFTERS.fake_course_type_id
  is '课程类别 ID ###引用表名是XB_COURSE_TYPES### ';
alter table T_MAJOR_PLAN_C_MOD_AFTERS
  add primary key (ID);
alter table T_MAJOR_PLAN_C_MOD_AFTERS
  add constraint FK_9YB2OR1NFTMYYYFNPEBNNCHC3 foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table T_MAJOR_PLAN_C_MOD_AFTERS
  add constraint FK_FM71V1WQMQAQC1QEHJMKSUDG3 foreign key (COURSE_ID)
  references T_COURSES (ID);
alter table T_MAJOR_PLAN_C_MOD_AFTERS
  add constraint FK_FTLK91UIDIHTBN8SE9U7XHSO0 foreign key (FAKE_COURSE_TYPE_ID)
  references XB_COURSE_TYPES (ID);

prompt Creating T_MAJOR_PLAN_C_MOD_BEFORS...
create table T_MAJOR_PLAN_C_MOD_BEFORS
(
  id                  NUMBER(19) not null,
  compulsory          NUMBER(1) not null,
  group_id            NUMBER(19),
  remark              VARCHAR2(255 CHAR),
  terms               VARCHAR2(255 CHAR),
  course_id           NUMBER(19),
  department_id       NUMBER(10),
  fake_course_type_id NUMBER(10)
)
;
comment on table T_MAJOR_PLAN_C_MOD_BEFORS
  is '专业计划课程修改前信息';
comment on column T_MAJOR_PLAN_C_MOD_BEFORS.id
  is '非业务主键';
comment on column T_MAJOR_PLAN_C_MOD_BEFORS.compulsory
  is '是否必修';
comment on column T_MAJOR_PLAN_C_MOD_BEFORS.group_id
  is '课程组ID';
comment on column T_MAJOR_PLAN_C_MOD_BEFORS.remark
  is '备注';
comment on column T_MAJOR_PLAN_C_MOD_BEFORS.terms
  is '开课的学期';
comment on column T_MAJOR_PLAN_C_MOD_BEFORS.course_id
  is '课程 ID ###引用表名是T_COURSES### ';
comment on column T_MAJOR_PLAN_C_MOD_BEFORS.department_id
  is '院系所 ID ###引用表名是C_DEPARTMENTS### ';
comment on column T_MAJOR_PLAN_C_MOD_BEFORS.fake_course_type_id
  is '课程类别 ID ###引用表名是XB_COURSE_TYPES### ';
alter table T_MAJOR_PLAN_C_MOD_BEFORS
  add primary key (ID);
alter table T_MAJOR_PLAN_C_MOD_BEFORS
  add constraint FK_H1CGW5KTTL111MAISS2357H6Y foreign key (COURSE_ID)
  references T_COURSES (ID);
alter table T_MAJOR_PLAN_C_MOD_BEFORS
  add constraint FK_IQA0TXBN8EW4SSN4K0SGIK3ST foreign key (FAKE_COURSE_TYPE_ID)
  references XB_COURSE_TYPES (ID);
alter table T_MAJOR_PLAN_C_MOD_BEFORS
  add constraint FK_OCDOF9WJRTNXEJVDC1AOQ1OR8 foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);

prompt Creating T_MAJOR_PLAN_C_MODIFIES...
create table T_MAJOR_PLAN_C_MODIFIES
(
  id                 NUMBER(19) not null,
  apply_date         TIMESTAMP(6),
  dep_opinion        VARCHAR2(255 CHAR),
  dep_sign           VARCHAR2(255 CHAR),
  flag               NUMBER(10),
  plan_id            NUMBER(19),
  practice_sign      VARCHAR2(255 CHAR),
  reason             VARCHAR2(255 CHAR),
  reply_date         TIMESTAMP(6),
  requisition_type   VARCHAR2(255 CHAR),
  teach_opinion      VARCHAR2(255 CHAR),
  teach_sign         VARCHAR2(255 CHAR),
  assessor_id        NUMBER(19),
  department_id      NUMBER(10),
  new_plan_course_id NUMBER(19),
  old_plan_course_id NUMBER(19),
  proposer_id        NUMBER(19)
)
;
comment on table T_MAJOR_PLAN_C_MODIFIES
  is '专业计划课程修改';
comment on column T_MAJOR_PLAN_C_MODIFIES.id
  is '非业务主键';
comment on column T_MAJOR_PLAN_C_MODIFIES.apply_date
  is '申请时间';
comment on column T_MAJOR_PLAN_C_MODIFIES.dep_opinion
  is '学院、系、部审核意见';
comment on column T_MAJOR_PLAN_C_MODIFIES.dep_sign
  is '学院（部）会签';
comment on column T_MAJOR_PLAN_C_MODIFIES.flag
  is '申请单状态';
comment on column T_MAJOR_PLAN_C_MODIFIES.plan_id
  is '专业计划';
comment on column T_MAJOR_PLAN_C_MODIFIES.practice_sign
  is '实践学科会签';
comment on column T_MAJOR_PLAN_C_MODIFIES.reason
  is '更改原因';
comment on column T_MAJOR_PLAN_C_MODIFIES.reply_date
  is '答复时间';
comment on column T_MAJOR_PLAN_C_MODIFIES.requisition_type
  is '更改类型';
comment on column T_MAJOR_PLAN_C_MODIFIES.teach_opinion
  is '教务处审核意见';
comment on column T_MAJOR_PLAN_C_MODIFIES.teach_sign
  is '教学研究科会签';
comment on column T_MAJOR_PLAN_C_MODIFIES.assessor_id
  is '审核员 ID ###引用表名是SE_USERS### ';
comment on column T_MAJOR_PLAN_C_MODIFIES.department_id
  is '学院（部） ID ###引用表名是C_DEPARTMENTS### ';
comment on column T_MAJOR_PLAN_C_MODIFIES.new_plan_course_id
  is '更改后的状态 ID ###引用表名是T_MAJOR_PLAN_C_MOD_AFTERS### ';
comment on column T_MAJOR_PLAN_C_MODIFIES.old_plan_course_id
  is '更改前的状态 ID ###引用表名是T_MAJOR_PLAN_C_MOD_BEFORS### ';
comment on column T_MAJOR_PLAN_C_MODIFIES.proposer_id
  is '申请人 ID ###引用表名是SE_USERS### ';
alter table T_MAJOR_PLAN_C_MODIFIES
  add primary key (ID);
alter table T_MAJOR_PLAN_C_MODIFIES
  add constraint FK_10MX1F17GR8TTNHMS4GH2I64E foreign key (OLD_PLAN_COURSE_ID)
  references T_MAJOR_PLAN_C_MOD_BEFORS (ID);
alter table T_MAJOR_PLAN_C_MODIFIES
  add constraint FK_14GG78DTHGY7JC8CND4IO4GNF foreign key (ASSESSOR_ID)
  references SE_USERS (ID);
alter table T_MAJOR_PLAN_C_MODIFIES
  add constraint FK_8AUKT28CCL5AWVH0CA5S6EI37 foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table T_MAJOR_PLAN_C_MODIFIES
  add constraint FK_B47GWIOXFA0C4F2FNPYXCIJL8 foreign key (NEW_PLAN_COURSE_ID)
  references T_MAJOR_PLAN_C_MOD_AFTERS (ID);
alter table T_MAJOR_PLAN_C_MODIFIES
  add constraint FK_RMHJANS1FQO037T7OWY4JA2EV foreign key (PROPOSER_ID)
  references SE_USERS (ID);

prompt Creating T_MAJOR_PLAN_C_MOD_AFT_C_H...
create table T_MAJOR_PLAN_C_MOD_AFT_C_H
(
  major_plan_c_mod_aft_id NUMBER(19) not null,
  course_hour             NUMBER(10),
  course_hour_type_id     NUMBER(10) not null
)
;
comment on table T_MAJOR_PLAN_C_MOD_AFT_C_H
  is '专业计划课程修改后信息-各类课时';
comment on column T_MAJOR_PLAN_C_MOD_AFT_C_H.major_plan_c_mod_aft_id
  is '专业计划课程修改后信息 ID ###引用表名是T_MAJOR_PLAN_C_MOD_AFTERS### ';
alter table T_MAJOR_PLAN_C_MOD_AFT_C_H
  add primary key (MAJOR_PLAN_C_MOD_AFT_ID, COURSE_HOUR_TYPE_ID);
alter table T_MAJOR_PLAN_C_MOD_AFT_C_H
  add constraint FK_IVPE2A2UWDCL7OU1HF2VI2UXR foreign key (MAJOR_PLAN_C_MOD_AFT_ID)
  references T_MAJOR_PLAN_C_MOD_AFTERS (ID);

prompt Creating T_MAJOR_PLAN_C_MOD_BEF_C_H...
create table T_MAJOR_PLAN_C_MOD_BEF_C_H
(
  major_plan_c_mod_bef_id NUMBER(19) not null,
  course_hour             NUMBER(10),
  course_hour_type_id     NUMBER(10) not null
)
;
comment on table T_MAJOR_PLAN_C_MOD_BEF_C_H
  is '专业计划课程修改前信息-各类课时';
comment on column T_MAJOR_PLAN_C_MOD_BEF_C_H.major_plan_c_mod_bef_id
  is '专业计划课程修改前信息 ID ###引用表名是T_MAJOR_PLAN_C_MOD_BEFORS### ';
alter table T_MAJOR_PLAN_C_MOD_BEF_C_H
  add primary key (MAJOR_PLAN_C_MOD_BEF_ID, COURSE_HOUR_TYPE_ID);
alter table T_MAJOR_PLAN_C_MOD_BEF_C_H
  add constraint FK_8OUWKVE0PIG2BOUQM961191RH foreign key (MAJOR_PLAN_C_MOD_BEF_ID)
  references T_MAJOR_PLAN_C_MOD_BEFORS (ID);

prompt Creating T_MA_COURSE_SUBS...
create table T_MA_COURSE_SUBS
(
  id            NUMBER(19) not null,
  created_at    TIMESTAMP(6),
  updated_at    TIMESTAMP(6),
  grades        VARCHAR2(100 CHAR) not null,
  remark        VARCHAR2(300 CHAR),
  department_id NUMBER(10),
  direction_id  NUMBER(10),
  education_id  NUMBER(10) not null,
  major_id      NUMBER(10),
  project_id    NUMBER(10) not null,
  std_type_id   NUMBER(10)
)
;
comment on table T_MA_COURSE_SUBS
  is '专业替代课程';
comment on column T_MA_COURSE_SUBS.id
  is '非业务主键';
comment on column T_MA_COURSE_SUBS.created_at
  is '创建时间';
comment on column T_MA_COURSE_SUBS.updated_at
  is '更新时间';
comment on column T_MA_COURSE_SUBS.grades
  is '年级';
comment on column T_MA_COURSE_SUBS.remark
  is '备注';
comment on column T_MA_COURSE_SUBS.department_id
  is '院系 ID ###引用表名是C_DEPARTMENTS### ';
comment on column T_MA_COURSE_SUBS.direction_id
  is '方向 ID ###引用表名是C_DIRECTIONS### ';
comment on column T_MA_COURSE_SUBS.education_id
  is '学历层次 ID ###引用表名是HB_EDUCATIONS### ';
comment on column T_MA_COURSE_SUBS.major_id
  is '专业 ID ###引用表名是C_MAJORS### ';
comment on column T_MA_COURSE_SUBS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column T_MA_COURSE_SUBS.std_type_id
  is '学生类别 ID ###引用表名是XB_STD_TYPES### ';
alter table T_MA_COURSE_SUBS
  add primary key (ID);
alter table T_MA_COURSE_SUBS
  add constraint FK_1DEYR4LAFLSM4QOGJECUQ2JAP foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);
alter table T_MA_COURSE_SUBS
  add constraint FK_D3VXX42VSF0OSS85UXRNDX16G foreign key (MAJOR_ID)
  references C_MAJORS (ID);
alter table T_MA_COURSE_SUBS
  add constraint FK_FG9DW2L0O3IMG1U9A3HS4NJEM foreign key (DIRECTION_ID)
  references C_DIRECTIONS (ID);
alter table T_MA_COURSE_SUBS
  add constraint FK_G62U5F36350VO219JH5YBLHOB foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table T_MA_COURSE_SUBS
  add constraint FK_O6RPAES1YAHP6JB34S723T7PY foreign key (STD_TYPE_ID)
  references XB_STD_TYPES (ID);
alter table T_MA_COURSE_SUBS
  add constraint FK_QSHBMSPQ9D96YTECBKCJ1FGAK foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);

prompt Creating T_MA_COURSE_SUBS_ORIGS...
create table T_MA_COURSE_SUBS_ORIGS
(
  t_ma_course_subs_id NUMBER(19) not null,
  course_id           NUMBER(19) not null
)
;
comment on table T_MA_COURSE_SUBS_ORIGS
  is '专业替代课程-被替代的课程';
comment on column T_MA_COURSE_SUBS_ORIGS.t_ma_course_subs_id
  is '专业替代课程 ID ###引用表名是T_MA_COURSE_SUBS### ';
comment on column T_MA_COURSE_SUBS_ORIGS.course_id
  is '课程基本信息 ID ###引用表名是T_COURSES### ';
alter table T_MA_COURSE_SUBS_ORIGS
  add primary key (T_MA_COURSE_SUBS_ID, COURSE_ID);
alter table T_MA_COURSE_SUBS_ORIGS
  add constraint FK_DGKN5UOMXEDHFRPVLW0QWYSLA foreign key (T_MA_COURSE_SUBS_ID)
  references T_MA_COURSE_SUBS (ID);
alter table T_MA_COURSE_SUBS_ORIGS
  add constraint FK_JJ9XIEDH6KL0TLOUQOEEN6MQR foreign key (COURSE_ID)
  references T_COURSES (ID);

prompt Creating T_MA_COURSE_SUBS_SUBS...
create table T_MA_COURSE_SUBS_SUBS
(
  t_ma_course_subs_id NUMBER(19) not null,
  course_id           NUMBER(19) not null
)
;
comment on table T_MA_COURSE_SUBS_SUBS
  is '专业替代课程-已替代的课程';
comment on column T_MA_COURSE_SUBS_SUBS.t_ma_course_subs_id
  is '专业替代课程 ID ###引用表名是T_MA_COURSE_SUBS### ';
comment on column T_MA_COURSE_SUBS_SUBS.course_id
  is '课程基本信息 ID ###引用表名是T_COURSES### ';
alter table T_MA_COURSE_SUBS_SUBS
  add primary key (T_MA_COURSE_SUBS_ID, COURSE_ID);
alter table T_MA_COURSE_SUBS_SUBS
  add constraint FK_D6XKIWYIU2EVUI77GM0QIJ8E5 foreign key (T_MA_COURSE_SUBS_ID)
  references T_MA_COURSE_SUBS (ID);
alter table T_MA_COURSE_SUBS_SUBS
  add constraint FK_KMIQS6833OTWU9WLK5GRSH2VK foreign key (COURSE_ID)
  references T_COURSES (ID);

prompt Creating T_SHR_PLANS...
create table T_SHR_PLANS
(
  id           NUMBER(19) not null,
  credits      FLOAT not null,
  terms_count  NUMBER(10) not null,
  created_at   TIMESTAMP(6),
  effective_on DATE not null,
  invalid_on   DATE,
  name         VARCHAR2(255 CHAR) not null,
  updated_at   TIMESTAMP(6),
  education_id NUMBER(10),
  project_id   NUMBER(10) not null
)
;
comment on table T_SHR_PLANS
  is '公共共享计划';
comment on column T_SHR_PLANS.id
  is '非业务主键';
comment on column T_SHR_PLANS.credits
  is '要求学分';
comment on column T_SHR_PLANS.terms_count
  is '学期数量';
comment on column T_SHR_PLANS.created_at
  is '创建时间';
comment on column T_SHR_PLANS.effective_on
  is '开始日期';
comment on column T_SHR_PLANS.invalid_on
  is '结束日期 结束日期包括在有效期内';
comment on column T_SHR_PLANS.name
  is '名称';
comment on column T_SHR_PLANS.updated_at
  is '最后修改时间';
comment on column T_SHR_PLANS.education_id
  is '培养层次 ID ###引用表名是HB_EDUCATIONS### ';
comment on column T_SHR_PLANS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
alter table T_SHR_PLANS
  add primary key (ID);
alter table T_SHR_PLANS
  add constraint FK_E5HPUAWMVS4AOY88GWT8LLDMN foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);
alter table T_SHR_PLANS
  add constraint FK_IO8SJLRBFLXRIVAAQDHLC4VHA foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating T_SHR_PLAN_C_GROUPS...
create table T_SHR_PLAN_C_GROUPS
(
  id             NUMBER(19) not null,
  course_num     NUMBER(10) not null,
  credits        FLOAT not null,
  indexno        VARCHAR2(30 CHAR) not null,
  relation       VARCHAR2(255 CHAR),
  remark         VARCHAR2(2000 CHAR),
  term_credits   VARCHAR2(255 CHAR),
  course_type_id NUMBER(10) not null,
  language_id    NUMBER(10),
  parent_id      NUMBER(19),
  plan_id        NUMBER(19)
)
;
comment on table T_SHR_PLAN_C_GROUPS
  is '公共共享课程组(默认实现)';
comment on column T_SHR_PLAN_C_GROUPS.id
  is '非业务主键';
comment on column T_SHR_PLAN_C_GROUPS.course_num
  is '要求门数';
comment on column T_SHR_PLAN_C_GROUPS.credits
  is '要求学分';
comment on column T_SHR_PLAN_C_GROUPS.indexno
  is 'index no';
comment on column T_SHR_PLAN_C_GROUPS.relation
  is '下级组关系';
comment on column T_SHR_PLAN_C_GROUPS.remark
  is '备注';
comment on column T_SHR_PLAN_C_GROUPS.term_credits
  is '学期学分分布';
comment on column T_SHR_PLAN_C_GROUPS.course_type_id
  is '课程类别 ID ###引用表名是XB_COURSE_TYPES### ';
comment on column T_SHR_PLAN_C_GROUPS.language_id
  is '对应外语语种 ID ###引用表名是GB_LANGUAGES### ';
comment on column T_SHR_PLAN_C_GROUPS.parent_id
  is '上级组 ID ###引用表名是T_SHR_PLAN_C_GROUPS### ';
comment on column T_SHR_PLAN_C_GROUPS.plan_id
  is '公共共享计划 ID ###引用表名是T_SHR_PLANS### ';
alter table T_SHR_PLAN_C_GROUPS
  add primary key (ID);
alter table T_SHR_PLAN_C_GROUPS
  add constraint FK_1SVX52HFX5WSNRM35TL67BU7F foreign key (LANGUAGE_ID)
  references GB_LANGUAGES (ID);
alter table T_SHR_PLAN_C_GROUPS
  add constraint FK_7JRHDBWU31VB4TJSUSMWUCUR5 foreign key (PARENT_ID)
  references T_SHR_PLAN_C_GROUPS (ID);
alter table T_SHR_PLAN_C_GROUPS
  add constraint FK_IDD93LQGB8DRTCFYKYM3FRJFM foreign key (PLAN_ID)
  references T_SHR_PLANS (ID);
alter table T_SHR_PLAN_C_GROUPS
  add constraint FK_OCYPFI5B5QDTCGGKEOFHRGGJN foreign key (COURSE_TYPE_ID)
  references XB_COURSE_TYPES (ID);

prompt Creating T_MA_PLAN_C_GROUPS...
create table T_MA_PLAN_C_GROUPS
(
  id                    NUMBER(19) not null,
  course_num            NUMBER(10) not null,
  credits               FLOAT not null,
  indexno               VARCHAR2(30 CHAR) not null,
  relation              VARCHAR2(255 CHAR),
  remark                VARCHAR2(2000 CHAR),
  term_credits          VARCHAR2(255 CHAR),
  micro_name            VARCHAR2(40 CHAR),
  course_type_id        NUMBER(10) not null,
  direction_id          NUMBER(10),
  parent_id             NUMBER(19),
  plan_id               NUMBER(19) not null,
  share_course_group_id NUMBER(19)
)
;
comment on table T_MA_PLAN_C_GROUPS
  is '专业计划课程组.';
comment on column T_MA_PLAN_C_GROUPS.id
  is '非业务主键';
comment on column T_MA_PLAN_C_GROUPS.course_num
  is '要求门数';
comment on column T_MA_PLAN_C_GROUPS.credits
  is '要求学分';
comment on column T_MA_PLAN_C_GROUPS.indexno
  is 'index no';
comment on column T_MA_PLAN_C_GROUPS.relation
  is '下级组关系';
comment on column T_MA_PLAN_C_GROUPS.remark
  is '备注';
comment on column T_MA_PLAN_C_GROUPS.term_credits
  is '学期学分分布';
comment on column T_MA_PLAN_C_GROUPS.micro_name
  is '自定义名称';
comment on column T_MA_PLAN_C_GROUPS.course_type_id
  is '课程类别 ID ###引用表名是XB_COURSE_TYPES### ';
comment on column T_MA_PLAN_C_GROUPS.direction_id
  is '该组针对的专业方向 ID ###引用表名是C_DIRECTIONS### ';
comment on column T_MA_PLAN_C_GROUPS.parent_id
  is '上级组 ID ###引用表名是T_MA_PLAN_C_GROUPS### ';
comment on column T_MA_PLAN_C_GROUPS.plan_id
  is '专业计划 ID ###引用表名是T_MA_PLANS### ';
comment on column T_MA_PLAN_C_GROUPS.share_course_group_id
  is '引用组 ID ###引用表名是T_SHR_PLAN_C_GROUPS### ';
alter table T_MA_PLAN_C_GROUPS
  add primary key (ID);
alter table T_MA_PLAN_C_GROUPS
  add constraint FK_1GNQWMMCVAOGUV6ES91081OL foreign key (COURSE_TYPE_ID)
  references XB_COURSE_TYPES (ID);
alter table T_MA_PLAN_C_GROUPS
  add constraint FK_A9K4QJ6U141K905IP4SFP4AD3 foreign key (PARENT_ID)
  references T_MA_PLAN_C_GROUPS (ID);
alter table T_MA_PLAN_C_GROUPS
  add constraint FK_AHQNSARPXX6A45N7BVSND6C54 foreign key (PLAN_ID)
  references T_MA_PLANS (ID);
alter table T_MA_PLAN_C_GROUPS
  add constraint FK_BHS2K0220M0S2H188R50ECYL7 foreign key (DIRECTION_ID)
  references C_DIRECTIONS (ID);
alter table T_MA_PLAN_C_GROUPS
  add constraint FK_FK3DPNEB1PXIXGI11QW05LWWR foreign key (SHARE_COURSE_GROUP_ID)
  references T_SHR_PLAN_C_GROUPS (ID);

prompt Creating T_MA_PLAN_COURSES...
create table T_MA_PLAN_COURSES
(
  id              NUMBER(19) not null,
  compulsory      NUMBER(1) not null,
  remark          VARCHAR2(500 CHAR),
  terms           VARCHAR2(255 CHAR) not null,
  course_id       NUMBER(19) not null,
  department_id   NUMBER(10) not null,
  exam_mode_id    NUMBER(10),
  course_group_id NUMBER(19) not null
)
;
comment on table T_MA_PLAN_COURSES
  is '专业计划课程';
comment on column T_MA_PLAN_COURSES.id
  is '非业务主键';
comment on column T_MA_PLAN_COURSES.compulsory
  is '是否必修';
comment on column T_MA_PLAN_COURSES.remark
  is '备注';
comment on column T_MA_PLAN_COURSES.terms
  is '开课学期';
comment on column T_MA_PLAN_COURSES.course_id
  is '课程 ID ###引用表名是T_COURSES### ';
comment on column T_MA_PLAN_COURSES.department_id
  is '院系所 ID ###引用表名是C_DEPARTMENTS### ';
comment on column T_MA_PLAN_COURSES.exam_mode_id
  is '考核方式 ID ###引用表名是HB_EXAM_MODES### ';
comment on column T_MA_PLAN_COURSES.course_group_id
  is '课程组 ID ###引用表名是T_MA_PLAN_C_GROUPS### ';
alter table T_MA_PLAN_COURSES
  add primary key (ID);
alter table T_MA_PLAN_COURSES
  add constraint FK_4A1TXDA1CF9G9JEDLO2U7HVX7 foreign key (COURSE_ID)
  references T_COURSES (ID);
alter table T_MA_PLAN_COURSES
  add constraint FK_BO6PCY1K2AV5MRGPPONC6Q3Q5 foreign key (EXAM_MODE_ID)
  references HB_EXAM_MODES (ID);
alter table T_MA_PLAN_COURSES
  add constraint FK_FEX8M59M9ANT6PIKG91889GTG foreign key (COURSE_GROUP_ID)
  references T_MA_PLAN_C_GROUPS (ID);
alter table T_MA_PLAN_COURSES
  add constraint FK_IOMUITOH2N47DNVCHVBGFYCAU foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);

prompt Creating T_MA_PLAN_C_GROUPS_REQ_CORS...
create table T_MA_PLAN_C_GROUPS_REQ_CORS
(
  t_ma_plan_c_groups_id NUMBER(19) not null,
  course_id             NUMBER(19) not null
)
;
comment on table T_MA_PLAN_C_GROUPS_REQ_CORS
  is '专业计划课程组.-必修课程.';
comment on column T_MA_PLAN_C_GROUPS_REQ_CORS.t_ma_plan_c_groups_id
  is '专业计划课程组. ID ###引用表名是T_MA_PLAN_C_GROUPS### ';
comment on column T_MA_PLAN_C_GROUPS_REQ_CORS.course_id
  is '课程基本信息 ID ###引用表名是T_COURSES### ';
alter table T_MA_PLAN_C_GROUPS_REQ_CORS
  add primary key (T_MA_PLAN_C_GROUPS_ID, COURSE_ID);
alter table T_MA_PLAN_C_GROUPS_REQ_CORS
  add constraint FK_1PN26K0V07740MYJFJSULHR2F foreign key (COURSE_ID)
  references T_COURSES (ID);
alter table T_MA_PLAN_C_GROUPS_REQ_CORS
  add constraint FK_2MR8KYMQSQMTG5C06IKN8N9I5 foreign key (T_MA_PLAN_C_GROUPS_ID)
  references T_MA_PLAN_C_GROUPS (ID);

prompt Creating T_MA_PLAN_C_GROUPS_XCL_CORS...
create table T_MA_PLAN_C_GROUPS_XCL_CORS
(
  t_ma_plan_c_groups_id NUMBER(19) not null,
  course_id             NUMBER(19) not null
)
;
comment on table T_MA_PLAN_C_GROUPS_XCL_CORS
  is '专业计划课程组.-排除课程.';
comment on column T_MA_PLAN_C_GROUPS_XCL_CORS.t_ma_plan_c_groups_id
  is '专业计划课程组. ID ###引用表名是T_MA_PLAN_C_GROUPS### ';
comment on column T_MA_PLAN_C_GROUPS_XCL_CORS.course_id
  is '课程基本信息 ID ###引用表名是T_COURSES### ';
alter table T_MA_PLAN_C_GROUPS_XCL_CORS
  add primary key (T_MA_PLAN_C_GROUPS_ID, COURSE_ID);
alter table T_MA_PLAN_C_GROUPS_XCL_CORS
  add constraint FK_2VETO0NBE7MAQIPTIYRT8MVPN foreign key (T_MA_PLAN_C_GROUPS_ID)
  references T_MA_PLAN_C_GROUPS (ID);
alter table T_MA_PLAN_C_GROUPS_XCL_CORS
  add constraint FK_IG4BD6A8DFKFKWPLFFGID9AX5 foreign key (COURSE_ID)
  references T_COURSES (ID);

prompt Creating T_NORMAL_CLASSES...
create table T_NORMAL_CLASSES
(
  id           NUMBER(19) not null,
  created_at   TIMESTAMP(6),
  updated_at   TIMESTAMP(6),
  code         VARCHAR2(32 CHAR) not null,
  effective_at TIMESTAMP(6) not null,
  grade        VARCHAR2(10 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  education_id NUMBER(10) not null,
  project_id   NUMBER(10) not null
)
;
comment on table T_NORMAL_CLASSES
  is '常规教学班实现';
comment on column T_NORMAL_CLASSES.id
  is '非业务主键';
comment on column T_NORMAL_CLASSES.created_at
  is '创建时间';
comment on column T_NORMAL_CLASSES.updated_at
  is '更新时间';
comment on column T_NORMAL_CLASSES.code
  is '班级代码';
comment on column T_NORMAL_CLASSES.effective_at
  is '生效时间';
comment on column T_NORMAL_CLASSES.grade
  is '年级';
comment on column T_NORMAL_CLASSES.invalid_at
  is '失效时间';
comment on column T_NORMAL_CLASSES.name
  is '名称';
comment on column T_NORMAL_CLASSES.education_id
  is '培养层次 ID ###引用表名是HB_EDUCATIONS### ';
comment on column T_NORMAL_CLASSES.project_id
  is '所在项目 ID ###引用表名是C_PROJECTS### ';
alter table T_NORMAL_CLASSES
  add primary key (ID);
alter table T_NORMAL_CLASSES
  add constraint UK_J6D10W8JQDIV21TO3P4P675JC unique (CODE);
alter table T_NORMAL_CLASSES
  add constraint FK_44MCUMCNX4N0DVJ7J4O1ESTJ foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);
alter table T_NORMAL_CLASSES
  add constraint FK_BPDPCH18VAX2VSFUK96SSPNWS foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating T_NORMAL_CLASSES_STUDENTS...
create table T_NORMAL_CLASSES_STUDENTS
(
  normal_class_id NUMBER(19) not null,
  student_id      NUMBER(19) not null
)
;
comment on table T_NORMAL_CLASSES_STUDENTS
  is '常规教学班实现-学生名单';
comment on column T_NORMAL_CLASSES_STUDENTS.normal_class_id
  is '常规教学班实现 ID ###引用表名是T_NORMAL_CLASSES### ';
comment on column T_NORMAL_CLASSES_STUDENTS.student_id
  is '学籍信息实现 ID ###引用表名是C_STUDENTS### ';
alter table T_NORMAL_CLASSES_STUDENTS
  add primary key (NORMAL_CLASS_ID, STUDENT_ID);
alter table T_NORMAL_CLASSES_STUDENTS
  add constraint FK_ABD1P4VGX077N0CNNSMACOOVU foreign key (NORMAL_CLASS_ID)
  references T_NORMAL_CLASSES (ID);
alter table T_NORMAL_CLASSES_STUDENTS
  add constraint FK_H29H5A0VF4E8H0PJ94M17I619 foreign key (STUDENT_ID)
  references C_STUDENTS (ID);

prompt Creating T_NOT_PASS_CREDIT_STATSS...
create table T_NOT_PASS_CREDIT_STATSS
(
  id             NUMBER(19) not null,
  credit         FLOAT,
  course_id      NUMBER(19),
  course_type_id NUMBER(10),
  std_id         NUMBER(19)
)
;
comment on table T_NOT_PASS_CREDIT_STATSS
  is '不及格学分统计';
comment on column T_NOT_PASS_CREDIT_STATSS.id
  is '非业务主键';
comment on column T_NOT_PASS_CREDIT_STATSS.credit
  is '学分';
comment on column T_NOT_PASS_CREDIT_STATSS.course_id
  is '课程 ID ###引用表名是T_COURSES### ';
comment on column T_NOT_PASS_CREDIT_STATSS.course_type_id
  is '课程类别 ID ###引用表名是XB_COURSE_TYPES### ';
comment on column T_NOT_PASS_CREDIT_STATSS.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table T_NOT_PASS_CREDIT_STATSS
  add primary key (ID);
alter table T_NOT_PASS_CREDIT_STATSS
  add constraint FK_KC3GYRY4O9JOTL29852FGO3HR foreign key (COURSE_ID)
  references T_COURSES (ID);
alter table T_NOT_PASS_CREDIT_STATSS
  add constraint FK_OWNBCSI1KG6SCFG1SFXMGIDXH foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table T_NOT_PASS_CREDIT_STATSS
  add constraint FK_RYO06D1RQC5J4D0AAN1JPLJSV foreign key (COURSE_TYPE_ID)
  references XB_COURSE_TYPES (ID);

prompt Creating T_OFF_CAMPUS_TUTORS...
create table T_OFF_CAMPUS_TUTORS
(
  id           NUMBER(19) not null,
  name         VARCHAR2(50 CHAR),
  organization VARCHAR2(100 CHAR),
  title_id     NUMBER(10)
)
;
comment on table T_OFF_CAMPUS_TUTORS
  is '校外导师';
comment on column T_OFF_CAMPUS_TUTORS.id
  is '非业务主键';
comment on column T_OFF_CAMPUS_TUTORS.name
  is '姓名';
comment on column T_OFF_CAMPUS_TUTORS.organization
  is '单位';
comment on column T_OFF_CAMPUS_TUTORS.title_id
  is '职称 ID ###引用表名是GB_TEACHER_TITLES### ';
alter table T_OFF_CAMPUS_TUTORS
  add primary key (ID);
alter table T_OFF_CAMPUS_TUTORS
  add constraint FK_MCPXJQ64U4BNMHHP6MMC5PDMR foreign key (TITLE_ID)
  references GB_TEACHER_TITLES (ID);

prompt Creating T_ORI_PLANS...
create table T_ORI_PLANS
(
  id          NUMBER(19) not null,
  credits     FLOAT not null,
  terms_count NUMBER(10) not null,
  end_term    NUMBER(10),
  start_term  NUMBER(10),
  program_id  NUMBER(19) not null
)
;
comment on table T_ORI_PLANS
  is '原始计划';
comment on column T_ORI_PLANS.id
  is '非业务主键';
comment on column T_ORI_PLANS.credits
  is '要求学分';
comment on column T_ORI_PLANS.terms_count
  is '学期数量';
comment on column T_ORI_PLANS.end_term
  is '结束学期';
comment on column T_ORI_PLANS.start_term
  is '起始学期';
comment on column T_ORI_PLANS.program_id
  is '培养方案 ID ###引用表名是T_PROGRAMS### ';
alter table T_ORI_PLANS
  add primary key (ID);
alter table T_ORI_PLANS
  add constraint FK_T41YM76E69TAJ1UH0JOABEEMY foreign key (PROGRAM_ID)
  references T_PROGRAMS (ID);

prompt Creating T_ORI_PLAN_C_GROUPS...
create table T_ORI_PLAN_C_GROUPS
(
  id                    NUMBER(19) not null,
  course_num            NUMBER(10) not null,
  credits               FLOAT not null,
  indexno               VARCHAR2(30 CHAR) not null,
  relation              VARCHAR2(255 CHAR),
  remark                VARCHAR2(2000 CHAR),
  term_credits          VARCHAR2(255 CHAR),
  micro_name            VARCHAR2(100 CHAR),
  course_type_id        NUMBER(10) not null,
  direction_id          NUMBER(10),
  parent_id             NUMBER(19),
  plan_id               NUMBER(19) not null,
  share_course_group_id NUMBER(19)
)
;
comment on table T_ORI_PLAN_C_GROUPS
  is '原始计划的课程组';
comment on column T_ORI_PLAN_C_GROUPS.id
  is '非业务主键';
comment on column T_ORI_PLAN_C_GROUPS.course_num
  is '要求门数';
comment on column T_ORI_PLAN_C_GROUPS.credits
  is '要求学分';
comment on column T_ORI_PLAN_C_GROUPS.indexno
  is 'index no';
comment on column T_ORI_PLAN_C_GROUPS.relation
  is '下级组关系';
comment on column T_ORI_PLAN_C_GROUPS.remark
  is '备注';
comment on column T_ORI_PLAN_C_GROUPS.term_credits
  is '学期学分分布';
comment on column T_ORI_PLAN_C_GROUPS.micro_name
  is '自定义组名';
comment on column T_ORI_PLAN_C_GROUPS.course_type_id
  is '课程类别 ID ###引用表名是XB_COURSE_TYPES### ';
comment on column T_ORI_PLAN_C_GROUPS.direction_id
  is '该组针对的专业方向 ID ###引用表名是C_DIRECTIONS### ';
comment on column T_ORI_PLAN_C_GROUPS.parent_id
  is '上级组 ID ###引用表名是T_ORI_PLAN_C_GROUPS### ';
comment on column T_ORI_PLAN_C_GROUPS.plan_id
  is '培养方案 ID ###引用表名是T_ORI_PLANS### ';
comment on column T_ORI_PLAN_C_GROUPS.share_course_group_id
  is '引用组 ID ###引用表名是T_SHR_PLAN_C_GROUPS### ';
alter table T_ORI_PLAN_C_GROUPS
  add primary key (ID);
alter table T_ORI_PLAN_C_GROUPS
  add constraint FK_7QEAVKPNHHHW22LBFS24DI9PL foreign key (PARENT_ID)
  references T_ORI_PLAN_C_GROUPS (ID);
alter table T_ORI_PLAN_C_GROUPS
  add constraint FK_AJS1M9K2QVIWM8JN3HDJYHS9L foreign key (PLAN_ID)
  references T_ORI_PLANS (ID);
alter table T_ORI_PLAN_C_GROUPS
  add constraint FK_FHHRTV8XXUCLS2RTXSS86R886 foreign key (DIRECTION_ID)
  references C_DIRECTIONS (ID);
alter table T_ORI_PLAN_C_GROUPS
  add constraint FK_N97GNBR9EJK0FD4DRKP8RBHDN foreign key (SHARE_COURSE_GROUP_ID)
  references T_SHR_PLAN_C_GROUPS (ID);
alter table T_ORI_PLAN_C_GROUPS
  add constraint FK_OV2KF2LEFRK0MIYJIGUJCM6DO foreign key (COURSE_TYPE_ID)
  references XB_COURSE_TYPES (ID);

prompt Creating T_ORI_PLAN_COURSES...
create table T_ORI_PLAN_COURSES
(
  id              NUMBER(19) not null,
  compulsory      NUMBER(1) not null,
  remark          VARCHAR2(500 CHAR),
  terms           VARCHAR2(255 CHAR) not null,
  course_id       NUMBER(19) not null,
  department_id   NUMBER(10) not null,
  exam_mode_id    NUMBER(10),
  course_group_id NUMBER(19) not null
)
;
comment on table T_ORI_PLAN_COURSES
  is '原始计划的计划课程';
comment on column T_ORI_PLAN_COURSES.id
  is '非业务主键';
comment on column T_ORI_PLAN_COURSES.compulsory
  is '是否必修';
comment on column T_ORI_PLAN_COURSES.remark
  is '备注';
comment on column T_ORI_PLAN_COURSES.terms
  is '开课学期';
comment on column T_ORI_PLAN_COURSES.course_id
  is '课程 ID ###引用表名是T_COURSES### ';
comment on column T_ORI_PLAN_COURSES.department_id
  is '院系所 ID ###引用表名是C_DEPARTMENTS### ';
comment on column T_ORI_PLAN_COURSES.exam_mode_id
  is '考核方式 ID ###引用表名是HB_EXAM_MODES### ';
comment on column T_ORI_PLAN_COURSES.course_group_id
  is '课程组 ID ###引用表名是T_ORI_PLAN_C_GROUPS### ';
alter table T_ORI_PLAN_COURSES
  add primary key (ID);
alter table T_ORI_PLAN_COURSES
  add constraint FK_6N0XWH10XDM4RFR1VT8I2L0LC foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table T_ORI_PLAN_COURSES
  add constraint FK_9QQSKJXPPQ7T5XKFX1755Y3N8 foreign key (COURSE_ID)
  references T_COURSES (ID);
alter table T_ORI_PLAN_COURSES
  add constraint FK_IEU0H2Q5MWNFJ2CIC9LJXXNM0 foreign key (EXAM_MODE_ID)
  references HB_EXAM_MODES (ID);
alter table T_ORI_PLAN_COURSES
  add constraint FK_LWNWU3VNPAE0AQ4L79Y4WP011 foreign key (COURSE_GROUP_ID)
  references T_ORI_PLAN_C_GROUPS (ID);

prompt Creating T_ORI_PLAN_C_GROUPS_REQ_CORS...
create table T_ORI_PLAN_C_GROUPS_REQ_CORS
(
  t_ori_plan_c_groups_id NUMBER(19) not null,
  course_id              NUMBER(19) not null
)
;
comment on table T_ORI_PLAN_C_GROUPS_REQ_CORS
  is '原始计划的课程组-必修课程.';
comment on column T_ORI_PLAN_C_GROUPS_REQ_CORS.t_ori_plan_c_groups_id
  is '原始计划的课程组 ID ###引用表名是T_ORI_PLAN_C_GROUPS### ';
comment on column T_ORI_PLAN_C_GROUPS_REQ_CORS.course_id
  is '课程基本信息 ID ###引用表名是T_COURSES### ';
alter table T_ORI_PLAN_C_GROUPS_REQ_CORS
  add primary key (T_ORI_PLAN_C_GROUPS_ID, COURSE_ID);
alter table T_ORI_PLAN_C_GROUPS_REQ_CORS
  add constraint FK_E7OMJB5RWO6F07111KG09BO1C foreign key (T_ORI_PLAN_C_GROUPS_ID)
  references T_ORI_PLAN_C_GROUPS (ID);
alter table T_ORI_PLAN_C_GROUPS_REQ_CORS
  add constraint FK_SXBAU4UIJU70WJYBYP7817WWJ foreign key (COURSE_ID)
  references T_COURSES (ID);

prompt Creating T_ORI_PLAN_C_GROUPS_XCL_CORS...
create table T_ORI_PLAN_C_GROUPS_XCL_CORS
(
  t_ori_plan_c_groups_id NUMBER(19) not null,
  course_id              NUMBER(19) not null
)
;
comment on table T_ORI_PLAN_C_GROUPS_XCL_CORS
  is '原始计划的课程组-排除课程.';
comment on column T_ORI_PLAN_C_GROUPS_XCL_CORS.t_ori_plan_c_groups_id
  is '原始计划的课程组 ID ###引用表名是T_ORI_PLAN_C_GROUPS### ';
comment on column T_ORI_PLAN_C_GROUPS_XCL_CORS.course_id
  is '课程基本信息 ID ###引用表名是T_COURSES### ';
alter table T_ORI_PLAN_C_GROUPS_XCL_CORS
  add primary key (T_ORI_PLAN_C_GROUPS_ID, COURSE_ID);
alter table T_ORI_PLAN_C_GROUPS_XCL_CORS
  add constraint FK_AU7GFT2CONWTJVW5CNASC56B foreign key (COURSE_ID)
  references T_COURSES (ID);
alter table T_ORI_PLAN_C_GROUPS_XCL_CORS
  add constraint FK_B7D5GY5NV44BNJJMEF87HQN7C foreign key (T_ORI_PLAN_C_GROUPS_ID)
  references T_ORI_PLAN_C_GROUPS (ID);

prompt Creating T_OTHER_EXAM_CONFIGS_CAMPUSES...
create table T_OTHER_EXAM_CONFIGS_CAMPUSES
(
  t_other_exam_configs_id NUMBER(19) not null,
  campus_id               NUMBER(10) not null
)
;
comment on table T_OTHER_EXAM_CONFIGS_CAMPUSES
  is '校外考试报名设置（期号）-报名校区';
comment on column T_OTHER_EXAM_CONFIGS_CAMPUSES.t_other_exam_configs_id
  is '校外考试报名设置（期号） ID ###引用表名是T_OTHER_EXAM_CONFIGS### ';
comment on column T_OTHER_EXAM_CONFIGS_CAMPUSES.campus_id
  is '校区信息 ID ###引用表名是C_CAMPUSES### ';
alter table T_OTHER_EXAM_CONFIGS_CAMPUSES
  add primary key (T_OTHER_EXAM_CONFIGS_ID, CAMPUS_ID);
alter table T_OTHER_EXAM_CONFIGS_CAMPUSES
  add constraint FK_1C19S4Y0I9XIUYRHIB4BC2DBD foreign key (CAMPUS_ID)
  references C_CAMPUSES (ID);
alter table T_OTHER_EXAM_CONFIGS_CAMPUSES
  add constraint FK_HUVYY88HSUFEOA3R5AXHW9M36 foreign key (T_OTHER_EXAM_CONFIGS_ID)
  references T_OTHER_EXAM_CONFIGS (ID);

prompt Creating T_OTHER_EXAM_LOGGERS...
create table T_OTHER_EXAM_LOGGERS
(
  id          NUMBER(19) not null,
  created_at  TIMESTAMP(6),
  updated_at  TIMESTAMP(6),
  action_type VARCHAR2(255 CHAR) not null,
  code        VARCHAR2(255 CHAR) not null,
  log_at      TIMESTAMP(6) not null,
  remote_addr VARCHAR2(255 CHAR) not null,
  semester    VARCHAR2(255 CHAR) not null,
  std_code    VARCHAR2(255 CHAR) not null,
  subject     VARCHAR2(255 CHAR) not null
)
;
comment on table T_OTHER_EXAM_LOGGERS
  is '校外考试报名日志';
comment on column T_OTHER_EXAM_LOGGERS.id
  is '非业务主键';
comment on column T_OTHER_EXAM_LOGGERS.created_at
  is '创建时间';
comment on column T_OTHER_EXAM_LOGGERS.updated_at
  is '更新时间';
comment on column T_OTHER_EXAM_LOGGERS.action_type
  is '操作类型';
comment on column T_OTHER_EXAM_LOGGERS.code
  is '操作人ID';
comment on column T_OTHER_EXAM_LOGGERS.log_at
  is '操作时间';
comment on column T_OTHER_EXAM_LOGGERS.remote_addr
  is '客户端IP';
comment on column T_OTHER_EXAM_LOGGERS.semester
  is '考试期号';
comment on column T_OTHER_EXAM_LOGGERS.std_code
  is '被操作学生学号';
comment on column T_OTHER_EXAM_LOGGERS.subject
  is '报名科目';
alter table T_OTHER_EXAM_LOGGERS
  add primary key (ID);

prompt Creating T_OTHER_EXAM_SETTINGS...
create table T_OTHER_EXAM_SETTINGS
(
  id               NUMBER(19) not null,
  begin_at         TIMESTAMP(6) not null,
  end_at           TIMESTAMP(6) not null,
  fee_of_material  FLOAT,
  fee_of_outline   FLOAT,
  fee_of_sign_up   FLOAT not null,
  field_visable    NUMBER(1),
  grade            VARCHAR2(150 CHAR),
  grade_permited   NUMBER(1) not null,
  have_paid        NUMBER(1) not null,
  max_std          NUMBER(10),
  re_exam_allowed  NUMBER(1) not null,
  config_id        NUMBER(19) not null,
  subject_id       NUMBER(10) not null,
  super_subject_id NUMBER(10)
)
;
comment on table T_OTHER_EXAM_SETTINGS
  is '校外考试报名科目设置';
comment on column T_OTHER_EXAM_SETTINGS.id
  is '非业务主键';
comment on column T_OTHER_EXAM_SETTINGS.begin_at
  is '开始时间';
comment on column T_OTHER_EXAM_SETTINGS.end_at
  is '结束时间';
comment on column T_OTHER_EXAM_SETTINGS.fee_of_material
  is '要求材料费';
comment on column T_OTHER_EXAM_SETTINGS.fee_of_outline
  is '要求考纲费';
comment on column T_OTHER_EXAM_SETTINGS.fee_of_sign_up
  is '要求报名费';
comment on column T_OTHER_EXAM_SETTINGS.field_visable
  is '是否显示字段';
comment on column T_OTHER_EXAM_SETTINGS.grade
  is '考试报名学生的限制年级';
comment on column T_OTHER_EXAM_SETTINGS.grade_permited
  is '年级开放或者禁止';
comment on column T_OTHER_EXAM_SETTINGS.have_paid
  is '是否缴费';
comment on column T_OTHER_EXAM_SETTINGS.max_std
  is '最大学生数(0或者null表示不限制)';
comment on column T_OTHER_EXAM_SETTINGS.re_exam_allowed
  is '通过后是否可以重考';
comment on column T_OTHER_EXAM_SETTINGS.config_id
  is '报名设置(期号) ID ###引用表名是T_OTHER_EXAM_CONFIGS### ';
comment on column T_OTHER_EXAM_SETTINGS.subject_id
  is '报名科目 ID ###引用表名是HB_OTHER_EXAM_SUBJECTS### ';
comment on column T_OTHER_EXAM_SETTINGS.super_subject_id
  is '报名时要求通过的科目 ID ###引用表名是HB_OTHER_EXAM_SUBJECTS### ';
alter table T_OTHER_EXAM_SETTINGS
  add primary key (ID);
alter table T_OTHER_EXAM_SETTINGS
  add constraint FK_5TKFT7I3OJ2FJASNC5WFQMLAH foreign key (SUBJECT_ID)
  references HB_OTHER_EXAM_SUBJECTS (ID);
alter table T_OTHER_EXAM_SETTINGS
  add constraint FK_BX8H2YWC2AJ8GCFK165R7OI0Y foreign key (CONFIG_ID)
  references T_OTHER_EXAM_CONFIGS (ID);
alter table T_OTHER_EXAM_SETTINGS
  add constraint FK_E2FV9GKKI8GGIPC5QG1N6I9U2 foreign key (SUPER_SUBJECT_ID)
  references HB_OTHER_EXAM_SUBJECTS (ID);

prompt Creating T_OTHER_EXAM_SETTINGS_FB_STDS...
create table T_OTHER_EXAM_SETTINGS_FB_STDS
(
  t_other_exam_settings_id NUMBER(19) not null,
  student_id               NUMBER(19) not null
)
;
comment on table T_OTHER_EXAM_SETTINGS_FB_STDS
  is '校外考试报名科目设置-黑名单';
comment on column T_OTHER_EXAM_SETTINGS_FB_STDS.t_other_exam_settings_id
  is '校外考试报名科目设置 ID ###引用表名是T_OTHER_EXAM_SETTINGS### ';
comment on column T_OTHER_EXAM_SETTINGS_FB_STDS.student_id
  is '学籍信息实现 ID ###引用表名是C_STUDENTS### ';
alter table T_OTHER_EXAM_SETTINGS_FB_STDS
  add primary key (T_OTHER_EXAM_SETTINGS_ID, STUDENT_ID);
alter table T_OTHER_EXAM_SETTINGS_FB_STDS
  add constraint UK_5YU6739FC75UKIBD6JCAAIQ4J unique (STUDENT_ID);
alter table T_OTHER_EXAM_SETTINGS_FB_STDS
  add constraint FK_5YU6739FC75UKIBD6JCAAIQ4J foreign key (STUDENT_ID)
  references C_STUDENTS (ID);
alter table T_OTHER_EXAM_SETTINGS_FB_STDS
  add constraint FK_EV7FASBFX3E19LRQV70Y3Y47J foreign key (T_OTHER_EXAM_SETTINGS_ID)
  references T_OTHER_EXAM_SETTINGS (ID);

prompt Creating T_OTHER_EXAM_SETTINGS_PM_STDS...
create table T_OTHER_EXAM_SETTINGS_PM_STDS
(
  t_other_exam_settings_id NUMBER(19) not null,
  student_id               NUMBER(19) not null
)
;
comment on table T_OTHER_EXAM_SETTINGS_PM_STDS
  is '校外考试报名科目设置-白名单';
comment on column T_OTHER_EXAM_SETTINGS_PM_STDS.t_other_exam_settings_id
  is '校外考试报名科目设置 ID ###引用表名是T_OTHER_EXAM_SETTINGS### ';
comment on column T_OTHER_EXAM_SETTINGS_PM_STDS.student_id
  is '学籍信息实现 ID ###引用表名是C_STUDENTS### ';
alter table T_OTHER_EXAM_SETTINGS_PM_STDS
  add primary key (T_OTHER_EXAM_SETTINGS_ID, STUDENT_ID);
alter table T_OTHER_EXAM_SETTINGS_PM_STDS
  add constraint UK_OA5HYCFX2NVXXE2N7AQST98OD unique (STUDENT_ID);
alter table T_OTHER_EXAM_SETTINGS_PM_STDS
  add constraint FK_LS82GMB4I70QM4OCLQ2FNQ4YP foreign key (T_OTHER_EXAM_SETTINGS_ID)
  references T_OTHER_EXAM_SETTINGS (ID);
alter table T_OTHER_EXAM_SETTINGS_PM_STDS
  add constraint FK_OA5HYCFX2NVXXE2N7AQST98OD foreign key (STUDENT_ID)
  references C_STUDENTS (ID);

prompt Creating T_OTHER_EXAM_SIGN_UPS...
create table T_OTHER_EXAM_SIGN_UPS
(
  id              NUMBER(19) not null,
  exam_no         VARCHAR2(32 CHAR),
  fee_of_material FLOAT,
  fee_of_outline  FLOAT,
  fee_of_sign_up  FLOAT,
  sign_up_at      TIMESTAMP(6) not null,
  take_bus        NUMBER(1) not null,
  bill_id         NUMBER(19),
  campus_id       NUMBER(10),
  pay_state_id    NUMBER(10) not null,
  semester_id     NUMBER(10) not null,
  std_id          NUMBER(19) not null,
  subject_id      NUMBER(10) not null
)
;
comment on table T_OTHER_EXAM_SIGN_UPS
  is '校外考试报名记录';
comment on column T_OTHER_EXAM_SIGN_UPS.id
  is '非业务主键';
comment on column T_OTHER_EXAM_SIGN_UPS.exam_no
  is '准考证号码';
comment on column T_OTHER_EXAM_SIGN_UPS.fee_of_material
  is '材料费';
comment on column T_OTHER_EXAM_SIGN_UPS.fee_of_outline
  is '考纲费';
comment on column T_OTHER_EXAM_SIGN_UPS.fee_of_sign_up
  is '报名费';
comment on column T_OTHER_EXAM_SIGN_UPS.sign_up_at
  is '报名时间';
comment on column T_OTHER_EXAM_SIGN_UPS.take_bus
  is '是否乘坐校车';
comment on column T_OTHER_EXAM_SIGN_UPS.bill_id
  is '账单 ID ###引用表名是F_BILLS### ';
comment on column T_OTHER_EXAM_SIGN_UPS.campus_id
  is '校区 ID ###引用表名是C_CAMPUSES### ';
comment on column T_OTHER_EXAM_SIGN_UPS.pay_state_id
  is '缴费状态 ID ###引用表名是HB_PAY_STATES### ';
comment on column T_OTHER_EXAM_SIGN_UPS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
comment on column T_OTHER_EXAM_SIGN_UPS.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
comment on column T_OTHER_EXAM_SIGN_UPS.subject_id
  is '报名科目 ID ###引用表名是HB_OTHER_EXAM_SUBJECTS### ';
alter table T_OTHER_EXAM_SIGN_UPS
  add primary key (ID);
alter table T_OTHER_EXAM_SIGN_UPS
  add constraint FK_1VEGT7AIHW4WOVXCLHD7PCB9Y foreign key (BILL_ID)
  references F_BILLS (ID);
alter table T_OTHER_EXAM_SIGN_UPS
  add constraint FK_293QQNFAJIHKK8MLUD7NFKSR2 foreign key (SUBJECT_ID)
  references HB_OTHER_EXAM_SUBJECTS (ID);
alter table T_OTHER_EXAM_SIGN_UPS
  add constraint FK_FANRPJHLBITVDPW6TO53E8QFR foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table T_OTHER_EXAM_SIGN_UPS
  add constraint FK_FO0E5BYM5SA35JPHQTLSYWYU3 foreign key (CAMPUS_ID)
  references C_CAMPUSES (ID);
alter table T_OTHER_EXAM_SIGN_UPS
  add constraint FK_M17HEVN0J9VYLM4UP942NPNX6 foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_OTHER_EXAM_SIGN_UPS
  add constraint FK_V02JCIB9NX2QFDEMUBVP9A26 foreign key (PAY_STATE_ID)
  references HB_PAY_STATES (ID);

prompt Creating T_OTHER_FEE_CONFIGS...
create table T_OTHER_FEE_CONFIGS
(
  id              NUMBER(19) not null,
  created_at      TIMESTAMP(6),
  updated_at      TIMESTAMP(6),
  close_at        TIMESTAMP(6),
  dead_line       TIMESTAMP(6),
  fee_rule_script VARCHAR2(3000 CHAR),
  fee_rule_state  VARCHAR2(1000 CHAR),
  open_at         TIMESTAMP(6),
  opened          NUMBER(1) not null,
  pay_duration    NUMBER(19),
  fee_type_id     NUMBER(10) not null,
  project_id      NUMBER(10) not null,
  semester_id     NUMBER(10) not null
)
;
comment on table T_OTHER_FEE_CONFIGS
  is '校外考试收费配置';
comment on column T_OTHER_FEE_CONFIGS.id
  is '非业务主键';
comment on column T_OTHER_FEE_CONFIGS.created_at
  is '创建时间';
comment on column T_OTHER_FEE_CONFIGS.updated_at
  is '更新时间';
comment on column T_OTHER_FEE_CONFIGS.close_at
  is '关闭时间';
comment on column T_OTHER_FEE_CONFIGS.dead_line
  is '最后截止日期';
comment on column T_OTHER_FEE_CONFIGS.fee_rule_script
  is '收费规则';
comment on column T_OTHER_FEE_CONFIGS.fee_rule_state
  is '收费规则说明';
comment on column T_OTHER_FEE_CONFIGS.open_at
  is '开放时间';
comment on column T_OTHER_FEE_CONFIGS.opened
  is '是否开放';
comment on column T_OTHER_FEE_CONFIGS.pay_duration
  is '支付周期，毫秒数';
comment on column T_OTHER_FEE_CONFIGS.fee_type_id
  is '收费项目 ID ###引用表名是XB_FEE_TYPES### ';
comment on column T_OTHER_FEE_CONFIGS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column T_OTHER_FEE_CONFIGS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
alter table T_OTHER_FEE_CONFIGS
  add primary key (ID);
alter table T_OTHER_FEE_CONFIGS
  add constraint UK_908XM3OJTIMN3QTI245OD9EGF unique (PROJECT_ID, SEMESTER_ID);
alter table T_OTHER_FEE_CONFIGS
  add constraint FK_BSGRN3GD3YCDXR0NB803OX5NX foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_OTHER_FEE_CONFIGS
  add constraint FK_CNVMA5KTPJM34O6RWFQ5848TD foreign key (FEE_TYPE_ID)
  references XB_FEE_TYPES (ID);
alter table T_OTHER_FEE_CONFIGS
  add constraint FK_KP32DF9YTVD4N45R6Q9NGWQR7 foreign key (PROJECT_ID)
  references C_PROJECTS (ID);

prompt Creating T_OTHER_GRADES...
create table T_OTHER_GRADES
(
  id                 NUMBER(19) not null,
  created_at         TIMESTAMP(6),
  updated_at         TIMESTAMP(6),
  certificate_number VARCHAR2(255 CHAR),
  exam_no            VARCHAR2(50 CHAR),
  passed             NUMBER(1) not null,
  score              FLOAT,
  score_text         VARCHAR2(255 CHAR),
  status             NUMBER(10) not null,
  mark_style_id      NUMBER(10) not null,
  semester_id        NUMBER(10) not null,
  std_id             NUMBER(19) not null,
  subject_id         NUMBER(10) not null
)
;
comment on table T_OTHER_GRADES
  is '校外考试成绩';
comment on column T_OTHER_GRADES.id
  is '非业务主键';
comment on column T_OTHER_GRADES.created_at
  is '创建时间';
comment on column T_OTHER_GRADES.updated_at
  is '更新时间';
comment on column T_OTHER_GRADES.certificate_number
  is '证书编号';
comment on column T_OTHER_GRADES.exam_no
  is '准考证号';
comment on column T_OTHER_GRADES.passed
  is '是否合格';
comment on column T_OTHER_GRADES.score
  is '得分';
comment on column T_OTHER_GRADES.score_text
  is '得分等级/等分文本内容';
comment on column T_OTHER_GRADES.status
  is '状态';
comment on column T_OTHER_GRADES.mark_style_id
  is '成绩记录方式 ID ###引用表名是HB_SCORE_MARK_STYLES### ';
comment on column T_OTHER_GRADES.semester_id
  is '教学日历 ID ###引用表名是C_SEMESTERS### ';
comment on column T_OTHER_GRADES.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
comment on column T_OTHER_GRADES.subject_id
  is '考试科目 ID ###引用表名是HB_OTHER_EXAM_SUBJECTS### ';
alter table T_OTHER_GRADES
  add primary key (ID);
alter table T_OTHER_GRADES
  add constraint UK_34T5RFC8NHLRN2TELBGWQBITS unique (STD_ID, SEMESTER_ID, SUBJECT_ID);
alter table T_OTHER_GRADES
  add constraint FK_BI7HKC1TGXDXY0R38WF3K9UN3 foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table T_OTHER_GRADES
  add constraint FK_JMS4S66EBO4DDG8XOF7CRSFAC foreign key (SUBJECT_ID)
  references HB_OTHER_EXAM_SUBJECTS (ID);
alter table T_OTHER_GRADES
  add constraint FK_L4LRH991QCHTP5COCVXSPM5GA foreign key (MARK_STYLE_ID)
  references HB_SCORE_MARK_STYLES (ID);
alter table T_OTHER_GRADES
  add constraint FK_PTTYYOCTYYJA76JJCFFOHFQY1 foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);

prompt Creating T_OTHER_GRADE_ALTER_INFOES...
create table T_OTHER_GRADE_ALTER_INFOES
(
  id           NUMBER(19) not null,
  modifier     VARCHAR2(255 CHAR),
  remark       VARCHAR2(255 CHAR),
  score_after  FLOAT,
  score_before FLOAT,
  updated_at   TIMESTAMP(6),
  grade_id     NUMBER(19)
)
;
comment on table T_OTHER_GRADE_ALTER_INFOES
  is '其他成绩修改信息';
comment on column T_OTHER_GRADE_ALTER_INFOES.id
  is '非业务主键';
comment on column T_OTHER_GRADE_ALTER_INFOES.modifier
  is '修改人';
comment on column T_OTHER_GRADE_ALTER_INFOES.remark
  is '备注';
comment on column T_OTHER_GRADE_ALTER_INFOES.score_after
  is '修改后成绩';
comment on column T_OTHER_GRADE_ALTER_INFOES.score_before
  is '修改前成绩';
comment on column T_OTHER_GRADE_ALTER_INFOES.updated_at
  is '修改于';
comment on column T_OTHER_GRADE_ALTER_INFOES.grade_id
  is '被修改的成绩 ID ###引用表名是T_OTHER_GRADES### ';
alter table T_OTHER_GRADE_ALTER_INFOES
  add primary key (ID);
alter table T_OTHER_GRADE_ALTER_INFOES
  add constraint FK_9Y7NM1XVTVKLTMKSLFQ1E5P2X foreign key (GRADE_ID)
  references T_OTHER_GRADES (ID);

prompt Creating T_PER_PLANS...
create table T_PER_PLANS
(
  id           NUMBER(19) not null,
  credits      FLOAT not null,
  terms_count  NUMBER(10) not null,
  audit_state  VARCHAR2(255 CHAR) not null,
  effective_on DATE not null,
  invalid_on   DATE,
  remark       VARCHAR2(800 CHAR),
  std_id       NUMBER(19) not null
)
;
comment on table T_PER_PLANS
  is '个人计划';
comment on column T_PER_PLANS.id
  is '非业务主键';
comment on column T_PER_PLANS.credits
  is '要求学分';
comment on column T_PER_PLANS.terms_count
  is '学期数量';
comment on column T_PER_PLANS.audit_state
  is '审核状态';
comment on column T_PER_PLANS.effective_on
  is '开始日期';
comment on column T_PER_PLANS.invalid_on
  is '结束日期 结束日期包括在有效期内';
comment on column T_PER_PLANS.remark
  is '备注';
comment on column T_PER_PLANS.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table T_PER_PLANS
  add primary key (ID);
alter table T_PER_PLANS
  add constraint FK_F3P4JR2US90W73QQ9YTIAJ5Y0 foreign key (STD_ID)
  references C_STUDENTS (ID);

prompt Creating T_PER_PLAN_C_GROUPS...
create table T_PER_PLAN_C_GROUPS
(
  id                    NUMBER(19) not null,
  course_num            NUMBER(10) not null,
  credits               FLOAT not null,
  indexno               VARCHAR2(30 CHAR) not null,
  relation              VARCHAR2(255 CHAR),
  remark                VARCHAR2(2000 CHAR),
  term_credits          VARCHAR2(255 CHAR),
  course_type_id        NUMBER(10) not null,
  parent_id             NUMBER(19),
  plan_id               NUMBER(19) not null,
  share_course_group_id NUMBER(19)
)
;
comment on table T_PER_PLAN_C_GROUPS
  is '个人计划的课程组';
comment on column T_PER_PLAN_C_GROUPS.id
  is '非业务主键';
comment on column T_PER_PLAN_C_GROUPS.course_num
  is '要求门数';
comment on column T_PER_PLAN_C_GROUPS.credits
  is '要求学分';
comment on column T_PER_PLAN_C_GROUPS.indexno
  is 'index no';
comment on column T_PER_PLAN_C_GROUPS.relation
  is '下级组关系';
comment on column T_PER_PLAN_C_GROUPS.remark
  is '备注';
comment on column T_PER_PLAN_C_GROUPS.term_credits
  is '学期学分分布';
comment on column T_PER_PLAN_C_GROUPS.course_type_id
  is '课程类别 ID ###引用表名是XB_COURSE_TYPES### ';
comment on column T_PER_PLAN_C_GROUPS.parent_id
  is '上级组 ID ###引用表名是T_PER_PLAN_C_GROUPS### ';
comment on column T_PER_PLAN_C_GROUPS.plan_id
  is '个人计划 ID ###引用表名是T_PER_PLANS### ';
comment on column T_PER_PLAN_C_GROUPS.share_course_group_id
  is '引用课程组 ID ###引用表名是T_SHR_PLAN_C_GROUPS### ';
alter table T_PER_PLAN_C_GROUPS
  add primary key (ID);
alter table T_PER_PLAN_C_GROUPS
  add constraint FK_20CAGRPXQY89W6RBURBJ43ASJ foreign key (PLAN_ID)
  references T_PER_PLANS (ID);
alter table T_PER_PLAN_C_GROUPS
  add constraint FK_GCPL9EHDKXSPYNX7WQ8UC2BQT foreign key (SHARE_COURSE_GROUP_ID)
  references T_SHR_PLAN_C_GROUPS (ID);
alter table T_PER_PLAN_C_GROUPS
  add constraint FK_IIHBCGLOH7BXJ6TOAW5VTFTOA foreign key (PARENT_ID)
  references T_PER_PLAN_C_GROUPS (ID);
alter table T_PER_PLAN_C_GROUPS
  add constraint FK_J8BGY6GN9DCEU5LCAQV1CRU1Y foreign key (COURSE_TYPE_ID)
  references XB_COURSE_TYPES (ID);

prompt Creating T_PER_PLAN_COURSES...
create table T_PER_PLAN_COURSES
(
  id              NUMBER(19) not null,
  compulsory      NUMBER(1) not null,
  remark          VARCHAR2(500 CHAR),
  terms           VARCHAR2(255 CHAR) not null,
  course_id       NUMBER(19) not null,
  department_id   NUMBER(10) not null,
  exam_mode_id    NUMBER(10),
  course_group_id NUMBER(19) not null
)
;
comment on table T_PER_PLAN_COURSES
  is '个人计划的课程';
comment on column T_PER_PLAN_COURSES.id
  is '非业务主键';
comment on column T_PER_PLAN_COURSES.compulsory
  is '是否必修';
comment on column T_PER_PLAN_COURSES.remark
  is '备注';
comment on column T_PER_PLAN_COURSES.terms
  is '开课学期';
comment on column T_PER_PLAN_COURSES.course_id
  is '课程 ID ###引用表名是T_COURSES### ';
comment on column T_PER_PLAN_COURSES.department_id
  is '院系所 ID ###引用表名是C_DEPARTMENTS### ';
comment on column T_PER_PLAN_COURSES.exam_mode_id
  is '考核方式 ID ###引用表名是HB_EXAM_MODES### ';
comment on column T_PER_PLAN_COURSES.course_group_id
  is '课程组 ID ###引用表名是T_PER_PLAN_C_GROUPS### ';
alter table T_PER_PLAN_COURSES
  add primary key (ID);
alter table T_PER_PLAN_COURSES
  add constraint FK_899KGA43L9P7WGFWQ0WG2N0PV foreign key (EXAM_MODE_ID)
  references HB_EXAM_MODES (ID);
alter table T_PER_PLAN_COURSES
  add constraint FK_HVBEHC9HC5VM73D089KM2EMD2 foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table T_PER_PLAN_COURSES
  add constraint FK_QLR6TO356MKWEILEKCR23E7O9 foreign key (COURSE_ID)
  references T_COURSES (ID);
alter table T_PER_PLAN_COURSES
  add constraint FK_QVQ2PH5625F6CSOCP5T6WB3EN foreign key (COURSE_GROUP_ID)
  references T_PER_PLAN_C_GROUPS (ID);

prompt Creating T_PER_PLAN_C_GROUPS_REQ_CORS...
create table T_PER_PLAN_C_GROUPS_REQ_CORS
(
  t_per_plan_c_groups_id NUMBER(19) not null,
  course_id              NUMBER(19) not null
)
;
comment on table T_PER_PLAN_C_GROUPS_REQ_CORS
  is '个人计划的课程组-必修课程.';
comment on column T_PER_PLAN_C_GROUPS_REQ_CORS.t_per_plan_c_groups_id
  is '个人计划的课程组 ID ###引用表名是T_PER_PLAN_C_GROUPS### ';
comment on column T_PER_PLAN_C_GROUPS_REQ_CORS.course_id
  is '课程基本信息 ID ###引用表名是T_COURSES### ';
alter table T_PER_PLAN_C_GROUPS_REQ_CORS
  add primary key (T_PER_PLAN_C_GROUPS_ID, COURSE_ID);
alter table T_PER_PLAN_C_GROUPS_REQ_CORS
  add constraint FK_FK90QQ92UR47AM7LC4IXS72OG foreign key (COURSE_ID)
  references T_COURSES (ID);
alter table T_PER_PLAN_C_GROUPS_REQ_CORS
  add constraint FK_N2WBHP23FVNLVBEDHWFW0UK4I foreign key (T_PER_PLAN_C_GROUPS_ID)
  references T_PER_PLAN_C_GROUPS (ID);

prompt Creating T_PER_PLAN_C_GROUPS_XCL_CORS...
create table T_PER_PLAN_C_GROUPS_XCL_CORS
(
  t_per_plan_c_groups_id NUMBER(19) not null,
  course_id              NUMBER(19) not null
)
;
comment on table T_PER_PLAN_C_GROUPS_XCL_CORS
  is '个人计划的课程组-排除课程.';
comment on column T_PER_PLAN_C_GROUPS_XCL_CORS.t_per_plan_c_groups_id
  is '个人计划的课程组 ID ###引用表名是T_PER_PLAN_C_GROUPS### ';
comment on column T_PER_PLAN_C_GROUPS_XCL_CORS.course_id
  is '课程基本信息 ID ###引用表名是T_COURSES### ';
alter table T_PER_PLAN_C_GROUPS_XCL_CORS
  add primary key (T_PER_PLAN_C_GROUPS_ID, COURSE_ID);
alter table T_PER_PLAN_C_GROUPS_XCL_CORS
  add constraint FK_MJHQYADJWI32I8YOI5DGDWR0L foreign key (T_PER_PLAN_C_GROUPS_ID)
  references T_PER_PLAN_C_GROUPS (ID);
alter table T_PER_PLAN_C_GROUPS_XCL_CORS
  add constraint FK_RVEQTKPOKGVE8G8I2CTJOF3CL foreign key (COURSE_ID)
  references T_COURSES (ID);

prompt Creating T_PROGRAM_DOCS...
create table T_PROGRAM_DOCS
(
  id         NUMBER(19) not null,
  created_at TIMESTAMP(6),
  updated_at TIMESTAMP(6),
  locale     VARCHAR2(255 CHAR) not null,
  program_id NUMBER(19) not null
)
;
comment on table T_PROGRAM_DOCS
  is '培养方案文档';
comment on column T_PROGRAM_DOCS.id
  is '非业务主键';
comment on column T_PROGRAM_DOCS.created_at
  is '创建时间';
comment on column T_PROGRAM_DOCS.updated_at
  is '更新时间';
comment on column T_PROGRAM_DOCS.locale
  is '针对语言';
comment on column T_PROGRAM_DOCS.program_id
  is '培养方案 ID ###引用表名是T_PROGRAMS### ';
alter table T_PROGRAM_DOCS
  add primary key (ID);
alter table T_PROGRAM_DOCS
  add constraint FK_S0E1HVARQH4QFCE4JJ10UR2VS foreign key (PROGRAM_ID)
  references T_PROGRAMS (ID);

prompt Creating T_PROGRAM_DOC_TEMPLATES...
create table T_PROGRAM_DOC_TEMPLATES
(
  id           NUMBER(19) not null,
  created_at   TIMESTAMP(6),
  updated_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  invalid_at   TIMESTAMP(6),
  locale       VARCHAR2(255 CHAR) not null,
  name         VARCHAR2(50 CHAR) not null,
  project_id   NUMBER(10),
  education_id NUMBER(10) not null
)
;
comment on table T_PROGRAM_DOC_TEMPLATES
  is '培养方案模板';
comment on column T_PROGRAM_DOC_TEMPLATES.id
  is '非业务主键';
comment on column T_PROGRAM_DOC_TEMPLATES.created_at
  is '创建时间';
comment on column T_PROGRAM_DOC_TEMPLATES.updated_at
  is '更新时间';
comment on column T_PROGRAM_DOC_TEMPLATES.effective_at
  is '生效日期';
comment on column T_PROGRAM_DOC_TEMPLATES.invalid_at
  is '失效日期';
comment on column T_PROGRAM_DOC_TEMPLATES.locale
  is '针对语言';
comment on column T_PROGRAM_DOC_TEMPLATES.name
  is '模板名称';
comment on column T_PROGRAM_DOC_TEMPLATES.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column T_PROGRAM_DOC_TEMPLATES.education_id
  is '学历层次 ID ###引用表名是HB_EDUCATIONS### ';
alter table T_PROGRAM_DOC_TEMPLATES
  add primary key (ID);
alter table T_PROGRAM_DOC_TEMPLATES
  add constraint FK_9H7OY3TGDG5YL2A0NNHD410OU foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table T_PROGRAM_DOC_TEMPLATES
  add constraint FK_HA1G7RD4FJA8TQI2V0S5W9YKI foreign key (EDUCATION_ID)
  references HB_EDUCATIONS (ID);

prompt Creating T_PROGRAM_DOC_METAS...
create table T_PROGRAM_DOC_METAS
(
  id          NUMBER(19) not null,
  indexno     NUMBER(10) not null,
  maxlength   NUMBER(10) not null,
  name        VARCHAR2(100 CHAR) not null,
  template_id NUMBER(19) not null
)
;
comment on table T_PROGRAM_DOC_METAS
  is '培养方案中的章节定义';
comment on column T_PROGRAM_DOC_METAS.id
  is '非业务主键';
comment on column T_PROGRAM_DOC_METAS.indexno
  is '顺序号';
comment on column T_PROGRAM_DOC_METAS.maxlength
  is '最大长度';
comment on column T_PROGRAM_DOC_METAS.name
  is '名称';
comment on column T_PROGRAM_DOC_METAS.template_id
  is '模板 ID ###引用表名是T_PROGRAM_DOC_TEMPLATES### ';
alter table T_PROGRAM_DOC_METAS
  add primary key (ID);
alter table T_PROGRAM_DOC_METAS
  add constraint FK_SYXM4BLPW833XQACFD9GTKPP9 foreign key (TEMPLATE_ID)
  references T_PROGRAM_DOC_TEMPLATES (ID);

prompt Creating T_PROGRAM_DOC_SECTIONS...
create table T_PROGRAM_DOC_SECTIONS
(
  id        NUMBER(19) not null,
  code      VARCHAR2(20 CHAR) not null,
  content   VARCHAR2(3000 CHAR),
  name      VARCHAR2(100 CHAR) not null,
  doc_id    NUMBER(19) not null,
  parent_id NUMBER(19)
)
;
comment on table T_PROGRAM_DOC_SECTIONS
  is '培养计划文档章节';
comment on column T_PROGRAM_DOC_SECTIONS.id
  is '非业务主键';
comment on column T_PROGRAM_DOC_SECTIONS.code
  is '内部编码';
comment on column T_PROGRAM_DOC_SECTIONS.content
  is '内容';
comment on column T_PROGRAM_DOC_SECTIONS.name
  is '标题';
comment on column T_PROGRAM_DOC_SECTIONS.doc_id
  is '文档 ID ###引用表名是T_PROGRAM_DOCS### ';
comment on column T_PROGRAM_DOC_SECTIONS.parent_id
  is '上级章节 ID ###引用表名是T_PROGRAM_DOC_SECTIONS### ';
alter table T_PROGRAM_DOC_SECTIONS
  add primary key (ID);
alter table T_PROGRAM_DOC_SECTIONS
  add constraint FK_4KM7LE1BEXMAN3RSIFLPP7G0A foreign key (DOC_ID)
  references T_PROGRAM_DOCS (ID);
alter table T_PROGRAM_DOC_SECTIONS
  add constraint FK_JVJAFHLOTPOWOPKFBDLWEWIV1 foreign key (PARENT_ID)
  references T_PROGRAM_DOC_SECTIONS (ID);

prompt Creating T_PROGRAM_DOC_TEMPLATES_TYPES...
create table T_PROGRAM_DOC_TEMPLATES_TYPES
(
  program_doc_template_id NUMBER(19) not null,
  std_type_id             NUMBER(10) not null
)
;
comment on table T_PROGRAM_DOC_TEMPLATES_TYPES
  is '培养方案模板-学生类别列表';
comment on column T_PROGRAM_DOC_TEMPLATES_TYPES.program_doc_template_id
  is '培养方案模板 ID ###引用表名是T_PROGRAM_DOC_TEMPLATES### ';
comment on column T_PROGRAM_DOC_TEMPLATES_TYPES.std_type_id
  is '学生类别 ID ###引用表名是XB_STD_TYPES### ';
alter table T_PROGRAM_DOC_TEMPLATES_TYPES
  add primary key (PROGRAM_DOC_TEMPLATE_ID, STD_TYPE_ID);
alter table T_PROGRAM_DOC_TEMPLATES_TYPES
  add constraint FK_HMH0KII31FPOVUETDX5K8XAJ3 foreign key (PROGRAM_DOC_TEMPLATE_ID)
  references T_PROGRAM_DOC_TEMPLATES (ID);
alter table T_PROGRAM_DOC_TEMPLATES_TYPES
  add constraint FK_S9TIB3M36EWG1ETBKN5JE6GRP foreign key (STD_TYPE_ID)
  references XB_STD_TYPES (ID);

prompt Creating T_RETAKE_FEE_CONFIGS...
create table T_RETAKE_FEE_CONFIGS
(
  id               NUMBER(19) not null,
  created_at       TIMESTAMP(6),
  updated_at       TIMESTAMP(6),
  close_at         TIMESTAMP(6),
  dead_line        TIMESTAMP(6),
  fee_rule_script  VARCHAR2(3000 CHAR),
  fee_rule_state   VARCHAR2(1000 CHAR),
  open_at          TIMESTAMP(6),
  opened           NUMBER(1) not null,
  pay_duration     NUMBER(19),
  price_per_credit NUMBER(10) not null,
  fee_type_id      NUMBER(10) not null,
  project_id       NUMBER(10) not null,
  semester_id      NUMBER(10) not null
)
;
comment on table T_RETAKE_FEE_CONFIGS
  is '重修收费规则';
comment on column T_RETAKE_FEE_CONFIGS.id
  is '非业务主键';
comment on column T_RETAKE_FEE_CONFIGS.created_at
  is '创建时间';
comment on column T_RETAKE_FEE_CONFIGS.updated_at
  is '更新时间';
comment on column T_RETAKE_FEE_CONFIGS.close_at
  is '关闭时间';
comment on column T_RETAKE_FEE_CONFIGS.dead_line
  is '最后截止日期';
comment on column T_RETAKE_FEE_CONFIGS.fee_rule_script
  is '收费规则';
comment on column T_RETAKE_FEE_CONFIGS.fee_rule_state
  is '收费规则说明';
comment on column T_RETAKE_FEE_CONFIGS.open_at
  is '开放时间';
comment on column T_RETAKE_FEE_CONFIGS.opened
  is '是否开放';
comment on column T_RETAKE_FEE_CONFIGS.pay_duration
  is '支付周期，毫秒数';
comment on column T_RETAKE_FEE_CONFIGS.price_per_credit
  is '每学分单价';
comment on column T_RETAKE_FEE_CONFIGS.fee_type_id
  is '收费项目 ID ###引用表名是XB_FEE_TYPES### ';
comment on column T_RETAKE_FEE_CONFIGS.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column T_RETAKE_FEE_CONFIGS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
alter table T_RETAKE_FEE_CONFIGS
  add primary key (ID);
alter table T_RETAKE_FEE_CONFIGS
  add constraint UK_I3ELWT7NN9BKYFRT0HGHVFOP1 unique (PROJECT_ID, SEMESTER_ID);
alter table T_RETAKE_FEE_CONFIGS
  add constraint FK_2JG0C8QPN3WIOAR3EEBA0LB9C foreign key (FEE_TYPE_ID)
  references XB_FEE_TYPES (ID);
alter table T_RETAKE_FEE_CONFIGS
  add constraint FK_A3HQA9JGQ3PILKULB5JY7KLDU foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table T_RETAKE_FEE_CONFIGS
  add constraint FK_AYLRTTEC9LDWPO77UM3OVIM5R foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);

prompt Creating T_SCORE_SECTIONS...
create table T_SCORE_SECTIONS
(
  id         NUMBER(19) not null,
  from_score FLOAT not null,
  to_score   FLOAT not null
)
;
comment on table T_SCORE_SECTIONS
  is '分数范围';
comment on column T_SCORE_SECTIONS.id
  is '非业务主键';
comment on column T_SCORE_SECTIONS.from_score
  is '起始分值';
comment on column T_SCORE_SECTIONS.to_score
  is '结束分值';
alter table T_SCORE_SECTIONS
  add primary key (ID);

prompt Creating T_SHR_PLAN_COURSES...
create table T_SHR_PLAN_COURSES
(
  id              NUMBER(19) not null,
  compulsory      NUMBER(1) not null,
  remark          VARCHAR2(500 CHAR),
  terms           VARCHAR2(255 CHAR) not null,
  course_id       NUMBER(19) not null,
  department_id   NUMBER(10) not null,
  exam_mode_id    NUMBER(10),
  course_group_id NUMBER(19)
)
;
comment on table T_SHR_PLAN_COURSES
  is '公共共享课程组课程';
comment on column T_SHR_PLAN_COURSES.id
  is '非业务主键';
comment on column T_SHR_PLAN_COURSES.compulsory
  is '是否必修';
comment on column T_SHR_PLAN_COURSES.remark
  is '备注';
comment on column T_SHR_PLAN_COURSES.terms
  is '开课学期';
comment on column T_SHR_PLAN_COURSES.course_id
  is '课程 ID ###引用表名是T_COURSES### ';
comment on column T_SHR_PLAN_COURSES.department_id
  is '院系所 ID ###引用表名是C_DEPARTMENTS### ';
comment on column T_SHR_PLAN_COURSES.exam_mode_id
  is '考核方式 ID ###引用表名是HB_EXAM_MODES### ';
comment on column T_SHR_PLAN_COURSES.course_group_id
  is '共享课程组 ID ###引用表名是T_SHR_PLAN_C_GROUPS### ';
alter table T_SHR_PLAN_COURSES
  add primary key (ID);
alter table T_SHR_PLAN_COURSES
  add constraint FK_J93NSK4AMSFQ3PMJMVFIX94PH foreign key (COURSE_ID)
  references T_COURSES (ID);
alter table T_SHR_PLAN_COURSES
  add constraint FK_K1FFSN0NNXK56AMXR2IEBUCGE foreign key (EXAM_MODE_ID)
  references HB_EXAM_MODES (ID);
alter table T_SHR_PLAN_COURSES
  add constraint FK_MLE4SNEOAO7SH7XSAGR7INCMU foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table T_SHR_PLAN_COURSES
  add constraint FK_TJUTJIH94SEU7RAU7HFHUERK8 foreign key (COURSE_GROUP_ID)
  references T_SHR_PLAN_C_GROUPS (ID);

prompt Creating T_STD_APPLY_LOGS...
create table T_STD_APPLY_LOGS
(
  id            NUMBER(19) not null,
  apply_on      TIMESTAMP(6) not null,
  apply_type    NUMBER(10) not null,
  course_code   VARCHAR2(255 CHAR) not null,
  course_credit FLOAT not null,
  course_name   VARCHAR2(255 CHAR) not null,
  ip            VARCHAR2(255 CHAR) not null,
  remark        VARCHAR2(255 CHAR),
  result_type   NUMBER(10) not null,
  semester_id   NUMBER(10) not null,
  std_code      VARCHAR2(255 CHAR) not null,
  std_id        NUMBER(19) not null,
  std_name      VARCHAR2(255 CHAR) not null,
  task_id       NUMBER(19) not null
)
;
comment on table T_STD_APPLY_LOGS
  is '学生选课申请日志';
comment on column T_STD_APPLY_LOGS.id
  is '非业务主键';
comment on column T_STD_APPLY_LOGS.apply_on
  is '申请的日期';
comment on column T_STD_APPLY_LOGS.apply_type
  is '申请的类型';
comment on column T_STD_APPLY_LOGS.course_code
  is '申请的课程代码';
comment on column T_STD_APPLY_LOGS.course_credit
  is '申请的课程学分';
comment on column T_STD_APPLY_LOGS.course_name
  is '申请的课程名称';
comment on column T_STD_APPLY_LOGS.ip
  is '申请的ip';
comment on column T_STD_APPLY_LOGS.remark
  is '备注';
comment on column T_STD_APPLY_LOGS.result_type
  is '申请的处理结果';
comment on column T_STD_APPLY_LOGS.semester_id
  is '申请的学期id';
comment on column T_STD_APPLY_LOGS.std_code
  is '申请的学生学号';
comment on column T_STD_APPLY_LOGS.std_id
  is '申请的学生id';
comment on column T_STD_APPLY_LOGS.std_name
  is '申请的学生姓名';
comment on column T_STD_APPLY_LOGS.task_id
  is '相关的教学任务';
alter table T_STD_APPLY_LOGS
  add primary key (ID);

prompt Creating T_STD_COURSE_ABILITIES...
create table T_STD_COURSE_ABILITIES
(
  id              NUMBER(19) not null,
  published       NUMBER(1) not null,
  score           FLOAT,
  ability_rate_id NUMBER(10) not null,
  std_id          NUMBER(19) not null
)
;
comment on table T_STD_COURSE_ABILITIES
  is '学生课程等级能力';
comment on column T_STD_COURSE_ABILITIES.id
  is '非业务主键';
comment on column T_STD_COURSE_ABILITIES.published
  is '状态，已发布/未发布，默认状态就是未发布';
comment on column T_STD_COURSE_ABILITIES.score
  is '分数';
comment on column T_STD_COURSE_ABILITIES.ability_rate_id
  is '获得英语等级，比如A级、B级、C级 ID ###引用表名是XB_COURSE_ABILITY_RATES### ';
comment on column T_STD_COURSE_ABILITIES.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table T_STD_COURSE_ABILITIES
  add primary key (ID);
alter table T_STD_COURSE_ABILITIES
  add constraint FK_AQ1YUAA8H4RER24P1S8VNO435 foreign key (ABILITY_RATE_ID)
  references XB_COURSE_ABILITY_RATES (ID);
alter table T_STD_COURSE_ABILITIES
  add constraint FK_SC04AAIVEB07S5TL4O3FR505 foreign key (STD_ID)
  references C_STUDENTS (ID);

prompt Creating T_STD_COURSE_SUBS...
create table T_STD_COURSE_SUBS
(
  id         NUMBER(19) not null,
  created_at TIMESTAMP(6),
  updated_at TIMESTAMP(6),
  remark     VARCHAR2(300 CHAR),
  std_id     NUMBER(19) not null
)
;
comment on table T_STD_COURSE_SUBS
  is '学生可代替课程实体类.';
comment on column T_STD_COURSE_SUBS.id
  is '非业务主键';
comment on column T_STD_COURSE_SUBS.created_at
  is '创建时间';
comment on column T_STD_COURSE_SUBS.updated_at
  is '更新时间';
comment on column T_STD_COURSE_SUBS.remark
  is '备注';
comment on column T_STD_COURSE_SUBS.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table T_STD_COURSE_SUBS
  add primary key (ID);
alter table T_STD_COURSE_SUBS
  add constraint FK_MJKB2C85QRS816EDX16Y92BS3 foreign key (STD_ID)
  references C_STUDENTS (ID);

prompt Creating T_STD_COURSE_SUBS_ORIGS...
create table T_STD_COURSE_SUBS_ORIGS
(
  t_std_course_subs_id NUMBER(19) not null,
  course_id            NUMBER(19) not null
)
;
comment on table T_STD_COURSE_SUBS_ORIGS
  is '学生可代替课程实体类.-被替代的课程';
comment on column T_STD_COURSE_SUBS_ORIGS.t_std_course_subs_id
  is '学生可代替课程实体类. ID ###引用表名是T_STD_COURSE_SUBS### ';
comment on column T_STD_COURSE_SUBS_ORIGS.course_id
  is '课程基本信息 ID ###引用表名是T_COURSES### ';
alter table T_STD_COURSE_SUBS_ORIGS
  add primary key (T_STD_COURSE_SUBS_ID, COURSE_ID);
alter table T_STD_COURSE_SUBS_ORIGS
  add constraint FK_NYRA65GUTGIQSQ7XT3LF9XVI8 foreign key (T_STD_COURSE_SUBS_ID)
  references T_STD_COURSE_SUBS (ID);
alter table T_STD_COURSE_SUBS_ORIGS
  add constraint FK_PN7QAO6CYG07DTAIY1P4C7JIQ foreign key (COURSE_ID)
  references T_COURSES (ID);

prompt Creating T_STD_COURSE_SUBS_SUBS...
create table T_STD_COURSE_SUBS_SUBS
(
  t_std_course_subs_id NUMBER(19) not null,
  course_id            NUMBER(19) not null
)
;
comment on table T_STD_COURSE_SUBS_SUBS
  is '学生可代替课程实体类.-已替代的课程';
comment on column T_STD_COURSE_SUBS_SUBS.t_std_course_subs_id
  is '学生可代替课程实体类. ID ###引用表名是T_STD_COURSE_SUBS### ';
comment on column T_STD_COURSE_SUBS_SUBS.course_id
  is '课程基本信息 ID ###引用表名是T_COURSES### ';
alter table T_STD_COURSE_SUBS_SUBS
  add primary key (T_STD_COURSE_SUBS_ID, COURSE_ID);
alter table T_STD_COURSE_SUBS_SUBS
  add constraint FK_A2M71CNN16B2SOTYP38XD0U03 foreign key (T_STD_COURSE_SUBS_ID)
  references T_STD_COURSE_SUBS (ID);
alter table T_STD_COURSE_SUBS_SUBS
  add constraint FK_PGGDGTBQKW9QRX8AOFM3CDDOX foreign key (COURSE_ID)
  references T_COURSES (ID);

prompt Creating T_STD_CREDIT_CONSTRAINTS...
create table T_STD_CREDIT_CONSTRAINTS
(
  id          NUMBER(19) not null,
  max_credit  FLOAT not null,
  gpa         FLOAT,
  semester_id NUMBER(10) not null,
  std_id      NUMBER(19) not null
)
;
comment on table T_STD_CREDIT_CONSTRAINTS
  is '学生个人学分上限';
comment on column T_STD_CREDIT_CONSTRAINTS.id
  is '非业务主键';
comment on column T_STD_CREDIT_CONSTRAINTS.max_credit
  is '学分上限';
comment on column T_STD_CREDIT_CONSTRAINTS.gpa
  is '平均绩点';
comment on column T_STD_CREDIT_CONSTRAINTS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
comment on column T_STD_CREDIT_CONSTRAINTS.std_id
  is '学生对象 ID ###引用表名是C_STUDENTS### ';
alter table T_STD_CREDIT_CONSTRAINTS
  add primary key (ID);
alter table T_STD_CREDIT_CONSTRAINTS
  add constraint UK_FHIIO7NMVFUCNEU6JNHM099R7 unique (SEMESTER_ID, STD_ID);
alter table T_STD_CREDIT_CONSTRAINTS
  add constraint FK_CJ2F1OYL1DO22YNPGKN2WDQ0W foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_STD_CREDIT_CONSTRAINTS
  add constraint FK_OY6XKSVXBX90PRRPBRNN6PU2Q foreign key (STD_ID)
  references C_STUDENTS (ID);

prompt Creating T_STD_GPAS...
create table T_STD_GPAS
(
  id            NUMBER(19) not null,
  created_at    TIMESTAMP(6),
  updated_at    TIMESTAMP(6),
  count         NUMBER(10) not null,
  credits       FLOAT,
  ga            FLOAT,
  gpa           FLOAT,
  total_credits FLOAT,
  std_id        NUMBER(19) not null
)
;
comment on table T_STD_GPAS
  is '学生历学期的成绩绩点';
comment on column T_STD_GPAS.id
  is '非业务主键';
comment on column T_STD_GPAS.created_at
  is '创建时间';
comment on column T_STD_GPAS.updated_at
  is '更新时间';
comment on column T_STD_GPAS.count
  is '成绩的门数';
comment on column T_STD_GPAS.credits
  is '总学分';
comment on column T_STD_GPAS.ga
  is '平均分';
comment on column T_STD_GPAS.gpa
  is '总平均绩点';
comment on column T_STD_GPAS.total_credits
  is '修读学分';
comment on column T_STD_GPAS.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table T_STD_GPAS
  add primary key (ID);
alter table T_STD_GPAS
  add constraint FK_11F8Q3SEPUT51OMA0X049C4FQ foreign key (STD_ID)
  references C_STUDENTS (ID);

prompt Creating T_STD_SEMESTER_GPAS...
create table T_STD_SEMESTER_GPAS
(
  id            NUMBER(19) not null,
  count         NUMBER(10) not null,
  credits       FLOAT,
  ga            FLOAT,
  gpa           FLOAT,
  total_credits FLOAT,
  semester_id   NUMBER(10) not null,
  std_gpa_id    NUMBER(19) not null
)
;
comment on table T_STD_SEMESTER_GPAS
  is '每学期绩点';
comment on column T_STD_SEMESTER_GPAS.id
  is '非业务主键';
comment on column T_STD_SEMESTER_GPAS.count
  is '总成绩数量';
comment on column T_STD_SEMESTER_GPAS.credits
  is '获得学分';
comment on column T_STD_SEMESTER_GPAS.ga
  is '平均分';
comment on column T_STD_SEMESTER_GPAS.gpa
  is '平均绩点';
comment on column T_STD_SEMESTER_GPAS.total_credits
  is '修读学分';
comment on column T_STD_SEMESTER_GPAS.semester_id
  is '学期 ID ###引用表名是C_SEMESTERS### ';
comment on column T_STD_SEMESTER_GPAS.std_gpa_id
  is '学生绩点 ID ###引用表名是T_STD_GPAS### ';
alter table T_STD_SEMESTER_GPAS
  add primary key (ID);
alter table T_STD_SEMESTER_GPAS
  add constraint FK_5DJUMJB2L3S5TKJM9P4GS4R05 foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_STD_SEMESTER_GPAS
  add constraint FK_OOGQWN5GRRKIGIEIASQ7B9NCK foreign key (STD_GPA_ID)
  references T_STD_GPAS (ID);

prompt Creating T_STD_TERM_CREDITS...
create table T_STD_TERM_CREDITS
(
  id            NUMBER(19) not null,
  credits       FLOAT not null,
  total_credits FLOAT not null,
  semester_id   NUMBER(10) not null,
  std_id        NUMBER(19) not null
)
;
alter table T_STD_TERM_CREDITS
  add primary key (ID);
alter table T_STD_TERM_CREDITS
  add constraint FK_PBKUB9UF1KH4667KU08A8DO70 foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table T_STD_TERM_CREDITS
  add constraint FK_RHASP5C97J7NV8PYO2H286HAF foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);

prompt Creating T_STD_TOTAL_CREDIT_CONS...
create table T_STD_TOTAL_CREDIT_CONS
(
  id         NUMBER(19) not null,
  max_credit FLOAT not null,
  std_id     NUMBER(19) not null
)
;
comment on table T_STD_TOTAL_CREDIT_CONS
  is '学生个人全程选课学分上限';
comment on column T_STD_TOTAL_CREDIT_CONS.id
  is '非业务主键';
comment on column T_STD_TOTAL_CREDIT_CONS.max_credit
  is '学分上限';
comment on column T_STD_TOTAL_CREDIT_CONS.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table T_STD_TOTAL_CREDIT_CONS
  add primary key (ID);
alter table T_STD_TOTAL_CREDIT_CONS
  add constraint FK_BB780OT6O1H5E5KEUKADKW4QD foreign key (STD_ID)
  references C_STUDENTS (ID);

prompt Creating T_STD_YEAR_GPAS...
create table T_STD_YEAR_GPAS
(
  id            NUMBER(19) not null,
  count         NUMBER(10) not null,
  credits       FLOAT,
  ga            FLOAT,
  gpa           FLOAT,
  school_year   VARCHAR2(15 CHAR),
  total_credits FLOAT,
  std_gpa_id    NUMBER(19) not null
)
;
comment on table T_STD_YEAR_GPAS
  is '学生学年绩点';
comment on column T_STD_YEAR_GPAS.id
  is '非业务主键';
comment on column T_STD_YEAR_GPAS.count
  is '总成绩数量';
comment on column T_STD_YEAR_GPAS.credits
  is '获得学分';
comment on column T_STD_YEAR_GPAS.ga
  is '平均分';
comment on column T_STD_YEAR_GPAS.gpa
  is '平均绩点';
comment on column T_STD_YEAR_GPAS.school_year
  is '学年度';
comment on column T_STD_YEAR_GPAS.total_credits
  is '修读学分';
comment on column T_STD_YEAR_GPAS.std_gpa_id
  is '学生绩点 ID ###引用表名是T_STD_GPAS### ';
alter table T_STD_YEAR_GPAS
  add primary key (ID);
alter table T_STD_YEAR_GPAS
  add constraint FK_K40N9063XPQO3Q0JN0O6PQ168 foreign key (STD_GPA_ID)
  references T_STD_GPAS (ID);

prompt Creating T_STUDENT_PROGRAMS...
create table T_STUDENT_PROGRAMS
(
  id         NUMBER(19) not null,
  created_at TIMESTAMP(6),
  updated_at TIMESTAMP(6),
  program_id NUMBER(19) not null,
  std_id     NUMBER(19) not null
)
;
comment on table T_STUDENT_PROGRAMS
  is '学生培养方案绑定';
comment on column T_STUDENT_PROGRAMS.id
  is '非业务主键';
comment on column T_STUDENT_PROGRAMS.created_at
  is '创建时间';
comment on column T_STUDENT_PROGRAMS.updated_at
  is '更新时间';
comment on column T_STUDENT_PROGRAMS.program_id
  is '培养方案 ID ###引用表名是T_PROGRAMS### ';
comment on column T_STUDENT_PROGRAMS.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table T_STUDENT_PROGRAMS
  add primary key (ID);
alter table T_STUDENT_PROGRAMS
  add constraint UK_NUFBE0HTMWEJ9LAI1LBYUGIRX unique (PROGRAM_ID, STD_ID);
alter table T_STUDENT_PROGRAMS
  add constraint FK_FA7TVJUYNDS1YCCS679PQLOML foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table T_STUDENT_PROGRAMS
  add constraint FK_KY9K3HEK4TNNMQ8H4WR5WIODO foreign key (PROGRAM_ID)
  references T_PROGRAMS (ID);

prompt Creating T_SUGGEST_ACTIVITIES...
create table T_SUGGEST_ACTIVITIES
(
  id                 NUMBER(19) not null,
  end_time           NUMBER(10),
  end_unit           NUMBER(10),
  start_time         NUMBER(10),
  start_unit         NUMBER(10),
  week_state         VARCHAR2(255 CHAR),
  week_state_num     NUMBER(19),
  weekday            NUMBER(10),
  arrange_suggest_id NUMBER(19) not null
)
;
comment on table T_SUGGEST_ACTIVITIES
  is '建议教学活动';
comment on column T_SUGGEST_ACTIVITIES.id
  is '非业务主键';
comment on column T_SUGGEST_ACTIVITIES.end_time
  is '结束时间';
comment on column T_SUGGEST_ACTIVITIES.end_unit
  is '结束小节';
comment on column T_SUGGEST_ACTIVITIES.start_time
  is '开始时间';
comment on column T_SUGGEST_ACTIVITIES.start_unit
  is '开始小节';
comment on column T_SUGGEST_ACTIVITIES.week_state
  is '周状态';
comment on column T_SUGGEST_ACTIVITIES.week_state_num
  is '周状态数字';
comment on column T_SUGGEST_ACTIVITIES.weekday
  is '星期几';
comment on column T_SUGGEST_ACTIVITIES.arrange_suggest_id
  is '教学任务 ID ###引用表名是T_ARRANGE_SUGGESTS### ';
alter table T_SUGGEST_ACTIVITIES
  add primary key (ID);
alter table T_SUGGEST_ACTIVITIES
  add constraint FK_5ASFV9TMYJVAF8L9PAQCAOTSJ foreign key (ARRANGE_SUGGEST_ID)
  references T_ARRANGE_SUGGESTS (ID);

prompt Creating T_SUGGEST_ACTIVITIES_TEACHERS...
create table T_SUGGEST_ACTIVITIES_TEACHERS
(
  suggest_activity_id NUMBER(19) not null,
  teacher_id          NUMBER(19) not null
)
;
comment on table T_SUGGEST_ACTIVITIES_TEACHERS
  is '建议教学活动-授课教师列表';
comment on column T_SUGGEST_ACTIVITIES_TEACHERS.suggest_activity_id
  is '建议教学活动 ID ###引用表名是T_SUGGEST_ACTIVITIES### ';
comment on column T_SUGGEST_ACTIVITIES_TEACHERS.teacher_id
  is '教师信息默认实现 ID ###引用表名是C_TEACHERS### ';
alter table T_SUGGEST_ACTIVITIES_TEACHERS
  add primary key (SUGGEST_ACTIVITY_ID, TEACHER_ID);
alter table T_SUGGEST_ACTIVITIES_TEACHERS
  add constraint FK_6B71L6A692KM7Y0TYUJWUEOO4 foreign key (SUGGEST_ACTIVITY_ID)
  references T_SUGGEST_ACTIVITIES (ID);
alter table T_SUGGEST_ACTIVITIES_TEACHERS
  add constraint FK_92VQVUPFXH1UI4UUXXLB2MGPH foreign key (TEACHER_ID)
  references C_TEACHERS (ID);

prompt Creating T_TEACHERBOOK_NUMS...
create table T_TEACHERBOOK_NUMS
(
  id            NUMBER(19) not null,
  num           NUMBER(10),
  course_id     NUMBER(19),
  department_id NUMBER(10),
  semester_id   NUMBER(10),
  textbook_id   NUMBER(19)
)
;
comment on table T_TEACHERBOOK_NUMS
  is '教师用书数量';
comment on column T_TEACHERBOOK_NUMS.id
  is '非业务主键';
comment on column T_TEACHERBOOK_NUMS.num
  is '教师用书数量';
comment on column T_TEACHERBOOK_NUMS.course_id
  is '课程 ID ###引用表名是T_COURSES### ';
comment on column T_TEACHERBOOK_NUMS.department_id
  is '部门 ID ###引用表名是C_DEPARTMENTS### ';
comment on column T_TEACHERBOOK_NUMS.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
comment on column T_TEACHERBOOK_NUMS.textbook_id
  is '教材 ID ###引用表名是T_TEXTBOOKS### ';
alter table T_TEACHERBOOK_NUMS
  add primary key (ID);
alter table T_TEACHERBOOK_NUMS
  add constraint FK_DPSYO34WICVR35SIMTJ3CRYTV foreign key (TEXTBOOK_ID)
  references T_TEXTBOOKS (ID);
alter table T_TEACHERBOOK_NUMS
  add constraint FK_M7N5QXUSNYDWMF692QNGNHGGR foreign key (DEPARTMENT_ID)
  references C_DEPARTMENTS (ID);
alter table T_TEACHERBOOK_NUMS
  add constraint FK_MONCV75W7RMB499JSQYSM7E2Q foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_TEACHERBOOK_NUMS
  add constraint FK_QM66B5JJ98M7H5JNJPML5APJ5 foreign key (COURSE_ID)
  references T_COURSES (ID);

prompt Creating T_TEXTBOOK_ORDER_LINES...
create table T_TEXTBOOK_ORDER_LINES
(
  id          NUMBER(19) not null,
  created_at  TIMESTAMP(6),
  updated_at  TIMESTAMP(6),
  amount      NUMBER(10),
  code        VARCHAR2(32 CHAR) not null,
  quantity    NUMBER(10) not null,
  lesson_id   NUMBER(19),
  semester_id NUMBER(10) not null,
  student_id  NUMBER(19) not null,
  textbook_id NUMBER(19) not null
)
;
comment on table T_TEXTBOOK_ORDER_LINES
  is '教材订购明细';
comment on column T_TEXTBOOK_ORDER_LINES.id
  is '非业务主键';
comment on column T_TEXTBOOK_ORDER_LINES.created_at
  is '创建时间';
comment on column T_TEXTBOOK_ORDER_LINES.updated_at
  is '更新时间';
comment on column T_TEXTBOOK_ORDER_LINES.amount
  is '应付金额';
comment on column T_TEXTBOOK_ORDER_LINES.code
  is '账单流水号码';
comment on column T_TEXTBOOK_ORDER_LINES.quantity
  is '订购教材数量';
comment on column T_TEXTBOOK_ORDER_LINES.lesson_id
  is '所选教学任务 ID ###引用表名是T_LESSONS### ';
comment on column T_TEXTBOOK_ORDER_LINES.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
comment on column T_TEXTBOOK_ORDER_LINES.student_id
  is '订购学生 ID ###引用表名是C_STUDENTS### ';
comment on column T_TEXTBOOK_ORDER_LINES.textbook_id
  is '订购教材 ID ###引用表名是T_TEXTBOOKS### ';
alter table T_TEXTBOOK_ORDER_LINES
  add primary key (ID);
alter table T_TEXTBOOK_ORDER_LINES
  add constraint FK_DBFPKJQMK7QVP59EX4PBIO0DQ foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_TEXTBOOK_ORDER_LINES
  add constraint FK_O675C9VK35QCHY13UL1S39EH8 foreign key (STUDENT_ID)
  references C_STUDENTS (ID);
alter table T_TEXTBOOK_ORDER_LINES
  add constraint FK_RAYFTT81EMO6PDG6LO7SKN4OF foreign key (LESSON_ID)
  references T_LESSONS (ID);
alter table T_TEXTBOOK_ORDER_LINES
  add constraint FK_SRDCWK2EDRXSDN1JL0ON8LV5E foreign key (TEXTBOOK_ID)
  references T_TEXTBOOKS (ID);

prompt Creating T_TEXTBOOK_PRICES...
create table T_TEXTBOOK_PRICES
(
  id             NUMBER(19) not null,
  textbook_price FLOAT,
  project_id     NUMBER(10),
  semester_id    NUMBER(10),
  textbook_id    NUMBER(19)
)
;
comment on table T_TEXTBOOK_PRICES
  is '教材价格';
comment on column T_TEXTBOOK_PRICES.id
  is '非业务主键';
comment on column T_TEXTBOOK_PRICES.textbook_price
  is '教材价格';
comment on column T_TEXTBOOK_PRICES.project_id
  is '项目 ID ###引用表名是C_PROJECTS### ';
comment on column T_TEXTBOOK_PRICES.semester_id
  is '学年学期 ID ###引用表名是C_SEMESTERS### ';
comment on column T_TEXTBOOK_PRICES.textbook_id
  is '教材 ID ###引用表名是T_TEXTBOOKS### ';
alter table T_TEXTBOOK_PRICES
  add primary key (ID);
alter table T_TEXTBOOK_PRICES
  add constraint UK_NLXTSY7G5MI2Y3PJ7VMW0YJ70 unique (TEXTBOOK_ID);
alter table T_TEXTBOOK_PRICES
  add constraint FK_5IJBB1IQD1YBPRIR8ANYFMRFH foreign key (SEMESTER_ID)
  references C_SEMESTERS (ID);
alter table T_TEXTBOOK_PRICES
  add constraint FK_AQFJAXVDFJTRH1XXJMRQDX36C foreign key (PROJECT_ID)
  references C_PROJECTS (ID);
alter table T_TEXTBOOK_PRICES
  add constraint FK_R27KEHR1QKGYURJGDMJ3M3GGK foreign key (TEXTBOOK_ID)
  references T_TEXTBOOKS (ID);

prompt Creating T_THESES...
create table T_THESES
(
  id                  NUMBER(19) not null,
  created_at          TIMESTAMP(6),
  updated_at          TIMESTAMP(6),
  duplicate_count     NUMBER(10),
  duplicate_ratio     FLOAT,
  uploaded            NUMBER(1) not null,
  filename            VARCHAR2(255 CHAR),
  subtitle            VARCHAR2(255 CHAR),
  summary             VARCHAR2(1000 CHAR),
  title               VARCHAR2(255 CHAR),
  off_campus_tutor_id NUMBER(19),
  std_id              NUMBER(19)
)
;
comment on table T_THESES
  is '论文';
comment on column T_THESES.id
  is '非业务主键';
comment on column T_THESES.created_at
  is '创建时间';
comment on column T_THESES.updated_at
  is '更新时间';
comment on column T_THESES.duplicate_count
  is '重合字数';
comment on column T_THESES.duplicate_ratio
  is '复制比';
comment on column T_THESES.uploaded
  is '是否上传';
comment on column T_THESES.filename
  is '文件名';
comment on column T_THESES.subtitle
  is '副标题';
comment on column T_THESES.summary
  is '摘要';
comment on column T_THESES.title
  is '论文题目';
comment on column T_THESES.off_campus_tutor_id
  is '校外导师 ID ###引用表名是T_OFF_CAMPUS_TUTORS### ';
comment on column T_THESES.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table T_THESES
  add primary key (ID);
alter table T_THESES
  add constraint FK_DH6UYW8WEXT64NUEL1U5XFE7U foreign key (STD_ID)
  references C_STUDENTS (ID);
alter table T_THESES
  add constraint FK_LX4MG1ODPU0Y1FUTECK6T2OSD foreign key (OFF_CAMPUS_TUTOR_ID)
  references T_OFF_CAMPUS_TUTORS (ID);

prompt Creating T_TOTAL_CREDIT_STATSS...
create table T_TOTAL_CREDIT_STATSS
(
  id         NUMBER(19) not null,
  tol_credit FLOAT,
  std_id     NUMBER(19)
)
;
comment on table T_TOTAL_CREDIT_STATSS
  is '总学分统计';
comment on column T_TOTAL_CREDIT_STATSS.id
  is '非业务主键';
comment on column T_TOTAL_CREDIT_STATSS.tol_credit
  is '总学分';
comment on column T_TOTAL_CREDIT_STATSS.std_id
  is '学生 ID ###引用表名是C_STUDENTS### ';
alter table T_TOTAL_CREDIT_STATSS
  add primary key (ID);
alter table T_TOTAL_CREDIT_STATSS
  add constraint FK_LW3TH7OPVLY11VW2O3YUW32BB foreign key (STD_ID)
  references C_STUDENTS (ID);

prompt Creating XB_COURSE_APPLY_TYPES...
create table XB_COURSE_APPLY_TYPES
(
  id           NUMBER(10) not null,
  code         VARCHAR2(32 CHAR) not null,
  created_at   TIMESTAMP(6),
  effective_at TIMESTAMP(6) not null,
  eng_name     VARCHAR2(100 CHAR),
  invalid_at   TIMESTAMP(6),
  name         VARCHAR2(100 CHAR) not null,
  updated_at   TIMESTAMP(6)
)
;
comment on table XB_COURSE_APPLY_TYPES
  is '课程申请类型';
comment on column XB_COURSE_APPLY_TYPES.id
  is '非业务主键';
comment on column XB_COURSE_APPLY_TYPES.code
  is '代码';
comment on column XB_COURSE_APPLY_TYPES.created_at
  is '创建时间';
comment on column XB_COURSE_APPLY_TYPES.effective_at
  is '生效时间';
comment on column XB_COURSE_APPLY_TYPES.eng_name
  is '英文名称';
comment on column XB_COURSE_APPLY_TYPES.invalid_at
  is '失效时间';
comment on column XB_COURSE_APPLY_TYPES.name
  is '名称';
comment on column XB_COURSE_APPLY_TYPES.updated_at
  is '修改时间';
alter table XB_COURSE_APPLY_TYPES
  add primary key (ID);
alter table XB_COURSE_APPLY_TYPES
  add constraint UK_PQ9DOMRPB9YIT5O0MHUX80PYM unique (CODE);

CREATE TABLE SE_SESSIONINFOES
(
    ID                          VARCHAR2(255) NOT NULL,
    AGENT                       VARCHAR2(50),
    CATEGORY                    VARCHAR2(50),
    EXPIRED_AT                  TIMESTAMP(6),
    FULLNAME                    VARCHAR2(50) NOT NULL,
    IP                          VARCHAR2(100),
    LAST_ACCESS_AT              TIMESTAMP(6),
    LOGIN_AT                    TIMESTAMP(6) NOT NULL,
    OS                          VARCHAR2(50),
    REMARK                      VARCHAR2(100),
    SERVER                      VARCHAR2(100),
    USERNAME                    VARCHAR2(40) NOT NULL,
    CONSTRAINT SYS_C0045641 PRIMARY KEY (ID)
);
CREATE TABLE SE_SESSIONINFO_LOGS
(
    ID                          VARCHAR2(255) NOT NULL,
    AGENT                       VARCHAR2(50),
    FULLNAME                    VARCHAR2(50) NOT NULL,
    IP                          VARCHAR2(100),
    LOGIN_AT                    TIMESTAMP(6) NOT NULL,
    LOGOUT_AT                   TIMESTAMP(6) NOT NULL,
    ONLINE_TIME                 NUMBER(19) NOT NULL,
    OS                          VARCHAR2(50),
    REMARK                      VARCHAR2(100),
    USERNAME                    VARCHAR2(40) NOT NULL,
    CONSTRAINT SYS_C0045636 PRIMARY KEY (ID)
);
CREATE TABLE SE_SESSION_STATS
(
    ID                          NUMBER(10) NOT NULL,
    CAPACITY                    NUMBER(10) NOT NULL,
    CATEGORY                    VARCHAR2(255) NOT NULL,
    ON_LINE                     NUMBER(10),
    STAT_AT                     TIMESTAMP(6) NOT NULL,
    CONSTRAINT SYS_C0045629 PRIMARY KEY (ID),
    CONSTRAINT UK_7HKT37WYEF4TH6FXOIP4Q1E2B UNIQUE (CATEGORY)
);

set feedback on
prompt Done.
exit
