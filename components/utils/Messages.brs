sub createDialog(params = {} as object)
	if (params <> invalid)
		if (params.count() > 0)
			if (params.title <> invalid and len(params.title) > 0)
				messageValid = true
			else
				messageValid = false
				? "message title is required - Messages.brs"
				? "message is: "; params
			end if
			if (messageValid <> invalid and messageValid)
				if not screenExists("dialogModal")
					screen = addScreen("DialogModal", "dialogModal", true, false)
				else
					screen = getScreen("dialogModal")
				end if
				if (screen <> invalid)
					showDialog(params, screen)
				end if
			end if
		else
			? "message is empty - Messages.brs"
		end if
	else
		? "message is not an object - Messages.brs"
	end if
end sub
sub showDialog(params as object, screen as object)
	screen.dialogInfo = params
end sub
function getMessage(messageString = "" as string)
	messagefile = ReadAsciiFile("pkg:/components/data/messages.json")
	if (messagefile <> invalid)
		json = ParseJson(messagefile)
		if (json <> invalid)
			for each message in json.items()
				if (message.key = messageString and message.value <> invalid)
					return message.value
					exit for
				end if
			end for
		end if
	else
		return invalid
	end if
end function
sub setMessage(message as string)
	m.top.getScene().message = message
end sub