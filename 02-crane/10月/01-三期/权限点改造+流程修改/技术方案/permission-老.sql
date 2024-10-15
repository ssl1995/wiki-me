create table permission
(
    id                bigint auto_increment comment 'id主键'
        primary key, 
    feature           varchar(512)                           not null comment '权限feature',// songSys.feature3
    name              varchar(128)                           not null comment '权限名称', //宋的系统.三期方案
    security_level    tinyint      default 1                 null comment '安全等级',// securityLevel
    support_data_rule tinyint      default 0                 not null comment '是否支持配置数据权限', // 是否支持属性维度


    `desc`            varchar(512) default ''                not null comment '权限说明',
    status            tinyint      default 1                 not null comment '是否可用 0：不可用，1：可用',
    type              tinyint      default 0                 null comment '角色类型：0:内部,1:通用',
  



    operator          varchar(5)                             not null comment '操作人',
    create_time       timestamp    default CURRENT_TIMESTAMP not null comment '创建时间',
    update_time       timestamp    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    constraint uindex__feature
        unique (feature),
    constraint uindex__name
        unique (name)
)
    comment '权限表' charset = utf8mb4;

    {
    "name": "宋的系统.三期方案",
    "feature": "songSys.feature3",
    "type": "INTERNAL",
    "securityLevel": "HIGH",
    "supportDataRule": false
}

https://crane-test.yangqianguan.com/admin/common/enums/SecurityLevelEnum