DKP_OPTIONS_UI = {}

local frame = CreateFrame("Frame", "DKPBidderOptionsFrame", UIParent)
frame:SetSize(300, 420)
frame:SetPoint("CENTER")
frame:Hide()

frame:SetBackdrop({
    bgFile = "Interface\\AchievementFrame\\UI-Achievement-Parchment",  -- Parchment-like background
    edgeFile = "Interface\\AchievementFrame\\UI-Achievement-WoodBorder",
    tile = false,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})

frame:SetBackdropColor(0.2, 0.2, 0.2, 1)  -- Darker background color (dark gray)
frame:SetBackdropBorderColor(1, 1, 1, 1)  -- Border remains white

local closeButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
closeButton:SetSize(20, 20)  -- Adjust the size of the button
closeButton:SetText("X")  -- Set the button text as "X"

-- Position the button at the top-right corner
closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -8, -8)

-- Set a script for when the button is clicked to hide the frame
closeButton:SetScript("OnClick", function()
    frame:Hide()  -- Close the frame
end)

local titleFrame = CreateFrame("Frame", nil, frame)
titleFrame:SetSize(256, 64)
titleFrame:SetPoint("TOP", frame, "TOP", 0, 30)

local titleTexture = titleFrame:CreateTexture(nil, "ARTWORK")
titleTexture:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
titleTexture:SetAllPoints(titleFrame)

local leftGryphon = frame:CreateTexture(nil, "ARTWORK")
leftGryphon:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-EndCap-Human")
leftGryphon:SetSize(90, 90)
leftGryphon:SetPoint("RIGHT", titleFrame, "LEFT", 80, 39)

local rightGryphon = frame:CreateTexture(nil, "ARTWORK")
rightGryphon:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-EndCap-Human")
rightGryphon:SetTexCoord(1, 0, 0, 1)  -- Flip the texture horizontally
rightGryphon:SetSize(90, 90)
rightGryphon:SetPoint("LEFT", titleFrame, "RIGHT", -80, 39)

local topLeftCorner = frame:CreateTexture(nil, "OVERLAY")
topLeftCorner:SetTexture("Interface\\AchievementFrame\\UI-Achievement-WoodCorner")
topLeftCorner:SetSize(32, 32)
topLeftCorner:SetPoint("TOPLEFT", frame, "TOPLEFT", -8, 8)

local topRightCorner = frame:CreateTexture(nil, "OVERLAY")
topRightCorner:SetTexture("Interface\\AchievementFrame\\UI-Achievement-WoodCorner")
topRightCorner:SetTexCoord(1, 0, 0, 1)  -- Flip the texture horizontally
topRightCorner:SetSize(32, 32)
topRightCorner:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 8, 8)

local bottomLeftCorner = frame:CreateTexture(nil, "OVERLAY")
bottomLeftCorner:SetTexture("Interface\\AchievementFrame\\UI-Achievement-WoodCorner")
bottomLeftCorner:SetTexCoord(0, 1, 1, 0)  -- Flip the texture vertically
bottomLeftCorner:SetSize(32, 32)
bottomLeftCorner:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", -8, -8)

local bottomRightCorner = frame:CreateTexture(nil, "OVERLAY")
bottomRightCorner:SetTexture("Interface\\AchievementFrame\\UI-Achievement-WoodCorner")
bottomRightCorner:SetTexCoord(1, 0, 1, 0)  -- Flip the texture horizontally and vertically
bottomRightCorner:SetSize(32, 32)
bottomRightCorner:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 8, -8)

local topMetal = frame:CreateTexture(nil, "OVERLAY")
topMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Metal")
topMetal:SetSize(256, 16)
topMetal:SetPoint("TOP", frame, "TOP", 0, 8)

local bottomMetal = frame:CreateTexture(nil, "OVERLAY")
bottomMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Metal")
bottomMetal:SetTexCoord(0, 1, 1, 0)  -- Flip the texture vertically
bottomMetal:SetSize(256, 16)
bottomMetal:SetPoint("BOTTOM", frame, "BOTTOM", 0, -8)

local leftMetal = frame:CreateTexture(nil, "OVERLAY")
leftMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Metal")
leftMetal:SetTexCoord(0, 1, 1, 0)  -- Rotate the texture 90 degrees
leftMetal:SetSize(16, 256)
leftMetal:SetPoint("LEFT", frame, "LEFT", -8, 0)

local rightMetal = frame:CreateTexture(nil, "OVERLAY")
rightMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Metal")
rightMetal:SetTexCoord(0, 1, 0, 1)  -- Rotate the texture 90 degrees and flip horizontally
rightMetal:SetSize(16, 256)
rightMetal:SetPoint("RIGHT", frame, "RIGHT", 8, 0)

local topLeftMetal = frame:CreateTexture(nil, "OVERLAY")
topLeftMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-MetalCorner")
topLeftMetal:SetSize(32, 32)
topLeftMetal:SetPoint("TOPLEFT", frame, "TOPLEFT", -8, 8)

local topRightMetal = frame:CreateTexture(nil, "OVERLAY")
topRightMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-MetalCorner")
topRightMetal:SetTexCoord(1, 0, 0, 1)  -- Flip the texture horizontally
topRightMetal:SetSize(32, 32)
topRightMetal:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 8, 8)

local bottomLeftMetal = frame:CreateTexture(nil, "OVERLAY")
bottomLeftMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-MetalCorner")
bottomLeftMetal:SetTexCoord(0, 1, 1, 0)  -- Flip the texture vertically
bottomLeftMetal:SetSize(32, 32)
bottomLeftMetal:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", -8, -8)

local bottomRightMetal = frame:CreateTexture(nil, "OVERLAY")
bottomRightMetal:SetTexture("Interface\\AchievementFrame\\UI-Achievement-MetalCorner")
bottomRightMetal:SetTexCoord(1, 0, 1, 0)  -- Flip the texture horizontally and vertically
bottomRightMetal:SetSize(32, 32)
bottomRightMetal:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 8, -8)

frame:SetMovable(true)
frame:EnableMouse(true)

titleFrame:SetMovable(true)
titleFrame:EnableMouse(true)
titleFrame:RegisterForDrag("LeftButton")
titleFrame:SetScript("OnDragStart", function() frame:StartMoving() end)
titleFrame:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)

frame.title = titleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
frame.title:SetPoint("CENTER", titleFrame, "CENTER", 0, 12)
frame.title:SetText("Settings")

local guildNameString = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
guildNameString:SetPoint("TOP", frame.title, "BOTTOM", 0, -25)
guildNameString:SetText("Config: " .. DKP_ADDON_CORE.guildName)

-- elements 
local dropdownTitle1 = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
dropdownTitle1:SetPoint("TOP", guildNameString, "BOTTOM", 0, -10)
dropdownTitle1:SetText("DKP Storage Location")

local dropdown1 = CreateFrame("Frame", "DKPBidderConfigDropdown1", frame, "UIDropDownMenuTemplate")
dropdown1:SetPoint("TOP", dropdownTitle1, "BOTTOM", 0, -5)
UIDropDownMenu_SetWidth(dropdown1, 150)
UIDropDownMenu_SetText(dropdown1, "Select Note Type")

local function OnClickDropdown1(self)
    
    UIDropDownMenu_SetSelectedID(dropdown1, self:GetID())  -- Use dropdown1 reference
    DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].dkp_location = self.value
end

local function initializeDropdown1(self, level)

    if not DKP_ADDON_CORE or not DKP_ADDON_CORE.config or not DKP_ADDON_CORE.guildName then
        --print("Error: Missing DKP_ADDON_CORE or its required properties.")
        return
    end
    if not DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName] then
        --print("Error: Guild configuration not found for", DKP_ADDON_CORE.guildName)
        return
    end
    local info = UIDropDownMenu_CreateInfo()
    info.text = "Officer Note"
    info.value = "Officer Note"
    info.func = OnClickDropdown1
    info.checked = (DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].dkp_location == "OfficerNote")
    UIDropDownMenu_AddButton(info, level)
    
    info.text = "Public Note"
    info.value = "Public Note"
    info.func = OnClickDropdown1
    info.checked = (DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].dkp_location == "PublicNote")
    UIDropDownMenu_AddButton(info, level)
end

UIDropDownMenu_Initialize(dropdown1, initializeDropdown1)

local dropdownTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
dropdownTitle:SetPoint("TOP", dropdown1, "BOTTOM", 0, -10)
dropdownTitle:SetText("Officer Ranks")

local dropdown = CreateFrame("Frame", "DKPBidderConfigDropdown", frame, "UIDropDownMenuTemplate")
dropdown:SetPoint("TOP", dropdownTitle, "BOTTOM", 0, -5)
UIDropDownMenu_SetWidth(dropdown, 150)

-- Function to update the dropdown text based on the officer ranks
local function updateDropdownText()
    local selectedRanksText = "Select Officer Ranks"
    if DKP_ADDON_CORE and DKP_ADDON_CORE.config and DKP_ADDON_CORE.guildName then
        local guildConfig = DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName]
        if guildConfig and guildConfig.officerRanks and next(guildConfig.officerRanks) then
            selectedRanksText = "Selected: "
            for _, rank in ipairs(guildConfig.officerRanks) do
                selectedRanksText = selectedRanksText .. rank .. ", "
            end
            selectedRanksText = selectedRanksText:sub(1, -3) -- Remove the trailing comma
        end
    else
        print("Error: DKP_ADDON_CORE or required properties are not initialized.")
    end
    UIDropDownMenu_SetText(dropdown, selectedRanksText)
end

-- Toggle selection of the dropdown item
local function OnClickDropdown(self)
    local selectedID = self:GetID()
    local rankValue = self.value

    -- Check if the rank is already selected
    local isSelected = false
    for _, selected in ipairs(DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].officerRanks) do
        if selected == rankValue then
            isSelected = true
            break
        end
    end

    -- If already selected, remove it; if not, add it
    if isSelected then
        -- Remove rank from the table if it is already selected
        for index, selected in ipairs(DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].officerRanks) do
            if selected == rankValue then
                table.remove(DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].officerRanks, index)
                break
            end
        end
    else
        -- Add rank to the table if it is not already selected
        table.insert(DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].officerRanks, rankValue)
    end

    -- Refresh dropdown text
    updateDropdownText()
end

-- Initialize dropdown menu with options from guild ranks
local function initializeDropdown(self, level)
    for rank, _ in pairs(DKP_ADDON_CORE.guildRanks) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = rank
        info.value = rank

        -- Highlight as selected if the rank name is in the saved officerRanks
        info.checked = false
        for _, savedRank in ipairs(DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].officerRanks) do
            if savedRank == rank then
                info.checked = true
                break
            end
        end

        -- Set up the click handler
        info.func = OnClickDropdown
        UIDropDownMenu_AddButton(info, level)
    end
end

-- Initialize the dropdown menu
UIDropDownMenu_Initialize(dropdown, initializeDropdown)

-- Update the dropdown text to reflect the selected ranks from saved configuration
updateDropdownText()

local bidAmountTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
bidAmountTitle:SetPoint("TOP", dropdown, "BOTTOM", 0, -10)
bidAmountTitle:SetText("Bid Amount")

local bidAmountEditBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
bidAmountEditBox:SetSize(100, 25)
bidAmountEditBox:SetPoint("TOP", bidAmountTitle, "BOTTOM", 0, -5)
bidAmountEditBox:SetAutoFocus(false)
bidAmountEditBox:SetText(DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName] and DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].minDkpBid or "10")
bidAmountEditBox:SetJustifyH("CENTER") 
bidAmountEditBox:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",  -- Background texture
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",  -- Border texture
    tile = true,
    tileSize = 16,
    edgeSize = 16,  -- Border size, adjusted back to 16 for better alignment
    insets = { left = 0, right = 0, top = 0, bottom = 0 }  -- Remove internal inset to prevent double borders
})

-- Set the background and border color
bidAmountEditBox:SetBackdropColor(0, 0, 0, 1)  -- Black background
bidAmountEditBox:SetBackdropBorderColor(0.8, 0.8, 0.8)  -- Light gray border

-- Remove internal borders by adjusting the EditBox's internal settings
bidAmountEditBox:SetTextInsets(5, 5, 5, 5) 

local officerNoteHidden = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
officerNoteHidden:SetPoint("TOP", bidAmountEditBox, "BOTTOM", -100, 0)
officerNoteHidden:SetChecked(DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName] and DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].isOfficerNoteVisible)

local officerNoteLabel = officerNoteHidden:CreateFontString(nil, "OVERLAY", "GameFontNormal")
officerNoteLabel:SetPoint("LEFT", officerNoteHidden, "RIGHT", 5, 0)  -- Position it to the right of the checkbox
officerNoteLabel:SetText("Officer note visible?")  -- The text of the label

-- show other member dkp amount in the raid chat - works only if officernote is visible
local otherMemberDKPFrame = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
otherMemberDKPFrame:SetPoint("TOP", officerNoteHidden, "BOTTOM", 50, 10)
otherMemberDKPFrame:SetChecked(DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName] and DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].showOtherMemberDKPInRaidChat)

local otherMemberDKPLabel = otherMemberDKPFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
otherMemberDKPLabel:SetPoint("LEFT", otherMemberDKPFrame, "RIGHT", 5, 0)  -- Position it to the right of the checkbox
otherMemberDKPLabel:SetText("Use custom raid chat?")  -- The text of the label

local chatFrameForRaids = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
chatFrameForRaids:SetPoint("TOP", otherMemberDKPLabel, "BOTTOM", -30, -10)
chatFrameForRaids:SetText("Raid chat tab")

local chatFrameForRaidsEditBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
chatFrameForRaidsEditBox:SetSize(100, 25)
chatFrameForRaidsEditBox:SetPoint("TOP", chatFrameForRaids, "BOTTOM", 0, -5)
chatFrameForRaidsEditBox:SetAutoFocus(false)
chatFrameForRaidsEditBox:SetText(DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName] and DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].raidFrame or "raid")
chatFrameForRaidsEditBox:SetJustifyH("CENTER") 
chatFrameForRaidsEditBox:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",  -- Background texture
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",  -- Border texture
    tile = true,
    tileSize = 16,
    edgeSize = 16,  -- Border size, adjusted back to 16 for better alignment
    insets = { left = 0, right = 0, top = 0, bottom = 0 }  -- Remove internal inset to prevent double borders
})

-- Set the background and border color
chatFrameForRaidsEditBox:SetBackdropColor(0, 0, 0, 1)  -- Black background
chatFrameForRaidsEditBox:SetBackdropBorderColor(0.8, 0.8, 0.8)  -- Light gray border

-- Remove internal borders by adjusting the EditBox's internal settings
chatFrameForRaidsEditBox:SetTextInsets(5, 5, 5, 5) 

local showDkpInCharFrame = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
showDkpInCharFrame:SetPoint("TOP", chatFrameForRaidsEditBox, "BOTTOM", -90, 0)
showDkpInCharFrame:SetChecked(DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName] and DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].showDkpInCharacterFrame)

local showDkpInCharFrameLabel = showDkpInCharFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
showDkpInCharFrameLabel:SetPoint("LEFT", showDkpInCharFrame, "RIGHT", 5, 0)  -- Position it to the right of the checkbox
showDkpInCharFrameLabel:SetText("Show DKP in char frame")  -- The text of the label

local smallFrame = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
smallFrame:SetPoint("TOP", showDkpInCharFrameLabel, "BOTTOM", -50, 0)
smallFrame:SetChecked(DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName] and DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].smallFrame)

local smallFrameLabel = smallFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
smallFrameLabel:SetPoint("LEFT", smallFrame, "RIGHT", 5, 0)  -- Position it to the right of the checkbox
smallFrameLabel:SetText("Small?")  -- The text of the label

officerNoteHidden:SetScript("OnClick",function()
    if officerNoteHidden:GetChecked() then
        otherMemberDKPFrame:Enable()
        chatFrameForRaidsEditBox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)  -- Re-enable typing
        chatFrameForRaidsEditBox:SetFocus()  -- Set focus back to the EditBox
    else
        otherMemberDKPFrame:Disable()
        chatFrameForRaidsEditBox:ClearFocus()  -- Removes focus from the EditBox, preventing input
        chatFrameForRaidsEditBox:SetScript("OnEditFocusGained", function() return true end)  
    end
end)

showDkpInCharFrame:SetScript("OnClick", function()
    if showDkpInCharFrame:GetChecked() then
        smallFrame:Enable()
    else
        smallFrame:Disable()
    end
end)

otherMemberDKPFrame:SetScript("OnClick",function()
    DKP_ADDON_CORE.updateFilters()
end)

local wipeButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
wipeButton:SetPoint("BOTTOM", frame, "BOTTOM", -50,20)
wipeButton:SetSize(100, 25)
wipeButton:SetText("Wipe")
wipeButton:SetScript("OnClick", function()
    -- Wipe the saved configuration
    table.wipe(DKP_Config)

    -- Reset to default configuration
    DKP_Config = DKP_ADDON_CORE.defaultConfig

    -- Optionally reload UI to apply changes
    ReloadUI()
end)

-- Save button for saving configurations
local saveButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
saveButton:SetPoint("BOTTOM", frame, "BOTTOM", 50, 20)
saveButton:SetSize(100, 25)
saveButton:SetText("Save")
saveButton:SetScript("OnClick", function()
    -- Save values from the UI elements
    DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].dkp_location = UIDropDownMenu_GetText(dropdown1) or "OfficerNote"  -- Get selected location

    -- Reset officer ranks and update with selected ones
    DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].officerRanks = {}  -- Reset the officerRanks table before adding new values

    -- Go through all guild ranks and check if they are selected
    for rank, _ in pairs(DKP_ADDON_CORE.guildRanks) do
        -- Check if this rank is selected in the dropdown
        if UIDropDownMenu_GetText(dropdown):find(rank) then
            table.insert(DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].officerRanks, rank)  -- Save only the rank name
        end
    end

    DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].isOfficerNoteVisible = officerNoteHidden:GetChecked()  -- Get checkbox state
    DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].minDkpBid = tonumber(bidAmountEditBox:GetText()) or 10  -- Get bid amount

    DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].raidFrame = tonumber(chatFrameForRaidsEditBox:GetText()) or "raid"  -- Get bid amount


    DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].showDkpInCharacterFrame = showDkpInCharFrame:GetChecked()  -- Get checkbox state
    DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].smallFrame = smallFrame:GetChecked()  -- Get checkbox state
    DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].showOtherMemberDKPInRaidChat = otherMemberDKPFrame:GetChecked()  -- Get checkbox state
    
    DKP_ADDON_CORE.SaveConfig()
    ReloadUI()
end)

function DKP_OPTIONS_UI.Show()
    DKP_ADDON_CORE.LoadConfig()
    UIDropDownMenu_SetSelectedValue(dropdown1, DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].dkp_location)
    UIDropDownMenu_SetText(dropdown1, DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].dkp_location)
    updateDropdownText()
    bidAmountEditBox:SetText(DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].minDkpBid or '10')

    chatFrameForRaidsEditBox:SetText(DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].raidFrame or "raid")

    officerNoteHidden:SetChecked(DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].isOfficerNoteVisible or false)
    showDkpInCharFrame:SetChecked(DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].showDkpInCharacterFrame or false)
    if DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].showDkpInCharacterFrame then
        smallFrame:Enable()
    else
        smallFrame:Disable()
    end
    if DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].isOfficerNoteVisible then
        otherMemberDKPFrame:Enable()
        chatFrameForRaidsEditBox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)  -- Re-enable typing
        chatFrameForRaidsEditBox:SetFocus()  -- Set focus back to the EditBox
    else
        otherMemberDKPFrame:Disable()
        chatFrameForRaidsEditBox:ClearFocus()  -- Removes focus from the EditBox, preventing input
        chatFrameForRaidsEditBox:SetScript("OnEditFocusGained", function() return true end)  
    end
    otherMemberDKPFrame:SetChecked(DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].showOtherMemberDKPInRaidChat or false)
    smallFrame:SetChecked(DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].smallFrame or false)
    guildNameString:SetText("Config: " .. DKP_ADDON_CORE.guildName)
    frame:Show()
end
