function createTextBox()
    local _o = {}
    box = {
        ["name"] = "text box",
        ["selected"] = true,
        ["index"] = 0,
        ["options"] = {}
    }
    return box
end

menuModule = {
    ["guiRegister"] = function()

        text_default_color = 0xF7FFF7FF
		text_default_border_color = 0x101008FF
		text_selected_color = 0xFF0000FF
        text_disabled_color = 0x999999FF
        
        local index = 0
        x = createTextBox()
        if globals.show_menu == true then
            gui.box(0, 0, 100, 50, text_default_color, text_default_border_color)
            gui.text(10, 10, "hello menu", text_default_color, text_default_border_color)
        else 
            gui.box(0,0,0,0,0,0) 
        end        
    end
}

return menuModule