myDeck = 'd3724a'
myDiscard = '74276a'
myTimer = ''
canContinue = true

fourPlayer = false
threePlayer = false

function onLoad()
  button = {click_function = 'nextTurn',
                                function_owner = self,
                                label = 'Next Turn',
                                position = {0,0.1,0},
                                rotation = {0,0,0},
                                width = 2000,
                                height = 750,
                                font_size = 200,
                                tooltip = "Flip the deck turn order card. Flips and shuffles automatically if deck is empty.",
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
  findDeck = findDecksInZone(deckObject)
  findDiscard = findDecksInZone(discardObject)
  if findDeck == nil and findDiscard == nil then
    broadcastToAll("There is no turn order deck or discard pile!", {r = 1, g = 0, b = 0})
    return(nil)
  end

  local pos = discardObject.getPosition() + vector(0,1.5,0)
  local rot = {0,180,0}
  deckParam = {position = pos,rotation = rot, smooth = true}
  if findDeck ~= nil then
    if (findDeck.tag == "Deck") then
      findDeck.takeObject(deckParam)
    elseif (findDeck.tag == "Card") then
      findDeck.setPositionSmooth(pos)
      findDeck.setRotationSmooth(rot)
    end
    canContinue = false
    Wait.time(flipBool,1)
  else
    if (findDiscard ~= nil) then
      findDiscard.setPositionSmooth(deckObject.getPosition() + vector(0,1.5,0))
      findDiscard.setRotation({0,180,180})
      findDiscard.shuffle()
      findDiscard.setName("Turn Order Deck")
      canContinue = false
      if fourPlayer == true then
        local token1 = getObjectFromGUID('373770')
        local token2 = getObjectFromGUID('dc4292')
        token1.setPositionSmooth({2.04, 3.78, -17.92})
        token1.setRotation({0,180,0})
        token2.setPositionSmooth({-2.04, 3.78, -17.92})
        token2.setRotation({0,180,0})
      end
      if threePlayer == true then
        local token3 = getObjectFromGUID('1b87f7')
        local myPos = token3.getPosition()
        if myPos.x  > 48 then
          token3.setPositionSmooth({25.06, 5.64, -30.74}, false, true)
        else if myPos.x > 0 then
          token3.setPositionSmooth({-24.94, 5.64, -30.74}, false, true)
        else
            token3.setPositionSmooth({70.07, 5.64, -30.74}, false, true)
        end
        token3.setRotation({0,180,0})
      end
      end
      Wait.time(flipBool,0.5)
      Wait.time(nextTurn,0.5)
    else
      broadcastToAll("There is no turn order deck or discard pile!", {r = 1, g = 0, b = 0})
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