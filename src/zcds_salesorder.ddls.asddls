@EndUserText.label: 'Sales Order Basic View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.transactionalProcessingEnabled: true
@ObjectModel.usageType: {
serviceQuality: #X,
sizeCategory: #S,
dataClass: #MIXED
}


define root view entity ZCDS_SalesOrder
  as select from zsalesorder as so
  association [0..1] to zcustomer          as _Customer on _Customer.customer_id = so.customer_id
  association [0..1] to ZCDS_StatusVH      as _StatusVH on _StatusVH.status_table = so.status
  composition [0..*] of ZCDS_SO_Attachment as _Attachments


{

      @UI.hidden: true
  key so.salesorderuuid,

      @EndUserText.label: 'Sales Orders'

      so.salesorder_id,




      @Consumption.filter.hidden: true
      @UI.selectionField: [{ exclude: true }]
      _Customer.name,


      @UI.hidden: true
      so.customer_id,

      @EndUserText.label: 'Customer Name'




      so.customer_name as customer_name_salesord,
      @EndUserText.label: 'Order Date'
      so.order_date,
      @EndUserText.label: 'Delivery Date'
      so.delivery_date,
      @EndUserText.label: 'Payment Date'
      so.payment_date,
      @EndUserText.label: 'Send Due Date'
      so.send_due_date,
      @EndUserText.label: 'Status'
      so.status,
      @Consumption.hidden: true
      so.status_type_text,
      @ObjectModel.text.element: [ 'StatusCriticality' ]
      @Consumption.hidden: true
      @UI.hidden: true
      @Consumption.filter.hidden: true
      so.status_criticality,
      @EndUserText.label: 'Total Price'
      so.total_price,
      @EndUserText.label: 'Description'
      so.description,
      @Semantics.systemDateTime.lastChangedAt: true
      so.lastchangedat as LastChangedAt,
      @Semantics.user.lastChangedBy: true
      so.lastchangedby as lastChangedBy,



      _Customer.name   as customer_name,


      // Fields from Status Table
      @UI.hidden: true
      @Consumption.filter.hidden: true
      _StatusVH.status_table,
      @UI.hidden: true
      @Consumption.filter.hidden: true
      _StatusVH.status_text,



      _Attachments,

      @Consumption.hidden: true
      case status
      when 'NEW' then 'NEW'
      when 'PROGRESS' then 'PROGRESS'
      when 'COMPLETED' then 'COMPLETED'
      when 'HOLD' then 'HOLD'
      when 'REJECTED'   then 'REJECTED'
      when 'CANCELLED'  then 'CANCELLED'
      else 'N/A'
      end              as StatusTypeText,

      case status
      when 'NEW' then 2
      when 'PROGRESS' then 3
      when 'COMPLETED' then 3
      when 'HOLD' then 1
      when 'REJECTED'   then 1
      when 'CANCELLED'  then 1
      else 0
      end              as StatusCriticality,


      case so.customer_name
       when 'MICROSOFT CORPORATION'        then 'https://www.microsoft.com/'
          when 'SAP SE'   then 'https://www.sap.com/'
          when 'BIEDRONKA'  then 'https://www.biedronka.pl'
          when 'PEWEX'       then 'https://pewex.pl'
          when 'BALTONA'   then 'https://baltona.pl'
          when 'YAMAHA'  then 'https://global.yamaha-motor.com'
          when 'SONY CORPORATION'  then 'https://www.sony.com'
          when 'NINTENDO'  then 'https://www.nintendo.com'
          when 'HONDA MOTOR CO. LTD.'  then 'https://global.honda/'
          when 'KAROL ORLOWSKI'  then 'https://www.linkedin.com/in/karol-orlowski-85ba3b46/'
          else 'https://www.google.com/'
          end          as customerUrl






}
