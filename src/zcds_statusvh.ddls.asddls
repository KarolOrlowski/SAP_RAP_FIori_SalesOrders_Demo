@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Statuses for SalesOrder'
@ObjectModel.transactionalProcessingEnabled: true
@ObjectModel.resultSet.sizeCategory: #XS
//@ObjectModel.draftEnabled: true
@ObjectModel.usageType: {
serviceQuality: #X,
sizeCategory: #S,
dataClass: #MIXED
}


define view entity ZCDS_StatusVH
  as select from zsalesor_status as SalesOrder_status
{
      //      @UI.hidden: true
      //      @ObjectModel.text.element: ['status_text']
      //      @UI.textArrangement: #TEXT_ONLY



  key status as status_table,

@ObjectModel.text.element: ['status_text']
      @UI.hidden: true
      case status
      when 'NEW'        then 'NEW'
      when 'PROGRESS'   then 'PROGRESS'
      when 'COMPLETED'  then 'COMPLETED'
      when 'HOLD'       then 'HOLD'
      when 'REJECTED'   then 'REJECTED'
      when 'CANCELLED'  then 'CANCELLED'
      else 'NEW'
      end    as status_text

}
