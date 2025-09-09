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
            local text = response:text()  -- Get as text
            
            gurt.location.goto("gurt://arson.dev/login")
        else
            local text = response:text()
            gurt.select('#notmatch').text = "Error " .. response.status .. ": " .. text
        end
    else    
        gurt.select('#notmatch').text = 'Passwords do not match.'
        gurt.select('#notmatch2').text = 'Passwords do not match.'
    end
end)