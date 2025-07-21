myPlayer = 'White'
myCount = 5

function onLoad()
  button = {click_function = 'draw5',
                                function_owner = self,
                                label = 'Draw to 5\nCards',
                                position = {-1.5,0.5,0},
                                rotation = {0,0,0},
                                width = 1400,
                                height = 750,
                                font_size = 200,
                                tooltip = "Draw up to 5 cards in hand.",
                                color = {r=0.5,b=1,g=0.5}

          }  -- body...
    button2 = {click_function = 'draw1',
                                        function_owner = self,
                                        label = 'Draw 1\nCard',
                                        position = {1.5,0.5,0},
                                        rotation = {0,0,0},
                                        width = 1400,
                                        height = 750,
                                        font_size = 200,
                                        tooltip = "Draw 1 card.",
                                        color = {r=1,b=0.5,g=0.5}
                  }  -- body...
    self.createButton(button)
    self.createButton(button2)
    myDeck = self.getName()
    myDiscard = self.getDescription()
end

function draw5()
  local cDeck = findDecksInZone(getObjectFromGUID(myDeck))
  local cDiscard = findDecksInZone(getObjectFromGUID(myDiscard))
  local owner = Player[myPlayer]
  local cCount = #owner.getHandObjects()
  if cCount < myCount then
    if cDeck ~= nil then
      Wait.time(checkDeck, 50/60)
    end
    local drawX = myCount - cCount
    for i = 1, drawX, 1 do
      cDeck = findDecksInZone(getObjectFromGUID(myDeck))
        if cDeck ~= nil then
          cDeck.deal(1,myPlayer)
        else
          if cDiscard == nil then
            if (Player[myPlayer].seated == true) then
              printToColor("Cannot flip Discard Pile.", myPlayer, {r=1,g=0,b=0})
            end
          return(nil)
          end
          flipDeck()
          Wait.time(draw5, 0.5)
          break
        end
    end
  else
    if (Player[myPlayer].seated == true) then
      broadcastToColor("Your hand already has " .. tostring(cCount) .. " cards", myPlayer, {r=1, g=1, b= 0})
    end
  end
end

function checkDeck()
  local owner = Player[myPlayer]
  local cCount = #owner.getHandObjects()
  if cCount < myCount then
    draw5()
  end
end
function draw1()
  local cDeck = findDecksInZone(getObjectFromGUID(myDeck))
  local cDiscard = findDecksInZone(getObjectFromGUID(myDiscard))
  local owner = Player[myPlayer]
  if cDeck ~= nil then
    cDeck.deal(1,myPlayer)
  else
    if cDiscard == nil then
      if (Player[myPlayer].seated == true) then
        printToColor("Cannot flip Discard Pile.", myPlayer, {r=1,g=0,b=0})
      end
    return(nil)
    end
    flipDeck()
    Wait.time(draw1, 0.5)
  end
end

function flipDeck()
  local cDiscard = findDecksInZone(getObjectFromGUID(myDiscard))
  local deckPos = getObjectFromGUID(myDeck)
  local owner = Player[myPlayer]
  if cDiscard ~= nil then
    local moveParam = deckPos.getPosition()
    cDiscard.setPositionSmooth(moveParam)
    cDiscard.setRotation({0.00, 180.00, 180.00})
  else
    if (#owner.seated == true) then
    printToColor("Cannot flip Discard Pile.", myPlayer, {r=1,g=0,b=0})
    end
  end
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