对接短信验证码 done

卡券已过期的提醒-done

重点解决时区问题，-done


客户服务日期要不要加判断 ， 如何加
卡券验证 必须选择至少一个门店 - done
卡券默认创建是下架 ， 点上架需验证投放开始时间与投放结束时间 - done

whenever 发送 短信过期提醒 ， 短信即将过期的时间范围 done
whenever 发送 会员身份即将过期提醒 ， 短信即将过期的时间范围 done 

卡券核销有效期修改时 ， 更新未被使用的卡券有效期 done
核销短信的数量限制 done
update_all 添加 transaction 处理 , 如果 update_all 的 数量 和 number 不一致 done
bug : card.client_id = null  done
完善 card_tpl.period_card_can_acquire done

#rails-sl

CardTpl.can_check 支持判断可核销数量 done
抽奖券 删除卡券 done

接口上传client_id
发券 - 结合indate done done
发券和核销， 结合卡券的投放时间及有效时间 done 

发券结合没人限领次数及没时间段限领次数 done

报表功能 done

批量生成卡券的实现 - waiting
批量生成抽奖券的实现 - waiting
先使用简单方法， 遍历生成 done

当卡券生效时 ，不可编辑卡券信息 done

validation 
	memeber.phone, 定义为phone validator - done

在 rails-sl-client 重构 use_weeks use_hours - done

核销需要验证的情况
	已获得
	未核销
	验证码，密钥， 二者绑定
	卡券实例在有效期内
	卡券模板未下架
	当前时间在可核销时间内
	当前天(周1，2，3，4，5，6，7）在可核销cwday内
	使用乐观锁


发券核销， 要结合乐观锁 - done
重构管理员结构 client.admin_phone and client_managers.admin 要结合在一起, 包括， 登陆，  - done

卡券如何与门店结合在一起 ？核销的门店么 ？
生成卡密有效期

时区的问题需要解决 生成及验证卡券的有效期

