-- Author      : eliea
-- Create Date : 9/7/2023 2:43:48 PM

--TODO A button to hide ES and ET

--TODO Restrict/Delay reloading only to out of combat
--TODO Message if spec doesn't match with the settings
--TODO Add a label inside the profiles' "You can have up to 6 profiles"

--TODO Add Header and Tail frames (dark)
--TODO Function to clear/remove the initializedButtons
--TODO Change line numbers to start at one instead of 0
--TODO Add title based on loaded SpecID
--TODO Fix profile Ids and sorting in order

--TODO Change buttons' texture when selected in profiles
--TODO Save last selected minitab
--TODO Mouseover Tooltip for explaining the settings
--TODO Move Profile related functions outside of this lua file

local name, ES = ...

EpicSettings = ES;

ES.Toggles = {}

ES.Queues = {}

ES.KeysPressed = {}

ES.Buttons = {}
ES.MainButton = {}

ES.ProfileButtons = {}

ES.SettingsFrameTabProfiles = {}
ES.SettingsFrameTabCommands = {}

ES.Tabs = {}

-- /run EpicSettings.Setup()
-- /run EpicSettings.AddSlider(2, "Another Slider", 1, 100, 22)
-- /run print(EpicSettings.Settings["F1"])
-- /run print(EpicSettingsDB.Profiles["Default2"]["F1"])
-- Label checkbox, label slider, label dropdown, label slider

ES.DebugOn = false;

ES.TabOffsetX = 4;
ES.TabOffsetY = 3;
ES.TabNextOffsetY = 0;

ES.TabBodySizeX = 771;
ES.TabBodySizeY = 446;

ES.TabBodyCategoriesSizeY = 32;

ES.TabButtonSizeX = 120;
ES.TabButtonSizeY = 25;

ES.TabButtonsSpacingX = 4;
ES.TabButtonsSpacingY = 0;

ES.MiniTabOffsetX = 4;
ES.MiniTabOffsetY = 4;
ES.MiniTabNextOffsetX = 0
ES.MiniTabButtonSizeX = 80
ES.MiniTabButtonSizeY = 20;
ES.MiniTabButtonsSpacingX = 2

ES.ControlsSpacingX = 180;

ES.SpacingBetweenLines = 50;
ES.SettingControlHeight = 30;

ES.CheckboxSize = 22;

ES.TextboxSizeX = 130;
ES.TextboxSizeY = 20;

ES.SliderWidth = 130;
ES.SliderHeight = 15;

ES.MaxProfiles = 6;

ES.SpecID = 0;

-- Settings table
ES.Settings = {}
-- /run print(" "..#EpicSettingsDB.Profiles)
-- /run EpicSettings.Toggles["AOE"] = not EpicSettings.Toggles["AOE"]

ES.DefaultSettings = {}

local font = "Interface\\Addons\\EpicSettings\\Fonts\\ActionMan.TTF";

local fontAlt = "Interface\\Addons\\EpicSettings\\Fonts\\PTSansNarrow.TTF";

local fontAltMulti = "Interface\\Addons\\EpicSettings\\Fonts\\NanumGothic-Regular.TTF";

local normalButtonFont = CreateFont("epicFontButtonNormal")
normalButtonFont:SetFont(font, 12, "")
normalButtonFont:SetTextColor(1, 0.725, 0.058, 1.0);
local selectedButtonFont = CreateFont("epicFontButtonSelected")
selectedButtonFont:SetFont(font, 12, "")
selectedButtonFont:SetTextColor(0.0, 0.0, 0.0, 1.0);
local normalButtonFontS = CreateFont("epicFontButtonNormalS")
normalButtonFontS:SetFont(font, 9, "")
normalButtonFontS:SetTextColor(1, 0.725, 0.058, 1.0);
local selectedButtonFontS = CreateFont("epicFontButtonSelectedS")
selectedButtonFontS:SetFont(font, 9, "")
selectedButtonFontS:SetTextColor(0.0, 0.0, 0.0, 1.0);

local normalFont = CreateFont("epicFontNormal")
normalFont:SetFont(font, 10, "")
normalFont:SetTextColor(1, 0.725, 0.058, 1.0);
local normalAccentFont = CreateFont("epicFontNormalAccent")
normalAccentFont:SetFont(font, 10, "")
normalAccentFont:SetTextColor(1, 0.968, 0.0, 1.0);
local normalAccentFontAlt = CreateFont("epicFontNormalAccentAlt")
normalAccentFontAlt:SetFont(fontAlt, 10, "")
normalAccentFontAlt:SetTextColor(1, 0.968, 0.0, 1.0);

local fontAlternativeNormal = CreateFont("epicFontAlternativeNormal")
fontAlternativeNormal:SetFont(fontAltMulti, 12, "")
fontAlternativeNormal:SetTextColor(1, 0.725, 0.058, 1.0);


-- Profiles
-- Load Settings When addon is loaded
local frame = CreateFrame("FRAME");
frame:RegisterEvent("ADDON_LOADED");
frame:RegisterEvent("PLAYER_LOGOUT");
frame:RegisterEvent("PLAYER_LOGIN");
frame:RegisterEvent("ADDON_ACTION_FORBIDDEN");
frame:RegisterEvent("ADDON_ACTION_BLOCKED");
frame:RegisterEvent("PLAYER_REGEN_DISABLED");
frame:RegisterEvent("PLAYER_REGEN_ENABLED");

local function HandleCommands(msg, editbox)
	if ES.Toggles[string.lower(msg)] ~= nil then
		  if ES.Toggles[string.lower(msg)] then
			ES.Toggles[string.lower(msg)] = false 
			print(string.lower(msg)..' Off')
			ES.Buttons[string.lower(msg)]:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted")
			ES.Buttons[string.lower(msg)]:SetNormalFontObject(_G["epicFontButtonNormal"])
		else
			ES.Toggles[string.lower(msg)] = true
			print(string.lower(msg)..' On')
			ES.Buttons[string.lower(msg)]:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButton")
			ES.Buttons[string.lower(msg)]:SetNormalFontObject(_G["epicFontButtonSelected"])
		end
	else
		local a, b, c = strsplit(" ", string.lower(msg), 3)
		if a == "cast" then
			ES.Queues[b..c] = true
			if b == "custom" then
				C_Timer.After(3.5, function() ES.Queues[b..c] = false end)
			else
				C_Timer.After(2.5, function() ES.Queues[b..c] = false end) -- /run print(EpicSettings.Queues["targetdisarm"])
			end
		elseif a == "resetqueues" then
			ES.Queues = {}
		elseif a == "hide" then
			if SettingsButton:IsVisible() then
				SettingsButton:Hide()
			else
				SettingsButton:Show()
			end
			if HideButton:IsVisible() then
				HideButton:Hide()
			else
				HideButton:Show()
			end
		elseif a == "debug" then
			ES.DebugOn = not ES.DebugOn
		end
	end
end

SLASH_EPICSTTNGS1, SLASH_EPICSTTNGS2, SLASH_EPICSTTNGS3 = '/epic', '/EPIC', '/Epic'

SlashCmdList["EPICSTTNGS"] = HandleCommands   -- add /hiw and /hellow to command list

function frame:OnEvent(event, arg1)
 if event == "ADDON_LOADED" and arg1 == "EpicSettings" then
	if EpicSettingsDB == nil then
		EpicSettingsDB = {}
	end
 elseif event == "PLAYER_LOGIN" then
	local SpecIndex = GetSpecialization()
	local Spec, _  = GetSpecializationInfo(SpecIndex)
	ES.SpecID = Spec

	if EpicSettingsDB[ES.SpecID] == nil then
		EpicSettingsDB[ES.SpecID] = {}
		EpicSettingsDB[ES.SpecID].Profiles = {}
		EpicSettingsDB[ES.SpecID].Profiles["Default"] = {}
		EpicSettingsDB[ES.SpecID].Profiles["Default"].ID = 1
		EpicSettingsDB[ES.SpecID].SelectedProfile = "Default"
	else
		if EpicSettingsDB[ES.SpecID].Profiles[EpicSettingsDB[ES.SpecID].SelectedProfile] == nil then
			EpicSettingsDB[ES.SpecID].Profiles["Default"] = {}
			EpicSettingsDB[ES.SpecID].Profiles["Default"].ID = 1
			EpicSettingsDB[ES.SpecID].SelectedProfile = "Default"
		end
	end

	ES.InitMiniButtons()
	ES.InitProfilesTab()
	ES.UpdateExistingControls()

	if GetCVar("setupEpicSettingsCVAR") == nil then 
		RegisterCVar("setupEpicSettingsCVAR", 0 )
	end
	SetCVar("setupEpicSettingsCVAR", 0)
 elseif event == "PLAYER_LOGOUT" then
		if EpicSettingsDB[ES.SpecID].Profiles[EpicSettingsDB[ES.SpecID].SelectedProfile] then
			for i, v in pairs(ES.Settings) do
				EpicSettingsDB[ES.SpecID].Profiles[EpicSettingsDB[ES.SpecID].SelectedProfile][i] = v
			end
		end
	elseif event == "ADDON_ACTION_FORBIDDEN" or event == "ADDON_ACTION_BLOCKED" then
		print(debugstack())
	elseif event == "PLAYER_REGEN_DISABLED" then
		print("Entered Combat")
	elseif event == "PLAYER_REGEN_ENABLED" then
		print("Exited Combat")
	end
end

--frame:EnableKeyboard(true)
--frame:SetPropagateKeyboardInput(true)
--
--function frame:OnKeyUp(event, arg1)
--	if event == 'Z' then
--		print("Key Released"..event)
--		--KeysPressed["Z"] = false
--		frame:SetPropagateKeyboardInput(true)
--	end
--end
--
--function frame:OnKeyDown(event, arg1)
--	if event == 'Z' then
--		ES.KeysPressed["Z"] = GetTime()
--		print("Key Pressed"..event)
--		frame:SetPropagateKeyboardInput(false)
--	end
--end

frame:SetScript("OnEvent", frame.OnEvent);

--frame:SetScript("OnKeyDown", frame.OnKeyDown);
--frame:SetScript("OnKeyUp", frame.OnKeyUp);

--Setup Controls
function ES.Setup()
	ES.InitTabs("First Tab", "Second Tab", "Third Tab", "Fourth", "Fifth", "Sixth", "Etc", "Another One", "And one with a long name")

	ES.InitMiniTabs(1, "Mini Tab 1", "Mini Tab 2")
	ES.InitMiniTabs(2, "Hi", "I'm a tab", "And one long tab to check the length of the letters")
	
	ES.AddCheckbox(1, 1, 0, "C1", "Checkbox1", false)
	ES.AddSlider(1, 1, 0, "F1", "Fun1 Slider", 5, 25, 11)
	ES.AddSlider(1, 1, 0, "F21","Fun21 Slider", 6, 66, 6)
	ES.AddCheckbox(1, 2, 0, "C14", "Checkbox11", false)
	ES.AddSlider(1, 2, 0, "F15", "Fun144 Slider", 5, 25, 11)
	ES.AddSlider(1, 2, 0, "F216","Fun2155 Slider", 6, 66, 6)
	ES.AddDropdown(1, 2, 1, "SomeDropdown2344", "DropdownTest22", "123", "Some long option, just for testing", "Option2", "123")
	ES.AddDropdown(1, 1, 1, "SomeDropdown23", "DropdownTest22", "123", "Option1", "Option2", "123")
	ES.AddSlider(1, 1, 1, "Fun2", "Fun2 Slider", 5, 25, 11)
	ES.AddTextbox(1, 1, 1, "Var123", "Text", "box")
	ES.AddSlider(1, 1, 2, "Fun3", "Fun3 Slider", 5, 25, 11)
	ES.AddLabel(1, 1, 2, "Im a label")
	ES.AddLabel(1, 1, 2, "Hi, im another label")
	ES.AddSlider(1, 1, 3, "Fun4", "Fun4 Slider", 5, 25, 11)
	ES.AddCheckbox(1, 1, 3, "Ch2", "Checkbox2", true)
	ES.AddDropdown(1, 1, 3, "SomeDropdown", "DropdownTest", "123", "Option1", "Option2", "123")
	ES.AddCheckbox(1, 1, 3, "Ch3", "Checkbox3", false)
	ES.AddCheckbox(1, 1, 4, "Ch322", "CheckboxHi", false)
	ES.AddDropdown(1, 1, 5, "SomeDropdownHello", "DropdownTest123", "123", "Option1", "Option2", "123")
	ES.AddTextbox(1, 1, 5, "TextVar1", "Testing Textbox", "Hi, im a test")

	ES.AddLabel(2, 1, 0, "This is a test")
	ES.AddLabel(2, 1, 0, "This is another test")
	ES.AddLabel(2, 1, 1, "Another label, line 1")

	ES.InitButtonMain("Main", "xxxxx")

	ES.InitToggle("Cooldowns", "CDs", false, "")

	ES.InitToggle("AOE", "AOE", false, "Test explanation")

	ES.InitToggle("Third Toggle", "T12T", true, "Test")

end

function ES.InitTabs(...)
	local arg = {...}	

	--Hardcode third to last tab as Trinkets
	arg[#arg+1] = "Trinkets"

	--Hardcode second to last tab as Pots
	arg[#arg+1] = "Potions"

	--Hardcode last tab as Cycle
	arg[#arg+1] = "Cycle"

	--Set the Tabs' Frame backdrop
	local topWindowBackdrop ={
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
 		edgeFile = "Interface\\Addons\\EpicSettings\\Vectors\\border",
		tile = true,
		tileEdge = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 3, right = 5, top = 3, bottom = 5 },
	}

	local backdropInfo ={
		--bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
 		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
 		tile = true,
 		tileEdge = true,
 		tileSize = 8,
 		edgeSize = 8,
 		insets = { left = 1, right = 1, top = 1, bottom = 1 },
	}

	local texture = SettingsFrameIconHeader:CreateTexture()
	texture:SetAllPoints()
	texture:SetPoint("TOPLEFT", SettingsFrameIconHeader ,"TOPLEFT", 34, -1)
	texture:SetPoint("BOTTOMRIGHT", SettingsFrameIconHeader ,"BOTTOMRIGHT", -34, 1)
	texture:SetTexture("Interface\\Addons\\EpicSettings\\Vectors\\epic3d")
	SettingsFrameIconHeader.texture = texture

	SettingsFrameTabs:SetBackdrop(backdropInfo);
	SettingsFrameIconHeader:SetBackdrop(backdropInfo);

	SettingsFrame:SetBackdrop(topWindowBackdrop);
	--SettingsFrame:SetBackdropBorderColor(0.9, 0.9 ,0.1, 1.0);

	LoadSaveButton:SetSize(ES.TabButtonSizeX, ES.TabButtonSizeY)
	LoadSaveButton:SetPoint("TOPLEFT", SettingsFrameTabs, "BOTTOMLEFT", ES.TabOffsetX, ES.TabOffsetY+ES.TabButtonSizeY)
	LoadSaveButton:SetText("Profiles")
	LoadSaveButton:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted")--1Button BigButtonNotHighlighted
	LoadSaveButton:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
	LoadSaveButton:SetNormalFontObject(_G["epicFontButtonNormal"])
	LoadSaveButton:SetHighlightFontObject(_G["epicFontButtonSelected"])

	CommandsButton:SetSize(ES.TabButtonSizeX, ES.TabButtonSizeY)
	CommandsButton:SetPoint("TOPLEFT", SettingsFrameTabs, "BOTTOMLEFT", ES.TabOffsetX, ES.TabOffsetY+ES.TabButtonSizeY + ES.TabButtonSizeY +ES.TabButtonsSpacingY)
	CommandsButton:SetText("Commands")
	CommandsButton:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted")--1Button BigButtonNotHighlighted
	CommandsButton:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
	CommandsButton:SetNormalFontObject(_G["epicFontButtonNormal"])
	CommandsButton:SetHighlightFontObject(_G["epicFontButtonSelected"])

	for i=1,#arg do
		ES.Tabs[i] = {}
		--ES.Tabs[i].Lines = {}

		ES.Tabs[i].CategoriesBody = CreateFrame("Frame", "SettingsFrameTab"..i, SettingsFrame, "BackdropTemplate")
		ES.Tabs[i].CategoriesBody:SetPoint("TOPRIGHT", SettingsFrame, "TOPRIGHT", -10, -10)
		ES.Tabs[i].CategoriesBody:SetSize(ES.TabBodySizeX, ES.TabBodyCategoriesSizeY)
		ES.Tabs[i].CategoriesBody:Hide();
		ES.Tabs[i].CategoriesBody:SetBackdrop(backdropInfo)
	
		ES.Tabs[i].MiniTabs = {}

		ES.Tabs[i].Button = CreateFrame("Button", nil, SettingsFrameTabs, "UIPanelButtonTemplate")
		ES.Tabs[i].Button:SetPoint("TOPLEFT", SettingsFrameTabs, "TOPLEFT", ES.TabOffsetX, -ES.TabOffsetY + ES.TabNextOffsetY)
		ES.Tabs[i].Button:SetSize(ES.TabButtonSizeX, ES.TabButtonSizeY)
		ES.Tabs[i].Button:SetText(arg[i])
		ES.Tabs[i].Button:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted")--1Button BigButtonNotHighlighted
		ES.Tabs[i].Button:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
		ES.Tabs[i].Button:SetNormalFontObject(_G["epicFontButtonNormal"])
		ES.Tabs[i].Button:SetHighlightFontObject(_G["epicFontButtonSelected"])

		ES.Tabs[i].Button:SetScript("OnClick", function(self, button, down)
			ES.ToggleTab(i, 1)
		end)
		ES.Tabs[i].Button:RegisterForClicks("AnyDown", "AnyUp")

		ES.TabNextOffsetY = ES.TabNextOffsetY - ES.TabButtonSizeY -ES.TabButtonsSpacingY;
	end
	SettingsFrameTabProfiles:Hide();

	--Hardcode minitabs for trinkets
	ES.InitMiniTabs(#arg-2, "Top", "Bottom", "Special")

	--Hardcode trinket settings
	ES.AddDropdown(#arg-2, 1, 0, "TopTrinketCondition", "Top Trinket Usage", "Don't Use", "At HP", "On Cooldown", "With Cooldowns", "Don't Use");
	ES.AddDropdown(#arg-2, 1, 0, "TopTrinketTarget", "Top Trinket Target", "Enemy", "Enemy", "Player", "Cursor", "Friendly");
	ES.AddDropdown(#arg-2, 1, 1, "TopTrinketCursor", "Top Trinket Cursor Settings", "Enemy Under Cursor", "Confirmation", "Cursor", "Enemy Under Cursor");
	ES.AddSlider(#arg-2, 1, 1, "TopTrinketHP", "Top Trinket @ HP", 0, 100, 80);

	ES.AddDropdown(#arg-2, 2, 0, "BottomTrinketCondition", "Bottom Trinket Usage", "Don't Use", "At HP", "On Cooldown", "With Cooldowns", "Don't Use");
	ES.AddDropdown(#arg-2, 2, 0, "BottomTrinketTarget", "Bottom Trinket Target", "Enemy", "Enemy", "Player", "Cursor", "Friendly");
	ES.AddDropdown(#arg-2, 2, 1, "BottomTrinketCursor", "Bottom Trinket Cursor Settings", "Enemy Under Cursor", "Confirmation", "Cursor", "Enemy Under Cursor");
	ES.AddSlider(#arg-2, 2, 1, "BottomTrinketHP", "Bottom Trinket @ HP", 0, 100, 80);

	ES.AddDropdown(#arg-2, 3, 0, "SpoilsOfNeltharusUsage", "Spoils of Neltharus Trinket", "Not Equipped", "Top", "Bottom", "Not Equipped" );
	ES.AddCheckbox(#arg-2, 3, 1, "NeltharusHaste", "Use with Haste", true);
	ES.AddCheckbox(#arg-2, 3, 1, "NeltharusCrit", "Use with Crit", true);
	ES.AddCheckbox(#arg-2, 3, 2, "NeltharusMastery", "Use with Mastery", false);
	ES.AddCheckbox(#arg-2, 3, 2, "NeltharusVersatility", "Use with Versatility", false);

	--Hardcode minitabs for Pots
	ES.InitMiniTabs(#arg-1, "DPS")
	
	--Hardcode trinket settings
	ES.AddDropdown(#arg-1, 1, 0, "DPSPotionUsage", "DPS Potion With", "Bloodlust+Cooldowns", "Cooldowns", "Bloodlust", "Bloodlust+Cooldowns", "On Cooldown", "Don't Use");
	ES.AddDropdown(#arg-1, 1, 1, "DPSPotionName", "DPS Potion Name", "Ultimate Power", "Fleeting Ultimate Power", "Ultimate Power", "Fleeting Power", "Power", "Shocking Disclosure");
	--ES.AddDropdown(#arg-1, 1, 1, "DPSPotionRank", "DPS Potion Rank", "3", "1", "2", "3");

	--Hardcode minitabs for Cycle
	ES.InitMiniTabs(#arg, "Cycle", "Pulse")
	
	--Hardcode trinket settings
	ES.AddSlider(#arg, 1, 1, "cycleDelay", "Cycle delay", 500, 2500, 500);
	ES.AddCheckbox(#arg, 2, 1, "pulseSaveCPU", "Reduce CPU Load", false);
	ES.AddSlider(#arg, 2, 1, "pulseSaveCPUOffset", "CPU Load Offset in milliseconds", 0, 600, 300);
	--ES.AddDropdown(#arg, 1, 1, "DPSPotionRank", "DPS Potion Rank", "3", "1", "2", "3");
	
end

function ES.InitMiniTabs(tab, ...)
	local arg = {...}

	local backdropInfo ={
		--bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
 		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
 		tile = true,
 		tileEdge = true,
 		tileSize = 8,
 		edgeSize = 8,
 		insets = { left = 1, right = 1, top = 1, bottom = 1 },
	}

	ES.MiniTabNextOffsetX = 0
	
	for i=1,#arg do
		ES.Tabs[tab].MiniTabs[i] = {}
		ES.Tabs[tab].MiniTabs[i].Lines = {}

		ES.Tabs[tab].MiniTabs[i].Body = CreateFrame("Frame", "SettingsFrameTab"..i, SettingsFrame, "BackdropTemplate")
		ES.Tabs[tab].MiniTabs[i].Body:SetPoint("BOTTOMRIGHT", SettingsFrame, "BOTTOMRIGHT", -10, 10)
		ES.Tabs[tab].MiniTabs[i].Body:SetSize(ES.TabBodySizeX, ES.TabBodySizeY)
		ES.Tabs[tab].MiniTabs[i].Body:Hide();
		ES.Tabs[tab].MiniTabs[i].Body:SetBackdrop(backdropInfo)
		ES.Tabs[tab].MiniTabs[i].Body:SetScript("OnMouseDown", function(self, button, down)
			ES.MinimizeDropdowns(nil)
		end)

		ES.Tabs[tab].MiniTabs[i].Button = CreateFrame("Button", nil, ES.Tabs[tab].CategoriesBody, "UIPanelButtonTemplate")
		ES.Tabs[tab].MiniTabs[i].Button:SetPoint("BOTTOMLEFT", ES.Tabs[tab].CategoriesBody, "BOTTOMLEFT", ES.MiniTabOffsetX + ES.MiniTabNextOffsetX, ES.MiniTabOffsetY)
		ES.Tabs[tab].MiniTabs[i].Button:SetSize(ES.MiniTabButtonSizeX, ES.MiniTabButtonSizeY)
		ES.Tabs[tab].MiniTabs[i].Button:SetText(arg[i])
		ES.Tabs[tab].MiniTabs[i].Button:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted")--1Button BigButtonNotHighlighted
		ES.Tabs[tab].MiniTabs[i].Button:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
		ES.Tabs[tab].MiniTabs[i].Button:SetNormalFontObject(_G["epicFontButtonNormalS"])
		ES.Tabs[tab].MiniTabs[i].Button:SetHighlightFontObject(_G["epicFontButtonSelectedS"])

		ES.Tabs[tab].MiniTabs[i].Button:SetScript("OnClick", function(self, button, down)
			ES.ToggleTab(tab, i)
		end)
		ES.Tabs[tab].MiniTabs[i].Button:RegisterForClicks("AnyDown", "AnyUp")

		ES.MiniTabNextOffsetX = ES.MiniTabNextOffsetX + ES.MiniTabButtonSizeX +ES.MiniTabButtonsSpacingX;
	end

end

function ES.InitMiniButtons()
	SettingsButton:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted")
	SettingsButton:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
	SettingsButton:SetNormalFontObject(_G["epicFontButtonNormal"])
	SettingsButton:SetHighlightFontObject(_G["epicFontButtonSelected"])

	HideButton:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted")
	HideButton:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
	HideButton:SetNormalFontObject(_G["epicFontButtonNormal"])
	HideButton:SetHighlightFontObject(_G["epicFontButtonSelected"])
end

function ES.InitProfilesTab()
	local backdropInfo ={
		--bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
 		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
 		tile = true,
 		tileEdge = true,
 		tileSize = 8,
 		edgeSize = 8,
 		insets = { left = 1, right = 1, top = 1, bottom = 1 },
	}

	ES.SettingsFrameTabProfiles.CategoriesBody = CreateFrame("Frame", "SettingsFrameTabProfiles", SettingsFrame, "BackdropTemplate")
	ES.SettingsFrameTabProfiles.CategoriesBody:SetPoint("TOPRIGHT", SettingsFrame, "TOPRIGHT", -10, -10)
	ES.SettingsFrameTabProfiles.CategoriesBody:SetSize(ES.TabBodySizeX, ES.TabBodyCategoriesSizeY)
	ES.SettingsFrameTabProfiles.CategoriesBody:Hide();
	ES.SettingsFrameTabProfiles.CategoriesBody:SetBackdrop(backdropInfo)

	ES.SettingsFrameTabProfiles.Body = CreateFrame("Frame", "SettingsFrameTabProfiles", SettingsFrame, "BackdropTemplate")
	ES.SettingsFrameTabProfiles.Body:SetPoint("BOTTOMRIGHT", SettingsFrame, "BOTTOMRIGHT", -10, 10)
	ES.SettingsFrameTabProfiles.Body:SetSize(ES.TabBodySizeX, ES.TabBodySizeY)
	ES.SettingsFrameTabProfiles.Body:Hide();
	ES.SettingsFrameTabProfiles.Body:SetBackdrop(backdropInfo)

	ES.SettingsFrameTabCommands.CategoriesBody = CreateFrame("Frame", "SettingsFrameTabCommandsCategories", SettingsFrame, "BackdropTemplate")
	ES.SettingsFrameTabCommands.CategoriesBody:SetPoint("TOPRIGHT", SettingsFrame, "TOPRIGHT", -10, -10)
	ES.SettingsFrameTabCommands.CategoriesBody:SetSize(ES.TabBodySizeX, ES.TabBodyCategoriesSizeY)
	ES.SettingsFrameTabCommands.CategoriesBody:Hide();
	ES.SettingsFrameTabCommands.CategoriesBody:SetBackdrop(backdropInfo)

	ES.SettingsFrameTabCommands.MiniTabs = {}

	local miniTabNextOffsetXCommands = 0
	local commandTabNames = {"Toggles", "Player", "Target", "Cursor", "Mouseover", "Focus", "PvP", "Custom"}
	
	for i=1,#commandTabNames do
		ES.SettingsFrameTabCommands.MiniTabs[i] = {}
		ES.SettingsFrameTabCommands.MiniTabs[i].Lines = {}
		ES.SettingsFrameTabCommands.MiniTabs[i].NumberOfCommands = 0

		ES.SettingsFrameTabCommands.MiniTabs[i].Body = CreateFrame("Frame", nil, SettingsFrame, "BackdropTemplate")
		ES.SettingsFrameTabCommands.MiniTabs[i].Body:SetPoint("BOTTOMRIGHT", SettingsFrame, "BOTTOMRIGHT", -10, 10)
		ES.SettingsFrameTabCommands.MiniTabs[i].Body:SetSize(ES.TabBodySizeX, ES.TabBodySizeY)
		ES.SettingsFrameTabCommands.MiniTabs[i].Body:Hide();
		ES.SettingsFrameTabCommands.MiniTabs[i].Body:SetBackdrop(backdropInfo)
		ES.SettingsFrameTabCommands.MiniTabs[i].Body:SetScript("OnMouseDown", function(self, button, down)
			ES.MinimizeDropdowns(nil)
		end)

		ES.SettingsFrameTabCommands.MiniTabs[i].Button = CreateFrame("Button", nil, ES.SettingsFrameTabCommands.CategoriesBody, "UIPanelButtonTemplate")
		ES.SettingsFrameTabCommands.MiniTabs[i].Button:SetPoint("BOTTOMLEFT", ES.SettingsFrameTabCommands.CategoriesBody, "BOTTOMLEFT", ES.MiniTabOffsetX + miniTabNextOffsetXCommands, ES.MiniTabOffsetY)
		ES.SettingsFrameTabCommands.MiniTabs[i].Button:SetSize(ES.MiniTabButtonSizeX, ES.MiniTabButtonSizeY)
		ES.SettingsFrameTabCommands.MiniTabs[i].Button:SetText(commandTabNames[i])
		ES.SettingsFrameTabCommands.MiniTabs[i].Button:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted")--1Button BigButtonNotHighlighted
		ES.SettingsFrameTabCommands.MiniTabs[i].Button:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
		ES.SettingsFrameTabCommands.MiniTabs[i].Button:SetNormalFontObject(_G["epicFontButtonNormalS"])
		ES.SettingsFrameTabCommands.MiniTabs[i].Button:SetHighlightFontObject(_G["epicFontButtonSelectedS"])

		ES.SettingsFrameTabCommands.MiniTabs[i].Button:SetScript("OnClick", function(self, button, down)
			ES.ToggleTab(99, i)
		end)
		ES.SettingsFrameTabCommands.MiniTabs[i].Button:RegisterForClicks("AnyDown", "AnyUp")

		miniTabNextOffsetXCommands = miniTabNextOffsetXCommands + ES.MiniTabButtonSizeX +ES.MiniTabButtonsSpacingX;
	end

	local i = 1
	for _,k in pairs(ES.GetProfileKeysInOrder()) do
		ES.ProfileButtons[k] = CreateFrame("Frame", nil, ES.SettingsFrameTabProfiles.Body, "BackdropTemplate")
		ES.ProfileButtons[k]:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\Addons\\EpicSettings\\Vectors\\borderActive",
			edgeSize = 16,
			insets = { left = 4, right = 4, top = 4, bottom = 4 },
		})
		if EpicSettingsDB[ES.SpecID].SelectedProfile == k then
			ES.ProfileButtons[k]:SetBackdropBorderColor(1, 0.9, 0.9, 1)
		else
			ES.ProfileButtons[k]:SetBackdropBorderColor(0.2, 0, 0, 1)
		end
		ES.ProfileButtons[k]:SetPoint("TOPLEFT", ES.SettingsFrameTabProfiles.Body, "TOPLEFT", 10, -8 - 70*(i-1))
		ES.ProfileButtons[k]:SetSize(400,70);

		local Button = CreateFrame("Button", nil, ES.ProfileButtons[k], "UIPanelButtonTemplate")
		Button:SetPoint("TOPLEFT", ES.ProfileButtons[k], "TOPLEFT", 10, -10)
		Button:SetPoint("BOTTOMRIGHT", ES.ProfileButtons[k], "BOTTOMLEFT", 130, 14)
		--Button:SetSize(100, 50)
		Button:SetText(k)
		Button:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted")--1Button BigButtonNotHighlighted
		Button:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
		Button:SetNormalFontObject(_G["epicFontButtonNormal"])
		Button:SetHighlightFontObject(_G["epicFontButtonSelected"])
		Button:SetScript("OnClick", function(self, button, down)
			ES.ChangeProfile(k)
		end)

		local ButtonDelete = CreateFrame("Button", nil, ES.ProfileButtons[k], "UIPanelButtonTemplate")
		--ButtonDelete:SetPoint("CENTER", ES.ProfileButtons[k], "TOPRIGHT", -50, -35)
		--ButtonDelete:SetSize(80, 50)
		ButtonDelete:SetPoint("TOPLEFT", ES.ProfileButtons[k], "TOPRIGHT", -130, -10)
		ButtonDelete:SetPoint("BOTTOMRIGHT", ES.ProfileButtons[k], "BOTTOMRIGHT", -10, 14)
		ButtonDelete:SetText("Delete Profile")
		ButtonDelete:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted")--1Button BigButtonNotHighlighted
		ButtonDelete:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
		ButtonDelete:SetNormalFontObject(_G["epicFontButtonNormal"])
		ButtonDelete:SetHighlightFontObject(_G["epicFontButtonSelected"])
		ButtonDelete:SetScript("OnClick", function(self, button, down)
			ES.DeleteProfile(k)
		end)

		i = i + 1
	end

	local EditBox = CreateFrame("EditBox", nil, ES.SettingsFrameTabProfiles.Body, "InputBoxTemplate")
	EditBox:SetPoint("TOPRIGHT", ES.SettingsFrameTabProfiles.Body, "TOPRIGHT", -ES.MiniTabOffsetX, -ES.MiniTabOffsetY)
	EditBox:SetSize(ES.MiniTabButtonSizeX-4, ES.MiniTabButtonSizeY)
	EditBox:SetAutoFocus(false)
	EditBox:SetText("Profile Name")
	EditBox:SetFontObject(_G["epicFontNormalAccentAlt"])

	local texture = EditBox:CreateTexture()
	texture:SetAllPoints()
	texture:SetPoint("TOPLEFT", EditBox ,"TOPLEFT", -4, 0)
	texture:SetPoint("BOTTOMRIGHT", EditBox ,"BOTTOMRIGHT", 0, 0)
	texture:SetTexture("Interface\\Addons\\EpicSettings\\Vectors\\Editbox")
	EditBox.texture = texture

	local ButtonCreate = CreateFrame("Button", nil, ES.SettingsFrameTabProfiles.CategoriesBody, "UIPanelButtonTemplate")
	ButtonCreate:SetPoint("BOTTOMRIGHT", ES.SettingsFrameTabProfiles.CategoriesBody, "BOTTOMRIGHT", -ES.MiniTabOffsetX, ES.MiniTabOffsetY)
	ButtonCreate:SetSize(ES.MiniTabButtonSizeX, ES.MiniTabButtonSizeY)
	ButtonCreate:SetText("Create Profile")
	ButtonCreate:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted")--1Button BigButtonNotHighlighted
	ButtonCreate:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
	ButtonCreate:SetNormalFontObject(_G["epicFontButtonNormalS"])
	ButtonCreate:SetHighlightFontObject(_G["epicFontButtonSelectedS"])
	ButtonCreate:SetScript("OnClick", function(self, button, down)
		ES.CreateProfile(EditBox:GetText())
	end)
	
	local ButtonResetToDefault = CreateFrame("Button", nil, ES.SettingsFrameTabProfiles.CategoriesBody, "UIPanelButtonTemplate")
	ButtonResetToDefault:SetPoint("BOTTOMLEFT", ES.SettingsFrameTabProfiles.CategoriesBody, "BOTTOMLEFT", ES.MiniTabOffsetX, ES.MiniTabOffsetY)
	ButtonResetToDefault:SetSize(ES.MiniTabButtonSizeX*2+10, ES.MiniTabButtonSizeY)
	ButtonResetToDefault:SetText("Reset Selected Profile to Default")
	ButtonResetToDefault:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted")--1Button BigButtonNotHighlighted
	ButtonResetToDefault:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
	ButtonResetToDefault:SetNormalFontObject(_G["epicFontButtonNormalS"])
	ButtonResetToDefault:SetHighlightFontObject(_G["epicFontButtonSelectedS"])
	ButtonResetToDefault:SetScript("OnClick", function(self, button, down)
		for i, v in pairs(ES.DefaultSettings) do
			ES.Settings[i] = v
		end
		ES.UpdateExistingControls();
	end)

	local ButtonLockETESPos = CreateFrame("Button", nil, ES.SettingsFrameTabProfiles.CategoriesBody, "UIPanelButtonTemplate")
	ButtonLockETESPos:SetPoint("BOTTOMLEFT", ES.SettingsFrameTabProfiles.CategoriesBody, "BOTTOMLEFT", ES.MiniTabOffsetX + ES.MiniTabButtonSizeX*2+10 + ES.MiniTabOffsetX, ES.MiniTabOffsetY)
	ButtonLockETESPos:SetSize(ES.MiniTabButtonSizeX, ES.MiniTabButtonSizeY)
	ButtonLockETESPos:SetText("Lock ES/ET")
	ButtonLockETESPos:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted")
	ButtonLockETESPos:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
	ButtonLockETESPos:SetNormalFontObject(_G["epicFontButtonNormalS"])
	ButtonLockETESPos:SetHighlightFontObject(_G["epicFontButtonSelectedS"])
	ButtonLockETESPos:SetScript("OnClick", function(self, button, down)
		if SettingsButton:IsMovable() then
			self:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButton")
			self:SetNormalFontObject(_G["epicFontButtonSelectedS"])
			SettingsButton:SetMovable(false);
		else
			ButtonLockETESPos:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted")
			self:SetNormalFontObject(_G["epicFontButtonNormalS"])
			SettingsButton:SetMovable(true);
		end
		if HideButton:IsMovable() then
			HideButton:SetMovable(false);
		else
			HideButton:SetMovable(true);
		end
	end)
	
	--Version label
	ES.SettingsFrameTabProfiles.VersionLabel = CreateFrame("Frame", nil, ES.SettingsFrameTabProfiles.CategoriesBody)
	ES.SettingsFrameTabProfiles.VersionLabel:SetPoint("BOTTOMLEFT", ES.SettingsFrameTabProfiles.CategoriesBody, "BOTTOMLEFT", ES.MiniTabOffsetX + ES.MiniTabButtonSizeX*5+10 + ES.MiniTabOffsetX, ES.MiniTabOffsetY)
	ES.SettingsFrameTabProfiles.VersionLabel:SetSize(ES.MiniTabButtonSizeX*2+10, ES.MiniTabButtonSizeY)
	ES.SettingsFrameTabProfiles.VersionText = ES.SettingsFrameTabProfiles.VersionLabel:CreateFontString(nil,"OVERLAY","GameFontNormal");
	ES.SettingsFrameTabProfiles.VersionText:SetPoint("CENTER");
	ES.SettingsFrameTabProfiles.VersionText:SetText("");
	ES.SettingsFrameTabProfiles.VersionText:SetFontObject(_G["epicFontNormal"])

	ES.AddLabelForCommands(1, 0, "These are the Commands to manually control the toggles")	
	ES.AddLabelForCommands(2, 0, "These spells can be queued to cast on player")
	ES.AddLabelForCommands(2, 1, "If you want to queue other spells, ask the responsible Dev")
	ES.AddLabelForCommands(3, 0, "These spells can be queued to cast on target")
	ES.AddLabelForCommands(4, 0, "These spells can be queued to cast on cursor")
	ES.AddLabelForCommands(4, 1, "If you want to queue other spells, ask the responsible Dev")
	ES.AddLabelForCommands(5, 0, "These spells can be queued to cast on mouseover")
	ES.AddLabelForCommands(5, 1, "If you want to queue other spells, ask the responsible Dev")
	ES.AddLabelForCommands(6, 0, "These spells can be queued to cast on focus")
	ES.AddLabelForCommands(6, 1, "If you want to queue other spells, ask the responsible Dev")
	

	--[[
	local ButtonLockUnlockToggles = CreateFrame("Button", nil, SettingsFrameTabProfiles, "UIPanelButtonTemplate")
	ButtonResetToDefault:SetPoint("TOPRIGHT", SettingsFrameTabProfiles, "BOTTOMRIGHT", -10, 60)
	ButtonResetToDefault:SetSize(100, 50)
	ButtonResetToDefault:SetText("Lock Toggles' Position")
	ButtonResetToDefault:SetScript("OnClick", function(self, button, down)
		if FrameToggles:IsMoveable() then
			FrameToggles.SetMoveable(false);
			self:SetText("Unlock Toggles' Position")
		else
			FrameToggles.SetMoveable(true);
			self:SetText("Lock Toggles' Position")
		end
	end)
	--]]

end

function ES.ChangeProfile(profile)
	for k,v in pairs(ES.ProfileButtons) do
		if k == profile then
			v:SetBackdropBorderColor(1, 0.9, 0.9, 1)
		else
			v:SetBackdropBorderColor(0.2, 0, 0, 1)
		end
	end

	if EpicSettingsDB[ES.SpecID].SelectedProfile then
		for i, v in pairs(ES.Settings) do
			EpicSettingsDB[ES.SpecID].Profiles[EpicSettingsDB[ES.SpecID].SelectedProfile][i] = v
		end
	end

	EpicSettingsDB[ES.SpecID].SelectedProfile = profile

	-- Update Settings to the loaded profile's ones
	for i, v in pairs(EpicSettingsDB[ES.SpecID].Profiles[profile]) do
		ES.Settings[i] = v
	end

	ES.UpdateExistingControls();
end


-- /run print(EpicSettings.GetProfileKeysInOrder()[1])
function ES.GetProfileKeysInOrder()
	local keysInAscendingOrder = {}
	local ids = {}
	local i = 1

	for k,v in pairs(EpicSettingsDB[ES.SpecID].Profiles) do
		keysInAscendingOrder[i] = k;
		i = i+1
	end

	return keysInAscendingOrder
end

function ES.CreateProfile(profile)
	local currentProfileCount = 0
	for k, v in pairs(EpicSettingsDB[ES.SpecID].Profiles) do
		if v then
			currentProfileCount = currentProfileCount + 1
		end
	end

	if EpicSettingsDB[ES.SpecID].Profiles[profile] then
		ES.CreateProfile(profile.."_")
		return
	end

	if currentProfileCount >= ES.MaxProfiles then
		return
	end
	
	local profileID = 0
	
	if currentProfileCount > 0 then
		profileID = EpicSettingsDB[ES.SpecID].Profiles[ES.GetProfileKeysInOrder()[1]].ID + 1
	end

	EpicSettingsDB[ES.SpecID].Profiles[profile] = {}

	for i, v in pairs(ES.Settings) do
		EpicSettingsDB[ES.SpecID].Profiles[profile][i] = v
	end

	EpicSettingsDB[ES.SpecID].Profiles[profile].ID = profileID
	
	--Add a new Profile Button
	
	ES.ProfileButtons[profile] = CreateFrame("Frame", nil, ES.SettingsFrameTabProfiles.Body, "BackdropTemplate")
	ES.ProfileButtons[profile]:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\Addons\\EpicSettings\\Vectors\\borderActive",
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	ES.ProfileButtons[profile]:SetBackdropBorderColor(1, 0.9, 0.9, 1)
	ES.ProfileButtons[profile]:SetPoint("TOPLEFT", ES.SettingsFrameTabProfiles.Body, "TOPLEFT", 10, -8 - 70*(currentProfileCount))
	ES.ProfileButtons[profile]:SetSize(400,70);

	local ButtonDelete = CreateFrame("Button", nil, ES.ProfileButtons[profile], "UIPanelButtonTemplate")
	ButtonDelete:SetPoint("TOPLEFT", ES.ProfileButtons[profile], "TOPRIGHT", -130, -10)
	ButtonDelete:SetPoint("BOTTOMRIGHT", ES.ProfileButtons[profile], "BOTTOMRIGHT", -10, 14)
	ButtonDelete:SetText("Delete Profile")
	ButtonDelete:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted")
	ButtonDelete:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
	ButtonDelete:SetNormalFontObject(_G["epicFontButtonNormal"])
	ButtonDelete:SetHighlightFontObject(_G["epicFontButtonSelected"])
	ButtonDelete:SetScript("OnClick", function(self, button, down)
		ES.DeleteProfile(profile)
	end)

	local Button = CreateFrame("Button", nil, ES.ProfileButtons[profile], "UIPanelButtonTemplate")
	Button:SetPoint("TOPLEFT", ES.ProfileButtons[profile], "TOPLEFT", 10, -10)
	Button:SetPoint("BOTTOMRIGHT", ES.ProfileButtons[profile], "BOTTOMLEFT", 130, 14)
	Button:SetText(profile)
	Button:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted")
	Button:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
	Button:SetNormalFontObject(_G["epicFontButtonNormal"])
	Button:SetHighlightFontObject(_G["epicFontButtonSelected"])
	Button:SetScript("OnClick", function(self, button, down)
		ES.ChangeProfile(profile)
	end)

	--Change the current Profile
	ES.ChangeProfile(profile)
end

function ES.DeleteProfile(profile)
	EpicSettingsDB[ES.SpecID].Profiles[profile] = nil

	ES.ProfileButtons[profile]:Hide()

	if EpicSettingsDB[ES.SpecID].SelectedProfile == profile then
		if ES.GetProfileKeysInOrder()[1] then
			EpicSettingsDB[ES.SpecID].SelectedProfile = ES.GetProfileKeysInOrder()[1]
			ES.ChangeProfile(ES.GetProfileKeysInOrder()[1])
		else
			EpicSettingsDB[ES.SpecID].SelectedProfile = nil
		end
	end

	ES.ReorderProfileFrame()
end

function ES.ReorderProfileFrame()
	local i = 1
	for _,k in pairs(ES.GetProfileKeysInOrder()) do
		ES.ProfileButtons[k]:SetPoint("TOPLEFT", ES.SettingsFrameTabProfiles.Body, "TOPLEFT", 10, -8 - 80*(i-1))
		i = i + 1
	end

end

function ES.ToggleTab(tab, minitab)
	for i,v in ipairs(ES.Tabs) do 
		if i == tab then
			for j,u in ipairs(ES.Tabs[i].MiniTabs) do 
				if j == minitab then
					u.Body:Show();
					u.Button:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButton")--2ndtry 
					u.Button:SetNormalFontObject(_G["epicFontButtonSelectedS"])
				else
					u.Body:Hide();
					u.Button:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted") -- BigButtonS
					u.Button:SetNormalFontObject(_G["epicFontButtonNormalS"])
				end
			end
			v.CategoriesBody:Show();
			v.Button:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButton")--2ndtry
			v.Button:SetNormalFontObject(_G["epicFontButtonSelected"])
		else
			for j,u in ipairs(ES.Tabs[i].MiniTabs) do 
				u.Body:Hide();
				u.Button:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted") -- BigButtonS
				u.Button:SetNormalFontObject(_G["epicFontButtonNormalS"])
			end
			v.CategoriesBody:Hide();
			v.Button:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted") --BigButtonS
			v.Button:SetNormalFontObject(_G["epicFontButtonNormal"])
		end
	end
	if tab == 0 then
		ES.SettingsFrameTabProfiles.Body:Show();
		ES.SettingsFrameTabProfiles.CategoriesBody:Show();
		LoadSaveButton:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButton")--2ndtry
		LoadSaveButton:SetNormalFontObject(_G["epicFontButtonSelected"])
	else
		ES.SettingsFrameTabProfiles.Body:Hide();
		ES.SettingsFrameTabProfiles.CategoriesBody:Hide();
		LoadSaveButton:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted")
		LoadSaveButton:SetNormalFontObject(_G["epicFontButtonNormal"])
	end
	if tab == 99 then
		for j,u in ipairs(ES.SettingsFrameTabCommands.MiniTabs) do 
			if j == minitab then
				u.Body:Show();
				u.Button:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButton")--2ndtry 
				u.Button:SetNormalFontObject(_G["epicFontButtonSelectedS"])
			else
				u.Body:Hide();
				u.Button:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted") -- BigButtonS
				u.Button:SetNormalFontObject(_G["epicFontButtonNormalS"])
			end
		end
		ES.SettingsFrameTabCommands.CategoriesBody:Show();
		CommandsButton:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButton")--2ndtry
		CommandsButton:SetNormalFontObject(_G["epicFontButtonSelected"])
	else
		for j,u in ipairs(ES.SettingsFrameTabCommands.MiniTabs) do 
			u.Body:Hide();
			u.Button:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted") -- BigButtonS
			u.Button:SetNormalFontObject(_G["epicFontButtonNormalS"])
		end
		ES.SettingsFrameTabCommands.CategoriesBody:Hide();
		CommandsButton:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted") --BigButtonS
		CommandsButton:SetNormalFontObject(_G["epicFontButtonNormal"])
	end
	ES.MinimizeDropdowns(nil)
	--ES.SettingsFrameTabProfiles.Body:Hide();
end

function ES.MinimizeDropdowns(dropdownName)
	--Close Dropdowns
	for i,v in pairs(ES.Tabs) do 
		for _,m in pairs(v.MiniTabs) do 
			for _,l in pairs(m.Lines) do 
				for k,u in pairs(l.Controls) do
					local controlName = u:GetName()
					if controlName ~= dropdownName then
						if string.find(controlName, "DROPDOWN") then
							for _,t in pairs(u.optionControls) do
								t:Hide()
							end
						end
					end
				end
			end
		end
	end
end

function ES.UpdateExistingControls()
	for i=1,#ES.Tabs do
		for k=1,#ES.Tabs[i].MiniTabs do
			--for j=0,#ES.Tabs[i].MiniTabs[k].Lines-1 do
			for _,u in pairs(ES.Tabs[i].MiniTabs[k].Lines) do
				for k,v in pairs(u.Controls) do
					local controlName = v:GetName()
					--Dropdowns
					if string.find(controlName, "DROPDOWN") then
						local variableName = string.sub(controlName, 9, #controlName)
						--UIDropDownMenu_SetText(v, ES.Settings[variableName])
						v:SetText(ES.Settings[variableName])
					end
					--Sliders
					if string.find(controlName, "SLIDER") then
						local variableName = string.sub(controlName, 7, #controlName)
						v:SetValue(ES.Settings[variableName])
					end
					--Checkboxes
					if string.find(controlName, "CHECKBOX") then
						local variableName = string.sub(controlName, 9, #controlName)
						v:SetChecked(ES.Settings[variableName])
					end
					--Textboxes
					if string.find(controlName, "TEXTBOX") then
						local variableName = string.sub(controlName, 8, #controlName)
						v:SetText(ES.Settings[variableName])
					end
				end
			end
		end
	end
end

function ES.CreateDropdownControl(name, parent, positionX, positionY, width, height, default, optionsTable)
	local optionHeight = 15;
	
	local f = CreateFrame("Button", "DROPDOWN"..name, parent, "UIPanelButtonTemplate")
	f:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\dropdown")
	f:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
	f:SetNormalFontObject(_G["epicFontNormal"])
	f:SetHighlightFontObject(_G["epicFontNormalAccent"])
	f:SetSize(width, height)
	f:SetPoint("CENTER", parent, "TOPLEFT", positionX, positionY)
	f:SetText(default)

	f.options = optionsTable
	f.optionControls = {}
	
	--Create Buttons For Options
	for i=1,#f.options do
		f.optionControls[i] = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		f.optionControls[i]:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\Editbox")
		f.optionControls[i]:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
		f.optionControls[i]:SetNormalFontObject(_G["epicFontNormal"])
		f.optionControls[i]:SetHighlightFontObject(_G["epicFontNormalAccent"])
		f.optionControls[i]:SetText(f.options[i])
		f.optionControls[i]:SetSize(width, optionHeight)
		f.optionControls[i]:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, -optionHeight*(i-1))
		
		f.optionControls[i]:SetScript("OnClick", function(self, button, down)
			f:SetText(f.options[i])
			ES.Settings[name] = f.options[i]
			for k, v in pairs(f.optionControls) do
				v:Hide()
			end
		end)

		f.optionControls[i]:Hide()
	end
	
	f:SetScript("OnClick", function(self, button, down)
		for k, v in pairs(f.optionControls) do
			if v:IsVisible() then
				v:Hide()
			else
				v:Show()
			end
		end
		ES.MinimizeDropdowns(f:GetName())
	end)
	
	return f;
end

-- Dropdown
function ES.AddDropdown(tab, minitab, line, variable, label, default, ...)
	local arg = {...}

	ES.DefaultSettings[variable] = default

	local currentValue = EpicSettingsDB[ES.SpecID].Profiles[EpicSettingsDB[ES.SpecID].SelectedProfile][variable] or default

	if not ES.Tabs[tab].MiniTabs[minitab].Lines[line] then
		ES.Tabs[tab].MiniTabs[minitab].Lines[line] = {}
		ES.Tabs[tab].MiniTabs[minitab].Lines[line].Controls = {}
		ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset = 0
	end

	local frame=CreateFrame("Frame","DropdownLabel"..variable,ES.Tabs[tab].MiniTabs[minitab].Body);
	frame:SetPoint("BOTTOM", ES.Tabs[tab].MiniTabs[minitab].Body, "TOPLEFT", 80 + ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset, -ES.SettingControlHeight - ES.SpacingBetweenLines*line)
	frame:SetSize(100,ES.SettingControlHeight);
 
	local text=frame:CreateFontString(nil,"OVERLAY","GameFontNormal");
	text:SetPoint("CENTER");
	text:SetText(label);
	text:SetFontObject(_G["epicFontNormal"])

	--local dropDown = CreateFrame("Frame", "DROPDOWN"..variable, ES.Tabs[tab].Body, "UIDropDownMenuTemplate")

	local dropDown = ES.CreateDropdownControl(variable, ES.Tabs[tab].MiniTabs[minitab].Body, 80 + ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset, -ES.SettingControlHeight - ES.SpacingBetweenLines*line, 130, 20, currentValue, arg)

	--local texture = dropDown:CreateTexture()
	--texture:SetAllPoints()
	--texture:SetPoint("TOPLEFT", dropDown ,"TOPLEFT", 14, -3)
	--texture:SetPoint("BOTTOMRIGHT", dropDown ,"BOTTOMRIGHT", -14, 7)
	--texture:SetTexture("Interface\\Addons\\EpicSettings\\Vectors\\dropdown2")
	--dropDown.texture = texture

	--dropDown:SetBackdrop({
	--	bgFile = "Interface\\Addons\\EpicSettings\\Vectors\\dropdown",
	--	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
	--	edgeSize = 16,
	--	insets = { left = 4, right = 4, top = 4, bottom = 4 },
	--})
	--/run print(_G[_G["DROPDOWNSomeDropdown"]:GetChildren():GetName()]:GetNumRegions()) 4
	--/run print(select(2, _G["DROPDOWNSomeDropdown"]:GetRegions()):GetFrameType()) 5

	--/run print(_G["DROPDOWNSomeDropdownBackdrop"]) 5

	--/run print(select(1, _G[_G["DROPDOWNSomeDropdown"]:GetChildren():GetName()]:GetRegions()):GetName()) 4

	--_G[dropDown:GetName() .. 'Button']:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\dropdownbutton")
	--for i,v in ipairs(_G[dropDown:GetName()]) do 
	--	print(i)
	--end

	--dropDown:SetPoint("LEFT", ES.Tabs[tab].Body, "TOPLEFT", -10 + ES.Tabs[tab].Lines[line].NextOffset, -ES.SettingControlHeight -2 - ES.SpacingBetweenLines*line)
	--dropDown:SetNormalFontObject(_G["epicFontNormal"])
	--_G[dropDown:GetName() .. 'Text']:SetFontObject(_G["epicFontNormalAccent"])
	--UIDropDownMenu_SetWidth(dropDown, 130)
	--UIDropDownMenu_SetButtonWidth(dropDown, 130)
	--UIDropDownMenu_SetAnchor(dropDown, 25, 20, "TOPLEFT", dropDown, "BOTTOMLEFT")
	--UIDropDownMenu_Initialize(dropDown, function(self, level, menuList)
	--local info = UIDropDownMenu_CreateInfo()
	--info.fontObject = _G["epicFontNormalAccent"]
	--for i=1,#arg do
	--	info.text, info.arg1 = arg[i], i

		--local f = CreateFrame("Frame", nil, ES.Tabs[tab].Body, "UIDropDownCustomMenuEntryTemplate")
		--f:SetWidth(130)
		--f:SetHeight(20)

	--	info.customFrame = f;
	--	info.func = function(self, arg1, arg2, checked)
	--		UIDropDownMenu_SetText(dropDown, arg[i])
	--		ES.Settings[variable] = arg[i]
	--		CloseDropDownMenus()
	--	end
	--	UIDropDownMenu_AddButton(info)
	--	end
	--end)
	--UIDropDownMenu_SetText(dropDown, currentValue)

	--Init value
	ES.Settings[variable] = currentValue

	ES.Tabs[tab].MiniTabs[minitab].Lines[line].Controls[#ES.Tabs[tab].MiniTabs[minitab].Lines[line].Controls + 1] = dropDown

	ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset = ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset + ES.ControlsSpacingX--7*#label + 125

	return dropDown;
end

-- Group Dropdown
function ES.AddGroupDropdown(tab, minitab, line, variable, label, includeHealers, includeDamagers, includeTanks, includePlayer)
	local dropdown = ES.AddDropdown(tab, minitab, line, variable, label, "party1", "party1", "party2", "party3", "party4")

	do
		--Get Current party
		local PartyUnits = {}
		if includePlayer then
			table.insert(PartyUnits, "player");
		end
		for i = 1, 4 do
			local PartyUnitKey = string.format("party%d", i);
			if UnitExists(PartyUnitKey) then
				if (UnitGroupRolesAssigned(PartyUnitKey) == "HEALER" and includeHealers) or (UnitGroupRolesAssigned(PartyUnitKey) == "DAMAGER" and includeDamagers) or (UnitGroupRolesAssigned(PartyUnitKey) == "TANK" and includeTanks) then
					table.insert(PartyUnits, PartyUnitKey);
				end
			end
		end

		for i = 1, 40 do
			local RaidUnitKey = string.format("raid%d", i);
			if UnitExists(RaidUnitKey) then
				if (UnitGroupRolesAssigned(RaidUnitKey) == "HEALER" and includeHealers) or (UnitGroupRolesAssigned(RaidUnitKey) == "DAMAGER" and includeDamagers) or (UnitGroupRolesAssigned(RaidUnitKey) == "TANK" and includeTanks) then
					table.insert(PartyUnits, RaidUnitKey);
				end
			end
		end

		--Delete old Option buttons
		for i=1,#dropdown.optionControls do
			dropdown.optionControls[i] = nil
			table.remove(dropdown.optionControls, i)
			dropdown.options[i] = nil
			table.remove(dropdown.options, i)
		end

		--Create a Default "None" button
		dropdown.optionControls[1] = CreateFrame("Button", nil, dropdown, "UIPanelButtonTemplate")
		dropdown.optionControls[1]:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\Editbox")
		dropdown.optionControls[1]:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
		dropdown.optionControls[1]:SetNormalFontObject(_G["epicFontNormal"])
		dropdown.optionControls[1]:SetHighlightFontObject(_G["epicFontNormalAccent"])
		dropdown.optionControls[1]:SetText("None")
		dropdown.optionControls[1]:SetSize(130, 15)
		dropdown.optionControls[1]:SetPoint("TOPLEFT", dropdown, "BOTTOMLEFT", 0, 0)
		
		dropdown.optionControls[1]:SetScript("OnClick", function(self, button, down)
			dropdown:SetText("None")
			ES.Settings[variable] = "None"
			for k, v in pairs(dropdown.optionControls) do
				v:Hide()
			end
		end)

		dropdown.optionControls[1]:Hide()

		--Create new Option buttons
		for i=2,(#PartyUnits+1) do
			dropdown.optionControls[i] = CreateFrame("Button", nil, dropdown, "UIPanelButtonTemplate")
			dropdown.optionControls[i]:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\Editbox")
			dropdown.optionControls[i]:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
			dropdown.optionControls[i]:SetNormalFontObject(_G["epicFontNormal"])
			dropdown.optionControls[i]:SetHighlightFontObject(_G["epicFontNormalAccent"])
			dropdown.optionControls[i]:SetText(UnitName(PartyUnits[i-1]))
			dropdown.optionControls[i]:SetSize(130, 15)
			dropdown.optionControls[i]:SetPoint("TOPLEFT", dropdown, "BOTTOMLEFT", 0, -15*(i-1))
			
			dropdown.optionControls[i]:SetScript("OnClick", function(self, button, down)
				dropdown:SetText(UnitName(PartyUnits[i-1]))
				ES.Settings[variable] = UnitName(PartyUnits[i-1])
				for k, v in pairs(dropdown.optionControls) do
					v:Hide()
				end
			end)

			dropdown.optionControls[i]:Hide()
		end
	end

	dropdown:RegisterEvent("GROUP_ROSTER_UPDATE");
	local function eventHandler(self, event, ...)
		if event == "GROUP_ROSTER_UPDATE" then
			local selectedUnitStillExits = false
			--Get Current party
			local PartyUnits = {}
			if includePlayer then
				if ES.Settings[variable] == UnitName("player") then
					selectedUnitStillExits = true
				end
				table.insert(PartyUnits, "player");
			end
			for i = 1, 4 do
				local PartyUnitKey = string.format("party%d", i);
				if UnitExists(PartyUnitKey) then
					if (UnitGroupRolesAssigned(PartyUnitKey) == "HEALER" and includeHealers) or (UnitGroupRolesAssigned(PartyUnitKey) == "DAMAGER" and includeDamagers) or (UnitGroupRolesAssigned(PartyUnitKey) == "TANK" and includeTanks) then
						if ES.Settings[variable] == UnitName(PartyUnitKey) then
							selectedUnitStillExits = true
						end
						table.insert(PartyUnits, PartyUnitKey);
					end
				end
			end

			for i = 1, 40 do
				local RaidUnitKey = string.format("raid%d", i);
				if UnitExists(RaidUnitKey) then
					if (UnitGroupRolesAssigned(RaidUnitKey) == "HEALER" and includeHealers) or (UnitGroupRolesAssigned(RaidUnitKey) == "DAMAGER" and includeDamagers) or (UnitGroupRolesAssigned(RaidUnitKey) == "TANK" and includeTanks) then
						if ES.Settings[variable] == UnitName(RaidUnitKey) then
							selectedUnitStillExits = true
						end
						table.insert(PartyUnits, RaidUnitKey);
					end
				end
			end

			--Delete old Option buttons
			for i=1,#dropdown.optionControls do
				dropdown.optionControls[i] = nil
				table.remove(dropdown.optionControls, i)
				dropdown.options[i] = nil
				table.remove(dropdown.options, i)
			end

			--Create a Default "None" button
			dropdown.optionControls[1] = CreateFrame("Button", nil, dropdown, "UIPanelButtonTemplate")
			dropdown.optionControls[1]:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\Editbox")
			dropdown.optionControls[1]:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
			dropdown.optionControls[1]:SetNormalFontObject(_G["epicFontNormal"])
			dropdown.optionControls[1]:SetHighlightFontObject(_G["epicFontNormalAccent"])
			dropdown.optionControls[1]:SetText("None")
			dropdown.optionControls[1]:SetSize(130, 15)
			dropdown.optionControls[1]:SetPoint("TOPLEFT", dropdown, "BOTTOMLEFT", 0, 0)
			
			dropdown.optionControls[1]:SetScript("OnClick", function(self, button, down)
				dropdown:SetText("None")
				ES.Settings[variable] = "None"
				for k, v in pairs(dropdown.optionControls) do
					v:Hide()
				end
			end)

			dropdown.optionControls[1]:Hide()

			--Create new Option buttons
			for i=2,#PartyUnits+1 do
				dropdown.optionControls[i] = CreateFrame("Button", nil, dropdown, "UIPanelButtonTemplate")
				dropdown.optionControls[i]:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\Editbox")
				dropdown.optionControls[i]:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
				dropdown.optionControls[i]:SetNormalFontObject(_G["epicFontNormal"])
				dropdown.optionControls[i]:SetHighlightFontObject(_G["epicFontNormalAccent"])
				dropdown.optionControls[i]:SetText(UnitName(PartyUnits[i-1]))
				dropdown.optionControls[i]:SetSize(130, 15)
				dropdown.optionControls[i]:SetPoint("TOPLEFT", dropdown, "BOTTOMLEFT", 0, -15*(i-1))
				
				dropdown.optionControls[i]:SetScript("OnClick", function(self, button, down)
					dropdown:SetText(UnitName(PartyUnits[i-1]))
					ES.Settings[variable] = UnitName(PartyUnits[i-1])
					for k, v in pairs(dropdown.optionControls) do
						v:Hide()
					end
				end)

				dropdown.optionControls[i]:Hide()
			end
			
			--Set selected option to None if the unit left the party
			if not selectedUnitStillExits then
				dropdown:SetText("None")
			end
		end
	end
	dropdown:SetScript("OnEvent", eventHandler);

end

-- Label
function ES.AddLabel(tab, minitab, line, label)
	if not ES.Tabs[tab].MiniTabs[minitab].Lines[line] then
		ES.Tabs[tab].MiniTabs[minitab].Lines[line] = {}
		ES.Tabs[tab].MiniTabs[minitab].Lines[line].Controls = {}
		ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset = 0
	end

	local frame=CreateFrame("Frame","TextboxLabel"..label,ES.Tabs[tab].MiniTabs[minitab].Body);
	frame:SetPoint("LEFT", ES.Tabs[tab].MiniTabs[minitab].Body, "TOPLEFT", 10 + ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset,  -30 - ES.SpacingBetweenLines*line)
	frame:SetSize(7*#label,ES.SettingControlHeight);
 
	local text=frame:CreateFontString(nil,"OVERLAY","GameFontNormal");
	text:SetPoint("LEFT");
	text:SetText(label);
	text:SetFontObject(_G["epicFontButtonNormal"])

	ES.Tabs[tab].MiniTabs[minitab].Lines[line].Controls[#ES.Tabs[tab].MiniTabs[minitab].Lines[line].Controls + 1] = frame

	ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset = ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset + ES.ControlsSpacingX--7*#label +64

	--EditBox:HookScript("OnClick", function(self, button, down)
	--	ES.MinimizeDropdowns(nil)
	--end)
end

-- Textbox
function ES.AddTextbox(tab, minitab, line, variable, label, default)

	ES.DefaultSettings[variable] = default

	local currentValue = EpicSettingsDB[ES.SpecID].Profiles[EpicSettingsDB[ES.SpecID].SelectedProfile][variable] or default

	if not ES.Tabs[tab].MiniTabs[minitab].Lines[line] then
		ES.Tabs[tab].MiniTabs[minitab].Lines[line] = {}
		ES.Tabs[tab].MiniTabs[minitab].Lines[line].Controls = {}
		ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset = 0
	end

	local frame=CreateFrame("Frame","TextboxLabel"..variable,ES.Tabs[tab].MiniTabs[minitab].Body);
	frame:SetPoint("BOTTOM", ES.Tabs[tab].MiniTabs[minitab].Body, "TOPLEFT", ES.TextboxSizeX/2 +15 + ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset,  -ES.TextboxSizeY -10 - ES.SpacingBetweenLines*line)
	frame:SetSize(7*#label,ES.SettingControlHeight);
 
	local text=frame:CreateFontString(nil,"OVERLAY","GameFontNormal");
	text:SetPoint("LEFT");
	text:SetText(label);
	text:SetFontObject(_G["epicFontNormal"])

	local EditBox = CreateFrame("EditBox", "TEXTBOX"..variable, ES.Tabs[tab].MiniTabs[minitab].Body, "InputBoxTemplate")
	EditBox:SetPoint("CENTER", ES.Tabs[tab].MiniTabs[minitab].Body, "TOPLEFT", ES.TextboxSizeX/2 + 15 + ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset,  -ES.TextboxSizeY -10 - ES.SpacingBetweenLines*line)
	EditBox:SetSize(ES.TextboxSizeX, ES.TextboxSizeY)
	EditBox:SetAutoFocus(false)
	EditBox:SetText(currentValue)
	EditBox:SetFontObject(_G["epicFontNormalAccentAlt"])

	local texture = EditBox:CreateTexture()
	texture:SetAllPoints()
	texture:SetPoint("TOPLEFT", EditBox ,"TOPLEFT", -4, 0)
	texture:SetPoint("BOTTOMRIGHT", EditBox ,"BOTTOMRIGHT", 0, 0)
	texture:SetTexture("Interface\\Addons\\EpicSettings\\Vectors\\Editbox")
	EditBox.texture = texture

	--Init value
	ES.Settings[variable] = currentValue

	ES.Tabs[tab].MiniTabs[minitab].Lines[line].Controls[#ES.Tabs[tab].MiniTabs[minitab].Lines[line].Controls + 1] = EditBox

	ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset = ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset + ES.ControlsSpacingX--7*#label +64

	--EditBox:HookScript("OnClick", function(self, button, down)
	--	ES.MinimizeDropdowns(nil)
	--end)
	EditBox:SetScript("OnTextChanged", function(self, value)
		ES.Settings[variable] = EditBox:GetText()
		ES.MinimizeDropdowns(nil)
	end)
end

-- Checkbox
function ES.AddCheckbox(tab, minitab, line, variable, label, default)

	ES.DefaultSettings[variable] = default

	local currentValue = default
	if EpicSettingsDB[ES.SpecID].Profiles[EpicSettingsDB[ES.SpecID].SelectedProfile][variable] ~= nil then
		currentValue = EpicSettingsDB[ES.SpecID].Profiles[EpicSettingsDB[ES.SpecID].SelectedProfile][variable]
	end

	if not ES.Tabs[tab].MiniTabs[minitab].Lines[line] then
		ES.Tabs[tab].MiniTabs[minitab].Lines[line] = {}
		ES.Tabs[tab].MiniTabs[minitab].Lines[line].Controls = {}
		ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset = 0
	end

	local frame=CreateFrame("Frame","CheckboxLabel"..variable,ES.Tabs[tab].MiniTabs[minitab].Body);
	frame:SetPoint("BOTTOM", ES.Tabs[tab].MiniTabs[minitab].Body, "TOPLEFT", 80 + ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset, -ES.CheckboxSize -10 - ES.SpacingBetweenLines*line)
	frame:SetSize(7*#label,ES.SettingControlHeight);
 
	local text=frame:CreateFontString(nil,"OVERLAY","GameFontNormal");
	text:SetPoint("CENTER");
	text:SetText(label);
	text:SetFontObject(_G["epicFontNormal"])

	local MyCheckbox = CreateFrame("CheckButton", "CHECKBOX"..variable, ES.Tabs[tab].MiniTabs[minitab].Body, "ChatConfigCheckButtonTemplate");
	MyCheckbox:SetSize(ES.CheckboxSize,ES.CheckboxSize);
	MyCheckbox:SetHitRectInsets(0,0,0,0)
	MyCheckbox:SetPoint("TOP", ES.Tabs[tab].MiniTabs[minitab].Body, "TOPLEFT", 80 + ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset, -ES.CheckboxSize - ES.SpacingBetweenLines*line)
	MyCheckbox:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\Unchecked")
	MyCheckbox:SetPushedTexture("Interface\\Addons\\EpicSettings\\Vectors\\Checked")
	MyCheckbox:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")

	--Init value
	MyCheckbox:SetChecked(currentValue)

	ES.Settings[variable] = currentValue

	ES.Tabs[tab].MiniTabs[minitab].Lines[line].Controls[#ES.Tabs[tab].MiniTabs[minitab].Lines[line].Controls + 1] = MyCheckbox

	ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset = ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset + ES.ControlsSpacingX--7*#label +64

	MyCheckbox:SetScript("OnClick", function(self, button, down)
		ES.Settings[variable] = self:GetChecked()
		ES.MinimizeDropdowns(nil)
	end)
end

-- Slider
function ES.AddSlider(tab, minitab, line, variable, label, min, max, default)

	ES.DefaultSettings[variable] = default

	local currentValue = EpicSettingsDB[ES.SpecID].Profiles[EpicSettingsDB[ES.SpecID].SelectedProfile][variable] or default

	if not ES.Tabs[tab].MiniTabs[minitab].Lines[line] then
		ES.Tabs[tab].MiniTabs[minitab].Lines[line] = {}
		ES.Tabs[tab].MiniTabs[minitab].Lines[line].Controls = {}
		ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset = 0
	end

	--local frame=CreateFrame("Frame","SliderLabel"..variable,ES.Tabs[tab].Body);
	--frame:SetPoint("TOPLEFT", ES.Tabs[tab].Body, "TOPLEFT", 10 + ES.Tabs[tab].Lines[line].NextOffset, -10 - ES.SpacingBetweenLines*line)
	--frame:SetSize(7*#label,ES.SettingControlHeight);
 
	--local text=frame:CreateFontString(nil,"OVERLAY","GameFontNormal");
	--text:SetPoint("TOPLEFT");
	--text:SetText(label);

	local MySlider = CreateFrame("Slider", "SLIDER"..variable, ES.Tabs[tab].MiniTabs[minitab].Body, "OptionsSliderTemplate")
	MySlider:SetWidth(ES.SliderWidth)
	MySlider:SetHeight(ES.SliderHeight)
	MySlider:SetPoint("LEFT", ES.Tabs[tab].MiniTabs[minitab].Body, "TOPLEFT", 10 + ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset, -ES.SettingControlHeight - ES.SpacingBetweenLines*line)
	MySlider:SetOrientation('HORIZONTAL')
	MySlider:SetMinMaxValues(min, max)
	MySlider:SetValue(currentValue)
	--MySlider:SetValueStep(1)
	--MySlider:SetStepsPerPage(1)
	MySlider:Show()

	MySlider:SetThumbTexture("Interface\\Addons\\EpicSettings\\Vectors\\sliderThumb");

	local textureThumb = MySlider:GetThumbTexture()
	textureThumb:SetWidth(15)
	textureThumb:SetHeight(15)
	textureThumb:SetPoint("BOTTOM", 0, 1)


	local texture = MySlider:CreateTexture()
	texture:SetAllPoints()
	texture:SetPoint("TOPLEFT", MySlider ,"TOPLEFT", -2, 0)
	texture:SetPoint("BOTTOMRIGHT", MySlider ,"BOTTOMRIGHT", 0, -14)
	texture:SetTexture("Interface\\Addons\\EpicSettings\\Vectors\\slider")
	MySlider.texture = texture
	
	--MySlider.tooltipText = 'This is the Tooltip hint'
	_G[MySlider:GetName() .. 'Low']:SetText(min)        -- Sets the left-side slider text (default is "Low").
	_G[MySlider:GetName() .. 'Low']:SetFontObject(_G["epicFontNormal"])
	_G[MySlider:GetName() .. 'High']:SetText(max)     -- Sets the right-side slider text (default is "High").
	_G[MySlider:GetName() .. 'High']:SetFontObject(_G["epicFontNormal"])
	_G[MySlider:GetName() .. 'Text']:SetText(label)       -- Sets the "title" text (top-centre of slider).
	_G[MySlider:GetName() .. 'Text']:SetFontObject(_G["epicFontNormal"])

	local frameValue =CreateFrame("Frame","SliderLabel"..variable,ES.Tabs[tab].MiniTabs[minitab].Body);
	frameValue:SetPoint("TOP", ES.Tabs[tab].MiniTabs[minitab].Body, "TOPLEFT", 10 + ES.SliderWidth/2 + ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset, -ES.SettingControlHeight - ES.SpacingBetweenLines*line)
	frameValue:SetSize(30 ,ES.SettingControlHeight);
 
	local textValue=frameValue:CreateFontString(nil,"OVERLAY","GameFontNormal");
	textValue:SetPoint("CENTER");
	textValue:SetText(currentValue);
	textValue:SetFontObject(_G["epicFontNormalAccent"])

	--Init value
	ES.Settings[variable] = currentValue

	ES.Tabs[tab].MiniTabs[minitab].Lines[line].Controls[#ES.Tabs[tab].MiniTabs[minitab].Lines[line].Controls + 1] = MySlider

	ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset = ES.Tabs[tab].MiniTabs[minitab].Lines[line].NextOffset + ES.ControlsSpacingX--+ 147 + ES.SliderWidth

	MySlider:SetScript("OnValueChanged", function(self, value)
		textValue:SetText(math.floor(value))
		ES.Settings[variable] = math.floor(value)
		ES.MinimizeDropdowns(nil)
	end)
end

-- Labels for Commands
function ES.AddLabelForCommands(minitab, line, label)
	if not ES.SettingsFrameTabCommands.MiniTabs[minitab].Lines[line] then
		ES.SettingsFrameTabCommands.MiniTabs[minitab].Lines[line] = {}
		ES.SettingsFrameTabCommands.MiniTabs[minitab].Lines[line].Controls = {}
		ES.SettingsFrameTabCommands.MiniTabs[minitab].Lines[line].NextOffset = 0
	end

	local frame=CreateFrame("Frame","TextboxLabel"..label,ES.SettingsFrameTabCommands.MiniTabs[minitab].Body);
	frame:SetPoint("LEFT", ES.SettingsFrameTabCommands.MiniTabs[minitab].Body, "TOPLEFT", 10 + ES.SettingsFrameTabCommands.MiniTabs[minitab].Lines[line].NextOffset,  -30 - 14*line)
	frame:SetSize(7*#label,ES.SettingControlHeight);
 
	local text=frame:CreateFontString(nil,"OVERLAY","GameFontNormal");
	text:SetPoint("LEFT");
	text:SetText(label);
	text:SetFontObject(_G["epicFontAlternativeNormal"])

	ES.SettingsFrameTabCommands.MiniTabs[minitab].Lines[line].Controls[#ES.SettingsFrameTabCommands.MiniTabs[minitab].Lines[line].Controls + 1] = frame

	ES.SettingsFrameTabCommands.MiniTabs[minitab].Lines[line].NextOffset = ES.SettingsFrameTabCommands.MiniTabs[minitab].Lines[line].NextOffset + 250--7*#label +64

	--EditBox:HookScript("OnClick", function(self, button, down)
	--	ES.MinimizeDropdowns(nil)
	--end)
end

function ES.AddCommandInfo(minitab, label)
	ES.SettingsFrameTabCommands.MiniTabs[minitab].NumberOfCommands = ES.SettingsFrameTabCommands.MiniTabs[minitab].NumberOfCommands + 1
	--ES.AddLabelForCommands(minitab, 3 + math.floor((ES.SettingsFrameTabCommands.MiniTabs[minitab].NumberOfCommands-1) / 3), label)
	ES.AddLabelForCommands(minitab, 3 + math.floor((ES.SettingsFrameTabCommands.MiniTabs[minitab].NumberOfCommands-1) % 38), label)
end

function ES.InitToggle(label, variable, default, explanation)
	local numberOfRegisteredToggles = 0

	ES.Toggles[string.lower(variable)] = default
	
	for k,v in pairs(ES.Toggles) do
		numberOfRegisteredToggles = numberOfRegisteredToggles+1;
	end

	if numberOfRegisteredToggles <= 15 then
		ES.Buttons[string.lower(variable)] = CreateFrame("Button", nil, FrameToggles, "UIPanelButtonTemplate")

		ES.Buttons[string.lower(variable)]:SetPoint("TOPLEFT", FrameToggles, "TOPLEFT", 3, -28 - 25*(numberOfRegisteredToggles-2))
		ES.Buttons[string.lower(variable)]:SetSize(83, 25)
		ES.Buttons[string.lower(variable)]:SetText(label);
		ES.Buttons[string.lower(variable)]:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted") -- BigButtonS
		ES.Buttons[string.lower(variable)]:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
		ES.Buttons[string.lower(variable)]:SetNormalFontObject(_G["epicFontButtonNormal"])
		ES.Buttons[string.lower(variable)]:SetHighlightFontObject(_G["epicFontButtonSelected"])
		if ES.Toggles[string.lower(variable)] then
			ES.Buttons[string.lower(variable)]:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButton") -- 2ndtry
			ES.Buttons[string.lower(variable)]:SetNormalFontObject(_G["epicFontButtonSelected"])
		else
			ES.Buttons[string.lower(variable)]:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted") -- BigButtonS
			ES.Buttons[string.lower(variable)]:SetNormalFontObject(_G["epicFontButtonNormal"])
		end
		ES.Buttons[string.lower(variable)]:SetScript("OnClick", function(self, button, down)
			if ES.Toggles[string.lower(variable)] then
				ES.Toggles[string.lower(variable)] = false 
				--self:SetText(label.." Off");
				ES.Buttons[string.lower(variable)]:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted") -- BigButtonS
				ES.Buttons[string.lower(variable)]:SetNormalFontObject(_G["epicFontButtonNormal"])
			else
				ES.Toggles[string.lower(variable)] = true
				--self:SetText(label.." On");
				ES.Buttons[string.lower(variable)]:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButton")  -- 2ndtry
				ES.Buttons[string.lower(variable)]:SetNormalFontObject(_G["epicFontButtonSelected"])
			end
		end)
		ES.Buttons[string.lower(variable)]:HookScript("OnMouseDown", function(self, button)
			FrameToggles:StartMoving()
		end)
		ES.Buttons[string.lower(variable)]:HookScript("OnMouseUp", function(self, button)
			FrameToggles:StopMovingOrSizing()
		end)
	end

	ES.AddLabelForCommands(1, 2+numberOfRegisteredToggles, explanation)
	ES.AddLabelForCommands(1, 2+numberOfRegisteredToggles, "/epic "..variable)

	--Resize FrameToggles
	FrameToggles:SetHeight((numberOfRegisteredToggles+1)*25);
end

function ES.InitButtonMain(label, addonName)
	ES.Toggles["toggle"] = true
	ES.Toggles["cycle"] = false

	if not ES.MainButton.Initialized then
		-- ES.MainButton.Initialized = true
		-- ES.MainButton.Name = label;
		-- ES.MainButton.Toggled = true
		-- ToggleButtonTop:SetText(label);
		-- ToggleButtonTop:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButton") -- 2ndtry
		-- ToggleButtonTop:SetNormalFontObject(_G["epicFontButtonSelected"])
		-- ToggleButtonTop:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
		-- ToggleButtonTop:SetHighlightFontObject(_G["epicFontButtonSelected"])
		-- ToggleButtonTop:Show();
		-- --ToggleButtonTop:SetAttribute("type1", "macro") -- left click causes macro
		-- --ToggleButtonTop:SetAttribute("macrotext1", "/"..addonName.." toggle")
		-- ToggleButtonTop:RegisterForClicks("RightButtonDown", "LeftButtonDown")
		-- ToggleButtonTop:HookScript("OnClick", ToggleButtonTop_OnClick)
		-- ToggleButtonTop:HookScript("OnMouseDown", function(self, button)
		-- 	FrameToggles:StartMoving()
		-- end)
		-- ToggleButtonTop:HookScript("OnMouseUp", function(self, button)
		-- 	FrameToggles:StopMovingOrSizing()
		-- end)

		--Hardcoded Toggle button
		ES.Buttons["toggle"] = CreateFrame("Button", nil, FrameToggles, "UIPanelButtonTemplate")

		ES.Buttons["toggle"]:SetPoint("TOPLEFT", FrameToggles, "TOPLEFT", 3, -3)
		ES.Buttons["toggle"]:SetSize(83, 25)
		ES.Buttons["toggle"]:SetText("Toggle");
		ES.Buttons["toggle"]:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted") -- BigButtonS
		ES.Buttons["toggle"]:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
		ES.Buttons["toggle"]:SetNormalFontObject(_G["epicFontButtonNormal"])
		ES.Buttons["toggle"]:SetHighlightFontObject(_G["epicFontButtonSelected"])
		if ES.Toggles["toggle"] then
			ES.Buttons["toggle"]:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButton") -- 2ndtry
			ES.Buttons["toggle"]:SetNormalFontObject(_G["epicFontButtonSelected"])
		else
			ES.Buttons["toggle"]:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted") -- BigButtonS
			ES.Buttons["toggle"]:SetNormalFontObject(_G["epicFontButtonNormal"])
		end
		ES.Buttons["toggle"]:SetScript("OnClick", function(self, button, down)
			if ES.Toggles["toggle"] then
				ES.Toggles["toggle"] = false 
				--self:SetText(label.." Off");
				ES.Buttons["toggle"]:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted") -- BigButtonS
				ES.Buttons["toggle"]:SetNormalFontObject(_G["epicFontButtonNormal"])
			else
				ES.Toggles["toggle"] = true
				--self:SetText(label.." On");
				ES.Buttons["toggle"]:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButton")  -- 2ndtry
				ES.Buttons["toggle"]:SetNormalFontObject(_G["epicFontButtonSelected"])
			end
		end)
		ES.Buttons["toggle"]:HookScript("OnMouseDown", function(self, button)
			FrameToggles:StartMoving()
		end)
		ES.Buttons["toggle"]:HookScript("OnMouseUp", function(self, button)
			FrameToggles:StopMovingOrSizing()
		end)

		--Hardcoded Cycle toggle button
		ES.Buttons["cycle"] = CreateFrame("Button", nil, FrameToggles, "UIPanelButtonTemplate")

		ES.Buttons["cycle"]:SetPoint("TOPLEFT", FrameToggles, "TOPLEFT", 3, -28)
		ES.Buttons["cycle"]:SetSize(83, 25)
		ES.Buttons["cycle"]:SetText("Cycle");
		ES.Buttons["cycle"]:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted") -- BigButtonS
		ES.Buttons["cycle"]:SetHighlightTexture("Interface\\Addons\\EpicSettings\\Vectors\\White", "MOD")
		ES.Buttons["cycle"]:SetNormalFontObject(_G["epicFontButtonNormal"])
		ES.Buttons["cycle"]:SetHighlightFontObject(_G["epicFontButtonSelected"])
		if ES.Toggles["cycle"] then
			ES.Buttons["cycle"]:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButton") -- 2ndtry
			ES.Buttons["cycle"]:SetNormalFontObject(_G["epicFontButtonSelected"])
		else
			ES.Buttons["cycle"]:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted") -- BigButtonS
			ES.Buttons["cycle"]:SetNormalFontObject(_G["epicFontButtonNormal"])
		end
		ES.Buttons["cycle"]:SetScript("OnClick", function(self, button, down)
			if ES.Toggles["cycle"] then
				ES.Toggles["cycle"] = false 
				--self:SetText(label.." Off");
				ES.Buttons["cycle"]:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted") -- BigButtonS
				ES.Buttons["cycle"]:SetNormalFontObject(_G["epicFontButtonNormal"])
			else
				ES.Toggles["cycle"] = true
				--self:SetText(label.." On");
				ES.Buttons["cycle"]:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButton")  -- 2ndtry
				ES.Buttons["cycle"]:SetNormalFontObject(_G["epicFontButtonSelected"])
			end
		end)
		ES.Buttons["cycle"]:HookScript("OnMouseDown", function(self, button)
			FrameToggles:StartMoving()
		end)
		ES.Buttons["cycle"]:HookScript("OnMouseUp", function(self, button)
			FrameToggles:StopMovingOrSizing()
		end)
	end
end

function ES.SetupVersion(version)
	ES.SettingsFrameTabProfiles.VersionText:SetText(version);
end

function SettingsButton_OnClick()
	--if not UnitAffectingCombat("player") then
		if not SettingsFrame:IsVisible() then
			SettingsFrame:Show();
		else
			SettingsFrame:Hide();
		end
	--end
end

function HideButton_OnClick()
	if not UnitAffectingCombat("player") then
		if not FrameToggles:IsVisible() then
			FrameToggles:Show();
		else
			FrameToggles:Hide();
		end
	end
end

function ToggleButtonTop_OnClick(self, args)
	if ES.MainButton.Toggled then
		ES.MainButton.Toggled = false
		--self:SetText(ES.MainButton.Name.." Off");
		self:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButtonNotHighlighted")
		self:SetNormalFontObject(_G["epicFontButtonNormal"])
		ES.Toggles["main"] = false
	else
		ES.MainButton.Toggled = true
		--self:SetText(ES.MainButton.Name.." On");
		self:SetNormalTexture("Interface\\Addons\\EpicSettings\\Vectors\\BigButton") -- 2ndtry
		self:SetNormalFontObject(_G["epicFontButtonSelected"])
		ES.Toggles["main"] = true
	end
end

function ScrollFrame1_OnVerticalScroll()

end

function MiniButtons_OnDragStart(self, args)
	if self:IsMovable() then
		self:StartMoving()
	end
end

function MiniButtons_OnDragStop(self, args)
	if self:IsMovable() then
		self:StopMovingOrSizing()
	end
end


function LoadSaveButton_OnClick()
	--if not ES.SettingsFrameTabProfiles.Body:IsVisible() then
	--	ES.SettingsFrameTabProfiles.Body:Show();
	--else
	--	ES.SettingsFrameTabProfiles.Body:Hide();
	--end
	--for i,v in ipairs(ES.Tabs) do 
	--	v.Body:Hide();
	--end
	ES.ToggleTab(0, 0)
end

function CommandsButton_OnClick()
	ES.ToggleTab(99, 1)
end

function HideButton_OnDragStart()
	
end
