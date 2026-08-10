---
name: iccce
description: 执行 ICC-CE 的版本查询、设置管理、当前墨迹/屏幕截图、白板截图和白板分页管理；修改设置前必须阅读设置参考并读取目标字段。
---

# ICC-CE

本 Skill 由 SecAgent ICC-CE 连接插件提供。连接插件通过本机普通 HTTP JSON API 调用 ICC-CE，不使用 MCP。若服务未连接，先确认 ICC-CE 已启用对应插件。

工具 key 使用插件前缀 `iccce-connector__`：

- `iccce-connector__get_iccce_version_status`：参数 `{}`，查询版本、进程和设置文件状态。
- `iccce-connector__list_iccce_setting_paths`：参数 `{}` 或 `{"prefix":"canvas"}`，列出可读写设置路径。
- `iccce-connector__read_iccce_settings`：参数 `{"path":"canvas"}`，读取指定设置；完整设置使用 `{"path":""}`。敏感字段会被遮蔽。
- `iccce-connector__update_iccce_settings`：使用 `{"path":"canvas.inkWidth","value":3.0}` 修改单字段，或使用 `{"patch":{"canvas":{"inkWidth":3.0}}}` 做递归增量更新。
- `iccce-connector__get_iccce_current_screenshot`：使用 `{}` 获取透明墨迹层；使用 `{"include_screen_background":true}` 获取桌面背景叠加墨迹的截图。
- `iccce-connector__get_iccce_whiteboard_screenshot`：使用 `{}` 获取当前白板页，或使用 `{"page":2}` 获取指定页；同样支持 `include_screen_background`。
- `iccce-connector__get_iccce_whiteboard_status`：获取当前页、总页数和分页操作能力。
- `iccce-connector__switch_iccce_whiteboard_page`：使用 `{"page":2}` 切换当前白板页。
- `iccce-connector__add_iccce_whiteboard_page`：在当前页后新增白板页。
- `iccce-connector__delete_iccce_whiteboard_page`：删除当前白板页；至少保留一页。

修改前必须阅读本 Skill 目录中的 `SETTINGS_REFERENCE.md`，确认字段路径、类型和影响范围，再读取目标字段。插件会拒绝密码、Token、Secret、哈希、盐和 TOTP 等敏感字段，并在写入前创建 `Settings.json.bak`。部分只在启动时读取的设置需要重启 ICC-CE。
