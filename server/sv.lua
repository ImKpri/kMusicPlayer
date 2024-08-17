--ESX = nil
--TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX = exports["base"]:getSharedObject()

MySQL.ready(function()
    print('^1kMusicPlayer ^4STARTED')
end)

RegisterServerEvent('save_music_history')
AddEventHandler('save_music_history', function(url)
    local _source = source
    local playerName = GetPlayerName(_source)
    
    MySQL.Async.execute('INSERT INTO music_history (player_name, url) VALUES (@playerName, @url)', {
        ['@playerName'] = playerName,
        ['@url'] = url
    })
end)

RegisterServerEvent('get_music_history')
AddEventHandler('get_music_history', function()
    local _source = source
    MySQL.Async.fetchAll('SELECT * FROM music_history ORDER BY timestamp DESC LIMIT 10', {}, function(result)
        TriggerClientEvent('receive_music_history', _source, result)
    end)
end)

RegisterServerEvent('sync_sound')
AddEventHandler('sync_sound', function(soundId, position)
    TriggerClientEvent('play_synced_sound', -1, soundId, position)
end)
