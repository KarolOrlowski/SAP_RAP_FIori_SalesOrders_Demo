@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Attachments Projection View'
//@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_SO_Attachment_Proj
  as projection on ZCDS_SO_Attachment 
{


 @UI.facet: [{
             id: 'AttachmentInformation',
             purpose: #STANDARD,
             label: 'Attachment Information',
             type: #IDENTIFICATION_REFERENCE,
             position: 10
         }]



  // Adnotacje UI definiują, jak lista załączników wygląda w Fiori
  @UI.lineItem: [{ position: 10, label: 'Attachment UUID' }]
  @UI.identification: [{ position: 40 }]
  key AttachUuid,
  @UI.lineItem: [{ position: 20, label: 'Parent UUID' }]
  @UI.identification: [{ position: 20 }]
  ParentUuid,
  
@UI.lineItem: [{ position: 30, label: 'Comments' }]
@UI.identification: [{ position: 30 }]
--@UI.multiLineText: true
  Comments,
  
@UI.lineItem: [{ position: 30, label: 'Atatchment ID' }]
  @UI.identification: [{ position: 10 , label: 'Attachment'}]
  AttachmentID, // Pole techniczne z danymi pliku
  
  MimeType,
  @UI.lineItem: [{ position: 20, label: 'Filename' }]
  Filename,
  LastChangedAt,
  
  // Przekierowanie z powrotem do widoku nadrzędnego
  _SalesOrder : redirected to parent ZC_SalesOrderWithCustomer
}
