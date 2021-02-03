Config = {}
Config.DrawDistance = 50

Config.LockKey = 303 -- Key used for locking/unlock vehicles, 303 is U

Config.ColorHex 		= "#074dd9" -- Hex color code, used for Mythic Notify
Config.ColorR 			= 7 -- Color for menu
Config.ColorG           = 77 -- Color for menu
Config.ColorB           = 217 -- Color for menu
Config.Type 			= 6 -- Circletype
Config.StoreOnServerStart = true -- Store all vehicles in garage on server start?

Config.Garages = {
    ["A"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(213.74465942383, -809.332479248047, 31.018844909668)
            },
            ["vehicle"] = {
                ["position"] = vector3(229.8497616289, -802.43420410156, 30.544597625732), 
                ["heading"] = 160.0
            }
        },
        ["camera"] = {  -- camera is not needed just if you want cool effects.
            ["x"] = 233.53096008301, 
            ["y"] = -810.65643310547, 
            ["z"] = 33.571212768555, 
            ["rotationX"] = -20.401574149728, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = 20.40157422423 
        }
    },
    ["B"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(275.81, -344.89, 45.17)
            },
            ["vehicle"] = {
                ["position"] = vector3(288.03, -342.09, 44.92), 
                ["heading"] = 160.0
            }
        },
        ["camera"] = {
            ["x"] = 291.06, 
            ["y"] = -349.99, 
            ["z"] = 48.04, 
            ["rotationX"] = -20.401574149728, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = 20.40157422423 
        }
    },
    ["C"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-2030.82, -465.42, 11.6)
            },
            ["vehicle"] = {
                ["position"] = vector3(-2036.26, -470.34, 11.38), 
                ["heading"] = 230.0
            }
        },
        ["camera"] = {
            ["x"] = -2044.93, 
            ["y"] = -469.95, 
            ["z"] = 16.11, 
            ["rotationX"] = -20.401574149728, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -80.40157422423 
        }
    },
    ["D"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(1036.42, -762.98, 57.99)
            },
            ["vehicle"] = {
                ["position"] = vector3(1026.77, -776.09, 58.04), 
                ["heading"] = 40.0
            }
        },
        ["camera"] = {
            ["x"] = 1027.09, 
            ["y"] = -791.04, 
            ["z"] = 62.81, 
            ["rotationX"] = -20.401574149728, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = -00.40157422423 
        }
    },
    ["E"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-340.79, 267.12, 85.68)
            },
            ["vehicle"] = {
                ["position"] = vector3(-335.34, 277.79, 85.90), 
                ["heading"] = 180.0
            }
        },
        ["camera"] = { 
            ["x"] = -329.65, 
            ["y"] = 269.46, 
            ["z"] = 88.81, 
            ["rotationX"] = -20.401574149728, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = 30.40157422423 
        }
    }
}

Config.Labels = {
    ["menu"] = "Press ~INPUT_CONTEXT~ to view garage",
    ["vehicle"] = "Press ~INPUT_CONTEXT~ to put vehicle back in the garage"
}

Config.Trim = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

Config.AllowedImpoundJob = 'police', 'mechanic' -- Select what job can impound vehicles

Config.Impound = {
	RetrieveLocation = { x = 409.6, y = -1623.4, z = 28.30 },
	StoreLocation = { x = 534.94, y = -26.06, z = 70.63 },
	SpawnLocation = vector3(402.49, -1634.40, 28.86)
}
