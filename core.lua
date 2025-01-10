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
        startBidRegex = "Bidding for (.+) started.",
        stopBidRegex = "Bidding for (.+) has been cancelled.",
        startRollRegex = "startroll",
        stopRollRegex = "stoproll",
        noteRegexDkp = "[Nn]et:%s*(%d+)",
        noteRegexName = "^%a+$",
        msgRegex = "You have%s+(%d+)%s+DKP",
        smallFrame = false
    }
}

DKP_ADDON_CORE.config = {}  -- Guild-specific config
DKP_ADDON_CORE.guildRanks = {}
DKP_ADDON_CORE.DkpAmount = 0
DKP_ADDON_CORE.EVENT_FRAME = CreateFrame("Frame")
DKP_ADDON_CORE.guildName = ""
DKP_ADDON_CORE.DKP_BackupData = {}  -- Backup data for DKP

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, arg1)
    if arg1 == "DKPBidder_V2" then  -- Replace with your addon name
        local guildName = GetGuildInfo("player")
        DKP_ADDON_CORE.guildName = guildName
        print("Guild Name: " .. guildName)
        DKP_ADDON_CORE.LoadConfig()
        DKP_ADDON_CORE.LoadGuildRanks()
        DKP_ADDON_CORE.GatherDKP()
        --CHAR_FRAME.UpdateText(DKP_ADDON_CORE.DkpAmount)
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
    print(officername)
    return officername
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
            end
        end
    else
        -- If no name regex match, match DKP in the note directly
        if string.match(note, DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].noteRegexDkp) then
            DKP_ADDON_CORE.DkpAmount = tonumber(string.match(note, DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].noteRegexDkp))
        else
            DKP_ADDON_CORE.DkpAmount = 0
        end
    end
    -- Update the character frame with the current DKP amount
    CHAR_FRAME.UpdateText(DKP_ADDON_CORE.DkpAmount)
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

-- Backup DKP data in case no officer is online
function DKP_ADDON_CORE.BackupDKP()
    if DKP_ADDON_CORE.guildName and DKP_ADDON_CORE.DkpAmount then
        DKP_ADDON_CORE.DKP_BackupData[DKP_ADDON_CORE.guildName] = DKP_ADDON_CORE.DkpAmount
    end
end
