ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('AS_SimpleGarage:VeranderSpawnStatus')
AddEventHandler('AS_SimpleGarage:VeranderSpawnStatus', function(plate, spawnstate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicles = getPlayerVehicles(xPlayer.getIdentifier())
	local spawnstate = spawnstate
	for _,v in pairs(vehicles) do
		MySQL.Sync.execute("UPDATE owned_vehicles SET spawnstate =@spawnstate WHERE plate=@plate",{['@spawnstate'] = spawnstate , ['@plate'] = plate})
		break		
	end
end)

function getPlayerVehicles(identifier)
	
	local vehicles = {}
	local data = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = identifier})	
	for _,v in pairs(data) do
		local vehicle = json.decode(v.vehicle)
		table.insert(vehicles, {id = v.id, plate = v.plate})
	end
	return vehicles
end

AddEventHandler('onMySQLReady', function()

	MySQL.Sync.execute("UPDATE owned_vehicles SET spawnstate=true WHERE spawnstate=false", {})

end)

ESX.RegisterServerCallback('AS_SimpleGarage:checkLocked',function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	local islocked = MySQL.Sync.fetchScalar("SELECT lockcheck FROM owned_vehicles WHERE plate = @plate", {['@plate'] = plate}) 
	
	if islocked == "no" then
		cb(false)
	elseif islocked == "yes" then
		cb(true)
	end
end)

ESX.RegisterServerCallback('AS_SimpleGarage:IsVehicleOwner',function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = plate
	}, function (result)
		if result[1] then -- does the owner match?
			cb(true)
		else
			cb(false)
		end
	end)
end)


RegisterServerEvent('AS_SimpleGarage:changeLockStatus')
AddEventHandler('AS_SimpleGarage:changeLockStatus', function(plate)
	local statusyes = "yes"
	local statusno = "no"
	local islocked = MySQL.Sync.fetchScalar("SELECT lockcheck FROM owned_vehicles WHERE plate = @plate", {['@plate'] = plate}) 
	
	if islocked == "no" then
		MySQL.Sync.execute("UPDATE owned_vehicles SET lockcheck=@status WHERE plate=@plate",{['@status'] = statusyes , ['@plate'] = plate})	
	elseif islocked == "yes" then
		MySQL.Sync.execute("UPDATE owned_vehicles SET lockcheck=@status WHERE plate=@plate",{['@status'] = statusno , ['@plate'] = plate})	
	end
end)

RegisterServerEvent('AS_SimpleGarage:registerVehicle')
AddEventHandler('AS_SimpleGarage:registerVehicle', function(plate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local status = "yes"
	MySQL.Sync.execute("UPDATE owned_vehicles SET registered=@status WHERE plate=@plate",{['@status'] = status , ['@plate'] = plate})
end)

ESX.RegisterServerCallback('AS_SimpleGarage:checkRegistered',function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	local isRegistered = MySQL.Sync.fetchScalar("SELECT registered FROM owned_vehicles WHERE plate = @plate", {['@plate'] = plate}) 
	
	if isRegistered == "no" then
		cb(false)
	elseif isRegistered == "yes" then
		cb(true)
	end
end)

ESX.RegisterServerCallback("garage:fetchPlayerVehicles", function(source, callback, garage)
	local player = ESX.GetPlayerFromId(source)

	if player then
		local sqlQuery = [[
			SELECT
				plate, vehicle
			FROM
				owned_vehicles
			WHERE
				owner = @cid
		]]

		if garage then
			sqlQuery = [[
				SELECT
					plate, vehicle
				FROM
					owned_vehicles
				WHERE
					owner = @cid and garage = @garage and impounded = @impounded
			]]
		end

		MySQL.Async.fetchAll(sqlQuery, {
			["@cid"] = player["identifier"],
			["@garage"] = garage,
			["@impounded"] = 'no'
		}, function(responses)
			local playerVehicles = {}

			for key, vehicleData in ipairs(responses) do
				table.insert(playerVehicles, {
					["plate"] = vehicleData["plate"],
					["props"] = json.decode(vehicleData["vehicle"])
				})
			end

			callback(playerVehicles)
		end)
	else
		callback(false)
	end
end)

ESX.RegisterServerCallback("garage:validateVehicle", function(source, callback, vehicleProps, garage)
	local player = ESX.GetPlayerFromId(source)

	if player then
		local sqlQuery = [[
			SELECT
				owner
			FROM
				owned_vehicles
			WHERE
				plate = @plate
		]]

		MySQL.Async.fetchAll(sqlQuery, {
			["@plate"] = vehicleProps["plate"]
		}, function(responses)
			if responses[1] then
				UpdateGarage(vehicleProps, garage)

				callback(true)
			else
				callback(false)
			end
		end)
	else
		callback(false)
	end
end)

UpdateGarage = function(vehicleProps, newGarage)
	local sqlQuery = [[
		UPDATE
			owned_vehicles
		SET
			garage = @garage, vehicle = @newVehicle, spawnstate = @spawnstate
		WHERE
			plate = @plate
	]]

	MySQL.Async.execute(sqlQuery, {
		["@plate"] = vehicleProps["plate"],
		["@garage"] = newGarage,
		["@newVehicle"] = json.encode(vehicleProps),
		["@spawnstate"] = 1
	}, function(rowsChanged)
		if rowsChanged > 0 then
			
		end
	end)
end

if Config.StoreOnServerStart then
	AddEventHandler('onMySQLReady', function()
		local impounded = true
		if impounded then 
			TriggerEvent('AS_SimpleGarage:checkImpounded')
			--TriggerServerEvent('AS_SimpleGarage:checkImpounded') IF THIS BREAKS IT REVERT TO THIS.
		elseif not impounded then
		MySQL.Async.execute("UPDATE owned_vehicles SET `stored`=1 WHERE `stored`=0", {})
		end
	end)
end
