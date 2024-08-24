script_name("Admin&recon checker")
script_version("0.1.0")


local encoding = require("encoding")
encoding.default = "CP1251"
local u8 = encoding.UTF8

local COLOR_AQUA = 0x7FFFD4
local COLOR_WARNING = 0xFFD700
local FONT = renderCreateFont("Georgia", 8, 0)
local active = false

local window_width, window_height = getScreenResolution()
local FILE_PATH = "moonloader/admins.txt"
local ADMIN_LIST = {}
local admin_list_x = window_width / 4
local admin_list_y = window_height / 2


function loadAdminList()
    ADMIN_LIST = {}
    collectgarbage()
    local file = io.open(FILE_PATH, "r")
    local nickname = file:read("*line")
    while nickname do
        nickname:gsub("%s+", "")
        table.insert(ADMIN_LIST, nickname)
        ADMIN_LIST[nickname] = true
        nickname = file:read("*line")
    end
    file:close()
    sampAddChatMessage(u8:decode"Загружено админов: " .. tostring(#ADMIN_LIST), COLOR_AQUA)
end

loadAdminList()

function helloMessage()
    local msg = string.format("%s %s by alisson loaded!", thisScript().name, thisScript().version)
    sampAddChatMessage(msg, COLOR_AQUA)
    sampAddChatMessage("- /chk to show/hide admin list", COLOR_WARNING)
    sampAddChatMessage("- /cre to enable/disable recon checker", COLOR_WARNING)
    sampAddChatMessage("- /aupd to update admin list", COLOR_WARNING)
end

function getAdminList()
    local founded = {u8:decode"Админы в сети:"}
    for id = 0, 1000 do
        if sampIsPlayerConnected(id) then
            nickname = sampGetPlayerNickname(id)
            if ADMIN_LIST[nickname] then
                table.insert(founded, "[" .. tostring(id) .. "] " .. nickname)
            end
        end
    end
    if #founded == 1 then
        return u8:decode"Админов нет в сети"
    end
    return table.concat(founded, "\n")
end

function showAdminList()
    if not active then
        printStringNow("ACTIVE", 1500)
    else
        printStyledString("Kek", 1000, 7)
    end
    active = not active
end

function reconChecker()
    printStyledString(u8:decode"Скоро будет доступно", 2000, 7)
end

function main()
    if not isSampLoaded or not isSampfuncsLoaded then return end
    while not isSampAvailable() do wait(0) end
    helloMessage()
    sampRegisterChatCommand("chk", showAdminList)
    sampRegisterChatCommand("cre", reconChecker)
    sampRegisterChatCommand("aupd", loadAdminList)
    while true do 
        wait(0)
        if active then
            renderFontDrawText(FONT, getAdminList(), admin_list_x, admin_list_y, 0xFFFFFFFF, 0x90000000)
        end
    end
end
