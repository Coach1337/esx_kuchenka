local Keys = {

  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,

  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,

  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,

  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,

  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,

  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,

  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,

  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,

}



--##AKCJE##

local CurrentAction = nil

local CurrentActionMsg = ''

local CurrentActionData = {}

local HasAlreadyEnteredMarker = false

local LastZone = nil

local kuchenka = vector3(265.858515625, -996.006171875, -100.03701019287)

--##ŁADOWANIE ESX##


ESX = nil

local PlayerData = {}


Citizen.CreateThread(function ()

  while ESX == nil do

    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

    Citizen.Wait(0)

  PlayerData = ESX.GetPlayerData()

  end

end)

--##ZAŁADOWANO ESX##

--##STREFY##




--##POBIERANIE PRACY DANEGO GRACZA##

RegisterNetEvent('esx:playerLoaded')

AddEventHandler('esx:playerLoaded', function(xPlayer)

  PlayerData = xPlayer

end)


RegisterNetEvent('esx:setJob')

AddEventHandler('esx:setJob', function(job)

  PlayerData.job = job

end) 

--##KONIEC WSTĘPU##






--##PO RESTARCIE SKRYPTU ZAMYKA MENU JEŚLI OTWARTE##

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if czyOtwarte then
			ESX.UI.Menu.CloseAll()
		end
	end
end)





--##MARKERY W GRZE##

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerCoords = GetEntityCoords(PlayerPedId())
		local canSleep, isInMarker, hasExited = true, false, false

    local distance = GetDistanceBetweenCoords(playerCoords, kuchenka, true)

    if distance < Config.DrawDistance then
      DrawMarker(1, kuchenka, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, Config.Marker.a, false, false, 2, Config.Marker.rotate, nil, nil, false)
      canSleep = false
	end
	
	end
end)

--##WEJSCE/WYJSCIE MARKER##


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		local isInMarker = false

		if GetDistanceBetweenCoords(coords, kuchenka, true) < 1.5 then
			isInMarker = true
		end

    if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('esx_kuchenka:hasEnteredMarker')
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_kuchenka:hasExitedMarker')
		end

	end
end)

AddEventHandler('esx_kuchenka:hasEnteredMarker', function()
		CurrentAction     = 'kuchenka'
		CurrentActionMsg  = ('Kuchenka')
end)

AddEventHandler('esx_kuchenka:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
	TriggerServerEvent('esx_kuchenka:stopTost')
	TriggerServerEvent('esx_kuchenka:stopHerbata')
end)



--##PO WYJŚCIU Z MARKERA PRZERYWA AKCJE##

AddEventHandler('esx_kuchenka:hasExitedMarker', function()
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

--##KONTROLSY##
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction ~= nil then
			ESX.ShowHelpNotification('Wciśnij ~INPUT_CONTEXT~ aby otworzyć ~y~Kuchenkę~s~.')

			if IsControlJustReleased(0, Keys['E']) then

				if CurrentAction == 'kuchenka' then

          otworzKuchenka()

				end

				CurrentAction = nil
			end
		end
	end
end)


function otworzKuchenka()
	
	ESX.UI.Menu.CloseAll()
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu', 
	{
		title = 'Kuchenka', 
		align = 'top', 
		elements = 
		{
			{ label = 'Tosty z serem', value = 'tost' }, 
			{ label = 'Herbatka', value = 'herbata' }, 
			{ label = 'test', value = 'testt' }
		}
	}, function(data, menu)
	
		local action = data.current.value
		
		if action == 'tost' then
			TriggerServerEvent('esx_kuchenka:tost')
		elseif action == 'herbata' then
			TriggerServerEvent('esx_kuchenka:herbata')
		elseif action == 'testt' then
			TriggerServerEvent('esx_kuchenka:testt')
		end
		
	end, function(data, menu)
	
		menu.close()
		
	end)
end


--##ANIMACJA TOSTOWANIA## NIE DZIAŁA?????

--RegisterNetEvent('esx_kuchenka:onTost')
--AddEventHandler('esx_kuchenka:onTost', function()
--	if not IsEntityPlayingAnim(ped, "missbigscore1switch_trevor_piss", "piss_loop", 3) then
--			RequestAnimDict("missbigscore1switch_trevor_piss")
--		while not HasAnimDictLoaded("missbigscore1switch_trevor_piss") do
--			Citizen.Wait(100)
--		end
--		TaskPlayAnim(ped, "missbigscore1switch_trevor_piss", "piss_loop", 8.0, -8, -1, 49, 0, 0, 0, 0)
--		Citizen.Wait(13000)
--		ClearPedTasksImmediately(ped)
--	end
--end) 


--##ANIMACJA HERBATY##

--RegisterNetEvent('esx_kuchenka:onHerbata')
--AddEventHandler('esx_kuchenka:onHerbata', function()
--	TaskStartScenarioInPlace(PlayerPedId(), "mini@drinking", 0, true)
--	Citizen.Wait(15000)
--	ClearPedTasksImmediately(PlayerPedId())
--end)
