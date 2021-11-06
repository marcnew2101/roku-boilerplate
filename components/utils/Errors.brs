sub createErrorDialog(error = {})
	' check that error is not invalid and is AA
	if (error <> Invalid AND type(error) = "roAssociativeArray")
		' check that AA is not empty
		if (error.count() > 0)
			' check that both the error type and message are included
			if (error.type <> Invalid AND error.message <> Invalid)
				errorValid = true
				' check error types
				if (error.type = 1)
					' TODO set custom interfaces on error dialog screen
					? error.message
				else if (error.type = 2)
					' TODO set custom interfaces on error dialog screen
					? error.message
				else if (error.type = 3)
					' TODO set custom interfaces on error dialog screen
					? error.message
				else
					errorValid = false
					? "ERROR: a valid error.type (1, 2 ,3) is required - Errors.brs"
				end if

				' check that help message is not invalid and the string is not empty
				if (error.help <> Invalid AND len(error.help) > 0)
					' TODO set custom interfaces on error dialog screen
					? error.help
				end if

				if (errorValid)
					showErrorDialog()
				end if
			else
				? "ERROR: a valid error message and/or error type is missing - Errors.brs"
				? "error object is: "; error
			end if
		end if
	end if
end sub

sub showErrorDialog()
	' TODO make error dialog screen visible
end sub