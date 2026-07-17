Daemon UI v2.0
Modern Roblox Interface Library by DaemonIX

Load
local Daemon = loadstring(game:HttpGet("YOUR_RAW_LINK"))()

Window
local Window = Daemon:CreateWindow({
    Name = "Daemon Hub",
    Icon = "rbxassetid://7733965386",
    LoadingTitle = "Daemon Hub",
    Subtitle = "by DaemonIX",
    Theme = "Nebula",        -- "Nebula" | "Midnight" | "Cyber" | "Aurora"
    Size = UDim2.new(0, 700, 0, 450),
})

Tab
local Tab = Window:CreateTab({
    Name = "Main",
    Icon = "rbxassetid://7733965386",
})

Elements
Section
Tab:AddSection({Name = "Section Name"})
Paragraph
Tab:AddParagraph({
    Title = "Title",
    Content = "Description text...",
})
Button
Tab:AddButton({
    Title = "Click Me",
    Description = "Optional description",
    Icon = "rbxassetid://...",
    Callback = function()
        print("Clicked!")
    end,
})
Toggle
local Toggle = Tab:AddToggle({
    Title = "Auto Farm",
    Description = "Optional",
    Default = false,
    Callback = function(value)
        print(value)
    end,
})

Toggle:Set(true)   -- set value
Toggle:Get()       -- get value
Slider
local Slider = Tab:AddSlider({
    Title = "Walk Speed",
    Description = "Optional",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 1,
    Suffix = " studs/s",
    Callback = function(value)
        print(value)
    end,
})

Slider:Set(100)
Slider:Get()
Dropdown
local Dropdown = Tab:AddDropdown({
    Title = "Mode",
    Description = "Optional",
    Options = {"Casual", "Ranked", "Competitive"},
    Default = "Casual",
    Multi = false,      -- true = multi-select
    Callback = function(value)
        print(value)
    end,
})

Dropdown:Set("Ranked")
Dropdown:Get()
Dropdown:Refresh({"New", "Options"})
Input
local Input = Tab:AddInput({
    Title = "Username",
    Description = "Optional",
    Placeholder = "Type here...",
    Default = "",
    Numeric = false,
    Callback = function(text)
        print(text)
    end,
})

Input:Set("Hello")
Input:Get()
Keybind
local Keybind = Tab:AddKeybind({
    Title = "Fly Key",
    Description = "Optional",
    Default = "F",
    Callback = function(key)
        print("Pressed:", key)
    end,
})

Keybind:Set("G")
Keybind:Get()
ColorPicker
local Picker = Tab:AddColorPicker({
    Title = "ESP Color",
    Description = "Optional",
    Default = Color3.fromRGB(120, 80, 255),
    Callback = function(color)
        print(color)
    end,
})

Picker:Set(Color3.fromRGB(255, 0, 0))
Picker:Get()
Divider
Tab:AddDivider({Text = "or"})     -- with text
Tab:AddDivider({})                 -- line only

Notification
Daemon:Notify({
    Title = "Hello",
    Content = "This is a notification",
    Type = "Info",          -- "Info" | "Success" | "Warning" | "Error"
    Duration = 5,
    Icon = "rbxassetid://...",
})

Theme
Daemon:SetTheme("Cyber")
Theme	Style
Nebula	Purple + Cyan (default)
Midnight	Dark + subtle
Cyber	Neon green + purple
Aurora	Blue + pink

Save Manager
-- Register elements
Daemon.SaveManager:SetFolder("MyScriptHub")
Daemon.SaveManager:RegisterElement(Toggle, "AutoFarm", "Toggle")
Daemon.SaveManager:RegisterElement(Slider, "Speed", "Slider")
Daemon.SaveManager:RegisterElement(Dropdown, "Mode", "Dropdown")
Daemon.SaveManager:RegisterElement(Input, "Name", "Input")
Daemon.SaveManager:RegisterElement(Keybind, "Key", "Keybind")
Daemon.SaveManager:RegisterElement(Picker, "Color", "ColorPicker")

-- Save / Load / Delete
Daemon.SaveManager:Save("Config1")
Daemon.SaveManager:Load("Config1")
Daemon.SaveManager:Delete("Config1")

Key System
Daemon:CreateKeySystem({
    KeyLink = "https://your-key-link.com",
    Keys = {"Daemon2026", "FreeKey123"},
    Callback = function(valid)
        if valid then
            -- create window here
        end
    end,
})

Features
•Auto cleanup old UI on re-execute
•Glassmorphism + neon glow + particles
•4 built-in themes
•Search bar inside tabs
•Minimize / Close animations
•Mobile & PC support
•Config save/load (JSON)
