-- Daemon UI Example by DaemonIX

local Daemon = loadstring(game:HttpGet("YOUR_RAW_LINK_HERE"))()

-- Optional: Key System
-- Daemon:CreateKeySystem({
--     KeyLink = "https://your-key-link.com",
--     Keys = {"Daemon2026", "FreeKey123"},
--     Callback = function(valid)
--         if valid then print("Key OK") end
--     end,
-- })

local Window = Daemon:CreateWindow({
    Name = "Daemon Hub",
    Icon = "rbxassetid://7733965386",
    LoadingTitle = "Daemon Hub",
    Subtitle = "by DaemonIX",
    Theme = "Nebula",
    Size = UDim2.new(0, 700, 0, 450),
})

local MainTab = Window:CreateTab({Name = "Main", Icon = "rbxassetid://7733965386"})
local PlayerTab = Window:CreateTab({Name = "Player", Icon = "rbxassetid://7733954760"})
local VisualTab = Window:CreateTab({Name = "Visuals", Icon = "rbxassetid://7733774602"})
local SettingsTab = Window:CreateTab({Name = "Settings", Icon = "rbxassetid://7734053495"})

-- Main Tab
MainTab:AddSection({Name = "Info"})
MainTab:AddParagraph({Title = "Welcome", Content = "Daemon UI - Modern Roblox Interface Library"})

MainTab:AddSection({Name = "Actions"})
MainTab:AddButton({
    Title = "Notify Test",
    Description = "Send a test notification",
    Callback = function()
        Daemon:Notify({Title = "Test", Content = "It works!", Type = "Success", Duration = 3})
    end,
})

local autoFarm = MainTab:AddToggle({
    Title = "Auto Farm",
    Description = "Toggle auto farming",
    Default = false,
    Callback = function(v) print("Auto Farm:", v) end,
})

local speed = MainTab:AddSlider({
    Title = "Walk Speed",
    Description = "Adjust speed",
    Min = 16, Max = 200, Default = 16, Increment = 1, Suffix = " studs/s",
    Callback = function(v)
        local char = game.Players.LocalPlayer.Character
        if char then char.Humanoid.WalkSpeed = v end
    end,
})

local mode = MainTab:AddDropdown({
    Title = "Game Mode",
    Description = "Select mode",
    Options = {"Casual", "Ranked", "Competitive", "Sandbox"},
    Default = "Casual",
    Callback = function(v) print("Mode:", v) end,
})

-- Player Tab
PlayerTab:AddSection({Name = "Character"})
local jump = PlayerTab:AddSlider({
    Title = "Jump Power",
    Min = 50, Max = 300, Default = 50, Increment = 5, Suffix = " power",
    Callback = function(v)
        local char = game.Players.LocalPlayer.Character
        if char then char.Humanoid.JumpPower = v end
    end,
})

local fly = PlayerTab:AddToggle({Title = "Fly Mode", Default = false, Callback = function(v) print("Fly:", v) end})

PlayerTab:AddSection({Name = "Input"})
local target = PlayerTab:AddInput({
    Title = "Target Player",
    Description = "Enter username",
    Placeholder = "Username...",
    Callback = function(t) print("Target:", t) end,
})

local flyKey = PlayerTab:AddKeybind({
    Title = "Fly Keybind",
    Description = "Toggle fly",
    Default = "F",
    Callback = function(k) print("Fly key:", k) end,
})

-- Visuals Tab
VisualTab:AddSection({Name = "ESP"})
local esp = VisualTab:AddToggle({Title = "ESP", Description = "See through walls", Default = false, Callback = function(v) print("ESP:", v) end})
local espColor = VisualTab:AddColorPicker({
    Title = "ESP Color",
    Description = "Highlight color",
    Default = Color3.fromRGB(255, 0, 100),
    Callback = function(c) print("Color:", c) end,
})

VisualTab:AddDivider({Text = "World"})
local fullBright = VisualTab:AddToggle({
    Title = "Full Bright",
    Description = "Remove shadows",
    Default = false,
    Callback = function(v)
        game.Lighting.Brightness = v and 10 or 2
        game.Lighting.GlobalShadows = not v
    end,
})

-- Settings Tab
SettingsTab:AddSection({Name = "Theme"})
SettingsTab:AddButton({Title = "Nebula", Description = "Purple + Cyan", Callback = function() Daemon:SetTheme("Nebula") end})
SettingsTab:AddButton({Title = "Midnight", Description = "Dark subtle", Callback = function() Daemon:SetTheme("Midnight") end})
SettingsTab:AddButton({Title = "Cyber", Description = "Neon green + purple", Callback = function() Daemon:SetTheme("Cyber") end})
SettingsTab:AddButton({Title = "Aurora", Description = "Blue + pink", Callback = function() Daemon:SetTheme("Aurora") end})

SettingsTab:AddDivider({Text = "Config"})
SettingsTab:AddButton({
    Title = "Save Config",
    Description = "Save current settings",
    Callback = function() Daemon.SaveManager:Save("MyConfig") end,
})
SettingsTab:AddButton({
    Title = "Load Config",
    Description = "Load saved settings",
    Callback = function() Daemon.SaveManager:Load("MyConfig") end,
})
SettingsTab:AddButton({
    Title = "Delete Config",
    Description = "Remove saved settings",
    Callback = function() Daemon.SaveManager:Delete("MyConfig") end,
})

-- Save Manager Setup
Daemon.SaveManager:SetFolder("DaemonHub")
Daemon.SaveManager:RegisterElement(autoFarm, "AutoFarm", "Toggle")
Daemon.SaveManager:RegisterElement(speed, "WalkSpeed", "Slider")
Daemon.SaveManager:RegisterElement(mode, "GameMode", "Dropdown")
Daemon.SaveManager:RegisterElement(fly, "FlyMode", "Toggle")
Daemon.SaveManager:RegisterElement(jump, "JumpPower", "Slider")
Daemon.SaveManager:RegisterElement(esp, "ESP", "Toggle")
Daemon.SaveManager:RegisterElement(espColor, "ESPColor", "ColorPicker")
Daemon.SaveManager:RegisterElement(fullBright, "FullBright", "Toggle")

-- Welcome notification
Daemon:Notify({
    Title = "Daemon Hub Loaded",
    Content = "Welcome! Your hub is ready.",
    Type = "Success",
    Duration = 5,
})
