local token = gurt.crumbs.get("JWT_TOKEN_DO_NOT_SHARE")
if token then 
    trace.log(token)
else 
    gurt.location.goto("gurt://arson.dev/login")
end

gurt.select('#deploy'):on('click', function()
    local domain = gurt.select('#domain').value
    local response = fetch('gurt://dns.web/domain/' .. domain .. '/records', {
        method = 'get',
        headers = {
            ['Content-Type'] = 'application/json',
        }
    })
    
    -- Check response
    if response:ok() then
        local data = response:json()  -- Parse JSON response
        local text = response:text()  -- Get as text
        
        trace.log('Status: ' .. response.status)
        trace.log('Status Text: ' .. response.statusText)
        
        -- Access headers
        local contentType = response.headers['content-type']
    else
        trace.log('Request failed with status: ' .. response.status)
    end
end)

gurt.select('#type'):on('change', function(event)
    if event.value == "option1" then
        gurt.select('#origin-text').text = 'Input the github repo for the website.'
    else
        gurt.select('#origin-text').text = 'Input the origin ip.'
    end
end)
