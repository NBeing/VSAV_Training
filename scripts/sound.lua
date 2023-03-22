local soundModule = {
    ["registerBefore"] = function()
       if globals.options.bgm_on then
        memory.writebyte_audio(0xF026,0xFF)
        memory.writebyte_audio(0xF027,0xFF)
       else
        memory.writebyte_audio(0xF026,0x0)
        memory.writebyte_audio(0xF027,0x0)
       end
    end
}
return soundModule