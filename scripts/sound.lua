local soundModule = {
    ["registerBefore"] = function()
       if globals.options.bgm_on then
        memory.writebyte_audio(0xF026,0xF)
        memory.writebyte_audio(0xF027,0xF)
       else
        memory.writebyte_audio(0xF026,0x0)
        memory.writebyte_audio(0xF027,0x0)
       end
    end
}
return soundModule