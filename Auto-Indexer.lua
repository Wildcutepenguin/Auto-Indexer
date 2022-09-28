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
local openButton = toolbar:CreateButton("Index Instances", "Index instances automatically", "rbxassetid://4458901886")

local function onNewScriptButtonClicked()
	widget.Enabled = not widget.Enabled
end

openButton.Click:Connect(onNewScriptButtonClicked)

local textbox = Instance.new("TextBox")
textbox.BorderSizePixel = 0
textbox.TextScaled = true
textbox.TextEditable = false
textbox.ClearTextOnFocus = false
textbox.TextColor3 = Color3.new(1,0.2,0.4)
textbox.AnchorPoint = Vector2.new(0.5,0)
textbox.Size = UDim2.new(1,0,0.5,0)
textbox.Position = UDim2.new(0.5,0,0,0)
textbox.SizeConstraint = Enum.SizeConstraint.RelativeYY
textbox.Text = "Select the parent of the objects you would like to index"
textbox.Parent = widget

local runButton = Instance.new("TextButton")
runButton.BorderSizePixel = 0
runButton.TextSize = 20
runButton.TextColor3 = Color3.new(1,0.2,0.4)
runButton.AnchorPoint = Vector2.new(0.5,1)
runButton.Size = UDim2.new(1,0,0.5,0)
runButton.Position = UDim2.new(0.5,0,1,0)
runButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
runButton.Text = "Run"
runButton.Parent = widget

local parent

local function changeSelection()
	if runButton.Text == "Run" then
		local selectedObjects = Selection:Get()
		if #selectedObjects == 1 then
			parent = selectedObjects[1]
			textbox.Text = selectedObjects[1].Name
		else
			textbox.Text = ""
		end
	end
end

local selectionConnection = Selection.SelectionChanged:Connect(changeSelection)

local childDetection

local function onRunButtonClick()
	if parent then
		if runButton.Text == "Run" then
			runButton.Text = "Stop"
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
				runButton.Text = "Run"
				childDetection:Disconnect()
			end
		end
	end
end

runButton.MouseButton1Click:Connect(onRunButtonClick)

widget:GetPropertyChangedSignal("Enabled"):Connect(function()
	openButton:SetActive(widget.Enabled)
	if widget.Enabled then
		selectionConnection = Selection.SelectionChanged:Connect(changeSelection)
	else
		if selectionConnection then
			selectionConnection:Disconnect()
		end
		if childDetection then
			runButton.Text = "Run"
			childDetection:Disconnect()
		end
	end
end)