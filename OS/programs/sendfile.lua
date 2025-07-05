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
print("==File Sharer==")
write("Enter Target ID: ")
local Target = tonumber(read())
write("File To Send: ")
local FileName = read()

if not fs.exists(FileName) then
    print("File Does Not Exist")
    return
end

local File = fs.open(FileName, "r")
local content = File.readAll()
File.close()

local chunks = {}
local chunkSize = 1024
for i = 1, #content, chunkSize do
    tabel.insert(chunks, content:sub(i, i +  chunkSize - 1))
end

rednet.send(Target, textutils.serialize({type="file_start", name=FileName, total=#chunks}))

for i, chunk in ipairs(chunks) do
  rednet.send(target, textutils.serialize({type="file_chunk", index=i, data=chunk}))
  sleep(0.05)  -- brief pause to avoid flooding
end

-- Finish
rednet.send(target, textutils.serialize({type="file_end", name=filename}))
print("File sent successfully!")