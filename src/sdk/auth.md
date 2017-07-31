---
title: 安全机制
type: sdk
order: 2
---

平台 API 会对每个访问的请求进行身份验证，即每个请求都需要在请求的headers中包含AccessKey和签名信息（Signature）以验证用户身份。签名信息由用户所执有的安全凭证生成，安全凭证包括 Accesskey 和 Secretkey，用户可在个人中心生成和查看。

## 头部说明

|参数        | 是否必须 | 描述    |
|--------   |---------|---------|
| AccessKey | Y       | 验证key|
| Signature | Y       |签名信息  |
| Time      | N       |过期时间(UNIX时间戳),同时支持从请求参数中传递|

## 签名信息算法

**待签名数据**
AccessKey + ‘\n\n’ + time 组成字符串，得到`signingStr`，time可从headers或者请求参数中传递。

**HMAC-SHA1签名数据**
使用`SecretKey`对`signingStr`进行`HMAC-SHA1`签名，得到`Sign`。

```
Sign = hmac_sha1(signingStr,"<SecretKey>")

```

**Base64编码签名数据，获得签名信息**
对签名数据`Sign`进行Base64编码，得到`Signature`

```
Signature = base64_encode(Sign)
```






