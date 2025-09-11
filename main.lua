gurt.select('#register'):on('click', function()
    gurt.location.goto("gurt://arsonflare.aura/register")
end)
gurt.select('#login1'):on('click', function()
    gurt.location.goto("gurt://arsonflare.aura/login")
end)
gurt.select('#register1'):on('click', function()
    gurt.location.goto("gurt://arsonflare.aura/register")
end)

 
gurt.select('#discord'):on('click', function()
    gurt.location.goto("https://discord.gg/a4GVk5gbxv")
end)
gurt.select('#docs'):on('click', function()
    gurt.location.goto("gurt://arsonflare.aura/docs")
end)
gurt.select('#docs2'):on('click', function()
    gurt.location.goto("gurt://arsonflare.aura/docs")
end)
local uptimeSigma = 0
local response = fetch('https://arsonbase.smart.is-a.dev/api/metrics')

if response:ok() then
    local text = response:json()
    
    trace.log('Status: ' .. response.status)
    local uptime = gurt.select('#uptime')
    local requests = gurt.select('#requests')
    local turnaround = gurt.select('#turnaround')
    uptime.text = 'Uptime: ' .. text.uptime .. 's'
    uptimeSigma = text.uptime
    requests.text = 'Requests handled since restart ' .. text.requests_handled
    turnaround.text = 'Average processing time: ' .. text.turnaround_time .. ' microseconds'
else
    trace.log('Request failed with status: ' .. response.status)
end

local intervalId = setInterval(function()
    local uptime = gurt.select('#uptime')
    uptimeSigma = uptimeSigma + 1
    uptime.text = 'Uptime: ' .. uptimeSigma .. 's'
local response = fetch('https://arsonbase.smart.is-a.dev/api/metrics')
if response:ok() then
    local text = response:json()
    
    trace.log('Status: ' .. response.status)
    local requests = gurt.select('#requests')
    local turnaround = gurt.select('#turnaround')
    requests.text = 'Requests handled since restart ' .. text.requests_handled
    turnaround.text = 'Average processing time: ' .. text.turnaround_time .. ' microseconds'
else
    trace.log('Request failed with status: ' .. response.status)
end
end, 1000)