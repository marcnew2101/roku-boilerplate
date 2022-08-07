sub createDialog(params = {})
	if (params <> invalid and type(params) = "roAssociativeArray")
		if (params.count() > 0)
			if (params.title <> invalid and len(params.title) > 0)
				messageValid = true
			else
				messageValid = false
				? "message title is required - Messages.brs"
				? "message is: "; params
			end if
			if (messageValid <> invalid and messageValid)
				screen = getScreen("DialogModal")
				if (screen <> invalid)
					showDialog(params, screen)
				end if
			end if
		else
			? "message object is empty - Messages.brs"
		end if
	else
		? "message is not an object - Messages.brs"
	end if
end sub
sub showDialog(params, screen)
	screen.dialogInfo = params
end sub
function getMessage(messageString = "")
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
sub setMessage(message)
	m.top.getScene().message = message
end sub