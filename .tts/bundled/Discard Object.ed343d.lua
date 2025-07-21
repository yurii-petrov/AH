myPlayer = 'White'
myCount = 5
cCard = 1
loopCount = -1
handCount = 0
altC = 0
waitFunct = {}
function onLoad()
  button = {click_function = 'sendHand',
                                function_owner = self,
                                label = 'Send Hand to Discard',
                                position = {0,0.5,0},
                                rotation = {0,0,0},
                                width = 2200,
                                height = 750,
                                font_size = 200,
                                tooltip = "Sends your hand [b]except spells[/b] to the discard pile, in the current order its in. \n[i](Left to right)[/i]\n\n[b]Right click[/b] to send all cards regardless of type.",
                                color = {r=0.5,b=0.5,g=1}

          }  -- body...
    self.createButton(button)
    myDeck = self.getName()
    myDiscard = self.getDescription()
    self.setLock(true)
end

function sendHand(obj,color,alt_click)
  local owner = Player[myPlayer]
  altC = alt_click
  handCount = #owner.getHandObjects()
  if (#owner.getHandObjects() ~= 0) then
    loopCount = #owner.getHandObjects()
    waitFunct = Wait.time(moveCard,0.2,#owner.getHandObjects())
    --print(tostring(waitFunct))
  else
    if (Player[myPlayer].seated) then
      broadcastToColor("You have no hand.", myPlayer, {r =1, g = 1, b = 0})
    end
  end
end

function moveCard()
  local owner = Player[myPlayer]
  handCount = #owner.getHandObjects()
  loopCount = loopCount - 1
  local deckPos = getObjectFromGUID(myDiscard)
  local moveParam = deckPos.getPosition() + vector(0,1.4,0)


  local hand = Player[myPlayer].getHandObjects(1)

  for i, object in ipairs(hand) do
    if (object.hasTag('tokenCard') == false) then
      if object.type == "Card" and ((object.hasTag('spellCard') == false and  object.hasTag('nemesisDeckCard') == false) or altC == true) and i == cCard then
        card = object
      elseif object.type == "Card" and (object.hasTag('spellCard') == true or object.hasTag('nemesisDeckCard') == true) and i == cCard then
        cCard = cCard + 1
      end
    elseif (object.hasTag('tokenCard') == true) then
      object.destruct()
      --cCard = cCard + 1
    end
--card = object
      --print(tostring(cCard))


  end
  if (card ~= nil) then
    card.setPosition(moveParam, false, true)
    card.setRotation({0.00, 180.00, 0})
  end
  handCount = #owner.getHandObjects()
  --printToAll(tostring(handCount),{r=1,g=0,b=0})

  if loopCount <= 0 then --kill function early if needed
    --print('kill function')
    resetCount()
    loopCount = -1
    return(nil)
  end


end

function resetCount()
  cCard = 1
  --print('debug')
end

function findDecksInZone(zone)
    local objectsInZone = zone.getObjects()
    local decksFound = {}
    for i, object in ipairs(objectsInZone) do
        if object.tag == "Deck" or object.tag == "Card" then
            return getObjectFromGUID(object.guid)
        end
    end
    if #decksFound > 0 then
        return decksFound
    else
        return nil
    end
end