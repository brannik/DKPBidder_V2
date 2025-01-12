REGEX = {}

REGEX.regex = {
    startBidRegex = "Bidding for (.+) started.",
    stopBidRegex = "(.+) has been cancelled.",
    wonBidRegex = "[Pp]urchases%s+(.+)",
    startRollRegex = "roll%s+(ms%s+)?(|c%x%x%x%x%x%x%x%x|Hitem:.+|h%[.+%]|h|r)", -- fix the regex
    stopRollRegex = "stoproll",
    wonRollRegex = "wonroll",
    noteRegexDkp = "[Nn]et:%s*(%d+)",
    noteRegexName = "^%a+$",
    msgRegex = "You have%s+(%d+)%s+DKP",
    msgregexTwo = "Your new net DKP amount is%s+(%d+)"
}

