myDeck = '695bba'
myDiscard = '2ff5f0'
myBag = 'dd9a90'
myTokens = '0b7ea6'
myTimer = ''
canContinue = true
function onLoad()
  button = {click_function = 'nextTurn',
                                function_owner = self,
                                label = 'Activate\nXaxos',
                                position = {0,0.1,0},
                                rotation = {0,0,0},
                                width = 2000,
                                height = 750,
                                font_size = 200,
                                tooltip = "Flip a Xaxos spell card. Flips and shuffles automatically if deck is empty.",
                                color = {r=0.5,b=0.5,g=1}

          }  -- body...
    self.createButton(button)
    self.setLock(true)
end

function nextTurn()
  if (canContinue == false) then
    return(nil)
  end
  deckObject = getObjectFromGUID(myDeck)
  discardObject = getObjectFromGUID(myDiscard)
  tokenObject = getObjectFromGUID(myTokens)
  findDeck = findDecksInZone(deckObject)
  findDiscard = findDecksInZone(discardObject)
  if findDeck == nil and findDiscard == nil then
    broadcastToAll("There is no Xaxos deck or discard pile!", {r = 1, g = 0, b = 0})
    return(nil)
  end

  local pos = discardObject.getPosition() + vector(0,2,0)
  local rot = {0,180,0}
  deckParam = {position = pos,rotation = rot, smooth = true}
  if findDeck ~= nil then
    if (findDeck.tag == "Deck") then
      findDeck.takeObject(deckParam)
    elseif (findDeck.tag == "Card") then
      findDeck.setPositionSmooth(pos)
      findDeck.setRotationSmooth(rot)
    end
    findTokensInZone(tokenObject)
    canContinue = false
    Wait.time(flipBool,1)
  else
    if (findDiscard ~= nil) then
      findDiscard.setPositionSmooth(deckObject.getPosition() + vector(0,3,0))
      findDiscard.setRotation({0,180,180})
      findDiscard.shuffle()
      findDiscard.setName("Xaxos Spell Deck")
      canContinue = false
      Wait.time(flipBool,1.4)
      Wait.time(nextTurn,1.5)
    else
      broadcastToAll("There is no Xaxos deck or discard pile!", {r = 1, g = 0, b = 0})
      return(nil)
    end

  end
end

function flipBool()
  canContinue = true
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