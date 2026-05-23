' Single source of truth for magic strings used across the channel.
' Grouped by purpose; reference with e.g. Const().key.back
function Const() as object
    return {
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
