local token = gurt.crumbs.get("JWT_TOKEN_DO_NOT_SHARE")
if not token then 
    gurt.location.goto("gurt://arsonflare.aura/login")
end

local domains_list = {}

local function render_domains()
    local text_content = ""
    for _, domain in ipairs(domains_list) do
        text_content = text_content .. "Name: " .. domain.name
        text_content = text_content .. " ID: " .. domain.id
        text_content = text_content .. "  Redirect URL: " .. domain.redirect_url .. "\n\n"
        gurt.select('#domain-list').text = text_content
    end
    
end

local function fetch_domains()
    local response = fetch('https://arsonbase.smart.is-a.dev/api/sites', {
        headers = {
            ['Authorization'] = 'Bearer ' .. token
        }
    })

    if response:ok() then
        local data = response:json()
        gurt.select('#username').text = "Welcome, " .. data.username
        domains_list = data.sites
        render_domains()
    else
        gurt.select('#error').text = "Failed to fetch domains: " .. response:text()

        if response.status == 401 then
            gurt.crumbs.delete("JWT_TOKEN_DO_NOT_SHARE")
            gurt.location.goto("gurt://arsonflare.aura/login")
        end
    end
end

gurt.select('#deploy'):on('click', function()
    local website_name = gurt.select('#name').value
    local redirect_url = gurt.select('#redirectUrl').value

    local website_exists = false
    for _, d in ipairs(domains_list) do
        if d.domain == website_name then
            website_exists = true
            break
        end
    end

    local url
    local body
    if website_exists then
        url = 'https://arsonbase.smart.is-a.dev/api/sites/' .. website_name
        body = JSON.stringify({
            redirect_url = redirect_url,
        })
    else
        url = 'https://arsonbase.smart.is-a.dev/api/site/register'
        body = JSON.stringify({
            name = website_name,
            redirect_url = redirect_url,
        })
    end

    local response = fetch(url, {
        method = 'POST',
        headers = {
            ['Content-Type'] = 'application/json',
            ['Authorization'] = 'Bearer ' .. token
        },
        body = body
    })

    if response:ok() then
        gurt.select('#error').text = "Success!"
        fetch_domains() -- Refresh list
    else
        gurt.select('#error').text = "Error: " .. response:text()
    end
end)

gurt.select('#logout'):on('click', function()
    gurt.crumbs.delete("JWT_TOKEN_DO_NOT_SHARE")
    gurt.location.goto("gurt://arsonflare.aura/login")
end)


fetch_domains()