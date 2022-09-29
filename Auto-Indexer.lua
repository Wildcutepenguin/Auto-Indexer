-- Auto-Indexer
-- Made by Wildcutepenguin

local Selection = game:GetService("Selection")

-- Create new "DockWidgetPluginGuiInfo" object
local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,  -- Widget will be initialized in floating panel
	false,   -- Widget will be initially enabled
	false,  -- Don't override the previous enabled state
	200,    -- Default width of the floating window
	300,    -- Default height of the floating window
	100,    -- Minimum width of the floating window
	150     -- Minimum height of the floating window
)

-- Create new widget GUI
local widget = plugin:CreateDockWidgetPluginGui("TestWidget", widgetInfo)
widget.Title = "Auto-Indexer"  -- Optional widget title

local toolbar = plugin:CreateToolbar("Auto-Indexer")
local openButton = toolbar:CreateButton("Index Instances", "Index instances automatically", "rbxassetid://11114821897")

local function onNewScriptButtonClicked()
	widget.Enabled = not widget.Enabled
end

openButton.Click:Connect(onNewScriptButtonClicked)

local Elements = {
	["_Frame"] = Instance.new("Frame");
	["_RunButton"] = Instance.new("TextButton");
	["_UICorner"] = Instance.new("UICorner");
	["_TextBox"] = Instance.new("TextBox");
	["_UICorner1"] = Instance.new("UICorner");
	["_TextLabel"] = Instance.new("TextLabel");
}

Elements["_Frame"].AnchorPoint = Vector2.new(0.5, 0.5)
Elements["_Frame"].BackgroundColor3 = Color3.fromRGB(27.000002190470695, 94.0000019967556, 125.00000774860382)
Elements["_Frame"].Position = UDim2.new(0.5, 0, 0.5, 0)
Elements["_Frame"].Size = UDim2.new(1, 0, 1, 0)
Elements["_Frame"].Parent = widget

Elements["_RunButton"].Font = Enum.Font.PatrickHand
Elements["_RunButton"].Text = "Run"
Elements["_RunButton"].TextColor3 = Color3.fromRGB(255, 255, 255)
Elements["_RunButton"].TextScaled = true
Elements["_RunButton"].TextSize = 14
Elements["_RunButton"].TextStrokeTransparency = 0
Elements["_RunButton"].TextWrapped = true
Elements["_RunButton"].AnchorPoint = Vector2.new(0.5, 1)
Elements["_RunButton"].BackgroundColor3 = Color3.fromRGB(0, 255, 0)
Elements["_RunButton"].Position = UDim2.new(0.5, 0, 1, 0)
Elements["_RunButton"].Size = UDim2.new(1, 0, 0.25, 0)
Elements["_RunButton"].Name = "RunButton"
Elements["_RunButton"].Parent = Elements["_Frame"]

Elements["_UICorner"].CornerRadius = UDim.new(1, 0)
Elements["_UICorner"].Parent = Elements["_RunButton"]

Elements["_TextBox"].ClearTextOnFocus = false
Elements["_TextBox"].CursorPosition = -1
Elements["_TextBox"].Font = Enum.Font.SourceSans
Elements["_TextBox"].PlaceholderText = "______"
Elements["_TextBox"].Text = ""
Elements["_TextBox"].TextColor3 = Color3.fromRGB(255, 255, 255)
Elements["_TextBox"].TextEditable = false
Elements["_TextBox"].TextScaled = true
Elements["_TextBox"].TextSize = 14
Elements["_TextBox"].TextStrokeTransparency = 0
Elements["_TextBox"].TextWrapped = true
Elements["_TextBox"].AnchorPoint = Vector2.new(0.5, 0)
Elements["_TextBox"].BackgroundColor3 = Color3.fromRGB(68.00000354647636, 68.00000354647636, 68.00000354647636)
Elements["_TextBox"].Position = UDim2.new(0.5, 0, 0.150000006, 0)
Elements["_TextBox"].Size = UDim2.new(1, 0, 0.25, 0)
Elements["_TextBox"].Parent = Elements["_Frame"]

Elements["_UICorner1"].CornerRadius = UDim.new(0.200000003, 0)
Elements["_UICorner1"].Parent = Elements["_TextBox"]

Elements["_TextLabel"].Font = Enum.Font.PatrickHand
Elements["_TextLabel"].Text = "Select the parent of the objects you would like to index"
Elements["_TextLabel"].TextColor3 = Color3.fromRGB(255, 255, 255)
Elements["_TextLabel"].TextScaled = true
Elements["_TextLabel"].TextSize = 14
Elements["_TextLabel"].TextStrokeTransparency = 0
Elements["_TextLabel"].TextWrapped = true
Elements["_TextLabel"].AnchorPoint = Vector2.new(0.5, 0)
Elements["_TextLabel"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Elements["_TextLabel"].BackgroundTransparency = 1
Elements["_TextLabel"].BorderSizePixel = 0
Elements["_TextLabel"].Position = UDim2.new(0.5, 0, 0, 0)
Elements["_TextLabel"].Size = UDim2.new(1, 0, 0.150000006, 0)
Elements["_TextLabel"].Parent = Elements["_Frame"]

--local textbox = Instance.new("TextBox")
--textbox.BorderSizePixel = 0
--textbox.TextScaled = true
--textbox.TextEditable = false
--textbox.ClearTextOnFocus = false
--textbox.TextColor3 = Color3.new(1,0.2,0.4)
--textbox.AnchorPoint = Vector2.new(0.5,0)
--textbox.Size = UDim2.new(1,0,0.5,0)
--textbox.Position = UDim2.new(0.5,0,0,0)
--textbox.Text = "Select the parent of the objects you would like to index"
--textbox.Parent = widget

--local runButton = Instance.new("TextButton")
--runButton.BorderSizePixel = 0
--runButton.TextSize = 20
--runButton.TextColor3 = Color3.new(1,0.2,0.4)
--runButton.AnchorPoint = Vector2.new(0.5,1)
--runButton.Size = UDim2.new(1,0,0.5,0)
--runButton.Position = UDim2.new(0.5,0,1,0)
--runButton.Text = "Run"
--runButton.Parent = widget

local parent

local function changeSelection()
	if Elements["_RunButton"].Text == "Run" then
		local selectedObjects = Selection:Get()
		if #selectedObjects == 1 then
			parent = selectedObjects[1]
			Elements["_TextBox"].Text = selectedObjects[1].Name
		else
			Elements["_TextBox"].Text = ""
		end
	end
end

local selectionConnection = Selection.SelectionChanged:Connect(changeSelection)

local childDetection

local function onRunButtonClick()
	if parent then
		if Elements["_RunButton"].Text == "Run" then
			Elements["_RunButton"].Text = "Stop"
			Elements["_RunButton"].BackgroundColor3 = Color3.new(1,0,0)
			childDetection = parent.ChildAdded:Connect(function(newChild)
				local highestInt = 0
				for i, v in parent:GetChildren() do
					if v.Name:match("%d") then
						local num = tonumber(string.match(v.Name,"%d"))
						if num > highestInt then
							highestInt = num
						end
					end
				end
				newChild.Name = tostring(highestInt+1)
			end)
		else
			if childDetection then
				Elements["_RunButton"].Text = "Run"
				Elements["_RunButton"].BackgroundColor3 = Color3.new(0,1,0)
				childDetection:Disconnect()
			end
		end
	end
end

Elements["_RunButton"].MouseButton1Click:Connect(onRunButtonClick)

widget:GetPropertyChangedSignal("Enabled"):Connect(function()
	openButton:SetActive(widget.Enabled)
	if widget.Enabled then
		selectionConnection = Selection.SelectionChanged:Connect(changeSelection)
	else
		if selectionConnection then
			selectionConnection:Disconnect()
		end
		if childDetection then
			Elements["_RunButton"].Text = "Run"
			childDetection:Disconnect()
		end
	end
end)
