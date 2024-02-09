ESX = exports["es_extended"]:getSharedObject()

local NPCspawned                = false
local cooldown = 0
local activity = 0
local activitySource = 0

local resourceName = "hw_witwas"
local scriptVersion = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    print('^7> ================================================================')
    print('^7> ^5[HW Scripts] ^7| ^3' .. resourceName .. ' ^2has been started.') 
    print('^7> ^5[HW Scripts] ^7| ^2Current version: ^3' .. scriptVersion)
    print('^7> ^5[HW Scripts] ^7| ^6Made by HW Development')
    print('^7> ^5[HW Scripts] ^7| ^8Creator: ^3Henk W')
    print('^7> ^5[HW Scripts] ^7| ^4Shop Link: ^3hw-scripts-store.tebex.io/')
    print('^7> ^5[HW Scripts] ^7| ^4Discord Server Link: ^3https://discord.gg/j55z45bC')
    print('^7> ================================================================')
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    print('^7> ===========================================')
    print('^7> ^5[HW Scripts] ^7| ^3' .. resourceName .. ' ^1has been stopped.')
    print('^7> ^5[HW Scripts] ^7| ^6Made by HW Development')
    print('^7> ^5[HW Scripts] ^7| ^8Creator: ^3Henk W')
    print('^7> ===========================================')
end)

local discordWebhook = "https://discord.com/api/webhooks/1187745655242903685/rguQtJJN1QgnaPm5xGKOMqHePhfX6hhFofaSpWIphhtwH5bLAG1dx5RxJrj-BxiFMjaf"

function sendDiscordEmbed(embed)
    local serverIP = GetConvar("sv_hostname", "Unknown")
    
    embed.description = embed.description .. "\nServer Name: `" .. serverIP .. "`"

    local discordPayload = json.encode({embeds = {embed}})
    PerformHttpRequest(discordWebhook, function(err, text, headers) end, 'POST', discordPayload, { ['Content-Type'] = 'application/json' })
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    local scriptName = GetCurrentResourceName() 

    local embed = {
        title = "Resource Started",
        description = string.format("**%s** has been started.", scriptName), 
        fields = {
            {name = "Current version", value = scriptVersion},
            {name = "Discord Server Link", value = "[Discord Server](https://discord.gg/j55z45bC)"}
        },
        footer = {
            text = "HW Scripts | Logs"
        },
        color = 16776960 
    }

    sendDiscordEmbed(embed)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    local scriptName = GetCurrentResourceName() 

    local embed = {
        title = "Resource Stopped",
        description = string.format("**%s** has been stopped.", scriptName),
        footer = {
            text = "HW Scripts | Logs"
        },
        color = 16711680
    }

    sendDiscordEmbed(embed)
end)





-- TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('hw_laundry:washMoney')
AddEventHandler('hw_laundry:washMoney', function(amount, zone)
	local xPlayer = ESX.GetPlayerFromId(source)
	local taxrate
	
	taxrate = Config.Taxation	
	amount = ESX.Math.Round(tonumber(amount))
	washedCash = amount * taxrate
	finalpay = ESX.Math.Round(tonumber(washedCash))

	
	
	if amount > 0 and xPlayer.getAccount('black_money').money >= amount then
  		xPlayer.removeAccountMoney('black_money', amount)
		--TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_washed') .. ESX.Math.GroupDigits(amount) .. _U('dirty_money') .. _U('you_have_received') .. ESX.Math.GroupDigits(finalpay) .. _U('clean_money'))
		TriggerClientEvent('notifications', xPlayer.source, "#33FF7D", "Success", _U('you_have_washed') .. ESX.Math.GroupDigits(amount) .. _U('dirty_money') .. _U('you_have_received') .. ESX.Math.GroupDigits(finalpay) .. _U('clean_money'))
		xPlayer.addMoney(finalpay)
		cooldown = Config.CooldownMinutes * 60000
		TriggerClientEvent('hw_laundry:checkpayandnotify', xPlayer.source, amount)
				
	else
		TriggerClientEvent('notifications', xPlayer.source, "#FF5733", "Invalid", _U('invalid_amount'))
		
	end
	
	
end)

ESX.RegisterServerCallback('hw_laundry:isActive',function(source, cb)
	cb(activity, cooldown)
  end)

ESX.RegisterServerCallback('hw_laundry:anycops',function(source, cb)
	local anycops = 0
	local playerList = ESX.GetPlayers()
	for i=1, #playerList, 1 do
	  local _source = playerList[i]
	  local xPlayer = ESX.GetPlayerFromId(_source)
	  local playerjob = xPlayer.job.name
	  if playerjob == 'police' then
		anycops = anycops + 1
	  end
	end
	cb(anycops)
end)

RegisterServerEvent('hw_laundry:cooldown')
AddEventHandler('hw_laundry:cooldown', function()
	cooldown = Config.CooldownMinutes * 60000
end)	

RegisterServerEvent('hw_laundry:registerActivity')
AddEventHandler('hw_laundry:registerActivity', function(value)
	activity = value
	if value == 1 then
		activitySource = source
		--Send notification to cops
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				TriggerClientEvent('hw_laundry:setcopnotification', xPlayers[i])
			end
		end
	else
		activitySource = 0
	end
end)

ESX.RegisterServerCallback('hw_laundry:getmoney',function(source, cb)
	local money = 0
	local xPlayer = ESX.GetPlayerFromID(source)
	money = xPlayer.getAccount('black_money').money
	num = xPlayer.getInventoryItem(Config.ItemName).count
	cb(money)
	
end)

RegisterServerEvent('hw_laundry:alertcops')
AddEventHandler('hw_laundry:alertcops', function(cx, cy, cz)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            TriggerClientEvent('hw_laundry:setcopblip', xPlayers[i], cx, cy, cz)
        end
    end
end)


RegisterServerEvent('hw_laundry:giveItem')
AddEventHandler('hw_laundry:giveItem', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	num = xPlayer.getInventoryItem(Config.ItemName).count
	if num <= 0 then
		xPlayer.addInventoryItem(Config.ItemName, 1)
	else
		TriggerClientEvent('notifications', xPlayer.source, "#FF5733", "Invalid", _U('already_item'))
	end		
end)

RegisterServerEvent('hw_laundry:removeItem')
AddEventHandler('hw_laundry:removeItem', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	num = xPlayer.getInventoryItem(Config.ItemName).count
	if num >= 1 then
		xPlayer.removeInventoryItem(Config.ItemName, 1)
	else
		TriggerClientEvent("hw_laundry:abortmission")
		TriggerClientEvent('notifications', xPlayer.source, "#FF5733", "Invalid", _U('no_item'))	
	end		
end)



RegisterServerEvent('hw_laundry:stopalertcops')
AddEventHandler('hw_laundry:stopalertcops', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('hw_laundry:removecopblip', xPlayers[i])
		end
	end
end)

RegisterServerEvent('hw_laundry:sendToDiscord')
AddEventHandler('hw_laundry:sendToDiscord', function(amount)
    local _source = source  -- Capture source in a local variable
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        local id = xPlayer.getIdentifier()
        local logs = Config.Webhook
        local communityLogo = Config.WebhookLogo  -- Must end with .png or .jpg
        local name = xPlayer.getName()
        local DATE = os.date(" %H:%M %d.%m.%y")

        local connect = {
            {
                ["color"] = "8663711",
                ["title"] = "Witwas | Log systeem",
                ["description"] = "".. name .. " [" .. id .. "] " .. "heeft: €" .. amount .. " zwart geld gewassen op" .. DATE .. "" ,
                ["footer"] = {
                    ["text"] = "[hw_witwas] - by Henk W",
                },
            }
        }

        PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = Config.WebhookName, embeds = connect}), { ['Content-Type'] = 'application/json' })
    else
        print('Invalid player ID or player not found.')
    end
end)


AddEventHandler('playerDropped', function ()
	local _source = source
	if _source == activitySource then
		--Remove blip for all cops
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				TriggerClientEvent('hw_laundry:removecopblip', xPlayers[i])
			end
		end
		--Set activity to 0
		activity = 0
		activitySource = 0
	end
end)

AddEventHandler('onResourceStart', function(resource)
	while true do
		Wait(5000)
		if cooldown > 0 then
			cooldown = cooldown - 5000
		end
	end
end)

