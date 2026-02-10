@EndUserText.label: 'Customer Basic View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.transactionalProcessingEnabled: true
@ObjectModel.resultSet.sizeCategory: #XS
//@Search.searchable: true

//@ObjectModel.draftEnabled: true
@ObjectModel.usageType: {
serviceQuality: #X,
sizeCategory: #S,
dataClass: #MIXED}

define root view entity ZCDS_Customer
  as select from zcustomer
{


      @UI.hidden: true
      @Consumption.filter.hidden: true
      @UI.selectionField: [{ exclude: true }]
  key customer_id,
      //@Search.defaultSearchElement: true
      //@ObjectModel.text.element: ['name']
      //@EndUserText.label: 'Customer Name'
      //@ObjectModel.text.element: ['name']
      //@UI.hidden: true
      //@Consumption.filter.hidden: true
      //@UI.selectionField: [{ exclude: true }]
      //@Consumption.hidden: true
      name as Name,

      @UI.hidden: true
      lastchangedat as LastChangedAt

}
