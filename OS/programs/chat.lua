-- chat.lua

-- Try to open rednet on all sides
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

-- Get your computer's ID
local id = os.getComputerID()

-- Ask user for their name
term.clear()
term.setCursorPos(1,1)
write("Enter your username: ")
local username = read()

openAllModems()
print("Your ID is: " .. id)
print("Type '/exit' to quit.")
print("Waiting for messages...")

-- Start parallel send/receive loop
parallel.waitForAny(
    function() -- Receiving
        while true do
            local senderID, msg = rednet.receive()
            print("\n[" .. senderID .. "] " .. msg)
            write("> ") -- Reset input line
        end
    end,

    function() -- Sending
        while true do
            write("> ")
            local message = read()

            if message == "/exit" then
                print("Exiting chat...")
                return
            end

            -- Send to all
            rednet.broadcast(username .. ": " .. message)
        end
    end
)
