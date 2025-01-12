DKPBidder_Minimap = {}

-- Create the minimap button
function DKPBidder_Minimap:CreateButton()
    -- Create the button frame
    self.button = CreateFrame("Button", "DKPBidder_MinimapButton", Minimap)
    self.button:SetSize(32, 32) -- Size of the button

    -- Add a circular border
    local border = self.button:CreateTexture(nil, "OVERLAY")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    border:SetSize(54, 54) -- Slightly larger than the button
    border:SetPoint("CENTER", self.button, "CENTER", 0, 0)
    self.button.border = border

    -- Set the button's icon texture (Gold coin icon)
    local icon = self.button:CreateTexture(nil, "ARTWORK")
    icon:SetTexture("Interface\\Icons\\INV_Misc_Coin_01") -- Gold coin icon
    icon:SetSize(20, 20) -- Adjust size to fit within the border
    -- Center the icon inside the button
    icon:SetPoint("CENTER", self.button, "CENTER", -10, 10)
    -- Crop the square texture to appear circular
    icon:SetTexCoord(0, 1, 0, 1)  -- Use the full square icon, but should be inherently circular
    self.button.icon = icon

    -- Position the button around the minimap (initial position)
    self.button:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -10, -10)

    -- Enable dragging of the button
    self.button:SetMovable(true)
    self.button:EnableMouse(true)
    self.button:RegisterForDrag("LeftButton")
    self.button:SetScript("OnDragStart", function()
        self.button:StartMoving()
    end)
    self.button:SetScript("OnDragStop", function()
        self.button:StopMovingOrSizing()
    end)

    -- Set a script for when the button is clicked
    self.button:SetScript("OnClick", function()
        DKPBidder_Minimap.showTooltipMenu(
            function()
                DKP_BID_UI.Show()
            end,
            function()
                ROLL_UI.Show()
            end,
            function()
                HISTORY_UI.Show()
            end,
            function()
                DKP_ADDON_CORE.GatherDKP(true)
            end,
            function()
                DKP_OPTIONS_UI.Show()
            end
        )
    end)

    -- Show the button
    self.button:Show()
end

-- Show the menu with four buttons
function DKPBidder_Minimap.showTooltipMenu(onDKPClick, onRollClick, onHistoryClick,onManualClick, onOptionsClick)
    if DKPBidder_Minimap.tooltipMenu then
        DKPBidder_Minimap.tooltipMenu:Hide() -- Hide any existing menu
    end

    local menu = CreateFrame("Frame", "DKPBidderTooltipMenu", UIParent)
    DKPBidder_Minimap.tooltipMenu = menu
    menu:SetSize(160, 150) -- Adjust size to fit all buttons

    local x, y = GetCursorPosition()
    local uiScale = UIParent:GetEffectiveScale()
    menu:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", x / uiScale, y / uiScale)

    menu:SetFrameStrata("TOOLTIP")
    menu:SetFrameLevel(100)

    local bg = menu:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(menu)
    bg:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
    bg:SetVertexColor(0, 0, 0, 0.8)

    local function createMenuButton(text, onClick, yOffset)
        local button = CreateFrame("Button", nil, menu, "UIPanelButtonTemplate")
        button:SetSize(140, 20)
        button:SetPoint("TOP", menu, "TOP", 0, yOffset)
        button:SetText(text)
        button:SetScript("OnClick", function()
            onClick()
            menu:Hide()
        end)
        return button
    end

    createMenuButton("DKP", onDKPClick, -10)
    createMenuButton("Roll", onRollClick, -30)
    createMenuButton("History", onHistoryClick, -50)
    createMenuButton("Manual refresh DKP", onManualClick, -70)
    createMenuButton("Options", onOptionsClick, -90)

    local closeButton = CreateFrame("Button", nil, menu, "UIPanelButtonTemplate")
    closeButton:SetSize(140, 20)
    closeButton:SetPoint("BOTTOM", menu, "BOTTOM", 0, 10)
    closeButton:SetText("Close")
    closeButton:SetScript("OnClick", function()
        menu:Hide()
    end)

    menu:Show()
end

-- Call the CreateButton function to create the minimap button
DKPBidder_Minimap:CreateButton()
