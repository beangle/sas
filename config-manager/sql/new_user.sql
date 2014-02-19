DROP USER eams_empty cascade;
create user eams_empty identified by 1 default tablespace users temporary tablespace temp;
grant connect,resource,unlimited tablespace,create any sequence,drop any sequence to eams_empty;
exit
