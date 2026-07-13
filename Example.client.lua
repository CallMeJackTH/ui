--[[
	Pryv4x - Example usage
	วางไฟล์นี้เป็น LocalScript แล้วเปลี่ยน URL ด้านล่างเป็น raw link
	ของไฟล์ Pryv4x.lua ที่อยู่บน GitHub ของคุณ
--]]

local Pryv4x = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/PJKUNGHUB/ui/main/Pryv4x.lua"
))()

local Window = Pryv4x:CreateWindow({
	Title = "PRYV4X",
	Icon  = "rbxassetid://111219641085455",
	Size  = UDim2.fromOffset(560, 360),
})

-- Tab 1: Main
local MainTab = Window:CreateTab("Main")

MainTab:CreateLabel("Invisible Fists : Cloak & Dagger")

MainTab:CreateButton({
	Text = "Print Hello",
	Callback = function()
		print("Hello from Pryv4x!")
	end,
})

MainTab:CreateToggle({
	Text = "Auto Combo",
	Default = false,
	Callback = function(state)
		print("Auto Combo:", state)
	end,
})

MainTab:CreateSlider({
	Text = "Walk Speed",
	Min = 8,
	Max = 40,
	Default = 16,
	Callback = function(value)
		print("Walk Speed:", value)
	end,
})

MainTab:CreateDropdown({
	Text = "Combat Mode",
	Options = { "Normal", "Aggressive", "Defensive" },
	Callback = function(value)
		print("Combat Mode:", value)
	end,
})

-- Tab 2: Settings
local SettingsTab = Window:CreateTab("Settings")

SettingsTab:CreateLabel("Adjust visual & UI settings here.")

SettingsTab:CreateButton({
	Text = "Test Notification",
	Callback = function()
		Window:Notify({
			Title = "Pryv4x",
			Content = "This is a test notification.",
			Duration = 3,
		})
	end,
})
