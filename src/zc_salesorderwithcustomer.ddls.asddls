@EndUserText.label: 'Sales Orders with Customer - Project View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI.headerInfo: {
  typeName: 'Sales Order',
  typeNamePlural: 'Sales Orders',
  title: { type: #STANDARD, value: 'salesorder_id' },
  description: { value: 'customer_name' }}
@Search.searchable: true


define root view entity ZC_SalesOrderWithCustomer
  provider contract transactional_query
  as projection on ZCDS_SalesOrder
{

      @UI.facet: [



          { id: 'headerFacet',
            purpose: #STANDARD,
            type: #FIELDGROUP_REFERENCE,
            label: 'General Information',
            targetQualifier: 'GeneralGroup' , position: 20},



            { id: 'DetailFacet',
            purpose: #STANDARD,
            type: #FIELDGROUP_REFERENCE,
            label: ' ',
            targetQualifier: 'DetailGroup' , position: 30},



            { id: 'HeaderStatus',
             purpose: #STANDARD,
             type: #DATAPOINT_REFERENCE,
             targetQualifier: 'StatusData',
             position: 10 },

             { id: 'AttachmentsFacet',
             purpose: #STANDARD,
             type: #LINEITEM_REFERENCE,
             label: 'Attachments',
             position: 40,
      targetElement: '_Attachments'}



      ]


  key salesorderuuid,

      @UI.lineItem: [{ position: 10 }]
      @UI.identification: [{ position: 10, label: 'Order Number' }]
      @UI.fieldGroup: [{ position: 10, qualifier: 'GeneralGroup', label: 'Order Number' }]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @UI.selectionField: [{ position: 20 }]
      //      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZCDS_SalesOrder', element: 'salesorder_id' }
      //      }]

      @Consumption.valueHelpDefinition: [{
          entity: { name: 'ZCDS_SalesOrder', element: 'salesorder_id' },
          additionalBinding: [
              { localElement: 'salesorder_id', element: 'salesorder_id', usage: #FILTER },
              { localElement: 'salesorder_id', element: 'name', usage: #FILTER },
              { localElement: 'salesorder_id', element: 'customerUrl', usage: #FILTER },
              { localElement: 'salesorder_id', element: 'StatusCriticality', usage: #FILTER },
              { localElement: 'salesorder_id', element: 'customer_name', usage: #FILTER }
              --{ localElement: 'salesorder_id', element: 'Customer Name', usage: #FILTER }
          ]
      }]


      salesorder_id,

      //@UI.lineItem: [{ position: 20, label: 'Customer Name' }]
      @UI.identification: [{ position: 20, label: 'Customer List' }]
      @UI.fieldGroup: [{ position: 20, qualifier: 'GeneralGroup', label: 'Customer List' }]
      //@Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      //@UI.selectionField: [{ position: 10 }]
      @Consumption.valueHelpDefinition: [{
             entity: { name: 'ZCDS_Customer', element: 'Name' },
             additionalBinding: [{ localElement: 'customer_name', element: 'Name', usage: #FILTER }]
                   }]



      customer_name,


      @UI.lineItem: [{ position: 30, label: 'Order Date' }]
      @UI.identification: [{ position: 30, label: 'Order Date' }]
      @UI.fieldGroup: [{ position: 30, qualifier: 'GeneralGroup', label: 'Order Date' }]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      order_date,

      @UI.lineItem: [{ position: 40, label: 'Delivery Date' }]
      @UI.fieldGroup: [{ position: 30, qualifier: 'DetailGroup', label: 'Delivery Date' }]
      @UI.identification: [{ position: 30 }]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      delivery_date,

      @UI.lineItem: [{ position: 50, label: 'Payment Date' }]
      @UI.fieldGroup: [{ position: 10, qualifier: 'DetailGroup', label: 'Payment Date' }]
      @UI.identification: [{ position: 10 }]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      payment_date,

      @UI.lineItem: [{ position: 60, label: 'Send Due Date' }]
      @UI.fieldGroup: [{ position: 20, qualifier: 'DetailGroup', label: 'Send Due Date' }]
      @UI.identification: [{ position: 20 }]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      send_due_date,

      @UI.lineItem: [{ position: 70, label: 'Status' , criticality: 'StatusCriticality' }]
      //@UI.identification: [{ position: 40, label: 'Status' }]
      //@UI.fieldGroup: [{ position: 40, qualifier: 'GeneralGroup', label: 'Status' }]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @UI.textArrangement: #TEXT_ONLY
      @UI.dataPoint: { criticality: 'StatusCriticality', qualifier: 'StatusData' , criticalityRepresentation: #WITH_ICON  }
      @Consumption.valueHelpDefinition: [{
        entity: { name: 'ZCDS_StatusVH', element: 'status_text' }
      }]

      status,

      @UI.hidden: true
      StatusCriticality,


      @UI.lineItem: [{ position: 80, label: 'Total Price', cssDefault.width: '250px' }]
      @UI.identification: [{ position: 40, label: 'Total Price' }]
      @UI.fieldGroup: [{ position: 40, qualifier: 'GeneralGroup', label: 'Total Price' }]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8

      total_price,

      @UI.lineItem: [{ position: 90, label: 'Description' }]
      @UI.identification: [{ position: 50 , label: 'Description' }]
      @UI.fieldGroup: [{ position: 50, qualifier: 'DetailGroup', label: 'Description' }]
      @UI.multiLineText: true

      description,

      @Consumption.filter.hidden: true
      @UI.selectionField: [{ exclude: true }]
      @UI.hidden: true
      customer_id,

      @UI.lineItem: [{ position: 20, label: 'Customer Name' , type: #WITH_URL, url: 'customerUrl' }]
      @UI.identification: [{ position: 60, label: 'Customer Name' }]
      @UI.fieldGroup: [{ position: 20, qualifier: 'GeneralGroup', label: 'Customer Name' }]
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      //@UI.selectionField: [{ position: 20 }]
      //       @Consumption.valueHelpDefinition: [{
      //            entity: { name: 'ZCDS_Customer', element: 'name' },
      //            additionalBinding: [{ localElement: 'customer_name_salesord', element: 'name' }]
      //                  }]

      //CustomerURL,
      customer_name_salesord,

      //@UI.lineItem: [{ position: 100, label: 'Home Page' , type: #WITH_URL, url: 'customerUrl'}]
      @UI.hidden: true

      customerUrl,


      _Attachments : redirected to composition child ZC_SO_Attachment_Proj

















}
