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


print("== File Receiver ==")
print("Waiting for file...")

local incoming = {}
local fileName = nil
local totalChunks = 0

while true do
  local _, msg = rednet.receive()
  local data = textutils.unserialize(msg)

  if data and data.type == "file_start" then
    print("Receiving: " .. data.name)
    fileName = data.name
    totalChunks = data.total
    incoming = {}
  elseif data and data.type == "file_chunk" then
    incoming[data.index] = data.data
    print("Received chunk " .. data.index .. " of " .. totalChunks)
  elseif data and data.type == "file_end" then
    -- Reconstruct file
    local f = fs.open(fileName, "w")
    for i = 1, #incoming do
      f.write(incoming[i])
    end
    f.close()
    print("File saved as " .. fileName)
    break
  end
end
