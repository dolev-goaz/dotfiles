require("env")
require("base-config")
require("binds")
local machine = require("machine")
if machine.is_laptop then
	require("laptop-config")
else
	require("desktop-config")
end
require("plugins")
require("window-rules")
require("auto-start")
require("animations")
require("decorations")
