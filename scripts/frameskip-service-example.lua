-- An example of how to use frameskip-serivce.lua
-- 
-- Feel free to remove this file from the codebase if it becomes useless

-- So you want to subscribe to data from the frameskip service? You've come to
-- the right place. The frameskip service uses
-- [RxLua](https://github.com/bjornbytes/RxLua) to handle updating consumers
-- when new events happen

-- Let's say you want to know the value of the frameskip pattern when it is
-- accessed in game code. Simple enough:
local frameskip_observable = globals.frameskipService.get_frameskip_pattern()
  :subscribe(function(data)
    print(data)
  end)
-- If you run this code, you will notice you are getting the frameskip pattern
-- every single frame. If you only want output when it changes, simply invoke
-- {Observable:distinctUntilChanged} before subscribing, like so:
frameskip_observable = globals.frameskipService.get_frameskip_pattern()
  :distinctUntilChanged() -- will only fire the subscription callback on change
  :subscribe(function(data)
    print(data)
  end)
-- Now you'll only receive the frameskip pattern when it changes, i.e.: only
-- when the game speed changes

-- Let's say you only want distinct values and also to only update while in
-- battle, even though the frameskip logic doesn't run while out of battle.
-- That's easy enough, too; just invoke {Observable:skipWhile}:
frameskip_observable = globals.frameskipService.get_framskip_pattern()
  :distinctUntilChanged()
  -- skip values while we're not in battle
  :skipWhile(function() return not globals.game_state.match_begun end)
  :subscribe(function(data)
    print(data)
  end)

-- Let's say you want to know if the next frame will be skipped (DOES NOT WORK
-- TODAY, but for the sake of example), but don't really care when it won't be.
-- You want to filter the values of the get_next_frame_skipped observable:
frameskip_observable = globals.frameskipService.get_next_frame_skipped()
  -- only emits if value is `true`
  :filter(function(frameSkipped) return frameSkipped == true end)
  :subscribe(function(frameSkipped)
    print(frameSkipped)
  end)

-- There are many other things you can do with observable data streams,
-- including matching and mapping and reducing and all kinds of things. See
-- ./scripts/rx-lua/rx.lua or the RxLua documentation for more details