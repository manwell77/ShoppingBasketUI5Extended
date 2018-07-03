sap.ui.define(["sap/ui/core/mvc/Controller",
			   "sap/ui/core/routing/History"], 
		
	function (Controller,History) { 
	
		"use strict";

		return Controller.extend("com.eni.extbasket.controller.notfound", {
	
			/* initialization */
			onInit : function () { 	
								
			},
			
			onNavBack: function (oEvent) {
				var oHistory, sPreviousHash;

				oHistory = History.getInstance();
				sPreviousHash = oHistory.getPreviousHash();

				if (sPreviousHash !== undefined) {
					window.history.go(-1);
				} else {
					sap.ui.core.UIComponent.getRouterFor(this).navTo("app", {}, true ); 
				}
			}			
			
		});

});
