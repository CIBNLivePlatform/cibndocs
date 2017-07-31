主播信息体包含的字段：

| 字段          | 类型  |必填|说明|
|---------     |------|----|----|
| appkey       |string| Y  |应用的appkey|
| created_time |int   | Y  |创建时间，单位毫秒|
| updated_time |int   | Y  |更新时间，单位毫秒|
| cuid         |string| Y  |用户id|
|alipay_certified|boolean|Y|是否通过支付宝认证|
|alipay_certified_id|string|N|支付宝认证id|
| realname    |string| Y  |真实姓名|
| identity    |string| Y  |身份证号码|
| identity_img|string| Y  |手持身份证照片|
| avatar      |string| N  |头像图片|
| nickname    |string| N  |昵称|
| phone       |string| Y  |电话|
| address     |string| N  |地址|
| gender      |string| N  |性别|