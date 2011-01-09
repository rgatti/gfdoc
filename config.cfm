<cfscript>

// Configuration structure
application.config = structNew();
// Array of doc roots that contain cfc's
application.config.docroots = arrayNew(1);
// Should private methods be documented
application.config.hidePrivateMethod = false;
// Title of this app
application.config.title = "Nexus Platform";
application.config.subtitle = "Nexus Platform 2.0";
// Default start page to show
application.config.startPage = "readme.cfm";
// Default name of the constructor
application.config.constructorName = "init";

// Path to the root where cfc's live
application.config.docroots[1] = "nexus";
application.config.docroots[2] = "mxunit";
application.config.docroots[3] = "coldbox";
application.config.docroots[4] = "coldspring";
</cfscript>
