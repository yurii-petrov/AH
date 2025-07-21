marketBags = {
    --gem bags
    ["Gem1"] = "c70854",
    ["Gem2"] = "c70854",
    ["Gem3"] = "a0ee7c",
    ["Gem4"] = "326176",
    ["Gem5"] = "76b9b1",
    ["Gem6"] = "ae4191",
    ["Gem7"] = "ae4191",
    ["Spell1"] = "aef55f",
    ["Spell2"] = "aef55f",
    ["Spell3"] = "269f19",
    ["Spell4"] = "6b6868",
    ["Spell5"] = "70a46c",
    ["Spell6"] = "c2eea0",
    ["Spell7"] = "723b07",
    ["Spell8"] = "6a9948",
    ["Spell9"] = "6a9948",
    ["Relic1"] = "0bcafd",
    ["Relic2"] = "0bcafd",
    ["Relic3"] = "f696d8",
    ["Relic4"] = "5dd56e",
    ["Relic5"] = "ca6d11",
    ["Relic6"] = "f037fc",
    ["Relic7"] = "ca0abc",
    ["Relic8"] = "d42b3a",
    ["Relic9"] = "d42b3a"
}

swapBag = "524f69"
swapCount = 1
swapPosition = vector(50.45, 1.42, 5.04)
swapDictionary =
{
    ["[0DBF0D]Propel[-]"] = "[BF0DBF]Gather Force[-]",
    ["[0DBF0D]Inscrutable Artifact[-]"] = "[BF0DBF]Aetherrune[-]",
    ["[0DBF0D]Cavernous Maw[-]"] = "[BF0DBF]Dragonflare[-]",
    ["[0DBF0D]Consume Magic[-]"] = "[BF0DBF]Detonate[-]",
    ["[0DBF0D]Glowstone[-]"] = "[BF0DBF]Illuminite[-]",
    ["[0DBF0D]Encased Fossil[-]"] = "[BF0DBF]Diamin[-]",
    ["[0DBF0D]Fool's Gold[-]"] = "[BF0DBF]Smite[-]",
    ["[0DBF0D]Harbinger Descent[-]"] = "[BF0DBF]Apocalypse[-]"


}

zoneTable = {
    [1] = "243c0f",
    [2] = "27cf5f",
    [3] = "c08962",
    [4] = "d46559",
    [5] = "9bad65",
    [6] = "5ce8bd",
    [7] = "00e430",
    [8] = "8bea37",
    [9] = "e1bcd8"
}

playerBoardGUID = {
    [1] = "5ebb47",
    [2] = "e87d81",
    [3] = "7ff2e6",
    [4] = "c3c58d"
}



gem_random_deck_id = "d35e87"
spell_random_deck_id = "8cc318"
relic_random_deck_id = "bc68c5"
destroyID = "2f91ae"
barracksID = "d089df"
barracksPos = getObjectFromGUID(barracksID).getPosition()
locked = false

gem_random_script = '61d17d'
relic_random_script = 'feac97'
spell_random_script = 'c04785'

preventError = false

deckCostTable = {
    ["Cost0"] = 0,
    ["Cost1"] = 1,
    ["Cost2"] = 2,
    ["Cost3"] = 3,
    ["Cost4"] = 4,
    ["Cost5"] = 5,
    ["Cost6"] = 6,
    ["Cost7"] = 7,
    ["Cost8"] = 8,
    ["Cost9"] = 9
}

altCostTable =
{
  [1] = {[1] = 3, [2] = 3},
  [2] = {[1] = 3,[2] =3},
  [3] = {[1] = 3,[2] =4},
  [4] = {[1] = 3,[2] =5},
  [5] = {[1] = 4,[2] =6},
  [6] = {[1] = 5,[2] =7},
  [7] = {[1] = 6,[2] =8},
  [8] = {[1] = 6,[2] =8},
  [9] = {[1] = 7,[2] =8}
}
cost_plus = false
cost_minus = false
barracksOffset = 1

function resetOffset()
  barracksOffset = 1
end

function resetError()
  preventError = false
end


function setDecks()
  gem_random_deck_id = findDecksInZone(getObjectFromGUID(gem_random_script)).getGUID()
  getObjectFromGUID(gem_random_deck_id).shuffle()

  relic_random_deck_id = findDecksInZone(getObjectFromGUID(relic_random_script)).getGUID()
  getObjectFromGUID(relic_random_deck_id).shuffle()

  spell_random_deck_id = findDecksInZone(getObjectFromGUID(spell_random_script)).getGUID()
  getObjectFromGUID(spell_random_deck_id).shuffle()
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

function onLoad()
    local buttonWidth = 320
    local buttonHeight = 90
    local buttonY = 0.9
    local leftPos = -0.475
    local middlePos = 0
    local rightPos = leftPos + ((math.abs(leftPos) - math.abs(middlePos)) * 2)
    local toolT = "Reroll the card above for another card of the same cost and type.\nThe former current market card is put into destroyed objects.\n \n [b]Right Click[/b] to allow slightly randomised cost leeway, but at the extreme ends of the cost spectrum it favours the alternative cost!"
    local toolTp = "Reroll the card above for another card of the same type at cost +1."
    local toolTm = "Reroll the card above for another card of the same type at cost -1."
    buttonParameters = {
        Card1 = {
            index = 0,
            click_function = "Card1",
            function_owner = self,
            label = "Re",
            position = {leftPos, buttonY, -0.3},
            rotation = {0, 0, 0},
            width = buttonWidth/2,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolT
        },
        Card2 = {
            index = 1,
            click_function = "Card2",
            function_owner = self,
            label = "Re",
            position = {0, buttonY, -0.3},
            rotation = {0, 0, 0},
            width = buttonWidth/2,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolT
        },
        Card3 = {
            index = 2,
            click_function = "Card3",
            function_owner = self,
            label = "Re",
            position = {rightPos, buttonY, -0.3},
            rotation = {0, 0, 0},
            width = buttonWidth/2,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolT
        },
        Card4 = {
            index = 3,
            click_function = "Card4",
            function_owner = self,
            label = "Re",
            position = {leftPos, buttonY, 0.35},
            rotation = {0, 0, 0},
            width = buttonWidth/2,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolT
        },
        Card5 = {
            index = 4,
            click_function = "Card5",
            function_owner = self,
            label = "Re",
            position = {0, buttonY, 0.35},
            rotation = {0, 0, 0},
            width = buttonWidth/2,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolT
        },
        Card6 = {
            index = 5,
            click_function = "Card6",
            function_owner = self,
            label = "Re",
            position = {rightPos, buttonY, 0.35},
            rotation = {0, 0, 0},
            width = buttonWidth/2,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolT
        },
        Card7 = {
            index = 6,
            click_function = "Card7",
            function_owner = self,
            label = "Re",
            position = {leftPos, buttonY, 0.95},
            rotation = {0, 0, 0},
            width = buttonWidth/2,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolT
        },
        Card8 = {
            index = 7,
            click_function = "Card8",
            function_owner = self,
            label = "Re",
            position = {0, buttonY, 0.95},
            rotation = {0, 0, 0},
            width = buttonWidth/2,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolT
        },
        Card9 = {
            index = 8,
            click_function = "Card9",
            function_owner = self,
            label = "Re",
            position = {rightPos, buttonY, 0.95},
            rotation = {0, 0, 0},
            width = buttonWidth/2,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolT
        },
        Lock = {
            index = 9,
            click_function = "lockMarket",
            function_owner = self,
            label = "Lock\nMarket",
            position = {0.92, 0.1, 0},
            rotation = {0, 0, 0},
            width = buttonWidth*2,
            height = buttonHeight*4,
            color = {r = 0, g = 1, b = 1},
            scale ={0.25,0.25,0.25},
            font_size = 130,
            tooltip = "Locks in the market - This replaces the re-roll buttons with buy/gain buttons!"
        },
        Card1p = {
            index = 10,
            click_function = "Card1p",
            function_owner = self,
            label = "+",
            position = {leftPos+0.15, buttonY, -0.3},
            rotation = {0, 0, 0},
            width = buttonWidth/3,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolTp
        },
        Card1m = {
            index = 11,
            click_function = "Card1m",
            function_owner = self,
            label = "-",
            position = {leftPos-0.15, buttonY, -0.3},
            rotation = {0, 0, 0},
            width = buttonWidth/3,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolTm
        },
        Card2p = {
            index = 12,
            click_function = "Card2p",
            function_owner = self,
            label = "+",
            position = {0+0.15, buttonY, -0.3},
            rotation = {0, 0, 0},
            width = buttonWidth/3,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolTp
        },
        Card2m = {
            index = 13,
            click_function = "Card2m",
            function_owner = self,
            label = "-",
            position = {0-0.15, buttonY, -0.3},
            rotation = {0, 0, 0},
            width = buttonWidth/3,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolTm
        },
        Card3p = {
            index = 14,
            click_function = "Card3p",
            function_owner = self,
            label = "+",
            position = {rightPos+0.15, buttonY, -0.3},
            rotation = {0, 0, 0},
            width = buttonWidth/3,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolTp
        },
        Card3m = {
            index = 15,
            click_function = "Card3m",
            function_owner = self,
            label = "-",
            position = {rightPos-0.15, buttonY, -0.3},
            rotation = {0, 0, 0},
            width = buttonWidth/3,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolTm
        },
        Card4p = {
            index = 16,
            click_function = "Card4p",
            function_owner = self,
            label = "+",
            position = {leftPos+0.15, buttonY, 0.35},
            rotation = {0, 0, 0},
            width = buttonWidth/3,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolTp
        },
        Card4m = {
            index = 17,
            click_function = "Card4m",
            function_owner = self,
            label = "-",
            position = {leftPos-0.15, buttonY, 0.35},
            rotation = {0, 0, 0},
            width = buttonWidth/3,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolTm
        },
        Card5p = {
            index = 18,
            click_function = "Card5p",
            function_owner = self,
            label = "+",
            position = {0+0.15, buttonY, 0.35},
            rotation = {0, 0, 0},
            width = buttonWidth/3,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolTp
        },
        Card5m = {
            index = 19,
            click_function = "Card5m",
            function_owner = self,
            label = "-",
            position = {0-0.15, buttonY, 0.35},
            rotation = {0, 0, 0},
            width = buttonWidth/3,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolTm
        },
        Card6p = {
            index = 20,
            click_function = "Card6p",
            function_owner = self,
            label = "+",
            position = {rightPos+0.15, buttonY, 0.35},
            rotation = {0, 0, 0},
            width = buttonWidth/3,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolTp
        },
        Card6m = {
            index = 21,
            click_function = "Card6m",
            function_owner = self,
            label = "-",
            position = {rightPos-0.15, buttonY, 0.35},
            rotation = {0, 0, 0},
            width = buttonWidth/3,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolTm
        },
        Card7p = {
            index = 22,
            click_function = "Card7p",
            function_owner = self,
            label = "+",
            position = {leftPos+0.15, buttonY, 0.95},
            rotation = {0, 0, 0},
            width = buttonWidth/3,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolTp
        },
        Card7m = {
            index = 23,
            click_function = "Card7m",
            function_owner = self,
            label = "-",
            position = {leftPos-0.15, buttonY, 0.95},
            rotation = {0, 0, 0},
            width = buttonWidth/3,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolTm
        },
        Card8p = {
            index = 24,
            click_function = "Card8p",
            function_owner = self,
            label = "+",
            position = {0+0.15, buttonY, 0.95},
            rotation = {0, 0, 0},
            width = buttonWidth/3,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolTp
        },
        Card8m = {
            index = 25,
            click_function = "Card8m",
            function_owner = self,
            label = "-",
            position = {0-0.15, buttonY, 0.95},
            rotation = {0, 0, 0},
            width = buttonWidth/3,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolTm
        },
        Card9p = {
            index = 26,
            click_function = "Card9p",
            function_owner = self,
            label = "+",
            position = {rightPos+0.15, buttonY, 0.95},
            rotation = {0, 0, 0},
            width = buttonWidth/3,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolTp
        },
        Card9m = {
            index = 27,
            click_function = "Card9m",
            function_owner = self,
            label = "-",
            position = {rightPos-0.15, buttonY, 0.95},
            rotation = {0, 0, 0},
            width = buttonWidth/3,
            height = buttonHeight,
            scale ={0.5,0.5,0.5},
            font_size = 60,
            tooltip = toolTm
        },
    }

    for i, v in pairs(buttonParameters) do
        self.createButton(v)
    end
end

function rerollCard(pos,altclick)
    --print(altclick)

    deckObj = findDecksInZone(getObjectFromGUID(zoneTable[pos]))
    if deckObj == nil then
        broadcastToAll("No cards found at market position " .. tostring(pos) .. "!", {r = 1, g = 0, b = 0})
        return (nil)
    else
        setDecks()
        local deckType = ""
        local deckCost = ""
        if deckObj.hasTag("gemDeck") or deckObj.hasTag("gemCard") then
            deckType = "Gem"
        elseif deckObj.hasTag("spellDeck") or deckObj.hasTag("spellCard") then
            deckType = "Spell"
        elseif deckObj.hasTag("relicDeck") or deckObj.hasTag("relicCard") then
            deckType = "Relic"
        else
            broadcastToAll(
                "Invalid deck type/missing type tag at position " .. tostring(pos) .. "!",
                {r = 1, g = 0, b = 0}
            )
            return (nil)
        end
        --print(deckType)
        local maxCost = 7
        local minCost = 2
        local hardMax = 8
        if deckType == "Gem" then
          hardMax = 6
        end
        local GemMinCost = 2
        local GemMaxCost = 7
        local RelicMinCost = 1
        local RelicMaxCost = 8
        local SpellMinCost = 1
        local SpellMaxCost = 9
        if (deckObj.getGMNotes() ~= "" and tonumber(deckObj.getGMNotes()) ~= nil) then
          --and tonumber(deckObj.getGMNotes()) ~= 2 and tonumber(deckObj.getGMNotes()) < hardMax
          --^ old code check that I don't think is needed
          if (cost_plus == true) then
            cost_plus = false
            deckCost = deckObj.getGMNotes() + 1
            if deckType == "Gem" and deckCost>GemMaxCost then
              broadcastToAll("No more expensive gem!", {r = 1, g = 0, b = 0})
              return
            end
            if deckType == "Relic" and deckCost>RelicMaxCost then
              broadcastToAll("No more expensive relic!", {r = 1, g = 0, b = 0})
              return
            end
            if deckType == "Spell" and deckCost>SpellMaxCost then
              broadcastToAll("No more expensive spell!", {r = 1, g = 0, b = 0})
              return
            end
          elseif (cost_minus == true) then
            cost_minus = false
            deckCost = deckObj.getGMNotes() - 1
            if deckType == "Gem" and deckCost<GemMinCost then
              broadcastToAll("No less expensive gem!", {r = 1, g = 0, b = 0})
              return
            end
            if deckType == "Relic" and deckCost<RelicMinCost then
              broadcastToAll("No less expensive relic!", {r = 1, g = 0, b = 0})
              return
            end
            if deckType == "Spell" and deckCost<SpellMinCost then
              broadcastToAll("No less expensive spell!", {r = 1, g = 0, b = 0})
              return
            end
          else
            if (altclick == true) then
              minCost = altCostTable[tonumber(deckObj.getGMNotes())][1]
              maxCost = altCostTable[tonumber(deckObj.getGMNotes())][2]
              deckCost = math.random(minCost,maxCost)
              if deckType == "Gem" and deckCost > 6 then
                deckCost = 6
              end
            else
                deckCost = deckObj.getGMNotes()
            end
          end

        else
            broadcastToAll(
                "Invalid cost type/missing cost tag at position " .. tostring(pos) .. "!",
                {r = 1, g = 0, b = 0}
            )
            return (nil)
        end
        --print(deckCost)
        --print(deckObj.getName())
        --print(deckType .. deckCost)
        local destroyObj = getObjectFromGUID(destroyID)
        deckObj.setPositionSmooth(destroyObj.getPosition() + vector(0,5,0), false, true)
        searchDeck(
            getObjectFromGUID(barracksID),
            deckObj.getName(),
            destroyObj.getPosition() + vector(0,2,0),
            deckObj.getRotation(),
            "Name",
            "Randomiser card not found in Barracks!"
        )
        print("Re-rolling card at position " .. tostring(pos))
        getShopCard(deckType .. deckCost, deckType, getObjectFromGUID(zoneTable[pos]))
    end
end

function grabCard(color, error, myDeck)
    deckObj = findDecksInZone(getObjectFromGUID(myDeck))
    if deckObj == nil then
        broadcastToAll(error, {r = 1, g = 0, b = 0})
        return (nil)
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
    if deckObj.type == "Card" then
        deckObj.setPositionSmooth(boardPos.getPosition() + vector(14, 3, -6.4),false,true)
        deckObj.setRotationSmooth({0.00, 180.00, 0.00})
    elseif deckObj.type == "Deck" then
      deckObj.takeObject({
        position = deckObj.getPosition(),
        smooth = false,
        rotation = {0.00, 180.00, 0.00},
        callback_function = function(obj)
          if obj then
            obj.setPositionSmooth(boardPos.getPosition() + vector(14, 3, -6.4), false, true)
          end
        end
      })
    end
end

function buyCard(pos, playerC)
    --print("Re-roll card at position " .. tostring(pos) .. "  "  .. playerC)
    local myDeck = findDecksInZone(getObjectFromGUID(zoneTable[pos]))
    grabCard(playerC, "No cards found at market position " .. tostring(pos) .. "!", zoneTable[pos])
end

--[[function getShopCard(box, type, pos)
  --print(marketBags[box])
  --print(pos)
    cardBox = getObjectFromGUID(marketBags[box])
    --print(cardBox)
    marketPos = getObjectFromGUID(pos)
    cardBoxSize = tablelength(cardBox.getObjects())
    if cardBoxSize == 0 then
      broadcastToAll("You've either ran out of cards to randomise or something went wrong!\nYou may have to fix this manually, grab a card from the randomiser decks!",{r=1,g=0.7,b=0.7})
      return(nil)
    end
    possible_cards = cardBoxSize
    chosen_card = math.random(0, possible_cards - 1)
    params = {index = chosen_card, position = marketPos.getPosition() + vector(0,3,0), rotation = {x = 0, y = 180, z = 0}, smooth = false}
    card_stack = cardBox.takeObject(params)

  --  card_stack.setRotation({x = 0, y = 180, z = 0})
    --card_stack.setPositionSmooth(market.getPosition() + vector(0,3,0), false, false)

    if type == "Gem" then
        searchGem(card_stack.getName())
    elseif type == "Relic" then
        searchRelic(card_stack.getName())
    elseif type == "Spell" then
        searchSpell(card_stack.getName())
    end
end
]]--

function getShopCard(box, type, pos)
  --print(marketBags[box])
  --print(pos.getGUID() .. ' / ' .. tostring(pos.getPosition()))

    cardBox = getObjectFromGUID(marketBags[box])
    --print(box)
    --print(cardBox)
    --marketPos = zoneTable[pos]
    cardBoxSize = tablelength(cardBox.getObjects())
    if cardBoxSize == 0 then
      broadcastToAll("You've either ran out of cards to randomise or something went wrong!\nYou may have to fix this manually, grab a card from the randomiser decks!",{r=1,g=0.7,b=0.7})
      return(nil)
    end
    if type == "CommentedOut" then
      possible_cards = cardBoxSize
      chosen_card = math.random(0, possible_cards - 1)
      params = {index = chosen_card, position = marketPos.getPosition() + vector(0,3,0), rotation = {x = 0, y = 180, z = 0}, smooth = false}
      card_stack = cardBox.takeObject(params)
    end
  --  card_stack.setRotation({x = 0, y = 180, z = 0})
    --card_stack.setPositionSmooth(market.getPosition() + vector(0,3,0), false, false)
    local myCost = box
    --print(tostring(pos.getPosition()))
    if type == "Gem" then
          searchDeck(getObjectFromGUID(gem_random_deck_id),myCost, pos.getPosition() +vector(0, 5 + barracksOffset, 0),{0,180,0},"Des","Cannot find a " .. myCost .. " randomizer card in deck.")
    elseif type == "Relic" then
        --searchRelic(card_stack.getName())
        searchDeck(getObjectFromGUID(relic_random_deck_id),myCost,pos.getPosition() + vector(0, 5 + barracksOffset, 0),{0,180,0},"Des","Cannot find a " .. myCost .. " randomizer card in deck.")
    elseif type == "Spell" then
        --searchSpell(card_stack.getName())
        searchDeck(getObjectFromGUID(spell_random_deck_id),myCost,pos.getPosition() + vector(0, 5 + barracksOffset, 0),{0,180,0},"Des","Cannot find a " .. myCost .. " randomizer card in deck.")
    end
    barracksOffset = barracksOffset + 1
    Wait.time(resetOffset,6)

end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function searchGem(name)
    searchDeck(
        getObjectFromGUID(gem_random_deck_id),
        name,
        barracksPos,
        {0, 180, 0},
        "Name",
        "Cannot find " .. name .. " randomizer card in deck."
    )
end
function searchRelic(name)
    searchDeck(
        getObjectFromGUID(relic_random_deck_id),
        name,
        barracksPos,
        {0, 180, 0},
        "Name",
        "Cannot find " .. name .. " randomizer card in deck."
    )
end
function searchSpell(name)
    searchDeck(
        getObjectFromGUID(spell_random_deck_id),
        name,
        barracksPos,
        {0, 180, 0},
        "Name",
        "Cannot find " .. name .. " randomizer card in deck."
    )
end

function lockMarket()
    locked = true
    local buttonWidth = 320
    local buttonHeight = 90
    for i = 9, 27, 1 do
          self.removeButton(i)
    end
    for i = 0, 9, 1 do
        self.editButton({
          index = i,
          label = "Buy/Gain",
          width = buttonWidth*1.2,
          height = buttonHeight*2,
          scale = {0.4,0.4,0.4},
          tooltip = "Adds the above card to your discard pile."})
    end
    broadcastToAll("Market has been locked!", {r = 1, g = 0, b = 0.3})
    getObjectFromGUID('b9111a').setVar('marketDone',true)
    getObjectFromGUID('184d8b').setVar('marketDone',true)
end

function checkZone(zone)
    for i = 0, 9, 1 do
        if zone.getGUID() == zoneTable[i] then
            return (true)
        end
    end
    return (false)
end

function onObjectEnterScriptingZone(zone, info)
    local foundZone = checkZone(zone)
    if foundZone == false or info == nil then
        --print("not a zone")
        return (nil)
    end
    if (foundZone == true and (info.getGMNotes() ~= "Swap Randomiser" and info.getGMNotes() ~= "Market Randomiser" and info.getGMNotes() ~= "Market Randomizer")) then
        --print("not a market card")
        return (nil)
    else
        if (foundZone == true) then
          local error = ''
          if (preventError == false) then
            error = "No market card by the name '" ..
                info.getName() .. "' found. \n The card is supposed to be in bag: " .. info.getDescription()
          end
            local myZone = getObjectFromGUID(zone.getGUID())
            searchDeck(
                getObjectFromGUID(marketBags[info.getDescription()]),
                info.getName(),
                myZone.getPosition() + vector(0, 4, 0),
                {0, 180, 0},
                "Name",
                error
            )
            local myPos2 = getObjectFromGUID("d089df").getPosition()
            -- info.setPositionSmooth(myPos2 + vector(0, 8 + barracksOffset*0.5, 0), false, true)
            info.setPosition(myPos2 + vector(0, 8 + barracksOffset, 0), false, true)
            info.setRotation({0, 180, 0})
            barracksOffset = barracksOffset + 1
            Wait.time(resetOffset,2)
            preventError = true
            Wait.time(resetError,4)
        end
        if info.getGMNotes() == "Swap Randomiser" then
            error = "No swap market card by the name '" ..
            swapDictionary[info.getName()] .. "' found. \n The card is supposed to be in bag: " .. swapBag
            searchDeck(
                getObjectFromGUID(swapBag),
                swapDictionary[info.getName()],
                swapPosition + vector(swapCount * 2.9, 4, 0),
                {0, 180, 0},
                "Name",
                error
            )
            --printToAll("The Swap card " .. swapDictionary[info.getName()] .. " has been added to the Swap Zone.", {r = 1, g = 1, b = 0.8})
            swapCount = swapCount + 1
        end
    end
end

function searchDeck(deck, charName, pos, rot, nameOrDes, error)
    for _, card in pairs(deck.getObjects()) do
        if (nameOrDes == "Des" and card.description == charName) or (nameOrDes == "Name" and card.name == charName) then
            return (deck.takeObject({guid = card.guid, position = pos, rotation = rot, smooth = false}))
        end
    end
    local myError = error or ""
    if (myError ~= "") then
        broadcastToAll(error, {r = 1, g = 0, b = 0})
    end
end

-- i dunno how else to do this with multiple buttons so..
function Card1(obj, player_clicker_color, alt_click)
    local num = 1
    if locked == true then
        buyCard(num, player_clicker_color)
    else
        rerollCard(num, alt_click)
    end
end
function Card1p(obj, player_clicker_color, alt_click)
    local num = 1
    cost_plus = true
    rerollCard(num, alt_click)
end
function Card1m(obj, player_clicker_color, alt_click)
    local num = 1
    cost_minus = true
    rerollCard(num, alt_click)
end
function Card2(obj, player_clicker_color, alt_click)
    local num = 2
    if locked == true then
        buyCard(num, player_clicker_color)
    else
        rerollCard(num, alt_click)
    end
end
function Card2p(obj, player_clicker_color, alt_click)
    local num = 2
    cost_plus = true
    rerollCard(num, alt_click)
end
function Card2m(obj, player_clicker_color, alt_click)
    local num = 2
    cost_minus = true
    rerollCard(num, alt_click)
end
function Card3(obj, player_clicker_color, alt_click)
    local num = 3
    if locked == true then
        buyCard(num, player_clicker_color)
    else
        rerollCard(num, alt_click)
    end
end
function Card3p(obj, player_clicker_color, alt_click)
    local num = 3
    cost_plus = true
    rerollCard(num, alt_click)
end
function Card3m(obj, player_clicker_color, alt_click)
    local num = 3
    cost_minus = true
    rerollCard(num, alt_click)
end
function Card4(obj, player_clicker_color, alt_click)
    local num = 4
    if locked == true then
        buyCard(num, player_clicker_color)
    else
        rerollCard(num, alt_click)
    end
end
function Card4p(obj, player_clicker_color, alt_click)
    local num = 4
    cost_plus = true
    rerollCard(num, alt_click)
end
function Card4m(obj, player_clicker_color, alt_click)
    local num = 4
    cost_minus = true
    rerollCard(num, alt_click)
end
function Card5(obj, player_clicker_color, alt_click)
    local num = 5
    if locked == true then
        buyCard(num, player_clicker_color)
    else
        rerollCard(num, alt_click)
    end
end
function Card5p(obj, player_clicker_color, alt_click)
    local num = 5
    cost_plus = true
    rerollCard(num, alt_click)
end
function Card5m(obj, player_clicker_color, alt_click)
    local num = 5
    cost_minus = true
    rerollCard(num, alt_click)
end
function Card6(obj, player_clicker_color, alt_click)
    local num = 6
    if locked == true then
        buyCard(num, player_clicker_color)
    else
        rerollCard(num, alt_click)
    end
end
function Card6p(obj, player_clicker_color, alt_click)
    local num = 6
    cost_plus = true
    rerollCard(num, alt_click)
end
function Card6m(obj, player_clicker_color, alt_click)
    local num = 6
    cost_minus = true
    rerollCard(num, alt_click)
end
function Card7(obj, player_clicker_color, alt_click)
    local num = 7
    if locked == true then
        buyCard(num, player_clicker_color)
    else
        rerollCard(num, alt_click)
    end
end
function Card7p(obj, player_clicker_color, alt_click)
    local num = 7
    cost_plus = true
    rerollCard(num, alt_click)
end
function Card7m(obj, player_clicker_color, alt_click)
    local num = 7
    cost_minus = true
    rerollCard(num, alt_click)
end
function Card8(obj, player_clicker_color, alt_click)
    local num = 8
    if locked == true then
        buyCard(num, player_clicker_color)
    else
        rerollCard(num, alt_click)
    end
end
function Card8p(obj, player_clicker_color, alt_click)
    local num = 8
    cost_plus = true
    rerollCard(num, alt_click)
end
function Card8m(obj, player_clicker_color, alt_click)
    local num = 8
    cost_minus = true
    rerollCard(num, alt_click)
end
function Card9(obj, player_clicker_color, alt_click)
    local num = 9
    if locked == true then
        buyCard(num, player_clicker_color)
    else
        rerollCard(num, alt_click)
    end
end
function Card9p(obj, player_clicker_color, alt_click)
    local num = 9
    cost_plus = true
    rerollCard(num, alt_click)
end
function Card9m(obj, player_clicker_color, alt_click)
    local num = 9
    cost_minus = true
    rerollCard(num, alt_click)
end