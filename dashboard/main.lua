local token = gurt.crumbs.get("JWT_TOKEN_DO_NOT_SHARE")
if not token then 
    gurt.location.goto("gurt://arsonflare.aura/login")
end

local response = fetch('https://arsonbase.smart.is-a.dev/api/domains', {
    headers = {
        ['Authorization'] = 'Bearer ' .. token
    }
})

if response:ok() then
    local data = response:json()
    gurt.select('#username').text = "Welcome, " .. data.username
    domains_list = data.domains
else
    if response.status == 401 then
        gurt.crumbs.delete("JWT_TOKEN_DO_NOT_SHARE")
        gurt.location.goto("gurt://arsonflare.aura/login")
    end
end

gurt.select('#hosting'):on('click', function()
    gurt.location.goto("gurt://arsonflare.aura/dashboard/dns")
end)

gurt.select('#serverless'):on('click', function()
    gurt.location.goto("gurt://arsonflare.aura/dashboard/serverless")
end)

gurt.select('#logout'):on('click', function()
    gurt.crumbs.delete("JWT_TOKEN_DO_NOT_SHARE")
    gurt.location.goto("gurt://arsonflare.aura/login")
end)
