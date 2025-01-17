---@diagnostic disable: redundant-parameter
DKP_ADDON_CORE = {}
-- To do:
-- Store the guild name and inside the officer ranks - support multi-guild 
-- Store DKP Backup in DKP_BackupData in case of no officer online
DKP_ADDON_CORE.defaultConfig = {
    ["DefaultGuild"] = {
        dkp_location = "OfficerNote",
        minDkpBid = 10,
        officerRanks = {
            "Auctioner",
            "Farmer",
        },
        isOfficerNoteVisible = false,
        showDkpInCharacterFrame = true,
        smallFrame = false,
        showOtherMemberDKPInRaidChat = false,
        raidFrame = "raid"
    }
}

DKP_ADDON_CORE.config = {}  -- Guild-specific config
DKP_ADDON_CORE.guildRanks = {}
DKP_ADDON_CORE.DkpAmount = 0
DKP_ADDON_CORE.EVENT_FRAME = CreateFrame("Frame")
DKP_ADDON_CORE.guildName = ""
DKP_ADDON_CORE.DKP_BackupData = {}  -- Backup data for DKP



DKP_ADDON_CORE.RaidHistory = {
    raidDateTime = "2025-01-11 20:00:00",  -- Date and time of the raid
    raidName = "Icecrown Citadel",        -- Name of the raid
    logs = {                              -- Logs for events within the raid
        {
            timestamp = "20:05:00",       -- Time of the event
            event = "join",               -- Event type: "join", "leave", "item"
            player = "PlayerOne",         -- Player involved
            details = nil,                -- Additional details (not applicable for "join" or "leave")
        },
        {
            timestamp = "20:30:00",
            event = "item",
            player = "PlayerTwo",
            details = {                   -- Details for the "item" event
                item = "Invincible's Reins", -- Item name
                method = "roll",          -- How the item was distributed: "dkp" or "roll"
                amount = nil,             -- DKP cost or roll value (nil for roll if not applicable)
            },
        },
        {
            timestamp = "21:00:00",
            event = "leave",
            player = "PlayerThree",
            details = nil,
        },
    },
}

local function DelayedExecution(delay, callback)
    local elapsed = 0
    local frame = CreateFrame("Frame")
    frame:SetScript("OnUpdate", function(self, delta)
        elapsed = elapsed + delta
        if elapsed >= delay then
            self:SetScript("OnUpdate", nil)  -- Stop the OnUpdate handler
            callback()  -- Execute the callback function
            frame:Hide() -- Cleanup the frame
        end
    end)
end


-- Track whether a raid is active
DKP_ADDON_CORE.isRaidActive = false
DKP_ADDON_CORE.knownRaidMembers = {}

-- Function to handle raid changes
function DKP_ADDON_CORE.HandleRaidChange()
    local numGroupMembers = GetNumGroupMembers()
    local isInRaid = IsInRaid()

    if isInRaid and not DKP_ADDON_CORE.isRaidActive then
        -- Start a new raid if a raid is detected and no raid is active
        local raidName = "Unnamed Raid" -- Replace with logic to determine the raid name dynamically if possible
        DKP_ADDON_CORE.StartNewRaid(raidName)
        DKP_ADDON_CORE.isRaidActive = true
        DKP_ADDON_CORE.knownRaidMembers = {}
        print("Raid started:", raidName)
    elseif not isInRaid and DKP_ADDON_CORE.isRaidActive then
        -- End the current raid if the raid ends
        DKP_ADDON_CORE.isRaidActive = false
        DKP_ADDON_CORE.knownRaidMembers = {}
        print("Raid ended.")
        -- Optionally save raid data here if needed
        DKP_ADDON_CORE.SaveRaidHistory()
    end

    if DKP_ADDON_CORE.isRaidActive then
        -- Track current raid members
        local currentMembers = {}
        for i = 1, numGroupMembers do
            local name = GetRaidRosterInfo(i)
            if name then
                currentMembers[name] = true
                if not DKP_ADDON_CORE.knownRaidMembers[name] then
                    -- New member detected, log their join
                    DKP_ADDON_CORE.AddPlayerJoin(name)
                end
            end
        end

        -- Detect members who have left
        for name, _ in pairs(DKP_ADDON_CORE.knownRaidMembers) do
            if not currentMembers[name] then
                -- Member has left, log their departure
                DKP_ADDON_CORE.AddPlayerLeave(name)
            end
        end

        -- Update known raid members to current members
        DKP_ADDON_CORE.knownRaidMembers = currentMembers
    end
end

function DKP_ADDON_CORE.UpdateRaidName()
    if not DKP_ADDON_CORE.isRaidActive then
        return -- No active raid to update
    end

    local mapID = C_Map.GetBestMapForUnit("player") -- Get the current map ID
    if mapID then
        local mapInfo = C_Map.GetMapInfo(mapID)
        if mapInfo and mapInfo.name then
            local currentRaid = DKP_ADDON_CORE.GetCurrentRaid()
            if currentRaid and currentRaid.raidName ~= mapInfo.name then
                currentRaid.raidName = mapInfo.name
                print("Raid name updated to:", mapInfo.name)
            end
        end
    end
end


DKP_ADDON_CORE.EVENT_FRAME:RegisterEvent("ADDON_LOADED")
DKP_ADDON_CORE.EVENT_FRAME:RegisterEvent("GROUP_ROSTER_UPDATE")
DKP_ADDON_CORE.EVENT_FRAME:RegisterEvent("PLAYER_LOGOUT")
DKP_ADDON_CORE.EVENT_FRAME:RegisterEvent("ZONE_CHANGED_NEW_AREA")

local function IsGuildMember(sender)
    if not IsInGuild() or not sender then
        return false
    end

    -- Fetch the total number of guild members
    for i = 1, GetNumGuildMembers(true) do
        -- Get the name of the guild member
        local guildMemberName = GetGuildRosterInfo(i)
        -- Compare sender with the guild member's name
        if guildMemberName and guildMemberName == sender then
            return true
        end
    end
    return false
end

local function GetClassColor(class,sender)
    local classColor
    local _, class = UnitClass(sender)
    if class == "WARRIOR" then
        classColor = "C79C6E"  -- Warrior color
    elseif class == "PALADIN" then
        classColor = "F58CBA"  -- Paladin color
    elseif class == "HUNTER" then
        classColor = "ABD473"  -- Hunter color
    elseif class == "ROGUE" then
        classColor = "FFF569"  -- Rogue color
    elseif class == "PRIEST" then
        classColor = "FFFFFF"  -- Priest color
    elseif class == "DEATHKNIGHT" then
        classColor = "C41E3A"  -- Death Knight color
    elseif class == "SHAMAN" then
        classColor = "0070DE"  -- Shaman color
    elseif class == "MAGE" then
        classColor = "69CCF0"  -- Mage color
    elseif class == "WARLOCK" then
        classColor = "9482C9"  -- Warlock color
    elseif class == "MONK" then
        classColor = "00FF96"  -- Monk color
    elseif class == "DRUID" then
        classColor = "FF7D0A"  -- Druid color
    elseif class == "DEMONHUNTER" then
        classColor = "A330C9"  -- Demon Hunter color
    end
    return classColor
end
local function setFontSize()
    -- Access the default chat frame (e.g., SELECTED_CHAT_FRAME or a specific one)
    local chatFrame = SELECTED_CHAT_FRAME

    -- Set the font size to a custom value (e.g., 14)
    if chatFrame then
        chatFrame:SetFont("Fonts\\FRIZQT__.TTF", 14)
    end
end

setFontSize()

-- Define the text size and color at the top
local textColor = "|cffBBBBBB"  -- Color for the message text (gray)
local statusColor = "|cFFFF4800"  -- Color for the status (DND/AFK)
local raidWarningColor = "|cFFFF4800"  -- Color for raid warning
local raidLeaderColor = "|cFF8B4800"  -- Color for raid leader
local raidMessageColor = "|cFFFF7F00"  -- Color for regular raid message

local function createWhisperLink(playerName)
    -- Create a whisper link with just [W] in front of the player name, in the player's class color
    local _, class = UnitClass(playerName)
    local classColor = GetClassColor(class, playerName)

    -- If class color is not found, use a default color (white)
    if not classColor or classColor == nil then
        classColor = "FFFFFF"
    end
    return string.format("|cff%s|Hplayer:%s|h[%s]|h|r", classColor, playerName,playerName)  -- Clickable [W] link in the player's class color
end

local function addItemLinkTooltip(msg)
    -- Search for item links in the message and apply the hover tooltip
    -- Item links are in the form |Hitem:ID|h[Item Name]|h|r
    return msg:gsub("|Hitem:.-|h%[.-%]|h|r", function(itemLink)
        -- Wrap item link to ensure tooltips appear when hovered over
        return string.format("|cff00ff00%s|r", itemLink)  -- Green color for items (You can change the color)
    end)
end
local function GetPlayerDKP(playerName)
    if DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName] and DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].dkp_location == "Officer Note" and DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].isOfficerNoteVisible then
        local amount = GetDkpFromOtherNote(playerName)
        if amount and amount ~= "" then
            return "[DKP:" .. amount .. "]"
        else
            return ""
        end
    elseif DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName] and DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].dkp_location == "Public Note" then
        local amount = GetDkpFromOtherNote(playerName)
        if amount and amount ~= "" then
            return "[DKP:" .. amount .. "]"
        else
            return ""
        end
    else
        return ""
    end
end

local function sendMessageToTab(tabName, message)
    -- Loop through all chat tabs to find the matching tab by name
    for i = 1, NUM_CHAT_WINDOWS do
        local chatTabName = _G["ChatFrame" .. i .. "Tab"]:GetText()
        
        -- If the tab name matches the one specified, send the message to that chat frame
        if chatTabName == tabName then
            local chatFrame = _G["ChatFrame" .. i]
            if chatFrame then
                chatFrame:AddMessage(message)
            end
            break
        end
    end
end

-- Define the icon paths
--local raidIcon = "Interface\\AddOns\\DKPBidder_V2\\media\\chat\\raidIcon.blp"
--local raidLeaderIcon = "Interface\\AddOns\\DKPBidder_V2\\media\\chat\\raidLeaderIcon.blp"
--local raidWarningIcon = "Interface\\AddOns\\DKPBidder_V2\\media\\chat\\raidWarningIcon.blp"
local raidIcon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_1.blp"
local raidLeaderIcon = "Interface\\GroupFrame\\UI-Group-LeaderIcon.blp"
local raidWarningIcon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8.blp" -- skull

local function raidMessage(self, event, msg, author, ...)
    -- Ensure author is valid
    if not author or author == "" then
        return false
    end

    -- Get the name of the raid frame tab
    local raidFrameTabName = DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName] and DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].raidFrame or "raid"

    -- Check if the player is DND or AFK
    local playerStatus = ""
    if UnitIsDND(author) then
        playerStatus = statusColor .. "[DND]|r"  -- Red color for DND
    elseif UnitIsAFK(author) then
        playerStatus = "|cFF888888[AFK]|r"  -- Gray color for AFK
    end

    -- Format the message with the player's status (DND/AFK)
    if playerStatus and author then
        local whisperLink = createWhisperLink(author)
        local dkpAmount = GetPlayerDKP(author)
        -- Add item link tooltip functionality
        local formattedMessage = string.format("%s|T%s:16|t%s%s|cffFF8000%s|r: %s%s", 
            raidMessageColor,
            raidIcon,  -- Icon for raid
            playerStatus,
            whisperLink,  -- 
            dkpAmount,
            textColor,
            addItemLinkTooltip(msg)  -- Add the hover tooltip for item links
        )

        -- Send the formatted message to the raid tab
        sendMessageToTab(raidFrameTabName, formattedMessage)

        -- Suppress the original message in all frames (return true to stop further processing)
        return true
    end

    -- If we reach here, return false as no valid message was processed
    return false
end

local function raidLeader(self, event, msg, author, ...)
    -- Ensure author is valid
    if not author or author == "" then
        return false
    end

    -- Get the name of the raid frame tab
    local raidFrameTabName = DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName] and DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].raidFrame or "raid"

    -- Check if the player is DND or AFK
    local playerStatus = ""
    if UnitIsDND(author) then
        playerStatus = statusColor .. "[DND]|r"  -- Red color for DND
    elseif UnitIsAFK(author) then
        playerStatus = "|cFF888888[AFK]|r"  -- Gray color for AFK
    end

    -- Format the message with the player's status (DND/AFK)
    if playerStatus and author then
        local whisperLink = createWhisperLink(author)
        local dkpAmount = GetPlayerDKP(author)
        -- Add item link tooltip functionality
        local formattedMessage = string.format("%s|T%s:16|t%s%s|cffFF8000%s|r: %s%s", 
            raidLeaderColor,
            raidLeaderIcon,  -- Icon for raid leader
            playerStatus,
            whisperLink,  
            dkpAmount,
            textColor,
            addItemLinkTooltip(msg)  -- Add the hover tooltip for item links
        )

        -- Send the formatted message to the raid tab
        sendMessageToTab(raidFrameTabName, formattedMessage)

        -- Suppress the original message in all frames (return true to stop further processing)
        return true
    end

    -- If we reach here, return false as no valid message was processed
    return false
end

local function raidWarning(self, event, msg, author, ...)
    -- Ensure author is valid
    if not author or author == "" then
        return false
    end

    -- Get the name of the raid frame tab
    local raidFrameTabName = DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName] and DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].raidFrame or "raid"

    -- Check if the player is DND or AFK
    local playerStatus = ""
    if UnitIsDND(author) then
        playerStatus = statusColor .. "[DND]|r"  -- Red color for DND
    elseif UnitIsAFK(author) then
        playerStatus = "|cFF888888[AFK]|r"  -- Gray color for AFK
    end

    -- Format the message with the player's status (DND/AFK)
    if playerStatus and author then
        local whisperLink = createWhisperLink(author)
        local dkpAmount = GetPlayerDKP(author)
        -- Add item link tooltip functionality
        local formattedMessage = string.format("%s|T%s:16|t%s%s|cffFF8000%s|r: %s%s", 
            raidWarningColor,
            raidWarningIcon,  -- Icon for raid warning
            playerStatus,
            whisperLink,  
            dkpAmount,
            textColor,
            addItemLinkTooltip(msg)  -- Add the hover tooltip for item links
        )

        -- Send the formatted message to the raid tab
        sendMessageToTab(raidFrameTabName, formattedMessage)

        -- Suppress the original message in all frames (return true to stop further processing)
        return true
    end

    -- If we reach here, return false as no valid message was processed
    return false
end

function DKP_ADDON_CORE.registerFilters()
    -- Register filters for raid chat events
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", raidMessage)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", raidLeader)
    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", raidWarning)
end

function DKP_ADDON_CORE.unregisterFilters()
    -- Unregister filters for raid chat events
    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", raidMessage)
    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", raidLeader)
    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_WARNING", raidWarning)
end

-- Function to check and apply the filters based on config setting
function DKP_ADDON_CORE.updateFilters()
    -- Check if the config setting allows showing DKP in raid chat
    if DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName] and DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].showOtherMemberDKPInRaidChat then
        -- Register the filters if enabled
        DKP_ADDON_CORE.registerFilters()
    else
        -- Unregister the filters if disabled
        DKP_ADDON_CORE.unregisterFilters()
    end
end


-- Main event handler function
local function EventHandler(self, event, arg1, arg2, ...)
    if event == "PLAYER_LOGOUT" then
        DKP_ADDON_CORE.SaveRaidHistory()

    elseif event == "ADDON_LOADED" and arg1 == "DKPBidder_V2" then
        -- Register chat-related events once
        self:RegisterEvent("CHAT_MSG_WHISPER")
        self:RegisterEvent("CHAT_MSG_RAID_WARNING")
        self:RegisterEvent("CHAT_MSG_RAID")
        self:RegisterEvent("CHAT_MSG_RAID_LEADER")
        self:RegisterEvent("CHAT_MSG_SAY")

        -- Perform delayed setup for the addon
        DelayedExecution(2, function()
            local guildName = GetGuildInfo("player")
            DKP_ADDON_CORE.guildName = guildName
            DKP_ADDON_CORE.LoadConfig()
            DKP_ADDON_CORE.LoadGuildRanks()
            DKP_ADDON_CORE.RestoreDKP()
            DKP_ADDON_CORE.GatherDKP()
            DKP_ADDON_CORE.LoadRaidHistory()
            CHAR_FRAME.UpdateText(DKP_ADDON_CORE.DkpAmount)
        end)

        if event == "CHAT_MSG_WHISPER" then
            -- Handle whispers with regex
            local message = arg1
            local sender = arg2
            local number = string.match(message, REGEX.regex.msgregexTwo)
            if number then
                DKP_ADDON_CORE.DkpAmount = number
                CHAR_FRAME.UpdateText(DKP_ADDON_CORE.DkpAmount)
                if DKP_BID_UI.frameVisible then
                    DKP_BID_UI.UpdateUI()
                end
            else
                print("regex error")
            end
    
        elseif event == "GROUP_ROSTER_UPDATE" then
            DKP_ADDON_CORE.HandleRaidChange()
    
        elseif event == "ZONE_CHANGED_NEW_AREA" then
            DKP_ADDON_CORE.UpdateRaidName()
        elseif event == "CHAT_MSG_RAID" then

        end
    end
    
end

-- Assign the event handler to the event frame
DKP_ADDON_CORE.EVENT_FRAME:SetScript("OnEvent", EventHandler)

function DKP_ADDON_CORE.LoadConfig()
    if not DKP_ADDON_CORE.guildName then
        print("Error: Guild name not initialized. Call DKP_ADDON_CORE.Initialize() first.")
        return
    end

    DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName] = DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName] or {}

    _G.DKP_Config = _G.DKP_Config or {}

    -- Check if configuration for the current guild exists, if not, load default
    if _G.DKP_Config[DKP_ADDON_CORE.guildName] and next(_G.DKP_Config[DKP_ADDON_CORE.guildName]) then
        DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName] = _G.DKP_Config[DKP_ADDON_CORE.guildName]
    else
        -- Initialize with default config
        DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName] = DKP_ADDON_CORE.defaultConfig["DefaultGuild"]
    end

    print("Configuration loaded for guild:", DKP_ADDON_CORE.guildName)
    DKP_ADDON_CORE.updateFilters()
end

function DKP_ADDON_CORE.SaveConfig()
    if DKP_ADDON_CORE.guildName then
        _G.DKP_Config[DKP_ADDON_CORE.guildName] = DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName]
    else
        print("Error: Unable to save configuration. Guild name is not set.")
    end
end

function DKP_ADDON_CORE.LoadGuildRanks()
    local numRanks = GuildControlGetNumRanks()
    for i = 1, numRanks do
        local rankName = GuildControlGetRankName(i)
        DKP_ADDON_CORE.guildRanks[rankName] = i
    end
end

function DKP_ADDON_CORE.FirstOnlineOfficer()
    local officername = "none"
    local numGuildMembers = GetNumGuildMembers()
    for i = 1, numGuildMembers do
        local name, rankName, rankIndex, level, classDisplayName, zone, publicNote, officerNote, isOnline, status, classFileName, achievementPoints, achievementRank, isMobile, canSoR, reputation = GetGuildRosterInfo(i)
        for _, rank in ipairs(DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].officerRanks) do
            if rank == rankName and isOnline then
                officername = name
                break
            end
        end
    end
    return officername
end

function DKP_ADDON_CORE.UpdateDKPAmount(amount)
    DKP_ADDON_CORE.DkpAmount = amount
end

function DKP_ADDON_CORE.RequestDKPFromOfficer(officerName)
    DKP_ADDON_CORE.DkpAmount = nil

    DKP_ADDON_CORE.EVENT_FRAME:RegisterEvent("CHAT_MSG_WHISPER")
    
    local function OnEvent(self, event, ...)
        if event == "CHAT_MSG_WHISPER" then
            local message, sender = ...
            -- Ensure the sender is the officer and the message is not sent by you
            if sender == officerName then
                -- Match and extract DKP from the message
                local dkp = string.match(message, REGEX.regex.msgRegex)
                if dkp then
                    DKP_ADDON_CORE.DkpAmount = tonumber(dkp)
                else
                    DKP_ADDON_CORE.DkpAmount = 0
                end
                CHAR_FRAME.UpdateText(DKP_ADDON_CORE.DkpAmount)
                DKP_ADDON_CORE.BackupTheDKP(DKP_ADDON_CORE.DkpAmount)
            end
        end
    end

    -- Assign the event handler function
    DKP_ADDON_CORE.EVENT_FRAME:SetScript("OnEvent", OnEvent)

    -- Create a delay using OnUpdate method for 2 seconds
    local delayFrame = CreateFrame("Frame")
    delayFrame:SetScript("OnUpdate", function(self, elapsed)
        -- Countdown and trigger after 2 seconds
        self.timer = (self.timer or 0) + elapsed
        if self.timer >= 2 then
            -- Send the request message to the officer
            SendChatMessage("?dkp", "WHISPER", nil, officerName)
            
            -- Clean up the frame after sending the message
            self:Hide()
        end
    end)
    
    delayFrame:Show()  -- Start the OnUpdate handler
end

function GetDkpFromNote(note)
    -- Check if the note matches the name regex
    if string.match(note, REGEX.regex.noteRegexName) then
        for i = 1, GetNumGuildMembers(true) do
            local name, _, _, _, _, _, publicNote, officerNote = GetGuildRosterInfo(i)
            
            -- Match the player's note with the given player's note
            if name == note then
                -- Check if DKP is in Public Note
                if DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].dkp_location == "Public Note" then
                    if string.match(publicNote, REGEX.regex.noteRegexDkp) then
                        DKP_ADDON_CORE.DkpAmount = tonumber(string.match(publicNote, REGEX.regex.noteRegexDkp))
                    else
                        DKP_ADDON_CORE.DkpAmount = 0
                    end
                    
                -- Check if DKP is in Officer Note
                elseif DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].dkp_location == "Officer Note" then
                    if string.match(officerNote, REGEX.regex.noteRegexDkp) then
                        DKP_ADDON_CORE.DkpAmount = tonumber(string.match(officerNote, REGEX.regex.noteRegexDkp))
                    else
                        DKP_ADDON_CORE.DkpAmount = 0
                    end
                end
                CHAR_FRAME.UpdateText(DKP_ADDON_CORE.DkpAmount)
            end
        end
    else
        -- If no name regex match, match DKP in the note directly
        if string.match(note, REGEX.regex.noteRegexDkp) then
            DKP_ADDON_CORE.DkpAmount = tonumber(string.match(note, REGEX.regex.noteRegexDkp))
        else
            DKP_ADDON_CORE.DkpAmount = 0
        end
        CHAR_FRAME.UpdateText(DKP_ADDON_CORE.DkpAmount)
    end
    -- Update the character frame with the current DKP amount
    
end

function GetDkpFromOtherNote(note2)
    -- Check if the note matches the name regex
    if string.match(note2, REGEX.regex.noteRegexName) then
        for i = 1, GetNumGuildMembers(true) do
            local name, _, _, _, _, _, publicNote, officerNote = GetGuildRosterInfo(i)
            
            -- Match the player's note with the given player's note
            if name == note2 then
                -- Check if DKP is in Public Note
                if DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].dkp_location == "Public Note" then
                    if string.match(publicNote, REGEX.regex.noteRegexDkp) then
                        return string.match(publicNote, REGEX.regex.noteRegexDkp)
                    else
                        return ""
                    end
                    
                -- Check if DKP is in Officer Note
                elseif DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].dkp_location == "Officer Note" then
                    if string.match(officerNote, REGEX.regex.noteRegexDkp) then
                        return string.match(officerNote, REGEX.regex.noteRegexDkp)
                    else
                        return ""
                    end
                end
            end
        end
    else
        -- If no name regex match, match DKP in the note directly
        if string.match(note2, REGEX.regex.noteRegexDkp) then
            return string.match(note, REGEX.regex.noteRegexDkp)
        else
            return ""
        end
    end
end
function DKP_ADDON_CORE.GetOtherPlayerDKP(playerName)
    if DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].dkp_location == "Public Note" then
        for i = 1, GetNumGuildMembers() do
            local name, _, _, _, _, _, publicNote, officerNote = GetGuildRosterInfo(i)
            if name == playerName then
                local note = GetDkpFromOtherNote(publicNote)
                GetPlayerDKP(note)
                break
            end
        end
    end
    if DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].dkp_location == "Officer Note" then
        if DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].isOfficerNoteVisible then
            for i = 1, GetNumGuildMembers() do
                local name, _, _, _, _, _, publicNote, officerNote = GetGuildRosterInfo(i)
                if name == playerName then
                    local note = GetDkpFromOtherNote(officerNote)
                    GetPlayerDKP(note)
                    break
                end
            end
        end
    end
end
function DKP_ADDON_CORE.GatherDKP(manualCheck)
    local manual = manualCheck or false
    if not IsInGuild() then
        DKP_ADDON_CORE.DkpAmount = 0
    end

    local playerName = UnitName("player")

    if DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].dkp_location == "Public Note" then
        for i = 1, GetNumGuildMembers() do
            local name, _, _, _, _, _, publicNote, officerNote = GetGuildRosterInfo(i)
            if name == playerName then
                GetDkpFromNote(publicNote)
                break
            end
        end
    end
    if DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].dkp_location == "Officer Note" then
        if DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].isOfficerNoteVisible then
            for i = 1, GetNumGuildMembers() do
                local name, _, _, _, _, _, publicNote, officerNote = GetGuildRosterInfo(i)
                if name == playerName then
                    GetDkpFromNote(officerNote)
                    break
                end
            end
        else
            DKP_ADDON_CORE.RestoreDKP()
            if manual then
                local officerName = DKP_ADDON_CORE.FirstOnlineOfficer()
                DKP_ADDON_CORE.RequestDKPFromOfficer(officerName)
            else
                if DKP_ADDON_CORE.DkpAmount == nil then
                    local officerName = DKP_ADDON_CORE.FirstOnlineOfficer()
                    DKP_ADDON_CORE.RequestDKPFromOfficer(officerName)
                end
            end
            
        end
    end
    
end

DKP_BackupData = DKP_BackupData or {}
local backupCounter = 0  -- Initialize the backup counter

-- Function to get the next available backup counter
local function GetNextBackupCounter()
    -- Check if there's a saved counter in the backup data
    if DKP_BackupData and DKP_BackupData.counter then
        return DKP_BackupData.counter + 1  -- Return the next available counter
    end
    return 1  -- If no counter exists, start from 1
end

-- Function to manually add or update a record in the backup
function DKP_ADDON_CORE.BackupTheDKP(amount)
    -- Get the guild name
    --local guildName = DKP_ADDON_CORE.guildName
    if not DKP_ADDON_CORE.guildName then
        print("Guild name is not set.")
        return
    end

    -- Check if the guild already has an existing record
    local existingBackupKey = nil
    for key, data in pairs(DKP_BackupData) do
        if type(data) == "table" and data.guildName == DKP_ADDON_CORE.guildName then
            -- Found an existing record, mark the key to update it
            existingBackupKey = key
            break
        end
    end

    -- If an existing backup record is found, update the DKP value
    if existingBackupKey then
        DKP_BackupData[existingBackupKey].DKP = amount
        print("Updated backup for guild '" .. DKP_ADDON_CORE.guildName .. "' to " .. amount .. " DKP.")
    else
        -- Increment the counter to ensure each record has a unique key
        backupCounter = GetNextBackupCounter()

        -- Store the backup data with a unique number as the key
        DKP_BackupData[backupCounter] = {guildName = DKP_ADDON_CORE.guildName, DKP = amount}

        -- Update the counter in the saved data
        DKP_BackupData.counter = backupCounter

        --print("Backup for guild '" .. DKP_ADDON_CORE.guildName .. "' set to " .. amount .. " DKP with record number " .. backupCounter)
    end
end

-- Function to restore the DKP for the current guild
function DKP_ADDON_CORE.RestoreDKP()
    local guildName = DKP_ADDON_CORE.guildName
    local restored = false

    -- Search through all the records in DKP_BackupData to find the most recent backup for the guild
    for key, data in pairs(DKP_BackupData) do
        -- Make sure we're looking at the data within the table (not the key)
        if type(data) == "table" and data.guildName == guildName then
            -- Restore the stored DKP amount from the inner table
            local dkpAmount = data.DKP
            --print("Restored " .. dkpAmount .. " DKP for guild " .. guildName)
            DKP_ADDON_CORE.DkpAmount = dkpAmount
            restored = true
            break
        end
    end

    if not restored then
        print("No backup found for guild: " .. guildName)
    end
end

function DKP_ADDON_CORE.DebugBackup(guildName, dkpAmount)
    DKP_ADDON_CORE.guildName = guildName
    if not guildName or not dkpAmount then
        print("Error: Guild name or DKP amount is missing.")
        return
    end

    -- Call the BackupTheDKP function with the provided guildName and dkpAmount
    DKP_ADDON_CORE.BackupTheDKP(dkpAmount)
    print("Debug: Backup for guild '" .. guildName .. "' set to " .. dkpAmount .. " DKP.")
end

function DKP_ADDON_CORE.SaveRaidHistory()
    if not DKP_HistoryData then
        DKP_HistoryData = {}
    end
    DKP_HistoryData.RaidHistory = DKP_ADDON_CORE.RaidHistory
    print("Raid history saved!")
end

-- Function to load RaidHistory from the shared variable
function DKP_ADDON_CORE.LoadRaidHistory()
    if DKP_HistoryData and DKP_HistoryData.RaidHistory then
        DKP_ADDON_CORE.RaidHistory = DKP_HistoryData.RaidHistory
        print("Raid history loaded!")
    else
        print("No raid history data found.")
    end
end

function DKP_ADDON_CORE.StartNewRaid(raidName)
    local newRaid = {
        raidDateTime = date("%Y-%m-%d %H:%M:%S"), -- Current date and time
        raidName = raidName or "Unknown Location",
        logs = {}
    }
    table.insert(DKP_ADDON_CORE.RaidHistory, newRaid)
    DKP_ADDON_CORE.UpdateRaidName() -- Set initial name dynamically
    print("New raid started:", newRaid.raidName, "| Date:", newRaid.raidDateTime)
end

-- Helper function to get the current raid (last raid in the history)
function DKP_ADDON_CORE.GetCurrentRaid()
    return DKP_ADDON_CORE.RaidHistory[#DKP_ADDON_CORE.RaidHistory]
end

-- Function to add a player join log
function DKP_ADDON_CORE.AddPlayerJoin(playerName)
    local currentRaid = DKP_ADDON_CORE.GetCurrentRaid()
    if currentRaid then
        local logEntry = {
            timestamp = date("%H:%M:%S"), -- Current time
            event = "join",
            player = playerName,
            details = nil
        }
        table.insert(currentRaid.logs, logEntry)
        print("Player joined:", playerName, "| Time:", logEntry.timestamp)
    else
        print("Error: No active raid to add a player to.")
    end
end

-- Function to add an item log
function DKP_ADDON_CORE.AddItemLog(playerName, itemName, method, amount)
    local currentRaid = DKP_ADDON_CORE.GetCurrentRaid()
    if currentRaid then
        local logEntry = {
            timestamp = date("%H:%M:%S"),
            event = "item",
            player = playerName,
            details = {
                item = itemName,
                method = method,  -- "dkp" or "roll"
                amount = amount
            }
        }
        table.insert(currentRaid.logs, logEntry)
        print("Item awarded:", itemName, "| Player:", playerName, "| Method:", method, "| Amount:", amount)
    else
        print("Error: No active raid to add an item log to.")
    end
end

-- Function to add a player leave log
function DKP_ADDON_CORE.AddPlayerLeave(playerName)
    local currentRaid = DKP_ADDON_CORE.GetCurrentRaid()
    if currentRaid then
        local logEntry = {
            timestamp = date("%H:%M:%S"),
            event = "leave",
            player = playerName,
            details = nil
        }
        table.insert(currentRaid.logs, logEntry)
        print("Player left:", playerName, "| Time:", logEntry.timestamp)
    else
        print("Error: No active raid to add a leave log to.")
    end
end

DKP_ADDON_CORE.LoadConfig()
