#rails-sl

发卷 - 结合indate
发卷和核销， 结合卡卷的投放时间及有效时间

发卷结合没人限领次数及没时间段限领次数

报表功能

批量生成卡卷的实现
先使用简单方法， 遍历生成

当卡卷生效时 ，不可编辑卡卷信息

validation
	memeber.phone, 定义为phone validator

在 rails-sl-client 重构 use_weeks use_hours

核销需要验证的情况
	已获得
	未核销
	验证码，密钥， 二者绑定
	卡卷实例在有效期内
	卡卷模板未下架
	当前时间在可核销时间内
	当前天(周1，2，3，4，5，6，7）在可核销cwday内
	使用乐观锁


发卷核销， 要结合乐观锁 - done
重构管理员结构 client.admin_phone and client_managers.admin 要结合在一起, 包括， 登陆，  - done
