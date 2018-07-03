class ZCL_ZENIEXTSB_DPC_EXT definition
  public
  inheriting from ZCL_ZENIEXTSB_DPC
  create public .

public section.
protected section.

  constants BASKET_APPROVAL_TASK type IBO_INBOX_TASK_ID value 'TS90000006'. "#EC NOTEXT
  constants APPROVAL_WHOLE_DOCUMENT type /SAPSRM/WF_DECISION_TYPE value '1'. "#EC NOTEXT
  constants STATUS_WAITING type ZENIEXTSBSTATUS value 'WTG'. "#EC NOTEXT
  constants STATUS_REJECTED type ZENIEXTSBSTATUS value 'REG'. "#EC NOTEXT
  constants STATUS_APPROVED type ZENIEXTSBSTATUS value 'APP'. "#EC NOTEXT
  constants LANGUAGE_DEFAULT type SYLANGU value 'E'. "#EC NOTEXT
  constants PARTNER_SUPPLIER type CRMT_PARTNER_FCT value '00000019'. "#EC NOTEXT
  constants PARTNER_SHIPTO type CRMT_PARTNER_FCT value '00000027'. "#EC NOTEXT
  constants CURRENCY_DEFAULT type WAERS value 'EUR'. "#EC NOTEXT
  constants DOMAIN_STATUS type DOMNAME value 'ZENIEXTSBSTATUS'. "#EC NOTEXT
  constants DOMAIN_ACC_DISTRIBUTION type DOMNAME value 'BBP_DIST_IND'. "#EC NOTEXT
  constants ACC_DISTRIBUTION_PERCENTAGE type BBP_DIST_IND value ' '. "#EC NOTEXT
  constants ACC_DISTRIBUTION_QUANTITY type BBP_DIST_IND value 'Q'. "#EC NOTEXT
  constants ACC_DISTRIBUTION_VALUE type BBP_DIST_IND value 'V'. "#EC NOTEXT

  methods APPLY_ENTITYSET_FILTERS
    importing
      value(ORDER) type /IWBEP/T_MGW_SORTING_ORDER
      value(ORDER_DEFAULT) type /IWBEP/T_MGW_SORTING_ORDER
      value(SEARCH_STRING) type STRING
      value(PAGING) type /IWBEP/S_MGW_PAGING
      value(TECH_REQUEST_CONTEXT) type ref to /IWBEP/IF_MGW_REQ_ENTITYSET optional
    changing
      value(ENTITYSET) type STANDARD TABLE .
  class ZCL_ZENIEXTSB_MPC definition load .
  methods BUILD_ADDRESS
    importing
      value(DATA) type ZCL_ZENIEXTSB_MPC=>TS_BASKETITEM
    returning
      value(RESULT) type ALK_STRING .
  methods CONVERT_CURRENCY_VALUE
    importing
      value(EXCHANGE) type KURST_CURR default 'EURX'
      value(DATE) type SYDATUM default SY-DATUM
      value(VALUE_FROM) type /SAPPSSRM/_GROSS_VALUE
      value(CURRENCY_FROM) type WAERS
      value(CURRENCY_TO) type WAERS default 'EUR'
    returning
      value(RESULT) type ZENIEXTSBSTCURRENCYVALUE .
  methods WRITE_OUT
    importing
      value(INPUT) type ANY
    returning
      value(RESULT) type TEXT255 .
  methods TO_BAPI_MESSAGE
    importing
      value(MESSAGE) type ANY
    returning
      value(RESULT) type BAPI_MSG .
  methods ALPHA_OUTPUT
    importing
      value(INPUT) type ANY
    returning
      value(RESULT) type STRING .
  methods RAISE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods GET_WORKITEM_LIST
    importing
      value(KEY_TAB) type /IWBEP/T_MGW_NAME_VALUE_PAIR optional
    returning
      value(RESULT) type IBO_T_WF_FACADE_INBOX_WI
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
  methods PREPARE_ENTITY_SET
    importing
      value(WORKITEMS) type IBO_T_WF_FACADE_INBOX_WI
    returning
      value(RESULT) type ZENIEXTSB_TT .
  methods PREPARE_ITM_ENTITY_SET
    importing
      value(WORKITEMS) type IBO_T_WF_FACADE_INBOX_WI
    returning
      value(RESULT) type ZENIEXTSBITM_TT .
  methods GET_BASKET_DATA
    importing
      value(ENTITYSET) type ZENIEXTSB_TT
    returning
      value(RESULT) type ZENIEXTSBSTDATA .
  methods GET_BASKET_ITEM_DATA
    importing
      value(ENTITYSET) type ZENIEXTSBITM_TT
    returning
      value(RESULT) type ZENIEXTSBITMSTDATA .
  methods GET_BASKET_ITEM_ACC_INFO
    importing
      value(ITEM) type CRMD_ORDERADM_I
      value(DATA) type ZENIEXTSBITMSTDATA
    returning
      value(RESULT) type ZENIEXTSBSTITMACCINFO .
  methods GET_BASKET_ITEM_INFO
    importing
      value(HEADER) type CRMD_ORDERADM_H
      value(DATA) type ZENIEXTSBSTDATA
    returning
      value(RESULT) type ZENIEXTSBSTITMINFO .
  methods BUILD_SEARCH_KEY
    importing
      value(ENTITY) type ZENIEXTSB
      value(DATA) type ZENIEXTSBSTDATA
    returning
      value(RESULT) type ALK_STRING .
  methods GET_BASKET_SUPPLIER_INFO
    importing
      value(HEADER) type CRMD_ORDERADM_H
      value(DATA) type ZENIEXTSBSTDATA
    returning
      value(RESULT) type ZENIEXTSBSTSUPPLIERINFO .
  methods GET_DAYS
    importing
      value(DATA) type ZENIEXTSBSTDATA
    returning
      value(RESULT) type ZENIEXTSBTTDAY .
  methods GET_ITM_DAYS
    importing
      value(DATA) type ZENIEXTSBITMSTDATA
    returning
      value(RESULT) type ZENIEXTSBTTDAY .

  methods BASKETITEMSET_GET_ENTITYSET
    redefinition .
  methods BASKETSET_GET_ENTITY
    redefinition .
  methods BASKETSET_GET_ENTITYSET
    redefinition .
  methods BASKETSET_UPDATE_ENTITY
    redefinition .
  methods USERSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZENIEXTSB_DPC_EXT IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZENIEXTSB_DPC_EXT->ALPHA_OUTPUT
* +-------------------------------------------------------------------------------------------------+
* | [--->] INPUT                          TYPE        ANY
* | [<-()] RESULT                         TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method ALPHA_OUTPUT.

  call function 'CONVERSION_EXIT_ALPHA_OUTPUT'
    exporting
      input  = input
    importing
      output = result.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZENIEXTSB_DPC_EXT->APPLY_ENTITYSET_FILTERS
* +-------------------------------------------------------------------------------------------------+
* | [--->] ORDER                          TYPE        /IWBEP/T_MGW_SORTING_ORDER
* | [--->] ORDER_DEFAULT                  TYPE        /IWBEP/T_MGW_SORTING_ORDER
* | [--->] SEARCH_STRING                  TYPE        STRING
* | [--->] PAGING                         TYPE        /IWBEP/S_MGW_PAGING
* | [--->] TECH_REQUEST_CONTEXT           TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITYSET(optional)
* | [<-->] ENTITYSET                      TYPE        STANDARD TABLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
method apply_entityset_filters.

  data: lv_osql  type string,
        ls_order type /iwbep/s_mgw_sorting_order,
        ls_sort  type abap_sortorder,
        lt_sort  type abap_sortorder_tab.

  try.

*     filter with open sql (instead of using it_filter_select_options or iv_filter_string)
      if tech_request_context is bound.
        clear lv_osql. lv_osql = tech_request_context->get_osql_where_clause( ).
        if not lv_osql is initial.
          translate lv_osql: to upper case, using '_+', using '%*'. replace all occurrences of 'LIKE' in lv_osql with 'CP'. lv_osql = |NOT { lv_osql }|.
          delete entityset where (lv_osql).
        endif.
      endif.

*     sorting
      if not order is initial.
        loop at order into ls_order.
          translate: ls_order-order to upper case, ls_order-property to upper case.
          ls_sort-name = ls_order-property.
          if ls_order-order eq 'DESC'. ls_sort-descending = abap_true. endif.
          append ls_sort to lt_sort.
        endloop.
      else.
        if not order_default is initial.
          loop at order_default into ls_order.
            translate: ls_order-order to upper case, ls_order-property to upper case.
            ls_sort-name = ls_order-property.
            if ls_order-order eq 'DESC'. ls_sort-descending = abap_true. endif.
            append ls_sort to lt_sort.
          endloop.
        endif.
      endif.

      sort entityset by (lt_sort).

*     search string
      if not search_string is initial.                      "#EC NEEDED
*       not supported in odata v2
      endif.

*     paging (last thing to do)
      if not paging-skip is initial. delete entityset to paging-skip. endif.
      if not paging-top is initial. delete entityset from paging-top + 1. endif.

    catch cx_static_check cx_dynamic_check.
      return.
  endtry.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZENIEXTSB_DPC_EXT->BASKETITEMSET_GET_ENTITYSET
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_FILTER_SELECT_OPTIONS       TYPE        /IWBEP/T_MGW_SELECT_OPTION
* | [--->] IS_PAGING                      TYPE        /IWBEP/S_MGW_PAGING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IT_ORDER                       TYPE        /IWBEP/T_MGW_SORTING_ORDER
* | [--->] IV_FILTER_STRING               TYPE        STRING
* | [--->] IV_SEARCH_STRING               TYPE        STRING
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITYSET(optional)
* | [<---] ET_ENTITYSET                   TYPE        ZCL_ZENIEXTSB_MPC=>TT_BASKETITEM
* | [<---] ES_RESPONSE_CONTEXT            TYPE        /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
method basketitemset_get_entityset.

  data: lt_wi          type ibo_t_wf_facade_inbox_wi,
        lt_set         type standard table of zcl_zeniextsb_mpc=>ts_basketitem,
        lt_odf         type /iwbep/t_mgw_sorting_order,
        ls_odf         type /iwbep/s_mgw_sorting_order,
        ls_data        type zeniextsbitmstdata,
        ls_cnt         type t005t,
        ls_reg         type t005u,
        ls_itm         type crmd_orderadm_i,
        ls_igp         type bbp_pdigp,
        ls_set         type zcl_zeniextsb_mpc=>ts_basketitem,
        ls_new         type zcl_zeniextsb_mpc=>ts_basketitem,
        ls_cur         type tcurc,
        ls_cut         type tcurt,
        ls_adr         type adrc,
        ls_uni         type t006,
        ls_but         type but000,
        ls_unt         type t006a,
        ls_sul         type crmd_link,
        ls_sup         type crmd_partner,
        ls_sto         type crmd_partner,
        ls_day         type zeniextsbstday.

* init
  refresh et_entityset. clear: es_response_context.

* get workitems
  lt_wi = me->get_workitem_list( it_key_tab ).
  if lt_wi is initial. return. endif.

* prepare entity set
  et_entityset = me->prepare_itm_entity_set( lt_wi ).
  if et_entityset is initial. return. endif.

* get basket data
  ls_data = me->get_basket_item_data( et_entityset ).

* move
  append lines of et_entityset to lt_set.
  refresh et_entityset.

* map data
  loop at lt_set into ls_set.
    loop at ls_data-items into ls_itm where header eq ls_set-headerguid.
*     clean
      clear: ls_new, ls_igp, ls_cur, ls_cut, ls_uni, ls_unt, ls_sul, ls_sup, ls_but, ls_sto, ls_adr, ls_cnt, ls_reg, ls_day.
*     common data
      ls_new-workitemid = ls_set-workitemid.
      ls_new-headerguid = ls_new-headerguidout = ls_set-guid.
*     get workitem info
      read table: ls_data-purchasing into ls_igp with key guid = ls_itm-guid,
                  ls_data-currencies into ls_cur with key waers = ls_igp-currency,
                  ls_data-currenciestext into ls_cut with key waers = ls_igp-currency spras = sy-langu,
                  ls_data-unit into ls_uni with key msehi = ls_igp-unit,
                  ls_data-unittext into ls_unt with key msehi = ls_igp-unit spras = sy-langu,
                  ls_data-partnerlink into ls_sul with key guid_hi = ls_itm-guid objtype_hi = '06' objtype_set = '07',
                  ls_data-supplierpartner into ls_sup with key guid = ls_sul-guid_set partner_fct = me->partner_supplier,
                  ls_data-partner into ls_but with key partner_guid = ls_sup-partner_no, "#EC WARNOK
                  ls_data-shiptopartner into ls_sto with key guid = ls_sul-guid_set partner_fct = me->partner_shipto,
                  ls_data-shiptoaddresses into ls_adr with key addrnumber = ls_sto-addr_nr date_from = '00010101' nation = '',
                  ls_data-countries into ls_cnt with key land1 = ls_adr-country spras = sy-langu,
                  ls_data-regions into ls_reg with key land1 = ls_adr-country bland = ls_adr-region spras = sy-langu,
                  ls_data-days into ls_day with key date = ls_igp-deliv_date langu = sy-langu.
*     critical
      if ls_igp is initial. continue. endif.
*     language dependent
      if ls_unt is initial.
        read table ls_data-unittext into ls_unt with key msehi = ls_igp-unit spras = me->language_default.
        if sy-subrc ne 0. ls_unt-mseh3 = ls_unt-mseh6 = ls_unt-mseht = ls_unt-msehl = ls_igp-unit. endif.
      endif.
      if ls_cut is initial.
        read table ls_data-currenciestext into ls_cut with key waers = ls_igp-currency spras = me->language_default.
        if sy-subrc ne 0. ls_cut-ktext = ls_cut-ltext = ls_igp-currency. endif.
      endif.
      if ls_cnt is initial.
        read table ls_data-countries into ls_cnt with key land1 = ls_adr-country spras = me->language_default.
        if sy-subrc ne 0. ls_cnt-landx = ls_cnt-landx50 = ls_adr-country. endif.
      endif.
      if ls_reg is initial.
        read table ls_data-regions into ls_reg with key land1 = ls_adr-country bland = ls_adr-region spras = me->language_default.
        if sy-subrc ne 0. ls_reg-bezei = ls_adr-region. endif.
      endif.
      if ls_day is initial.
        read table ls_data-days into ls_day with key date = ls_igp-deliv_date langu = me->language_default.
        if sy-subrc ne 0. ls_day-day_string = me->write_out( ls_igp-deliv_date ). endif.
      endif.
      ls_new-guidout = me->write_out( ls_itm-guid ).
      ls_new-guid = ls_itm-guid.
      ls_new-number = me->alpha_output( ls_itm-number_int ).
      ls_new-product = ls_itm-ordered_prod.
      ls_new-productname = ls_itm-description.
      ls_new-category = ls_igp-category.
      ls_new-categoryid = ls_igp-category.
      ls_new-categoryname = ls_igp-category_id.
      ls_new-price = ls_igp-price.
      ls_new-priceunit = ls_igp-price_unit.
      ls_new-quantity = ls_igp-quantity.
      ls_new-unit = ls_igp-unit.
      ls_new-unitiso = ls_uni-isocode.
      ls_new-unitcommercial = ls_unt-mseh3.
      ls_new-unittechnical = ls_unt-mseh6.
      ls_new-unitshort = ls_unt-mseht.
      ls_new-unitlong = ls_unt-msehl.
      ls_new-value = ls_igp-value.
      ls_new-currency = ls_igp-currency.
      ls_new-currencyiso = ls_cur-isocd.
      ls_new-currencyshort = ls_cut-ktext.
      ls_new-currencylong = ls_cut-ltext.
      ls_new-supplier = me->alpha_output( ls_but-partner ).
      ls_new-suppliername = ls_but-name_org1.
      ls_new-deliverydate = ls_igp-deliv_date.
      ls_new-deliverydateout = ls_day-day_string.
      ls_new-co = ls_adr-name_co.
      ls_new-street = ls_adr-street.
      ls_new-houseno = ls_adr-house_num1.
      ls_new-city = ls_adr-city1.
      ls_new-region = ls_adr-region.
      ls_new-regionname = ls_reg-bezei.
      ls_new-country = ls_adr-country.
      ls_new-countryshort = ls_cnt-landx.
      ls_new-countrylong = ls_cnt-landx50.
      ls_new-zip = ls_adr-post_code1.
      ls_new-address = me->build_address( ls_new ).
      move-corresponding me->get_basket_item_acc_info( item = ls_itm data = ls_data ) to ls_new.
      append ls_new to et_entityset.
    endloop.
  endloop.

* default order
  ls_odf-property = 'NUMBER'. ls_odf-order = 'ASC'. append ls_odf to lt_odf.

* filter result
  me->apply_entityset_filters( exporting order = it_order order_default = lt_odf search_string = iv_search_string paging = is_paging tech_request_context = io_tech_request_context changing entityset = et_entityset ).


endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZENIEXTSB_DPC_EXT->BASKETSET_GET_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IO_REQUEST_OBJECT              TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY(optional)
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY(optional)
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [<---] ER_ENTITY                      TYPE        ZCL_ZENIEXTSB_MPC=>TS_BASKET
* | [<---] ES_RESPONSE_CONTEXT            TYPE        /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITY_CNTXT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
method basketset_get_entity.

  data: lx_root        type ref to cx_root,
        lt_wi          type ibo_t_wf_facade_inbox_wi,
        lt_set         type standard table of zcl_zeniextsb_mpc=>ts_basket,
        ls_wi          type ibo_s_wf_facade_inbox_wi,
        ls_wih         type swwwihead,
        ls_wit         type swwwihead,
        ls_data        type zeniextsbstdata,
        ls_prc         type crmc_proc_type_t,
        ls_hdr         type crmd_orderadm_h,
        ls_cur         type tcurc,
        ls_cut         type tcurt,
        ls_adr         type adrp,
        ls_usr         type usr21,
        ls_day         type zeniextsbstday,
        ls_sts         type dd07v,
        ls_ifo         type zeniextsbstitminfo,
        ls_sfo         type zeniextsbstsupplierinfo,
        lv_mv1         type symsgv,
        lv_msg         type bapi_msg.

* init
  clear: er_entity, es_response_context.

* get workitems
  lt_wi = me->get_workitem_list( it_key_tab ).
  if lt_wi is initial. return. else. read table lt_wi index 1 into ls_wi. endif.

* prepare entity set
  lt_set = me->prepare_entity_set( lt_wi ).
  if lt_set is initial.
    lv_mv1 = me->alpha_output( ls_wi-wi_id ).
    message e002(zenisbext) with lv_mv1 into lv_msg.
    me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( )->add_message_text_only( iv_msg_type = 'E' iv_msg_text = lv_msg iv_add_to_response_header = abap_true ).
    me->raise( ).
  endif.

* get basket data
  ls_data = me->get_basket_data( lt_set ).

  try.
*     get entity
      read table lt_set index 1 into er_entity.
      if sy-subrc ne 0.
        lv_mv1 = me->alpha_output( ls_wi-wi_id ).
        message e002(zenisbext) with lv_mv1 into lv_msg.
        me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( )->add_message_text_only( iv_msg_type = 'E' iv_msg_text = lv_msg iv_add_to_response_header = abap_true ).
        me->raise( ).
      endif.
*     get workitem info
      read table: ls_data-workitem into ls_wih with key wi_id = er_entity-workitemid,
                  ls_data-workflow into ls_wit with key wi_id = ls_wih-top_wi_id,
                  ls_data-header into ls_hdr with key guid = er_entity-guid,
                  ls_data-process into ls_prc with key process_type = ls_hdr-process_type langu = sy-langu,
                  ls_data-user into ls_usr with key bname = ls_wit-wi_creator+2, "#EC WARNOK
                  ls_data-person into ls_adr with key persnumber = ls_usr-persnumber date_from = '00010101' nation = '',
                  ls_data-status into ls_sts with key domname = me->domain_status domvalue_l = me->status_waiting ddlanguage = sy-langu,
                  ls_data-days into ls_day with key date = ls_wit-wi_cd langu = sy-langu.
*     critical check
      if ls_wih is initial or ls_wit is initial or ls_hdr is initial or ls_usr is initial or ls_adr is initial.
        lv_mv1 = me->alpha_output( ls_wi-wi_id ).
        message e002(zenisbext) with lv_mv1 into lv_msg.
        me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( )->add_message_text_only( iv_msg_type = 'E' iv_msg_text = lv_msg iv_add_to_response_header = abap_true ).
        me->raise( ).
      endif.
*     adjust translated info
      if ls_prc is initial.
        read table ls_data-process into ls_prc with key process_type = ls_hdr-process_type langu = me->language_default.
        if sy-subrc ne 0. ls_prc-p_description = ls_prc-p_description_20 = ls_hdr-process_type. endif.
      endif.
*     adjust status
      if ls_sts is initial.
        read table ls_data-status into ls_sts with key domname = me->domain_status domvalue_l = me->status_waiting ddlanguage = me->language_default.
        if sy-subrc ne 0. ls_sts-ddtext = me->status_waiting. endif.
      endif.
*     adjust date
      if ls_day is initial.
        read table ls_data-days into ls_day with key date = ls_wit-wi_cd langu = me->language_default.
        if sy-subrc ne 0. write ls_wit-wi_cd to ls_day-day_string. endif.
      endif.
*     supplier info
      ls_sfo = me->get_basket_supplier_info( header = ls_hdr data = ls_data ).
*     item info
      ls_ifo = me->get_basket_item_info( header = ls_hdr data = ls_data ).
*     currensy info
      read table: ls_data-currencies into ls_cur with key waers = ls_ifo-currency,
                  ls_data-currenciestext into ls_cut with key waers = ls_ifo-currency spras = sy-langu.
*     adjust currency info
      if ls_cur is initial. ls_cur-isocd = ls_ifo-currency. endif.
*     adjust currency text
      if ls_cut is initial.
        read table ls_data-currenciestext into ls_cut with key waers = ls_ifo-currency spras = me->language_default.
        if sy-subrc ne 0. ls_cut-ktext = ls_cut-ltext = ls_ifo-currency. endif.
      endif.
*     assign values
      er_entity-topflowid = ls_wit-wi_id.
      er_entity-number = me->alpha_output( ls_hdr-object_id ).
      er_entity-text = ls_hdr-description.
      er_entity-postedby = ls_wit-wi_creator+2.
      er_entity-postedbyname = ls_adr-name_text.
      er_entity-postingdate = ls_wit-wi_cd.
      er_entity-postingdateout = ls_day-day_string.
      er_entity-flow = ls_hdr-process_type.
      er_entity-flowshort = ls_prc-p_description_20.
      er_entity-flowlong = ls_prc-p_description.
      er_entity-value = ls_ifo-value.
      er_entity-currencymono = ls_ifo-monocurrency.
      er_entity-currency = ls_ifo-currency.
      er_entity-currencyiso = ls_cur-isocd.
      er_entity-currencyshort = ls_cut-ktext.
      er_entity-currencylong = ls_cut-ltext.
      er_entity-status = me->status_waiting.
      er_entity-statusname = ls_sts-ddtext.
      er_entity-items = ls_ifo-itemno.
      er_entity-suppliers = ls_sfo-supplierno.
      er_entity-suppliermono = ls_sfo-mono.
      er_entity-suppliermononame = ls_sfo-monosupname.
      er_entity-searchkey = me->build_search_key( entity = er_entity data = ls_data ).
    catch cx_static_check cx_dynamic_check into lx_root.
      lv_msg = lx_root->get_text( ).
      me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( )->add_message_text_only( iv_msg_type = 'E' iv_msg_text = lv_msg iv_add_to_response_header = abap_true ).
      me->raise( ).
  endtry.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZENIEXTSB_DPC_EXT->BASKETSET_GET_ENTITYSET
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_FILTER_SELECT_OPTIONS       TYPE        /IWBEP/T_MGW_SELECT_OPTION
* | [--->] IS_PAGING                      TYPE        /IWBEP/S_MGW_PAGING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IT_ORDER                       TYPE        /IWBEP/T_MGW_SORTING_ORDER
* | [--->] IV_FILTER_STRING               TYPE        STRING
* | [--->] IV_SEARCH_STRING               TYPE        STRING
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITYSET(optional)
* | [<---] ET_ENTITYSET                   TYPE        ZCL_ZENIEXTSB_MPC=>TT_BASKET
* | [<---] ES_RESPONSE_CONTEXT            TYPE        /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
method basketset_get_entityset.

  data: lt_wi          type ibo_t_wf_facade_inbox_wi,
        lt_odf         type /iwbep/t_mgw_sorting_order,
        ls_odf         type /iwbep/s_mgw_sorting_order,
        ls_wih         type swwwihead,
        ls_wit         type swwwihead,
        ls_data        type zeniextsbstdata,
        ls_prc         type crmc_proc_type_t,
        ls_hdr         type crmd_orderadm_h,
        ls_cur         type tcurc,
        ls_cut         type tcurt,
        ls_adr         type adrp,
        ls_usr         type usr21,
        ls_day         type zeniextsbstday,
        ls_sts         type dd07v,
        ls_ifo         type zeniextsbstitminfo,
        ls_sfo         type zeniextsbstsupplierinfo,
        lv_idx         type sytabix.

  field-symbols: <ls_set> type zcl_zeniextsb_mpc=>ts_basket.

* init
  refresh et_entityset. clear: es_response_context.

* get workitems
  lt_wi = me->get_workitem_list( it_key_tab ).
  if lt_wi is initial. return. endif.

* prepare entity set
  et_entityset = me->prepare_entity_set( lt_wi ).
  if et_entityset is initial. return. endif.

* get basket data
  ls_data = me->get_basket_data( et_entityset ).

* map data
  loop at et_entityset assigning <ls_set>.
    try.
*       line
        lv_idx = sy-tabix.
*       clean
        clear: ls_wih, ls_wit, ls_hdr, ls_prc, ls_usr, ls_adr, ls_ifo, ls_cur, ls_cut, ls_sts, ls_sfo, ls_day.
*       get workitem info
        read table: ls_data-workitem into ls_wih with key wi_id = <ls_set>-workitemid,
                    ls_data-workflow into ls_wit with key wi_id = ls_wih-top_wi_id,
                    ls_data-header into ls_hdr with key guid = <ls_set>-guid,
                    ls_data-process into ls_prc with key process_type = ls_hdr-process_type langu = sy-langu,
                    ls_data-user into ls_usr with key bname = ls_wit-wi_creator+2, "#EC WARNOK
                    ls_data-person into ls_adr with key persnumber = ls_usr-persnumber date_from = '00010101' nation = '',
                    ls_data-status into ls_sts with key domname = me->domain_status domvalue_l = me->status_waiting ddlanguage = sy-langu,
                    ls_data-days into ls_day with key date = ls_wit-wi_cd langu = sy-langu.
*       critical check
        if ls_wih is initial or ls_wit is initial or ls_hdr is initial or ls_usr is initial or ls_adr is initial. delete et_entityset index lv_idx. continue. endif.
*       adjust translated info
        if ls_prc is initial.
          read table ls_data-process into ls_prc with key process_type = ls_hdr-process_type langu = me->language_default.
          if sy-subrc ne 0. ls_prc-p_description = ls_prc-p_description_20 = ls_hdr-process_type. endif.
        endif.
*       adjust status
        if ls_sts is initial.
          read table ls_data-status into ls_sts with key domname = me->domain_status domvalue_l = me->status_waiting ddlanguage = me->language_default.
          if sy-subrc ne 0. ls_sts-ddtext = me->status_waiting. endif.
        endif.
*       adjust date
        if ls_day is initial.
          read table ls_data-days into ls_day with key date = ls_wit-wi_cd langu = me->language_default.
          if sy-subrc ne 0. write ls_wit-wi_cd to ls_day-day_string. endif.
        endif.
*       supplier info
        ls_sfo = me->get_basket_supplier_info( header = ls_hdr data = ls_data ).
*       item info
        ls_ifo = me->get_basket_item_info( header = ls_hdr data = ls_data ).
*       currensy info
        read table: ls_data-currencies into ls_cur with key waers = ls_ifo-currency,
                    ls_data-currenciestext into ls_cut with key waers = ls_ifo-currency spras = sy-langu.
*       adjust currency info
        if ls_cur is initial. ls_cur-isocd = ls_ifo-currency. endif.
*       adjust currency text
        if ls_cut is initial.
          read table ls_data-currenciestext into ls_cut with key waers = ls_ifo-currency spras = me->language_default.
          if sy-subrc ne 0. ls_cut-ktext = ls_cut-ltext = ls_ifo-currency. endif.
        endif.
*       assign values
        <ls_set>-topflowid = ls_wit-wi_id.
        <ls_set>-number = me->alpha_output( ls_hdr-object_id ).
        <ls_set>-text = ls_hdr-description.
        <ls_set>-postedby = ls_wit-wi_creator+2.
        <ls_set>-postedbyname = ls_adr-name_text.
        <ls_set>-postingdate = ls_wit-wi_cd.
        <ls_set>-postingdateout = ls_day-day_string.
        <ls_set>-flow = ls_hdr-process_type.
        <ls_set>-flowshort = ls_prc-p_description_20.
        <ls_set>-flowlong = ls_prc-p_description.
        <ls_set>-value = ls_ifo-value.
        <ls_set>-currencymono = ls_ifo-monocurrency.
        <ls_set>-currency = ls_ifo-currency.
        <ls_set>-currencyiso = ls_cur-isocd.
        <ls_set>-currencyshort = ls_cut-ktext.
        <ls_set>-currencylong = ls_cut-ltext.
        <ls_set>-status = me->status_waiting.
        <ls_set>-statusname = ls_sts-ddtext.
        <ls_set>-items = ls_ifo-itemno.
        <ls_set>-suppliers = ls_sfo-supplierno.
        <ls_set>-suppliermono = ls_sfo-mono.
        <ls_set>-suppliermononame = ls_sfo-monosupname.
        <ls_set>-searchkey = me->build_search_key( entity = <ls_set> data = ls_data ).
      catch cx_static_check cx_dynamic_check.
        delete et_entityset index lv_idx.
        continue.
    endtry.
  endloop.

* default order
  ls_odf-property = 'NUMBER'. ls_odf-order = 'DESC'. append ls_odf to lt_odf.

* filter result
  me->apply_entityset_filters( exporting order = it_order order_default = lt_odf search_string = iv_search_string paging = is_paging tech_request_context = io_tech_request_context changing entityset = et_entityset ).

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZENIEXTSB_DPC_EXT->BASKETSET_UPDATE_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY_U(optional)
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IO_DATA_PROVIDER               TYPE REF TO /IWBEP/IF_MGW_ENTRY_PROVIDER(optional)
* | [<---] ER_ENTITY                      TYPE        ZCL_ZENIEXTSB_MPC=>TS_BASKET
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
method basketset_update_entity.

  data: lx_root type ref to cx_root,
        lo_sc   type ref to /sapsrm/cl_pdo_bo_sc_adv,
        lo_msg  type ref to /sapsrm/if_pdo_msg_consumer,
        lo_cont type ref to if_swf_ifs_parameter_container,
        ls_msg  type bbp_pds_messages,
        lt_msg  type bbpt_pd_messages,
        lt_cv   type swfnamvtab,
        lt_co   type swfnamvtab, "#EC NEEDED
        lt_cs   type swfnamvtab,
        lt_cm   type swft100tab, "#EC NEEDED
        lt_cw   type swft100tab, "#EC NEEDED
        ls_cv   type swaconextv,
        ls_cs   type swaconextv,
        ls_set  type zcl_zeniextsb_mpc=>ts_basket,
        lv_mode type /sapsrm/pdo_inst_mode,
        lv_key  type guid_32,
        lv_ko   type xfeld,
        lv_msg  type bapi_msg.

  try.

*     initialize
      clear: er_entity.

*     get http data
      io_data_provider->read_entry_data( importing es_data = ls_set ).

*     get decision set key & mode
      cl_swf_run_wim_factory=>find_by_wiid( ls_set-workitemid )->get_wi_container( )->to_simple_container( importing ex_container_values = lt_cv ex_container_objects = lt_co ex_container_sibflporbs = lt_cs ex_t_messages = lt_cm ex_t_warnings = lt_cw ).
      read table lt_cv into ls_cv with key element = 'BOMODE'. lv_mode  = ls_cv-value.
      read table lt_cs into ls_cs with key element = 'DECISIONSET'. lv_key = ls_cs-value(32).

*     get cart instance
      lo_sc ?= zcl_stdobjwi=>get_instance( document_type = /sapsrm/if_pdo_obj_types_c=>gc_pdo_shop document_guid = ls_set-guid mode = lv_mode workitem_id = ls_set-workitemid ).

*     perform action
      case ls_set-status.
        when me->status_approved. lo_sc->/sapsrm/if_pdo_adv_base~approve( changing co_message_handler = lo_msg ).
        when me->status_rejected. lo_sc->/sapsrm/if_pdo_adv_base~reject( changing co_message_handler = lo_msg ).
        when others.
          message e003(zenisbext) with ls_set-status into lv_msg.
          me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( )->add_message_text_only( iv_msg_type = 'E' iv_msg_text = lv_msg iv_add_to_response_header = abap_true ).
          me->raise( ).
      endcase.

*     result -> if error exit without closing workitem
      if lo_msg is bound.
        lo_msg->get_messages( importing et_messages = lt_msg ).
        loop at lt_msg into ls_msg where msgty ca 'EA'.
          me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( )->add_message_text_only( iv_msg_type = 'E' iv_msg_text = ls_msg-message iv_add_to_response_header = abap_true ). lv_ko = abap_true.
        endloop.
      endif.

*     errors
      if lv_ko eq abap_true. me->raise( ). endif.

*     prepare event container
      lo_cont = cl_swf_evt_event=>get_event_container( im_objcateg = 'CL' im_objtype = '/SAPSRM/CL_WF_DSET_SBWF' im_event = 'EXECUTED' ).
      lo_cont->set( name = 'MV_AGENT_ID' value = sy-uname ).

*     raise wf event
      cl_swf_evt_event=>raise_in_update_task( im_objcateg = 'CL' im_objtype = '/SAPSRM/CL_WF_DSET_SBWF' im_event = 'EXECUTED' im_objkey = lv_key im_event_container = lo_cont ).

    catch cx_static_check cx_dynamic_check into lx_root.
      lv_msg = lx_root->get_text( ).
      me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( )->add_message_text_only( iv_msg_type = 'E' iv_msg_text = lv_msg iv_add_to_response_header = abap_true ).
      me->raise( ).
  endtry.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZENIEXTSB_DPC_EXT->BUILD_ADDRESS
* +-------------------------------------------------------------------------------------------------+
* | [--->] DATA                           TYPE        ZCL_ZENIEXTSB_MPC=>TS_BASKETITEM
* | [<-()] RESULT                         TYPE        ALK_STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method BUILD_ADDRESS.

  if not data-co is initial. result = |{ data-co } -|. endif.

  if not data-houseno is initial. result = |{ result } { data-houseno },|. endif.

  if not data-street is initial. result = |{ result } { data-street } - |. endif.

  if not data-zip is initial. result = |{ result } { data-zip }|. endif.

  if not data-city is initial. result = |{ result } { data-city }|. endif.

  if not data-regionname is initial. result = |{ result } ({ data-regionname })|. endif.

  if not data-countryshort is initial. result = |{ result } - { data-countryshort }|. endif.

  condense result.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZENIEXTSB_DPC_EXT->BUILD_SEARCH_KEY
* +-------------------------------------------------------------------------------------------------+
* | [--->] ENTITY                         TYPE        ZENIEXTSB
* | [--->] DATA                           TYPE        ZENIEXTSBSTDATA
* | [<-()] RESULT                         TYPE        ALK_STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
method build_search_key.

  data: ls_itm type crmd_orderadm_i,
        ls_igp type bbp_pdigp,
        ls_lnk type crmd_link,
        ls_prn type crmd_partner,
        ls_but type but000,
        ls_cur type tcurc.

* main properties
  result = |{ entity-number }| & | | &
           |{ entity-text }| & | | &
           |{ entity-postedby }| & | | &
           |{ entity-postedbyname }| & | | &
           |{ me->write_out( entity-postingdate ) }| & | | &
           |{ entity-postingdateout }| & | | &
           |{ entity-flow }| & | | &
           |{ entity-flowshort }| & | | &
           |{ entity-flowlong }| & | | &
           |{ entity-currency }| & | | &
           |{ entity-currencyiso }| & | | &
           |{ entity-suppliermononame }|.

  loop at data-items into ls_itm where header eq entity-guid.
*   clean
    clear: ls_lnk, ls_prn, ls_but, ls_igp, ls_cur.
*   item info
    result = |{ result }| & | | &
             |{ ls_itm-ordered_prod }| & | | &
             |{ ls_itm-description }|.
*   purchasing item info
    read table data-purchasing into ls_igp with key guid = ls_itm-guid.
    if sy-subrc eq 0.
      result = |{ result }| & | | &
               |{ ls_igp-category_id }| & | | &
               |{ me->alpha_output( ls_igp-ctr_hdr_number ) }| & | | &
               |{ me->write_out( ls_igp-deliv_date ) }| & | | &
               |{ ls_igp-currency }|.
*     iso currency
      read table data-currencies into ls_cur with key waers = ls_igp-currency.
      if sy-subrc eq 0.
        result = |{ result }| & | | &
                 |{ ls_cur-isocd }|.
      endif.
    endif.
*   suppliers
    read table data-partnerlink into ls_lnk with key guid_hi = ls_itm-guid.
    read table data-supplierpartner into ls_prn with key guid = ls_lnk-guid_set.
    read table data-partner into ls_but with key partner_guid = ls_prn-partner_no. "#EC WARNOK
    if not ls_but is initial.
      result = |{ result }| & | | &
               |{ me->alpha_output( ls_but-partner ) }| & | | &
               |{ ls_but-name_org1 }| & | | &
               |{ ls_but-name_org2 }| & | | &
               |{ ls_but-name_org3 }| & | | &
               |{ ls_but-name_org4 }|.
    endif.
  endloop.

  translate result to upper case.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZENIEXTSB_DPC_EXT->CONVERT_CURRENCY_VALUE
* +-------------------------------------------------------------------------------------------------+
* | [--->] EXCHANGE                       TYPE        KURST_CURR (default ='EURX')
* | [--->] DATE                           TYPE        SYDATUM (default =SY-DATUM)
* | [--->] VALUE_FROM                     TYPE        /SAPPSSRM/_GROSS_VALUE
* | [--->] CURRENCY_FROM                  TYPE        WAERS
* | [--->] CURRENCY_TO                    TYPE        WAERS (default ='EUR')
* | [<-()] RESULT                         TYPE        ZENIEXTSBSTCURRENCYVALUE
* +--------------------------------------------------------------------------------------</SIGNATURE>
method convert_currency_value.

  data: ls_rate   type bapi1093_0,
        ls_return type bapiret1.

  result-currency = currency_to.

  if currency_from eq currency_to. result-value = value_from. return. endif.

  call function 'BAPI_EXCHANGERATE_GETDETAIL'
    exporting
      rate_type  = exchange
      from_curr  = currency_from
      to_currncy = me->currency_default
      date       = sy-datum
    importing
      exch_rate  = ls_rate
      return     = ls_return.

  if ls_return-type ca 'EA'.
    clear: result-currency, result-value.
  endif.

  result-value = value_from * ls_rate-exch_rate.

  if currency_to eq me->currency_default. return. endif.

  clear: ls_rate, ls_return.

  call function 'BAPI_EXCHANGERATE_GETDETAIL'
    exporting
      rate_type  = exchange
      from_curr  = currency_to
      to_currncy = me->currency_default
      date       = sy-datum
    importing
      exch_rate  = ls_rate
      return     = ls_return.

  if ls_return-type ca 'EA'.
    clear: result-currency, result-value.
  endif.

  result-value = value_from * ls_rate-exch_rate_v.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZENIEXTSB_DPC_EXT->GET_BASKET_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] ENTITYSET                      TYPE        ZENIEXTSB_TT
* | [<-()] RESULT                         TYPE        ZENIEXTSBSTDATA
* +--------------------------------------------------------------------------------------</SIGNATURE>
method GET_BASKET_DATA.

  data: lt_uid type standard table of crmt_partner_guid,
        lt_usr type standard table of xubname,
        lt_sts type standard table of dd07v,
        ls_wfl type swwwihead,
        ls_prn type crmd_partner,
        ls_igp type bbp_pdigp.


  if entityset is initial. return. endif.

* get related workflow
  select * from swwwihead into table result-workitem for all entries in entityset where wi_id eq entityset-workitemid.
  if not result-workitem is initial.
    select * from swwwihead into table result-workflow for all entries in result-workitem where wi_id eq result-workitem-top_wi_id.
  endif.

* workflow related
  if not result-workflow is initial.
    loop at result-workflow into ls_wfl. append ls_wfl-wi_creator+2 to lt_usr. endloop. sort lt_usr. delete adjacent duplicates from lt_usr comparing table_line.
    select * from usr21 into table result-user for all entries in lt_usr where bname eq lt_usr-table_line.
  endif.

* get header
  select * from crmd_orderadm_h into table result-header for all entries in entityset where guid eq entityset-guid.

* get header related
  if not result-header is initial.
    select * from: crmd_orderadm_i into table result-items for all entries in result-header where header eq result-header-guid,
                   crmc_proc_type_t into table result-process for all entries in result-header where process_type eq result-header-process_type and ( langu eq sy-langu or langu eq me->language_default ).
  endif.

* get item related
  if not result-items is initial.
    select * from: bbp_pdigp into table result-purchasing for all entries in result-items where guid eq result-items-guid,
                   crmd_link into table result-partnerlink for all entries in result-items where guid_hi eq result-items-guid and objtype_hi eq '06' and objtype_set eq '07'.
    loop at result-purchasing into ls_igp where del_ind eq abap_true. delete result-items where guid eq ls_igp-guid. endloop.
    delete result-purchasing where del_ind eq abap_true.
  endif.

* get purchasing related
  if not result-purchasing is initial.
    select * from: tcurc into table result-currencies for all entries in result-purchasing where waers eq result-purchasing-currency,
                   tcurt into table result-currenciestext for all entries in result-purchasing where waers eq result-purchasing-currency and ( spras eq sy-langu or spras eq me->language_default ).
  endif.

* get link related
  if not result-partnerlink is initial.
    select * from crmd_partner into table result-supplierpartner for all entries in result-partnerlink where guid eq result-partnerlink-guid_set and partner_fct eq me->partner_supplier and disabled ne abap_true.
  endif.

* partner related
  if not result-supplierpartner is initial.
    loop at result-supplierpartner into ls_prn. append ls_prn-partner_no to lt_uid. sort lt_uid. delete adjacent duplicates from lt_uid comparing table_line. endloop.
    select * from but000 appending table result-partner for all entries in lt_uid where partner_guid eq lt_uid-table_line.
  endif.

* user related
  if not result-user is initial.
    select * from adrp into table result-person for all entries in result-user where persnumber eq result-user-persnumber and date_from eq '00010101' and nation eq ''.
  endif.

* status
  call function 'DDIF_DOMA_GET'
    exporting
      name          = me->domain_status
      langu         = sy-langu
    tables
      dd07v_tab     = result-status
    exceptions
      illegal_input = 0
      others        = 0.

  call function 'DDIF_DOMA_GET'
    exporting
      name          = me->domain_status
      langu         = me->language_default
    tables
      dd07v_tab     = lt_sts
    exceptions
      illegal_input = 0
      others        = 0.

  append lines of lt_sts to result-status.

* days
  result-days = me->get_days( result ).

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZENIEXTSB_DPC_EXT->GET_BASKET_ITEM_ACC_INFO
* +-------------------------------------------------------------------------------------------------+
* | [--->] ITEM                           TYPE        CRMD_ORDERADM_I
* | [--->] DATA                           TYPE        ZENIEXTSBITMSTDATA
* | [<-()] RESULT                         TYPE        ZENIEXTSBSTITMACCINFO
* +--------------------------------------------------------------------------------------</SIGNATURE>
method get_basket_item_acc_info.

  data: lt_acc type standard table of bbp_pdacc,
        ls_acc type bbp_pdacc,
        ls_dis type dd07v,
        ls_lnk type crmd_link,
        ls_fld type bbp_c_accf,
        ls_typ type bbp_c_accd.

  field-symbols: <lv_acc> type any.

  read table data-accountinglink into ls_lnk with key guid_hi = item-guid objtype_hi = '06' objtype_set = '31'.
  if sy-subrc ne 0. return. endif.

* get all
  loop at data-accounting into ls_acc where set_guid eq ls_lnk-guid_set. append ls_acc to lt_acc. endloop.

* decide
  if lt_acc is initial. return. endif.
  if lines( lt_acc ) eq 1. result-accountmono = abap_true. endif.

* omogeneus split (percentage, quantity ecc)
  read table lt_acc index 1 into ls_acc.

* pick dominant
  case ls_acc-dist_ind.
    when me->acc_distribution_percentage.
      sort lt_acc by distr_perc descending.
      read table lt_acc index 1 into ls_acc.
      result-accountsplitvalue = ls_acc-distr_perc.
    when me->acc_distribution_quantity.
      sort lt_acc by dist_quan descending.
      read table lt_acc index 1 into ls_acc.
      result-accountsplitvalue = ls_acc-dist_quan.
    when me->acc_distribution_value.
      sort lt_acc by dist_value descending.
      read table lt_acc index 1 into ls_acc.
      result-accountsplitvalue = ls_acc-dist_value.
    when others.
      clear result.
      return.
  endcase.

* codes
  result-account = ls_acc-acc_cat.
  result-accountsplit = ls_acc-dist_ind.

* distribution indicator
  read table data-accountingdistribution into ls_dis with key domname = me->domain_acc_distribution domvalue_l = ls_acc-dist_ind ddlanguage = sy-langu.
  if sy-subrc ne 0.
    read table data-accountingdistribution into ls_dis with key domname = me->domain_acc_distribution domvalue_l = ls_acc-dist_ind ddlanguage = me->language_default.
    if sy-subrc ne 0. ls_dis-ddtext = ls_acc-dist_ind. endif.
  endif.

* account category
  read table data-accountingtypes into ls_typ with key acc_cat = ls_acc-acc_cat langu = sy-langu.
  if sy-subrc ne 0.
    read table data-accountingtypes into ls_typ with key acc_cat = ls_acc-acc_cat langu = me->language_default.
    if sy-subrc ne 0. ls_typ-acccat_d = ls_acc-acc_cat. endif.
  endif.

* set descriptions
  result-accountname = ls_typ-acccat_d.
  result-accountsplitname = ls_dis-ddtext.

* account name
  read table data-accountingfields into ls_fld with key acc_cat = ls_acc-acc_cat.
  if sy-subrc ne 0. return. endif.

* get accounting value depending on customizing field
  assign component ls_fld-acc_field of structure ls_acc to <lv_acc>.
  if sy-subrc ne 0. return. endif.

  result-accountvalue = me->alpha_output( <lv_acc> ).

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZENIEXTSB_DPC_EXT->GET_BASKET_ITEM_DATA
* +-------------------------------------------------------------------------------------------------+
* | [--->] ENTITYSET                      TYPE        ZENIEXTSBITM_TT
* | [<-()] RESULT                         TYPE        ZENIEXTSBITMSTDATA
* +--------------------------------------------------------------------------------------</SIGNATURE>
method get_basket_item_data.

  data: lt_uid type standard table of crmt_partner_guid,
        lt_dis type standard table of dd07v,
        ls_prn type crmd_partner,
        ls_igp type bbp_pdigp.


  if entityset is initial. return. endif.

* get header
  select * from crmd_orderadm_h into table result-header for all entries in entityset where guid eq entityset-headerguid.

* get header related
  if not result-header is initial.
    select * from: crmd_orderadm_i into table result-items for all entries in result-header where header eq result-header-guid.
  endif.

* get item related
  if not result-items is initial.
    select * from: bbp_pdigp into table result-purchasing for all entries in result-items where guid eq result-items-guid,
                   crmd_link into table result-partnerlink for all entries in result-items where guid_hi eq result-items-guid and objtype_hi eq '06' and objtype_set eq '07',
                   crmd_link into table result-accountinglink for all entries in result-items where guid_hi eq result-items-guid and objtype_hi eq '06' and objtype_set eq '31'.
    loop at result-purchasing into ls_igp where del_ind eq abap_true. delete result-items where guid eq ls_igp-guid. endloop.
    delete result-purchasing where del_ind eq abap_true.
  endif.

* get purchasing related
  if not result-purchasing is initial.
    select * from: tcurc into table result-currencies for all entries in result-purchasing where waers eq result-purchasing-currency,
                   tcurt into table result-currenciestext for all entries in result-purchasing where waers eq result-purchasing-currency and ( spras eq sy-langu or spras eq me->language_default ),
                   t006 into table result-unit for all entries in result-purchasing where msehi eq result-purchasing-unit,
                   t006a into table result-unittext for all entries in result-purchasing where msehi eq result-purchasing-unit and ( spras eq sy-langu or spras eq me->language_default ).
  endif.

* get link related
  if not result-partnerlink is initial.
    select * from crmd_partner into table: result-supplierpartner for all entries in result-partnerlink where guid eq result-partnerlink-guid_set and partner_fct eq me->partner_supplier and disabled ne abap_true,
                                           result-shiptopartner for all entries in result-partnerlink where guid eq result-partnerlink-guid_set and partner_fct eq me->partner_shipto and disabled ne abap_true.
  endif.

* accounting related
  if not result-accountinglink is initial.
    select * from bbp_pdacc into table result-accounting for all entries in result-accountinglink where set_guid eq result-accountinglink-guid_set and del_ind ne abap_true.
  endif.

* related accounting
  if not result-accounting is initial.
    select * from: bbp_c_accd into table result-accountingtypes for all entries in result-accounting where acc_cat eq result-accounting-acc_cat and ( langu eq sy-langu or langu eq me->language_default ),
                   bbp_c_accf into table result-accountingfields for all entries in result-accounting where acc_cat eq result-accounting-acc_cat.
*   distribution
    call function 'DDIF_DOMA_GET'
      exporting
        name          = me->domain_acc_distribution
        langu         = sy-langu
      tables
        dd07v_tab     = result-accountingdistribution
      exceptions
        illegal_input = 0
        others        = 0.
    call function 'DDIF_DOMA_GET'
      exporting
        name          = me->domain_acc_distribution
        langu         = me->language_default
      tables
        dd07v_tab     = lt_dis
      exceptions
        illegal_input = 0
        others        = 0.
    append lines of lt_dis to result-accountingdistribution.
  endif.

* partner related
  if not result-supplierpartner is initial.
    loop at result-supplierpartner into ls_prn. append ls_prn-partner_no to lt_uid. endloop. sort lt_uid. delete adjacent duplicates from lt_uid comparing table_line.
    select * from but000 appending table result-partner for all entries in lt_uid where partner_guid eq lt_uid-table_line.
  endif.

* shipto related
  if not result-shiptopartner is initial.
    select * from adrc into table result-shiptoaddresses for all entries in result-shiptopartner where addrnumber eq result-shiptopartner-addr_nr and date_from eq '00010101' and nation eq ''.
  endif.

* address related
  if not result-shiptoaddresses is initial.
    select * from: t005t into table result-countries for all entries in result-shiptoaddresses where land1 eq result-shiptoaddresses-country and ( spras eq sy-langu or spras eq me->language_default ),
                   t005u into table result-regions for all entries in result-shiptoaddresses where bland eq result-shiptoaddresses-region and ( spras eq sy-langu or spras eq me->language_default ).
  endif.

* days
  result-days = me->get_itm_days( result ).

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZENIEXTSB_DPC_EXT->GET_BASKET_ITEM_INFO
* +-------------------------------------------------------------------------------------------------+
* | [--->] HEADER                         TYPE        CRMD_ORDERADM_H
* | [--->] DATA                           TYPE        ZENIEXTSBSTDATA
* | [<-()] RESULT                         TYPE        ZENIEXTSBSTITMINFO
* +--------------------------------------------------------------------------------------</SIGNATURE>
method GET_BASKET_ITEM_INFO.

  data: lt_value type standard table of zeniextsbstvalue,
        ls_value type zeniextsbstvalue,
        ls_itm   type crmd_orderadm_i,
        ls_igp   type bbp_pdigp.

  field-symbols: <ls_value> type zeniextsbstvalue.

* item number
  delete: data-items where header ne header-guid.
  result-itemno = lines( data-items ).

* item value  table
  loop at data-items into ls_itm.
    read table data-purchasing into ls_igp with key guid = ls_itm-guid.
    if sy-subrc ne 0. continue. endif.
    read table lt_value assigning <ls_value> with key currency = ls_igp-currency.
    if sy-subrc ne 0.
      ls_value-currency = ls_igp-currency.
      ls_value-value = ls_value-default_currency_value = ls_igp-value.
      if ls_value-currency ne me->currency_default.
        ls_value-default_currency_value = me->convert_currency_value( value_from = ls_value-value currency_from = ls_value-currency currency_to = me->currency_default )-value.
      endif.
      append ls_value to lt_value.
    else.
      <ls_value>-value = <ls_value>-value + ls_igp-value.
      if <ls_value>-currency ne me->currency_default.
        <ls_value>-default_currency_value = me->convert_currency_value( value_from = <ls_value>-value currency_from = <ls_value>-currency currency_to = me->currency_default )-value.
      endif.
    endif.
  endloop.

* mono currency
  sort lt_value by default_currency_value descending.
  if lines( lt_value ) eq 1. result-monocurrency = abap_true. endif.

* first
  read table lt_value assigning <ls_value> index 1.
  result-value = <ls_value>-value. result-currency = <ls_value>-currency.

* whole in main value
  loop at lt_value into ls_value from 2.
    if ls_value-currency ne <ls_value>-currency.
      ls_value-value = me->convert_currency_value( value_from = ls_value-value currency_from = ls_value-currency currency_to = <ls_value>-currency )-value.
    endif.
    result-value = result-value + ls_value-value.
  endloop.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZENIEXTSB_DPC_EXT->GET_BASKET_SUPPLIER_INFO
* +-------------------------------------------------------------------------------------------------+
* | [--->] HEADER                         TYPE        CRMD_ORDERADM_H
* | [--->] DATA                           TYPE        ZENIEXTSBSTDATA
* | [<-()] RESULT                         TYPE        ZENIEXTSBSTSUPPLIERINFO
* +--------------------------------------------------------------------------------------</SIGNATURE>
method GET_BASKET_SUPPLIER_INFO.

  data: lt_but type standard table of but000,
        ls_itm type crmd_orderadm_i,
        ls_but type but000,
        ls_buz type but000,
        ls_lnk type crmd_link,
        ls_prn type crmd_partner.

* item number
  delete: data-items where header ne header-guid.

  loop at data-items into ls_itm.
    read table data-partnerlink into ls_lnk with key guid_hi = ls_itm-guid.
    if sy-subrc ne 0. continue. endif.
    read table data-supplierpartner into ls_prn with key guid = ls_lnk-guid_set.
    if sy-subrc ne 0. continue. endif.
    read table data-partner into ls_but with key partner_guid = ls_prn-partner_no. "#EC WARNOK
    if sy-subrc ne 0. continue. endif.
    read table lt_but into ls_buz with key partner = ls_but-partner.
    if sy-subrc eq 0. continue. endif.
    append ls_but to lt_but.
  endloop.

  result-supplierno = lines( lt_but ).
  if lines( lt_but ) eq 1.
    result-mono = abap_true.
    read table lt_but into ls_but index 1.
    result-monosupname = |{ ls_but-name_org1 }|.
  endif.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZENIEXTSB_DPC_EXT->GET_DAYS
* +-------------------------------------------------------------------------------------------------+
* | [--->] DATA                           TYPE        ZENIEXTSBSTDATA
* | [<-()] RESULT                         TYPE        ZENIEXTSBTTDAY
* +--------------------------------------------------------------------------------------</SIGNATURE>
method GET_DAYS.

  data: lt_day type standard table of casdayattr,
        ls_out type zeniextsbstday,
        ls_day type casdayattr,
        ls_wfs type swwwihead,
        ls_wfe type swwwihead.

  sort data-workflow by wi_cd ascending.

  read table data-workflow into ls_wfs index 1.
  read table data-workflow into ls_wfe index lines( data-workflow ).

  call function 'DAY_ATTRIBUTES_GET'
    exporting
      date_from                  = ls_wfs-wi_cd
      date_to                    = ls_wfe-wi_cd
    tables
      day_attributes             = lt_day
    exceptions
      factory_calendar_not_found = 0
      holiday_calendar_not_found = 0
      date_has_invalid_format    = 0
      date_inconsistency         = 0
      others                     = 0.

  loop at lt_day into ls_day. ls_out-langu = sy-langu. move-corresponding ls_day to ls_out. append ls_out to result. endloop.

  refresh lt_day.

  call function 'DAY_ATTRIBUTES_GET'
    exporting
      date_from                  = ls_wfs-wi_cd
      date_to                    = ls_wfe-wi_cd
      language                   = me->language_default
    tables
      day_attributes             = lt_day
    exceptions
      factory_calendar_not_found = 0
      holiday_calendar_not_found = 0
      date_has_invalid_format    = 0
      date_inconsistency         = 0
      others                     = 0.

  loop at lt_day into ls_day. ls_out-langu = me->language_default. move-corresponding ls_day to ls_out. append ls_out to result. endloop.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZENIEXTSB_DPC_EXT->GET_ITM_DAYS
* +-------------------------------------------------------------------------------------------------+
* | [--->] DATA                           TYPE        ZENIEXTSBITMSTDATA
* | [<-()] RESULT                         TYPE        ZENIEXTSBTTDAY
* +--------------------------------------------------------------------------------------</SIGNATURE>
method GET_ITM_DAYS.

  data: lt_day type standard table of casdayattr,
        ls_out type zeniextsbstday,
        ls_day type casdayattr,
        ls_dfr type bbp_pdigp,
        ls_dto type bbp_pdigp.

  sort data-purchasing by deliv_date ascending. delete data-purchasing where deliv_date is initial.

  read table data-purchasing into ls_dfr index 1.
  read table data-purchasing into ls_dto index lines( data-purchasing ).

  call function 'DAY_ATTRIBUTES_GET'
    exporting
      date_from                  = ls_dfr-deliv_date
      date_to                    = ls_dto-deliv_date
    tables
      day_attributes             = lt_day
    exceptions
      factory_calendar_not_found = 0
      holiday_calendar_not_found = 0
      date_has_invalid_format    = 0
      date_inconsistency         = 0
      others                     = 0.

  loop at lt_day into ls_day. ls_out-langu = sy-langu. move-corresponding ls_day to ls_out. append ls_out to result. endloop.

  refresh lt_day.

  call function 'DAY_ATTRIBUTES_GET'
    exporting
      date_from                  = ls_dfr-deliv_date
      date_to                    = ls_dto-deliv_date
      language                   = me->language_default
    tables
      day_attributes             = lt_day
    exceptions
      factory_calendar_not_found = 0
      holiday_calendar_not_found = 0
      date_has_invalid_format    = 0
      date_inconsistency         = 0
      others                     = 0.

  loop at lt_day into ls_day. ls_out-langu = me->language_default. move-corresponding ls_day to ls_out. append ls_out to result. endloop.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZENIEXTSB_DPC_EXT->GET_WORKITEM_LIST
* +-------------------------------------------------------------------------------------------------+
* | [--->] KEY_TAB                        TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR(optional)
* | [<-()] RESULT                         TYPE        IBO_T_WF_FACADE_INBOX_WI
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
method get_workitem_list.

  data: lt_task_filter type ibo_t_inbox_task_id,
        ls_key         type /iwbep/s_mgw_name_value_pair,
        lv_msg         type bapi_msg,
        lv_mv1         type symsgv.

  try.
*     get workitem list
      append me->basket_approval_task to lt_task_filter.
      cl_ibo_wf_inbox_facade=>get_workitem_list( exporting iv_user = sy-uname iv_passive_substitution = space it_task_filter = lt_task_filter importing et_work_item = result ).
    catch cx_static_check cx_dynamic_check.
      return.
  endtry.

* check keytab (only one field)
  if not key_tab is initial.
*   provided but no key -> not found
    read table key_tab index 1 into ls_key.
*   purge
    delete result where wi_id ne ls_key-value.
*   check
    if not lines( result ) eq 1.
      lv_mv1 = me->alpha_output( ls_key-value ).
      message e001(zenisbext) with lv_mv1 into lv_msg.
      me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( )->add_message_text_only( iv_msg_type = 'E' iv_msg_text = lv_msg iv_add_to_response_header = abap_true ).
      me->raise( ).
    endif.
  endif.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZENIEXTSB_DPC_EXT->PREPARE_ENTITY_SET
* +-------------------------------------------------------------------------------------------------+
* | [--->] WORKITEMS                      TYPE        IBO_T_WF_FACADE_INBOX_WI
* | [<-()] RESULT                         TYPE        ZENIEXTSB_TT
* +--------------------------------------------------------------------------------------</SIGNATURE>
method PREPARE_ENTITY_SET.

  data: lx_cnt  type ref to cx_swf_cnt_container,
        ls_wi   type ibo_s_wf_facade_inbox_wi,
        ls_set  type zcl_zeniextsb_mpc=>ts_basket,
        ##needed
        lv_uni         type setst_type_any.

  loop at workitems into ls_wi.
    try.
*       clean
        clear: ls_set.
*       set workitem id
        ls_set-workitemid = ls_wi-wi_id.
*       get cart guid
        cl_swf_run_wim_factory=>find_by_wiid( ls_wi-wi_id )->get_wi_container( )->if_swf_cnt_element_access_1~element_get_value( exporting name = 'BOID' importing value = ls_set-guid unit = lv_uni exception_return = lx_cnt ).
*       handle exception error
        if lx_cnt is bound or ls_set-guid is initial. continue. endif.
*       cast gui
        ls_set-guidout = ls_set-guid.
*       add to list
        append: ls_set to result.
      catch cx_static_check cx_dynamic_check.
        continue.
    endtry.
  endloop.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZENIEXTSB_DPC_EXT->PREPARE_ITM_ENTITY_SET
* +-------------------------------------------------------------------------------------------------+
* | [--->] WORKITEMS                      TYPE        IBO_T_WF_FACADE_INBOX_WI
* | [<-()] RESULT                         TYPE        ZENIEXTSBITM_TT
* +--------------------------------------------------------------------------------------</SIGNATURE>
method PREPARE_ITM_ENTITY_SET.

  data: lx_cnt  type ref to cx_swf_cnt_container,
        ls_wi   type ibo_s_wf_facade_inbox_wi,
        ls_set  type zcl_zeniextsb_mpc=>ts_basketitem,
        ##needed
        lv_uni         type setst_type_any.

  loop at workitems into ls_wi.
    try.
*       clean
        clear: ls_set.
*       set workitem id
        ls_set-workitemid = ls_wi-wi_id.
*       get cart guid
        cl_swf_run_wim_factory=>find_by_wiid( ls_wi-wi_id )->get_wi_container( )->if_swf_cnt_element_access_1~element_get_value( exporting name = 'BOID' importing value = ls_set-headerguid unit = lv_uni exception_return = lx_cnt ).
*       handle exception error
        if lx_cnt is bound or ls_set-headerguid is initial. continue. endif.
*       cast gui
        ls_set-headerguidout = ls_set-headerguid.
*       add to list
        append: ls_set to result.
      catch cx_static_check cx_dynamic_check.
        continue.
    endtry.
  endloop.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZENIEXTSB_DPC_EXT->RAISE
* +-------------------------------------------------------------------------------------------------+
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
method RAISE.

  raise exception type /iwbep/cx_mgw_busi_exception
    exporting
      message_container = me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( ).

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZENIEXTSB_DPC_EXT->TO_BAPI_MESSAGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] MESSAGE                        TYPE        ANY
* | [<-()] RESULT                         TYPE        BAPI_MSG
* +--------------------------------------------------------------------------------------</SIGNATURE>
method TO_BAPI_MESSAGE.

  result = message.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZENIEXTSB_DPC_EXT->USERSET_GET_ENTITYSET
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_FILTER_SELECT_OPTIONS       TYPE        /IWBEP/T_MGW_SELECT_OPTION
* | [--->] IS_PAGING                      TYPE        /IWBEP/S_MGW_PAGING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IT_ORDER                       TYPE        /IWBEP/T_MGW_SORTING_ORDER
* | [--->] IV_FILTER_STRING               TYPE        STRING
* | [--->] IV_SEARCH_STRING               TYPE        STRING
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITYSET(optional)
* | [<---] ET_ENTITYSET                   TYPE        ZCL_ZENIEXTSB_MPC=>TT_USER
* | [<---] ES_RESPONSE_CONTEXT            TYPE        /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
method userset_get_entityset.

  data: lt_wi  type ibo_t_wf_facade_inbox_wi,
        lt_wfl type standard table of swwwihead,
        lt_tsk type standard table of swwwihead,
        lt_adp type standard table of adrp,
        lt_usr type standard table of usr21,
        ls_usr type usr21,
        ls_adp type adrp,
        ls_set type zcl_zeniextsb_mpc=>ts_user,
        ls_wfl type swwwihead.

  field-symbols: <ls_set> type zcl_zeniextsb_mpc=>ts_user.

* init
  refresh et_entityset. clear: es_response_context.

* get workitems
  lt_wi = me->get_workitem_list( it_key_tab ).
  if lt_wi is initial. return. endif.

* get related workflow
  select * from swwwihead into table lt_tsk for all entries in lt_wi where wi_id eq lt_wi-wi_id.
  if not lt_tsk is initial.
    select * from swwwihead into table lt_wfl for all entries in lt_tsk where wi_id eq lt_tsk-top_wi_id.
  endif.

* workflow related
  if not lt_wfl is initial.
    loop at lt_wfl into ls_wfl. ls_set-userid = ls_wfl-wi_creator+2. append ls_set to et_entityset. endloop.
    sort et_entityset. delete adjacent duplicates from et_entityset comparing userid.
    select * from usr21 into table lt_usr for all entries in et_entityset where bname eq et_entityset-userid.
  endif.

* get usernames
  if not lt_usr is initial.
    select * from adrp into table lt_adp for all entries in lt_usr where persnumber eq lt_usr-persnumber and date_from eq '00010101' and nation eq ''.
  endif.

* map
  loop at et_entityset assigning <ls_set>.
    read table lt_usr into ls_usr with key bname = <ls_set>-userid.
    if sy-subrc ne 0. <ls_set>-username = <ls_set>-userid. continue. endif.
    read table lt_adp into ls_adp with key persnumber = ls_usr-persnumber date_from = '00010101' nation = ''.
    if sy-subrc ne 0. <ls_set>-username = <ls_set>-userid. continue. endif.
    <ls_set>-username = ls_adp-name_text.
  endloop.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZENIEXTSB_DPC_EXT->WRITE_OUT
* +-------------------------------------------------------------------------------------------------+
* | [--->] INPUT                          TYPE        ANY
* | [<-()] RESULT                         TYPE        TEXT255
* +--------------------------------------------------------------------------------------</SIGNATURE>
method write_out.

  ##WRITE_MOVE
  write input to result.
  condense result.

endmethod.
ENDCLASS.