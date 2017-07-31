---
title: 主播管理
type: sdk
order: 4
---

公共头部信息，请查看相关说明：[安全机制](/sdk/auth.html)


## 主播列表

`GET: http://dev.cibnlive.com/api/v1/anchor/all`

### 请求参数

| 字段      |类型     |必填 |说明|
|-----------|--------|----|----|
| appkey    | string | N  |应用的appkey，不传默认查询账号下所有应用。|
| page_id   | int    | N  |当前页码，不传默认1|
| page_limit| int    | N  |每页限制个数，不传默认20,最大限制1000|
| text      | string | N  |流名称的模糊搜索|

### 返回数据

如果请求成功，将返回json格式的字符串，包含以下字段：

| 字段       | 类型  |必填|说明|
|---------  |------|----|----|
| msg       |string| Y  |结果|
| ret       |int   | Y  |0是成功，其他是失败|
| page_id   |int   | Y  |当前页码|
| page_limit|int   | Y  |每页个数|
| page_total|int   | Y  |结果总数|
| data      |array | Y  |查询结果列表，主播信息体集合|



主播信息体包含的字段：

| 字段          | 类型  |必填|说明|
|---------     |------|----|----|
| cuid         |string| Y  |用户id|
| avatar      |string| N  |头像图片|
| nickname    |string| N  |昵称|
| gender      |string| N  |性别|







