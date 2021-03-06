sub createErrorDialog(error = {})
	' check that error is not invalid and is AA
	if (error <> Invalid AND type(error) = "roAssociativeArray")
		' check that AA is not empty
		if (error.count() > 0)
			' check that both the error title and message are included
			if (error.message <> Invalid AND len(error.message) > 0)
				' set error valid to true
				errorValid = true
			else
				' set error valid to false
				errorValid = false
				? "a valid error.message is required - Errors.brs"
				? "error is: "; error
			end if

			' check if error is valid and true
			if (errorValid <> Invalid AND errorValid)
				' get the Dialog Modal screen
				screen = getScreen("DialogModal")
				' check that the screen is not invalid
				if (screen <> Invalid)
					' show the error dialog screen/modal
					showErrorDialog(error, screen)
				end if
			end if
		else
			? "error object is empty - Errors.brs"
		end if
	else
		? "error object is invalid in createErrorDialog(error = {}) - Errors.brs"
	end if
end sub

sub showErrorDialog(error, screen)
	' send the AA to the interface AA on the Dialog Modal screen
	screen.dialogInfo = error
end sub

function getError(errorString = "")
    errorfile = ReadAsciiFile("pkg:/components/data/errors.json")
	if (errorfile <> Invalid)
		json = ParseJson(errorfile)
		if (json <> Invalid)
            for each error in json.items()
                if (error.key = errorString AND error.value <> Invalid)
                    return error.value
                    exit for
                end if
            end for
        end if
	else
		return Invalid
	end if
end function

sub setError(error)
	m.top.getScene().error = error
end sub