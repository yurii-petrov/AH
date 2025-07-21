cardList = {
  [1] = nil,
  [2] = nil,
  --wave 1
  [3] = "Aeon's End",
  [4] = "Aeon's End",
  [5] = "The Depths",
  [6] = "The Depths",
  [7] = "Malastar",
  [8] = "The Nameless",
  --wave 2
  [9] = "War Eternal",
  [10] = "War Eternal",
  [11] = "The Void",
  [12] = "The Void",
  [13] = "The Outer Dark",
  [14] = "Outer Dark",
  --wave 3
  [15] = "Legacy",
  [16] = "Buried Secrets",
  --wave4
  [17] = "New Age",
  [18] = "New Age",
  [19] = "Nook",
  [20] = "Shattered Dreams",
  [21] = "The Ancients",
  [22] = "The Ancients",
  [23] = "Into the Wild",
  [24] = "Into the Wild",
  --?
  [25] = "Added By Mistake",
  [26] = "Added By Mistake",
  --wave 5
  [27] = "Outcasts",
  [28] = "Outcasts",
  [29] = "Return to Gravehold",
  [30] = "Return to Gravehold",
  [31] = "Southern Village",
  [32] = "Southern Village",
  --wave 6
  [33] = "Legacy of Gravehold",
  [34] = "Legacy of Gravehold",
  [35] = "Legacy Boost Cards",
  [36] = "The Ruins",
  --other
  [37] = "Promo Cards",
  [38] = "All Mini Expansions",
  --wave 7
  [39] = "Evolution",
  [40] = "Origins",
  [41] = "Origins / Evolution",
  [42] = "Past and Future Mages",
  [43] = "Past and Future",
  --wave 8
  [44] = "The Descent Mages",
  [45] = "The Descent Market",
  [46] = "The Caverns Mages",
  [47] = "The Caverns Market",
  [48] = "Xaxos(the Abyss)",
  [49] = "The Abyss Market",
  [50] = "Kain",
  [51] = "Tales Of Old Gravehold Market",
}

isUsed = false
isMage = false
rOff = -2


gem_random_deck_id = "d35e87"
spell_random_deck_id = "8cc318"
relic_random_deck_id = "bc68c5"
mage_random_deck_id = 'e922d3'
destroyID = "2f91ae"

gem_random_script = '61d17d'
relic_random_script = 'feac97'
spell_random_script = 'c04785'
mage_random_script = 'ee030e'

storeGem = 'a5bf7a'
storeSpell = '5ff0d7'
storeRelic = 'e6f39b'
storeMage = '91211b'

storeButtonIndex = 0

function findDecksInZone(zone)
    local objectsInZone = zone.getObjects()
    local decksFound = {}
    for i, object in ipairs(objectsInZone) do
        if object.tag == "Deck" then
            return getObjectFromGUID(object.guid)
        end
    end
    if #decksFound > 0 then
        return decksFound
    else
        return nil
    end
end

function grabDecks(marketOrNot,index)
  myName = cardList[index]
  if (marketOrNot == false) then
    if isMage == false then
      setDecks()
      local destroyObj = getObjectFromGUID(destroyID)
      local myDeck1 = findDecksInZone(getObjectFromGUID(mage_random_script))
      --myDeck1.flip()
      myDeck1.setPosition(destroyObj.getPosition() + vector(0,3,0))
      isMage = true
      Wait.frames(renameDecks,40)
    end
    --search Mages
    --Example
    --storeMage = '91211b', myName = '3'
    searchDeck(getObjectFromGUID(storeMage),myName,getObjectFromGUID(mage_random_script).getPosition() + vector(0,2,0),{0.00, 180.00, 180.00},"Name",'')
    Wait.time(shuffleMages,2)
  else
    if isUsed == false then
      setDecks2()
      local destroyObj = getObjectFromGUID(destroyID)
      local myDeck1 = findDecksInZone(getObjectFromGUID(gem_random_script))
      myDeck1.setPosition(destroyObj.getPosition() + vector(0,3,0))
      local myDeck2 = findDecksInZone(getObjectFromGUID(relic_random_script))
      myDeck2.setPosition(destroyObj.getPosition() + vector(0,5,0))
      local myDeck3 = findDecksInZone(getObjectFromGUID(spell_random_script))
      myDeck3.setPosition(destroyObj.getPosition() + vector(0,7,0))
      isUsed = true
      --Wait.frames(setDecks2,15)
      Wait.time(renameDecks,4)

    end
    --search Gems
    searchDeck(getObjectFromGUID(storeGem),myName,getObjectFromGUID(gem_random_script).getPosition() + vector(0,2,0),{0.00, 180.00, 180.00},"Name",'')
    searchDeck(getObjectFromGUID(storeSpell),myName,getObjectFromGUID(spell_random_script).getPosition() + vector(0,2,0),{0.00, 180.00, 180.00},"Name",'')
    searchDeck(getObjectFromGUID(storeRelic),myName,getObjectFromGUID(relic_random_script).getPosition() + vector(0,2,0),{0.00, 180.00, 180.00},"Name",'')
    Wait.frames(setDecks2,35)
    Wait.time(renameDecks,2)
  end
end


function setDecks()
  mage_random_deck_id = findDecksInZone(getObjectFromGUID(mage_random_script)).getGUID()
  getObjectFromGUID(mage_random_deck_id).shuffle()
  getObjectFromGUID(mage_random_deck_id).setName("Mage Randomizer Deck")
  getObjectFromGUID(mage_random_deck_id).setDescription('Drag one of these cards onto a player mat to set that mage up.')
end

function setDecks2()
  gem_random_deck_id = findDecksInZone(getObjectFromGUID(gem_random_script))
  if (gem_random_deck_id ~= nil) then
    local gem_id = gem_random_deck_id.getGUID()
    getObjectFromGUID(gem_id).shuffle()
    getObjectFromGUID(gem_id).setName("Gem Randomizer Deck")
    getObjectFromGUID(gem_id).setDescription('Place a card into a market slot to draw that mini-deck.')
  end
  relic_random_deck_id = findDecksInZone(getObjectFromGUID(relic_random_script))
  if (relic_random_deck_id ~= nil) then
    local relic_id = relic_random_deck_id.getGUID()
    getObjectFromGUID(relic_id).shuffle()
    getObjectFromGUID(relic_id).setName("Relic Randomizer Deck")
    getObjectFromGUID(relic_id).setDescription('Place a card into a market slot to draw that mini-deck.')
end
  spell_random_deck_id = findDecksInZone(getObjectFromGUID(spell_random_script))
  if (spell_random_deck_id ~= nil) then
    local spell_id = spell_random_deck_id.getGUID()
    getObjectFromGUID(spell_id).shuffle()
    getObjectFromGUID(spell_id).setName("Spell Randomizer Deck")
    getObjectFromGUID(spell_id).setDescription('Place a card into a market slot to draw that mini-deck.')
  end
end

function searchDeck(deck, charName,pos,rot,nameOrDes,error)

    for _, card in pairs(deck.getObjects()) do
      if (nameOrDes == "Des" and card.description == charName) or (nameOrDes == "Name" and card.name == charName) then
        return(deck.takeObject({guid = card.guid, position = pos, rotation = rot, smooth = false}))
      end
    end
    local myError = error or ''
    if (myError ~= '') then
      broadcastToAll(error,{r = 1, g = 0, b = 0})
    end
end

function renameDecks()
  mage_random_deck_id = findDecksInZone(getObjectFromGUID(mage_random_script))
  gem_random_deck_id = findDecksInZone(getObjectFromGUID(gem_random_script))
  relic_random_deck_id = findDecksInZone(getObjectFromGUID(relic_random_script))
  spell_random_deck_id = findDecksInZone(getObjectFromGUID(spell_random_script))
  if (mage_random_deck_id ~= nil and mage_random_deck_id.tag == "Deck") then
    local mage_id = mage_random_deck_id.getGUID()
    mage_random_deck_id.setName("Mage Randomizer Deck")
    mage_random_deck_id.setDescription('Drag one of these cards onto a player mat to set that mage up.')
  end
  if (gem_random_deck_id ~= nil and gem_random_deck_id.tag == "Deck") then
    local gem_id = gem_random_deck_id.getGUID()
    gem_random_deck_id.setName("Gem Randomizer Deck")
    gem_random_deck_id.shuffle()
    gem_random_deck_id.setDescription('Place a card into a market slot to draw that mini-deck.')
end
if (relic_random_deck_id ~= nil and relic_random_deck_id.tag == "Deck") then
  local relic_id = relic_random_deck_id.getGUID()
  relic_random_deck_id.setName("Relic Randomizer Deck")
  relic_random_deck_id.shuffle()
  relic_random_deck_id.setDescription('Place a card into a market slot to draw that mini-deck.')
end
if (spell_random_deck_id ~= nil and spell_random_deck_id.tag == "Deck") then
  local spell_id = spell_random_deck_id.getGUID()
  spell_random_deck_id.setName("Spell Randomizer Deck")
  spell_random_deck_id.shuffle()
  spell_random_deck_id.setDescription('Place a card into a market slot to draw that mini-deck.')
end


  --getObjectFromGUID('5ebb47').setVar(mageDeck,mage_random_deck_id)
  --getObjectFromGUID('e87d81').setVar(mageDeck,mage_random_deck_id)
  --getObjectFromGUID('7ff2e6').setVar(mageDeck,mage_random_deck_id)
  --getObjectFromGUID('c3c58d').setVar(mageDeck,mage_random_deck_id)
end

function pickA()
  broadcastToAll("Already added.", {r = 0.6,g = 0, b = 0.4})
end

function pickB()
  broadcastToAll("Other mini expansions already added.", {r = 0.6,g = 0, b = 0.4})
end

function pickC()
  broadcastToAll("All mini expansions already added.", {r = 0.6,g = 0, b = 0.4})
end

function shuffleMages()
 local md = findDecksInZone(getObjectFromGUID(mage_random_script))
 if md ~= nil and md.tag == "Deck" then
  md.shuffle()

  md.setName("Mage Randomizer Deck")
  md.setDescription('Drag one of these cards onto a player mat to set that mage up.')
 end
end

function turnOffButton(inN,fun)
  self.editButton({
    index = inN-3,
    color = {r = 0, g = 0, b = 0},
    click_function = 'pickA'
  })
  if fun == "Mini" then
    self.editButton({
      index = 33,
      color = {r = 0, g = 0, b = 0},
      click_function = 'pickB'
    })
  end
end

function turnOffMiniButton(inN)
  self.editButton({
    index = inN-3,
    color = {r = 0, g = 0, b = 0},
    click_function = 'pickC'
  })
end

function w1w()
  grabDecks(false,3)
  turnOffButton(3,"Main")
end

function w1m()
  grabDecks(true,4)
  turnOffButton(4,"Main")
end

function w1c()
  grabDecks(false,5)
  turnOffButton(5,"Mini")
end

function w1d()
  grabDecks(true,6)
  searchDeck(getObjectFromGUID(storeGem),"Banishing Topaz",getObjectFromGUID(gem_random_script).getPosition() + vector(0,2,0),{0.00, 180.00, 180.00},"Name",'')
  turnOffButton(6,"Mini")
end

function w1e()
  grabDecks(false,7)
    turnOffButton(7,"Mini")
end

function w1f()
  grabDecks(true,8)
  searchDeck(getObjectFromGUID(storeGem),"Leeching Agate",getObjectFromGUID(gem_random_script).getPosition() + vector(0,2,0),{0.00, 180.00, 180.00},"Name",'')
  turnOffButton(8,"Mini")
end

function w2a()
  grabDecks(false,9)
  turnOffButton(9,"Main")
end

function w2b()
  grabDecks(true,10)
  turnOffButton(10,"Main")
end

function w2c()
  grabDecks(false,11)
  turnOffButton(11,"Mini")

end

function w2d()
  grabDecks(true,12)
  searchDeck(getObjectFromGUID(storeGem),"Fossilized Scarab",getObjectFromGUID(gem_random_script).getPosition() + vector(0,2,0),{0.00, 180.00, 180.00},"Name",'')
    turnOffButton(12,"Mini")
end

function w2e()
  grabDecks(false,13)
    turnOffButton(13,"Mini")
end

function w2f()
  grabDecks(true,14)
    turnOffButton(14,"Mini")
end

function w3a()
  grabDecks(true,15)
    turnOffButton(15,"Main")
end

function w3b()
  grabDecks(true,16)
  turnOffButton(16,"Mini")
end

function w4a()
  grabDecks(false,17)
      turnOffButton(17,"Main")
end

function w4b()
  grabDecks(true,18)
  turnOffButton(18,"Main")
end

function w4d()
  grabDecks(false,19)
      turnOffButton(19,"Mini")
end

function w4e()
  grabDecks(true,20)
  turnOffButton(20,"Mini")
end

function w4f()
  grabDecks(false,21)
  turnOffButton(21,"Mini")
end

function w4g()
  grabDecks(true,22)
  searchDeck(getObjectFromGUID(storeGem),"Shining Fluorite",getObjectFromGUID(gem_random_script).getPosition() + vector(0,2,0),{0.00, 180.00, 180.00},"Name",'')
  turnOffButton(22,"Mini")
end

function w4h()
  grabDecks(false,23)
  turnOffButton(23,"Mini")
end

function w4i()
  searchDeck(getObjectFromGUID(storeGem),"Jeweled Brain",getObjectFromGUID(gem_random_script).getPosition() + vector(0,2,0),{0.00, 180.00, 180.00},"Name",'')
  searchDeck(getObjectFromGUID(storeSpell),"Wound Mender",getObjectFromGUID(spell_random_script).getPosition() + vector(0,2,0),{0.00, 180.00, 180.00},"Name",'')
  searchDeck(getObjectFromGUID(storeRelic),"Blast Sphere",getObjectFromGUID(relic_random_script).getPosition() + vector(0,2,0),{0.00, 180.00, 180.00},"Name",'')
  turnOffButton(24,"Mini")
end

function w5a()
  grabDecks(false,27)
  turnOffButton(25,"Main")
end

function w5b()
  grabDecks(true,28)
  turnOffButton(26,"Main")
end

function w5c()
  grabDecks(false,29)
  turnOffButton(27,"Mini")
end

function w5d()
  grabDecks(true,30)
  --牌堆只有一张的情况下的找牌办法
  searchDeck(getObjectFromGUID(storeRelic),"Glass-Eyed Oracle",getObjectFromGUID(relic_random_script).getPosition() + vector(0,2,0),{0.00, 180.00, 180.00},"Name",'')
  turnOffButton(28,"Mini")
end


function w5e()
  grabDecks(false,31)
  turnOffButton(29,"Mini")
end

function w5f()
  grabDecks(true,32)
  turnOffButton(30,"Mini")
end

function w6a()
  grabDecks(false,33)
  turnOffButton(31,"Main")
end

function w6b()
  grabDecks(true,34)
  turnOffButton(32,"Main")
end

function w6c()
  grabDecks(true,35)
  turnOffButton(33,"Main")
end

function w6d()
  grabDecks(true,36)
  turnOffButton(34,"Mini")
end


function w6e()
  grabDecks(true,37)
  turnOffButton(35,"Mini")
end

function w7a()
  grabDecks(false,42)
  turnOffButton(37,"Main")
end

function w7b()
  grabDecks(true,43)
  turnOffButton(38,"Main")
end

function w7d()
  grabDecks(true,39)

  searchDeck(getObjectFromGUID(storeGem),"Feeding Lichen",getObjectFromGUID(gem_random_script).getPosition() + vector(0,2,0),{0.00, 180.00, 180.00},"Name",'')
  turnOffButton(39,"Mini")
end

function w7e()
  grabDecks(true,40)

  searchDeck(getObjectFromGUID(storeGem),"Rhodonix",getObjectFromGUID(gem_random_script).getPosition() + vector(0,2,0),{0.00, 180.00, 180.00},"Name",'')
  turnOffButton(40,"Mini")
end


function w7f()
  grabDecks(false,41)
  turnOffButton(41,"Mini")
end
------
function w8a()
  grabDecks(false,44)
  turnOffButton(42,"Mini")
end

function w8b()
  grabDecks(true,45)
  turnOffButton(43,"Mini")
end

function w8c()
  grabDecks(false,46)
  turnOffButton(44,"Mini")
end

function w8d()
  grabDecks(true,47)
  searchDeck(getObjectFromGUID(storeGem),"Electinium",getObjectFromGUID(gem_random_script).getPosition() + vector(0,2,0),{0.00, 180.00, 180.00},"Name",'')
  turnOffButton(45,"Mini")
end

function w8e()
  grabDecks(false,48)

  turnOffButton(46,"Mini")
end

function w8f()
  grabDecks(true,49)
  turnOffButton(47,"Mini")
end

function w8g()
  grabDecks(false,50)
  turnOffButton(48,"Mini")
end

function w8h()
  grabDecks(true,51)
  searchDeck(getObjectFromGUID(storeRelic),"Blackened Orb",getObjectFromGUID(relic_random_script).getPosition() + vector(0,2,0),{0.00, 180.00, 180.00},"Name",'')
  searchDeck(getObjectFromGUID(storeSpell),"Spiritual Infusion",getObjectFromGUID(spell_random_script).getPosition() + vector(0,2,0),{0.00, 180.00, 180.00},"Name",'')
  turnOffButton(49,"Mini")
end

function w6f() --add all mini expansions
  grabDecks(true,38)
  grabDecks(false,38)
  turnOffMiniButton(5)
  turnOffMiniButton(6)
  turnOffMiniButton(7)
  turnOffMiniButton(8)
  turnOffMiniButton(11)
  turnOffMiniButton(12)
  turnOffMiniButton(13)
  turnOffMiniButton(14)
  turnOffMiniButton(16)
  turnOffMiniButton(19)
  turnOffMiniButton(20)
  turnOffMiniButton(21)
  turnOffMiniButton(22)
  turnOffMiniButton(23)
  turnOffMiniButton(24)
  turnOffMiniButton(27)
  turnOffMiniButton(28)
  turnOffMiniButton(29)
  turnOffMiniButton(30)
  turnOffMiniButton(34)
    turnOffMiniButton(35)
  turnOffMiniButton(37)
  turnOffButton(36,"Main")
end


function soon()
  broadcastToAll("Still working on these.", {r = 1, g = 0, b = 0.1})
end


function onLoad()

   local topPos = -0.7
   local addY = 0.220
   local cPos = topPos
   local legacyOfGravehold = true
   local pastAndPresent = true
   local bigFont = 40
   local smallFont = 35
   local smallerFont = 30
   local bigButton = {
      [1] =275,
      [2] = 175}

      local smallButton = {
         [1] = 175,
         [2] = 175
      }

      buttonParameters =
      {
         allMage =
         { index = 1,
         click_function = "INSERT_FUNCTION", function_owner = self, label = "All Mages",
         position = {-0.3, 0.4, -0.7}, scale = {0.5, 0.5, 0.5}, width = 500, height = 225, font_size = 75, color = {0.9509, 1, 0.1759, 1},
         tooltip = "Create Randomiser Deck out of all Mages"},

         allMarket =
         { index = 2, click_function = "INSERT_FUNCTION", function_owner = self, label = "All Market\nCards",
         position = {0.3, 0.4, -0.7}, scale = {0.5, 0.5, 0.5}, width = 500, height = 225, font_size = 75,color = {0.129, 0.694, 0.607, 1},
         tooltip = "All Market\nCards"},

      }
      --buttonCreateBatch()
      --wave one --
      buttonParameters =
      {
         wave1A = { index = 3, click_function = "w1w", function_owner = self, label = "Aeon's End\nMages",
         position = {-0.55, 0.3, cPos}, scale = {0.5, 0.5, 0.5}, width = bigButton[1], height = bigButton[2], font_size = bigFont,
         color = {0.9509, 1, 0.1759, 1}, tooltip = "Xaxos, Phaedraxa, Mist, Lash, Kadir, Jian, Brama, Adelheim"},

         wave1B = { index = 4,click_function = "w1m", function_owner = self, label = "Aeon's End\nMarket", position = {-0.25, 0.3, cPos},
         scale = {0.5, 0.5, 0.5},width = bigButton[1], height = bigButton[2], font_size = bigFont, color = {0.129, 0.694, 0.607, 1}, tooltip = "Aeon's End\nMarket"},

         wave1C = { index = 5,click_function = "w1c", function_owner = self, label = "The\nDepths\nMages", position = {0, 0.3, cPos},
         scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {0.9509, 1, 0.1759, 1}, tooltip = "Nym, Reeve, Z'hara"},

         wave1D = { index = 6, click_function = "w1d", function_owner = self, label = "The \nDepths\nMarket", position = {0.2, 0.3, cPos},
         scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {0.129, 0.694, 0.607, 1}, tooltip = "The \nDepths\nMarket"},

         wave1E = { index = 7,click_function = "w1e", function_owner = self, label = "The\nNameless\nMage",
         position = {0.4, 0.3, cPos}, scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {0.9509, 1, 0.1759, 1}, tooltip = "Malastar"},

         wave1F = { index = 8,click_function = "w1f", function_owner = self, label = "The\nNameless\nMarket", position = {0.6, 0.3, cPos},
         scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {0.129, 0.694, 0.607, 1}, tooltip = "The\nNameless\nMarket"},
      }
      buttonCreateBatch()
      cPos = cPos + addY
      --wave two --
      buttonParameters =
      {
         wave2A = { index = 9,click_function = "w2a", function_owner = self, label = "War Eternal\nMages",
         position = {-0.55, 0.3, cPos}, scale = {0.5, 0.5, 0.5},width = bigButton[1], height = bigButton[2], font_size = bigFont, color = {0.9181, 0.5319, 0.2607, 1}, tooltip = "Dezmodia, Garu, Gex, Mazahaedron, Mist, Quilius, Ulgimor, Yan Magda"},

         wave2B = { index = 10,click_function = "w2b", function_owner = self, label = "War Eternal\nMarket",
         position = {-0.25, 0.3, cPos}, scale = {0.5, 0.5, 0.5},width = bigButton[1], height = bigButton[2], font_size = bigFont, color = {0.1205, 0.577, 0.7439, 1}, tooltip = "War Eternal\nMarket"},

         wave2C = { index = 11,click_function = "w2c", function_owner = self, label = "The\nVoid\nMages", position = {0, 0.3, cPos},
         scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {1, 0.8235, 0.3058, 1}, tooltip = "Sparrow, Xaxos"},

         wave2D = { index = 12,click_function = "w2d", function_owner = self, label = "The\nVoid\nMarket",
         position = {0.2, 0.3, cPos}, scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {0.0662, 0.5264, 0.6916, 1}, tooltip = "The\nVoid\nMarket"},

         wave2E = { index = 13,click_function = "w2e", function_owner = self, label = "Outer\nDark\nMages",
         position = {0.4, 0.3, cPos}, scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {1, 0.8235, 0.3058, 1}, tooltip = "Indira, Remnant"},

         wave2F= { index = 14,click_function = "w2f", function_owner = self, label = "Outer\nDark\nMarket",
         position = {0.6, 0.3, cPos}, scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {0.0662, 0.5264, 0.6916, 1}, tooltip = "Outer\nDark\nMarket"},
      }
      buttonCreateBatch()
      cPos = cPos + addY
      local midX = 0.1
      --wave three/four --
      buttonParameters =
      {
         wave3A = { index = 15,click_function = "w3a", function_owner = self, label = "Legacy\nMarket", position = {-0.55 + midX, 0.4, cPos},
         scale = {0.5, 0.5, 0.5},width = bigButton[1], height = bigButton[2], font_size = bigFont, color = {0.1388, 0.7892, 0.3125, 1}, tooltip = "Legacy\nMarket"},

         wave3B = { index = 16,click_function = "w3b", function_owner = self, label = "Buried\nSecrets\nMarket", position = {-0.25 + midX, 0.4, cPos},
         scale = {0.5, 0.5, 0.5},width = bigButton[1], height = bigButton[2], font_size = bigFont, color = {0.0627, 0.6902, 0.2283, 1}, tooltip = "Buried\nSecrets\nMarket"},

         wave4A = { index = 17,click_function = "w4a", function_owner = self, label = "New Age\nMages",
         position = {0.05 + midX, 0.4, cPos}, scale = {0.5, 0.5, 0.5},width = bigButton[1], height = bigButton[2], font_size = bigFont, color = {1, 0.8423, 0.5069, 1}, tooltip = "Claudia, Gygar, Lost, Rhia, Sahala, Soskel, Talix, Taqren"},

         wave4B = { index = 18,click_function = "w4b", function_owner = self, label = "New Age\nMarket", position = {0.35 + midX, 0.4, cPos},
         scale = {0.5, 0.5, 0.5},width = bigButton[1], height = bigButton[2], font_size = bigFont, color = {0.2221, 0.7822, 0.4853, 1}, tooltip = "New Age\nMarket"},

         --wave4C = { index = 19,click_function = "INSERT_FUNCTION", function_owner = self, label = "New Age\nTreasure", position = {0.6, 0.4, cPos},
         --scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {0.96, 0.439, 0.807, 1}, tooltip = "New Age\nTreasure"},

         --allTreasure = { index = 20,click_function = "INSERT_FUNCTION", function_owner = self, label = "All\nTreasure", position = {0.55, 0.4, -0.8},
         --scale = {0.5, 0.5, 0.5}, width = 300, height = 250, font_size = 65, color = {0.96, 0.439, 0.807, 1}, tooltip = "All\nTreasure"},
      }
      buttonCreateBatch()
      cPos = cPos + addY
      --wave four --
      buttonParameters =
      {
         wave4D = { index = 21,click_function = "w4d", function_owner = self, label = "Shattered\nDreams\nMage", position = {-0.6 + midX, 0.3, cPos},
         scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallerFont, color = {1, 0.8235, 0.3058, 1}, tooltip = "Nook"},

         wave4E = { index = 22,click_function = "w4e", function_owner = self, label = "Shattered\nDreams\nMarket", position = {-0.4 + midX, 0.3, cPos},
         scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallerFont, color = {0.2232, 0.5453, 0.3729, 1}, tooltip = "Shattered\nDreams\nMarket"},

         wave4F = { index = 23,click_function = "w4f", function_owner = self, label = "The\nAncients\nMages", position = {-0.2 + midX, 0.3, cPos},
         scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {1, 0.8235, 0.3058, 1}, tooltip = "Mazra, Qu"},

         wave4G = { index = 24,click_function = "w4g", function_owner = self, label = "The\nAncients \nMarket", position = {0 + midX, 0.3, cPos},
         scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {0.2232, 0.5453, 0.3729, 1}, tooltip = "The\nAncients \nMarket"},

         wave4H = { index = 25,click_function = "w4h", function_owner = self, label = "Into The\nWild\nMages", position = {0.2 + midX, 0.3, cPos},
         scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {1, 0.8235, 0.3058, 1}, tooltip = "Inco, Razra"},

         wave4I = { index = 26,click_function = "w4i", function_owner = self, label = "Into The\nWild\nMarket", position = {0.4 + midX, 0.3, cPos},
         scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {0.2232, 0.5453, 0.3729, 1}, tooltip = "Into The\nWild\nMarket"},

         --wave4J = { index = 27,click_function = "INSERT_FUNCTION", function_owner = self, label = "Other \nWave 4\nTreasure", position = {0.6, 0.4, cPos},
         --scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {0.96, 0.439, 0.807, 1}, tooltip = "Other \nWave 4\nTreasure"},

      }
      buttonCreateBatch()
      cPos = cPos + addY
      --wave five --
      buttonParameters =
      {
         wave5A = { index = 27,click_function = "w5a", function_owner = self, label = "Outcasts\nMages",
         position = {-0.55, 0.3, cPos}, scale = {0.5, 0.5, 0.5},width = bigButton[1], height = bigButton[2], font_size = bigFont, color = {0.9181, 0.5319, 0.2607, 1}, tooltip = "Arachnos, Dezmodia, Ilya, Kel, Qu, Taqren, Thraxir, Z'hana"},

         wave5B = { index = 28,click_function = "w5b", function_owner = self, label = "Outcasts\nMarket",
         position = {-0.25, 0.3, cPos}, scale = {0.5, 0.5, 0.5},width = bigButton[1], height = bigButton[2], font_size = bigFont, color = {0.1205, 0.577, 0.7439, 1}, tooltip = "Outcasts\nMarket"},

         wave5C = { index = 29,click_function = "w5c", function_owner = self, label = "Return to\nGravehold\nMages", position = {0, 0.3, cPos},
         scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallerFont, color = {1, 0.8235, 0.3058, 1}, tooltip = "Cairna, Ohat and Uligimor"},

         wave5D = { index = 30,click_function = "w5d", function_owner = self, label = "Return to\nGravehold\nMarket",
         position = {0.2, 0.3, cPos}, scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallerFont, color = {0.0662, 0.5264, 0.6916, 1}, tooltip = "Return to\nGravehold\nMarket"},

         wave5E = { index = 31,click_function = "w5e", function_owner = self, label = "Southern\nVillage\nMages",
         position = {0.4, 0.3, cPos}, scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallerFont, color = {1, 0.8235, 0.3058, 1}, tooltip = "Lucien, Reth"},

         wave5F= { index = 32,click_function = "w5f", function_owner = self, label = "Southern\nVillage\nMarket",
         position = {0.6, 0.3, cPos}, scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallerFont, color = {0.0662, 0.5264, 0.6916, 1}, tooltip = "Southern Village\nMarket"},
      }
      buttonCreateBatch()
      cPos = cPos + addY
      --wave six --
      if legacyOfGravehold == true then
         buttonParameters =
         {
            wave6A = { index = 33,click_function = "w6a", function_owner = self, label = "Legacy of\nGravehold\nMages",
            position = {-0.55, 0.3, cPos}, scale = {0.5, 0.5, 0.5},width = bigButton[1], height = bigButton[2], font_size = bigFont, color = {0.9181, 0.5319, 0.2607, 1}, tooltip = "Arachnos, Claudia, Dezmodia, Gygar, Ilya, Inco, Indria, Kadir, Kel, Lost, Malastar, Mazra, Nook, Qu, Razra, Soskel, Talix, Taqren, Thraxir, Xaxos, Yan Magda"},

            wave6B = { index = 34,click_function = "w6b", function_owner = self, label = "Legacy of\nGravehold\nMarket",
            position = {-0.25, 0.3, cPos}, scale = {0.5, 0.5, 0.5},width = bigButton[1], height = bigButton[2], font_size = bigFont, color = {0.1205, 0.577, 0.7439, 1}, tooltip = "Legacy of Gravehold\nMarket\nDoes not include the Boost/Overheat cards."},

            wave6C = { index = 35,click_function = "w6c", function_owner = self, label = "LoG\nBoost / \nOverheat", position = {0, 0.3, cPos},
            scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {1, 0.8235, 0.3058, 1}, tooltip = "Adds the [i]Boost/Overheat[/i] cards.\nThese cards use states to Boost/Overheat them. \n\nThese probably don't work so well in one off games, but might make fine additions to Expedition mode."},
         }
         buttonCreateBatch()
      end
      buttonParameters =
      {
         wave6D = { index = 36,click_function = "w6d", function_owner = self, label = "The Ruins\nMarket",
         position = {0.2, 0.3, cPos}, scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {0.0662, 0.5264, 0.6916, 1}, tooltip = "The\nRuins\nMarket"},

         wave6E = { index = 37,click_function = "w6e", function_owner = self, label = "Promo\nCards\nMarket",
         position = {0.4, 0.3, cPos}, scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {1, 0.8235, 0.3058, 1}, tooltip = "Kickstarter Exclusive\nPromo Cards"},

         wave6F= { index = 38,click_function = "w6f", function_owner = self, label = "All Mini\nExpansions",
         position = {0.6, 0.3, cPos}, scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallerFont, color = {0.0662, 0.5264, 0.6916, 1}, tooltip = "Add all Market and Mage cards from the various mini expansions."},
      }
      buttonCreateBatch()
      cPos = cPos + addY
      --wave seven --
      if pastAndPresent == true then
         buttonParameters =
         {
            wave7A = { index = 39,click_function = "w7a", function_owner = self, label = "Past and\nFuture\nMages",
            position = {-0.55, 0.3, cPos}, scale = {0.5, 0.5, 0.5},width = bigButton[1], height = bigButton[2], font_size = bigFont, color = {0.9181, 0.5319, 0.2607, 1}, tooltip = "Aurien, Bayu, Kavoc, Lilly, Nadea, Naffir, Ona, Willow, Shoshana, Rhys"},

            wave7B = { index = 40,click_function = "w7b", function_owner = self, label = "Past and\nFuture\nMarket",
            position = {-0.25, 0.3, cPos}, scale = {0.5, 0.5, 0.5},width = bigButton[1], height = bigButton[2], font_size = bigFont, color = {0.1205, 0.577, 0.7439, 1}, tooltip = "Past and Future\nMarket"},

         }
         buttonCreateBatch()
      end
      buttonParameters =
      {
         wave7D = { index = 41,click_function = "w7d", function_owner = self, label = "Origins\nMarket",
         position = {0.1, 0.3, cPos}, scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {0.0662, 0.5264, 0.6916, 1}, tooltip = "Origins\nMarket"},

         wave7E = { index = 42,click_function = "w7e", function_owner = self, label = "Evolution\nMarket",
         position = {0.3, 0.3, cPos}, scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {1, 0.8235, 0.3058, 1}, tooltip = "Evolution\nMarket"},

         wave7F= { index = 43,click_function = "w7f", function_owner = self, label = "Origins /\nEvo\nMages",
         position = {0.5, 0.3, cPos}, scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallerFont, color = {1, 0.8235, 0.3058, 1}, tooltip = "Kiri, Dorian"},
      }
      buttonCreateBatch()
      cPos = cPos + addY
      local midX = 0.17
      --wave eight --
      buttonParameters =
      {
         wave8A = { index = 44,click_function = "w8a", function_owner = self, label = "The\nDescent\nMages",
         position = {-0.8 + midX, 0.3, cPos}, scale = {0.5, 0.5, 0.5},width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {0.9181, 0.5319, 0.2607, 1}, tooltip = "Brama, Janti, Leisan, Mazahaedron, Raven, Thraxir"},

         wave8B = { index = 45,click_function = "w8b", function_owner = self, label = "The\nDescent\nMarket",
         position = {-0.62+ midX, 0.3, cPos}, scale = {0.5, 0.5, 0.5},width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {0.1205, 0.577, 0.7439, 1}, tooltip = "The Descent Market"},

         wave8C = { index = 46,click_function = "w8c", function_owner = self, label = "The\nCaverns\nMages",
         position = {-0.44+ midX, 0.3, cPos}, scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {1, 0.8235, 0.3058, 1}, tooltip = "Alcheia, Quilius"},

         wave8D = { index = 47,click_function = "w8d", function_owner = self, label = "The\nCaverns\nMarket",
         position = {-0.26+ midX, 0.3, cPos}, scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {0.0662, 0.5264, 0.6916, 1}, tooltip = "The Caverns Market"},

         wave8E = { index = 48,click_function = "w8e", function_owner = self, label = "The Abyss\nMage",
         position = {-0.08+ midX, 0.3, cPos}, scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {1, 0.8235, 0.3058, 1}, tooltip = "Xaxos"},

         wave8F= { index = 49,click_function = "w8f", function_owner = self, label = "The Abyss\nMarket",
         position = {0.1+ midX, 0.3, cPos}, scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {0.0662, 0.5264, 0.6916, 1}, tooltip = "The Abyss Market"},

         wave8G= { index = 50,click_function = "w8g", function_owner = self, label = "Tales\nOf Old\nGravehold\nMage",
         position = {0.28+ midX, 0.3, cPos}, scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {1, 0.8235, 0.3058, 1}, tooltip = "Kain"},

         wave8H= { index = 51,click_function = "w8h", function_owner = self, label = "Tales\nOf Old\nGravehold\nMarket",
         position ={0.46+ midX, 0.3, cPos}, scale = {0.5, 0.5, 0.5}, width = smallButton[1], height = smallButton[2], font_size = smallFont, color = {0.0662, 0.5264, 0.6916, 1}, tooltip = "Tales of Old Gravehold Market"},
      }
      buttonCreateBatch()
   end

   function buttonCreateBatch()
      for i, v in pairs(buttonParameters) do
         self.createButton(v)
      end
   end