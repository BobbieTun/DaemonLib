--// DaemonUI - Modified Fluent Interface
--// Author: Modified from Fluent by dawid
--// Features: Neon glow, Row layout, Themes, Smooth animations

local DaemonUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Themes = {
    PurpleNeon = {
        Name = "PurpleNeon",
        Background = Color3.fromRGB(10, 5, 20),
        BackgroundSecondary = Color3.fromRGB(18, 10, 35),
        Accent = Color3.fromRGB(170, 0, 255),
        AccentGlow = Color3.fromRGB(200, 50, 255),
        Text = Color3.fromRGB(240, 240, 255),
        SubText = Color3.fromRGB(160, 140, 200),
        Element = Color3.fromRGB(25, 15, 45),
        ElementHover = Color3.fromRGB(40, 25, 70),
        Border = Color3.fromRGB(60, 30, 100),
        Glow = Color3.fromRGB(170, 0, 255),
        ToggleOn = Color3.fromRGB(170, 0, 255),
        ToggleOff = Color3.fromRGB(40, 30, 60),
        Slider = Color3.fromRGB(170, 0, 255),
        TitleBar = Color3.fromRGB(15, 8, 30),
        TabSelected = Color3.fromRGB(30, 15, 60),
        TabUnselected = Color3.fromRGB(20, 10, 40),
    },
    RedNeon = {
        Name = "RedNeon",
        Background = Color3.fromRGB(20, 5, 5),
        BackgroundSecondary = Color3.fromRGB(35, 10, 10),
        Accent = Color3.fromRGB(255, 20, 60),
        AccentGlow = Color3.fromRGB(255, 80, 100),
        Text = Color3.fromRGB(255, 240, 240),
        SubText = Color3.fromRGB(200, 140, 140),
        Element = Color3.fromRGB(45, 15, 15),
        ElementHover = Color3.fromRGB(70, 25, 25),
        Border = Color3.fromRGB(100, 30, 30),
        Glow = Color3.fromRGB(255, 20, 60),
        ToggleOn = Color3.fromRGB(255, 20, 60),
        ToggleOff = Color3.fromRGB(60, 30, 30),
        Slider = Color3.fromRGB(255, 20, 60),
        TitleBar = Color3.fromRGB(30, 8, 8),
        TabSelected = Color3.fromRGB(60, 15, 15),
        TabUnselected = Color3.fromRGB(40, 10, 10),
    },
    WhiteBlack = {
        Name = "WhiteBlack",
        Background = Color3.fromRGB(10, 10, 10),
        BackgroundSecondary = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(255, 255, 255),
        AccentGlow = Color3.fromRGB(200, 200, 200),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(150, 150, 150),
        Element = Color3.fromRGB(25, 25, 25),
        ElementHover = Color3.fromRGB(45, 45, 45),
        Border = Color3.fromRGB(80, 80, 80),
        Glow = Color3.fromRGB(255, 255, 255),
        ToggleOn = Color3.fromRGB(255, 255, 255),
        ToggleOff = Color3.fromRGB(50, 50, 50),
        Slider = Color3.fromRGB(255, 255, 255),
        TitleBar = Color3.fromRGB(15, 15, 15),
        TabSelected = Color3.fromRGB(40, 40, 40),
        TabUnselected = Color3.fromRGB(25, 25, 25),
    },
    YellowBlack = {
        Name = "YellowBlack",
        Background = Color3.fromRGB(12, 12, 5),
        BackgroundSecondary = Color3.fromRGB(22, 22, 10),
        Accent = Color3.fromRGB(255, 215, 0),
        AccentGlow = Color3.fromRGB(255, 235, 80),
        Text = Color3.fromRGB(255, 250, 220),
        SubText = Color3.fromRGB(200, 190, 140),
        Element = Color3.fromRGB(30, 28, 15),
        ElementHover = Color3.fromRGB(50, 45, 20),
        Border = Color3.fromRGB(100, 90, 30),
        Glow = Color3.fromRGB(255, 215, 0),
        ToggleOn = Color3.fromRGB(255, 215, 0),
        ToggleOff = Color3.fromRGB(50, 45, 25),
        Slider = Color3.fromRGB(255, 215, 0),
        TitleBar = Color3.fromRGB(18, 16, 8),
        TabSelected = Color3.fromRGB(45, 40, 15),
        TabUnselected = Color3.fromRGB(28, 25, 12),
    },
    WhiteYellow = {
        Name = "WhiteYellow",
        Background = Color3.fromRGB(245, 245, 235),
        BackgroundSecondary = Color3.fromRGB(255, 255, 245),
        Accent = Color3.fromRGB(255, 180, 0),
        AccentGlow = Color3.fromRGB(255, 200, 50),
        Text = Color3.fromRGB(40, 40, 30),
        SubText = Color3.fromRGB(100, 100, 80),
        Element = Color3.fromRGB(235, 235, 220),
        ElementHover = Color3.fromRGB(220, 220, 200),
        Border = Color3.fromRGB(200, 190, 160),
        Glow = Color3.fromRGB(255, 180, 0),
        ToggleOn = Color3.fromRGB(255, 180, 0),
        ToggleOff = Color3.fromRGB(180, 180, 160),
        Slider = Color3.fromRGB(255, 180, 0),
        TitleBar = Color3.fromRGB(240, 240, 230),
        TabSelected = Color3.fromRGB(255, 245, 210),
        TabUnselected = Color3.fromRGB(250, 250, 240),
    }
}

--// Utility
local function Create(className, properties, children)
    local instance = Instance.new(className)
    if properties then
        for prop, value in pairs(properties) do
            instance[prop] = value
        end
    end
    if children then
        for _, child in pairs(children) do
            child.Parent = instance
        end
    end
    return instance
end

local function Tween(instance, properties, duration, easingStyle, easingDirection, callback)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration or 0.3, easingStyle or Enum.EasingStyle.Quart, easingDirection or Enum.EasingDirection.Out),
        properties
    )
    if callback then
        tween.Completed:Connect(callback)
    end
    tween:Play()
    return tween
end

local function ApplyGlow(frame, color, thickness)
    local stroke = Create("UIStroke", {
        Color = color or Color3.fromRGB(170, 0, 255),
        Thickness = thickness or 1.5,
        Transparency = 0.6,
    })
    stroke.Parent = frame

    local glow = Create("UIStroke", {
        Color = color or Color3.fromRGB(170, 0, 255),
        Thickness = thickness and thickness * 3 or 4,
        Transparency = 0.9,
    })
    glow.Parent = frame

    return stroke, glow
end

--// Main Library
DaemonUI.Version = "2.0.0"
DaemonUI.Theme = "PurpleNeon"
DaemonUI.Window = nil
DaemonUI.GUI = nil
DaemonUI.Elements = {}

function DaemonUI:SetTheme(themeName)
    if Themes[themeName] then
        self.Theme = themeName
        self:UpdateTheme()
    end
end

function DaemonUI:GetTheme()
    return Themes[self.Theme]
end

function DaemonUI:UpdateTheme()
    -- This will be called to update all elements when theme changes
    -- Implementation handled per element
end

function DaemonUI:CreateWindow(config)
    config = config or {}
    assert(config.Title, "Window - Missing Title")

    if self.Window then
        warn("You can only create one window!")
        return self.Window
    end

    local theme = self:GetTheme()

    -- ScreenGui
    local screenGui = Create("ScreenGui", {
        Name = "DaemonUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = game:GetService("CoreGui"),
    })
    self.GUI = screenGui

    -- Main Window Frame
    local mainFrame = Create("Frame", {
        Name = "MainWindow",
        Size = config.Size or UDim2.new(0, 600, 0, 400),
        Position = UDim2.new(0.5, -300, 0.5, -200),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        Parent = screenGui,
    })

    Create("UICorner", {CornerRadius = UDim.new(0, 10)}).Parent = mainFrame
    ApplyGlow(mainFrame, theme.Glow, 2)

    -- Shadow
    local shadow = Create("ImageLabel", {
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        ZIndex = -1,
        Parent = mainFrame,
    })

    -- Title Bar
    local titleBar = Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = theme.TitleBar,
        BorderSizePixel = 0,
        Parent = mainFrame,
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 10)}).Parent = titleBar

    local titleBarFix = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = theme.TitleBar,
        BorderSizePixel = 0,
        Parent = titleBar,
    })

    -- Icon
    if config.Icon then
        local icon = Create("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 22, 0, 22),
            Position = UDim2.new(0, 15, 0.5, -11),
            BackgroundTransparency = 1,
            Image = config.Icon,
            ImageColor3 = theme.Accent,
            Parent = titleBar,
        })
    end

    -- Title
    local titleLabel = Create("TextLabel", {
        Name = "Title",
        Text = config.Title,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 200, 1, 0),
        Position = config.Icon and UDim2.new(0, 45, 0, 0) or UDim2.new(0, 15, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar,
    })

    -- SubTitle
    if config.SubTitle then
        local subTitle = Create("TextLabel", {
            Name = "SubTitle",
            Text = config.SubTitle,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextColor3 = theme.SubText,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 200, 0, 20),
            Position = UDim2.new(0, config.Icon and 45 or 15, 0, 25),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = titleBar,
        })
    end

    -- Close Button
    local closeBtn = Create("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -38, 0.5, -15),
        BackgroundColor3 = theme.Element,
        Text = "X",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = theme.Text,
        Parent = titleBar,
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 6)}).Parent = closeBtn

    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}, 0.2)
    end)
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, {BackgroundColor3 = theme.Element}, 0.2)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        Tween(mainFrame, {Size = UDim2.new(0, mainFrame.AbsoluteSize.X, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In, function()
            screenGui:Destroy()
            self.Window = nil
        end)
    end)

    -- Minimize Button
    local minBtn = Create("TextButton", {
        Name = "Minimize",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -73, 0.5, -15),
        BackgroundColor3 = theme.Element,
        Text = "-",
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = theme.Text,
        Parent = titleBar,
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 6)}).Parent = minBtn

    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(mainFrame, {Size = UDim2.new(0, mainFrame.AbsoluteSize.X, 0, 45)}, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        else
            Tween(mainFrame, {Size = config.Size or UDim2.new(0, 600, 0, 400)}, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        end
    end)

    -- Tab Holder
    local tabHolder = Create("Frame", {
        Name = "TabHolder",
        Size = UDim2.new(0, 140, 1, -55),
        Position = UDim2.new(0, 8, 0, 50),
        BackgroundColor3 = theme.BackgroundSecondary,
        BorderSizePixel = 0,
        Parent = mainFrame,
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8)}).Parent = tabHolder

    local tabList = Create("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabHolder,
    })

    local tabPadding = Create("UIPadding", {
        PaddingTop = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6),
        PaddingBottom = UDim.new(0, 6),
        Parent = tabHolder,
    })

    -- Content Holder
    local contentHolder = Create("Frame", {
        Name = "ContentHolder",
        Size = UDim2.new(1, -160, 1, -55),
        Position = UDim2.new(0, 152, 0, 50),
        BackgroundColor3 = theme.BackgroundSecondary,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = mainFrame,
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8)}).Parent = contentHolder

    -- Dragging
    local dragging = false
    local dragStart = nil
    local startPos = nil

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Window Object
    local window = {
        Frame = mainFrame,
        TabHolder = tabHolder,
        ContentHolder = contentHolder,
        Tabs = {},
        ActiveTab = nil,
        Theme = self.Theme,
    }

    function window:AddTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Title or "Tab"
        local tabIcon = tabConfig.Icon
        local tabId = #self.Tabs + 1

        local t = theme

        -- Tab Button
        local tabBtn = Create("TextButton", {
            Name = tabName,
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = t.TabUnselected,
            Text = "",
            LayoutOrder = tabId,
            Parent = tabHolder,
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6)}).Parent = tabBtn

        local tabBtnStroke = Create("UIStroke", {
            Color = t.Border,
            Thickness = 1,
            Transparency = 0.8,
            Parent = tabBtn,
        })

        if tabIcon then
            local icon = Create("ImageLabel", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 8, 0.5, -8),
                BackgroundTransparency = 1,
                Image = tabIcon,
                ImageColor3 = t.SubText,
                Parent = tabBtn,
            })
        end

        local tabText = Create("TextLabel", {
            Text = tabName,
            Font = Enum.Font.GothamSemibold,
            TextSize = 13,
            TextColor3 = t.SubText,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, tabIcon and -30 or -12, 1, 0),
            Position = tabIcon and UDim2.new(0, 30, 0, 0) or UDim2.new(0, 10, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabBtn,
        })

        -- Tab Content
        local tabContent = Create("ScrollingFrame", {
            Name = tabName.."Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = t.Accent,
            ScrollBarImageTransparency = 0.8,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = contentHolder,
        })

        local contentList = Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tabContent,
        })

        Create("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            Parent = tabContent,
        })

        contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 20)
        end)

        -- Tab Selection Logic
        local function selectTab()
            if self.ActiveTab == tabId then return end

            -- Deselect all
            for _, tab in pairs(self.Tabs) do
                Tween(tab.Button, {BackgroundColor3 = t.TabUnselected}, 0.2)
                tab.Text.TextColor3 = t.SubText
                tab.Content.Visible = false
                if tab.Indicator then
                    Tween(tab.Indicator, {BackgroundTransparency = 1}, 0.2)
                end
            end

            -- Select this
            self.ActiveTab = tabId
            Tween(tabBtn, {BackgroundColor3 = t.TabSelected}, 0.2)
            tabText.TextColor3 = t.Text
            tabContent.Visible = true

            -- Entrance animation
            tabContent.Position = UDim2.new(0, 20, 0, 0)
            Tween(tabContent, {Position = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        end

        tabBtn.MouseButton1Click:Connect(selectTab)

        tabBtn.MouseEnter:Connect(function()
            if self.ActiveTab ~= tabId then
                Tween(tabBtn, {BackgroundColor3 = t.ElementHover}, 0.2)
            end
        end)

        tabBtn.MouseLeave:Connect(function()
            if self.ActiveTab ~= tabId then
                Tween(tabBtn, {BackgroundColor3 = t.TabUnselected}, 0.2)
            end
        end)

        local tabObj = {
            Id = tabId,
            Name = tabName,
            Button = tabBtn,
            Text = tabText,
            Content = tabContent,
            Elements = {},
        }

        -- Row System
        function tabObj:AddRow(columns)
            columns = columns or 1
            if columns > 2 then columns = 2 end

            local rowFrame = Create("Frame", {
                Name = "Row",
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = #self.Elements + 1,
                Parent = tabContent,
            })

            local layout = Create("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, 8),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Top,
                Parent = rowFrame,
            })

            local rowObj = {
                Frame = rowFrame,
                Columns = columns,
                Elements = {},
            }

            function rowObj:AddToggle(config)
                config = config or {}
                local toggleTheme = DaemonUI:GetTheme()

                local container = Create("Frame", {
                    Size = columns == 2 and UDim2.new(0.5, -4, 0, 40) or UDim2.new(1, 0, 0, 40),
                    BackgroundColor3 = toggleTheme.Element,
                    BorderSizePixel = 0,
                    Parent = rowFrame,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 6)}).Parent = container
                ApplyGlow(container, toggleTheme.Glow, 1)

                local label = Create("TextLabel", {
                    Text = config.Title or "Toggle",
                    Font = Enum.Font.GothamSemibold,
                    TextSize = 13,
                    TextColor3 = toggleTheme.Text,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -60, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = container,
                })

                -- Toggle Switch
                local switchBg = Create("Frame", {
                    Size = UDim2.new(0, 40, 0, 22),
                    Position = UDim2.new(1, -50, 0.5, -11),
                    BackgroundColor3 = toggleTheme.ToggleOff,
                    BorderSizePixel = 0,
                    Parent = container,
                })
                Create("UICorner", {CornerRadius = UDim.new(1, 0)}).Parent = switchBg

                local switchKnob = Create("Frame", {
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = UDim2.new(0, 2, 0.5, -9),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    Parent = switchBg,
                })
                Create("UICorner", {CornerRadius = UDim.new(1, 0)}).Parent = switchKnob

                -- Glow effect for knob
                local knobGlow = Create("UIStroke", {
                    Color = toggleTheme.AccentGlow,
                    Thickness = 2,
                    Transparency = 0.8,
                    Parent = switchKnob,
                })

                local value = config.Default or false

                local toggleObj = {
                    Value = value,
                    Frame = container,
                    Set = function(self, newValue)
                        self.Value = newValue
                        local currentTheme = DaemonUI:GetTheme()
                        if newValue then
                            Tween(switchBg, {BackgroundColor3 = currentTheme.ToggleOn}, 0.25)
                            Tween(switchKnob, {Position = UDim2.new(0, 20, 0.5, -9)}, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                            Tween(knobGlow, {Transparency = 0.3}, 0.25)
                            container.BackgroundColor3 = currentTheme.ElementHover
                        else
                            Tween(switchBg, {BackgroundColor3 = currentTheme.ToggleOff}, 0.25)
                            Tween(switchKnob, {Position = UDim2.new(0, 2, 0.5, -9)}, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                            Tween(knobGlow, {Transparency = 0.8}, 0.25)
                            container.BackgroundColor3 = currentTheme.Element
                        end
                        if config.Callback then
                            config.Callback(newValue)
                        end
                    end,
                    Get = function(self)
                        return self.Value
                    end,
                }

                -- Initial set
                toggleObj:Set(value)

                container.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        toggleObj:Set(not toggleObj.Value)
                    end
                end)

                container.MouseEnter:Connect(function()
                    local ct = DaemonUI:GetTheme()
                    Tween(container, {BackgroundColor3 = toggleObj.Value and ct.ElementHover or ct.ElementHover}, 0.2)
                end)

                container.MouseLeave:Connect(function()
                    local ct = DaemonUI:GetTheme()
                    Tween(container, {BackgroundColor3 = toggleObj.Value and ct.ElementHover or ct.Element}, 0.2)
                end)

                table.insert(self.Elements, toggleObj)
                return toggleObj
            end

            function rowObj:AddLabel(config)
                config = config or {}
                local labelTheme = DaemonUI:GetTheme()

                local container = Create("Frame", {
                    Size = columns == 2 and UDim2.new(0.5, -4, 0, 40) or UDim2.new(1, 0, 0, 40),
                    BackgroundColor3 = labelTheme.Element,
                    BorderSizePixel = 0,
                    Parent = rowFrame,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 6)}).Parent = container
                ApplyGlow(container, labelTheme.Glow, 1)

                local title = Create("TextLabel", {
                    Text = config.Title or "Label",
                    Font = Enum.Font.GothamSemibold,
                    TextSize = 13,
                    TextColor3 = labelTheme.Text,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -20, 0, 20),
                    Position = UDim2.new(0, 12, 0, 4),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = container,
                })

                local desc = Create("TextLabel", {
                    Text = config.Content or "",
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextColor3 = labelTheme.SubText,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -20, 0, 16),
                    Position = UDim2.new(0, 12, 0, 22),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = container,
                })

                local labelObj = {
                    Frame = container,
                    Title = title,
                    Desc = desc,
                    SetTitle = function(self, text)
                        self.Title.Text = text
                    end,
                    SetContent = function(self, text)
                        self.Desc.Text = text
                    end,
                }

                table.insert(self.Elements, labelObj)
                return labelObj
            end

            function rowObj:AddButton(config)
                config = config or {}
                local btnTheme = DaemonUI:GetTheme()

                local container = Create("TextButton", {
                    Size = columns == 2 and UDim2.new(0.5, -4, 0, 40) or UDim2.new(1, 0, 0, 40),
                    BackgroundColor3 = btnTheme.Accent,
                    Text = config.Title or "Button",
                    Font = Enum.Font.GothamBold,
                    TextSize = 13,
                    TextColor3 = Color3.new(1,1,1),
                    BorderSizePixel = 0,
                    Parent = rowFrame,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 6)}).Parent = container
                ApplyGlow(container, btnTheme.AccentGlow, 2)

                container.MouseEnter:Connect(function()
                    local ct = DaemonUI:GetTheme()
                    Tween(container, {BackgroundColor3 = ct.AccentGlow, Size = UDim2.new(
                        container.Size.X.Scale, container.Size.X.Offset + 2,
                        container.Size.Y.Scale, container.Size.Y.Offset + 2
                    )}, 0.15)
                end)

                container.MouseLeave:Connect(function()
                    local ct = DaemonUI:GetTheme()
                    Tween(container, {BackgroundColor3 = ct.Accent, Size = UDim2.new(
                        container.Size.X.Scale, container.Size.X.Offset - 2,
                        container.Size.Y.Scale, container.Size.Y.Offset - 2
                    )}, 0.15)
                end)

                container.MouseButton1Down:Connect(function()
                    Tween(container, {Size = UDim2.new(
                        container.Size.X.Scale, container.Size.X.Offset - 4,
                        container.Size.Y.Scale, container.Size.Y.Offset - 4
                    )}, 0.1)
                end)

                container.MouseButton1Up:Connect(function()
                    Tween(container, {Size = UDim2.new(
                        container.Size.X.Scale, container.Size.X.Offset + 4,
                        container.Size.Y.Scale, container.Size.Y.Offset + 4
                    )}, 0.1)
                    if config.Callback then
                        config.Callback()
                    end
                end)

                local btnObj = {
                    Frame = container,
                    SetTitle = function(self, text)
                        self.Frame.Text = text
                    end,
                }

                table.insert(self.Elements, btnObj)
                return btnObj
            end

            function rowObj:AddSlider(config)
                config = config or {}
                local sliderTheme = DaemonUI:GetTheme()

                local container = Create("Frame", {
                    Size = columns == 2 and UDim2.new(0.5, -4, 0, 50) or UDim2.new(1, 0, 0, 50),
                    BackgroundColor3 = sliderTheme.Element,
                    BorderSizePixel = 0,
                    Parent = rowFrame,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 6)}).Parent = container
                ApplyGlow(container, sliderTheme.Glow, 1)

                local title = Create("TextLabel", {
                    Text = config.Title or "Slider",
                    Font = Enum.Font.GothamSemibold,
                    TextSize = 13,
                    TextColor3 = sliderTheme.Text,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -80, 0, 20),
                    Position = UDim2.new(0, 12, 0, 4),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = container,
                })

                local valueLabel = Create("TextLabel", {
                    Text = tostring(config.Default or config.Min or 0),
                    Font = Enum.Font.GothamBold,
                    TextSize = 12,
                    TextColor3 = sliderTheme.Accent,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 50, 0, 20),
                    Position = UDim2.new(1, -60, 0, 4),
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = container,
                })

                -- Rail
                local rail = Create("Frame", {
                    Size = UDim2.new(1, -24, 0, 6),
                    Position = UDim2.new(0, 12, 0, 32),
                    BackgroundColor3 = sliderTheme.ToggleOff,
                    BorderSizePixel = 0,
                    Parent = container,
                })
                Create("UICorner", {CornerRadius = UDim.new(1, 0)}).Parent = rail

                -- Fill
                local fill = Create("Frame", {
                    Size = UDim2.new(0, 0, 1, 0),
                    BackgroundColor3 = sliderTheme.Slider,
                    BorderSizePixel = 0,
                    Parent = rail,
                })
                Create("UICorner", {CornerRadius = UDim.new(1, 0)}).Parent = fill

                -- Knob
                local knob = Create("Frame", {
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new(0, -7, 0.5, -7),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    Parent = fill,
                })
                Create("UICorner", {CornerRadius = UDim.new(1, 0)}).Parent = knob

                local knobGlow = Create("UIStroke", {
                    Color = sliderTheme.AccentGlow,
                    Thickness = 2,
                    Transparency = 0.5,
                    Parent = knob,
                })

                local min = config.Min or 0
                local max = config.Max or 100
                local value = config.Default or min
                local dragging = false

                local function updateSlider(input)
                    local pos = math.clamp((input.Position.X - rail.AbsolutePosition.X) / rail.AbsoluteSize.X, 0, 1)
                    local newValue = min + (max - min) * pos
                    if config.Rounding then
                        newValue = math.floor(newValue * (10 ^ config.Rounding) + 0.5) / (10 ^ config.Rounding)
                    else
                        newValue = math.floor(newValue + 0.5)
                    end
                    value = newValue
                    valueLabel.Text = tostring(newValue)
                    fill.Size = UDim2.new(pos, 0, 1, 0)
                    if config.Callback then
                        config.Callback(newValue)
                    end
                end

                knob.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                    end
                end)

                rail.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        updateSlider(input)
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateSlider(input)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                -- Init
                local initPos = (value - min) / (max - min)
                fill.Size = UDim2.new(initPos, 0, 1, 0)
                valueLabel.Text = tostring(value)

                local sliderObj = {
                    Value = value,
                    Frame = container,
                    Set = function(self, newValue)
                        newValue = math.clamp(newValue, min, max)
                        if config.Rounding then
                            newValue = math.floor(newValue * (10 ^ config.Rounding) + 0.5) / (10 ^ config.Rounding)
                        else
                            newValue = math.floor(newValue + 0.5)
                        end
                        self.Value = newValue
                        valueLabel.Text = tostring(newValue)
                        local pos = (newValue - min) / (max - min)
                        Tween(fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.2)
                        if config.Callback then
                            config.Callback(newValue)
                        end
                    end,
                    Get = function(self)
                        return self.Value
                    end,
                }

                table.insert(self.Elements, sliderObj)
                return sliderObj
            end

            function rowObj:AddDropdown(config)
                config = config or {}
                local ddTheme = DaemonUI:GetTheme()

                local container = Create("Frame", {
                    Size = columns == 2 and UDim2.new(0.5, -4, 0, 40) or UDim2.new(1, 0, 0, 40),
                    BackgroundColor3 = ddTheme.Element,
                    BorderSizePixel = 0,
                    Parent = rowFrame,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 6)}).Parent = container
                ApplyGlow(container, ddTheme.Glow, 1)

                local label = Create("TextLabel", {
                    Text = config.Title or "Dropdown",
                    Font = Enum.Font.GothamSemibold,
                    TextSize = 13,
                    TextColor3 = ddTheme.Text,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -20, 0, 20),
                    Position = UDim2.new(0, 12, 0, 2),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = container,
                })

                local ddBtn = Create("TextButton", {
                    Size = UDim2.new(1, -20, 0, 22),
                    Position = UDim2.new(0, 10, 0, 18),
                    BackgroundColor3 = ddTheme.BackgroundSecondary,
                    Text = config.Default or (config.Values and config.Values[1]) or "Select...",
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextColor3 = ddTheme.Text,
                    BorderSizePixel = 0,
                    Parent = container,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 4)}).Parent = ddBtn

                local arrow = Create("ImageLabel", {
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new(1, -20, 0.5, -7),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://10709790948",
                    ImageColor3 = ddTheme.SubText,
                    Parent = ddBtn,
                })

                local dropdownFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 1, 4),
                    BackgroundColor3 = ddTheme.BackgroundSecondary,
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    Visible = false,
                    ZIndex = 10,
                    Parent = ddBtn,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 6)}).Parent = dropdownFrame
                ApplyGlow(dropdownFrame, ddTheme.Glow, 1)

                local ddList = Create("UIListLayout", {
                    Padding = UDim.new(0, 2),
                    Parent = dropdownFrame,
                })

                Create("UIPadding", {
                    PaddingTop = UDim.new(0, 4),
                    PaddingBottom = UDim.new(0, 4),
                    Parent = dropdownFrame,
                })

                local selected = config.Default or (config.Values and config.Values[1]) or ""
                local opened = false

                local function buildOptions()
                    for _, child in pairs(dropdownFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end

                    if config.Values then
                        for _, val in pairs(config.Values) do
                            local opt = Create("TextButton", {
                                Size = UDim2.new(1, -8, 0, 28),
                                Position = UDim2.new(0, 4, 0, 0),
                                BackgroundColor3 = ddTheme.Element,
                                Text = val,
                                Font = Enum.Font.Gotham,
                                TextSize = 12,
                                TextColor3 = ddTheme.Text,
                                BorderSizePixel = 0,
                                Parent = dropdownFrame,
                            })
                            Create("UICorner", {CornerRadius = UDim.new(0, 4)}).Parent = opt

                            opt.MouseEnter:Connect(function()
                                Tween(opt, {BackgroundColor3 = ddTheme.ElementHover}, 0.15)
                            end)

                            opt.MouseLeave:Connect(function()
                                Tween(opt, {BackgroundColor3 = ddTheme.Element}, 0.15)
                            end)

                            opt.MouseButton1Click:Connect(function()
                                selected = val
                                ddBtn.Text = val
                                opened = false
                                Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, function()
                                    dropdownFrame.Visible = false
                                end)
                                Tween(arrow, {Rotation = 0}, 0.2)
                                if config.Callback then
                                    config.Callback(val)
                                end
                            end)
                        end
                    end
                end

                buildOptions()

                ddBtn.MouseButton1Click:Connect(function()
                    opened = not opened
                    if opened then
                        dropdownFrame.Visible = true
                        local count = #dropdownFrame:GetChildren() - 2
                        local height = math.min(count * 30 + 8, 150)
                        Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, height)}, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                        Tween(arrow, {Rotation = 180}, 0.2)
                    else
                        Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, function()
                            dropdownFrame.Visible = false
                        end)
                        Tween(arrow, {Rotation = 0}, 0.2)
                    end
                end)

                local ddObj = {
                    Value = selected,
                    Frame = container,
                    Set = function(self, newValue)
                        if config.Values and table.find(config.Values, newValue) then
                            selected = newValue
                            ddBtn.Text = newValue
                            if config.Callback then
                                config.Callback(newValue)
                            end
                        end
                    end,
                    Get = function(self)
                        return selected
                    end,
                    Refresh = function(self, newValues)
                        config.Values = newValues
                        buildOptions()
                    end,
                }

                table.insert(self.Elements, ddObj)
                return ddObj
            end

            table.insert(self.Elements, rowObj)
            return rowObj
        end

        -- Select first tab by default
        if tabId == 1 then
            task.delay(0.1, selectTab)
        end

        table.insert(self.Tabs, tabObj)
        return tabObj
    end

    -- Entrance Animation
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.BackgroundTransparency = 1
    Tween(mainFrame, {Size = config.Size or UDim2.new(0, 600, 0, 400), BackgroundTransparency = 0}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    self.Window = window
    return window
end

function DaemonUI:Notify(config)
    config = config or {}
    local theme = self:GetTheme()

    local holder = self.GUI:FindFirstChild("NotificationHolder")
    if not holder then
        holder = Create("Frame", {
            Name = "NotificationHolder",
            Size = UDim2.new(0, 320, 1, -20),
            Position = UDim2.new(1, -330, 0, 10),
            BackgroundTransparency = 1,
            Parent = self.GUI,
        })

        Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Parent = holder,
        })
    end

    local notif = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundColor3 = theme.BackgroundSecondary,
        BorderSizePixel = 0,
        Parent = holder,
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8)}).Parent = notif
    ApplyGlow(notif, theme.Glow, 1)

    local title = Create("TextLabel", {
        Text = config.Title or "Notification",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 12, 0, 8),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notif,
    })

    local content = Create("TextLabel", {
        Text = config.Content or "",
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 36),
        Position = UDim2.new(0, 12, 0, 28),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = notif,
    })

    -- Slide in
    notif.Position = UDim2.new(1, 20, 0, 0)
    Tween(notif, {Position = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

    local duration = config.Duration or 5
    task.delay(duration, function()
        Tween(notif, {Position = UDim2.new(1, 20, 0, 0)}, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In, function()
            notif:Destroy()
        end)
    end)
end

--// Export
getgenv().DaemonUI = DaemonUI
return DaemonUI
