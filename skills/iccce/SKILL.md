---
name: iccce
description: 管理 ICC-CE 的状态、设置、截图、白板分页与 SVG 插入。
---

# ICC-CE

先确认 ICC-CE 正在运行且 CE 端 SecAgent 插件已启用。所有工具使用前缀 `iccce-connector__`。

## 插入手写 Markdown SVG

优先调用 `markdown-handdrawn__render`，并使用：

```json
{
  "markdown": "# 标题\n\n正文",
  "transparent": true,
  "frame": false,
  "preview": false,
  "insertToIccce": true
}
```

当用户要求把内容插入画板时，若存在手写 SVG 生成工具，必须先调用该工具生成手写 SVG，并设置 `insertToIccce: true`、`preview: false`；此路径只导出并插入，不弹出预览窗口。Markdown 中的 Mermaid 代码块也会在这一步转换为手写风格图表。只有用户明确要求预览，或只是要求查看/导出预览时，才使用 `preview: true`。手写 SVG 内含 `secagent-editable-scene` 时，ICC-CE 会把本次插入作为一个整体选中，方便一起移动和等比例缩放；组内部仍保留独立的 WPF Path 行、表格线、分隔线和基础形状，面积橡皮擦只删除命中的局部 Path，线擦则删除命中的独立项。Mermaid 图表作为一个独立 SVG 图表项移动、缩放和删除。

文字和公式在 ICC-CE 内均转换为字形轮廓 Path，不创建可编辑文本节点；同一源 Markdown 行合并为一个 Path。预览 SVG 仍保留 KaTeX 的完整排版。没有 `secagent-editable-scene` 元数据的普通 SVG 会回退为一个整体 SVG 元素。

## 直接插入 SVG

使用 `iccce-connector__insert_iccce_svg`：

```json
{
  "svg": "<svg ...>...</svg>",
  "name": "可选名称",
  "width": 1200,
  "height": 800
}
```

## 其它工具

- `get_iccce_version_status`：状态与版本。
- `get_iccce_current_screenshot`、`get_iccce_whiteboard_screenshot`：截图。
- `get_iccce_whiteboard_status`、`switch_iccce_whiteboard_page`、`add_iccce_whiteboard_page`、`delete_iccce_whiteboard_page`：分页管理。
- `list_iccce_setting_paths`、`read_iccce_settings`、`update_iccce_settings`：读取和修改设置。修改设置前，先阅读同目录的 `SETTINGS_REFERENCE.md` 并读取目标字段。
## SVG 插入时的背景与尺寸

插入当前白板时默认使用 `transparent: true`、`frame: false`。如果白板是深色，先调用 `get_iccce_whiteboard_screenshot` 或当前画布截图判断明暗，再调用 `markdown-handdrawn__render` 并传入浅色 `textColor`、`lineColor`；如果白板是浅色则使用深色文字。背景未知时优先透明背景，不要让 SVG 固定铺白底。

清空和面积擦除由 CE 的 WPF 元素路径处理：表头填充矩形也支持面积擦除，标题下分割线是独立手写 Path。短 Markdown 的 SVG 高度按实际可编辑场景计算；`$$...$$` 和 `\\[...\\]` 块级公式会作为一个公式 Path 插入。
