nemBoard = 'd3fa17'

function onLoad()
  self.setLock(true)
  params = {
       click_function = "onR",
       function_owner = self,
       label          = "Auto Remove\nTokens\n(ON)",
       position       = {0, 0.125, 0},
       rotation       = {0, 0, 0},
       width          = 2200,
       height         = 900,
       font_size      = 260,
       color          = {0, 0.5, 0},
       font_color     = {1, 1, 1},
       tooltip        = "Automatically remove tokens from cards that get placed in Discard?",
   }
   self.createButton(params)
end

function onR()
  getObjectFromGUID(nemBoard).setVar('removeTokens',false)
  params = {index = 0, click_function = "offR", label = "Auto Remove\nTokens\n(OFF)",
  color = {0.5,0,0.5}
}
  self.editButton(params)
end

function offR()
  getObjectFromGUID(nemBoard).setVar('removeTokens',true)
  params = {index = 0, click_function = "onR", label = "Auto Remove\nTokens\n(ON)",
  color = {0, 0.5, 0}
}
  self.editButton(params)
end