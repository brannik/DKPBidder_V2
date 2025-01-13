REGEX = {}

REGEX.regex = {
    startBidRegex = "Bidding for (.+) started.",
    stopBidRegex = "(.+) has been cancelled.",
    wonBidRegex = "[Pp]urchases%s+(.+)",
    startRollRegex = "^([Rr][Oo][Ll]{1,2})?(%s+)?(([Mm][Ss])?([Oo][Ss])?([Dd][Ee])?){1}(%s+)(.+)", -- fix the regex
    stopRollRegex = "stoproll",
    wonRollRegex = "wonroll",
    noteRegexDkp = "[Nn]et:%s*(%d+)",
    noteRegexName = "^%a+$",
    msgRegex = "You have%s+(%d+)%s+DKP",
    msgregexTwo = "Your new net DKP amount is%s+(%d+)"
}
