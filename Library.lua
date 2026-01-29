local InputService = game:GetService('UserInputService')
local TextService = game:GetService('TextService')
local TweenService = game:GetService('TweenService')
local RunService = game:GetService('RunService')
local CoreGui = game:GetService('CoreGui')
local HttpService = game:GetService('HttpService')
local Players = game:GetService('Players')

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local Library = {
    Name = "DaemonIX",
    Version = "3.0.0",
    Directory = "DaemonIX_Config",
    
    Theme = {
        Main = Color3.fromRGB(15, 12, 20),
        Secondary = Color3.fromRGB(25, 22, 30),
        Stroke = Color3.fromRGB(50, 45, 65),
        Divider = Color3.fromRGB(40, 35, 50),
        
        Accent = Color3.fromRGB(170, 50, 255),
        Accent2 = Color3.fromRGB(0, 255, 240),
        
        Text = Color3.fromRGB(240, 240, 255),
        DarkText = Color3.fromRGB(140, 140, 160),
    },
    
    Toggles = {},
    Options = {},
    Flags = {},
    UnloadSignals = {},
    OpenedFrames = {},
    ThemeObjects = {},
    
    IsVisible = true,
    Keybind = Enum.KeyCode.RightControl
}

local function GetTextSize(text, font, size)
    return TextService:GetTextSize(text, size, font, Vector2.new(10000, 10000))
end

local function Tween(obj, props, time, style, dir)
    local info = TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then obj[k] = v end
    end
    if props.Parent then obj.Parent = props.Parent end
    return obj
end

local function TriggerRipple(parent)
    spawn(function()
        local ripple = Create("ImageLabel", {
            Parent = parent, BackgroundTransparency = 1,
            Image = "rbxassetid://2708891598", ImageTransparency = 0.8,
            Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 0, 0, 0),
            ZIndex = 9
        })
        Tween(ripple, {Size = UDim2.new(1.5, 0, 1.5, 0), ImageTransparency = 1}, 0.5)
        wait(0.5)
        ripple:Destroy()
    end)
end

local function MakeDraggable(dragObj, moveObj)
    local dragging, dragInput, dragStart, startPos
    
    table.insert(Library.UnloadSignals, dragObj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = moveObj.Position
        end
    end))
    
    table.insert(Library.UnloadSignals, dragObj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end))
    
    table.insert(Library.UnloadSignals, InputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Tween(moveObj, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.05)
        end
    end))
    
    table.insert(Library.UnloadSignals, InputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end))
end

function Library:Notify(title, text, duration)
    if not Library.NotifContainer then
        Library.NotifContainer = Create("Frame", {
            Parent = Library.ScreenGui, Size = UDim2.new(0, 300, 1, 0), Position = UDim2.new(1, -320, 0, 0), BackgroundTransparency = 1
        })
        Create("UIListLayout", {Parent = Library.NotifContainer, VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 10)})
        Create("UIPadding", {Parent = Library.NotifContainer, PaddingBottom = UDim.new(0, 20)})
    end

    local Frame = Create("Frame", {
        Parent = Library.NotifContainer, Size = UDim2.new(1, 0, 0, 70), BackgroundColor3 = Library.Theme.Main, BackgroundTransparency = 0.1,
        Position = UDim2.new(1, 0, 0, 0)
    })
    Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 8)})
    Create("UIStroke", {Parent = Frame, Color = Library.Theme.Stroke, Thickness = 1})
    
    local Bar = Create("Frame", {Parent = Frame, Size = UDim2.new(0, 4, 1, -10), Position = UDim2.new(0, 5, 0, 5), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0})
    Create("UICorner", {Parent = Bar, CornerRadius = UDim.new(0, 4)})
    Create("UIGradient", {Parent = Bar, Rotation = 90, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Library.Theme.Accent), ColorSequenceKeypoint.new(1, Library.Theme.Accent2)}})
    
    Create("TextLabel", {
        Parent = Frame, Text = title, Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 18, 0, 8),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Library.Theme.Accent, TextXAlignment = 0
    })
    Create("TextLabel", {
        Parent = Frame, Text = text, Size = UDim2.new(1, -20, 0, 35), Position = UDim2.new(0, 18, 0, 28),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Library.Theme.Text, TextXAlignment = 0, TextWrapped = true
    })
    
    Tween(Frame, {Position = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back)
    
    task.delay(duration or 4, function()
        Tween(Frame, {Position = UDim2.new(1.2, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back)
        wait(0.4)
        Frame:Destroy()
    end)
end

function Library:Window(Config)
    if CoreGui:FindFirstChild("DaemonIX_Eternal") then CoreGui.DaemonIX_Eternal:Destroy() end
    
    local ScreenGui = Create("ScreenGui", {Name = "DaemonIX_Eternal", Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    Library.ScreenGui = ScreenGui

    local Watermark = Create("Frame", {
        Name = "Watermark", Parent = ScreenGui, Size = UDim2.new(0, 0, 0, 30), Position = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = Library.Theme.Main, BackgroundTransparency = 0.2, AutomaticSize = Enum.AutomaticSize.X
    })
    Create("UICorner", {Parent = Watermark, CornerRadius = UDim.new(0, 6)})
    Create("UIStroke", {Parent = Watermark, Color = Library.Theme.Accent, Thickness = 1, Transparency = 0.5})
    Create("UIPadding", {Parent = Watermark, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})
    
    local WatermarkText = Create("TextLabel", {
        Parent = Watermark, Size = UDim2.new(0, 0, 1, 0), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X,
        Text = "DaemonIX | FPS: 60 | Ping: 0ms", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Library.Theme.Text
    })

    spawn(function()
        while ScreenGui.Parent do
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            WatermarkText.Text = string.format("DaemonIX | FPS: %d | Ping: %dms", fps, ping)
            wait(0.5)
        end
    end)

    local ShadowHolder = Create("Frame", {
        Name = "ShadowHolder", Parent = ScreenGui, Size = UDim2.new(0, 650, 0, 450), Position = UDim2.new(0.5, -325, 0.5, -225), BackgroundTransparency = 1
    })
    
    local Main = Create("Frame", {
        Parent = ShadowHolder, Size = UDim2.new(1, -20, 1, -20), Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Library.Theme.Main, BackgroundTransparency = 0.15, ClipsDescendants = true
    })
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 10)})
    
    Create("ImageLabel", {
        Parent = Main, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Image = "rbxassetid://9968344105", ImageTransparency = 0.94, ScaleType = Enum.ScaleType.Tile, TileSize = UDim2.new(0, 128, 0, 128)
    })
    
    local Separator = Create("Frame", {
        Parent = Main, Size = UDim2.new(0, 2, 1, -50), Position = UDim2.new(0, 170, 0, 25), BorderSizePixel = 0, BackgroundColor3 = Color3.new(1,1,1)
    })
    Create("UIGradient", {
        Parent = Separator, Rotation = 90,
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Library.Theme.Accent), ColorSequenceKeypoint.new(1, Library.Theme.Accent2)}
    })

    local Header = Create("Frame", {Parent = Main, Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1})
    MakeDraggable(Header, ShadowHolder)
    
    Create("TextLabel", {
        Parent = Header, Text = Config.Name or "DaemonIX", Size = UDim2.new(0, 200, 1, 0), Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBlack, TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = Library.Theme.Text
    })
    
    local CloseBtn = Create("TextButton", {
        Parent = Header, Text = "×", Size = UDim2.new(0, 40, 1, 0), Position = UDim2.new(1, -40, 0, 0),
        BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150), TextSize = 24, Font = Enum.Font.Gotham
    })
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    
    local Sidebar = Create("ScrollingFrame", {
        Parent = Main, Size = UDim2.new(0, 160, 1, -50), Position = UDim2.new(0, 10, 0, 50),
        BackgroundTransparency = 1, ScrollBarThickness = 0, CanvasSize = UDim2.new(0,0,0,0)
    })
    Create("UIListLayout", {Parent = Sidebar, Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder})

    local PageContainer = Create("Frame", {
        Parent = Main, Size = UDim2.new(1, -190, 1, -50), Position = UDim2.new(0, 180, 0, 50), BackgroundTransparency = 1
    })

    local Tabs = {}
    
    function Library:Tab(Name)
        local Tab = {Sections = {}}
        local Button = Create("TextButton", {
            Parent = Sidebar, Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 1, Text = "", AutoButtonColor = false
        })
        
        local Indicator = Create("Frame", {
            Parent = Button, Size = UDim2.new(0, 3, 0, 16), Position = UDim2.new(0, 0, 0.5, -8),
            BackgroundColor3 = Library.Theme.Accent, BackgroundTransparency = 1
        })
        Create("UICorner", {Parent = Indicator, CornerRadius = UDim.new(1,0)})
        
        local Label = Create("TextLabel", {
            Parent = Button, Text = Name, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 15, 0, 0),
            BackgroundTransparency = 1, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = Library.Theme.DarkText, TextXAlignment = 0
        })
        
        local Page = Create("ScrollingFrame", {
            Parent = PageContainer, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false,
            ScrollBarThickness = 2, ScrollBarImageColor3 = Library.Theme.Accent, CanvasSize = UDim2.new(0,0,0,0)
        })
        local PageList = Create("UIListLayout", {Parent = Page, Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder})
        
        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 20)
        end)
        
        Button.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                Tween(t.Label, {TextColor3 = Library.Theme.DarkText})
                Tween(t.Ind, {BackgroundTransparency = 1})
                t.Page.Visible = false
            end
            Tween(Label, {TextColor3 = Library.Theme.Text})
            Tween(Indicator, {BackgroundTransparency = 0})
            Page.Visible = true
        end)
        
        if #Tabs == 0 then
            Tween(Label, {TextColor3 = Library.Theme.Text})
            Tween(Indicator, {BackgroundTransparency = 0})
            Page.Visible = true
        end
        
        table.insert(Tabs, {Btn = Button, Label = Label, Ind = Indicator, Page = Page})

        function Tab:Section(Title)
            local Section = {}
            local SecFrame = Create("Frame", {
                Parent = Page, Size = UDim2.new(1, -5, 0, 30), BackgroundColor3 = Library.Theme.Secondary,
                BackgroundTransparency = 0.4, BorderSizePixel = 0
            })
            Create("UICorner", {Parent = SecFrame, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = SecFrame, Color = Library.Theme.Stroke, Transparency = 0.5})
            
            Create("TextLabel", {
                Parent = SecFrame, Text = Title, Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1, TextColor3 = Library.Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = 0
            })
            
            local Container = Create("Frame", {
                Parent = SecFrame, Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 35), BackgroundTransparency = 1
            })
            local List = Create("UIListLayout", {Parent = Container, Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder})
            
            List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Container.Size = UDim2.new(1, 0, 0, List.AbsoluteContentSize.Y + 10)
                SecFrame.Size = UDim2.new(1, -5, 0, List.AbsoluteContentSize.Y + 45)
            end)

            function Sec:Label(Text)
                local LabFrame = Create("Frame", {
                    Parent = Cont, 
                    Size = UDim2.new(1, 0, 0, 25), 
                    BackgroundTransparency = 1
                })
                
                Create("TextLabel", {
                    Parent = LabFrame, 
                    Text = Text, 
                    Size = UDim2.new(1, -10, 1, 0), 
                    Position = UDim2.new(0, 5, 0, 0),
                    BackgroundTransparency = 1, 
                    TextColor3 = Library.Theme.Text, 
                    Font = Enum.Font.Gotham, 
                    TextSize = 13, 
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true
                })
            end
            function Section:Button(Text, Callback)
                local Btn = Create("TextButton", {
                    Parent = Container, Size = UDim2.new(1, 0, 0, 35), BackgroundTransparency = 1, Text = "", AutoButtonColor = false
                })
                
                local Bg = Create("Frame", {
                    Parent = Btn, Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Library.Theme.Main, BackgroundTransparency = 0.5
                })
                Create("UICorner", {Parent = Bg, CornerRadius = UDim.new(0, 6)})
                Create("UIStroke", {Parent = Bg, Color = Library.Theme.Stroke, Thickness = 1})
                
                local Lab = Create("TextLabel", {
                    Parent = Btn, Text = Text, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
                    TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham, TextSize = 13
                })
                
                Btn.MouseEnter:Connect(function() Tween(Bg, {BackgroundColor3 = Library.Theme.Accent, BackgroundTransparency = 0.8}) end)
                Btn.MouseLeave:Connect(function() Tween(Bg, {BackgroundColor3 = Library.Theme.Main, BackgroundTransparency = 0.5}) end)
                Btn.MouseButton1Click:Connect(function()
                    TriggerRipple(Btn)
                    if Callback then Callback() end
                end)
            end

            function Section:Toggle(Config)
                local Toggle = {Value = Config.Default or false}
                local Obj = Create("TextButton", {
                    Parent = Container, Size = UDim2.new(1, 0, 0, 35), BackgroundTransparency = 1, Text = "", AutoButtonColor = false
                })
                
                Create("TextLabel", {
                    Parent = Obj, Text = Config.Name, Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 12, 0, 0),
                    BackgroundTransparency = 1, TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = 0
                })
                
                local Capsule = Create("Frame", {
                    Parent = Obj, Size = UDim2.new(0, 42, 0, 22), Position = UDim2.new(1, -52, 0.5, -11),
                    BackgroundColor3 = Library.Theme.Stroke
                })
                Create("UICorner", {Parent = Capsule, CornerRadius = UDim.new(1, 0)})
                
                local Circle = Create("Frame", {
                    Parent = Capsule, Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 3, 0.5, -8),
                    BackgroundColor3 = Color3.fromRGB(180, 180, 180)
                })
                Create("UICorner", {Parent = Circle, CornerRadius = UDim.new(1, 0)})
                
                local function Update()
                    if Toggle.Value then
                        Tween(Capsule, {BackgroundColor3 = Library.Theme.Accent})
                        Tween(Circle, {Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = Color3.new(1,1,1)})
                    else
                        Tween(Capsule, {BackgroundColor3 = Library.Theme.Stroke})
                        Tween(Circle, {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.fromRGB(180, 180, 180)})
                    end
                    Library.Flags[Config.Flag or Config.Name] = Toggle.Value
                    if Config.Callback then Config.Callback(Toggle.Value) end
                end
                
                Obj.MouseButton1Click:Connect(function()
                    Toggle.Value = not Toggle.Value
                    Update()
                end)
                
                if Config.Default then Update() end
                return Toggle
            end

            function Section:Slider(Config)
                local Slider = {Value = Config.Default or Config.Min}
                
                local Frame = Create("Frame", {Parent = Container, Size = UDim2.new(1, 0, 0, 45), BackgroundTransparency = 1})
                Create("TextLabel", {
                    Parent = Frame, Text = Config.Name, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 12, 0, 0),
                    BackgroundTransparency = 1, TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = 0
                })
                
                local InputBox = Create("TextBox", {
                    Parent = Frame, Text = tostring(Slider.Value), Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -52, 0, 0),
                    BackgroundTransparency = 1, TextColor3 = Library.Theme.DarkText, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = 1,
                    ClearTextOnFocus = false
                })
                
                local Bar = Create("Frame", {
                    Parent = Frame, Size = UDim2.new(1, -24, 0, 4), Position = UDim2.new(0, 12, 0, 30),
                    BackgroundColor3 = Library.Theme.Stroke
                })
                Create("UICorner", {Parent = Bar, CornerRadius = UDim.new(1, 0)})
                
                local Fill = Create("Frame", {
                    Parent = Bar, Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Library.Theme.Accent
                })
                Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(1, 0)})
                
                local function Update(val)
                    val = math.clamp(val, Config.Min, Config.Max)
                    Slider.Value = val
                    InputBox.Text = tostring(val)
                    Tween(Fill, {Size = UDim2.new((val - Config.Min) / (Config.Max - Config.Min), 0, 1, 0)}, 0.05)
                    Library.Flags[Config.Flag or Config.Name] = val
                    if Config.Callback then Config.Callback(val) end
                end
                
                local dragging = false
                Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
                table.insert(Library.UnloadSignals, InputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end))
                table.insert(Library.UnloadSignals, InputService.InputChanged:Connect(function(i)
                    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                        local pos = math.clamp((i.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                        Update(Config.Min + (Config.Max - Config.Min) * pos)
                    end
                end))
                
                InputBox.FocusLost:Connect(function()
                    local val = tonumber(InputBox.Text)
                    if val then Update(val) end
                end)
                
                Update(Slider.Value)
                return Slider
            end

            function Section:Dropdown(Config)
                local Drop = {Value = Config.Default or Config.List[1]}
                local IsOpen = false
                
                local Frame = Create("Frame", {
                    Parent = Container, 
                    Size = UDim2.new(1, 0, 0, 60), 
                    BackgroundTransparency = 1
                })
                
                Create("TextLabel", {
                    Parent = Frame, 
                    Text = Config.Name, 
                    Size = UDim2.new(1, 0, 0, 20), 
                    Position = UDim2.new(0, 12, 0, 0),
                    BackgroundTransparency = 1, 
                    TextColor3 = Library.Theme.Text, 
                    Font = Enum.Font.Gotham, 
                    TextSize = 13, 
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local Box = Create("TextButton", {
                    Parent = Frame, 
                    Size = UDim2.new(1, -24, 0, 30), 
                    Position = UDim2.new(0, 12, 0, 25),
                    BackgroundColor3 = Library.Theme.Secondary, 
                    Text = Drop.Value or "...", 
                    TextColor3 = Library.Theme.DarkText,
                    Font = Enum.Font.Gotham, 
                    TextSize = 13, 
                    AutoButtonColor = false
                })
                Create("UICorner", {Parent = Box, CornerRadius = UDim.new(0, 6)})
                Create("UIStroke", {Parent = Box, Color = Library.Theme.Stroke, Thickness = 1})
                
                local Arrow = Create("ImageLabel", {
                    Parent = Box, 
                    Size = UDim2.new(0, 16, 0, 16), 
                    Position = UDim2.new(1, -24, 0.5, -8),
                    BackgroundTransparency = 1, 
                    Image = "rbxassetid://6031090990", 
                    ImageColor3 = Library.Theme.DarkText
                })

                local List = Create("ScrollingFrame", {
                    Parent = Library.ScreenGui,
                    Size = UDim2.new(0, 0, 0, 0),
                    BackgroundColor3 = Library.Theme.Main, 
                    BorderColor3 = Library.Theme.Accent, 
                    BorderSizePixel = 1, 
                    Visible = false, 
                    ZIndex = 3000,
                    ScrollBarThickness = 2, 
                    ScrollBarImageColor3 = Library.Theme.Accent,
                    CanvasSize = UDim2.new(0,0,0,0)
                })
                Create("UICorner", {Parent = List, CornerRadius = UDim.new(0, 6)})
                Create("UIListLayout", {Parent = List, SortOrder = Enum.SortOrder.LayoutOrder})

                local function UpdatePosition()
                    if not IsOpen then return end
                    List.Size = UDim2.new(0, Box.AbsoluteSize.X, 0, math.min(#Config.List * 25, 150))
                    List.Position = UDim2.new(0, Box.AbsolutePosition.X, 0, Box.AbsolutePosition.Y + Box.AbsoluteSize.Y + 5)
                end

                table.insert(Library.UnloadSignals, RunService.RenderStepped:Connect(UpdatePosition))

                local function Refresh()
                    for _, v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                    
                    for _, val in pairs(Config.List) do
                        local Item = Create("TextButton", {
                            Parent = List, 
                            Size = UDim2.new(1, 0, 0, 25), 
                            BackgroundTransparency = 1, 
                            Text = val,
                            TextColor3 = Library.Theme.DarkText, 
                            Font = Enum.Font.Gotham, 
                            TextSize = 12,
                            ZIndex = 3001
                        })
                        
                        Item.MouseEnter:Connect(function() Item.TextColor3 = Library.Theme.Accent end)
                        Item.MouseLeave:Connect(function() Item.TextColor3 = Library.Theme.DarkText end)

                        Item.MouseButton1Click:Connect(function()
                            Drop.Value = val
                            Box.Text = val
                            IsOpen = false
                            List.Visible = false
                            Tween(Arrow, {Rotation = 0})
                            Library.Flags[Config.Flag or Config.Name] = val
                            if Config.Callback then Config.Callback(val) end
                        end)
                    end
                    List.CanvasSize = UDim2.new(0,0,0, #Config.List * 25)
                end
                
                Box.MouseButton1Click:Connect(function()
                    IsOpen = not IsOpen
                    if IsOpen then
                        Refresh()
                        List.Visible = true
                        UpdatePosition()
                        Tween(Arrow, {Rotation = 180})
                    else
                        List.Visible = false
                        Tween(Arrow, {Rotation = 0})
                    end
                end)
                
                Box.AncestryChanged:Connect(function()
                    if not Box:IsDescendantOf(game) then List:Destroy() end
                end)
                
                return Drop
            end

            function Section:Textbox(Config)
                local Frame = Create("Frame", {Parent = Container, Size = UDim2.new(1, 0, 0, 60), BackgroundTransparency = 1})
                Create("TextLabel", {
                    Parent = Frame, Text = Config.Name, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 12, 0, 0),
                    BackgroundTransparency = 1, TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = 0
                })
                local Input = Create("TextBox", {
                    Parent = Frame, Size = UDim2.new(1, -24, 0, 30), Position = UDim2.new(0, 12, 0, 25),
                    BackgroundColor3 = Library.Theme.Secondary, Text = Config.Default or "", TextColor3 = Library.Theme.Text,
                    Font = Enum.Font.Gotham, TextSize = 13, ClearTextOnFocus = false, PlaceholderText = Config.Placeholder or "Type here..."
                })
                Create("UICorner", {Parent = Input, CornerRadius = UDim.new(0, 6)})
                Create("UIStroke", {Parent = Input, Color = Library.Theme.Stroke, Thickness = 1})
                
                Input.FocusLost:Connect(function()
                    Library.Flags[Config.Flag or Config.Name] = Input.Text
                    if Config.Callback then Config.Callback(Input.Text) end
                end)
            end

            function Section:Keybind(Config)
                local Bind = {Value = Config.Default, Mode = "Toggle"}
                
                local Frame = Create("Frame", {Parent = Container, Size = UDim2.new(1, 0, 0, 35), BackgroundTransparency = 1})
                Create("TextLabel", {
                    Parent = Frame, Text = Config.Name, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 12, 0, 8),
                    BackgroundTransparency = 1, TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = 0
                })
                
                local BindBtn = Create("TextButton", {
                    Parent = Frame, Size = UDim2.new(0, 80, 0, 20), Position = UDim2.new(1, -92, 0, 8),
                    BackgroundColor3 = Library.Theme.Secondary, Text = (Bind.Value and Bind.Value.Name) or "None", 
                    TextColor3 = Library.Theme.DarkText, Font = Enum.Font.Gotham, TextSize = 12
                })
                Create("UICorner", {Parent = BindBtn, CornerRadius = UDim.new(0, 4)})
                Create("UIStroke", {Parent = BindBtn, Color = Library.Theme.Stroke, Thickness = 1})

                local Listening = false
                BindBtn.MouseButton1Click:Connect(function()
                    if Listening then return end
                    Listening = true
                    BindBtn.Text = "..."
                    
                    local connection
                    connection = InputService.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            if input.KeyCode == Enum.KeyCode.Backspace then
                                Bind.Value = nil
                                BindBtn.Text = "None"
                            else
                                Bind.Value = input.KeyCode
                                BindBtn.Text = input.KeyCode.Name
                            end
                            Listening = false
                            connection:Disconnect()
                            Library.Flags[Config.Flag or Config.Name] = Bind.Value
                            if Config.Callback then Config.Callback(Bind.Value) end
                        end
                    end)
                end)

                local MenuOpen = false
                local ModeMenu = Create("Frame", {
                    Parent = Library.ScreenGui, Size = UDim2.new(0, 100, 0, 90), BackgroundColor3 = Library.Theme.Main,
                    BorderColor3 = Library.Theme.Outline, BorderSizePixel = 1, Visible = false, ZIndex = 200
                })
                
                local Modes = {"Toggle", "Hold", "Always"}
                for i, m in pairs(Modes) do
                    local MBtn = Create("TextButton", {
                        Parent = ModeMenu, Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0, (i-1)*30),
                        BackgroundTransparency = 1, Text = m, TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham
                    })
                    MBtn.MouseButton1Click:Connect(function()
                        Bind.Mode = m
                        ModeMenu.Visible = false
                        MenuOpen = false
                        Library:Notify("Keybind", "Mode set to: " .. m, 2)
                    end)
                end

                BindBtn.MouseButton2Click:Connect(function()
                    MenuOpen = not MenuOpen
                    ModeMenu.Visible = MenuOpen
                    ModeMenu.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y)
                end)
                
                return Bind
            end

            function Section:ColorPicker(Config)
                local ToggleLabel = Container
                
                local ColorPicker = {
                    Value = Config.Default or Color3.fromRGB(255, 255, 255),
                    Transparency = Config.Transparency or 0,
                    Type = 'ColorPicker',
                    Title = Config.Name or 'Color Picker',
                    Callback = Config.Callback or function() end
                }

                function ColorPicker:SetHSVFromRGB(Color)
                    local h, s, v = Color3.toHSV(Color)
                    ColorPicker.Hue = h
                    ColorPicker.Sat = s
                    ColorPicker.Vib = v
                end

                ColorPicker:SetHSVFromRGB(ColorPicker.Value)

                local Frame = Create("Frame", {Parent = Container, Size = UDim2.new(1, 0, 0, 35), BackgroundTransparency = 1})
                
                Create("TextLabel", {
                    Parent = Frame, Text = Config.Name, Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 12, 0, 0),
                    BackgroundTransparency = 1, TextColor3 = Library.Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = 0
                })
                
                local DisplayFrame = Create("TextButton", {
                    Parent = Frame, Size = UDim2.new(0, 42, 0, 20), Position = UDim2.new(1, -52, 0.5, -10),
                    BackgroundColor3 = ColorPicker.Value, Text = "", AutoButtonColor = false
                })
                Create("UICorner", {Parent = DisplayFrame, CornerRadius = UDim.new(0, 4)})
                Create("UIStroke", {Parent = DisplayFrame, Color = Library.Theme.Stroke, Thickness = 1})
                
                local Checker = Create("ImageLabel", {
                    Parent = DisplayFrame, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 0,
                    Image = "rbxassetid://12977615774", ScaleType = Enum.ScaleType.Tile, TileSize = UDim2.new(0, 8, 0, 8)
                })
                Create("UICorner", {Parent = Checker, CornerRadius = UDim.new(0, 4)})

                local PickerFrameOuter = Create("Frame", {
                    Name = "ColorPickerPopup",
                    Parent = Library.ScreenGui,
                    Size = UDim2.fromOffset(250, 280),
                    BackgroundColor3 = Library.Theme.Main,
                    BorderColor3 = Library.Theme.Outline,
                    BorderSizePixel = 1,
                    Visible = false,
                    ZIndex = 5000
                })
                Create("UICorner", {Parent = PickerFrameOuter, CornerRadius = UDim.new(0, 6)})
                
                DisplayFrame:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
                    if PickerFrameOuter.Visible then
                        PickerFrameOuter.Position = UDim2.fromOffset(DisplayFrame.AbsolutePosition.X + 50, DisplayFrame.AbsolutePosition.Y)
                    end
                end)

                local PickerFrameInner = Create("Frame", {
                    Parent = PickerFrameOuter, Size = UDim2.new(1, -10, 1, -10), Position = UDim2.new(0, 5, 0, 5),
                    BackgroundTransparency = 1
                })

                local SatVibMap = Create("ImageButton", {
                    Parent = PickerFrameInner, Size = UDim2.new(0, 200, 0, 200), Position = UDim2.new(0, 0, 0, 0),
                    Image = "rbxassetid://4155801252", AutoButtonColor = false, BorderColor3 = Library.Theme.Outline, BorderSizePixel = 1
                })
                Create("UICorner", {Parent = SatVibMap, CornerRadius = UDim.new(0, 4)})

                local CursorOuter = Create("ImageLabel", {
                    Parent = SatVibMap, Size = UDim2.new(0, 12, 0, 12), AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1, Image = "http://www.roblox.com/asset/?id=9619665977", ImageColor3 = Color3.new(0,0,0)
                })

                local HueSelectorOuter = Create("ImageButton", {
                    Parent = PickerFrameInner, Size = UDim2.new(0, 25, 0, 200), Position = UDim2.new(1, -30, 0, 0),
                    Image = "rbxassetid://6977078330", AutoButtonColor = false
                })
                Create("UICorner", {Parent = HueSelectorOuter, CornerRadius = UDim.new(0, 4)})

                local HueCursor = Create("Frame", {
                    Parent = HueSelectorOuter, Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 0, 0),
                    BackgroundColor3 = Color3.new(1,1,1), BorderColor3 = Color3.new(0,0,0), BorderSizePixel = 1
                })

                local InputContainer = Create("Frame", {
                    Parent = PickerFrameInner, Size = UDim2.new(1, 0, 0, 25), Position = UDim2.new(0, 0, 1, -25), BackgroundTransparency = 1
                })
                
                local HexBox = Create("TextBox", {
                    Parent = InputContainer, Size = UDim2.new(0.4, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0),
                    BackgroundColor3 = Library.Theme.Secondary, Text = "#FFFFFF", TextColor3 = Library.Theme.Text,
                    Font = Enum.Font.Code, TextSize = 12, ClearTextOnFocus = false
                })
                Create("UICorner", {Parent = HexBox, CornerRadius = UDim.new(0, 4)})
                Create("UIStroke", {Parent = HexBox, Color = Library.Theme.Stroke, Thickness = 1})

                local RgbBox = Create("TextBox", {
                    Parent = InputContainer, Size = UDim2.new(0.55, 0, 1, 0), Position = UDim2.new(0.45, 0, 0, 0),
                    BackgroundColor3 = Library.Theme.Secondary, Text = "255, 255, 255", TextColor3 = Library.Theme.Text,
                    Font = Enum.Font.Code, TextSize = 12, ClearTextOnFocus = false
                })
                Create("UICorner", {Parent = RgbBox, CornerRadius = UDim.new(0, 4)})
                Create("UIStroke", {Parent = RgbBox, Color = Library.Theme.Stroke, Thickness = 1})

                function ColorPicker:Display()
                    ColorPicker.Value = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib)
                    SatVibMap.ImageColor3 = Color3.fromHSV(ColorPicker.Hue, 1, 1)

                    DisplayFrame.BackgroundColor3 = ColorPicker.Value
                    DisplayFrame.BackgroundTransparency = ColorPicker.Transparency

                    CursorOuter.Position = UDim2.new(ColorPicker.Sat, 0, 1 - ColorPicker.Vib, 0)
                    HueCursor.Position = UDim2.new(0, 0, ColorPicker.Hue, 0)

                    HexBox.Text = '#' .. ColorPicker.Value:ToHex()
                    RgbBox.Text = table.concat({ math.floor(ColorPicker.Value.R * 255), math.floor(ColorPicker.Value.G * 255), math.floor(ColorPicker.Value.B * 255) }, ', ')

                    Library.Flags[Config.Flag or Config.Name] = ColorPicker.Value
                    if Config.Callback then Config.Callback(ColorPicker.Value) end
                end

                function ColorPicker:Show()
                    for Frame, _ in next, Library.OpenedFrames do
                        Frame.Visible = false
                        Library.OpenedFrames[Frame] = nil
                    end
                    PickerFrameOuter.Visible = true
                    PickerFrameOuter.Position = UDim2.fromOffset(DisplayFrame.AbsolutePosition.X + 50, DisplayFrame.AbsolutePosition.Y)
                    Library.OpenedFrames[PickerFrameOuter] = true
                end

                function ColorPicker:Hide()
                    PickerFrameOuter.Visible = false
                    Library.OpenedFrames[PickerFrameOuter] = nil
                end

                HexBox.FocusLost:Connect(function(enter)
                    if enter then
                        local success, result = pcall(Color3.fromHex, HexBox.Text)
                        if success then
                            ColorPicker:SetHSVFromRGB(result)
                            ColorPicker:Display()
                        end
                    end
                end)

                RgbBox.FocusLost:Connect(function(enter)
                    if enter then
                        local r, g, b = RgbBox.Text:match('(%d+),%s*(%d+),%s*(%d+)')
                        if r and g and b then
                            ColorPicker:SetHSVFromRGB(Color3.fromRGB(r, g, b))
                            ColorPicker:Display()
                        end
                    end
                end)

                SatVibMap.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                            local MinX = SatVibMap.AbsolutePosition.X
                            local MaxX = MinX + SatVibMap.AbsoluteSize.X
                            local MouseX = math.clamp(Mouse.X, MinX, MaxX)

                            local MinY = SatVibMap.AbsolutePosition.Y
                            local MaxY = MinY + SatVibMap.AbsoluteSize.Y
                            local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

                            ColorPicker.Sat = (MouseX - MinX) / (MaxX - MinX)
                            ColorPicker.Vib = 1 - ((MouseY - MinY) / (MaxY - MinY))
                            ColorPicker:Display()

                            RunService.RenderStepped:Wait()
                        end
                    end
                end)

                HueSelectorOuter.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                            local MinY = HueSelectorOuter.AbsolutePosition.Y
                            local MaxY = MinY + HueSelectorOuter.AbsoluteSize.Y
                            local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

                            ColorPicker.Hue = ((MouseY - MinY) / (MaxY - MinY))
                            ColorPicker:Display()

                            RunService.RenderStepped:Wait()
                        end
                    end
                end)

                DisplayFrame.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if PickerFrameOuter.Visible then ColorPicker:Hide() else ColorPicker:Show() end
                    end
                end)
                
                InputService.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 and PickerFrameOuter.Visible then
                        local m = InputService:GetMouseLocation()
                        local p = PickerFrameOuter.AbsolutePosition
                        local s = PickerFrameOuter.AbsoluteSize
                        local b = DisplayFrame.AbsolutePosition
                        
                        if not (m.X >= p.X and m.X <= p.X + s.X and m.Y >= p.Y and m.Y <= p.Y + s.Y) 
                           and not (m.X >= b.X and m.X <= b.X + 42 and m.Y >= b.Y and m.Y <= b.Y + 20) then
                            ColorPicker:Hide()
                        end
                    end
                end)

                ColorPicker:Display()
                return ColorPicker
            end
            return Section
        end
        return Tab
    end
    function Library:SaveConfig(name)
        if not isfolder(Library.Directory) then makefolder(Library.Directory) end
        local json = HttpService:JSONEncode(Library.Flags)
        writefile(Library.Directory .. "/" .. name .. ".json", json)
        Library:Notify("Config", "Saved config: " .. name, 3)
    end
    
    function Library:LoadConfig(name)
        if isfile(Library.Directory .. "/" .. name .. ".json") then
            local json = readfile(Library.Directory .. "/" .. name .. ".json")
            local data = HttpService:JSONDecode(json)
            for k, v in pairs(data) do
                Library.Flags[k] = v
            end
            Library:Notify("Config", "Loaded config: " .. name, 3)
        end
    end
    table.insert(Library.UnloadSignals, InputService.InputBegan:Connect(function(input, processed)
        if input.KeyCode == Library.Keybind and not processed then
            Library.IsVisible = not Library.IsVisible
            Library.ScreenGui.ShadowHolder.Visible = Library.IsVisible
        end
    end))

    table.insert(Library.UnloadSignals, InputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        
        for _, flag in pairs(Library.Flags) do
            if type(flag) == "table" and flag.Value and flag.Mode then
                if input.KeyCode == flag.Value or input.UserInputType == flag.Value then
                    if flag.Mode == "Toggle" then
                        flag.State = not flag.State
                        if flag.Callback then flag.Callback(flag.State) end
                    elseif flag.Mode == "Hold" then
                        flag.State = true
                        if flag.Callback then flag.Callback(true) end
                    end
                end
            end
        end
    end))
    
    table.insert(Library.UnloadSignals, InputService.InputEnded:Connect(function(input)
        for _, flag in pairs(Library.Flags) do
            if type(flag) == "table" and flag.Value and flag.Mode == "Hold" then
                if input.KeyCode == flag.Value or input.UserInputType == flag.Value then
                    flag.State = false
                    if flag.Callback then flag.Callback(false) end
                end
            end
        end
    end))

    function Library:Unload()
        for _, signal in pairs(Library.UnloadSignals) do
            signal:Disconnect()
        end
        ScreenGui:Destroy()
    end

    return Library
end
getgenv().Library = Library
return Library
