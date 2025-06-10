-- Modern Roblox UI Library
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
local TWEEN_TIME = 0.3
local EASE_STYLE = Enum.EasingStyle.Quad
local EASE_DIRECTION = Enum.EasingDirection.Out

-- Color scheme
local COLORS = {
    Background = Color3.fromRGB(20, 20, 25),
    Secondary = Color3.fromRGB(30, 30, 35),
    Accent = Color3.fromRGB(100, 150, 255),
    AccentHover = Color3.fromRGB(120, 170, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 180),
    Success = Color3.fromRGB(80, 200, 120),
    Danger = Color3.fromRGB(255, 100, 100)
}

-- Create main GUI
function UILibrary.new(title)
    local self = setmetatable({}, UILibrary)
    
    -- Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "ModernUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = PlayerGui
    
    -- Main frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 500, 0, 400)
    self.MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    self.MainFrame.BackgroundColor3 = COLORS.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    
    -- Corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = self.MainFrame
    
    -- Drop shadow effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ZIndex = -1
    shadow.Parent = self.MainFrame
    
    -- Title bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 50)
    self.TitleBar.BackgroundColor3 = COLORS.Secondary
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = self.TitleBar
    
    -- Title text
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = title or "Modern UI"
    self.TitleLabel.TextColor3 = COLORS.Text
    self.TitleLabel.TextSize = 18
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.TitleBar
    
    -- Close button
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Size = UDim2.new(0, 30, 0, 30)
    self.CloseButton.Position = UDim2.new(1, -40, 0, 10)
    self.CloseButton.BackgroundColor3 = COLORS.Danger
    self.CloseButton.BorderSizePixel = 0
    self.CloseButton.Text = "×"
    self.CloseButton.TextColor3 = COLORS.Text
    self.CloseButton.TextSize = 16
    self.CloseButton.Font = Enum.Font.GothamBold
    self.CloseButton.Parent = self.TitleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = self.CloseButton
    
    -- Tab system
    self.TabBar = Instance.new("Frame")
    self.TabBar.Name = "TabBar"
    self.TabBar.Size = UDim2.new(1, 0, 0, 40)
    self.TabBar.Position = UDim2.new(0, 0, 0, 50)
    self.TabBar.BackgroundColor3 = COLORS.Secondary
    self.TabBar.BorderSizePixel = 0
    self.TabBar.Parent = self.MainFrame
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 2)
    tabLayout.Parent = self.TabBar
    
    -- Content area
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "Content"
    self.ContentFrame.Size = UDim2.new(1, -20, 1, -110)
    self.ContentFrame.Position = UDim2.new(0, 10, 0, 100)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.Parent = self.MainFrame
    
    -- Make draggable
    self:MakeDraggable()
    
    -- Close functionality
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Hover effects for close button
    self.CloseButton.MouseEnter:Connect(function()
        local tween = TweenService:Create(self.CloseButton, 
            TweenInfo.new(0.2, EASE_STYLE, EASE_DIRECTION), 
            {BackgroundColor3 = Color3.fromRGB(255, 120, 120)}
        )
        tween:Play()
    end)
    
    self.CloseButton.MouseLeave:Connect(function()
        local tween = TweenService:Create(self.CloseButton, 
            TweenInfo.new(0.2, EASE_STYLE, EASE_DIRECTION), 
            {BackgroundColor3 = COLORS.Danger}
        )
        tween:Play()
    end)
    
    self.Tabs = {}
    self.CurrentTab = nil
    
    return self
end

-- Make window draggable
function UILibrary:MakeDraggable()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Create tab
function UILibrary:CreateTab(name)
    local tab = {}
    tab.Name = name
    tab.Elements = {}
    
    -- Tab button
    tab.Button = Instance.new("TextButton")
    tab.Button.Name = name
    tab.Button.Size = UDim2.new(0, 100, 1, 0)
    tab.Button.BackgroundColor3 = COLORS.Secondary
    tab.Button.BorderSizePixel = 0
    tab.Button.Text = name
    tab.Button.TextColor3 = COLORS.TextSecondary
    tab.Button.TextSize = 14
    tab.Button.Font = Enum.Font.Gotham
    tab.Button.Parent = self.TabBar
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tab.Button
    
    -- Tab content
    tab.Content = Instance.new("ScrollingFrame")
    tab.Content.Name = name .. "Content"
    tab.Content.Size = UDim2.new(1, 0, 1, 0)
    tab.Content.BackgroundTransparency = 1
    tab.Content.BorderSizePixel = 0
    tab.Content.ScrollBarThickness = 6
    tab.Content.ScrollBarImageColor3 = COLORS.Accent
    tab.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.Content.Visible = false
    tab.Content.Parent = self.ContentFrame
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = tab.Content
    
    -- Auto-resize canvas
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.Content.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Tab click functionality
    tab.Button.MouseButton1Click:Connect(function()
        self:SwitchTab(name)
    end)
    
    -- Hover effects
    tab.Button.MouseEnter:Connect(function()
        if self.CurrentTab ~= name then
            local tween = TweenService:Create(tab.Button, 
                TweenInfo.new(0.2, EASE_STYLE, EASE_DIRECTION), 
                {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}
            )
            tween:Play()
        end
    end)
    
    tab.Button.MouseLeave:Connect(function()
        if self.CurrentTab ~= name then
            local tween = TweenService:Create(tab.Button, 
                TweenInfo.new(0.2, EASE_STYLE, EASE_DIRECTION), 
                {BackgroundColor3 = COLORS.Secondary}
            )
            tween:Play()
        end
    end)
    
    self.Tabs[name] = tab
    
    -- Auto-select first tab
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
            tab.Button.BackgroundColor3 = COLORS.Secondary
            tab.Button.TextColor3 = COLORS.TextSecondary
        end
    end
    self.CurrentTab = tabName
end

-- Add Toggle
function UILibrary:AddToggle(tab, text, default, callback)
    local toggle = Instance.new("Frame")
    toggle.Name = "Toggle"
    toggle.Size = UDim2.new(1, 0, 0, 45)
    toggle.BackgroundColor3 = COLORS.Secondary
    toggle.BorderSizePixel = 0
    toggle.Parent = tab.Content
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggle
    
    -- Toggle label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = COLORS.Text
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggle
    
    -- Toggle switch background
    local switchBg = Instance.new("Frame")
    switchBg.Name = "SwitchBg"
    switchBg.Size = UDim2.new(0, 45, 0, 25)
    switchBg.Position = UDim2.new(1, -60, 0.5, -12.5)
    switchBg.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    switchBg.BorderSizePixel = 0
    switchBg.Parent = toggle
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(0, 12.5)
    switchCorner.Parent = switchBg
    
    -- Toggle switch circle
    local switchCircle = Instance.new("Frame")
    switchCircle.Name = "SwitchCircle"
    switchCircle.Size = UDim2.new(0, 21, 0, 21)
    switchCircle.Position = UDim2.new(0, 2, 0, 2)
    switchCircle.BackgroundColor3 = COLORS.Text
    switchCircle.BorderSizePixel = 0
    switchCircle.Parent = switchBg
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0, 10.5)
    circleCorner.Parent = switchCircle
    
    -- Toggle state
    local isToggled = default or false
    
    -- Update visual state
    local function updateToggle()
        local bgColor = isToggled and COLORS.Accent or Color3.fromRGB(60, 60, 65)
        local circlePos = isToggled and UDim2.new(1, -23, 0, 2) or UDim2.new(0, 2, 0, 2)
        
        local bgTween = TweenService:Create(switchBg, 
            TweenInfo.new(TWEEN_TIME, EASE_STYLE, EASE_DIRECTION), 
            {BackgroundColor3 = bgColor}
        )
        
        local circleTween = TweenService:Create(switchCircle, 
            TweenInfo.new(TWEEN_TIME, EASE_STYLE, EASE_DIRECTION), 
            {Position = circlePos}
        )
        
        bgTween:Play()
        circleTween:Play()
    end
    
    -- Initial state
    updateToggle()
    
    -- Click functionality
    local clickDetector = Instance.new("TextButton")
    clickDetector.Size = UDim2.new(1, 0, 1, 0)
    clickDetector.BackgroundTransparency = 1
    clickDetector.Text = ""
    clickDetector.Parent = toggle
    
    clickDetector.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        updateToggle()
        if callback then
            callback(isToggled)
        end
    end)
    
    -- Hover effects
    clickDetector.MouseEnter:Connect(function()
        local tween = TweenService:Create(toggle, 
            TweenInfo.new(0.2, EASE_STYLE, EASE_DIRECTION), 
            {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}
        )
        tween:Play()
    end)
    
    clickDetector.MouseLeave:Connect(function()
        local tween = TweenService:Create(toggle, 
            TweenInfo.new(0.2, EASE_STYLE, EASE_DIRECTION), 
            {BackgroundColor3 = COLORS.Secondary}
        )
        tween:Play()
    end)
    
    return {
        Toggle = function(state)
            isToggled = state
            updateToggle()
        end,
        GetState = function()
            return isToggled
        end
    }
end

-- Add Slider
function UILibrary:AddSlider(tab, text, min, max, default, callback)
    local slider = Instance.new("Frame")
    slider.Name = "Slider"
    slider.Size = UDim2.new(1, 0, 0, 65)
    slider.BackgroundColor3 = COLORS.Secondary
    slider.BorderSizePixel = 0
    slider.Parent = tab.Content
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 8)
    sliderCorner.Parent = slider
    
    -- Slider label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -15, 0, 25)
    label.Position = UDim2.new(0, 15, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = COLORS.Text
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = slider
    
    -- Value label
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.Size = UDim2.new(0, 60, 0, 25)
    valueLabel.Position = UDim2.new(1, -75, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default or min)
    valueLabel.TextColor3 = COLORS.Accent
    valueLabel.TextSize = 14
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = slider
    
    -- Slider track
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(1, -30, 0, 6)
    track.Position = UDim2.new(0, 15, 1, -20)
    track.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    track.BorderSizePixel = 0
    track.Parent = slider
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 3)
    trackCorner.Parent = track
    
    -- Slider fill
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = COLORS.Accent
    fill.BorderSizePixel = 0
    fill.Parent = track
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill
    
    -- Slider handle
    local handle = Instance.new("Frame")
    handle.Name = "Handle"
    handle.Size = UDim2.new(0, 16, 0, 16)
    handle.Position = UDim2.new(0, -8, 0.5, -8)
    handle.BackgroundColor3 = COLORS.Text
    handle.BorderSizePixel = 0
    handle.Parent = track
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0, 8)
    handleCorner.Parent = handle
    
    -- Slider logic
    local currentValue = default or min
    local dragging = false
    
    local function updateSlider(value)
        value = math.clamp(value, min, max)
        currentValue = value
        valueLabel.Text = tostring(math.round(value))
        
        local percentage = (value - min) / (max - min)
        fill.Size = UDim2.new(percentage, 0, 1, 0)
        handle.Position = UDim2.new(percentage, -8, 0.5, -8)
        
        if callback then
            callback(value)
        end
    end
    
    -- Initial update
    updateSlider(currentValue)
    
    -- Mouse input
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local trackStart = track.AbsolutePosition.X
            local trackWidth = track.AbsoluteSize.X
            local mouseX = input.Position.X
            local percentage = math.clamp((mouseX - trackStart) / trackWidth, 0, 1)
            local value = min + (max - min) * percentage
            updateSlider(value)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local trackStart = track.AbsolutePosition.X
            local trackWidth = track.AbsoluteSize.X
            local mouseX = input.Position.X
            local percentage = math.clamp((mouseX - trackStart) / trackWidth, 0, 1)
            local value = min + (max - min) * percentage
            updateSlider(value)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return {
        SetValue = function(value)
            updateSlider(value)
        end,
        GetValue = function()
            return currentValue
        end
    }
end

-- Add Button
function UILibrary:AddButton(tab, text, callback)
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = COLORS.Accent
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = COLORS.Text
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = tab.Content
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    -- Click functionality
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
        
        -- Click animation
        local originalSize = button.Size
        local tween1 = TweenService:Create(button, 
            TweenInfo.new(0.1, EASE_STYLE, EASE_DIRECTION), 
            {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, originalSize.Y.Scale, originalSize.Y.Offset - 2)}
        )
        tween1:Play()
        
        tween1.Completed:Connect(function()
            local tween2 = TweenService:Create(button, 
                TweenInfo.new(0.1, EASE_STYLE, EASE_DIRECTION), 
                {Size = originalSize}
            )
            tween2:Play()
        end)
    end)
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, 
            TweenInfo.new(0.2, EASE_STYLE, EASE_DIRECTION), 
            {BackgroundColor3 = COLORS.AccentHover}
        )
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, 
            TweenInfo.new(0.2, EASE_STYLE, EASE_DIRECTION), 
            {BackgroundColor3 = COLORS.Accent}
        )
        tween:Play()
    end)
end

-- Destroy UI
function UILibrary:Destroy()
    local tween = TweenService:Create(self.MainFrame, 
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
        {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}
    )
    tween:Play()
    
    tween.Completed:Connect(function()
        self.ScreenGui:Destroy()
    end)
end

-- Example usage:
--[[
local UI = UILibrary.new("My Modern UI")

local Tab1 = UI:CreateTab("Main")
local Tab2 = UI:CreateTab("Settings")

UI:AddToggle(Tab1, "Enable Feature", false, function(state)
    print("Toggle:", state)
end)

UI:AddSlider(Tab1, "Speed", 1, 100, 50, function(value)
    print("Slider:", value)
end)

UI:AddButton(Tab1, "Click Me!", function()
    print("Button clicked!")
end)

UI:AddToggle(Tab2, "Auto Save", true, function(state)
    print("Auto Save:", state)
end)
--]]

return UILibrary
