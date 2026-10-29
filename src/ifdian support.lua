local AfDian = require(76936687761521)    
local data = AfDian.queryOrderDecoded("202504032246135348102117331")    

if data.ec == 200 then
	if data.data.list and data.data.list[1] then
		--[[这是你的主要代码部分 还可以加入二次验证
		    参考文档：
		    data.data.list[1]所返回的数据为
    "list": [{
      "out_trade_no": "202106232138371083454010626",
      "custom_order_id": "Steam12345",
      "user_id": "adf397fe8374811eaacee52540025c377",
      "user_private_id":"33这个是每个用户唯一的，相当于微信的 unionid",
      "plan_id": "a45353328af911eb973052540025c377",
      "month": 1,
      "total_amount": "5.00",
      "show_amount": "5.00",
      "status": 2,
      "remark": "",
      "redeem_id": "",
      "product_type": 0,
      "discount": "0.00",
      "sku_detail": [{
        "sku_id": "b082342c4aba11ebb5cb52540025c377",
        "count": 1,
        "name": "15000 赏金/货币 兑换码",
        "album_id": "",
        "pic": "https://pic1.afdiancdn.com/user/8a8e408a3aeb11eab26352540025c377/common/sfsfsff.jpg"
      }],
      "address_person": "",
      "address_phone": "",
      "address_address": ""
    }],
		]]
	else
		--这是验证未通过的代码部分
		for _,i in game.Players:GetChildren() do
			i:Kick("[Lorg Studio]该游戏使用了未经授权的系统/模型(如果开发者正确购买了模型，请检查是否填写订单号)")
		end
	end
else
	warn("请求失败: " .. tostring(data))
end

