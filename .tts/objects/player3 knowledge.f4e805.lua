val = 0

function onSave()
    local tableToSave = {};

    if val then

            tableToSave['val'] = val

    end



    saved_data = JSON.encode(tableToSave)
    return saved_data
end

function onload(saved_data)


    if saved_data != nil then
        loaded_data = JSON.decode(saved_data)
        if loaded_data != nil then
            val = loaded_data['val']
        else
            val = 0
        end
    else
        val = 0
    end


    buttonParameters =
    {
        Val =
        {
            index = 0,
            label = tostring(val),
            click_function = 'setVal',
            function_owner = self,

            -- Designer stuff
        position = {0,0.2,0}, width = 700, height = 700, font_size = 700, color = {1,1,1}, font_color = {191/255,144/255,0}

        },

        Inc =
        {
            label = '+',
            click_function = 'IncVal',
            function_owner = self,

            -- Designer stuff
            position = {1.5,0.2,0},
            width = 500,
            height = 500,
            font_size = 500
        },
        Dec =
        {
            label = '-', --Text to display
            click_function = 'DecVal',
            function_owner = self,

            -- Designer stuff
            position = {-1.5,0.2,0},
            width = 500,
            height = 500,
            font_size = 500
        }
    }

    for i, v in pairs(buttonParameters) do
        self.createButton(v)
    end
end

function setVal()
  val = 0


  -- update the charge 'button' label.
  buttonParameters.Val.label = val
  self.editButton(buttonParameters.Val)
end

function IncVal()
    val = val+1


    -- update the charge 'button' label.
    buttonParameters.Val.label = val
    self.editButton(buttonParameters.Val)
end

function DecVal()
  if (val > 0) then
    val = val-1
  end


    -- update the charge 'button' label.
    buttonParameters.Val.label = val
    self.editButton(buttonParameters.Val)
end