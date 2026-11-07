local M = {}

local function read(path)
	local f = io.open(path)
	if not f then
		return nil
	end
	local v = f:read("*l")
	f:close()
	return v
end

-- SMBIOS chassis types: 8 Portable, 9 Laptop, 10 Notebook, 14 Sub Notebook, 31 Convertible, 32 Detachable
local laptop_types = { ["8"] = true, ["9"] = true, ["10"] = true, ["14"] = true, ["31"] = true, ["32"] = true }

local chassis = read("/sys/class/dmi/id/chassis_type")
if not chassis then
	hl.notification.create({
		text = "Unable to determine chassis type. Defaulting to desktop configuration.",
		timeout = 5000,
	})
end

local is_laptop = laptop_types[chassis] == true

M.is_laptop = is_laptop
M.is_desktop = not is_laptop

return M
