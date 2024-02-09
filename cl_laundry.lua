local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = exports["es_extended"]:getSharedObject()

local hasAlreadyEnteredMarker = nil
local CurrentAction	= nil
local CurrentActionMsg = ''
local CurrentActionData	= {}
local startedjob = false
local isTaken = 0

-- Citizen.CreateThread(function()
--     while ESX == nil do
--         TriggerEvent('esx:getSharedObject', function(obj) 
--             ESX = obj 
--         end)

--         Citizen.Wait(0)
--     end
-- end)


RegisterNetEvent('esx:playerLoaded') 
AddEventHandler('esx:playerLoaded', function(xPlayer, isNew)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
	
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)



function MoneyWashMenu()
local player = PlayerPedId()
local anim_lib = "missheistdockssetup1ig_5@base"
local anim_dict = "workers_talking_base_dockworker1"
local elements = {
	{label = _U('wash_money'), 	value = 'wash_money'},
	}
	
	ESX.UI.Menu.CloseAll()

	FreezeEntityPosition(player,true)
    TaskPlayAnim(player,anim_lib,anim_dict,1.0,0.5,-1,31,1.0,0,0)
	ClearPedTasks(player)
    ClearPedSecondaryTask(player)
	FreezeEntityPosition(player,false)
	TriggerServerEvent('hw_laundry:removeItem')
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'wash', {
		title		= _U('washed_menu'),
		align		= 'top-left',
		elements	= elements
	}, function(data, menu)
		if data.current.value == 'wash_money' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wash_money_amount_', {
				title = _U('wash_money_amount')
			}, function(data, menu)
				
				local amount = tonumber(data.value)
				
				if amount == nil then
					TriggerEvent('notifications', "#FF5733", "Invalid", _U('invalid_amount'))
			
			
				else
					menu.close()
					local startedjob = false
					TriggerServerEvent('hw_laundry:washMoney', amount, zone)
			
					RemoveBlip(deliveryblip)
					isTaken = 0
			
					DeletePed(MoneyWashped2)
					DeletePed(MoneyWashped3)
					DeletePed(MoneyWashped4)
				end
			end, function(data, menu)
				menu.close()
			end)
		end
	end, function(data, menu)
	
	menu.close()
	end)
			
		

end
RegisterNetEvent('hw_laundry:checkpayandnotify')
AddEventHandler('hw_laundry:checkpayandnotify', function(amount)
	TriggerServerEvent('hw_laundry:sendToDiscord', amount)
end)

RegisterNetEvent("hw_laundry:jobstart")
AddEventHandler("hw_laundry:jobstart", function()
	local coords = GetEntityCoords(PlayerPedId())
	local player = PlayerPedId()
    local anim_lib = "missheistdockssetup1ig_5@base"
    local anim_dict = "workers_talking_base_dockworker1"
	
	loadModel("a_m_m_business_01")
    MoneyWashped2 = CreatePed(4, GetHashKey("a_m_m_business_01"), Config.JobPed1.x, Config.JobPed1.y-0.5, Config.JobPed1.z - 0.95, Config.Headingjobped, false, true)
    FreezeEntityPosition(MoneyWashped2, true)
    SetEntityInvincible(MoneyWashped2, true)
    SetBlockingOfNonTemporaryEvents(MoneyWashped2, true)

	loadModel("a_m_m_og_boss_01")
    MoneyWashped3 = CreatePed(4, GetHashKey("a_m_m_og_boss_01"), Config.JobPed2.x, Config.JobPed2.y-0.5, Config.JobPed2.z - 0.95, Config.Headingjobped, false, true)
    FreezeEntityPosition(MoneyWashped3, true)
    SetEntityInvincible(MoneyWashped3, true)
    SetBlockingOfNonTemporaryEvents(MoneyWashped3, true)

	loadModel("a_m_m_og_boss_01")
    MoneyWashped4 = CreatePed(4, GetHashKey("a_m_m_og_boss_01"), Config.JobPed3.x, Config.JobPed3.y-0.5, Config.JobPed3.z - 0.95, Config.Headingjobped, false, true)
    FreezeEntityPosition(MoneyWashped4, true)
    SetEntityInvincible(MoneyWashped4, true)
    SetBlockingOfNonTemporaryEvents(MoneyWashped4, true)

    deliveryblip = AddBlipForCoord(Config.JobPed1.x, Config.JobPed1.y-0.5, Config.JobPed1.z)
	SetBlipSprite(deliveryblip, 1)
	SetBlipDisplay(deliveryblip, 4)
	SetBlipScale(deliveryblip, 1.0)
	SetBlipColour(deliveryblip, 5)
	SetBlipAsShortRange(deliveryblip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Destination")
	EndTextCommandSetBlipName(deliveryblip)
	SetBlipRoute(deliveryblip, true)

	TriggerServerEvent('hw_laundry:registerActivity', 1)

	TriggerServerEvent('hw_laundry:giveItem')

	isTaken = 1
    
	startedjob = true
    FreezeEntityPosition(player,true)
    TaskPlayAnim(player,anim_lib,anim_dict,1.0,0.5,-1,31,1.0,0,0)
	
	TriggerEvent('notifications', "#66FF66", "Lets Go!", _U('success'))
	ClearPedTasks(player)
    ClearPedSecondaryTask(player)
	FreezeEntityPosition(player,false)
	
end)

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(Config.BlipUpdateTime)
	  if isTaken == 1 and IsPedInAnyVehicle(GetPlayerPed(-1)) then
			  local coords = GetEntityCoords(GetPlayerPed(-1))
			TriggerServerEvent('hw_laundry:alertcops', coords.x, coords.y, coords.z)
		  elseif isTaken == 1 and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
			  TriggerServerEvent('hw_laundry:stopalertcops')
	  end
	end
end)

  
AddEventHandler('hw_laundry:hasEnteredMarker', function(zone)
	if LastZone == 'jobmenu' then
		CurrentAction     = 'wash_menu'
		CurrentActionMsg  = _U('press_menu')
		CurrentActionData = {zone = zone}
	end
	if LastZone == 'jobstart' then
		CurrentAction     = 'jobmenu'
		CurrentActionMsg  = _U('press_menu_start')
		CurrentActionData = {zone = zone}	
	end	
end)

AddEventHandler('hw_laundry:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()	
--	ESX.UI.Dialog.CloseAll()		
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		
		local isAuthorized 	= Authorized()
		
		if isAuthorized and (GetDistanceBetweenCoords(coords, Config.Location.x, Config.Location.y, Config.Location.z, true) < Config.DrawDistance) then
			DrawMarker(20, Config.Location.x, Config.Location.y,Config.Location.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3, 250, 0, 0, 100, false, true, 2, false, false, false, false)
		    DrawText3Ds(Config.Location.x, Config.Location.y, Config.Location.z+0.3, tostring("Black Money Wash"))
			
		end
				
			
	end
end)

Citizen.CreateThread(function()
    loadModel("a_m_m_og_boss_01")
    MoneyWashped = CreatePed(4, GetHashKey("a_m_m_og_boss_01"), Config.Location.x, Config.Location.y-0.5, Config.Location.z - 0.95, Config.Heading, false, true)
    FreezeEntityPosition(MoneyWashped, true)
    SetEntityInvincible(MoneyWashped, true)
    SetBlockingOfNonTemporaryEvents(MoneyWashped, true)
    
end)


function loadModel(model)
    if type(model) == 'number' then
        model = model
    else
        model = GetHashKey(model)
    end
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
end

DrawText3Ds = function(x, y, z, text)
	SetTextScale(0.25, 0.25)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end
	
	

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords		= GetEntityCoords(PlayerPedId())
		local isInMarker	= false
		local currentZone 	= nil
		
		
		
			local isAuthorized 	= Authorized()
			
			
			if isAuthorized and (GetDistanceBetweenCoords(coords, Config.Location.x, Config.Location.y, Config.Location.z, true) < 2.0) then
				isInMarker = true
				CurrentZone = 'jobstart'
				LastZone = 'jobstart'
			end	

			if startedjob and (isTaken == 1) and (GetDistanceBetweenCoords(coords, Config.JobPed1.x, Config.JobPed1.y, Config.JobPed1.z, true) < 3) then
				isInMarker  = true
				currentZone = 'jobmenu'
				LastZone    = 'jobmenu'
			end
			
						
		
		
		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			TriggerEvent('hw_laundry:hasEnteredMarker', currentZone)
		end
		
		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('hw_laundry:hasExitedMarker', LastZone)
		end
		
	end
end)
	


function Authorized()
local job = Config.AllowedJob	
	if ESX.PlayerData.job == nil then
		return false
	end
			
	if job == 'any' or job == ESX.PlayerData.job.name then
		return true
	end
		
	return false
	
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)
			
			if IsControlJustReleased(0, 38) then
				
				if CurrentAction == 'wash_menu' then
					MoneyWashMenu()
				end
				if CurrentAction == 'jobmenu' then
					ESX.TriggerServerCallback('hw_laundry:isActive', function(isActive, cooldown)
						
						if cooldown <= 0 then
						
							if isActive == 0 then
								ESX.TriggerServerCallback('hw_laundry:anycops', function(anycops)
									if anycops >= Config.CopsRequired then
										TriggerEvent("hw_laundry:jobstart")
									else
										TriggerEvent('notifications', "#FF5733", "Invalid", _U('not_cops'))
									end		
							    end)
							else
								TriggerEvent('notifications', "#FF5733", "Invalid", _U('already_active'))
						    end
						else
							TriggerEvent('notifications', "#FF5733", "Invalid", _U('cooldown'),math.ceil(cooldown/1000))
				    	end
					end)		
				end	
					CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)


RegisterNetEvent('hw_laundry:removecopblip')
AddEventHandler('hw_laundry:removecopblip', function()
		RemoveBlip(copblip)
end)


RegisterNetEvent('hw_laundry:setcopblip')
AddEventHandler('hw_laundry:setcopblip', function(cx,cy,cz)
		RemoveBlip(copblip)
    copblip = AddBlipForCoord(cx,cy,cz)
    SetBlipSprite(copblip , 161)
    SetBlipScale(copblipy , 2.0)
		SetBlipColour(copblip, 8)
		PulseBlip(copblip)
end)


-- Citizen.CreateThread(function()
--     info = Config.Location
--     info.blip = AddBlipForCoord(info.x, info.y, info.z)
--     SetBlipSprite(info.blip, 463)
--     SetBlipDisplay(info.blip, 4)
--     SetBlipScale(info.blip, 1.0)
--     SetBlipColour(info.blip, 1)
--     SetBlipAsShortRange(info.blip, true)
--     BeginTextCommandSetBlipName("STRING")
-- 	AddTextComponentString("Money Laundering")
--     EndTextCommandSetBlipName(info.blip)
-- end)

AddEventHandler('esx:onPlayerDeath', function(data)
    TriggerEvent("hw_laundry:abortmission")
end)

RegisterNetEvent("hw_laundry:abortmission")
AddEventHandler('hw_laundry:abortmission', function()
	isTaken = 0
	startedjob = false
	TriggerServerEvent('hw_laundry:registerActivity', 0)
	DeletePed(MoneyWashped2)
	DeletePed(MoneyWashped3)
	DeletePed(MoneyWashped4)
	RemoveBlip(deliveryblip)
	TriggerServerEvent('hw_laundry:cooldown')
end)	