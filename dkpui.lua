DKP_BID_UI = {}

DKP_BID_UI.currentDKPvar = ""
DKP_BID_UI.currentBid = { player = "", amount = 0 }
DKP_BID_UI.ongoingBid = false
DKP_BID_UI.dkpAmount = 0

local frame = CreateFrame("Frame", "DKPBidderFrame", UIParent)
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

local overlay = CreateFrame("Frame", "DKPBidderOverlay", frame)
overlay:SetSize(300, 420)
overlay:SetPoint("CENTER")
overlay:Hide()  -- Initially hidden

overlay:SetBackdrop({
    bgFile = "Interface\\AchievementFrame\\UI-Achievement-Parchment",  -- Parchment-like background
    edgeFile = "Interface\\AchievementFrame\\UI-Achievement-WoodBorder",
    tile = false,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})

overlay:SetBackdropColor(0.2, 0.2, 0.2, 1)  -- Darker background color (dark gray)
overlay:SetBackdropBorderColor(1, 1, 1, 1)  -- Border remains white

-- Make sure the overlay is always above everything
overlay:SetFrameStrata("HIGH")

-- Add the first text
local text1 = overlay:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
text1:SetPoint("CENTER", overlay, "CENTER", 0, 20)  -- Position slightly above the center
text1:SetText("NO ACTIVE BID SESSION")
text1:SetTextColor(1, 1, 1, 1)  -- White text

-- Add the second text
local text2 = overlay:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
text2:SetPoint("CENTER", overlay, "CENTER", 0, -20)  -- Position slightly below the center
text2:SetText("Your DKP is: 0")
text2:SetTextColor(1, 1, 1, 1)  -- White text

local closeButton = CreateFrame("Button", nil, overlay, "UIPanelButtonTemplate")
closeButton:SetSize(20, 20)  -- Adjust the size of the button
closeButton:SetText("X")  -- Set the button text as "X"

-- Position the button at the top-right corner
closeButton:SetPoint("TOPRIGHT", overlay, "TOPRIGHT", -8, -8)

-- Set a script for when the button is clicked to hide the frame
closeButton:SetScript("OnClick", function()
    frame:Hide()  -- Close the frame
end)


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
frame.title:SetText("DKP Bidder")

local itemText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
itemText:SetPoint("TOP", frame.title, "BOTTOM", 0, -30)
itemText:SetWidth(280)  -- Set the width to ensure text wraps
itemText:SetWordWrap(true)  -- Enable word wrapping
itemText:SetText("No item selected")

local itemSlot = CreateFrame("Button", "DKPBidderItemSlot", frame, "ItemButtonTemplate")
itemSlot:SetPoint("TOP", itemText, "BOTTOM", 0, -10)
itemSlot:SetSize(64, 64)
_G[itemSlot:GetName() .. "IconTexture"]:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")  -- Set a default item icon
itemSlot:SetNormalTexture(nil)  -- Remove the default border

local DKPAmount = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
DKPAmount:SetPoint("TOP", itemSlot, "BOTTOM", 0, -10)
local dkpValue = DKP_ADDON_CORE.DkpAmount
if tonumber(dkpValue) then
    DKPAmount:SetText("Your net " .. dkpValue .. " DKP")
else
    DKPAmount:SetText(dkpValue)
end

local refreshButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
refreshButton:SetPoint("RIGHT", DKPAmount, "LEFT", -10, 0)
refreshButton:SetSize(25, 25)
refreshButton:SetText("R")
refreshButton:SetScript("OnClick", function()
    local dkpValue = DKP_ADDON_CORE.DkpAmount
    if tonumber(dkpValue) then
        DKPAmount:SetText("Your net " .. dkpValue .. " DKP")
    else
        DKPAmount:SetText(dkpValue)
    end
    DKP_BID_UI.updateBidButton()
end)
refreshButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Refresh", 1, 1, 1)
    GameTooltip:AddLine("Click to refresh the DKP amount.", nil, nil, nil, true)
    GameTooltip:Show()
end)
refreshButton:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

local messageFrame = CreateFrame("Frame", nil, frame)
messageFrame:SetSize(280, 50)
messageFrame:SetPoint("TOP", DKPAmount, "BOTTOM", 0, -20)

local messageTitle = messageFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
messageTitle:SetPoint("TOP", 0, 0)
messageTitle:SetText("Current Bid")

local messageText = messageFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
messageText:SetPoint("TOP", messageTitle, "BOTTOM", 0, -10)
messageText:SetTextColor(0, 0.75, 1)  -- GM-like blue text
messageText:SetText("")
frame.messageText = messageText

local bidButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
bidButton:SetPoint("TOP", messageFrame, "BOTTOM", 0, -10)
bidButton:SetSize(180, 25)  -- Make the button wider by 15 units
frame.bidButton = bidButton

local allInButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
allInButton:SetPoint("TOP", bidButton, "BOTTOM", 0, -10)
allInButton:SetSize(180, 25)  -- Make the button wider by 15 units
allInButton:SetText("ALL IN")
frame.allInButton = allInButton

local customBidBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
customBidBox:SetSize(50, 25)
customBidBox:SetPoint("TOP", allInButton, "BOTTOM", -60, -10)
customBidBox:SetAutoFocus(false)
customBidBox:SetNumeric(true)
frame.customBidBox = customBidBox

local customBidButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
customBidButton:SetPoint("LEFT", customBidBox, "RIGHT", 10, 0)
customBidButton:SetSize(120, 25)  -- Make the button wider by 15 units
customBidButton:SetText("BID")
frame.customBidButton = customBidButton

local passButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
passButton:SetPoint("TOP", customBidButton, "BOTTOM", -32, -10)
passButton:SetSize(180, 25)  -- Make the button wider by 15 units
passButton:SetText("PASS")
frame.passButton = passButton

function DKP_BID_UI.updateMessageText(text)
    messageText:SetText(text)
    DKP_BID_UI.updateBidButton()
end


bidButton:SetScript("OnClick", function()
    local currentBid = DKP_BID_UI.currentBid
    local playerName = UnitName("player")
    local bidAmount = DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName] and DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].bidAmount or 10
    local dkpValue = tonumber(DKP_ADDON_CORE.DkpAmount)
    local newBidAmount = currentBid.amount + bidAmount

    if dkpValue >= newBidAmount and (currentBid.amount == 0 or currentBid.player ~= playerName) then
        SendChatMessage(tostring(newBidAmount), "RAID")
    end
end)

allInButton:SetScript("OnClick", function()
    local currentBid = DKP_BID_UI.currentBid
    local playerName = UnitName("player")
    local dkpValue = tonumber(DKP_ADDON_CORE.DkpAmount)

    if dkpValue > currentBid.amount and currentBid.player ~= playerName then
        SendChatMessage(tostring(dkpValue), "RAID")
    else
        print("NOT ENOUGH DKP")
    end
end)

customBidButton:SetScript("OnClick", function()
    local customBid = tonumber(customBidBox:GetText())
    local dkpValue = tonumber(DKP_ADDON_CORE.DkpAmount)
    local newBidAmount = DKP_BID_UI.currentBid.amount + customBid
    if customBid and customBid > 0 and newBidAmount <= dkpValue and DKP_BID_UI.currentBid.player ~= UnitName("player") then
        SendChatMessage(tostring(newBidAmount), "RAID")
        customBidBox:ClearFocus()
        customBidBox:SetText("")
    else
        print("Invalid bid amount or insufficient DKP.")
    end
end)

passButton:SetScript("OnClick", function()
    SendChatMessage("pass", "RAID")
    bidButton:Disable()
    allInButton:Disable()
    customBidButton:Disable()
    passButton:Disable()
end)

itemSlot:SetScript("OnEnter", function(self)
    local itemLink = self.itemLink
    if itemLink then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetHyperlink(itemLink)
        GameTooltip:Show()
    end
end)

itemSlot:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)
-- fix
function DKP_BID_UI.onRaidWarningMessage(self, event, message, sender)
    local startBidRegex = DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName] and DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].startBidRegex or "Bidding for (.+) started."
    local itemLink = message:match(startBidRegex)
    if itemLink then
        DKP_BID_UI.updateItemSlot(itemLink)
        DKP_BID_UI.bidStarter = sender
        DKP_BID_UI.currentBid = { player = "", amount = 0 }
        DKP_BID_UI.updateMessageText("")
        DKP_BID_UI.unlockButtons()
        DKP_BID_UI.ongoingBid = true
        DKP_BID_UI.UpdateUI()
    end
end

function DKP_BID_UI.onRaidMessage(self, event, message, sender)
    local stopBidRegex = DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName] and DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].stopBidRegex or ".+ has been cancelled."
    if message:match(stopBidRegex) and sender == DKP_BID_UI.bidStarter then
        DKP_BID_UI.resetItemSlot()
        DKP_BID_UI.ongoingBid = false
        DKP_BID_UI.UpdateUI()
    elseif message:match("^%d+$") then
        local bidAmount = tonumber(message)
        if bidAmount and bidAmount > DKP_BID_UI.currentBid.amount then
            DKP_BID_UI.currentBid = { player = sender, amount = bidAmount }
            DKP_BID_UI.updateMessageText(sender .. " - " .. bidAmount)
        end
    end
    DKP_BID_UI.UpdateUI()
end
function DKP_BID_UI.updateItemSlot(itemLink)
    local function updateSlot()
        -- Attempt to get the item info
        local itemName, _, itemRarity, _, _, _, _, _, _, itemTexture = GetItemInfo(itemLink)
        
        -- If the item data is available
        if itemTexture then
            itemSlot:SetNormalTexture(itemTexture)
            itemSlot.itemLink = itemLink
            local r, g, b = GetItemQualityColor(itemRarity)
            itemText:SetText(itemName)
            itemText:SetTextColor(r, g, b)
        else
            -- If item data isn't available yet, retry after a short delay
            print("Item info not available, retrying...")
            
            -- Using a Frame's OnUpdate for a retry mechanism
            local retryFrame = CreateFrame("Frame")
            retryFrame:SetScript("OnUpdate", function(self, elapsed)
                -- Delay of 0.1 seconds
                self.timeSinceLastUpdate = (self.timeSinceLastUpdate or 0) + elapsed
                if self.timeSinceLastUpdate >= 0.1 then
                    updateSlot()  -- Retry fetching item info
                    self:Hide()  -- Hide the frame after retry
                end
            end)
            retryFrame:Show()  -- Start the frame's OnUpdate event
        end
    end
    
    -- Call the updateSlot function
    updateSlot()
end

function DKP_BID_UI.resetItemSlot()
    -- Reset the icon texture to the default "?" icon
    local iconTexture = _G[itemSlot:GetName() .. "IconTexture"]
    iconTexture:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")

    -- Remove any additional visual effects or borders
    local iconBorder = _G[itemSlot:GetName() .. "IconBorder"]
    if iconBorder then
        iconBorder:Hide()  -- Hide the border if present
    end

    -- Clear the item link
    itemSlot.itemLink = nil

    -- Reset the item name text
    if itemText then
        itemText:SetText("No item selected")
        itemText:SetTextColor(1, 1, 1)
    end

    -- Reset any additional states (if applicable)
    itemSlot:SetNormalTexture(nil)  -- Remove any button-specific normal texture
    itemSlot:SetPushedTexture(nil)  -- Remove any pushed texture (in case it was set)

    -- Ensure the icon is reset visually
    iconTexture:SetDesaturated(false)  -- Ensure the texture isn't grayed out

    -- Update the message text (this function is assumed to exist)
    if DKP_BID_UI.updateMessageText then
        DKP_BID_UI.updateMessageText("")
    end

    DKP_BID_UI.currentBid = { player = "", amount = 0 }
end



function DKP_BID_UI.unlockButtons()
    local bidAmount = DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName] and DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].minDkpBid or 10
    bidButton:SetText("BID " .. bidAmount)
    bidButton:Enable()
    allInButton:SetText("ALL IN")
    allInButton:Enable()
    customBidButton:SetText("BID")
    customBidButton:Enable()
    passButton:SetText("PASS")
    passButton:Enable()
end

function DKP_BID_UI.updateBidButton()
    local currentBid = DKP_BID_UI.currentBid
    local playerName = UnitName("player")
    local bidAmount = DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName] and DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].minDkpBid or 10
    local dkpValue = tonumber(DKP_ADDON_CORE.DkpAmount)
    local newBidAmount = currentBid.amount + bidAmount

    if currentBid.amount == 0 then
        bidButton:SetText("NO ACTIVE BID")
        bidButton:Disable()
        allInButton:SetText("NO ACTIVE BID")
        allInButton:Disable()
        customBidButton:SetText("NO ACTIVE BID")
        customBidButton:Disable()
        passButton:SetText("NO ACTIVE BID")
        passButton:Disable()
    elseif dkpValue < newBidAmount then
        bidButton:SetText("NOT ENOUGH DKP")
        bidButton:Disable()
        allInButton:SetText("NOT ENOUGH DKP")
        allInButton:Disable()
        customBidButton:SetText("NOT ENOUGH DKP")
        customBidButton:Disable()
        passButton:SetText("PASS")
        passButton:Enable()
    elseif currentBid.player == playerName then
        bidButton:SetText("YOUR BID")
        bidButton:Disable()
        allInButton:SetText("YOUR BID")
        allInButton:Disable()
        customBidButton:SetText("YOUR BID")
        customBidButton:Disable()
        passButton:SetText("PASS")
        passButton:Enable()
    else
        bidButton:SetText("OUTBID " .. bidAmount)
        bidButton:Enable()
        allInButton:SetText("ALL IN")
        allInButton:Enable()
        customBidButton:SetText("BID")
        customBidButton:Enable()
        passButton:SetText("PASS")
        passButton:Enable()
    end
end

function DKP_BID_UI.UpdateUI()
    if DKP_BID_UI.ongoingBid == false then
        overlay:Show()
    else
        overlay:Hide()
    end
end

function DKP_BID_UI.registerRaidWarningListener()
    if not DKP_BID_UI.raidWarningFrame then
        DKP_BID_UI.raidWarningFrame = CreateFrame("Frame")
        DKP_BID_UI.raidWarningFrame:RegisterEvent("CHAT_MSG_RAID_WARNING")
        DKP_BID_UI.raidWarningFrame:RegisterEvent("CHAT_MSG_RAID")
        DKP_BID_UI.raidWarningFrame:RegisterEvent("CHAT_MSG_RAID_LEADER")
        DKP_BID_UI.raidWarningFrame:SetScript("OnEvent", function(self, event, message, sender)
            if event == "CHAT_MSG_RAID_WARNING" then
                DKP_BID_UI.onRaidWarningMessage(self, event, message, sender)
            elseif event == "CHAT_MSG_RAID" or event == "CHAT_MSG_RAID_LEADER" then
                DKP_BID_UI.onRaidMessage(self, event, message, sender)
            end
        end)
    end
end

function DKP_BID_UI.unregisterRaidWarningListener()
    if DKP_BID_UI.raidWarningFrame then
        DKP_BID_UI.raidWarningFrame:UnregisterEvent("CHAT_MSG_RAID_WARNING")
        DKP_BID_UI.raidWarningFrame:UnregisterEvent("CHAT_MSG_RAID")
        DKP_BID_UI.raidWarningFrame:UnregisterEvent("CHAT_MSG_RAID_LEADER")
    end
end

local function OnFrameShow(self)
    DKP_ADDON_CORE.GatherDKP()
    DKP_BID_UI.registerRaidWarningListener()
    DKP_BID_UI.updateBidButton()
    DKP_BID_UI.ongoingBid = false
    DKP_BID_UI.UpdateUI()
end

-- Event handler function for OnHide
local function OnFrameHide(self)
    DKP_BID_UI.unregisterRaidWarningListener()
end

frame:RegisterEvent("PLAYER_LOGIN") -- Example of registering an event you might need, if any
frame:SetScript("OnShow", OnFrameShow)
frame:SetScript("OnHide", OnFrameHide)

function DKP_BID_UI.Show()
    if tonumber(DKP_ADDON_CORE.DkpAmount) then
        DKPAmount:SetText("Your net " .. DKP_ADDON_CORE.DkpAmount .. " DKP")
        text2:SetText("Your DKP is: " .. DKP_ADDON_CORE.DkpAmount)
    else
        DKPAmount:SetText(DKP_ADDON_CORE.DkpAmount)
    end
    DKP_BID_UI.UpdateUI()
    frame:Show()
end
