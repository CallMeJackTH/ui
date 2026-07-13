--[[
	Pryv4x UI Library
	----------------------------------------------------
	A minimal, high-tech / dark cyberpunk styled UI library for Roblox.
	No bouncy tweens, no heavy effects - just clean sharp panels,
	thin cyan borders, monospace text.

	Usage:
		local Pryv4x = loadstring(game:HttpGet("<raw github url>"))()

		local Window = Pryv4x:CreateWindow({
			Title = "PRYV4X",
			Icon  = "rbxassetid://111219641085455",
		})

		local Tab = Window:CreateTab("Main")

		Tab:CreateButton({ Text = "Do Thing", Callback = function() end })
		Tab:CreateToggle({ Text = "Enabled", Default = false, Callback = function(v) end })
		Tab:CreateSlider({ Text = "Speed", Min = 0, Max = 100, Default = 16, Callback = function(v) end })
		Tab:CreateDropdown({ Text = "Mode", Options = {"A","B","C"}, Callback = function(v) end })
		Tab:CreateLabel("Just some info text")

		Window:Notify({ Title = "Pryv4x", Content = "Loaded.", Duration = 3 })
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--=====================================================
-- THEME
--=====================================================
local Theme = {
	Background   = Color3.fromRGB(8, 8, 12),
	Panel        = Color3.fromRGB(13, 13, 18),
	PanelAlt     = Color3.fromRGB(17, 17, 23),
	Border       = Color3.fromRGB(0, 210, 200),
	BorderDim    = Color3.fromRGB(0, 90, 88),
	Accent       = Color3.fromRGB(0, 240, 230),
	AccentDim    = Color3.fromRGB(0, 120, 115),
	Text         = Color3.fromRGB(215, 235, 235),
	SubText      = Color3.fromRGB(110, 130, 130),
	Danger       = Color3.fromRGB(255, 70, 90),
}

local FONT = Enum.Font.Code            -- monospace, no-nonsense
local FONT_BOLD = Enum.Font.Code

local DEFAULT_ICON = "rbxassetid://111219641085455"

--=====================================================
-- HELPERS
--=====================================================
local function new(class, props, children)
	local inst = Instance.new(class)
	for k, v in pairs(props or {}) do
		inst[k] = v
	end
	for _, child in ipairs(children or {}) do
		child.Parent = inst
	end
	return inst
end

local function stroke(color, thickness)
	return new("UIStroke", {
		Color = color or Theme.Border,
		Thickness = thickness or 1,
		Transparency = 0.2,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})
end

local function corner(radius)
	return new("UICorner", { CornerRadius = UDim.new(0, radius or 4) })
end

local function pad(t, b, l, r)
	return new("UIPadding", {
		PaddingTop = UDim.new(0, t or 6),
		PaddingBottom = UDim.new(0, b or 6),
		PaddingLeft = UDim.new(0, l or 8),
		PaddingRight = UDim.new(0, r or 8),
	})
end

local function tween(inst, props, time, style)
	local t = TweenService:Create(inst, TweenInfo.new(time or 0.12, style or Enum.EasingStyle.Quad), props)
	t:Play()
	return t
end

local function makeDraggable(handle, target)
	local dragging, dragStart, startPos = false, nil, nil

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = target.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	handle.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			target.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

--=====================================================
-- LIBRARY
--=====================================================
local Pryv4x = {}
Pryv4x.__index = Pryv4x

function Pryv4x:CreateWindow(config)
	config = config or {}
	local title = config.Title or "PRYV4X"
	local icon = config.Icon or DEFAULT_ICON
	local size = config.Size or UDim2.fromOffset(560, 360)

	-- Cleanup old instance of this gui if it exists
	local existing = PlayerGui:FindFirstChild("Pryv4x_UI")
	if existing then existing:Destroy() end

	local ScreenGui = new("ScreenGui", {
		Name = "Pryv4x_UI",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = PlayerGui,
	})

	local Main = new("Frame", {
		Name = "Main",
		Size = size,
		Position = UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2),
		BackgroundColor3 = Theme.Background,
		BorderSizePixel = 0,
		Parent = ScreenGui,
	}, { corner(6), stroke(Theme.Border, 1) })

	-- Top bar
	local TopBar = new("Frame", {
		Name = "TopBar",
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundColor3 = Theme.Panel,
		BorderSizePixel = 0,
		Parent = Main,
	}, { corner(6) })

	-- mask bottom corners of topbar so it looks like a flat header
	new("Frame", {
		Size = UDim2.new(1, 0, 0, 10),
		Position = UDim2.new(0, 0, 1, -10),
		BackgroundColor3 = Theme.Panel,
		BorderSizePixel = 0,
		ZIndex = 1,
		Parent = TopBar,
	})

	new("ImageLabel", {
		Name = "Icon",
		Size = UDim2.fromOffset(20, 20),
		Position = UDim2.new(0, 8, 0.5, -10),
		BackgroundTransparency = 1,
		Image = icon,
		Parent = TopBar,
	})

	new("TextLabel", {
		Name = "Title",
		Size = UDim2.new(1, -140, 1, 0),
		Position = UDim2.new(0, 36, 0, 0),
		BackgroundTransparency = 1,
		Font = FONT_BOLD,
		Text = string.upper(title),
		TextColor3 = Theme.Accent,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = TopBar,
	})

	local CloseBtn = new("TextButton", {
		Name = "Close",
		Size = UDim2.fromOffset(26, 22),
		Position = UDim2.new(1, -32, 0.5, -11),
		BackgroundColor3 = Theme.PanelAlt,
		Text = "X",
		Font = FONT,
		TextColor3 = Theme.Danger,
		TextSize = 13,
		AutoButtonColor = false,
		Parent = TopBar,
	}, { corner(3), stroke(Theme.BorderDim, 1) })

	CloseBtn.MouseEnter:Connect(function()
		tween(CloseBtn, { BackgroundColor3 = Theme.Danger })
		tween(CloseBtn, { TextColor3 = Theme.Background })
	end)
	CloseBtn.MouseLeave:Connect(function()
		tween(CloseBtn, { BackgroundColor3 = Theme.PanelAlt })
		tween(CloseBtn, { TextColor3 = Theme.Danger })
	end)
	CloseBtn.MouseButton1Click:Connect(function()
		ScreenGui.Enabled = false
	end)

	makeDraggable(TopBar, Main)

	-- Sidebar (tab list)
	local Sidebar = new("Frame", {
		Name = "Sidebar",
		Size = UDim2.new(0, 130, 1, -34),
		Position = UDim2.new(0, 0, 0, 34),
		BackgroundColor3 = Theme.Panel,
		BorderSizePixel = 0,
		Parent = Main,
	})

	new("Frame", {
		Size = UDim2.new(0, 1, 1, 0),
		Position = UDim2.new(1, -1, 0, 0),
		BackgroundColor3 = Theme.BorderDim,
		BorderSizePixel = 0,
		Parent = Sidebar,
	})

	local TabList = new("UIListLayout", {
		Padding = UDim.new(0, 2),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
	TabList.Parent = Sidebar
	pad(8, 8, 6, 6).Parent = Sidebar

	-- Content area
	local ContentHolder = new("Frame", {
		Name = "ContentHolder",
		Size = UDim2.new(1, -130, 1, -34),
		Position = UDim2.new(0, 130, 0, 34),
		BackgroundTransparency = 1,
		Parent = Main,
	})

	-- Notification container (top right of screen)
	local NotifHolder = new("Frame", {
		Name = "Notifications",
		Size = UDim2.new(0, 260, 1, -20),
		Position = UDim2.new(1, -270, 0, 10),
		BackgroundTransparency = 1,
		Parent = ScreenGui,
	})
	new("UIListLayout", {
		Padding = UDim.new(0, 6),
		VerticalAlignment = Enum.VerticalAlignment.Top,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		SortOrder = Enum.SortOrder.LayoutOrder,
	}).Parent = NotifHolder

	local Window = setmetatable({
		ScreenGui = ScreenGui,
		Main = Main,
		Sidebar = Sidebar,
		ContentHolder = ContentHolder,
		NotifHolder = NotifHolder,
		_tabs = {},
		_firstTab = nil,
	}, Pryv4x)

	return Window
end

--=====================================================
-- WINDOW METHODS
--=====================================================
function Pryv4x:SetVisible(visible)
	self.ScreenGui.Enabled = visible
end

function Pryv4x:Notify(config)
	config = config or {}
	local title = config.Title or "Pryv4x"
	local content = config.Content or ""
	local duration = config.Duration or 3

	local Notif = new("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Theme.Panel,
		BorderSizePixel = 0,
		LayoutOrder = -os.clock(),
		Parent = self.NotifHolder,
	}, { corner(4), stroke(Theme.Border, 1), pad(8, 8, 10, 10) })

	new("UIListLayout", {
		Padding = UDim.new(0, 2),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}).Parent = Notif

	new("TextLabel", {
		Size = UDim2.new(1, 0, 0, 16),
		BackgroundTransparency = 1,
		Font = FONT_BOLD,
		Text = string.upper(title),
		TextColor3 = Theme.Accent,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = 1,
		Parent = Notif,
	})

	new("TextLabel", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Font = FONT,
		Text = content,
		TextColor3 = Theme.SubText,
		TextSize = 12,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = 2,
		Parent = Notif,
	})

	task.delay(duration, function()
		if Notif and Notif.Parent then
			tween(Notif, { BackgroundTransparency = 1 }, 0.2)
			task.wait(0.2)
			Notif:Destroy()
		end
	end)
end

function Pryv4x:CreateTab(name)
	local index = #self._tabs + 1

	local TabButton = new("TextButton", {
		Name = name,
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundColor3 = Theme.PanelAlt,
		AutoButtonColor = false,
		Font = FONT,
		Text = "  " .. name,
		TextColor3 = Theme.SubText,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = index,
		Parent = self.Sidebar,
	}, { corner(3) })

	local Page = new("ScrollingFrame", {
		Name = name .. "_Page",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = Theme.Border,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Visible = false,
		Parent = self.ContentHolder,
	}, { pad(10, 10, 10, 10) })

	local Layout = new("UIListLayout", {
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
	Layout.Parent = Page

	local TabObj = setmetatable({
		Button = TabButton,
		Page = Page,
		_order = 0,
	}, Pryv4x.Tab)

	table.insert(self._tabs, TabObj)

	local function selectTab()
		for _, t in ipairs(self._tabs) do
			t.Page.Visible = false
			t.Button.BackgroundColor3 = Theme.PanelAlt
			t.Button.TextColor3 = Theme.SubText
		end
		TabObj.Page.Visible = true
		TabButton.BackgroundColor3 = Theme.Border
		TabButton.TextColor3 = Theme.Background
	end

	TabButton.MouseButton1Click:Connect(selectTab)

	if not self._firstTab then
		self._firstTab = TabObj
		selectTab()
	end

	return TabObj
end

--=====================================================
-- TAB METHODS (components)
--=====================================================
Pryv4x.Tab = {}
Pryv4x.Tab.__index = Pryv4x.Tab

local function nextOrder(tab)
	tab._order = tab._order + 1
	return tab._order
end

function Pryv4x.Tab:CreateLabel(text)
	new("TextLabel", {
		Size = UDim2.new(1, 0, 0, 18),
		BackgroundTransparency = 1,
		Font = FONT,
		Text = text,
		TextColor3 = Theme.SubText,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		LayoutOrder = nextOrder(self),
		Parent = self.Page,
	})
end

function Pryv4x.Tab:CreateButton(config)
	config = config or {}
	local text = config.Text or "Button"
	local callback = config.Callback or function() end

	local Btn = new("TextButton", {
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundColor3 = Theme.Panel,
		AutoButtonColor = false,
		Font = FONT,
		Text = text,
		TextColor3 = Theme.Text,
		TextSize = 13,
		LayoutOrder = nextOrder(self),
		Parent = self.Page,
	}, { corner(4), stroke(Theme.BorderDim, 1) })

	Btn.MouseEnter:Connect(function()
		tween(Btn, { BackgroundColor3 = Theme.PanelAlt })
	end)
	Btn.MouseLeave:Connect(function()
		tween(Btn, { BackgroundColor3 = Theme.Panel })
	end)
	Btn.MouseButton1Click:Connect(function()
		callback()
	end)

	return Btn
end

function Pryv4x.Tab:CreateToggle(config)
	config = config or {}
	local text = config.Text or "Toggle"
	local default = config.Default or false
	local callback = config.Callback or function() end
	local state = default

	local Holder = new("Frame", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = Theme.Panel,
		LayoutOrder = nextOrder(self),
		Parent = self.Page,
	}, { corner(4), stroke(Theme.BorderDim, 1) })

	new("TextLabel", {
		Size = UDim2.new(1, -50, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		BackgroundTransparency = 1,
		Font = FONT,
		Text = text,
		TextColor3 = Theme.Text,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Holder,
	})

	local Switch = new("Frame", {
		Size = UDim2.fromOffset(34, 16),
		Position = UDim2.new(1, -44, 0.5, -8),
		BackgroundColor3 = state and Theme.Border or Theme.PanelAlt,
		Parent = Holder,
	}, { corner(8), stroke(Theme.BorderDim, 1) })

	local Knob = new("Frame", {
		Size = UDim2.fromOffset(12, 12),
		Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
		BackgroundColor3 = Theme.Background,
		Parent = Switch,
	}, { corner(6) })

	local Click = new("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		Parent = Holder,
	})

	Click.MouseButton1Click:Connect(function()
		state = not state
		tween(Switch, { BackgroundColor3 = state and Theme.Border or Theme.PanelAlt })
		tween(Knob, { Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6) })
		callback(state)
	end)

	return {
		Set = function(_, value)
			state = value
			tween(Switch, { BackgroundColor3 = state and Theme.Border or Theme.PanelAlt })
			tween(Knob, { Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6) })
		end,
	}
end

function Pryv4x.Tab:CreateSlider(config)
	config = config or {}
	local text = config.Text or "Slider"
	local min = config.Min or 0
	local max = config.Max or 100
	local default = math.clamp(config.Default or min, min, max)
	local callback = config.Callback or function() end

	local Holder = new("Frame", {
		Size = UDim2.new(1, 0, 0, 44),
		BackgroundColor3 = Theme.Panel,
		LayoutOrder = nextOrder(self),
		Parent = self.Page,
	}, { corner(4), stroke(Theme.BorderDim, 1), pad(6, 6, 10, 10) })

	local Label = new("TextLabel", {
		Size = UDim2.new(1, 0, 0, 16),
		BackgroundTransparency = 1,
		Font = FONT,
		Text = text .. ": " .. tostring(default),
		TextColor3 = Theme.Text,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Holder,
	})

	local Track = new("Frame", {
		Size = UDim2.new(1, 0, 0, 4),
		Position = UDim2.new(0, 0, 0, 24),
		BackgroundColor3 = Theme.PanelAlt,
		Parent = Holder,
	}, { corner(2) })

	local Fill = new("Frame", {
		Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
		BackgroundColor3 = Theme.Border,
		Parent = Track,
	}, { corner(2) })

	local Grabber = new("TextButton", {
		Size = UDim2.new(1, 0, 0, 14),
		Position = UDim2.new(0, 0, 0, -5),
		BackgroundTransparency = 1,
		Text = "",
		Parent = Track,
	})

	local dragging = false
	local function setFromX(x)
		local rel = math.clamp((x - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
		local value = math.floor(min + (max - min) * rel + 0.5)
		Fill.Size = UDim2.new(rel, 0, 1, 0)
		Label.Text = text .. ": " .. tostring(value)
		callback(value)
	end

	Grabber.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			setFromX(input.Position.X)
		end
	end)
	Grabber.MouseButton1Down:Connect(function()
		local x = UserInputService:GetMouseLocation().X
		setFromX(x)
	end)

	return Holder
end

function Pryv4x.Tab:CreateDropdown(config)
	config = config or {}
	local text = config.Text or "Dropdown"
	local options = config.Options or {}
	local callback = config.Callback or function() end
	local open = false
	local selected = options[1]

	local Holder = new("Frame", {
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundColor3 = Theme.Panel,
		ClipsDescendants = false,
		LayoutOrder = nextOrder(self),
		Parent = self.Page,
	}, { corner(4), stroke(Theme.BorderDim, 1) })

	new("TextLabel", {
		Size = UDim2.new(0.5, 0, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		BackgroundTransparency = 1,
		Font = FONT,
		Text = text,
		TextColor3 = Theme.Text,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Holder,
	})

	local ValueBtn = new("TextButton", {
		Size = UDim2.new(0.5, -10, 1, -6),
		Position = UDim2.new(0.5, 0, 0, 3),
		BackgroundColor3 = Theme.PanelAlt,
		AutoButtonColor = false,
		Font = FONT,
		Text = tostring(selected) .. "  v",
		TextColor3 = Theme.Accent,
		TextSize = 12,
		Parent = Holder,
	}, { corner(3), stroke(Theme.BorderDim, 1) })

	local List = new("Frame", {
		Size = UDim2.new(0.5, -10, 0, #options * 24),
		Position = UDim2.new(0.5, 0, 1, 4),
		BackgroundColor3 = Theme.PanelAlt,
		Visible = false,
		ZIndex = 5,
		Parent = Holder,
	}, { corner(3), stroke(Theme.Border, 1) })

	new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }).Parent = List

	for _, option in ipairs(options) do
		local OptBtn = new("TextButton", {
			Size = UDim2.new(1, 0, 0, 24),
			BackgroundTransparency = 1,
			Font = FONT,
			Text = tostring(option),
			TextColor3 = Theme.Text,
			TextSize = 12,
			ZIndex = 5,
			Parent = List,
		})
		OptBtn.MouseButton1Click:Connect(function()
			selected = option
			ValueBtn.Text = tostring(selected) .. "  v"
			List.Visible = false
			open = false
			callback(selected)
		end)
	end

	ValueBtn.MouseButton1Click:Connect(function()
		open = not open
		List.Visible = open
	end)

	return {
		Get = function() return selected end,
	}
end

return Pryv4x
