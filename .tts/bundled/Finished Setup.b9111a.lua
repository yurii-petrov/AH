nemesisDone = false
marketDone = false
nemScript =''
devZone = '22b514'
swapZone = '76dca9'
xaxos = false
friend = false
foe = false
playerval = 2


function lock()
  if (nemesisDone == false and marketDone == false) then
    broadcastToAll('Setup Nemesis and Lock Market first!', {r=1,b=0.1,g=0.1})
  elseif nemesisDone == true and marketDone == false then
    broadcastToAll('Lock Market first!', {r=1,b=0.1,g=0.1})
  elseif
    nemesisDone == false and marketDone == true then
    broadcastToAll('Setup Nemesis first!', {r=1,b=0.1,g=0.1})
  else
    getObjectFromGUID('877410').setValue(' ') --text "Nemesis Randomizer Setup"
    getObjectFromGUID('25e037').setValue(' ') --text "Nemesis Randomiser Cards (Split by Tiers)"
    getObjectFromGUID('5d28b0').setValue(' ') --text "Nemesis Scripted Setup"
    getObjectFromGUID('31bbf0').setValue(' ') --text "Banner Cards"
    getObjectFromGUID('fd786a').setValue(' ') --text "Barracks"
    getObjectFromGUID('c3ad8a').setValue(' ') --text "Stroe relevant cards here, ..."
    getObjectFromGUID('36cb77').setValue(' ') --text "Market Randomiser Script"


    local dv = getObjectFromGUID(devZone)
    local sv = getObjectFromGUID(swapZone)
    dv.setPosition(dv.getPosition() + vector(0,1.53,0))
    sv.setPosition(sv.getPosition() + vector(0,1.53,0))
    -- dv.setScale({4,2,4})
    -- sv.setScale({4,2,4})
    for i,obj in pairs(getAllObjects()) do
      if obj.hasTag('setup') then
        destroyObject(obj)
      end
      if xaxos == false and obj.hasTag('xaxs') then
        destroyObject(obj)
      end
      if friend == false and obj.hasTag('friend') then
        destroyObject(obj)
      end
      if foe == false and obj.hasTag('foe') then
        destroyObject(obj)
      end
      if playerval == 3 and obj.hasTag('player4 mat') then
        destroyObject(obj)
      end
      if playerval == 2 then
        if obj.hasTag('player4 mat') then
          destroyObject(obj)
        end
        if obj.hasTag('player3 mat') then
          destroyObject(obj)
        end
      end
      if playerval == 1 then
        if obj.hasTag('player4 mat') then
          destroyObject(obj)
        end
        if obj.hasTag('player3 mat') then
          destroyObject(obj)
        end
        if obj.hasTag('player2 mat') then
          destroyObject(obj)
        end
      end
    end
    if xaxos == false then
      getObjectFromGUID('422303').setState(1)
    end
  end
end



function onLoad()
  local param = {
  click_function = "lock",
  function_owner = self,
  label = "Clear\nSetup",
  position = {0, 0.5, 0},
  rotation = {0, 0, 0},
  scale = {2,2,2},
  width = 200 * 3,
  height = 40,
  color = {r = 0, g = 1, b = 1},
  font_size = 70,
  tooltip = 'Once Nemesis & Market is setup, click this to clear away scripting setup elements.\nRandomizer decks stay and can still be used.'
  }

  self.createButton(param)

end