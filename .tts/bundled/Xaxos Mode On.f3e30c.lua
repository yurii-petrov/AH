nemBoard = 'b9111a'

function onLoad()
  self.setLock(true)
  params = {
       click_function = "offR",
       function_owner = self,
       label          = "Xaxos\nOutcast\n[b](OFF)[/b]",
       position       = {0, 0.125, 0},
       rotation       = {0, 0, 0},
       width          = 2200,
       height         = 900,
       font_size      = 260,
       color          = {0.5,0,0.1},
       font_color     = {1, 1, 1},
       tooltip        = "If OFF, then Xaxos and his board will be removed when finalisaing game setup above.",
   }
   self.createButton(params)
   self.setColorTint({r = 1, g = 0.6, b = 0.8})
end

function onR()
  getObjectFromGUID(nemBoard).setVar('xaxos',false)
  params = {index = 0, click_function = "offR", label = "Xaxos\nOutcast\n[b](OFF)[/b]",
  color = {0.5,0,0.1}
}
  self.editButton(params)

end

function offR()
  getObjectFromGUID(nemBoard).setVar('xaxos',true)
  params = {index = 0, click_function = "onR", label = "Xaxos\nOutcast\n[b](ON)[/b]",
  color = {0, 0.5, 0}
}
  self.editButton(params)
end