local token = gurt.crumbs.get("JWT_TOKEN_DO_NOT_SHARE")

local currentUrl = gurt.location.href
local query = currentUrl:match("%?(.*)")

-- Table to store parameters
local params = {}

if query then
    for key, value in query:gmatch("([^&=?]+)=([^&=?]+)") do
        params[key] = value
    end
end
-- Access your values
local appid = params["appid"]
local redirect = params["redirect"]

if not token then
    gurt.location.goto("gurt://arsonflare.aura/login?redirect=" .. gurt.location.href)
end

local response = fetch('https://arsonbase.smart.is-a.dev/api/user/verify', {
    method = 'get',
    headers = {
        ['Authorization'] = 'Bearer ' .. token,
    },
})
if not response:ok() then
    gurt.location.goto("gurt://arsonflare.aura/login?redirect=" .. gurt.location.href)
end

local response = fetch('https://arsonbase.smart.is-a.dev/api/site/verify', {
    method = 'POST',
    headers = {
        ['Content-Type'] = 'application/json',
    },
    body = JSON.stringify({
        site_id = appid,
    })
})
if response:ok() then
    local siteName = response:json().name
    gurt.select("#appName").text = siteName
else
    local text = response:text()
    gurt.select('#error').text = "Error " .. response.status .. ": " .. text
end

gurt.select('#authorize'):on('click', function()
    local response = fetch('https://arsonbase.smart.is-a.dev/api/site/verify', {
        method = 'POST',
        headers = {
            ['Content-Type'] = 'application/json',
        },
        body = JSON.stringify({
            site_id = appid,
        })
    })
    if response:ok() then
        local data = response:json()
        local site_redirect = data.redirect_url

        local response = fetch('https://arsonbase.smart.is-a.dev/api/oauth2/login', {
            method = 'POST',
            headers = {
                ['Content-Type'] = 'application/json',
                ['Authorization'] = 'Bearer ' .. token,
            },
            body = JSON.stringify({
                app_id = appid,
            })
        })
        if response:ok() then
            local siteToken = response:json().token
            gurt.location.goto(site_redirect .. "?token=" .. siteToken)
        else
            local text = response:text()
            gurt.select('#error').text = "Error " .. response.status .. ": " .. text
        end
    else
        local text = response:text()
        gurt.select('#error').text = "Error " .. response.status .. ": " .. text
    end
end)