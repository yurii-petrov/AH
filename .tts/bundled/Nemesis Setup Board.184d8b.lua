info = {}
obj_GUID = {}
me = {}
mePos = {}
bagNum = 1
zone_GUID = ''
myPlayer = ''
PlayerVal = 2
BattleVal = 1
marketDone = false

legacyOfGraveholdOn = true;
killSwitch = false
canContinue =
{
 [1] =  false,
 [2] = false,
 [3] = true
}
minorBoardStore = ''
mainBoardStore = ''

--nemTier1 = {-83.55, 1.61, 1.5}
--nemTier2 = {-74.94, 1.61, 1.5}
--nemTier3 = {-66.78, 1.61, 1.5}
nemTier1 = {-28.50, 1.95, 79.50}
nemTier2 = {-19.50, 1.95, 79.50}
nemTier3 = {-11.50, 1.95, 79.50}

player1BoardGUID = 'c7768d'

playerBoardGUID = {
  [1] = '5ebb47',
  [2] = 'e87d81',
  [3] = '7ff2e6',
  [4] = 'c3c58d'
}

balanceVariant = 0

turnOrderCard = nil
turnOrderCardAlt = nil

forceMythBone = false
mythLife = ''
boneLife = ''

nemesisTokensGUID = '3a7b1b'

--buildTier1 = {-83.55, 1.61, -11.05}
--buildTier2 = {-74.94, 1.61, -11.05}
--buildTier3 = {-66.78, 1.61, -11.05}
buildTier1 = {-28.50, 1.95, 67.84}
buildTier2 = {-19.50, 1.95, 67.84}
buildTier3 = {-11.50, 1.95, 67.84}

tier1Select = '05a93c'
tier2Select = '7e6a56'
tier3Select = '86c358'

boardGUID = 'd3fa17'
subboardGUID = '6dcf27'

mainBoardOffset = {-3,5,-6.37}
nemesisDeck = vector(-16.09,6,0.2)
subDeck = vector(10.28,6,2.11)

mythBoard = vector(-54.71, 1.56, 2.82)
zone_GUID = '5b5b88'

nemesisLifeObject = '9197a2'

tier1Zone = '1c035a'
tier2Zone = '971a74'
tier3Zone = 'c89146'
storeND = ''
lifeTrackerKill = ''

nemesis_table = {
    [1] = {
        [1] = 1,
        [2] = 3,
        [3] = 5,
        [4] = 8
       },
    [2] = {
        [1] = 3,
        [2] = 5,
        [3] = 6,
        [4] = 7
    },
    [3] = {
        [1] = 7,
        [2] = 7,
        [3] = 7,
        [4] = 7
    }
}

upgrade_table = {
    [1] = {
        [1] = 0,
        [2] = 1,
        [3] = 2,
        [4] = 3
       },
    [2] = {
        [1] = 0,
        [2] = 3,
        [3] = 4,
        [4] = 5
    },
    [3] = {
        [1] = 0,
        [2] = 3,
        [3] = 5,
        [4] = 7
    }
}

deck_id = {

[1] = '09b945',
[2] = '0af199',
[3] = '5b6ce9',
[4] = '964004',
[5] = '0261f3',
[6] = 'cb11f4'
}

nem_deck1_table = {
  [1] = '9024e2', -- aeon
  [2] = 'db138c', -- we
  [3] = 'b19403', -- legacy
  [4] = 'b511b8', -- new age
  [5] = '5ba8a0', --outcasts
  [6] = 'ff0396', --promo
  [7] = '998800', -- minions
  [8] = '7edaba', --powers
  [9] = 'ddb49f', -- attacks,
  [10] = '964004', --upgraded all
  [11] = '433aa4', --upgraded new age
  [12] = '69fb05', --upgraded outcasts
  [13] = '2c0f7f', --upgraded legacy
  [14] = '2894dd', --log
  [15] = 'acdf1c', --log upg
  [16] = '9b2138', --past and future up
  [17] = 'ee5ea3', --the descent
  [18] = '823a37'--upgraded descent
}

nem_deck2_table = {
  [1] = '10fe3a', -- aeon
  [2] = 'e87bf1', -- we
  [3] = '8709b4', -- legacy
  [4] = 'b83fa5', -- new age
  [5] = '888a0f', --outcasts
  [6] = '268075', --promo
  [7] = 'a54e60', -- minions
  [8] = '596d42', --powers
  [9] = '4dab82', -- attacks
  [10] = '0261f3', --upgraded all
  [11] = '3115e2', --upgraded new age
  [12] = '194b52', --upgraded outcasts
  [13] = 'd92ae1', --upgraded legacy
  [14] = '8579f3', --log
  [15] = 'e047f1', --log upg
  [16] = 'e22a68', -- past and future up
  [17] = '3c0bfc', --the descent
  [18] ='9cf8da'--upgraded descent
}

nem_deck3_table = {
  [1] = '7dd9e8', -- aeon
  [2] = 'e3305d', -- we
  [3] = 'e7c453', -- legacy
  [4] = '7784dc', -- new age
  [5] = '17140c', --outcasts
  [6] = '5d71a8', --promo
  [7] = '0f5ecb', -- minions
  [8] = '763314', --powers
  [9] = '454288', -- attacks
  [10] = 'cb11f4', --upgraded all
  [11] = 'e9524d', --upgraded new age
  [12] = 'b1095d', --upgraded outcasts
  [13] = 'a82744', --upgraded legacy
  [14] = '7f9f4d', --log
  [15] = '0e3853', --log upg
  [16] = '45d001', --past and future up
  [17] = '626b76', --the descent
  [18] = 'e47a71' --upgraded descent
}

shop_table = {
  [1] = '243c0f',
  [2] = '27cf5f',
  [3] = 'c08962',
  [4] = 'd46559',
  [5] = '9bad65',
  [6] = '5ce8bd',
  [7] = '00e430',
  [8] = '8bea37',
  [9] = 'e1bcd8'
}

shop_vector = {
  [1] = Vector(28.928, 1.64, 23.46),
  [2] = Vector(36.06, 1.64, 23.46),
  [3] = Vector(43.27, 1.64, 23.46),
  [4] = Vector(28.928, 1.64, 13.75),
  [5] = Vector(36.06, 1.64, 13.75),
  [6] = Vector(43.27, 1.64, 13.75),
  [7] = Vector(28.928, 1.64, 4.06),
  [8] = Vector(36.06, 1.64, 4.06),
  [9] = Vector(43.27, 1.64, 4.06)
}
local bV1X = -51.59
local bV2Y = 72.62
local bV1Add = 6.68
local bV2Add = -9.71
local bVZ = 5
balance_vector = {
  --[1] = Vector(-113.23, 1.69, 69.51),
  --[2] = Vector(-106.55, 1.69, 69.51),
  --[3] = Vector(-99.87, 1.69, 69.51),
  --[4] = Vector(-113.23, 1.69, 60.42),
  --[5] = Vector(-106.55, 1.69, 60.42),
  --[6] = Vector(-99.87, 1.69, 60.42),
  --[7] = Vector(-113.23, 1.69, 51.06),
  --[8] = Vector(-106.55, 1.69, 51.06),
  --[9] = Vector(-99.87, 1.69, 51.06),
  [1] = Vector(bV1X, bVZ, bV2Y),
  [2] = Vector(bV1X + bV1Add, bVZ, bV2Y),
  [3] = Vector(bV1X + (bV1Add*2), bVZ, bV2Y),
  [4] = Vector(bV1X, bVZ, bV2Y + bV2Add),
  [5] = Vector(bV1X + bV1Add, bVZ, bV2Y + bV2Add),
  [6] = Vector(bV1X + (bV1Add*2), bVZ, bV2Y + bV2Add),
  [7] = Vector(bV1X, bVZ, bV2Y + (bV2Add*2)),
  [8] = Vector(bV1X + bV1Add, bVZ, bV2Y+ (bV2Add*2)),
  [9] = Vector(bV1X + (bV1Add*2), bVZ,bV2Y+ (bV2Add*2)),
}

turnDeck = 'd3724a'
turnDiscard = '74276a'
turnVariant = true
turn_table = {
  [1] = 'ab0228',
  [2] = '3f9c6d',
  [3] = 'a93efc',
  [4] = '426293',
  [5] = 'ee8f9a', --four player new
  [6] = '373770',
  [7] = 'dc4292',
  [8] = '0de9fc', -- three player new
  [9] = '1b87f7'
}

balancedTiers =
{
  [1] = --tier 1
  {
    [1] = 2,
    [2] = 3,
    [3] = 3,
  },
  [2] = -- tier 2
  {
    [1] = 2,
    [2] = 3,
    [3] = 2,
  },
  [3] = --tier 3
  {
    [1] = 1,
    [2] = 3,
    [3] = 3,
  },
  [4] = --tier 1 type 2
  {
    [1] = 2,
    [2] = 4,
    [3] = 2,
  },
  [5] = -- tier 2
  {
    [1] = 3,
    [2] = 3,
    [3] = 1,
  },
  [6] = --tier 3
  {
    [1] = 1,
    [2] = 4,
    [3] = 2,
  },
  [7] = --tier 1 type 3
  {
    [1] = 2,
    [2] = 4,
    [3] = 2,
  },
  [8] = -- tier 2
  {
    [1] = 2,
    [2] = 2,
    [3] = 3,
  },
  [9] = --tier 3
  {
    [1] = 2,
    [2] = 2,
    [3] = 3,
  }
}

function onObjectLeaveContainer(container, leave_object) --why did they have to make nemesis cards usable by players :V
  if (storeND ~= "") then

  if (container.type == "Deck" and container == storeND) then
   leave_object.addTag('nemesisDeckCard')
 end
end
end

--upgraded basics guid --
upgradedScript ={
  [1] = 'b2b756',
  [2] = '805dbf',
  [3] = '587d07'
}

nemesisBagDeck = {
['NemesisRandomizer1'] = 'fe9e05',
['NemesisRandomizer2'] = '83ce89',
['NemesisRandomizer3'] = '835c1c',
['NemesisRandomizer4'] = '5015ba'
}


function onSave()
    local tableToSave = {};

    if PlayerVal then

            tableToSave['PlayerVal'] = PlayerVal

    end
    if BattleVal then

            tableToSave['BattleVal'] = BattleVal

    end



    saved_data = JSON.encode(tableToSave)
    return saved_data
end

function onload(saved_data)


    if saved_data != nil then
        loaded_data = JSON.decode(saved_data)
        if loaded_data != nil then
            PlayerVal = loaded_data['PlayerVal']
            BattleVal = loaded_data['BattleVal']
        else
            PlayerVal = 2
            BattleVal = 1
        end
    else
        PlayerVal = 2
        BattleVal = 1
    end

  local buttonWidth = 380
  local buttonHeight = 150
  local buttonHeightBig = 200
  local leftPos = -1.35
  local middlePos = -0.6
  local rightPos = leftPos + ((math.abs(leftPos) - math.abs(middlePos))*2)
  local right_rightPos = 0.9
  local row0 = -0.5
  local row1 = -0.2
  local row2 = 0.1
  local row3 = 0.4
  local row4 = 0.76
  me = getObjectFromGUID(self.guid)
  mePos = me.getPosition()
  mainPos = getObjectFromGUID(boardGUID).getPosition()
  subPos = getObjectFromGUID(subboardGUID).getPosition()
  buttonParameters =
  {

      PlayerVal =
      {
          index = 0,
          label = tostring(PlayerVal),
          click_function = 'SayPlayer',
          function_owner = self, label = "2",
          position = {-2.4, 0.2, 0.7}, width = 200, height = 200, color = {0, 0, 0, 1}, font_color = {0, 1, 0, 1}, tooltip = "Current Players"

      },

      PlayerInc =
      {
        index = 1,
          label = '+',
          click_function = 'PlayerInc',
          function_owner = self, label = "+", position = {-2.1, 0.2, 0.7}, tooltip = "Add Player"
      }
      ,
      PlayerDec =
      {
        index = 2,
          label = '-', --Text to display
          click_function = 'PlayerDec',
          function_owner = self, label = "-", position = {-2.7, 0.2, 0.7}, tooltip = "Remove Player"
      },


      BattleVal =
      {
          index = 3,
          label = tostring(BattleVal),
          click_function = 'SayBattle',
          function_owner = self, label = "1",
          position = {-2.4, 0.2, -0.3}, width = 200, height = 200, color = {0, 0, 0, 1}, font_color = {0, 1, 0, 1}, tooltip = "Current Battle (Leave at one when not playing Expedition)"

      },

     BattleInc =
      {
        index = 4,
          label = '+',
          click_function = 'BattleInc',
          function_owner = self, label = "+", position = {-2.1, 0.2, -0.3}, tooltip = "Increase Battle"
      }
      ,
      BattleDec =
      {
        index = 5,
          label = '-', --Text to display
          click_function = 'BattleDec',
          function_owner = self, label = "-", position = {-2.7, 0.2, -0.3}, tooltip = "Lower Battle"
      },

      TurnVariantButton =
      {
        index = 6,
        click_function = 'variant',
        function_owner = self,
        label = 'New Age\nTurn Variant',
        position = {-2.4, 0.2, 0.1},
        rotation = {0,0,0},
        width = 500,
        height = 200,
        font_size = 60,
        color = {r = 0, g = 0.2, b = 1},
        tooltip = "Change between classic or updated Turn Orders for 3 and 4 player."
      },


      AeonNemesis =
      {
        index = 7,
        click_function = 'AeonNem',
        function_owner = self,
        label = 'Aeons End',
        position = {leftPos,0.2,row0},
        rotation = {0,0,0},
        width = buttonWidth,
        height = buttonHeight,
        font_size = 60,
        tooltip = "Add Aeon End Basic Nemesis Cards"
      },

      OutcastNemesis =
      {
        index = 8,
        click_function = 'OutcastNem',
        function_owner = self,
        label = 'Outcasts',
        position = {middlePos,0.2,row0},
        rotation = {0,0,0},
        width = buttonWidth,
        height = buttonHeight,
        font_size = 60,
        tooltip = "Add Outcasts Basic Nemesis Cards"
      },

      WarNemesis =
      {
        index = 9,
        click_function = 'WarNem',
        function_owner = self,
        label = 'War Eternal',
        position = {leftPos,0.2,row1},
        rotation = {0,0,0},
        width = buttonWidth,
        height = buttonHeight,
        font_size = 60,
        tooltip = "Add War Eternal Basic Nemesis Cards"
      },

      MinorNemesis =
      {
        index = 10,
        click_function = 'MinorNem',
        function_owner = self,
        label = 'Small Box\n& Kickstarter',
        position = {middlePos,0.2,row1},
        rotation = {0,0,0},
        width = buttonWidth,
        height = buttonHeight,
        font_size = 55,
        tooltip = "Add Small Box Expansion & Promotional Kickstarter Basic Nemesis Cards"
      },

      LegacyNemesis =
      {
        index = 11,
        click_function = 'LegacyNem',
        function_owner = self,
        label = 'Legacy',
        position = {leftPos,0.2,row2},
        rotation = {0,0,0},
        width = buttonWidth,
        height = buttonHeight,
        font_size = 60,
        tooltip = "Add Legacy Basic Nemesis Cards"
      },

      AgeNemesis =
      {
        index = 12,
        click_function = 'AgeNem',
        function_owner = self,
        label = 'New Age',
        position = {middlePos,0.2,row2},
        rotation = {0,0,0},
        width = buttonWidth,
        height = buttonHeight,
        font_size = 60,
        tooltip = "Add New Age Basic Nemesis Cards"
      },
      AllNemesisBalanced =
      {
        index = 13,
        click_function = 'AllNemBalanced',
        function_owner = self,
        label = 'All Games\n(Balanced)',
        position = {leftPos,0.2,row4},
        rotation = {0,0,0},
        width = buttonWidth,
        height = buttonHeightBig,
        font_size = 60,
        color = {r = 0.7, g = 0.7, b = 0.1},
        tooltip = "Add All Basic Nemesis Cards, mixed in the same manner that the base games do. Will choose randomly between AE/WE, Legacy, or NA/Outcasts style deck contstruction. Right click to pick specific style."
      },

      AllNemesis =
      {
        index = 14,
        click_function = 'AllNem',
        function_owner = self,
        label = 'All Games\n(Chaos)',
        position = {middlePos,0.2,row4},
        rotation = {0,0,0},
        width = buttonWidth,
        height = buttonHeightBig,
        font_size = 60,
        color = {r = 0.7, g = 0.2, b = 0.2},
        tooltip = "Add All Basic Nemesis Cards without regards to quantity of card types. Probably a lot harder!"
      },
      NewAgeUpgrade =
      {
        index = 15,
        click_function = 'NewUpg',
        function_owner = self,
        label = 'New Age\nUpgraded',
        position = {rightPos,0.2,row1},
        rotation = {0,0,0},
        width = buttonWidth,
        height = buttonHeight,
        font_size = 60,
        color = {r= 0.8, g = 0.4, b = 0.8},
        tooltip = "Add New Age Upgraded Basic Nemesis Cards"
      },
      OutcastsUpgrade =
      {
        index = 16,
        click_function = 'OutUpg',
        function_owner = self,
        label = 'Outcasts\nUpgraded',
        position = {rightPos,0.2,row2},
        rotation = {0,0,0},
        width = buttonWidth,
        height = buttonHeight,
        font_size = 60,
        color = {r= 0.8, g = 0.4, b = 0.8},
        tooltip = "Add Outcasts Upgraded Basic Nemesis Cards"
      },
      LegacyUpgrade =
      {
        index = 17,
        click_function = 'LegUpg',
        function_owner = self,
        label = 'Legacy\nUpgraded',
        position = {right_rightPos,0.2,row2},
        rotation = {0,0,0},
        width = buttonWidth,
        height = buttonHeight,
        font_size = math.floor(60),
        color = {r= 0.5, g = 0.3, b = 0.6},
        tooltip = "Add Legacy Upgraded Basic Nemesis Cards. These are fan edits of the final evolution cards, includes duplicates from New Age/Outcasts that existed in Legacy"
      },
      AllUpgrade =
      {
        index = 18,
        click_function = 'AllUpg',
        function_owner = self,
        label = 'All\nUpgraded',
        position = {(rightPos + right_rightPos)/2,0.2,row4},
        rotation = {0,0,0},
        width = buttonWidth,
        height = buttonHeightBig,
        font_size = 60,
        color = {r= 0.2, g = 0.1, b = 0.8},
        tooltip = "Add ALL Upgraded Basic Nemesis Cards. You will not get the same ratio as normal."
      },
        --[[GraveholdUpgrade =
        {
          index = 19,
          click_function = 'GraveUpg',
          function_owner = self,
          label = 'Gravehold\nUpgraded',
          position = {rightPos+0.43,0.2,row3},
          rotation = {0,0,0},
          width = buttonWidth*0.75,
          height = buttonHeight,
          font_size = math.floor(60*0.75),
          color = {r= 0.35, g = 0.2, b = 0.4},
          font_color = {r = 0.4, g = 0.4, b = 0.4},
          tooltip = "Add Legacy of Gravehold Upgraded Basic Nemesis Cards. These are fan edits of upgraded basics.\n[b]These were later reprinted and replaced by versions in the Past and Future Wave 7 release.[/b]\nThere are fewer in this set than normal and heavily rely on the Fire Mechanic."
        },]]--
        PastFutureUpgrade =
        {
          index = 19,
          click_function = 'FutureUpg',
          function_owner = self,
          label = 'Past & Future\nUpgraded',
          position = {right_rightPos,0.2,row1},
          rotation = {0,0,0},
          width = buttonWidth,
          height = buttonHeight,
          font_size = 55,
          color = {r= 0.8, g = 0.4, b = 0.8},
          tooltip = "Add Past and Future Upgraded Basic Nemesis Cards\nThese are official reprints of the Upgraded Basics from Legacy of Gravehold and include new ones to bulk up the numbers.\n[i](These make heavy use of the Fire token mechanic)[/i]"
        },
        GraveholdNemesis =
        {
          index = 20,
          click_function = 'GraveNem',
          function_owner = self,
          label = 'Legacy of\nGravehold',
          position = {leftPos,0.2,row3},
          rotation = {0,0,0},
          width = buttonWidth,
          height = buttonHeight,
          font_size = 55,
          tooltip = "Add Legacy of Gravehold Basic Nemesis Cards\n[i](These make heavy use of the Fire token mechanic)[/i]"
        },
        DescentNemesis =
        {
          index = 21,
          click_function = 'DescentNem',
          function_owner = self,
          label = 'Descent',
          position = {middlePos,0.2,row3},
          rotation = {0,0,0},
          width = buttonWidth,
          height = buttonHeight,
          font_size = 60,
          tooltip = "Add the Descent Basic Nemesis Cards"
        },
        DescentUpgrade =
        {
          index = 22,
          click_function = 'DescentUpg',
          function_owner = self,
          label = 'Descent\nUpgraded',
          position = {(rightPos + right_rightPos)/2,0.2,row3},
          rotation = {0,0,0},
          width = buttonWidth,
          height = buttonHeight,
          font_size = 55,
          color = {r= 0.8, g = 0.4, b = 0.8},
          tooltip = "Add Descent Upgraded Basic Nemesis Cards"
        },
    }



  for i, v in pairs(buttonParameters) do
      self.createButton(v)
  end
end



function SayPlayer()
  print("The game is current set for " .. tostring(PlayerVal) .. " players.")
end

function PlayerInc()
  if PlayerVal < 4 then
    PlayerVal = PlayerVal+1
    getObjectFromGUID('b9111a').setVar('playerval',PlayerVal)
  end


    -- update the attack 'button' label.
    buttonParameters.PlayerVal.label = PlayerVal
    self.editButton(buttonParameters.PlayerVal)
end

function PlayerDec()
  if PlayerVal > 1 then
    PlayerVal = PlayerVal-1
    getObjectFromGUID('b9111a').setVar('playerval',PlayerVal)
  end


    -- update the attack 'button' label.
    buttonParameters.PlayerVal.label = PlayerVal
    self.editButton(buttonParameters.PlayerVal)
end

function SayBattle()
  print("The game is current set to expedition battle " .. tostring(BattleVal))
end

function BattleInc()
  if BattleVal < 4 then
    BattleVal = BattleVal+1
  end


    -- update the attack 'button' label.
    buttonParameters.BattleVal.label = BattleVal
    if BattleVal > 1 then
      canContinue[3] = false
    end
    self.editButton(buttonParameters.BattleVal)
end

function BattleDec()
  if BattleVal > 1 then
    BattleVal =BattleVal-1
  end


    -- update the attack 'button' label.
    buttonParameters.BattleVal.label = BattleVal
    if BattleVal == 1 then
      canContinue[3] = true
    end
    self.editButton(buttonParameters.BattleVal)
end

function variant()
  if (turnVariant == false) then
      turnVariant = true
      self.editButton({
        index = 6,
        label = "New Age\nTurn Variant",
        color = {r = 0, g = 0.2, b = 1}
      })
  else
      turnVariant = false;
      self.editButton({
        index = 6,
        label = "Classic\nTurn Variant",
        color = {r = 0, g = 1, b = 0.2}
      })
  end
end


function fuckingMythAndFuckingBone() --seriously this has so much specific setup needed, bloody moose mo-fo.
  getObjectFromGUID(mythLife).setLock(true)
  getObjectFromGUID(boneLife).setLock(true)
end

function BuildNemesis(reduce)
  if forceMythBone == true then
    Wait.time(turnOrder,2.4)
    return(nil)
  end
  local Tier1 = findDecksInZone(getObjectFromGUID(tier1Select))
  if (Tier1 ~= nil) then
    Tier1.randomize()
  end
  local Tier2 = findDecksInZone(getObjectFromGUID(tier2Select))
  if (Tier2 ~= nil) then
    Tier2.randomize()
  end
  local Tier3 = findDecksInZone(getObjectFromGUID(tier3Select))
  if (Tier3 ~= nil) then
    Tier3.randomize()
  end

  if reduce == nil then
    reduce = 0
  end

  if (canContinue[2] == true) then
    upgrade1 = findDecksInZone(getObjectFromGUID(upgradedScript[1]))
    upgrade2 = findDecksInZone(getObjectFromGUID(upgradedScript[2]))
    upgrade3 = findDecksInZone(getObjectFromGUID(upgradedScript[3]))

    upgrade1.shuffle()
    upgrade2.shuffle()
    upgrade3.shuffle()
  end

  local params1 = {position = buildTier1, rotation = {0.00, 180.00, 180.00}}
  local params2 = {position = buildTier2, rotation = {0.00, 180.00, 180.00}}
  local params3 = {position = buildTier3, rotation = {0.00, 180.00, 180.00}}

-- build tier 1
  local tier1Selection = math.min(nemesis_table[1][PlayerVal] - upgrade_table[1][BattleVal] + reduce, nemesis_table[1][PlayerVal])
  if tier1Selection > 0 then
    for i = 1, tier1Selection,1 do
      Tier1.takeObject(params1)
    end
    for i = 1, upgrade_table[1][BattleVal] - reduce,1 do
      upgrade1.takeObject(params1)
    end
  else
    for i = 1, nemesis_table[1][PlayerVal] - reduce,1 do
      upgrade1.takeObject(params1)
    end
  end

  -- build tier 2
    local tier2Selection = math.min(nemesis_table[2][PlayerVal] - upgrade_table[2][BattleVal] + reduce, nemesis_table[2][PlayerVal])
    if tier2Selection > 0 then
      for i = 1, tier2Selection,1 do
        Tier2.takeObject(params2)
      end
      for i = 1, upgrade_table[2][BattleVal] - reduce,1 do
        upgrade2.takeObject(params2)
      end
    else
      for i = 1, nemesis_table[2][PlayerVal] - reduce,1 do
        upgrade2.takeObject(params2)
      end
    end

    -- build tier 3
      local tier3Selection = math.min(nemesis_table[3][PlayerVal] - upgrade_table[3][BattleVal] + reduce, nemesis_table[3][PlayerVal])
      if tier3Selection > 0 then
        for i = 1, tier3Selection,1 do
          Tier3.takeObject(params3)
        end
        for i = 1, upgrade_table[3][BattleVal] - reduce,1 do
          upgrade3.takeObject(params3)
        end
      else
        for i = 1, nemesis_table[3][PlayerVal] - reduce,1 do
          upgrade3.takeObject(params3)
        end
      end
    Wait.time(turnOrder,2.4)



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

function alreadyPicked()
  printToAll("You've already added this.", {r = 0.8, g = 0.3, b = 0.4})
end

function cannotBalance()
  printToAll("This option can no longer be picked.", {r = 0.8, g = 0.3, b = 0.4})
end

function AeonNem()

  local myGame = 1
  takeTiers(myGame)
  self.editButton({
    index = 7,
    color = {r = 0, g = 0, b = 0},
    click_function = 'alreadyPicked'
  })

end

function WarNem()

  local myGame = 2
  takeTiers(myGame)
  self.editButton({
    index = 9,
    color = {r = 0, g = 0, b = 0},
    click_function = 'alreadyPicked'
  })

end

function LegacyNem()

  local myGame = 3
  takeTiers(myGame)
  self.editButton({
    index = 11,
    color = {r = 0, g = 0, b = 0},
    click_function = 'alreadyPicked'
  })

end

function AgeNem()

  local myGame = 4
  takeTiers(myGame)
  self.editButton({
    index = 12,
    color = {r = 0, g = 0, b = 0},
    click_function = 'alreadyPicked'
  })

end

function OutcastNem()

  local myGame = 5
  takeTiers(myGame)
  self.editButton({
    index = 8,
    color = {r = 0, g = 0, b = 0},
    click_function = 'alreadyPicked'
  })

end

function GraveNem()

  local myGame = 14
  takeTiers(myGame)
  self.editButton({
    index = 20,
    color = {r = 0, g = 0, b = 0},
    click_function = 'alreadyPicked'
  })

end

function DescentNem()

  local myGame = 17
  takeTiers(myGame)
  self.editButton({
    index = 21,
    color = {r = 0, g = 0, b = 0},
    click_function = 'alreadyPicked'
  })

end

function MinorNem()

  local myGame = 6
  takeTiers(myGame)
  self.editButton({
    index = 10,
    color = {r = 0, g = 0, b = 0},
    click_function = 'alreadyPicked'
  })

end

function AllNem()

  for j = 0, 7, 1 do
    self.editButton({
      index = 7 + j,
      color = {r = 0, g = 0, b = 0},
      click_function = 'alreadyPicked'
    })
  end
  self.editButton({
    index = 20,
    color = {r = 0, g = 0, b = 0},
    click_function = 'alreadyPicked'
  })
  self.editButton({
    index = 21,
    color = {r = 0, g = 0, b = 0},
    click_function = 'alreadyPicked'
  })
  for i = 1, 6, 1 do
  takeTiers(i)
  end
  takeTiers(17) --the descent
end

function AllNemBalanced(obj,color,alt_click)
    if (alt_click == false) then
        for j = 0, 7, 1 do
            self.editButton(
                {
                    index = 7 + j,
                    color = {r = 0, g = 0, b = 0},
                    click_function = "alreadyPicked"
                }
            )
        end
        self.editButton({
          index = 20,
          color = {r = 0, g = 0, b = 0},
          click_function = 'alreadyPicked'
        })
        self.editButton({
          index = 21,
          color = {r = 0, g = 0, b = 0},
          click_function = 'alreadyPicked'
        })
        for i = 7, 9, 1 do --minion, power, attack cards
            takeTiers(i, 999)
        end
        Wait.time(grabBalancedNem, 0.6)
    else
        if (balanceVariant < 4) then
            balanceVariant = balanceVariant + 1
        else
            balanceVariant = 0
        end
        local vers = "(Balanced)"
        if (balanceVariant == 1) then
            vers = "(AE/WE)"
        elseif (balanceVariant == 2) then
            vers = "(NA/Outcasts)"
        elseif (balanceVariant == 3) then
            vers = "(Legacy)"
        elseif (balanceVariant == 4) then
            vers = "(Descent)"
        end
        self.editButton(
            {
                index = 13,
                label = "All Games\n" .. vers
            }
        )
    end
end


function grabBalancedNem()
        if (balanceVariant == 0) then
            myOffset = math.random(1, 4)
        else
            myOffset = balanceVariant
        end
        if (myOffset == 2) then
            myOffset = 4
            broadcastToAll("Using Aeon's End / War Eternal basic deck construction.")
        elseif (myOffset == 3) then
            myOffset = 7
            broadcastToAll("Using Legacy basic deck construction.")
        elseif (myOffset == 1) then
            myOffset = 1
            broadcastToAll("Using New Age / Outcasts basic deck construction.")
        elseif (myOffset == 4) then
            broadcastToAll("Using Descent basic deck construction.")
  			    takeTiers(17)
  			    return
        end
        for h = 1, 3, 1 do
            for i = myOffset, myOffset + 2, 1 do
                numToTake = balancedTiers[i][h]

                if 1 == 0 then
                    return (nil)
                end
                local myNemDeck = {}
                local n1 = {}
                if i == 1 or i == 4 or i == 7 then
                    myNemDeck = nem_deck1_table
                    n1 = nemTier1
                elseif i == 2 or i == 5 or i == 8 then
                    myNemDeck = nem_deck2_table
                    n1 = nemTier2
                else
                    myNemDeck = nem_deck3_table
                    n1 = nemTier3
                end

                for g = 1, numToTake, 1 do
                    math.randomseed(os.time())
                    getObjectFromGUID(myNemDeck[6 + h]).shuffle()
                    local param = {position = n1, rotation = {0, 180, 180}}
                    getObjectFromGUID(myNemDeck[6 + h]).takeObject(param)
                end
            end
        end
end


function NewUpg()
  takeUpgrade(11)
end

function OutUpg()
  takeUpgrade(12)
end

function LegUpg()
  takeUpgrade(13)
end

function GraveUpg()
  takeUpgrade(15)
end

function FutureUpg()
  takeUpgrade(16)
end

function DescentUpg()
  takeUpgrade(18)
end


function AllUpg()
  takeUpgrade(10)
end

function canCont()
    canContinue[1] = true
end

function canCont2()
    canContinue[2] = true
end

function takeTiers(myGame,alternative_pos)
  local n1 = alternative_pos or nemTier1
  local n2 = alternative_pos or nemTier2
  local n3 = alternative_pos or nemTier3

  if (n1 == 999) then
    if (myGame == 7) then
      n1 = balance_vector[1]
      n2 = balance_vector[4]
      n3 = balance_vector[7]
    end
    if (myGame == 8) then
      n1 = balance_vector[2]
      n2 = balance_vector[5]
      n3 = balance_vector[8]
    end
    if (myGame == 9) then
      n1 = balance_vector[3]
      n2 = balance_vector[6]
      n3 = balance_vector[9]
    end
  end
  takeObjectSafe(getObjectFromGUID(deck_id[1]) ,{guid = nem_deck1_table[myGame] , position = n1, rotation = {0.00, 180.00, 180.00}, smooth = false},false)

  takeObjectSafe(getObjectFromGUID(deck_id[2]) ,{guid = nem_deck2_table[myGame] , position = n2, rotation = {0.00, 180.00, 180.00}, smooth = false},false)

  takeObjectSafe(getObjectFromGUID(deck_id[3]) ,{guid = nem_deck3_table[myGame] , position = n3, rotation = {0.00, 180.00, 180.00}, smooth = false},false)
  local myFrames = 1
  if (n1 == nemTier1) then
    myFrames = 2
  end
  Wait.time(canCont,myFrames)


    self.editButton({
      index = 13,
      color = {r = 0, g = 0, b = 0},
      click_function = 'cannotBalance'
    })
    self.editButton({
      index = 14,
      color = {r = 0, g = 0, b = 0},
      click_function = 'cannotBalance'
    })
end

function takeUpgrade(myGame)


  takeObjectSafe(getObjectFromGUID(deck_id[1]) ,{guid = nem_deck1_table[myGame] , position = getObjectFromGUID(upgradedScript[1]).getPosition(), rotation = {0.00, 180.00, 180.00}},false)

  takeObjectSafe(getObjectFromGUID(deck_id[2]) ,{guid = nem_deck2_table[myGame] , position = getObjectFromGUID(upgradedScript[2]).getPosition(), rotation = {0.00, 180.00, 180.00}},false)

  takeObjectSafe(getObjectFromGUID(deck_id[3]) ,{guid = nem_deck3_table[myGame] , position = getObjectFromGUID(upgradedScript[3]).getPosition(), rotation = {0.00, 180.00, 180.00}},false)
  Wait.time(canCont2,0.8)


  for i = 15, 19, 1 do
    self.editButton({
      index = i,
      color = {r = 0, g = 0, b = 0},
      click_function = 'alreadyPicked'
    })
  end
  self.editButton({
    index = 22,
    color = {r = 0, g = 0, b = 0},
    click_function = 'alreadyPicked'
  })
end

--perform takeObject only if the object exists in the container
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
    local playError = error or true
    if (playError == true) then
      print("Warning: Object " .. params.guid .. " not found in container.")
    end
end

function onObjectEnterScriptingZone(zone, info)
  if marketDone == false and info.getName() == "Burrower (Diff: 8) (SETUP AFTER THE SHOP)" and zone.getGUID() == "5b5b88" then
    broadcastToAll("Before setting up this nemesis, you should set up and lock market at first!",{r = 1, g = 0, b = 0})
    return
  end
  if (killSwitch == true) then
    return(nil)
  end
    if (zone.getGUID() == zone_GUID and ((info.getDescription() == "Nemesis" and info.type == "Bag") or
    ((info.getGMNotes() == "NemesisRandomizer1" or info.getGMNotes() == "NemesisRandomizer2" or
    info.getGMNotes() == "NemesisRandomizer3" or info.getGMNotes() == "NemesisRandomizer4")
    and info.type == "Card"))) then
    if (info.getName() == "Paradox of Myth and Bone (DOES NOT REQUIRE BASICS) (Diff: 5)") then
      canContinue[1] = true;
      canContinue[2] = true;
      canContinue[3] = true;
    else
        if canContinue[1] == false or (canContinue[2] == false and canContinue[3] == false) then
            local mess = "Basic and Upgraded Basics Nemesis"
            if canContinue[1] == true and (canContinue[2] == false and canContinue[3] == false) then
              mess = "Upgraded Basics Nemesis"
            elseif canContinue[1] == false and (canContinue[2] == true or canContinue[3] == true) then
              mess = "Basic Nemesis"
            end
            broadcastToAll("Select " .. mess .. " cards and then place this bag here again", {r = 1, g = 0.2, b = 0.2})
            return (nil)
        end
      end
        --print(info.getGUID())
        obj_GUID = info.getGUID()
        local bagName = info.getName()
        local reduceBy = 0
        local takeTurn = nil
        -- print(tostring(info) .. " collided with " .. tostring(self))
        obj_GUID = getObjectFromGUID(info.guid)
        if (info.getDescription() == "Nemesis" and info.type == "Bag" and zone.getGUID() == zone_GUID) then
            -- print("Is a bag")

            --print(zone.getGUID())
            bagNum = info.getQuantity()
            --print(tostring(bagNum))
            pullItems(info, bagNum)
            if bagName == "Xaxos: Ascended [Final Legacy Nemesis] (Diff: 9)" then
                reduceBy = 3
            elseif bagName == "Maelstrom: Risen (Diff: 8)" then
                reduceBy = 2
                turnOrderCard = "b6f3d6"
            elseif bagName == "Thief of Dreams (Diff: 4)" then
                turnOrderCard = "d34108"
            elseif bagName == "Paradox of Myth and Bone (DOES NOT REQUIRE BASICS) (Diff: 5)" then
              turnOrderCard = "7d16b6"
              turnOrderCardAlt = "df613f"
              forceMythBone = true
            end


            BuildNemesis(reduceBy)
      end

      if (info.type == 'Card') then
        broadcastToAll("Preparing Nemesis Deck", {r=1, g=1, b=0})
      else
        if (bagName ~= "Paradox of Myth and Bone (DOES NOT REQUIRE BASICS) (Diff: 5)") then
              Wait.time(moveTier3, 6)
              Wait.time(moveTier2, 8)
              Wait.time(moveTier1, 10)


        			Wait.time(nemWarning, 2.0)
              Wait.time(setupDone,11)
              if (info.type == 'Bag') then
                killSwitch = true
              end
        else
          broadcastToAll("Preparing Nemesis Deck", {r=1, g=1, b=0})

          Wait.time(nemWarning, 2.0)
          Wait.time(nemWarning, 5.5)
          Wait.time(setupDone,11)
        end
      end
        -- print("Is not a bag")

        if ((info.getGMNotes() == "NemesisRandomizer1" or info.getGMNotes() == "NemesisRandomizer2" or
        info.getGMNotes() == "NemesisRandomizer3" or info.getGMNotes() == "NemesisRandomizer4")
        and info.type == "Card") then
          print(info.getGMNotes())
          getNemesisBag(info.getGMNotes(),info)
        end
    end
end

function setupDone()

  -- Iterate through each contained object
  storeND = findDecksInZone(getObjectFromGUID('71a6e1'))


  broadcastToAll('Nemesis constructed.',{r=1,g=1,b=0})
  getObjectFromGUID('b9111a').setVar('nemesisDone',true)
end

function nemWarning()
	broadcastToAll("Do not interact with Nemesis Deck until its constructed.",{r=1, g=0, b=0})
end

function getNemesisBag(currentTier,card)
  print(nemesisBagDeck[currentTier] .. " / " .. card.getName())
  searchDeck(getObjectFromGUID(nemesisBagDeck[currentTier]),card.getName(),vector(-55.42, -0.35, 25.04),{0,180,0},'Name','Nemesis Bag does not exist in box.')
  local myPos2 = getObjectFromGUID('d089df').getPosition()
  card.setPositionSmooth(myPos2 + vector(0,8,0))
end

function killLifeTracker()
  destroyObject(getObjectFromGUID(lifeTrackerKill))
end

function moveTier1()
  print("Adding Tier 1")
  local TierDeck = findDecksInZone(getObjectFromGUID(tier1Zone))
  if (TierDeck ~= nil) then
    TierDeck.randomize()
    mainPos = getObjectFromGUID(boardGUID).getPosition()
    TierDeck.setPositionSmooth(mainPos + nemesisDeck + vector(0,3.5,0),false,true)
  end
end

function moveTier2()
print("Adding Tier 2")
local TierDeck = findDecksInZone(getObjectFromGUID(tier2Zone))
if (TierDeck ~= nil) then
  TierDeck.randomize()
  mainPos = getObjectFromGUID(boardGUID).getPosition()
  TierDeck.setPositionSmooth(mainPos + nemesisDeck + vector(0,2,0),false,trues)
end
end

function moveTier3()
	print("Adding Tier 3")
	local TierDeck = findDecksInZone(getObjectFromGUID(tier3Zone))
	  if (TierDeck ~= nil) then
		TierDeck.randomize()
		mainPos = getObjectFromGUID(boardGUID).getPosition()
		TierDeck.setPositionSmooth(mainPos + nemesisDeck,false,trues)
		TierDeck.setName("Nemesis Deck")
    --storeND = TierDeck
		Wait.time(moveTier3a, 1.2)
	  end
end

function moveTier3a()
	local TierDeck = findDecksInZone(getObjectFromGUID(tier3Zone))
	  if (TierDeck ~= nil) then
		TierDeck.randomize()
		mainPos = getObjectFromGUID(boardGUID).getPosition()
		TierDeck.setPositionSmooth(mainPos + nemesisDeck)

		TierDeck.setName("Nemesis Deck")
	  end
end

function pullItems(obj,num)
  local params = {}
  mainPos = getObjectFromGUID(boardGUID).getPosition()
  subPos = getObjectFromGUID(subboardGUID).getPosition()

  params = {
    position = mainPos + vector(0,5,0),
    smooth = false,
    callback_function = function(obj) takeCallback(obj) end
    }

  for j = 1, num do
      obj.takeObject(params)
  end

  destroyObject(obj)
end

function xaxosMove(deck)
  local xParam = {position = subPos + vector(-5.67, 5,-2.88), rotation = {0.00, 180.00, 180.00}}
  local xParamA = {position = subPos + vector(5.67, 24,-2.88), rotation = {0.00, 180.00, 180.00}}
  for i = 1, 6, 1 do
    if i <= 5 then
      deck.takeObject(xParam)
    else
      deck.takeObject(xParamA)
    end
  end
end

function lockMinorBoard()
  minorBoardStore.setLock(true)
end

function lockMainBoard()
  mainBoardStore.setLock(true)
end



function turnOrder()
  if (PlayerVal < 3) or (turnVariant == false) then
    turnV = getObjectFromGUID(turn_table[PlayerVal])
    local oldPos = turnV.getPosition()
    local newPos = getObjectFromGUID(turnDeck).getPosition()
    turnV.setPosition(newPos + vector(0,2,0))
    turnV.setRotation({0,180,180})
    Wait.time(function()
      zone = getObjectFromGUID('d3724a')
      turn_order_deck = findDecksInZone(zone)
      if turn_order_deck ~= nil then
        Wait.time(function()
        turn_order_deck.shuffle()
      end,1.5)
      end
    end,0.5)
  end
  if (PlayerVal == 3) and (turnVariant == true) then
    turnV = getObjectFromGUID(turn_table[8])
    local oldPos = turnV.getPosition()
    local newPos = getObjectFromGUID(turnDeck).getPosition()
    turnV.setPosition(newPos + vector(0,2,0))
    turnV.setRotation({0,180,180})
    Wait.time(function()
      zone = getObjectFromGUID('d3724a')
      turn_order_deck = findDecksInZone(zone)
      if turn_order_deck ~= nil then
        Wait.time(function()
        turn_order_deck.shuffle()
      end,1.5)
      end
    end,0.5)
    local myTok = getObjectFromGUID(turn_table[9])
    myTok.setPositionSmooth(vector(0,3,-17.92))
    myTok.setRotationSmooth({0,180,0})
    myTok.setScale({0.85,1,0.85})
    local meT = getObjectFromGUID('88a2c3')
    meT.setVar('threePlayer',true)
  end
  if (PlayerVal == 4) and (turnVariant == true) then
    turnV = getObjectFromGUID(turn_table[5])
    local oldPos = turnV.getPosition()
    local newPos = getObjectFromGUID(turnDeck).getPosition()
    turnV.setPosition(newPos + vector(0,2,0))
    turnV.setRotation({0,180,180})
    Wait.time(function()
      zone = getObjectFromGUID('d3724a')
      turn_order_deck = findDecksInZone(zone)
      if turn_order_deck ~= nil then
        Wait.time(function()
        turn_order_deck.shuffle()
      end,1.5)
      end
    end,0.5)
    local myTok = getObjectFromGUID(turn_table[6])
    myTok.setPositionSmooth({2.04, 3.78, -17.92})
    myTok.setRotationSmooth({0,180,0})
    myTok.setScale({0.75,1,0.75})
    local myTok2 = getObjectFromGUID(turn_table[7])
    myTok2.setPositionSmooth({-2.04, 3.78, -17.92})
    myTok2.setRotationSmooth({0,180,0})
    myTok2.setScale({0.75,1,0.75})
    local meT = getObjectFromGUID('88a2c3')
    meT.setVar('fourPlayer',true)
  end
  Wait.time(moveTurnBossCard,2)

end

function moveTurnBossCard()
  if (turnOrderCard ~= nil) then
    findDeck = findDecksInZone(getObjectFromGUID(turnDeck))
    local setNem = searchDeck(findDeck,'nem1',vector(22.61, 3, 4.58),{0,180,0},"Des","Cannot find Nemesis turn order card.")
    getObjectFromGUID(turnOrderCard).putObject(findDeck)
    setNem.addTag('setup')
    findDeck.shuffle()
  end
  if (turnOrderCardAlt ~= nil) then
    findDeck = findDecksInZone(getObjectFromGUID(turnDeck))
    local setNem2 = searchDeck(findDeck,'nem2',vector(22.61, 3, 4.58),{0,180,0},"Des","Cannot find Nemesis turn order card.")
    getObjectFromGUID(turnOrderCardAlt).putObject(findDeck)
    setNem2.addTag('setup')
    findDeck.shuffle()
  end
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

function takeCallback(obj_spawned)
  local myDes = obj_spawned.getDescription()
  local myName = obj_spawned.getName()
  local myGMS = obj_spawned.getGMNotes()
  mainPos = getObjectFromGUID(boardGUID).getPosition()
  subPos = getObjectFromGUID(subboardGUID).getPosition()

  --print("Spawning " .. tostring(myDes) .. " " .. tostring(myName))
      if (myDes == "T1" or myName =="Mist 1") then
        obj_spawned.setPositionSmooth(buildTier1)
        obj_spawned.setRotation({0.00, 180.00, 180.00})
    end
    if (myDes == "T2") then
      obj_spawned.setPositionSmooth(buildTier2)
      obj_spawned.setRotation({0.00, 180.00, 180.00})
  end
  if (myDes == "T3") then
    obj_spawned.setPositionSmooth(buildTier3)
    obj_spawned.setRotation({0.00, 180.00, 180.00})
end
-- mist revealed setup --
if (myDes == "T4") then
  obj_spawned.setPositionSmooth(buildTier3)
  obj_spawned.shuffle()
  obj_spawned.setRotation({0.00, 180.00, 180.00})

  local i = 1
  for i = 1, 7, 1 do
    local m3 = {position = vector(22.61, 2.42 + i, 4.58), rotation = {0,180,180},
    smooth = true}
    obj_spawned.takeObject(m3)
  end

end
if (myDes == "Minor Deck") then
  obj_spawned.setPositionSmooth(mainPos + subDeck)
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myGMS == "MinorHP") then
  obj_spawned.setPositionSmooth((mainPos + subDeck) + vector(-4.5,4,0))
  --print(obj_spawned.getName())
  --obj_spawned.setRotation({0.00, 180.00, 0})
end
--paradox of myth and bone
if (myName == "Myth Nemesis Board") then
  obj_spawned.setPosition(mythBoard)
  obj_spawned.setRotation({0.00, 180.00, 0})
  obj_spawned.setLock(true)

  local subMe = getObjectFromGUID(subboardGUID)
  subMe.setPosition(subMe.getPosition() + vector(-3,-5,0))
end

if (myName == "Myth 1" or myName == "Myth 2" or myName == "Myth 3") then
  if (myDes == "T1" or myDes == "T2" or myDes == "T3") then
    return(nil)
  end
  local myOff = 9
  local take = 0
  if (myName == "Myth 1") then
    myOff = 15

    if (PlayerVal == 1) then take = 3 end
    if (PlayerVal == 2) then take = 2 end
    if (PlayerVal == 3) then take = 1 end
  end
  if (myName == "Myth 2") then
    myOff = 12
    if (PlayerVal == 1) then take = 2 end
    if (PlayerVal == 2) then take = 1 end
  end
  obj_spawned.setPositionSmooth(mythBoard + vector(-17.45,myOff,7.73))
  obj_spawned.setRotation({0.00, 180.00, 180.00})
  obj_spawned.shuffle()
obj_spawned.setName("Myth Deck")
  for i = 1, take, 1 do
    local m3 = {position = vector(22.61, 2.42 + i, 4.58), rotation = {0,180,180},
    smooth = true}
    obj_spawned.takeObject(m3)
  end
end

if (myName == "Bone Life") then
  obj_spawned.setPositionSmooth(vector(13.65, 4.77, 32.44))
  obj_spawned.setRotation({0.00, 180.00, 00})
  boneLife = obj_spawned.getGUID()
  if (PlayerVal <= 2) then
    obj_spawned.setDescription(50)
    obj_spawned.call('customSet')
    print("Nemesis life set.")
  end
end

if (myName == "Myth Life") then
  obj_spawned.setPositionSmooth(vector(-49.49, 4.77, 10.71))
  obj_spawned.setRotation({0.00, 180.00, 00})
  mythLife = obj_spawned.getGUID()
  if (PlayerVal <= 2) then
    obj_spawned.setDescription(50)
    obj_spawned.call('customSet')
  end
  Wait.time(fuckingMythAndFuckingBone,4)
end

if (myName == "Bone 1" or myName == "Bone 2" or myName == "Bone 3") then
  if (myDes == "T1" or myDes == "T2" or myDes == "T3") then
    return(nil)
  end
  local myOff = 9
  local take = 0
  if (myName == "Bone 2") then
    myOff = 12
    if (PlayerVal == 1) then take = 2 end
    if (PlayerVal == 2) then take = 1 end
  end
  if (myName == "Bone 1") then
    myOff = 15
    if (PlayerVal == 1) then take = 3 end
    if (PlayerVal == 2) then take = 2 end
    if (PlayerVal == 3) then take = 1 end
  end
  obj_spawned.setPositionSmooth(mainPos + nemesisDeck + vector(0,myOff,0))
  obj_spawned.setName("Bone Deck")
  obj_spawned.setRotation({0.00, 180.00, 180.00})
  obj_spawned.shuffle()

    for i = 1, take, 1 do
    local m3 = {position = vector(22.61, 2.42 + i, 4.58), rotation = {0,180,180},
    smooth = true}
    obj_spawned.takeObject(m3)
    obj_spawned.addTag(nemesisDeckCard)
  end
end

if (myName == "Nemesis Life Scripting") then
  local nemobj = getObjectFromGUID(nemesisLifeObject)
  nemobj.setDescription(obj_spawned.getDescription())
  nemobj.call('customSet')
  print("Nemesis life set to " .. obj_spawned.getDescription())
  lifeTrackerKill = obj_spawned.getGUID()
  Wait.time(killLifeTracker, 1)
end

if (myDes == "Minor Deck Shuffled" or myDes == "Minor Deck Shuffle") then
  obj_spawned.setPositionSmooth(mainPos + subDeck)

  if (myName ~= "Parasite Deck") then
    obj_spawned.setRotation({0.00, 180.00, 180.00})
  else
    obj_spawned.setRotation({0.00, 180.00, 0})
  end
  obj_spawned.shuffle()
  obj_spawned.setDescription('')
end

if (myDes == "Minor Deck No Flip") then
  obj_spawned.setPositionSmooth(mainPos + subDeck)
  obj_spawned.setRotation({0.00, 180.00, 0})
  obj_spawned.shuffle()
  obj_spawned.setDescription('')
end

if (myName == "[A020F0]Void Tokens[-]") then
  obj_spawned.setPosition(vector(-0,8,-30.46))
  obj_spawned.setRotation({0.00, 0.00, 0.00})
  obj_spawned.setScale({x=2,y=2,z=2})
  obj_spawned.setDescription('')
end

    if (myDes == "Bag 1") then
      obj_spawned.setPositionSmooth(mainPos + vector(20,6,-5))
      obj_spawned.setRotation({0.00, 0.00, 0.00})
      obj_spawned.setDescription('')
    end
    if (myDes == "Bag 2") then
      obj_spawned.setPositionSmooth(mainPos + vector(24,6,-5))
      obj_spawned.setRotation({0.00, 0.00, 0.00})
      obj_spawned.setDescription('')
    end
    if (myDes == "Bag 3") then
      obj_spawned.setPositionSmooth(mainPos + vector(28,6,-5))
      obj_spawned.setRotation({0.00, 0.00, 0.00})
      obj_spawned.setDescription('')
    end
    if (myDes == "Bag 4") then
      obj_spawned.setPositionSmooth(mainPos + vector(32,6,-5))
      obj_spawned.setRotation({0.00, 0.00, 0.00})
      obj_spawned.setDescription('')
    end
if (myDes == "Main Board") then
  obj_spawned.setPositionSmooth(mainPos + vector(-3.2,5,6.37))
  obj_spawned.setRotation({0.00, 180.00,0})
  mainBoardStore = obj_spawned
  Wait.time(lockMainBoard, 3)
  local counter = getObjectFromGUID("a55a93")
  if myName == "The Wrath (Diff: 8)" then
    counter.call('setValue',1)
  end
  if myName == "Stonemonger" and PlayerVal < 4 then
    counter.call('setValue',1)
  end
  if (myName == "Magus of Cloaks") or (myName == "Gate Witch") or (myName == "Umbra Titan") or (myName == "The Wailing")
  or (((myName == "Herald of the End") or (myName == "Fenrix")) and PlayerVal ~= 4) or ((myName == "Corruption's Core") and PlayerVal < 3) then
    local magus = getObjectFromGUID(nemesisTokensGUID)
    local nm = 4
    if (myName == "Gate Witch" or myName == "The Wailing") then
      nm = 1
    end
    if (myName == "Umbra Titan") then
      nm = 8
      counter.call('setValue',8)
    end
    if (myName == "Fenrix") then
      nm = 1
      if (PlayerVal < 3) then
        nm = 2
      end
    end
    if (myName == "Corruption's Core") then
      nm = 2
    end
    if (myName == "Herald of the End") then
      nm = 2
      counter.call('setValue',2)
      if (PlayerVal == 3) then
        nm = 1
        counter.call('setValue',1)
      end
    end
    for i = 1, nm, 1 do
      local add = 2.04 * i
      local magusParams = {
      position = mainPos + vector(-12.24 + add,6,18.13),
      rotation = {0, 180, 0}}
      magus.takeObject(magusParams)
    end
  end
end
if (myDes == "Sub Board") then
  obj_spawned.setPositionSmooth(subPos + vector(0,2.5,0),false,true)
  obj_spawned.setRotation({0.00, 180.00, 0})
  if (myName == "Tainted Track") then
      obj_spawned.setRotation({0.00, 180.00, 180})
  end
  minorBoardStore = obj_spawned
  Wait.time(lockMinorBoard,4)
end
if (myDes == "SubBag1") then
  obj_spawned.setPositionSmooth(subPos + vector(-6.03,8,8.54))
  obj_spawned.setRotation({0, 0, 0})
  obj_spawned.setDescription('')
end

if (myName == "[0EEE27]Globule Tokens[-]") then
  obj_spawned.setPositionSmooth(subPos + vector(6.53,8,5.54))
  obj_spawned.setRotation({0, 0, 0})
  --obj_spawned.setDescription('')
end

--starting nemesis cards--
--position 1
if (myName == "Breeding Chamber") or (myName == "Thief of Dreams Additional Setup") or (myDes == "Setup Reminder")  or (myDes == "Reminder Card") then
  obj_spawned.setPositionSmooth(mainPos + vector(-17.19,6,-12.31))
  obj_spawned.setRotation({0.00, 180.00, 0.00})
  if (myDes == "Setup Reminder" or myDes == "Reminder Card") then
    obj_spawned.setDescription('')
  end
end
--position 2--
if (myName == "Thief of Dreams Delirium Turn" or myName == "Bone Nemesis Turn") then
  obj_spawned.setPositionSmooth(mainPos + vector(-10.69,6,-12.31))
  obj_spawned.setRotation({0.00, 180.00, 0.00})
end

--position 3--
if (myName == "Maelstrom Assault Turn" or myName == "Myth Nemesis Turn") then
  obj_spawned.setPositionSmooth(mainPos + vector(-4.19,6,-12.31))
  obj_spawned.setRotation({0.00, 180.00, 0.00})
end

--rageborne --
if (myName == "Fury Token") then
  obj_spawned.setPositionSmooth(mainPos + vector(-10.2,6,18.13))
  obj_spawned.setRotation({0, 180, 0})
end

-- blazing kor --
if (myName == "Voracious Ember Token") then
  obj_spawned.setPositionSmooth(subPos + vector(-4,6,-9.02))
  obj_spawned.setRotation({0, 180, 0})
end

if (myName == "Blazing Ember Token") then
  obj_spawned.setPositionSmooth(subPos + vector(0.2,6,-9.02))
  obj_spawned.setRotation({0, 180, 0})
end

if (myName == "Ember Lord Token") then
  obj_spawned.setPositionSmooth(subPos + vector(4,6,-9.02))
  obj_spawned.setRotation({0, 180, 0})
end

if (myName == "Ignition Randomiser Dice") then
  obj_spawned.setPositionSmooth(subPos + vector(0,14,0))
  obj_spawned.setName("Ignition Dice")
end

if (myName == "1st Player Token") then
  obj_spawned.setPositionSmooth(subPos + vector(-3.36,8,1.17))
  obj_spawned.setRotation({0, 180, 0})
end

if (myName == "2nd Player Token") then
  obj_spawned.setPositionSmooth(subPos + vector(3.36,8,-1.17))
  obj_spawned.setRotation({0, 180, 0})
end

if (myName == "3rd Player Token") then
  obj_spawned.setPositionSmooth(subPos + vector(-1.17,8,-3.36))
  obj_spawned.setRotation({0, 180, 0})
end

if (myName == "4th Player Token") then
  obj_spawned.setPositionSmooth(subPos + vector(1.17,8,3.36))
  obj_spawned.setRotation({0, 180, 0})
end

if (myName == "Ember Tokens") then
  obj_spawned.setPositionSmooth(subPos + vector(0,6,9.02))
  obj_spawned.setRotation({0, 0, 0})
  local offsetEmb = {
  [1] = vector(-5.67,9,5.67),
  [2] = vector(5.67,9,5.67),
  [3] = vector(5.67,9,-5.67),
  [4] = vector(-5.67,9,-5.67)
  }
  local posX = math.random(1,4)
  print("Spawning Embers at " .. tostring(posX))
  local emberParam = {position = subPos + offsetEmb[posX], rotation ={0.00, 0, 0.00}}
  for i = 1, 2, 1 do
    obj_spawned.takeObject(emberParam)
  end
end

if (myName == "Burning Kor Player Reminders") then
  for i = 1, 4, 1 do
    local playPos = getObjectFromGUID(playerBoardGUID[i]).getPosition()
    local curseParm = {position = playPos + vector(8,3,-3.4), rotation ={0.00, 180.00, 0.00}}
    obj_spawned.takeObject(curseParm)
  end
end
--stonemonger
if (myDes == "Corrupted Opal") or (myDes == "Poisoned Peridot") or (myDes == "Draining Diamond") then
  if (myDes == "Corrupted Opal") then
    obj_spawned.setPositionSmooth(mainPos + vector(-10.69,6,-12.31))
    obj_spawned.setRotation({0.00, 180.00, 0.00})
  end
    if (myDes == "Poisoned Peridot") then
      obj_spawned.setPositionSmooth(mainPos + vector(-4.2,6,-12.31))
      obj_spawned.setRotation({0.00, 180.00, 0.00})
  end
  if (myDes == "Draining Diamond") then
    obj_spawned.setPositionSmooth(mainPos + vector(2.31,6,-12.31))
    obj_spawned.setRotation({0.00, 180.00, 0.00})
  end
end
--infested mutation--
if (myName == "Glob 1") then
  obj_spawned.setName("[0EEE27]Globule Minion[-]")
  if (myDes == "V1") then
    obj_spawned.setPositionSmooth(vector(-34.27, 15.09, 14.34))

elseif (myDes == "V2") then
    obj_spawned.setPositionSmooth(vector(-31.79, 15.09, 14.34))

elseif (myDes == "V3") then
    obj_spawned.setPositionSmooth(vector(-31.92, 15.09, 12.25))
else
    obj_spawned.setPositionSmooth(vector(-34.57, 5.09, 12.26))
  end

  obj_spawned.setDescription("")

end

if (myName == "Glob 2") then
  if (PlayerVal <= 2) then
    obj_spawned.destruct()
  else
  obj_spawned.setName("[0EEE27]Globule Minion[-]")
  if (myDes == "V5") then
    obj_spawned.setPositionSmooth(vector(-34.13, 15.09, 10.32))
  end
  if (myDes == "V6") then
    obj_spawned.setPositionSmooth(vector(-31.63, 15.09, 10.22))
  end
  obj_spawned.setDescription("")
  end
end

--necroswrm--
if (myName == "Bramble Tokens") then
  obj_spawned.setPositionSmooth(subPos + vector(0,6,9.02))
  obj_spawned.setRotation({0, 0, 0})
  local brambleParam = {position = subPos + vector(-8.06,8,-0.21), rotation ={0.00, 180.00, 0.00}}
  obj_spawned.takeObject(brambleParam)

end

--hordecrone--
if (myName == "Yud Reminder Token") then
  obj_spawned.setPositionSmooth(mainPos + vector(-7.2,6,18.13))
  obj_spawned.setRotation({0, 180, 0})
end

if (myName == "Zom Reminder Token") then
  obj_spawned.setPositionSmooth(mainPos + vector(-3.2,6,18.13))
  obj_spawned.setRotation({0, 180, 0})
end

if (myName == "Orp Reminder Token") then
  obj_spawned.setPositionSmooth(mainPos + vector(1.2,6,18.13))
  obj_spawned.setRotation({0, 180, 0})
end

--maiden of thorns --
if (myName == "Thorn Token") then
  if (myDes == "Tier 1") then
    obj_spawned.setPositionSmooth(subPos + vector(0,8,-2))
  elseif (myDes == "Tier 2") then
    obj_spawned.setPositionSmooth(subPos + vector(-4.68,8,2.16))
  elseif (myDes == "Tier 3") then
    obj_spawned.setPositionSmooth(subPos + vector(4.83,8,2.06))
  end
  obj_spawned.setRotation({0.00, 0.00, 180.00})
end

--maelstrom--


--hollow crown / horde crone / maelstrom / bishop of scrolls / mother of rust
if (myName == "Acolyte Deck" or myName == "Trogg Deck" or myName == "Beacon Deck" or myName == "Rustborn Deck" or myName == "Unnamed Deck" or myName == "Villager Deck" or myName == "Hydra Deck") then
  obj_spawned.setPositionSmooth(mainPos + subDeck)
  obj_spawned.setRotation({0.00, 180.00, 180.00})
  obj_spawned.shuffle()
  obj_spawned.setDescription('')
  local ac1 = {position = mainPos + vector(-17.19,6,-12.31), rotation = {0,180,0},
  smooth = true}
  local ac2 = {position = mainPos + vector(-10.69,6,-12.31), rotation = {0,180,0},
  smooth = true}
  local ac3 = {position = mainPos + vector(-4.19,6,-12.31), rotation = {0,180,0},
  smooth = true}
  obj_spawned.takeObject(ac1)
	if (myName ~= "Trogg Deck" and myName ~= "Hydra Deck" and myName ~= "Rustborn Deck") then
		obj_spawned.takeObject(ac2)
	end
  if (myName == "Unnamed Deck" and PlayerVal <= 3) then
    obj_spawned.takeObject(ac3)
  end
end

-- bishop of scrolls --
if (myName == "Bishop of Scrolls Comparsion") then
  obj_spawned.setPositionSmooth({22.61, 2.42, 4.58})
end

-- paradox of myth --
if (myName == "Myth Unleash Token") then
  obj_spawned.setPositionSmooth(mainPos + vector(-7.05,15,7.85))
  obj_spawned.setRotation({0, 180, 0})
end

-- griefweaver
if (myName == "Griefweaver Setup Reminder Board") then
  obj_spawned.setScale({4.20,0,4.20})
  obj_spawned.setDescription("Griefweaver requires a specific shop setup in order to function, this will have to be done somewhat manually.")
end

--wraithmonger--
if (myName == "Terror Level Token") then
  local ref = -2.84
  obj_spawned.setPositionSmooth(subPos + vector(0,6,-8.38 - (ref * (tonumber(myDes) - 1))))
  obj_spawned.setRotation({0.00, 180.00, 0.00})
  obj_spawned.setName("Terror Level " .. myDes .. " Token")
  obj_spawned.setDescription('')
end

--ageless walker--
if (myName == "Curse of Aging") then
  for i = 1, 4, 1 do
    local playPos = getObjectFromGUID(playerBoardGUID[i]).getPosition()
    local curseParm = {position = playPos + vector(14,3,-6.4), rotation ={0.00, 180.00, 0.00}}
    obj_spawned.takeObject(curseParm)
  end
end

--fenrix--
if (myName == "Player Position") then
    local playPos = getObjectFromGUID(playerBoardGUID[tonumber(myDes)]).getPosition()
    obj_spawned.setPositionSmooth(playPos + vector(0,8,-6.4))
    obj_spawned.setRotation({0.00, 180.00, 0.00})
    if (myDes == "1") then
      obj_spawned.setName("1st Player Position Token")
    elseif (myDes == "2") then
      obj_spawned.setName("2nd Player Position Token")
    elseif (myDes == "3") then
      obj_spawned.setName("3rd Player Position Token")
    elseif (myDes == "4") then
      obj_spawned.setName("4th Player Position Token")
    end
    obj_spawned.setDescription("")
end

--fountain of souls--
if (myName == "1 Soul Token") then
  local addY = 6
  if (myDes == "soul2") then
    addY = 12
    obj_spawned.setDescription("")
  end
  if (PlayerVal == 4) then
    obj_spawned.setPositionSmooth(subPos + vector(-5.65,addY,3.61))
  elseif (PlayerVal == 3) then
    obj_spawned.setPositionSmooth(subPos + vector(-3.43,addY,2.89))
  elseif (PlayerVal == 1 or PlayerVal == 2) then
    obj_spawned.setPositionSmooth(subPos + vector(-1.22,addY,3.19))
  end
  obj_spawned.setRotation({0, 180, 0})
end

if (myName == "Lantern Token") then
  obj_spawned.setPositionSmooth(subPos + vector(-4.48,7,-3.71))
  obj_spawned.setRotation({0, 180, 0})
end

if (myName == "One Soul Tokens") then
  obj_spawned.setPositionSmooth(subPos + vector(-4,6,7.02))
  obj_spawned.setRotation({0, 0, 0})
end

if (myName == "Three Souls Tokens") then
  obj_spawned.setPositionSmooth(subPos + vector(4,6,7.02))
  obj_spawned.setRotation({0, 0, 0})
end

if (myName == "Soulfire") then
  obj_spawned.setPositionSmooth(mainPos + subDeck)
  obj_spawned.setRotation({0.00, 180.00, 0})
  obj_spawned.setDescription('Soulfire Deck')
  local ac1 = {position = mainPos + vector(-10.69,6,-12.31), rotation = {0,180,0},
  smooth = true}
  local ac2 = {position = mainPos + vector(-4.19,6,-12.31), rotation = {0,180,0},
  smooth = true}
  if (PlayerVal >= 3) then
    obj_spawned.takeObject(ac1)
  end
  if (PlayerVal == 4) then
    obj_spawned.takeObject(ac2)
  end
end

--fortress
if (myName == "Fortress Token") then
  if (PlayerVal == 1 or PlayerVal == 2) then
    obj_spawned.setPositionSmooth(subPos + vector(1.32,7,-3.84))
  elseif (PlayerVal == 3) then
    obj_spawned.setPositionSmooth(subPos + vector(-2.63,7,-3.84))
  elseif (PlayerVal == 4) then
    obj_spawned.setPositionSmooth(subPos + vector(5.61,7,6.37))
  end
  obj_spawned.setRotation({0, 180, 0})
end

--corruption's core

  if (myDes == "VoidWhite") then
    obj_spawned.setPositionSmooth(vector(-35.18, 5.61, -16.76))
    obj_spawned.setDescription("")
  end

    if (myDes == "VoidOrange") then
      if (PlayerVal >= 2) then
      obj_spawned.setPositionSmooth(vector(14.79, 5.61, -16.76))
      obj_spawned.setDescription("")
      --print(obj_spawned.getDescription())
      else
        --print("kill " .. obj_spawned.getDescription())
        obj_spawned.destruct()
    end
  end

    if (myDes == "VoidBlue") then
      if (PlayerVal >= 3) then
      obj_spawned.setPositionSmooth(vector(60.00, 5.61, -16.76))
        obj_spawned.setDescription("")
      --print(obj_spawned.getDescription())
  else
    --print("kill " .. obj_spawned.getDescription())
    obj_spawned.destruct()
  end
end

    if (myDes == "VoidPurple") then
      if (PlayerVal >= 4) then
      obj_spawned.setPositionSmooth(vector(-80.21, 5.61, -16.76))
      obj_spawned.setDescription("")
      --print(obj_spawned.getDescription())
      else
        --print("kill " .. obj_spawned.getDescription())
        obj_spawned.destruct()
    end
  end


if (myName == "Rubble Tokens") then
  obj_spawned.setPositionSmooth(mainPos + vector(-3.2,6,18.13))
  obj_spawned.setRotation({0, 0, 0})
  if (PlayerVal < 4) then
    for i = 1, 3, 1 do
      local offset = -3.6
      if i == 2 then
        offset = 0
      elseif i == 3 then
        offset = 3.6
      end
      local rubbleParams = {position = mainPos + vector(-3.2 + offset,14,9.12), rotation = {0,180,0},
      smooth = true}
      obj_spawned.takeObject(rubbleParams)
    end
  end
end

-- blight lord --

if (myName == "Blight Lord Token") then
  obj_spawned.setPositionSmooth(subPos + vector(-3.65,8,5.4))
  obj_spawned.setRotation({0, 180, 0})
end

if (myName == "Tainted Jade Deck") then
  obj_spawned.setPositionSmooth(mainPos + subDeck)
  obj_spawned.setRotation({0.00, 180.00, 0})
  local jadeParams = {position = mainPos + subDeck + vector(8.35,0,0), rotation = {0,180,180},
  smooth = true}
  local remNum = 4 - (PlayerVal)

  if (remNum > 0) then
    for i = 1, remNum,1 do
    obj_spawned.takeObject(jadeParams)
    end
  end
end

--xaxos --
if (myName == "Xaxos Spells") then
  local myNum = 5
  if myDes == 4 then
    myNum = 10
  end
  obj_spawned.setPositionSmooth(subPos + vector(5.67, 3 + myNum,-2.88))
  obj_spawned.setRotation({0.00, 180.00, 180})
  obj_spawned.shuffle()
  obj_spawned.setName("Concentration Deck")
  obj_spawned.setDescription("")

  if (myDes == "3") then
    xaxosMove(obj_spawned)
  end
end

-- aracnos --
if (myName == "Arachnos Token") then
  obj_spawned.setPositionSmooth(subPos + vector(-7.03,9,3.27))
  obj_spawned.setRotation({0, 180, 0})
end

-- bone --
if (myName == "Spell Bone Token") then
  obj_spawned.setPositionSmooth(subPos + vector(-6.18,12,0.3))
  obj_spawned.setRotation({0, 180, 0})
end

if (myName == "Gem/Relic Bone Token") then
  obj_spawned.setPositionSmooth(subPos + vector(-6.18,9,0.3))
  obj_spawned.setRotation({0, 180, 0})
end

-- wayward one --
if (myName == "Wayward One Token") then
  obj_spawned.setPositionSmooth(subPos + vector(-7.05,9,1.91))
  obj_spawned.setRotation({0, 180, 0})
end

--wailing or endless decay--
if (myName == "Shatter") or (myName == "Deteriorate") then
  if (myDes == tostring(PlayerVal)) then
    obj_spawned.setPositionSmooth(mainPos + vector(-17.19,6,-12.31))
    obj_spawned.setRotation({0.00, 180.00, 0.00})
    obj_spawned.setDescription(tostring(PlayerVal) .. " version")
  else
    --obj_spawned.setPositionSmooth(mainPos + subDeck + vector(8.35,0,0))
    obj_spawned.setPositionSmooth(vector(22.61, 2.42, 4.58) + vector(0,tonumber(obj_spawned.getDescription()),0))
    obj_spawned.setRotation({0.00, 180.00, 180.00})
  end
end

if (myName == "Target Token") then
  local playerBoard = getObjectFromGUID(playerBoardGUID[1])
  local playerPos = playerBoard.getPosition()
  obj_spawned.setPositionSmooth(playerPos + vector(0,12,-1.91))
  obj_spawned.setRotation({0, 180, 0})
end

if (myName == "Shatter Power") then
  obj_spawned.setPositionSmooth(mainPos + vector(-17.19,8,-10.11))
  obj_spawned.setRotation({0.00, 180, 0.00})
  if (PlayerVal == 4) then
    obj_spawned.setDescription("11")
    obj_spawned.call('startVal',13)
  elseif (PlayerVal == 2) then
    obj_spawned.setDescription("6")
    obj_spawned.call('startVal',8)
  elseif (PlayerVal == 3) then
    obj_spawned.setDescription("8")
    obj_spawned.call('startVal',10)
  elseif (PlayerVal == 1) then
    obj_spawned.setDescription("5")
    obj_spawned.call('startVal',6)
  end
end

if (myName == "Deteriorate Power") then
  obj_spawned.setPositionSmooth(mainPos + vector(-17.19,8,-10.11))
  obj_spawned.setRotation({0.00, 180, 0.00})
  if (PlayerVal == 4) then
    obj_spawned.setDescription("7")
    obj_spawned.call('startVal',10)
  elseif (PlayerVal == 3) then
    obj_spawned.setDescription("6")
    obj_spawned.call('startVal',8)
  elseif (PlayerVal == 2) then
    obj_spawned.setDescription("4")
    obj_spawned.call('startVal',6)
  elseif (PlayerVal == 1) then
    obj_spawned.setDescription("3")
    obj_spawned.call('startVal',4)
  end
end

--deathmind--
if (myName == "Sever Link Power") then
  obj_spawned.setPositionSmooth({-17.19, 1.76, -0.49})
  obj_spawned.setRotation({0.00, 180, 0.00})
end
-- wanderer / changeling nest
if (myDes == "P1") or (myName == "(Yellow)") then
  local cX = 0
  if (myName == "(Yellow)") then
    cX = 180
  end
  obj_spawned.setPositionSmooth(subPos + vector(-3.41,6,5.41))
  obj_spawned.setRotation({0, 180, cX})
  obj_spawned.setDescription('')
end
if (myDes == "P2") or (myName == "(Green)") then
  local cX = 0
  if (myName == "(Green)") then
    cX = 180
  end
  obj_spawned.setPositionSmooth(subPos + vector(3.41,6,5.41))
  obj_spawned.setRotation({0, 180, cX})
  obj_spawned.setDescription('')
end
if (myDes == "P3") or (myName == "(Blue)") then
  local cX = 0
  if (myName == "(Blue)") then
    cX = 180
  end
  local addV = vector(0,0,0)
  if (myName == "(Blue)") then
    addV = vector(3.41,0,0)
  end
  obj_spawned.setPositionSmooth(subPos + vector(-3.41,6,-5.41) + addV)
  obj_spawned.setRotation({0, 180, cX})
  obj_spawned.setDescription('')
end
if (myDes == "P4") then
  obj_spawned.setPositionSmooth(subPos + vector(3.41,6,-5.41))
  obj_spawned.setRotation({0, 180, 0})
  obj_spawned.setDescription('')
end

if (myName == "Pylon Health 1") or (myGMS == "Cocoon1") then
  local vxc = vector(0,0,0)
  if (myGMS == "Cocoon1") then
    vxc = vector(-1.76,0,0)
  end
  obj_spawned.setPositionSmooth(subPos + vector(-3.41,6,5.41) + vector(-0.06,5,2.08) + vxc)
  obj_spawned.setRotation({0, 180, 0})
end
if (myName == "Pylon Health 2") or (myGMS == "Cocoon2") then
  local vxc = vector(0,0,0)
  if (myGMS == "Cocoon2") then
    vxc = vector(-1.76,0,0)
  end
  obj_spawned.setPositionSmooth(subPos + vector(3.41,6,5.41) + vector(-0.06,5,2.08) + vxc)
  obj_spawned.setRotation({0, 180, 0})
end
if (myName == "Pylon Health 3") or (myGMS == "Cocoon3") then
  local addV = vector(0,0,0)
  if (myGMS == "Cocoon3") then
    addV = vector(1.705,0,0)
  end
  obj_spawned.setPositionSmooth(subPos + vector(-3.41,6,-5.41) + vector(-0.06,5,2.08) + addV)
  obj_spawned.setRotation({0, 180, 0})
end
if (myName == "Pylon Health 4") then
  obj_spawned.setPositionSmooth(subPos + vector(3.41,6,-5.41) + vector(-0.06,5,2.08))
  obj_spawned.setRotation({0, 180, 0})
end

--knight of shackles --
if (myName == "Knight of Shackles Breach I") then
  obj_spawned.setPositionSmooth(subPos + vector(-5.79,6,3.74))
  obj_spawned.setRotation({0, 180, 180})
end

if (myName == "Knight of Shackles Breach II") then
  obj_spawned.setPositionSmooth(subPos + vector(2.89,6,3.74))
  obj_spawned.setRotation({0, 180, 180})
end

if (myName == "Knight of Shackles Breach III") then
  obj_spawned.setPositionSmooth(subPos + vector(-1.96,6,-3.33))
  obj_spawned.setRotation({0, 180, 180})
end

if (myName == "Knight of Shackles Breach IV") then
  obj_spawned.setPositionSmooth(subPos + vector(6.24,6,-3.33))
  obj_spawned.setRotation({0, 180, 180})
end

if (myName == "Z'hana Commander Cards" or myName == "Brama Commander Cards") then
  obj_spawned.setPositionSmooth(subPos + vector(0,9,0))
  obj_spawned.setDescription("wip - spread these to each space")
end

--maggoth --
if (myName == "Maggot/Fly Tokens") or (myDes == "SubBag2") then
  obj_spawned.setPositionSmooth(subPos + vector(-1.2,6,7))
  obj_spawned.setRotation({0, 0, 0})
end
if (myDes == "Maggoth1") then
  obj_spawned.setPositionSmooth(subPos + vector(-5.21,8,-7.42))
  obj_spawned.setRotation({0, 180, 0})
  obj_spawned.setDescription('')
end
if (myDes == "Maggoth2") then
  obj_spawned.setPositionSmooth(subPos + vector(-2.66,8,-7.42))
  obj_spawned.setRotation({0, 180, 0})
  obj_spawned.setDescription('')
end

--carapace queen--
if (myDes == "Husk1") then
  obj_spawned.setPositionSmooth(subPos + vector(-2.27,8,4.05))
  obj_spawned.setRotation({0, 180, 0})
  obj_spawned.setDescription('1 Life')
end
if (myDes == "Husk2") then
  obj_spawned.setPositionSmooth(subPos + vector(0.44,8,4.05))
  obj_spawned.setRotation({0, 180, 0})
  obj_spawned.setDescription('1 Life')
end

-- spawning horror --

if (myName == "Breeding Chamber Health") then
  obj_spawned.setPositionSmooth(mainPos + vector(-17.19,8,-10.31))
  obj_spawned.setRotation({0.00, 180, 0.00})
  if (PlayerVal == 4) then
    obj_spawned.setDescription("1")
    obj_spawned.call('setVal')
  end
end

--experiment 153 specialised
if (myName == "Maw Token 1") then
  obj_spawned.setPositionSmooth(subPos + vector(-0.86,6,-4.71))
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myName == "Maw Token 2") then
  obj_spawned.setPositionSmooth(subPos + vector(0.99,6,-5.7))
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myName == "Maw Token 3") then
  obj_spawned.setPositionSmooth(subPos + vector(2.9,6,-5.7))
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myName == "Maw Token 4") then
  obj_spawned.setPositionSmooth(subPos + vector(4.78,6,-4.71))
  obj_spawned.setRotation({0.00, 180.00, 0})
end

if (myName == "Maw Health 1") then
  obj_spawned.setPositionSmooth(subPos + vector(-10.54,4,-3.94))
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myName == "Maw Health 2") then
  obj_spawned.setPositionSmooth(subPos + vector(-7.92,4,-3.94))
  obj_spawned.setRotation({0.00, 180.00, 0})
end

if (myName == "Maw Health 3") then
  obj_spawned.setPositionSmooth(subPos + vector(7.92,4,-3.94))
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myName == "Maw Health 4") then
  obj_spawned.setPositionSmooth(subPos + vector(10.54,4,-3.94))
  obj_spawned.setRotation({0.00, 180.00, 0})
end

--that city boss i cant spell
if (myName == "Mega Breach") then

    obj_spawned.setPositionSmooth(subPos + vector(-16,7,0))
    obj_spawned.setRotation({0.00, 240.0, 0.00})
  end
if (myName == "Mega Breach Controls") then
  obj_spawned.setPositionSmooth(subPos + vector(-20,4,0))
  obj_spawned.setRotation({0,180.00,0})
  obj_spawned.setVar("count", 7)
end


if (myName == "City Token") then
  obj_spawned.setPositionSmooth(subPos + vector(-5.4,5,4.36))
  obj_spawned.setRotation({0.00,180.00,0})
end

if (myName == "[EEAFFF]Damage Track Token[-]") then
  if (PlayerVal < 3) then
  obj_spawned.setPositionSmooth(subPos + vector(-6.47,5,-2.42))
  else
    obj_spawned.setPositionSmooth(subPos + vector(-5.51,5,-5.1))
  end
  obj_spawned.setRotation({0.00,180.00,0})
end

-- burrowerer

if (myName == "Burrower Traps") then
  obj_spawned.shuffle()
  obj_spawned.setPositionSmooth(mainPos + subDeck)
  obj_spawned.setRotation({0.00, 180.00, 180.00})
  for i = 1, 9, 1 do
    local myDeck = findDecksInZone(getObjectFromGUID(shop_table[i]))
    print("Found Deck: " .. tostring(myDeck.getGUID()) .. " - Contains  " .. tostring(myDeck.getQuantity()))
    IncreaseBurrower = 2
    CurrentSetting = i
    local quant = myDeck.getQuantity() + 4
      if (quant == 9) then
        quant = 8
      end
    for j = 0, quant , 1 do
      if (j % 3 == 0) then
        trapParam = {position = shop_vector[i] + vector(0,IncreaseBurrower,0), rotation = {0,180,0}}
        obj_spawned.takeObject(trapParam)
        IncreaseBurrower = IncreaseBurrower + 3
      elseif (j % 3 == 1 or j % 3 == 2) then
        trapParam = {position = shop_vector[i] + vector(0,IncreaseBurrower,-0), rotation = {0,180,0}}
        myDeck.takeObject(trapParam)
        IncreaseBurrower = IncreaseBurrower + 3
      end
    end
  end
end

--Absorbing Wraith--
if (myName == "Freeze Token") then
  obj_spawned.setPositionSmooth({-7.88, 3, 36.42})
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myName == "[FFD700]Aether Tokens[-] [i]") then
  obj_spawned.setPositionSmooth({-25.70, 2, 20.91})
  obj_spawned.setRotation({0.00, 180.00, 0})
end
--The Reliquary
if (myName == "Obsession Deck") then
  obj_spawned.setPositionSmooth({-34.82, 1.78, 8.87})
  obj_spawned.setRotation({0.00, 180.00, 180})
  obj_spawned.shuffle()
  local pos1 = {-17.19, 1.72, 6.06}
  local pos2 = {-10.69, 1.71, 6.06}
  local rot = {0,180,0}
  obj_spawned.takeObject({position = pos1, rotation = rot, smooth = false})
  obj_spawned.takeObject({position = pos2, rotation = rot, smooth = false})
  Wait.time(function()
    local increment = PlayerVal * 2
    for _, guid in ipairs({"5026e7", "04f1f6"}) do
      local zone = getObjectFromGUID(guid)
      local counter_table = zone.getObjects()
      for i, object in ipairs(counter_table)do
          if object.getName() == "Power Counter" then
            for i = 1, increment do
                object.call("IncVal")  -- 调用计数器的增加函数
            end
          end
      end
    end
  end, 0.5)
end
if (myDes == "Tainted Halo Deck") then
  obj_spawned.setPositionSmooth({15.31, 1.73, 6.06})
  obj_spawned.setRotation({0.00, 180.00, 0})
end
--The Wrath--
if (myDes == "the Wrath Track(normal difficulty)") then
  obj_spawned.setPositionSmooth({-34.82, 2, 8.86})
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myDes == "the Wrath Track(increased difficulty)") then
  obj_spawned.setPositionSmooth({-65.04, 1.67, 8.65})
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myName == "Strike Token") then
  obj_spawned.setPositionSmooth({-44.96, 3, 11.77})
  obj_spawned.setRotation({0.00, 180.00, 0})
end
--The Coven--
if (myName == "Matron of Malice") then
  obj_spawned.setPositionSmooth({-45.19, 3.68, 5.41})
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myName == "Daughter of Doom") then
  obj_spawned.setPositionSmooth({-32.19, 3.66, 5.41})
  obj_spawned.setRotation({0.00, 180.00, 0})
end
if (myName == "the Coven Board") then
  obj_spawned.setPositionSmooth({-35.48, 1.73, 5.42})
  obj_spawned.setRotation({0.00, 180.00, 0})
  obj_spawned.setLock(true)
end
if (myName == "Barrier Tokens") then
  obj_spawned.setPositionSmooth({-35.49, 1.72, 14.13})
  obj_spawned.setRotation({0.08, 90.00, 359.98})
  obj_spawned.setLock(true)
end
if (myName == "Barrier Counters") then
  obj_spawned.setPositionSmooth({-31.49, 1.72, 14.13})
  obj_spawned.setRotation({0.08, 90.00, 359.98})
  obj_spawned.setLock(true)
end
--Absorbing Wraith--
if myName == "Aether Counter 1" then
  obj_spawned.setPositionSmooth({-40.94, 4,18.57})
  Wait.time(function()
      obj_spawned.setLock(true)
  end, 2)
end
if myName == "Aether Counter 2" then
  obj_spawned.setPositionSmooth({-34.90, 4, 18.57})
  Wait.time(function()
      obj_spawned.setLock(true)
  end, 2)
end
if myName == "Aether Counter 3" then
  obj_spawned.setPositionSmooth({-28.86, 4, 18.57})
  Wait.time(function()
      obj_spawned.setLock(true)
  end, 2)
end
if myName == "Aether Counter 4" then
  obj_spawned.setPositionSmooth({-40.94, 4, 7.52})
  Wait.time(function()
      obj_spawned.setLock(true)
  end, 2)
end
if myName == "Aether Counter 5" then
  obj_spawned.setPositionSmooth({-34.90, 4, 7.52})
  Wait.time(function()
      obj_spawned.setLock(true)
  end, 2)
end
if myName == "Aether Counter 6" then
  obj_spawned.setPositionSmooth({-28.86, 4, 7.52})
  Wait.time(function()
      obj_spawned.setLock(true)
  end, 2)
end

if (myName == "1-player MM") then
  if (PlayerVal == 1) then
    obj_spawned.setPositionSmooth({-38.69, 3.69, 5.40})
    obj_spawned.setRotation({0.00, 180.00, 0})
  else
    obj_spawned.setPositionSmooth( {22.61,3, 4.58}) --destroyed
  end
end
if (myName == "1-player DD") then
  if (PlayerVal == 1) then
    obj_spawned.setPositionSmooth({-25.69, 3.67, 5.41})
    obj_spawned.setRotation({0.00, 180.00, 0})
  else
    obj_spawned.setPositionSmooth( {22.61,3, 4.58}) --destroyed
  end
end

if (myName == "2-player MM") then
  if (PlayerVal == 2) then
    obj_spawned.setPositionSmooth({-38.69, 3.69, 5.40})
    obj_spawned.setRotation({0.00, 180.00, 0})
  else
    obj_spawned.setPositionSmooth({22.61,3, 4.58}) --destroyed
 end
 end
if (myName == "2-player DD") then
  if (PlayerVal == 2) then
    obj_spawned.setPositionSmooth({-25.69, 3.67, 5.41})
    obj_spawned.setRotation({0.00, 180.00, 0})
  else
    obj_spawned.setPositionSmooth( {22.61,3, 4.58}) --destroyed
  end
end

if (myName == "3-player MM") then
  if (PlayerVal == 3) then
    obj_spawned.setPositionSmooth({-38.69, 3.69, 5.40})
    obj_spawned.setRotation({0.00, 180.00, 0})
  else
    obj_spawned.setPositionSmooth( {22.61,3, 4.58}) --destroyed
 end
 end
if (myName == "3-player DD") then
  if (PlayerVal == 3) then
    obj_spawned.setPositionSmooth({-25.69, 3.67, 5.41})
    obj_spawned.setRotation({0.00, 180.00, 0})
  else
    obj_spawned.setPositionSmooth( {22.61,3, 4.58}) --destroyed
  end
end

if (myName == "4-player MM") then
  if (PlayerVal == 4) then
    obj_spawned.setPositionSmooth({-38.69, 3.69, 5.40})
    obj_spawned.setRotation({0.00, 180.00, 0})
  else
    obj_spawned.setPositionSmooth( {22.61,3, 4.58}) --destroyed
 end
 end
if (myName == "4-player DD") then
  if (PlayerVal == 4) then
    obj_spawned.setPositionSmooth({-25.69, 3.67, 5.41})
    obj_spawned.setRotation({0.00, 180.00, 0})
  else
    obj_spawned.setPositionSmooth( {22.61,3, 4.58}) --destroyed
  end
end
if (myName == "MM Life") then
  obj_spawned.setPositionSmooth({-45.24, 5, 8.13})
  obj_spawned.setRotation({0.08, 180.00, 0})
end
if (myName == "DD Life") then
  obj_spawned.setPositionSmooth({-32.24, 5, 8.22})
  obj_spawned.setRotation({0.08, 180.00, 0})
end
if (myName == "Barrier Counter 1") then
  obj_spawned.setPositionSmooth({-38.85, 3, 10.41})
  obj_spawned.setRotation({359.31, 179.99, 0.00})
end
if (myName == "Barrier Counter 2") then
  obj_spawned.setPositionSmooth({-25.65, 3, 10.23})
  obj_spawned.setRotation({359.30, 179.97, 0.00})
end
if (myName == "Power Counter 1") then
  obj_spawned.setPositionSmooth({-38.76, 3, -0.35})
  obj_spawned.setRotation({0.71, 180.03, 0.00})
end
if (myName == "Power Counter 2") then
  obj_spawned.setPositionSmooth({-25.64, 3, -0.32})
  obj_spawned.setRotation({0.71, 180.03, 0.00})
end

function Burrower(offset,sV)
    return {position = shop_vector[sV] + vector(0,offset,0), rotation = {0,180,0}}
end

end
