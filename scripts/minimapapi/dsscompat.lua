local MinimapAPI = require("scripts.minimapapi")
local json = require("json")

-- Do not add DSS on our side (wouldn't really make sense to support MCM
-- otherwise) but add a way for dependent mods to add MinimapAPI config to DSS
-- Added since integration in Rev, for consistency

-- run only once in case more dependents mod call it
local AddedDSSMenu = false

local EditedProviders = {}

function MinimapAPI:AddDSSMenu(DSSModName, dssmod, MenuProvider)
    if not EditedProviders[DSSModName] then
        EditedProviders[DSSModName] = true

       -- Hijack save data of provided menu to save minimapapi data,
        -- in case it isn't already handled by dependent mod
        -- (ie it's the standalone version)
        if not MinimapAPI.DisableSaving then
            local prevSaveDataFun = MenuProvider.SaveSaveData
            function MenuProvider.SaveSaveData()
                prevSaveDataFun()
                MinimapAPI:SaveData(json.encode(MinimapAPI:GetSaveTable()))
            end
        end
    end

    if AddedDSSMenu then
        return
    end

    local menuDirectory = {
        --LEVEL 1
        main = {
            title = 'minimapapi',
            buttons = {
                {str = 'resume game', action = 'resume'},
                {str = 'settings', dest = 'settings'},
                {str = 'presets'}, --, dest = 'settings'},
                {str = 'minimapapi info', dest = 'info'},
            },
            tooltip = dssmod.menuOpenToolTip
        },
        settings = {
            title = 'settings',
            buttons = {
                {str = 'pickups', dest = 'pickups'},
                {str = 'map', dest = 'map'},
    
                dssmod.gamepadToggleButton,
                dssmod.menuKeybindButton,
                dssmod.paletteButton,
                dssmod.menuHintButton,
                dssmod.menuBuzzerButton,
            },
            tooltip = dssmod.menuOpenToolTip
        },
        pickups = {
            title = 'pickup settings',
            buttons = {
                {
                    str = 'pickup icons',
                    choices = {'on', 'off'},
                    tooltip = {strset = {'show pickup', 'icons' }},
                    variable = 'PickupIcons',
                    setting = 1,
                    load = function()
                        return MinimapAPI.Config.ShowPickupIcons and 1 or 2
                    end,
                    store = function(var)
                        MinimapAPI.Config.ShowPickupIcons = var == 1
                        MinimapAPI.Config.ConfigPreset = 0
                    end
                },
                {
                    str = 'current room icons',
                    choices = {'on', 'off'},
                    tooltip = {strset = {'show pickup', 'icons even if', 'isaac is in', 'the current', 'room' }},
                    variable = 'ShowCurrentRoomItems',
                    setting = 2,
                    load = function()
                        return MinimapAPI.Config.ShowCurrentRoomItems and 1 or 2
                    end,
                    store = function(var)
                        MinimapAPI.Config.ShowCurrentRoomItems = var == 1
                    end
                },
                {
                    str = 'duplicate icons',
                    choices = {'on', 'off'},
                    tooltip = {strset = {'show pickup', 'icons multiple', 'times if more', 'are in the', 'room' }},
                    variable = 'PickupNoGrouping',
                    setting = 2,
                    load = function()
                        return MinimapAPI.Config.PickupNoGrouping and 1 or 2
                    end,
                    store = function(var)
                        MinimapAPI.Config.PickupNoGrouping = var == 1
                        MinimapAPI.Config.ConfigPreset = 0
                    end
                },
            },
            tooltip = dssmod.menuOpenToolTip,
        },
        map = {
            title = 'map settings',
            buttons = {
                {
                    str = 'room outlines',
                    choices = {'on', 'off'},
                    tooltip = {strset = {'show dark', 'room outlines' }},
                    variable = 'ShowShadows',
                    setting = 1,
                    load = function()
                        return MinimapAPI.Config.ShowShadows and 1 or 2
                    end,
                    store = function(var)
                        MinimapAPI.Config.ShowShadows = var == 1
                        MinimapAPI.Config.ConfigPreset = 0
                    end
                },
                {
                    str = 'map effect icons',
                    choices = {'off', 'left', 'bottom'},
                    tooltip = {strset = {'blue map,', 'compass and', 'treasure map', 'icons' }},
                    variable = 'ShowShadows',
                    setting = 2,
                    load = function()
                        return MinimapAPI.Config.DisplayLevelFlags
                    end,
                    store = function(var)
                        MinimapAPI.Config.DisplayLevelFlags = var
                        MinimapAPI.Config.ConfigPreset = 0
                    end,
                },
                {
                    str = 'show unclr vstd',
                    size = 1,
                    choices = {'on', 'off'},
                    tooltip = {strset = {'seen but not', 'cleared rooms', 'will show as', 'checkerboard', 'pattern' }},
                    variable = 'ShowShadows',
                    setting = 2,
                    load = function()
                        return MinimapAPI.Config.DisplayExploredRooms and 1 or 2
                    end,
                    store = function(var)
                        MinimapAPI.Config.DisplayExploredRooms = var == 1
                        MinimapAPI.Config.ConfigPreset = 0
                    end,
                },
                {
                    str = 'bounded map width',
                    min = 10,
                    max = 100,
                    increment = 5,
                    setting = 50,
                    variable = "MapFrameWidth",
                    tooltip = {strset = {'border map\'s', 'width' }},
                    load = function()
                        return MinimapAPI.Config.MapFrameWidth
                    end,
                    store = function(var)
                        MinimapAPI.Config.MapFrameWidth = var
                        MinimapAPI.Config.ConfigPreset = 0
                    end,
                },
                {
                    str = 'bounded map height',
                    min = 10,
                    max = 100,
                    increment = 5,
                    setting = 50,
                    variable = "MapFrameHeight",
                    tooltip = {strset = {'border map\'s', 'height' }},
                    load = function()
                        return MinimapAPI.Config.MapFrameHeight
                    end,
                    store = function(var)
                        MinimapAPI.Config.MapFrameHeight = var
                        MinimapAPI.Config.ConfigPreset = 0
                    end,
                },
                {
                    str = 'position x',
                    min = 0,
                    max = 100,
                    increment = 2,
                    setting = 10,
                    variable = "PositionX",
                    tooltip = {strset = {'horizontal', 'distance from', 'top right of', 'the screen' }},
                    load = function()
                        return MinimapAPI.Config.PositionX
                    end,
                    store = function(var)
                        MinimapAPI.Config.PositionX = var
                        MinimapAPI.Config.ConfigPreset = 0
                    end,
                },
                {
                    str = 'position y',
                    min = 0,
                    max = 100,
                    increment = 2,
                    setting = 10,
                    variable = "PositionY",
                    tooltip = {strset = {'vertical', 'distance from', 'top right of', 'the screen' }},
                    load = function()
                        return MinimapAPI.Config.PositionY
                    end,
                    store = function(var)
                        MinimapAPI.Config.PositionY = var
                        MinimapAPI.Config.ConfigPreset = 0
                    end,
                },
                {
                    str = 'map interpolation',
                    min = 0.1,
                    max = 1,
                    increment = 0.05,
                    setting = 0.5,
                    variable = "SmoothSlidingSpeed",
                    tooltip = {strset = {'how quickly', 'the map moves'}},
                    load = function()
                        return MinimapAPI.Config.SmoothSlidingSpeed
                    end,
                    store = function(var)
                        MinimapAPI.Config.SmoothSlidingSpeed = var
                        MinimapAPI.Config.ConfigPreset = 0
                    end,
                },
                -- Map 2 section
                {
                    str = 'hide in combat',
                    choices = {'never', 'bosses only', 'always'},
                    tooltip = {strset = {'hide map', 'in uncleared', 'rooms' }},
                    variable = 'HideInCombat',
                    setting = 2,
                    load = function()
                        return MinimapAPI.Config.HideInCombat
                    end,
                    store = function(var)
                        MinimapAPI.Config.HideInCombat = var
                        MinimapAPI.Config.ConfigPreset = 0
                    end,
                },
                {
                    str = 'hide outside',
                    choices = {'on', 'off'},
                    tooltip = {strset = {'hide map', 'in rooms', 'not on the', 'map (ie.', 'devil rooms)' }},
                    variable = 'HideInInvalidRoom',
                    setting = 1,
                    load = function()
                        return MinimapAPI.Config.HideInInvalidRoom and 1 or 2
                    end,
                    store = function(var)
                        MinimapAPI.Config.HideInInvalidRoom = var == 1
                        MinimapAPI.Config.ConfigPreset = 0
                    end,
                },
                {
                    str = 'room distance',
                    choices = {'on', 'off'},
                    tooltip = {strset = {'rooms will', 'have their', 'distance shown' }},
                    variable = 'ShowGridDistances',
                    setting = 2,
                    load = function()
                        return MinimapAPI.Config.ShowGridDistances and 1 or 2
                    end,
                    store = function(var)
                        MinimapAPI.Config.ShowGridDistances = var == 1
                        MinimapAPI.Config.ConfigPreset = 0
                    end,
                },
                {
                    str = 'highlight start',
                    choices = {'on', 'off'},
                    tooltip = {strset = {'starting room', 'will be', 'highlighted' }},
                    variable = 'HighlightStartRoom',
                    setting = 2,
                    load = function()
                        return MinimapAPI.Config.HighlightStartRoom and 1 or 2
                    end,
                    store = function(var)
                        MinimapAPI.Config.HighlightStartRoom = var == 1
                        MinimapAPI.Config.ConfigPreset = 0
                    end,
                },
                {
                    str = 'highlight far',
                    choices = {'on', 'off'},
                    tooltip = {strset = {'furthest room', 'from start', 'will be', 'highlighted'}},
                    variable = 'HighlightFurthestRoom',
                    setting = 2,
                    load = function()
                        return MinimapAPI.Config.HighlightFurthestRoom and 1 or 2
                    end,
                    store = function(var)
                        MinimapAPI.Config.HighlightFurthestRoom = var == 1
                        MinimapAPI.Config.ConfigPreset = 0
                    end,
                },
                {
                    str = 'alt visited',
                    choices = {'on', 'off'},
                    tooltip = {strset = {'alternate', 'sprite for', 'semivisited', 'rooms' }},
                    variable = 'AltSemivisitedSprite',
                    setting = 1,
                    load = function()
                        return MinimapAPI.Config.AltSemivisitedSprite and 1 or 2
                    end,
                    store = function(var)
                        MinimapAPI.Config.AltSemivisitedSprite = var == 1
                        MinimapAPI.Config.ConfigPreset = 0
                    end,
                },
                {
                    str = 'secret shadows',
                    choices = {'on', 'off'},
                    tooltip = {strset = {'discovered', 'secret rooms', 'show as', 'shadows', 'instead of', 'normal rooms' }},
                    variable = 'VanillaSecretRoomDisplay',
                    setting = 1,
                    load = function()
                        return MinimapAPI.Config.VanillaSecretRoomDisplay and 1 or 2
                    end,
                    store = function(var)
                        MinimapAPI.Config.VanillaSecretRoomDisplay = var == 1
                        MinimapAPI.Config.ConfigPreset = 0
                    end,
                },
            },
            tooltip = dssmod.menuOpenToolTip,
        },
        info = {
            title = 'minimapapi info',
            fsize = 2,
            nocursor = true,
            scroller = true,
            buttons = {
                {str = 'minimapapi', clr = 3},
                {str = 'adds more map icons'},
                {str = 'and allows mods to'},
                {str = 'add their own'},
                {str = 'plus other features'},
                {str = ''},
                {str = 'you can change visual'},
                {str = 'presets in the settings'},
                {str = ''},
                {str = 'for technical reasons'},
                {str = 'the minimap cannot be'},
                {str = 'at partial trasparency'},
            },
            tooltip = dssmod.menuOpenToolTip
        },
    }
    
    local menuDirectoryKey = {
        Item = menuDirectory.main,
        Main = 'main',
        Idle = false,
        MaskAlpha = 1,
        Settings = {},
        SettingsChanged = false,
        Path = {},
    }

    DeadSeaScrollsMenu.AddMenu("MinimapAPI", {
        Run = dssmod.runMenu, 
        Open = dssmod.openMenu, 
        Close = dssmod.closeMenu, 
        Directory = menuDirectory, 
        DirectoryKey = menuDirectoryKey, 
    })

    AddedDSSMenu = true
end