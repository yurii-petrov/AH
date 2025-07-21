--[[ Lua code. See documentation: https://api.tabletopsimulator.com/ --]]
discardZones = {
    ["White"]  = "f6d8d7",
    ["Orange"] = "1dd831",
    ["Blue"]   = "45a28a",
    ["Purple"] = "aa8a91"
}
--[[ The onLoad event is called after the game save finishes loading. --]]
function onLoad()
    --[[ print('onLoad!') --]]
    addHotkey("Gain a Card", function(playerColor, object, isKeyUp)
      local obj = Player[playerColor].getHoverObject()
      if obj and (obj.tag == "Card") then
          local guid = discardZones[playerColor]
          if guid then
              local discardZone = getObjectFromGUID(guid)
              if discardZone then
                  obj.setPositionSmooth(discardZone.getPosition()+vector(0,2,0), false,true)
                  obj.setRotation({0, 180, 0})
              end
          end
      end
    end, false)
    addHotkey("Discard a token", function(playerColor, object, isKeyUp)
      local trashBag = getObjectFromGUID("2f91ae")
      local hoveredObject = Player[playerColor].getHoverObject()
      if hoveredObject == nil then
        return
      end
      local forbiddenTypes = {["Deck"]=true, ["Card"]=true}
      if forbiddenTypes[hoveredObject.type] then
          return
      end

      if hoveredObject.getLock() then
          return
      end
      hoveredObject.setPositionSmooth(trashBag.getPosition()+vector(0,1,0), flase, true) -- 平滑移动
    end, false)
    addHotkey("Charge token", function(playerColor, object, isKeyUp)
      getObjectFromGUID("65eb1b").takeObject({
          position = Player[playerColor].getPointerPosition()+ vector(0,2,0),
          rotation = {0,180,0},
          smooth = false
      })
    end, false)
    addHotkey("Aether token", function(playerColor, object, isKeyUp)
      getObjectFromGUID("75aee6").takeObject({
          position = Player[playerColor].getPointerPosition()+ vector(0,2,0),
          rotation = {0,180,0},
          smooth = false
      })
    end, false)

end

--[[ The onUpdate event is called once per frame. --]]
function onUpdate()
    --[[ print('onUpdate loop!') --]]
end

function onScriptingButtonDown(index, playerColor)
  if index == 1 then
      local obj = Player[playerColor].getHoverObject()
      if obj and (obj.tag == "Card") then
          local guid = discardZones[playerColor]
          if guid then
              local discardZone = getObjectFromGUID(guid)
              if discardZone then
                  obj.setPositionSmooth(discardZone.getPosition()+vector(0,2,0), false,true)
                  obj.setRotation({0, 180, 0})
              end
          end
      end
  end
  if index == 2 then
    local trashBag = getObjectFromGUID("2f91ae")
    local hoveredObject = Player[playerColor].getHoverObject()
    if hoveredObject == nil then
      return
    end
    local forbiddenTypes = {["Deck"]=true, ["Card"]=true}
    if forbiddenTypes[hoveredObject.type] then
        return
    end

    if hoveredObject.getLock() then
        return
    end
    hoveredObject.setPositionSmooth(trashBag.getPosition()+vector(0,1,0), flase, true) -- 平滑移动
  end
  if index ==3 then
    getObjectFromGUID("65eb1b").takeObject({
        position = Player[playerColor].getPointerPosition() + vector(0,2,0),
        rotation = {0,180,0},
        smooth = false
    })
  end
  if index ==4 then
    getObjectFromGUID("75aee6").takeObject({
        position = Player[playerColor].getPointerPosition()+ vector(0,2,0),
        rotation = {0,180,0},
        smooth = false
    })
  end
end