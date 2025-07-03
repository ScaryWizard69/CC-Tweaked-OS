-- Secure Uninstaller for MyOS with menu fallback

local CONFIRM_CODE = "d31et3Th3OS" -- Secret code

write("Enter uninstall code to continue: ")
local input = read("*")

if input ~= CONFIRM_CODE then
  print("\nIncorrect code. Returning to menu...")
  sleep(1)
  shell.run("OS/Menu.lua")
  return
end

-- Perform uninstall
if fs.exists("startup.lua") then fs.delete("startup.lua") end
if fs.exists("OS") then fs.delete("OS") end

print("Uninstall complete. MyOS has been removed.")
