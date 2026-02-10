@EndUserText.label: 'Sales Orders with Customer Data'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define root view entity ZCDS_SalesOrderWithCustomer
  as select from ZCDS_SalesOrder as so
    inner join   ZCDS_Customer   as cu on so.customer_id = cu.customer_id
{
  key so.salesorder_id,
      so.customer_id,
      cu.name          as customer_name,
      so.order_date    as order_date,
      so.delivery_date as delivery_date,
      so.payment_date  as payment_date,
      so.send_due_date as send_due_date,
      so.status        as status,
      so.total_price   as total_price,
      so.description   as description


}
