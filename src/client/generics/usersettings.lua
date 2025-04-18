--!strict


-- Services
local _PLAYERS = game:GetService("Players")
local _STARTERGUI = game:GetService("StarterGui")
local _USERINPUTSERVICE = game:GetService("UserInputService")
local _VRSERVICE = game:GetService("VRService")
local _LOCALIZATIONSERVICE = game:GetService("LocalizationService")


-- Services


-- Libraries


-- Upvalues


-- Constants
local LOCALPLAYER = _PLAYERS.LocalPlayer
local GAMESETTINGS = UserSettings().GameSettings

local COUNTRIES = {
	MS = "Montserrat",
	FK = "Falkland Islands",
	CC = "Cocos Islands",
	HK = "Hong Kong",
	EC = "Ecuador",
	PS = "Palestinian Territory",
	SS = "South Sudan",
	RS = "Serbia",
	US = "United States",
	WS = "Samoa",
	MC = "Monaco",
	LC = "Saint Lucia",
	DK = "Denmark",
	SC = "Seychelles",
	XK = "Kosovo",
	AS = "American Samoa",
	TC = "Turks and Caicos Islands",
	BS = "Bahamas",
	ES = "Spain",
	ZW = "Zimbabwe",
	GS = "South Georgia and the South Sandwich Islands",
	PK = "Pakistan",
	SK = "Slovakia",
	QA = "Qatar",
	UA = "Ukraine",
	TK = "Tokelau",
	NP = "Nepal",
	CN = "China",
	SV = "El Salvador",
	GH = "Ghana",
	AZ = "Azerbaijan",
	MH = "Marshall Islands",
	AX = "Aland Islands",
	KH = "Cambodia",
	IN = "India",
	MX = "Mexico",
	AW = "Aruba",
	CK = "Cook Islands",
	TZ = "Tanzania",
	EH = "Western Sahara",
	BH = "Bahrain",
	CH = "Switzerland",
	PW = "Palau",
	AQ = "Antarctica",
	AO = "Angola",
	CX = "Christmas Island",
	CM = "Cameroon",
	AM = "Armenia",
	IR = "Iran",
	IS = "Iceland",
	PH = "Philippines",
	GP = "Guadeloupe",
	VI = "U.S. Virgin Islands",
	AI = "Anguilla",
	JP = "Japan",
	KP = "North Korea",
	AF = "Afghanistan",
	SH = "Saint Helena",
	CA = "Canada",
	BA = "Bosnia and Herzegovina",
	GI = "Gibraltar",
	FI = "Finland",
	GA = "Gabon",
	LI = "Liechtenstein",
	KI = "Kiribati",
	AG = "Antigua and Barbuda",
	MY = "Malaysia",
	LY = "Libya",
	KY = "Cayman Islands",
	AD = "Andorra",
	AE = "United Arab Emirates",
	PY = "Paraguay",
	MA = "Morocco",
	BI = "Burundi",
	SA = "Saudi Arabia",
	VC = "Saint Vincent and the Grenadines",
	CY = "Cyprus",
	BY = "Belarus",
	VA = "Vatican",
	BQ = "Bonaire, Saint Eustatius and Saba ",
	GY = "Guyana",
	NR = "Nauru",
	GQ = "Equatorial Guinea",
	ZA = "South Africa",
	SR = "Suriname",
	NI = "Nicaragua",
	NU = "Niue",
	TH = "Thailand",
	SI = "Slovenia",
	LS = "Lesotho",
	CF = "Central African Republic",
	LR = "Liberia",
	KN = "Saint Kitts and Nevis",
	LU = "Luxembourg",
	CG = "Republic of the Congo",
	LV = "Latvia",
	GN = "Guinea",
	BF = "Burkina Faso",
	CU = "Cuba",
	BN = "Brunei",
	MF = "Saint Martin",
	NF = "Norfolk Island",
	GF = "French Guiana",
	TV = "Tuvalu",
	LK = "Sri Lanka",
	MK = "Macedonia",
	CI = "Ivory Coast",
	TF = "French Southern Territories",
	LA = "Laos",
	BV = "Bouvet Island",
	LB = "Lebanon",
	PF = "French Polynesia",
	MP = "Northern Mariana Islands",
	UY = "Uruguay",
	YE = "Yemen",
	VG = "British Virgin Islands",
	SN = "Senegal",
	TN = "Tunisia",
	WF = "Wallis and Futuna",
	IT = "Italy",
	DM = "Dominica",
	PN = "Pitcairn",
	JO = "Jordan",
	IO = "British Indian Ocean Territory",
	RW = "Rwanda",
	EG = "Egypt",
	FO = "Faroe Islands",
	KW = "Kuwait",
	BG = "Bulgaria",
	MW = "Malawi",
	BO = "Bolivia",
	KG = "Kyrgyzstan",
	DO = "Dominican Republic",
	MG = "Madagascar",
	TW = "Taiwan",
	GG = "Guernsey",
	KM = "Comoros",
	MN = "Mongolia",
	TG = "Togo",
	SG = "Singapore",
	BW = "Botswana",
	UG = "Uganda",
	PG = "Papua New Guinea",
	MV = "Maldives",
	SX = "Sint Maarten",
	SY = "Syria",
	RO = "Romania",
	GW = "Guinea-Bissau",
	TO = "Tonga",
	SO = "Somalia",
	NO = "Norway",
	MO = "Macao",
	CV = "Cape Verde",
	CW = "Curacao",
	HN = "Honduras",
	PA = "Panama",
	IL = "Israel",
	PT = "Portugal",
	GL = "Greenland",
	BD = "Bangladesh",
	CD = "Democratic Republic of the Congo",
	LT = "Lithuania",
	MD = "Moldova",
	CL = "Chile",
	AL = "Albania",
	BL = "Saint Barthelemy",
	ID = "Indonesia",
	CO = "Colombia",
	GD = "Grenada",
	TT = "Trinidad and Tobago",
	AT = "Austria",
	BT = "Bhutan",
	SD = "Sudan",
	TD = "Chad",
	NZ = "New Zealand",
	NG = "Nigeria",
	NA = "Namibia",
	NC = "New Caledonia",
	SL = "Sierra Leone",
	TL = "East Timor",
	GT = "Guatemala",
	HT = "Haiti",
	ET = "Ethiopia",
	PL = "Poland",
	ML = "Mali",
	NL = "Netherlands",
	RU = "Russia",
	EE = "Estonia",
	JM = "Jamaica",
	IM = "Isle of Man",
	BE = "Belgium",
	GM = "Gambia",
	FM = "Micronesia",
	VU = "Vanuatu",
	NE = "Niger",
	ME = "Montenegro",
	BM = "Bermuda",
	KE = "Kenya",
	JE = "Jersey",
	IE = "Ireland",
	YT = "Mayotte",
	GE = "Georgia",
	VE = "Venezuela",
	AU = "Australia",
	ZM = "Zambia",
	SE = "Sweden",
	RE = "Reunion",
	MR = "Mauritania",
	PE = "Peru",
	UM = "United States Minor Outlying Islands",
	TM = "Turkmenistan",
	SM = "San Marino",
	HU = "Hungary",
	GU = "Guam",
	PM = "Saint Pierre and Miquelon",
	OM = "Oman",
	MQ = "Martinique",
	MM = "Myanmar",
	FJ = "Fiji",
	SZ = "Swaziland",
	BB = "Barbados",
	UZ = "Uzbekistan",
	PR = "Puerto Rico",
	MT = "Malta",
	MU = "Mauritius",
	GB = "United Kingdom",
	TR = "Turkey",
	KZ = "Kazakhstan",
	ST = "Sao Tome and Principe",
	MZ = "Mozambique",
	BJ = "Benin",
	VN = "Vietnam",
	DJ = "Djibouti",
	IQ = "Iraq",
	BZ = "Belize",
	CZ = "Czech Republic",
	DZ = "Algeria",
	SB = "Solomon Islands",
	DE = "Germany",
	AR = "Argentina",
	BR = "Brazil",
	CR = "Costa Rica",
	HM = "Heard Island and McDonald Islands",
	ER = "Eritrea",
	FR = "France",
	GR = "Greece",
	HR = "Croatia",
	SJ = "Svalbard and Jan Mayen",
	TJ = "Tajikistan",
	KR = "South Korea",
}


-- Variables


-- Module
local usersettings = {}


--[[ DISCLAIMER: These functions are CLIENT-ONLY.
     Any attempt to use them outside of the client will error. ]]

--[[ Functions: 

	usersettings.getCameraMovementMode()
	usersettings.getMovementMode()
	usersettings.getMouseLockMode()
	usersettings.getMouseSensitivity()
	usersettings.getGraphicsLevel()
	usersettings.getFullScreen()
	usersettings.getLocalRegion()
	usersettings.getCameraYInvertValue()
	usersettings.toggleCameraYInvertMenu()
	usersettings.bindToFullScreenChanged(fn)
	usersettings.bindToAnyPropertyChanged(fn)
	usersettings.bindToSpecificPropertyChanged(property, fn)
	usersettings.getAllValidProperties()
	usersettings.bindToGraphicsChanged(fn)

]]


--[[ usersettings.getCameraMovementMode()
	PARAMETERS:
	- nil.

	RETURNS:
	- <Enum.ComputerCameraMovementMode> mode: The camera movement mode for the player.

	Returns your camera movement mode. ]] 
function usersettings.getCameraMovementMode(): Enum.ComputerCameraMovementMode
	return GAMESETTINGS.ComputerCameraMovementMode
end


--[[ usersettings.getMovementMode()
	PARAMETERS:
	- nil.

	RETURNS:
	- <Enum.ComputerMovementMode> mode: The movement mode for the player.

	Returns your the movement mode. ]] 
function usersettings.getMovementMode(): Enum.ComputerMovementMode
	return GAMESETTINGS.ComputerMovementMode
end


--[[ usersettings.getMouseLockMode()
	PARAMETERS:
	- nil.

	RETURNS:
	- <Enum.ControlMode> mode: Whether you can use mouse lock or not.

	Returns whether you can use mouse lock or not. ]] 
function usersettings.getMouseLockMode(): Enum.ControlMode
	return GAMESETTINGS.ControlMode
end


--[[ usersettings.getMouseSensitivity()
	PARAMETERS:
	- nil.

	RETURNS:
	- <number> sens: The sensitivity for your mouse defined in your game settings.

	Returns your ROBLOX's mouse sensitivity. ]] 
function usersettings.getMouseSensitivity(): number
	return GAMESETTINGS.MouseSensitivity
end


--[[ usersettings.getGraphicsLevel()
	PARAMETERS:
	- nil.

	RETURNS:
	- <Enum.SavedQualitySetting> level: The current graphics level defined in your game settings.

	Returns your ROBLOX's graphics level. ]] 
function usersettings.getGraphicsLevel(): Enum.SavedQualitySetting
	return GAMESETTINGS.SavedQualityLevel
end


--[[ usersettings.getFullScreen()
	PARAMETERS:
	- nil.

	RETURNS:
	- <boolean> fullscreen: Whether or not the user is in full screen.

	Returns whether you are in full screen currently. ]] 
function usersettings.getFullScreen(): boolean
	return GAMESETTINGS:InFullScreen()
end


--[[ usersettings.getLocalRegion()
	PARAMETERS:
	- nil.

	RETURNS:
	- <string> locale: The country code of the player.
	- <string> country: The country name of the player.

	Returns the code and country of the player. ]] 
function usersettings.getLocalRegion(): (string, string)
	local locale = _LOCALIZATIONSERVICE:GetCountryRegionForPlayerAsync(LOCALPLAYER)
	return locale, COUNTRIES[locale]
end


--[[ usersettings.getCameraYInvertValue()
	PARAMETERS:
	- nil.

	RETURNS:
	- <number> value: The camera Y invert value.

	Returns the Y invert value for ROBLOX's camera. ]] 
function usersettings.getCameraYInvertValue(): number
	return GAMESETTINGS:GetCameraYInvertValue()
end


--[[ usersettings.toggleCameraYInvertMenu()
	PARAMETERS:
	- nil.

	RETURNS:
	- nil.

	Toggles ROBLOX's camera Y invert menu. ]] 
function usersettings.toggleCameraYInvertMenu()
	GAMESETTINGS:SetCameraYInvertVisible()
end


--[[ usersettings.bindToFullScreenChanged(fn)
	PARAMETERS:
	- <function> fn: The function to bind to the event. Also accepts an argument that indicates whether it is now fullscreen or not.

	RETURNS:
	- <RBXScriptConnection> cxn: The connection to the event. Useful to call for disconnects, etc.

Binds a given function to the fullscreen change event. Also returns the resulting connection. ]] 
function usersettings.bindToFullScreenChanged(fn: (boolean) -> ()): RBXScriptConnection
	return GAMESETTINGS.FullscreenChanged:Connect(fn)
end


--[[ usersettings.bindToGraphicsChanged(fn)
	PARAMETERS: 
	- <function> fn: The function to bind to the event.

	RETURNS:
	- <RBXScriptConnection> cxn: The connection to the event. Useful to call for disconnects, etc.

	Binds a given function to when the local player has changed their graphics level. Also returns the resulting connection. ]] 
function usersettings.bindToGraphicsChanged(fn: (Enum.SavedQualitySetting) -> ()): RBXScriptConnection
	local userSettings = UserSettings():GetService("UserGameSettings")

	return userSettings:GetPropertyChangedSignal("SavedQualityLevel"):Connect(function()  
		fn(userSettings.SavedQualityLevel)
	end)
end


return usersettings