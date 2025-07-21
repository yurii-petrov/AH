cube_GUID = '9872e1'
cube = {}
locat_GUID = '64c906'
locat = {}
me_GUID = '909b83'
me = {}
params = {}
zone_GUID = ''
discard_zone = getObjectFromGUID('aa8a91')
function rotateBreach()

    -- print error message and abort function if the bag somehow doesn't have any objects in it

    local zoneObjects = getObjectFromGUID(zone_GUID).getObjects()
    for k, obj in pairs(zoneObjects) do
      if obj.tag == "Generic" then
        local vR = obj.getRotation()
        obj.setRotationSmooth(vR + {x=0, y=90, z=0},true, false)
      end
      if (obj.tag == "Deck" or obj.tag == "Card") then
        local vP = obj.getPosition()
        obj.setPositionSmooth(vP + {x=0, y=2.33, z=0},false, true)
      end
  end
end


function flipOver()

      -- print error message and abort function if the bag somehow doesn't have any objects in it

      local zoneObjects = getObjectFromGUID(zone_GUID).getObjects()
      for k, obj in pairs(zoneObjects) do
        if obj.tag == "Generic" then
          obj.flip()
          obj.setRotationSmooth({x=0, y=180, z=0},true, false)
        end
        if (obj.tag == "Deck" or obj.tag == "Card") then
          local vP = obj.getPosition()
          obj.setPositionSmooth(vP + {x=0, y=4.33, z=0},false, true)
        end
    end
  end

  function castSpell()
      local zoneObjects = getObjectFromGUID(zone_GUID).getObjects()
      for k, obj in pairs(zoneObjects) do
        if (obj.type == "Card" and obj.hasTag('spellCard')) or (obj.type == "Card" and obj.getRotation().z > 179) then
          obj.setPositionSmooth(discard_zone.getPosition()+ vector(0,1,0), false, true)
          obj.setRotation({0,180,0})
        end
      end
  end


function onLoad()
cube = getObjectFromGUID(cube_GUID)
locat = getObjectFromGUID(locat_GUID)
me = getObjectFromGUID(self.guid)
zone_GUID = me.getDescription()



buttonParameters = {
  Open =
  {
    click_function = 'flipOver',
    function_owner = self,
    label = 'Open',
    position = {-0.3, 0.1, 0.5},
    rotation = {0, 0, 0},
    scale = {0.5,0.5,0.5},
    width = 550,
    height = 280,
    font_size = 130},
  Focus =
  {
    click_function = 'rotateBreach',
    function_owner = self,
    label = 'Focus',
    position = {0.3, 0.1, 0.5},
    scale = {0.5,0.5,0.5},
    width = 550,
    height = 280,
    font_size = 130
  },
  Cast =
  {
    click_function = 'castSpell',
    function_owner = self,
    label = 'Cast',
    position = {0, 0.1, 0.8},
    rotation = {0, 0, 0},
    scale = {0.5,0.5,0.5},
    width = 1100,
    height = 280,
    font_size = 130
  }
}
  self.createButton(buttonParameters.Open)
  self.createButton(buttonParameters.Focus)
  self.createButton(buttonParameters.Cast)

end