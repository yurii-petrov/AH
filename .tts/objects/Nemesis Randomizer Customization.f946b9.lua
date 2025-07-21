isUsed = false
myBag = '9a2b7f'
tierScript ={
[1] = '480bec',
[2] = '98363c',
[3] = '216f08',
[4] = '6599fa',
}

unknownDeck = false

nemDeck ={
[1] = 'a295f2',
[2] = '00d19b',
[3] = 'd8e1b9',
[4] = '15bd92',
}

tier1 = {
  [1] = 'Wave 1A',
  [2] = 'Wave 2A',
  [3] = 'Wave 3A',
  [4] = 'Maggoth (Diff: 3)',
  [5] = 'Experiment 153 (Diff: 3)',
  [6] = 'Wave 6A',
  [7] = 'No Deck Here Wave 7A',
  [8] = 'The Infecter (Diff: 4)'
}

tier2 = {
  [1] = 'Wave 1B',
  [2] = 'Wave 2B',
  [3] = 'Fungal Mesh (Diff: 4)',
  [4] = 'Arachnos (Diff: 4)',
  [5] = 'Wave 5B)',
  [6] = 'Wave 6B',
  [7] = 'Herald of the End (Diff: 4)',
  [8] = 'The Coven (Diff: 5)'
}

tier3 = {
  [1] = 'Wayward One (Diff: 7)',
  [2] = 'Wave 2C',
  [3] = 'No Deck Here Wave 3C',
  [4] = 'Wave 4C',
  [5] = 'Risen Thrall (Diff:5)',
  [6] = 'Wave 6C',
  [7] = 'Wave 7C',
  [8] = 'Wave 8C'
}

tier4 = {
  [1] = 'No Deck Here Wave 1D',
  [2] = 'Wave 2D',
  [3] = 'Wave 3D',
  [4] = 'Wave 4D',
  [5] = 'Wave 5D',
  [6] = 'Wave 6D',
  [7] = 'Wave 7D',
  [8] = 'Wave 8D'
}

destroyID = '2f91ae'

function onLoad()
buttonParams = {
  wv1 = {click_function = "Wave1", function_owner = self, label = "Wave 1",
  position = {0, 0.2, -0.7}, scale = {0.15, 0.3, 0.15}, width = 1800, height = 600, font_size = 400,
  color = {0.4616, 0.9159, 1, 1}, tooltip = "[b]Aeon's End[/b] + \nThe Depths, The Nameless\n\n[i]This Wave does not have a Tier 4 nemesis.[/i]"},
  wv2 = {click_function = "Wave2", function_owner = self, label = "Wave 2",
  position = {0, 0.2, -0.5}, scale = {0.15, 0.3, 0.15}, width = 1800, height = 600, font_size = 400,
  color = {0.4616, 0.9159, 1, 1}, tooltip = "[b]War Eternal[/b] +\nThe Void, The Outer Dark"},
  wv3 = {click_function = "Wave3", function_owner = self, label = "Wave 3",
  position = {0, 0.2, -0.3}, scale = {0.15, 0.3, 0.15}, width = 1800, height = 600, font_size = 400,
  color = {0.4616, 0.9159, 1, 1}, tooltip = "[b]Legacy\n[/b][i]\nThis Wave does not have a Tier 3 nemesis.[/i]"},
  wv4 = {click_function = "Wave4", function_owner = self, label = "Wave 4",
  position = {0, 0.2, -0.1}, scale = {0.15, 0.3, 0.15}, width = 1800, height = 600, font_size = 400,
  color = {0.4616, 0.9159, 1, 1}, tooltip = "[b]New Age[/b] +\nShattered Dreams, The Ancients, Into the Wild"},
  wv5 = {click_function = "Wave5", function_owner = self, label = "Wave 5",
  position = {0, 0.2, 0.1}, scale = {0.15, 0.3, 0.15}, width = 1800, height = 600, font_size = 400,
  color = {0.4616, 0.9159, 1, 1}, tooltip = "[b]Outcasts[/b] + \nReturn to Gravehold, Southern Village"},
  wv6 = {click_function = "Wave6", function_owner = self, label = "Wave 6",
  position = {0, 0.2, 0.3}, scale = {0.15, 0.3, 0.15}, width = 1800, height = 600, font_size = 400,
  color = {0.4616, 0.9159, 1, 1}, tooltip = "[b]Legacy of Gravehold[/b]"},
  wv7 = {click_function = "Wave7", function_owner = self, label = "Wave 7",
  position = {0, 0.2, 0.5}, scale = {0.15, 0.3, 0.15}, width = 1800, height = 600, font_size = 400,
  color = {0.4616, 0.9159, 1, 1}, tooltip = "[b]Past and Future[/b] + \nOrigins, Evolution\n\n[i]This Wave does not have a Tier 1 nemesis.[/i]"},
  wv8 = {click_function = "Wave8", function_owner = self, label = "Wave 8",
  position = {0, 0.2, 0.7}, scale = {0.15, 0.3, 0.15}, width = 1800, height = 600, font_size = 400,
  color = {0.4616, 0.9159, 1, 1}, tooltip = "[b]Descent[/b] + \nCaverns, Abyss"},
}
buttonCreateBatch()

self.setDescription("Create Nemesis Selection Randomizer decks out of specific waves of content.\n\nWave 1 is the original Aeon's End release, Wave 6 is the latest: Legacy of Gravehold.\n\n[b]Not all Waves contain all 4 Tiers of Nemesis.[/b]\n\nThis means that you may need to add more than 1 Wave to create a full Expedition.")

getObjectFromGUID(myBag).setName('Nemesis Randomizer Collection')



end

function Wave1()
  turnOffButton(0)
  grabDecks(1)
  print("Adding Wave 1 Nemesis - Aeon's End, The Depths & The Nameless")
end

function Wave2()
  turnOffButton(1)
  grabDecks(2)
  print("Adding Wave 2 Nemesis - War Eternal, The Void, Outer Dark")
end

function Wave3()
  turnOffButton(2)
  grabDecks(3)
  print("Adding Wave 3 Nemesis - Legacy")
end

function Wave4()
  turnOffButton(3)
  grabDecks(4)
  print("Adding Wave 4 Nemesis - The New Age, The Ancients, Into the Wild & Shattered Dreams")
end

function Wave5()
  turnOffButton(4)
  grabDecks(5)
  print("Adding Wave 5 Nemesis - Outcasts, Return to Gravehold & Southern Village")
end

function Wave6()
  turnOffButton(5)
  grabDecks(6)
  print("Adding Wave 6 Nemesis - Legacy of Gravehold")
end

function Wave7()
  turnOffButton(6)
  grabDecks(7)
  print("Adding Wave 7 Nemesis - Past and Future, Origins & Evolution")
end
function Wave8()
  turnOffButton(7)
  grabDecks(8)
  print("Adding Wave 8 Nemesis - The Descent, The Caverns & The Abyss")
end

function findDecksInZone(zone)
    local objectsInZone = zone.getObjects()
    local decksFound = {}
    for i, object in ipairs(objectsInZone) do
        if object.type == "Deck" or object.type == "Card" then
            return getObjectFromGUID(object.guid)
        end
    end
    if #decksFound > 0 then
        return decksFound
    else
        return nil
    end
end

function findActualDeck(zone)
  local check = findDecksInZone(zone)
  if check == 'No Deck' then
    --print("shouldnt havbe fund")
    unknownDeck = true
    return check
  else
    return check
  end
end

function grabDecks(myWave)
  if isUsed == false then
      local destroyObj = getObjectFromGUID(destroyID)

      local myDeck1 = findDecksInZone(getObjectFromGUID(tierScript[1]))
      myDeck1.setPosition(destroyObj.getPosition() + vector(0,3,0))
      local myDeck2 = findDecksInZone(getObjectFromGUID(tierScript[2]))
      myDeck2.setPosition(destroyObj.getPosition() + vector(0,5,0))
      local myDeck3 = findDecksInZone(getObjectFromGUID(tierScript[3]))
      myDeck3.setPosition(destroyObj.getPosition() + vector(0,7,0))
      local myDeck4 = findDecksInZone(getObjectFromGUID(tierScript[4]))
      myDeck4.setPosition(destroyObj.getPosition() + vector(0,9,0))

      isUsed = true

    end
    --search Nemesis
    searchDeck(getObjectFromGUID(myBag ),tier1[myWave],getObjectFromGUID(tierScript[1]).getPosition() + vector(0,2,0),{0.00, 180.00, 180.00},"Name",'')
    searchDeck(getObjectFromGUID(myBag ),tier2[myWave],getObjectFromGUID(tierScript[2]).getPosition() + vector(0,2,0),{0.00, 180.00, 180.00},"Name",'')
    searchDeck(getObjectFromGUID(myBag ),tier3[myWave],getObjectFromGUID(tierScript[3]).getPosition() + vector(0,2,0),{0.00, 180.00, 180.00},"Name",'')
    searchDeck(getObjectFromGUID(myBag ),tier4[myWave],getObjectFromGUID(tierScript[4]).getPosition() + vector(0,2,0),{0.00, 180.00, 180.00},"Name",'')

    Wait.frames(renameDecks,40)
end


function searchDeck(deck, charName,pos,rot,nameOrDes,error)

    for _, card in pairs(deck.getObjects()) do
      if (nameOrDes == "Des" and card.description == charName) or (nameOrDes == "Name" and card.name == charName) then
        if card.name == 'No Deck Here Wave 1D'  then
          unknownDeck = 1
          return nil
        elseif card.name == 'No Deck Here Wave 7A' then
          unknownDeck = 7
          return nil
        elseif  card.name == 'No Deck Here Wave 3C' then
          unknownDeck = 3
          return nil
        else
          return(deck.takeObject({guid = card.guid, position = pos, rotation = rot, smooth = false}))
        end
      end
    end
    local myError = error or ''
    if (myError ~= '') then
      broadcastToAll(error,{r = 1, g = 0, b = 0})
    end
end

function setNemDeck(num)

  --print(unknownDeck)
  --print(num)
  if unknownDeck == 1 and num == 4 then
    unknownDeck = 0
    return nil
  elseif unknownDeck == 3 and num == 3 then
    unknownDeck = 0
    return nil
  elseif unknownDeck == 7 and num == 1  then
    unknownDeck = 7
    return nil
  elseif unknownDeck == 7 and num == 2  then
    unknownDeck = 0
    return nil
  else
    nemDeck[num] = findActualDeck(getObjectFromGUID(tierScript[num])).getGUID()
    if getObjectFromGUID(nemDeck[num]).type == 'Deck' then
      --print("just card found")

        getObjectFromGUID(nemDeck[num]).setName("Nemesis Randomizer Deck ".. tostring(num))
        getObjectFromGUID(nemDeck[num]).setDescription("Drag one of these cards onto the Nemesis setup mat to set that Nemesis up.")

        shuffleNem(num)
      end
  end
end

function renameDecks()
  setNemDeck(1)
  setNemDeck(2)
  setNemDeck(3)
  setNemDeck(4)
end

function pickA()
  broadcastToAll("Already added.", {r = 0.6,g = 0, b = 0.4})
end


function shuffleNem(num)
 findDecksInZone(getObjectFromGUID(tierScript[num])).shuffle()
end

function turnOffButton(inN)
  self.editButton({
    index = inN,
    color = {r = 0, g = 0, b = 0},
    click_function = 'pickA'
  })
end

function buttonCreateBatch()
   for i, v in pairs(buttonParams) do
      self.createButton(v)
   end
end