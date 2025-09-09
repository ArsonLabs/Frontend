gurt.select('#register'):on('click', function()
    local input = gurt.select('#username')
    local username = input.value
    local input = gurt.select('#password')
    local password = input.value
    local input = gurt.select('#password2')
    local password2 = input.value
    
    if password==password2 then
        local response = fetch('https://arsonbase.smart.is-a.dev/api/user/register', {
            method = 'POST',
            headers = {
                ['Content-Type'] = 'application/json',
            },
            body = JSON.stringify({
                username = username,
                password = password,
            })
        })
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
    else    
        gurt.select('#notmatch').text = 'Passwords do not match.'
        gurt.select('#notmatch2').text = 'Passwords do not match.'
    end
end)