# ICC-CE 设置参考

使用 `iccce-connector__list_iccce_setting_paths` 获取当前版本实际可用的字段路径。不要猜测路径，也不要通过文件系统绕过 HTTP API。

`security`、`password`、`token`、`secret`、`hash`、`salt`、`totp` 等字段可能包含敏感材料；不要读取、回显或修改它们。
