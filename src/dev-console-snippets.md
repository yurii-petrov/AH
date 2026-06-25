# Dev console snippets

In-game `/execute` helpers used while authoring the mod. Paste into the TTS
chat console. Not bundled into the mod (this file is not `require()`d).

```lua
-- Selected + hovered: log hovered guid, its position/rotation in selected's local space
/execute local c=Player.White;local s=c.getSelectedObjects()[1];local h=c.getHoverObject();if s and h then log("g="..h.getGUID().."\npos="..serpent.tts(s.positionToLocal(h.getPosition())).." rot="..serpent.tts(s.positionToLocal(h.getRotation()))) end

-- Hovered: log guid + world position/rotation
/execute local c=Player.White;local h=c.getHoverObject();if h then log("g="..h.getGUID().."\npos="..serpent.tts(h.getPosition()).." rot="..serpent.tts(h.getRotation())) end

-- Move hovered to a fixed position
/execute local c=Player.White;local h=c.getHoverObject();if h then h.setPosition({0, 2.4, 0}) end
```

## Prepare scenario

```lua
-- Set memo / GM notes on hovered object
/execute local c=Player.White;local h=c.getHoverObject();if h then h.memo = "Items Mat"; print("set: "..h.memo) end
/execute local c=Player.White;local h=c.getHoverObject();if h then h.setGMNotes("Neighborhood"); print("set: "..h.getGMNotes()) end
/execute local c=Player.White;local s=c.getSelectedObjects()[1];local h=c.getHoverObject();if s and h then log("["..s.memo.."] = {\npos="..serpent.tts(s.positionToLocal(h.getPosition())).." rot="..serpent.tts(s.positionToLocal(h.getRotation()))) end
/execute local c=Player.White;local h=c.getHoverObject();if h then h.memo = "Remnant Token"; print("set: "..h.memo) end

-- Read memo (plain text vs Lua/JSON)
/execute local c=Player.White;local h=c.getHoverObject();if h then print("memo: "..h.memo) end -- якщо тільки текст
/execute local c=Player.White;local h=c.getHoverObject();if h then print("memo: "..serpent.tts(parseJson(h.memo))) end -- якщо луа
/execute local c=Player.White;local h=c.getHoverObject();if h then print("guid: "..h.guid) end

-- Position/rotation helpers (mPos/gPos/mPosRot/gPosRot/addSet defined in code)
/execute local c=Player.White;local s=c.getSelectedObjects()[1];local h=c.getHoverObject();if s and h then mPos(s, h) end
/execute local c=Player.White;local s=c.getSelectedObjects()[1];local h=c.getHoverObject();if s and h then gPos(s, h) end
/execute local c=Player.White;local s=c.getSelectedObjects()[1];local h=c.getHoverObject();if s and h then mPosRot(s, h) end
/execute local c=Player.White;local s=c.getSelectedObjects()[1];local h=c.getHoverObject();if s and h then gPosRot(s, h) end
/execute local c=Player.White;local s=c.getSelectedObjects();if s then addSet(n, s) end

-- Dump hovered object
/execute local c=Player.White;local h=c.getHoverObject();if h then print(serpent.tts(h)) end
```
