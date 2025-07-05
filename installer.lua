-- Installer script

local base = "https://raw.githubusercontent.com/ScaryWizard69/CC-Tweaked-OS/main/"


local files = {
  { url = "startup.lua", dest = "startup.lua" },
  { url = "OS/Menu.lua", dest = "OS/Menu.lua" },
  { url = "OS/back.lua", dest = "OS/back.lua" },
  { url = "OS/Command.lua", dest = "OS/Command.lua" },
  { url = "OS/uninstall.lua", dest = "OS/uninstall.lua"},
  { url = "OS/programs.lua", dest = "OS/programs.lua"},
  { url = "OS/programs/chat.lua", dest = "OS/programs/chat.lua"},
  { url = "OS/programs/sendfile.lua", dest = "OS/programs/sendfile.lua"},
  { url = "OS/programs/recvfile.lua", dest = "OS/programs/recvfile.lua"},
}

shell.run("mkdir", "OS")
shell.run("mkdir", "OS/programs")

for _, file in ipairs(files) do
  local fullUrl = base .. file.url
  local ok, err = http.get(fullUrl)
  if ok then
    local handle = fs.open(file.dest, "w")
    handle.write(ok.readAll())
    handle.close()
    ok.close()
    print("Downloaded: " .. file.dest)
  else
    print("Failed to download: " .. file.url)
  end
end

print("\nDone! Run `reboot` or `startup` to boot MyOS.")
fs.delete("installer.lua")