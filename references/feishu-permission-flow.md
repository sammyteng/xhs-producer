# Bot 创建文档后的用户授权流程

> **场景**：`lark-cli docs +create --as bot` 创建的文档，默认只有 Bot 自己可访问，用户打开链接会提示无权限。

## 快速流程

### 1. 获取当前用户 open_id

```bash
lark-cli api GET "/open-apis/contact/v3/users?page_size=20" --as bot \
  | python3 -c "
import sys, json
data = json.load(sys.stdin)
items = data.get('data', {}).get('items', [])
for u in items:
    print(f'{u[\"name\"]} | open_id: {u[\"open_id\"]} | user_id: {u[\"user_id\"]}')
"
```

从输出中找到目标用户的 `open_id`。

### 2. 授权 full_access

```bash
lark-cli api POST "/open-apis/drive/v1/permissions/${DOC_ID}/members" \
  --data '{
    "member_type": "openid",
    "member_id": "ou_xxxxxxxxxxxxx",
    "perm": "full_access",
    "type": "user"
  }' \
  --params '{"type":"docx"}' \
  --as bot
```

成功返回：`{"code": 0, "data": {"member": {...}}}`

### 3. 常见错误

| 错误码 | 原因 | 修复 |
|-------|------|------|
| `99992402` field validation failed | `type` 字段传了 `"docx"` 等错误值 | 改为 `"type": "user"` |
| `need_user_authorization` | 没有用 `--as bot` | 加上 `--as bot` |

### 4. 权限 API 参数说明

- **member_type**: `openid` / `userid` / `unionid` / `email`
- **member_id**: 对应类型的 ID
- **perm**: `view` / `edit` / `full_access`
- **type**: `user`（⚠️ 这里填的是"成员类型"，不是文档类型）
- **query params**: `type=docx`（这里是文档类型）

### 5. lark-cli 内置的 permission_grant

`lark-cli docs +create --as bot` 成功后返回值中的 `permission_grant` 字段会说明自动授权结果：

- `status: granted` → 已自动授权，无需手动操作
- `status: skipped` → 本地无用户 open_id 配置，需手动授权（走本流程）
- `status: failed` → 自动授权失败，需手动授权
