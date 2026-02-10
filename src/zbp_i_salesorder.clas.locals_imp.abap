CLASS lhc_SalesOrder DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PUBLIC SECTION.




  PRIVATE SECTION.
    DATA lv_number TYPE i.


    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR SalesOrder RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR salesorder RESULT result.

    METHODS add FOR MODIFY
      IMPORTING keys FOR ACTION salesorder~add RESULT result.

    METHODS gen_num_salesorder_id FOR DETERMINE ON SAVE
      IMPORTING keys FOR salesorder~gen_num_salesorder_id.

    METHODS validate_mandatory_fields FOR VALIDATE ON SAVE
      IMPORTING keys FOR salesorder~validate_mandatory_fields.



ENDCLASS.

CLASS lhc_SalesOrder IMPLEMENTATION.

  METHOD get_instance_authorizations.
    APPEND VALUE #( %tky = keys[ 1 ]-%tky
                    %update = if_abap_behv=>auth-allowed
                    %delete = if_abap_behv=>auth-allowed ) TO result.
  ENDMETHOD.

  METHOD get_instance_features.

    MOVE-CORRESPONDING keys TO result.

    LOOP AT result ASSIGNING FIELD-SYMBOL(<fs>).
      <fs>-%action-Add = if_abap_behv=>fc-o-enabled.
    ENDLOOP.

  ENDMETHOD.

  METHOD Add.

    READ ENTITIES OF zcds_salesorder IN LOCAL MODE
    ENTITY SalesOrder
    ALL FIELDS WITH
      CORRESPONDING #( keys )
    RESULT DATA(lt_salesorders).

    DATA lt_update TYPE TABLE FOR UPDATE zcds_salesorder.
    lt_update = CORRESPONDING #( lt_salesorders ).

    MODIFY ENTITIES OF zcds_salesorder
      IN LOCAL MODE
      ENTITY SalesOrder
      UPDATE FIELDS
        ( description )
      WITH lt_update
      REPORTED DATA(li_reported).


  ENDMETHOD.

  METHOD gen_num_salesorder_id.



    DATA: lv_number TYPE i.


    READ ENTITIES OF zcds_salesorder IN LOCAL MODE
      ENTITY SalesOrder
      FIELDS ( salesorder_id )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_orders).

    " Remove records with identificator
    DELETE lt_orders WHERE salesorder_id IS NOT INITIAL.
    IF lt_orders IS INITIAL.
      RETURN.
    ENDIF.

    " Find Highest number in the table (zsalesorder)
    SELECT MAX( salesorder_id )
      FROM zsalesorder
      INTO @DATA(lv_max_active).

    " Find Highest number in the table DRAFT (zsalesorder_dr)

    SELECT MAX( salesorder_id )
      FROM zsalesorder_dr
      INTO @DATA(lv_max_draft).

    " Select latest used identificator
    DATA(lv_last_id) = COND #( WHEN lv_max_draft > lv_max_active
                               THEN lv_max_draft
                               ELSE lv_max_active ).

    " Count loop start
    IF lv_last_id IS INITIAL.
      lv_number = 1.
    ELSE.
      TRY.
          " format 'SO001', cut from 3 sign (index 2)
          lv_number = CONV i( substring( val = lv_last_id off = 2 ) ) + 1.
        CATCH cx_sy_range_out_of_bounds cx_sy_conversion_error.
          lv_number = 1.
      ENDTRY.
    ENDIF.

    " Loop assign number for every new number
    LOOP AT lt_orders ASSIGNING FIELD-SYMBOL(<ls_order>).

      DATA(lv_found_unique) = abap_false.

      WHILE lv_found_unique = abap_false.
        DATA(lv_new_id) = |SO{ lv_number WIDTH = 3 ALIGN = RIGHT PAD = '0' }|.

        " Check if number didn't appear in meantime (Race Condition)
        SELECT SINGLE @abap_true
          FROM zsalesorder
          WHERE salesorder_id = @lv_new_id
          INTO @DATA(lv_exists_active).

        SELECT SINGLE @abap_true
          FROM zsalesorder_d
          WHERE salesorder_id = @lv_new_id
          INTO @DATA(lv_exists_draft).

        IF lv_exists_active = abap_false AND lv_exists_draft = abap_false.
          lv_found_unique = abap_true.
        ELSE.
          lv_number += 1.
        ENDIF.
      ENDWHILE.

      " Actualization with new number
      MODIFY ENTITIES OF zcds_salesorder IN LOCAL MODE
        ENTITY SalesOrder
          UPDATE FIELDS ( salesorder_id )
          WITH VALUE #( (
              %tky          = <ls_order>-%tky
              salesorder_id = lv_new_id
          ) ).

      lv_number += 1. " Incrementation for next record in the loop
    ENDLOOP.
  ENDMETHOD.







  METHOD validate_mandatory_fields.


    READ ENTITIES OF zcds_salesorder IN LOCAL MODE
   ENTITY SalesOrder
   ALL FIELDS
   WITH CORRESPONDING #( keys )
   RESULT DATA(lt_orders).

    LOOP AT lt_orders INTO DATA(ls_order).

      " customer_id
      IF ls_order-customer_name_salesord IS INITIAL.
        IF ls_order-customer_name IS INITIAL.
          APPEND VALUE #( %tky = ls_order-%tky ) TO failed-SalesOrder.

          APPEND VALUE #( %tky = keys[ 1 ]-%tky
          %msg = new_message(
      severity = if_abap_behv_message=>severity-error
      id       = 'ZMSG'
      number   = '001'
      v1       = 'Customer Name'


        )

       ) TO reported-SalesOrder.

        ENDIF.
      ENDIF.

      "order date

      IF ls_order-order_date IS INITIAL.
        APPEND VALUE #( %tky = ls_order-%tky ) TO failed-SalesOrder.

        APPEND VALUE #( %tky = keys[ 1 ]-%tky
        %msg = new_message(
    severity = if_abap_behv_message=>severity-error
    id       = 'ZMSG'
    number   = '001'
    v1       = 'Order Date'
      )

     ) TO reported-SalesOrder.

      ENDIF.

      "Total price

      IF ls_order-total_price IS INITIAL.
        APPEND VALUE #( %tky = ls_order-%tky ) TO failed-SalesOrder.

        APPEND VALUE #( %tky = keys[ 1 ]-%tky
        %msg = new_message(
    severity = if_abap_behv_message=>severity-error
    id       = 'ZMSG'
    number   = '001'
    v1       = 'Total Price'
      )

     ) TO reported-SalesOrder.

      ENDIF.


      "Status
      IF ls_order-status IS INITIAL.
        APPEND VALUE #( %tky = ls_order-%tky ) TO failed-SalesOrder.

        APPEND VALUE #( %tky = keys[ 1 ]-%tky
        %msg = new_message(
    severity = if_abap_behv_message=>severity-error
    id       = 'ZMSG'
    number   = '001'
    v1       = 'Status'
      )
     ) TO reported-SalesOrder.

      ENDIF.

      IF ls_order-status = 'COMPLETED'.

        "APPEND VALUE #( %tky = ls_order-%tky ) TO failed-SalesOrder.

        APPEND VALUE #( %tky = keys[ 1 ]-%tky
          %msg = new_message(
      severity = if_abap_behv_message=>severity-information
      id       = 'ZMSG'
      number   = '002'
      v1       = 'Status'
        )
       ) TO reported-SalesOrder.

      ENDIF.

      "Description
      IF ls_order-description IS INITIAL.
        APPEND VALUE #( %tky = ls_order-%tky ) TO failed-SalesOrder.

        APPEND VALUE #( %tky = keys[ 1 ]-%tky
        %msg = new_message(
    severity = if_abap_behv_message=>severity-error
    id       = 'ZMSG'
    number   = '001'
    v1       = 'Description'
      )

     ) TO reported-SalesOrder.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.




CLASS lsc_SalesOrder DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS save_modified REDEFINITION.

ENDCLASS.


CLASS lsc_SalesOrder IMPLEMENTATION.

  METHOD save_modified.


    DATA lt_keys TYPE TABLE FOR READ IMPORT zcds_salesorder.

    LOOP AT update-salesorder INTO DATA(ls_update).
      APPEND VALUE #( %key = ls_update-%key ) TO lt_keys.
    ENDLOOP.

    IF lt_keys IS NOT INITIAL.
      READ ENTITIES OF zcds_salesorder IN LOCAL MODE
        ENTITY SalesOrder
        ALL FIELDS WITH lt_keys
        RESULT DATA(lt_sales_orders).

      LOOP AT lt_sales_orders INTO DATA(ls_order).
        IF ls_order-Status = 'COMPLETED'.
          TRY.

              "Exemple Communication with Customer

              DATA(lt_text) = VALUE soli_tab( ( line = |Sales Order nr { ls_order-salesorder_id } has been completed.| ) ).
              DATA(lo_document) = cl_document_bcs=>create_document(
                                    i_type    = 'RAW'
                                    i_text    = lt_text
                                    i_subject = CONV #( |Sales order number  { ls_order-salesorder_id } Closed.| ) ).

*

              DATA(lv_pdf_content) = |Sales Order Details:\r\n| &&
                                     |--------------------\r\n| &&
                                     |Sales Order Number: { ls_order-salesorder_id }\r\n| &&
                                     |Status:        { ls_order-Status }\r\n| &&
                                     |Data:          { sy-datum DATE = USER }\r\n| &&
                                     |Automatically generated by Karol Orlowski Company.|.

              " Conversion to binary
              DATA(lv_pdf_xstring) = cl_bcs_convert=>string_to_xstring(
                                       iv_string = lv_pdf_content ).

              " Conversion to Solix format
              DATA(lt_pdf_hex) = cl_document_bcs=>xstring_to_solix( ip_xstring = lv_pdf_xstring ).

              " Add Sales Order attachment
              lo_document->add_attachment(
                i_attachment_type    = 'TXT'
                i_attachment_subject = CONV #( |Sales Order_{ ls_order-salesorder_id }| )
                i_att_content_hex    = lt_pdf_hex ).



              "Create Invoice Number
              DATA(lv_inv_number) = |INV/{ sy-datum }/{ sy-uzeit }|.

              "Create invoice body
              DATA(lv_inv_str) = |INVOICE NO: { lv_inv_number }\n| &&
                                 |====================================\n| &&
                                 |Date of issue: { sy-datum DATE = USER }\n| &&
                                 |Customer:      { ls_order-customer_name_salesord }\n| &&
                                 |Total Amount:  { ls_order-total_price } $\n\n| &&
                                 |Thank you for your business!|.

              DATA(lv_inv_x)   = cl_bcs_convert=>string_to_xstring( iv_string = lv_inv_str ).
              DATA(lt_inv_hex) = cl_document_bcs=>xstring_to_solix( ip_xstring = lv_inv_x ).

              "Create Invoice attachment
              lo_document->add_attachment(
                i_attachment_type    = 'TXT'
                i_attachment_subject = CONV #( |Invoice_{ lv_inv_number }| )
                i_att_content_hex    = lt_inv_hex ).


              DATA(lo_send_request) = cl_bcs=>create_persistent( ).
              lo_send_request->set_document( lo_document ).



              DATA(lv_mail) = 'example_customer@company.com'.
              DATA(lo_ext_mail) = cl_cam_address_bcs=>create_internet_address( i_address_string = CONV #( lv_mail ) ).
              lo_send_request->add_recipient( lo_ext_mail ).


              lo_send_request->send( i_with_error_screen = abap_false ).

            CATCH cx_bcs INTO DATA(lx_bcs).

          ENDTRY.
        ENDIF.
      ENDLOOP.
    ENDIF.


  ENDMETHOD.
ENDCLASS.
