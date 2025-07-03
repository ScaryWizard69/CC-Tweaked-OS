-- Installer script

local base = "https://raw.githubusercontent.com/ScaryWizard69/CC-Tweaked-OS/refs/heads/main/installer.lua"

local files = {
  { url = "startup.lua", dest = "startup.lua" },
  { url = "OS/.Menu.lua", dest = "OS/Menu.lua" },
}

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
