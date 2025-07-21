info = {}
obj_GUID = {}
me = {}
mePos = {}
bagNum = 1
zone_GUID = ''
myPlayer = ''
mainBoardStore = {}
phoenixStore = {}
friendBagDeck = '6d8d24'
friendDeck = 'd91a46'
clear_setup = 'b9111a'
friend_off_button = 'cbe10f'



function onCollisionEnter(info)


end

function onObjectEnterScriptingZone(zone, info)
    --print(info.getGUID())
    if (zone.getGUID() == zone_GUID) then
      obj_GUID = info.getGUID()

      -- print(tostring(info) .. " collided with " .. tostring(self))
      obj_GUID = getObjectFromGUID(info.guid)
      if (info.getDescription() == "Friend" and info.type == "Bag") then

        if getObjectFromGUID(friend_off_button)~= nil  and getObjectFromGUID(clear_setup)~= nil  then
          getObjectFromGUID(friend_off_button).call("offR")
          getObjectFromGUID(clear_setup).setVar('friend',true)
        end
        broadcastToAll("Don't forget to include Banner Cards in your starting deck", {r=0,b=0,g=1})
        -- print("Is a bag")
        bagNum = info.getQuantity()
        --print(tostring(bagNum))
        pullItems(info,bagNum)
          -- print("Is not a bag")
          local myPos2 = getObjectFromGUID('d089df').getPosition()
        print("Setting up " .. info.getName())
        --searchDeck(getObjectFromGUID('e922d3'),info.getName(),myPos2 + vector(0,8,0),{0,180,0},'Name')
        friend_turn_card = getObjectFromGUID('f990f0')
        friend_turn_card.setPosition({17.25, 2, -7.01})
        friend_turn_card.setRotation({0,180,180})
        Wait.time(function()
          zone = getObjectFromGUID('d3724a')
          turn_order_deck = findDecksInZone(zone)
          if turn_order_deck ~= nil then
            turn_order_deck.shuffle()
          end
        end,0.5)
      end
      if (info.type == "Card" and info.getGMNotes() == 'FriendRandomiser') then
        info.drop()
        getFriendBag(info)
        --local getBag = getObjectFromGUID(info.getDescription())
        --getBag.setPositionSmooth(mePos + vector(0,5,-5))
        --local myPos2 = getObjectFromGUID('d089df').getPosition()
        --info.setPositionSmooth(myPos2 + vector(0,8,0))
        local myPos2 = getObjectFromGUID('d089df').getPosition()
        info.setPositionSmooth(myPos2 + vector(0,6,0))
      end
    end
end

function getFriendBag(card)
  --print(mageBagDeck .. " / " .. card.getName())
  local getBag = searchDeck(getObjectFromGUID(friendBagDeck),card.getName(),vector(-55.42, 0.35, 13.44),{0,180,0},'Name','Friend Bag does not exist in box.')
  getBag.setPositionSmooth(mePos + vector(0,5,0))

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


function onLoad()
  me = getObjectFromGUID(self.guid)
  mePos = me.getPosition()
  zone_GUID = me.getDescription()
  myPlayer = me.getName()
end


function takeCallback(obj_spawned)
  local myDes = obj_spawned.getDescription()
  local myName = obj_spawned.getName()
  local myDeck = '986585'
  local myDiscard = 'c72ff9'
  --print(tostring(myDes) .. tostring(myName))
  if (myDes == "Main Board") then
    obj_spawned.setPositionSmooth(mePos+vector(0, 1, 0))
    obj_spawned.setRotation({0,180,0})
  end
  if (myDes == "Minor Deck Shuffled") then
    obj_spawned.setPositionSmooth(mePos+vector(18.28, 1, -0.52))
    obj_spawned.setRotation({0.00, 180.00, 180.00})
    obj_spawned.shuffle()
  end
  if (myDes == "Minor Deck") then
    obj_spawned.setPositionSmooth(mePos+vector(18.28, 1, -0.52))
    obj_spawned.setRotation({0.00, 180.00, 0.00})
  end
  if (myDes == "Friend Deck") then
    obj_spawned.setPositionSmooth(mePos+vector(-8.88, 1, -0.51))
    obj_spawned.setRotation({0.00, 180.00, 180.00})
    obj_spawned.shuffle()
    local button =  getObjectFromGUID("3eaeec")
    Wait.time(function()
      button.call('nextTurn',nil)
    end, 1)

    if(myName== "Myrna Deck") then
      local counter = getObjectFromGUID("aa372c")
      counter.call('setVal',2)
    end
  end
end
function findDecksInZone(zone)
    local objectsInZone = zone.getObjects()
    local decksFound = {}
    for i, object in ipairs(objectsInZone) do
        if object.type == "Deck" then
            return getObjectFromGUID(object.guid)
        end
    end
    if #decksFound > 0 then
        return decksFound
    else
        return nil
    end
end