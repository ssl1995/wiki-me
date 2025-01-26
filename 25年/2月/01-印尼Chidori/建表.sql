# authority_operate_analysis
create table authority_operate_analysis
(
    id          bigint auto_increment primary key,
    domestic_id bigint                              null comment '关联国内OA 对应表的ID',
    log_id      bigint                              not null comment '操作日志ID',
    target_id   bigint                              not null comment '操作目标id,eg:权限ID/角色ID/员工工号',
    target_name varchar(127)                        not null comment '操作目标name',
    target_code varchar(127)                        null comment '操作目标code,eg:权限feature',
    target_type tinyint                             not null comment '操作目标类型,eg: 1:权限点,2:角色,3:员工',
    action_type tinyint                             not null comment '操作类型,eg: 0:default,1:assign,2:cancel',
    description longtext                            null comment '操作描述',
    create_time timestamp default CURRENT_TIMESTAMP not null,
    update_time timestamp default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP
)
    charset = utf8;

create index INDEX_LOG_ID
    on authority_operate_analysis (log_id);

create index INDEX_TARGET
    on authority_operate_analysis (target_id, target_type, target_code);

# authority_operate_log
create table authority_operate_log
(
    id          bigint auto_increment primary key,
    domestic_id bigint                                null comment '关联国内OA 对应表的ID',
    type        int(4)      default 0                 not null comment 'AuthorityMonitorEnum',
    data        text                                  null comment '数据',
    description longtext                              null comment '操作内容描述',
    operator    varchar(64) default ''                not null comment '操作人',
    create_time timestamp   default CURRENT_TIMESTAMP not null,
    update_time timestamp   default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP
)
    charset = utf8;

# business
create table business
(
    id                  bigint auto_increment primary key,
    domestic_id         bigint                                 null comment '关联国内OA 对应表的ID',
    name                varchar(100) default ''                not null comment '名称',
    code                varchar(100) default ''                not null,
    host                text                                   not null comment '域名',
    wechat_app_id       varchar(128) default ''                not null comment '微信公众号 ID',
    wechat_secret       varchar(128) default ''                not null comment '微信公众号密钥',
    cookie_secret       varchar(8)   default ''                not null,
    cookie_max_age      int(10)      default 0                 not null,
    cross_domain        tinyint(1)   default 0                 not null comment '0:不需要跨域;1:跨域登录',
    status              tinyint      default 1                 not null comment '状态，1：启用，2：禁用，-1：删除',
    create_time         timestamp    default CURRENT_TIMESTAMP not null,
    update_time         timestamp    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    cookie_access_codes varchar(500)                           null comment '加密 cookie 可访问的系统 code，多个用逗号隔开'
)
    charset = utf8mb4;

create index index__name
    on business (name);

create index index__wechat_app_id
    on business (wechat_app_id);

# channel
create table channel
(
    id          bigint auto_increment primary key,
    domestic_id bigint                                 null comment '关联国内OA 对应表的ID',
    name        varchar(100) default ''                not null comment '名称',
    code        varchar(100) default ''                not null,
    parent_id   bigint       default 1                 not null comment '父节点 id',
    level       int(10)      default 1                 not null comment '层级',
    create_time timestamp    default CURRENT_TIMESTAMP not null,
    update_time timestamp    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    constraint key__code
        unique (code),
    constraint key__name
        unique (name)
)
    charset = utf8mb4;

create index index__left
    on channel (parent_id);

create index index__level
    on channel (level);


# employee_mac_relation
create table employee_mac_relation
(
    id              bigint auto_increment primary key,
    domestic_id     bigint                              null comment '关联国内OA 对应表的ID',
    employee_number varchar(16)                         not null comment '工号',
    mac_info        varchar(128)                        not null comment '设备信息',
    create_time     timestamp default CURRENT_TIMESTAMP not null,
    update_time     timestamp default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP
)
    charset = utf8mb4;

# employee_role_relation
create table employee_role_relation
(
    id              bigint auto_increment primary key,
    domestic_id     bigint                              null comment '关联国内OA 对应表的ID',
    role_id         bigint                              not null comment '角色ID',
    employee_number varchar(8)                          not null comment '员工工号',
    operator        varchar(5)                          not null comment '操作人',
    create_time     timestamp default CURRENT_TIMESTAMP not null,
    update_time     timestamp default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    constraint uindex__email_role_id
        unique (employee_number, role_id)
);

create index index__role_id
    on employee_role_relation (role_id);


# ex_employee_business_relation
create table ex_employee_business_relation
(
    id             bigint auto_increment primary key,
    domestic_id    bigint                                null comment '关联国内OA 对应表的ID',
    ex_employee_id bigint                                not null,
    work_number    varchar(16) default ''                null comment '工号',
    business_id    bigint                                not null,
    operator       varchar(8)                            not null comment '操作人',
    create_time    timestamp   default CURRENT_TIMESTAMP not null,
    update_time    timestamp   default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    constraint uindex__employee_id_work_number_business
        unique (ex_employee_id, work_number, business_id)
)
    charset = utf8;

create index INDEX_BUSINESS_ID
    on ex_employee_business_relation (business_id);

create index INDEX_EX_EMPLOYEE_ID
    on ex_employee_business_relation (ex_employee_id);

create index INDEX_WORK_NUMBER
    on ex_employee_business_relation (work_number);

# ex_employee
create table ex_employee
(
    id                   bigint auto_increment primary key,
    domestic_id          bigint                                null comment '关联国内OA 对应表的ID',
    name                 varchar(64)                           not null comment '姓名',
    mail                 varchar(64)                           not null comment '邮箱',
    mobile               varchar(32)                           not null comment '手机号',
    department_id        bigint      default -1                null comment '部门id',
    position_id          bigint                                not null comment '岗位id',
    work_number          varchar(8)                            not null comment '工号',
    valid                tinyint     default 1                 not null comment '1：有效，0：无效',
    operator             varchar(8)                            not null comment '操作人',
    create_time          timestamp   default CURRENT_TIMESTAMP not null,
    update_time          timestamp   default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    business_code        varchar(64) default ''                not null comment '数据来源系统Code',
    business_employee_id varchar(64) default ''                not null comment '数据在来源系统的ID',
    deleted              tinyint     default 0                 not null comment '逻辑删除标识，1-已删除',
    sync_status          tinyint(1)  default 0                 not null comment '是否同步到OA系统',
    employee_type        tinyint(1)  default 2                 not null comment '员工类型',
    constraint uk_work_number
        unique (work_number)
)
    charset = utf8;

create index idx_business_key
    on ex_employee (business_code, business_employee_id);

create index idx_mail
    on ex_employee (mail);

create index idx_mobile
    on ex_employee (mobile);

# password_change_log
create table password_change_log
(
    id              bigint auto_increment primary key,
    domestic_id     bigint                                 null comment '关联国内OA 对应表的ID',
    employee_number varchar(64)  default ''                not null comment '员工唯一标识',
    new_password    varchar(256) default ''                not null comment '新密码',
    type            tinyint                                not null comment '更改方式:S:短信验证码，P：旧密码修改',
    create_time     timestamp    default CURRENT_TIMESTAMP not null,
    update_time     timestamp    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP
);

create index INDEX_EMPLOYEE_NUMBER
    on password_change_log (employee_number);

# permission
create table permission
(
    id          bigint auto_increment primary key,
    domestic_id bigint                                 null comment '关联国内OA 对应表的ID',
    feature     varchar(127)                           not null comment '权限feature',
    name        varchar(127) default ''                not null comment '权限名称',
    status      tinyint      default 1                 not null comment '是否可用 0：不可用，1：可用',
    type        tinyint      default 0                 null comment '0内部,1外部,2通用',
    operator    varchar(5)                             not null comment '操作人',
    create_time timestamp    default CURRENT_TIMESTAMP not null,
    update_time timestamp    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    constraint index__feature
        unique (feature),
    constraint index__name
        unique (name)
);

# record_user_behavior
create table record_user_behavior
(
    id             bigint unsigned auto_increment primary key,
    domestic_id    bigint                                null comment '关联国内OA 对应表的ID',
    operator_email varchar(64) default ''                not null comment '操作人的邮箱',
    operation_time bigint      default 0                 not null comment '操作时间',
    operation_type tinyint     default 0                 not null comment '操作类型 1:登录 2:登出',
    create_time    timestamp   default CURRENT_TIMESTAMP not null,
    update_time    timestamp   default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP
)
    comment '记录用户登录登出表' charset = utf8;

create index index__operation_time_key
    on record_user_behavior (operation_time);

create index index__operator_email_key
    on record_user_behavior (operator_email);

# role_permission_relation
create table role_permission_relation
(
    id            bigint auto_increment primary key,
    domestic_id   bigint                              null comment '关联国内OA 对应表的ID',
    role_id       bigint                              not null comment '角色ID',
    permission_id bigint                              not null comment '权限ID',
    operator      varchar(5)                          not null comment '操作人',
    create_time   timestamp default CURRENT_TIMESTAMP not null,
    update_time   timestamp default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    constraint uindex__role_id_permission_id
        unique (role_id, permission_id)
);

create index index__permission_id
    on role_permission_relation (permission_id);

# role
create table role
(
    id          bigint auto_increment primary key,
    domestic_id bigint                                null comment '关联国内OA 对应表的ID',
    name        varchar(64) default ''                not null comment '角色名称',
    path        varchar(64) default ''                not null comment '顶层角色到当前角色的ID路径，比如：1/4/5',
    `default`   tinyint                               null comment '是否是默认角色 0：否，1：是',
    status      tinyint     default 1                 not null comment '是否可用 0：不可用，1：可用',
    type        tinyint     default 0                 null comment '0内部,1外部,2通用',
    operator    varchar(5)                            not null comment '操作人',
    create_time timestamp   default CURRENT_TIMESTAMP not null,
    update_time timestamp   default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    constraint index__name
        unique (name)
);

create index index__path
    on role (path);

# sample
create table sample
(
    id           bigint unsigned auto_increment primary key,
    domestic_id  bigint                                 null comment '关联国内OA 对应表的ID',
    first_field  int(10)      default 0                 not null comment '测试字段1',
    second_field varchar(256) default ''                not null comment '测试字段2',
    birthday     date                                   not null comment '生日',
    create_time  timestamp    default CURRENT_TIMESTAMP not null,
    update_time  timestamp    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP
)
    charset = utf8;


# schema_version
create table schema_version
(
    version_rank   int                                 not null,
    installed_rank int                                 not null,
    version        varchar(50)                         not null
        primary key,
    description    varchar(200)                        not null,
    type           varchar(20)                         not null,
    script         varchar(1000)                       not null,
    checksum       int                                 null,
    installed_by   varchar(100)                        not null,
    installed_on   timestamp default CURRENT_TIMESTAMP not null,
    execution_time int                                 not null,
    success        tinyint(1)                          not null
);

create index schema_version_ir_idx
    on schema_version (installed_rank);

create index schema_version_s_idx
    on schema_version (success);

create index schema_version_vr_idx
    on schema_version (version_rank);

# sign_in_link_save
create table sign_in_link_save
(
    id                 bigint unsigned auto_increment primary key,
    domestic_id        bigint                                 null comment '关联国内OA 对应表的ID',
    sign_in_link_key   varchar(64)  default ''                not null comment '签到连接的key',
    sign_in_link_value varchar(512) default ''                not null comment '签到连接的value',
    is_delete          tinyint(1)   default 0                 not null comment '是否禁用 0 启用 1禁用',
    create_time        timestamp    default CURRENT_TIMESTAMP not null,
    update_time        timestamp    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP
)
    charset = utf8;

create index index__sign_in_link_key
    on sign_in_link_save (sign_in_link_key);

# web_page_config
create table web_page_config
(
    id                    bigint auto_increment primary key,
    domestic_id           bigint                                 null comment '关联国内OA 对应表的ID',
    business_id           bigint                                 not null comment '业务 ID',
    channels              varchar(100) default ''                not null comment '渠道，以逗号分隔的三级形式',
    title                 varchar(200) default ''                not null comment '标题',
    creator               varchar(100) default ''                not null,
    updater               varchar(100) default ''                not null,
    type                  tinyint      default 1                 not null comment '类型，1：页面，2：模板',
    status                tinyint      default 1                 not null comment '状态，1：启用，2：禁用，-1：删除',
    template_body         text                                   not null comment '模板',
    template_preview_body text                                   not null comment '模板预览',
    create_time           timestamp    default CURRENT_TIMESTAMP not null,
    update_time           timestamp    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP
)
    charset = utf8mb4;

create index index__business_id
    on web_page_config (business_id);