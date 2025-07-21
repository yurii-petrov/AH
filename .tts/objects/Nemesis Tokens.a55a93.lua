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
            tooltip = "Click here to set value to the decription.",

            -- Designer stuff
        position = {0,0.1,0}, width = 800, height = 800, font_size = 1000, color = {1,1,1,0}, font_color = {1,1,1,255}



        },

        Inc =
        {
            label = '+',
            click_function = 'IncVal',
            function_owner = self,

            -- Designer stuff
            position = {1.3,0.1,0},
            width = 400,
            height = 400,
            font_size = 400
        },
        Dec =
        {
            label = '-', --Text to display
            click_function = 'DecVal',
            function_owner = self,

            -- Designer stuff
            position = {-1.3,0.1,0},
            width = 400,
            height = 400,
            font_size = 400
        }
    }

    for i, v in pairs(buttonParameters) do
        self.createButton(v)
    end
end

function setVal()
    val = tonumber(self.getDescription())


    -- update the attack 'button' label.
    buttonParameters.Val.label = val
    self.editButton(buttonParameters.Val)
end
function setValue(value)
    buttonParameters.Val.label = value
    val = value
    self.editButton(buttonParameters.Val)
end
function IncVal()
    val =val+1


    -- update the attack 'button' label.
    buttonParameters.Val.label = val
    self.editButton(buttonParameters.Val)
end

function DecVal()
    val =val-1


    -- update the attack 'button' label.
    buttonParameters.Val.label = val
    self.editButton(buttonParameters.Val)
end