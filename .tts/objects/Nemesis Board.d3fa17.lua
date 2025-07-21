nemDiscard = 'f93722'
nemSpefDiscard = '68d849'


bags = {
  ['Nemesis Token'] = '3a7b1b',
  ['Monster Health'] = '613a0f',
  ['Monster Shields'] = 'd5d9f1',
  ['Shield Token'] = 'cadf8d',
  ['Power Token'] = 'a1dccd',
  ['5 Health'] = '1e0235',
  ['1 Health'] = 'e8f3ff',
  ['[B0C4DE]Silence Token[-]']= '5985ad',
  ['Venom Token'] ='3ee330',
  ['Electrify Token'] ='121b13',
  ['Immolate Token'] ='bfef0c'
}
removeTokens = true
addMe = 0


function onObjectEnterScriptingZone(zone, info)
  if removeTokens == false then
    return(nil)
  else
    if (zone.getGUID() == nemDiscard) or (zone.getGUID() == nemSpefDiscard) then
      --print("Find")
      local myName = info.getName()
      --print(myName)
        if myName == "Monster Health" then
        info.destruct()
        elseif myName == "Monster Shields" then
        info.destruct()
        elseif myName == "Health Counter" then
          info.destruct()
        elseif myName == "Power Counter" then
          info.destruct()
        elseif myName == "Shield Counter" then
          info.destruct()
      elseif bags[myName] ~= nil then
        local myBag = getObjectFromGUID(bags[myName])
        local myObj = getObjectFromGUID(info.getGUID())
        myObj.setPositionSmooth(myBag.getPosition() + vector(0,4 + addMe*0.25,0),false,true)
        myObj.setRotationSmooth({0,180,0},false,true)
        addMe = addMe + 1
        Wait.time(rest,2)
      end
    end
  end
  --place counter for nemesis card--
  for i, guid in ipairs(card_zones) do
    local p_val, h_val, s_val = nil, nil, nil
    if zone.getGUID() == guid then
        local counter_zone = getObjectFromGUID(counter_zones[i])
        local existing_counter = getCounterInZone(counter_zone)

        local desc = info.getDescription()
        if desc == "" or desc:match("^%d+$") then
          return
        end

        h_val, s_val = desc:match("^H(%d+)S(%d+)$")  -- 新增结束符$确保全字匹配

        if not (h_val and s_val) then
            p_val = desc:match("^P(%d+)$")  -- 严格匹配P开头纯数字
            h_val = desc:match("^H(%d+)$")  -- 严格匹配H开头纯数字
        end
        if (h_val ==nil and p_val==nil and s_val==nil)then
          return
        end

        counter_type = nil
        if p_val then
            counter_type = "P"
        elseif h_val then
            counter_type = "H"
        end

        counter_value = h_val or p_val  -- 保留原有逻辑兼容性

        if p_val then
          counter_type = "P"
        end
        if h_val then
          counter_type = "H"
        end

        if existing_counter then
            existing_counter.destruct()
        end
        spawnCounter(counter_zone, counter_type, counter_value)
        if s_val then
            local shield_pos = zone.getPosition() + vector(0, 3, 1)
              shield_bag.takeObject({
                  position = shield_pos,
                  rotation = {0,180,0},
                  callback_function = function(o) -- ��������������������������里开始回调函数
                  -- o.setLock(true)
                  o.call("setValue", tonumber(s_val))
                  o.setVar("val",tonumber(s_val))
                  -- Wait.time(function() o.setLock(false) end, 1)
                  end
              })
        end


        info.setDescription("")
    end
end
end

function rest()
  addMe = 0
end

function tableContains(table, element)
  for _, value in pairs(table) do
    if value == element then

      print(toString(value) .. ' true')
      return true
    end
  end
  print(toString(value) .. ' false')
  return false
end

function onLoad()
  self.setName("Nemesis Board")
  card_zones = {
      "78801d", "8aabc9", "b04ec4", "64ca97", "0238fa", "b3a9df"
  }
  counter_zones = {
      "5026e7", "04f1f6", "649cde", "b26e18", "86234d", "67e177"
  }

  power_bag = getObjectFromGUID("e941e9")
  health_bag = getObjectFromGUID("90aabe")
  shield_bag = getObjectFromGUID("07aac2")
  draw_nemesis_deck_params = {
    click_function = "drawNem",
    function_owner = self,
    label = "Draw Nemesis Card",
    position = {-0.8, 0.2 , 0.3},
    rotation = {0,0,0},
    width = 1500,
    height = 500,
    scale = {0.1,0.1,0.1},
    color = {0.5,1,0.5},
    font_color = {0,0,0},
    font_size = 150
  }
  self.createButton(draw_nemesis_deck_params)
end

function getCounterInZone(zone)
    local objects = zone.getObjects()
    for _, o in ipairs(objects) do
        if o.getName():find("Counter") then
            return o
        end
    end
end


function spawnCounter(zone, type, value)
    if type == "P" then
      target_bag = power_bag
    else
      target_bag = health_bag
    end

    target_bag.takeObject({
        position = zone.getPosition(),
        rotation = {0, 180, 0},
        smooth = false,
        callback_function = function(o)
            -- 正确调用方式
            o.call("setValue", tonumber(value))
            o.setVar("val",tonumber(value))
        end
    })
end

function drawNem()
    local source_guid = "71a6e1"
    local card_zones = {
        "78801d", "8aabc9", "b04ec4", "64ca97", "0238fa", "b3a9df"
    }
    local counter_zones = {
        "5026e7", "04f1f6", "649cde", "b26e18", "86234d", "67e177"
    }
    -- 简化有效性检测为卡牌类型判断


    -- 阶段1：精确检测卡牌位置（只识别卡牌对象）
    local occupied = {}
    for i, guid in ipairs(card_zones) do
        local zone = getObjectFromGUID(guid)
        if zone then
            for _, obj in ipairs(zone.getObjects()) do
                -- 严格过滤条件：有效对象且是卡牌类型且不是区域本身
                if obj ~= zone and isValidObject(obj) and obj.type == "Card" then
                    table.insert(occupied, i)
                    break  -- 每个区域只记录一次
                end
            end
        end
    end
    table.sort(occupied)  -- 确保升序排列

    -- 阶段2：改进型填补逻辑
    local original_max = #occupied > 0 and math.max(unpack(occupied)) or 0
    local actual_max_index = 0
    -- 预清理阶段：清除所有空位的计数器
    for pos = 1, 6 do
        if not tableContains(occupied, pos) then  -- 判��是否原本是空位
            local counter_zone = getObjectFromGUID(counter_zones[pos])
            if counter_zone then
                clearZoneContents(counter_zone, true)  -- 只清理计数器区域
            end
        end
    end

    -- 执行填补
    for i = #occupied, 1, -1 do
        local old_pos = occupied[i]
        local new_pos = i

        if old_pos > new_pos then
            local card_src = getObjectFromGUID(card_zones[old_pos])
            local card_dest = getObjectFromGUID(card_zones[new_pos])
            local counter_src = getObjectFromGUID(counter_zones[old_pos])
            local counter_dest = getObjectFromGUID(counter_zones[new_pos])

            -- 卡牌移动（保持原有逻辑）
            moveZoneContents(card_src, card_dest.getPosition()+vector(0,2,0))

            -- 计数器迁移（目标已预清理）
            moveCounter(counter_src, counter_dest)

            actual_max_index = math.max(actual_max_index, new_pos)
        end
    end

    -- 关键修正：处理未移动的情况
    if actual_max_index == 0 and #occupied > 0 then
        actual_max_index = original_max
    end

    -- 阶段4：精确计算目标位置
    local target_index = actual_max_index + 1

    local deck_zone = getObjectFromGUID(source_guid)
    if deck_zone then
        local decks = findDecksInZone(deck_zone)
        if decks and #decks > 0 then
          if target_index <= #card_zones then
            local safe_height_pos = deck_zone.getPosition() + vector(0, 3, 0)
            local target_pos = getObjectFromGUID(card_zones[target_index]).getPosition() + vector(0,2,0)
            if decks[1].type == "Card" then  -- 直接处理单卡
               decks[1].setRotation({0,180,0})
               decks[1].setPositionSmooth(target_pos)
            else  -- 原有卡组处理逻辑
                decks[1].takeObject({
                    position = safe_height_pos,
                    flip= true,
                    smooth =false,
                    callback_function = function(card)
                        card.setPositionSmooth(target_pos)
                    end
                })
            end
            else
              -- 高空坠落特效加强版
              local spawn_pos = deck_zone.getPosition() + vector(0, 5, 0)
              decks[1].takeObject({
                  position = spawn_pos,
                  flip = true,
                  rotation = {0, math.random(170,190), 0},
                  callback_function = function(card)
                      card.setVelocity(vector(0, -5, 0))
                      card.setAngularVelocity(vector(math.random(-5,5),0,math.random(-5,5)))
                  end
              })
              broadcastToAll("No space! Place manually!", {1,0,0})
            end
        end
    end
end

function findDecksInZone(zone)
    local decksFound = {}
    -- 使用更可靠的类型判断
    for _, object in ipairs(zone.getObjects()) do
        -- 修正为检查type而不是tag
        if object.type == "Deck" or object.type == "Card" then
            table.insert(decksFound, object)
        end
    end
    return decksFound -- 始终返回table（可能为空）
end


function moveZoneContents(src_zone, dest_pos, rotation, callback)
    local moved = false
    local objs = src_zone.getObjects()

    for _, obj in ipairs(objs) do
        if obj ~= src_zone and isValidObject(obj) then
            -- 物理特性重置
            obj.setVelocity({0,0,0})
            obj.setAngularVelocity({0,0,0})

            -- 分步移动
            if obj.getName() == "Shield Counter" then
              dest_pos = dest_pos + vector(0,0,1)
            end
            obj.setPositionSmooth(dest_pos)

            moved = true
        end
    end

    -- 无对象移动时立即回调
    if not moved and callback then
        callback()
    end
end

function isValidObject(obj)
    return obj.type == "Card" or obj.getName() == "Shield Counter"
end

function moveCounter(src_zone, dest_zone)
    if not src_zone or not dest_zone then return end

    -- 精确识别并移动计数器
    local valid_counters = {
        ["Health Counter"] = true,
        ["Power Counter"] = true
    }

    local objs = src_zone.getObjects()
    for _, obj in ipairs(objs) do
        -- 多重安全校验
        if valid_counters[obj.getName()] then
        obj.setPositionSmooth(dest_zone.getPosition()+vector(0, 2, 0))
        end
    end
end

function clearZoneContents(zone)
    local objs = zone.getObjects()
    for _, obj in ipairs(objs) do
        -- 保留区域本身和有效计数器
        if isCounter(obj) then
            obj.destruct()
        end
    end
end

function isCounter(obj)
    local valid_counters = {
        ["Health Counter"] = true,
        ["Power Counter"] = true
    }
    return valid_counters[obj.getName()]
end

function tableContains(tbl, item)
    for _, v in ipairs(tbl) do
        if v == item then return true end
    end
    return false
end