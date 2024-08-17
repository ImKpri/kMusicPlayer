--[[ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)]]--
ESX = exports["base"]:getSharedObject()

local isPlaying = false
local currentSoundId = nil
local musicURL = ""
local historyData = {}

RegisterCommand(Config.Commands, function()
    OMusicPlayer()
end)

RegisterNetEvent('receive_music_history')
AddEventHandler('receive_music_history', function(data)
    historyData = data
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if isPlaying and currentSoundId then
            local playerCoords = GetEntityCoords(PlayerPedId())
            TriggerServerEvent('sync_sound', currentSoundId, playerCoords)
        end
    end
end)

RegisterNetEvent('play_synced_sound')
AddEventHandler('play_synced_sound', function(soundId, position)
    if not isPlaying then
        PlayUrlPos(soundId, musicURL, 0.7, position, true)
    end
end)

function PlayUrlPos(soundId, url, volume, position, loop)
    if soundId and url then
        SendNUIMessage({
            transactionType = 'playSound',
            transactionFile = url,
            transactionVolume = volume,
            transactionId = soundId,
            transactionLoop = loop or false,
            transactionPosition = position
        })
    end
end

OMusicPlayer = function()
    TriggerServerEvent('get_music_history')
    local MainPlayers = RageUI.CreateMenu("Music Menu", "Sélectionnez une option") 
    local MusicHistory = RageUI.CreateSubMenu(MainPlayers, "Historique des Musiques", "Historique des musiques jouées")
    
    RageUI.Visible(MainPlayers, true)
    
    Citizen.CreateThread(function()
        while RageUI.Visible(MainPlayers) do 
            Wait(0)
            RageUI.IsVisible(MainPlayers, function()
                RageUI.Button("Saisir URL de la musique", "Entrer un lien YouTube, Spotify, SoundCloud", {}, true, {
                    onSelected = function()
                        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 256)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0)
                            Wait(0)
                        end
                        if (GetOnscreenKeyboardResult()) then
                            musicURL = GetOnscreenKeyboardResult()
                        end
                    end
                })

                RageUI.Button("Jouer Musique", "Commencer à jouer la musique", {}, not isPlaying and musicURL ~= "", {
                    onSelected = function()
                        currentSoundId = GetSoundId()
                        PlayUrlPos(currentSoundId, musicURL, 0.7, GetEntityCoords(PlayerPedId()), true)
                        isPlaying = true
                        TriggerServerEvent('save_music_history', musicURL)
                    end
                })

                RageUI.Button("Arrêter Musique", "Arrête la musique en cours", {}, isPlaying, {
                    onSelected = function()
                        StopSound(currentSoundId)
                        ReleaseSoundId(currentSoundId)
                        isPlaying = false
                    end
                })

                RageUI.Separator()

                RageUI.Button("Historique des Musiques", "Historique des musiques jouées", {RightLabel = '→→'}, true, {}, MusicHistory)
            end)
            
            RageUI.IsVisible(MusicHistory, function()
                if #historyData == 0 then
                    RageUI.Separator("~r~Aucun historique trouvé")
                else
                    for i = 1, #historyData, 1 do
                        RageUI.Button("Joué par: " .. historyData[i].player_name, historyData[i].url, {}, true, {
                            onSelected = function()
                                local url = historyData[i].url
                                currentSoundId = GetSoundId()
                                PlayUrlPos(currentSoundId, url, 0.7, GetEntityCoords(PlayerPedId()), true)
                                isPlaying = true
                            end
                        })
                    end
                end
            end)

            if not RageUI.Visible(MainPlayers) and not RageUI.Visible(MusicHistory) then
                MainPlayers = RMenu:DeleteType('MainPlayers')
            end
        end
    end)
end