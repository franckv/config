local io = io
local os = os
local string = string
local table = table
local math = math
local tonumber = tonumber
local awful = require("awful")
local widget = widget
local timer = timer
require("lib/mpd")
local mpd = mpd

module("widgets")

batterywidget = widget({ type = "textbox" })
mpdwidget = widget({ type = "textbox" })
mpdwidget:buttons({awful.button({ }, 1, function () mpd.toggle_play() end)})
fswidget = widget({ type = "textbox" })

function setFg(color, text)
    return '<span color="'..color..'">'..text..'</span>'
end

function batteryInfo(adapter)
    batterywidget.text = adapter

    local spacer = " "
    local fcur = io.open("/sys/class/power_supply/"..adapter.."/charge_now")    
    local fcap = io.open("/sys/class/power_supply/"..adapter.."/charge_full")
    local fsta = io.open("/sys/class/power_supply/"..adapter.."/status")

    if not fcur or not fcap or not fsta then
	dir = "="
	status = "A/C"
        batterywidget.text = dir..status..dir.." "
        return
    end

    local cur = fcur:read()
    local cap = fcap:read()
    local sta = fsta:read()
    local status = math.floor(cur * 100 / cap)
    if sta:match("Charging") then
	dir = "^"
	status = "A/C ("..status..")"
    elseif sta:match("Discharging") then
	dir = "v"
	if tonumber(status) > 25 and tonumber(status) < 75 then
	    status = setFg("#e6d51d", status)
	elseif tonumber(status) < 25 then
	    if tonumber(status) < 10 then
		naughty.notify({ title      = "Battery Warning"
		, text       = "Battery low!"..spacer..status.."%"..spacer.."left!"
		, timeout    = 5
		, position   = "top_right"
		, fg         = beautiful.fg_focus
		, bg         = beautiful.bg_focus })
	    end
	    status = setFg("#ff6565", status)
	else
	    status = status
	end
    else
	dir = "="
	status = "A/C"
    end
    batterywidget.text = dir..status..dir.." "
    fcur:close()
    fcap:close()
    fsta:close()
end
batteryInfo("BAT0")
batTimer = timer { timeout = 20 }
batTimer:add_signal("timeout", function() batteryInfo("BAT0") end)
batTimer:start()

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
  local zstats = mpd.send("currentsong")
  local artist = awful.util.escape(zstats.artist)
  local song = awful.util.escape(zstats.title)
  local current = os.date("%M:%S", stats.time:match("(%d+):"))
  local total = os.date("%M:%S", stats.time:match("%d+:(%d+)"))

  mpdwidget.text = ' <i>' .. artist .. " - " .. song .. ' ' .. current .. "/" .. total .. ' [' .. pos .. '/' .. len .. ']</i> '
end
mpdInfo()
mpdTimer = timer {timeout = 2}
mpdTimer:add_signal("timeout", function() mpdInfo() end)
mpdTimer:start()

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
fsInfo("[/:${/ used}/${/ size} ~:${/home used}/${/home size}] ")
fsTimer = timer {timeout = 30}
fsTimer:add_signal("timeout", function() fsInfo('[/:${/ used}/${/ size} ~:${/home used}/${/home size}] ') end)
fsTimer:start()

