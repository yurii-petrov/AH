clear_setup = 'b9111a'
function onLoad()
  self.setLock(true)
  params = {
       click_function = "offR",
       function_owner = self,
       label          = "Foe[b](OFF)[/b]",
       position       = {0, 0.125, 0},
       rotation       = {0, 0, 0},
       width          = 2200,
       height         = 900,
       font_size      = 260,
       color          = {0.5,0,0.1},
       font_color     = {1, 1, 1},
       tooltip        = "If OFF, then Foe board will be removed when finalisaing game setup above.",
   }
   self.createButton(params)
end

function onR()
  getObjectFromGUID(clear_setup).setVar('foe',false)
  params = {index = 0, click_function = "offR", label = "Foe[b](OFF)[/b]",
  color = {0.5,0,0.1}
}
  self.editButton(params)

end

function offR()
  getObjectFromGUID(clear_setup).setVar('foe',true)
  params = {index = 0, click_function = "onR", label = "Foe\n[b](ON)[/b]",
  color = {0, 0.5, 0}
}
  self.editButton(params)
end