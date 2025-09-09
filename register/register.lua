gurt.select('#register'):on('click', function()
    local input = gurt.select('#username')
    local username = input.value
    local input = gurt.select('#password')
    local password = input.value
    local input = gurt.select('#password2')
    local password2 = input.value
    
    if password==password2 then
        trace.log("Create account")
    else    
        gurt.select('#notmatch').text = 'Passwords do not match.'
        gurt.select('#notmatch2').text = 'Passwords do not match.'
    end
end)