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


function ROLL_UI.Show()
    frame:Show()
end
