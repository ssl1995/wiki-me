# authority_operate_analysis
create table authority_operate_analysis
(
    id          bigint auto_increment primary key,
    domestic_id bigint                              null comment 'Associated domestic OA corresponding table ID',
    log_id      bigint                              not null comment 'Operation log ID',
    target_id   bigint                              not null comment 'Operation target ID, e.g., permission ID/role ID/employee number',
    target_name varchar(127)                        not null comment 'Operation target name',
    target_code varchar(127)                        null comment 'Operation target code, e.g., permission feature',
    target_type tinyint                             not null comment 'Operation target type, e.g., 1: permission point, 2: role, 3: employee',
    action_type tinyint                             not null comment 'Operation type, e.g., 0: default, 1: assign, 2: cancel',
    description longtext                            null comment 'Operation description',
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
    domestic_id bigint                                null comment 'Associated domestic OA corresponding table ID',
    type        int(4)      default 0                 not null comment 'AuthorityMonitorEnum',
    data        text                                  null comment 'Data',
    description longtext                              null comment 'Operation content description',
    operator    varchar(64) default ''                not null comment 'Operator',
    create_time timestamp   default CURRENT_TIMESTAMP not null,
    update_time timestamp   default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP
)
    charset = utf8;

# business
create table business
(
    id                  bigint auto_increment primary key,
    domestic_id         bigint                                 null comment 'Associated domestic OA corresponding table ID',
    name                varchar(100) default ''                not null comment 'Name',
    code                varchar(100) default ''                not null,
    host                text                                   not null comment 'Domain name',
    wechat_app_id       varchar(128) default ''                not null comment 'WeChat public account ID',
    wechat_secret       varchar(128) default ''                not null comment 'WeChat public account secret',
    cookie_secret       varchar(8)   default ''                not null,
    cookie_max_age      int(10)      default 0                 not null,
    cross_domain        tinyint(1)   default 0                 not null comment '0: no cross-domain; 1: cross-domain login',
    status              tinyint      default 1                 not null comment 'Status, 1: enabled, 2: disabled, -1: deleted',
    create_time         timestamp    default CURRENT_TIMESTAMP not null,
    update_time         timestamp    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    cookie_access_codes varchar(500)                           null comment 'Encrypted cookie accessible system codes, separated by commas'
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
    domestic_id bigint                                 null comment 'Associated domestic OA corresponding table ID',
    name        varchar(100) default ''                not null comment 'Name',
    code        varchar(100) default ''                not null,
    parent_id   bigint       default 1                 not null comment 'Parent node ID',
    level       int(10)      default 1                 not null comment 'Level',
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
    domestic_id     bigint                              null comment 'Associated domestic OA corresponding table ID',
    employee_number varchar(16)                         not null comment 'Employee number',
    mac_info        varchar(128)                        not null comment 'Device information',
    create_time     timestamp default CURRENT_TIMESTAMP not null,
    update_time     timestamp default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP
)
    charset = utf8mb4;

# employee_role_relation
create table employee_role_relation
(
    id              bigint auto_increment primary key,
    domestic_id     bigint                              null comment 'Associated domestic OA corresponding table ID',
    role_id         bigint                              not null comment 'Role ID',
    employee_number varchar(8)                          not null comment 'Employee number',
    operator        varchar(5)                          not null comment 'Operator',
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
    domestic_id    bigint                                null comment 'Associated domestic OA corresponding table ID',
    ex_employee_id bigint                                not null,
    work_number    varchar(16) default ''                null comment 'Employee number',
    business_id    bigint                                not null,
    operator       varchar(8)                            not null comment 'Operator',
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
    domestic_id          bigint                                null comment 'Associated domestic OA corresponding table ID',
    name                 varchar(64)                           not null comment 'Name',
    mail                 varchar(64)                           not null comment 'Email',
    mobile               varchar(32)                           not null comment 'Mobile number',
    department_id        bigint      default -1                null comment 'Department ID',
    position_id          bigint                                not null comment 'Position ID',
    work_number          varchar(8)                            not null comment 'Employee number',
    valid                tinyint     default 1                 not null comment '1: valid, 0: invalid',
    operator             varchar(8)                            not null comment 'Operator',
    create_time          timestamp   default CURRENT_TIMESTAMP not null,
    update_time          timestamp   default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    business_code        varchar(64) default ''                not null comment 'Data source system Code',
    business_employee_id varchar(64) default ''                not null comment 'Data ID in the source system',
    deleted              tinyint     default 0                 not null comment 'Logical delete flag, 1-deleted',
    sync_status          tinyint(1)  default 0                 not null comment 'Synchronized to OA system',
    employee_type        tinyint(1)  default 2                 not null comment 'Employee type',
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
    domestic_id     bigint                                 null comment 'Associated domestic OA corresponding table ID',
    employee_number varchar(64)  default ''                not null comment 'Employee unique identifier',
    new_password    varchar(256) default ''                not null comment 'New password',
    type            tinyint                                not null comment 'Change method: S: SMS verification code, P: old password change',
    create_time     timestamp    default CURRENT_TIMESTAMP not null,
    update_time     timestamp    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP
);

create index INDEX_EMPLOYEE_NUMBER
    on password_change_log (employee_number);

# permission
create table permission
(
    id          bigint auto_increment primary key,
    domestic_id bigint                                 null comment 'Associated domestic OA corresponding table ID',
    feature     varchar(127)                           not null comment 'Permission feature',
    name        varchar(127) default ''                not null comment 'Permission name',
    status      tinyint      default 1                 not null comment 'Available 0: no, 1: yes',
    type        tinyint      default 0                 null comment '0 internal, 1 external, 2 common',
    operator    varchar(5)                             not null comment 'Operator',
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
    domestic_id    bigint                                null comment 'Associated domestic OA corresponding table ID',
    operator_email varchar(64) default ''                not null comment 'Operator email',
    operation_time bigint      default 0                 not null comment 'Operation time',
    operation_type tinyint     default 0                 not null comment 'Operation type 1: login, 2: logout',
    create_time    timestamp   default CURRENT_TIMESTAMP not null,
    update_time    timestamp   default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP
)
    comment 'Record user login/logout table' charset = utf8;

create index index__operation_time_key
    on record_user_behavior (operation_time);

create index index__operator_email_key
    on record_user_behavior (operator_email);

# role_permission_relation
create table role_permission_relation
(
    id            bigint auto_increment primary key,
    domestic_id   bigint                              null comment 'Associated domestic OA corresponding table ID',
    role_id       bigint                              not null comment 'Role ID',
    permission_id bigint                              not null comment 'Permission ID',
    operator      varchar(5)                          not null comment 'Operator',
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
    domestic_id bigint                                null comment 'Associated domestic OA corresponding table ID',
    name        varchar(64) default ''                not null comment 'Role name',
    path        varchar(64) default ''                not null comment 'Top-level role to current role ID path, e.g., 1/4/5',
    `default`   tinyint                               null comment 'Default role 0: no, 1: yes',
    status      tinyint     default 1                 not null comment 'Available 0: no, 1: yes',
    type        tinyint     default 0                 null comment '0 internal, 1 external, 2 common',
    operator    varchar(5)                            not null comment 'Operator',
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
    domestic_id  bigint                                 null comment 'Associated domestic OA corresponding table ID',
    first_field  int(10)      default 0                 not null comment 'Test field 1',
    second_field varchar(256) default ''                not null comment 'Test field 2',
    birthday     date                                   not null comment 'Birthday',
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
    domestic_id        bigint                                 null comment 'Associated domestic OA corresponding table ID',
    sign_in_link_key   varchar(64)  default ''                not null comment 'Sign-in link key',
    sign_in_link_value varchar(512) default ''                not null comment 'Sign-in link value',
    is_delete          tinyint(1)   default 0                 not null comment 'Disabled 0: enabled, 1: disabled',
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
    domestic_id           bigint                                 null comment 'Associated domestic OA corresponding table ID',
    business_id           bigint                                 not null comment 'Business ID',
    channels              varchar(100) default ''                not null comment 'Channels, separated by commas in three levels',
    title                 varchar(200) default ''                not null comment 'Title',
    creator               varchar(100) default ''                not null,
    updater               varchar(100) default ''                not null,
    type                  tinyint      default 1                 not null comment 'Type, 1: page, 2: template',
    status                tinyint      default 1                 not null comment 'Status, 1: enabled, 2: disabled, -1: deleted',
    template_body         text                                   not null comment 'Template',
    template_preview_body text                                   not null comment 'Template preview',
    create_time           timestamp    default CURRENT_TIMESTAMP not null,
    update_time           timestamp    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP
)
    charset = utf8mb4;

create index index__business_id
    on web_page_config (business_id);
