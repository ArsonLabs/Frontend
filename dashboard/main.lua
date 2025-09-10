local token = gurt.crumbs.get("JWT_TOKEN_DO_NOT_SHARE")
if not token then 
    gurt.location.goto("gurt://arsonflare.aura/login")
end

local domains_list = {}

local function render_domains()
    local text_content = ""
    for _, domain in ipairs(domains_list) do
        text_content = text_content .. "Domain: " .. domain.domain
        text_content = text_content .. "  Protocol: " .. domain.protocol
        text_content = text_content .. "  Origin: " .. domain.origin .. "\n\n"
        gurt.select('#domain-list').text = text_content
    end
    
end

local function fetch_domains()
    local response = fetch('https://arsonbase.smart.is-a.dev/api/domains', {
        headers = {
            ['Authorization'] = 'Bearer ' .. token
        }
    })

    if response:ok() then
        local data = response:json()
        gurt.select('#username').text = "Welcome, " .. data.username
        domains_list = data.domains
        render_domains()
    else
        gurt.select('#error').text = "Failed to fetch domains: " .. response:text()
        trace.log(response:text())
        if response.status == 401 then
            gurt.crumbs.delete("JWT_TOKEN_DO_NOT_SHARE")
            gurt.location.goto("gurt://arsonflare.aura/login")
        end
    end
end

gurt.select('#type'):on('change', function(event)
    if event.value == "option1" then
        gurt.select('#origin-text').text = 'Input the github repo for the website.'
    else
        gurt.select('#origin-text').text = 'Input the origin ip.'
    end
end)

gurt.select('#deploy'):on('click', function()
    local domain_name = gurt.select('#domain').value
    local origin = gurt.select('#origin').value
    local type_select = gurt.select('#type').value
    local protocol = (type_select == "option1" and "static" or "proxy")

    local domain_exists = false
    for _, d in ipairs(domains_list) do
        if d.domain == domain_name then
            domain_exists = true
            break
        end
    end

    local url
    local body
    if domain_exists then
        -- Update existing domain
        url = 'https://arsonbase.smart.is-a.dev/api/domains/' .. domain_name
        body = JSON.stringify({
            protocol = protocol,
            origin = origin
        })
    else
        -- Add new domain
        url = 'https://arsonbase.smart.is-a.dev/api/domains'
        body = JSON.stringify({
            domain = domain_name,
            protocol = protocol,
            origin = origin
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
