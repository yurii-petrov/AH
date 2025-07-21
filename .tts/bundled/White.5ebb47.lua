info = {}
obj_GUID = {}
me = {}
mePos = {}
bagNum = 1
zone_GUID = ''
myPlayer = ''
mainBoardStore = {}
phoenixStore = {}
mageBagDeck = 'ad35d0'
mageDeck = 'e922d3'
myBag = '65eb1b'
myTokens = 'b29239'
myTimer = ''
canContinue = true
myPlayer = 'White'
chargeCounter = 0
MageCharge = 0
charge_zone = "b29239"
charge_token_bag = "65eb1b"
canContinue = true

function onCollisionEnter(info)


end

function onObjectEnterScriptingZone(zone, info)
    if (zone.getGUID() == zone_GUID) then
      obj_GUID = info.getGUID()
      if (info.getDescription() == "Mage" and info.type == "Bag") then
        bagNum = info.getQuantity()
        pullItems(info,bagNum)
        print("Setting up " .. info.getName())
      end
      if (info.type == "Card" and info.getGMNotes() == 'MageRandomiser') then
        info.drop()
        getMageBag(info)
        local myPos2 = getObjectFromGUID('d089df').getPosition()
        info.setPosition(myPos2 + vector(0,8,0))
        info.setVelocity({0,0,0})
        info.setAngularVelocity({0,0,0})
      end
    end
end

function getMageBag(card)
  --print(mageBagDeck .. " / " .. card.getName())
  local getBag = searchDeck(getObjectFromGUID(mageBagDeck),card.getName(),vector(-55.42, 0.35, 13.44),{0,180,0},'Name','Mage Bag does not exist in box.')
  getBag.setPosition(mePos + vector(0,5,-5))
  getBag.setRotation({0,180,0})
end

function searchDeck(deck, charName,pos,rot,nameOrDes,error)

    for _, card in pairs(deck.getObjects()) do
      if (nameOrDes == "Des" and card.description == charName) or (nameOrDes == "Name" and card.name == charName) then
        return(deck.takeObject({guid = card.guid, position = pos, rotation = rot}))
      end
    end
    local myError = error or ''
    if (myError ~= '') then
      broadcastToAll(error,{r = 1, g = 0, b = 0})
    end
end

function pullItems(obj,num)
  local params = {}
  params = {
    position = mePos + vector(0,5,-5),
    smooth = false,
    callback_function = function(obj) takeCallback(obj) end
    }

  for j = 1, num do
      obj.takeObject(params)
  end
  destroyObject(obj)
end

function lockMainBoard()
  mainBoardStore.setLock(true)
end

function lockPhoenixBoard()
  phoenixStore.setLock(true)
end


function takeCallback(obj_spawned)
  local myDes = obj_spawned.getDescription()
  local myName = obj_spawned.getName()
  --print(tostring(myDes) .. tostring(myName))
  if (myDes == "Main  Board") then
    obj_spawned.setRotation({0,180,0})
  end
    if (myName == "Breach I") then
        obj_spawned.setPosition(mePos + vector(-10.5,3,7.1))
        obj_spawned.setRotation(obj_spawned.getTable('myRot'))
      end
    if (myName == "Breach II") then
        obj_spawned.setPosition(mePos + vector(-3.5,3,7.1))
        obj_spawned.setRotation(obj_spawned.getTable('myRot'))
    end
    if (myName == "Breach IV") then
        obj_spawned.setPosition(mePos + vector(10.5,3,7.1))
        obj_spawned.setRotation(obj_spawned.getTable('myRot'))
    end
    if (myName == "Breach III") then
        obj_spawned.setPosition(mePos + vector(3.5,3,7.1))
        obj_spawned.setRotation(obj_spawned.getTable('myRot'))
    end

      if (myName == "Deck") then
        obj_spawned.setPosition(mePos + vector(-14,3,-6.4))
        obj_spawned.setRotation({0.00, 180.00, 180.00})
    end
    if (myName == "Hand") then
      obj_spawned.deal(5,myPlayer)
    end
    if (myDes == "Bag 1") then
      local add = 0
      if (myName == '[6495ED]Storm Tokens[-] [i](+1 Damage)[/i]') then
        add = 8
      end
      obj_spawned.setPosition(mePos + vector(-2,16 + add,-3))
      obj_spawned.setRotation({0.00, 0.00, 0.00})
      obj_spawned.setDescription(obj_spawned.getGMNotes())
      obj_spawned.setGMNotes('')
    end
    if (myDes == "Bag 2") then
      obj_spawned.setPosition(mePos + vector(-2,12,-5))
      obj_spawned.setRotation({0.00, 0.00, 0.00})
      obj_spawned.setDescription(obj_spawned.getGMNotes())
      obj_spawned.setGMNotes('')
    end
    if (myDes == "Bag 3") then
      obj_spawned.setPosition(mePos + vector(-4,12,-3))
      obj_spawned.setRotation({0.00, 0.00, 0.00})
      obj_spawned.setDescription(obj_spawned.getGMNotes())
      obj_spawned.setGMNotes('')
    end
    if (myDes == "Bag 4") then
      obj_spawned.setPosition(mePos + vector(-4,12,-5))
      obj_spawned.setRotation({0.00, 0.00, 0.00})
      obj_spawned.setDescription(obj_spawned.getGMNotes())
      obj_spawned.setGMNotes('')
    end
    if (myDes == "Minor Deck Shuffled") then
      obj_spawned.setPosition(mePos + vector(-21,3,-6.4))
      obj_spawned.setRotation({0.00, 180.00, 180.00})
      obj_spawned.shuffle()
  end
    if (myDes == "Minor Deck 1") then
      obj_spawned.setPosition(mePos + vector(-21,3,-6.4))
      obj_spawned.setRotation({0.00, 180.00, 0})
  end
  if (myDes == "Minor Deck 2") or (myName == "Soul Facet") then
    obj_spawned.setPosition(mePos + vector(21,3,-6.4))
    obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myDes == "Main Board") then
  obj_spawned.setPosition(mePos + vector(0, 2, -5.19))
  obj_spawned.setRotation({0.00, 180.00, 0})
  mainBoardStore = obj_spawned
  Wait.time(lockMainBoard,4)
  obj_spawned.setDescription("For any extra rules, hold ALT + SHIFT to view underneath this board.")
end
if (myName == "Phoenix Breach") then
  obj_spawned.setPosition(mePos + vector(-3.48, 0.21, 7.22))
  obj_spawned.setRotation({0.00,180.00,0.00})
  obj_spawned.setDescription("This breach cannot be destroyed. Only Phoenix spells can be prepped here.")
  phoenixStore = obj_spawned
  Wait.time(lockPhoenixBoard,4)
end
if (myName == "Phoenix Spell Deck") then
  obj_spawned.setPosition(mePos + vector(-9.68, 8, 10.17))
  obj_spawned.setRotation({0.00, 180.00, 180.00})
  obj_spawned.shuffle()
end
if (myDes == "Qu") or (myName == "[E7E52C]Tether Token[-]") then
  obj_spawned.setPosition(mePos + vector(-4.04,4,-5.6))
  if (myDes == "Qu") then
    obj_spawned.setRotation({0.00, 180.00, 180.00})
  else
    obj_spawned.setRotation({0.00, 180.00, 0})
  end
end
if (myDes == "Taqren") or (myDes == "Zhana 1") then
  obj_spawned.setPosition(mePos + vector(-5.8,4,-1.8))
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myDes == "Zhana 2") then
  obj_spawned.setPosition(mePos + vector(-1.8,4,-1.8))
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myDes == "Zhana 3") then
  obj_spawned.setPosition(mePos + vector(-5.8,4,-6.2))
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myDes == "Zhana 4") then
  obj_spawned.setPosition(mePos + vector(-1.8,4,-6.2))
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myDes == "Zhana 5") then
  obj_spawned.setPosition(mePos + vector(-3.4,4,-9.8))
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myDes == "Ohat") then
  obj_spawned.setPosition(mePos + vector(-4.04,4,-5.6))
  obj_spawned.setRotation({0.00, 180.00, 0.00})
end
if (myName == "Errated Deck") then
	local binObj = getObjectFromGUID(BIN)
  obj_spawned.setPosition(binObj.getPosition() + vector(0,4,0))
end
if (myName == "Under Consuming Breach") then
  phoenixStore = obj_spawned
  Wait.time(lockPhoenixBoard,4)
end

if (myName == "Gygar Reminder Token") then
  if (obj_spawned.getDescription() ~= 'This effect is in addition to any Legacy sticker abilities.') then
    obj_spawned.setPosition(mePos + vector(-3.7, 4, -8.94))
    --im getting sick of eyeballing this so screw it
  else
  obj_spawned.setPosition(mePos + vector(-4.2, 8, -3.94))
  end
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myName == "Builder Token") then
  obj_spawned.setPosition(mePos + vector(-5.49, 6, -4))
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myName == "Rhys Breach Board") then
--{70.00, 1.85, -34.00}
	--{73.99, 2.00, -22.26}
	  obj_spawned.setPosition(mePos + vector(3.99, 0.15, 10.74))
  obj_spawned.setRotation({0.00,180.00,0.00})
  obj_spawned.setScale({2.54,1.00,2.64})
  obj_spawned.setDescription("Rhys can have up to 6 breaches. They are found in the Gear bag.")
  phoenixStore = obj_spawned
  Wait.time(lockPhoenixBoard,4)
end
if (myName == "Destroyer Token") then
  obj_spawned.setPosition(mePos + vector(-2.39, 6, -4))
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myDes == "Path1") then
  obj_spawned.setPosition(mePos + vector(-10.5, 4, -13.5))
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myDes == "Path2") then
  obj_spawned.setPosition(mePos + vector(-5.5, 4, -13.5))
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myDes == "Path3") then
  obj_spawned.setPosition(mePos + vector(10.5, 4, -13.5))
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myDes == "Path4") then
  obj_spawned.setPosition(mePos + vector(5.5, 4, -13.5))
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myDes == "Manifest Token") then
  obj_spawned.setPosition(mePos + vector(0, 0, -16.5))
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myDes == "destiny token 1") then
  obj_spawned.setPosition(mePos + vector(-14, 0, -16.5))
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myDes == "destiny token 2") then
  obj_spawned.setPosition(mePos + vector(-7, 0, -16.5))
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myDes == "destiny token 3") then
  obj_spawned.setPosition(mePos + vector(0, 0, -16.5))
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myDes == "destiny token 4") then
  obj_spawned.setPosition(mePos + vector(7, 0, -16.5))
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myDes == "destiny token 5") then
  obj_spawned.setPosition(mePos + vector(14, 0, -16.5))
  obj_spawned.setRotation({0.00, 180.00, 0})
end
end

function onLoad()
  me = getObjectFromGUID(self.guid)
  mePos = me.getPosition()
  zone_GUID = me.getDescription()
  myPlayer = me.getName()
  BIN = me.getGMNotes()
  activate_ability_params={
    click_function = 'ability',
    function_owner = self,
    label = 'Activate\nAbility',
    position = {-0.3,0.1,1.1},
    rotation = {0,0,0},
    width = 1200,
    height = 650,
    font_size = 190,
    tooltip = "Use ability! Removes all charge tokens from your sheet.",
    color = {r=0.5,b=0.5,g=1},
    scale = {0.1,0.1,0.1}
  }
  charge_params={
    click_function = 'chargeButtonClick',
    function_owner = self,
    label = 'Charge',
    position = {0,0.1,1.1},
    rotation = {0,0,0},
    width = 1200,
    height = 650,
    font_size = 190,
    scale = {0.1,0.1,0.1},
    font_color = {r=0/255,b=0/255,g=0/255},
    tooltip = "Left Click to Gain a Charge. Right Click to Lose a Charge.",
    color = {r=0/255,b=254/255,g=215/255}
  }
  draw_aether_params = {
    click_function = 'draw_aether',
    function_owner = self,
    label = 'Aether',
    position = {0.3,0.1,1.1},
    rotation = {0,0,0},
    width = 1200,
    height = 650,
    font_size = 190,
    scale = {0.1,0.1,0.1},
    font_color = {r=113/255,b=23/255,g=59/255},
    tooltip = "Draw an aether token (The token card will be automatically returned when discarded from your hand)",
    color = {r=231/255,b=44/255,g=229/255}

          }  -- body...
  self.createButton(draw_aether_params)
  self.createButton(activate_ability_params)
  self.createButton(charge_params)
end

function ability()
  if (canContinue == false) then
    return(nil)
  end
    local charge_button = getObjectFromGUID('f49f3e')
    if charge_button ~= nil then
      getObjectFromGUID('f49f3e').setVar('chargeCounter',0)
    end
    tokenObject = getObjectFromGUID(myTokens)
    findTokensInZone(tokenObject)
end


function findTokensInZone(zone)
    local objectsInZone = zone.getObjects()
    local decksFound = {}
    local locBag = getObjectFromGUID(myBag)
    for i, object in ipairs(objectsInZone) do
        if object.getName() == "Charge Token" then
            object.setPositionSmooth(locBag.getPosition() + vector(0,i*2,0), false, false)
        end
    end
end


function chargeButtonClick(obj, player, alt_click)

    if canContinue then
      reorganize_charges()
      if alt_click == false then -- left_click
          gain_charge()
          Wait.time(enable_continue,0.16)
      elseif alt_click == true then -- right_click
          lose_charge()
      end
    end
end


function gain_charge()
    canContinue = false
    local snapList = getOrderedSnapPoints(charge_zone)
    local tokenBag = getObjectFromGUID(charge_token_bag)
    MageCharge = #snapList
    chargeCounter = chargeCounter + 1
    if MageCharge == 0 then
      chargeCounter = 0
      return
    end
    if chargeCounter > MageCharge then
        broadcastToAll("Cannot Place More Charge Token", {1,0,0})
        chargeCounter = chargeCounter - 1
        return
    end
    local targetPos = snapList[chargeCounter].position:copy()
    targetPos.y = 2.5

    tokenBag.takeObject({
      position = tokenBag.getPosition(),
      smooth = false,
      callback_function = function(obj)
          if obj then
              obj.setPositionSmooth(targetPos, false, true)  -- 启用快速移动
          end
      end
    })

end

function lose_charge()
  local tokenBag = getObjectFromGUID(charge_token_bag)
  local zone = getObjectFromGUID(charge_zone)
  local objectsInZone = zone.getObjects()
  local inZoneTokens = {}
  for _, obj in ipairs(objectsInZone) do
    if obj.getName() == "Charge Token" then
        table.insert(inZoneTokens, obj)
    end
  end
  if #inZoneTokens > 0 then
    table.sort(inZoneTokens, function(a,b)
        return a.getPosition().x > b.getPosition().x
    end)

    -- 回收最右侧代币
    tokenBag.putObject(inZoneTokens[1])
    chargeCounter = math.max(0, chargeCounter - 1)
  else
    return
  end

end

function getOrderedSnapPoints(zoneGUID)
    local zone = getObjectFromGUID(zoneGUID)
    local zonePos = zone.getPosition()
    local zoneScale = zone.getScale()
    local minX, maxX = zonePos.x - zoneScale.x/2, zonePos.x + zoneScale.x/2
    local minZ, maxZ = zonePos.z - zoneScale.z/2, zonePos.z + zoneScale.z/2

    local objectsInZone = zone.getObjects()

    local validPoints = 0
    local points = {}

    for _, obj in ipairs(zone.getObjects()) do
        for _, sp in ipairs(obj.getSnapPoints() or {}) do
            local worldPos = obj.positionToWorld(sp.position)
            if worldPos.x >= minX and worldPos.x <= maxX
            and worldPos.z >= minZ and worldPos.z <= maxZ then
                validPoints = validPoints + 1
                table.insert(points, {
                    position = worldPos,
                    source = obj
                })
            end
        end
    end

    table.sort(points, function(a,b) return a.position.x < b.position.x end)
    return points
end

function reorganize_charges()
    local zone = getObjectFromGUID(charge_zone)
    local tokenBag = getObjectFromGUID(charge_token_bag)

    local existingTokens = {}
    for _, obj in ipairs(zone.getObjects()) do
        if obj.getName() == "Charge Token" then
            table.insert(existingTokens, obj)
        end
    end

    table.sort(existingTokens, function(a,b) return a.getPosition().x < b.getPosition().x end)
    local snapList = getOrderedSnapPoints(charge_zone)

    -- 重新排列token
    for i = 1, math.min(#snapList, #existingTokens) do
        local token = existingTokens[i]
        local currentPos = token.getPosition()
        local targetPos = snapList[i].position:copy()

        -- 仅修改XZ坐标，保持原有Y轴高度
        targetPos:setAt('y', currentPos.y)    -- 保持原始高度
        targetPos:setAt('x', targetPos.x)     -- 使用吸附点X坐标
        targetPos:setAt('z', targetPos.z)     -- 使用吸附点Z坐标

        -- 仅在需要移动时更新位置
        if currentPos:distance(targetPos) > 0.1 then
            token.setPositionSmooth(targetPos, false, true)
        end
    end

    -- 优化计数器更新逻辑
    chargeCounter = math.min(#existingTokens, #snapList)
end
function enable_continue()
  canContinue = true
end

function draw_aether()
  local token_bag = getObjectFromGUID('4a10c6')
  token_bag.deal(1, myPlayer)
end