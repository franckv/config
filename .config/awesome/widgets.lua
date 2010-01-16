function setFg(color, text)
    return '<span color="'..color..'">'..text..'</span>'
end

function batteryInfo(adapter)
    mybatterywidget.text = adapter

    local spacer = " "
    local fcur = io.open("/sys/class/power_supply/"..adapter.."/charge_now")    
    local fcap = io.open("/sys/class/power_supply/"..adapter.."/charge_full")
    local fsta = io.open("/sys/class/power_supply/"..adapter.."/status")

    if not fcur or not fcap or not fsta then
	dir = "="
	battery = "A/C"
        mybatterywidget.text = dir..battery..dir.." "
        return
    end

    local cur = fcur:read()
    local cap = fcap:read()
    local sta = fsta:read()
    local battery = math.floor(cur * 100 / cap)
    if sta:match("Charging") then
	dir = "^"
	battery = "A/C ("..battery..")"
    elseif sta:match("Discharging") then
	dir = "v"
	if tonumber(battery) > 25 and tonumber(battery) < 75 then
	    battery = setFg("#e6d51d", battery)
	elseif tonumber(battery) < 25 then
	    if tonumber(battery) < 10 then
		naughty.notify({ title      = "Battery Warning"
		, text       = "Battery low!"..spacer..battery.."%"..spacer.."left!"
		, timeout    = 5
		, position   = "top_right"
		, fg         = beautiful.fg_focus
		, bg         = beautiful.bg_focus })
	    end
	    battery = setFg("#ff6565", battery)
	else
	    battery = battery
	end
    else
	dir = "="
	battery = "A/C"
    end
    mybatterywidget.text = dir..battery..dir.." "
    fcur:close()
    fcap:close()
    fsta:close()
end

function mpdInfo()
  local stats = mpd.send("status")

  if not stats.state then
      mpdwidget.text = " --- "
      return
  end

  if stats.state == "stop" then
      mpdwidget.text = " --- "
      return
  end

  local pos = stats.song + 1
  local len = stats.playlistlength
  --local zstats = mpd.send("playlistid " .. stats.songid)
  local zstats = mpd.send("currentsong")
  local artist = zstats.artist
  local song = zstats.title
  local current = os.date("%M:%S", stats.time:match("(%d+):"))
  local total = os.date("%M:%S", stats.time:match("%d+:(%d+)"))

  mpdwidget.text = ' <i>' .. artist .. " - " .. song .. ' ' .. current .. "/" .. total .. ' [' .. pos .. '/' .. len .. ']</i> '
end

function splitbywhitespace(str)
    values = {}
    start = 1
    splitstart, splitend = string.find(str, ' ', start)
    
    while splitstart do
        m = string.sub(str, start, splitstart-1)
        if m:gsub(' ','') ~= '' then
            table.insert(values, m)
        end

        start = splitend+1
        splitstart, splitend = string.find(str, ' ', start)
    end

    m = string.sub(str, start)
    if m:gsub(' ','') ~= '' then
        table.insert(values, m)
    end

    return values
end

function fsInfo(format)
    local f = io.popen('df -h')
    local result = format

    for line in f:lines() do
        vars = splitbywhitespace(line)
        
        if #vars == 6 then
            vars[5] = vars[5]:gsub('%%','')

	    result = result:gsub('%${'..vars[6]..' size}', vars[2])
	    result = result:gsub('%${'..vars[6]..' used}', vars[3])
	    result = result:gsub('%${'..vars[6]..' avail}', vars[4])
        end
    end

    f:close()
    fswidget.text = result
end


