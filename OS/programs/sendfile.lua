local function openAllModems()
    local sides = {"top", "bottom", "left", "right", "front", "back"}
    for _, side in ipairs(sides) do
        if peripheral.getType(side) == "modem" then
            if not rednet.isOpen(side) then
                rednet.open(side)
                print("Opened modem on side: " .. side)
            end
        end
    end
end

openAllModems()

term.clear()
term.setCursorPos(1,1)
print("== File Sharer ==")
write("Enter Target Label: ")
local targetLabel = read()
write("File to Send: ")
local fileName = read()

if not fs.exists(fileName) then
    print("File does not exist.")
    return
end

-- Look up the ID using a custom protocol (or nil for all protocols)
local protocol = "fileshare"
local targetID = rednet.lookup(protocol, targetLabel)

if not targetID then
    print("Target not found on network.")
    sleep(2)
    shell.run("OS/Menu.lua")
end

-- Read file contents
local file = fs.open(fileName, "r")
local content = file.readAll()
file.close()

local chunks = {}
local chunkSize = 1024
for i = 1, #content, chunkSize do
    table.insert(chunks, content:sub(i, i + chunkSize - 1))
end

-- Send metadata
rednet.send(targetID, textutils.serialize({
    type = "file_start",
    name = fileName,
    total = #chunks
}), protocol)
sleep(0.1)

-- Send chunks
for i, chunk in ipairs(chunks) do
    rednet.send(targetID, textutils.serialize({
        type = "file_chunk",
        index = i,
        data = chunk
    }), protocol)
    sleep(0.05)
end

-- Send file end
rednet.send(targetID, textutils.serialize({
    type = "file_end",
    name = fileName
}), protocol)

print("File sent successfully!")
shell.run("OS/Menu.lua")