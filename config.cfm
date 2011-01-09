<cfscript>
// Configuration structure
application.config = structNew();
// Should private methods be documented
application.config.hidePrivateMethod = false;
// Title of this app
application.config.title = "Example Platform";
application.config.subtitle = "Example Platform 1.0";
// Default start page to show
application.config.startPage = "readme.cfm";
// Default name of the constructor
application.config.constructorName = "init";
// Array of doc roots that contain cfc's
application.config.docroots = arrayNew(1);
// Name of the mapping to the root where cfc's live
application.config.docroots[1] = "example";
</cfscript>