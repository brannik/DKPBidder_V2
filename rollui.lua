ROLL_UI = {}

local frame = CreateFrame("Frame", "RollFrame", UIParent)
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
frame.title:SetText("Roll track")

-- Create the text label for the item slot
local rollItemText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
rollItemText:SetPoint("TOP", frame.title, "BOTTOM", 0, -30)
rollItemText:SetWidth(280)  -- Set the width to ensure text wraps
rollItemText:SetWordWrap(true)  -- Enable word wrapping
rollItemText:SetText("No item selected")

-- Create the item slot button (for the item icon)
local rollItemSlot = CreateFrame("Button", "RollItemSlot", frame, "ItemButtonTemplate")
rollItemSlot:SetPoint("TOP", rollItemText, "BOTTOM", 0, -10)
rollItemSlot:SetSize(64, 64)

-- Set the default question mark icon immediately
local iconTexture = _G[rollItemSlot:GetName() .. "IconTexture"]
iconTexture:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")  -- Set a default question mark icon

-- Remove the default border from the item button
rollItemSlot:SetNormalTexture(nil)

-- Show item information when the mouse hovers over the item slot
rollItemSlot:SetScript("OnEnter", function(self)
    local itemLink = self.itemLink
    if itemLink then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetHyperlink(itemLink)
        GameTooltip:Show()
    end
end)

-- Hide item information when the mouse leaves the item slot
rollItemSlot:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

local rollButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
rollButton:SetPoint("TOP", rollItemSlot, "BOTTOM", 0, -10)
rollButton:SetSize(180, 25)  -- Make the button wider by 15 units
rollButton:SetText("ROLL")
rollButton:SetScript("OnClick", function()
    -- Perform the roll action
    RandomRoll(1, 100)
end)


local rollButton = CreateFrame("Button", nil, rollButton, "GameMenuButtonTemplate")
rollButton:SetPoint("TOP", rollItemSlot, "BOTTOM", 0, -40)
rollButton:SetSize(180, 25)  -- Make the button wider by 15 units
rollButton:SetText("Announce winner")
rollButton:SetScript("OnClick", function()
    if #ROLL_UI.rolls > 0 then
        local firstRoll = ROLL_UI.rolls[1]  -- Get the first record

        -- Add some emphasis to the message
        local message = "[!] -> " .. firstRoll.name .. " won. Rolled: " .. firstRoll.roll .. " for the item!"

        -- Send the message to the raid chat
        SendChatMessage(message, "RAID")
    else
        print("No rolls available to send to raid chat.")
    end
end)

-- Example data for list items
ROLL_UI = ROLL_UI or {}  -- Ensure ROLL_UI exists
ROLL_UI.rolls = ROLL_UI.rolls or {}  -- Ensure ROLL_UI.rolls exists


-- Function to create the main frame (subframe) to hold the list
local subframe = CreateFrame("Frame", "RollsListFrame", frame)
subframe:SetSize(250, 200)  -- Adjust the size of the subframe
subframe:SetPoint("BOTTOM", frame, "BOTTOM", 0, 15)  -- Position the subframe at the center of the screen

-- Set background and border manually (since templates like BasicFrameTemplateWithInset aren't available)
subframe:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", 
    tile = true, tileSize = 32, edgeSize = 32, 
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
subframe:SetBackdropColor(0, 0, 0, 1)  -- Set background color to black

-- Title of the subframe
subframe.title = subframe:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
subframe.title:SetPoint("TOP", subframe, "TOP", 0, -10)
subframe.title:SetText("Rolls List")

-- Create the scroll frame for the list (without a template)
local scrollContainer = CreateFrame("ScrollFrame", nil, subframe)
scrollContainer:SetSize(240, 160)  -- Size of the scrollable area
scrollContainer:SetPoint("TOP", subframe, "TOP", 0, -40)  -- Position it inside the subframe

-- Create a container for the list items (empty container for now)
local listContainer = CreateFrame("Frame", nil, scrollContainer)
listContainer:SetSize(240, 1)  -- Start with a minimal height for now, will adjust dynamically
scrollContainer:SetScrollChild(listContainer)

-- Create the vertical scrollbar manually
local scrollbar = CreateFrame("Slider", nil, subframe, "UIPanelScrollBarTemplate")
scrollbar:SetPoint("TOPRIGHT", subframe, "TOPRIGHT", -7, -30)  -- Position the scrollbar
scrollbar:SetOrientation("VERTICAL")
scrollbar:SetWidth(16)
scrollbar:SetHeight(140)  -- Set the height of the scrollbar to match the scroll container

scrollbar:SetMinMaxValues(0, 100)  -- Set min and max scroll values
scrollbar:SetValueStep(1)  -- Step for each scroll action

-- Attach the scrollbar to the scroll frame
scrollbar:SetScript("OnValueChanged", function(self, value)
    -- Update the position of the listContainer based on the scrollbar's value
    listContainer:SetPoint("TOP", scrollContainer, "TOP", 0, value)
end)

local labelList = {}

-- Function to create a list item (player name and roll)
local function CreateListItem(index, name, roll, classColor)
    local label = listContainer:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("TOP", listContainer, "TOP", 0, -(index - 1) * 15)  -- Position each label vertically
    label:SetText(name .. ": " .. roll)  -- Display name and roll

    -- Apply class color to the player name text
    if classColor then
        label:SetTextColor(classColor.r, classColor.g, classColor.b)
    else
        label:SetTextColor(1, 1, 1)  -- Default to white if no class color
    end

    -- Add the label to the list of labels for future reference
    table.insert(labelList, label)
end

-- Function to clear existing list items
local function ClearListItems()
    -- Loop through and remove the existing labels in the labelList
    for _, label in ipairs(labelList) do
        label:Hide()  -- Hide the label
    end

    -- Clear the label list so we don't have references to the old labels
    wipe(labelList)

    -- Reset the height of listContainer to 1 (minimal size) to effectively clear it from the scrollable area
    listContainer:SetHeight(1)
end

-- Function to populate the list
local function populateTheList()
    -- Sort the rolls table by the roll value in descending order
    table.sort(ROLL_UI.rolls, function(a, b)
        return tonumber(a.roll) > tonumber(b.roll)
    end)

    -- Clear existing items before repopulating
    ClearListItems()

    -- Populate the list with player names and rolls
    local totalHeight = 0
    for index, player in ipairs(ROLL_UI.rolls) do
        CreateListItem(index, player.name, player.roll, player.classColor)
        totalHeight = totalHeight + 30  -- Each item is 30px in height
    end

    -- Adjust the listContainer's height based on the number of items
    listContainer:SetHeight(totalHeight)

    -- Update scrollbar values
    --scrollbar:SetMinMaxValues(0, totalHeight - scrollContainer:GetHeight())
end


function ROLL_UI.registerEvents()
    DKP_ADDON_CORE.EVENT_FRAME:RegisterEvent("CHAT_MSG_SYSTEM")
    DKP_ADDON_CORE.EVENT_FRAME:RegisterEvent("CHAT_MSG_RAID_WARNING")
    DKP_ADDON_CORE.EVENT_FRAME:RegisterEvent("CHAT_MSG_RAID")
    DKP_ADDON_CORE.EVENT_FRAME:RegisterEvent("CHAT_MSG_RAID_LEADER")
    -- Set up the event handler
    DKP_ADDON_CORE.EVENT_FRAME:SetScript("OnEvent", function(self, event, ...)
        local msg = ...
        if event == "CHAT_MSG_SYSTEM" then
            
            -- Check if the message is a roll
            local player, roll, min, max = string.match(msg, "^(%a+) rolls (%d+) %((%d+)-(%d+)%)$")
            if player and roll and min and max then
                -- Check if the player is already in the rolls table
                local alreadyExists = false
                for _, entry in ipairs(ROLL_UI.rolls) do
                    if entry.name == player then
                        alreadyExists = true
                        break
                    end
                end
                
                if not alreadyExists then
                    -- Get player's class and class color
                    local guid = UnitGUID(player)
                    local classColor = { r = 1, g = 1, b = 1 } -- Default to white
                    if guid then
                        local _, class = GetPlayerInfoByGUID(guid)
                        if class and RAID_CLASS_COLORS[class] then
                            classColor = RAID_CLASS_COLORS[class]
                        end
                    end
                    
                    -- Player performed a valid roll and is not already in the table
                    --print(player .. " rolled " .. roll .. " (Range: " .. min .. "-" .. max .. ")")
                    
                    -- Add the roll, class, and class color to the list
                    table.insert(ROLL_UI.rolls, {
                        name = player,
                        roll = tonumber(roll),
                        classColor = classColor,
                    })
                    populateTheList()
                else
                    SendChatMessage("MULTIROLL BY: " .. player, "RAID")
                end
            end
        elseif event == "CHAT_MSG_RAID_WARNING" then
            -- Extract the item link using the updated regex
            local itemLink2 = string.match(msg:lower(), REGEX.regex.startBidRegex)
            -- Check if itemLink was successfully extracted
            if itemLink2 then
                local itemLink = string.match(msg, REGEX.regex.startBidRegex) -- patch 
                ClearListItems()
                ROLL_UI.rolls = {}
                
                -- Update the item text and item slot with the extracted item link
                rollItemText:SetText(itemLink)
                rollItemSlot.itemLink = itemLink
                
                -- Try fetching the item information
                local _, _, _, _, _, _, _, _, _, itemIcon = GetItemInfo(itemLink)
                
                -- Check if itemIcon is valid, otherwise we need to handle it asynchronously
                if itemIcon then
                    -- Set the item icon in the item slot immediately
                    _G[rollItemSlot:GetName() .. "IconTexture"]:SetTexture(itemIcon)
                else
                    -- Fallback icon in case the item info is not cached yet
                    _G[rollItemSlot:GetName() .. "IconTexture"]:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
                    
                    -- We can register for an event to handle the situation when the icon info becomes available
                    local function onItemLoaded(_, _, link)
                        -- Ensure we are handling the correct item link
                        if link == itemLink then
                            local _, _, _, _, _, _, _, _, _, loadedItemIcon = GetItemInfo(link)
                            if loadedItemIcon then
                                -- Set the item icon in the item slot once it is available
                                _G[rollItemSlot:GetName() .. "IconTexture"]:SetTexture(loadedItemIcon)
                                -- Unregister the event once we are done
                                self:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
                            end
                        end
                    end
                    
                    -- Listen for the event of item data being loaded
                    self:RegisterEvent("GET_ITEM_INFO_RECEIVED")
                    self:SetScript("OnEvent", onItemLoaded)
                end
            else
                print("No valid itemLink found in raid warning")
            end
        end
    end)
end



function ROLL_UI.unregisterEvents()
    DKP_ADDON_CORE.EVENT_FRAME:UnregisterEvent("CHAT_MSG_SYSTEM")
    DKP_ADDON_CORE.EVENT_FRAME:UnregisterEvent("CHAT_MSG_RAID_WARNING")
    DKP_ADDON_CORE.EVENT_FRAME:UnregisterEvent("CHAT_MSG_RAID")
    DKP_ADDON_CORE.EVENT_FRAME:UnregisterEvent("CHAT_MSG_RAID_LEADER")
end

local function OnFrameShow(self)
    ROLL_UI.registerEvents()
end

-- Event handler function for OnHide
local function OnFrameHide(self)
    ROLL_UI.unregisterEvents()
end

frame:RegisterEvent("PLAYER_LOGIN") -- Example of registering an event you might need, if any
frame:SetScript("OnShow", OnFrameShow)
frame:SetScript("OnHide", OnFrameHide)

function ROLL_UI.Show()
    frame:Show()
end
