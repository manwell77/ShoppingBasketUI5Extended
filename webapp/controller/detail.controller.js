sap.ui.define(["sap/ui/core/mvc/Controller",
               "sap/ui/core/routing/History",
               "sap/ui/model/resource/ResourceModel",
               "sap/m/MessageToast",
               "sap/m/Dialog",
               "sap/m/Button"], 
		
	function (Controller,History,ResourceModel,MessageToast, Dialog, Button) {
	
		"use strict";
   
		return Controller.extend("com.eni.extbasket.controller.detail", {  											
			
			onInit: function () {		
                /* get route */				
				var oRouter = sap.ui.core.UIComponent.getRouterFor(this);
				oRouter.getRoute("detail").attachPatternMatched(this._onObjectMatched, this);				
				oRouter.getRoute("app").attachPatternMatched(this._onRootMatched, this);	
				oRouter.attachBypassed(this._notFound);				
				this.getView().byId("detailPage").setVisible(false);				
			},								
			
			_notFound: function (oEvent) {
				var sHash = oEvent.getParameter("hash");
			},
			
			_onBindingChange : function (oEvent) {
				var oRouter = sap.ui.core.UIComponent.getRouterFor(this);
				// No data for the binding
				if (!this.getView().getBindingContext("sc")) { oRouter.navTo("notfound",true);}
			},

			onNavigationBack: function () {				
                /* back navigation */
				if (History.getInstance().getPreviousHash() !== undefined) 
				  { window.history.go(-1); } 
				else 
				  { sap.ui.core.UIComponent.getRouterFor(this).navTo("app", true); }
			},	
			
			_onObjectMatched: function (oEvent) {
				/* match path */						
				var sPath = "/BasketSet('" + oEvent.getParameter("arguments").WorkitemID + "')";
				var oView = this.getView();
				oView.bindElement( { path: sPath, model: "sc", events: { change: this._onBindingChange.bind(this), dataRequested: function(oEvent) { oView.setBusy(true); }, dataReceived: function(oEvent) { oView.setBusy(false); } } } );					
				this.getView().byId("detailPage").setVisible(true);		
			},
			
			_onRootMatched: function (oEvent) {
				/* match path */
				this.getView().unbindElement( "sc" );
				this.getView().byId("detailPage").setVisible(false);
			},
			
			_buildObject: function(oSC) {
				  // build Object
				  var oObject = { WorkitemID: oSC.WorkitemID,
						          BasketGuid: oSC.BasketGuid,
						          BasketNumber: oSC.BasketNumber,
						          CreatedBy: oSC.CreatedBy,
						          Status: oSC.Status };
				  // return
				  return oObject;
			},
			
			onApprove: function(oEvent) {
				// get cart obejct, model and model path
				var oSC = oEvent.getSource().getBindingContext("sc").getObject();
				var sPath = oEvent.getSource().getBindingContext("sc").getPath();
				var oModel = this.getView().getModel("sc");
				// set entity status
				oSC.Status = "APP";
				// build entry
				var oEntry = this._buildObject(oSC);	
				// myself reference
				var self = this;
				// update
				oModel.update(sPath,oEntry, 
					{ context:null,
					  success: function(oData, oResponse) { MessageToast.show("Approved"); self.getView().getModel("sc").refresh(); },
					  error: function(oError) { MessageToast.show("Error Occurred"); 	}
					} );			
			},
			
			onReject:function(oEvent) {
				// get cart obejct, model and model path
				var oSC = oEvent.getSource().getBindingContext("sc").getObject();
				var sPath = oEvent.getSource().getBindingContext("sc").getPath();
				var oModel = this.getView().getModel("sc");
				// set entity status
				oSC.Status = "REJ";
				// build entry
				var oEntry = this._buildObject(oSC);
				// myself reference
				var self = this;
				// update
				oModel.update(sPath,oEntry, 
						{ context:null,
					      success: function(oData, oResponse) { MessageToast.show("Rejected"); self.getView().getModel("sc").refresh(); },
						  error: function(oError) {	MessageToast.show("Error Occurred"); }
						} );		
			}
			
		});
   
});