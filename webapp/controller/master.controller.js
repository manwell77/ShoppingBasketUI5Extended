sap.ui.define(["sap/ui/core/mvc/Controller",
               "sap/ui/model/resource/ResourceModel",
           	   "sap/ui/model/Filter",
        	   "sap/ui/model/FilterOperator",
        	   'sap/ui/core/Fragment'], 
		
	function (Controller,ResourceModel,Filter,FilterOperator) {
	
		"use strict";
   
		return Controller.extend("com.eni.extbasket.controller.master", {  						

			_getSettings : function () {
				if (!this._oSettings) {
					this._oSettings = sap.ui.xmlfragment("com.eni.extbasket.fragment.settings", this);
					this.getView().addDependent(this._oSettings);
				}
				return this._oSettings;
			},

			onScPressed: function(oEvent) {
				var oRouter = sap.ui.core.UIComponent.getRouterFor(this);
				oRouter.navTo("detail", { WorkitemID: oEvent.getSource().getBindingContext("sc").getObject().WorkitemID }, false );
			},
			
			onLiveSearch: function(oEvent) {
				var oFilter;
				var searchKey = oEvent.getSource().getValue();
				if (searchKey) { oFilter = new Filter("SearchKey",FilterOperator.Contains,searchKey); }
				else { oFilter = new Filter("SearchKey",FilterOperator.Contains,""); }
				// filter binding
				this.byId("masterList").getBinding("items").filter(oFilter);				
			},
			
			onFilter: function (oEvent) {
				this._getSettings().setFilterSearchCallback(null).setFilterSearchOperator(sap.m.StringFilterOperator.Equal).open();				
			},
			
			onConfirm: function(oEvent) {
				// get parameters and initialize sorter
				var parameters = oEvent.getParameters();
				var aSorter = [];
				var aFilters = [];
				// grouping
			    if (parameters.groupItem) {
			    	switch (parameters.groupItem.getKey()) {
			    		case "1": aSorter.push(new sap.ui.model.Sorter("FlowShort",parameters.groupDescending,true)); break;
			    		case "2": aSorter.push(new sap.ui.model.Sorter("PostedByName",parameters.groupDescending,true)); break;
			    	}	 
			    }
			    // sorting
			    if (parameters.sortItem) {
			    	switch (parameters.sortItem.getKey()) {
			    		case "1": aSorter.push(new sap.ui.model.Sorter("FlowShort",parameters.sortDescending,false)); break;
			    		case "2": aSorter.push(new sap.ui.model.Sorter("Number",parameters.sortDescending,false)); break;
			    		case "3": aSorter.push(new sap.ui.model.Sorter("PostedByName",parameters.sortDescending,false)); break;
			    		default: break;
			    	}
			    }
			    // filtering			    
			    for (var i=0;i<parameters.filterItems.length;i++) {
				      var aSplit = parameters.filterItems[i].getKey().split("__");
				      var oFilter = new sap.ui.model.Filter(aSplit[0],FilterOperator.EQ,aSplit[1]);
				      aFilters.push(oFilter);
				    }
			    
			    // apply
			    this.byId("masterList").getBinding("items").filter(aFilters);
			    this.byId("masterList").getBinding("items").sort(aSorter);
			    
			    // handle icon
			    if ((aSorter.length>0) || (parameters.filterItems.length>0))
			    	{ this.byId("butFilter").setIcon("sap-icon://add-filter"); }
			    else
			    	{ this.byId("butFilter").setIcon("sap-icon://filter"); }
			}
			
		});
   
});