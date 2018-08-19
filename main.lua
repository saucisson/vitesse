-- luacheck: globals audio display easing graphics lfs media native network Runtime system timer transition

package.path = "./?.lua;" .. package.path
local Composer = require "composer"

-- hide the status bar
display.setStatusBar (display.DefaultStatusBar)
-- load menu screen
Composer.gotoScene "vitesse.main"
