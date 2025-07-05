local menuPages = {
    {
        { name = "chat", action = function() shell.run("OS/programs/chat.lua") end },
        { name = "sendFile", action = function() shell.run("OS/programs/sendfile.lua") end },
        { name = "recvFile", action = function() shell.run("OS/programs/recvfile.lua") end },
        { name = "Back", action = function() shell.run("OS/Menu.lua") end },
    },
    {
        { name = "Notepad", action = function() print("Notepad coming soon") end },
        { name = "Calculator", action = function() print("Calculator coming soon") end },
        { name = "Settings", action = function() print("Settings coming soon") end },
        { name = "Back", action = function() shell.run("OS/Menu.lua") end },
    }
}

local currentPage = 1
local selection = 1

local function drawMenu()
    term.clear()
    local w,h = term.getSize()

    -- header
    term.setCursorPos(1,1)
    term.write("IOS")
    term.setCursorPos(1,2)
    term.write("V1.0.0 Page " .. currentPage .. "/" .. #menuPages)

    local menuItems = menuPages[currentPage]
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
        if selection < 1 then selection = #menuPages[currentPage] end
    elseif key == keys.down then
        selection = selection + 1
        if selection > #menuPages[currentPage] then selection = 1 end
    elseif key == keys.left then
        currentPage = currentPage - 1
        if currentPage < 1 then currentPage = #menuPages end
        selection = 1
    elseif key == keys.right then
        currentPage = currentPage + 1
        if currentPage > #menuPages then currentPage = 1 end
        selection = 1
    elseif key == keys.enter then
        term.clear()
        term.setCursorPos(1,1)
        menuPages[currentPage][selection].action()
        break  -- remove if you want to return to menu after action
    end
end
