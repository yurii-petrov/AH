bagGUID = ""
function onLoad()
  bagGUID = self.getGUID()
  setupShop_params = {
    click_function = "setupShop",
    function_owner = self,
    label = "Setup Market",
    tooltip = "Auto-sets Market. >9 cards? Even 3-type split. Extra cards become deck in Barracks Storage.",
    position = {0, 0,1.3},
    rotation = {0,0,0},
    width = 1000,
    height = 400,
    color = {1,1,1},
    font_color = {0,0,0},
    font_size = 150
  }
  self.createButton(setupShop_params)

end

function setupShop(params)
    local bag = getObjectFromGUID(bagGUID)
    local cardDatas = bag.getObjects() -- 获取卡牌数据表列表
    local shopSlots = {}
    local bagPosition = bag.getPosition()

    -- 阶段1：数据采集 ----------------------------------------------
    for _, data in ipairs(cardDatas) do
        local desc = data.description
        if desc and data.gm_notes == "Market Randomiser" then
            local cardType, value = desc:match("(%a+)(%d+)")
            if cardType and value then
                -- 关键修改：使用takeObject取出卡牌获取真实对象
                local cardObj = bag.takeObject({
                    guid = data.guid,
                    position = bagPosition + vector(0, 5, 0), -- 临时放置位置
                    smooth = false
                })
                -- print("取出卡牌:", cardObj.getGUID())
                table.insert(shopSlots, {
                    obj = cardObj,
                    type = cardType:lower(),
                    value = tonumber(value)
                })
            end
        end
    end

    -- 调试：打印原始数据
    -- print("\n==== 阶段1：数据采集 ====")
    -- print("袋中卡牌总数:", #cardDatas)
    -- print("有效解析卡牌数:", #shopSlots)

    -- 阶段2：智能排序 ----------------------------------------------
    table.sort(shopSlots, function(a,b)
        local typeOrder = {gem=1, relic=2, spell=3}
        -- 优先按类型排序
        if a.type ~= b.type then
            return typeOrder[a.type] < typeOrder[b.type]
        end
        -- 同类型按数值升序
        return a.value < b.value
    end)

    -- 阶段3：智能筛选 ----------------------------------------------
    local finalSelection = {}
    local typeCounts = {gem=0, relic=0, spell=0}
    local remaining = 9

    -- 调试头
    -- print("\n==== 阶段3：筛选过程 ====")

    -- 情况1：刚好9张直接使用
    if #shopSlots == 9 then
        -- print("检测到正好9张卡牌，直接使用全部")
        finalSelection = shopSlots
    else
        -- print("开始智能筛选...")
        -- 情况2：需要筛选时
        for i, card in ipairs(shopSlots) do
            local canSelect = false
            -- local reason = ""

            -- 核心筛选条件
            if remaining > 0 then
                -- 条件A：该类型未达配额（3张）
                if typeCounts[card.type] < 3 then
                    canSelect = true
                    -- reason = "类型配额未满"
                -- 条件B：所有类型都达配额但仍有剩余位置
                elseif typeCounts.gem >=3 and typeCounts.relic >=3 and typeCounts.spell >=3 then
                    canSelect = true
                    -- reason = "强制填充剩余位置"
                end

                if canSelect then
                    table.insert(finalSelection, card)
                    typeCounts[card.type] = typeCounts[card.type] + 1
                    remaining = remaining - 1
                    -- 调试日志
                    -- print(string.format("选中 %2d: %s%-2d | 类型计数: G%d R%d S%d | 剩余: %d | 原因: %s",
                    --     i, card.type:upper(), card.value,
                    --     typeCounts.gem, typeCounts.relic, typeCounts.spell,
                    --     remaining, reason))
                end
            else
                break
            end
        end
    end

    -- 阶段4：布局与调试 --------------------------------------------
    local positions = {
        {28.93,3,23.46}, {36.07,3,23.46}, {43.27,3,23.46},
        {28.93,3,13.75}, {36.07,3,13.75}, {43.32,3,13.75},
        {28.93,3,3.96},  {36.07,3,3.96},  {43.23,3,3.96}
    }

    -- print("\n==== 最终结果 ====")
    -- print("目标位置数:", 9)
    -- print("实际选中数:", #finalSelection)
    -- print("各类型分布:")
    -- print("GEM:", typeCounts.gem, "RELIC:", typeCounts.relic, "SPELL:", typeCounts.spell)

    -- 打印每张卡的详细信息
    for i, card in ipairs(finalSelection) do
        local pos = positions[i] or {"无位置"}
        -- print(string.format("槽位%1d: [%s] %s%-2d → 坐标: %.2f,%.2f,%.2f",
        --     i, card.obj.getGUID(), card.type:upper(), card.value,
        --     pos[1], pos[2], pos[3]))
    end

    -- 执行卡牌摆放
    for i, card in ipairs(finalSelection) do
        if positions[i] then
            card.obj.setPosition(positions[i])
        end
    end
end