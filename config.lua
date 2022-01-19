Config              = {}

Config.Hash = {
	{hash = `ambulanceals`, detection = 2.4, depth = -1.0, height = 0.0},
	{hash = `f450ambo`, detection = 2.4, depth = -1.0, height = 0.0},
}

Config.Lits = {
	{lit = `stretcher`,          distance_stop = 2.4},
	{lit = `stryker_M1`,         distance_stop = 2.4},
	{lit = `stryker_M1_coroner`, distance_stop = 2.4},
	{lit = `mxpro`,              distance_stop = 2.4},
	{lit = `stretcher_basket`,   distance_stop = 2.4},
}


--[[
	Add the following to your Bones.Options['bonnet'] For this to appear correctly on target with qb-target
	
	Bones.Options['bonnet'] = {
		["Seating"] = {
			type = "client",
			event = "qb-fivemems:client:StretcherSeatMenu",
			icon = "fas fa-ambulance",
			label = "Stretcher Seating",
			distance = 2.5
		},
		["Stretcher_Menu"] = {
			type = "client",
			event = "qb-fivemems:client:StretcherMenu",
			icon = "fas fa-ambulance",
			label = "Stretcher Menu",
			job = "ambulance",
			distance = 2.5
		},
		["EMS"] = {
			type = "client",
			event = "qb-fivemems:client:AmbulanceMenu",
			icon = "fas fa-ambulance",
			label = "EMS Menu",
			job = "ambulance",
			distance = 2.5
		},
		["Toggle_Hood"] = {
			icon = "fa-duotone fa-engine",
			label = "Toggle Hood",
			action = function(entity)
				ToggleDoor(entity, 4)
			end,
			distance = 2.5
		},
	}
]]