List<PermissionApplyResult> fetchByCondition(@Param("condition") ApplyResultCondition condition);

  List<PermissionApplyResult> fetchByExpireTimeAndStatus(@Param("expireTimeEnd") LocalDateTime expireTimeEnd, @Param("status") List<PermissionApplyResultStatus> status);

  List<PermissionApplyResult> fetchByExpireTimeAndStatusAndBusinessType(@Param("expireTimeEnd") LocalDateTime expireTimeEnd, @Param("status") List<PermissionApplyResultStatus> status, @Param("permissionApplyType") Integer permissionApplyType);
