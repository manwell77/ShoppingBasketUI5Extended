sap.ui.define(["sap/ui/core/UIComponent",
               "sap/ui/model/json/JSONModel",
               "sap/ui/Device"], 
		
	function (UIComponent, JSONModel, Device) {
	
		"use strict";
		
		return UIComponent.extend("com.eni.extbasket.Component", {

            metadata: {	manifest: "json" },	
        	
			init: function () {
							
				// call the init function of the parent
				UIComponent.prototype.init.apply(this, arguments); 
			
				// create the views based on the url/hash
				this.getRouter().initialize();
				
				// set device model -> still to be done manually, not in manifest.json
				var oDeviceModel = new JSONModel(Device);					            
				oDeviceModel.setDefaultBindingMode("OneWay");
				this.setModel(oDeviceModel, "device");		
				
			}
   });
});