-- randomizer decks
market_random_deck_id = '866f82'
gem_random_deck_id = 'd35e87'
spell_random_deck_id = '8cc318'
relic_random_deck_id = 'bc68c5'


gem_random_script = '61d17d'
relic_random_script = 'feac97'
spell_random_script = 'c04785'

barracksPos = ''
--gem bags
g2 = 'c70854'
g3 = 'a0ee7c'
g4 = '326176'
g5 = '76b9b1'
g6 = 'ae4191'

--spell bags
s2 = 'aef55f'
s3 = '269f19'
s4 = '6b6868'
s5 = '70a46c'
s6 = 'c2eea0'
s7 = '723b07'
s8 = '6a9948'

--relic bags
r2 = '0bcafd'
r3 = 'f696d8'
r4 = '5dd56e'
r5 = 'ca6d11'
r6 = 'f037fc'
r7 = 'ca0abc'
r8 = 'd42b3a'

barracksVectorOffset = 1

tagList = {
  [1] = 'AeonsDeck',
  [2] = 'WarDeck',
  [3] = 'LegacyDeck',
  [4] = 'NewADeck',
  [5] = 'OutcastsDeck',
  [6] = 'LoGDeck',
  [7] = 'NamelessDeck',
  [8] = 'OuterDDeck',
  [9] = 'VoidDeck',
  [10] = 'DepthsDeck',
  [11] = 'BSDeck',
  [12] = 'TADeck',
  [13] = 'ITWDeck',
  [14] = 'VillageDeck',
  [15] = 'SDDeck',
  [16] = 'RTGDeck',
  [17] = 'RuinsDeck',
  [18] = 'MiniDeck',
  [19] = 'PromoDeck',
}

nvm = {
  [1] = 'setup'
}

--market positions
spot11 = Vector(28.928, 1.64, 23.46)
spot12 = Vector(36.06, 1.64, 23.46)
spot13 = Vector(43.27, 1.64, 23.46)
spot21 = Vector(28.928, 1.64, 13.75)
spot22 = Vector(36.06, 1.64, 13.75)
spot23 = Vector(43.27, 1.64, 13.75)
spot31 = Vector(28.928, 1.64, 4.06)
spot32 = Vector(36.06, 1.64, 4.06)
spot33 = Vector(43.27, 1.64, 4.06)

--market function table
market_setups = {}
market_setups['8d517a'] = 'setupMarket1'
market_setups['1d4e76'] = 'setupMarket2'
market_setups['765ab6'] = 'setupMarket3'
market_setups['b341a5'] = 'setupMarket4'
market_setups['9a91a0'] = 'setupMarket5'
market_setups['881ec2'] = 'setupMarket6'
market_setups['20585a'] = 'setupMarket7'
market_setups['7f44bf'] = 'setupMarket8'

marketScript = '2803db'

market_funcs = {}

rmarket_setup_button_params = {click_function = 'randomMarket',
                              function_owner = self,
                              label = 'Random Market Card',
                              position = {0,0.2,-0.5},
                              rotation = {0,0,0},
                              width = 700,
                              height = 300,
                              font_size = 70,
                              tooltip = "Chooses a random market card in the Market Setup deck and constructs a random market from that."
                          }
market_setup_button_params = {click_function = 'setupMarket',
                                                        function_owner = self,
                                                        label = 'Selected Market Card',
                                                        position = {0,0.2,0.5},
                                                        rotation = {0,0,0},
                                                        width = 700,
                                                        height = 300,
                                                        font_size = 70,
                                                        tooltip = "Selects the Market Setup Card that's on the green tile and constructs a random market from that."
                                                    }

function onLoad()
    market_deck = getObjectFromGUID(market_random_deck_id)
    self.createButton(market_setup_button_params)
    self.createButton(rmarket_setup_button_params)
    barracksPos =  getObjectFromGUID("d089df").getPosition()
    self.setTags(nvm)
end

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

function findCardsInZone(zone)
    local objectsInZone = zone.getObjects()
    local decksFound = {}
    for i, object in ipairs(objectsInZone) do
        if object.tag == "Card" then
            return getObjectFromGUID(object.guid)
        end
    end
    if #decksFound > 0 then
        return decksFound
    else
        return nil
    end
end

function randomMarket()
  print("Taking Random Market Card")
  random_deck = getObjectFromGUID(market_random_deck_id)

  random_deck.shuffle()
  math.randomseed(os.time())
  deck_index = math.random(0, 5)
  market_choice = random_deck.takeObject({index = deck_index})
  market_choice.setPositionSmooth(Vector(56.89, 1.406, 15.66), false, false)
  market_funcs[market_setups[market_choice.getGUID()]]()
end

function setupMarket()
    print("Getting Market Card from board")
    math.randomseed(os.time())
    market_choice = findCardsInZone(getObjectFromGUID(marketScript))
    if market_choice == nil then
      broadcastToAll("Select a single market card first.", {r=1,b=0.2,g=0.2})
      return(nil)
    end
    market_choice.setPositionSmooth(Vector(56.89, 1.406, 15.66), false, false)


    --for key, value in pairs(market_setups) do
    --    print(key, " -- ", value)
    --end
    --market_setups['b341a5']()
    market_funcs[market_setups[market_choice.getGUID()]]()
    --setupMarket4()
end

function setDecks()
  gem_random_deck_id = findDecksInZone(getObjectFromGUID(gem_random_script)).getGUID()
  getObjectFromGUID(gem_random_deck_id).shuffle()
  relic_random_deck_id = findDecksInZone(getObjectFromGUID(relic_random_script)).getGUID()
  getObjectFromGUID(relic_random_deck_id).shuffle()
  spell_random_deck_id = findDecksInZone(getObjectFromGUID(spell_random_script)).getGUID()
  getObjectFromGUID(spell_random_deck_id).shuffle()
end

function market_funcs.setupMarket1()
    --[[
    <4g 4g anyG
    anyR anyR <5S
    <5S >5S >5s
    ]]
    print('Market 1')
    setDecks()

    getGem23(spot11)
    getGem4(spot12)
    getGemAny(spot13)

    getRelicAny(spot21)
    getRelicAny(spot22)
    getSpell234(spot23)

    getSpell234(spot31)
    getSpell678(spot32)
    getSpell678(spot33)
end

function market_funcs.setupMarket2()
    --[[
    >3G >3G >3G
    >4R anyR <6S
    <6S <6S >6S
    ]]
    print('Market 2')
    setDecks()

    getGem456(spot11)
    getGem456(spot12)
    getGem456(spot13)

    getRelic5678(spot21)
    getRelicAny(spot22)
    getSpell2345(spot23)

    getSpell2345(spot31)
    getSpell2345(spot32)
    getSpell78(spot33)
end

function market_funcs.setupMarket3()
    --[[
    <4G 45G 45G
    anyR 3S 4S
    >5S >5S >5S
    ]]
    print('Market 3')
    setDecks()

    getGem23(spot11)
    getGem45(spot12)
    getGem45(spot13)

    getRelicAny(spot21)
    getSpell3(spot22)
    getSpell4(spot23)

    getSpell678(spot31)
    getSpell678(spot32)
    getSpell678(spot33)
end

function market_funcs.setupMarket4()
    --[[
    >4G anyG anyG
    <4R >4R  anyR
    <5S >5S  anyS
    ]]
    setDecks()
    -- >4G
    getGem56(spot11)
    getGemAny(spot12)
    getGemAny(spot13)

    getRelic23(spot21)
    getRelic5678(spot22)
    getRelicAny(spot23)

    getSpell234(spot31)
    getSpell678(spot32)
    getSpellAny(spot33)
end

function market_funcs.setupMarket5()
    print('Market 5')
    setDecks()
    getGem2(spot11)
    getGem3(spot12)
    getGem4(spot13)

    getGem5(spot21)
    getRelicAny(spot22)
    getSpell4(spot23)

    getSpell5(spot31)
    getSpell6(spot32)
    getSpell78(spot33)
end

function market_funcs.setupMarket6()
    print('Market 6')
    setDecks()
    getGem3(spot11)
    getGem4(spot12)
    getRelic23(spot13)

    getRelic5678(spot21)
    getRelicAny(spot22)
    getSpell34(spot23)

    getSpell56(spot31)
    getSpell56(spot32)
    getSpell78(spot33)
end

function market_funcs.setupMarket7()
    print('Market 7')
    setDecks()
    getGem3(spot11)
    getGem4(spot12)
    getGem45(spot13)

    getRelic23(spot21)
    getRelic5678(spot22)
    getSpell3(spot23)

    getSpell4(spot31)
    getSpell5(spot32)
    getSpell78(spot33)
end

function market_funcs.setupMarket8()
    print('Market 8')
    setDecks()

    getGem23(spot11)
    getGemAny(spot12)
    getGemAny(spot13)

    getRelicAny(spot21)
    getRelicAny(spot22)
    getSpellAny(spot23)

    getSpellAny(spot31)
    getSpellAny(spot32)
    getSpellAny(spot33)
end

function searchDeck(deck, charName, pos, rot, nameOrDes, error)
    if (nameOrDes == "Des") then
      --broadcastToAll("Looking for " .. charName)
    end
    for _, card in pairs(deck.getObjects()) do
        if (nameOrDes == "Des" and card.description == charName) or (nameOrDes == "Name" and card.name == charName) or (nameOrDes == "Any") then
            return (deck.takeObject({guid = card.guid, position = pos, rotation = rot, smooth = false}))
        end
    end
    local myError = error or ""
    if (myError ~= "") then
        broadcastToAll(error, {r = 1, g = 0, b = 0})
    end
end

function searchGem(name)
  searchDeck(getObjectFromGUID(gem_random_deck_id),name,barracksPos + vector(0, 7 + barracksVectorOffset, 0),{0,180,0},"Name","Cannot find " .. name .. " randomizer card in deck.")
  barracksVectorOffset = barracksVectorOffset + 1
end
function searchRelic(name)
  searchDeck(getObjectFromGUID(relic_random_deck_id),name,barracksPos + vector(0, 7 + barracksVectorOffset, 0),{0,180,0},"Name","Cannot find " .. name .. " randomizer card in deck.")
  barracksVectorOffset = barracksVectorOffset + 1
end
function searchSpell(name)
  searchDeck(getObjectFromGUID(spell_random_deck_id),name,barracksPos + vector(0, 7 + barracksVectorOffset, 0),{0,180,0},"Name","Cannot find " .. name .. " randomizer card in deck.")
  barracksVectorOffset = barracksVectorOffset + 1
end

--function takeObject(object)
  --allow_interaction = not object.hasAnyTag() or object.hasMatchingTag(self)
  --ptint(allow_interaction)
  --return (allow_interaction)
--end
-- GEM GETS --
function checkTag(obj)
  --print(obj.getTags())
  if (obj.hasMatchingTag(self)) then
    return (true)
else
  return(false)
end

end

function getGem23(market_location)
  g2o = getObjectFromGUID(g2)
  g3o = getObjectFromGUID(g3)
  local myGem = 'Gem3'
  local g2o_size = tablelength(g2o.getObjects())
  local g3o_size = tablelength(g3o.getObjects())
  local possible_gems = g2o_size + g3o_size
  local chosen_gem = math.random(0, possible_gems - 1)

  if chosen_gem < g2o_size then
    myGem = 'Gem2'
  end

  searchDeck(getObjectFromGUID(gem_random_deck_id),myGem,market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Des","Cannot find a " .. myGem .. " randomizer card in deck.")

end

function getGem45(market_location)
  g4o = getObjectFromGUID(g4)
  g5o = getObjectFromGUID(g5)
  local myGem = 'Gem5'
  local g4o_size = tablelength(g4o.getObjects())
  local g5o_size = tablelength(g5o.getObjects())
  local possible_gems = g4o_size + g5o_size
  local chosen_gem = math.random(0, possible_gems - 1)

  if chosen_gem < g4o_size then
    myGem = 'Gem4'
  end

  searchDeck(getObjectFromGUID(gem_random_deck_id),myGem,market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Des","Cannot find a " .. myGem .. " randomizer card in deck.")

end

function getGem56(market_location)
  g6o = getObjectFromGUID(g6)
  g5o = getObjectFromGUID(g5)
  local myGem = 'Gem5'
  local g6o_size = tablelength(g6o.getObjects())
  local g5o_size = tablelength(g5o.getObjects())
  local possible_gems = g6o_size + g5o_size
  local chosen_gem = math.random(0, possible_gems - 1)

  if chosen_gem < g6o_size then
    myGem = 'Gem6'
  end

  searchDeck(getObjectFromGUID(gem_random_deck_id),myGem,market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Des","Cannot find a " .. myGem .. " randomizer card in deck.")
  --barracksVectorOffset = barracksVectorOffset + 1
end


function getGem456(market_location)
  g4o = getObjectFromGUID(g4)
  g5o = getObjectFromGUID(g5)
  g6o = getObjectFromGUID(g6)
  g4o_size = tablelength(g4o.getObjects())
  g5o_size = tablelength(g5o.getObjects())
  g6o_size = tablelength(g6o.getObjects())
  local possible_gems = g6o_size + g5o_size + g4o_size
  local chosen_gem = math.random(0, possible_gems - 1)
  local myGem = 'Gem6'
  if chosen_gem < g4o_size then
      myGem = 'Gem4'
  elseif chosen_gem - g4o_size < g5o_size then
    myGem = 'Gem5'
  end
  searchDeck(getObjectFromGUID(gem_random_deck_id),myGem,market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Des","Cannot find a " .. myGem .. " randomizer card in deck.")
  --barracksVectorOffset = barracksVectorOffset + 1.5
end

function getGem2(market_location)
  local myGem = 'Gem2'
  searchDeck(getObjectFromGUID(gem_random_deck_id),myGem,market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Des","Cannot find a " .. myGem .. " randomizer card in deck.")
--  barracksVectorOffset = barracksVectorOffset + 1.5
end

function getGem3(market_location)
  local myGem = 'Gem3'
  searchDeck(getObjectFromGUID(gem_random_deck_id),myGem,market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Des","Cannot find a " .. myGem .. " randomizer card in deck.")
  --barracksVectorOffset = barracksVectorOffset + 1.5
end

function getGem4(market_location)
  local myGem = 'Gem4'
  searchDeck(getObjectFromGUID(gem_random_deck_id),myGem,market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Des","Cannot find a " .. myGem .. " randomizer card in deck.")
  --barracksVectorOffset = barracksVectorOffset + 1.5
end

function getGem5(market_location)
  local myGem = 'Gem5'
  searchDeck(getObjectFromGUID(gem_random_deck_id),myGem,market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Des","Cannot find a " .. myGem .. " randomizer card in deck.")
--  barracksVectorOffset = barracksVectorOffset + 1.5
end

function getGem6(market_location)
  local myGem = 'Gem6'
  searchDeck(getObjectFromGUID(gem_random_deck_id),myGem,market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Des","Cannot find a " .. myGem .. " randomizer card in deck.")
  --barracksVectorOffset = barracksVectorOffset + 1.5
end

function getGem7(market_location)
  local myGem = 'Gem7'
  searchDeck(getObjectFromGUID(gem_random_deck_id),myGem,market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Des","Cannot find a " .. myGem .. " randomizer card in deck.")
--  barracksVectorOffset = barracksVectorOffset + 1.5
end

function getGemAny(market_location)
  searchDeck(getObjectFromGUID(gem_random_deck_id),"myGem",market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Any","Cannot find any gems in the randomizer card deck.")
--  barracksVectorOffset = barracksVectorOffset + 1.5
end
--RELICS GET--
function getRelic23(market_location)
  local myRelic = 'Relic3'
  r2o = getObjectFromGUID(r2)
  r3o = getObjectFromGUID(r3)
  r2o_size = tablelength(r2o.getObjects())
  r3o_size = tablelength(r3o.getObjects())
  local possible_relics = r2o_size + r3o_size
  local chosen_relic = math.random(0, possible_relics - 1)

  if chosen_relic < r2o_size then
        myRelic = 'Relic2'
    end
  searchDeck(getObjectFromGUID(relic_random_deck_id),myRelic,market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Des","Cannot find a " .. myRelic .. " randomizer card in deck.")
  end

function getRelic5678(market_location)
  local myRelic = 'Relic8'
  r5o = getObjectFromGUID(r5)
  r6o = getObjectFromGUID(r6)
  r7o = getObjectFromGUID(r7)
  r8o = getObjectFromGUID(r8)
  r5o_size = tablelength(r5o.getObjects())
  r6o_size = tablelength(r6o.getObjects())
  r7o_size = tablelength(r7o.getObjects())
  r8o_size = tablelength(r8o.getObjects())
  local possible_relics = r5o_size + r6o_size + r7o_size + r8o_size
  local chosen_relic = math.random(0, possible_relics - 1)

  if chosen_relic < r5o_size then
        myRelic = 'Relic5'
    elseif chosen_relic - r5o_size < r6o_size then
        myRelic = 'Relic6'
    elseif chosen_relic - r5o_size - r6o_size < r7o_size then
        myRelic = 'Relic7'
    end
  searchDeck(getObjectFromGUID(relic_random_deck_id),myRelic,market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Des","Cannot find a " .. myRelic .. " randomizer card in deck.")
  end

function getRelicAny(market_location)
  searchDeck(getObjectFromGUID(relic_random_deck_id),"myRelic",market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Any","Cannot find any relics in the randomizer card deck.")
--  barracksVectorOffset = barracksVectorOffset + 1.5
end

function getSpell3(market_location)
  local mySpell = 'Spell3'
  searchDeck(getObjectFromGUID(spell_random_deck_id),mySpell,market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Des","Cannot find a " .. mySpell .. " randomizer card in deck.")
end

function getSpell4(market_location)
  local mySpell = 'Spell4'
  searchDeck(getObjectFromGUID(spell_random_deck_id),mySpell,market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Des","Cannot find a " .. mySpell .. " randomizer card in deck.")
end

function getSpell5(market_location)
  local mySpell = 'Spell5'
  searchDeck(getObjectFromGUID(spell_random_deck_id),mySpell,market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Des","Cannot find a " .. mySpell .. " randomizer card in deck.")
end

function getSpell6(market_location)
  local mySpell = 'Spell6'
  searchDeck(getObjectFromGUID(spell_random_deck_id),mySpell,market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Des","Cannot find a " .. mySpell .. " randomizer card in deck.")
end

function getSpellAny(market_location)
  searchDeck(getObjectFromGUID(spell_random_deck_id),'mySpell',market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Any","Cannot find any spells in the randomizer card deck.")
end

function getSpell34(market_location)
  s3o = getObjectFromGUID(s3)
  s4o = getObjectFromGUID(s4)
  local mySpell = 'Spell3'
  local s3o_size = tablelength(s3o.getObjects())
  local s4o_size = tablelength(s4o.getObjects())
  local possible_spells = s3o_size + s4o_size
  local chosen_spell = math.random(0, possible_spells - 1)

  if chosen_spell < s4o_size then
    mySpell = 'Spell4'
  end

  searchDeck(getObjectFromGUID(spell_random_deck_id),mySpell,market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Des","Cannot find a " .. mySpell .. " randomizer card in deck.")
  --barracksVectorOffset = barracksVectorOffset + 1
end

function getSpell56(market_location)
  s6o = getObjectFromGUID(s6)
  s5o = getObjectFromGUID(s5)
  local mySpell = 'Spell5'
  local s6o_size = tablelength(s6o.getObjects())
  local s5o_size = tablelength(s5o.getObjects())
  local possible_spells = s6o_size + s5o_size
  local chosen_spell = math.random(0, possible_spells - 1)

  if chosen_spell < s6o_size then
    mySpell = 'Spell6'
  end

  searchDeck(getObjectFromGUID(spell_random_deck_id),mySpell,market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Des","Cannot find a " .. mySpell .. " randomizer card in deck.")
  --barracksVectorOffset = barracksVectorOffset + 1
end

function getSpell78(market_location)
  s7o = getObjectFromGUID(s7)
  s8o = getObjectFromGUID(s8)
  local mySpell = 'Spell8'
  local s7o_size = tablelength(s7o.getObjects())
  local s8o_size = tablelength(s8o.getObjects())
  local possible_spells = s8o_size + s7o_size
  local chosen_spell = math.random(0, possible_spells - 1)

  if chosen_spell < s7o_size then
    mySpell = 'Spell7'
  end

  searchDeck(getObjectFromGUID(spell_random_deck_id),mySpell,market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Des","Cannot find a " .. mySpell .. " randomizer card in deck.")
  --barracksVectorOffset = barracksVectorOffset + 1
end

function getSpell5678(market_location)
  local mySpell = 'Spell8'
  s5o = getObjectFromGUID(s5)
  s6o = getObjectFromGUID(s6)
  s7o = getObjectFromGUID(s7)
  s8o = getObjectFromGUID(s8)
  s5o_size = tablelength(s5o.getObjects())
  s6o_size = tablelength(s6o.getObjects())
  s7o_size = tablelength(s7o.getObjects())
  s8o_size = tablelength(s8o.getObjects())
  local possible_spells = s5o_size + s6o_size + s7o_size + s8o_size
  local chosen_spell = math.random(0, possible_spells - 1)

  if chosen_spell < s5o_size then
        mySpell = 'Spell5'
    elseif chosen_spell - s5o_size < s6o_size then
        mySpell = 'Spell5'
    elseif chosen_spell - s5o_size - s6o_size < s7o_size then
        mySpell = 'Spell6'
    elseif chosen_spell - s5o_size - s6o_size - s7o_size < s8o_size then
      mySpell = 'Spell7'
    end
  searchDeck(getObjectFromGUID(spell_random_deck_id),mySpell,market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Des","Cannot find a " .. mySpell .. " randomizer card in deck.")
  end

  function getSpell2345(market_location)
    local mySpell = 'Spell2'
    s5o = getObjectFromGUID(s5)
    s4o = getObjectFromGUID(s4)
    s3o = getObjectFromGUID(s3)
    s2o = getObjectFromGUID(s2)
    s5o_size = tablelength(s5o.getObjects())
    s4o_size = tablelength(s4o.getObjects())
    s3o_size = tablelength(s3o.getObjects())
    s2o_size = tablelength(s2o.getObjects())
    local possible_spells = s5o_size + s4o_size + s3o_size + s2o_size
    local chosen_spell = math.random(0, possible_spells - 1)

    if chosen_spell < s5o_size then
          mySpell = 'Spell5'
      elseif chosen_spell - s5o_size < s4o_size then
          mySpell = 'Spell4'
      elseif chosen_spell - s5o_size - s4o_size < s3o_size then
          mySpell = 'Spell3'
      elseif chosen_spell - s5o_size - s4o_size - s3o_size < s2o_size then
        mySpell = 'Spell2'
      end
    searchDeck(getObjectFromGUID(spell_random_deck_id),mySpell,market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Des","Cannot find a " .. mySpell .. " randomizer card in deck.")
    end

    function getSpell234(market_location)
      s2o = getObjectFromGUID(s2)
      s3o = getObjectFromGUID(s3)
      s4o = getObjectFromGUID(s4)
      local mySpell = 'Spell2'
      local s2o_size = tablelength(s2o.getObjects())
      local s3o_size = tablelength(s3o.getObjects())
      local s4o_size = tablelength(s4o.getObjects())
      local possible_spells = s3o_size + s4o_size + s2o_size
      local chosen_spell = math.random(0, possible_spells - 1)

      if chosen_spell < s4o_size then
        mySpell = 'Spell4'
      elseif chosen_spell - s4o_size < s3o_size then
        mySpell = 'Spell3'
      end

      searchDeck(getObjectFromGUID(spell_random_deck_id),mySpell,market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Des","Cannot find a " .. mySpell .. " randomizer card in deck.")
      --barracksVectorOffset = barracksVectorOffset + 1
    end

    function getSpell678(market_location)
      s6o = getObjectFromGUID(s6)
      s7o = getObjectFromGUID(s7)
      s8o = getObjectFromGUID(s8)
      local mySpell = 'Spell8'
      local s6o_size = tablelength(s6o.getObjects())
      local s7o_size = tablelength(s7o.getObjects())
      local s8o_size = tablelength(s8o.getObjects())
      local possible_spells = s6o_size + s7o_size + s8o_size
      local chosen_spell = math.random(0, possible_spells - 1)

      if chosen_spell < s6o_size then
        mySpell = 'Spell6'
      elseif chosen_spell - s6o_size < s7o_size then
        mySpell = 'Spell7'
      end

      searchDeck(getObjectFromGUID(spell_random_deck_id),mySpell,market_location + vector(0, 5 + barracksVectorOffset, 0),{0,180,0},"Des","Cannot find a " .. mySpell .. " randomizer card in deck.")
      --barracksVectorOffset = barracksVectorOffset + 1
    end



function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end