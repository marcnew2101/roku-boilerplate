' Single source of truth for magic strings used across the channel.
' Grouped by purpose; reference with e.g. Const().button.okay
function Const() as object
    return {
        button: {
            okay: "OKAY"
            yes: "YES"
            cancel: "CANCEL"
            no: "NO"
        }
        key: {
            back: "back"
            up: "up"
            down: "down"
        }
        path: {
            messages: "pkg:/components/data/messages.json"
            requirements: "pkg:/components/data/requirements.json"
            themes: "pkg:/components/data/themes.json"
        }
        registry: {
            theme: "theme"
        }
        beacon: {
            dialogInitiate: "AppDialogInitiate"
            dialogComplete: "AppDialogComplete"
            launchComplete: "AppLaunchComplete"
        }
    }
end function
