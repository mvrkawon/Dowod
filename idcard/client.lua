--
--LICENSE
--
--ZAKAZ USUWANIA TEKSTU Z TEGO PLIKU
--
--Całkowity zakaz jakiegokolwiek przekazywania skryptu.
--Konsekwencje odsprzedaży lub darmowego przekazania skryptu opisane jest w art. 116 KK
--Więcej informacji w http://www.prawoautorskie.pl/art-116	

ESX                           = nil
local PlayerData                = {}
local coordsstart = vector3(244.54, 373.83, 104.78)
Citizen.CreateThread(function()

	while ESX == nil do
		TriggerEvent('esx:getShiwannabeaidontknowaredObjiwannabeaidontknowect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)
local npc 
local created = false
RegisterNetEvent('esx:spawnpedserver')
AddEventHandler('esx:spawnpedserver', function(x,y,z,h)
	Citizen.Wait(100)
	if not created and not DoesEntityExist(npc)then
		RequestModel(GetHashKey("a_m_y_beach_03"))
		while not HasModelLoaded(GetHashKey("a_m_y_beach_03")) do
			Citizen.Wait(100)
		end	
		if not DoesEntityExist(npc) then
		npc = CreatePed(4, 0xE7A963D9, x, y, z, h, false, true)	
		created = true
		end		
		SetEntityAsMissionEntity(npc, true, true)
		TaskStartScenarioInPlace(npc, "WORLD_HUMAN_SMOKING", 0, true)
	end
end)
Config = {}
Config.Zones = {}

RegisterNetEvent('kaiser_dowod:odebranie')
AddEventHandler('kaiser_dowod:odebranie', function(x,y,z,h)
Config.Zones.dowod = {}
Config.Zones.dowod.text = "Odbierz dowód"
Config.Zones.dowod.Pos = {}
Config.Zones.dowod.Pos.x = x
Config.Zones.dowod.Pos.y = y
Config.Zones.dowod.Pos.z = z+0.6
Config.Zones.dowod.Pos.h = h
end)
-- Display markers		
	
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)

			for k,v in pairs(Config.Zones) do	

			local distance = GetDistanceBetweenCoords(coords, v.Pos.x,v.Pos.y,v.Pos.z, true)
			if distance < 100 then
					if not created then
						TriggerServerEvent('esx:spawnpedserver',v.Pos.x,v.Pos.y,v.Pos.z,v.Pos.h)
					end
					
				if distance < 6 then

					local Texcik5 = {
						["x"] = v.Pos.x,
						["y"] = v.Pos.y,
						["z"] = v.Pos.z+0.7
					}	
	
					DrawText3D(v.Pos.x, v.Pos.y, v.Pos.z, v.text)
					if IsControlJustReleased(0, 38) then
						--ide = v.id+1
						--ESX.ShowNotification("~g~Możesz udać się w kolejne miejsce")
						--TriggerServerEvent('zagadka:etap', v.id)
						local playerPed = PlayerPedId()
						ClearPedTasks(npc)
						Citizen.Wait(5000)
						ClearPedTasksImmediately(npc)
						AttachEntityToEntity(GetPlayerPed(-1), npc, 11816, 0.1, 1.15, 0.0, 0.0, 0.0, 180.0, false, false, false, false, 20, false)						
						ESX.Streaming.RequestAnimDict("mp_ped_interaction", function()
							TaskPlayAnim(npc, "mp_ped_interaction", "handshake_guy_b", 8.0, -8.0, -1, 0, 0, false, false, false)
						end)
						
						ESX.Streaming.RequestAnimDict("mp_ped_interaction", function()
							TaskPlayAnim(PlayerPedId(), "mp_ped_interaction", "handshake_guy_a", 8.0, -8.0, -1, 0, 0, false, false, false)
						end)
						Citizen.Wait(2500)
						ClearPedTasksImmediately(npc)
						ESX.Streaming.RequestAnimDict("mp_common", function()
							TaskPlayAnim(npc, "mp_common", "givetake1_a", -8.0, 8.0, -1, 0, 0, false, false, false)
						end)							
						Citizen.Wait(1800)
						TaskWanderStandard(npc,10.0,10)
						SetPedAsNoLongerNeeded(npc)						
						DetachEntity(GetPlayerPed(-1), true, false)
						Config.Zones.dowod = nil
						ESX.ShowNotification("Odebrałeś fałszywy dowód (Pageup > Dowód)")
						TriggerServerEvent('kaiser_dowod:odebranie', true)
						created = false
						SetEntityAsMissionEntity(npc, false, true)
					end

						--ESX.Game.Utils.DrawText3D(Texcik5, "Maxim Petrov \nZmarł 15-07-2020", 0.55, 1.5, "~b~TABLICZKA", 0.7)						
				end
			end
		end	
	end
end)

DrawText3D = function(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local factor = #text / 370
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	DrawRect(_x,_y + 0.0225, 0.06 , 0.05, 0, 0, 0, 60)
end

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), coordsstart, true) < 3.0 then
				ESX.ShowHelpNotification("Wciśnij ~INPUT_CONTEXT~ Aby wyrobić fejkowy dowód")
			if (IsControlJustReleased(1, 38)) then
				Menu()
			end
		end
	end
end)

function Menu()
	local elements = {
		{label = 'Cena 25000$', value = 'cena'},
		{label = 'Kliknij aby przyjąć ofertę', value = 'oferta'},	
	}

	


	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fejkdowod', {
		title    = 'Informacje',
		align    = 'center',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'oferta' then
			menu.close()
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'imienazwisko', {
				title = "Wpisz Imię Nazwisko"
			}, function(data2, menu2)
				local imienazwisko = data2.value
				menu2.close()
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'tele', {
						title = "Wpisz Numer Telefonu na który ma przyjść GPS"
					}, function(data3, menu3)
						local tel = data3.value
						TriggerServerEvent('kaiser_dowod:fejk', imienazwisko, tel)


						menu3.close()
					end, function(data3, menu3)
						menu3.close()
					end)
			end, function(data2, menu2)
				menu2.close()
			end)
			--TriggerServerEvent('kaiser_dowod:fejk')
		end
	end, function(data, menu)
		menu.close()
	end)
end

function ShowAdvancedNotification(title, subject, msg, icon, iconType)

	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	SetNotificationMessage(icon, icon, false, iconType, title, subject)
	DrawNotification(false, false)

end
RegisterNetEvent('esx:dowod_pokazdowod')
AddEventHandler('esx:dowod_pokazdowod', function(id, imie, data, dodatek)


local praca = PlayerData.job.label

  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid ~= -1 then
	  local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(pid))
	  if pid == myId then
		ShowAdvancedNotification(imie, data, dodatek, mugshotStr, 8)

	  elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
	 ShowAdvancedNotification(imie, data, dodatek, mugshotStr, 8)

	  end
	  
	  UnregisterPedheadshot(mugshot)
	end
end)

RegisterNetEvent('esx:dowod_wiz')
AddEventHandler('esx:dowod_wiz', function(id, imie, data,dodatek)

if PlayerData then
local praca = PlayerData.job.label

  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
   if pid ~= -1 then 
	  local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(pid))
	  if pid == myId then
	ShowAdvancedNotification(imie, data, dodatek, mugshotStr, 8)

	  elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
	 ShowAdvancedNotification(imie, data, dodatek, mugshotStr, 8)

	  end
	  
	  UnregisterPedheadshot(mugshot)
	end
end	
	
end)
