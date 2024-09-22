alter table role

    modify type tinyint default 0 null comment '角色类型：0:内部,1:通用';


alter table permission
    modify type tinyint default 0 null comment '角色类型：0:内部,1:通用';

alter table permission_apply_result
    modify approval_time timestamp default '0000-00-00 00:00:00' not null comment '审批通过时间' after expire_time;