local addr={count=0xFF8109,frame=0xFF810A,}
local full=109 --set timer speed to slow
local old,new={},{}

old.count=memory.readbyte(addr.count)
old.frame=memory.readbyte(addr.frame)
old.skip=old.frame

frameskipHandlerModule = {
    ["registerBefore"] = function()
        -- print(emu.framecount())
        local isSkipFrame = false

        new.count=memory.readbyte(addr.count)
		new.frame=memory.readbyte(addr.frame)

        --don't lose count when the frame count resets
        if old.count>new.count then
            old.frame=old.frame+full
            old.skip=old.skip+full
        else 
            globals.skip_frame = false

        end

        local diff=old.frame-new.frame
        -- emu.message(diff)

        if diff>1 then
            new.skip=new.frame
            -- print("skip here?")
            isSkipFrame = true
            globals.skip_frame = true
            --subtract 1 because of the lost frame
            -- print(old.skip-new.skip-1)
            old.skip=new.skip
        elseif diff<0 then
            -- print("error: diff =",diff)
        end

        old.count=new.count
        old.frame=new.frame

        return isSkipFrame
    end
}

return frameskipHandlerModule