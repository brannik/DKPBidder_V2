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
        smallFrame = false
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

DKP_ADDON_CORE.EVENT_FRAME:SetScript("OnEvent", function(self, event, arg1)
    if event == "PLAYER_LOGOUT" then
        DKP_ADDON_CORE.SaveRaidHistory()
    elseif event == "ADDON_LOADED" and arg1 == "DKPBidder_V2" then  -- Replace with your addon name

        DKP_ADDON_CORE.EVENT_FRAME:RegisterEvent("CHAT_MSG_WHISPER")
        DKP_ADDON_CORE.EVENT_FRAME:SetScript("OnEvent", function(self, event, message, sender)
            if event == "CHAT_MSG_WHISPER" then
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
            end
        end)

        DelayedExecution(2, function()
            local guildName = GetGuildInfo("player")
            DKP_ADDON_CORE.guildName = guildName
            DKP_ADDON_CORE.LoadConfig()
            DKP_ADDON_CORE.LoadGuildRanks()
            DKP_ADDON_CORE.GatherDKP()
            DKP_ADDON_CORE.LoadRaidHistory()
        end)
    elseif event == "GROUP_ROSTER_UPDATE" then
        DKP_ADDON_CORE.HandleRaidChange()
    elseif event == "ZONE_CHANGED_NEW_AREA" then
        DKP_ADDON_CORE.UpdateRaidName()
    end
end)

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
                local dkp = string.match(message, DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].msgRegex)
                if dkp then
                    DKP_ADDON_CORE.DkpAmount = tonumber(dkp)
                else
                    DKP_ADDON_CORE.DkpAmount = 0
                end
                CHAR_FRAME.UpdateText(DKP_ADDON_CORE.DkpAmount)
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
    if string.match(note, DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].noteRegexName) then
        for i = 1, GetNumGuildMembers(true) do
            local name, _, _, _, _, _, publicNote, officerNote = GetGuildRosterInfo(i)
            
            -- Match the player's note with the given player's note
            if name == note then
                -- Check if DKP is in Public Note
                if DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].dkp_location == "Public Note" then
                    if string.match(publicNote, DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].noteRegexDkp) then
                        DKP_ADDON_CORE.DkpAmount = tonumber(string.match(publicNote, DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].noteRegexDkp))
                    else
                        DKP_ADDON_CORE.DkpAmount = 0
                    end
                    
                -- Check if DKP is in Officer Note
                elseif DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].dkp_location == "Officer Note" then
                    if string.match(officerNote, DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].noteRegexDkp) then
                        DKP_ADDON_CORE.DkpAmount = tonumber(string.match(officerNote, DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].noteRegexDkp))
                    else
                        DKP_ADDON_CORE.DkpAmount = 0
                    end
                end
                CHAR_FRAME.UpdateText(DKP_ADDON_CORE.DkpAmount)
            end
        end
    else
        -- If no name regex match, match DKP in the note directly
        if string.match(note, DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].noteRegexDkp) then
            DKP_ADDON_CORE.DkpAmount = tonumber(string.match(note, DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].noteRegexDkp))
        else
            DKP_ADDON_CORE.DkpAmount = 0
        end
        CHAR_FRAME.UpdateText(DKP_ADDON_CORE.DkpAmount)
    end
    -- Update the character frame with the current DKP amount
    
end

function DKP_ADDON_CORE.GatherDKP()
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
            local officerName = DKP_ADDON_CORE.FirstOnlineOfficer()
            DKP_ADDON_CORE.RequestDKPFromOfficer(officerName)
        end
    end
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