ESX					= nil

local PlayersTostuje = {}
local PlayersHerbatuje = {} 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


--##TOSTY##

local function Tost(source)
		if PlayersTostuje[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)
			local _source = source

			local bread = xPlayer.getInventoryItem('bread').count
			local ser = xPlayer.getInventoryItem('ser').count
			local tost = xPlayer.getInventoryItem('tost').count

			if tost > 8 then
				TriggerClientEvent('esx:showNotification', source, ('Posiadasz zbyt dużo ~r~tostów'))
			elseif bread < 1 then
				TriggerClientEvent('esx:showNotification', source, ('Nie posiadasz wystarczająco ~r~chleba'))
			elseif ser <1 then
				TriggerClientEvent('esx:showNotification', source, ('Nie posiadasz wystarczająco ~r~sera'))
			else
				Citizen.Wait(8000)
				TriggerClientEvent('esx:showNotification', source, ('Tosty już~g~ prawie ~w~gotowe!'))				
				Citizen.Wait(7000)
				TriggerClientEvent('esx:showNotification', source, ('~g~Ukończyłeś ~w~przygotowywanie tostów!'))

				xPlayer.removeInventoryItem('bread', 1)
				xPlayer.removeInventoryItem('ser', 1)
				xPlayer.addInventoryItem('tost', 2)
				
				
				
			end
		end
end

RegisterServerEvent('esx_kuchenka:tost')
AddEventHandler('esx_kuchenka:tost', function()

	local _source = source

	PlayersTostuje[_source] = true

	TriggerClientEvent('esx:showNotification', _source, ('Przygotowywanie ~g~tostów ~w~w toku...'))

	Tost(source)

end)


--##HERBATKA##
local function Herbata(source)

		if PlayersHerbatuje[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local water = xPlayer.getInventoryItem('water').count
			local lip_tor = xPlayer.getInventoryItem('lip_tor').count
			local herbata = xPlayer.getInventoryItem('herbata').count

			if herbata > 8 then
				TriggerClientEvent('esx:showNotification', source, ('Posiadasz zbyt dużo ~r~herbat'))
			elseif water < 1 then
				TriggerClientEvent('esx:showNotification', source, ('Nie posiadasz wystarczająco ~r~wody'))
			elseif lip_tor <1 then
				TriggerClientEvent('esx:showNotification', source, ('Nie posiadasz wystarczająco ~r~torebek herbaty'))
			else
				Citizen.Wait(8000)
				TriggerClientEvent('esx:showNotification', source, ('Herbata już~g~ prawie ~w~gotowa!'))				
				Citizen.Wait(7000)
				TriggerClientEvent('esx:showNotification', source, ('~g~Ukończyłeś ~w~przygotowywanie herbaty!'))
				
				xPlayer.removeInventoryItem('water', 1)
				xPlayer.removeInventoryItem('lip_tor', 1)
				xPlayer.addInventoryItem('herbata', 2)
				
				
			end
		end
end

RegisterServerEvent('esx_kuchenka:herbata')
AddEventHandler('esx_kuchenka:herbata', function()

	local _source = source

	PlayersHerbatuje[_source] = true

	TriggerClientEvent('esx:showNotification', _source, ('Przygotowywanie ~g~herbaty ~w~w toku...'))

	Herbata(source)

end)


--##PO WYJŚCIU Z MARKERA PRZERYWA AKCJĘ
RegisterServerEvent('esx_kuchenka:stopTost')
AddEventHandler('esx_kuchenka:stopTost', function()
	
	local _source = source
	
	PlayersTostuje[_source] = false

end)


RegisterServerEvent('esx_kuchenka:stopHerbata')
AddEventHandler('esx_kuchenka:stopHerbata', function()
	
	local _source = source
	
	PlayersHerbatuje[_source] = false

end)
