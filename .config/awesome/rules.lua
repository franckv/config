awful.rules.rules = awful.util.table.join(awful.rules.rules, {
    { rule = { class = "Navigator" }, properties = { tag = tags[1][2] } },
    { rule = { class = "Sonata" }, properties = { tag = tags[1][3] } },
    { rule = { class = "Vlc" }, properties = { tag = tags[1][4] } },
    { rule = { class = "Pidgin" }, properties = { tag = tags[1][5] } },
    { rule = { class = "Pcmanfm" }, properties = { tag = tags[1][6] } },
    --{ rule = { class = "OpenOffice.org 3.1" }, properties = { tag = tags[1][7] } },
    { rule = { class = "Wicd-client.py" }, properties = { tag = tags[1][8] } }
})
