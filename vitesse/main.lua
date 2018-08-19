-- luacheck: globals audio Display easing graphics lfs media native network Runtime system timer transition

local Composer = require "composer"
local Display  = require "display"
local Native   = require "native"
local System   = require "system"

local scene = Composer.newScene ()

function scene.create ()
  -- Background:
  scene.background = Display.newRect (
    Display.screenOriginX + Display.actualContentWidth  / 2,
    Display.screenOriginY + Display.actualContentHeight / 2,
    Display.actualContentWidth,
    Display.actualContentHeight
  )
  scene.background:setFillColor (0)
  scene.view:insert (scene.background)
  -- Speed:
  scene.speed = Display.newText {
    text     = "---",
    font     = Native.systemFontBold,
    fontSize = Display.actualContentWidth / 5,
    align    = "center",
    x        = 0 + Display.screenOriginX + Display.actualContentWidth  / 2,
    y        = 0 + Display.screenOriginY + Display.actualContentHeight / 2,
    width    = Display.actualContentWidth,
    height   = 0,
  }
  scene.view:insert (scene.speed)
end

function scene.show (_, event)
  if event.phase == "will" then
    Runtime:addEventListener ("location", scene.locate)
    Runtime:addEventListener ("resize"  , scene.resize)
    System.setIdleTimer (false)
  elseif event.phase == "did" then
    assert (true)
  end
end

function scene.hide (_, event)
  if event.phase == "will" then
    Runtime:removeEventListener ("location", scene.locate)
    Runtime:removeEventListener ("resize"  , scene.resize)
    System.setIdleTimer (true)
  elseif event.phase == "did" then
    assert (true)
  end
end

function scene.destroy ()
  scene.background:removeSelf ()
  scene.speed     :removeSelf ()
end

function scene.locate (event)
    if (event.errorCode) then
      Native.showAlert ("GPS Location Error", event.errorMessage, {"OK"})
      print ("Location error: " .. tostring (event.errorMessage))
      scene.speed.text = "---"
    else
      -- Convert from m/s to km/h:
      local speed = event.speed * 3.6
      if speed < 0 then
        scene.speed.text = "---"
      else
        scene.speed.text = string.format ("%d\nkm/h", speed)
      end
    end
end

function scene.resize (_)
  scene.destroy ()
  scene.create  ()
end

-- Listeners:
scene:addEventListener ("create" , scene)
scene:addEventListener ("show"   , scene)
scene:addEventListener ("hide"   , scene)
scene:addEventListener ("destroy", scene)

return scene
