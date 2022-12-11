sub createDialog(params = {} as object)
	if (not isNullOrEmpty(params) and not isNullOrEmpty(params.title))
		if (not isValid(screenExists("dialogModal")))
			screen = addScreen("DialogModal", "dialogModal", true, false)
		else
			screen = getScreen("dialogModal")
		end if
		if screen <> invalid then showDialog(params, screen)
	else
		logging("message object is invalid or missing title", 3)
	end if
end sub
sub showDialog(params as object, screen as object)
	screen.dialogInfo = params
end sub
function getMessage(messageString = "" as string) as dynamic
	try
		messagefile = parseJson(readAsciiFile("pkg:/components/data/messages.json"))
		for each message in messagefile.items()
			if (message.key = messageString and message.value <> invalid)
				return message.value
				exit for
			end if
		end for
	catch e
		logging("unable to read messages.json file - " + e.message, 3)
		return invalid
	end try
end function
sub setMessage(message as string, node = m.top.getScene())
	node.message = message
end sub