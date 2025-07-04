local menuItems = {
    { name = "chat", action = function() shell.run("OS/programs/chat.lua") end}
}

local selection = 1

local function drawMenu()
    term.clear()
    local w,h = term.getSize()

    -- header
    term.setCursorPos(1,1)
    term.write("IOS")
    term.setCursorPos(1,2)
    term.write("V1.0.0")

    -- centered menu
    local startY = math.floor((h - #menuItems) / 2)
    for i, item in ipairs(menuItems) do
        local prefix = (i == selection) and "-> " or "   "
        local text = prefix .. item.name
        local x = math.floor((w - #text) / 2)
        term.setCursorPos(x, startY + i - 1)
        term.write(text)
    end

    -- footer
    term.setCursorPos(1, h)
    term.write("CopyWrite PublishWeb 2025")
end

while true do
    drawMenu()
    local event, key = os.pullEvent("key")

    if key == keys.up then
        selection = selection - 1
        if selection < 1 then selection = #menuItems end
    elseif key == keys.down then
        selection = selection + 1
        if selection > #menuItems then selection = 1 end
    elseif key == keys.enter then
        term.clear()
        term.setCursorPos(1,1)
        menuItems[selection].action()
        break  -- remove this break if you want to return to menu after running action
    end
end