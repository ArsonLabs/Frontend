gurt.select('#login'):on('click', function()
    local input = gurt.select('#username')
    local username = input.value
    local input = gurt.select('#password')
    local password = input.value
    

    local response = fetch('https://arsonbase.smart.is-a.dev/api/user/login', {
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
        local data = response:json()
        gurt.crumbs.set({
            name = "JWT_TOKEN_DO_NOT_SHARE",
            value = data.token,
            lifetime = 259200
        })
        gurt.location.goto("gurt://localhost/dashboard")
    else
        local text = response:text()
        gurt.select('#error').text = "Error " .. response.status .. ": " .. text
    end
end)