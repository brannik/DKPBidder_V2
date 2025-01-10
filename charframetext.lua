CHAR_FRAME = {}

-- Create the frame for the text
local ragdollFrame = CreateFrame("Frame", nil, PaperDollFrame)
ragdollFrame:SetSize(500, 65)  -- Set width and height for the frame
ragdollFrame:SetPoint("BOTTOM", PaperDollFrame, "TOP", 0, -40)  -- Position it above PaperDollFrame

-- Set up the backdrop for the frame with a solid background
local titleTexture = ragdollFrame:CreateTexture(nil, "ARTWORK")
titleTexture:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
titleTexture:SetAllPoints(ragdollFrame)

-- Create the left gryphon texture
local leftGryphon = ragdollFrame:CreateTexture(nil, "ARTWORK")
leftGryphon:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-EndCap-Human")  -- Set gryphon texture
leftGryphon:SetSize(90, 90)  -- Set the size of the left gryphon
leftGryphon:SetPoint("RIGHT", ragdollFrame, "LEFT", 145, 40)  -- Position it to the left of the frame

-- Create the right gryphon texture (flipped horizontally)
local rightGryphon = ragdollFrame:CreateTexture(nil, "ARTWORK")
rightGryphon:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-EndCap-Human")  -- Set gryphon texture
rightGryphon:SetTexCoord(1, 0, 0, 1)  -- Flip the texture horizontally
rightGryphon:SetSize(90, 90)  -- Set the size of the right gryphon
rightGryphon:SetPoint("LEFT", ragdollFrame, "RIGHT", -145, 40)  -- Position it to the right of the frame

-- Create the text string within the frame
local ragdollText = ragdollFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
ragdollText:SetPoint("CENTER", ragdollFrame, "CENTER", 0, 12)  -- Position the text in the center of the frame
ragdollText:SetText()  -- The text to display (empty for now)
ragdollText:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")  -- Custom font size and style
ragdollText:SetTextColor(0, 0.44, 0.87)

-- Update function to modify text content and show/hide frame
    function CHAR_FRAME.UpdateText(text)
        if DKP_ADDON_CORE.config and DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName] then
            if DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].showDkpInCharacterFrame then
                if DKP_ADDON_CORE.config[DKP_ADDON_CORE.guildName].smallFrame then
                    ragdollFrame:SetSize(300, 65)  -- Set width and height for the small frame
                    ragdollText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")  -- Custom font size and style for small frame
                    ragdollText:SetPoint("CENTER", ragdollFrame, "CENTER", 0, 12)  -- Reposition the text for small frame

                    leftGryphon:SetPoint("RIGHT", ragdollFrame, "LEFT", 100, 40) 
                    rightGryphon:SetPoint("LEFT", ragdollFrame, "RIGHT", -100, 40)
                    ragdollText:SetText(text)
                else
                    ragdollFrame:SetSize(500, 65)  -- Reset width and height for the regular frame
                    ragdollText:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")  -- Reset font size and style for regular frame
                    ragdollText:SetPoint("CENTER", ragdollFrame, "CENTER", 0, 12)  -- Reset text position for regular frame
                    leftGryphon:SetPoint("RIGHT", ragdollFrame, "LEFT", 145, 40) 
                    rightGryphon:SetPoint("LEFT", ragdollFrame, "RIGHT", -145, 40)
                    ragdollText:SetText("DKP: " .. text)
                end
                
                ragdollFrame:Show()  -- Show the frame if the setting is true
            else
                ragdollFrame:Hide()  -- Hide the frame if the setting is false
            end
        else
            print("Config or guild info not found.")
        end
    end
