@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Web Url for Customers'
@ObjectModel.transactionalProcessingEnabled: true
@ObjectModel.resultSet.sizeCategory: #XS
@ObjectModel.usageType: {
serviceQuality: #X,
sizeCategory: #S,
dataClass: #MIXED
}




define view entity ZCDS_Customer_url
  as select from ZCDS_SalesOrder as so
{

      @UI.hidden: true
  key so.salesorderuuid,
      customer_name_salesord,

      case so.customer_name_salesord
        when 'MICROSOFT CORPORATION'        then 'https://www.microsoft.com/'
           when 'SAP SE'   then 'https://www.sap.com/'
           when 'BIEDRONKA'  then 'https://www.biedronka.pl'
           when 'PEWEX'       then 'https://pewex.pl'
           when 'BALTONA'   then 'https://baltona.pl'
           when 'YAMAHA'  then 'https://global.yamaha-motor.com'
           when 'SONY CORPORATION'  then 'https://www.sony.com'
           when 'NINITENDO'  then 'https://www.nintendo.com'
           when 'HONDA MOTOR CO. LTD.'  then 'https://global.honda/'
           else 'https://www.google.com/'
           end as customerUrl




}
