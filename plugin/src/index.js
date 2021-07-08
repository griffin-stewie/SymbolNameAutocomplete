var REPOSITORY_URL_STRING = "https://github.com/griffin-stewie/SymbolNameAutocomplete";

/**
 * Handles startup action.
 */
export function onStartup(context) {
    if (!isFrameworkLoaded()) {
        var contentsPath = context.scriptPath.stringByDeletingLastPathComponent().stringByDeletingLastPathComponent();
        var resourcesPath = contentsPath.stringByAppendingPathComponent("Resources");

        var result = Mocha.sharedRuntime().loadFrameworkWithName_inDirectory("SymbolNameAutocomplete", resourcesPath);
        if (!result) {
            var alert = NSAlert.alloc().init();
            alert.alertStyle = NSAlertStyleCritical;
            alert.messageText = "Loading framework for “Symbol Name Autocomplete” failed"
            alert.informativeText = "Please try disabling and enabling the plugin or restarting Sketch."

            alert.runModal();

            return;
        }
    }

    log("SymbolNameAutocompletePluginController Enabled");
    SymbolNameAutocompletePluginController.sharedController().enabled = true;
}

/**
 * Handles shutdown action.
 */
export function onShutdown(context) {
    if (isFrameworkLoaded()) {
        log("SymbolNameAutocompletePluginController Disabled");
        SymbolNameAutocompletePluginController.sharedController().enabled = false;
    }
}

/**
 * Handles CreateSymbol.finish action.
 */
export function onCreateSymbolDidAppearHandler(context) {
    if (isFrameworkLoaded()) {
        const doc = context.actionContext.document;
        const docData = doc.documentData();
        const allMasterSymbols = docData.allSymbols();
        log(allMasterSymbols);
        const window = doc.window();
        const sheetWindow = window.attachedSheet();
        const createSymbolNameingSheet = sheetWindow.windowController();
        log("SymbolNameAutocompletePluginController Passing Sheet instance");
        SymbolNameAutocompletePluginController.sharedController().namingSheet = createSymbolNameingSheet;
        SymbolNameAutocompletePluginController.sharedController().documentData = docData;
    }
}


function isFrameworkLoaded() {
    return Boolean(NSClassFromString("SymbolNameAutocompletePluginController"));
}

/**
 * Handles about menu item.
 */
export function onSelectAboutMenuItem(context) {
    var repositoryUrl = NSURL.URLWithString(REPOSITORY_URL_STRING);

    NSWorkspace.sharedWorkspace().openURL(repositoryUrl);
}