local HttpService = game:GetService("HttpService")
local EncodingService = game:GetService("EncodingService")

local API_URL = "https://ifdian.net/api/open/query-order"
local TOKEN   = "YOUR_TOKEN"
local USER_ID = "YOUR_USER_ID"    

local AfDian = {}

local function md5Hex(s)
	local raw = EncodingService:ComputeStringHash(s, Enum.HashAlgorithm.Md5)
	local out = table.create(#raw)
	for i = 1, #raw do
		out[i] = string.format("%02x", string.byte(raw, i))
	end
	return table.concat(out)
end

AfDian.md5 = md5Hex

function AfDian.queryOrder(outTradeNo, page, perPage)
	page = page or 1
	perPage = perPage or 50

	local params
	if outTradeNo and outTradeNo ~= "" then
		assert(string.match(outTradeNo, "^[%d,]+$"), "outTradeNo 只能包含数字和英文逗号")
		params = string.format('{"page":%d,"out_trade_no":"%s"}', page, outTradeNo)
	else
		params = string.format('{"page":%d,"per_page":%d}', page, perPage)
	end

	local ts = os.time()
	local sign = md5Hex(TOKEN .. "params" .. params .. "ts" .. string.format("%d", ts) .. "user_id" .. USER_ID)

	local body = HttpService:JSONEncode({
		user_id = USER_ID,
		params = params,
		ts = ts,
		sign = sign,
	})

	local ok, res = pcall(function()
		return HttpService:RequestAsync({
			Url = API_URL,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = body,
		})
	end)

	if not ok then
		return nil, "请求异常: " .. tostring(res)
	end
	if not res.Success then
		return nil, string.format("HTTP %d: %s", res.StatusCode, res.Body)
	end

	return res.Body
end

function AfDian.queryOrderDecoded(outTradeNo, page, perPage)
	local raw, err = AfDian.queryOrder(outTradeNo, page, perPage)
	if not raw then
		return nil, err
	end

	local ok, decoded = pcall(function()
		return HttpService:JSONDecode(raw)
	end)
	if not ok then
		return nil, "JSON 解析失败: " .. tostring(decoded)
	end

	return decoded
end

return AfDian
