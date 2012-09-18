<cfscript>
// Configuration structure
application.config = structNew();
// Should private methods be documented
application.config.hidePrivateMethod = false;
// Title of this app
application.config.title = "Getfused Platform";
application.config.subtitle = "Getfused Platform 1.75";
// Default start page to show
application.config.startPage = "readme.cfm";
// Default name of the constructor
application.config.constructorName = "init";
// The output directory where to generate all html files
application.config.output = "C:/Users/rgatti/Development/Websites/gfdoc/doc";

// Array of doc roots that contain cfc's
application.config.docroots = arrayNew(1);

application.config.docroots[1] = "gfplatform";

application.config.hide = [ "\.frameworks\.", "\.handlers\.?", "\.base$" ];

/*
// Name of the mapping to the root where cfc's live
application.config.docroots[1] = {
	// the coldfusion mapping where this root exists
	mapping = "gfplatform",
	// array of regex patterns applied to packages that should not be indexed
	remove = [ "\.frameworks\.", "\.handlers\.?" ],
	// array of regex patterns applied to packages that should be hidden from listings
	// but still cross referenced
	hide = [ "\.base$" ]
};
application.config.docroots[2] = {
	mapping = "coldbox"
};
application.config.docroots[3] = {
	mapping = "coldspring"
};
*/
</cfscript>