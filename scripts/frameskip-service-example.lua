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

-- Let's say you want to know if the next frame will be skipped or if the last
-- frame was skipped. Then you want to filter the values of the 
-- get_current_frame_frameskip_data_observable:
frameskip_observable = globals.frameskipService.get_current_frame_frameskip_data()
  -- will only emit if a frame was skipped or is about to be skipped
  :filter(function(frame_skip_data)
    return frame_skip_data.last_frame_was_skipped or frame_skip_data.next_frame_will_be_skipped
  end)
  :subscribe(function(frame_skip_data)
    print(frame_skip_data)
  end)

-- There are many other things you can do with observable data streams,
-- including matching and mapping and reducing and all kinds of things. See
-- ./scripts/rx-lua/rx.lua or the RxLua documentation for more details