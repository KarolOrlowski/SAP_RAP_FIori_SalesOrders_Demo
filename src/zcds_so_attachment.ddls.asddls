@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View For Sales Order Attachments'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_SO_Attachment
  as select from zso_attach
  // Association wstecz do obiektu głównego (Sales Order):
  association to parent ZCDS_SalesOrder as _SalesOrder on $projection.ParentUuid = _SalesOrder.salesorderuuid
{

      @UI.hidden: true
  key attach_uuid     as AttachUuid,
      @UI.hidden: true
      parent_uuid     as ParentUuid,

      
      @EndUserText.label: 'Attachment'
      @Semantics.largeObject: { mimeType: 'MimeType',
       fileName: 'Filename',
        contentDispositionPreference: #INLINE,
        acceptableMimeTypes: ['application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ,  'application/pdf' ]}
        @UI.identification: [{ position: 20, label: 'Attachment ID' }]
      attachment_id   as AttachmentID,

      @Semantics.mimeType: true
      @EndUserText.label: 'File Type'
      mimetype        as MimeType,
      @UI.identification: [{ position: 10, label: 'File Name' }]
      filename        as Filename,
      @EndUserText.label: 'Comments'
      comments as Comments,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,

      _SalesOrder
}
