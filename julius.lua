-- Advanced Modern Roblox UI Library (Dark Theme)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- UI Library
local UILibrary = {}
UILibrary.__index = UILibrary

-- Animation settings
local TWEEN_TIME = 0.25
local EASE_STYLE = Enum.EasingStyle.Quint
local EASE_DIRECTION = Enum.EasingDirection.Out

-- Modern Dark Color Scheme
local COLORS = {
    Background = Color3.fromRGB(16, 16, 18),
    Secondary = Color3.fromRGB(22, 22, 26),
    Tertiary = Color3.fromRGB(28, 28, 32),
    Border = Color3.fromRGB(35, 35, 40),
    Accent = Color3.fromRGB(88, 101, 242),
    AccentHover = Color3.fromRGB(108, 121, 255),
    AccentDark = Color3.fromRGB(71, 82, 196),
    Text = Color3.fromRGB(220, 221, 222),
    TextSecondary = Color3.fromRGB(150, 152, 157),
    TextMuted = Color3.fromRGB(114, 118, 125),
    Success = Color3.fromRGB(87, 242, 135),
    Warning = Color3.fromRGB(254, 231, 92),
    Danger = Color3.fromRGB(237, 66, 69),
    Online = Color3.fromRGB(67, 181, 129)
}

-- Create main GUI
function UILibrary.new(title)
    local self = setmetatable({}, UILibrary)
    
    -- Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "ModernUI_" .. math.random(1000, 9999)
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = PlayerGui
    
    -- Blur effect
    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = game.Lighting
    self.BlurEffect = blur
    
    -- Main container
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainContainer"
    self.MainFrame.Size = UDim2.new(0, 650, 0, 450)
    self.MainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
    self.MainFrame.BackgroundColor3 = COLORS.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui
    
    -- Main corner radius
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 8)
    mainCorner.Parent = self.MainFrame
    
    -- Border glow effect
    local borderGlow = Instance.new("UIStroke")
    borderGlow.Color = COLORS.Border
    borderGlow.Thickness = 1
    borderGlow.Parent = self.MainFrame
    
    -- Top bar
    self.TopBar = Instance.new("Frame")
    self.TopBar.Name = "TopBar"
    self.TopBar.Size = UDim2.new(1, 0, 0, 35)
    self.TopBar.BackgroundColor3 = COLORS.Secondary
    self.TopBar.BorderSizePixel = 0
    self.TopBar.Parent = self.MainFrame
    
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 8)
    topCorner.Parent = self.TopBar
    
    -- Fix corner clipping
    local topFix = Instance.new("Frame")
    topFix.Size = UDim2.new(1, 0, 0, 8)
    topFix.Position = UDim2.new(0, 0, 1, -8)
    topFix.BackgroundColor3 = COLORS.Secondary
    topFix.BorderSizePixel = 0
    topFix.Parent = self.TopBar
    
    -- Title
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = title or "Modern UI"
    self.TitleLabel.TextColor3 = COLORS.Text
    self.TitleLabel.TextSize = 13
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.TopBar
    
    -- Window controls
    self.MinimizeBtn = self:CreateWindowButton("−", UDim2.new(1, -65, 0.5, -8), COLORS.Warning)
    self.CloseBtn = self:CreateWindowButton("×", UDim2.new(1, -35, 0.5, -8), COLORS.Danger)
    
    -- Tab container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(0, 120, 1, -35)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 35)
    self.TabContainer.BackgroundColor3 = COLORS.Secondary
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Parent = self.MainFrame
    
    -- Tab list
    self.TabList = Instance.new("ScrollingFrame")
    self.TabList.Name = "TabList"
    self.TabList.Size = UDim2.new(1, 0, 1, -10)
    self.TabList.Position = UDim2.new(0, 0, 0, 10)
    self.TabList.BackgroundTransparency = 1
    self.TabList.BorderSizePixel = 0
    self.TabList.ScrollBarThickness = 2
    self.TabList.ScrollBarImageColor3 = COLORS.Accent
    self.TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.TabList.Parent = self.TabContainer
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 2)
    tabLayout.Parent = self.TabList
    
    -- Content area
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Name = "ContentArea"
    self.ContentArea.Size = UDim2.new(1, -120, 1, -35)
    self.ContentArea.Position = UDim2.new(0, 120, 0, 35)
    self.ContentArea.BackgroundColor3 = COLORS.Background
    self.ContentArea.BorderSizePixel = 0
    self.ContentArea.Parent = self.MainFrame
    
    -- Separator line
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.Size = UDim2.new(0, 1, 1, 0)
    separator.Position = UDim2.new(0, 120, 0, 35)
    separator.BackgroundColor3 = COLORS.Border
    separator.BorderSizePixel = 0
    separator.Parent = self.MainFrame
    
    -- Auto-resize tab canvas
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.TabList.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Initialize
    self:MakeDraggable()
    self:SetupWindowControls()
    
    self.Tabs = {}
    self.CurrentTab = nil
    self.IsMinimized = false
    
    -- Entrance animation
    self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local openTween = TweenService:Create(self.MainFrame, 
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
        {
            Size = UDim2.new(0, 650, 0, 450),
            Position = UDim2.new(0.5, -325, 0.5, -225)
        }
    )
    openTween:Play()
    
    -- Blur entrance
    local blurTween = TweenService:Create(blur, 
        TweenInfo.new(0.3, EASE_STYLE, EASE_DIRECTION), 
        {Size = 15}
    )
    blurTween:Play()
    
    return self
end

-- Create window control buttons
function UILibrary:CreateWindowButton(text, position, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 16, 0, 16)
    btn.Position = position
    btn.BackgroundColor3 = color
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = COLORS.Text
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Parent = self.TopBar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end)
    
    return btn
end

-- Window controls
function UILibrary:SetupWindowControls()
    self.CloseBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    self.MinimizeBtn.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
end

-- Toggle minimize
function UILibrary:ToggleMinimize()
    self.IsMinimized = not self.IsMinimized
    
    local targetSize = self.IsMinimized and 
        UDim2.new(0, 650, 0, 35) or 
        UDim2.new(0, 650, 0, 450)
    
    local tween = TweenService:Create(self.MainFrame, 
        TweenInfo.new(TWEEN_TIME, EASE_STYLE, EASE_DIRECTION), 
        {Size = targetSize}
    )
    tween:Play()
end

-- Make draggable
function UILibrary:MakeDraggable()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    self.TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Create tab
function UILibrary:CreateTab(name, icon)
    local tab = {}
    tab.Name = name
    tab.Icon = icon or "🔹"
    
    -- Tab button
    tab.Button = Instance.new("TextButton")
    tab.Button.Name = name
    tab.Button.Size = UDim2.new(1, -10, 0, 32)
    tab.Button.BackgroundColor3 = COLORS.Tertiary
    tab.Button.BorderSizePixel = 0
    tab.Button.Text = "  " .. tab.Icon .. "  " .. name
    tab.Button.TextColor3 = COLORS.TextSecondary
    tab.Button.TextSize = 12
    tab.Button.Font = Enum.Font.Gotham
    tab.Button.TextXAlignment = Enum.TextXAlignment.Left
    tab.Button.Parent = self.TabList
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 4)
    tabCorner.Parent = tab.Button
    
    -- Tab content
    tab.Content = Instance.new("ScrollingFrame")
    tab.Content.Name = name .. "Content"
    tab.Content.Size = UDim2.new(1, -20, 1, -20)
    tab.Content.Position = UDim2.new(0, 10, 0, 10)
    tab.Content.BackgroundTransparency = 1
    tab.Content.BorderSizePixel = 0
    tab.Content.ScrollBarThickness = 4
    tab.Content.ScrollBarImageColor3 = COLORS.Accent
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.Content.Visible = false
    tab.Content.Parent = self.ContentArea
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = tab.Content
    
    -- Auto-resize
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.Content.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Tab functionality
    tab.Button.MouseButton1Click:Connect(function()
        self:SwitchTab(name)
    end)
    
    -- Hover effects
    tab.Button.MouseEnter:Connect(function()
        if self.CurrentTab ~= name then
            TweenService:Create(tab.Button, TweenInfo.new(0.2), 
                {BackgroundColor3 = COLORS.Border}):Play()
        end
    end)
    
    tab.Button.MouseLeave:Connect(function()
        if self.CurrentTab ~= name then
            TweenService:Create(tab.Button, TweenInfo.new(0.2), 
                {BackgroundColor3 = COLORS.Tertiary}):Play()
        end
    end)
    
    self.Tabs[name] = tab
    
    if not self.CurrentTab then
        self:SwitchTab(name)
    end
    
    return tab
end

-- Switch tabs
function UILibrary:SwitchTab(tabName)
    for name, tab in pairs(self.Tabs) do
        if name == tabName then
            tab.Content.Visible = true
            tab.Button.BackgroundColor3 = COLORS.Accent
            tab.Button.TextColor3 = COLORS.Text
        else
            tab.Content.Visible = false
            tab.Button.BackgroundColor3 = COLORS.Tertiary
            tab.Button.TextColor3 = COLORS.TextSecondary
        end
    end
    self.CurrentTab = tabName
end

-- Create section
function UILibrary:CreateSection(tab, title)
    local section = Instance.new("Frame")
    section.Name = "Section_" .. title
    section.Size = UDim2.new(1, 0, 0, 25)
    section.BackgroundTransparency = 1
    section.Parent = tab.Content
    
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Size = UDim2.new(1, 0, 1, 0)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = title:upper()
    sectionTitle.TextColor3 = COLORS.Accent
    sectionTitle.TextSize = 11
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.Parent = section
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 1, -1)
    line.BackgroundColor3 = COLORS.Border
    line.BorderSizePixel = 0
    line.Parent = section
end

-- Add Toggle
function UILibrary:AddToggle(tab, text, desc, default, callback)
    local toggle = Instance.new("Frame")
    toggle.Name = "Toggle_" .. text
    toggle.Size = UDim2.new(1, 0, 0, desc and 55 or 40)
    toggle.BackgroundColor3 = COLORS.Secondary
    toggle.BorderSizePixel = 0
    toggle.Parent = tab.Content
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggle
    
    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Color = COLORS.Border
    toggleStroke.Thickness = 1
    toggleStroke.Parent = toggle
    
    -- Text label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, 20)
    label.Position = UDim2.new(0, 12, 0, desc and 8 or 10)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = COLORS.Text
    label.TextSize = 13
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggle
    
    -- Description
    if desc then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -60, 0, 15)
        descLabel.Position = UDim2.new(0, 12, 0, 28)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = desc
        descLabel.TextColor3 = COLORS.TextMuted
        descLabel.TextSize = 11
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = toggle
    end
    
    -- Toggle switch
    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 36, 0, 20)
    switch.Position = UDim2.new(1, -48, 0.5, -10)
    switch.BackgroundColor3 = default and COLORS.Accent or COLORS.Border
    switch.BorderSizePixel = 0
    switch.Parent = toggle
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(0, 10)
    switchCorner.Parent = switch
    
    local switchCircle = Instance.new("Frame")
    switchCircle.Size = UDim2.new(0, 16, 0, 16)
    switchCircle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    switchCircle.BackgroundColor3 = COLORS.Text
    switchCircle.BorderSizePixel = 0
    switchCircle.Parent = switch
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0, 8)
    circleCorner.Parent = switchCircle
    
    local isToggled = default or false
    
    local function updateToggle()
        local switchColor = isToggled and COLORS.Accent or COLORS.Border
        local circlePos = isToggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        
        TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = switchColor}):Play()
        TweenService:Create(switchCircle, TweenInfo.new(0.2), {Position = circlePos}):Play()
    end
    
    -- Click detection
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = toggle
    
    button.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        updateToggle()
        if callback then callback(isToggled) end
    end)
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(toggleStroke, TweenInfo.new(0.2), {Color = COLORS.Accent}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(toggleStroke, TweenInfo.new(0.2), {Color = COLORS.Border}):Play()
    end)
    
    return {
        SetState = function(state) isToggled = state; updateToggle() end,
        GetState = function() return isToggled end
    }
end

-- Add Slider
function UILibrary:AddSlider(tab, text, min, max, default, callback)
    local slider = Instance.new("Frame")
    slider.Name = "Slider_" .. text
    slider.Size = UDim2.new(1, 0, 0, 50)
    slider.BackgroundColor3 = COLORS.Secondary
    slider.BorderSizePixel = 0
    slider.Parent = tab.Content
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 6)
    sliderCorner.Parent = slider
    
    local sliderStroke = Instance.new("UIStroke")
    sliderStroke.Color = COLORS.Border
    sliderStroke.Thickness = 1
    sliderStroke.Parent = slider
    
    -- Labels
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = COLORS.Text
    label.TextSize = 13
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = slider
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.4, -12, 0, 20)
    valueLabel.Position = UDim2.new(0.6, 0, 0, 8)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default or min)
    valueLabel.TextColor3 = COLORS.Accent
    valueLabel.TextSize = 13
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = slider
    
    -- Slider track
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -24, 0, 4)
    track.Position = UDim2.new(0, 12, 1, -16)
    track.BackgroundColor3 = COLORS.Border
    track.BorderSizePixel = 0
    track.Parent = slider
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 2)
    trackCorner.Parent = track
    
    -- Slider fill
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = COLORS.Accent
    fill.BorderSizePixel = 0
    fill.Parent = track
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 2)
    fillCorner.Parent = fill
    
    -- Slider handle
    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0, 12, 0, 12)
    handle.Position = UDim2.new(0, -6, 0.5, -6)
    handle.BackgroundColor3 = COLORS.Text
    handle.BorderSizePixel = 0
    handle.Parent = track
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0, 6)
    handleCorner.Parent = handle
    
    local currentValue = default or min
    local dragging = false
    
    local function updateSlider(value)
        value = math.clamp(value, min, max)
        currentValue = value
        valueLabel.Text = tostring(math.floor(value + 0.5))
        
        local percentage = (value - min) / (max - min)
        fill.Size = UDim2.new(percentage, 0, 1, 0)
        handle.Position = UDim2.new(percentage, -6, 0.5, -6)
        
        if callback then callback(value) end
    end
    
    updateSlider(currentValue)
    
    -- Input handling
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local percentage = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            updateSlider(min + (max - min) * percentage)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local percentage = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            updateSlider(min + (max - min) * percentage)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return {
        SetValue = function(value) updateSlider(value) end,
        GetValue = function() return currentValue end
    }
end

-- Add Button
function UILibrary:AddButton(tab, text, desc, callback)
    local button = Instance.new("TextButton")
    button.Name = "Button_" .. text
    button.Size = UDim2.new(1, 0, 0, desc and 50 or 35)
    button.BackgroundColor3 = COLORS.Accent
    button.BorderSizePixel = 0
    button.Text = ""
    button.Parent = tab.Content
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 18)
    label.Position = UDim2.new(0, 10, 0, desc and 8 or 8.5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = COLORS.Text
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.Parent = button
    
    if desc then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -20, 0, 14)
        descLabel.Position = UDim2.new(0, 10, 0, 26)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = desc
        descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        descLabel.TextSize = 11
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextXAlignment = Enum.TextXAlignment.Center
        descLabel.Parent = button
    end
    
    button.MouseButton1Click:Connect(function()
        if callback then callback() end
        
        -- Click animation
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = COLORS.AccentDark}):Play()
        wait(0.1)
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = COLORS.Accent}):Play()
    end)
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 =
