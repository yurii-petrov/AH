myDeck = 'ea1713'
playerBoardGUID = {
  [1] = '5ebb47',
  [2] = 'e87d81',
  [3] = '7ff2e6',
  [4] = 'c3c58d'
}

function onLoad()
  button1 = {click_function = 'rot',
                                function_owner = self,
                                label = 'Curse of Rot',
                                position = {0,0.2,-0.7},
                                rotation = {0,0,0},
                                width = 500,
                                height = 170,
                                font_size = 50,
                                tooltip = "The player who clicks this gains Curse of Rot",
                                color = {r=0.65,b=0,g=0.6}

          }  -- body...
    button2 = {click_function = 'shard',
                                        function_owner = self,
                                        label = 'Cursed Shard',
                                        position = {0,0.2,-0.35},
                                        rotation = {0,0,0},
                                        width = 500,
                                        height = 170,
                                        font_size = 50,
                                        tooltip = "The player who clicks this gains a Cursed Shard",
                                        color = {r=0.75,b=0.65,g=0}

                  }
      button3 = {click_function = 'manacle',
                                          function_owner = self,
                                          label = 'Cursed Manacles',
                                          position = {0,0.2,0},
                                          rotation = {0,0,0},
                                          width = 500,
                                          height = 170,
                                          font_size = 50,
                                          tooltip = "The player who clicks this gains a Cursed Manacles",
                                          color = {r=0.15,b=0.95,g=0.1}

                    }
      button4 = {click_function = 'bolt',
                                          function_owner = self,
                                          label = 'Cursed Bolts',
                                          position = {0,0.2,0.35},
                                          rotation = {0,0,0},
                                          width = 500,
                                          height = 170,
                                          font_size = 50,
                                          tooltip = "The player who clicks this gains a Cursed Bolt",
                                          color = {r=0.75,b=0.05,g=0.8}
                    }
  button5 = {click_function = 'pearl',
                      function_owner = self,
                      label = 'Scorched Pearl',
                      position = {0,0.2,0.7},
                      rotation = {0,0,0},
                      width = 500,
                      height = 170,
                      font_size = 50,
                      tooltip = "The player who clicks this gains a Scorched Pearl",
                      color = {r=0,b=0,g=1}

            }  -- body...
    self.createButton(button1)
    self.createButton(button2)
    self.createButton(button3)
    self.createButton(button4)
    self.createButton(button5)
    self.setLock(true)
    self.setName("Curse Deck Scripting")
end

function rot(obj,playcolor)
  grabCard(playcolor,"Curse of Rot","There's no Curse of Rot in the Curse Deck.")
end

function shard(obj,playcolor)
  grabCard(playcolor,"Cursed Shard","There are no Cursed Shards in the Curse Deck.")
end

function manacle(obj,playcolor)
  grabCard(playcolor,"Cursed Manacles","There are no Cursed Manacles in the Curse Deck.")
end

function bolt(obj,playcolor)
  grabCard(playcolor,"Cursed Bolt","There are no Cursed Bolts in the Curse Deck.")
end

function pearl(obj,playcolor)
  grabCard(playcolor,"Scorched Pearl","There are no Scorched Pearls in the Curse Deck.")
end

function grabCard(color,myName,error)
  deckObj = findDecksInZone(getObjectFromGUID(myDeck))
  if deckObj == nil then
    broadcastToAll(error,{r = 1, g= 0, b = 0})
    return(nil)
  end
  if color == "White" then
    myBoard = playerBoardGUID[1]
  elseif color == "Orange" then
    myBoard = playerBoardGUID[2]
  elseif color == "Blue" then
    myBoard = playerBoardGUID[3]
  elseif color == "Purple" then
    myBoard = playerBoardGUID[4]
  end
  local boardPos = getObjectFromGUID(myBoard)
  if deckObj.tag == "Card" then
    if deckObj.getName() == myName then
      deckObj.setPositionSmooth(boardPos.getPosition() + vector(14,3,-6.4))
      deckObj.setRotationSmooth({0.00, 180.00, 0.00})
    else
      broadcastToAll(error,{r = 1, g= 0, b = 0})
    end
  else
    searchDeck(deckObj, myName, boardPos.getPosition() + vector(14,3,-6.4), {0.00, 180.00, 0.00},error)
  end
end

function takeObjectSafe(container, params, error)
    if params.guid ~= nil then
        for _, item in pairs(container.getObjects()) do
            if item.guid == params.guid then
                return container.takeObject(params)
            end
        end
    else
        return container.takeObject(params)
    end
    broadcastToAll(error,{r = 1, g= 0, b = 0})
end

function searchDeck(deck, charName,pos,rot,error)

    for _, card in pairs(deck.getObjects()) do
      if card.name == charName then
        return(deck.takeObject({guid = card.guid, position = pos, rotation = rot}))
      end
    end
    broadcastToAll(error,{r = 1, g = 0, b = 0})
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