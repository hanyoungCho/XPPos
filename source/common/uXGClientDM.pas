(*******************************************************************************
  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 데이터 모듈
  Author      : Lee, Sun-Woo
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2019-05-10   Initial Release.
  CopyrightⓒSolbiPOS Co., Ltd. 2008-2019 All rights reserved.
*******************************************************************************)
{$M+}
unit uXGClientDM;
interface
uses
  { Native }
  SysUtils, Classes, Messages, Windows, DB, DBClient, ImgList, Controls, ImageList, Graphics, Types,
  { UniDAC }
  Uni, UniProvider, MySQLUniProvider, DBAccess, MemDS, MemData,
  { Absolute Database }
  ABSMain,
  { DevExpress }
  cxGraphics, dxGDIPlusClasses, cxStyles, cxClasses, cxImageList, dxmdaset, cxGridTableView,
  cxGridDBTableView, cxGridDBBandedTableView,
  { Indy }
  IdHTTP, IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze,
  { XGPOS Common }
  uXGGlobal,
  { Solbi VCL }
  XQuery;
{$I XGCommon.inc}
{$I XGPOS.inc}
const
  CDS_RECEIPT  = 'TBReceipt';
  CDS_SALEITEM = 'TBSaleItem';
  CDS_PAYMENT  = 'TBPayment';
  CDS_COUPON   = 'TBCoupon';
type
  TIdHTTPAccess = class(TIdHTTP)
  end;
  TClientDM = class(TDataModule)
    adbLocal: TABSDatabase;
    conParking: TUniConnection;
    conTeeBox: TUniConnection;
    MySQLUniProvider: TMySQLUniProvider;
    csrGridStyle: TcxStyleRepository;
    DSCoupon: TDataSource;
    DSPayment: TDataSource;
    DSReceipt: TDataSource;
    DSSaleItem: TDataSource;
    imlGridArrow: TcxImageList;
    MDCodeGroup: TdxMemData;
    MDCodeGroupgroup_cd: TStringField;
    MDCodeGroupgroup_nm: TStringField;
    MDCodeGroupsort_order: TIntegerField;
    MDCodeItems: TdxMemData;
    MDCodeItemscode: TStringField;
    MDCodeItemscode_nm: TStringField;
    MDCodeItemsgroup_cd: TStringField;
    MDCodeItemsmemo: TStringField;
    MDCodeItemssort_ord: TIntegerField;
    MDLocker: TdxMemData;
    MDLockerfloor_cd: TStringField;
    MDLockerfloor_nm: TStringField;
    MDLockerlocker_nm: TStringField;
    MDLockerlocker_no: TIntegerField;
    MDLockersex_div: TShortintField;
    MDLockerStatus: TdxMemData;
    MDLockerStatusdc_amt: TIntegerField;
    MDLockerStatusend_day: TStringField;
    MDLockerStatushp_no: TStringField;
    MDLockerStatuskeep_amt: TIntegerField;
    MDLockerStatuslocker_no: TIntegerField;
    MDLockerStatusmember_nm: TStringField;
    MDLockerStatusmember_no: TStringField;
    MDLockerStatusmemo: TStringField;
    MDLockerStatusproduct_cd: TStringField;
    MDLockerStatuspurchase_amt: TIntegerField;
    MDLockerStatuspurchase_month: TIntegerField;
    MDLockerStatussale_date: TStringField;
    MDLockerStatusseat_product_nm: TStringField;
    MDLockerStatusstart_day: TStringField;
    MDLockerStatususer_nm: TStringField;
    MDLockerStatususe_div: TIntegerField;
    MDLockerStatususe_yn: TBooleanField;
    MDLockeruse_div: TIntegerField;
    MDLockeruse_yn: TBooleanField;
    MDLockerzone_cd: TStringField;
    MDMember: TdxMemData;
    MDMemberaddress: TStringField;
    MDMemberaddress_desc: TStringField;
    MDMemberbirth_ymd: TStringField;
    MDMembercalc_sex_div: TStringField;
    MDMembercar_no: TStringField;
    MDMembercustomer_cd: TStringField;
    MDMemberdc_rate: TIntegerField;
    MDMemberemail: TStringField;
    MDMemberfingerprint1: TStringField;
    MDMemberfingerprint2: TStringField;
    MDMembergroup_cd: TStringField;
    MDMemberhp_no: TStringField;
    MDMemberlocker_list: TStringField;
    MDMemberlocker_nm: TStringField;
    MDMemberlocker_no: TIntegerField;
    MDMembermember_nm: TStringField;
    MDMembermember_no: TStringField;
    MDMembermember_point: TIntegerField;
    MDMembermember_seq: TIntegerField;
    MDMembermemo: TStringField;
    MDMemberphoto: TBlobField;
    MDMemberqr_cd: TStringField;
    MDMemberSearch: TdxMemData;
    MDMemberSearchaddress: TStringField;
    MDMemberSearchaddress_desc: TStringField;
    MDMemberSearchbirth_ymd: TStringField;
    MDMemberSearchcar_no: TStringField;
    MDMemberSearchcustomer_cd: TStringField;
    MDMemberSearchdc_rate: TIntegerField;
    MDMemberSearchemail: TStringField;
    MDMemberSearchfingerprint1: TStringField;
    MDMemberSearchfingerprint2: TStringField;
    MDMemberSearchgroup_cd: TStringField;
    MDMemberSearchhp_no: TStringField;
    MDMemberSearchlocker_nm: TStringField;
    MDMemberSearchlocker_no: TIntegerField;
    MDMemberSearchmember_list: TStringField;
    MDMemberSearchmember_nm: TStringField;
    MDMemberSearchmember_no: TStringField;
    MDMemberSearchmember_point: TIntegerField;
    MDMemberSearchmember_seq: TIntegerField;
    MDMemberSearchmemo: TStringField;
    MDMemberSearchphoto: TBlobField;
    MDMemberSearchqr_cd: TStringField;
    MDMemberSearchsex_div: TIntegerField;
    MDMemberSearchsex_div_desc: TStringField;
    MDMemberSearchwelfare_cd: TStringField;
    MDMemberSearchxg_user_key: TStringField;
    MDMemberSearchzip_no: TStringField;
    MDMembersex_div: TIntegerField;
    MDMemberwelfare_cd: TStringField;
    MDMemberxg_user_key: TStringField;
    MDMemberzip_no: TStringField;
    MDProdGeneral: TdxMemData;
    MDProdGeneralbarcode: TStringField;
    MDProdGeneralclass_cd: TStringField;
    MDProdGeneralmemo: TStringField;
    MDProdGeneralphoto: TBlobField;
    MDProdGeneralproduct_amt: TIntegerField;
    MDProdGeneralproduct_cd: TStringField;
    MDProdGeneralproduct_nm: TStringField;
    MDProdGeneraltax_type: TShortintField;
    MDProdLocker: TdxMemData;
    MDProdLockerkeep_amt: TIntegerField;
    MDProdLockermemo: TStringField;
    MDProdLockerproduct_amt: TIntegerField;
    MDProdLockerproduct_cd: TStringField;
    MDProdLockerproduct_div: TStringField;
    MDProdLockerproduct_nm: TStringField;
    MDProdLockerrefund_yn: TBooleanField;
    MDProdLockersex_div: TShortintField;
    MDProdLockeruse_month: TIntegerField;
    MDProdLockerzone_cd: TStringField;
    MDProdTeeBox: TdxMemData;
    MDProdTeeBoxcalc_sex_div: TStringField;
    MDProdTeeBoxcalc_zone_cd: TStringField;
    MDProdTeeBoxend_time: TStringField;
    MDProdTeeBoxexpire_day: TIntegerField;
    MDProdTeeBoxFiltered: TdxMemData;
    MDProdTeeBoxFilteredcalc_sex_div: TStringField;
    MDProdTeeBoxFilteredcalc_zone_cd: TStringField;
    MDProdTeeBoxFilteredend_time: TStringField;
    MDProdTeeBoxFilteredexpire_day: TIntegerField;
    MDProdTeeBoxFilteredmemo: TStringField;
    MDProdTeeBoxFilteredone_use_cnt: TIntegerField;
    MDProdTeeBoxFilteredone_use_time: TIntegerField;
    MDProdTeeBoxFilteredproduct_amt: TIntegerField;
    MDProdTeeBoxFilteredproduct_cd: TStringField;
    MDProdTeeBoxFilteredproduct_div: TStringField;
    MDProdTeeBoxFilteredproduct_nm: TStringField;
    MDProdTeeBoxFilteredrefund_yn: TBooleanField;
    MDProdTeeBoxFilteredsex_div: TIntegerField;
    MDProdTeeBoxFilteredstart_time: TStringField;
    MDProdTeeBoxFilteredtoday_yn: TBooleanField;
    MDProdTeeBoxFiltereduse_cnt: TIntegerField;
    MDProdTeeBoxFiltereduse_div: TStringField;
    MDProdTeeBoxFiltereduse_month: TIntegerField;
    MDProdTeeBoxFilteredxgolf_dc_amt: TIntegerField;
    MDProdTeeBoxFilteredxgolf_dc_yn: TBooleanField;
    MDProdTeeBoxFilteredxgolf_product_amt: TIntegerField;
    MDProdTeeBoxFilteredzone_cd: TStringField;
    MDProdTeeBoxmemo: TStringField;
    MDProdTeeBoxone_use_cnt: TIntegerField;
    MDProdTeeBoxons_use_time: TIntegerField;
    MDProdTeeBoxproduct_amt: TIntegerField;
    MDProdTeeBoxproduct_cd: TStringField;
    MDProdTeeBoxproduct_div: TStringField;
    MDProdTeeBoxproduct_nm: TStringField;
    MDProdTeeBoxrefund_yn: TBooleanField;
    MDProdTeeBoxsex: TIntegerField;
    MDProdTeeBoxstart_time: TStringField;
    MDProdTeeBoxtoday_yn: TBooleanField;
    MDProdTeeBoxuse_cnt: TIntegerField;
    MDProdTeeBoxuse_div: TStringField;
    MDProdTeeBoxuse_month: TIntegerField;
    MDProdTeeBoxxgolf_dc_amt: TIntegerField;
    MDProdTeeBoxxgolf_dc_yn: TBooleanField;
    MDProdTeeBoxxgolf_product_amt: TIntegerField;
    MDProdTeeBoxzone_cd: TStringField;
    MDTeeBox: TdxMemData;
    MDTeeBoxdevice_id: TStringField;
    MDTeeBoxfloor_cd: TStringField;
    MDTeeBoxfloor_nm: TStringField;
    MDTeeBoxIssued2: TdxMemData;
    MDTeeBoxIssued2assign_time: TIntegerField;
    MDTeeBoxIssued2coupon_cnt: TIntegerField;
    MDTeeBoxIssued2expire_day: TStringField;
    MDTeeBoxIssued2floor_nm: TStringField;
    MDTeeBoxIssued2product_cd: TStringField;
    MDTeeBoxIssued2product_div: TStringField;
    MDTeeBoxIssued2product_nm: TStringField;
    MDTeeBoxIssued2reserve_no: TStringField;
    MDTeeBoxIssued2start_datetime: TStringField;
    MDTeeBoxIssued2teebox_nm: TStringField;
    MDTeeBoxIssued2use_cnt: TIntegerField;
    MDTeeBoxIssued: TdxMemData;
    MDTeeBoxIssuedassign_time: TIntegerField;
    MDTeeBoxIssuedcoupon_cnt: TIntegerField;
    MDTeeBoxIssuedexpire_day: TStringField;
    MDTeeBoxIssuedfloor_nm: TStringField;
    MDTeeBoxIssuedproduct_cd: TStringField;
    MDTeeBoxIssuedproduct_div: TStringField;
    MDTeeBoxIssuedproduct_nm: TStringField;
    MDTeeBoxIssuedreserve_no: TStringField;
    MDTeeBoxIssuedstart_datetime: TStringField;
    MDTeeBoxIssuedteebox_nm: TStringField;
    MDTeeBoxIssueduse_qty: TIntegerField;
    MDTeeBoxProdMember: TdxMemData;
    MDTeeBoxProdMembercalc_product_div: TStringField;
    MDTeeBoxProdMembercoupon_cnt: TIntegerField;
    MDTeeBoxProdMemberday_end_time: TStringField;
    MDTeeBoxProdMemberday_start_time: TStringField;
    MDTeeBoxProdMemberend_day: TStringField;
    MDTeeBoxProdMemberexpire_day: TStringField;
    MDTeeBoxProdMemberone_use_cnt: TIntegerField;
    MDTeeBoxProdMemberone_use_time: TIntegerField;
    MDTeeBoxProdMemberproduct_amt: TIntegerField;
    MDTeeBoxProdMemberproduct_cd: TStringField;
    MDTeeBoxProdMemberproduct_div: TStringField;
    MDTeeBoxProdMemberproduct_nm: TStringField;
    MDTeeBoxProdMemberpurchase_cd: TStringField;
    MDTeeBoxProdMemberremain_cnt: TIntegerField;
    MDTeeBoxProdMemberstart_day: TStringField;
    MDTeeBoxProdMemberteeboxUsedItemList: TStringField;
    MDTeeBoxProdMembertoday_yn: TBooleanField;
    MDTeeBoxProdMemberzone_cd: TStringField;
    MDTeeBoxReserved2: TdxMemData;
    MDTeeBoxReserved2affiliate_cd: TStringField;
    MDTeeBoxReserved2assign_balls: TIntegerField;
    MDTeeBoxReserved2assign_nm: TIntegerField;
    MDTeeBoxReserved2assign_yn: TBooleanField;
    MDTeeBoxReserved2calc_play_yn: TStringField;
    MDTeeBoxReserved2calc_remain_min: TIntegerField;
    MDTeeBoxReserved2calc_reserve_div: TStringField;
    MDTeeBoxReserved2calc_reserve_root_div: TStringField;
    MDTeeBoxReserved2coupon_cnt: TIntegerField;
    MDTeeBoxReserved2end_datetime: TStringField;
    MDTeeBoxReserved2floor_cd: TStringField;
    MDTeeBoxReserved2hp_no: TStringField;
    MDTeeBoxReserved2member_nm: TStringField;
    MDTeeBoxReserved2member_no: TStringField;
    MDTeeBoxReserved2memo: TStringField;
    MDTeeBoxReserved2play_yn: TBooleanField;
    MDTeeBoxReserved2prepare_min: TIntegerField;
    MDTeeBoxReserved2product_cd: TStringField;
    MDTeeBoxReserved2product_nm: TStringField;
    MDTeeBoxReserved2purchase_cd: TStringField;
    MDTeeBoxReserved2receipt_no: TStringField;
    MDTeeBoxReserved2reserve_div: TStringField;
    MDTeeBoxReserved2reserve_no: TStringField;
    MDTeeBoxReserved2reserve_root_div: TStringField;
    MDTeeBoxReserved2reserve_datetime: TStringField;
    MDTeeBoxReserved2start_datetime: TStringField;
    MDTeeBoxReserved2teebox_nm: TStringField;
    MDTeeBoxReserved2teebox_no: TIntegerField;
    MDTeeBoxReserved2use_seq: TIntegerField;
    MDTeeBoxReserved: TdxMemData;
    MDTeeBoxReservedaffiliate_cd: TStringField;
    MDTeeBoxReservedassign_balls: TIntegerField;
    MDTeeBoxReservedassign_nm: TIntegerField;
    MDTeeBoxReservedassign_yn: TBooleanField;
    MDTeeBoxReservedcalc_play_yn: TStringField;
    MDTeeBoxReservedcalc_remain_min: TIntegerField;
    MDTeeBoxReservedcalc_reserve_div: TStringField;
    MDTeeBoxReservedcalc_reserve_root_div: TStringField;
    MDTeeBoxReservedcoupon_cnt: TIntegerField;
    MDTeeBoxReservedend_datetime: TStringField;
    MDTeeBoxReservedfloor_cd: TStringField;
    MDTeeBoxReservedhp_no: TStringField;
    MDTeeBoxReservedmember_nm: TStringField;
    MDTeeBoxReservedmember_no: TStringField;
    MDTeeBoxReservedmemo: TStringField;
    MDTeeBoxReservedpurchase_cd: TStringField;
    MDTeeBoxReservedplay_yn: TBooleanField;
    MDTeeBoxReservedprepare_min: TIntegerField;
    MDTeeBoxReservedproduct_cd: TStringField;
    MDTeeBoxReservedproduct_nm: TStringField;
    MDTeeBoxReservedreceipt_no: TStringField;
    MDTeeBoxReservedreserve_div: TStringField;
    MDTeeBoxReservedreserve_no: TStringField;
    MDTeeBoxReservedreserve_root_div: TStringField;
    MDTeeBoxReservedreserve_datetime: TStringField;
    MDTeeBoxReservedstart_datetime: TStringField;
    MDTeeBoxReservedteebox_nm: TStringField;
    MDTeeBoxReservedteebox_no: TIntegerField;
    MDTeeBoxReserveduse_seq: TIntegerField;
    MDTeeBoxSelected: TdxMemData;
    MDTeeBoxSelectedassign_balls: TIntegerField;
    MDTeeBoxSelectedassign_min: TIntegerField;
    MDTeeBoxSelectedfloor_cd: TStringField;
    MDTeeBoxSelectedhold_datetime: TStringField;
    MDTeeBoxSelectedprepare_min: TIntegerField;
    MDTeeBoxSelectedproduct_cd: TStringField;
    MDTeeBoxSelectedpurchase_cd: TStringField;
    MDTeeBoxSelectedTeeBoxIndex: TIntegerField;
    MDTeeBoxSelectedteebox_div: TStringField;
    MDTeeBoxSelectedteebox_nm: TStringField;
    MDTeeBoxSelectedteebox_no: TIntegerField;
    MDTeeBoxSelectedvip_cnt: TIntegerField;
    MDTeeBoxSelectedvip_div: TStringField;
    MDTeeBoxStatus2: TdxMemData;
    MDTeeBoxStatus2end_datetime: TStringField;
    MDTeeBoxStatus2heat_status: TIntegerField;
    MDTeeBoxStatus2hp_no: TStringField;
    MDTeeBoxStatus2member_nm: TStringField;
    MDTeeBoxStatus2member_no: TStringField;
    MDTeeBoxStatus2memo: TStringField;
    MDTeeBoxStatus2remain_balls: TIntegerField;
    MDTeeBoxStatus2remain_min: TIntegerField;
    MDTeeBoxStatus2reserved_count: TIntegerField;
    MDTeeBoxStatus2reserve_div: TStringField;
    MDTeeBoxStatus2reserve_no: TStringField;
    MDTeeBoxStatus2reserve_datetime: TStringField;
    MDTeeBoxStatus2start_datetime: TStringField;
    MDTeeBoxStatus2teebox_no: TIntegerField;
    MDTeeBoxStatus2use_status: TIntegerField;
    MDTeeBoxStatus3: TdxMemData;
    MDTeeBoxStatus3end_datetime: TStringField;
    MDTeeBoxStatus3heat_status: TIntegerField;
    MDTeeBoxStatus3hp_no: TStringField;
    MDTeeBoxStatus3member_nm: TStringField;
    MDTeeBoxStatus3member_no: TStringField;
    MDTeeBoxStatus3memo: TStringField;
    MDTeeBoxStatus3remain_balls: TIntegerField;
    MDTeeBoxStatus3remain_min: TIntegerField;
    MDTeeBoxStatus3reserved_count: TIntegerField;
    MDTeeBoxStatus3reserve_div: TStringField;
    MDTeeBoxStatus3reserve_no: TStringField;
    MDTeeBoxStatus3reserve_datetime: TStringField;
    MDTeeBoxStatus3start_datetime: TStringField;
    MDTeeBoxStatus3teebox_no: TIntegerField;
    MDTeeBoxStatus3use_status: TIntegerField;
    MDTeeBoxStatus4: TdxMemData;
    MDTeeBoxStatus4end_datetime: TStringField;
    MDTeeBoxStatus4heat_status: TIntegerField;
    MDTeeBoxStatus4hp_no: TStringField;
    MDTeeBoxStatus4member_nm: TStringField;
    MDTeeBoxStatus4member_no: TStringField;
    MDTeeBoxStatus4memo: TStringField;
    MDTeeBoxStatus4remain_balls: TIntegerField;
    MDTeeBoxStatus4remain_min: TIntegerField;
    MDTeeBoxStatus4reserved_count: TIntegerField;
    MDTeeBoxStatus4reserve_div: TStringField;
    MDTeeBoxStatus4reserve_no: TStringField;
    MDTeeBoxStatus4reserve_datetime: TStringField;
    MDTeeBoxStatus4start_datetime: TStringField;
    MDTeeBoxStatus4teebox_no: TIntegerField;
    MDTeeBoxStatus4use_staus: TIntegerField;
    MDTeeBoxStatus: TdxMemData;
    MDTeeBoxStatusend_datetime: TStringField;
    MDTeeBoxStatusheat_status: TIntegerField;
    MDTeeBoxStatushp_no: TStringField;
    MDTeeBoxStatusmember_nm: TStringField;
    MDTeeBoxStatusmember_no: TStringField;
    MDTeeBoxStatusmemo: TStringField;
    MDTeeBoxStatusremain_balls: TIntegerField;
    MDTeeBoxStatusremain_min: TIntegerField;
    MDTeeBoxStatusreserved_count: TIntegerField;
    MDTeeBoxStatusreserve_div: TStringField;
    MDTeeBoxStatusreserve_no: TStringField;
    MDTeeBoxStatusreserve_datetime: TStringField;
    MDTeeBoxStatusstart_datetime: TStringField;
    MDTeeBoxStatusteebox_no: TIntegerField;
    MDTeeBoxStatususe_status: TIntegerField;
    MDTeeBoxteebox_nm: TStringField;
    MDTeeBoxteebox_no: TIntegerField;
    MDTeeBoxuse_yn: TBooleanField;
    MDTeeBoxvip_yn: TBooleanField;
    MDTeeBoxzone_cd: TStringField;
    MDVersion: TdxMemData;
    MDVersionproduct_type: TStringField;
    MDVersionversion_no: TIntegerField;
    QRCouponPend: TABSQuery;
    QRCouponPendapply_dc_amt: TIntegerField;
    QRCouponPendcalc_dc_cnt: TStringField;
    QRCouponPendcalc_dc_div: TStringField;
    QRCouponPendcalc_product_div: TStringField;
    QRCouponPendcalc_teebox_product_div: TStringField;
    QRCouponPendcalc_use_yn: TStringField;
    QRCouponPendcoupon_nm: TStringField;
    QRCouponPendcoupon_seq: TIntegerField;
    QRCouponPenddc_cnt: TIntegerField;
    QRCouponPenddc_cond_div: TStringField;
    QRCouponPenddc_div: TStringField;
    QRCouponPendevent_nm: TStringField;
    QRCouponPendevent_url: TStringField;
    QRCouponPendexpire_day: TStringField;
    QRCouponPendmemo: TStringField;
    QRCouponPendproduct_div: TStringField;
    QRCouponPendqr_date: TStringField;
    QRCouponPendreceipt_no: TStringField;
    QRCouponPendsend_date: TStringField;
    QRCouponPendstart_day: TStringField;
    QRCouponPendtable_no: TSmallintField;
    QRCouponPendused_cnt: TIntegerField;
    QRCouponPenduse_cnt: TIntegerField;
    QRCouponPenduse_yn: TStringField;
    QRPaymentPend: TABSQuery;
    QRPaymentPendapply_dc_amt: TIntegerField;
    QRPaymentPendapproval_yn: TStringField;
    QRPaymentPendapprove_amt: TIntegerField;
    QRPaymentPendapprove_no: TStringField;
    QRPaymentPendbuyer_cd: TStringField;
    QRPaymentPendbuyer_div: TStringField;
    QRPaymentPendbuyer_nm: TStringField;
    QRPaymentPendcalc_approval_yn: TStringField;
    QRPaymentPendcalc_cancel_count: TIntegerField;
    QRPaymentPendcalc_pay_method: TStringField;
    QRPaymentPendcredit_card_no: TStringField;
    QRPaymentPendinst_mon: TIntegerField;
    QRPaymentPendinternet_yn: TStringField;
    QRPaymentPendissuer_cd: TStringField;
    QRPaymentPendissuer_nm: TStringField;
    QRPaymentPendorg_approve_no: TStringField;
    QRPaymentPendpay_method: TStringField;
    QRPaymentPendpc_div: TStringField;
    QRPaymentPendpc_seq: TIntegerField;
    QRPaymentPendservice_amt: TIntegerField;
    QRPaymentPendtable_no: TSmallintField;
    QRPaymentPendtid: TStringField;
    QRPaymentPendtrade_date: TStringField;
    QRPaymentPendtrade_no: TStringField;
    QRPaymentPendvan_cd: TStringField;
    QRPaymentPendvat: TIntegerField;
    QRReceiptPend: TABSQuery;
    QRReceiptPendaffiliate_card_no: TStringField;
    QRReceiptPendaffiliate_cd: TStringField;
    QRReceiptPendaffiliate_dc_amt: TIntegerField;
    QRReceiptPendcalc_cancel_yn: TStringField;
    QRReceiptPendcalc_coupon_dc_amt: TIntegerField;
    QRReceiptPendcalc_dc_amt: TIntegerField;
    QRReceiptPendcalc_receipt_no: TStringField;
    QRReceiptPendcalc_sale_amt: TIntegerField;
    QRReceiptPendcalc_sale_dc_amt: TIntegerField;
    QRReceiptPendcalc_sale_root_div: TStringField;
    QRReceiptPendcancel_yn: TStringField;
    QRReceiptPendcoupon_dc_amt: TIntegerField;
    QRReceiptPenddirect_dc_amt: TIntegerField;
    QRReceiptPendhp_no: TStringField;
    QRReceiptPendmember_nm: TStringField;
    QRReceiptPendmember_no: TStringField;
    QRReceiptPendmemo: TStringField;
    QRReceiptPendpos_no: TStringField;
    QRReceiptPendprev_receipt_no: TStringField;
    QRReceiptPendsale_amt: TIntegerField;
    QRReceiptPendsale_date: TStringField;
    QRReceiptPendsale_root_div: TStringField;
    QRReceiptPendsale_time: TStringField;
    QRReceiptPendtable_no: TSmallintField;
    QRReceiptPendtotal_amt: TIntegerField;
    QRReceiptPenduser_id: TStringField;
    QRReceiptPenduser_nm: TStringField;
    QRReceiptPendxgolf_dc_amt: TIntegerField;
    QRReceiptPendxgolf_no: TStringField;
    QRSaleItemPend: TABSQuery;
    QRSaleItemPendcalc_charge_amt: TIntegerField;
    QRSaleItemPendcalc_coupon_dc_amt: TIntegerField;
    QRSaleItemPendcalc_dc_amt: TIntegerField;
    QRSaleItemPendcalc_product_div: TStringField;
    QRSaleItemPendcalc_sell_subtotal: TIntegerField;
    QRSaleItemPendcalc_vat_subtotal: TIntegerField;
    QRSaleItemPendcoupon_dc_amt: TIntegerField;
    QRSaleItemPendcoupon_dc_fixed_amt: TIntegerField;
    QRSaleItemPendcoupon_dc_rate_amt: TIntegerField;
    QRSaleItemPenddirect_dc_amt: TIntegerField;
    QRSaleItemPendfloor_cd: TStringField;
    QRSaleItemPendkeep_amt: TIntegerField;
    QRSaleItemPendlocker_nm: TStringField;
    QRSaleItemPendlocker_no: TIntegerField;
    QRSaleItemPendorder_qty: TIntegerField;
    QRSaleItemPendproduct_amt: TIntegerField;
    QRSaleItemPendproduct_cd: TStringField;
    QRSaleItemPendproduct_div: TStringField;
    QRSaleItemPendproduct_nm: TStringField;
    QRSaleItemPendpurchase_month: TIntegerField;
    QRSaleItemPendservice_yn: TBooleanField;
    QRSaleItemPendtable_no: TSmallintField;
    QRSaleItemPendteebox_list: TStringField;
    QRSaleItemPendteebox_prod_div: TStringField;
    QRSaleItemPendxgolf_dc_amt: TIntegerField;
    StandStyleBandHeader: TcxStyle;
    StandStyleHeader: TcxStyle;
    StandStyleSelection: TcxStyle;
    StandStyleSelectionWhite: TcxStyle;
    QRSaleItemPendpurchase_cd: TStringField;
    QRCouponPendteebox_product_div: TStringField;
    MDProdGeneralrefund_yn: TBooleanField;
    MDTeeBoxReserveduse_cnt: TIntegerField;
    MDTeeBoxReservedready_cnt: TIntegerField;
    MDMemberFinger: TdxMemData;
    MDMemberFingermember_seq: TIntegerField;
    MDMemberFingermember_no: TStringField;
    MDMemberFingermember_nm: TStringField;
    MDMemberFingercustomer_cd: TStringField;
    MDMemberFingergroup_cd: TStringField;
    MDMemberFingerwelfare_cd: TStringField;
    MDMemberFingerdc_rate: TIntegerField;
    MDMemberFingermember_point: TIntegerField;
    MDMemberFingersex_div: TIntegerField;
    MDMemberFingerbirth_ymd: TStringField;
    MDMemberFingerhp_no: TStringField;
    MDMemberFingeremail: TStringField;
    MDMemberFingercar_no: TStringField;
    MDMemberFingerzip_no: TStringField;
    MDMemberFingeraddress: TStringField;
    MDMemberFingeraddress_desc: TStringField;
    MDMemberFingerqr_cd: TStringField;
    MDMemberFingerxg_user_key: TStringField;
    MDMemberFingerfingerprint1: TStringField;
    MDMemberFingerfingerprint2: TStringField;
    MDMemberFingermem: TStringField;
    MDMemberFingerlocker_no: TIntegerField;
    MDMemberFingerlocker_nm: TStringField;
    MDMemberFingerlocker_list: TStringField;
    MDMemberFingerphoto: TBlobField;
    MDMemberFingersex_div_desc: TStringField;
    MDRefreshClubCoupon: TdxMemData;
    MDRefreshClubCouponcoupon_id: TIntegerField;
    MDRefreshClubCouponsubtitle: TStringField;
    MDRefreshClubCouponvalid_period_end: TStringField;
    MDRefreshClubCouponpass_count: TIntegerField;
    MDTeeBoxStatusfloor_cd: TStringField;
    MDTeeBoxStatus2floor_cd: TStringField;
    MDTeeBoxStatus3floor_cd: TStringField;
    MDTeeBoxStatus4floor_cd: TStringField;
    MDTeeBoxStatusteebox_nm: TStringField;
    MDTeeBoxStatus2teebox_nm: TStringField;
    MDTeeBoxStatus3teebox_nm: TStringField;
    MDTeeBoxStatus4teebox_nm: TStringField;
    MDTeeBoxcontrol_yn: TStringField;
    MDMemberexpire_locker: TStringField;
    MDMemberSearchexpire_locker: TStringField;
    MDMembermember_card_uid: TStringField;
    MDMemberSearchmember_card_uid: TStringField;
    MDACSList: TdxMemData;
    MDACSListsend_div: TIntegerField;
    MDACSListfailure_second: TIntegerField;
    MDACSListrecv_hp_no: TStringField;
    MDACSListcalc_send_div: TStringField;
    MDTeeBoxStatuserror_cd: TIntegerField;
    MDTeeBoxStatus2error_cd: TIntegerField;
    MDTeeBoxStatus3error_cd: TIntegerField;
    MDTeeBoxStatus4error_cd: TIntegerField;
    MDLockerProdMember: TdxMemData;
    MDLockerProdMemberpurchase_cd: TStringField;
    MDLockerProdMemberproduct_cd: TStringField;
    MDLockerProdMemberproduct_div: TStringField;
    MDLockerProdMemberproduct_nm: TStringField;
    MDLockerProdMemberzone_cd: TStringField;
    MDLockerProdMemberpurchase_amt: TIntegerField;
    MDLockerProdMemberzone_nm: TStringField;
    MDLockerProdMemberstart_day: TStringField;
    MDLockerProdMemberend_day: TStringField;
    MDLockerProdMemberlocker_no: TIntegerField;
    MDLockerProdMemberlocker_nm: TStringField;
    MDLockerProdMemberfloor_cd: TStringField;
    MDLockerProdMemberfloor_nm: TStringField;
    MDLockerProdMemberuse_status: TIntegerField;
    MDLockerProdMemberoverdue_day: TIntegerField;
    MDLockerProdMembercalc_product_div: TStringField;
    MDLockerProdMembercalc_use_status: TStringField;
    MDLockerzone_nm: TStringField;
    indAntiFreeze: TIdAntiFreeze;
    MDReceiptList: TdxMemData;
    MDReceiptListreceipt_no: TStringField;
    MDReceiptListtable_no: TSmallintField;
    MDReceiptListprev_receipt_no: TStringField;
    MDReceiptListpos_no: TStringField;
    MDReceiptListsale_date: TStringField;
    MDReceiptListsale_time: TStringField;
    MDReceiptListmember_no: TStringField;
    MDReceiptListmember_nm: TStringField;
    MDReceiptListxgolf_no: TStringField;
    MDReceiptListhp_no: TStringField;
    MDReceiptListtotal_amt: TIntegerField;
    MDReceiptListsale_amt: TIntegerField;
    MDReceiptListdirect_dc_amt: TIntegerField;
    MDReceiptListxgolf_dc_amt: TIntegerField;
    MDReceiptListcoupon_dc_amt: TIntegerField;
    MDReceiptListmemo: TStringField;
    MDReceiptListcancel_yn: TStringField;
    MDReceiptListsale_root_div: TStringField;
    MDReceiptListuser_id: TStringField;
    MDReceiptListuser_nm: TStringField;
    MDReceiptListaffiliate_cd: TStringField;
    MDReceiptListaffiliate_card_no: TStringField;
    MDReceiptListaffiliate_dc_amt: TIntegerField;
    MDReceiptListcalc_cancel_yn: TStringField;
    MDReceiptListcalc_sale_root_div: TStringField;
    MDReceiptListcalc_receipt_no: TStringField;
    MDReceiptListcalc_more_dc_amt: TIntegerField;
    MDReceiptListcalc_coupon_dc_amt: TIntegerField;
    MDReceiptListcalc_sale_dc_amt: TIntegerField;
    MDReceiptListcalc_sale_amt: TIntegerField;
    MDSaleItemList: TdxMemData;
    MDPaymentList: TdxMemData;
    MDCouponList: TdxMemData;
    MDSaleItemListreceipt_no: TStringField;
    MDSaleItemListtable_no: TSmallintField;
    MDSaleItemListproduct_div: TStringField;
    MDSaleItemListteebox_prod_div: TStringField;
    MDSaleItemListproduct_cd: TStringField;
    MDSaleItemListproduct_nm: TStringField;
    MDSaleItemListproduct_amt: TIntegerField;
    MDSaleItemListorder_qty: TIntegerField;
    MDSaleItemListdirect_dc_amt: TIntegerField;
    MDSaleItemListcoupon_dc_amt: TIntegerField;
    MDSaleItemListcoupon_dc_fixed_amt: TIntegerField;
    MDSaleItemListcoupon_dc_rate_amt: TIntegerField;
    MDSaleItemListxgolf_dc_amt: TIntegerField;
    MDSaleItemListservice_yn: TBooleanField;
    MDSaleItemListlocker_no: TIntegerField;
    MDSaleItemListlocker_nm: TStringField;
    MDSaleItemListfloor_cd: TStringField;
    MDSaleItemListpurchase_month: TIntegerField;
    MDSaleItemListkeep_amt: TIntegerField;
    MDSaleItemListpurchase_cd: TStringField;
    MDSaleItemListuse_start_date: TStringField;
    MDSaleItemListuse_end_date: TStringField;
    MDSaleItemListteebox_list: TStringField;
    MDSaleItemListcalc_product_div: TStringField;
    MDSaleItemListcalc_sell_subtotal: TIntegerField;
    MDSaleItemListcalc_charge_amt: TIntegerField;
    MDSaleItemListcalc_vat_subtotal: TIntegerField;
    MDSaleItemListcalc_dc_amt: TIntegerField;
    MDSaleItemListcalc_coupon_dc_amt: TIntegerField;
    MDPaymentListreceipt_no: TStringField;
    MDPaymentListtable_no: TIntegerField;
    MDPaymentListapproval_yn: TStringField;
    MDPaymentListpay_method: TStringField;
    MDPaymentListvan_cd: TStringField;
    MDPaymentListtid: TStringField;
    MDPaymentListinternet_yn: TStringField;
    MDPaymentListcredit_card_no: TStringField;
    MDPaymentListinst_mon: TIntegerField;
    MDPaymentListapprove_amt: TIntegerField;
    MDPaymentListvat: TIntegerField;
    MDPaymentListservice_amt: TIntegerField;
    MDPaymentListapprove_no: TStringField;
    MDPaymentListorg_approve_no: TStringField;
    MDPaymentListtrade_no: TStringField;
    MDPaymentListtrade_date: TStringField;
    MDPaymentListissuer_cd: TStringField;
    MDPaymentListissuer_nm: TStringField;
    MDPaymentListbuyer_div: TStringField;
    MDPaymentListbuyer_cd: TStringField;
    MDPaymentListbuyer_nm: TStringField;
    MDPaymentListpc_seq: TIntegerField;
    MDPaymentListpc_div: TStringField;
    MDPaymentListapply_dc_amt: TIntegerField;
    MDPaymentListcalc_pay_method: TStringField;
    MDPaymentListcalc_approval_yn: TStringField;
    MDPaymentListcalc_cancel_count: TIntegerField;
    MDCouponListreceipt_no: TStringField;
    MDCouponListtable_no: TIntegerField;
    MDCouponListcoupon_seq: TIntegerField;
    MDCouponListqr_code: TStringField;
    MDCouponListcoupon_nm: TStringField;
    MDCouponListdc_div: TStringField;
    MDCouponListdc_cnt: TIntegerField;
    MDCouponListstart_day: TStringField;
    MDCouponListexpire_day: TStringField;
    MDCouponListuse_cnt: TIntegerField;
    MDCouponListused_cnt: TIntegerField;
    MDCouponListdc_cond_div: TStringField;
    MDCouponListproduct_div: TStringField;
    MDCouponListteebox_product_div: TStringField;
    MDCouponListsend_date: TStringField;
    MDCouponListuse_yn: TStringField;
    MDCouponListevent_nm: TStringField;
    MDCouponListevent_url: TStringField;
    MDCouponListapply_dc_amt: TIntegerField;
    MDCouponListmemo: TStringField;
    MDCouponListcalc_dc_div: TStringField;
    MDCouponListcalc_dc_cnt: TStringField;
    MDCouponListcalc_product_div: TStringField;
    MDCouponListcalc_teebox_product_div: TStringField;
    MDCouponListcalc_use_yn: TStringField;
    MDReceiptListpaid_cnt: TIntegerField;
    MDReceiptListcancel_cnt: TIntegerField;
    DSReceiptList: TDataSource;
    DSPaymentList: TDataSource;
    DSCouponList: TDataSource;
    DSSaleItemList: TDataSource;
    DSReceiptPend: TDataSource;
    DSSaleItemPend: TDataSource;
    DSCouponPend: TDataSource;
    DSPaymentPend: TDataSource;
    DSMemberSearch: TDataSource;
    DSProdTeeBoxFilter: TDataSource;
    DSRefreshClubCoupon: TDataSource;
    DSTeeBoxProdMember: TDataSource;
    DSLockerProdMember: TDataSource;
    DSProdGeneral: TDataSource;
    DSTeeBoxSelected: TDataSource;
    DSTeeBoxReserved2: TDataSource;
    DSACSList: TDataSource;
    MDTeeBoxReservedcalc_reserve_time: TStringField;
    MDTeeBoxReservedcalc_start_time: TStringField;
    MDTeeBoxReservedcalc_end_time: TStringField;
    MDTeeBoxReserved2use_cnt: TIntegerField;
    MDTeeBoxReserved2ready_cnt: TIntegerField;
    MDTeeBoxReserved2calc_reserve_time: TStringField;
    MDTeeBoxReserved2calc_start_time: TStringField;
    MDTeeBoxReserved2calc_end_time: TStringField;
    MDTeeBoxProdMemberuse_status: TIntegerField;
    TBEmergency: TABSTable;
    QREmergency: TABSQuery;
    DSEmergency: TDataSource;
    DSTeeBoxAssignList: TDataSource;
    SPTeeBoxAssignList: TUniStoredProc;
    SPTeeBoxAssignListreserve_no: TStringField;
    SPTeeBoxAssignListprepare_min: TIntegerField;
    SPTeeBoxAssignListremain_min: TIntegerField;
    SPTeeBoxAssignListuse_status: TStringField;
    SPTeeBoxAssignListreserve_date: TStringField;
    SPTeeBoxAssignListstart_time: TStringField;
    SPTeeBoxAssignListend_time: TStringField;
    SPTeeBoxAssignListremain_balls: TIntegerField;
    SPTeeBoxAssignListreserve_move_yn: TStringField;
    SPTeeBoxAssignListmove_yn: TStringField;
    SPTeeBoxAssignListmember_nm: TStringField;
    SPTeeBoxAssignListcalc_use_status: TStringField;
    SPTeeBoxAssignListcalc_move_status: TStringField;
    MDTeeBoxReservedreserve_move_yn: TBooleanField;
    MDTeeBoxReserved2reserve_move_yn: TBooleanField;
    MDTeeBoxReserved2calc_remark: TStringField;
    MDTeeBoxReservedcalc_remark: TStringField;
    MDTeeBoxIssuedreserve_move_yn: TBooleanField;
    MDTeeBoxIssued2reserve_move_yn: TBooleanField;
    NoShowStyleBackground: TcxStyle;
    DSTeeBoxNoShowList: TDataSource;
    SPTeeBoxNoShowList: TUniStoredProc;
    SPTeeBoxNoShowListuse_seq: TIntegerField;
    SPTeeBoxNoShowListteebox_no: TIntegerField;
    SPTeeBoxNoShowListteebox_nm: TStringField;
    SPTeeBoxNoShowListuse_status: TStringField;
    SPTeeBoxNoShowListfloor_cd: TStringField;
    SPTeeBoxNoShowListvip_yn: TStringField;
    SPTeeBoxNoShowListuse_yn: TStringField;
    SPTeeBoxNoShowListreserve_root_div: TStringField;
    SPTeeBoxNoShowListassign_yn: TStringField;
    SPTeeBoxNoShowListproduct_cd: TIntegerField;
    SPTeeBoxNoShowListproduct_nm: TStringField;
    SPTeeBoxNoShowListassign_min: TIntegerField;
    SPTeeBoxNoShowListassign_balls: TIntegerField;
    SPTeeBoxNoShowListprepare_min: TIntegerField;
    SPTeeBoxNoShowListreserve_no: TStringField;
    SPTeeBoxNoShowListreserve_div: TStringField;
    SPTeeBoxNoShowListpurchase_cd: TIntegerField;
    SPTeeBoxNoShowListmember_no: TStringField;
    SPTeeBoxNoShowListmember_nm: TStringField;
    SPTeeBoxNoShowListmemo: TStringField;
    SPTeeBoxNoShowListreserve_datetime: TStringField;
    SPTeeBoxNoShowListstart_datetime: TStringField;
    SPTeeBoxNoShowListend_datetime: TStringField;
    SPTeeBoxNoShowListcalc_reserve_div: TStringField;
    SPTeeBoxNoShowListcalc_reserve_root_div: TStringField;
    SPTeeBoxNoShowListcalc_reserve_time: TStringField;
    SPTeeBoxNoShowListcalc_start_time: TStringField;
    SPTeeBoxNoShowListcalc_end_time: TStringField;
    MDTeeBoxIssuedreserve_noshow_yn: TBooleanField;
    MDTeeBoxIssued2reserve_noshow_yn: TBooleanField;
    MDTeeBoxSelectedproduct_div: TStringField;
    MDTeeBoxSelectedproduct_nm: TStringField;
    MDTeeBoxStatuslesson_pro_nm: TStringField;
    MDTeeBoxStatus2lesson_pro_nm: TStringField;
    MDTeeBoxStatus3lesson_pro_nm: TStringField;
    MDTeeBoxStatus4lesson_pro_nm: TStringField;
    MDTeeBoxReservedlesson_pro_nm: TStringField;
    MDTeeBoxReservedlesson_pro_color: TIntegerField;
    MDTeeBoxReserved2lesson_pro_nm: TStringField;
    MDTeeBoxReserved2lesson_pro_color: TIntegerField;
    MDTeeBoxStatuslesson_pro_color: TIntegerField;
    MDTeeBoxStatus2lesson_pro_color: TIntegerField;
    MDTeeBoxStatus3lesson_pro_color: TIntegerField;
    MDTeeBoxStatus4lesson_pro_color: TIntegerField;
    MDTeeBoxStatusagent_status: TSmallintField;
    MDTeeBoxStatus2agent_status: TSmallintField;
    MDTeeBoxStatus3agent_status: TSmallintField;
    MDTeeBoxStatus4agent_status: TSmallintField;
    MDProdTeeBoxavail_zone_cd: TStringField;
    MDProdTeeBoxFilteredavail_zone_cd: TStringField;
    MDTeeBoxProdMemberavail_zone_cd: TStringField;
    MDTeeBoxSelectedavail_zone_cd: TStringField;
    MDTeeBoxSelectedzone_cd: TStringField;
    MDTeeBoxReservedavail_zone_cd: TStringField;
    MDTeeBoxReserved2avail_zone_cd: TStringField;
    SPTeeBoxNoShowListavailable_zone_cd: TStringField;
    BunkerStyleBackground: TcxStyle;
    MDProdTeeBoxlimit_product_yn: TBooleanField;
    MDProdTeeBoxaffiliate_yn: TBooleanField;
    MDProdTeeBoxaffiliate_cd: TStringField;
    MDProdTeeBoxaffiliate_item_cd: TStringField;
    MDProdTeeBoxFilteredaffiliate_cd: TStringField;
    MDProdTeeBoxFilteredaffiliate_item_cd: TStringField;
    MDProdTeeBoxFilteredaffiliate_yn: TBooleanField;
    MDProdTeeBoxFilteredlimit_product_yn: TBooleanField;
    MDLessonPro: TdxMemData;
    MDLessonProlesson_pro_cd: TStringField;
    MDLessonProlesson_pro_nm: TStringField;
    QRSaleItemPendlesson_pro_cd: TStringField;
    QRSaleItemPendlesson_pro_nm: TStringField;
    MDMemberspectrum_cust_id: TStringField;
    MDMemberSearchspectrum_cust_id: TStringField;
    MDMemberFingerspectrum_cust_id: TStringField;
    MDMemberFingermember_card_uid: TStringField;
    MDMemberFingerexpire_locker: TStringField;
    MDMemberspecial_yn: TBooleanField;
    MDMemberFingerspecial_yn: TBooleanField;
    MDMemberSearchspecial_yn: TBooleanField;
    imcWeather: TcxImageCollection;
    imcWeather00d: TcxImageCollectionItem;
    imcWeather00n: TcxImageCollectionItem;
    imcWeather01d: TcxImageCollectionItem;
    imcWeather01n: TcxImageCollectionItem;
    imcWeather02d: TcxImageCollectionItem;
    imcWeather02n: TcxImageCollectionItem;
    imcWeather03d: TcxImageCollectionItem;
    imcWeather03n: TcxImageCollectionItem;
    imcWeather04d: TcxImageCollectionItem;
    imcWeather04n: TcxImageCollectionItem;
    imcWeather09d: TcxImageCollectionItem;
    imcWeather09n: TcxImageCollectionItem;
    imcWeather10d: TcxImageCollectionItem;
    imcWeather10n: TcxImageCollectionItem;
    imcWeather11d: TcxImageCollectionItem;
    imcWeather11n: TcxImageCollectionItem;
    imcWeather13d: TcxImageCollectionItem;
    imcWeather13n: TcxImageCollectionItem;
    imcWeather50d: TcxImageCollectionItem;
    imcWeather50n: TcxImageCollectionItem;
    imcWeather51d: TcxImageCollectionItem;
    imcWeather51n: TcxImageCollectionItem;
    MDWeatherDay: TdxMemData;
    DSWeatherDay: TDataSource;
    MDWeatherDayweather_id: TIntegerField;
    MDWeatherDayicon_idx: TShortintField;
    MDWeatherDaycondition: TStringField;
    MDWeatherDaytemper: TStringField;
    MDWeatherDayprecipit: TStringField;
    MDWeatherDayhumidity: TStringField;
    MDWeatherDaywind_speed: TStringField;
    MDWeatherDayicon: TBlobField;
    MDWeatherDaydatetime: TDateTimeField;
    MDWeatherHour: TdxMemData;
    MDWeatherHourdatetime: TDateTimeField;
    MDWeatherHourweather_id: TIntegerField;
    MDWeatherHouricon_idx: TShortintField;
    MDWeatherHourtemper: TStringField;
    MDWeatherHourprecipit: TStringField;
    MDWeatherHourhumidity: TStringField;
    MDWeatherHourwind_speed: TStringField;
    MDWeatherHourcondition: TStringField;
    MDWeatherHouricon: TBlobField;
    DSWeatherHour: TDataSource;
    MDFacilityProdMember: TdxMemData;
    DSFacilityProdMember: TDataSource;
    MDProdFacility: TdxMemData;
    MDProdFacilityproduct_cd: TStringField;
    MDProdFacilityfacility_div: TStringField;
    MDProdFacilityproduct_nm: TStringField;
    MDProdFacilityproduct_amt: TIntegerField;
    MDProdFacilityuse_cnt: TIntegerField;
    MDProdFacilityuse_month: TIntegerField;
    MDProdFacilitymemo: TStringField;
    MDFacilityProdMemberpurchase_cd: TStringField;
    MDFacilityProdMemberproduct_cd: TStringField;
    MDFacilityProdMemberproduct_div: TStringField;
    MDFacilityProdMemberproduct_nm: TStringField;
    MDFacilityProdMemberproduct_div_nm: TStringField;
    MDFacilityProdMemberaccess_control_nm: TStringField;
    MDFacilityProdMemberproduct_amt: TIntegerField;
    MDFacilityProdMemberpurchase_amt: TIntegerField;
    MDFacilityProdMemberstart_day: TStringField;
    MDFacilityProdMemberend_day: TStringField;
    MDFacilityProdMemberuse_status: TShortintField;
    MDFacilityProdMemberpurchase_date: TStringField;
    MDProdFacilityfacility_div_nm: TStringField;
    MDTeeBoxIssuedaccess_barcode: TStringField;
    MDTeeBoxIssuedaccess_control_nm: TStringField;
    MDTeeBoxIssued2access_barcode: TStringField;
    MDTeeBoxIssued2access_control_nm: TStringField;
    MDFacilityProdMembercalc_use_status: TStringField;
    MDFacilityProdMembertoday_used_yn: TBooleanField;
    MDFacilityProdMemberpurchase_cnt: TIntegerField;
    MDFacilityProdMemberremain_cnt: TIntegerField;
    MDSaleItemListcalc_facility_count: TIntegerField;
    QRSaleItemPendcalc_facility_count: TIntegerField;
    StandStyleSelection2: TcxStyle;
    QRReceiptPendreceipt_no: TStringField;
    QRSaleItemPendreceipt_no: TStringField;
    QRPaymentPendreceipt_no: TStringField;
    MDReceiptListgroup_no: TSmallintField;
    QRReceiptPendgroup_no: TSmallintField;
    MDReceiptListtable_come_tm: TStringField;
    MDReceiptListtable_out_tm: TStringField;
    MDReceiptListtable_guest_cnt: TSmallintField;
    QRReceiptPendtable_come_tm: TStringField;
    QRReceiptPendtable_out_tm: TStringField;
    QRReceiptPendtable_guest_cnt: TSmallintField;
    QRSaleItem: TABSQuery;
    QRPayment: TABSQuery;
    QRCoupon: TABSQuery;
    QRSaleItemreceipt_no: TStringField;
    QRSaleItemtable_no: TSmallintField;
    QRSaleItemproduct_div: TStringField;
    QRSaleItemteebox_prod_div: TStringField;
    QRSaleItemproduct_cd: TStringField;
    QRSaleItemproduct_nm: TStringField;
    QRSaleItemproduct_amt: TIntegerField;
    QRSaleItemorder_qty: TIntegerField;
    QRSaleItemdirect_dc_amt: TIntegerField;
    QRSaleItemcoupon_dc_amt: TIntegerField;
    QRSaleItemcoupon_dc_fixed_amt: TIntegerField;
    QRSaleItemcoupon_dc_rate_amt: TIntegerField;
    QRSaleItemxgolf_dc_amt: TIntegerField;
    QRSaleItemservice_yn: TBooleanField;
    QRSaleItemlocker_no: TIntegerField;
    QRSaleItemlocker_nm: TStringField;
    QRSaleItemfloor_cd: TStringField;
    QRSaleItempurchase_month: TIntegerField;
    QRSaleItemkeep_amt: TIntegerField;
    QRSaleItempurchase_cd: TStringField;
    QRSaleItemuse_start_date: TStringField;
    QRSaleItemuse_end_date: TStringField;
    QRSaleItemlesson_pro_cd: TStringField;
    QRSaleItemlesson_pro_nm: TStringField;
    QRSaleItemteebox_list: TStringField;
    QRSaleItemcalc_product_div: TStringField;
    QRSaleItemcalc_sell_subtotal: TIntegerField;
    QRSaleItemcalc_charge_amt: TIntegerField;
    QRSaleItemcalc_vat_subtotal: TIntegerField;
    QRSaleItemcalc_dc_amt: TIntegerField;
    QRSaleItemcalc_coupon_dc_amt: TIntegerField;
    QRSaleItemcalc_facility_count: TIntegerField;
    QRPaymentreceipt_no: TStringField;
    QRPaymenttable_no: TSmallintField;
    QRPaymentapproval_yn: TStringField;
    QRPaymentpay_method: TStringField;
    QRPaymentvan_cd: TStringField;
    QRPaymenttid: TStringField;
    QRPaymentinternet_yn: TStringField;
    QRPaymentcredit_card_no: TStringField;
    QRPaymentinst_mon: TIntegerField;
    QRPaymentapprove_amt: TIntegerField;
    QRPaymentvat: TIntegerField;
    QRPaymentservice_amt: TIntegerField;
    QRPaymentapprove_no: TStringField;
    QRPaymentorg_approve_no: TStringField;
    QRPaymenttrade_no: TStringField;
    QRPaymenttrade_date: TStringField;
    QRPaymentissuer_cd: TStringField;
    QRPaymentissuer_nm: TStringField;
    QRPaymentbuyer_div: TStringField;
    QRPaymentbuyer_cd: TStringField;
    QRPaymentbuyer_nm: TStringField;
    QRPaymentpc_seq: TIntegerField;
    QRPaymentpc_div: TStringField;
    QRPaymentapply_dc_amt: TIntegerField;
    QRPaymentcalc_pay_method: TStringField;
    QRPaymentcalc_approval_yn: TStringField;
    QRPaymentcalc_cancel_count: TIntegerField;
    QRCouponreceipt_no: TStringField;
    QRCoupontable_no: TIntegerField;
    QRCouponcoupon_seq: TIntegerField;
    QRCouponqr_code: TStringField;
    QRCouponcoupon_nm: TStringField;
    QRCoupondc_div: TStringField;
    QRCoupondc_cnt: TIntegerField;
    QRCouponstart_day: TStringField;
    QRCouponexpire_day: TStringField;
    QRCouponuse_cnt: TIntegerField;
    QRCouponused_cnt: TIntegerField;
    QRCoupondc_cond_div: TStringField;
    QRCouponproduct_div: TStringField;
    QRCouponteebox_product_div: TStringField;
    QRCouponuse_yn: TStringField;
    QRCouponevent_nm: TStringField;
    QRCouponevent_url: TStringField;
    QRCouponsend_date: TStringField;
    QRCouponapply_dc_amt: TIntegerField;
    QRCouponmemo: TStringField;
    QRCouponcalc_dc_div: TStringField;
    QRCouponcalc_dc_cnt: TStringField;
    QRCouponcalc_product_div: TStringField;
    QRCouponcalc_teebox_product_div: TStringField;
    QRCouponcalc_use_yn: TStringField;
    QRReceipt: TABSQuery;
    QRReceiptreceipt_no: TStringField;
    QRReceipttable_no: TSmallintField;
    QRReceiptgroup_no: TSmallintField;
    QRReceipttable_come_tm: TStringField;
    QRReceipttable_out_tm: TStringField;
    QRReceipttable_guest_cnt: TSmallintField;
    QRReceiptprev_receipt_no: TStringField;
    QRReceiptpos_no: TStringField;
    QRReceiptsale_date: TStringField;
    QRReceiptsale_time: TStringField;
    QRReceiptmember_no: TStringField;
    QRReceiptmember_nm: TStringField;
    QRReceiptxgolf_no: TStringField;
    QRReceipthp_no: TStringField;
    QRReceipttotal_amt: TIntegerField;
    QRReceiptsale_amt: TIntegerField;
    QRReceiptdirect_dc_amt: TIntegerField;
    QRReceiptxgolf_dc_amt: TIntegerField;
    QRReceiptcoupon_dc_amt: TIntegerField;
    QRReceiptcancel_yn: TStringField;
    QRReceiptsale_root_div: TStringField;
    QRReceiptaffiliate_cd: TStringField;
    QRReceiptaffiliate_card_no: TStringField;
    QRReceiptaffiliate_dc_amt: TIntegerField;
    QRReceiptuser_id: TStringField;
    QRReceiptuser_nm: TStringField;
    QRReceiptmemo: TStringField;
    QRReceiptcalc_cancel_yn: TStringField;
    QRReceiptcalc_sale_root_div: TStringField;
    QRReceiptcalc_receipt_no: TStringField;
    QRReceiptcalc_more_dc_amt: TIntegerField;
    QRReceiptcalc_coupon_dc_amt: TIntegerField;
    QRReceiptcalc_sale_dc_amt: TIntegerField;
    QRReceiptcalc_sale_amt: TIntegerField;
    MDTeeBoxReserved2floor_nm: TStringField;
    MDTeeBoxReservedfloor_nm: TStringField;
    SPTeeBoxNoShowListfloor_nm: TStringField;
    MDTeeBoxSelectedfloor_nm: TStringField;
    MDProdFacilityticket_print_yn: TBooleanField;
    MDFacilityProdMemberticket_print_yn: TBooleanField;
    MDProdTeeBoxstamp_yn: TBooleanField;
    MDProdTeeBoxFilteredstamp_yn: TBooleanField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure conTeeBoxBeforeConnect(Sender: TObject);
    procedure conTeeBoxConnectionLost(Sender: TObject; Component: TComponent; ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
    procedure conParkingBeforeConnect(Sender: TObject);
    procedure conParkingConnectionLost(Sender: TObject; Component: TComponent; ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
    procedure MDMemberCalcFields(DataSet: TDataSet);
    procedure MDProdTeeBoxCalcFields(DataSet: TDataSet);
    procedure MDTeeBoxProdMemberCalcFields(DataSet: TDataSet);
    procedure MDTeeBoxReserved2FilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure OnSaleItemCalcFields(DataSet: TDataSet);
    procedure OnPaymentCalcFields(DataSet: TDataSet);
    procedure OnTeeBoxReservedCalcFields(DataSet: TDataSet);
    procedure OnCouponCalcFields(DataSet: TDataSet);
    procedure OnReceiptCalcFields(DataSet: TDataSet);
    procedure MDACSListCalcFields(DataSet: TDataSet);
    procedure MDLockerProdMemberCalcFields(DataSet: TDataSet);
    procedure SPTeeBoxAssignListCalcFields(DataSet: TDataSet);
    procedure SPTeeBoxNoShowListCalcFields(DataSet: TDataSet);
    procedure MDFacilityProdMemberCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    function CheckABSDatabase(const ADBFile: string; var AErrMsg: string): Boolean;
    procedure CreateTeeBoxEmergencyTable;
    procedure ImportMemData(ADataSet: TdxMemData);
    function ImportMemDataAll(var AErrMsg: string): Boolean;
    procedure ExportMemData(ADataSet: TdxMemData);
    function ExportMemDataAll(var AErrMsg: string): Boolean;
    function GetDataVersion(const AProductType: string): Integer;
    procedure SetDataVersion(const AProductType: string; const AVersion: Integer);
    function GetToken(const AClientId, AClientKey: string; var AToken: string; var AErrMsg: string): Boolean;
    function CheckToken(const AToken, AClientId, AClientKey: string; var AErrMsg: string): Boolean;
    function GetTerminalInfo(var AErrMsg: string): Boolean;
    function CheckLogin(const AUserId, ATerminalPwd: string; var AErrMsg: string): Boolean;
    function GetConfigListNew(var AErrMsg: string): Boolean;
    function PostConfigList(var AErrMsg: string): Boolean;
    function GetStoreInfo(var AErrMsg: string): Boolean;
    function GetTableList(var AErrMsg: string): Boolean;
    function GetTeeBoxList(var AErrMsg: string): Boolean;
    function GetNoticeList(const ASearchDate: string; var AErrMsg: string): Boolean;
    function GetProdTeeBoxList(var AErrMsg: string): Boolean;
    function GetProdLessonList(var AErrMsg: string): Boolean;
    function GetProdReserveList(var AErrMsg: string): Boolean;
    function GetProdFacilityList(var AErrMsg: string): Boolean;
    function GetZoneCodeNames(const AZoneCodes: string): string;
    function GetTeeBoxEmergencyMode(var AErrMsg: string): Boolean;
    function SetTeeBoxEmergencyMode(const AIsEmergency: Boolean; var AErrMsg: string): Boolean;
    function GetTeeBoxListEmergency(var AErrMsg: string): Boolean;
    function GetTeeBoxReserveListEmergency(const AReserveDate: string; var AErrMsg: string): Boolean;
    function GetTeeBoxStatus(AStatusDataSet: TDataSet; var AErrMsg: string): Boolean;
    function GetTeeBoxStatusLocal(AStatusDataSet: TDataSet; var AErrMsg: string): Boolean;
    function GetTeeBoxStatusServer(AStatusDataSet: TDataSet; var AErrMsg: string): Boolean;
    procedure ReloadTeeBoxStatus;
    procedure RefreshTeeboxViewData(const ACommand: string);
    function GetTeeBoxReserveList(const AReserveDate: string; const ATeeBoxNo: Integer; var AErrMsg: string): Boolean;
    function GetProdGeneralList(var AErrMsg: string): Boolean;
    function SetAirConOnOff(const ATeeBoxNo, AUseCmd: Integer; var AErrMsg: string): Boolean;
    function GetPluList(var AErrMsg: string): Boolean;
    function GetMemberList(var AErrMsg: string): Boolean;
    function GetICReaderVerify(var AErrMsg: string): Boolean;
    function GetLockerList(var AErrMsg: string): Boolean;
    function GetProdLockerList(var AErrMsg: string): Boolean;
    function GetLessonProList(const AProductCode: string; var AErrMsg: string): Boolean;
    procedure RefreshTeeBoxUsingCounter;
    procedure RefreshNoticeList;
    function GetCodeInfo(var AErrMsg: string): Boolean;
    procedure GetCodes(const AGroupCode: string; const AAddNoCode: Boolean; var AItems: TStringList);
    function GetCodeItemName(const AGroupCode, AItemCode: string): string;
    procedure GetLessonProCodes(var AItems: TStringList);
    function IndexOfCodes(const ACode: string; const AItems: TStrings): Integer;
    procedure FreeCodes(AItems: TStringList);
    function CheckXGolfMemberNew(const AValueType, AMemberValue: string; var AErrMsg: string): Boolean;
    function PostMemberInfo(const ADataMode: Integer; APhotoStream: TStream; var AErrMsg: string): Boolean;
    function GetMemberSearch(const AMemberNo, AMemberName, AHpNo, ACarNo, AEmpFilter: string; const AUsePhoto: Boolean; const ATimeOut: Integer; var AErrMsg: string): Boolean;
    function SearchMemberByCode(const ACodeType: Integer; const ASearchValue: string; var AErrMsg: string): Boolean;
    function SearchMember(const AMemberNo, AMemberName, AHpNo, ACarNo: string; const AUsePhoto: Boolean; var AErrMsg: string): Boolean;
    function GetTeeBoxProdMember(const AMemberNo, ATeeBoxProdDiv: string; var AErrMsg: string): Boolean;
    function GetTeeBoxProdMemberCheck(const AMemberNo: string; var AErrMsg: string): Boolean;
    function GetTeeBoxProdMemberClear(const AMemberNo: string; var AErrMsg: string): Boolean;
    function OpenTeeBoxProdList(const AProductDiv, AZoneCode: string; const ADayOfWeekFiltered: Boolean; var ARecordCount: Integer; var AErrMsg: string): Boolean;
    function CheckTeeBoxHoldTime(AList: TStringList; var AErrMsg: string): Boolean;
    function CheckTeeBoxProdTime(const AProductCode, AReserveDateTime: string; const ATeeBoxNo: Integer; var AAssignMin: Integer; var AErrMsg: string): Boolean;
    function MakeNewReceipt(const ATableNo: Integer; const AReceiptNo: string; var AErrMsg: string): Boolean;
    function UpdateSaleList(const ATableNo: Integer; const ADelimitedGroupTableList: string; const AProductDiv, ATeeBoxProdDiv, AProductCode, AProductName, AUseStartDate, ALessonProCode: string; const AProductAmt, AXGolfDCAmt, AOrderQty, AUseMonth, AKeepAmt: Integer; var AErrMsg: string): Boolean;
    function UpdateSaleListCafe(const ATableNo: Integer; const ADelimitedGroupTableList: string; const AProductDiv, ATeeBoxProdDiv, AProductCode, AProductName: string; const AProductAmt, AXGolfDCAmt, AOrderQty, AUseMonth, AKeepAmt: Integer; var AErrMsg: string): Boolean;
    function PostProdSale(const ATableNo: Integer; var AErrMsg: string): Boolean;
    function PostProdSaleChange(const ATableNo: Integer; var AErrMsg: string): Boolean;
    function PostProdCashSaleChange(const AReceiptNo, ACreditCardNo, AApproveNo: string): Boolean;
    function GetProdSaleNew(const AStartDate, AEndDate: string; var AErrMsg: string): Boolean;
    function GetProdSaleDetailNew(const AReceiptNo: string; var AErrMsg: string): Boolean;
    function CancelProdSale(const AReceiptNo, APrevReceiptNo, AAffiliateCode, AAffiliateMemberCode, AMemo: string; var AIsParkingError: Boolean; var AErrMsg: string): Boolean;
    function CancelProdSalePartial(const AReceiptNo, APayMethod, ACardNo, AApprovalNo, AOrgApprovalNo: string; var AErrMsg: string): Boolean;
    function GetCardBinDiscount(const ACardBinNo, ATeeBoxProdDiv: string; const AApproveAmt: Integer; var APromoSeq, ADiscountAmt: Integer; var AErrMsg: string): Boolean;
    function PostTeeBoxReserve(const AMemberNo: string; var AErrMsg: string): Boolean; overload;
    function PostTeeBoxReserve(const AMemberNo, AMemberName, AMemberHpNo, AReceiptNo: string; var AErrMsg: string): Boolean; overload;
    function PostTeeBoxReserveLocal(const AMemberNo, AMemberName, AMemberHpNo, AReceiptNo: string; var AErrMsg: string): Boolean;
    function PostTeeBoxReserveServer(const AMemberNo: string; var AErrMsg: string): Boolean;
    function PostTeeBoxReserveCheckinServer(const AMemberNo: string; var ACheckinList: TCheckinList; var AErrCode, AErrMsg: string): Boolean;
    function PostTeeBoxReserveCheckinLocal(const ACheckinList: TCheckinList; var AErrMsg: string): Boolean;
    function GetTeeBoxNoShowList(var AErrMsg: string): Boolean;
    function PostTeeBoxNoShowReserve(const AReceiptNo, AAffiliateCode: string; var AErrMsg: string): Boolean;
    function PostTeeBoxReserveMove(const AReserveNo: string; const ATeeBoxNo, AAssignMin, APrepareMin, AAssignBalls: Integer; var AErrMsg: string): Boolean;
    function PostTeeBoxReserveMoveLocal(const AReserveNo: string; const ATeeBoxNo, AAssignMin, APrepareMin, AAssignBalls: Integer; var AErrMsg: string): Boolean;
    function PostTeeBoxReserveMoveServer(const AReserveNo: string; const ATeeBoxNo, AAssignMin, APrepareMin, AAssignBalls: Integer; var AErrMsg: string): Boolean;
    function PostTeeBoxReserveChange(const AReserveNo: string; const AAssignMin, APrepareMin, AAssignBalls: Integer; const AMemo: string; var AErrMsg: string): Boolean;
    function PostTeeBoxReserveChangeLocal(const AReserveNo: string; const AAssignMin, APrepareMin, AAssignBalls: Integer; const AMemo: string; var AErrMsg: string): Boolean;
    function PostTeeBoxReserveChangeServer(const AReserveNo: string; const AAssignMin, APrepareMin, AAssignBalls: Integer; const AMemo: string; var AErrMsg: string): Boolean;
    function CancelTeeBoxReserve(const AReserveNo, AReceiptNo: string; var AErrMsg: string): Boolean;
    function CancelTeeBoxReserveLocal(const AReserveNo, AReceiptNo: string; var AErrMsg: string): Boolean;
    function CancelTeeBoxReserveServer(const AReserveNo: string; var AErrMsg: string): Boolean;
    function CloseTeeBoxReserve(const AReserveNo: string; const ATeeBoxNo: Integer; var AErrMsg: string): Boolean;
    function CloseTeeBoxReserveLocal(const AReserveNo: string; var AErrMsg: string): Boolean;
    function CloseTeeBoxReserveServer(const AReserveNo: string; const ATeeBoxNo: Integer; var AErrMsg: string): Boolean;
    function GetTeeBoxTicketInfo(const AReserveNo: string; const ATeeBoxMoved: Boolean; const APrepareMin: Integer; var AErrMsg: string): Boolean;
    function GetTeeBoxTicketInfoLocal(const AReserveNo: string; const ATeeBoxMoved: Boolean; const APrepareMin: Integer; var AErrMsg: string): Boolean;
    function GetTeeBoxTicketInfoServer(const AReserveNo: string; const ATeeBoxMoved: Boolean; var AErrMsg: string): Boolean;
    function SetTeeBoxError(const ATeeBoxNo, AErrorCode: Integer; var AErrMsg: string): Boolean;
    function SetTeeBoxErrorLocal(const ATeeBoxNo, AErrorCode: Integer; var AErrMsg: string): Boolean;
    function SetTeeBoxErrorServer(const ATeeBoxNo, AErrorCode: Integer; var AErrMsg: string): Boolean;
    function ProcSetTeeBoxError(const ATeeBoxNo, AErrorCode: Integer; var AErrMsg: string): Boolean;
    function ProcSetTeeBoxErrorLocal(const ATeeBoxNo, AErrorCode: Integer; var AErrMsg: string): Boolean;
    function SetTeeBoxHold(const ATeeBoxNo, ATeeBoxIndex: Integer; const AUseHold: Boolean; var AErrMsg: string): Boolean;
    function SetTeeBoxHoldLocal(const ATeeBoxNo: Integer; const AUseHold: Boolean; var AEmergency: Boolean; var AErrMsg: string): Boolean;
    function SetTeeBoxHoldServer(const ATeeBoxNo: Integer; const AUseHold: Boolean; var AErrMsg: string): Boolean;
    function SetTeeBoxAgentControl(const ATeeBoxNo, AMethod: Integer; var AErrMsg: string): Boolean;
    procedure UpdateTeeBoxSelection(const ASelected: Boolean; const ATeeBoxNo: Integer; const AFloorCode, AFloorName, AZoneCode: string); overload;
    procedure UpdateTeeBoxSelection(const ASelected: Boolean; const ATeeBoxNo, ATeeBoxIndex: Integer; const AFloorCode, AFloorName, AZoneCode: string; const AIsVIP: Boolean; const ATeeBoxName: string); overload;
    function ImmediateTeeBoxStart(const AChoiceReserveNo: string; var AErrMsg: string): Boolean;
    function GetAirConStatus(var AErrMsg: string): Boolean;
    procedure GetAllowedProdTeeBoxList(const AProdType: string; AItems: TStringList; const ARefreshSource: Boolean=False);
    function GetLockerStatus(var AErrMsg: string): Boolean;
    function GetLockerProdMember(const AMemberNo: string; var AErrMsg: string): Boolean;
    function PostLockerClear(const ALockerNo: Integer; var AErrMsg: string): Boolean;
    function GetFacilityProdMember(const AMemberNo: string; var AErrMsg: string): Boolean;
    function PostUseFacility(const APurchaseCode: string; var AErrMsg: string): Boolean; overload;
    function PostUseFacility(const APurchaseCode: string; var ABarcode, AAccessName, AErrMsg: string): Boolean; overload;
    procedure UpdatePayment(const ATableNo: Integer;
      const AIsApproval, AIsSaleMode, ADeleteExists: Boolean;
      const APayMethod, AVan, ATid, AInternetYN, ACreditCardNo, AApproveNo, AOrgApproveNo, AOrgApproveDate,
            ATradeNo, ATradeDate, AIssuerCode, AISsuerName, ABuyerDiv, ABuyerCode, ABuyerName: string;
      const AInstMonth, AApproveAmt, AVat, AServiceAmt, APromoSeq, APromoDcAmt: Integer;
      const APromoDiv: string);
    function GetWelfareDiscountAmt(const ATableNo: Integer): Integer;
    function UpdateWelfarePayment(const ATableNo: Integer; const ADelimitedGroupTableList: string; AUsePoint: Integer; var AErrMsg: string): Boolean;
    function MakeReceiptJson(const ATeeBoxReserved: Boolean; var AErrMsg: string): string;
    function MakeReIssueReceiptJson(var AErrMsg: string): string; overload;
    function MakeReIssueReceiptJson(const AReceiptNo: string; var AErrMsg: string): string; overload;
    function MakeCancelReceiptJson(ADataSet: TDataSet; var AErrMsg: string): string;
    function MakeTeeBoxTicketJson(var AErrMsg: string): string;
    function GetCouponInfo(const ACouponCode: string; var AErrMsg: string): Boolean;
    function CheckSaleItem(var ADailyTeeBoxCount, AMemberOnlyCount: Integer; var AErrMsg: string): Boolean;
    function CheckAllowedTeeBoxCoupon(const ATeeBoxProdDiv: string; var AErrMsg: string): Boolean;
    function AddPending(const ATableNo: Integer; var AErrMsg: string): Boolean;
    function DeletePending(const AReceiptNo: string; var AErrMsg: string): Boolean;
    function LoadPending(const AReceiptNo: string; var AErrMsg: string): Boolean;
    procedure RefreshActiveGroupTableList(const ATableNo: Integer);
    procedure RefreshReceiptTable(const ATableNo: Integer; const ADelimitedGroupTableList: string='');
    procedure RefreshSaleItemTable(const ATableNo: Integer; const ADelimitedGroupTableList: string='');
    procedure RefreshPaymentTable(const ATableNo: Integer; const ADelimitedGroupTableList: string='');
    procedure RefreshCouponTable(const ATableNo: Integer; const ADelimitedGroupTableList: string='');
    procedure RefreshSaleTables(const ATableNo: Integer; const ADelimitedGroupTableList: string='');
    procedure ClearReceiptTable(const ATableNo: Integer; const ADelimitedGroupTableList: string='');
    procedure ClearSaleItemTable(const ATableNo: Integer; const ADelimitedGroupTableList: string='');
    procedure ClearPaymentTable(const ATableNo: Integer; const ADelimitedGroupTableList: string='');
    procedure ClearCouponTable(const ATableNo: Integer; const ADelimitedGroupTableList: string='');
    procedure ClearSaleTables(const ATableNo: Integer; const ADelimitedGroupTableList: string='');
    procedure ClearMemberInfo(const ATargetID: Integer);
    procedure SetMemberInfo(ADataSet: TDataSet; const AUsePhoto: Boolean=False);
    procedure PaymentCancelUpdate(const APayMethod, AOrgApproveNo, AOrgApproveDate, AApproveNo: string);
    function ApplyCouponDiscount(const ATableNo: Integer; var AErrMsg: string): Integer;
    function ReCalcCouponDiscount(const ATableNo: Integer; var AErrMsg: string): Boolean;
    procedure AddDiscountCoupon(const ATableNo: Integer);
    function DoPaymentPAYCO(const AIsApproval, AIsSaleMode: Boolean; var AErrMsg: string): Boolean;
    function AddParking(const AVender: Integer; const APurchaseCode, ACarNo, AMemberName, AWeekInfo: string; const AStartDate, AEndDate: TDateTime; var AErrMsg: string): Boolean;
    function DeleteParking(const AVender: Integer; const APurchaseCode: string; var AErrMsg: string): Boolean;
    function OldDeleteParking(const AVender: Integer; const AToDay: string; var AErrMsg: string): Boolean;
    function UpdateParkingMember(const AVender: Integer; const APurchaseCode, ACarNo, AMemberName, AEndDay: string; var AErrMsg: string): Boolean;
    function SendACS(const ASendDiv: Integer; const ATeeBoxName: string; var AErrMsg: string): Boolean;
    function SendMemberQrCode(const AMemberNo: string; var AErrMsg: string): Boolean;
    function PrintAddonTicket(const AMemberInfo: string; var AErrMsg: string): Boolean;
    function GetAffiliateAmt(const ATableNo: Integer; var AErrMsg: string): Integer;
    function DoAffiliateProcess(const AOwnerID: Integer; var AErrMsg: string): Boolean;
    function ApplyWelbeingClub(const AIsApproval: Boolean; const ACardNo: string; var AErrMsg: string): Boolean; overload;
    function ApplyWelbeingClub(const AIsApproval: Boolean; const ACardNo: string; var AMemberName, AMemberTelNo, AErrMsg: string): Boolean; overload;
    function ApplyWelbeingClub(const AIsApproval: Boolean; const ACardNo, AOrderCode: string; var AMemberName, AMemberTelNo, AErrMsg: string): Boolean; overload;
    function ApplyRefreshClub(const AQRData: string; const ATestMode: Boolean; var AErrMsg: string): Boolean;
    function ApplyRefreshGolf(const AUserId, ACouponId: Integer; const ATestMode: Boolean; var AErrMsg: string): Boolean;
    function GetRefreshGolfCoupon(const AQRData: string; const ATestMode: Boolean; var AErrMsg: string): Integer;
    function ApplyIKozen(const AMemberNo, AExecId, AExecTime: string; var AMemberName, AErrMsg: string): Boolean;
    function ExtractIKozenQRCode(const AReadData: string; var AMemberCode, AStoreCode, AExecId, AExecTime, AErrMsg: string): Boolean;
    function ApplySmartix(const AMemberNo: string; var AErrMsg: string): Boolean;
    function GetWeatherInfo: Boolean; overload;
    function GetWeatherInfo(var AErrMsg: string): Boolean; overload;
    function DoAdminCall(const ACode: Integer; const AMsg, ASender: string; var AErrMsg: string): Boolean;
    procedure FingerPrintClearUserList;
    function FingerPrintCapture(var ATextFIR, AErrMsg: string): Boolean;
    function FingerPrintAddUser(const ATextFIR: string; const AMemberSeq: Integer; var AErrMsg: string): Boolean;
    function FingerPrintRemoveUser(const AMemberSeq: Integer; var AErrMsg: string): Boolean;
    function FingerPrintMatching(const ATextFIR: string; var AMemberSeq: Integer; var AErrMsg: string): Boolean;
    procedure CreateField(ADataSet: TDataSet; const AFieldName: string; const AFieldKind: TFieldKind; const AFieldType: TFieldType; const AFieldSize: Integer);
    procedure CreateFieldsReceipt(ADataSet: TDataSet);
    procedure CreateFieldsSaleItem(ADataSet: TDataSet);
    procedure CreateFieldsPayment(ADataSet: TDataSet);
    procedure CreateFieldsCoupon(ADataSet: TDataSet);
    function PostStampSave(const AProductCd, AHpNo, ASaveCnt: string; var AErrMsg: string): Boolean;
  end;
var
  ClientDM: TClientDM;
  CouponRec: TCouponRec;
  ChangeProdRec: TChangeProdRec;
  LockerRec: TLockerRec;
  AffiliateRec: TAffiliateRec;
  MemberRec: TMemberRec;
procedure RefreshDataSet(ADataSet: TABSTable); overload;
procedure RefreshDataSet(ADataSet: TABSQuery); overload;
procedure RefreshDataSet(ADataSet: TDataSet); overload;
//메모리 데이터셋 초기화
procedure ClearMemData(ADataSet: TdxMemData);
//ABSQuery
function ExecuteABSQuery(const ASQL: string): Boolean; overload;
function ExecuteABSQuery(const ASQL: string; var AErrMsg: string): Boolean; overload;
//Grid Focused Row Changer
procedure GridRowFocused(AView: TcxGridTableView; const ARowNo: integer);
procedure GridScrollFirst(AView: TcxGridTableView); overload;
procedure GridScrollFirst(AView: TcxGridDBTableView); overload;
procedure GridScrollFirst(AView: TcxGridDBBandedTableView); overload;
procedure GridScrollPageUp(AView: TcxGridTableView); overload;
procedure GridScrollPageUp(AView: TcxGridDBTableView); overload;
procedure GridScrollPageUp(AView: TcxGridDBBandedTableView); overload;
procedure GridScrollUp(AView: TcxGridTableView; const ARowCount: integer=1); overload;
procedure GridScrollUp(AView: TcxGridDBTableView; const ARowCount: integer=1); overload;
procedure GridScrollUp(AView: TcxGridDBBandedTableView; const ARowCount: integer=1); overload;
procedure GridScrollDown(AView: TcxGridTableView; const ARowCount: integer=1); overload;
procedure GridScrollDown(AView: TcxGridDBTableView; const ARowCount: integer=1); overload;
procedure GridScrollDown(AView: TcxGridDBBandedTableView; const ARowCount: integer=1); overload;
procedure GridScrollPageDown(AView: TcxGridTableView); overload;
procedure GridScrollPageDown(AView: TcxGridDBTableView); overload;
procedure GridScrollPageDown(AView: TcxGridDBBandedTableView); overload;
procedure GridScrollLast(AView: TcxGridTableView); overload;
procedure GridScrollLast(AView: TcxGridDBTableView); overload;
procedure GridScrollLast(AView: TcxGridDBBandedTableView); overload;
implementation
uses
  Vcl.Forms, Vcl.Dialogs, System.Math, System.Variants, System.DateUtils, System.IniFiles,
  System.StrUtils, System.JSON, Vcl.Imaging.Jpeg, Vcl.ExtCtrls,
  { ABSDB }
  ABSTypes, ABSConverts,
  { Indy }
  IdTCPClient, IdSSLOpenSSL, IdURI, IdGlobal, IdCoderMIME,
  { Plugin System }
  uPluginManager, uPluginMessages,
  { VAN }
  uPaycoNewModule,
  { Project }
  uXGCommonLib, uXGSaleManager, uXGRefreshClubCoupon, uXGAddonTicket, uHTMLColorConversions,
  uXGMsgBox, uNBioBSPHelper, uUCBioBSPHelper;
{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}
procedure RefreshDataSet(ADataSet: TABSTable);
begin
  RefreshDataSet(TDataSet(ADataSet));
end;
procedure RefreshDataSet(ADataSet: TABSQuery);
begin
  RefreshDataSet(TDataSet(ADataSet));
end;
procedure RefreshDataSet(ADataSet: TDataSet);
begin
  with ADataSet do
  try
    if not Active then
      Open
    else
    begin
      DisableControls;
      Refresh;
    end;
  finally
    EnableControls;
  end;
end;
procedure ClearMemData(ADataSet: TdxMemData);
begin
  with ADataSet do
  begin
    Close;
    Open;
  end;
end;
function ExecuteABSQuery(const ASQL: string): Boolean;
var
  sErrMsg: string;
begin
  Result := ExecuteABSQuery(ASQL, sErrMsg);
end;
function ExecuteABSQuery(const ASQL: string; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := '';
  with TABSQuery.Create(nil) do
  try
    try
      DatabaseName := ClientDM.adbLocal.DatabaseName;
      SQL.Text := ASQL;
{$IFDEF DEBUG}
      SQL.SaveToFile(Global.LogDir + 'ExecuteABSQuery.sql');
{$ENDIF}
      ExecSQL;
      Result := True;
    except
      on E: Exception do
      begin
        AErrMsg := E.Message;
{$IFDEF DEBUG}
        UpdateLog(Global.LogFile, Format('ExecuteABSQuery.SQL = %s', [ASQL]));
{$ENDIF}
        UpdateLog(Global.LogFile, Format('ExecuteABSQuery.Exception = %s', [AErrMsg]));
      end;
    end;
  finally
    Close;
    Free;
  end;
end;
//Grid Focused Specify Row
procedure GridRowFocused(AView: TcxGridTableView; const ARowNo: integer);
begin
  if (ARowNo > 0) and (AView.ViewData.RowCount <= ARowNo) then
    AView.Controller.FocusedRowIndex := Pred(ARowNo);
end;
//Grid Focused Row First
procedure GridScrollFirst(AView: TcxGridTableView);
begin
  if (AView.ViewData.RowCount > 0) then
    AView.Controller.FocusedRowIndex := 0;
end;
procedure GridScrollFirst(AView: TcxGridDBTableView);
begin
  GridScrollFirst(TcxGridTableView(AView));
end;
procedure GridScrollFirst(AView: TcxGridDBBandedTableView);
begin
  GridScrollFirst(TcxGridTableView(AView));
end;
//Grid Focused Row PageUp
procedure GridScrollPageUp(AView: TcxGridTableView);
begin
//  AView.Controller.GoToPrev(False, True);
  AView.Site.Perform(WM_KEYDOWN, VK_PRIOR, 0);
  AView.Site.Perform(WM_KEYUP, VK_PRIOR, 0);
end;
procedure GridScrollPageUp(AView: TcxGridDBTableView);
begin
  GridScrollPageUp(TcxGridTableView(AView));
end;
procedure GridScrollPageUp(AView: TcxGridDBBandedTableView);
begin
  GridScrollPageUp(TcxGridTableView(AView));
end;
//Grid Focused Row Previous
procedure GridScrollUp(AView: TcxGridTableView; const ARowCount: integer);
var
  nFocusedRowIndex: integer;
begin
  nFocusedRowIndex := (AView.Controller.FocusedRowIndex - ARowCount);
  if (nFocusedRowIndex < 0) then
    nFocusedRowIndex := Pred(AView.ViewData.RowCount);
//    nFocusedRowIndex := 0;
  AView.Controller.FocusedRowIndex := nFocusedRowIndex;
end;
procedure GridScrollUp(AView: TcxGridDBTableView; const ARowCount: integer);
begin
  GridScrollUp(TcxGridTableView(AView), ARowCount);
end;
procedure GridScrollUp(AView: TcxGridDBBandedTableView; const ARowCount: integer);
begin
  GridScrollUp(TcxGridTableView(AView), ARowCount);
end;
//Grid Focused Row Next
procedure GridScrollDown(AView: TcxGridTableView; const ARowCount: integer);
var
  nFocusedRowIndex: integer;
begin
  nFocusedRowIndex := (AView.Controller.FocusedRowIndex + ARowCount);
  if (nFocusedRowIndex > Pred(AView.ViewData.RowCount)) then
    nFocusedRowIndex := 0;
//    nFocusedRowIndex := Pred(AView.ViewData.RowCount);
  AView.Controller.FocusedRowIndex := nFocusedRowIndex;
end;
procedure GridScrollDown(AView: TcxGridDBTableView; const ARowCount: integer);
begin
  GridScrollDown(TcxGridTableView(AView), ARowCount);
end;
procedure GridScrollDown(AView: TcxGridDBBandedTableView; const ARowCount: integer);
begin
  GridScrollDown(TcxGridTableView(AView), ARowCount);
end;
//Grid Focused Row PageDown
procedure GridScrollPageDown(AView: TcxGridTableView);
begin
//  AView.Controller.GoToNext(False, True);
  AView.Site.Perform(WM_KEYDOWN, VK_NEXT, 0);
  AView.Site.Perform(WM_KEYUP, VK_NEXT, 0);
end;
procedure GridScrollPageDown(AView: TcxGridDBTableView);
begin
  GridScrollPageDown(TcxGridTableView(AView));
end;
procedure GridScrollPageDown(AView: TcxGridDBBandedTableView);
begin
  GridScrollPageDown(TcxGridTableView(AView));
end;
//Grid Focused Row Last
procedure GridScrollLast(AView: TcxGridTableView);
begin
  AView.Controller.FocusedRowIndex := Pred(AView.ViewData.RowCount);
end;
procedure GridScrollLast(AView: TcxGridDBTableView);
begin
  GridScrollLast(TcxGridTableView(AView));
end;
procedure GridScrollLast(AView: TcxGridDBBandedTableView);
begin
  GridScrollLast(TcxGridTableView(AView));
end;
{ TClientDM }
procedure TClientDM.DataModuleCreate(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to Pred(ComponentCount) do
    if (Components[I] is TdxMemData) then
      TdxMemData(Components[I]).Active := True;
  conTeeBox.Options.LocalFailover := True;
  conParking.Options.LocalFailover := True;
end;
procedure TClientDM.DataModuleDestroy(Sender: TObject);
begin
  Global.Closing := True;
end;
procedure TClientDM.conParkingBeforeConnect(Sender: TObject);
begin
  with TUniConnection(Sender) do
  begin
    ProviderName := 'MySQL';
    LoginPrompt := False;
    Database := Global.ParkingServer.Database;
    SpecificOptions.Clear;
    SpecificOptions.Add('MySQL.CharSet=utf8');
    SpecificOptions.Add('MySQL.UseUniCode=True');
    SpecificOptions.Add('MySQL.ConnectionTimeOut=30');
    Server := Format('%s,%d Allow User Variables=True', [Global.ParkingServer.Host, Global.ParkingServer.DBPort]);
    Port := Global.ParkingServer.DBPort;
    UserName := Global.ParkingServer.DBUser;
    Password := Global.ParkingServer.DBPwd;
  end;
end;
procedure TClientDM.conParkingConnectionLost(Sender: TObject; Component: TComponent; ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
begin
  RetryMode := rmReconnectExecute;
end;
procedure TClientDM.conTeeBoxBeforeConnect(Sender: TObject);
begin
  with TUniConnection(Sender) do
  begin
    ProviderName := 'MySQL';
    LoginPrompt := False;
    Database := CCD_TEEBOX_DB;
    SpecificOptions.Clear;
    SpecificOptions.Add('MySQL.CharSet=euckr');
    SpecificOptions.Add('MySQL.UseUniCode=False');
    SpecificOptions.Add('MySQL.ConnectionTimeOut=30');
    Server := Format('%s,%d Allow User Variables=True', [Global.TeeBoxADInfo.Host, Global.TeeBoxADInfo.DBPort]);
    Port := Global.TeeBoxADInfo.DBPort;
    UserName := Global.TeeBoxADInfo.DBUser;
    Password := Global.TeeBoxADInfo.DBPwd;
  end;
end;
procedure TClientDM.conTeeBoxConnectionLost(Sender: TObject; Component: TComponent; ConnLostCause: TConnLostCause; var RetryMode: TRetryMode);
begin
  RetryMode := rmReconnectExecute;
end;
function TClientDM.CheckABSDatabase(const ADBFile: string; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := '';
  try
    adbLocal.DatabaseFileName := ADBFile;
    if not TBEmergency.Exists then
      CreateTeeBoxEmergencyTable;
    if adbLocal.Connected then
      adbLocal.Connected := False;
    adbLocal.CompactDatabase;
    adbLocal.RepairDatabase;
    QRReceipt.Open;
    QRSaleItem.Open;
    QRPayment.Open;
    QRCoupon.Open;
    if (QRReceipt.FindField('table_no') = nil) or
       (QRReceipt.FindField('group_no') = nil) then
      raise Exception.Create('이전 버전의 데이터베이스를 사용 중입니다.');
    Result := True;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      adbLocal.Connected := False;
      UpdateLog(Global.LogFile, Format('CheckABSDatabase.Exception = %s', [E.Message]));
    end;
  end;
end;
procedure TClientDM.CreateTeeBoxEmergencyTable;
begin
  with TBEmergency.FieldDefs do
  begin
    Clear;
    Add('reserve_no', ftString, 12, False);
    Add('org_reserve_no', ftString, 12, False);
    Add('teebox_no', ftInteger, 0, False);
    Add('teebox_nm', ftString, 20, False);
    Add('prepare_min', ftInteger, 0, False);
    Add('assign_min', ftInteger, 0, False);
    Add('reserve_datetime', ftString, 19, False); //yyyy-mm-dd hh:nn:ss
    Add('start_datetime', ftString, 19, False); //yyyy-mm-dd hh:nn:ss
    Add('member_nm', ftString, 30, False);
    Add('status', ftString, 10, False);
    Add('updated', ftDateTime, 0, False);
  end;
  with TBEmergency.IndexDefs do
  begin
    Clear;
    Add('TBEmergency_PK', 'reserve_no', [ixPrimary]);
  end;
  TBEmergency.CreateTable;
end;
procedure TClientDM.ImportMemData(ADataSet: TdxMemData);
var
  sFileName: string;
begin
  with ADataSet do
  begin
    Close;
    sFileName := Global.DataDir + ADataSet.Name + CDB_EXTENSION;
    if FileExists(sFileName) then
      LoadFromBinaryFile(sFileName);
    Open;
  end;
end;
function TClientDM.ImportMemDataAll(var AErrMsg: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  AErrMsg := '';
  try
    for I := 0 to Pred(ComponentCount) do
      if (Components[I] is TdxMemData) then
        ImportMemData(TdxMemData(Components[I]));
    Result := True;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('CheckABSDatabase.Exception = %s', [E.Message]));
    end;
  end;
end;
procedure TClientDM.ExportMemData(ADataSet: TdxMemData);
begin
  with ADataSet do
  begin
    if not Active then
      Open;
    SaveToBinaryFile(Global.DataDir + ADataSet.Name + CDB_EXTENSION);
  end;
end;
function TClientDM.ExportMemDataAll(var AErrMsg: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  AErrMsg := '';
  try
    for I := 0 to Pred(ComponentCount) do
      if (Components[I] is TdxMemData) then
        ExportMemData(TdxMemData(Components[I]));
    Result := True;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('ExportMemDataAll.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetDataVersion(const AProductType: string): Integer;
begin
  Result := -1;
  with MDVersion do
  begin
    if not Active then
      Active := True;
    if Locate('product_type', AProductType, []) and
       (not FieldByName('version_no').IsNull) then
      Result := FieldByName('version_no').AsInteger;
  end;
end;
function TClientDM.GetICReaderVerify(var AErrMsg: string): Boolean;
var
  sMsg: Ansistring;
begin
  Result := False;
  AErrMsg := '';
  try
    if (not VanModule.CallICReaderVerify(SaleManager.StoreInfo.CreditTID, sMsg)) then
      raise Exception.Create(sMsg);
    Result := True;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetICReaderVerify.Exception = %s', [E.Message]));
    end;
  end;
end;
procedure TClientDM.SetDataVersion(const AProductType: string; const AVersion: Integer);
begin
  if (AVersion < 0) then
    Exit;
  with MDVersion do
  try
    if not Active then
      Active := True;
    DisableControls;
    if not Locate('product_type', AProductType, []) then
    begin
      Append;
      FieldValues['product_type'] := AProductType;
    end
    else
      Edit;
    FieldValues['version_no'] := AVersion;
    Post;
  finally
    EnableControls;
  end;
end;
function TClientDM.GetToken(const AClientId, AClientKey: string; var AToken: string; var AErrMsg: string): Boolean;
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS, RS: TStringStream;
  JO: TJSONObject;
  JV: TJSONValue;
  sAuth: AnsiString;
  sUrl: string;
begin
  Result := False;
  AToken := '';
  AErrMsg := '';
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  JO := nil;
  JV := nil;
  SS := TStringStream.Create;
  RS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    try
      sAuth := Base64Encode(AClientId + ':' + AClientKey, True);
      HC.Request.ContentType := 'application/x-www-form-urlencoded';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Basic ' + sAuth;
      HC.Request.Method := 'POST';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      SS.WriteString(TIdURI.ParamsEncode('grant_type=client_credentials'));
      sUrl := Format('%s/oauth/token', [Global.ClientConfig.Host]);
      HC.Post(sUrl, SS, RS);
      JO := TJSONObject.ParseJSONValue(RS.DataString) as TJSONObject;
      JV := JO.GetValue('access_token');
      AToken := JV.Value;
      Result := True;
    finally
      FreeAndNilJSONObject(JV);
      FreeAndNilJSONObject(JO);
      FreeAndNil(RS);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetToken.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.CheckToken(const AToken, AClientId, AClientKey: string; var AErrMsg: string): Boolean;
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS, RS: TStringStream;
  JO: TJSONObject;
  JV: TJSONValue;
  sAuth: AnsiString;
  sUrl: string;
begin
  Result := False;
  AErrMsg := '';
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  JO := nil;
  JV := nil;
  SS := TStringStream.Create;
  RS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    try
      sAuth := Base64Encode(AClientId + ':' + AClientKey, True);
      HC.Request.ContentType := 'application/x-www-form-urlencoded';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Basic ' + sAuth;
      HC.Request.Method := 'POST';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      SS.WriteString(TIdURI.ParamsEncode('token=' + AToken));
      sUrl := Format('%s/oauth/check_token', [Global.ClientConfig.Host]);
      HC.Post(sUrl, SS, RS);
      RS.SaveToFile(Global.LogDir + 'CheckToken.json');
      JO := TJSONObject.ParseJSONValue(RS.DataString) as TJSONObject;
      JV := JO.GetValue('client_id');
      Result := True;
    finally
      FreeAndNilJSONObject(JV);
      FreeAndNilJSONObject(JO);
      FreeAndNil(RS);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('CheckToken.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetTerminalInfo(var AErrMsg: string): Boolean;
const
  CS_API = 'K104_Terminal';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO, RO: TJSONObject;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  JO := nil;
  RO := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?client_id=%s', [Global.ClientConfig.Host, CS_API, Global.ClientConfig.ClientId]);
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg  := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      RO := JO.GetValue('result_data') as TJSONObject;
      SaleManager.StoreInfo.StoreCode   := RO.GetValue('store_cd').Value;
      SaleManager.StoreInfo.StoreName   := RO.GetValue('store_nm').Value;
      SaleManager.StoreInfo.POSNo       := Global.ClientConfig.ClientId; //RO.GetValue('pos_no').Value;
      SaleManager.StoreInfo.POSName     := RO.GetValue('terminal_nm').Value;
      SaleManager.StoreInfo.SaleZoneCode:= RO.GetValue('sale_zone_code').Value;
      SaleManager.StoreInfo.POSType     := StrToIntDef(SaleManager.StoreInfo.SaleZoneCode, CPO_SALE_TEEBOX);
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(RO);
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetTerminalInfo.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.CheckTeeBoxHoldTime(AList: TStringList; var AErrMsg: string): Boolean;
var
  sErrMsg, sHoldDateTime, sNewDateTime, sTeeBoxName, sFmtMsg: string;
  nTeeBoxNo, nDiffMin: Integer;
  dHoldDateTime, dNewDateTime: TDateTime;
begin
  Result := True;
  AErrMsg := '';
  try
    if not GetTeeBoxStatus(MDTeeBoxStatus, sErrMsg) then
      raise Exception.Create(sErrMsg);
    MDTeeBoxStatus4.CopyFromDataSet(MDTeeBoxStatus);
    with MDTeeBoxSelected do
    try
      DisableControls;
      First;
      while not Eof do
      begin
        nTeeBoxNo := FieldByName('teebox_no').AsInteger;
        if MDTeeBoxStatus4.Locate('teebox_no', nTeeBoxNo, []) then
        begin
          sNewDateTime := MDTeeBoxStatus4.FieldByName('end_datetime').AsString;
          sTeeBoxName := FieldByName('teebox_nm').AsString;
          sHoldDateTime := FieldByName('hold_datetime').AsString;
          if not sNewDateTime.IsEmpty then
          begin
            sFmtMsg := Format('▶타석=%s  ▶요청시각=%s  ▶배정시각=%s', [sTeeBoxName, FormatDateTime('hh:nn', Now), Copy(sNewDateTime, 12, 5)]);
            dHoldDateTime := StrToDateTime(FieldByName('hold_datetime').AsString, Global.FS);
            dNewDateTime := StrToDateTime(sNewDateTime, Global.FS);
            nDiffMin := MinutesBetween(dNewDateTime, dHoldDateTime);
            if (nDiffMin >= 10) then
              AList.Add(sFmtMsg);
          end;
        end;
        Next;
      end;
    finally
      EnableControls;
    end;
    Result := (AList.Count = 0);
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('CheckTeeBoxHoldTime.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.CheckTeeBoxProdTime(const AProductCode, AReserveDateTime: string; const ATeeBoxNo: Integer; var AAssignMin: Integer; var AErrMsg: string): Boolean;
const
  CS_API = 'K222_TeeBoxProductTime';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO1, JO2: TJSONObject;
  RS: TStringStream;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sStartTime, sEndTime: string;
  dStartTime, dEndTime: TDateTime;
  bLimitProduct: Boolean;
begin
  Result := False;
  AErrMsg := '';
  AAssignMin := 0;
  JO1 := nil;
  JO2 := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  RS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    ClearMemData(MDTeeBoxIssued2);
    MDTeeBoxIssued2.DisableControls;
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&product_cd=%s&reserve_datetime=%s&teebox_no=%d',
        [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, AProductCode, AReserveDateTime, ATeeBoxNo]);
      HC.Get(sUrl, RS);
      RS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO1 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO1.GetValue('result_cd').Value;
      sResMsg  := JO1.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if (JO1.FindValue('result_data') is TJSONNull) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      JO2 := JO1.GetValue('result_data') as TJSONObject;
      AAssignMin := StrToIntDef(JO2.GetValue('one_use_time').Value, AAssignMin);
      bLimitProduct := (JO2.GetValue('limit_product_yn').Value = CRC_YES);
      if bLimitProduct then
      begin
        sStartTime := FormattedTimeString(Copy(AReserveDateTime, 9, 6));
        sEndTime := JO2.GetValue('end_time').Value;
        if (Copy(sStartTime, 1, 5) > sEndTime) then
        begin
          dStartTime := StrToDateTime(Format('%s %s', [FormattedDateString(Copy(AReserveDateTime, 1, 8)), sStartTime]), Global.FS);
          dEndTime := IncMinute(dStartTime, AAssignMin);
          if (not SaleManager.StoreInfo.EndTimeIgnoreYN) and //영업 종료시각 체크 여부
             (dEndTime > SaleManager.StoreInfo.StoreEndDateTime) then
            AAssignMin := MinutesBetween(dStartTime, SaleManager.StoreInfo.StoreEndDateTime);
          //올빼미 상품을 위한 상품시각 추적 로그
          UpdateLog(Global.LogFile,
            Format('CheckTeeBoxProdTime.Result = 상품코드: %s, 예약: %s %s, 배정시간: %d, 시작: %s, 종료: %s',
              [AProductCode, FormattedDateString(AReserveDateTime.Substring(0, 8)), FormattedTimeString(AReserveDateTime.Substring(8)), AAssignMin, FormatDateTime('yyyy-mm-dd hh:nn', dStartTime), FormatDateTime('yyyy-mm-dd hh:nn', dEndTime)]));
        end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      MDTeeBoxIssued2.EnableControls;
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JO1);
      FreeAndNil(RS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('CheckTeeBoxProdTime.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetTeeBoxProdMemberCheck(const AMemberNo: string; var AErrMsg: string): Boolean;
begin
  Result := False;
  try
    with TUniStoredProc.Create(nil) do
    try
      Connection := conTeeBox;
      StoredProcName := 'SP_UPD_MEMBER_HOLD_CHECK';
      Params.Clear;
      Params.CreateParam(ftString, 'p_store_cd', ptInput).AsString := SaleManager.StoreInfo.StoreCode;
      Params.CreateParam(ftString, 'p_member_cd', ptInput).AsString := AMemberNo;
      Params.CreateParam(ftString, 'p_device_nm', ptInput).AsString := SaleManager.StoreInfo.POSName;
      Prepared := True;
      Open;
      Result := FieldByName('memberYN').AsBoolean;
    finally
      Close;
      Free;
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetTeeBoxProdMemberCheck.Exception = %s', [AErrMsg]));
    end;
  end;
end;
function TClientDM.CheckLogin(const AUserId, ATerminalPwd: string; var AErrMsg: string): Boolean;
const
  CS_API = 'K103_CheckLogin';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO, RO: TJSONObject;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  JO := nil;
  RO := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?account_id=%s&store_cd=%s&terminal_pwd=%s',
        [Global.ClientConfig.Host, CS_API, AUserId, SaleManager.StoreInfo.StoreCode, ATerminalPwd]);
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg  := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      RO := JO.GetValue('result_data') as TJSONObject;
      SaleManager.UserInfo.UserId   := RO.GetValue('account_id').Value;
      SaleManager.UserInfo.UserName := RO.GetValue('account_nm').Value;
      SaleManager.UserInfo.HpNo     := RO.GetValue('hp_no').Value;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(RO);
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('CheckLogin.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetConfigListNew(var AErrMsg: string): Boolean;
const
  CS_API = 'K202_ConfiglistNew';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO: TJSONObject;
  RBS: RawByteString;
  MI: TMemIniFile;
  SL, IL: TStringList;
  sUrl, sResCode, sResMsg, sSettings, sSection, sKey, sValue: string;
  I, J: Integer;
begin
  if Global.ClientConfig.UseLocalSetting then
  begin
    UpdateLog(Global.LogFile, Format('GetConfigListNew.Skipped. (UseLocalSetting = %s)', [BoolToStr(Global.ClientConfig.UseLocalSetting)]));
    Exit(True);
  end;
  Result := False;
  AErrMsg := '';
  JO := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?client_id=%s&store_cd=%s&search_date=%s',
        [Global.ClientConfig.Host, CS_API, Global.ClientConfig.ClientId, SaleManager.StoreInfo.StoreCode, Global.ConfigUpdated]);
      SS.Clear;
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO.FindValue('settings') is TJSONNull) then
      begin
        sSettings := JO.GetValue('settings').Value;
        if not sSettings.IsEmpty then
        begin
          SS.Clear;
          SS.WriteString(sSettings);
          SL := TStringList.Create;
          IL := TStringList.Create;
          MI := TMemIniFile.Create(SS, TEncoding.ANSI);
          try
            MI.ReadSections(SL);
            for I := 0 to Pred(SL.Count) do
            begin
              sSection := SL[I];
              MI.ReadSection(sSection, IL);
              for J := 0 to Pred(IL.Count) do
              begin
                sKey := IL[J];
                sValue := MI.ReadString(sSection, sKey, '');
                Global.Config.WriteString(sSection, sKey, sValue);
              end;
            end;
          finally
            FreeAndNil(IL);
            FreeAndNil(SL);
            FreeAndNil(MI);
            Global.ConfigUpdated := (Global.CurrentDate + Global.CurrentTime);
            Global.ReadConfig;
          end;
        end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetConfigListNew.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.PostConfigList(var AErrMsg: string): Boolean;
const
  CS_API = 'K202_ConfigUpdate';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO, RO: TJSONObject;
  SS, RS: TStringStream;
  SL: TStrings;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  JO := TJSONObject.Create;
  RO := nil;
  SL := TStringList.Create;
  RS := TStringStream.Create;
  SS := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    SL.LoadFromFile(Global.ConfigFileName);
    JO.AddPair(TJSONPair.Create('store_cd', SaleManager.StoreInfo.StoreCode));
    JO.AddPair(TJSONPair.Create('client_id', Global.ClientConfig.ClientId));
    JO.AddPair(TJSONPair.Create('settings', UTF8String(SL.Text)));
    SS := TStringStream.Create(JO.ToString, TEncoding.UTF8);
    try
      HC.Request.ContentType := 'application/json';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'POST';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s', [Global.ClientConfig.Host, CS_API]);
      HC.Post(sUrl, SS, RS);
      RS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      RO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := RO.GetValue('result_cd').Value;
      sResMsg := RO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNil(SL);
      FreeAndNilJSONObject(RO);
      FreeAndNilJSONObject(JO);
      FreeAndNil(RS);
      if Assigned(SS) then
        FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('PostConfigList.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetStoreInfo(var AErrMsg: string): Boolean;
const
  CS_API = 'K203_StoreInfo';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO, RO: TJSONObject;
  JV: TJSONValue;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sValue, sErrMsg: string;
{$IFDEF RELEASE}
  dSvrTime: TDateTime;
{$ENDIF}
  I, J, nCount: Integer;
  SL: TStrings;
begin
  Result := False;
  AErrMsg := '';
  JO := nil;
  RO := nil;
  JV := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      SaleManager.StoreInfo.CreditTID := Global.ConfigRegistry.ReadString('StoreInfo', 'CreditTID', '');
      SaleManager.StoreInfo.PaycoTID := Global.ConfigRegistry.ReadString('StoreInfo', 'PaycoTID', '');
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s',
        [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode]);
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg  := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO.FindValue('result_data') is TJSONNull) then
      begin
        RO := JO.GetValue('result_data') as TJSONObject;
        with SaleManager.StoreInfo do
        begin
          StoreName       := RO.GetValue('store_nm').Value;
          BizNo           := RO.GetValue('biz_no').Value;
          Company         := RO.GetValue('upper_store_nm').Value;
          CEO             := RO.GetValue('owner_nm').Value;
          Address         := RO.GetValue('address').Value + ' ' + RO.GetValue('address_desc').Value;
          TelNo           := RO.GetValue('tel_no').Value;
          StoreStartTime  := RO.GetValue('start_time').Value;
          StoreEndTime    := RO.GetValue('end_time').Value;
          ShutdownTimeout := StrToIntDef(RO.GetValue('shutdown_timeout').Value, 0);
          EndTimeIgnoreYN := (RO.GetValue('end_time_ignore_yn').Value = CRC_YES);
          CloseStartTime  := RO.GetValue('close_start_date').Value;
          CloseEndTime    := RO.GetValue('close_end_date').Value;
          UseRewardYN     := (RO.GetValue('use_reward_yn').Value = CRC_YES);
          EndYN           := (RO.GetValue('end_yn').Value = CRC_YES);
          UseAcsYN        := (RO.GetValue('acs_use_yn').Value = CRC_YES);
          FacilityProdYN  := (RO.GetValue('facility_product_yn').Value = CRC_YES);
          StoreMemo       := RO.GetValue('memo').Value;
          OutdoorDiv      := StrToIntDef(RO.GetValue('outdoor_div').Value, 0); //1:실외, 2:실내
          StoreUpdated    := RO.GetValue('chg_date').Value;
          SpectrumYN      := (RO.GetValue('spectrum_yn').Value = CRC_YES);
          SpectrumHistUrl := RO.GetValue('spectrum_hist_url').Value;
          LockerListOrder := StrToIntDef(RO.GetValue('pos_locker_order_div').Value, CLO_FLOOR_ZONE_LOCKER); //1:층/구역코드/라커번호순, 2:층/라커번호/구역코드순
          StampYN         := (RO.GetValue('stamp_yn').Value = CRC_YES);
          if (Global.AdminCallHandle <> 0) then
          begin
            sValue := Format('영업시간: %s ~ %s', [
              FormatDateTime('yyyy-mm-dd hh:nn', SaleManager.StoreInfo.StoreStartDateTime),
              FormatDateTime('yyyy-mm-dd hh:nn', SaleManager.StoreInfo.StoreEndDateTime)]);
            DoAdminCall(0, sValue, 'POS', sErrMsg);
          end;
          if UseAcsYN and
             (not (RO.FindValue('acs_config_list') is TJSONNull)) then
          begin
            JV := RO.Get('acs_config_list').JsonValue;
            nCount := (JV as TJSONArray).Count;
            try
              MDACSList.DisableControls;
              ClearMemData(MDACSList);
              if (nCount > 0) then
              try
                SL := TStringList.Create;
                SL.StrictDelimiter := True;
                SL.Delimiter := ',';
                for I := 0 to Pred(nCount) do
                begin
                  SL.DelimitedText := (JV as TJSONArray).Items[I].P['recv_hp_no'].Value;
                  for J := 0 to Pred(SL.Count) do
                  begin
                    MDACSList.Append;
                    MDACSList.FieldValues['send_div'] := StrToIntDef((JV as TJSONArray).Items[I].P['send_div'].Value, 0);
                    MDACSList.FieldValues['failure_second'] := StrToIntDef((JV as TJSONArray).Items[I].P['failure_second'].Value, 0);
                    MDACSList.FieldValues['recv_hp_no'] := SL.Strings[J];
                    MDACSList.Post;
                  end;
                end;
              finally
                FreeAndNil(SL);
              end;
            finally
              MDACSList.First;
              MDACSList.EnableControls;
            end;
          end;
{$IFDEF RELEASE}
          sValue := Trim(RO.GetValue('server_time').Value);
          if (Length(sValue) = 14) then
          begin
            dSvrTime := StrToDateTime(Format('%s-%s-%s %s:%s:%s',
              [
                Copy(sValue, 1, 4),
                Copy(sValue, 5, 2),
                Copy(sValue, 7, 2),
                Copy(sValue, 9, 2),
                Copy(sValue, 11, 2),
                Copy(sValue, 13, 2)
              ]), Global.FS);
            ChangeSystemTime(dSvrTime);
          end;
{$ENDIF}
        end;
      end;
      RefreshTeeBoxUsingCounter;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JV);
      FreeAndNilJSONObject(RO);
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetStoreInfo.Exception = %s', [AErrMsg]));
    end;
  end;
end;
function TClientDM.GetTableList(var AErrMsg: string): Boolean;
const
  CS_API = 'K242_OrderTableList';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO: TJSONObject;
  JV: TJSONValue;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg: string;
  nTable, nCount: Integer;
  SL: TStrings;
  bExistsTableInfo: Boolean;
begin
  Result := False;
  AErrMsg := '';
  JO := nil;
  JV := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&del_yn=%s&search_date=%s', [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, CRC_NO, '']);
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg  := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO.FindValue('result_data') is TJSONNull) then
      begin
        Global.TableInfo.Reset;
        JV := JO.Get('result_data').JsonValue;
        nCount := (JV as TJSONArray).Count;
        bExistsTableInfo := (nCount > 0);
        if not bExistsTableInfo then
          nCount := 10;
        for nTable := 1 to nCount do
        begin
          SetLength(Global.TableInfo.Items, nTable + 1);
          if bExistsTableInfo then
          begin
            Global.TableInfo.Items[nTable].TableNo := StrToIntDef((JV as TJSONArray).Items[nTable-1].P['table_no'].Value, nTable);
            Global.TableInfo.Items[nTable].TableName := (JV as TJSONArray).Items[nTable-1].P['table_nm'].Value;
          end
          else
          begin
            Global.TableInfo.Items[nTable].TableNo := nTable;
            Global.TableInfo.Items[nTable].TableName := IntToStr(nTable);
          end;
          Global.TableInfo.Items[nTable].GroupNo := 0;
          Global.TableInfo.Items[nTable].EnteredTime := 0;
          Global.TableInfo.Items[nTable].ElapsedMinutes := 0;
          Global.TableInfo.Items[nTable].GuestCount := 0;
          Global.TableInfo.Items[nTable].OrderMemo := '';
        end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JV);
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetTableList.Exception = %s', [AErrMsg]));
    end;
  end;
end;
function TClientDM.GetTeeBoxList(var AErrMsg: string): Boolean;
const
  CS_API_1 = 'K203_TeeBoxVersion';
  CS_API_2 = 'K204_TeeBoxlist';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO1, RO1, JO2: TJSONObject;
  JV2: TJSONValue;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sProdType, sFloorCode, sFloorTemp, sFloorName: string;
  I, nCurVer, nNewVer, nFloorIndex, nFloorCount, nCount: Integer;
begin
  Result := False;
  sProdType := '';
  AErrMsg := '';
  JV2 := nil;
  JO1 := nil;
  JO2 := nil;
  RO1 := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s', [Global.ClientConfig.Host, CS_API_1, SaleManager.StoreInfo.StoreCode]);
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API_1 + '.Response.json');
      JO1 := TJSONObject.ParseJSONValue(SS.DataString) as TJSONObject;
      sResCode := JO1.GetValue('result_cd').Value;
      sResMsg := JO1.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      nNewVer := -1;
      if not (JO1.FindValue('result_data') is TJSONNull) then
      begin
        RO1 := JO1.GetValue('result_data') as TJSONObject;
        sProdType := RO1.GetValue('product_type').Value;
        nNewVer := StrToIntDef(RO1.GetValue('version_no').Value, 0);
      end;
      nCurVer := GetDataVersion(sProdType);
      if (nNewVer = -1) or
         (nNewVer > nCurVer) then
      begin
        SetDataVersion(sProdType, nNewVer);
        sUrl := Format('%s/wix/api/%s?store_cd=%s&client_id=%s', [Global.ClientConfig.Host, CS_API_2, SaleManager.StoreInfo.StoreCode, Global.ClientConfig.ClientId]);
        UpdateLog(Global.LogFile, Format('GetTeeBoxList.Request = %s', [sUrl]));
        SS.Clear;
        HC.Get(sUrl, SS);
        SS.SaveToFile(Global.LogDir + CS_API_2 + '.Response.json');
        RBS := PAnsiChar(SS.Memory);
        SetCodePage(RBS, 65001, False);
        JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
        sResCode := JO2.GetValue('result_cd').Value;
        sResMsg  := JO2.GetValue('result_msg').Value;
        if (sResCode <> CRC_SUCCESS) then
          raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
        if not (JO2.FindValue('result_data') is TJSONNull) then
        begin
          sFloorTemp  := '';
          nFloorCount := 0;
          nFloorIndex := 0;
          SetLength(Global.TeeBoxFloorInfo, 0);
          JV2 := JO2.Get('result_data').JsonValue;
          nCount := (JV2 as TJSONArray).Count;
          if (nCount > 0) then
          begin
            MDTeeBox.DisableControls;
            try
              ClearMemData(MDTeeBox);
              for I := 0 to Pred(nCount) do
              begin
                if ((JV2 as TJSONArray).Items[I].P['del_yn'].Value = CRC_YES) then
                  Continue;
                sFloorCode := (JV2 as TJSONArray).Items[I].P['floor_cd'].Value;
                sFloorName := (JV2 as TJSONArray).Items[I].P['floor_nm'].Value;
                if (sFloorCode <> sFloorTemp) then
                begin
                  sFloorTemp := sFloorCode;
                  nFloorIndex := nFloorCount;
                  Inc(nFloorCount);
                  SetLength(Global.TeeBoxFloorInfo, nFloorCount);
                  Global.TeeBoxFloorInfo[nFloorIndex].FloorCode := sFloorCode;
                  Global.TeeBoxFloorInfo[nFloorIndex].FloorName := sFloorName;
                  Global.TeeBoxFloorInfo[nFloorIndex].TeeBoxCount := 0;
                end;
                Inc(Global.TeeBoxFloorInfo[nFloorIndex].TeeBoxCount);
                with MDTeeBox do
                begin
                  Append;
                  FieldValues['teebox_no'] := StrToInt((JV2 as TJSONArray).Items[I].P['teebox_no'].Value);
                  FieldValues['teebox_nm'] := (JV2 as TJSONArray).Items[I].P['teebox_nm'].Value;
                  FieldValues['device_id'] := (JV2 as TJSONArray).Items[I].P['device_id'].Value;
                  FieldValues['floor_cd']  := sFloorCode;
                  FieldValues['floor_nm']  := sFloorName;
                  FieldValues['vip_yn']    := ((JV2 as TJSONArray).Items[I].P['vip_yn'].Value = CRC_YES);
                  FieldValues['use_yn']    := ((JV2 as TJSONArray).Items[I].P['use_yn'].Value = CRC_YES);
                  FieldValues['zone_cd']   := (JV2 as TJSONArray).Items[I].P['zone_div'].Value;
                  FieldValues['control_yn']:= (JV2 as TJSONArray).Items[I].P['control_yn'].Value;
                  Post;
                end;
              end;
              for I := 0 to Pred(Length(Global.TeeBoxFloorInfo)) do
                if (Global.TeeBoxMaxCountOfFloors < Global.TeeBoxFloorInfo[I].TeeBoxCount) then
                  Global.TeeBoxMaxCountOfFloors := Global.TeeBoxFloorInfo[I].TeeBoxCount;
            finally
              MDTeeBox.EnableControls;
            end;
          end;
        end;
      end;
      RefreshTeeboxViewData(CPC_TEEBOX_LAYOUT);
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JV2);
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(RO1);
      FreeAndNilJSONObject(JO1);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetTeeBoxList.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetTeeBoxListEmergency(var AErrMsg: string): Boolean;
var
  sStoreCode, sFloorCode, sFloorTemp: string;
  I, nFloorIndex, nFloorCount: Integer;
begin
  Result := False;
  AErrMsg := '';
  try
    Screen.Cursor := crSQLWait;
    sStoreCode := SaleManager.StoreInfo.StoreCode;
    if sStoreCode.IsEmpty then
      sStoreCode := Global.ClientConfig.ClientId.Substring(0, 5);
    with TUniStoredProc.Create(nil) do
    try
      MDTeeBox.DisableControls;
      ClearMemData(MDTeeBox);
      sFloorTemp  := '';
      nFloorCount := 0;
      nFloorIndex := 0;
      SetLength(Global.TeeBoxFloorInfo, 0);
      Connection := conTeeBox;
      StoredProcName := 'SP_GET_TEEBOX_LIST';
      Params.Clear;
      Params.CreateParam(ftString, 'p_store_cd', ptInput).AsString := sStoreCode;
      Prepared := True;
      Open;
      First;
      while not Eof do
      begin
        sFloorCode := FieldByName('FLOOR_ZONE_CODE').AsString;
        if (sFloorCode <> sFloorTemp) then
        begin
          sFloorTemp := sFloorCode;
          nFloorIndex := nFloorCount;
          Inc(nFloorCount);
          SetLength(Global.TeeBoxFloorInfo, nFloorCount);
          Global.TeeBoxFloorInfo[nFloorIndex].FloorCode := sFloorCode;
          Global.TeeBoxFloorInfo[nFloorIndex].FloorName := sFloorCode;
          Global.TeeBoxFloorInfo[nFloorIndex].TeeBoxCount := 0;
        end;
        Inc(Global.TeeBoxFloorInfo[nFloorIndex].TeeBoxCount);
        MDTeeBox.Append;
        MDTeeBox.FieldValues['teebox_no'] := FieldByName('SEAT_NO').AsInteger;
        MDTeeBox.FieldValues['teebox_nm'] := FieldByName('SEAT_NM').AsString;
        MDTeeBox.FieldValues['device_id'] := FieldByName('DEVICE_ID').AsString;
        MDTeeBox.FieldValues['floor_cd']  := sFloorCode;
        MDTeeBox.FieldValues['floor_nm']  := sFloorCode;
        MDTeeBox.FieldValues['vip_yn']    := False;
        MDTeeBox.FieldValues['use_yn']    := (FieldByName('USE_YN').AsString = CRC_YES);
        MDTeeBox.FieldValues['zone_cd']   := FieldByName('SEAT_ZONE_CODE').AsString;
        MDTeeBox.FieldValues['control_yn']:= CRC_YES;
        MDTeeBox.Post;
        for I := 0 to Pred(Length(Global.TeeBoxFloorInfo)) do
          if (Global.TeeBoxMaxCountOfFloors < Global.TeeBoxFloorInfo[I].TeeBoxCount) then
            Global.TeeBoxMaxCountOfFloors := Global.TeeBoxFloorInfo[I].TeeBoxCount;
        Next;
      end;
      RefreshTeeboxViewData(CPC_TEEBOX_LAYOUT);
      Result := True;
    finally
      Screen.Cursor := crDefault;
      MDTeeBox.EnableControls;
      Close;
      Free;
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetTeeBoxListEmergency.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetTeeBoxReserveListEmergency(const AReserveDate: string; var AErrMsg: string): Boolean;
var
  sSearchDate: string;
begin
  Result := False;
  AErrMsg := '';
  try
    Screen.Cursor := crSQLWait;
    sSearchDate := FormattedDateString(AReserveDate);
    with QREmergency do
    try
      DisableControls;
      Close;
      Params.Clear;
      Prepared := True;
      Params.CreateParam(ftString, 'p_start_datetime', ptInput).AsString := sSearchDate + ' 00:00:00';
      Params.CreateParam(ftString, 'p_end_datetime', ptInput).AsString := sSearchDate + ' 23:59:59';
      Open;
      First;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      EnableControls;
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetTeeBoxReserveListEmergency.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetTeeBoxReserveList(const AReserveDate: string; const ATeeBoxNo: Integer; var AErrMsg: string): Boolean;
var
  sStoreCode: string;
begin
  Result := False;
  AErrMsg := '';
  try
    Screen.Cursor := crSQLWait;
    sStoreCode := SaleManager.StoreInfo.StoreCode;
    if sStoreCode.IsEmpty then
      sStoreCode := Global.ClientConfig.ClientId.Substring(0, 5);
    with SPTeeBoxAssignList do
    try
      DisableControls;
      Close;
      Connection := conTeeBox;
      StoredProcName := 'SP_GET_TEEBOX_RESERVE_LIST';
      Params.Clear;
      Params.CreateParam(ftString, 'p_store_cd', ptInput).AsString := sStoreCode;
      Params.CreateParam(ftString, 'p_date', ptInput).AsString := AReserveDate; //yyyymmdd
      Params.CreateParam(ftString, 'p_teebox_no', ptInput).AsString := IIF(ATeeBoxNo > 0, IntToStr(ATeeBoxNo), '');
      Prepared := True;
      Open;
      First;
      Result := True;
    finally
      EnableControls;
      Screen.Cursor := crDefault;
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetTeeBoxReserveList.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetNoticeList(const ASearchDate: string; var AErrMsg: string): Boolean;
const
  CS_API = 'K803_NoticeList';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO: TJSONObject;
  JV: TJSONValue;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sStartDate, sEndDate: string;
  I, nCount: Integer;
begin
  Result := False;
  AErrMsg := '';
  JO := nil;
  JV := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&search_date=%s',
        [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, ASearchDate]);
      SS.Clear;
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      if not ((sResCode = CRC_SUCCESS) or (sResCode = CRC_NO_DATA)) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      Global.NoticePopupUrl := '';
      if not (JO.FindValue('result_data') is TJSONNull) then
      begin
        SetLength(GLobal.NoticeInfo, 0);
        JV := JO.Get('result_data').JsonValue;
        nCount := (JV as TJSONArray).Count;
        if (nCount > 0) then
        begin
          for I := 0 to Pred(nCount) do
          begin
            sStartDate := (JV as TJSONArray).Items[I].P['start_expose_date'].Value;
            sEndDate := (JV as TJSONArray).Items[I].P['end_expose_date'].Value;
            if (sStartDate > Global.FormattedCurrentDate) or
               (sEndDate < Global.FormattedCurrentDate) then
              Continue;
            SetLength(GLobal.NoticeInfo, I + 1);
            Global.NoticeInfo[I].Title := (JV as TJSONArray).Items[I].P['notice_title'].Value;
            Global.NoticeInfo[I].RegUserName := (JV as TJSONArray).Items[I].P['reg_user_nm'].Value;
            Global.NoticeInfo[I].RegDateTime := (JV as TJSONArray).Items[I].P['reg_datetime'].Value;
            Global.NoticeInfo[I].PageUrl := (JV as TJSONArray).Items[I].P['page_url'].Value;
            Global.NoticeInfo[I].PopupYN := ((JV as TJSONArray).Items[I].P['popup_yn'].Value = CRC_YES);
            //팝업으로 노출할 공지사항
            if Global.NoticePopupUrl.IsEmpty and
               Global.NoticeInfo[I].PopupYN then
              Global.NoticePopupUrl := Global.NoticeInfo[I].PageUrl;
          end;
        end;
        RefreshNoticeList;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JV);
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetNoticeList.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetProdTeeBoxList(var AErrMsg: string): Boolean;
const
  CS_API_1 = 'K205_TeeBoxProductVersion';
  CS_API_2 = 'K206_TeeBoxProductlist';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO1, RO1, JO2: TJSONObject;
  JV2: TJSONValue;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sProdType, sProdCode, sProdDiv: string;
  I, nCurVer, nNewVer, nCount: Integer;
  bIsFirst, bIsDelete, bIsToday: Boolean;
begin
  Result := False;
  AErrMsg := '';
  sProdType := '';
  bIsFirst := SaleManager.StoreInfo.TeeBoxProdUpdated.IsEmpty;
  JO1 := nil;
  JO2 := nil;
  RO1 := nil;
  JV2 := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    if bIsFirst then
      ClearMemdata(MDProdTeeBox);
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&search_date=%s',
        [Global.ClientConfig.Host, CS_API_1, SaleManager.StoreInfo.StoreCode, IIF(bIsFirst, '', SaleManager.StoreInfo.TeeBoxProdUpdated)]);
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API_1 + '.Response.json');
      JO1 := TJSONObject.ParseJSONValue(SS.DataString) as TJSONObject;
      sResCode := JO1.GetValue('result_cd').Value;
      sResMsg := JO1.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      nNewVer := -1;
      if not (JO1.FindValue('result_data') is TJSONNull) then
      begin
        RO1 := JO1.GetValue('result_data') as TJSONObject;
        sProdType := RO1.GetValue('product_type').Value;
        nNewVer := StrToIntDef(RO1.GetValue('version_no').Value, 0);
      end;
      nCurVer := GetDataVersion(sProdType);
      if (nNewVer = -1) or
         (nNewVer > nCurVer) then
      begin
        SetDataVersion(sProdType, nNewVer);
        sUrl := Format('%s/wix/api/%s?store_cd=%s&search_date=%s', [Global.ClientConfig.Host, CS_API_2, SaleManager.StoreInfo.StoreCode, IIF(bIsFirst, '', SaleManager.StoreInfo.TeeBoxProdUpdated)]);
        SS.Clear;
        HC.Get(sUrl, SS);
        SS.SaveToFile(Global.LogDir + CS_API_2 + '.Response.json');
        RBS := PAnsiChar(SS.Memory);
        SetCodePage(RBS, 65001, False);
        JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
        sResCode := JO2.GetValue('result_cd').Value;
        sResMsg  := JO2.GetValue('result_msg').Value;
        if (sResCode <> CRC_SUCCESS) then
          raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
        SaleManager.StoreInfo.TeeBoxProdUpdated := Global.CurrentDateTime;
        if not (JO2.FindValue('result_data') is TJSONNull) then
        begin
          JV2 := JO2.Get('result_data').JsonValue;
          nCount := (JV2 as TJSONArray).Count;
          if (nCount > 0) then
          begin
            with MDProdTeeBox do
            try
              DisableControls;
              for I := 0 to Pred(nCount) do
              if ((JV2 as TJSONArray).Items[I].P['use_yn'].Value = CRC_YES) then
              begin
                sProdDiv := (JV2 as TJSONArray).Items[I].P['product_div'].Value;
                sProdCode := (JV2 as TJSONArray).Items[I].P['product_cd'].Value;
                bIsToday := ((JV2 as TJSONArray).Items[I].P['today_yn'].Value = CRC_YES);
                bIsDelete := ((JV2 as TJSONArray).Items[I].P['del_yn'].Value = CRC_YES);
                if bIsFirst then
                begin
                  if bIsDelete or
                     ((not bIsToday) and (sProdDiv = CTP_DAILY)) then //당일 사용불가한 일일타석상품은 제외
                    Continue;
                  Append;
                  FieldValues['product_div'] := sProdDiv;
                  FieldValues['product_cd']  := sProdCode;
                end
                else
                begin
                  if Locate('product_div;product_cd', VarArrayOf([sProdDiv, sProdCode]), []) then
                  begin
                    if bIsDelete or
                       ((not bIsToday) and (sProdDiv = CTP_DAILY)) then //당일 사용불가한 일일타석상품은 제외
                    begin
                      Delete;
                      Continue;
                    end;
                    Edit;
                  end
                  else
                  begin
                    Append;
                    FieldValues['product_div'] := sProdDiv;
                    FieldValues['product_cd'] := sProdCode;
                  end;
                end;
                FieldValues['product_nm']       := (JV2 as TJSONArray).Items[I].P['product_nm'].Value;
                FieldValues['zone_cd']          := (JV2 as TJSONArray).Items[I].P['zone_cd'].Value;
                FieldValues['avail_zone_cd']    := (JV2 as TJSONArray).Items[I].P['available_zone_cd'].Value; //2022.01.19
                FieldValues['use_div']          := (JV2 as TJSONArray).Items[I].P['use_div'].Value;
                FieldValues['today_yn']         := bIsToday;
                FieldValues['use_month']        := StrToIntDef((JV2 as TJSONArray).Items[I].P['use_month'].Value, 0);
                FieldValues['use_cnt']          := StrToIntDef((JV2 as TJSONArray).Items[I].P['use_cnt'].Value, 0);
                FieldValues['sex_div']          := StrToIntDef((JV2 as TJSONArray).Items[I].P['sex'].Value, CSD_SEX_ALL);
                FieldValues['one_use_time']     := StrToIntDef((JV2 as TJSONArray).Items[I].P['one_use_time'].Value, 0);
                FieldValues['one_use_cnt']      := StrToIntDef((JV2 as TJSONArray).Items[I].P['one_use_cnt'].Value, 0);
                FieldValues['start_time']       := (JV2 as TJSONArray).Items[I].P['start_time'].Value;
                FieldValues['end_time']         := (JV2 as TJSONArray).Items[I].P['end_time'].Value;
                FieldValues['expire_day']       := StrToIntDef((JV2 as TJSONArray).Items[I].P['expire_day'].Value, 0);
                FieldValues['product_amt']      := StrToIntDef((JV2 as TJSONArray).Items[I].P['product_amt'].Value, 0);
                FieldValues['xgolf_dc_yn']      := ((JV2 as TJSONArray).Items[I].P['xgolf_dc_yn'].Value = CRC_YES);
                FieldValues['xgolf_dc_amt']     := StrToIntDef((JV2 as TJSONArray).Items[I].P['xgolf_dc_amt'].Value, 0);
                FieldValues['xgolf_product_amt']:= StrToIntDef((JV2 as TJSONArray).Items[I].P['xgolf_product_amt'].Value, 0);
                FieldValues['refund_yn']        := ((JV2 as TJSONArray).Items[I].P['refund_yn'].Value = CRC_YES);
                FieldValues['limit_product_yn'] := ((JV2 as TJSONArray).Items[I].P['limit_product_yn'].Value = CRC_YES); //2022.02.08
                FieldValues['affiliate_yn']     := ((JV2 as TJSONArray).Items[I].P['alliance_yn'].Value = CRC_YES); //2022.02.08
                FieldValues['affiliate_cd']     := (JV2 as TJSONArray).Items[I].P['alliance_code'].Value; //2022.02.08
                FieldValues['affiliate_item_cd']:= (JV2 as TJSONArray).Items[I].P['alliance_item_code'].Value; //2022.02.08
                FieldValues['stamp_yn']         := ((JV2 as TJSONArray).Items[I].P['stamp_yn'].Value = CRC_YES); //2024.01.04
                FieldValues['memo']             := (JV2 as TJSONArray).Items[I].P['memo'].Value;
                Post;
              end;
            finally
              EnableControls;
            end;
          end;
        end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JV2);
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(RO1);
      FreeAndNilJSONObject(JO1);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetProdTeeBoxList.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetProdLessonList(var AErrMsg: string): Boolean;
const
  CS_API = 'K239_LessonProductList';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO, RO: TJSONObject;
  JV: TJSONValue;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sProdDiv, sProdCode: string;
  I, nCount: Integer;
  bDelYN, bUseYN: Boolean;
begin
  Result := False;
  AErrMsg := '';
  JO := nil;
  RO := nil;
  JV := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&del_yn=%s&use_yn=%s&search_date=%s',
        [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, CRC_NO, CRC_YES, SaleManager.StoreInfo.LessonProdUpdated]);
      SS.Clear;
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg  := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      SaleManager.StoreInfo.LessonProdUpdated := Global.CurrentDateTime;
      if not (JO.FindValue('result_data') is TJSONNull) then
      begin
        JV := JO.Get('result_data').JsonValue;
        nCount := (JV as TJSONArray).Count;
        if (nCount > 0) then
        begin
          with MDProdTeeBox do
          try
            DisableControls;
            for I := 0 to Pred(nCount) do
            if ((JV as TJSONArray).Items[I].P['use_yn'].Value = CRC_YES) then
            begin
              sProdDiv := CTP_LESSON_STUDIO;
              sProdCode := (JV as TJSONArray).Items[I].P['product_cd'].Value;
              bDelYN := ((JV as TJSONArray).Items[I].P['del_yn'].Value = CRC_YES);
              bUseYN := ((JV as TJSONArray).Items[I].P['use_yn'].Value = CRC_YES);
              if Locate('product_div;product_cd', VarArrayOf([sProdDiv, sProdCode]), []) then
              begin
                if bDelYN or (not bUseYN) then
                begin
                  Delete;
                  Continue;
                end;
                Edit;
              end
              else
              begin
                Append;
                FieldValues['product_div'] := sProdDiv;
                FieldValues['product_cd']  := sProdCode;
              end;
              FieldValues['product_nm']        := (JV as TJSONArray).Items[I].P['product_nm'].Value;
              FieldValues['zone_cd']           := '';
              FieldValues['avail_zone_cd']     := '';
              FieldValues['use_div']           := '';
              FieldValues['today_yn']          := True;
              FieldValues['use_month']         := 0;
              FieldValues['use_cnt']           := StrToIntDef((JV as TJSONArray).Items[I].P['use_cnt'].Value, 0);
              FieldValues['sex_div']           := CSD_SEX_ALL;
              FieldValues['one_use_time']      := 0;
              FieldValues['one_use_cnt']       := 0;
              FieldValues['start_time']        := '';
              FieldValues['end_time']          := '';
              FieldValues['expire_day']        := StrToIntDef((JV as TJSONArray).Items[I].P['expire_day_cnt'].Value, 0);
              FieldValues['product_amt']       := StrToIntDef((JV as TJSONArray).Items[I].P['product_amt'].Value, 0);
              FieldValues['xgolf_dc_yn']       := False;
              FieldValues['xgolf_dc_amt']      := 0;
              FieldValues['xgolf_product_amt'] := 0;
              FieldValues['refund_yn']         := False;
              FieldValues['limit_product_yn']  := False;
              FieldValues['affiliate_yn']      := False;
              FieldValues['affiliate_cd']      := '';
              FieldValues['affiliate_item_cd'] := '';
              FieldValues['stamp_yn']          := False;
              FieldValues['memo']              := (JV as TJSONArray).Items[I].P['memo'].Value;
              Post;
            end;
          finally
            EnableControls;
          end;
        end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JV);
      FreeAndNilJSONObject(RO);
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetProdLessonList.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetProdReserveList(var AErrMsg: string): Boolean;
const
  CS_API = 'K240_ReservationProductList';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO, RO: TJSONObject;
  JV: TJSONValue;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sProdDiv, sProdCode: string;
  I, nCount: Integer;
  bDelYN, bUseYN: Boolean;
begin
  Result := False;
  AErrMsg := '';
  JO := nil;
  RO := nil;
  JV := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&del_yn=%s&use_yn=%s&search_date=%s',
        [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, CRC_NO, CRC_YES, SaleManager.StoreInfo.ReserveProdUpdated]);
      SS.Clear;
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg  := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      SaleManager.StoreInfo.ReserveProdUpdated := Global.CurrentDateTime;
      if not (JO.FindValue('result_data') is TJSONNull) then
      begin
        JV := JO.Get('result_data').JsonValue;
        nCount := (JV as TJSONArray).Count;
        if (nCount > 0) then
        begin
          with MDProdTeeBox do
          try
            DisableControls;
            for I := 0 to Pred(nCount) do
            if ((JV as TJSONArray).Items[I].P['use_yn'].Value = CRC_YES) then
            begin
              sProdDiv := CTP_LESSON_RESERVE;
              sProdCode := (JV as TJSONArray).Items[I].P['product_cd'].Value;
              bDelYN := ((JV as TJSONArray).Items[I].P['del_yn'].Value = CRC_YES);
              bUseYN := ((JV as TJSONArray).Items[I].P['use_yn'].Value = CRC_YES);
              if Locate('product_div;product_cd', VarArrayOf([sProdDiv, sProdCode]), []) then
              begin
                if bDelYN or (not bUseYN) then
                begin
                  Delete;
                  Continue;
                end;
                Edit;
              end else
              begin
                Append;
                FieldValues['product_div'] := sProdDiv;
                FieldValues['product_cd']  := sProdCode;
              end;
              FieldValues['product_nm']        := (JV as TJSONArray).Items[I].P['product_nm'].Value;
              FieldValues['zone_cd']           := '';
              FieldValues['avail_zone_cd']     := '';
              FieldValues['use_div']           := '';
              FieldValues['today_yn']          := True;
              FieldValues['use_month']         := 0;
              FieldValues['use_cnt']           := StrToIntDef((JV as TJSONArray).Items[I].P['use_cnt'].Value, 0);
              FieldValues['sex_div']           := CSD_SEX_ALL;
              FieldValues['one_use_time']      := 0;
              FieldValues['one_use_cnt']       := 0;
              FieldValues['start_time']        := '';
              FieldValues['end_time']          := '';
              FieldValues['expire_day']        := StrToIntDef((JV as TJSONArray).Items[I].P['expire_day_cnt'].Value, 0);
              FieldValues['product_amt']       := StrToIntDef((JV as TJSONArray).Items[I].P['product_amt'].Value, 0);
              FieldValues['xgolf_dc_yn']       := False;
              FieldValues['xgolf_dc_amt']      := 0;
              FieldValues['xgolf_product_amt'] := 0;
              FieldValues['refund_yn']         := False;
              FieldValues['limit_product_yn']  := False;
              FieldValues['affiliate_yn']      := False;
              FieldValues['affiliate_cd']      := '';
              FieldValues['affiliate_item_cd'] := '';
              FieldValues['stamp_yn']          := False;
              FieldValues['memo']              := (JV as TJSONArray).Items[I].P['memo'].Value;
              Post;
            end;
          finally
            EnableControls;
          end;
        end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JV);
      FreeAndNilJSONObject(RO);
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetProdReserveList.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetProdFacilityList(var AErrMsg: string): Boolean;
const
  CS_API = 'K241_FacilityProductList';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO: TJSONObject;
  JV: TJSONValue;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sProdType, sProdCode: string;
  I, nCount: Integer;
  bIsFirst, bDelYN, bUseYN: Boolean;
begin
  Result := False;
  AErrMsg := '';
  sProdType := '';
  bIsFirst := SaleManager.StoreInfo.FacilityProdUpdated.IsEmpty;
  JO := nil;
  JV := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    if bIsFirst then
      ClearMemdata(MDProdFacility);
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&search_date=%s', [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, IIF(bIsFirst, '', SaleManager.StoreInfo.FacilityProdUpdated)]);
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg  := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      SaleManager.StoreInfo.FacilityProdUpdated := Global.CurrentDateTime;
      if not (JO.FindValue('result_data') is TJSONNull) then
      begin
        JV := JO.Get('result_data').JsonValue;
        nCount := (JV as TJSONArray).Count;
        if (nCount > 0) then
        begin
          with MDProdFacility do
          try
            DisableControls;
            for I := 0 to Pred(nCount) do
            if ((JV as TJSONArray).Items[I].P['use_yn'].Value = CRC_YES) then
            begin
              sProdCode := (JV as TJSONArray).Items[I].P['product_cd'].Value;
              bDelYN    := ((JV as TJSONArray).Items[I].P['del_yn'].Value = CRC_YES);
              bUseYN    := ((JV as TJSONArray).Items[I].P['use_yn'].Value = CRC_YES);
              if bIsFirst then
              begin
                if bDelYN or (not bUseYN) then
                  Continue;
                Append;
                FieldValues['product_cd'] := sProdCode;
              end
              else
              begin
                if Locate('product_cd', VarArrayOf([sProdCode]), []) then
                begin
                  if bDelYN then
                  begin
                    Delete;
                    Continue;
                  end;
                  Edit;
                end
                else
                begin
                  Append;
                  FieldValues['product_cd'] := sProdCode;
                end;
              end;
              FieldValues['product_nm']      := (JV as TJSONArray).Items[I].P['product_nm'].Value;
              FieldValues['product_nm']      := (JV as TJSONArray).Items[I].P['product_nm'].Value;
              FieldValues['facility_div']    := (JV as TJSONArray).Items[I].P['facility_product_div'].Value;
              FieldValues['facility_div_nm'] := (JV as TJSONArray).Items[I].P['facility_product_div_nm'].Value;
              FieldValues['product_amt']     := StrToIntDef((JV as TJSONArray).Items[I].P['product_amt'].Value, 0);
              FieldValues['use_cnt']         := StrToIntDef((JV as TJSONArray).Items[I].P['use_cnt'].Value, 0);
              FieldValues['use_month']       := StrToIntDef((JV as TJSONArray).Items[I].P['use_month'].Value, 0);
              FieldValues['ticket_print_yn'] := ((JV as TJSONArray).Items[I].P['ticket_print_yn'].Value = CRC_YES); //시설이용배정표(제출용) 발행 여부
              FieldValues['memo']            := (JV as TJSONArray).Items[I].P['memo'].Value;
              Post;
            end;
          finally
            EnableControls;
          end;
        end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JV);
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetProdFacilityList.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetProdGeneralList(var AErrMsg: string): Boolean;
const
  CS_API_1 = 'K207_ProductVersion';
  CS_API_2 = 'K208_Productlist';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO1, RO1, JO2: TJSONObject;
  JV2: TJSONValue;
  RBS: RawByteString;
  AIdDM: TIdDecoderMIME;
  AIdBytes: TIdBytes;
  ABytes: TBytes;
  sUrl, sResCode, sResMsg, sProdType: string;
  i, j, nCurVer, nNewVer, nCount: Integer;
begin
  Result := False;
  sProdType := '';
  AErrMsg := '';
  JO1 := nil;
  JO2 := nil;
  RO1 := nil;
  JV2 := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s',
        [Global.ClientConfig.Host, CS_API_1, SaleManager.StoreInfo.StoreCode]);
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API_1 + '.Response.json');
      JO1 := TJSONObject.ParseJSONValue(SS.DataString) as TJSONObject;
      sResCode := JO1.GetValue('result_cd').Value;
      sResMsg := JO1.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      nNewVer := -1;
      if not (JO1.FindValue('result_data') is TJSONNull) then
      begin
        RO1 := JO1.GetValue('result_data') as TJSONObject;
        sProdType := RO1.GetValue('product_type').Value;
        nNewVer := StrToIntDef(RO1.GetValue('version_no').Value, 0);
      end;
      nCurVer := GetDataVersion(sProdType);
      if (nNewVer = -1) or
         (nNewVer > nCurVer) then
      begin
        SetDataVersion(sProdType, nNewVer);
        sUrl := Format('%s/wix/api/%s?store_cd=%s',
          [Global.ClientConfig.Host, CS_API_2, SaleManager.StoreInfo.StoreCode]);
        SS.Clear;
        HC.Get(sUrl, SS);
        SS.SaveToFile(Global.LogDir + CS_API_2 + '.Response.json');
        RBS := PAnsiChar(SS.Memory);
        SetCodePage(RBS, 65001, False);
        JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
        sResCode := JO2.GetValue('result_cd').Value;
        sResMsg  := JO2.GetValue('result_msg').Value;
        if (sResCode <> CRC_SUCCESS) then
          raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
        if not (JO2.FindValue('result_data') is TJSONNull) then
        begin
          JV2 := JO2.Get('result_data').JsonValue;
          nCount := (JV2 as TJSONArray).Count;
          if (nCount > 0) then
          begin
            with MDProdGeneral do
            try
              DisableControls;
              ClearMemData(MDProdGeneral);
              for I := 0 to Pred(nCount) do
                if ((JV2 as TJSONArray).Items[I].P['use_yn'].Value = CRC_YES) then
                begin
                  Append;
                  FieldValues['class_cd']    := (JV2 as TJSONArray).Items[I].P['class_cd'].Value;
                  FieldValues['product_cd']  := (JV2 as TJSONArray).Items[I].P['product_cd'].Value;
                  FieldValues['product_nm']  := (JV2 as TJSONArray).Items[I].P['product_nm'].Value;
                  FieldValues['product_amt'] := StrToIntDef((JV2 as TJSONArray).Items[I].P['product_amt'].Value, 0);
                  FieldValues['tax_type']    := StrToInt((JV2 as TJSONArray).Items[I].P['tax_type'].Value);
                  FieldValues['barcode']     := (JV2 as TJSONArray).Items[I].P['barcode'].Value;
                  FieldValues['refund_yn']   := ((JV2 as TJSONArray).Items[I].P['refund_yn'].Value = CRC_YES);
                  FieldValues['memo']        := (JV2 as TJSONArray).Items[I].P['memo'].Value;
                  if not ((JV2 as TJSONArray).Items[I].FindValue('photo_encoding') is TJSONNull) then
                  begin
                    AIdDM := TIdDecoderMIME.Create(nil);
                    try
                      AIdBytes := AIdDM.DecodeBytes(StringReplace((JV2 as TJSONArray).Items[I].P['photo_encoding'].Value, _CRLF, '', [rfReplaceAll]));
                      SetLength(ABytes, Length(AIdBytes));
                      for J := 0 to Pred(Length(AIdBytes)) do
                        ABytes[J] := AIdBytes[J];
                      SS.Clear;
                      SS.Write(ABytes, Length(ABytes));
                      SS.Position := 0;
                      TBlobField(FieldByName('photo')).LoadFromStream(SS);
                    finally
                      AIdDM.Free;
                    end;
                  end;
                  Post;
                end;
            finally
              EnableControls;
            end;
          end;
        end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JV2);
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(RO1);
      FreeAndNilJSONObject(JO1);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetProdGeneralList.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetPluList(var AErrMsg: string): Boolean;
const
  CS_API_1 = 'K211_PluItemVersion';
  CS_API_2 = 'K233_Plulist';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO1, RO1, JO2: TJSONObject;
  JV1, JV2, JV3: TJSONValue;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sProdType: string;
  sProdDiv, sProdDivName, sClassCode, sClassName, sClassDiv, sProdCode: string;
  I, J, K, nCurVer, nNewVer, nCount, nCount2, nCount3: Integer;
begin
  Result := False;
  sProdType := '';
  AErrMsg := '';
  JO1 := nil;
  JO2 := nil;
  RO1 := nil;
  JV1 := nil;
  JV2 := nil;
  JV3 := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s', [Global.ClientConfig.Host, CS_API_1, SaleManager.StoreInfo.StoreCode]);
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API_1 + '.Response.json');
      JO1 := TJSONObject.ParseJSONValue(SS.DataString) as TJSONObject;
      sResCode := JO1.GetValue('result_cd').Value;
      sResMsg := JO1.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      nNewVer := -1;
      if not (JO1.FindValue('result_data') is TJSONNull) then
      begin
        RO1 := JO1.GetValue('result_data') as TJSONObject;
        sProdType := RO1.GetValue('product_type').Value;
        nNewVer := StrToIntDef(RO1.GetValue('version_no').Value, 0);
      end;
      nCurVer := GetDataVersion(sProdType);
      if (nNewVer = -1) or
         (nNewVer > nCurVer) then
      begin
        SetDataVersion(sProdType, nNewVer);
        sUrl := Format('%s/wix/api/%s?store_cd=%s&client_id=%s', [Global.ClientConfig.Host, CS_API_2, SaleManager.StoreInfo.StoreCode, Global.ClientConfig.ClientId]);
        UpdateLog(Global.LogFile, Format('GetPluList.Request = %s', [sUrl]));
        SS.Clear;
        HC.Get(sUrl, SS);
        SS.SaveToFile(Global.LogDir + CS_API_2 + '.Response.json');
        RBS := PAnsiChar(SS.Memory);
        SetCodePage(RBS, 65001, False);
        JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
        sResCode := JO2.GetValue('result_cd').Value;
        sResMsg  := JO2.GetValue('result_msg').Value;
        if (sResCode <> CRC_SUCCESS) then
          raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
        if not (JO2.FindValue('result_data') is TJSONNull) then
        begin
          JV1 := JO2.Get('result_data').JsonValue;
          nCount := (JV1 as TJSONArray).Count;
          if (nCount > 0) then
          begin
            with SaleManager.SaleMenuManager do
            begin
              for I := 0 to Pred(GetCategoryCount) do
                ClearItems(I);
              ClearCategories;
            end;
            for I := 0 to Pred(nCount) do
            begin
              sProdDiv := (JV1 as TJSONArray).Items[I].P['group_cd'].Value;
              sProdDivName := (JV1 as TJSONArray).Items[I].P['group_nm'].Value;
              { 2023-01-03 이종섭 차장 요청으로 전 매장에 레슨/예역 상품 수신 허용
              //POSType이 레슨룸(파스텔)이 아니면 레슨 상품은 무시
              if (SaleManager.StoreInfo.POSType <> CPO_SALE_LESSON_ROOM) and
                 ((sProdDiv = CTP_LESSON_STUDIO) or (sProdDiv = CTP_LESSON_RESERVE)) then
                Continue;
              }
              { 부대시설이용상품을 사용하지 않는 매장은 무시 }
              if (not SaleManager.StoreInfo.FacilityProdYN) and
                 (sProdDiv = CPD_FACILITY) then
                Continue;
              JV2 := (JV1 as TJSONArray).Items[I].P['class_list'];
              nCount2 := (JV2 as TJSONArray).Count;
              if (nCount2 > 0) then
              begin
                for J := 0 to Pred(nCount2) do
                begin
                  sClassCode := (JV2 as TJSONArray).Items[J].P['class_cd'].Value;
                  sClassDiv := (JV2 as TJSONArray).Items[J].P['class_div'].Value;
                  if (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX) and
                     ((sClassCode = CTP_DAILY) or ((not sClassDiv.IsEmpty) and (sClassDiv <> SaleManager.StoreInfo.SaleZoneCode))) then
                    Continue;
                  sClassName := (JV2 as TJSONArray).Items[J].P['class_nm'].Value;
                  SaleManager.SaleMenuManager.AddCategory(sClassCode, sClassName);
                  JV3 := (JV2 as TJSONArray).Items[J].P['product_list'];
                  nCount3 := (JV3 as TJSONArray).Count;
                  if (nCount3 > 0) then
                  begin
                    for K := 0 to Pred(nCount3) do
                    begin
                      if ((JV3 as TJSONArray).Items[K].P['del_yn'].Value = CRC_YES) then
                        Continue;
                      sProdCode := (JV3 as TJSONArray).Items[K].P['product_cd'].Value;
                      SaleManager.SaleMenuManager.AddItem(sClassCode, sProdDiv, sProdCode);
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JV3);
      FreeAndNilJSONObject(JV2);
      FreeAndNilJSONObject(JV1);
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(RO1);
      FreeAndNilJSONObject(JO1);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetPluList.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetMemberList(var AErrMsg: string): Boolean;
const
  CS_API = 'K215_Memberlist';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO: TJSONObject;
  JV: TJSONValue;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sMemberNo, sTextFIR: string;
  I, nCount, nMemberSeq: Integer;
  bIsFirst, bIsDelete: Boolean;
begin
  Result := False;
  AErrMsg := '';
  JO := nil;
  JV := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    bIsFirst := SaleManager.StoreInfo.MemberUpdated.IsEmpty;
    if bIsFirst then
    begin
      FingerPrintClearUserList;
      ClearMemData(MDMember);
    end;
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&search_date=%s',
        [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, IIF(bIsFirst, '', SaleManager.StoreInfo.MemberUpdated)]);
      SS.Clear;
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg  := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      SaleManager.StoreInfo.MemberUpdated := Global.CurrentDateTime;
      if not (JO.FindValue('result_data') is TJSONNull) then
      begin
        JV := JO.Get('result_data').JsonValue;
        nCount := (JV as TJSONArray).Count;
        if (nCount > 0) then
        begin
          with MDMember do
          try
            DisableControls;
            for I := 0 to Pred(nCount) do
            begin
              sMemberNo := (JV as TJSONArray).Items[I].P['member_no'].Value;
              bIsDelete := ((JV as TJSONArray).Items[I].P['del_yn'].Value = CRC_YES);
              nMemberSeq := StrToInt((JV as TJSONArray).Items[I].P['member_seq'].Value);
              sTextFIR := (JV as TJSONArray).Items[I].P['fingerprint1'].Value;
              if bIsFirst then
              begin
                if bIsDelete then
                  Continue;
//                if (not FingerPrintAddUser(sTextFIR, nMemberSeq, AErrMsg)) and
//                   (not AErrMsg.IsEmpty) then
//                  UpdateLog(Global.LogFile, Format('GetMemberList.FingerPrintAddUser.Exception = %s', [AErrMsg]));
                Append;
                FieldValues['member_no'] := sMemberNo;
              end
              else
              begin
                if Locate('member_no', sMemberNo, []) then
                begin
                  if bIsDelete then
                  begin
//                    if (not FingerPrintRemoveUser(nMemberSeq, AErrMsg)) and
//                       (not AErrMsg.IsEmpty) then
//                      UpdateLog(Global.LogFile, Format('GetMemberList.FingerPrintDeleteUser.Exception = %s', [AErrMsg]));
                    Delete;
                    Continue;
                  end;
                  Edit;
                end
                else
                begin
//                  if (not FingerPrintAddUser(sTextFIR, nMemberSeq, AErrMsg)) and
//                     (not AErrMsg.IsEmpty) then
//                    UpdateLog(Global.LogFile, Format('GetMemberList.FingerPrintFastSearchAddUser.Exception = %s', [AErrMsg]));
                  Append;
                  FieldValues['member_no'] := sMemberNo;
                end;
              end;
              FieldValues['member_seq']       := nMemberSeq;
              FieldValues['member_nm']        := (JV as TJSONArray).Items[I].P['member_nm'].Value;
              FieldValues['customer_cd']      := (JV as TJSONArray).Items[I].P['customer_cd'].Value;
              FieldValues['group_cd']         := (JV as TJSONArray).Items[I].P['group_cd'].Value;
              FieldValues['member_card_uid']  := (JV as TJSONArray).Items[I].P['member_card_uid'].Value;
              FieldValues['welfare_cd']       := (JV as TJSONArray).Items[I].P['welfare_cd'].Value;
              FieldValues['dc_rate']          := StrToIntDef((JV as TJSONArray).Items[I].P['dc_rate'].Value, 0);
              FieldValues['member_point']     := StrToIntDef((JV as TJSONArray).Items[I].P['member_point'].Value, 0);
              FieldValues['sex_div']          := StrToIntDef((JV as TJSONArray).Items[I].P['sex_div'].Value, CSD_SEX_ALL);
              FieldValues['birth_ymd']        := (JV as TJSONArray).Items[I].P['birth_ymd'].Value;
              FieldValues['hp_no']            := StringReplace((JV as TJSONArray).Items[I].P['hp_no'].Value, '-', '', [rfReplaceAll]);
              FieldValues['email']            := (JV as TJSONArray).Items[I].P['email'].Value;
              FieldValues['car_no']           := (JV as TJSONArray).Items[I].P['car_no'].Value;
              FieldValues['zip_no']           := (JV as TJSONArray).Items[I].P['zip_no'].Value;
              FieldValues['address']          := (JV as TJSONArray).Items[I].P['address'].Value;
              FieldValues['address_desc']     := (JV as TJSONArray).Items[I].P['address_desc'].Value;
              FieldValues['qr_cd']            := (JV as TJSONArray).Items[I].P['qr_cd'].Value;
              FieldValues['xg_user_key']      := (JV as TJSONArray).Items[I].P['xg_user_key'].Value;
              FieldValues['special_yn']       := ((JV as TJSONArray).Items[I].P['special_yn'].Value = CRC_YES);
              FieldValues['memo']             := (JV as TJSONArray).Items[I].P['memo'].Value;
//              FieldValues['fingerprint1']     := sTextFIR;
              FieldValues['fingerprint1']     := (JV as TJSONArray).Items[I].P['fingerprint1'].Value;
              FieldValues['fingerprint2']     := (JV as TJSONArray).Items[I].P['fingerprint2'].Value;
              FieldValues['spectrum_cust_id'] := (JV as TJSONArray).Items[I].P['spectrum_cust_id'].Value;
              Post;
            end;
          finally
            EnableControls;
          end;
        end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JV);
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetMemberList.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetLockerList(var AErrMsg: string): Boolean;
const
  CS_API_1 = 'K216_LockerVersion';
  CS_API_2 = 'K217_Lockerlist';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO1, RO1, JO2: TJSONObject;
  JV2: TJSONValue;
  RBS: RawByteString;
  FL: TStringList;
  sUrl, sResCode, sResMsg, sProdType, sLockerName, sFloorCode, sFloorName, sZoneCode: string;
  I, nCurVer, nNewVer, nFloorCount, nFloorIndex, nLockerNo, nLockerCount, nCount, nSexDiv, nUseDiv: Integer;
  bUseYN: Boolean;
  function GetFloorIndex(const AFloorCode: string): Integer;
  var
    J: Integer;
  begin
    Result := -1;
    for J := 0 to Pred(FL.Count) do
      if (FL.Strings[J] = AFloorCode) then
      begin
        Result := J;
        Break;
      end;
  end;
begin
  Result := False;
  sProdType := '';
  AErrMsg := '';
  JO1 := nil;
  JO2 := nil;
  RO1 := nil;
  JV2 := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  FL := TStringList.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    MDLocker.DisableControls;
    ClearMemData(MDLocker);
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s', [Global.ClientConfig.Host, CS_API_1, SaleManager.StoreInfo.StoreCode]);
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API_1 + '.Response.json');
      JO1 := TJSONObject.ParseJSONValue(SS.DataString) as TJSONObject;
      sResCode := JO1.GetValue('result_cd').Value;
      sResMsg := JO1.GetValue('result_msg').Value;
      nNewVer := -1;
      if not (JO1.FindValue('result_data') is TJSONNull) then
      begin
        RO1 := JO1.GetValue('result_data') as TJSONObject;
        sProdType := RO1.GetValue('product_type').Value;
        nNewVer := StrToIntDef(RO1.GetValue('version_no').Value, 0);
      end;
      nCurVer := GetDataVersion(sProdType);
      if (nNewVer = -1) or
         (nNewVer > nCurVer) then
      begin
        SetDataVersion(sProdType, nNewVer);
        sUrl := Format('%s/wix/api/%s?store_cd=%s',
          [Global.ClientConfig.Host, CS_API_2, SaleManager.StoreInfo.StoreCode]);
        SS.Clear;
        HC.Get(sUrl, SS);
        SS.SaveToFile(Global.LogDir + CS_API_2 + '.Response.json');
        RBS := PAnsiChar(SS.Memory);
        SetCodePage(RBS, 65001, False);
        JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
        sResCode := JO2.GetValue('result_cd').Value;
        sResMsg  := JO2.GetValue('result_msg').Value;
        if (sResCode <> CRC_SUCCESS) then
          raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
        if not (JO2.FindValue('result_data') is TJSONNull) then
        begin
          nFloorCount  := 0;
          nLockerCount := 0;
          SetLength(Global.LockerFloorInfo, 0);
          SetLength(Global.LockerInfo, 0);
          JV2 := JO2.Get('result_data').JsonValue;
          nCount := (JV2 as TJSONArray).Count;
          if (nCount > 0) then
          begin
            for I := 0 to Pred(nCount) do
            begin
              if ((JV2 as TJSONArray).Items[I].P['del_yn'].Value = CRC_YES) then
                Continue;
              nLockerNo   := StrToIntDef((JV2 as TJSONArray).Items[I].P['locker_no'].Value, 0);
              sLockerName := (JV2 as TJSONArray).Items[I].P['locker_nm'].Value;
              sFloorCode  := (JV2 as TJSONArray).Items[I].P['floor_cd'].Value;
              sFloorName  := (JV2 as TJSONArray).Items[I].P['floor_nm'].Value;
              sZoneCode   := (JV2 as TJSONArray).Items[I].P['zone_code'].Value;
              nSexDiv     := StrToIntDef((JV2 as TJSONArray).Items[I].P['sex_div'].Value, CSD_SEX_ALL);
              nUseDiv     := StrToIntDef((JV2 as TJSONArray).Items[I].P['use_div'].Value, 0);
              bUseYN     := ((JV2 as TJSONArray).Items[I].P['use_yn'].Value = CRC_YES);
              //if (I >= 91) then
              //  UpdateLog(Global.LogFile, Format('GetLockerList = Index:%d, LockerNo:%d, FloorCode:%s, FloorName:%s', [I, nLockerNo, sFloorCode, sFloorName]));
              nFloorIndex := GetFloorIndex(sFloorCode);
              if (nFloorIndex < 0) then
              begin
                FL.Add(sFloorCode);
                Inc(nFloorCount);
                SetLength(Global.LockerFloorInfo, nFloorCount);
                nFloorIndex := Pred(nFloorCount);
                Global.LockerFloorInfo[nFloorIndex].FloorCode   := sFloorCode;
                Global.LockerFloorInfo[nFloorIndex].FloorName   := sFloorName;
                Global.LockerFloorInfo[nFloorIndex].LockerCount := 0;
              end;
              Inc(nLockerCount);
              Global.LockerFloorInfo[nFloorIndex].LockerCount := nLockerCount;
              SetLength(Global.LockerInfo, nLockerCount);
              { 라커 상태 }
              with Global.LockerInfo[Length(Global.LockerInfo) - 1] do
              begin
                LockerNo   := nLockerNo;
                LockerName := sLockerName;
                FloorIndex := nFloorIndex;
                ZoneCode   := sZoneCode;
                SexDiv     := nSexDiv;
                UseDiv     := nUseDiv;
                UseYN      := bUseYN;
                with MDLocker do
                begin
                  Append;
                  FieldValues['locker_no'] := nLockerNo;
                  FieldValues['locker_nm'] := sLockerName;
                  FieldValues['floor_cd']  := sFloorCode;
                  FieldValues['floor_nm']  := sFloorName;
                  FieldValues['zone_cd']   := sZoneCode;
                  FieldValues['zone_nm']   := IIF(sZoneCode = 'U', '상', IIF(sZoneCode = 'L', '하', IIF(sZoneCode = 'K', '중', '')));
                  FieldValues['sex_div']   := nSexDiv;
                  FieldValues['use_div']   := nUseDiv;
                  FieldValues['use_yn']    := bUseYN;
                  Post;
                end;
              end;
            end;
          end;
        end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      MDLocker.EnableControls;
      FreeAndNilJSONObject(JV2);
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(RO1);
      FreeAndNilJSONObject(JO1);
      FreeAndNil(FL);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetLockerList.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetProdLockerList(var AErrMsg: string): Boolean;
const
  CS_API_1 = 'K218_LockerProductVersion';
  CS_API_2 = 'K219_LockerProductlist';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO1, RO1, JO2: TJSONObject;
  JV2: TJSONValue;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sProdType: string;
  I, nCurVer, nNewVer, nCount: Integer;
begin
  Result := False;
  sProdType := '';
  AErrMsg := '';
  JO1 := nil;
  JO2 := nil;
  RO1 := nil;
  JV2 := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s', [Global.ClientConfig.Host, CS_API_1, SaleManager.StoreInfo.StoreCode]);
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API_1 + '.Response.json');
      JO1 := TJSONObject.ParseJSONValue(SS.DataString) as TJSONObject;
      sResCode := JO1.GetValue('result_cd').Value;
      sResMsg := JO1.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      nNewVer := -1;
      if not (JO1.FindValue('result_data') is TJSONNull) then
      begin
        RO1 := JO1.GetValue('result_data') as TJSONObject;
        sProdType := RO1.GetValue('product_type').Value;
        nNewVer := StrToIntDef(RO1.GetValue('version_no').Value, 0);
      end;
      nCurVer := GetDataVersion(sProdType);
      if (nNewVer = -1) or
         (nNewVer > nCurVer) then
      begin
        SetDataVersion(sProdType, nNewVer);
        sUrl := Format('%s/wix/api/%s?store_cd=%s',
          [Global.ClientConfig.Host, CS_API_2, SaleManager.StoreInfo.StoreCode]);
        SS.Clear;
        HC.Get(sUrl, SS);
        SS.SaveToFile(Global.LogDir + CS_API_2 + '.Response.json');
        RBS := PAnsiChar(SS.Memory);
        SetCodePage(RBS, 65001, False);
        JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
        sResCode := JO2.GetValue('result_cd').Value;
        sResMsg  := JO2.GetValue('result_msg').Value;
        if (sResCode <> CRC_SUCCESS) then
          raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
        if not (JO2.FindValue('result_data') is TJSONNull) then
        begin
          JV2 := JO2.Get('result_data').JsonValue;
          nCount := (JV2 as TJSONArray).Count;
          if (nCount > 0) then
          begin
            ClearMemData(MDProdLocker);
            with MDProdLocker do
            try
              DisableControls;
              for I := 0 to Pred(nCount) do
                if ((JV2 as TJSONArray).Items[I].P['use_yn'].Value = CRC_YES) then
                begin
                  Append;
                  FieldValues['product_cd']  := (JV2 as TJSONArray).Items[I].P['product_cd'].Value;
                  FieldValues['product_div'] := (JV2 as TJSONArray).Items[I].P['product_div'].Value;
                  FieldValues['zone_cd']     := (JV2 as TJSONArray).Items[I].P['zone_cd'].Value;
                  FieldValues['sex_div']     := StrToIntDef((JV2 as TJSONArray).Items[I].P['sex_div'].Value, CSD_SEX_ALL);
                  FieldValues['product_nm']  := (JV2 as TJSONArray).Items[I].P['product_nm'].Value;
                  FieldValues['use_month']   := StrToIntDef((JV2 as TJSONArray).Items[I].P['use_month'].Value, 1);
                  FieldValues['keep_amt']    := StrToIntDef((JV2 as TJSONArray).Items[I].P['keep_amt'].Value, 0);
                  FieldValues['product_amt'] := StrToIntDef((JV2 as TJSONArray).Items[I].P['product_amt'].Value, 0);
                  FieldValues['refund_yn']   := ((JV2 as TJSONArray).Items[I].P['refund_yn'].Value = CRC_YES);
                  FieldValues['memo']        := (JV2 as TJSONArray).Items[I].P['memo'].Value;
                  Post;
                end;
            finally
              EnableControls;
            end;
          end;
        end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JV2);
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(RO1);
      FreeAndNilJSONObject(JO1);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetProdLockerList.Exception = %s', [E.Message]));
    end;
  end;
end;
//레슨 프로 목록 조회
function TClientDM.GetLessonProList(const AProductCode: string; var AErrMsg: string): Boolean;
const
  CS_API = 'K238_LessonProList';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO: TJSONObject;
  JV: TJSONValue;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sProCode, sProName: string;
  nCount: Integer;
begin
  Result := False;
  AErrMsg := '';
  nCount := 0;
  JO := nil;
  JV := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    ClearMemData(MDLessonPro);
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&product_cd=%s', [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, AProductCode]);
      SS.Clear;
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg  := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO.FindValue('result_data') is TJSONNull) then
      begin
        JV := JO.Get('result_data').JsonValue;
        nCount := (JV as TJSONArray).Count;
        if (nCount > 0) then
        begin
          with MDLessonPro do
          try
            DisableControls;
            for var I := 0 to Pred(nCount) do
            begin
              Append;
              sProCode := (JV as TJSONArray).Items[I].P['lesson_pro_cd'].Value;
              sProName := (JV as TJSONArray).Items[I].P['lesson_pro_nm'].Value;
              FieldValues['lesson_pro_cd'] := sProCode;
              FieldValues['lesson_pro_nm'] := Format('%s (%s)', [sProName, sProCode]);
              Post;
            end;
          finally
            EnableControls;
          end;
        end;
      end;
      if (nCount = 0) and
         (not AProductCode.IsEmpty) then
        raise Exception.Create('선택 가능한 레슨 프로 데이터가 없습니다.');
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JV);
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetMemberList.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetTeeBoxStatus(AStatusDataSet: TDataSet; var AErrMsg: string): Boolean;
begin
  if Global.TeeBoxADInfo.Enabled then
    Result := GetTeeBoxStatusLocal(AStatusDataSet, AErrMsg)
  else
    Result := GetTeeBoxStatusServer(AStatusDataSet, AErrMsg);
end;
//타석가동상황(타석기AD 로컬 데이터베이스 연동)
function TClientDM.GetTeeBoxStatusLocal(AStatusDataSet: TDataSet; var AErrMsg: string): Boolean;
var
  nTeeBoxNo, nUseStatus, nHeatStatus, nReadyCount, nPlayCount, nWaitCount: Integer;
  sFloorName, sHpNo: string;
  bUseYN, bIsPlaying: Boolean;
begin
  Result := False;
  AErrMsg := '';
  try
//    if not conTeeBox.Connected then
//      raise Exception.Create('타석기AD 서버에 접속되지 않아 처리할 수 없습니다!');
    try
      AStatusDataSet.DisableControls;
      MDTeeBoxReserved.DisableControls;
      ClearMemData(TdxMemData(AStatusDataSet));
      ClearMemData(MDTeeBoxReserved);
      nReadyCount := 0;
      with TUniStoredProc.Create(nil) do
      try
        Connection := conTeeBox;
        StoredProcName := 'SP_GET_TEEBOX_STATUS';
        Params.Clear;
        Params.CreateParam(ftString, 'p_store_cd', ptInput).AsString := SaleManager.StoreInfo.StoreCode;
        Prepared := True;
        Open;
        First;
        while not Eof do
        begin
          AStatusDataSet.Append;
          nTeeBoxNo := FieldByName('teebox_no').AsInteger;
          nUseStatus := StrToIntDef(FieldByName('use_status').AsString, CTS_TEEBOX_ERROR);
          nHeatStatus := StrToIntDef(FieldByName('heat_status').AsString, CAS_OFF);
          bUseYN := (FieldByName('use_yn').AsString = CRC_YES);
          if bUseYN and
             (nUseStatus in [CTS_TEEBOX_READY]) then
            Inc(nReadyCount);
          AStatusDataSet.FieldValues['teebox_no']         := nTeeBoxNo;
          AStatusDataSet.FieldValues['teebox_nm']         := FieldByName('teebox_nm').AsString;
          AStatusDataSet.FieldValues['floor_cd']          := FieldByName('floor_cd').AsString;
          AStatusDataSet.FieldValues['use_status']        := nUseStatus;
          AStatusDataSet.FieldValues['heat_status']       := nHeatStatus;
          AStatusDataSet.FieldValues['remain_min']        := FieldByName('remain_min').AsInteger;
          AStatusDataSet.FieldValues['remain_balls']      := FieldByName('remain_balls').AsInteger;
          AStatusDataSet.FieldValues['reserve_no']        := FieldByName('reserve_no').AsString;
          AStatusDataSet.FieldValues['reserve_div']       := FieldByName('reserve_div').AsString;
          AStatusDataSet.FieldValues['member_no']         := FieldByName('member_no').AsString;
          AStatusDataSet.FieldValues['member_nm']         := FieldByName('member_nm').AsString;
          AStatusDataSet.FieldValues['memo']              := FieldByName('memo').AsString;
          AStatusDataSet.FieldValues['error_cd']          := FieldByName('error_cd').AsInteger;
          AStatusDataSet.FieldValues['reserve_datetime']  := FieldByName('reserve_date').AsString;
          AStatusDataSet.FieldValues['start_datetime']    := FieldByName('start_date').AsString;
          AStatusDataSet.FieldValues['end_datetime']      := FieldByName('end_date').AsString;
          AStatusDataSet.FieldValues['lesson_pro_nm']     := FieldByName('lesson_pro_nm').AsString;
          AStatusDataSet.FieldValues['lesson_pro_color']  := HTML2Color(FieldByName('lesson_pro_pos_color').AsString, $00FFFFFF); //clWhite
          if (SaleManager.StoreInfo.OutdoorDiv = CGD_INDOOR) then
            AStatusDataSet.FieldValues['agent_status'] := StrToIntDef(FieldByName('agent_status').AsString, 0) //0:Off, 1:On
          else
            AStatusDataSet.FieldValues['agent_status'] := 1; //0:Off, 1:On
          AStatusDataSet.Post;
          Next;
        end;
      finally
        Close;
        Free;
      end;
      nPlayCount := 0;
      nWaitCount := 0;
      with TUniStoredProc.Create(nil) do
      try
        Connection := conTeeBox;
        StoredProcName := 'SP_GET_TEEBOX_RESERVED';
        Params.Clear;
        Params.CreateParam(ftString, 'p_store_cd', ptInput).AsString := SaleManager.StoreInfo.StoreCode;
        Prepared := True;
        Open;
        First;
        while not Eof do
        begin
          nTeeBoxNo := FieldByName('teebox_no').AsInteger;
          bIsPlaying := (FieldByName('use_status').AsInteger = CTS_TEEBOX_USE);
          sHpNo := '';
          try
            sHpNo := FieldByName('hp_no').AsString;
          except
          end;
          try
            sFloorName := FieldByName('floor_nm').AsString;
          except
            sFloorName := FieldByName('floor_cd').AsString;
          end;
          MDTeeBoxReserved.Append;
          MDTeeBoxReserved.FieldValues['use_seq']         := FieldByName('use_seq').AsInteger;
          MDTeeBoxReserved.FieldValues['teebox_no']       := nTeeBoxNo;
          MDTeeBoxReserved.FieldValues['teebox_nm']       := FieldByName('teebox_nm').AsString;
          MDTeeBoxReserved.FieldValues['floor_cd']        := FieldByName('floor_cd').AsString;
          MDTeeBoxReserved.FieldValues['floor_nm']        := sFloorName;
          MDTeeBoxReserved.FieldValues['reserve_root_div']:= FieldByName('reserve_root_div').AsString;
          MDTeeBoxReserved.FieldValues['affiliate_cd']    := FieldByName('affiliate_cd').AsString;
          MDTeeBoxReserved.FieldValues['assign_yn']       := (FieldByName('assign_yn').AsString = CRC_YES);
          MDTeeBoxReserved.FieldValues['product_cd']      := FieldByName('product_cd').AsString;
          MDTeeBoxReserved.FieldValues['product_nm']      := FieldByName('product_nm').AsString;
          MDTeeBoxReserved.FieldValues['avail_zone_cd']   := FieldByName('available_zone_cd').AsString;
          MDTeeBoxReserved.FieldValues['assign_min']      := FieldByName('assign_min').AsInteger;
          MDTeeBoxReserved.FieldValues['assign_balls']    := FieldByName('assign_balls').AsInteger;
          MDTeeBoxReserved.FieldValues['prepare_min']     := FieldByName('prepare_min').AsInteger;
          MDTeeBoxReserved.FieldValues['reserve_no']      := FieldByName('reserve_no').AsString;
          MDTeeBoxReserved.FieldValues['reserve_div']     := FieldByName('reserve_div').AsString;
          MDTeeBoxReserved.FieldValues['purchase_cd']     := FieldByName('purchase_cd').AsString;
          MDTeeBoxReserved.FieldValues['member_no']       := FieldByName('member_no').AsString;
          MDTeeBoxReserved.FieldValues['member_nm']       := FieldByName('member_nm').AsString;
          MDTeeBoxReserved.FieldValues['hp_no']           := sHpNo;
          MDTeeBoxReserved.FieldValues['memo']            := FieldByName('memo').AsString;
          MDTeeBoxReserved.FieldValues['receipt_no']      := FieldByName('receipt_no').AsString;
          MDTeeBoxReserved.FieldValues['play_yn']         := bIsPlaying;
          MDTeeBoxReserved.FieldValues['reserve_datetime']:= FieldByName('reserve_datetime').AsString;
          MDTeeBoxReserved.FieldValues['start_datetime']  := FieldByName('start_datetime').AsString;
          MDTeeBoxReserved.FieldValues['end_datetime']    := FieldByName('end_datetime').AsString;
          MDTeeBoxReserved.FieldValues['reserve_move_yn'] := (FieldByName('reserve_move').AsString = CRC_YES);
          MDTeeBoxReserved.FieldValues['lesson_pro_nm']   := FieldByName('lesson_pro_nm').AsString;
          MDTeeBoxReserved.FieldValues['lesson_pro_color']:= HTML2Color(FieldByName('lesson_pro_pos_color').AsString, $00FFFFFF); //clWhite
          if (not bIsPlaying) and
             AStatusDataSet.Locate('teebox_no', nTeeBoxNo, []) then
          begin
            AStatusDataSet.Edit;
            AStatusDataSet.FieldValues['reserved_count'] := AStatusDataSet.FieldByName('reserved_count').AsInteger + 1;
            AStatusDataSet.Post;
          end;
          MDTeeBoxReserved.Post;
          if bIsPlaying then
            Inc(nPlayCount)
          else
            Inc(nWaitCount);
          Next;
        end;
        Global.TeeBoxPlayingCount := nPlayCount;
        Global.TeeBoxWaitingCount := nWaitCount;
        Global.TeeBoxReadyCount := nReadyCount;
      finally
        Close;
        Free;
      end;
      Result := True;
    except
      on E: Exception do
      begin
        AErrMsg := E.Message;
        UpdateLog(Global.LogFile, Format('GetTeeBoxStatusLocal.Exception = %s', [AErrMsg]));
      end;
    end;
  finally
    MDTeeBoxReserved.EnableControls;
    AStatusDataSet.EnableControls;
    RefreshTeeboxViewData(CPC_TEEBOX_STATUS);
    RefreshTeeBoxUsingCounter;
  end;
end;
//타석가동상황(파트너센터 API 연동)
function TClientDM.GetTeeBoxStatusServer(AStatusDataSet: TDataSet; var AErrMsg: string): Boolean;
const
  CS_API_1 = 'K402_TeeBoxStatus';
  CS_API_2 = 'K413_TeeBoxUsed';
  CS_API_3 = 'K407_TeeBoxReserved';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO1, JO2, JO3: TJSONObject;
  JV1, JV2, JV3: TJSONValue;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg: string;
  I, nCount, nTeeBoxNo, nUseStatus, nReadyCount, nPlayCount, nWaitCount: Integer;
  bUseYN: Boolean;
begin
  if Global.TeeBoxStatusWorking then
    Exit(True);
  Global.TeeBoxStatusWorking := True;
  Result := False;
  AErrMsg := '';
  nReadyCount := 0;
  nPlayCount := 0;
  nWaitCount := 0;
  JO1 := nil;
  JO2 := nil;
  JO3 := nil;
  JV1 := nil;
  JV2 := nil;
  JV3 := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s',
        [Global.ClientConfig.Host, CS_API_1, SaleManager.StoreInfo.StoreCode]);
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API_1 + '.Response.json');
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO1 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO1.GetValue('result_cd').Value;
      sResMsg  := JO1.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO1.FindValue('result_data') is TJSONNull) then
      begin
        ClearMemData(TdxMemData(AStatusDataSet));
        ClearMemData(MDTeeBoxReserved);
        JV1 := JO1.Get('result_data').JsonValue;
        nCount := (JV1 as TJSONArray).Count;
        AStatusDataSet.DisableControls;
        MDTeeBoxReserved.DisableControls;
        try
          if (nCount > 0) then
            for I := 0 to Pred(nCount) do
            begin
              with AStatusDataSet do
              begin
                Append;
                nTeeBoxNo := StrToInt((JV1 as TJSONArray).Items[I].P['teebox_no'].Value);
                nUseStatus := StrToIntDef((JV1 as TJSONArray).Items[I].P['use_status'].Value, CTS_TEEBOX_ERROR);
                bUseYN := ((JV1 as TJSONArray).Items[I].P['use_yn'].Value = CRC_YES);
                if bUseYN and
                   (nUseStatus in [CTS_TEEBOX_READY]) then
                  Inc(nReadyCount);
                FieldValues['teebox_no']        := nTeeBoxNo;
                FieldValues['teebox_nm']        := (JV1 as TJSONArray).Items[I].P['teebox_nm'].Value;
                FieldValues['floor_cd']         := (JV1 as TJSONArray).Items[I].P['floor_cd'].Value;
                FieldValues['use_status']       := nUseStatus;
                FieldValues['remain_min']       := StrToIntDef((JV1 as TJSONArray).Items[I].P['remain_min'].Value, 0);
                FieldValues['remain_balls']     := StrToIntDef((JV1 as TJSONArray).Items[I].P['remain_balls'].Value, 0);
                FieldValues['reserve_no']       := (JV1 as TJSONArray).Items[I].P['reserve_no'].Value;
                FieldValues['reserve_div']      := (JV1 as TJSONArray).Items[I].P['reserve_div'].Value;
                FieldValues['member_nm']        := (JV1 as TJSONArray).Items[I].P['member_nm'].Value;
                FieldValues['member_no']        := (JV1 as TJSONArray).Items[I].P['member_no'].Value;
                FieldValues['memo']             := (JV1 as TJSONArray).Items[I].P['memo'].Value;
                FieldValues['reserve_datetime'] := NVL((JV1 as TJSONArray).Items[I].P['reserve_datetime'].Value, '');
                FieldValues['start_datetime']   := NVL((JV1 as TJSONArray).Items[I].P['start_datetime'].Value, '');
                FieldValues['end_datetime']     := NVL((JV1 as TJSONArray).Items[I].P['end_datetime'].Value, '');
                Post;
              end;
            end;
          //타석 사용자 목록
          sUrl := Format('%s/wix/api/%s?store_cd=%s&teebox_no=%d',
            [Global.ClientConfig.Host, CS_API_2, SaleManager.StoreInfo.StoreCode, 0]);
          SS.Clear;
          HC.Get(sUrl, SS);
          SS.SaveToFile(Global.LogDir + CS_API_2 + '.Response.json');
          RBS := PAnsiChar(SS.Memory);
          SetCodePage(RBS, 65001, False);
          JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
          sResCode := JO2.GetValue('result_cd').Value;
          sResMsg  := JO2.GetValue('result_msg').Value;
          if (sResCode <> CRC_SUCCESS) then
            raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
          if not (JO2.FindValue('result_data') is TJSONNull) then
          begin
            JV2 := JO2.Get('result_data').JsonValue;
            nPlayCount := (JV2 as TJSONArray).Count;
            if (nPlayCount > 0) then
              for I := 0 to Pred(nPlayCount) do
              begin
                nTeeBoxNo := StrToIntDef((JV2 as TJSONArray).Items[I].P['teebox_no'].Value, 0);
                with MDTeeBoxReserved do
                begin
                  Append;
                  FieldValues['teebox_no']        := nTeeBoxNo;
                  FieldValues['teebox_nm']        := NVL((JV2 as TJSONArray).Items[I].P['teebox_nm'].Value, '');
                  FieldValues['floor_cd']         := NVL((JV2 as TJSONArray).Items[I].P['floor_cd'].Value, '');
                  FieldValues['reserve_root_div'] := NVL((JV2 as TJSONArray).Items[I].P['reserve_root_div'].Value, '');
                  FieldValues['assign_yn']        := ((JV2 as TJSONArray).Items[I].P['assign_yn'].Value = CRC_YES);
                  FieldValues['product_cd']       := NVL((JV2 as TJSONArray).Items[I].P['product_cd'].Value, '');
                  FieldValues['product_nm']       := NVL((JV2 as TJSONArray).Items[I].P['product_nm'].Value, '');
                  FieldValues['floor_cd']         := NVL((JV2 as TJSONArray).Items[I].P['floor_cd'].Value, '');
                  FieldValues['assign_min']       := StrToIntDef((JV2 as TJSONArray).Items[I].P['assign_min'].Value, 0);
                  FieldValues['assign_balls']     := StrToIntDef((JV2 as TJSONArray).Items[I].P['assign_balls'].Value, 0);
                  FieldValues['prepare_min']      := StrToIntDef((JV2 as TJSONArray).Items[I].P['prepare_min'].Value, 0);
                  FieldValues['reserve_no']       := NVL((JV2 as TJSONArray).Items[I].P['reserve_no'].Value, '');
                  FieldValues['reserve_div']      := NVL((JV2 as TJSONArray).Items[I].P['reserve_div'].Value, '');
                  FieldValues['reserve_datetime'] := NVL((JV2 as TJSONArray).Items[I].P['reserve_datetime'].Value, '');
                  FieldValues['start_datetime']   := NVL((JV2 as TJSONArray).Items[I].P['start_datetime'].Value, '');
                  FieldValues['end_datetime']     := NVL((JV2 as TJSONArray).Items[I].P['end_datetime'].Value, '');
                  FieldValues['purchase_cd']      := NVL((JV2 as TJSONArray).Items[I].P['purchase_cd'].Value, '');
                  FieldValues['product_nm']       := NVL((JV2 as TJSONArray).Items[I].P['product_nm'].Value, '');
                  FieldValues['receipt_no']       := NVL((JV2 as TJSONArray).Items[I].P['receipt_no'].Value, '');
                  FieldValues['member_nm']        := NVL((JV2 as TJSONArray).Items[I].P['member_nm'].Value, '');
                  FieldValues['member_no']        := NVL((JV2 as TJSONArray).Items[I].P['member_no'].Value, '');
                  FieldValues['hp_no']            := NVL((JV2 as TJSONArray).Items[I].P['hp_no'].Value, '');
                  FieldValues['coupon_cnt']       := StrToIntDef((JV2 as TJSONArray).Items[I].P['coupon_cnt'].Value, 0);
                  FieldValues['memo']             := (JV2 as TJSONArray).Items[I].P['memo'].Value;
                  FieldValues['play_yn']          := True;
                  Post;
                end;
              end;
          end;
          //전체 예약 목록 (teebox_no=0)
          sUrl := Format('%s/wix/api/%s?store_cd=%s&teebox_no=%d',
            [Global.ClientConfig.Host, CS_API_3, SaleManager.StoreInfo.StoreCode, 0]);
          SS.Clear;
          HC.Get(sUrl, SS);
          SS.SaveToFile(Global.LogDir + CS_API_3 + '.json');
          RBS := PAnsiChar(SS.Memory);
          SetCodePage(RBS, 65001, False);
          JO3 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
          sResCode := JO3.GetValue('result_cd').Value;
          sResMsg  := JO3.GetValue('result_msg').Value;
          if (sResCode <> CRC_SUCCESS) then
            raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
          if not (JO3.FindValue('result_data') is TJSONNull) then
          begin
            JV3 := JO3.Get('result_data').JsonValue;
            nWaitCount := (JV3 as TJSONArray).Count;
            if (nWaitCount > 0) then
            for I := 0 to Pred(nWaitCount) do
            begin
              nTeeBoxNo := StrToIntDef((JV3 as TJSONArray).Items[I].P['teebox_no'].Value, 0);
              with MDTeeBoxReserved do
              begin
                Append;
                FieldValues['teebox_no']        := nTeeBoxNo;
                FieldValues['teebox_nm']        := NVL((JV3 as TJSONArray).Items[I].P['teebox_nm'].Value, '');
                FieldValues['floor_cd']         := NVL((JV3 as TJSONArray).Items[I].P['floor_cd'].Value, '');
                FieldValues['reserve_root_div'] := NVL((JV3 as TJSONArray).Items[I].P['reserve_root_div'].Value, '');
                FieldValues['assign_yn']        := ((JV3 as TJSONArray).Items[I].P['assign_yn'].Value = CRC_YES);
                FieldValues['product_cd']       := NVL((JV3 as TJSONArray).Items[I].P['product_cd'].Value, '');
                FieldValues['product_nm']       := NVL((JV3 as TJSONArray).Items[I].P['product_nm'].Value, '');
                FieldValues['floor_cd']         := NVL((JV3 as TJSONArray).Items[I].P['floor_cd'].Value, '');
                FieldValues['assign_min']       := StrToIntDef((JV3 as TJSONArray).Items[I].P['assign_min'].Value, 0);
                FieldValues['assign_balls']     := StrToIntDef((JV3 as TJSONArray).Items[I].P['assign_balls'].Value, 0);
                FieldValues['prepare_min']      := StrToIntDef((JV3 as TJSONArray).Items[I].P['prepare_min'].Value, 0);
                FieldValues['reserve_no']       := NVL((JV3 as TJSONArray).Items[I].P['reserve_no'].Value, '');
                FieldValues['reserve_div']      := NVL((JV3 as TJSONArray).Items[I].P['reserve_div'].Value, '');
                FieldValues['affiliate_cd']     := NVL((JV3 as TJSONArray).Items[I].P['alliance_code'].Value, '');
                FieldValues['reserve_datetime'] := NVL((JV3 as TJSONArray).Items[I].P['reserve_datetime'].Value, '');
                FieldValues['start_datetime']   := NVL((JV3 as TJSONArray).Items[I].P['start_datetime'].Value, '');
                FieldValues['end_datetime']     := NVL((JV3 as TJSONArray).Items[I].P['end_datetime'].Value, '');
                FieldValues['purchase_cd']      := NVL((JV3 as TJSONArray).Items[I].P['purchase_cd'].Value, '');
                FieldValues['product_nm']       := NVL((JV3 as TJSONArray).Items[I].P['product_nm'].Value, '');
                FieldValues['receipt_no']       := NVL((JV3 as TJSONArray).Items[I].P['receipt_no'].Value, '');
                FieldValues['member_nm']        := NVL((JV3 as TJSONArray).Items[I].P['member_nm'].Value, '');
                FieldValues['member_no']        := NVL((JV3 as TJSONArray).Items[I].P['member_no'].Value, '');
                FieldValues['hp_no']            := NVL((JV3 as TJSONArray).Items[I].P['hp_no'].Value, '');
                FieldValues['coupon_cnt']       := StrToIntDef((JV3 as TJSONArray).Items[I].P['coupon_cnt'].Value, 0);
                FieldValues['memo']             := (JV3 as TJSONArray).Items[I].P['memo'].Value;
                FieldValues['play_yn']          := False;
                Post;
              end;
              if AStatusDataSet.Locate('teebox_no', nTeeBoxNo, []) then
              begin
                AStatusDataSet.Edit;
                AStatusDataSet.FieldValues['reserved_count'] := AStatusDataSet.FieldByName('reserved_count').AsInteger + 1;
                AStatusDataSet.Post;
              end;
            end;
          end;
        finally
          MDTeeBoxReserved.EnableControls;
          AStatusDataSet.EnableControls;
        end;
      end;
      Global.TeeBoxPlayingCount := nPlayCount;
      Global.TeeBoxWaitingCount := nWaitCount;
      Global.TeeBoxReadyCount := nReadyCount;
      RefreshTeeboxViewData(CPC_TEEBOX_STATUS);
      RefreshTeeBoxUsingCounter;
      Result := True;
    finally
      Global.TeeBoxStatusWorking := False;
      FreeAndNilJSONObject(JV3);
      FreeAndNilJSONObject(JO3);
      FreeAndNilJSONObject(JV2);
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JV1);
      FreeAndNilJSONObject(JO1);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetTeeBoxStatusServer.Exception = %s', [AErrMsg]));
    end;
  end;
end;
procedure TClientDM.ReloadTeeBoxStatus;
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_TEEBOX_GETDATA;
    PM.PluginMessageToID(Global.StartModuleId);
  finally
    FreeAndNil(PM);
  end;
end;
procedure TClientDM.RefreshTeeboxViewData(const ACommand: string);
begin
  with TPluginMessage.Create(nil) do
  try
    Command := ACommand;
    if (Global.TeeBoxViewId > 0) then
      PluginMessageToID(Global.TeeBoxViewId);
    if (Global.TeeBoxEmergencyId > 0) then
      PluginMessageToID(Global.TeeBoxEmergencyId);
    if (Global.SubMonitorId > 0) then
      PluginMessageToID(Global.SubMonitorId);
  finally
    Free;
  end;
end;
procedure TClientDM.RefreshTeeBoxUsingCounter;
begin
  with TPluginMessage.Create(nil) do
  try
    Command := CPC_TEEBOX_COUNTER;
    AddParams(CPP_PLAYING_COUNT, Global.TeeBoxPlayingCount);
    AddParams(CPP_WAITING_COUNT, Global.TeeBoxWaitingCount);
    AddParams(CPP_READY_COUNT, Global.TeeBoxReadyCount);
    PluginMessageToID(Global.TeeBoxViewId);
    PluginMessageToID(Global.SubMonitorId);
    PluginMessageToID(Global.SaleFormId);
  finally
    Free;
  end;
end;
procedure TClientDM.RefreshNoticeList;
begin
  with TPluginMessage.Create(nil) do
  try
    Command := CPC_NOTICE_REFRESH;
    if (Global.StartModuleId > 0) then
      PluginMessageToID(Global.StartModuleId); //대시보드
  finally
    Free;
  end;
end;
function TClientDM.GetCodeInfo(var AErrMsg: string): Boolean;
const
  CS_API_1 = 'K220_GroupCodeList';
  CS_API_2 = 'K221_CodeList';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO1, JO2: TJSONObject;
  JV1, JV2: TJSONValue;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg: string;
  I, nCount: Integer;
begin
  Result := False;
  AErrMsg := '';
  JO1 := nil;
  JO2 := nil;
  JV1 := nil;
  JV2 := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s', [Global.ClientConfig.Host, CS_API_1]);
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API_2 + '.ResponseCodeGroup.json');
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO1 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO1.GetValue('result_cd').Value;
      sResMsg := JO1.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO1.FindValue('result_data') is TJSONNull) then
      begin
        JV1 := JO1.Get('result_data').JsonValue;
        nCount := (JV1 as TJSONArray).Count;
        if (nCount > 0) then
        begin
          with MDCodeGroup do
          try
            DisableControls;
            ClearMemData(MDCodeGroup);
            for I := 0 to Pred(nCount) do
            begin
              Append;
              FieldValues['group_cd']   := (JV1 as TJSONArray).Items[I].P['group_cd'].Value;
              FieldValues['group_nm']   := (JV1 as TJSONArray).Items[I].P['group_nm'].Value;
              FieldValues['sort_order'] := StrToIntDef((JV1 as TJSONArray).Items[I].P['sort_order'].Value, 0);
              Post;
            end;
          finally
            EnableControls;
          end;
        end;
      end;
      sUrl := Format('%s/wix/api/%s?store_cd=%s', [Global.ClientConfig.Host, CS_API_2, SaleManager.StoreInfo.StoreCode]);
      SS.Clear;
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API_2 + '.ResponseCodeItems.json');
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO2.GetValue('result_cd').Value;
      sResMsg  := JO2.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO2.FindValue('result_data') is TJSONNull) then
      begin
        JV2 := JO2.Get('result_data').JsonValue;
        nCount := (JV2 as TJSONArray).Count;
        if (nCount > 0) then
        begin
          with MDCodeItems do
          try
            DisableControls;
            ClearMemData(MDCodeItems);
            for I := 0 to Pred(nCount) do
              if ((JV2 as TJSONArray).Items[I].P['use_yn'].Value = CRC_YES) then
              begin
                Append;
                FieldValues['group_cd']   := (JV2 as TJSONArray).Items[I].P['group_cd'].Value;
                FieldValues['code']       := (JV2 as TJSONArray).Items[I].P['code'].Value;
                FieldValues['code_nm']    := (JV2 as TJSONArray).Items[I].P['code_nm'].Value;
                FieldValues['sort_order'] := StrToIntDef((JV2 as TJSONArray).Items[I].P['sort_order'].Value, 0);
                FieldValues['memo']       := (JV2 as TJSONArray).Items[I].P['memo'].Value;
                Post;
              end;
          finally
            EnableControls;
          end;
        end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JV2);
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JV1);
      FreeAndNilJSONObject(JO1);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetCodeInfo.Exception = %s', [E.Message]));
    end;
  end;
end;
procedure TClientDM.GetCodes(const AGroupCode: string; const AAddNoCode: Boolean; var AItems: TStringList);
var
  CR: TCodeRec;
begin
  with TXQuery.Create(nil) do
  try
    AItems.BeginUpdate;
    AItems.Clear;
    AddDataSet(MDCodeItems, 'C');
    SQL.Add(Format('SELECT * FROM C WHERE C.group_cd = %s ORDER BY C.sort_order;', [QuotedStr(AGroupCode)]));
    Open;
    First;
    while not Eof do
    begin
      CR := TCodeRec.Create;
      CR.Code     := FieldByName('code').AsString;
      CR.CodeName := FieldByName('code_nm').AsString;
      CR.Memo     := FieldByName('memo').AsString;
      AItems.AddObject(CR.CodeName, TObject(CR));
      Next;
    end;
  finally
    AItems.EndUpdate;
    Close;
    Free;
  end;
end;
function TClientDM.GetCodeItemName(const AGroupCode, AItemCode: string): string;
begin
  Result := '';
  with MDCodeItems do
  try
    DisableControls;
    if Locate('group_cd;code', VarArrayOf([AGroupCode, AItemCode]), []) then
      Result := FieldByName('code_nm').AsString;
  finally
    EnableControls;
  end;
end;
procedure TClientDM.GetLessonProCodes(var AItems: TStringList);
var
  CR: TCodeRec;
begin
  with MDLessonPro do
  try
    AItems.BeginUpdate;
    AItems.Clear;
    First;
    while not Eof do
    begin
      CR := TCodeRec.Create;
      CR.Code := FieldByName('lesson_pro_cd').AsString;
      CR.CodeName := FieldByName('lesson_pro_nm').AsString;
      AItems.AddObject(CR.CodeName, TObject(CR));
      Next;
    end;
  finally
    AItems.EndUpdate;
  end;
end;
function TClientDM.IndexOfCodes(const ACode: string; const AItems: TStrings): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Pred(AItems.Count) do
    if (TCodeRec(AItems.Objects[I]).Code = ACode) then
    begin
      Result := i;
      Break;
    end;
end;
procedure TClientDM.OnPaymentCalcFields(DataSet: TDataSet);
var
  sPayMethod: string;
begin
  with DataSet do
  begin
    if (FieldByName('approval_yn').AsString = CRC_YES) then
    begin
      FieldValues['calc_approval_yn'] := '결제';
      FieldValues['calc_cancel_count'] := 0;
    end else
    begin
      FieldValues['calc_approval_yn'] := '환불';
      FieldValues['calc_cancel_count'] := 1;
    end;
    sPayMethod := FieldByName('pay_method').AsString;
    if (sPayMethod = CPM_CARD) then
      FieldValues['calc_pay_method'] := '카드'
    else if (sPayMethod = CPM_CASH) then
      FieldValues['calc_pay_method'] := '현금'
    else if (sPayMethod = CPM_PAYCO_CARD) then
      FieldValues['calc_pay_method'] := 'PAYCO(카드)'
    else if (sPayMethod = CPM_PAYCO_COUPON) then
      FieldValues['calc_pay_method'] := 'PAYCO(쿠폰)'
    else if (sPayMethod = CPM_PAYCO_POINT) then
      FieldValues['calc_pay_method'] := 'PAYCO(포인트)'
    else if (sPayMethod = CPM_SALES_COUPON) then
      FieldValues['calc_pay_method'] := '할인쿠폰'
    else if (sPayMethod = CPM_FREE_COUPON) then
      FieldValues['calc_pay_method'] := '무료쿠폰'
    else if (sPayMethod = CPM_POINT) then
      FieldValues['calc_pay_method'] := '포인트'
    else if (sPayMethod = CPM_WELFARE) then
      FieldValues['calc_pay_method'] := '복지카드'
    else
      FieldValues['calc_pay_method'] := '';
  end;
end;
procedure TClientDM.OnSaleItemCalcFields(DataSet: TDataSet);
var
  nProdAmt, nChargeAmt, nDCTotal, nDCCoupon, nDCXGolf, nVatAmt, nOrderQty: Integer;
  sProdDiv, sTeeBoxProdDiv: string;
begin
  with DataSet do
  begin
    if (RecordCount = 0) then
      Exit;
    sProdDiv       := FieldByName('product_div').AsString;
    sTeeBoxProdDiv := FieldByName('teebox_prod_div').AsString;
    nProdAmt       := FieldByName('product_amt').AsInteger;
    nOrderQty      := FieldByName('order_qty').AsInteger;
    nDCCoupon      := FieldByName('coupon_dc_amt').AsInteger;
    nDCXGolf       := FieldByName('xgolf_dc_amt').AsInteger;
    nDCTotal       := (FieldByName('direct_dc_amt').AsInteger + nDCCoupon + nDCXGolf);
    nChargeAmt     := (nProdAmt * nOrderQty) - nDCTotal;
    nVatAmt        := (nChargeAmt - Trunc(nChargeAmt / 1.1));
    FieldValues['calc_sell_subtotal'] := (nProdAmt * nOrderQty);
    FieldValues['calc_coupon_dc_amt'] := nDCCoupon;
    FieldValues['calc_dc_amt']        := nDCTotal;
    FieldValues['calc_charge_amt']    := nChargeAmt;
    FieldValues['calc_vat_subtotal']  := nVatAmt;
    if (sProdDiv = CPD_TEEBOX) then
    begin
      if (sTeeBoxProdDiv = CTP_CHANGE) then
        FieldValues['calc_product_div'] := '전환'
      else if (sTeeBoxProdDiv = CTP_LESSON) then
        FieldValues['calc_product_div'] := '레슨'
      else
        FieldValues['calc_product_div'] := '타석';
    end
    else if (sProdDiv = CPD_LOCKER) then
      FieldValues['calc_product_div'] := '라커'
    else if (sProdDiv = CPD_FACILITY) then
    begin
      FieldValues['calc_product_div'] := '시설';
      FieldValues['calc_facility_count'] := nOrderQty;
    end
    else
      FieldValues['calc_product_div'] := '일반';
  end;
end;
procedure TClientDM.FreeCodes(AItems: TStringList);
var
  I: Integer;
begin
  for I := 0 to Pred(AItems.Count) do
    AItems.Objects[I].Free;
  AItems.Free;
end;
function TClientDM.CheckXGolfMemberNew(const AValueType, AMemberValue: string; var AErrMsg: string): Boolean;
const
  CS_API = 'Member/DrivingMembChk';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  RS: TStringStream;
  JO: TJSONObject;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  Screen.Cursor := crSQLWait;
  JO := TJSONObject.Create;
  RS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    try
      JO.AddPair(TJSONPair.Create('drivingCode', SaleManager.StoreInfo.StoreCode));
      JO.AddPair(TJSONPair.Create('memberKey', AValueType));
      JO.AddPair(TJSONPair.Create('memberValue', AMemberValue));
      SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
      HC.Request.ContentType := 'application/x-www-form-urlencoded';
      HC.Request.Method := 'POST';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/api/%s?drivingCode=%s&memberKey=%s&memberValue=%s', [CCC_XGOLF_API_URL, CS_API, SaleManager.StoreInfo.StoreCode, AValueType, AMemberValue]);
      HC.Post(sUrl, RS, RS);
      RS.SaveToFile(Global.LogDir + 'CheckXGolfMemberNew.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      Result := True;
    except
      on E: Exception do
      begin
        AErrMsg := E.Message;
        UpdateLog(Global.LogFile, Format('CheckXGolfMemberNew.Exception = %s, url: %s', [E.Message, sUrl]));
      end;
    end;
  finally
    Screen.Cursor := crDefault;
    FreeAndNilJSONObject(JO);
    FreeAndNil(RS);
    FreeAndNil(SSL);
    HC.Disconnect;
    FreeAndNil(HC);
  end;
end;
function TClientDM.PostMemberInfo(const ADataMode: Integer; APhotoStream: TStream; var AErrMsg: string): Boolean;
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS, RS: TStringStream;
  JO1, JO2, JO3: TJSONObject;
  RBS: RawByteString;
  PM: TPluginMessage;
  sAPIName, sUrl, sResCode, sResMsg, sMemberNo: string;
  sEncPhoto, sJsonData: string;
  bIsNewMember: Boolean;
begin
  case ADataMode of
    CDM_NEW_DATA:
      begin
        bIsNewMember := True;
        sAPIName := 'K303_AddMember2';
      end;
    CDM_EDIT_DATA:
      begin
        bIsNewMember := False;
        sAPIName := 'K304_EditMember';
      end;
    else
      Exit(False);
  end;
  Result := False;
  AErrMsg := '';
  sEncPhoto := '';
  sJsonData := '';
  APhotoStream.Position := 0;
  sEncPhoto := Base64EncodeStream(APhotoStream);
  JO1 := nil;
  JO2 := nil;
  JO3 := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := nil;
  RS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      JO1 := TJSONObject.Create;
      JO1.AddPair(TJSONPair.Create('store_cd',              SaleManager.StoreInfo.StoreCode));
      JO1.AddPair(TJSONPair.Create('user_id',               SaleManager.UserInfo.UserId));
      JO1.AddPair(TJSONPair.Create('member_seq',            TJSONNumber.Create(MemberRec.MemberSeq)));
      JO1.AddPair(TJSONPair.Create('member_no',             MemberRec.MemberNo));
      JO1.AddPair(TJSONPair.Create('member_nm',             MemberRec.MemberName));
      JO1.AddPair(TJSONPair.Create('sex_div',               MemberRec.SexDiv));
      JO1.AddPair(TJSONPair.Create('birth_ymd',             MemberRec.BirthDate));
      JO1.AddPair(TJSONPair.Create('hp_no',                 MemberRec.HpNo));
      JO1.AddPair(TJSONPair.Create('email',                 MemberRec.Email));
      JO1.AddPair(TJSONPair.Create('car_no',                MemberRec.CarNo));
      JO1.AddPair(TJSONPair.Create('zip_no',                MemberRec.ZipNo));
      JO1.AddPair(TJSONPair.Create('address',               MemberRec.Address1));
      JO1.AddPair(TJSONPair.Create('address_desc',          MemberRec.Address2));
      JO1.AddPair(TJSONPair.Create('customer_cd',           MemberRec.CustomerCode));
      JO1.AddPair(TJSONPair.Create('member_card_uid',       MemberRec.MemberCardUId));
      JO1.AddPair(TJSONPair.Create('group_cd',              MemberRec.GroupCode));
      JO1.AddPair(TJSONPair.Create('qr_cd',                 MemberRec.QrCode));
      JO1.AddPair(TJSONPair.Create('photo_encoding',        sEncPhoto));
      JO1.AddPair(TJSONPair.Create('fingerprint1',          MemberRec.FingerPrint1));
      JO1.AddPair(TJSONPair.Create('fingerprint2',          MemberRec.FingerPrint2)); //예비
      JO1.AddPair(TJSONPair.Create('xg_user_key',           MemberRec.XGolfNo));
      JO1.AddPair(TJSONPair.Create('welfare_cd',            MemberRec.WelfareCode));
      JO1.AddPair(TJSONPair.Create('special_yn',            System.StrUtils.IfThen(MemberRec.SpecialYN, CRC_YES, CRC_NO)));
      JO1.AddPair(TJSONPair.Create('spectrum_interface_yn', System.StrUtils.IfThen(MemberRec.SpectrumIntfYN, CRC_YES, CRC_NO)));
      JO1.AddPair(TJSONPair.Create('spectrum_cust_id',      MemberRec.SpectrumCustId));
      JO1.AddPair(TJSONPair.Create('memo',                  MemberRec.Memo));
      SS := TStringStream.Create(JO1.ToString, TEncoding.UTF8);
      SS.SaveToFile(Global.LogDir + sAPIName + '.Request.json');
//      SS.SaveToFile(Global.LogDir + sAPIName + Format('.Request_%s.json', [Global.CurrentDateTime]));
      UpdateLog(Global.LogFile, Format('PostMemberInfo.Request = member_seq: %d, member_no: %s, member_name: %s', [MemberRec.MemberSeq, MemberRec.MemberNo, MemberRec.MemberName]));
      HC.Request.ContentType := 'application/json';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s', [Global.ClientConfig.Host, sAPIName]);
      if bIsNewMember then
      begin
        HC.Request.Method := 'POST';
        HC.Post(sUrl, SS, RS);
      end
      else
      begin
        HC.Request.Method := 'PUT';
        HC.Put(sUrl, SS, RS);
      end;
      RS.SaveToFile(Global.LogDir + sAPIName + '.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO2.GetValue('result_cd').Value;
      sResMsg := JO2.GetValue('result_msg').Value;
      UpdateLog(Global.LogFile, Format('PostMemberInfo.Response = result_cd: %s, result_msg: %s', [sResCode, sResMsg]));
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      JO3 := JO2.GetValue('result_data') as TJSONObject;
      SaleManager.MemberInfo.Clear;
      SaleManager.MemberInfo.MemberNo      := JO3.GetValue('member_no').Value;
      SaleManager.MemberInfo.MemberQRCode  := JO3.GetValue('qr_cd').Value;;
      (*
      //새로운 지문인식 방법 적용을 위해 추가되어야 함
      SaleManager.MemberInfo.MemberSeq     := StrToIntDef(JO3.GetValue('member_seq').Value, 0);
      *)
      SaleManager.MemberInfo.MemberName    := MemberRec.MemberName;
      SaleManager.MemberInfo.HpNo          := MemberRec.HpNo;
      SaleManager.MemberInfo.CarNo         := MemberRec.CarNo;
      SaleManager.MemberInfo.SexDiv        := StrToIntDef(MemberRec.SexDiv, CSD_SEX_ALL); //3
      SaleManager.MemberInfo.XGolfMemberNo := MemberRec.XGolfNo;
      SaleManager.MemberInfo.Memo          := MemberRec.Memo;
      SaleManager.MemberInfo.PhotoStream.Clear;
      PM := TPluginMessage.Create(nil);
      try
        PM.Command := CPC_SEND_MEMBER_NO;
        PM.AddParams(CPP_MEMBER_NO, sMemberNo);
        PM.PluginMessageToID(Global.TeeBoxViewId);
        PM.ClearParams;
        PM.Command := CPC_SEND_MEMBER_NO;
        PM.AddParams(CPP_MEMBER_NO, sMemberNo);
        PM.PluginMessageToID(Global.SaleFormId);
      finally
        FreeAndNil(PM);
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      MemberRec.Clear;
      FreeAndNilJSONObject(JO3);
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JO1);
      if Assigned(SS) then
        FreeAndNil(SS);
      FreeAndNil(RS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('PostMemberInfo.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetMemberSearch(const AMemberNo, AMemberName, AHpNo, ACarNo, AEmpFilter: string; const AUsePhoto: Boolean; const ATimeOut: Integer; var AErrMsg: string): Boolean;
const
  CS_API = 'K301_Member';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO: TJSONObject;
  JV: TJSONValue;
  RBS: RawByteString;
  AIdDM: TIdDecoderMIME;
  AIdBytes: TIdBytes;
  ABytes: TBytes;
  IMG: TImage;
  JPG: TJPEGImage;
  sUrl, sResCode, sResMsg, sMemberNo, sLockerName, sLockerList, sLockerEndDay, sPhotoEnc: string;
  I, J, nCount, nLockerNo, nTimeOut: Integer;
begin
  Result := False;
  AErrMsg := '';
  nTimeOut := ATimeOut;
  if (nTimeOut = 0) then
    nTimeOut := Global.TeeBoxADInfo.APITimeout;
  JO := nil;
  JV := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    try
      if (not AMemberName.IsEmpty) and (AMemberName.Length < 2) then
        raise Exception.Create('검색할 회원명은 2자 이상 입력되어야 합니다!');
      if (not AHpNo.IsEmpty) and (AHpNo.Length < 4) then
        raise Exception.Create('검색할 전화번호는 4자 이상 입력되어야 합니다!');
      if (not AHpNo.IsEmpty) and (AHpNo.Length < 4) then
        raise Exception.Create('검색할 차량번호는 4자 이상 입력되어야 합니다!');
      Screen.Cursor := crSQLWait;
      ClearMemData(MDMemberSearch);
      sUrl := Format('%s/wix/api/%s?store_cd=%s&member_no=%s&member_nm=%s&hp_no=%s&car_no=%s&photo_yn=%s&emp_yn=%s',
        [Global.ClientConfig.Host,
          TIdURI.ParamsEncode(CS_API),
          TIdURI.ParamsEncode(SaleManager.StoreInfo.StoreCode),
          TIdURI.ParamsEncode(AMemberNo),
          TIdURI.ParamsEncode(AMemberName),
          TIdURI.ParamsEncode(AHpNo),
          TIdURI.ParamsEncode(ACarNo),
          TIdURI.ParamsEncode(IIF(AUsePhoto, CRC_YES, CRC_NO)),
          TIdURI.ParamsEncode(AEmpFilter)]);  //'Y'(직원만) or 'N'(회원만) or ''(전체)
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := nTimeOut;
      HC.ReadTimeout := nTimeOut;
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
//      SS.SaveToFile(Global.LogDir + CS_API + Format('.Response_%s.json', [Global.CurrentDateTime]));
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO.FindValue('result_data') is TJSONNull) then
      begin
        JV := JO.Get('result_data').JsonValue;
        nCount := (JV as TJSONArray).Count;
        if (nCount > 0) then
        begin
          with MDMemberSearch do
          try
            MDMember.DisableControls;
            DisableControls;
            for I := 0 to Pred(nCount) do
            begin
              Append;
              sMemberNo     := (JV as TJSONArray).Items[I].P['member_no'].Value;
              nLockerNo     := StrToIntDef((JV as TJSONArray).Items[I].P['locker_no'].Value, 0);
              sLockerName   := (JV as TJSONArray).Items[I].P['locker_nm'].Value;
              sLockerEndDay := (JV as TJSONArray).Items[I].P['end_day'].Value;
              sLockerList   := (JV as TJSONArray).Items[I].P['locker_list'].Value;
              FieldValues['member_seq']       := StrToInt((JV as TJSONArray).Items[I].P['member_seq'].Value);
              FieldValues['member_no']        := sMemberNo;
              FieldValues['member_nm']        := (JV as TJSONArray).Items[I].P['member_nm'].Value;
              FieldValues['customer_cd']      := (JV as TJSONArray).Items[I].P['customer_cd'].Value;
              FieldValues['group_cd']         := (JV as TJSONArray).Items[I].P['group_cd'].Value;
              FieldValues['member_card_uid']  := (JV as TJSONArray).Items[I].P['member_card_uid'].Value;
              FieldValues['welfare_cd']       := (JV as TJSONArray).Items[I].P['welfare_cd'].Value;
              FieldValues['dc_rate']          := StrToIntDef((JV as TJSONArray).Items[I].P['dc_rate'].Value, 0);
              FieldValues['member_point']     := StrToIntDef((JV as TJSONArray).Items[I].P['member_point'].Value, 0);
              FieldValues['sex_div']          := StrToIntDef((JV as TJSONArray).Items[I].P['sex_div'].Value, CSD_SEX_ALL);
              FieldValues['birth_ymd']        := (JV as TJSONArray).Items[I].P['birth_ymd'].Value;
              FieldValues['hp_no']            := StringReplace((JV as TJSONArray).Items[I].P['hp_no'].Value, '-', '', [rfReplaceAll]);
              FieldValues['email']            := (JV as TJSONArray).Items[I].P['email'].Value;
              FieldValues['car_no']           := (JV as TJSONArray).Items[I].P['car_no'].Value;
              FieldValues['zip_no']           := (JV as TJSONArray).Items[I].P['zip_no'].Value;
              FieldValues['address']          := (JV as TJSONArray).Items[I].P['address'].Value;
              FieldValues['address_desc']     := (JV as TJSONArray).Items[I].P['address_desc'].Value;
              FieldValues['qr_cd']            := (JV as TJSONArray).Items[I].P['qr_cd'].Value;
              FieldValues['xg_user_key']      := (JV as TJSONArray).Items[I].P['xg_user_key'].Value;
              FieldValues['special_yn']       := ((JV as TJSONArray).Items[I].P['special_yn'].Value = CRC_YES);
              FieldValues['locker_no']        := nLockerNo;
              FieldValues['locker_nm']        := sLockerName;
              FieldValues['locker_list']      := sLockerList;
              FieldValues['expire_locker']    := sLockerEndDay;
              FieldValues['memo']             := (JV as TJSONArray).Items[I].P['memo'].Value;
              FieldValues['fingerprint1']     := (JV as TJSONArray).Items[I].P['fingerprint1'].Value;
              FieldValues['fingerprint2']     := (JV as TJSONArray).Items[I].P['fingerprint2'].Value;
              if SaleManager.StoreInfo.SpectrumYN then
                FieldValues['spectrum_cust_id'] := (JV as TJSONArray).Items[I].P['spectrum_cust_id'].Value;
              if not ((JV as TJSONArray).Items[I].FindValue('photo_encoding') is TJSONNull) then
              try
                sPhotoEnc := StringReplace((JV as TJSONArray).Items[I].P['photo_encoding'].Value, _CRLF, '', [rfReplaceAll]);
                if not sPhotoEnc.IsEmpty then
                begin
                  (*
                  ABytes := TNetEncoding.Base64.DecodeStringToBytes(sPhotoEnc);
                  SS.Clear;
                  SS.Write(ABytes, Length(ABytes));
                  SS.Position := 0;
                  TBlobField(FieldByName('photo')).LoadFromStream(SS);
                  *)
                  AIdDM := TIdDecoderMIME.Create(nil);
                  try
                    AIdBytes := AIdDM.DecodeBytes(sPhotoEnc);
                    SetLength(ABytes, Length(AIdBytes));
                    for J := 0 to Pred(Length(AIdBytes)) do
                      ABytes[J] := AIdBytes[J];
                    SS.Clear;
                    SS.Write(ABytes, Length(ABytes));
                    SS.Position := 0;
                    IMG := TImage.Create(nil);
                    IMG.Picture.WICImage.LoadFromStream(SS);
                    try
                      if (IMG.Picture.WICImage.ImageFormat <> TWICImageFormat.wifJpeg) then
                      begin
                        JPG := TJPEGImage.Create;
                        JPG.Assign(IMG.Picture.WICImage);
                        try
                          SS.Clear;
                          JPG.SaveToStream(SS);
                          SS.Position := 0;
                        finally
                          JPG.Free;
                        end;
                      end;
                    finally
                      IMG.Free;
                    end;
                    TBlobField(FieldByName('photo')).LoadFromStream(SS);
                  finally
                    AIdDM.Free;
                  end;
                end;
              except
                on E: Exception do
                  UpdateLog(Global.LogFile, Format('GetMemberSearch.PhotoDecoding.Exception = %s', [E.Message]));
              end;
              Post;
              if MDMember.Locate('member_no', sMemberNo, []) then
              begin
                MDMember.Edit;
                MDMember.FieldValues['locker_no']     := nLockerNo;
                MDMember.FieldValues['locker_nm']     := sLockerName;
                MDMember.FieldValues['expire_locker'] := sLockerEndDay;
                MDMember.FieldValues['locker_list']   := sLockerList;
                MDMember.Post;
              end;
            end;
          finally
            First;
            EnableControls;
            MDMember.EnableControls;
          end;
        end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JV);
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetMemberSearch.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.SearchMemberByCode(const ACodeType: Integer; const ASearchValue: string; var AErrMsg: string): Boolean;
var
  MS: TMemoryStream;
  sKind, sErrMsg: string;
begin
  Result := False;
  try
    if not GetMemberList(sErrMsg) then
      raise Exception.Create(sErrMsg);
    sKind := '회원';
    case ACodeType of
      CMC_MEMBER_CODE:
        Result := MDMember.Locate('member_no', ASearchValue, []);
      CMC_MEMBER_QRCODE:
        Result := MDMember.Locate('qr_cd', ASearchValue, []);
      CMC_XGOLF_QRCODE:
        Result := MDMember.Locate('xg_user_key', ASearchValue, []);
      CMC_MEMBER_CARD_UID:
        Result := MDMember.Locate('member_card_uid', ASearchValue, []);
      CMC_WELFARE_CODE:
        begin
          sKind := '직원';
          Result := MDMember.Locate('welfare_cd', ASearchValue, []);
        end;
      else
        raise Exception.Create(sKind + ' 검색 조건이 지정되지 않았습니다!');
    end;
    if not Result then
      raise Exception.Create('검색 조건에 일치하는 ' + sKind + ' 정보가 없습니다!');
    MS := TMemoryStream.Create;
    try
      (MDMember.FieldByName('photo') as TBlobField).SaveToStream(MS);
      MS.Position := 0;
      with SaleManager.MemberInfo do
      begin
        MemberNo      := MDMember.FieldByName('member_no').AsString;
        MemberSeq     := MDMember.FieldByName('member_seq').AsInteger;
        MemberQRCode  := MDMember.FieldByName('qr_cd').AsString;
        MemberName    := MDMember.FieldByName('member_nm').AsString;
        CustomerCode  := MDMember.FieldByName('customer_cd').AsString;
        MemberCardUID := MDMember.FieldByName('member_card_uid').AsString;
        WelfareCode   := MDMember.FieldByName('welfare_cd').AsString;
        WelfareRate   := MDMember.FieldByName('dc_rate').AsInteger;
        WelfarePoint  := MDMember.FieldByName('member_point').AsInteger;
        HpNo          := MDMember.FieldByName('hp_no').AsString;
        CarNo         := MDMember.FieldByName('car_no').AsString;
        LockerNo      := MDMember.FieldByName('locker_no').AsInteger;
        LockerName    := MDMember.FieldByName('locker_nm').AsString;
        LockerList    := MDMember.FieldByName('locker_list').AsString;
        ExpireLocker  := MDMember.FieldByName('expire_locker').AsString;
        SexDiv        := MDMember.FieldByName('sex_div').AsInteger;
        XGolfMemberNo := MDMember.FieldByName('xg_user_key').AsString;
        Memo          := MDMember.FieldByName('memo').AsString;
        TBlobField(MDMember.FieldByName('photo')).SaveToStream(PhotoStream);
      end;
//      UpdateLog(Global.LogFile, Format('SearchMemberByCode.Result : 회원명=%s, 회원번호=%s',
//        [SaleManager.MemberInfo.MemberName, SaleManager.MemberInfo.MemberNo]));
      with MDMemberSearch do
      try
        DisableControls;
        ClearMemData(MDMemberSearch);
        Append;
        FieldValues['member_seq']      := MDMember.FieldByName('member_seq').AsInteger;
        FieldValues['member_no']       := MDMember.FieldByName('member_no').AsString;
        FieldValues['member_nm']       := MDMember.FieldByName('member_nm').AsString;
        FieldValues['customer_cd']     := MDMember.FieldByName('customer_cd').AsString;
        FieldValues['group_cd']        := MDMember.FieldByName('group_cd').AsString;
        FieldValues['member_card_uid'] := MDMember.FieldByName('member_card_uid').AsString;
        FieldValues['welfare_cd']      := MDMember.FieldByName('welfare_cd').AsString;
        FieldValues['dc_rate']         := MDMember.FieldByName('dc_rate').AsInteger;
        FieldValues['member_point']    := MDMember.FieldByName('member_point').AsInteger;
        FieldValues['sex_div']         := MDMember.FieldByName('sex_div').AsInteger;
        FieldValues['birth_ymd']       := MDMember.FieldByName('birth_ymd').AsString;
        FieldValues['hp_no']           := MDMember.FieldByName('hp_no').AsString;
        FieldValues['email']           := MDMember.FieldByName('email').AsString;
        FieldValues['car_no']          := MDMember.FieldByName('car_no').AsString;
        FieldValues['zip_no']          := MDMember.FieldByName('zip_no').AsString;
        FieldValues['address']         := MDMember.FieldByName('address').AsString;
        FieldValues['address_desc']    := MDMember.FieldByName('address_desc').AsString;
        FieldValues['locker_no']       := MDMember.FieldByName('locker_no').AsInteger;
        FieldValues['locker_nm']       := MDMember.FieldByName('locker_nm').AsString;
        FieldValues['expire_locker']   := MDMember.FieldByName('expire_locker').AsString;
        FieldValues['qr_cd']           := MDMember.FieldByName('qr_cd').AsString;
        FieldValues['xg_user_key']     := MDMember.FieldByName('xg_user_key').AsString;
        FieldValues['fingerprint1']    := MDMember.FieldByName('fingerprint1').AsString;
        FieldValues['fingerprint2']    := MDMember.FieldByName('fingerprint2').AsString;
        FieldValues['memo']            := MDMember.FieldByName('memo').AsString;
        (FieldByName('photo') as TBlobField).LoadFromStream(MS);
        Post;
      finally
        EnableControls;
      end;
    finally
      FreeAndNil(MS);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('SearchMemberByCode.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.SetTeeBoxHold(const ATeeBoxNo, ATeeBoxIndex: Integer; const AUseHold: Boolean; var AErrMsg: string): Boolean;
var
  bEmergency: Boolean;
begin
  if Global.TeeBoxADInfo.Enabled then
  begin
    bEmergency := Global.TeeBoxEmergencyMode;
    Result := SetTeeBoxHoldLocal(ATeeBoxNo, AUseHold, bEmergency, AErrMsg);
    if bEmergency and
       (bEmergency <> Global.TeeBoxEmergencyMode) then
    begin
      Result := False;
      AErrMsg := '긴급배정 상태가 변경되었습니다!' + _CRLF + '프로그램을 종료하고 다시 시작하여 주십시오.';
      Exit;
    end;
  end
  else
    Result := SetTeeBoxHoldServer(ATeeBoxNo, AUseHold, AErrMsg);
  if Result then
    with TPluginMessage.Create(nil) do
    try
      Command := IIF(AUseHold, CPC_TEEBOX_HOLD, CPC_TEEBOX_HOLD_CANCEL);
      AddParams(CPP_TEEBOX_INDEX, ATeeBoxIndex);
      if (Global.TeeBoxViewId > 0) then
        PluginMessageToID(Global.TeeBoxViewId);
      if (Global.TeeBoxEmergencyId > 0) then
        PluginMessageToID(Global.TeeBoxEmergencyId);
      if (Global.SubMonitorId > 0) then
        PluginMessageToID(Global.SubMonitorId);
    finally
      Free;
    end;
end;
function TClientDM.SetTeeBoxHoldLocal(const ATeeBoxNo: Integer; const AUseHold: Boolean; var AEmergency: Boolean; var AErrMsg: string): Boolean;
var
  TC: TIdTCPClient;
  JO1, JO2: TJSONObject;
  SS: TStringStream;
  RBS: RawByteString;
  sAPIName, sJob, sBuffer, sResCode, sResMsg, sStoreEndTime, sStoreUpdated: string;
begin
  Result := False;
  AErrMsg := '';
  sJob := '';
  sAPIName := 'K405_TeeBoxHold';
  if not AUseHold then
  begin
    sJob := 'Cancel';
    sAPIName := 'K406_TeeBoxHold';
  end;
  JO1 := nil;
  JO2 := nil;
  SS := nil;
  TC := TIdTCPClient.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    Global.TeeBoxHoldWorking := True;
    try
      JO1 := TJSONObject.Create;
      JO1.AddPair(TJSONPair.Create('api', sAPIName));
      JO1.AddPair(TJSONPair.Create('store_cd', SaleManager.StoreInfo.StoreCode));
      JO1.AddPair(TJSONPair.Create('user_id',  Global.ClientConfig.ClientId)); //SaleManager.UserInfo.UserId
      JO1.AddPair(TJSONPair.Create('teebox_no', IntToStr(ATeeBoxNo)));
      sBuffer := JO1.ToString;
      SS := TStringStream.Create(sBuffer);
      SS.SaveToFile(Global.LogDir + sAPIName + '.Request.json');
      TC.Host := Global.TeeBoxADInfo.Host;
      TC.Port := Global.TeeBoxADInfo.APIPort;
      TC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(sBuffer, IndyTextEncoding_UTF8);
      RBS := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      SS.Clear;
      SS.WriteString(JO2.ToString);
      SS.SaveToFile(Global.LogDir + sAPIName + '.Response.json');
      sResCode := JO2.GetValue('result_cd').Value;
      sResMsg := JO2.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      Result := True;
      if AUseHold then
      begin
        sStoreEndTime := JO2.GetValue('store_close_time').Value; //hh:nn
        sStoreUpdated := JO2.GetValue('change_store_date').Value; //yyyy-mm-dd hh:nn:ss
        AEmergency := (JO2.GetValue('emergency_yn').Value = CRC_YES);
        //JO2.GetValue('DNSFail_yn').Value;
        //매장정보 재수신
        if (not AEmergency) and
           ((SaleManager.StoreInfo.StoreEndTime <> sStoreEndTime) or (SaleManager.StoreInfo.StoreUpdated < sStoreUpdated)) then
          GetStoreInfo(AErrMsg);
      end;
    finally
      Global.TeeBoxHoldWorking := False;
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JO1);
      if Assigned(SS) then
        FreeAndNil(SS);
      TC.Disconnect;
      FreeAndNil(TC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('SetTeeBoxHoldLocal%s.Exception = %s', [sJob, E.Message]));
    end;
  end;
end;
function TClientDM.SetTeeBoxHoldServer(const ATeeBoxNo: Integer; const AUseHold: Boolean; var AErrMsg: string): Boolean;
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO: TJSONObject;
  SS, RS: TStringStream;
  RBS: RawByteString;
  sAPIName, sJob, sUrl, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  sJob := '';
  sAPIName := 'K405_TeeBoxHold';
  if not AUseHold then
  begin
    sJob := 'Cancel';
    sAPIName := 'K406_TeeBoxHold';
  end;
  JO := nil;
  SS := TStringStream.Create;
  RS := TStringStream.Create;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    Global.TeeBoxHoldWorking := True;
    try
      HC.Request.ContentType := 'application/json';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&teebox_no=%d&user_id=%s',
        [Global.ClientConfig.Host, sAPIName, SaleManager.StoreInfo.StoreCode, ATeeBoxNo, Global.ClientConfig.ClientId]); //SaleManager.UserInfo.UserId
      if AUseHold then
      begin
        HC.Request.Method := 'POST';
        HC.Post(sUrl, SS, RS);
      end else
      begin
        HC.Request.Method := 'DELETE';
        HC.Delete(sUrl, RS);
      end;
      RS.SaveToFile(Global.LogDir + sAPIName + 'Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      Result := True;
    finally
      Global.TeeBoxHoldWorking := False;
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO);
      FreeAndNil(RS);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('SetTeeBoxHoldServer%s.Exception = %s', [sJob, E.Message]));
    end;
  end;
end;
function TClientDM.SetTeeBoxAgentControl(const ATeeBoxNo, AMethod: Integer; var AErrMsg: string): Boolean;
const
  CS_API = 'A440_AgentSetting';
var
  TC: TIdTCPClient;
  JO, RO: TJSONObject;
  SS: TStringStream;
  RBS: RawByteString;
  sBuffer, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  JO := nil;
  RO := nil;
  SS := nil;
  TC := TIdTCPClient.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      JO := TJSONObject.Create;
      JO.AddPair(TJSONPair.Create('api', CS_API));
      JO.AddPair(TJSONPair.Create('store_cd', SaleManager.StoreInfo.StoreCode));
      JO.AddPair(TJSONPair.Create('user_id',  Global.ClientConfig.ClientId)); //SaleManager.UserInfo.UserId
      JO.AddPair(TJSONPair.Create('teebox_no', TJSONNumber.Create(ATeeBoxNo)));
      JO.AddPair(TJSONPair.Create('method', TJSONNumber.Create(AMethod)));
      sBuffer := JO.ToString;
      SS := TStringStream.Create(sBuffer);
      SS.SaveToFile(Global.LogDir + CS_API + '.Request.json');
      TC.Host := Global.TeeBoxADInfo.Host;
      TC.Port := Global.TeeBoxADInfo.APIPort;
      TC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(sBuffer, IndyTextEncoding_UTF8);
      RBS := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      RO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      SS.Clear;
      SS.WriteString(RO.ToString);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      sResCode := RO.GetValue('result_cd').Value;
      sResMsg := RO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(RO);
      FreeAndNilJSONObject(JO);
      if Assigned(SS) then
        FreeAndNil(SS);
      TC.Disconnect;
      FreeAndNil(TC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('SetTeeBoxAgentControl(TeeBoxNo=%d, Method=%d).Exception = %s', [ATeeBoxNo, AMethod, E.Message]));
    end;
  end;
end;
procedure TClientDM.SPTeeBoxAssignListCalcFields(DataSet: TDataSet);
begin
  with DataSet do
  begin
    case StrToIntDef(FieldByName('use_status').AsString, 0) of
      1: FieldValues['calc_use_status'] := '이용중';
      2: FieldValues['calc_use_status'] := '이용종료';
      3: FieldValues['calc_use_status'] := '임시예약';
      4: FieldValues['calc_use_status'] := '대기';
      5: FieldValues['calc_use_status'] := '취소';
      7: FieldValues['calc_use_status'] := '볼회수';
      8: FieldValues['calc_use_status'] := '점검';
      9: FieldValues['calc_use_status'] := '기기고장';
    end;
    if (FieldByName('reserve_move_yn').AsString = CRC_YES) then
      FieldValues['calc_move_status'] := '이동배정'
    else if (FieldByName('move_yn').AsString = CRC_YES) then
      FieldValues['calc_move_status'] := '취소(이동)';
  end;
end;
procedure TClientDM.SPTeeBoxNoShowListCalcFields(DataSet: TDataSet);
var
  sValue: string;
begin
  with DataSet do
  begin
    FieldValues['calc_reserve_time'] := Copy(FieldByName('reserve_datetime').AsString, 12, 5);
    FieldValues['calc_start_time'] := Copy(FieldByName('start_datetime').AsString, 12, 5);
    FieldValues['calc_end_time'] := Copy(FieldByName('end_datetime').AsString, 12, 5);
    sValue := FieldByName('reserve_div').AsString;
    if (sValue = CTR_DAILY_MEMBER) then
      FieldValues['calc_reserve_div'] := '일일타석'
    else if (sValue = CTR_TERM_MEMBER) then
      FieldValues['calc_reserve_div'] := '기간회원'
    else if (sValue = CTR_COUPON_MEMBER) then
      FieldValues['calc_reserve_div'] := '쿠폰회원';
    sValue := FieldByName('reserve_root_div').AsString;
    if (sValue = CCT_POS) then
      FieldValues['calc_reserve_root_div'] := '프런트'
    else if (sValue = CCT_KIOSK) then
      FieldValues['calc_reserve_root_div'] := '키오스크'
    else if (sValue = CCT_MOBILE) then
      FieldValues['calc_reserve_root_div'] := '모바일'
    else if (sValue = CCT_TELE_RESERVED) then
      FieldValues['calc_reserve_root_div'] := '전화예약'
    else
      FieldValues['calc_reserve_root_div'] := sValue;
  end;
end;
procedure TClientDM.UpdateTeeBoxSelection(const ASelected: Boolean; const ATeeBoxNo: Integer; const AFloorCode, AFloorName, AZoneCode: string);
begin
  UpdateTeeBoxSelection(ASelected, ATeeBoxNo, 0, AFloorCode, AFloorName, AZoneCode, False, '');
end;
procedure TClientDM.UpdateTeeBoxSelection(const ASelected: Boolean;
  const ATeeBoxNo, ATeeBoxIndex: Integer; const AFloorCode, AFloorName, AZoneCode: string; const AIsVIP: Boolean; const ATeeBoxName: string);
var
  BM: TBookmark;
  bExists: Boolean;
begin
  with MDTeeBoxSelected do
  try
    DisableControls;
    BM := GetBookmark;
    bExists := Locate('teebox_no', ATeeBoxNo, []);
    if ASelected then
    begin
      if not bExists then
      begin
        Append;
        FieldValues['teebox_no']    := ATeeBoxNo;
        FieldValues['teebox_index'] := ATeeBoxIndex;
        FieldValues['teebox_nm']    := ATeeBoxName;
        FieldValues['teebox_div']   := '';
        FieldValues['floor_cd']     := AFloorCode;
        FieldValues['floor_nm']     := AFloorName;
        FieldValues['vip_div']      := IIF(AIsVIP, 'VIP', '');
        FieldValues['vip_cnt']      := IIF(AIsVIP, 1, 0);
        FieldValues['prepare_min']  := Global.PrepareMin;
        FieldValues['assign_balls'] := 9999;
        FieldValues['zone_cd']      := AZoneCode;
        if MDTeeBoxStatus.Locate('teebox_no', FieldByName('teebox_no').AsInteger, []) then
          FieldValues['hold_datetime'] := MDTeeBoxStatus.FieldByName('end_datetime').AsString;
        Post;
      end;
    end else
    begin
      if bExists then
        Delete;
    end;
    if BookmarkValid(BM) then
      GotoBookmark(BM);
  finally
    FreeBookmark(BM);
    EnableControls;
  end;
end;
function TClientDM.ImmediateTeeBoxStart(const AChoiceReserveNo: string; var AErrMsg: string): Boolean;
const
  CS_API = 'A417_TeeBoxStart';
var
  TC: TIdTCPClient;
  JO1, JO2: TJSONObject;
  RBS: RawByteString;
  sBuffer, sResCode, sResMsg: string;
  SS: TStringStream;
begin
  Result := False;
  AErrMsg := '';
  JO1 := nil;
  JO2 := nil;
  SS := nil;
  TC := TIdTCPClient.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      JO1 := TJSONObject.Create;
      JO1.AddPair(TJSONPair.Create('api', CS_API));
      JO1.AddPair(TJSONPair.Create('store_cd', SaleManager.StoreInfo.StoreCode));
      JO1.AddPair(TJSONPair.Create('reserve_no', AChoiceReserveNo));
      JO1.AddPair(TJSONPair.Create('user_id', Global.ClientConfig.ClientId)); //SaleManager.UserInfo.UserId
      sBuffer := JO1.ToString;
      SS := TStringStream.Create(sBuffer);
      SS.SaveToFile(Global.LogDir + CS_API + '.Request.json');
      TC.Host := Global.TeeBoxADInfo.Host;
      TC.Port := Global.TeeBoxADInfo.APIPort;
      TC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(sBuffer, IndyTextEncoding_UTF8);
      RBS := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      SS.Clear;
      SS.WriteString(JO2.ToString);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      sResCode := JO2.GetValue('result_cd').Value;
      sResMsg := JO2.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JO1);
      if Assigned(SS) then
        FreeAndNil(SS);
      TC.Disconnect;
      FreeAndNil(TC);
    end;
  except
    on E: Exception do
      AErrMsg := E.Message;
  end;
end;
function TClientDM.GetAirConStatus(var AErrMsg: string): Boolean;
const
  CS_API = 'K415_TeeBoxHeatStatus';
var
  TC: TIdTCPClient;
  JO1, JO2: TJSONObject;
  JV2: TJSONValue;
  sRecvData: AnsiString;
  I, nCount, nTeeBoxNo: Integer;
begin
  Result := False;
  AErrMsg := '';
  TC := TIdTCPClient.Create(nil);
  try
    JO2 := nil;
    JV2 := nil;
    JO1 := TJSONObject.Create;
    JO1.AddPair(TJSONPair.Create('api', CS_API));
    JO1.AddPair(TJSONPair.Create('store_cd', SaleManager.StoreInfo.StoreCode));
    JO1.AddPair(TJSONPair.Create('user_id', Global.ClientConfig.ClientId)); //SaleManager.UserInfo.UserId
    try
      TC.Host := Global.TeeBoxADInfo.Host;
      TC.Port := Global.TeeBoxADInfo.APIPort;
      TC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(JO1.ToString, IndyTextEncoding_UTF8);
      sRecvData := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      JO2 := TJSONObject.ParseJSONValue(String(sRecvData)) as TJSONObject;
      if not (JO2.FindValue('data') is TJSONNull) then
      begin
        JV2 := JO2.Get('data').JsonValue;
        nCount := (JV2 as TJSONArray).Count;
        if (nCount > 0) then
          with MDTeeBoxStatus do
          try
            DisableControls;
            First;
            for I := 0 to Pred(nCount) do
            begin
              nTeeBoxNo := StrToInt((JV2 as TJSONArray).Items[I].P['teebox_no'].Value);
              if Locate('teebox_no', nTeeBoxNo, []) then
              begin
                Edit;
                FieldValues['heat_status'] := StrToIntDef(NVL((JV2 as TJSONArray).Items[I].P['use_status'].Value, ''), 0);
                Post;
              end;
              Next;
            end;
          finally
            EnableControls;
          end;
      end;
      Result := True;
    finally
      FreeAndNilJSONObject(JV2);
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JO1);
      TC.Disconnect;
      FreeAndNil(TC);
    end;
  except
    on e: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetAirConStatus.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.PrintAddonTicket(const AMemberInfo: string; var AErrMsg: string): Boolean;
var
  sErrMsg: string;
begin
  Result := False;
  AErrMsg := '';
  with TXGAddonTicketForm.Create(nil) do
  try
    try
      if (ShowModal = mrOK) then
      begin
        if UseParkingTicket then
          if not Global.ReceiptPrint.AddonTicketPrint(CAT_PARKING_TICKET, '주 차 권', AMemberInfo, ServiceHours, Global.CurrentTime, sErrMsg) then
            raise Exception.Create(sErrMsg);
        if UseSaunaTicket and
           (not Global.ReceiptPrint.AddonTicketPrint(CAT_SAUNA_TICKET, System.StrUtils.IfThen(Global.AddOnTicket.SaunaTicketKind = 0, '사우나', '샤워실') + '이용권',
              AMemberInfo, ServiceHours, Global.CurrentTime, sErrMsg)) then
          raise Exception.Create(sErrMsg);
        if UseFitnessTicket then
          if not Global.ReceiptPrint.AddonTicketPrint(CAT_FITNESS_TICKET, '피트니스이용권', AMemberInfo, ServiceHours, Global.CurrentTime, sErrMsg) then
            raise Exception.Create(sErrMsg);
        Result := True;
      end;
    except
      on E: Exception do
      begin
        AErrMsg := E.Message;
        UpdateLog(Global.LogFile, Format('PrintAddonTicket.Exception = %s', [E.Message]));
      end;
    end;
  finally
    Free;
  end;
end;
procedure TClientDM.OnReceiptCalcFields(DataSet: TDataSet);
var
  sValue: string;
  bIsCancel: Boolean;
begin
  with DataSet do
  begin
    sValue := FieldByName('receipt_no').AsString;
    bIsCancel := (FieldByName('cancel_yn').AsString = CRC_YES);
    FieldValues['calc_receipt_no'] := Copy(sValue, (Length(sValue) - 10) + 1, 10);
    FieldValues['calc_cancel_yn']:= IIF(bIsCancel, '취소', '승인');
    sValue := FieldByName('sale_root_div').AsString;
    if (sValue = CCT_POS) then
    begin
      if (SaleManager.StoreInfo.POSType = CPO_SALE_TEEBOX) then
        FieldValues['calc_sale_root_div'] := '프런트'
      else if (SaleManager.StoreInfo.POSType = CPO_SALE_SCREEN_ROOM) then
        FieldValues['calc_sale_root_div'] := '스크린'
      else if (SaleManager.StoreInfo.POSType = CPO_SALE_LESSON_ROOM) then
        FieldValues['calc_sale_root_div'] := '스튜디오'
      else
        FieldValues['calc_sale_root_div'] := '일반'
    end
    else if (sValue = CCT_KIOSK) then
      FieldValues['calc_sale_root_div'] := '키오스크'
    else if (sValue = CCT_MOBILE) then
      FieldValues['calc_sale_root_div'] := '모바일'
    else if (sValue = CCT_TELE_RESERVED) then
      FieldValues['calc_sale_root_div'] := '전화예약'
    else
      FieldValues['calc_sale_root_div'] := sValue;
    FieldValues['calc_more_dc_amt']   := (FieldByName('direct_dc_amt').AsInteger + FieldByName('xgolf_dc_amt').AsInteger);
    if bIsCancel then
    begin
      FieldValues['calc_coupon_dc_amt'] := 0;
      FieldValues['calc_sale_dc_amt']   := 0;
      FieldValues['calc_sale_amt']      := 0;
    end else
    begin
      FieldValues['calc_coupon_dc_amt'] := FieldByName('coupon_dc_amt').AsInteger;
      FieldValues['calc_sale_dc_amt']   := (FieldByName('direct_dc_amt').AsInteger + FieldByName('xgolf_dc_amt').AsInteger);
      FieldValues['calc_sale_amt']      := FieldByName('sale_amt').AsInteger;
    end;
  end;
end;
function TClientDM.PostTeeBoxReserve(const AMemberNo: string; var AErrMsg: string): Boolean;
begin
  Result := PostTeeBoxReserve(AMemberNo, '', '', '', AErrMsg);
end;
function TClientDM.PostTeeBoxReserve(const AMemberNo, AMemberName, AMemberHpNo, AReceiptNo: string; var AErrMsg: string): Boolean;
begin
  if Global.TeeBoxADInfo.Enabled then
    Result := PostTeeBoxReserveLocal(AMemberNo, AMemberName, AMemberHpNo, AReceiptNo, AErrMsg)
  else
    Result := PostTeeBoxReserveServer(AMemberNo, AErrMsg);
end;
function TClientDM.PostTeeBoxReserveLocal(const AMemberNo, AMemberName, AMemberHpNo, AReceiptNo: string; var AErrMsg: string): Boolean;
const
  CS_API = 'K408_TeeBoxReserve2';
var
  TC: TIdTCPClient;
  JO1, JO2, RO: TJSONObject;
  DA: TJSONArray;
  JV1: TJSONValue;
  SS: TStringStream;
  RBS: RawByteString;
  sResCode, sResMsg, sBuffer, sProdDiv, sProdName, sParentNo, sTeeBoxName, sReserveTime, sStartTime: string;
  sAccessBarcode, sAccessControlName: string;
  I, nCount, nTeeBoxNo, nPrepareMin, nAssignMin, nAssignBalls, nFacility: Integer;
begin
  Result := False;
  AErrMsg := '';
  RBS := '';
  RO := nil;
  JO2 := nil;
  JV1 := nil;
  DA := TJSONArray.Create;
  TC := TIdTCPClient.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    JO1 := TJSONObject.Create;
    JO1.AddPair(TJSONPair.Create('api', CS_API));
    JO1.AddPair(TJSONPair.Create('store_cd', SaleManager.StoreInfo.StoreCode));
    JO1.AddPair(TJSONPair.Create('member_no', AMemberNo));
    JO1.AddPair(TJSONPair.Create('member_nm', AMemberName));
    JO1.AddPair(TJSONPair.Create('hp_no', AMemberHpNo));
    JO1.AddPair(TJSONPair.Create('reserve_root_div', String(IIF(Global.TeeBoxTeleReserved, CCT_TELE_RESERVED, CCT_POS))));
    JO1.AddPair(TJSONPair.Create('affiliate_cd', AffiliateRec.PartnerCode)); //제휴사구분코드(웰빙클럽 등)
    JO1.AddPair(TJSONPair.Create('user_id', Global.ClientConfig.ClientId)); //SaleManager.UserInfo.UserId
    JO1.AddPair(TJSONPair.Create('receipt_no', AReceiptNo));
    JO1.AddPair(TJSONPair.Create('data', DA));
    MDTeeBoxSelected.DisableControls;
    MDTeeBoxIssued.DisableControls;
    TBEmergency.DisableControls;
    ClearMemData(MDTeeBoxIssued);
    try
      with MDTeeBoxSelected do
      try
        First;
        while not Eof do
        begin
          nTeeBoxNo := FieldByName('teebox_no').AsInteger;
          nPrepareMin := FieldByName('prepare_min').AsInteger;
          nAssignMin := FieldByName('assign_min').AsInteger;
          nAssignBalls := FieldByName('assign_balls').AsInteger;
          sProdDiv := IIF(Global.TeeBoxEmergencyMode, CTP_DAILY, FieldByName('product_div').AsString);
          sProdName := IIF(Global.TeeBoxEmergencyMode, '긴급배정', FieldByName('product_nm').AsString);
          RO := TJSONObject.Create;
          RO.AddPair(TJSONPair.Create('teebox_no', IntToStr(nTeeBoxNo)));
          RO.AddPair(TJSONPair.Create('purchase_cd', FieldByName('purchase_cd').AsString));
          RO.AddPair(TJSONPair.Create('product_cd', FieldByName('product_cd').AsString));
          RO.AddPair(TJSONPair.Create('product_nm', UTF8String(sProdName)));
          RO.AddPair(TJSONPair.Create('available_zone_cd', FieldByName('avail_zone_cd').AsString));
          RO.AddPair(TJSONPair.Create('reserve_div', sProdDiv));
          RO.AddPair(TJSONPair.Create('assign_balls', IntToStr(nAssignBalls)));
          RO.AddPair(TJSONPair.Create('assign_min', IntToStr(nAssignMin)));
          RO.AddPair(TJSONPair.Create('prepare_min', IntToStr(nPrepareMin)));
          DA.Add(RO);
          Next;
        end;
      finally
        EnableControls;
      end;
      sBuffer := JO1.ToString;
      SS := TStringStream.Create(sBuffer);
      SS.SaveToFile(Global.LogDir + CS_API + '.Request.json');
      TC.Host := Global.TeeBoxADInfo.Host;
      TC.Port := Global.TeeBoxADInfo.APIPort;
      TC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(JO1.ToString, IndyTextEncoding_UTF8);
      RBS := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      SS.Clear;
      SS.WriteString(JO2.ToString);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      sResCode := JO2.GetValue('result_cd').Value;
      sResMsg := JO2.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO2.FindValue('data') is TJSONNull) then
      begin
        JV1 := JO2.GetValue('data');
        nCount := (JV1 as TJSONArray).Count;
        if (nCount > 0) then
          for I := 0 to Pred(nCount) do
          begin
            sParentNo := (JV1 as TJSONArray).Items[I].P['reserve_no'].Value;
            sTeeBoxName := (JV1 as TJSONArray).Items[I].P['teebox_nm'].Value;
            nAssignMin := StrToIntDef((JV1 as TJSONArray).Items[I].P['remain_min'].Value, 0);
            sReserveTime := (JV1 as TJSONArray).Items[I].P['reserve_datetime'].Value;
            sStartTime := (JV1 as TJSONArray).Items[I].P['start_datetime'].Value;
            sProdName := (JV1 as TJSONArray).Items[I].P['product_nm'].Value;
            sAccessBarcode := (JV1 as TJSONArray).Items[I].P['access_barcode'].Value;
            sAccessControlName := (JV1 as TJSONArray).Items[I].P['access_control_nm'].Value;
            with MDTeeBoxIssued do
            begin
              Append;
              FieldValues['reserve_no']        := sParentNo;
              FieldValues['teebox_nm']         := sTeeBoxName;
              FieldValues['product_div']       := (JV1 as TJSONArray).Items[I].P['product_div'].Value;
              FieldValues['product_cd']        := (JV1 as TJSONArray).Items[I].P['product_cd'].Value;
              FieldValues['product_nm']        := sProdName;
              FieldValues['floor_nm']          := (JV1 as TJSONArray).Items[I].P['floor_nm'].Value;
              FieldValues['start_datetime']    := sStartTime;
              FieldValues['assign_time']       := nAssignMin;
              FieldValues['expire_day']        := (JV1 as TJSONArray).Items[I].P['expire_day'].Value;
              FieldValues['coupon_cnt']        := StrToIntDef((JV1 as TJSONArray).Items[I].P['coupon_cnt'].Value, 0);
              FieldValues['reserve_move_yn']   := False;
              FieldValues['reserve_noshow_yn'] := False;
              //시설이용권 출력용
              FieldValues['access_barcode']    := sAccessBarcode;
              FieldValues['access_control_nm'] := sAccessControlName;
              nFacility := Length(SaleManager.ReceiptInfo.FacilityList);
              SetLength(SaleManager.ReceiptInfo.FacilityList, nFacility + 1);
              with SaleManager.ReceiptInfo.FacilityList[nFacility] do
              begin
                //ProdName := sProdName;
                AccessBarcode := sAccessBarcode;
                AccessControlName := sAccessControlName;
              end;
              Post;
            end;
            if Global.TeeBoxEmergencyMode then
              with TBEmergency do
              begin
                Append;
                FieldValues['reserve_no'] := sParentNo;
                FieldValues['org_reserve_no'] := '';
                FieldValues['teebox_nm'] := sTeeBoxName;
                FieldValues['assign_min'] := nAssignMin;
                FieldValues['reserve_datetime'] := sReserveTime;
                FieldValues['start_datetime'] := sStartTime;
                FieldValues['member_nm'] := AMemberName;
                FieldValues['status'] := '타석예약';
                FieldValues['updated'] := Now;
                Post;
              end;
          end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      TBEmergency.EnableControls;
      MDTeeBoxIssued.EnableControls;
      MDTeeBoxSelected.EnableControls;
      FreeAndNilJSONObject(RO);
      FreeAndNilJSONObject(DA);
      FreeAndNilJSONObject(JV1);
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JO1);
      if Assigned(SS) then
        FreeAndNil(SS);
      TC.Disconnect;
      FreeAndNil(TC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('PostTeeBoxReserveLocal.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.PostTeeBoxReserveServer(const AMemberNo: string; var AErrMsg: string): Boolean;
const
  CS_API = 'K408_TeeBoxReserve2';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO1, RO1, JO2: TJSONObject;
  DA1: TJSONArray;
  JV1: TJSONValue;
  SS, RS: TStringStream;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sParentNo: string;
  I, nCount: Integer;
begin
  Result := False;
  AErrMsg := '';
  DA1 := TJSONArray.Create;
  JO1 := TJSONObject.Create;
  RS := TStringStream.Create;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    JO1.AddPair(TJSONPair.Create('store_cd', SaleManager.StoreInfo.StoreCode));
    JO1.AddPair(TJSONPair.Create('member_no', AMemberNo));
    JO1.AddPair(TJSONPair.Create('reserve_root_div', String(IIF(Global.TeeBoxTeleReserved, CCT_TELE_RESERVED, CCT_POS))));
    JO1.AddPair(TJSONPair.Create('user_id', Global.ClientConfig.ClientId)); //SaleManager.UserInfo.UserId
    JO1.AddPair(TJSONPair.Create('data', DA1));
    with MDTeeBoxSelected do
    try
      DisableControls;
      First;
      while not Eof do
      begin
        RO1 := TJSONObject.Create;
        RO1.AddPair(TJSONPair.Create('teebox_no', UTF8String(FieldByName('teebox_no').AsString)));
        RO1.AddPair(TJSONPair.Create('purchase_cd', UTF8String(FieldByName('purchase_cd').AsString)));
        RO1.AddPair(TJSONPair.Create('product_cd', UTF8String(FieldByName('product_cd').AsString)));
        RO1.AddPair(TJSONPair.Create('assign_balls', UTF8String(FieldByName('assign_balls').AsString)));
        RO1.AddPair(TJSONPair.Create('assign_min', UTF8String(FieldByName('assign_min').AsString)));
        RO1.AddPair(TJSONPair.Create('prepare_min', UTF8String(FieldByName('prepare_min').AsString)));
        DA1.Add(RO1);
        Next;
      end;
    finally
      EnableControls;
    end;
    RO1 := nil;
    JO2 := nil;
    JV1 := nil;
    SS := TStringStream.Create(JO1.ToString);
    ClearMemData(MDTeeBoxIssued);
    try
      HC.Request.ContentType := 'application/json';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'POST';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s', [Global.ClientConfig.Host, CS_API]);
      HC.Post(sUrl, SS, RS);
      RS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO2.GetValue('result_cd').Value;
      sResMsg := JO2.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO2.FindValue('result_data') is TJSONNull) then
      begin
        JV1 := JO2.Get('result_data').JsonValue;
        JV1 := (JV1 as TJSONObject).Get('data').JsonValue;
        nCount := (JV1 as TJSONArray).Count;
        if (nCount > 0) then
        begin
          with MDTeeBoxIssued do
          try
            DisableControls;
            for I := 0 to Pred(nCount) do
            begin
              Append;
              sParentNo := (JV1 as TJSONArray).Items[I].P['reserve_no'].Value;
              FieldValues['reserve_no']       := sParentNo;
              FieldValues['teebox_nm']        := (JV1 as TJSONArray).Items[I].P['teebox_nm'].Value;
              FieldValues['product_div']      := (JV1 as TJSONArray).Items[I].P['product_div'].Value;
              FieldValues['product_cd']       := (JV1 as TJSONArray).Items[I].P['product_cd'].Value;
              FieldValues['product_nm']       := (JV1 as TJSONArray).Items[I].P['product_nm'].Value;
              FieldValues['floor_nm']         := (JV1 as TJSONArray).Items[I].P['floor_nm'].Value;
              FieldValues['start_datetime']   := (JV1 as TJSONArray).Items[I].P['start_time'].Value;
              FieldValues['assign_time']      := StrToIntDef((JV1 as TJSONArray).Items[I].P['assign_time'].Value, 0);
              FieldValues['expire_day']       := (JV1 as TJSONArray).Items[I].P['expire_day'].Value;
              FieldValues['coupon_cnt']       := StrToIntDef((JV1 as TJSONArray).Items[I].P['coupon_cnt'].Value, 0);
              FieldValues['reserve_move_yn']  := False;
              FieldValues['reserve_noshow_yn']:= False;
              Post;
            end;
          finally
            EnableControls;
          end;
        end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(RO1);
      FreeAndNilJSONObject(DA1);
      FreeAndNilJSONObject(JV1);
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JO1);
      FreeAndNil(RS);
      if Assigned(SS) then
        FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('PostTeeBoxReserveServer.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetTeeBoxNoShowList(var AErrMsg: string): Boolean;
var
  BM: TBookmark;
begin
  Result := False;
  AErrMsg := '';
  try
    Screen.Cursor := crSQLWait;
    with SPTeeBoxNoShowList do
    try
      BM := GetBookmark;
      DisableControls;
      Close;
      StoredProcName := 'SP_GET_TEEBOX_RESERVED_CUTIN';
      Params.Clear;
      Params.CreateParam(ftString, 'p_store_cd', ptInput).AsString := SaleManager.StoreInfo.StoreCode;
      Prepared := True;
      Open;
      Result := True;
      if BookmarkValid(BM) then
        GotoBookmark(BM);
    finally
      EnableControls;
      FreeBookmark(BM);
      Screen.Cursor := crDefault;
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetTeeBoxNoShowList.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.PostTeeBoxNoShowReserve(const AReceiptNo, AAffiliateCode: string; var AErrMsg: string): Boolean;
const
  CS_API = 'A431_TeeboxCutIn';
var
  TC: TIdTCPClient;
  JO, RO: TJSONObject;
  SS: TStringStream;
  RBS: RawByteString;
  sResCode, sResMsg, sBuffer, sProdName, sAccessBarcode, sAccessControlName: string;
  nFacility: Integer;
begin
  Result := False;
  AErrMsg := '';
  RBS := '';
  TC := TIdTCPClient.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    RO := nil;
    JO := TJSONObject.Create;
    MDTeeBoxIssued.DisableControls;
    ClearMemData(MDTeeBoxIssued);
    with MDTeeBoxSelected do
    try
      DisableControls;
      First;
      JO.AddPair(TJSONPair.Create('api', CS_API));
      JO.AddPair(TJSONPair.Create('store_cd', SaleManager.StoreInfo.StoreCode));
      JO.AddPair(TJSONPair.Create('user_id', Global.ClientConfig.ClientId)); //SaleManager.UserInfo.UserId
      JO.AddPair(TJSONPair.Create('member_no', SaleManager.MemberInfo.MemberNo));
      JO.AddPair(TJSONPair.Create('member_nm', SaleManager.MemberInfo.MemberName));
      JO.AddPair(TJSONPair.Create('hp_no', SaleManager.MemberInfo.HpNo));
      JO.AddPair(TJSONPair.Create('reserve_root_div', String(IIF(Global.TeeBoxTeleReserved, CCT_TELE_RESERVED, CCT_POS))));
      JO.AddPair(TJSONPair.Create('xg_user_key', SaleManager.MemberInfo.XGolfMemberNo));
      JO.AddPair(TJSONPair.Create('receipt_no', AReceiptNo));
      JO.AddPair(TJSONPair.Create('affiliate_cd', AAffiliateCode)); //제휴사구분코드(웰빙클럽 등)
      JO.AddPair(TJSONPair.Create('purchase_cd', FieldByName('purchase_cd').AsString));
      JO.AddPair(TJSONPair.Create('product_cd', FieldByName('product_cd').AsString));
      JO.AddPair(TJSONPair.Create('product_nm', UTF8String(FieldByName('product_nm').AsString)));
      JO.AddPair(TJSONPair.Create('available_zone_cd', FieldByName('avail_zone_cd').AsString));
      JO.AddPair(TJSONPair.Create('reserve_div', FieldByName('product_div').AsString));
      JO.AddPair(TJSONPair.Create('teebox_no', IntToStr(Global.NoShowInfo.TeeBoxNo)));
      JO.AddPair(TJSONPair.Create('assign_min', IntToStr(Global.NoShowInfo.AssignMin)));
      JO.AddPair(TJSONPair.Create('assign_balls', IntToStr(Global.NoShowInfo.AssignBalls)));
      JO.AddPair(TJSONPair.Create('prepare_min', IntToStr(Global.NoShowInfo.PrepareMin)));
      JO.AddPair(TJSONPair.Create('reserve_date', Global.NoShowInfo.ReserveDateTime));
      JO.AddPair(TJSONPair.Create('reserve_no', Global.NoShowInfo.NoShowReserveNo));
      sBuffer := JO.ToString;
      SS := TStringStream.Create(sBuffer);
      SS.SaveToFile(Global.LogDir + CS_API + '.Request.json');
      TC.Host := Global.TeeBoxADInfo.Host;
      TC.Port := Global.TeeBoxADInfo.APIPort;
      TC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(JO.ToString, IndyTextEncoding_UTF8);
      RBS := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      RO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      SS.Clear;
      SS.WriteString(RO.ToString);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      sResCode := RO.GetValue('result_cd').Value;
      sResMsg := RO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      sProdName := RO.GetValue('product_nm').Value;
      sAccessBarcode := RO.GetValue('access_barcode').Value;
      sAccessControlName := RO.GetValue('access_control_nm').Value;
      with MDTeeBoxIssued do
      begin
        Append;
        FieldValues['reserve_no']        := RO.GetValue('reserve_no').Value;
        FieldValues['product_cd']        := RO.GetValue('product_cd').Value;
        FieldValues['product_nm']        := sProdName;
        FieldValues['product_div']       := RO.GetValue('product_div').Value;
        FieldValues['floor_nm']          := RO.GetValue('floor_nm').Value;
        FieldValues['teebox_nm']         := RO.GetValue('teebox_nm').Value;
        FieldValues['start_datetime']    := RO.GetValue('start_datetime').Value;
        FieldValues['assign_time']       := StrToIntDef(RO.GetValue('remain_min').Value, 0);
        FieldValues['expire_day']        := RO.GetValue('expire_day').Value;
        FieldValues['coupon_cnt']        := StrToIntDef(RO.GetValue('coupon_cnt').Value, 0);
        FieldValues['reserve_move_yn']   := False;
        FieldValues['reserve_noshow_yn'] := True;
        //시설이용권 출력용
        FieldValues['access_barcode']    := sAccessBarcode;
        FieldValues['access_control_nm'] := sAccessControlName;
        nFacility := Length(SaleManager.ReceiptInfo.FacilityList);
        SetLength(SaleManager.ReceiptInfo.FacilityList, nFacility + 1);
        with SaleManager.ReceiptInfo.FacilityList[nFacility] do
        begin
          //ProdName := sProdName;
          AccessBarcode := sAccessBarcode;
          AccessControlName := sAccessControlName;
        end;
        Post;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      MDTeeBoxIssued.EnableControls;
      EnableControls;
      FreeAndNilJSONObject(RO);
      FreeAndNilJSONObject(JO);
      if Assigned(SS) then
        FreeAndNil(SS);
      TC.Disconnect;
      FreeAndNil(TC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('PostTeeBoxNoShowReserve.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.ProcSetTeeBoxError(const ATeeBoxNo, AErrorCode: Integer; var AErrMsg: string): Boolean;
begin
  if Global.TeeBoxADInfo.Enabled then
    Result := ProcSetTeeBoxErrorLocal(ATeeBoxNo, AErrorCode, AErrMsg)
  else
    Result := SetTeeBoxErrorServer(ATeeBoxNo, AErrorCode, AErrMsg);
end;
function TClientDM.ProcSetTeeBoxErrorLocal(const ATeeBoxNo, AErrorCode: Integer; var AErrMsg: string): Boolean;
begin
  Result := False;
  try
    Screen.Cursor := crSQLWait;
    conTeeBox.StartTransaction;
    with TUniStoredProc.Create(nil) do
    try
      Connection := conTeeBox;
      StoredProcName := 'SP_SET_TEEBOX_ERROR';
      Params.Clear;
      Params.CreateParam(ftString, 'p_store_cd', ptInput).AsString := SaleManager.StoreInfo.StoreCode;
      Params.CreateParam(ftString, 'p_teebox_no', ptInput).Asinteger := ATeeBoxNo;
      Params.CreateParam(ftString, 'p_error_div', ptInput).AsString := IntToStr(AErrorCode);
      Prepared := True;
      ExecProc;
      conTeeBox.Commit;
      Result := True;
    finally
      Close;
      Free;
      Screen.Cursor := crDefault;
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('ProcSetTeeBoxErrorLocal.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.SendACS(const ASendDiv: Integer; const ATeeBoxName: string; var AErrMsg: string): Boolean;
const
  CS_API = 'K802_SendAcs';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS, RS: TStringStream;
  JO1, JO2: TJSONObject;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  RS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    JO2 := nil;
    JO1 := TJSONObject.Create;
    JO1.AddPair(TJSONPair.Create('store_cd',  SaleManager.StoreInfo.StoreCode));
    JO1.AddPair(TJSONPair.Create('send_div',  IntToStr(ASendDiv)));
    JO1.AddPair(TJSONPair.Create('teebox_nm', ATeeBoxName));
    SS := TStringStream.Create(JO1.ToString, TEncoding.UTF8);
    try
      HC.Request.ContentType := 'application/json';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'POST';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s', [Global.ClientConfig.Host, CS_API]);
      HC.Post(sUrl, SS, RS);
      RS.SaveToFile(Global.LogDir + CS_API + '.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO2.GetValue('result_cd').Value;
      sResMsg := JO2.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JO1);
      if Assigned(SS) then
        FreeAndNil(SS);
      if Assigned(RS) then
        FreeAndNil(RS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('SendACS.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.SendMemberQrCode(const AMemberNo: string; var AErrMsg: string): Boolean;
const
  CS_API = 'K309_MemberQr';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS, RS: TStringStream;
  JO: TJSONObject;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  JO := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := nil;
  RS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.ContentType := 'application/json';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'POST';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&member_no=%s',
        [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, AMemberNo]);
      HC.Post(sUrl, SS, RS);
      RS.SaveToFile(Global.LogDir + 'K309_MemberQr.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO);
      if Assigned(SS) then
        FreeAndNil(SS);
      if Assigned(RS) then
        FreeAndNil(RS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('SendMemberQrCode.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.PostTeeBoxReserveMove(const AReserveNo: string; const ATeeBoxNo, AAssignMin, APrepareMin, AAssignBalls: Integer; var AErrMsg: string): Boolean;
begin
  if Global.TeeBoxADInfo.Enabled then
    Result := PostTeeBoxReserveMoveLocal(AReserveNo, ATeeBoxNo, AAssignMin, APrepareMin, AAssignBalls, AErrMsg)
  else
    Result := PostTeeBoxReserveMoveServer(AReserveNo, ATeeBoxNo, AAssignMin, APrepareMin, AAssignBalls, AErrMsg);
end;
function TClientDM.PostTeeBoxReserveMoveLocal(const AReserveNo: string; const ATeeBoxNo, AAssignMin, APrepareMin, AAssignBalls: Integer; var AErrMsg: string): Boolean;
const
  CS_API = 'K412_MoveTeeBoxReserved';
var
  TC: TIdTCPClient;
  SS: TStringStream;
  JO1, JO2: TJSONObject;
  JV2: TJSONValue;
  RBS: RawByteString;
  sBuffer, sResCode, sResMsg, sParentNo, sTeeBoxName, sReserveTime, sStartTime, sMemberName: string;
  I, nCount, nAssignMin: Integer;
begin
  Result := False;
  AErrMsg := '';
  SS := nil;
  TC := TIdTCPClient.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    MDTeeBoxIssued.DisableControls;
    TBEmergency.DisableControls;
    ClearMemData(MDTeeBoxIssued);
    JO2 := nil;
    JV2 := nil;
    JO1 := TJSONObject.Create;
    JO1.AddPair(TJSONPair.Create('api', CS_API));
    JO1.AddPair(TJSONPair.Create('store_cd', SaleManager.StoreInfo.StoreCode));
    JO1.AddPair(TJSONPair.Create('reserve_no', AReserveNo));
    JO1.AddPair(TJSONPair.Create('user_id', Global.ClientConfig.ClientId)); //SaleManager.UserInfo.UserId
    JO1.AddPair(TJSONPair.Create('assign_balls', IntToStr(AAssignBalls)));
    JO1.AddPair(TJSONPair.Create('assign_min', IntToStr(AAssignMin)));
    JO1.AddPair(TJSONPair.Create('prepare_min', IntToStr(APrepareMin)));
    JO1.AddPair(TJSONPair.Create('teebox_no', IntToStr(ATeeBoxNo)));
    sBuffer := JO1.ToString;
    SS := TStringStream.Create(sBuffer);
    try
//      SS.SaveToFile(Global.LogDir + CS_API + '.Request.json');
      TC.Host := Global.TeeBoxADInfo.Host;
      TC.Port := Global.TeeBoxADInfo.APIPort;
      TC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(sBuffer, IndyTextEncoding_UTF8);
      RBS := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      SS.Clear;
      SS.WriteString(JO2.ToString);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      sResCode := JO2.GetValue('result_cd').Value;
      sResMsg := JO2.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO2.FindValue('data') is TJSONNull) then
      begin
        JV2 := JO2.GetValue('data');
        nCount := (JV2 as TJSONArray).Count;
        if (nCount > 0) then
          for I := 0 to Pred(nCount) do
          begin
            sParentNo := (JV2 as TJSONArray).Items[I].P['reserve_no'].Value;
            sTeeBoxName := (JV2 as TJSONArray).Items[I].P['teebox_nm'].Value;
            nAssignMin := StrToIntDef((JV2 as TJSONArray).Items[I].P['remain_min'].Value, 0);
            sStartTime := (JV2 as TJSONArray).Items[I].P['start_datetime'].Value;
            with MDTeeBoxIssued do
            begin
              Append;
              FieldValues['reserve_no']       := sParentNo;
              FieldValues['teebox_nm']        := sTeeBoxName;
              FieldValues['product_div']      := (JV2 as TJSONArray).Items[I].P['product_div'].Value;
              FieldValues['product_cd']       := (JV2 as TJSONArray).Items[I].P['product_cd'].Value;
              FieldValues['product_nm']       := (JV2 as TJSONArray).Items[I].P['product_nm'].Value;
              FieldValues['floor_nm']         := (JV2 as TJSONArray).Items[I].P['floor_nm'].Value;
              FieldValues['start_datetime']   := sStartTime;
              FieldValues['assign_time']      := nAssignMin;
              FieldValues['expire_day']       := (JV2 as TJSONArray).Items[I].P['expire_day'].Value;
              FieldValues['coupon_cnt']       := StrToIntDef((JV2 as TJSONArray).Items[I].P['coupon_cnt'].Value, 0);
              FieldValues['reserve_move_yn']  := True; //이동된 예약
              FieldValues['reserve_noshow_yn']:= False;
              Post;
            end;
            if Global.TeeBoxEmergencyMode then
              with TBEmergency do
              begin
                sReserveTime := sStartTime;
                sMemberName := '';
                if Locate('reserve_no', AReserveNo, []) then
                begin
                  sReserveTime := FieldByName('reserve_datetime').AsString;
                  sMemberName := FieldByName('member_nm').AsString;
                  Edit;
                  FieldValues['use_status'] := '취소(이동)';
                  FieldValues['updated'] := Now;
                  Post;
                end;
                Append;
                FieldValues['reserve_no'] := sParentNo;
                FieldValues['org_reserve_no'] := AReserveNo;
                FieldValues['teebox_nm'] := sTeeBoxName;
                FieldValues['assign_min'] := nAssignMin;
                FieldValues['reserve_datetime'] := sReserveTime;
                FieldValues['start_datetime'] := sStartTime;
                FieldValues['status'] := '이동배정';
                FieldValues['updated'] := Now;
                Post;
              end;
          end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      TBEmergency.EnableControls;
      MDTeeBoxIssued.EnableControls;
      FreeAndNilJSONObject(JV2);
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JO1);
      if Assigned(SS) then
        FreeAndNil(SS);
      TC.Disconnect;
      FreeAndNil(TC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('PostTeeBoxReserveMoveLocal.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.PostTeeBoxReserveMoveServer(const AReserveNo: string; const ATeeBoxNo, AAssignMin, APrepareMin, AAssignBalls: Integer; var AErrMsg: string): Boolean;
const
  CS_API = 'K412_MoveTeeBoxReserved';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS, RS: TStringStream;
  JO1, JO2: TJSONObject;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sParentNo: string;
begin
  Result := False;
  AErrMsg := '';
  JO1 := nil;
  JO2 := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  RS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    ClearMemData(MDTeeBoxIssued);
    try
      SS := TStringStream.Create('', TEncoding.UTF8);
      HC.Request.ContentType := 'application/json';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'PUT';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&user_id=%s&reserve_no=%s&teebox_no=%d&assign_min=%d&prepare_min=%d&assign_balls=%d',
        [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, Global.ClientConfig.ClientId, {SaleManager.UserInfo.UserId,}
          AReserveNo, ATeeBoxNo, AAssignMin, APrepareMin, AAssignBalls]);
      HC.Put(sUrl, SS, RS);
      RS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO1 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO1.GetValue('result_cd').Value;
      sResMsg := JO1.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO1.FindValue('result_data') is TJSONNull) then
      begin
        JO2 := JO1.GetValue('result_data') as TJSONObject;
        sParentNo := JO2.GetValue('reserve_no').Value;
        with MDTeeBoxIssued do
        try
          DisableControls;
          Append;
          FieldValues['reserve_no']       := sParentNo;
          FieldValues['teebox_nm']        := JO2.GetValue('teebox_nm').Value;
          FieldValues['product_div']      := JO2.GetValue('product_div').Value;
          FieldValues['product_cd']       := JO2.GetValue('product_cd').Value;
          FieldValues['product_nm']       := JO2.GetValue('product_nm').Value;
          FieldValues['floor_nm']         := JO2.GetValue('floor_nm').Value;
          FieldValues['start_datetime']   := JO2.GetValue('start_datetime').Value;
          FieldValues['assign_time']      := StrToIntDef(JO2.GetValue('remain_min').Value, 0);
          FieldValues['expire_day']       := JO2.GetValue('expire_day').Value;
          FieldValues['coupon_cnt']       := StrToIntDef(JO2.GetValue('coupon_cnt').Value, 0);
          FieldValues['reserve_move_yn']  := True; //이동된 예약
          FieldValues['reserve_noshow_yn']:= False;
          Post;
        finally
          EnableControls;
        end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JO1);
      FreeAndNil(RS);
      if Assigned(SS) then
        FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('PostTeeBoxReserveMoveServer.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.PostTeeBoxReserveChange(const AReserveNo: string; const AAssignMin, APrepareMin, AAssignBalls: Integer; const AMemo: string; var AErrMsg: string): Boolean;
begin
  if Global.TeeBoxADInfo.Enabled then
    Result := PostTeeBoxReserveChangeLocal(AReserveNo, AAssignMin, APrepareMin, AAssignBalls, AMemo, AErrMsg)
  else
    Result := PostTeeBoxReserveChangeServer(AReserveNo, AAssignMin, APrepareMin, AAssignBalls, AMemo, AErrMsg);
end;
function TClientDM.PostTeeBoxReserveChangeLocal(const AReserveNo: string; const AAssignMin, APrepareMin, AAssignBalls: Integer; const AMemo: string; var AErrMsg: string): Boolean;
const
  CS_API = 'K411_TeeBoxReserved';
var
  TC: TIdTCPClient;
  SS: TStringStream;
  JO1, JO2: TJSONObject;
  JV2: TJSONValue;
  RBS: RawByteString;
  sBuffer, sResCode, sResMsg, sParentNo, sStartTime: string;
  I, nCount, nAssignMin: Integer;
begin
  Result := False;
  AErrMsg := '';
  TC := TIdTCPClient.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    MDTeeBoxIssued.DisableControls;
    TBEmergency.DisableControls;
    ClearMemdata(MDTeeBoxIssued);
    JO2 := nil;
    JV2 := nil;
    JO1 := TJSONObject.Create;
    JO1.AddPair(TJSONPair.Create('api', CS_API));
    JO1.AddPair(TJSONPair.Create('store_cd', SaleManager.StoreInfo.StoreCode));
    JO1.AddPair(TJSONPair.Create('reserve_no', AReserveNo));
    JO1.AddPair(TJSONPair.Create('user_id', Global.ClientConfig.ClientId)); //SaleManager.UserInfo.UserId
    JO1.AddPair(TJSONPair.Create('assign_balls', IntToStr(AAssignBalls)));
    JO1.AddPair(TJSONPair.Create('assign_min', IntToStr(AAssignMin)));
    JO1.AddPair(TJSONPair.Create('prepare_min', IntToStr(APrepareMin)));
    JO1.AddPair(TJSONPair.Create('memo', TIdURI.ParamsEncode(AMemo)));
    sBuffer := JO1.ToString;
    SS := TStringStream.Create(sBuffer);
    try
      SS.SaveToFile(Global.LogDir + CS_API + '.Request.json');
      TC.Host := Global.TeeBoxADInfo.Host;
      TC.Port := Global.TeeBoxADInfo.APIPort;
      TC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(sBuffer, IndyTextEncoding_UTF8);
      RBS := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      SS.Clear;
      SS.WriteString(JO2.ToString);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      sResCode := JO2.GetValue('result_cd').Value;
      sResMsg := JO2.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO2.FindValue('data') is TJSONNull) then
      begin
        JV2 := JO2.GetValue('data');
        nCount := (JV2 as TJSONArray).Count;
        if (nCount > 0) then
          for I := 0 to Pred(nCount) do
          begin
            nAssignMin := StrToIntDef((JV2 as TJSONArray).Items[I].P['remain_min'].Value, 0);
            sStartTime := (JV2 as TJSONArray).Items[I].P['start_datetime'].Value;
            with MDTeeBoxIssued do
            begin
              Append;
              sParentNo := (JV2 as TJSONArray).Items[I].P['reserve_no'].Value;
              FieldValues['reserve_no']       := sParentNo;
              FieldValues['teebox_nm']        := (JV2 as TJSONArray).Items[I].P['teebox_nm'].Value;
              FieldValues['product_div']      := (JV2 as TJSONArray).Items[I].P['product_div'].Value;
              FieldValues['product_cd']       := (JV2 as TJSONArray).Items[I].P['product_cd'].Value;
              FieldValues['product_nm']       := (JV2 as TJSONArray).Items[I].P['product_nm'].Value;
              FieldValues['floor_nm']         := (JV2 as TJSONArray).Items[I].P['floor_nm'].Value;
              FieldValues['assign_time']      := nAssignMin;
              FieldValues['start_datetime']   := sStartTime;
              FieldValues['expire_day']       := (JV2 as TJSONArray).Items[I].P['expire_day'].Value;
              FieldValues['coupon_cnt']       := StrToIntDef((JV2 as TJSONArray).Items[I].P['coupon_cnt'].Value, 0);
              FieldValues['reserve_move_yn']  := False; //확인 불가, API 수정 필요
              FieldValues['reserve_noshow_yn']:= False;
              Post;
            end;
            if Global.TeeBoxEmergencyMode then
              with TBEmergency do
                if Locate('reserve_no', AReserveNo, []) then
                begin
                  Edit;
                  FieldValues['assign_min'] := nAssignMin;
                  FieldValues['start_datetime'] := sStartTime;
                  FieldValues['status'] := '예약변경';
                  FieldValues['updated'] := Now;
                  Post;
                end;
          end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      TBEmergency.EnableControls;
      MDTeeBoxIssued.EnableControls;
      FreeAndNilJSONObject(JV2);
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JO1);
      if Assigned(SS) then
        FreeAndNil(SS);
      TC.Disconnect;
      FreeAndNil(TC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('PostTeeBoxReserveChangeLocal.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.PostTeeBoxReserveChangeServer(const AReserveNo: string; const AAssignMin, APrepareMin, AAssignBalls: Integer; const AMemo: string; var AErrMsg: string): Boolean;
const
  CS_API = 'K411_TeeBoxReserved';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  RS: TStringStream;
  JO1, JO2: TJSONObject;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sParentNo: string;
begin
  Result := False;
  AErrMsg := '';
  JO1 := nil;
  JO2 := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  RS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    ClearMemdata(MDTeeBoxIssued);
    try
      HC.Request.ContentType := 'application/json';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'PUT';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&user_id=%s&reserve_no=%s&assign_min=%d&prepare_min=%d&assign_balls=%d&memo=%s',
        [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, Global.ClientConfig.ClientId, {SaleManager.UserInfo.UserId,}
          AReserveNo, AAssignMin, APrepareMin, AAssignBalls, TIdURI.ParamsEncode(AMemo)]);
      HC.Put(sUrl, RS, RS);
      RS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO1 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO1.GetValue('result_cd').Value;
      sResMsg := JO1.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO1.FindValue('result_data') is TJSONNull) then
      begin
        JO2 := JO1.GetValue('result_data') as TJSONObject;
        sParentNo := JO2.GetValue('reserve_no').Value;
        with MDTeeBoxIssued do
        try
          DisableControls;
          Append;
          FieldValues['reserve_no']       := sParentNo;
          FieldValues['teebox_nm']        := JO2.GetValue('teebox_nm').Value;
          FieldValues['product_div']      := JO2.GetValue('product_div').Value;
          FieldValues['product_cd']       := JO2.GetValue('product_cd').Value;
          FieldValues['product_nm']       := JO2.GetValue('product_nm').Value;
          FieldValues['floor_nm']         := JO2.GetValue('floor_nm').Value;
          FieldValues['start_datetime']   := JO2.GetValue('start_datetime').Value;
          FieldValues['assign_time']      := StrToIntDef(JO2.GetValue('remain_min').Value, 0);
          FieldValues['expire_day']       := JO2.GetValue('expire_day').Value;
          FieldValues['coupon_cnt']       := StrToIntDef(JO2.GetValue('coupon_cnt').Value, 0);
          FieldValues['reserve_move_yn']  := False; //확인 불가, API 수정 필요
          FieldValues['reserve_noshow_yn']:= False;
          Post;
        finally
          EnableControls;
        end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JO1);
      FreeAndNil(RS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('PostTeeBoxReserveChangeServer.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.PostTeeBoxReserveCheckinServer(const AMemberNo: string; var ACheckinList: TCheckinList; var AErrCode, AErrMsg: string): Boolean;
const
  CS_API = 'K712_TeeboxCheckin';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS, RS: TStringStream;
  JO: TJSONObject;
  JV: TJSONValue;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sReserveNo: string;
  I, nCount, nTeeBoxNo: Integer;
begin
  Result := False;
  AErrCode := '0000';
  AErrMsg := '';
  ACheckinList.Clear;
  JO := nil;
  JV := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  RS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.ContentType := 'application/x-www-form-urlencoded';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'POST';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&member_no=%s&user_id=%s',
        [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, AMemberNo, Global.ClientConfig.ClientId]); //SaleManager.UserInfo.UserId
      HC.Post(sUrl, SS, RS);
      RS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      AErrCode := sResCode;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO.FindValue('result_data') is TJSONNull) then
      begin
        JV := JO.Get('result_data').JsonValue;
        nCount := (JV as TJSONArray).Count;
        if (nCount > 0) then
          for I := 0 to Pred(nCount) do
          begin
            sReserveNo := (JV as TJSONArray).Items[I].P['reserve_no'].Value;
            nTeeBoxNo := StrToIntDef((JV as TJSONArray).Items[I].P['teebox_no'].Value, 0);
            ACheckinList.AddItem(sReserveNo, nTeeBoxNo);
          end;
      end;
      if (ACheckinList.Count = 0) then
        raise Exception.Create('체크인 할 모바일 예약 내역이 없습니다.');
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JV);
      FreeAndNilJSONObject(JO);
      FreeAndNil(RS);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('PostTeeBoxReserveCheckinServer.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.PostTeeBoxReserveCheckinLocal(const ACheckinList: TCheckinList; var AErrMsg: string): Boolean;
const
  CS_API = 'A432_TeeboxCheckIn';
var
  TC: TIdTCPClient;
  SS: TStringStream;
  JO1, JO2, RO: TJSONObject;
  JA: TJSONArray;
  RBS: RawByteString;
  sBuffer, sResCode, sResMsg: string;
  I: Integer;
begin
  Result := False;
  AErrMsg := '';
  try
    Screen.Cursor := crSQLWait;
    TC := TIdTCPClient.Create(nil);
    RO := nil;
    JO2 := nil;
    JA := TJSONArray.Create;
    JO1 := TJSONObject.Create;
    JO1.AddPair(TJSONPair.Create('api', CS_API));
    JO1.AddPair(TJSONPair.Create('store_cd', SaleManager.StoreInfo.StoreCode));
    JO1.AddPair(TJSONPair.Create('user_id', Global.ClientConfig.ClientId)); //SaleManager.UserInfo.UserId
    JO1.AddPair(TJSONPair.Create('data', JA));
    for I := 0 to Pred(ACheckinList.Count) do
    begin
      JO2 := TJSONObject.Create;
      JO2.AddPair(TJSONPair.Create('reserve_no', PCheckinItem(ACheckinList[I])^.ReserveNo));
      JO2.AddPair(TJSONPair.Create('teebox_no', IntToStr(PCheckinItem(ACheckinList[I])^.TeeBoxNo)));
      JA.Add(JO2);
    end;
    sBuffer := JO1.ToString;
    SS := TStringStream.Create(sBuffer);
    try
      SS.SaveToFile(Global.LogDir + CS_API + '.Request.json');
      TC.Host := Global.TeeBoxADInfo.Host;
      TC.Port := Global.TeeBoxADInfo.APIPort;
      TC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(sBuffer, IndyTextEncoding_UTF8);
      RBS := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      RO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      SS.Clear;
      SS.WriteString(RO.ToString);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      sResCode := RO.GetValue('result_cd').Value;
      sResMsg := RO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(RO);
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JA);
      FreeAndNilJSONObject(JO1);
      if Assigned(SS) then
        FreeAndNil(SS);
      TC.Disconnect;
      FreeAndNil(TC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('PostTeeBoxReserveCheckinLocal.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.CancelTeeBoxReserve(const AReserveNo, AReceiptNo: string; var AErrMsg: string): Boolean;
begin
  if Global.TeeBoxADInfo.Enabled then
    Result := CancelTeeBoxReserveLocal(AReserveNo, AReceiptNo, AErrMsg)
  else
    Result := CancelTeeBoxReserveServer(AReserveNo, AErrMsg)
end;
function TClientDM.CancelTeeBoxReserveLocal(const AReserveNo, AReceiptNo: string; var AErrMsg: string): Boolean;
const
  CS_API = 'K410_TeeBoxReserved';
var
  TC: TIdTCPClient;
  JO1, JO2: TJSONObject;
  SS: TStringStream;
  RBS: RawByteString;
  sBuffer, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  SS := nil;
  TC := TIdTCPClient.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    MDTeeBoxReserved2.DisableControls;
    TBEmergency.DisableControls;
    JO2 := nil;
    JO1 := TJSONObject.Create;
    JO1.AddPair(TJSONPair.Create('api', CS_API));
    JO1.AddPair(TJSONPair.Create('store_cd', SaleManager.StoreInfo.StoreCode));
    JO1.AddPair(TJSONPair.Create('reserve_no', AReserveNo));
    JO1.AddPair(TJSONPair.Create('user_id', Global.ClientConfig.ClientId)); //SaleManager.UserInfo.UserId
    JO1.AddPair(TJSONPair.Create('receipt_no', AReceiptNo));
    sBuffer := JO1.ToString;
    SS := TStringStream.Create(sBuffer);
    try
      SS.SaveToFile(Global.LogDir + CS_API + '.Request.json');
      TC.Host := Global.TeeBoxADInfo.Host;
      TC.Port := Global.TeeBoxADInfo.APIPort;
      TC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(sBuffer, IndyTextEncoding_UTF8);
      RBS := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      SS.Clear;
      SS.WriteString(JO2.ToString);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      sResCode := JO2.GetValue('result_cd').Value;
      sResMsg := JO2.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      with MDTeeBoxReserved2 do
        if Locate('reserve_no', AReserveNo, []) then
          Delete;
      if Global.TeeBoxEmergencyMode then
        with TBEmergency do
          if Locate('reserve_no', AReserveNo, []) then
          begin
            Edit;
            FieldValues['status'] := '취소';
            FieldValues['updated'] := Now;
            Post;
          end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      TBEmergency.EnableControls;
      MDTeeBoxReserved2.EnableControls;
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JO1);
      if Assigned(SS) then
        FreeAndNil(SS);
      TC.Disconnect;
      FreeAndNil(TC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('CancelTeeBoxReserve.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.CancelTeeBoxReserveServer(const AReserveNo: string; var AErrMsg: string): Boolean;
const
  CS_API = 'K410_TeeBoxReserved';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO: TJSONObject;
  SS: TStringStream;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  JO := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.ContentType := 'application/json';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'DELETE';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&reserve_no=%s&user_id=%s',
        [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, AReserveNo, Global.ClientConfig.ClientId]); //SaleManager.UserInfo.UserId
      HC.Delete(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      with MDTeeBoxReserved2 do
        if Locate('reserve_no', AReserveNo, []) then
          Delete;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('CancelTeeBoxReserve.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.CloseTeeBoxReserve(const AReserveNo: string; const ATeeBoxNo: Integer; var AErrMsg: string): Boolean;
begin
  if Global.TeeBoxADInfo.Enabled then
    Result := CloseTeeBoxReserveLocal(AReserveNo, AErrMsg)
  else
    Result := CloseTeeBoxReserveServer(AReserveNo, ATeeBoxNo, AErrMsg);
end;
function TClientDM.CloseTeeBoxReserveLocal(const AReserveNo: string; var AErrMsg: string): Boolean;
const
  CS_API = 'K416_TeeBoxClose';
var
  TC: TIdTCPClient;
  JO1, JO2: TJSONObject;
  RBS: RawByteString;
  sBuffer, sResCode, sResMsg: string;
  SS: TStringStream;
begin
  Result := False;
  AErrMsg := '';
  SS := nil;
  TC := TIdTCPClient.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    MDTeeBoxReserved2.DisableControls;
    TBEmergency.DisableControls;
    JO2 := nil;
    JO1 := TJSONObject.Create;
    JO1.AddPair(TJSONPair.Create('api', CS_API));
    JO1.AddPair(TJSONPair.Create('store_cd', SaleManager.StoreInfo.StoreCode));
    JO1.AddPair(TJSONPair.Create('reserve_no', AReserveNo));
    JO1.AddPair(TJSONPair.Create('user_id', Global.ClientConfig.ClientId)); //SaleManager.UserInfo.UserId
    sBuffer := JO1.ToString;
    SS := TStringStream.Create(sBuffer);
    try
      SS.SaveToFile(Global.LogDir + CS_API + '.Request.json');
      TC.Host := Global.TeeBoxADInfo.Host;
      TC.Port := Global.TeeBoxADInfo.APIPort;
      TC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(sBuffer, IndyTextEncoding_UTF8);
      RBS := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      SS.Clear;
      SS.WriteString(JO2.ToString);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      sResCode := JO2.GetValue('result_cd').Value;
      sResMsg := JO2.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      with MDTeeBoxReserved2 do
        if Locate('reserve_no', AReserveNo, []) then
          Delete;
      if Global.TeeBoxEmergencyMode then
        with TBEmergency do
          if Locate('reserve_no', AReserveNo, []) then
          begin
            Edit;
            FieldValues['status'] := '타석정리';
            FieldValues['updated'] := Now;
            Post;
          end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      TBEmergency.EnableControls;
      MDTeeBoxReserved2.EnableControls;
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JO1);
      if Assigned(SS) then
        FreeAndNil(SS);
      TC.Disconnect;
      FreeAndNil(TC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('CloseTeeBoxReserve.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.CloseTeeBoxReserveServer(const AReserveNo: string; const ATeeBoxNo: Integer; var AErrMsg: string): Boolean;
const
  CS_API = 'K711_TeeboxClose';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO: TJSONObject;
  SS, RS: TStringStream;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  JO := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  RS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.ContentType := 'application/json';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'POST';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&reserve_no=%s&teebox_no=%d&user_id=%s&memo=%s',
        [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode,
          AReserveNo, ATeeBoxNo, Global.ClientConfig.ClientId, '']); //SaleManager.UserInfo.UserId
      HC.Post(sUrl, SS, RS);
      RS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      with MDTeeBoxReserved2 do
        if Locate('reserve_no', AReserveNo, []) then
          Delete;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
      FreeAndNil(RS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('CancelTeeBoxReserve.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetTeeBoxTicketInfo(const AReserveNo: string; const ATeeBoxMoved: Boolean; const APrepareMin: Integer; var AErrMsg: string): Boolean;
begin
  if Global.TeeBoxADInfo.Enabled then
    Result := GetTeeBoxTicketInfoLocal(AReserveNo, ATeeBoxMoved, APrepareMin, AErrMsg)
  else
    Result := GetTeeBoxTicketInfoServer(AReserveNo, ATeeBoxMoved, AErrMsg);
end;
function TClientDM.GetTeeBoxTicketInfoLocal(const AReserveNo: string; const ATeeBoxMoved: Boolean; const APrepareMin: Integer; var AErrMsg: string): Boolean;
const
  CS_API = 'K708_TeeboxSelect';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO1, JO2: TJSONObject;
  RS: TStringStream;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sReserveTime, sStartTime: string;
  dStartTime: TDateTime;
begin
  Result := False;
  AErrMsg := '';
  JO1 := nil;
  JO2 := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  RS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    ClearMemData(MDTeeBoxIssued2);
    MDTeeBoxIssued2.DisableControls;
    try
//      HC.Request.ContentType := 'application/json';
//      HC.Request.ContentType := 'none';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&reserve_no=%s',
        [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, AReserveNo]);
      HC.Get(sUrl, RS);
      RS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO1 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO1.GetValue('result_cd').Value;
      sResMsg  := JO1.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO1.FindValue('result_data') is TJSONNull) then
      begin
        JO2 := JO1.GetValue('result_data') as TJSONObject;
        sStartTime := JO2.GetValue('start_datetime').Value; //yyyy-mm-dd hh:nn:ss
        sReserveTime := JO2.GetValue('reserve_datetime').Value; //yyyy-mm-dd hh:nn:ss
        if sStartTime.IsEmpty then
          dStartTime := IncMinute(StrToDateTime(sReserveTime, Global.FS), APrepareMin)
        else
          dStartTime := StrToDateTime(sStartTime, Global.FS);
        with MDTeeBoxIssued2 do
        begin
          Append;
          FieldValues['reserve_no']       := AReserveNo;
          FieldValues['teebox_nm']        := JO2.GetValue('teebox_nm').Value;
          FieldValues['product_div']      := JO2.GetValue('product_div').Value;
          FieldValues['product_cd']       := JO2.GetValue('product_cd').Value;
          FieldValues['product_nm']       := JO2.GetValue('product_nm').Value;
          FieldValues['floor_nm']         := JO2.GetValue('floor_nm').Value;
          FieldValues['start_datetime']   := FormatDateTime('yyyy-mm-dd hh:nn:ss', dStartTime);
          FieldValues['assign_time']      := StrToIntDef(JO2.GetValue('remain_min').Value, 0);
          FieldValues['expire_day']       := JO2.GetValue('expire_day').Value;
          FieldValues['coupon_cnt']       := StrToIntDef(JO2.GetValue('coupon_cnt').Value, 0);
          FieldValues['reserve_move_yn']  := ATeeBoxMoved;
          FieldValues['reserve_noshow_yn']:= False;
          Post;
        end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      MDTeeBoxIssued2.EnableControls;
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JO1);
      FreeAndNil(RS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetTeeBoxTicketInfoLocal.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetTeeBoxTicketInfoServer(const AReserveNo: string; const ATeeBoxMoved: Boolean; var AErrMsg: string): Boolean;
const
  CS_API = 'K409_TeeBoxReserved';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO1, JO2: TJSONObject;
  RS: TStringStream;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  JO1 := nil;
  JO2 := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  RS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    ClearMemData(MDTeeBoxIssued2);
    MDTeeBoxIssued2.DisableControls;
    try
//      HC.Request.ContentType := 'application/json';
//      HC.Request.ContentType := 'none';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&reserve_no=%s',
        [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, AReserveNo]);
      HC.Get(sUrl, RS);
      RS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO1 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO1.GetValue('result_cd').Value;
      sResMsg  := JO1.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO1.FindValue('result_data') is TJSONNull) then
      begin
        JO2 := JO1.GetValue('result_data') as TJSONObject;
        with MDTeeBoxIssued2 do
        begin
          Append;
          FieldValues['reserve_no']       := AReserveNo;
          FieldValues['teebox_nm']        := JO2.GetValue('teebox_nm').Value;
          FieldValues['product_div']      := JO2.GetValue('product_div').Value;
          FieldValues['product_cd']       := JO2.GetValue('product_cd').Value;
          FieldValues['product_nm']       := JO2.GetValue('product_nm').Value;
          FieldValues['floor_nm']         := JO2.GetValue('floor_nm').Value;
          FieldValues['start_datetime']   := JO2.GetValue('start_datetime').Value;
          FieldValues['assign_time']      := StrToIntDef(JO2.GetValue('remain_min').Value, 0);
          FieldValues['expire_day']       := JO2.GetValue('expire_day').Value;
          FieldValues['coupon_cnt']       := StrToIntDef(JO2.GetValue('coupon_cnt').Value, 0);
          FieldValues['reserve_move_yn']  := ATeeBoxMoved;
          FieldValues['reserve_noshow_yn']:= False;
          Post;
        end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      MDTeeBoxIssued2.EnableControls;
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JO1);
      FreeAndNil(RS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetTeeBoxTicketInfoServer.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.SetTeeBoxError(const ATeeBoxNo, AErrorCode: Integer; var AErrMsg: string): Boolean;
begin
  if Global.TeeBoxADInfo.Enabled then
    Result := SetTeeBoxErrorLocal(ATeeBoxNo, AErrorCode, AErrMsg)
  else
    Result := SetTeeBoxErrorServer(ATeeBoxNo, AErrorCode, AErrMsg);
end;
function TClientDM.SetTeeBoxErrorLocal(const ATeeBoxNo, AErrorCode: Integer; var AErrMsg: string): Boolean;
var
  TC: TIdTCPClient;
  JO1, JO2: TJSONObject;
  SS: TStringStream;
  RBS: RawByteString;
  sAPIName, sJob, sBuffer, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  sJob := '';
  case AErrorCode of
    CTS_TEEBOX_READY:     //타석기 정상
      begin
        sAPIName := 'K404_TeeBoxError';
        sJob := 'Cancel';
      end;
    CTS_TEEBOX_STOP_ALL,  //볼 회수(전 타석 사용 중지)
    CTS_TEEBOX_STOP,      //점검중 등록(개별 타석)
    CTS_TEEBOX_ERROR:     //타석기 기기 장애(개별 타석)
      begin
        sAPIName := 'K403_TeeBoxError';
      end;
    else
      Exit;
  end;
  TC := TIdTCPClient.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    JO2 := nil;
    JO1 := TJSONObject.Create;
    JO1.AddPair(TJSONPair.Create('api', sAPIName));
    JO1.AddPair(TJSONPair.Create('store_cd', SaleManager.StoreInfo.StoreCode));
    JO1.AddPair(TJSONPair.Create('user_id', Global.ClientConfig.ClientId)); //SaleManager.UserInfo.UserId
    JO1.AddPair(TJSONPair.Create('teebox_no', IntToStr(ATeeBoxNo)));
    JO1.AddPair(TJSONPair.Create('error_div', IntToStr(AErrorCode)));
    sBuffer := JO1.ToString;
    SS := TStringStream.Create(sBuffer);
    try
      SS.SaveToFile(Global.LogDir + sAPIName + '.Request.json');
      TC.Host := Global.TeeBoxADInfo.Host;
      TC.Port := Global.TeeBoxADInfo.APIPort;
      TC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(sBuffer, IndyTextEncoding_UTF8);
      RBS := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      JO2 := TJSONObject.ParseJSONValue(string(RBS)) as TJSONObject;
      SS.Clear;
      SS.WriteString(JO2.ToString);
      SS.SaveToFile(Global.LogDir + sAPIName + '.Response.json');
      sResCode := JO2.GetValue('result_cd').Value;
      sResMsg := JO2.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JO1);
      if Assigned(SS) then
        FreeAndNil(SS);
      TC.Disconnect;
      FreeAndNil(TC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('SetTeeBoxError%s.Exception = %s', [sJob, E.Message]));
    end;
  end;
end;
function TClientDM.SetTeeBoxErrorServer(const ATeeBoxNo, AErrorCode: Integer; var AErrMsg: string): Boolean;
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO: TJSONObject;
  SS, RS: TStringStream;
  RBS: RawByteString;
  sAPIName, sJob, sUrl, sResCode, sResMsg: string;
  bIsError: Boolean;
begin
  Result := False;
  AErrMsg := '';
  sJob := '';
  bIsError := False;
  case AErrorCode of
    CTS_TEEBOX_READY:     //타석기 정상
      begin
        sAPIName := 'K404_TeeBoxError';
        sJob := 'Cancel';
      end;
    CTS_TEEBOX_STOP_ALL,  //볼 회수(전 타석 사용 중지)
    CTS_TEEBOX_STOP,      //점검중 등록(개별 타석)
    CTS_TEEBOX_ERROR:     //타석기 기기 장애(개별 타석)
      begin
        sAPIName := 'K403_TeeBoxError';
        bIsError := True;
      end;
    else
      Exit;
  end;
  JO := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  RS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.ContentType := 'application/json';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      if bIsError then
      begin
        sUrl := Format('%s/wix/api/%s?store_cd=%s&teebox_no=%d&error_div=%d&user_id=%s', [
          Global.ClientConfig.Host, sAPIName, SaleManager.StoreInfo.StoreCode, ATeeBoxNo, AErrorCode, Global.ClientConfig.ClientId]); //SaleManager.UserInfo.UserId
        HC.Request.Method := 'POST';
        HC.Post(sUrl, SS, RS);
        RS.SaveToFile(Global.LogDir + sAPIName + '.Response.json');
      end
      else
      begin
        sUrl := Format('%s/wix/api/%s?store_cd=%s&teebox_no=%d&user_id=%s', [
          Global.ClientConfig.Host, sAPIName, SaleManager.StoreInfo.StoreCode, ATeeBoxNo, Global.ClientConfig.ClientId]); //SaleManager.UserInfo.UserId
        HC.Request.Method := 'DELETE';
        HC.Delete(sUrl, RS);
        RS.SaveToFile(Global.LogDir + sAPIName + '.Response.json');
      end;
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('SetTeeBoxError%s.Exception = %s', [sJob, E.Message]));
    end;
  end;
end;
function TClientDM.GetTeeBoxEmergencyMode(var AErrMsg: string): Boolean;
const
  CS_API = 'A421_GetTeeBoxEmergency';
var
  PM: TPluginMessage;
  TC: TIdTCPClient;
  JO, RO: TJSONObject;
  SS: TStringStream;
  RBS: RawByteString;
  sStoreCode, sBuffer, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  TC := TIdTCPClient.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    sStoreCode := SaleManager.StoreInfo.StoreCode;
    if sStoreCode.IsEmpty then
      sStoreCode := Global.ClientConfig.ClientId.Substring(0, 5);
    RO := nil;
    JO := TJSONObject.Create;
    JO.AddPair(TJSONPair.Create('store_cd', sStoreCode));
    JO.AddPair(TJSONPair.Create('api', CS_API));
    JO.AddPair(TJSONPair.Create('user_id', Global.ClientConfig.ClientId)); //SaleManager.UserInfo.UserId
    sBuffer := JO.ToString;
    SS := TStringStream.Create(sBuffer);
    try
      SS.SaveToFile(Global.LogDir + CS_API + '.Request.json');
      TC.Host := Global.TeeBoxADInfo.Host;
      TC.Port := Global.TeeBoxADInfo.APIPort;
      TC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(sBuffer, IndyTextEncoding_UTF8);
      RBS := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      RO := TJSONObject.ParseJSONValue(string(RBS)) as TJSONObject;
      SS.Clear;
      SS.WriteString(RO.ToString);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      sResCode := RO.GetValue('result_cd').Value;
      sResMsg := RO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      Global.TeeBoxEmergencyMode := (RO.GetValue('result_yn').Value = CRC_YES);
      Result := True;
      PM := TPluginMessage.Create(nil);
      try
        PM.Command := CPC_TEEBOX_EMERGENCY;
        PM.AddParams(CPP_ACTIVE, Global.TeeBoxEmergencyMode);
        PM.PluginMessageToID(Global.StartModuleId);
      finally
        FreeAndNil(PM);
      end;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(RO);
      FreeAndNilJSONObject(JO);
      if Assigned(SS) then
        FreeAndNil(SS);
      TC.Disconnect;
      FreeAndNil(TC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetTeeBoxEmergencyMode.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.SetTeeBoxEmergencyMode(const AIsEmergency: Boolean; var AErrMsg: string): Boolean;
const
  CS_API = 'A420_SetTeeBoxEmergency';
var
  PM: TPluginMessage;
  TC: TIdTCPClient;
  JO, RO: TJSONObject;
  SS: TStringStream;
  RBS: RawByteString;
  sStoreCode, sBuffer, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  TC := TIdTCPClient.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    sStoreCode := SaleManager.StoreInfo.StoreCode;
    if sStoreCode.IsEmpty then
      sStoreCode := Global.ClientConfig.ClientId.Substring(0, 5);
    RO := nil;
    JO := TJSONObject.Create;
    JO.AddPair(TJSONPair.Create('store_cd', sStoreCode));
    JO.AddPair(TJSONPair.Create('api', CS_API));
    JO.AddPair(TJSONPair.Create('mode_yn', String(IIF(AIsEmergency, CRC_YES, CRC_NO))));
    JO.AddPair(TJSONPair.Create('user_id', Global.ClientConfig.ClientId)); //SaleManager.UserInfo.UserId
    sBuffer := JO.ToString;
    SS := TStringStream.Create(sBuffer);
    try
      SS.SaveToFile(Global.LogDir + CS_API + '.Request.json');
      TC.Host := Global.TeeBoxADInfo.Host;
      TC.Port := Global.TeeBoxADInfo.APIPort;
      TC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(sBuffer, IndyTextEncoding_UTF8);
      RBS := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      RO := TJSONObject.ParseJSONValue(string(RBS)) as TJSONObject;
      SS.Clear;
      SS.WriteString(RO.ToString);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      sResCode := RO.GetValue('result_cd').Value;
      sResMsg := RO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      Global.TeeBoxEmergencyMode := AIsEmergency;
      UpdateLog(Global.LogFile, '시스템이 긴급배정 ' + IIF(AIsEmergency, '사용', '중지') + ' 상태로 전환 되었습니다.');
      Result := True;
      PM := TPluginMessage.Create(nil);
      PM.Command := CPC_TEEBOX_EMERGENCY;
      PM.AddParams(CPP_ACTIVE, Global.TeeBoxEmergencyMode);
      PM.PluginMessageToID(Global.TeeBoxEmergencyId);
      PM.PluginMessageToID(Global.StartModuleId);
      PM.PluginMessageToID(Global.TeeBoxViewId);
      PM.PluginMessageToID(Global.SaleFormId);
    finally
      Screen.Cursor := crDefault;
      if Assigned(PM) then
        FreeAndNil(PM);
      FreeAndNilJSONObject(RO);
      FreeAndNilJSONObject(JO);
      if Assigned(SS) then
        FreeAndNil(SS);
      TC.Disconnect;
      FreeAndNil(TC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('SetTeeBoxEmergencyMode(%s).Exception = %s', [BoolToStr(AIsEmergency), E.Message]));
    end;
  end;
end;
function TClientDM.GetLockerStatus(var AErrMsg: string): Boolean;
const
  CS_API = 'K501_LockerStatus';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO: TJSONObject;
  JV: TJSONValue;
  RBS: RawByteString;
  sUrl, sValue, sResCode, sResMsg: string;
  I, nCount, nLockerNo: Integer;
begin
  Result := False;
  AErrMsg := '';
  JO := nil;
  JV := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    ClearMemData(MDLockerStatus);
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s', [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode]);
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg  := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO.FindValue('result_data') is TJSONNull) then
      begin
        JV := JO.Get('result_data').JsonValue;
        nCount := (JV as TJSONArray).Count;
        if (nCount > 0) then
          with MDLockerStatus do
          try
            DisableControls;
            for I := 0 to Pred(nCount) do
            begin
              Append;
              nLockerNo := StrToInt((JV as TJSONArray).Items[I].P['locker_no'].Value);
              FieldValues['locker_no']      := nLockerNo;
              FieldValues['use_yn']         := ((JV as TJSONArray).Items[I].P['use_yn'].Value = CRC_YES);
              FieldValues['use_div']        := StrToIntDef((JV as TJSONArray).Items[I].P['use_div'].Value, 0);
              FieldValues['member_no']      := NVL((JV as TJSONArray).Items[I].P['member_no'].Value, '');
              FieldValues['member_nm']      := NVL((JV as TJSONArray).Items[I].P['member_nm'].Value, '');
              FieldValues['hp_no']          := NVL((JV as TJSONArray).Items[I].P['hp_no'].Value, '');
              FieldValues['product_cd']     := NVL((JV as TJSONArray).Items[I].P['product_cd'].Value, '');
              FieldValues['sale_date']      := NVL((JV as TJSONArray).Items[I].P['sale_date'].Value, '');
              sValue := NVL((JV as TJSONArray).Items[I].P['start_day'].Value, '');
              if not sValue.IsEmpty then
                sValue := FormattedDateString(sValue);
              FieldValues['start_day'] := sValue;
              sValue := NVL((JV as TJSONArray).Items[I].P['end_day'].Value, '');
              if not sValue.IsEmpty then
                sValue := FormattedDateString(sValue);
              FieldValues['end_day'] := sValue;
              FieldValues['purchase_month'] := StrToIntDef((JV as TJSONArray).Items[I].P['purchase_month'].Value, 0);
              FieldValues['keep_amt']       := StrToIntDef((JV as TJSONArray).Items[I].P['keep_amt'].Value, 0);
              FieldValues['purchase_amt']   := StrToIntDef((JV as TJSONArray).Items[I].P['purchase_amt'].Value, 0);
              FieldValues['dc_amt']         := StrToIntDef((JV as TJSONArray).Items[I].P['dc_amt'].Value, 0);
              FieldValues['memo']           := NVL((JV as TJSONArray).Items[I].P['memo'].Value, '');
              FieldValues['user_nm']        := NVL((JV as TJSONArray).Items[I].P['user_nm'].Value, '');
              FieldValues['seat_product_nm']:= NVL((JV as TJSONArray).Items[I].P['seat_product_nm'].Value, '');
              Post;
            end;
          finally
            EnableControls;
          end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JV);
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetLockerStatus.Exception = %s', [AErrMsg]));
    end;
  end;
end;
function TClientDM.GetLockerProdMember(const AMemberNo: string; var AErrMsg: string): Boolean;
const
  CS_API = 'K313_GetMemberLockerProduct';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO: TJSONObject;
  JV: TJSONValue;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sValue: string;
  I, nCount: Integer;
begin
  Result := False;
  AErrMsg := '';
  JO := nil;
  JV := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    ClearMemData(MDLockerProdMember);
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&member_no=%s',
        [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, AMemberNo]);
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO.FindValue('result_data') is TJSONNull) then
      begin
        JV := JO.Get('result_data').JsonValue;
        nCount := (JV as TJSONArray).Count;
        if (nCount > 0) then
          with MDLockerProdMember do
          try
            DisableControls;
            for I := 0 to Pred(nCount) do
            begin
              Append;
              FieldValues['purchase_cd']  := (JV as TJSONArray).Items[I].P['purchase_cd'].Value;
              FieldValues['product_cd']   := (JV as TJSONArray).Items[I].P['product_cd'].Value;
              FieldValues['product_nm']   := (JV as TJSONArray).Items[I].P['product_nm'].Value;
              FieldValues['product_div']  := (JV as TJSONArray).Items[I].P['product_div'].Value;
              FieldValues['purchase_amt'] := StrToIntDef((JV as TJSONArray).Items[I].P['purchase_amt'].Value, 0);
              FieldValues['locker_no']    := StrToIntDef((JV as TJSONArray).Items[I].P['locker_no'].Value, 0);
              FieldValues['locker_nm']    := (JV as TJSONArray).Items[I].P['locker_nm'].Value;
              FieldValues['floor_cd']     := (JV as TJSONArray).Items[I].P['floor_cd'].Value;
              FieldValues['floor_nm']     := (JV as TJSONArray).Items[I].P['floor_nm'].Value;
              FieldValues['zone_cd']      := (JV as TJSONArray).Items[I].P['zone_cd'].Value;
              FieldValues['zone_nm']      := (JV as TJSONArray).Items[I].P['zone_nm'].Value;
              FieldValues['use_status']   := StrToIntDef((JV as TJSONArray).Items[I].P['use_status'].Value, 0);
              FieldValues['overdue_day']  := StrToIntDef((JV as TJSONArray).Items[I].P['overdue_day'].Value, 0);
              sValue := NVL((JV as TJSONArray).Items[I].P['start_day'].Value, '');
              if not sValue.IsEmpty then
                FieldValues['start_day'] := FormattedDateString(sValue);
              sValue := NVL((JV as TJSONArray).Items[I].P['end_day'].Value, '');
              if not sValue.IsEmpty then
                FieldValues['end_day'] := FormattedDateString(sValue);
              Post;
            end;
          finally
            First;
            EnableControls;
          end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JV);
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetLockerProdMember.Exception = %s', [AErrMsg]));
    end;
  end;
end;
function TClientDM.PostLockerClear(const ALockerNo: Integer; var AErrMsg: string): Boolean;
const
  CS_API = 'K502_LockerEnd';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO: TJSONObject;
  SS, RS: TStringStream;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  RS := TStringStream.Create;
  JO := nil;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.ContentType := 'application/json';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'POST';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&locker_no=%d&user_id=%s', [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, ALockerNo, SaleManager.UserInfo.UserId]);
      HC.Post(sUrl, SS, RS);
      RS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('PostLockerClear.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.DoAdminCall(const ACode: Integer; const AMsg, ASender: string; var AErrMsg: string): Boolean;
var
  JO: TJSONObject;
  Config: TIniFile;
  nServerPort: Integer;
begin
  AErrMsg := '';
  Result := False;
  if (Global.AdminCallHandle = 0) then
    Global.AdminCallHandle := FindWindow(PChar('TXGAdminCallForm'), nil);
  if (Global.AdminCallHandle = 0) then
  begin
    AErrMsg := '알리미 프로그램이 실행 중이지 않습니다.';
    Exit;
  end;
  JO := TJSONObject.Create;
  Config := TIniFile.Create(Global.ConfigDir + 'XGAdminCall.config');
  with TIdTCPClient.Create(nil) do
  try
    Screen.Cursor := crSQLWait;
    nServerPort := Config.ReadInteger('Config', 'ServerPort', 6001);
    try
      JO.AddPair(TJSONPair.Create('error_cd', FormatFloat('0000', ACode)));
      JO.AddPair(TJSONPair.Create('error_msg', AMsg));
      JO.AddPair(TJSONPair.Create('sender_id', ASender));
      Host := '127.0.0.1';
      Port := nServerPort;
      ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      Connect;
      IOHandler.WriteLn(JO.ToString, IndyTextEncoding_UTF8);
      Result := True;
    except
      on E: Exception do
      begin
        AErrMsg := '알리미 메시지 전송 중 장애가 발생하였습니다!' + _CRLF + E.Message;
        UpdateLog(Global.LogFile, Format('DoAdminCall.Exception = %s', [E.Message]));
      end;
    end;
  finally
    Screen.Cursor := crDefault;
    Disconnect;
    Free;
    FreeAndNilJSONObject(JO);
    FreeAndNil(Config);
  end;
end;
procedure TClientDM.GetAllowedProdTeeBoxList(const AProdType: string; AItems: TStringList; const ARefreshSource: Boolean);
var
  PR: TProdTeeBoxRec;
  nDoW: Integer;
  sHHMM: string;
begin
  nDoW := DayOfWeek(Now);
  sHHMM := FormatDateTime('hh:nn', Now);
  with TxQuery.Create(nil) do
  try
    Screen.Cursor := crSQLWait;
    AItems.BeginUpdate;
    AItems.Clear;
    AddDataSet(MDProdTeeBox, 'P');
    SQL.Add('SELECT P.* FROM P');
    SQL.Add(Format('WHERE P.product_div = %s', [QuotedStr(AProdType)]));
    SQL.Add(Format('AND SUBSTRING(P.use_div, %d, ''1'') = %s', [nDow]));
    SQL.Add(Format('AND P.start_time <= %s', [QuotedStr(sHHMM)]));
    SQL.Add(Format('AND P.end_time >= %s;', [QuotedStr(sHHMM)]));
    Open;
    First;
    while not Eof do
    begin
      PR := TProdTeeBoxRec.Create;
      PR.ProductCode   := FieldByName('product_cd').AsString;
      PR.ProductName   := FieldByName('product_nm').AsString;
      PR.ZoneCode      := FieldByName('zone_cd').AsString;
      PR.ProductDiv    := FieldByName('product_div').AsString;
      PR.UseDiv        := FieldByName('use_div').AsString;
      PR.UseMonth      := FieldByName('use_month').AsInteger;
      PR.UseCnt        := FieldByName('use_cnt').AsInteger;
      PR.SexDiv        := FieldByName('sex').AsInteger;
      PR.OneUseTime    := FieldByName('one_use_time').AsInteger;
      PR.OneUseCount   := FieldByName('one_use_cnt').AsInteger;
      PR.ProdStartTime := FieldByName('start_time').AsString;
      PR.ProdEndTime   := FieldByName('end_time').AsString;
      PR.ExpireDay     := FieldByName('expire_day').AsInteger;
      PR.ProductAmount := FieldByName('product_amt').AsInteger;
      PR.Memo          := FieldByName('memo').AsString;
      AItems.AddObject(PR.ProductName, TObject(PR));
      Next;
    end;
  finally
    AItems.EndUpdate;
    Screen.Cursor := crDefault;
    Close;
    Free;
  end;
end;
procedure TClientDM.MDACSListCalcFields(DataSet: TDataSet);
begin
  with DataSet do
    case FieldByName('send_div').AsInteger of
      1: FieldValues['calc_send_div'] := '타석기 고장';
      2: FieldValues['calc_send_div'] := 'KIOSK 고장';
      3: FieldValues['calc_send_div'] := 'KIOSK 용지없음';
    end;
end;
procedure TClientDM.MDLockerProdMemberCalcFields(DataSet: TDataSet);
var
  sProdDiv: string;
  nUseStatus: Integer;
begin
  with DataSet do
  begin
    sProdDiv := FieldByName('product_div').AsString;
    nUseStatus := FieldByName('use_status').AsInteger;
    FieldValues['calc_product_div'] := IIF(sProdDiv = CPD_LOCKER, '라커', IIF(sProdDiv = CPD_KEEP_AMT, '보증금', sProdDiv));
    FieldValues['calc_use_status'] := IIF(nUseStatus = 1, '이용중', IIF(nUseStatus = 3, '만기', ''));
  end;
end;
procedure TClientDM.MDFacilityProdMemberCalcFields(DataSet: TDataSet);
begin
  with DataSet do
  begin
    case FieldByName('use_status').AsInteger of
      CPS_PRODUCT_INUSE:  FieldValues['calc_use_status'] := '이용중';   //1
      CPS_PRODUCT_CLOSE:  FieldValues['calc_use_status'] := '종료';     //2
      CPS_PRODUCT_RECESS: FieldValues['calc_use_status'] := '휴회';     //3
      CPS_PRODUCT_BEFORE: FieldValues['calc_use_status'] := '이용전';   //4
      CPS_PRODUCT_PAUSE:  FieldValues['calc_use_status'] := '일시중지'; //5
    end;
  end;
end;
procedure TClientDM.MDMemberCalcFields(DataSet: TDataSet);
var
  nSexDiv: Integer;
begin
  with DataSet do
  begin
    nSexDiv := FieldByName('sex_div').AsInteger;
    FieldValues['sex_div_desc'] := IIF(nSexDiv = CSD_SEX_MALE, '남성', IIF(nSexDiv = CSD_SEX_MALE, '여성', IIF(nSexDiv = CSD_SEX_ALL, '공용', IntToStr(nSexDiv))));
  end;
end;
procedure TClientDM.MDTeeBoxProdMemberCalcFields(DataSet: TDataSet);
var
  sTeeBoxProdDiv: string;
begin
  with DataSet do
  begin
    sTeeBoxProdDiv := FieldbYnAME('product_div').AsString;
    if (sTeeBoxProdDiv = CTP_DAILY) then
      FieldValues['calc_product_div'] := '일일'
    else if (sTeeBoxProdDiv = CTP_COUPON) then
      FieldValues['calc_product_div'] := '쿠폰'
    else if (sTeeBoxProdDiv = CTP_TERM) then
      FieldValues['calc_product_div'] := '기간'
    else if (sTeeBoxProdDiv = CTP_LESSON) then
      FieldValues['calc_product_div'] := '레슨'
    else
      FieldValues['calc_product_div'] := '';
  end;
end;
procedure TClientDM.MDTeeBoxReserved2FilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
  Accept := (DataSet.FieldByName('teebox_no').AsInteger = SaleManager.StoreInfo.SelectedTeeBoxNo);
end;
procedure TClientDM.MDProdTeeBoxCalcFields(DataSet: TDataSet);
var
  sZoneCode: string;
  nSexDiv: Integer;
begin
  with DataSet do
  begin
    sZoneCode := FieldByName('zone_cd').AsString;
    DataSet.FieldValues['calc_zone_cd'] := IIF(sZoneCode = CTZ_VIP, 'VIP', IIF(sZoneCode = CTZ_GENERAL, '일반', ''));
    nSexDiv := FieldByName('sex_div').AsInteger;
    DataSet.FieldValues['calc_sex_div'] := IIF(nSexDiv = CSD_SEX_MALE, '남성', IIF(nSexDiv = CSD_SEX_MALE, '여성', IIF(nSexDiv = CSD_SEX_ALL, '공용', IntToStr(nSexDiv))));
  end;
end;
function TClientDM.OldDeleteParking(const AVender: Integer; const AToDay: string; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := '';
  try
    case AVender of
      CPV_HANIL: //한일테크닉스
        with TUniQuery.Create(nil) do
        try
          Screen.Cursor := crSQLWait;
          Connection := conParking;
          SQL.Add('DELETE FROM fix_car WHERE end_day < :today;');
          Params.ParamByName('today').AsString := AToDay;
          Prepared := True;
          ExecSQL;
          Result := True;
        finally
          Screen.Cursor := crDefault;
          Close;
          Free;
        end;
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('OldDeleteParking.Exception = %s', [E.Message]));
    end;
  end;
end;
procedure TClientDM.OnCouponCalcFields(DataSet: TDataSet);
var
  sDiv: string;
  nCnt: Integer;
begin
  with DataSet do
  begin
    sDiv := FieldByName('dc_div').AsString;
    nCnt := FieldByName('dc_cnt').AsInteger;
    if (sDiv = CDD_FIXED_AMT) then
    begin
      FieldValues['calc_dc_div'] := '정액';
      FieldValues['calc_dc_cnt'] := FormatCurr('#,##0', nCnt);
    end
    else if (sDiv = CDD_PERCENT) then
    begin
      FieldValues['calc_dc_div'] := '정률';
      FieldValues['calc_dc_cnt'] := IntToStr(nCnt) + '％';
    end;
    sDiv := FieldByName('product_div').AsString;
    if (sDiv = CPD_TEEBOX) then
      FieldValues['calc_product_div'] := '타석'
    else if (sDiv = CPD_LOCKER) then
      FieldValues['calc_product_div'] := '라커'
    else if (sDiv = CPD_GENERAL) then
      FieldValues['calc_product_div'] := '일반'
    else if (sDiv = CPD_FACILITY) then
      FieldValues['calc_product_div'] := '시설';
    sDiv := FieldByName('teebox_product_div').AsString;
    if (sDiv = CTP_DAILY) then
      FieldValues['calc_teebox_product_div'] := '일일타석권'
    else if (sDiv = CTP_COUPON) then
      FieldValues['calc_teebox_product_div'] := '쿠폰회원권'
    else if (sDiv = CTP_TERM) then
      FieldValues['calc_teebox_product_div'] := '기간회원권';
    sDiv := FieldByName('use_yn').AsString;
    if (sDiv = CCU_USED) then
      FieldValues['calc_use_yn'] := '사용완료'
    else if (sDiv = CCU_DO_NOT_USED) then
      FieldValues['calc_use_yn'] := '미사용'
    else if (sDiv = CCU_USE_ALLOWED) then
      FieldValues['calc_use_yn'] := '사용중';
  end;
end;
procedure TClientDM.OnTeeBoxReservedCalcFields(DataSet: TDataSet);
var
  sValue, sEndDateTime: string;
  dEndDateTime: TDateTime;
  nAssignMin, nRemainMin: Integer;
begin
  with DataSet do
  begin
    FieldValues['calc_reserve_time'] := Copy(FieldByName('reserve_datetime').AsString, 12, 5);
    FieldValues['calc_start_time'] := Copy(FieldByName('start_datetime').AsString, 12, 5);
    FieldValues['calc_end_time'] := Copy(FieldByName('end_datetime').AsString, 12, 5);
    nAssignMin := FieldByName('assign_min').AsInteger;
    if FieldByName('play_yn').AsBoolean then
    begin
      FieldValues['calc_play_yn'] := '사용중';
      try
        sEndDateTime := FieldByName('end_datetime').AsString;
        if not sEndDateTime.IsEmpty then
        begin
          dEndDateTime := StrToDateTime(sEndDateTime, Global.FS);
          nRemainMin := MinutesBetween(dEndDateTime, Now); // + 1;
          if (nRemainMin < 0) then
            nRemainMin := 0;
          FieldValues['calc_remain_min'] := nRemainMin;
        end
        else
          FieldValues['calc_remain_min'] := nAssignMin;
      except
        FieldValues['calc_remain_min'] := nAssignMin;
      end;
    end else
    begin
      FieldValues['calc_play_yn'] := '대기중';
      FieldValues['calc_remain_min'] := nAssignMin;
    end;
    sValue := FieldByName('reserve_div').AsString;
    if (sValue = CTR_DAILY_MEMBER) then
    begin
      if (FieldValues['affiliate_cd'] <> '') then
      begin
        if (FieldValues['affiliate_cd'] = GCD_WBCLUB_CODE) then
          FieldValues['calc_reserve_div'] := '웰빙클럽'
        else if (FieldValues['affiliate_cd'] = GCD_RFCLUB_CODE) then
          FieldValues['calc_reserve_div'] := '리프레쉬클럽'
        else if (FieldValues['affiliate_cd'] = GCD_RFGOLF_CODE) then
          FieldValues['calc_reserve_div'] := '리프레쉬골프'
        else if (FieldValues['affiliate_cd'] = GCD_IKOZEN_CODE) then
          FieldValues['calc_reserve_div'] := '아이코젠';
      end
      else
        FieldValues['calc_reserve_div'] := '일일타석';
    end
    else if (sValue = CTR_TERM_MEMBER) then
      FieldValues['calc_reserve_div'] := '기간회원'
    else if (sValue = CTR_COUPON_MEMBER) then
      FieldValues['calc_reserve_div'] := '쿠폰회원';
    sValue := FieldByName('reserve_root_div').AsString;
    if (sValue = CCT_POS) then
      FieldValues['calc_reserve_root_div'] := '프런트'
    else if (sValue = CCT_KIOSK) then
      FieldValues['calc_reserve_root_div'] := '키오스크'
    else if (sValue = CCT_MOBILE) then
    begin
      if FieldByName('assign_yn').AsBoolean then
        FieldValues['calc_reserve_root_div'] := '모바일(체크인)'
      else
        FieldValues['calc_reserve_root_div'] := '모바일';
    end
    else if (sValue = CCT_TELE_RESERVED) then
    begin
      if FieldByName('assign_yn').AsBoolean then
        FieldValues['calc_reserve_root_div'] := '전화예약(체크인)'
      else
        FieldValues['calc_reserve_root_div'] := '전화예약';
    end
    else
      FieldValues['calc_reserve_root_div'] := sValue;
    if FieldByName('reserve_move_yn').AsBoolean then
      FieldValues['calc_remark'] := '이동배정';
  end;
end;
function TClientDM.GetFacilityProdMember(const AMemberNo: string; var AErrMsg: string): Boolean;
const
  CS_API = 'K315_GetMemberFacilityProduct';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO: TJSONObject;
  JV: TJSONValue;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sStartDay, sEndDay: string;
  I, nCount: Integer;
begin
  Result := False;
  AErrMsg := '';
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  JO := nil;
  JV := nil;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    ClearMemData(MDFacilityProdMember);
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&member_no=%s', [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, AMemberNo]);
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO.FindValue('result_data') is TJSONNull) then
      begin
        JV := JO.Get('result_data').JsonValue;
        nCount := (JV as TJSONArray).Count;
        if (nCount > 0) then
          with MDFacilityProdMember do
          try
            DisableControls;
            for I := 0 to Pred(nCount) do
            begin
              Append;
              sStartDay := NVL((JV as TJSONArray).Items[I].P['start_day'].Value, '');
              if not sStartDay.IsEmpty then
                FieldValues['start_day'] := FormattedDateString(sStartDay);
              sEndDay := NVL((JV as TJSONArray).Items[I].P['end_day'].Value, '');
              if not sEndDay.IsEmpty then
                FieldValues['end_day'] := FormattedDateString(sEndDay);
              FieldValues['product_cd']        := (JV as TJSONArray).Items[I].P['product_cd'].Value;
              FieldValues['product_nm']        := (JV as TJSONArray).Items[I].P['product_nm'].Value;
              FieldValues['facility_div']      := (JV as TJSONArray).Items[I].P['facility_product_div'].Value;
              FieldValues['facility_div_nm']   := (JV as TJSONArray).Items[I].P['facility_product_div_nm'].Value;
              FieldValues['purchase_cd']       := (JV as TJSONArray).Items[I].P['purchase_cd'].Value;
              FieldValues['access_control_nm'] := (JV as TJSONArray).Items[I].P['access_control_nm'].Value;
              FieldValues['product_amt']       := StrToIntDef((JV as TJSONArray).Items[I].P['product_amt'].Value, 0);
              FieldValues['purchase_amt']      := StrToIntDef((JV as TJSONArray).Items[I].P['purchase_amt'].Value, 0);
              FieldValues['purchase_cnt']      := StrToIntDef((JV as TJSONArray).Items[I].P['purchase_cnt'].Value, 0);
              FieldValues['remain_cnt']        := StrToIntDef((JV as TJSONArray).Items[I].P['remain_cnt'].Value, 0);
              FieldValues['use_status']        := StrToIntDef((JV as TJSONArray).Items[I].P['use_status'].Value, 0); //1:이용中, 2:종료, 3:휴회, 4:이용前, 5:일시중지
              FieldValues['ticket_print_yn']   := ((JV as TJSONArray).Items[I].P['ticket_print_yn'].Value = CRC_YES); //시설이용배정표(제출용) 발행 여부
              FieldValues['today_used_yn']     := ((JV as TJSONArray).Items[I].P['today_used_yn'].Value = CRC_YES);
              Post;
            end;
          finally
            First;
            EnableControls;
          end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JV);
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetFacilityProdMember.Exception = %s', [AErrMsg]));
    end;
  end;
end;
function TClientDM.PostUseFacility(const APurchaseCode: string; var AErrMsg: string): Boolean;
var
  sBarcode, sAccessName: string;
begin
  Result := PostUseFacility(APurchaseCode, sBarcode, sAccessName, AErrMsg);
end;
function TClientDM.PostUseFacility(const APurchaseCode: string; var ABarcode, AAccessName, AErrMsg: string): Boolean;
const
  CS_API = 'K316_UseFacilityProduct';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO: TJSONObject;
  RS: TStringStream;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg: string;
begin
  Result := False;
  ABarcode := '';
  AAccessName := '';
  AErrMsg := '';
  JO := TJSONObject.Create;
  RS := TStringStream.Create;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.ContentType := 'application/x-www-form-urlencoded';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'POST';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&purchase_cd=%s&user_id=%s', [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, APurchaseCode, Global.ClientConfig.ClientId]);
      UpdateLog(Global.LogFile, Format('PostUseFacility.Requset = %s', [sUrl]));
      HC.Post(sUrl, RS, RS);
      RS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if (JO.FindValue('result_data') is TJSONNull) then
        raise Exception.Create('파트너센터로부터 잘못된 결과가 수신되었습니다.');
      try
        JO := JO.GetValue('result_data') as TJSONObject;
        ABarcode := JO.GetValue('access_barcode').Value;
        AAccessName := JO.GetValue('access_control_nm').Value;
      except
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO);
      FreeAndNil(RS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('PostUseFacility.Exception = %s', [E.Message]));
    end;
  end;
end;
procedure TClientDM.UpdatePayment(const ATableNo: Integer;
  const AIsApproval, AIsSaleMode, ADeleteExists: Boolean;
  const APayMethod, AVan, ATid, AInternetYN, ACreditCardNo, AApproveNo,
        AOrgApproveNo, AOrgApproveDate, ATradeNo, ATradeDate,
        AIssuerCode, AISsuerName, ABuyerDiv, ABuyerCode, ABuyerName: string;
  const AInstMonth, AApproveAmt, AVat, AServiceAmt, APromoSeq, APromoDcAmt: Integer;
  const APromoDiv: string);
begin
  if AIsSaleMode then
  begin
    //현금결제 건이 이미 존재하면 우선 삭제
    if ADeleteExists then
      ExecuteABSQuery(Format('DELETE FROM TBPayment WHERE table_no = %d AND pay_method = %s', [ATableNo, QuotedStr(CPM_CASH)]));
    ExecuteABSQuery(
      'INSERT INTO TBPayment(table_no, pay_method, approval_yn, van_cd, tid, internet_yn, credit_card_no, approve_no, ' +
        'org_approve_no, trade_no, trade_date, issuer_cd, issuer_nm, buyer_div, buyer_cd, buyer_nm, ' +
        'inst_mon, approve_amt, vat, service_amt, pc_seq, pc_div, apply_dc_amt)' + _CRLF +
      Format('VALUES (%d, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %d, %d, %d, %d, %d, %s, %d)', [
        ATableNo,
        QuotedStr(APayMethod),
        QuotedStr(IIF(AIsApproval, CRC_YES, CRC_NO)),
        QuotedStr(AVan),
        QuotedStr(ATid),
        QuotedStr(AInternetYN),
        QuotedStr(ACreditCardNo),
        QuotedStr(AApproveNo),
        QuotedStr(AOrgApproveNo),
        QuotedStr(ATradeNo),
        QuotedStr(ATradeDate),
        QuotedStr(AIssuerCode),
        QuotedStr(AISsuerName),
        QuotedStr(ABuyerDiv),
        QuotedStr(ABuyerCode),
        QuotedStr(ABuyerName),
        AInstMonth,
        AApproveAmt,
        AVat,
        AServiceAmt,
        APromoSeq,
        QuotedStr(APromoDiv),
        APromoDcAmt]));
    RefreshPaymentTable(ATableNo);
  end
  else
  begin
    with MDPaymentList do
    try
      DisableControls;
      Append;
      FieldValues['table_no']       := Global.TableInfo.ActiveTableNo;
//      FieldValues['receipt_no']     := SaleManager.ReceiptInfo.ReceiptNo;
      FieldValues['pay_method']     := APayMethod;
      FieldValues['approval_yn']    := IIF(AIsApproval, CRC_YES, CRC_NO);
      FieldValues['van_cd']         := AVan;
      FieldValues['tid']            := ATid;
      FieldValues['internet_yn']    := AInternetYN; //임의 등록(신용카드 수기 등록) 여부
      FieldValues['credit_card_no'] := ACreditCardNo;
      FieldValues['approve_no']     := AApproveNo;
      FieldValues['org_approve_no'] := AOrgApproveNo;
      FieldValues['trade_no']       := ATradeNo;
      FieldValues['trade_date']     := ATradeDate;
      FieldValues['issuer_cd']      := AIssuerCode;
      FieldValues['issuer_nm']      := AISsuerName;
      FieldValues['buyer_div']      := ABuyerDiv;
      FieldValues['buyer_cd']       := ABuyerCode;
      FieldValues['buyer_nm']       := ABuyerName;
      FieldValues['inst_mon']       := AInstMonth;
      FieldValues['approve_amt']    := AApproveAmt;
      FieldValues['vat']            := AVat;
      FieldValues['service_amt']    := AServiceAmt;
      FieldValues['pc_seq']         := APromoSeq;
      FieldValues['pc_div']         := APromoDiv; //CDC_CARD_IMMEDIATE;
      FieldValues['apply_dc_amt']   := APromoDcAmt;
      Post;
    finally
      EnableControls;
    end;
  end;
end;
function TClientDM.GetWelfareDiscountAmt(const ATableNo: Integer): Integer;
begin
  with TABSQuery.Create(nil) do
  try
    DatabaseName := adbLocal.DatabaseName;
    SQL.Add(Format('SELECT SUM(Floor((product_amt * order_qty) * %f)) AS sum_dc_amt', [(SaleManager.MemberInfo.WelfareRate / 100)]));
    SQL.Add(Format('FROM TBSaleItem WHERE table_no = %d', [ATableNo]));
    Open;
    Result := FieldByName('sum_dc_amt').AsInteger;
  finally
    Close;
    Free;
  end;
end;
function TClientDM.GetZoneCodeNames(const AZoneCodes: string): string;
var
  A: TArray<string>;
  I: Integer;
begin
  Result := '';
  A := SplitString(AZoneCodes, ',');
  for I := 0 to Pred(Length(A)) do
  begin
    if (not Result.IsEmpty) then
      Result := Result + ', ';
    if (A[I] = CTZ_GDR) then
      Result := Result + 'GDR'
    else if (A[I] = CTZ_SWING_ANALYZE) or
            (A[I] = CTZ_SWING_ANALYZE_2) then
      Result := Result + '스윙분석'
    else if (A[I] = CTZ_VIP_COUPLE) then
      Result := Result + 'VIP(커플)'
    else if (A[I] = CTZ_GENERAL) then
      Result := Result + '일반타석'
    else if (A[I] = CTZ_LEFT_RIGHT) then
      Result := Result + '좌우겸용'
    else if (A[I] = CTZ_LEFT) then
      Result := Result + '좌타'
    else if (A[I] = CTZ_LESSON) then
      Result := Result + '레슨'
    else if (A[I] = CTZ_SEMI_AUTO) then
      Result := Result + '반자동'
    else if (A[I] = CTZ_SHORT_GAME) then
      Result := Result + '숏게임'
    else if (A[I] = CTZ_TRACKMAN) then
      Result := Result + '트랙맨'
    else if (A[I] = CTZ_VIP) then
      Result := Result + 'VIP'
    else if (A[I] = CTZ_VIP_SINGLE) then
      Result := Result + 'VIP(싱글)'
    else if (A[I] = CTZ_SPECIAL) then
      Result := Result + 'S석'
    else if (A[I] = CTZ_INDOOR) then
      Result := Result + '실내'
    else if (A[I] = CTZ_SCREEN_INDOOR) then
      Result := Result + '스크린/실내'
    else if (A[I] = CTZ_SCREEN_OUTDOOR) then
      Result := Result + '스크린/야외'
    else
      Result := Result + '"' + A[I] + '"';
  end;
end;
function TClientDM.UpdateWelfarePayment(const ATableNo: Integer; const ADelimitedGroupTableList: string; AUsePoint: Integer; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := '';
  try
    if (QRSaleItem.FieldByName('direct_dc_amt').AsInteger = 0) then
    begin
      if not ExecuteABSQuery('UPDATE TBSaleItem' + _CRLF +
            Format('SET direct_dc_amt = Floor((product_amt * order_qty) * %f)', [(SaleManager.MemberInfo.WelfareRate / 100)]) + _CRLF +
            Format('WHERE table_no = %d', [ATableNo]),
          AErrMsg) then
        raise Exception.Create(AErrMsg);
      RefreshSaleItemTable(ATableNo, ADelimitedGroupTableList);
//      ReCalcCouponDiscount(ATableNo, AErrMsg);
    end;
    if not ExecuteABSQuery(
        'INSERT INTO TBPayment(table_no, pay_method, approval_yn, credit_card_no, approve_amt)' + _CRLF +
        Format('VALUES (%d, %s, %s, %s, %d)',
          [ATableNo,
           QuotedStr(CPM_WELFARE),
           QuotedStr(CRC_YES),
           QuotedStr(SaleManager.MemberInfo.WelfareCode),
           AUsePoint]),
        AErrMsg) then
      raise Exception.Create(AErrMsg);
    RefreshPaymentTable(ATableNo, ADelimitedGroupTableList);
    Result := True;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('UpdateWelfarePayment.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetTeeBoxProdMember(const AMemberNo, ATeeBoxProdDiv: string; var AErrMsg: string): Boolean;
const
  CS_API = 'K306_GetMemberTeeBoxProduct';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO: TJSONObject;
  JV: TJSONValue;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sValue, sStartDay, sEndDay: string;
  I, nCount: Integer;
begin
  Result := False;
  AErrMsg := '';
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  JO := nil;
  JV := nil;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    ClearMemData(MDTeeBoxProdMember);
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&member_no=%s',
        [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, AMemberNo]);
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO.FindValue('result_data') is TJSONNull) then
      begin
        JV := JO.Get('result_data').JsonValue;
        nCount := (JV as TJSONArray).Count;
        if (nCount > 0) then
          with MDTeeBoxProdMember do
          try
            DisableControls;
            for I := 0 to Pred(nCount) do
            begin
              sValue := (JV as TJSONArray).Items[I].P['product_div'].Value;
              if not (ATeeBoxProdDiv.IsEmpty or (sValue = ATeeBoxProdDiv)) then
                Continue;
              Append;
              FieldValues['product_div']    := sValue;
              FieldValues['purchase_cd']    := (JV as TJSONArray).Items[I].P['purchase_cd'].Value;
              FieldValues['product_cd']     := (JV as TJSONArray).Items[I].P['product_cd'].Value;
              FieldValues['product_nm']     := (JV as TJSONArray).Items[I].P['product_nm'].Value;
              FieldValues['zone_cd']        := (JV as TJSONArray).Items[I].P['zone_cd'].Value;
              FieldValues['avail_zone_cd']  := (JV as TJSONArray).Items[I].P['available_zone_cd'].Value;
              FieldValues['product_amt']    := StrToIntDef((JV as TJSONArray).Items[I].P['purchase_amt'].Value, 0); //product_amt
              FieldValues['day_start_time'] := (JV as TJSONArray).Items[I].P['day_start_time'].Value;
              FieldValues['day_end_time']   := (JV as TJSONArray).Items[I].P['day_end_time'].Value;
              FieldValues['one_use_time']   := StrToIntDef((JV as TJSONArray).Items[I].P['one_use_time'].Value, 0);
              FieldValues['one_use_cnt']    := StrToIntDef((JV as TJSONArray).Items[I].P['one_use_cnt'].Value, 0);
              FieldValues['coupon_cnt']     := StrToIntDef((JV as TJSONArray).Items[I].P['product_coupon_cnt'].Value, 0);
              FieldValues['remain_cnt']     := StrToIntDef((JV as TJSONArray).Items[I].P['coupon_cnt'].Value, 0);
              FieldValues['use_status']     := StrToIntDef((JV as TJSONArray).Items[I].P['use_status'].Value, 0); //1:이용中, 2:만료, 3:휴회, 4:이용前, 5:일시중지
              sStartDay := NVL((JV as TJSONArray).Items[I].P['start_day'].Value, '');
              if not sStartDay.IsEmpty then
                FieldValues['start_day'] := FormattedDateString(sStartDay);
              sEndDay := NVL((JV as TJSONArray).Items[I].P['end_day'].Value, '');
              if not sEndDay.IsEmpty then
                FieldValues['end_day'] := FormattedDateString(sEndDay);
              FieldValues['today_yn']       := ((JV as TJSONArray).Items[I].P['today_yn'].Value = CRC_YES) and
                                                (sStartDay.IsEmpty or (sStartDay <= Global.CurrentDate)) and
                                                (sEndDay.IsEmpty or (sEndDay >= Global.CurrentDate));
              Post;
            end;
          finally
            First;
            EnableControls;
          end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JV);
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetProdTeeBoxMember.Exception = %s', [AErrMsg]));
    end;
  end;
end;
function TClientDM.GetTeeBoxProdMemberClear(const AMemberNo: string; var AErrMsg: string): Boolean;
begin
  Result := False;
  try
    conTeeBox.StartTransaction;
    with TUniStoredProc.Create(nil) do
    try
      Connection := conTeeBox;
      StoredProcName := 'SP_SET_MEMBER_HOLD_CLEAR';
      Params.Clear;
      Params.CreateParam(ftString, 'p_store_cd', ptInput).AsString := SaleManager.StoreInfo.StoreCode;
      Params.CreateParam(ftString, 'p_member_cd', ptInput).AsString := AMemberNo;
      Params.CreateParam(ftString, 'p_device_nm', ptInput).AsString := SaleManager.StoreInfo.POSName;
      Prepared := True;
      ExecProc;
      conTeeBox.Commit;
      Result := True;
    finally
      Close;
      Free;
    end;
  except
    on E: Exception do
    begin
      conTeeBox.Rollback;
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetTeeBoxProdMemberClear.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.SearchMember(const AMemberNo, AMemberName, AHpNo, ACarNo: string; const AUsePhoto: Boolean; var AErrMsg: string): Boolean;
label
  LABEL_RETRY;
var
  nRetry: ShortInt;
begin
  nRetry := 0;
  try
    //-------
    LABEL_RETRY:
    //-------
    Result := GetMemberSearch(AMemberNo, AMemberName, AHpNo, ACarNo, '', AUsePhoto, 3000, AErrMsg);
    if not Result then
    begin
      Inc(nRetry);
      if (nRetry > 1) then
        raise Exception.Create('회원정보를 가져올 수 없습니다!' + _CRLF + AErrMsg);
      goto LABEL_RETRY;
    end;
    with MDMemberSearch do
    begin
      if not Active then
        Open;
      if (RecordCount = 0) then
      begin
        Result := False;
        raise Exception.Create('검색한 조건에 일치하는 회원정보가 없습니다!');
      end;
      First;
    end;
  except
    on E: Exception do
      AErrMsg := E.Message;
  end;
end;
function TClientDM.OpenTeeBoxProdList(const AProductDiv, AZoneCode: string;
  const ADayOfWeekFiltered: Boolean; var ARecordCount: Integer; var AErrMsg: string): Boolean;
var
  sProdDiv, sUseDiv, sAvailZoneCode: string;
  I: Integer;
  bIsToday: Boolean;
begin
  Result := False;
  AErrMsg := '';
  ARecordCount := 0;
  try
    if not GetProdTeeBoxList(AErrMsg) then
      raise Exception.Create(AErrMsg);
    ClearMemData(MDProdTeeBoxFiltered);
    MDProdTeeBoxFiltered.DisableControls;
    with MDProdTeeBox do
    try
      DisableControls;
      First;
      while not Eof do
      begin
        sProdDiv := FieldByName('product_div').AsString;
        sUseDiv  := FieldByName('use_div').AsString;
        bIsToday := FieldByName('today_yn').AsBoolean;
        sAvailZoneCode := FieldByName('avail_zone_cd').AsString;
        if (sProdDiv = AProductDiv) and
           ((not ADayOfWeekFiltered) or (ADayOfWeekFiltered and bIsToday)) and
           (AZoneCode.IsEmpty or (Pos(AZoneCode, sAvailZoneCode) > 0)) then
        begin
          MDProdTeeBoxFiltered.Append;
          for I := 0 to Pred(FieldCount) do
            if (Fields[I].FieldName <> 'RecId') and
               (Fields[I].FieldKind <> fkCalculated) then
              MDProdTeeBoxFiltered.FieldValues[Fields[I].FieldName] := FieldByName(Fields[I].FieldName).Value;
          MDProdTeeBoxFiltered.Post;
        end;
        Next;
      end;
      Result := True;
    finally
      MDProdTeeBoxFiltered.First;
      MDProdTeeBoxFiltered.EnableControls;
      ARecordCount := MDProdTeeBoxFiltered.RecordCount;
      EnableControls;
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('OpenTeeBoxProdList.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.PostProdCashSaleChange(const AReceiptNo, ACreditCardNo, AApproveNo: string): Boolean;
const
  CS_API = 'K610_PaymentApproval';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO: TJSONObject;
  SS, RS: TStringStream;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg: string;
begin
  Result := False;
  JO := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  RS := TStringStream.Create;
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.ContentType := 'application/json';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'POST';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&user_id=%s&receipt_no=%s&internet_yn=%s&credit_card_no=%s&approve_no=%s',
        [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, SaleManager.UserInfo.UserId, AReceiptNo, CRC_YES, ACreditCardNo, AApproveNo]);
      HC.Post(sUrl, SS, RS);
      RS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO);
      FreeAndNil(RS);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
      UpdateLog(Global.LogFile, Format('PostProdCashSaleChange.Exception = %s', [E.Message]));
  end;
end;
function TClientDM.MakeNewReceipt(const ATableNo: Integer; const AReceiptNo: string; var AErrMsg: string): Boolean;
begin
  Result := False;
  try
    if not ExecuteABSQuery(
        Format('INSERT INTO TBReceipt(receipt_no, table_no, table_come_tm, table_guest_cnt) VALUES (%s, %d, %s, %d)',
          [QuotedStr(AReceiptNo), ATableNo, QuotedStr(Global.CurrentTime), 1]),
        AErrMsg) then
      raise Exception.Create(AErrMsg);
    RefreshReceiptTable(ATableNo);
    Result := True;
  except
    on E: Exception do
      AErrMsg := E.Message;
  end;
end;
function TClientDM.UpdateSaleList(const ATableNo: Integer; const ADelimitedGroupTableList: string;
  const AProductDiv, ATeeBoxProdDiv, AProductCode, AProductName, AUseStartDate, ALessonProCode: string;
  const AProductAmt, AXGolfDCAmt, AOrderQty, AUseMonth, AKeepAmt: Integer; var AErrMsg: string): Boolean;
var
  sReceiptNo: string;
  nOrderQty: Integer;
  bNewRecord: Boolean;
begin
  Result := False;
  AErrMsg := '';
  Screen.Cursor := crSQLWait;
  try
    try
      if SaleManager.ReceiptInfo.ReceiptNo.IsEmpty or
         ((QRSaleItem.RecordCount = 0) and
          (QRPayment.RecordCount = 0) and
          (QRCoupon.RecordCount = 0)) then
       SaleManager.ReceiptInfo.ReceiptNo := SaleManager.GetNewReceiptNo; //20230330
      if not QRReceipt.Locate('table_no', Global.TableInfo.ActiveTableNo, []) then
        if not MakeNewReceipt(Global.TableInfo.ActiveTableNo, SaleManager.ReceiptInfo.ReceiptNo, AErrMsg) then
          raise Exception.Create('영수증 번호를 생성할 수 없습니다!' + _CRLF + AErrMsg);
      if QRSaleItem.Locate('table_no;product_div;product_cd', VarArrayOf([ATableNo, AProductDiv, AProductCode]), []) then
      begin
        if (AProductDiv = CPD_LESSON) or
           (AProductDiv = CPD_RESERVE) then
          raise Exception.Create('레슨/예약 상품은 주문서에 1건만 등록할 수 있습니다.');
        if (AProductDiv = CPD_TEEBOX) and
           (ATeeBoxProdDiv = CTP_DAILY) then
          nOrderQty := AOrderQty
        else
          nOrderQty := (QRSaleItem.FieldByName('order_qty').AsInteger + AOrderQty);
        if not ExecuteABSQuery(
              Format('UPDATE TBSaleItem SET xgolf_dc_amt = %d, order_qty = %d', [AXGolfDCAmt * nOrderQty, nOrderQty]) + _CRLF +
              Format('WHERE table_no = %d AND product_cd = %s', [ATableNo, QuotedStr(AProductCode)]),
            AErrMsg) then
          raise Exception.Create(AErrMsg);
      end
      else
      begin
        bNewRecord := True;
        if not ExecuteABSQuery(
            'INSERT INTO TBSaleItem(table_no, product_div, teebox_prod_div, product_cd, product_nm, product_amt, order_qty, ' +
              'xgolf_dc_amt, purchase_month, locker_no, locker_nm, floor_cd, keep_amt, use_start_date, lesson_pro_cd)' + _CRLF +
            Format('VALUES (%d, %s, %s, %s, %s, %d, %d, %d, %d, %d, %s, %s, %d, %s, %s)', [
              ATableNo,
              QuotedStr(AProductDiv),
              QuotedStr(ATeeBoxProdDiv),
              QuotedStr(AProductCode),
              QuotedStr(AProductName),
              AProductAmt,
              AOrderQty,
              AXGolfDCAmt,
              AUseMonth,
              LockerRec.LockerNo,
              QuotedStr(LockerRec.LockerName),
              QuotedStr(LockerRec.FloorCode),
              AKeepAmt,
              QuotedStr(AUseStartDate),
              QuotedStr(ALessonProCode)]),
            AErrMsg) then
          raise Exception.Create(AErrMsg);
      end;
      if not ExecuteABSQuery(Format('DELETE FROM TBSaleItem WHERE table_no = %d AND order_qty = 0', [ATableNo]), AErrMsg) then
        raise Exception.Create(AErrMsg);
      RefreshSaleItemTable(ATableNo, ADelimitedGroupTableList);
      if bNewRecord then
        QRSaleItem.Last;
      Result := True;
    except
      on E: Exception do
      begin
        AErrMsg := E.Message;
        UpdateLog(Global.LogFile, Format('UpdateSaleList.Exception = %s', [E.Message]));
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;
function TClientDM.UpdateSaleListCafe(const ATableNo: Integer; const ADelimitedGroupTableList: string;
  const AProductDiv, ATeeBoxProdDiv, AProductCode, AProductName: string;
  const AProductAmt, AXGolfDCAmt, AOrderQty, AUseMonth, AKeepAmt: Integer; var AErrMsg: string): Boolean;
begin
  Result := UpdateSaleList(ATableNo, ADelimitedGroupTableList, AProductDiv, ATeeBoxProdDiv, AProductCode, AProductName, '', '', AProductAmt, AXGolfDCAmt, AOrderQty, AUseMonth, AKeepAmt, AErrMsg);
end;
function TClientDM.PostProdSale(const ATableNo: Integer; var AErrMsg: string): Boolean;
const
  CS_API = 'K601_ProductSale';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO, RO, RT: TJSONObject;
  TA, PA, DA, CA: TJSONArray;
  JV: TJSONValue;
  SS, RS: TStringStream;
  RBS: RawByteString;
  Query: TABSQuery;
  sUrl, sResCode, sResMsg: string;
  sPayMethod, sInternetYN, sCreditCardNo, sApproveNo, sOrgApproveNo, sTradeNo: string;
  sTradeDate, sIssuerCode, sIssuerName, sBuyerDiv, sBuyerCode, sBuyerName: string;
  sProdDiv, sChildProdDiv, sProdCode, sProdName, sServiceYN, sCouponCode: string;
  sStartDate, sEndDate, sPcDiv, sPurchaseCode, sUseWeekdays, sLessonProCode, sErrMsg: string;
  sFacilityBarcode, sFacilityAccess: string;
  I, nCount, nSaleQty, nInstMon, nApproveAmt, nVat, nServiceAmt, nTotalAmt, nSaleAmt, nApplyDcAmt, nPcSeq: Integer;
  nDirectDcAmt, nCouponDcAmt, nXGolfDcAmt, nLockerNo, nPurchaseMonth, nKeepAmt, nUnitPrice, nFacility, nTeeBoxNo: Integer;
  dUseStartDate, dUseEndDate: TDateTime;
  bIsParkingError: Boolean;
begin
  Result := False;
  bIsParkingError := False;
  AErrMsg := '';
  sErrMsg := '';
  try
    if SaleManager.ReceiptInfo.ReceiptNo.IsEmpty then
      SaleManager.ReceiptInfo.ReceiptNo := QRReceipt.FieldByName('receipt_no').AsString;
    JO := TJSONObject.Create;
    JO.AddPair(TJSONPair.Create('store_cd',         SaleManager.StoreInfo.StoreCode));
    JO.AddPair(TJSONPair.Create('user_id',          SaleManager.UserInfo.UserId));
    JO.AddPair(TJSONPair.Create('pos_no',           SaleManager.StoreInfo.POSNo));
    JO.AddPair(TJSONPair.Create('client_id',        Global.ClientConfig.ClientId));
    JO.AddPair(TJSONPair.Create('member_no',        SaleManager.MemberInfo.MemberNo));
    JO.AddPair(TJSONPair.Create('xgolf_no',         UTF8String(SaleManager.MemberInfo.XGolfMemberNo)));
    JO.AddPair(TJSONPair.Create('table_no',         TJSONNumber.Create(ATableNo)));
    JO.AddPair(TJSONPair.Create('table_come_tm',    QRReceipt.FieldByName('table_come_tm').AsString));
    JO.AddPair(TJSONPair.Create('table_out_tm',     QRReceipt.FieldByName('table_out_tm').AsString));
    JO.AddPair(TJSONPair.Create('table_guest_cnt',  TJSONNumber.Create(QRReceipt.FieldByName('table_guest_cnt').AsInteger)));
    with SaleManager.ReceiptInfo do
    begin
      JO.AddPair(TJSONPair.Create('receipt_no',         SaleManager.ReceiptInfo.ReceiptNo));
      JO.AddPair(TJSONPair.Create('prev_receipt_no',    ''));
      JO.AddPair(TJSONPair.Create('sale_date',          Global.CurrentDate));
      JO.AddPair(TJSONPair.Create('sale_time',          Copy(Global.CurrentTime, 1, 4)));
      JO.AddPair(TJSONPair.Create('total_amt',          IntToStr(SellTotal)));
      JO.AddPair(TJSONPair.Create('sale_amt',           IntToStr(ChargeTotal)));
      JO.AddPair(TJSONPair.Create('dc_amt',             IntToStr(CouponFixedDCTotal + CouponRateDCTotal)));
      JO.AddPair(TJSONPair.Create('direct_dc_amt',      IntToStr(DirectDCTotal + PromoDCTotal + AffiliateAmt)));
      JO.AddPair(TJSONPair.Create('xgolf_dc_amt',       IntToStr(XGolfDCTotal)));
      JO.AddPair(TJSONPair.Create('alliance_code',      AffiliateRec.PartnerCode));
      JO.AddPair(TJSONPair.Create('alliance_member_no', AffiliateRec.MemberCode));
      JO.AddPair(TJSONPair.Create('memo',               UTF8String(SaleMemo)));
    end;
    PA := TJSONArray.Create;
    with QRPayment do
    try
      DisableControls;
      First;
      while not Eof do
      begin
        sPayMethod    := FieldByName('pay_method').AsString;
        sInternetYN   := IIF(FieldByName('internet_yn').AsBoolean, CRC_YES, CRC_NO);
        sCreditCardNo := FieldByName('credit_card_no').AsString;
        nInstMon      := FieldByName('inst_mon').AsInteger;
        nApproveAmt   := FieldByName('approve_amt').AsInteger;
        nVat          := FieldByName('vat').AsInteger;
        nServiceAmt   := FieldByName('service_amt').AsInteger;
        sApproveNo    := FieldByName('approve_no').AsString;
        sOrgApproveNo := FieldByName('org_approve_no').AsString;
        sTradeNo      := FieldByName('trade_no').AsString;
        sTradeDate    := FieldByName('trade_date').AsString;
        sIssuerCode   := FieldByName('issuer_cd').AsString;
        sIssuerName   := FieldByName('issuer_nm').AsString;
        sBuyerDiv     := FieldByName('buyer_div').AsString;
        sBuyerCode    := FieldByName('buyer_cd').AsString;
        sBuyerName    := FieldByName('buyer_nm').AsString;
        nPcSeq        := FieldByName('pc_seq').AsInteger;
        sPcDiv        := FieldByName('pc_div').AsString;
        nApplyDcAmt   := FieldByName('apply_dc_amt').AsInteger;
        RO := TJSONObject.Create;
        RO.AddPair(TJSONPair.Create('pay_method',     UTF8String(sPayMethod)));
        RO.AddPair(TJSONPair.Create('van_cd',         UTF8String(SaleManager.StoreInfo.VANCode)));
        RO.AddPair(TJSONPair.Create('tid',            UTF8String(SaleManager.StoreInfo.CreditTID)));
        RO.AddPair(TJSONPair.Create('internet_yn',    UTF8String(sInternetYN)));
        RO.AddPair(TJSONPair.Create('credit_card_no', UTF8String(sCreditCardNo)));
        RO.AddPair(TJSONPair.Create('inst_mon',       UTF8String(IntToStr(nInstMon))));
        RO.AddPair(TJSONPair.Create('approve_amt',    UTF8String(IntToStr(nApproveAmt))));
        RO.AddPair(TJSONPair.Create('vat',            UTF8String(IntToStr(nVat))));
        RO.AddPair(TJSONPair.Create('service_amt',    UTF8String(IntToStr(nServiceAmt))));
        RO.AddPair(TJSONPair.Create('approve_no',     UTF8String(sApproveNo)));
        RO.AddPair(TJSONPair.Create('org_approve_no', UTF8String(sOrgApproveNo)));
        RO.AddPair(TJSONPair.Create('trade_no',       UTF8String(sTradeNo)));
        RO.AddPair(TJSONPair.Create('trade_date',     UTF8String(sTradeDate)));
        RO.AddPair(TJSONPair.Create('issuer_cd',      UTF8String(sIssuerCode)));
        RO.AddPair(TJSONPair.Create('issuer_nm',      UTF8String(sIssuerName)));
        RO.AddPair(TJSONPair.Create('buyer_div',      UTF8String(sBuyerDiv)));
        RO.AddPair(TJSONPair.Create('buyer_cd',       UTF8String(sBuyerCode)));
        RO.AddPair(TJSONPair.Create('buyer_nm',       UTF8String(sBuyerName)));
        RO.AddPair(TJSONPair.Create('pc_seq',         UTF8String(IntToStr(nPcSeq))));
        RO.AddPair(TJSONPair.Create('pc_div',         UTF8String(sPcDiv)));
        RO.AddPair(TJSONPair.Create('apply_dc_amt',   UTF8String(IntToStr(nApplyDcAmt))));
        PA.Add(RO);
        Next;
      end;
    finally
      EnableControls;
    end;
    JO.AddPair(TJSONPair.Create('payment', PA));
    DA := TJSONArray.Create;
    with QRSaleItem do
    try
      DisableControls;
      First;
      while not Eof do
      begin
        sProdDiv := FieldByName('product_div').AsString;
        //파트너센터가 처리하지 못한다고 하여 시설상품은 주문수량만큼 전문 뻥튀기 해줌(20230323)
        nCount := System.Math.IfThen(sProdDiv = CPD_FACILITY, FieldByName('order_qty').AsInteger, 1);
        for I := 1 to nCount do
        begin
          sChildProdDiv  := FieldByName('teebox_prod_div').AsString;
          sProdCode      := FieldByName('product_cd').AsString;
          sServiceYN     := IIF(FieldByName('service_yn').AsBoolean, CRC_YES, CRC_NO);
          nLockerNo      := FieldByName('locker_no').AsInteger;
          nPurchaseMonth := FieldByName('purchase_month').AsInteger;
          sStartDate     := FieldByName('use_start_date').AsString;
          sLessonProCode := FieldByName('lesson_pro_cd').AsString;
          nKeepAmt       := FieldByName('keep_amt').AsInteger;
          nUnitPrice     := FieldByName('product_amt').AsInteger;
          sProdName      := FieldByName('product_nm').AsString;
          nSaleQty       := FieldByName('order_qty').AsInteger;
          nSaleAmt       := FieldByName('calc_charge_amt').AsInteger - IIF(AffiliateRec.Applied, SaleManager.ReceiptInfo.AffiliateAmt, 0);
          nTotalAmt      := FieldByName('calc_sell_subtotal').AsInteger;
          nDirectDcAmt   := FieldByName('direct_dc_amt').AsInteger;
          nCouponDcAmt   := (FieldByName('coupon_dc_fixed_amt').AsInteger + FieldByName('coupon_dc_rate_amt').AsInteger) + IIF(AffiliateRec.Applied, SaleManager.ReceiptInfo.AffiliateAmt, 0);
          nXGolfDcAmt    := FieldByName('xgolf_dc_amt').AsInteger;
          //시설상품은 개별 금액 적용(20230403)
          if (sProdDiv = CPD_FACILITY) then
          begin
            nSaleQty := 1;
            if (I < nCount) then
            begin
              nSaleAmt := nSaleAmt div nCount;
              nTotalAmt := nTotalAmt div nCount;
              nDirectDcAmt := nDirectDcAmt div nCount;
              nCouponDcAmt := nCouponDcAmt div nCount;
              nXGolfDcAmt := nXGolfDcAmt div nCount;
            end
            else
            begin
              nSaleAmt := (nSaleAmt div nCount) + (nSaleAmt mod nCount);
              nTotalAmt := (nTotalAmt div nCount) + (nTotalAmt mod nCount);
              nDirectDcAmt := (nDirectDcAmt div nCount) + (nDirectDcAmt mod nCount);
              nCouponDcAmt := (nCouponDcAmt div nCount) + (nCouponDcAmt mod nCount);
              nXGolfDcAmt := (nXGolfDcAmt div nCount) + (nXGolfDcAmt mod nCount);
            end;
          end;
          RO := TJSONObject.Create;
          RO.AddPair(TJSONPair.Create('product_div',    UTF8String(sProdDiv)));
          RO.AddPair(TJSONPair.Create('product_cd',     UTF8String(sProdCode)));
          RO.AddPair(TJSONPair.Create('unit_price',     UTF8String(IntToStr(nUnitPrice))));
          RO.AddPair(TJSONPair.Create('sale_qty',       TJSONNumber.Create(nSaleQty)));
          RO.AddPair(TJSONPair.Create('total_amt',      UTF8String(IntToStr(nTotalAmt))));
          RO.AddPair(TJSONPair.Create('sale_amt',       UTF8String(IntToStr(nSaleAmt))));
          RO.AddPair(TJSONPair.Create('dc_amt',         UTF8String(IntToStr(nCouponDcAmt))));
          RO.AddPair(TJSONPair.Create('direct_dc_amt',  UTF8String(IntToStr(nDirectDcAmt))));
          RO.AddPair(TJSONPair.Create('xgolf_dc_amt',   UTF8String(IntToStr(nXGolfDcAmt))));
          RO.AddPair(TJSONPair.Create('locker_no',      UTF8String(IntToStr(nLockerNo))));
          RO.AddPair(TJSONPair.Create('purchase_month', UTF8String(IntToStr(nPurchaseMonth))));
          RO.AddPair(TJSONPair.Create('start_day',      UTF8String(sStartDate)));
          RO.AddPair(TJSONPair.Create('lesson_pro_cd',  UTF8String(sLessonProCode)));
          RO.AddPair(TJSONPair.Create('keep_amt',       UTF8String(IntToStr(nKeepAmt))));
          RO.AddPair(TJSONPair.Create('product_nm',     UTF8String(sProdName)));
          RO.AddPair(TJSONPair.Create('service_yn',     UTF8String(sServiceYN)));
          TA := TJSONArray.Create;
          if (sProdDiv = CPD_TEEBOX) then
          begin
            with MDTeeBoxSelected do
            try
              DisableControls;
              First;
              while not Eof do
              begin
                RT := TJSONObject.Create;
                RT.AddPair(TJSONPair.Create('teebox_no', UTF8String(IntToStr(FieldByName('teebox_no').AsInteger))));
                TA.Add(RT);
                Next;
              end;
            finally
              EnableControls;
            end;
          end;
          RO.AddPair(TJSONPair.Create('teebox', TA));
          DA.Add(RO);
        end;
        Next;
      end;
    finally
      EnableControls;
    end;
    JO.AddPair(TJSONPair.Create('data', DA));
    CA := TJSONArray.Create;
    with QRCoupon do
    try
      DisableControls;
      First;
      while not Eof do
      begin
        sCouponCode := FieldByName('qr_code').AsString;
        nApplyDcAmt := FieldByName('apply_dc_amt').AsInteger;
        RO := TJSONObject.Create;
        RO.AddPair(TJSONPair.Create('coupon_cd', UTF8String(sCouponCode)));
        RO.AddPair(TJSONPair.Create('apply_dc_amt', UTF8String(IntToStr(nApplyDcAmt))));
        CA.Add(RO);
        Next;
      end;
    finally
      EnableControls;
    end;
    JO.AddPair(TJSONPair.Create('coupon', CA));
    JV := nil;
    RO := nil;
    RT := nil;
    TA := nil;
    SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    RS := TStringStream.Create;
    SS := TStringStream.Create(JO.ToString, TEncoding.UTF8);
    SS.SaveToFile(Global.LogDir + CS_API + '.Request.json');
    with SaleManager.ReceiptInfo do
      UpdateLog(Global.LogFile,
        Format('PostProdSale.Request = table_no: %d, receipt_no: %s, total_amt: %d, sale_amt: %d, dc_amt: %d, direct_dc_amt: %d, xgolf_dc_amt: %d',
          [ATableNo, SaleManager.ReceiptInfo.ReceiptNo, SellTotal, ChargeTotal, CouponFixedDCTotal + CouponRateDCTotal, DirectDCTotal + PromoDCTotal + AffiliateAmt, XGolfDCTotal]));
    Query := TABSQuery.Create(nil);
    Query.DatabaseName := adbLocal.DatabaseName;
    HC := TIdHTTP.Create(nil);
    try
      Screen.Cursor := crSQLWait;
      HC.Request.ContentType := 'application/json';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'POST';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s', [Global.ClientConfig.Host, CS_API]);
      HC.Post(sUrl, SS, RS);
      RS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      UpdateLog(Global.LogFile, Format('PostProdSale.Response = result_cd: %s, result_msg: %s', [sResCode, sResMsg]));
      if (sResCode = CRC_SUCCESS_2) or //매출등록은 되었으나 응답 지연으로 실패하여 재요청 시 수신되는 응답코드
         (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO.FindValue('result_data') is TJSONNull) then
      begin
        JV := JO.Get('result_data').JsonValue;
        nCount := (JV as TJSONArray).Count;
        if (nCount = 0) then
          UpdateLog(Global.LogFile, Format('PostProdSale.Response = result_data.Count : %d', [nCount]))
        else
        begin
          with MDTeeBoxSelected do
          try
            DisableControls;
            for I := 0 to Pred(nCount) do
            begin
              sProdCode := (JV as TJSONArray).Items[I].P['product_cd'].Value;
              sProdDiv := (JV as TJSONArray).Items[I].P['product_div'].Value;
              sChildProdDiv := (JV as TJSONArray).Items[I].P['seat_product_div'].Value;
              sPurchaseCode := (JV as TJSONArray).Items[I].P['purchase_cd'].Value;
              if (sProdDiv = CPD_TEEBOX) and
                 (sChildProdDiv = FieldByName('teebox_div').AsString) then
              begin
                nTeeBoxNo := StrToIntDef((JV as TJSONArray).Items[I].P['teebox_no'].Value, 0);
                if Locate('teebox_no;teebox_div;product_cd', VarArrayOf([nTeeBoxNo, sChildProdDiv, sProdCode]), []) then
                begin
                  Edit;
                  FieldValues['purchase_cd'] := sPurchaseCode;
                  Post;
                  UpdateLog(Global.LogFile, Format('PostProdSale.Response = PurchaseCode.Update(ProdCode: %s, ProdDiv: %s, TeeBoxProdDiv: %s, PuhchaseCode: %s)', [sProdCode, sProdDiv, sChildProdDiv, sPurchaseCode]));
                end;
              end;
              //라커 상품일 경우
              if (sProdDiv = CPD_LOCKER) then
              begin
                sEndDate := (JV as TJSONArray).Items[I].P['locker_end_day'].Value;
                Query.Close;
                Query.SQL.Text := Format('UPDATE TBSaleItem SET use_end_date = %s WHERE table_no = %d AND product_div = %s AND product_cd = %s',
                    [QuotedStr(sEndDate), ATableNo, QuotedStr(sProdDiv), QuotedStr(sProdCode)]);
                Query.ExecSQL;
              end;
              //일일이용권에 한해 부대시설 이용권 출력용 바코드 수신
              if (sProdDiv = CPD_FACILITY) and
                 (sChildProdDiv = CTP_DAILY) then
              try
                sFacilityBarcode := '';
                sFacilityAccess := '';
                if (not PostUseFacility(sPurchaseCode, sFacilityBarcode, sFacilityAccess, sErrMsg)) or
                   (not sErrMsg.IsEmpty) then
                  raise Exception.Create(sErrMsg);
                nFacility := Length(SaleManager.ReceiptInfo.FacilityList);
                SetLength(SaleManager.ReceiptInfo.FacilityList, nFacility + 1);
                with SaleManager.ReceiptInfo.FacilityList[nFacility] do
                begin
                  AccessBarcode := sFacilityBarcode;
                  AccessControlName := sFacilityAccess;
                end;
              except
                on E: Exception do
                begin
                  SaleManager.ReceiptInfo.FacilityError := True;
                  SaleManager.ReceiptInfo.FacilityErrorMessage := E.Message;
                  UpdateLog(Global.LogFile, Format('PostProdSale.PostUseFacility.Exception = %s', [E.Message]));
                end;
              end;
              //주차권(기간회원상품) 정보 등록
              if Global.ParkingServer.Enabled then
              try
                sUseWeekdays := (JV as TJSONArray).Items[I].P['use_div'].Value;
                if (not sPurchaseCode.IsEmpty) and
                   (sProdDiv = CPD_TEEBOX) and
                   (sChildProdDiv = CTP_TERM) then
                begin
                  dUseStartDate := Now;
                  sEndDate := (JV as TJSONArray).Items[I].P['seat_end_day'].Value;
                  if sEndDate.IsEmpty then
                    dUseEndDate := Now
                  else
                    dUseEndDate := StrToDateTime(FormattedDateString(sEndDate) + ' 23:59:59', Global.FS);
                  if not AddParking(Global.ParkingServer.Vendor, sPurchaseCode,
                            SaleManager.MemberInfo.CarNo, SaleManager.MemberInfo.MemberName,
                            sUseWeekdays, dUseStartDate, dUseEndDate, sErrMsg) then
                    raise Exception.Create(sErrMsg);
                  UpdateLog(Global.LogFile, Format('PostProdSale.AddParking = 구매번호: %s, 회원명: %s, 차량번호: %s, 적용요일: %s, 만료일시: %s',
                    [sPurchaseCode, SaleManager.MemberInfo.MemberName, SaleManager.MemberInfo.CarNo, sUseWeekdays, FormatDateTime('yyyy-mm-dd hh:nn:ss', dUseEndDate)]));
                end;
              except
                on E: Exception do
                begin
                  SaleManager.ReceiptInfo.ParkingError := True;
                  SaleManager.ReceiptInfo.ParkingErrorMessage := E.Message;
                  UpdateLog(Global.LogFile, Format('PostProdSale.AddParking.Exception = %s', [E.Message]));
                end;
              end;
            end;
          finally
            EnableControls;
          end;
          for I := 0 to Pred(nCount) do
          begin
            sProdCode := (JV as TJSONArray).Items[I].P['product_cd'].Value;
            sProdDiv := (JV as TJSONArray).Items[I].P['product_div'].Value;
            sChildProdDiv := (JV as TJSONArray).Items[I].P['seat_product_div'].Value;
            sPurchaseCode := (JV as TJSONArray).Items[I].P['purchase_cd'].Value;
          end;
        end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      Query.Close;
      Query.Free;
      FreeAndNilJSONObject(RT);
      FreeAndNilJSONObject(TA);
      FreeAndNilJSONObject(RO);
      FreeAndNilJSONObject(DA);
      FreeAndNilJSONObject(PA);
      FreeAndNilJSONObject(CA);
      FreeAndNilJSONObject(JV);
      FreeAndNilJSONObject(JO);
      FreeAndNil(RS);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('PostProdSale.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.PostProdSaleChange(const ATableNo: Integer; var AErrMsg: string): Boolean;
const
  CS_API = 'K605_ProductChgSale';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO, RO: TJSONObject;
  JV: TJSONValue;
  PA, DA, CA: TJSONArray;
  SS, RS: TStringStream;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sErrMsg: string;
  sReceiptNo, sPayMethod, sInternetYN, sCreditCardNo, sApproveNo, sOrgApproveNo, sTradeNo: string;
  sTradeDate, sIssuerCode, sIssuerNm, sBuyerDiv, sBuyerCode, sBuyerNm, sCouponCode, sPcDiv: string;
  nInstMon, nApproveAmt, nVat, nServiceAmt, nApplyDcAmt, I, nCount: Integer;
  sPurchaseCode, sUseWeekdays, sDate: string;
  dUseStartDate, dUseEndDate: TDateTime;
begin
  Result := False;
  AErrMsg := '';
  JO := TJSONObject.Create;
  RO := TJSONObject.Create;
  PA := TJSONArray.Create;
  DA := TJSONArray.Create;
  CA := TJSONArray.Create;
  with QRReceipt do
  begin
    sReceiptNo := FieldByName('receipt_no').AsString;
    JO.AddPair(TJSONPair.Create('store_cd',        SaleManager.StoreInfo.StoreCode));
    JO.AddPair(TJSONPair.Create('user_id',         SaleManager.UserInfo.UserId));
    JO.AddPair(TJSONPair.Create('pos_no',          SaleManager.StoreInfo.POSNo));
    JO.AddPair(TJSONPair.Create('client_id',       Global.ClientConfig.ClientId));
    JO.AddPair(TJSONPair.Create('member_no',       SaleManager.MemberInfo.MemberNo));
    JO.AddPair(TJSONPair.Create('xgolf_no',        UTF8String(SaleManager.MemberInfo.XGolfMemberNo)));
    JO.AddPair(TJSONPair.Create('receipt_no',      sReceiptNo));
    JO.AddPair(TJSONPair.Create('sale_date',       Global.CurrentDate));
    JO.AddPair(TJSONPair.Create('sale_time',       Copy(Global.CurrentTime, 1, 4)));
    JO.AddPair(TJSONPair.Create('total_amt',       IntToStr(SaleManager.ReceiptInfo.SellTotal)));
    JO.AddPair(TJSONPair.Create('sale_amt',        IntToStr(SaleManager.ReceiptInfo.ChargeTotal)));
    JO.AddPair(TJSONPair.Create('dc_amt',          IntToStr(SaleManager.ReceiptInfo.CouponFixedDCTotal + SaleManager.ReceiptInfo.CouponRateDCTotal)));
    JO.AddPair(TJSONPair.Create('direct_dc_amt',   IntToStr(SaleManager.ReceiptInfo.DirectDCTotal)));
    JO.AddPair(TJSONPair.Create('xgolf_dc_amt',    IntToStr(SaleManager.ReceiptInfo.XGolfDCTotal)));
    JO.AddPair(TJSONPair.Create('table_no',        TJSONNumber.Create(ATableNo)));
    JO.AddPair(TJSONPair.Create('table_come_tm',   FieldByName('table_come_tm').AsString));
    JO.AddPair(TJSONPair.Create('table_out_tm',    FieldByName('table_out_tm').AsString));
    JO.AddPair(TJSONPair.Create('table_guest_cnt', TJSONNumber.Create(FieldByName('table_guest_cnt').AsInteger)));
    JO.AddPair(TJSONPair.Create('memo',            UTF8String(SaleManager.ReceiptInfo.SaleMemo)));
  end;
  with QRPayment do
  try
    DisableControls;
    First;
    while not Eof do
    begin
      sPayMethod    := FieldByName('pay_method').AsString;
      sInternetYN   := IIF(FieldByName('internet_yn').AsBoolean, CRC_YES, CRC_NO);
      sCreditCardNo := FieldByName('credit_card_no').AsString;
      nInstMon      := FieldByName('inst_mon').AsInteger;
      nApproveAmt   := FieldByName('approve_amt').AsInteger;
      nVat          := FieldByName('vat').AsInteger;
      nServiceAmt   := FieldByName('service_amt').AsInteger;
      sApproveNo    := FieldByName('approve_no').AsString;
      sOrgApproveNo := FieldByName('org_approve_no').AsString;
      sTradeNo      := FieldByName('trade_no').AsString;
      sTradeDate    := FieldByName('trade_date').AsString;
      sIssuerCode   := FieldByName('issuer_cd').AsString;
      sIssuerNm     := FieldByName('issuer_nm').AsString;
      sBuyerDiv     := FieldByName('buyer_div').AsString;
      sBuyerCode    := FieldByName('buyer_cd').AsString;
      sBuyerNm      := FieldByName('buyer_nm').AsString;
      sPcDiv        := FieldByName('pc_div').AsString;
      RO.AddPair(TJSONPair.Create('pay_method',     UTF8String(sPayMethod)));
      RO.AddPair(TJSONPair.Create('van_cd',         UTF8String(SaleManager.StoreInfo.VANCode)));
      RO.AddPair(TJSONPair.Create('tid',            UTF8String(SaleManager.StoreInfo.CreditTID)));
      RO.AddPair(TJSONPair.Create('internet_yn',    UTF8String(sInternetYN)));
      RO.AddPair(TJSONPair.Create('credit_card_no', UTF8String(sCreditCardNo)));
      RO.AddPair(TJSONPair.Create('inst_mon',       UTF8String(IntToStr(nInstMon))));
      RO.AddPair(TJSONPair.Create('approve_amt',    UTF8String(IntToStr(nApproveAmt))));
      RO.AddPair(TJSONPair.Create('vat',            UTF8String(IntToStr(nVat))));
      RO.AddPair(TJSONPair.Create('service_amt',    UTF8String(IntToStr(nServiceAmt))));
      RO.AddPair(TJSONPair.Create('approve_no',     UTF8String(sApproveNo)));
      RO.AddPair(TJSONPair.Create('org_approve_no', UTF8String(sOrgApproveNo)));
      RO.AddPair(TJSONPair.Create('trade_no',       UTF8String(sTradeNo)));
      RO.AddPair(TJSONPair.Create('trade_date',     UTF8String(sTradeDate)));
      RO.AddPair(TJSONPair.Create('issuer_cd',      UTF8String(sIssuerCode)));
      RO.AddPair(TJSONPair.Create('issuer_nm',      UTF8String(sIssuerNm)));
      RO.AddPair(TJSONPair.Create('buyer_div',      UTF8String(sBuyerDiv)));
      RO.AddPair(TJSONPair.Create('buyer_cd',       UTF8String(sBuyerCode)));
      RO.AddPair(TJSONPair.Create('buyer_nm',       UTF8String(sBuyerNm)));
      PA.Add(RO);
      Next;
    end;
  finally
    EnableControls;
  end;
  JO.AddPair(TJSONPair.Create('payment', PA));
  RO.AddPair(TJSONPair.Create('pre_purchase_cd', UTF8String(ChangeProdRec.OldPurchaseCode)));
  RO.AddPair(TJSONPair.Create('product_div',     UTF8String(CTP_CHANGE)));
  RO.AddPair(TJSONPair.Create('product_cd',      UTF8String(ChangeProdRec.ProductCode)));
  RO.AddPair(TJSONPair.Create('sale_qty',        UTF8String('1')));
  RO.AddPair(TJSONPair.Create('service_yn',      UTF8String(CRC_NO)));
  RO.AddPair(TJSONPair.Create('sale_amt',        UTF8String(IntToStr(SaleManager.ReceiptInfo.ChargeTotal))));
  RO.AddPair(TJSONPair.Create('dc_amt',          UTF8String(IntToStr(SaleManager.ReceiptInfo.CouponFixedDCTotal + SaleManager.ReceiptInfo.CouponRateDCTotal))));
  RO.AddPair(TJSONPair.Create('direct_dc_amt',   UTF8String(IntToStr(SaleManager.ReceiptInfo.DirectDCTotal))));
  RO.AddPair(TJSONPair.Create('xgolf_dc_amt',    UTF8String(IntToStr(SaleManager.ReceiptInfo.XGolfDCTotal))));
  RO.AddPair(TJSONPair.Create('start_day',       UTF8String(StringReplace(ChangeProdRec.StartDate, '-', '', [rfReplaceAll]))));
  RO.AddPair(TJSONPair.Create('end_day',         UTF8String(StringReplace(ChangeProdRec.EndDate, '-', '', [rfReplaceAll]))));
  RO.AddPair(TJSONPair.Create('coupon_cnt',      UTF8String(IntToStr(ChangeProdRec.CouponCount))));
  DA.Add(RO);
  JO.AddPair(TJSONPair.Create('data', DA));
  with QRCoupon do
  try
    DisableControls;
    First;
    while not Eof do
    begin
      sCouponCode := FieldByName('qr_code').AsString;
      nApplyDcAmt := FieldByName('apply_dc_amt').AsInteger;
      RO := TJSONObject.Create;
      RO.AddPair(TJSONPair.Create('coupon_cd', UTF8String(sCouponCode)));
      RO.AddPair(TJSONPair.Create('apply_dc_amt', UTF8String(IntToStr(nApplyDcAmt))));
      CA.Add(RO);
      Next;
    end;
  finally
    EnableControls;
  end;
  JO.AddPair(TJSONPair.Create('coupon', CA));
  JV := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  RS := TStringStream.Create;
  SS := TStringStream.Create(JO.ToString, TEncoding.UTF8);
  SS.SaveToFile(Global.LogDir + CS_API + '.Request.json');
  with SaleManager.ReceiptInfo do
    UpdateLog(Global.LogFile,
      Format('PostProdSaleChange.Request = table_no: %d, receipt_no: %s, total_amt: %d, sale_amt: %d, dc_amt: %d, direct_dc_amt: %d, xgolf_dc_amt: %d',
        [ATableNo, sReceiptNo, SellTotal, ChargeTotal, CouponFixedDCTotal + CouponRateDCTotal, DirectDCTotal + PromoDCTotal + AffiliateAmt, XGolfDCTotal]));
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.ContentType := 'application/json';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'POST';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s', [Global.ClientConfig.Host, CS_API]);
      HC.Post(sUrl, SS, RS);
      RS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      UpdateLog(Global.LogFile, Format('PostProdSaleChange.Response = result_cd: %s, result_msg: %s', [sResCode, sResMsg]));
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      //주차권(기간회원상품) 정보 삭제
      if Global.ParkingServer.Enabled then
      try
        if not DeleteParking(Global.ParkingServer.Vendor, ChangeProdRec.OldPurchaseCode, sErrMsg) then
          raise Exception.Create(sErrMsg);
      except
        on E: Exception do
        begin
          AErrMsg := E.Message;
          UpdateLog(Global.LogFile, Format('PostProdSaleChange.DeleteParking.Exception = %s', [E.Message]));
        end;
      end;
      if not (JO.FindValue('result_data') is TJSONNull) then
      begin
        JV := JO.Get('result_data').JsonValue;
        nCount := (JV as TJSONArray).Count;
        //주차권(기간회원상품) 정보 등록
        if Global.ParkingServer.Enabled then
          for I := 0 to Pred(nCount) do
          begin
            sPurchaseCode := (JV as TJSONArray).Items[I].P['purchase_cd'].Value;
            sUseWeekdays := (JV as TJSONArray).Items[I].P['use_div'].Value;
            if not sPurchaseCode.IsEmpty then
            begin
              dUseStartDate := Now;
              sDate := StringReplace(ChangeProdRec.EndDate, '-', '', [rfReplaceAll]);
              if sDate.IsEmpty then
                dUseEndDate := Now
              else
                dUseEndDate := StrToDateTime(FormattedDateString(sDate) + ' 23:59:59', Global.FS);
              if not AddParking(Global.ParkingServer.Vendor, sPurchaseCode,
                        SaleManager.MemberInfo.CarNo, SaleManager.MemberInfo.MemberName,
                        sUseWeekdays, dUseStartDate, dUseEndDate, sErrMsg) then
                raise Exception.Create(sErrMsg);
              UpdateLog(Global.LogFile, Format('PostProdSaleChange.AddParking = 구매번호: %s, 회원명: %s, 차량번호: %s, 적용요일: %s, 만료일시: %s',
                [sPurchaseCode, SaleManager.MemberInfo.MemberName, SaleManager.MemberInfo.CarNo, sUseWeekdays, FormatDateTime('yyyy-mm-dd hh:nn:ss', dUseEndDate)]));
            end;
          end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(RO);
      FreeAndNilJSONObject(PA);
      FreeAndNilJSONObject(DA);
      FreeAndNilJSONObject(CA);
      FreeAndNilJSONObject(JV);
      FreeAndNilJSONObject(JO);
      FreeAndNil(RS);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('PostProdSaleChange.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetProdSaleNew(const AStartDate, AEndDate: string; var AErrMsg: string): Boolean;
const
  CS_API = 'K606_ProductSaleNewList';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO: TJSONObject;
  JV: TJSONValue;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sValue: string;
  I, nCount: Integer;
  nTotalAmt, nXGolfDCAmt, nDirectDCAmt, nCouponDCAmt: Integer;
begin
  Result := False;
  AErrMsg := '';
  JV := nil;
  JO := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    ClearMemData(MDReceiptList);
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&pos_no=%s&start_date=%s&end_date=%s&search_date=',
        [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, SaleManager.StoreInfo.POSNo, AStartDate, AEndDate, '']);
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO.FindValue('result_data') is TJSONNull) then
      begin
        JV := JO.Get('result_data').JsonValue;
        nCount := (JV as TJSONArray).Count;
        if (nCount > 0) then
          with MDReceiptList do
          try
            DisableControls;
            for I := 0 to Pred(nCount) do
            begin
              //영수증 목록
              Append;
              FieldValues['table_no']        := StrToIntDef((JV as TJSONArray).Items[I].P['table_no'].Value, 0);
              FieldValues['receipt_no']      := (JV as TJSONArray).Items[I].P['receipt_no'].Value;
              FieldValues['cancel_yn']       := (JV as TJSONArray).Items[I].P['cancel_yn'].Value;
              FieldValues['sale_root_div']   := (JV as TJSONArray).Items[I].P['sale_root_div'].Value;
              FieldValues['prev_receipt_no'] := (JV as TJSONArray).Items[I].P['prev_receipt_no'].Value;
              FieldValues['pos_no']          := (JV as TJSONArray).Items[I].P['pos_no'].Value;
              FieldValues['user_id']         := (JV as TJSONArray).Items[I].P['user_id'].Value;
              FieldValues['user_nm']         := (JV as TJSONArray).Items[I].P['user_nm'].Value;
              FieldValues['member_no']       := (JV as TJSONArray).Items[I].P['member_no'].Value;
              FieldValues['member_nm']       := (JV as TJSONArray).Items[I].P['member_nm'].Value;
              FieldValues['hp_no']           := (JV as TJSONArray).Items[I].P['hp_no'].Value;
              FieldValues['xgolf_no']        := (JV as TJSONArray).Items[I].P['xgolf_no'].Value;
              sValue := NVL((JV as TJSONArray).Items[I].P['sale_date'].Value, '');
              if not sValue.IsEmpty then
                sValue := FormattedDateString(sValue);
              FieldValues['sale_date'] := sValue;
              sValue := NVL((JV as TJSONArray).Items[I].P['sale_time'].Value, '');
              if not sValue.IsEmpty then
                sValue := Copy(sValue, 1, 2) + ':' + Copy(sValue, 3, 2);
              FieldValues['sale_time'] := sValue;
              nTotalAmt    := StrToIntDef((JV as TJSONArray).Items[I].P['total_amt'].Value, 0);
              nDirectDCAmt := StrToIntDef((JV as TJSONArray).Items[I].P['direct_dc_amt'].Value, 0);
              nCouponDCAmt := StrToIntDef((JV as TJSONArray).Items[I].P['dc_amt'].Value, 0);
              nXGolfDCAmt  := StrToIntDef((JV as TJSONArray).Items[I].P['xgolf_dc_amt'].Value, 0);
              FieldValues['total_amt']        := nTotalAmt;
              FieldValues['sale_amt']         := (nTotalAmt - (nDirectDCAmt + nCouponDCAmt + nXGolfDCAmt));
              FieldValues['direct_dc_amt']    := nDirectDCAmt;
              FieldValues['coupon_dc_amt']    := nCouponDCAmt;
              FieldValues['xgolf_dc_amt']     := nXGolfDCAmt;
              FieldValues['affiliate_cd']     := (JV as TJSONArray).Items[I].P['alliance_code'].Value;
              FieldValues['affiliate_card_no']:= (JV as TJSONArray).Items[I].P['alliance_member_no'].Value;
              FieldValues['paid_cnt']         := StrToIntDef((JV as TJSONArray).Items[I].P['approval_cnt'].Value, 0);
              FieldValues['cancel_cnt']       := StrToIntDef((JV as TJSONArray).Items[I].P['approval_cancel_cnt'].Value, 0);
              FieldValues['memo']             := (JV as TJSONArray).Items[I].P['memo'].Value;
              Post;
            end;
          finally
            First;
            EnableControls;
          end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JV);
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetProdSaleNew.Exception = %s', [AErrMsg]));
    end;
  end;
end;
function TClientDM.GetProdSaleDetailNew(const AReceiptNo: string; var AErrMsg: string): Boolean;
const
  CS_API = 'K607_ProductSaleDetailNewList';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  SS: TStringStream;
  JO: TJSONObject;
  JV1, JV2: TJSONValue;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sValue: string;
  I, J, nCount, nCount2, nApproveAmt: Integer;
begin
  Result := False;
  AErrMsg := '';
  ClearMemData(MDSaleItemList);
  ClearMemData(MDPaymentList);
  ClearMemData(MDCouponList);
  JO := nil;
  JV1 := nil;
  JV2 := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&rcp_no=%s', [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, AReceiptNo]);
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg  := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      //결제 내역
      JV1 := JO.Get('payment').JsonValue;
      nCount := (JV1 as TJSONArray).Count;
      if (nCount > 0) then
        with MDPaymentList do
        try
          DisableControls;
          for I := 0 to Pred(nCount) do
          begin
            nApproveAmt := StrToIntDef((JV1 as TJSONArray).Items[I].P['approve_amt'].Value, 0);
            Append;
            FieldValues['receipt_no']     := AReceiptNo;
            FieldValues['approval_yn']    := IIF((JV1 as TJSONArray).Items[I].P['cancel_yn'].Value = CRC_YES, CRC_NO, CRC_YES);
            FieldValues['pay_method']     := (JV1 as TJSONArray).Items[I].P['pay_method'].Value;
            FieldValues['van_cd']         := (JV1 as TJSONArray).Items[I].P['van_cd'].Value;
            FieldValues['tid']            := (JV1 as TJSONArray).Items[I].P['tid'].Value;
            FieldValues['internet_yn']    := (JV1 as TJSONArray).Items[I].P['internet_yn'].Value;
            FieldValues['credit_card_no'] := (JV1 as TJSONArray).Items[I].P['credit_card_no'].Value;
            FieldValues['inst_mon']       := StrToIntDef((JV1 as TJSONArray).Items[I].P['inst_mon'].Value, 0);
            FieldValues['approve_amt']    := nApproveAmt;
            FieldValues['vat']            := StrToIntDef((JV1 as TJSONArray).Items[I].P['vat'].Value, 0);
            FieldValues['service_amt']    := StrToIntDef((JV1 as TJSONArray).Items[I].P['service_amt'].Value, 0);
            FieldValues['apply_dc_amt']   := StrToIntDef((JV1 as TJSONArray).Items[I].P['apply_dc_amt'].Value, 0);
            FieldValues['approve_no']     := (JV1 as TJSONArray).Items[I].P['approve_no'].Value;
            FieldValues['org_approve_no'] := (JV1 as TJSONArray).Items[I].P['org_approve_no'].Value;
            FieldValues['trade_no']       := (JV1 as TJSONArray).Items[I].P['trade_no'].Value;
            FieldValues['trade_date']     := (JV1 as TJSONArray).Items[I].P['trade_date'].Value;
            FieldValues['issuer_cd']      := (JV1 as TJSONArray).Items[I].P['issuer_cd'].Value;
            FieldValues['issuer_nm']      := (JV1 as TJSONArray).Items[I].P['issuer_nm'].Value;
            FieldValues['buyer_div']      := (JV1 as TJSONArray).Items[I].P['buyer_div'].Value;
            FieldValues['buyer_cd']       := (JV1 as TJSONArray).Items[I].P['buyer_cd'].Value;
            FieldValues['buyer_nm']       := (JV1 as TJSONArray).Items[I].P['buyer_nm'].Value;
            Post;
          end;
        finally
          EnableControls;
        end;
      //상품 구매 내역
      JV1 := JO.Get('data').JsonValue;
      nCount := (JV1 as TJSONArray).Count;
      if (nCount > 0) then
        with MDSaleItemList do
        try
          DisableControls;
          for I := 0 to Pred(nCount) do
          begin
            Append;
            FieldValues['receipt_no']     := AReceiptNo;
            FieldValues['product_div']    := (JV1 as TJSONArray).Items[I].P['product_div'].Value;
            FieldValues['teebox_prod_div']:= (JV1 as TJSONArray).Items[I].P['seat_product_div'].Value;
            FieldValues['product_cd']     := (JV1 as TJSONArray).Items[I].P['product_cd'].Value;
            FieldValues['product_nm']     := (JV1 as TJSONArray).Items[I].P['product_nm'].Value;
            FieldValues['product_amt']    := StrToIntDef((JV1 as TJSONArray).Items[I].P['unit_price'].Value, 0);
            FieldValues['coupon_dc_amt']  := StrToIntDef((JV1 as TJSONArray).Items[I].P['dc_amt'].Value, 0);
            FieldValues['direct_dc_amt']  := StrToIntDef((JV1 as TJSONArray).Items[I].P['direct_dc_amt'].Value, 0);
            FieldValues['xgolf_dc_amt']   := StrToIntDef((JV1 as TJSONArray).Items[I].P['xgolf_dc_amt'].Value, 0);
            FieldValues['order_qty']      := StrToIntDef((JV1 as TJSONArray).Items[I].P['sale_qty'].Value, 0);
            FieldValues['purchase_month'] := StrToIntDef((JV1 as TJSONArray).Items[I].P['purchase_month'].Value, 0);
            FieldValues['locker_no']      := (JV1 as TJSONArray).Items[I].P['locker_no'].Value;
            FieldValues['keep_amt']       := StrToIntDef((JV1 as TJSONArray).Items[I].P['keep_amt'].Value, 0);
            FieldValues['purchase_cd']    := (JV1 as TJSONArray).Items[I].P['purchase_cd'].Value;
            sValue := '';
            if not ((JV1 as TJSONArray).Items[I].P['teebox'] is TJSONNull) then
            begin
              JV2 := (JV1 as TJSONArray).Items[I].P['teebox'];
              nCount2 := (JV2 as TJSONArray).Count;
              if (nCount2 > 0) then
              for J := 0 to Pred(nCount2) do
                sValue := sValue + IIF(sValue.IsEmpty, '', ',') + (JV2 as TJSONArray).Items[J].P['teebox_nm'].Value;
            end;
            FieldValues['teebox_list'] := sValue;
            Post;
          end;
        finally
          EnableControls;
        end;
      //주차관제 연동을 위한 기간회원 타석상품 구매번호 업데이트
      if Global.ParkingServer.Enabled then
      begin
        JV1 := JO.Get('purchase').JsonValue;
        nCount := (JV1 as TJSONArray).Count;
        with MDSaleItemList do
        try
          DisableControls;
          First;
          for I := 0 to Pred(nCount) do
          begin
            if not Locate('product_div;teebox_prod_div;use_start_date', VarArrayOf([CPD_TEEBOX, CTP_TERM, '']), []) then
              Break;
            Edit;
            FieldValues['purchase_cd'] := (JV1 as TJSONArray).Items[I].P['purchase_cd'].Value;
            Post;
          end;
        finally
          EnableControls;
        end;
      end;
      //할인쿠폰 사용 내역
      JV1 := JO.Get('coupon').JsonValue;
      nCount := (JV1 as TJSONArray).Count;
      if (nCount > 0) then
      with MDCouponList do
      try
        DisableControls;
        for I := 0 to Pred(nCount) do
        begin
          Append;
          FieldValues['receipt_no']         := AReceiptNo;
          FieldValues['coupon_seq']         := StrToIntDef((JV1 as TJSONArray).Items[I].P['coupon_seq'].Value, 0);
          FieldValues['qr_code']            := (JV1 as TJSONArray).Items[I].P['qr_code'].Value;
          FieldValues['coupon_nm']          := (JV1 as TJSONArray).Items[I].P['coupon_nm'].Value;
          FieldValues['dc_div']             := (JV1 as TJSONArray).Items[I].P['dc_div'].Value;
          FieldValues['dc_cnt']             := StrToIntDef((JV1 as TJSONArray).Items[I].P['dc_cnt'].Value, 0);
          FieldValues['start_day']          := (JV1 as TJSONArray).Items[I].P['start_day'].Value;
          FieldValues['expire_day']         := (JV1 as TJSONArray).Items[I].P['expire_day'].Value;
          FieldValues['use_cnt']            := StrToIntDef((JV1 as TJSONArray).Items[I].P['use_cnt'].Value, 0);
          FieldValues['used_cnt']           := StrToIntDef((JV1 as TJSONArray).Items[I].P['used_cnt'].Value, 0);
          FieldValues['event_nm']           := (JV1 as TJSONArray).Items[I].P['event_nm'].Value;
          FieldValues['event_url']          := (JV1 as TJSONArray).Items[I].P['event_url'].Value;
          FieldValues['dc_cond_div']        := (JV1 as TJSONArray).Items[I].P['dc_cond_div'].Value;
          FieldValues['apply_dc_amt']       := StrToIntDef((JV1 as TJSONArray).Items[I].P['apply_dc_amt'].Value, 0);
          FieldValues['product_div']        := (JV1 as TJSONArray).Items[I].P['product_div'].Value;
          FieldValues['teebox_product_div'] := (JV1 as TJSONArray).Items[I].P['seat_product_div'].Value;
          FieldValues['memo']               := (JV1 as TJSONArray).Items[I].P['memo'].Value;
          FieldValues['send_date']          := (JV1 as TJSONArray).Items[I].P['send_date'].Value;
          FieldValues['use_yn']             := (JV1 as TJSONArray).Items[I].P['use_yn'].Value;
          Post;
        end;
      finally
        EnableControls;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JV2);
      FreeAndNilJSONObject(JV1);
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetProdSaleDetailNew.Exception = %s', [AErrMsg]));
    end;
  end;
end;
function TClientDM.CancelProdSale(const AReceiptNo, APrevReceiptNo, AAffiliateCode, AAffiliateMemberCode, AMemo: string; var AIsParkingError: Boolean; var AErrMsg: string): Boolean;
const
  CS_API = 'K603_ProductSale';
var
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  HA: TIdHTTPAccess;
  JO1, JO2, RO: TJSONObject;
  PA: TJSONArray;
  SS, RS: TStringStream;
  RBS: RawByteString;
  sUrl, sErrMsg, sResCode, sResMsg: string;
begin
  Result := False;
  AIsParkingError := False;
  AErrMsg := '';
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  HA := TIdHTTPAccess(TIdHTTP.Create(nil));
  RS := TStringStream.Create;
  SS := nil;
  JO2 := nil;
  RO := nil;
  PA := nil;
  try
    Screen.Cursor := crSQLWait;
    JO1 := TJSONObject.Create;
    JO1.AddPair(TJSONPair.Create('store_cd', SaleManager.StoreInfo.StoreCode));
    JO1.AddPair(TJSONPair.Create('user_id', SaleManager.UserInfo.UserId));
    JO1.AddPair(TJSONPair.Create('pos_no', SaleManager.StoreInfo.POSNo));
    JO1.AddPair(TJSONPair.Create('receipt_no', AReceiptNo));
    JO1.AddPair(TJSONPair.Create('prev_receipt_no', APrevReceiptNo));
    JO1.AddPair(TJSONPair.Create('alliance_code', AAffiliateCode));
    JO1.AddPair(TJSONPair.Create('alliance_member_no', AAffiliateMemberCode));
    JO1.AddPair(TJSONPair.Create('memo', AMemo));
    try
      PA := TJSONArray.Create;
      with MDPaymentList do
      try
        DisableControls;
        First;
        while not Eof do
        begin
          RO := TJSONObject.Create;
          RO.AddPair(TJSONPair.Create('pay_method',     UTF8String(FieldByName('pay_method').AsString)));
          RO.AddPair(TJSONPair.Create('van_cd',         UTF8String(SaleManager.StoreInfo.VANCode)));
          RO.AddPair(TJSONPair.Create('tid',            UTF8String(FieldByName('tid').AsString)));
          RO.AddPair(TJSONPair.Create('internet_yn',    UTF8String(IIF(FieldByName('internet_yn').AsBoolean, CRC_YES, CRC_NO))));
          RO.AddPair(TJSONPair.Create('credit_card_no', UTF8String(FieldByName('credit_card_no').AsString)));
          RO.AddPair(TJSONPair.Create('inst_mon',       UTF8String(FieldByName('inst_mon').AsString)));
          RO.AddPair(TJSONPair.Create('approve_amt',    UTF8String(FieldByName('approve_amt').AsString)));
          RO.AddPair(TJSONPair.Create('vat',            UTF8String(FieldByName('vat').AsString)));
          RO.AddPair(TJSONPair.Create('service_amt',    UTF8String(FieldByName('service_amt').AsString)));
          RO.AddPair(TJSONPair.Create('approve_no',     UTF8String(FieldByName('approve_no').AsString)));
          RO.AddPair(TJSONPair.Create('org_approve_no', UTF8String(FieldByName('org_approve_no').AsString)));
          RO.AddPair(TJSONPair.Create('trade_no',       UTF8String(FieldByName('trade_no').AsString)));
          RO.AddPair(TJSONPair.Create('trade_date',     UTF8String(FieldByName('trade_date').AsString)));
          RO.AddPair(TJSONPair.Create('issuer_cd',      UTF8String(FieldByName('issuer_cd').AsString)));
          RO.AddPair(TJSONPair.Create('issuer_nm',      UTF8String(FieldByName('issuer_nm').AsString)));
          RO.AddPair(TJSONPair.Create('buyer_div',      UTF8String(FieldByName('buyer_div').AsString)));
          RO.AddPair(TJSONPair.Create('buyer_cd',       UTF8String(FieldByName('buyer_cd').AsString)));
          RO.AddPair(TJSONPair.Create('buyer_nm',       UTF8String(FieldByName('buyer_nm').AsString)));
          PA.Add(RO);
          Next;
        end;
      finally
        EnableControls;
      end;
      JO1.AddPair(TJSONPair.Create('payment', PA));
      SS := TStringStream.Create(JO1.ToString, TEncoding.UTF8);
      HA.Request.ContentType := 'application/json';
      HA.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HA.Request.Method := 'DELETE';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HA.IOHandler := SSL;
      HA.HandleRedirects := False;
      HA.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HA.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s', [Global.ClientConfig.Host, CS_API]);
      SS.SaveToFile(Global.LogDir + CS_API + '.Request.json');
      HA.DoRequest('DELETE', sUrl, SS, RS, []);
      RS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO2.GetValue('result_cd').Value;
      sResMsg := JO2.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      //주차권(기간회원상품) 정보 삭제
      if Global.ParkingServer.Enabled then
        with MDSaleItemList do
        try
          DisableControls;
          First;
          while not Eof do
          begin
            if ((FieldByName('product_div').AsString = CPD_TEEBOX) and
                (not DeleteParking(Global.ParkingServer.Vendor, FieldByName('purchase_cd').AsString, sErrMsg))) then
              raise Exception.Create(sErrMsg);
            Next;
          end;
        finally
          EnableControls;
        end;
//      UpdateLog(Global.LogFile, Format('CancelProductSale.Success = AReceiptNo : %s, APrevReceiptNo : %s', [AReceiptNo, APrevReceiptNo]));
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(RO);
      FreeAndNilJSONObject(PA);
      FreeAndNilJSONObject(JO1);
      FreeAndNil(RS);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HA.Disconnect;
      FreeAndNil(HA);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('CancelProdSale.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.CancelProdSalePartial(const AReceiptNo, APayMethod, ACardNo, AApprovalNo, AOrgApprovalNo: string; var AErrMsg: string): Boolean;
const
  CS_API = 'K609_PaymentCancel';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO: TJSONObject;
  SS, RS: TStringStream;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  JO := nil;
  SS := TStringStream.Create;
  RS := TStringStream.Create;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.ContentType := 'application/json';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'POST';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&user_id=%s&pos_no=%s&receipt_no=%s&pay_method=%s&credit_card_no=%s&approve_no=%s&org_approve_no=%s',
        [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, SaleManager.UserInfo.UserId,
          SaleManager.StoreInfo.POSNo, AReceiptNo, APayMethod, ACardNo, AApprovalNo, AOrgApprovalNo]);
      HC.Post(sUrl, SS, RS);
      RS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('result_cd').Value;
      sResMsg := JO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
//      UpdateLog(Global.LogFile, Format('CancelProdSalePartial.Success = ReceiptNo: %s', [AReceiptNo]));
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO);
      FreeAndNil(RS);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('CancelProdSalePartial.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.GetCardBinDiscount(const ACardBinNo, ATeeBoxProdDiv: string; const AApproveAmt: Integer; var APromoSeq, ADiscountAmt: Integer; var AErrMsg: string): Boolean;
const
  CS_API = 'K608_PromotionCardBin';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO1, JO2: TJSONObject;
  RS: TStringStream;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  APromoSeq := 0;
  ADiscountAmt := 0;
  JO1 := nil;
  JO2 := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  RS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&bin_no=%s&apply_amt=%d&seat_product_div=%s',
        [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, ACardBinNo, AApproveAmt, ATeeBoxProdDiv]); //운영계
      HC.Get(sUrl, RS);
      RS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO1 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO1.GetValue('result_cd').Value;
      sResMsg := JO1.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO1.FindValue('result_data') is TJSONNull) then
      begin
        JO2 := JO1.GetValue('result_data') as TJSONObject;
        if (JO2.GetValue('pos_use_yn').Value <> CRC_YES) then
          raise Exception.Create('POS에서는 즉시할인 적용이 불가한 카드입니다!' +
            IIF(JO2.GetValue('kiosk_use_yn').Value = CRC_YES, _CRLF + '(KIOSK 할인 적용 가능)', ''));
        APromoSeq := StrToIntDef(JO2.GetValue('pc_seq').Value, 0);
        ADiscountAmt := StrToIntDef(JO2.GetValue('dc_amt').Value, 0);
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JO1);
      FreeAndNil(RS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetCardBinDiscount.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.MakeReceiptJson(const ATeeBoxReserved: Boolean; var AErrMsg: string): string;
var
  SS: TStringStream;
  JO, RO, JOStore, JOMember, JOReceipt: TJSONObject;
  JAProduct, JADiscount, JAPayment, JATeeBox, JALocker: TJSONArray;
  sPayMethod, sStartDate, sEndDate, sPartner, sCouponUseDate, sProdDiv, sSaleDate, sSaleTime,
  sReserveMoveYN, sReserveNoShowYN, sExpireDate: string;
  nVatAmt, nAssignMin: Integer;
begin
  Result  := '';
  AErrMsg := '';
  JO := TJSONObject.Create;
  JOStore := TJSONObject.Create;
  JOMember := TJSONObject.Create;
  JOReceipt := TJSONObject.Create;
  JATeeBox := TJSONArray.Create;
  JALocker := TJSONArray.Create;
  JAProduct := TJSONArray.Create;
  JADiscount := TJSONArray.Create;
  JAPayment := TJSONArray.Create;
  RO := nil;
  SS := TStringStream.Create;
  try
    JO.AddPair(TJSONPair.Create('StoreInfo', JOStore));
    JO.AddPair(TJSONPair.Create('OrderItems', JATeeBox));
    JO.AddPair(TJSONPair.Create('LockerItems', JALocker));
    JO.AddPair(TJSONPair.Create('ReceiptMemberInfo', JOMember));
    JO.AddPair(TJSONPair.Create('ProductInfo', JAProduct));
    JO.AddPair(TJSONPair.Create('PayInfo', JAPayment));
    JO.AddPair(TJSONPair.Create('DiscountInfo', JADiscount));
    JO.AddPair(TJSONPair.Create('ReceiptEtc', JOReceipt));
    //매장 정보
    JOStore.AddPair(TJSONPair.Create('StoreName', SaleManager.StoreInfo.StoreName));
    JOStore.AddPair(TJSONPair.Create('BizNo', SaleManager.StoreInfo.BizNo));
    JOStore.AddPair(TJSONPair.Create('BossName', SaleManager.StoreInfo.CEO));
    JOStore.AddPair(TJSONPair.Create('Tel', SaleManager.StoreInfo.TelNo));
    JOStore.AddPair(TJSONPair.Create('Addr', SaleManager.StoreInfo.Address));
    JOStore.AddPair(TJSONPair.Create('CashierName', SaleManager.UserInfo.UserName));
    try
      sSaleDate := Global.FormattedCurrentDate;
      sSaleTime := Copy(Global.FormattedCurrentTime, 1, 5);
      if (QRPayment.RecordCount > 0) then
      begin
        //결제 내역
        with QRPayment do
        try
          DisableControls;
          First;
          while not Eof do
          begin
            RO := TJSONObject.Create;
            sPayMethod := FieldByName('pay_method').AsString;
            if (sPayMethod = CPM_CARD) then
              RO.AddPair(TJSONPair.Create('PayCode',  'Card'))
            else if (sPayMethod = CPM_PAYCO_CARD) or
                    (sPayMethod = CPM_PAYCO_COUPON) or
                    (sPayMethod = CPM_PAYCO_POINT) then
              RO.AddPair(TJSONPair.Create('PayCode',  'Payco'))
            else
              RO.AddPair(TJSONPair.Create('PayCode',  'Cash'));
            RO.AddPair(TJSONPair.Create('Approval',       TJSONBool.Create(FieldByName('approval_yn').AsString = CRC_YES).ToString));
            RO.AddPair(TJSONPair.Create('Internet',       TJSONBool.Create(FieldByName('internet_yn').AsString = CRC_YES).ToString));
            RO.AddPair(TJSONPair.Create('ApprovalAmt',    TJSONNumber.Create(FieldByName('approve_amt').AsInteger)));
            RO.AddPair(TJSONPair.Create('ApprovalNo',     FieldByName('approve_no').AsString));
            RO.AddPair(TJSONPair.Create('OrgApproveNo',   FieldByName('org_approve_no').AsString));
            RO.AddPair(TJSONPair.Create('CardNo',         FieldByName('credit_card_no').AsString));
            RO.AddPair(TJSONPair.Create('HalbuMonth',     IntToStr(FieldByName('inst_mon').AsInteger)));
            RO.AddPair(TJSONPair.Create('CompanyName',    FieldByName('issuer_nm').AsString));
            RO.AddPair(TJSONPair.Create('MerchantKey',    ''));
            RO.AddPair(TJSONPair.Create('TransDateTime',  FieldByName('trade_date').AsString));
            RO.AddPair(TJSONPair.Create('BuyCompanyName', FieldByName('buyer_nm').AsString));
            RO.AddPair(TJSONPair.Create('BuyTypeName',    FieldByName('buyer_cd').AsString));
            JAPayment.Add(RO);
            Next;
          end;
        finally
          EnableControls;
        end;
        //주문 상품 내역
        with QRSaleItem do
        try
          DisableControls;
          First;
          while not Eof do
          begin
            RO := TJSONobject.Create;
            nVatAmt := (FieldByName('product_amt').AsInteger - Trunc((FieldByName('product_amt').AsInteger / 1.1)));
            RO.AddPair(TJSONPair.Create('Name',  FieldByName('product_nm').AsString));
            RO.AddPair(TJSONPair.Create('Code',  FieldByName('product_cd').AsString));
            RO.AddPair(TJSONPair.Create('Price', TJSONNumber.Create(FieldByName('product_amt').AsInteger)));
            RO.AddPair(TJSONPair.Create('Vat',   TJSONNumber.Create(nVatAmt)));
            RO.AddPair(TJSONPair.Create('Qty',   TJSONNumber.Create(FieldByName('order_qty').AsInteger)));
            JAProduct.Add(RO);
            if (FieldByName('product_div').AsString = CPD_LOCKER) then
            begin
              RO := TJSONobject.Create;
              sStartDate := FormattedDateString(FieldByName('use_start_date').AsString);
              sEndDate   := FormattedDateString(FieldByName('use_end_date').AsString);
              RO.AddPair(TJSONPair.Create('LockerNo',      TJSONNumber.Create(FieldByName('locker_no').AsInteger)));
              RO.AddPair(TJSONPair.Create('LockerName',    FieldByName('locker_nm').AsString));
              RO.AddPair(TJSONPair.Create('FloorCode',     FieldByName('floor_cd').AsString));
              RO.AddPair(TJSONPair.Create('PurchaseMonth', TJSONNumber.Create(FieldByName('purchase_month').AsInteger)));
              RO.AddPair(TJSONPair.Create('UseStartDate',  sStartDate));
              RO.AddPair(TJSONPair.Create('UseEndDate',    sEndDate));
              JALocker.Add(RO);
            end;
            Next;
          end;
        finally
          EnableControls;
        end;
      end;
      //타석 발권 내역
      if ATeeBoxReserved then
      begin
        with MDTeeBoxIssued do
        try
          DisableControls;
          First;
          while not Eof do
          begin
            sCouponUseDate := '';
            sProdDiv := FieldByName('product_div').AsString;
            nAssignMin := FieldByName('assign_time').AsInteger;
            sReserveMoveYN := IIF(FieldByName('reserve_move_yn').AsBoolean, CRC_YES, CRC_NO);
            sReserveNoShowYN := IIF(FieldByName('reserve_noshow_yn').AsBoolean, CRC_YES, CRC_NO);
            sExpireDate := IIF(sProdDiv = CTP_DAILY, '', FormattedDateString(FieldByName('expire_day').AsString));
            if (sProdDiv = CTP_DAILY) then
            begin
              ClearMemberInfo(Global.TeeBoxViewId);
              ClearMemberInfo(Global.SaleFormId);
            end;
            RO := TJSONobject.Create;
            RO.AddPair(TJSONPair.Create('TeeBox_Floor',    FieldByName('floor_nm').AsString));
            RO.AddPair(TJSONPair.Create('TeeBox_No',       FieldByName('teebox_nm').AsString));
            RO.AddPair(TJSONPair.Create('UseTime',         Copy(FieldByName('start_datetime').AsString, 12, 5) + '-' +
              FormatDateTime('hh:nn', IncMinute(StrToDateTime(FieldByName('start_datetime').AsString, Global.FS), nAssignMin))));
            RO.AddPair(TJSONPair.Create('OneUseTime',      IntToStr(nAssignMin)));
            RO.AddPair(TJSONPair.Create('Reserve_No',      FieldByName('reserve_no').AsString));
            RO.AddPair(TJSONPair.Create('UseProductName',  FieldByName('product_nm').AsString));
            RO.AddPair(TJSONPair.Create('Coupon',          TJSONBool.Create(sProdDiv = CTP_COUPON).ToString)); // 쿠폰 사용 여부
            RO.AddPair(TJSONPair.Create('CouponQty',       TJSONNumber.Create(FieldByName('coupon_cnt').AsInteger)));  // 잔여 쿠폰 수
            RO.AddPair(TJSONPair.Create('ExpireDate',      sExpireDate));
            RO.AddPair(TJSONPair.Create('Product_Div',     sProdDiv));
            RO.AddPair(TJSONPair.Create('CouponUseDate',   sCouponUseDate));
            RO.AddPair(TJSONPair.Create('ReserveMoveYN',   sReserveMoveYN));
            RO.AddPair(TJSONPair.Create('ReserveNoShowYN', sReserveNoShowYN));
            JATeeBox.Add(RO);
            Next;
          end;
        finally
          EnableControls;
        end;
      end;
      //회원 정보
      with SaleManager.MemberInfo do
        if not MemberNo.IsEmpty then
        begin
          JOMember.AddPair(TJSONPair.Create('Name',         MemberName));
          JOMember.AddPair(TJSONPair.Create('Code',         MemberNo));
          JOMember.AddPair(TJSONPair.Create('Tel',          HpNo));
          JOMember.AddPair(TJSONPair.Create('CarNo',        CarNo));
          JOMember.AddPair(TJSONPair.Create('CardNo',       MemberQRCode));
          JOMember.AddPair(TJSONPair.Create('LockerList',   LockerList));
          JOMember.AddPair(TJSONPair.Create('ExpireLocker', FormattedDateString(ExpireLocker)));
        end;
      //엑스골프 회원 할인
      if (SaleManager.ReceiptInfo.XGolfDCTotal > 0) then
      begin
        RO := TJSONobject.Create;
        RO.AddPair(TJSONPair.Create('Name',   '엑스골프 회원 할인'));
        RO.AddPair(TJSONPair.Create('QRCode', ''));
        RO.AddPair(TJSONPair.Create('Value',  IntToStr(SaleManager.ReceiptInfo.XGolfDCTotal)));
        JADiscount.Add(RO);
      end;
      //결제수단별 제휴 할인
      if (SaleManager.ReceiptInfo.PromoDCTotal > 0) then
      begin
        RO := TJSONobject.Create;
        RO.AddPair(TJSONPair.Create('Name',   '신용카드 제휴 할인'));
        RO.AddPair(TJSONPair.Create('QRCode', ''));
        RO.AddPair(TJSONPair.Create('Value',  IntToStr(SaleManager.ReceiptInfo.PromoDCTotal)));
        JADiscount.Add(RO);
      end;
      //쿠폰 할인
      with QRCoupon do
      try
        DisableControls;
        First;
        while not Eof do
        begin
          RO := TJSONobject.Create;
          RO.AddPair(TJSONPair.Create('Name',   FieldByName('coupon_nm').AsString));
          RO.AddPair(TJSONPair.Create('QRCode', FieldByName('qr_code').AsString));
          if (FieldByName('dc_div').AsString = CDD_PERCENT) then
            RO.AddPair(TJSONPair.Create('Value', IntToStr(FieldByName('apply_dc_amt').AsInteger)))
          else
            RO.AddPair(TJSONPair.Create('Value', IntToStr(FieldByName('dc_cnt').AsInteger)));
          JADiscount.Add(RO);
          Next;
        end;
        //제휴사(웰빙클럽,리프레쉬클럽,아이코젠 등) 회원 할인
        if AffiliateRec.Applied then
        begin
          sPartner := GetAffiliateName(AffiliateRec.PartnerCode, '제휴사');
          RO := TJSONobject.Create;
          RO.AddPair(TJSONPair.Create('Name',   sPartner + ' 회원 할인'));
          RO.AddPair(TJSONPair.Create('QRCode', ''));
          RO.AddPair(TJSONPair.Create('Value',  IntToStr(SaleManager.ReceiptInfo.AffiliateAmt)));
          JADiscount.Add(RO);
        end;
      finally
        EnableControls;
      end;
      if (QRPayment.RecordCount > 0) then
      begin
        //영수증 출력 정보
        JOReceipt.AddPair(TJSONPair.Create('RcpNo',      TJSONNumber.Create(1)));
        JOReceipt.AddPair(TJSONPair.Create('SaleDate',   sSaleDate));
        JOReceipt.AddPair(TJSONPair.Create('SaleTime',   sSaleTime));
        JOReceipt.AddPair(TJSONPair.Create('ReturnDate', ''));
        JOReceipt.AddPair(TJSONPair.Create('RePrint',    TJSONBool.Create(False).ToString));  // 재출력 여부
        JOReceipt.AddPair(TJSONPair.Create('TotalAmt',   TJSONNumber.Create(SaleManager.ReceiptInfo.SellTotal)));
        JOReceipt.AddPair(TJSONPair.Create('DCAmt',      TJSONNumber.Create(Trunc(SaleManager.ReceiptInfo.DiscountTotal))));
        JOReceipt.AddPair(TJSONPair.Create('KeepAmt',    TJSONNumber.Create(Trunc(SaleManager.ReceiptInfo.KeepAmt))));
        JOReceipt.AddPair(TJSONPair.Create('ReceiptNo',  QRReceipt.FieldByName('receipt_no').AsString));
        JOReceipt.AddPair(TJSONPair.Create('Top1',       ''));
        JOReceipt.AddPair(TJSONPair.Create('Top2',       ''));
        JOReceipt.AddPair(TJSONPair.Create('Top3',       ''));
        JOReceipt.AddPair(TJSONPair.Create('Top4',       ''));
        JOReceipt.AddPair(TJSONPair.Create('Bottom1',    ''));
        JOReceipt.AddPair(TJSONPair.Create('Bottom2',    ''));
        JOReceipt.AddPair(TJSONPair.Create('Bottom3',    ''));
        JOReceipt.AddPair(TJSONPair.Create('Bottom4',    ''));
        JOReceipt.AddPair(TJSONPair.Create('SaleUpload', CRC_NO));
      end;
      (*
      //시설이용권 출력 정보
      JOReceipt.AddPair(TJSONPair.Create('FacilityBarcode', SaleManager.ReceiptInfo.FacilityBarcode));
      JOReceipt.AddPair(TJSONPair.Create('FacilityAccessName', SaleManager.ReceiptInfo.FacilityAccessName));
      *)
      Result := JO.ToString;
      SS.WriteString(Result);
      SS.SaveToFile(Global.LogDir + 'IssueReceiptPrint.json');
    finally
      FreeAndNilJSONObject(RO);
      FreeAndNilJSONObject(JOStore);
      FreeAndNilJSONObject(JOMember);
      FreeAndNilJSONObject(JOReceipt);
      FreeAndNilJSONObject(JATeeBox);
      FreeAndNilJSONObject(JALocker);
      FreeAndNilJSONObject(JAProduct);
      FreeAndNilJSONObject(JADiscount);
      FreeAndNilJSONObject(JAPayment);
      FreeAndNilJSONObject(JO);
      FreeAndNil(SS);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('MakeReceiptJson.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.MakeReIssueReceiptJson(var AErrMsg: string): string;
begin
  Result := MakeReIssueReceiptJson('', AErrMsg);
end;
function TClientDM.MakeReIssueReceiptJson(const AReceiptNo: string; var AErrMsg: string): string;
var
  JO, RO, JOStore, JOMember, JOReceipt: TJSONObject;
  JAProduct, JADiscount, JAPayment, JATeeBox: TJSONArray;
  SS: TStringStream;
  sPayMethod, sReceiptNo, sCashierName, sMemberName, sMemberNo, sMemberHpNo, sAffiliateCode, sAffiliateName, sSaleDate, sSaleTime: string;
  nSellTotal, nDiscountTotal, nKeepAmt, nVatAmt, nPromoDCAmt, nAffiliateAmt: Integer;
begin
  Result  := '';
  AErrMsg := '';
  nSellTotal := 0;
  nDiscountTotal := 0;
  nKeepAmt := 0;
  nPromoDCAmt := 0;
  JO := TJSONObject.Create;
  JOStore := TJSONObject.Create;
  JOMember := TJSONObject.Create;
  JOReceipt := TJSONObject.Create;
  JATeeBox := TJSONArray.Create;
  JAProduct := TJSONArray.Create;
  JADiscount := TJSONArray.Create;
  JAPayment := TJSONArray.Create;
  RO := nil;
  SS := TStringStream.Create;
  try
    with MDReceiptList do
    try
      DisableControls;
      if not AReceiptNo.IsEmpty then //타석배정관리에서 영수증 재발행을 할 경우
      begin
        if not GetProdSaleNew(Global.CurrentDate, Global.CurrentDate, AErrMsg) then
          raise Exception.Create(AErrMsg);
        if not Locate('receipt_no', AReceiptNo, []) then
          raise Exception.Create('재발행 할 거래내역을 조회할 수 없습니다.');
      end;
      sReceiptNo    := FieldByName('receipt_no').AsString;
      sMemberNo     := FieldByName('member_no').AsString;
      sMemberName   := FieldByName('member_nm').AsString;
      sMemberHpNo   := FieldByName('hp_no').AsString;
      sCashierName  := FieldByName('user_nm').AsString;
      sSaleDate     := FormattedDateString(FieldByName('sale_date').AsString);
      sSaleTime     := FormattedTimeString(FieldByName('sale_time').AsString);
      sAffiliateCode:= FieldByName('affiliate_cd').AsString;
      sAffiliateName:= '';
      nAffiliateAmt := 0;
      if not sAffiliateCode.IsEmpty then
      begin
        sAffiliateName := GetAffiliateName(sAffiliateCode, '제휴사');
        nAffiliateAmt  := FieldByName('direct_dc_amt').AsInteger;
      end;
    finally
      EnableControls;
    end;
    JO.AddPair(TJSONPair.Create('StoreInfo', JOStore));
    JO.AddPair(TJSONPair.Create('OrderItems', JATeeBox));
    JO.AddPair(TJSONPair.Create('ReceiptMemberInfo', JOMember));
    JO.AddPair(TJSONPair.Create('ProductInfo', JAProduct));
    JO.AddPair(TJSONPair.Create('PayInfo', JAPayment));
    JO.AddPair(TJSONPair.Create('DiscountInfo', JADiscount));
    JO.AddPair(TJSONPair.Create('ReceiptEtc', JOReceipt));
    //매장 정보
    JOStore.AddPair(TJSONPair.Create('StoreName', SaleManager.StoreInfo.StoreName));
    JOStore.AddPair(TJSONPair.Create('BizNo', SaleManager.StoreInfo.BizNo));
    JOStore.AddPair(TJSONPair.Create('BossName', SaleManager.StoreInfo.CEO));
    JOStore.AddPair(TJSONPair.Create('Tel', SaleManager.StoreInfo.TelNo));
    JOStore.AddPair(TJSONPair.Create('Addr', SaleManager.StoreInfo.Address));
    JOStore.AddPair(TJSONPair.Create('CashierName', sCashierName));
    try
      //결제 내역
      with MDPaymentList do
      try
        DisableControls;
        First;
        while not Eof do
        begin
          RO := TJSONObject.Create;
          sPayMethod := FieldByName('pay_method').AsString;
          if (sPayMethod = CPM_CARD) then
          begin
            RO.AddPair(TJSONPair.Create('PayCode', 'Card'));
          end
          else if (sPayMethod = CPM_PAYCO_CARD) or
                  (sPayMethod = CPM_PAYCO_COUPON) or
                  (sPayMethod = CPM_PAYCO_POINT) then
          begin
            RO.AddPair(TJSONPair.Create('PayCode', 'Payco'));
          end
          else if (sPayMethod = CPM_WELFARE) then
          begin
            RO.AddPair(TJSONPair.Create('PayCode', 'Welfare'));
          end else
          begin
            RO.AddPair(TJSONPair.Create('PayCode', 'Cash'));
          end;
          RO.AddPair(TJSONPair.Create('Approval',       TJSONBool.Create(FieldByName('approval_yn').AsBoolean).ToString));
          RO.AddPair(TJSONPair.Create('Internet',       TJSONBool.Create(FieldByName('internet_yn').AsString = CRC_YES).ToString));
          RO.AddPair(TJSONPair.Create('ApprovalAmt',    TJSONNumber.Create(FieldByName('approve_amt').AsInteger)));
          RO.AddPair(TJSONPair.Create('ApprovalNo',     FieldByName('approve_no').AsString));
          RO.AddPair(TJSONPair.Create('OrgApproveNo',   FieldByName('org_approve_no').AsString));
          RO.AddPair(TJSONPair.Create('CardNo',         FieldByName('credit_card_no').AsString));
          RO.AddPair(TJSONPair.Create('HalbuMonth',     IntToStr(FieldByName('inst_mon').AsInteger)));
          RO.AddPair(TJSONPair.Create('CompanyName',    FieldByName('issuer_nm').AsString));
          RO.AddPair(TJSONPair.Create('MerchantKey',    ''));
          RO.AddPair(TJSONPair.Create('TransDateTime',  FieldByName('trade_date').AsString));
          RO.AddPair(TJSONPair.Create('BuyCompanyName', FieldByName('buyer_nm').AsString));
          RO.AddPair(TJSONPair.Create('BuyTypeName',    FieldByName('buyer_cd').AsString));
          nPromoDCAmt := (nPromoDCAmt + FieldByName('apply_dc_amt').AsInteger);
          JAPayment.Add(RO);
          Next;
        end;
      finally
        EnableControls;
      end;
      //주문 상품 내역
      with MDSaleItemList do
      try
        DisableControls;
        First;
        while not Eof do
        begin
          RO := TJSONobject.Create;
          nVatAmt := (FieldByName('product_amt').AsInteger - Trunc((FieldByName('product_amt').AsInteger / 1.1)));
          RO.AddPair(TJSONPair.Create('Name',  FieldByName('product_nm').AsString));
          RO.AddPair(TJSONPair.Create('Code',  FieldByName('product_cd').AsString));
          RO.AddPair(TJSONPair.Create('Price', TJSONNumber.Create(FieldByName('product_amt').AsInteger)));
          RO.AddPair(TJSONPair.Create('Vat',   TJSONNumber.Create(nVatAmt)));
          RO.AddPair(TJSONPair.Create('Qty',   TJSONNumber.Create(FieldByName('order_qty').AsInteger)));
          nSellTotal := nSellTotal + FieldByName('calc_sell_subtotal').AsInteger;
          nDiscountTotal := nDiscountTotal + FieldByName('calc_dc_amt').AsInteger;
          nKeepAmt := nKeepAmt + FieldByName('keep_amt').AsInteger;
          JAProduct.Add(RO);
          Next;
        end;
      finally
        EnableControls;
      end;
      //회원 정보
      with SaleManager.MemberInfo do
        if not MemberNo.IsEmpty then
        begin
          JOMember.AddPair(TJSONPair.Create('Name',         sMemberName));
          JOMember.AddPair(TJSONPair.Create('Code',         sMemberNo));
          JOMember.AddPair(TJSONPair.Create('Tel',          sMemberHpNo));
          JOMember.AddPair(TJSONPair.Create('CarNo',        CarNo));
          JOMember.AddPair(TJSONPair.Create('CardNo',       MemberQRCode));
          JOMember.AddPair(TJSONPair.Create('LockerList',   LockerList));
          JOMember.AddPair(TJSONPair.Create('ExpireLocker', FormattedDateString(ExpireLocker)));
        end;
      //결제수단별 제휴 할인
      if (nPromoDCAmt > 0) then
      begin
        RO := TJSONobject.Create;
        RO.AddPair(TJSONPair.Create('Name',   '신용카드 제휴 할인'));
        RO.AddPair(TJSONPair.Create('QRCode', ''));
        RO.AddPair(TJSONPair.Create('Value',  IntToStr(nPromoDCAmt)));
        JADiscount.Add(RO);
      end;
      //쿠폰 할인
      with MDCouponList do
      try
        DisableControls;
        First;
        while not Eof do
        begin
          RO := TJSONobject.Create;
          RO.AddPair(TJSONPair.Create('Name',   FieldByName('coupon_nm').AsString));
          RO.AddPair(TJSONPair.Create('QRCode', FieldByName('qr_code').AsString));
          RO.AddPair(TJSONPair.Create('Value', IntToStr(FieldByName('apply_dc_amt').AsInteger)));
          JADiscount.Add(RO);
          Next;
        end;
        if not sAffiliateCode.IsEmpty then
        begin
          RO := TJSONobject.Create;
          RO.AddPair(TJSONPair.Create('Name',   sAffiliateName + ' 회원 할인'));
          RO.AddPair(TJSONPair.Create('QRCode', ''));
          RO.AddPair(TJSONPair.Create('Value',  IntToStr(nAffiliateAmt)));
          JADiscount.Add(RO);
        end;
      finally
        EnableControls;
      end;
      //영수증 출력 정보
      JOReceipt.AddPair(TJSONPair.Create('RcpNo',      TJSONNumber.Create(1)));
      JOReceipt.AddPair(TJSONPair.Create('SaleDate',   sSaleDate));
      JOReceipt.AddPair(TJSONPair.Create('SaleTime',   sSaleTime));
      JOReceipt.AddPair(TJSONPair.Create('ReturnDate', ''));
      JOReceipt.AddPair(TJSONPair.Create('RePrint',    TJSONBool.Create(True).ToString)); //재출력 여부
      JOReceipt.AddPair(TJSONPair.Create('TotalAmt',   TJSONNumber.Create(nSellTotal)));
      JOReceipt.AddPair(TJSONPair.Create('DCAmt',      TJSONNumber.Create(nDiscountTotal)));
      JOReceipt.AddPair(TJSONPair.Create('KeepAmt',    TJSONNumber.Create(nKeepAmt)));
      JOReceipt.AddPair(TJSONPair.Create('ReceiptNo',  sReceiptNo));
      JOReceipt.AddPair(TJSONPair.Create('Top1',       ''));
      JOReceipt.AddPair(TJSONPair.Create('Top2',       ''));
      JOReceipt.AddPair(TJSONPair.Create('Top3',       ''));
      JOReceipt.AddPair(TJSONPair.Create('Top4',       ''));
      JOReceipt.AddPair(TJSONPair.Create('Bottom1',    ''));
      JOReceipt.AddPair(TJSONPair.Create('Bottom2',    ''));
      JOReceipt.AddPair(TJSONPair.Create('Bottom3',    ''));
      JOReceipt.AddPair(TJSONPair.Create('Bottom4',    ''));
      JOReceipt.AddPair(TJSONPair.Create('SaleUpload', CRC_NO));
      (*
      //시설이용권 출력 정보
      JOReceipt.AddPair(TJSONPair.Create('FacilityBarcode', ''));
      JOReceipt.AddPair(TJSONPair.Create('FacilityAccessName', ''));
      *)
      Result := JO.ToString;
      SS.WriteString(Result);
      SS.SaveToFile(Global.LogDir + 'ReIssueReceiptPrint.json');
    finally
      FreeAndNil(SS);
      FreeAndNilJSONObject(RO);
      FreeAndNilJSONObject(JOStore);
      FreeAndNilJSONObject(JOMember);
      FreeAndNilJSONObject(JOReceipt);
      FreeAndNilJSONObject(JATeeBox);
      FreeAndNilJSONObject(JAProduct);
      FreeAndNilJSONObject(JADiscount);
      FreeAndNilJSONObject(JAPayment);
      FreeAndNilJSONObject(JO);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('MakeReIssueReceiptJson.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.MakeCancelReceiptJson(ADataSet: TDataSet; var AErrMsg: string): string;
var
  JO, RO, JOStore, JOMember, JOReceipt: TJSONObject;
  JAProduct, JADiscount, JAPayment, JATeeBox: TJSONArray;
  SS: TStringStream;
  sPayMethod: string;
begin
  Result  := '';
  AErrMsg := '';
  JO := TJSONObject.Create;
  RO := TJSONObject.Create;
  JOStore := TJSONObject.Create;
  JOMember := TJSONObject.Create;
  JOReceipt := TJSONObject.Create;
  JATeeBox := TJSONArray.Create;
  JAProduct := TJSONArray.Create;
  JADiscount := TJSONArray.Create;
  JAPayment := TJSONArray.Create;
  SS := TStringStream.Create;
  try
    JO.AddPair(TJSONPair.Create('StoreInfo', JOStore));
    JO.AddPair(TJSONPair.Create('OrderItems', JATeeBox));
    JO.AddPair(TJSONPair.Create('ReceiptMemberInfo', JOMember));
    JO.AddPair(TJSONPair.Create('ProductInfo', JAProduct));
    JO.AddPair(TJSONPair.Create('PayInfo', JAPayment));
    JO.AddPair(TJSONPair.Create('DiscountInfo', JADiscount));
    JO.AddPair(TJSONPair.Create('ReceiptEtc', JOReceipt));
    //매장 정보
    JOStore.AddPair(TJSONPair.Create('StoreName', SaleManager.StoreInfo.StoreName));
    JOStore.AddPair(TJSONPair.Create('BizNo', SaleManager.StoreInfo.BizNo));
    JOStore.AddPair(TJSONPair.Create('BossName', SaleManager.StoreInfo.CEO));
    JOStore.AddPair(TJSONPair.Create('Tel', SaleManager.StoreInfo.TelNo));
    JOStore.AddPair(TJSONPair.Create('Addr', SaleManager.StoreInfo.Address));
    JOStore.AddPair(TJSONPair.Create('CashierName', MDReceiptList.FieldByName('user_nm').AsString));
    //결제 내역
    with TABSTable(ADataSet) do
    try
      sPayMethod := FieldByName('pay_method').AsString;
      if (sPayMethod = CPM_CARD) then
      begin
        RO.AddPair(TJSONPair.Create('PayCode', 'Card'));
      end
      else if (sPayMethod = CPM_PAYCO_CARD) or
              (sPayMethod = CPM_PAYCO_COUPON) or
              (sPayMethod = CPM_PAYCO_POINT) then
      begin
        RO.AddPair(TJSONPair.Create('PayCode', 'Payco'));
      end
      else if (sPayMethod = CPM_WELFARE) then
      begin
        RO.AddPair(TJSONPair.Create('PayCode', 'Welfare'));
      end else
      begin
        RO.AddPair(TJSONPair.Create('PayCode', 'Cash'));
      end;
      RO.AddPair(TJSONPair.Create('Approval',       TJSONBool.Create(False).ToString));
      RO.AddPair(TJSONPair.Create('Internet',       TJSONBool.Create(FieldByName('internet_yn').AsString = CRC_YES).ToString));
      RO.AddPair(TJSONPair.Create('ApprovalAmt',    TJSONNumber.Create(FieldByName('approve_amt').AsInteger)));
      RO.AddPair(TJSONPair.Create('ApprovalNo',     FieldByName('approve_no').AsString));
      RO.AddPair(TJSONPair.Create('OrgApproveNo',   FieldByName('org_approve_no').AsString));
      RO.AddPair(TJSONPair.Create('CardNo',         FieldByName('credit_card_no').AsString));
      RO.AddPair(TJSONPair.Create('HalbuMonth',     IntToStr(FieldByName('inst_mon').AsInteger)));
      RO.AddPair(TJSONPair.Create('CompanyName',    FieldByName('issuer_nm').AsString));
      RO.AddPair(TJSONPair.Create('MerchantKey',    ''));
      RO.AddPair(TJSONPair.Create('TransDateTime',  FieldByName('trade_date').AsString));
      RO.AddPair(TJSONPair.Create('BuyCompanyName', FieldByName('buyer_nm').AsString));
      RO.AddPair(TJSONPair.Create('BuyTypeName',    FieldByName('buyer_cd').AsString));
      JAPayment.Add(RO);
      Result := JO.ToString;
//      SS.WriteString(Result);
//      SS.SaveToFile(Global.LogDir + 'CancelReceiptPrint.json');
    finally
      FreeAndNil(SS);
      FreeAndNilJSONObject(RO);
      FreeAndNilJSONObject(JOStore);
      FreeAndNilJSONObject(JOMember);
      FreeAndNilJSONObject(JOReceipt);
      FreeAndNilJSONObject(JAProduct);
      FreeAndNilJSONObject(JADiscount);
      FreeAndNilJSONObject(JAPayment);
      FreeAndNilJSONObject(JATeeBox);
      FreeAndNilJSONObject(JO);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('MakeCancelReceiptJson.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.MakeTeeBoxTicketJson(var AErrMsg: string): string;
var
  JO, RO, JOStore, JOMember, JOReceipt: TJSONObject;
  JAProduct, JADiscount, JAPayment, JATeeBox, JALocker: TJSONArray;
  SS: TStringStream;
  sProdDiv, sExpireDate, sUseTime, sCouponUseDate, sReserveMoveYN, sReserveNoShowYN: string;
  nAssignMin: Integer;
begin
  Result  := '';
  AErrMsg := '';
  SS := TStringStream.Create;
  JO := TJSONObject.Create;
  JOStore := TJSONObject.Create;
  JOMember := TJSONObject.Create;
  JOReceipt := TJSONObject.Create;
  JATeeBox := TJSONArray.Create;
  JALocker := TJSONArray.Create;
  JAProduct := TJSONArray.Create;
  JADiscount := TJSONArray.Create;
  JAPayment := TJSONArray.Create;
  RO := nil;
  try
    JO.AddPair(TJSONPair.Create('StoreInfo', JOStore));
    JO.AddPair(TJSONPair.Create('OrderItems', JATeeBox));
    JO.AddPair(TJSONPair.Create('LockerItems', JALocker));
    JO.AddPair(TJSONPair.Create('ReceiptMemberInfo', JOMember));
    JO.AddPair(TJSONPair.Create('ProductInfo', JAProduct));
    JO.AddPair(TJSONPair.Create('PayInfo', JAPayment));
    JO.AddPair(TJSONPair.Create('DiscountInfo', JADiscount));
    JO.AddPair(TJSONPair.Create('ReceiptEtc', JOReceipt));
    //매장 정보
    JOStore.AddPair(TJSONPair.Create('StoreName', SaleManager.StoreInfo.StoreName));
    JOStore.AddPair(TJSONPair.Create('BizNo', SaleManager.StoreInfo.BizNo));
    JOStore.AddPair(TJSONPair.Create('BossName', SaleManager.StoreInfo.CEO));
    JOStore.AddPair(TJSONPair.Create('Tel', SaleManager.StoreInfo.TelNo));
    JOStore.AddPair(TJSONPair.Create('Addr', SaleManager.StoreInfo.Address));
    JOStore.AddPair(TJSONPair.Create('CashierName', SaleManager.UserInfo.UserName));
    try
      with MDTeeBoxIssued2 do
      try
        DisableControls;
        First;
        while not Eof do
        begin
          sCouponUseDate := '';
          sProdDiv :=  FieldByName('product_div').AsString;
          nAssignMin := FieldByName('assign_time').AsInteger;
          sUseTime := Copy(FieldByName('start_datetime').AsString, 12, 5) + '-' +
            FormatDateTime('hh:nn', IncMinute(StrToDateTime(FieldByName('start_datetime').AsString, Global.FS), nAssignMin));
          sReserveMoveYN := IIF(FieldByName('reserve_move_yn').AsBoolean, CRC_YES, CRC_NO);
          sReserveNoShowYN := IIF(FieldByName('reserve_noshow_yn').AsBoolean, CRC_YES, CRC_NO);
          sExpireDate := IIF(sProdDiv = CTP_DAILY, '', FormattedDateString(FieldByName('expire_day').AsString));
          RO := TJSONobject.Create;
          RO.AddPair(TJSONPair.Create('TeeBox_Floor',    FieldByName('floor_nm').AsString));
          RO.AddPair(TJSONPair.Create('TeeBox_No',       FieldByName('teebox_nm').AsString));
          RO.AddPair(TJSONPair.Create('UseTime',         sUseTime));
          RO.AddPair(TJSONPair.Create('OneUseTime',      IntToStr(nAssignMin)));
          RO.AddPair(TJSONPair.Create('Reserve_No',      FieldByName('reserve_no').AsString));
          RO.AddPair(TJSONPair.Create('UseProductName',  FieldByName('product_nm').AsString));
          RO.AddPair(TJSONPair.Create('Coupon',          TJSONBool.Create(sProdDiv = CTP_COUPON).ToString)); // 쿠폰 사용 여부
          RO.AddPair(TJSONPair.Create('CouponQty',       TJSONNumber.Create(FieldByName('coupon_cnt').AsInteger)));  // 잔여 쿠폰 수
          RO.AddPair(TJSONPair.Create('ExpireDate',      sExpireDate));
          RO.AddPair(TJSONPair.Create('CouponUseDate',   sCouponUseDate));
          RO.AddPair(TJSONPair.Create('ReserveMoveYN',   sReserveMoveYN));
          RO.AddPair(TJSONPair.Create('ReserveNoShowYN', sReserveNoShowYN));
          JATeeBox.Add(RO);
          Next;
        end;
      finally
        EnableControls;
      end;
      //회원 정보
      with SaleManager.MemberInfo do
        if not MemberNo.IsEmpty then
        begin
          JOMember.AddPair(TJSONPair.Create('Name',         MemberName));
          JOMember.AddPair(TJSONPair.Create('Code',         MemberNo));
          JOMember.AddPair(TJSONPair.Create('Tel',          HpNo));
          JOMember.AddPair(TJSONPair.Create('CarNo',        CarNo));
          JOMember.AddPair(TJSONPair.Create('CardNo',       MemberQRCode));
          JOMember.AddPair(TJSONPair.Create('LockerList',   LockerList));
          JOMember.AddPair(TJSONPair.Create('ExpireLocker', FormattedDateString(ExpireLocker)));
        end;
      //영수증 출력 정보
      JOReceipt.AddPair(TJSONPair.Create('RcpNo',      TJSONNumber.Create(1)));
      JOReceipt.AddPair(TJSONPair.Create('SaleDate',   Global.FormattedCurrentDate));
      JOReceipt.AddPair(TJSONPair.Create('ReturnDate', ''));
      JOReceipt.AddPair(TJSONPair.Create('RePrint',    TJSONBool.Create(False).ToString));  // 재출력 여부
      JOReceipt.AddPair(TJSONPair.Create('TotalAmt',   TJSONNumber.Create(SaleManager.ReceiptInfo.SellTotal)));
      JOReceipt.AddPair(TJSONPair.Create('DCAmt',      TJSONNumber.Create(Trunc(SaleManager.ReceiptInfo.DiscountTotal))));
      JOReceipt.AddPair(TJSONPair.Create('KeepAmt',    TJSONNumber.Create(Trunc(SaleManager.ReceiptInfo.KeepAmt))));
      JOReceipt.AddPair(TJSONPair.Create('ReceiptNo',  SaleManager.ReceiptInfo.ReceiptNo));
      JOReceipt.AddPair(TJSONPair.Create('Top1',       ''));
      JOReceipt.AddPair(TJSONPair.Create('Top2',       ''));
      JOReceipt.AddPair(TJSONPair.Create('Top3',       ''));
      JOReceipt.AddPair(TJSONPair.Create('Top4',       ''));
      JOReceipt.AddPair(TJSONPair.Create('Bottom1',    ''));
      JOReceipt.AddPair(TJSONPair.Create('Bottom2',    ''));
      JOReceipt.AddPair(TJSONPair.Create('Bottom3',    ''));
      JOReceipt.AddPair(TJSONPair.Create('Bottom4',    ''));
      JOReceipt.AddPair(TJSONPair.Create('SaleUpload', CRC_NO));
      Result := JO.ToString;
      SS.WriteString(Result);
      SS.SaveToFile(Global.LogDir + 'TeeBoxTicketPrint.json');
    finally
      FreeAndNil(SS);
      FreeAndNilJSONObject(RO);
      FreeAndNilJSONObject(JOStore);
      FreeAndNilJSONObject(JOMember);
      FreeAndNilJSONObject(JOReceipt);
      FreeAndNilJSONObject(JAProduct);
      FreeAndNilJSONObject(JADiscount);
      FreeAndNilJSONObject(JAPayment);
      FreeAndNilJSONObject(JATeeBox);
      FreeAndNilJSONObject(JALocker);
      FreeAndNilJSONObject(JO);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('MakeCancelReceiptJson.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.CheckSaleItem(var ADailyTeeBoxCount, AMemberOnlyCount: Integer; var AErrMsg: string): Boolean;
var
  BM: TBookmark;
  sProdDiv, sTeeBoxProdDiv: string;
  nOrderQty: Integer;
begin
  Result := False;
  ADailyTeeBoxCount := 0;
  AMemberOnlyCount := 0;
  AErrMsg := '';
  try
    with QRSaleItem do
    try
      BM := GetBookmark;
      DisableControls;
      First;
      while not Eof do
      begin
        sProdDiv := FieldByName('product_div').AsString;
        sTeeBoxProdDiv := FieldByName('teebox_prod_div').AsString;
        nOrderQty := FieldByName('order_qty').AsInteger;
        if (sProdDiv = CPD_TEEBOX) and
           (sTeeBoxProdDiv = CTP_DAILY) then
          Inc(ADailyTeeBoxCount, nOrderQty);
        if (sProdDiv = CPD_LOCKER) or
           ((sProdDiv = CPD_TEEBOX) and ((sTeeBoxProdDiv = CTP_COUPON) or (sTeeBoxProdDiv = CTP_TERM))) then
          Inc(AMemberOnlyCount);
        Next;
      end;
      if BookmarkValid(BM) then
        GotoBookmark(BM);
      Result := True;
    finally
      FreeBookmark(BM);
      EnableControls;
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('CheckSaleItem.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.CheckAllowedTeeBoxCoupon(const ATeeBoxProdDiv: string; var AErrMsg: string): Boolean;
var
  BM: TBookmark;
  sProdDiv, sTeeBoxProdDiv: string;
begin
  Result := False;
  AErrMsg := '쿠폰을 적용할 타석 상품이 없습니다.';
  try
    with QRSaleItem do
    try
      BM := GetBookmark;
      DisableControls;
      First;
      while not Eof do
      begin
        sProdDiv := FieldByName('product_div').AsString;
        sTeeBoxProdDiv := FieldByName('teebox_prod_div').AsString;
        if (sProdDiv = CPD_TEEBOX) and
           (sTeeBoxProdDiv = ATeeBoxProdDiv) then
        begin
          Result := True;
          AErrMsg := '';
          Break;
        end;
        Next;
      end;
      if BookmarkValid(BM) then
        GotoBookmark(BM);
    finally
      FreeBookmark(BM);
      EnableControls;
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('CheckAllowedTeeBoxCoupon.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.AddPending(const ATableNo: Integer; var AErrMsg: string): Boolean;
var
  sReceiptNo, sProdDiv, sTeeBoxProdDiv: string;
begin
  Result := False;
  AErrMsg := '';
  sReceiptNo := SaleManager.GetNewReceiptNo;
  with TABSQuery.Create(nil) do
  try
    Screen.Cursor := crSQLWait;
    DatabaseName := adbLocal.DatabaseName;
    try
      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO TBReceiptPend(receipt_no');
      SQL.Add(', table_no');
      SQL.Add(', pos_no');
      SQL.Add(', sale_date');
      SQL.Add(', sale_time');
      SQL.Add(', member_no');
      SQL.Add(', member_nm');
      SQL.Add(', xgolf_no');
      SQL.Add(', hp_no');
      SQL.Add(', total_amt');
      SQL.Add(', sale_amt');
      SQL.Add(', direct_dc_amt');
      SQL.Add(', xgolf_dc_amt');
      SQL.Add(', coupon_dc_amt');
      SQL.Add(', memo');
      SQL.Add(', user_id');
      SQL.Add(', user_nm');
      SQL.Add(Format(') VALUES (%s', [QuotedStr(sReceiptNo)]));
      SQL.Add(Format(', %d', [0]));
      SQL.Add(Format(', %s', [QuotedStr(SaleManager.StoreInfo.POSNo)]));
      SQL.Add(Format(', %s', [QuotedStr(Global.CurrentDate)]));
      SQL.Add(Format(', %s', [QuotedStr(Copy(Global.FormattedCurrentTime, 1, 5))]));
      SQL.Add(Format(', %s', [QuotedStr(SaleManager.MemberInfo.MemberNo)]));
      SQL.Add(Format(', %s', [QuotedStr(SaleManager.MemberInfo.MemberName)]));
      SQL.Add(Format(', %s', [QuotedStr(SaleManager.MemberInfo.XGolfMemberNo)]));
      SQL.Add(Format(', %s', [QuotedStr(SaleManager.MemberInfo.HpNo)]));
      SQL.Add(Format(', %d', [SaleManager.ReceiptInfo.SellTotal]));
      SQL.Add(Format(', %d', [SaleManager.ReceiptInfo.ChargeTotal]));
      SQL.Add(Format(', %d', [SaleManager.ReceiptInfo.DirectDCTotal]));
      SQL.Add(Format(', %d', [SaleManager.ReceiptInfo.XGolfDCTotal]));
      SQL.Add(Format(', %d', [SaleManager.ReceiptInfo.CouponFixedDCTotal + SaleManager.ReceiptInfo.CouponRateDCTotal]));
      SQL.Add(Format(', %s', [QuotedStr(SaleManager.ReceiptInfo.SaleMemo)]));
      SQL.Add(Format(', %s', [QuotedStr(SaleManager.UserInfo.UserId)]));
      SQL.Add(Format(', %s', [QuotedStr(SaleManager.UserInfo.UserName)]));
      SQL.Add(')');
      ExecSQL;
      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO TBSaleItemPend(receipt_no');
      SQL.Add(', table_no');
      SQL.Add(', product_div');
      SQL.Add(', teebox_prod_div');
      SQL.Add(', product_cd');
      SQL.Add(', product_nm');
      SQL.Add(', product_amt');
      SQL.Add(', order_qty');
      SQL.Add(', direct_dc_amt');
      SQL.Add(', coupon_dc_fixed_amt');
      SQL.Add(', coupon_dc_rate_amt');
      SQL.Add(', coupon_dc_amt');
      SQL.Add(', xgolf_dc_amt');
      SQL.Add(', service_yn');
      SQL.Add(', locker_no');
      SQL.Add(', purchase_month');
      SQL.Add(', keep_amt');
      SQL.Add(Format(') SELECT %s', [QuotedStr(sReceiptNo)]));
      SQL.Add(', A.table_no');
      SQL.Add(', A.product_div');
      SQL.Add(', A.teebox_prod_div');
      SQL.Add(', A.product_cd');
      SQL.Add(', A.product_nm');
      SQL.Add(', A.product_amt');
      SQL.Add(', A.order_qty');
      SQL.Add(', A.direct_dc_amt');
      SQL.Add(', A.coupon_dc_fixed_amt');
      SQL.Add(', A.coupon_dc_rate_amt');
      SQL.Add(', A.coupon_dc_amt');
      SQL.Add(', A.xgolf_dc_amt');
      SQL.Add(', A.service_yn');
      SQL.Add(', A.locker_no');
      SQL.Add(', A.purchase_month');
      SQL.Add(', A.keep_amt');
      SQL.Add(Format('FROM TBSaleItem A WHERE table_no = %d', [ATableNo]));
      ExecSQL;
      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO TBPaymentPend(receipt_no');
      SQL.Add(', table_no');
      SQL.Add(', pay_method');
      SQL.Add(', approval_yn');
      SQL.Add(', van_cd');
      SQL.Add(', tid');
      SQL.Add(', internet_yn');
      SQL.Add(', credit_card_no');
      SQL.Add(', inst_mon');
      SQL.Add(', approve_amt');
      SQL.Add(', vat');
      SQL.Add(', service_amt');
      SQL.Add(', approve_no');
      SQL.Add(', org_approve_no');
      SQL.Add(', trade_no');
      SQL.Add(', trade_date');
      SQL.Add(', issuer_cd');
      SQL.Add(', issuer_nm');
      SQL.Add(', buyer_div');
      SQL.Add(', buyer_cd');
      SQL.Add(', buyer_nm');
      SQL.Add(Format(') SELECT %s', [QuotedStr(sReceiptNo)]));
      SQL.Add(', A.table_no');
      SQL.Add(', A.pay_method');
      SQL.Add(', A.approval_yn');
      SQL.Add(', A.van_cd');
      SQL.Add(', A.tid');
      SQL.Add(', A.internet_yn');
      SQL.Add(', A.credit_card_no');
      SQL.Add(', A.inst_mon');
      SQL.Add(', A.approve_amt');
      SQL.Add(', A.vat');
      SQL.Add(', A.service_amt');
      SQL.Add(', A.approve_no');
      SQL.Add(', A.org_approve_no');
      SQL.Add(', A.trade_no');
      SQL.Add(', A.trade_date');
      SQL.Add(', A.issuer_cd');
      SQL.Add(', A.issuer_nm');
      SQL.Add(', A.buyer_div');
      SQL.Add(', A.buyer_cd');
      SQL.Add(', A.buyer_nm');
      SQL.Add(Format('FROM TBPayment A WHERE table_no = %d', [ATableNo]));
      ExecSQL;
      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO TBCouponPend(receipt_no');
      SQL.Add(', table_no');
      SQL.Add(', coupon_seq');
      SQL.Add(', qr_code');
      SQL.Add(', coupon_nm');
      SQL.Add(', dc_div');
      SQL.Add(', dc_cnt');
      SQL.Add(', start_day');
      SQL.Add(', expire_day');
      SQL.Add(', use_cnt');
      SQL.Add(', used_cnt');
      SQL.Add(', dc_cond_div');
      SQL.Add(', product_div');
      SQL.Add(', teebox_product_div');
      SQL.Add(', send_date');
      SQL.Add(', use_yn');
      SQL.Add(', event_nm');
      SQL.Add(', event_url');
      SQL.Add(', memo');
      SQL.Add(Format(') SELECT %s', [QuotedStr(sReceiptNo)]));
      SQL.Add(', A.table_no');
      SQL.Add(', A.coupon_seq');
      SQL.Add(', A.qr_code');
      SQL.Add(', A.coupon_nm');
      SQL.Add(', A.dc_div');
      SQL.Add(', A.dc_cnt');
      SQL.Add(', A.start_day');
      SQL.Add(', A.expire_day');
      SQL.Add(', A.use_cnt');
      SQL.Add(', A.used_cnt');
      SQL.Add(', A.dc_cond_div');
      SQL.Add(', A.product_div');
      SQL.Add(', A.teebox_product_div');
      SQL.Add(', A.send_date');
      SQL.Add(', A.use_yn');
      SQL.Add(', A.event_nm');
      SQL.Add(', A.event_url');
      SQL.Add(', A.memo');
      SQL.Add(Format('FROM TBCoupon A WHERE table_no = %d', [ATableNo]));
      ExecSQL;
      Result := True;
      UpdateLog(Global.LogFile, Format('AddPending(%d-%s).Success = 보류 등록', [ATableNo, sReceiptNo]));
    except
      on E: Exception do
      begin
        AErrMsg := E.Message;
        UpdateLog(Global.LogFile, Format('AddPending(%d-%s).Exception = %s', [ATableNo, sReceiptNo, AErrMsg]));
      end;
    end;
  finally
    Screen.Cursor := crDefault;
    Close;
    Free;
  end;
end;
function TClientDM.DeletePending(const AReceiptNo: string; var AErrMsg: string): Boolean;
var
  SL: TStringList;
begin
  Result := False;
  AErrMsg := '';
  SL := TStringList.Create;
  with TABSQuery.Create(nil) do
  try
    Screen.Cursor := crSQLWait;
    DatabaseName := adbLocal.DatabaseName;
    try
      Close;
      SQL.Text := Format('SELECT * FROM TBReceiptPend WHERE receipt_no = %s;', [QuotedStr(AReceiptNo)]);
      Open;
      while not Eof do
      begin
        SL.Add(Format('DeletePending(%s).TBReceiptPend(sale_date=%s, sale_time=%s, member_no=%s, member_nm=%s, total_amt=%d, sale_amt=%d, direct_dc_amt=%d, xgolf_dc_amt=%d, coupon_dc_amt=%d)',
           [FieldByName('receipt_no').AsString,
            FieldByName('sale_date').AsString,
            FieldByName('sale_time').AsString,
            FieldByName('member_no').AsString,
            FieldByName('member_nm').AsString,
            FieldByName('total_amt').AsInteger,
            FieldByName('sale_amt').AsInteger,
            FieldByName('direct_dc_amt').AsInteger,
            FieldByName('xgolf_dc_amt').AsInteger,
            FieldByName('coupon_dc_amt').AsInteger]));
        Next;
      end;
      Close;
      SQL.Clear;
      SQL.Text := Format('SELECT * FROM TBPaymentPend WHERE receipt_no = %s', [QuotedStr(AReceiptNo)]);
      Open;
      while not Eof do
      begin
        SL.Add(Format('DeletePending(%s).TBPaymentPend(approval_yn=%s, pay_method=%s, internet_yn=%s, credit_card_no=%s, approve_amt=%d, approve_no=%s, org_approve_no=%s)',
          [ FieldByName('receipt_no').AsString,
            FieldByName('approval_yn').AsString,
            FieldByName('pay_method').AsString,
            FieldByName('internet_yn').AsString,
            FieldByName('credit_card_no').AsString,
            FieldByName('approve_amt').AsInteger,
            FieldByName('approve_no').AsString,
            FieldByName('org_approve_no').AsString]));
        Next;
      end;
      Close;
      SQL.Clear;
      SQL.Add(Format('DELETE FROM TBCouponPend WHERE receipt_no = %s;', [QuotedStr(AReceiptNo)]));
      SQL.Add(Format('DELETE FROM TBPaymentPend WHERE receipt_no = %s;', [QuotedStr(AReceiptNo)]));
      SQL.Add(Format('DELETE FROM TBSaleItemPend WHERE receipt_no = %s;', [QuotedStr(AReceiptNo)]));
      SQL.Add(Format('DELETE FROM TBReceiptPend WHERE receipt_no = %s;', [QuotedStr(AReceiptNo)]));
      ExecSQL;
      Result := True;
      for var I := 0 to Pred(SL.Count) do
        UpdateLog(Global.LogFile, SL[I]);
      UpdateLog(Global.LogFile, Format('DeletePending(%s).Success = 보류내역 삭제', [AReceiptNo]));
    except
      on E: Exception do
      begin
        AErrMsg := E.Message;
        UpdateLog(Global.LogFile, Format('DeletePending(%s).Exception = %s', [AReceiptNo, AErrMsg]));
      end;
    end;
  finally
    Screen.Cursor := crDefault;
    FreeAndNil(SL);
    Close;
    Free;
  end;
end;
function TClientDM.LoadPending(const AReceiptNo: string; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := '';
  with TABSQuery.Create(nil) do
  try
    try
      DatabaseName := adbLocal.DatabaseName;
      SQL.Add(Format('INSERT INTO TBReceipt SELECT * FROM TBReceiptPend WHERE receipt_no = %s;', [QuotedStr(AReceiptNo)]));
      SQL.Add(Format('INSERT INTO TBSaleItem SELECT * FROM TBSaleItemPend WHERE receipt_no = %s AND product_div <> %s AND teebox_prod_div <> %s;',
        [QuotedStr(AReceiptNo), QuotedStr(CPD_TEEBOX), QuotedStr(CTP_DAILY)]));
      SQL.Add(Format('INSERT INTO TBPayment SELECT * FROM TBPaymentPend WHERE receipt_no = %s;', [QuotedStr(AReceiptNo)]));
      SQL.Add(Format('INSERT INTO TBCoupon SELECT * FROM TBCouponPend WHERE receipt_no = %s;', [QuotedStr(AReceiptNo)]));
      ExecSQL;
      Result := True;
    except
      on E: Exception do
      begin
        AErrMsg := E.Message;
        UpdateLog(Global.LogFile, Format('LoadPending.Exception = %s', [E.Message]));
      end;
    end;
  finally
    Close;
    Free;
  end;
end;
procedure TClientDM.RefreshActiveGroupTableList(const ATableNo: Integer);
var
  nGroupNo: Integer;
begin
  nGroupNo := 0;
  Global.TableInfo.ActiveGroupTableList.Clear;
  with TABSQuery.Create(nil) do
  try
    DatabaseName := adbLocal.DatabaseName;
    SQL.Text := Format('SELECT group_no FROM TBReceipt WHERE table_no = %d', [ATableNo]);
    Open;
    if (RecordCount > 0) then
      nGroupNo := FieldByName('group_no').AsInteger;
    if (nGroupNo > 0) then
    begin
      Close;
      SQL.Text := Format('SELECT table_no FROM TBReceipt WHERE group_no = %d', [nGroupNo]);
      Open;
      while not Eof do
      begin
        Global.TableInfo.ActiveGroupTableList.Add(FieldByName('table_no').AsString);
        Next;
      end;
    end;
  finally
    Close;
    Free;
  end;
end;
procedure TClientDM.RefreshReceiptTable(const ATableNo: Integer; const ADelimitedGroupTableList: string);
var
  BM: TBookmark;
begin
  with QRReceipt do
  begin
    BM := GetBookmark;
    try
      DisableControls;
      Close;
      if ADelimitedGroupTableList.IsEmpty then
        SQL.Text := Format('SELECT * FROM TBReceipt WHERE table_no = %d', [ATableNo])
      else
        SQL.Text := Format('SELECT * FROM TBReceipt WHERE table_no IN (%s)', [Global.TableInfo.DelimitedGroupTableList]);
      Open;
      if BookmarkValid(BM) then
        GotoBookmark(BM);
    finally
      FreeBookmark(BM);
      EnableControls;
    end;
  end;
end;
procedure TClientDM.RefreshSaleItemTable(const ATableNo: Integer; const ADelimitedGroupTableList: string);
var
  BM: TBookmark;
  sErrMsg: string;
begin
  with QRSaleItem do
  begin
    BM := GetBookmark;
    try
      DisableControls;
      Close;
      if ADelimitedGroupTableList.IsEmpty then
        SQL.Text := Format('SELECT * FROM TBSaleItem WHERE table_no = %d', [ATableNo])
      else
        SQL.Text := Format('SELECT * FROM TBSaleItem WHERE table_no IN (%s)', [ADelimitedGroupTableList]);
      Open;
      if BookmarkValid(BM) then
        GotoBookmark(BM);
    finally
      FreeBookmark(BM);
      EnableControls;
    end;
  end;
end;
procedure TClientDM.RefreshPaymentTable(const ATableNo: Integer; const ADelimitedGroupTableList: string);
var
  BM: TBookmark;
begin
  with QRPayment do
  begin
    BM := GetBookmark;
    try
      DisableControls;
      Close;
      if ADelimitedGroupTableList.IsEmpty then
        SQL.Text := Format('SELECT * FROM TBPayment WHERE table_no = %d', [ATableNo])
      else
        SQL.Text := Format('SELECT * FROM TBPayment WHERE table_no IN (%s)', [ADelimitedGroupTableList]);
      Open;
      if BookmarkValid(BM) then
        GotoBookmark(BM);
    finally
      FreeBookmark(BM);
      EnableControls;
    end;
  end;
end;
procedure TClientDM.RefreshCouponTable(const ATableNo: Integer; const ADelimitedGroupTableList: string);
var
  BM: TBookmark;
  sErrMsg: string;
begin
  with QRCoupon do
  begin
    BM := GetBookmark;
    try
      DisableControls;
      Close;
      if ADelimitedGroupTableList.IsEmpty then
        SQL.Text := Format('SELECT * FROM TBCoupon WHERE table_no = %d', [ATableNo])
      else
        SQL.Text := Format('SELECT * FROM TBCoupon WHERE table_no IN (%s)', [ADelimitedGroupTableList]);
      Open;
      if BookmarkValid(BM) then
        GotoBookmark(BM);
    finally
      FreeBookmark(BM);
      EnableControls;
    end;
  end;
end;
procedure TClientDM.RefreshSaleTables(const ATableNo: Integer; const ADelimitedGroupTableList: string);
begin
  RefreshReceiptTable(ATableNo);
  RefreshSaleItemTable(ATableNo, ADelimitedGroupTableList);
  RefreshPaymentTable(ATableNo, ADelimitedGroupTableList);
  RefreshCouponTable(ATableNo, ADelimitedGroupTableList);
end;
procedure TClientDM.ClearReceiptTable(const ATableNo: Integer; const ADelimitedGroupTableList: string);
begin
  try
    if ADelimitedGroupTableList.IsEmpty then
      ExecuteABSQuery(Format('DELETE FROM TBReceipt WHERE table_no = %d', [ATableNo]))
    else
      ExecuteABSQuery(Format('DELETE FROM TBReceipt WHERE table_no IN (%s)', [ADelimitedGroupTableList]));
  finally
    RefreshReceiptTable(ATableNo);
  end;
end;
procedure TClientDM.ClearSaleItemTable(const ATableNo: Integer; const ADelimitedGroupTableList: string);
begin
  try
    if ADelimitedGroupTableList.IsEmpty then
      ExecuteABSQuery(Format('DELETE FROM TBSaleItem WHERE table_no = %d', [ATableNo]))
    else
      ExecuteABSQuery(Format('DELETE FROM TBSaleItem WHERE table_no IN (%s)', [ADelimitedGroupTableList]));
  finally
    RefreshSaleItemTable(ATableNo);
  end;
end;
procedure TClientDM.ClearPaymentTable(const ATableNo: Integer; const ADelimitedGroupTableList: string);
begin
  try
    if ADelimitedGroupTableList.IsEmpty then
      ExecuteABSQuery(Format('DELETE FROM TBPayment WHERE table_no = %d', [ATableNo]))
    else
      ExecuteABSQuery(Format('DELETE FROM TBPayment WHERE table_no IN (%s)', [ADelimitedGroupTableList]));
  finally
    RefreshpaymentTable(ATableNo);
  end;
end;
procedure TClientDM.ClearCouponTable(const ATableNo: Integer; const ADelimitedGroupTableList: string);
begin
  try
    if ADelimitedGroupTableList.IsEmpty then
      ExecuteABSQuery(Format('DELETE FROM TBCoupon WHERE table_no = %d', [ATableNo]))
    else
      ExecuteABSQuery(Format('DELETE FROM TBCoupon WHERE table_no IN (%s)', [ADelimitedGroupTableList]));
  finally
    RefreshCouponTable(ATableNo);
  end;
end;
procedure TClientDM.ClearSaleTables(const ATableNo: Integer; const ADelimitedGroupTableList: string);
begin
  ClearReceiptTable(ATableNo, ADelimitedGroupTableList);
  ClearSaleItemTable(ATableNo, ADelimitedGroupTableList);
  ClearPaymentTable(ATableNo, ADelimitedGroupTableList);
  ClearCouponTable(ATableNo, ADelimitedGroupTableList);
  if (SaleManager.StoreInfo.POSType in [CPO_SALE_TEEBOX, CPO_SALE_LESSON_ROOM]) then
    ClearMemData(MDTeeBoxIssued);
end;
procedure TClientDM.ClearMemberInfo(const ATargetID: Integer);
begin
  with TPluginMessage.Create(nil) do
  try
    try
      SaleManager.MemberInfo.Clear;
      Command := CPC_SEND_MEMBER_CLEAR;
      PluginMessageToID(ATargetID);
    except
      on E: Exception do
        UpdateLog(Global.LogFile, Format('ClearMemberInfo.Exception = %s', [E.Message]));
    end;
  finally
    Free;
  end;
end;
procedure TClientDM.SetMemberInfo(ADataSet: TDataSet; const AUsePhoto: Boolean);
begin
  with ADataSet do
  begin
    SaleManager.MemberInfo.MemberNo          := FieldByName('member_no').AsString;
    SaleManager.MemberInfo.MemberSeq         := FieldByName('member_seq').AsInteger;
    SaleManager.MemberInfo.MemberQRCode      := FieldByName('qr_cd').AsString;
    SaleManager.MemberInfo.MemberName        := FieldByName('member_nm').AsString;
    SaleManager.MemberInfo.CustomerCode      := FieldByName('customer_cd').AsString;
    SaleManager.MemberInfo.MemberCardUID     := FieldByName('member_card_uid').AsString;
    SaleManager.MemberInfo.WelfareCode       := FieldByName('welfare_cd').AsString;
    SaleManager.MemberInfo.WelfarePoint      := FieldByName('member_point').AsInteger;
    SaleManager.MemberInfo.WelfareRate       := FieldByName('dc_rate').AsInteger;
    SaleManager.MemberInfo.HpNo              := FieldByName('hp_no').AsString;
    SaleManager.MemberInfo.CarNo             := FieldByName('car_no').AsString;
    SaleManager.MemberInfo.LockerNo          := FieldByName('locker_no').AsInteger;
    SaleManager.MemberInfo.LockerName        := FieldByName('locker_nm').AsString;
    SaleManager.MemberInfo.LockerList        := FieldByName('locker_list').AsString;
    SaleManager.MemberInfo.ExpireLocker      := FieldByName('expire_locker').AsString;
    SaleManager.MemberInfo.SexDiv            := StrToIntDef(FieldByName('sex_div').AsString, CSD_SEX_ALL);
    SaleManager.MemberInfo.XGolfMemberNo     := FieldByName('xg_user_key').AsString;
    SaleManager.MemberInfo.SpecialYN         := FieldByName('special_yn').AsBoolean;
    SaleManager.MemberInfo.SpectrumCustId    := FieldByName('spectrum_cust_id').AsString;
    SaleManager.MemberInfo.Memo              := FieldByName('memo').AsString;
    SaleManager.MemberInfo.PhotoStream.Clear;
    if AUsePhoto then
      TBlobField(FieldByName('photo')).SaveToStream(SaleManager.MemberInfo.PhotoStream);
  end;
end;
//procedure TClientDM.PaymentCancelUpdate(const APayMethod, AOrgApproveNo, AOrgApproveDate, AApproveNo: string);
//var
//  BM: TBookmark;
//  sReturnDate: string;
//begin
//  sReturnDate := Global.CurrentDate;
//  with MDPaymentList do
//  try
//    BM := GetBookmark;
//    DisableControls;
//    First;
//    while not Eof do
//    begin
//      if (FieldByName('pay_method').AsString = APayMethod) and
//         (FieldByName('approve_no').AsString = AOrgApproveNo) and
//         (FieldByName('trade_date').AsString = AOrgApproveDate) and
//         (FieldByName('approval_yn').AsString = CRC_YES) then
//      begin
//        Edit;
//        FieldValues['approval_yn'] := CRC_NO;
//        FieldValues['approve_no'] := AApproveNo;
//        FieldValues['trade_date'] := sReturnDate;
//        FieldValues['org_approve_no'] := AOrgApproveNo;
//        Post;
//      end;
//
//      Next;
//    end;
//
//    if BookmarkValid(BM) then
//      GotoBookmark(BM);
//  finally
//    FreeBookmark(BM);
//    EnableControls;
//  end;
//end;
procedure TClientDM.PaymentCancelUpdate(const APayMethod, AOrgApproveNo, AOrgApproveDate, AApproveNo: string);
var
  sReturnDate: string;
begin
  with MDPaymentList do
    if (FieldByName('approval_yn').AsString = CRC_YES) and
       (FieldByName('pay_method').AsString = APayMethod) and
       (FieldByName('approve_no').AsString = AOrgApproveNo) and
       (FieldByName('trade_date').AsString = AOrgApproveDate) then
    begin
      sReturnDate := Global.CurrentDate;
      Edit;
      FieldValues['approval_yn'] := CRC_NO;
      FieldValues['approve_no'] := AApproveNo;
      FieldValues['trade_date'] := sReturnDate;
      FieldValues['org_approve_no'] := AOrgApproveNo;
      Post;
    end;
end;
//할인쿠폰 확인
function TClientDM.GetCouponInfo(const ACouponCode: string; var AErrMsg: string): Boolean;
const
  CS_API = 'K604_CheckCoupon';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  PM: TPluginMessage;
  JO1, JO2: TJSONObject;
  SS: TStringStream;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  JO1 := nil;
  JO2 := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SS := TStringStream.Create;
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    try
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'GET';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s?store_cd=%s&member_no=%s&coupon_cd=%s',
        [Global.ClientConfig.Host, CS_API, SaleManager.StoreInfo.StoreCode, SaleManager.MemberInfo.MemberNo, ACouponCode]);
      HC.Get(sUrl, SS);
      SS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(SS.Memory);
      SetCodePage(RBS, 65001, False);
      JO1 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO1.GetValue('result_cd').Value;
      sResMsg := JO1.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      if not (JO1.FindValue('result_data') is TJSONNull) then
      begin
        JO2 := JO1.GetValue('result_data') as TJSONObject;
        PM := TPluginMessage.Create(nil);
        try
          with CouponRec do
          begin
            QrCode        := JO2.GetValue('qr_code').Value;
            CouponName    := JO2.GetValue('coupon_nm').Value;
            DcDiv         := JO2.GetValue('dc_div').Value;
            DcCnt         := StrToIntDef(JO2.GetValue('dc_cnt').Value, 0);
            MemberNo      := JO2.GetValue('member_no').Value;
            StartDay      := JO2.GetValue('start_day').Value;
            ExpireDay     := JO2.GetValue('expire_day').Value;
            UseCnt        := StrToIntDef(JO2.GetValue('use_cnt').Value, 0);
            UsedCnt       := StrToIntDef(JO2.GetValue('used_cnt').Value, 0);
            EventName     := JO2.GetValue('event_nm').Value;
            DcCondDiv     := JO2.GetValue('dc_cond_div').Value;
            ProductDiv    := JO2.GetValue('product_div').Value;
            TeeBoxProdDiv := JO2.GetValue('seat_product_div').Value;
            UseYN         := JO2.GetValue('use_yn').Value;
            UseStatus     := IIF(UseYN=CRC_YES, '사용완료', IIF(UseYN=CRC_USING, '사용중', IIF(UseYN=CRC_NO, '미사용', '')));
          end;
          PM.Command := CPC_SEND_COUPON_INFO;
          PM.PluginMessageToID(Global.SaleFormId);
        finally
          FreeAndNil(PM);
        end;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JO1);
      FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetCouponInfo.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.ApplyCouponDiscount(const ATableNo: Integer; var AErrMsg: string): Integer;
var
  nProdAmt, nXGolfDCAmt, nDCAmt, nDCSum, nRecord: Integer;
  sProdDiv, sProdCd, sQuery, sWhere: string;
begin
  Result := 0;
  AErrMsg := '';
  CouponRec.ApplyDcAmt := 0;
  with TABSQuery.Create(nil) do
  try
    Screen.Cursor := crSQLWait;
    try
      DatabaseName := adbLocal.DatabaseName;
      SQL.Clear;
      SQL.Add('SELECT * FROM TBSaleItem');
      sWhere := Format('WHERE table_no = %d', [ATableNo]);
      SQL.Add(sQuery);
      if (CouponRec.ProductDiv = CPD_TEEBOX) or
         (CouponRec.ProductDiv = CPD_LOCKER) or
         (CouponRec.ProductDiv = CPD_GENERAL) or
         (CouponRec.ProductDiv = CPD_FACILITY) then //상품구분(S:타석, L:라커, G:일반, A:부대시설)
      begin
        sQuery := 'AND product_div = ' + QuotedStr(CouponRec.ProductDiv);
        sWhere := sWhere + _CRLF + sQuery;
        SQL.Add(sWhere);
        if (CouponRec.ProductDiv = CPD_TEEBOX) and
           ((CouponRec.TeeBoxProdDiv = CTP_DAILY) or
            (CouponRec.TeeBoxProdDiv = CTP_COUPON) or
            (CouponRec.TeeBoxProdDiv = CTP_TERM)) then //타석상품구분(D:일일, C:쿠폰, R:기간)
        begin
          sQuery := 'AND teebox_prod_div = ' + QuotedStr(CouponRec.TeeBoxProdDiv);
          sWhere := sWhere + _CRLF + sQuery;
          SQL.Add(sQuery);
        end;
      end;
      SQL.Add('ORDER BY product_amt DESC;');
      Open;
      SQL.SaveToFile(Global.LogDir + 'ApplyCoupon_Select.sql');
      First;
      nRecord := RecordCount;
      if (nRecord = 0) then
        raise Exception.Create('할인 적용이 가능한 상품이 없습니다!');
      if (CouponRec.DcDiv = CDD_PERCENT) then //정율쿠폰
      begin
        sProdDiv    := FieldByName('product_div').AsString;
        sProdCd     := FieldByName('product_cd').AsString;
        nDCAmt      := FieldByName('coupon_dc_rate_amt').AsInteger;
        nXGolfDCAmt := FieldByName('xgolf_dc_amt').AsInteger;
        nProdAmt    := FieldByName('product_amt').AsInteger;
        //할인 적용이 가능할 경우에만
        if (nProdAmt <= nDCAmt) then
          raise Exception.Create('정율 할인구폰은 더 이상 적용할 수 없습니다!');
        Inc(Result);
        //엑스골프 회원할인금액을 뺀 금액에서 추가 할인
        if (nXGolfDCAmt > 0) then
          nProdAmt := (nProdAmt - nXGolfDCAmt);
        nDCAmt := (nProdAmt * CouponRec.DcCnt) div 100;
        if (nDCAmt > nProdAmt) then
          nDcAmt := nProdAmt;
        CouponRec.ApplyDcAmt := nDcAmt;
        if not ExecuteABSQuery('UPDATE TBSaleItem' + _CRLF +
            Format('SET coupon_dc_rate_amt = (coupon_dc_rate_amt + %d), coupon_dc_amt = (coupon_dc_fixed_amt + %d)', [nDCAmt, nDCAmt]) + _CRLF +
            Format('WHERE table_no = %d AND product_div = %s AND product_cd = %s', [ATableNo, QuotedStr(sProdDiv), QuotedStr(sProdCd)]),
            AErrMsg) then
          raise Exception.Create(AErrMsg);
      end
      else if (CouponRec.DcDiv = CDD_FIXED_AMT) then //정액쿠폰
      begin
        nDCSum := 0;
        nDCAmt := (CouponRec.DcCnt div nRecord);
        CouponRec.ApplyDcAmt := 0;
        while not Eof do
        begin
          Inc(Result);
          sProdDiv := FieldByName('product_div').AsString;
          sProdCd  := FieldByName('product_cd').AsString;
          nDCSum   := (nDCSum + nDCAmt);
          //정액할인을 품목수 만큼 나누었을 때 차액이 있다면 가장 마지막 품목에 차액을 더함
          if (Result = nRecord) and
             (nDCSum < CouponRec.DcCnt) then
            nDCAmt := nDCAmt + (CouponRec.DcCnt - nDCSum);
          CouponRec.ApplyDcAmt := (CouponRec.ApplyDcAmt + nDCAmt);
          if not ExecuteABSQuery('UPDATE TBSaleItem' + _CRLF +
              Format('SET coupon_dc_fixed_amt = (coupon_dc_fixed_amt + %d), coupon_dc_amt = (coupon_dc_rate_amt + %d)' + _CRLF +
                     '%s AND product_div = %s AND product_cd = %s',
                [nDCAmt, nDCAmt, sWhere, QuotedStr(sProdDiv), QuotedStr(sProdCd)]),
              AErrMsg) then
            raise Exception.Create(AErrMsg);
          Next;
        end;
      end;
      if not ExecuteABSQuery(
          Format('UPDATE TBCoupon SET apply_dc_amt = %d WHERE table_no = %d AND qr_code = %s', [
            CouponRec.ApplyDcAmt,
            ATableNo,
            QuotedStr(CouponRec.QrCode)]),
          AErrMsg) then
        raise Exception.Create(AErrMsg);
    finally
      Screen.Cursor := crDefault;
      Close;
      Free;
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('ApplyCouponDiscount.Exception = %s', [E.Message]));
    end;
  end;
end;
//할인쿠폰 적용결과 갱신
procedure TClientDM.AddDiscountCoupon(const ATableNo: Integer);
var
  sErrMsg: string;
begin
  try
    if not ExecuteABSQuery(
        'INSERT INTO TBCoupon (table_no, qr_code, coupon_nm, dc_div, dc_cnt, apply_dc_amt, start_day, expire_day, ' +
          'use_cnt, used_cnt, dc_cond_div, product_div, teebox_product_div, use_yn, event_nm)' + _CRLF +
        Format('VALUES (%d, %s, %s, %s, %d, %d, %s, %s, %d, %d, %s, %s, %s, %s, %s)', [
          ATableNo, //테이블번호
          QuotedStr(CouponRec.QrCode), //쿠폰일련번호
          QuotedStr(CouponRec.CouponName), //쿠폰명
          QuotedStr(CouponRec.DcDiv), //할인구분(정액할인:A, 정률할인:R)
          CouponRec.DcCnt, //할인금액(정액) 또는 할인율(정률)
          0, //할인적용금액
          QuotedStr(CouponRec.StartDay), //시작일
          QuotedStr(CouponRec.ExpireDay), //만기일
          CouponRec.UseCnt, //사용가능 횟수
          CouponRec.UsedCnt, //사용한 횟수
          QuotedStr(CouponRec.DcCondDiv), //중복할인 허용여부 (1:중복할인, 2:단독할인)
          QuotedStr(CouponRec.ProductDiv), //할인적용상품구분 (전체상품:A, 타석상품:S, 일반상품:G, 라카상품:L)
          QuotedStr(CouponRec.TeeBoxProdDiv), //타석상품구분 (전체:A, 기간:R, 쿠폰:C, 일일입장:D)
          QuotedStr(CouponRec.UseYN), //사용여부 (사용완료:Y, 사용중:M, 미사용:N)
          QuotedStr(CouponRec.EventName)]), //이벤트명
        sErrMsg) then
      raise Exception.Create(sErrMsg);
  except
    on E: Exception do
      UpdateLog(Global.LogFile, Format('AddDiscountCoupon.Exception = %s', [E.Message]));
  end;
end;
//할인쿠폰 재계산
function TClientDM.ReCalcCouponDiscount(const ATableNo: Integer; var AErrMsg: string): Boolean;
var
  sErrMsg: string;
begin
  Result := False;
  try
    if not ExecuteABSQuery(
        Format('UPDATE TBSaleItem SET coupon_dc_amt = 0, coupon_dc_fixed_amt = 0, coupon_dc_rate_amt = 0 WHERE table_no = %d', [ATableNo]),
        AErrMsg) then
      raise Exception.Create(AErrMsg);
    with TABSQuery.Create(nil) do
    try
      DatabaseName := adbLocal.DatabaseName;
      SQL.Text := Format('SELECT * FROM TBCoupon WHERE table_no = %d ORDER BY dc_div DESC, dc_cnt DESC', [ATableNo]);
      Open;
      First;
      while not Eof do
      begin
        CouponRec.Clear;
        CouponRec.QrCode        := FieldByName('qr_code').AsString;
        CouponRec.CouponName    := FieldByName('coupon_nm').AsString;
        CouponRec.DcDiv         := FieldByName('dc_div').AsString;
        CouponRec.DcCnt         := FieldByName('dc_cnt').AsInteger;
        CouponRec.StartDay      := FieldByName('start_day').AsString;
        CouponRec.ExpireDay     := FieldByName('expire_day').AsString;
        CouponRec.UseCnt        := FieldByName('use_cnt').AsInteger;
        CouponRec.UsedCnt       := FieldByName('used_cnt').AsInteger;
        CouponRec.DcCondDiv     := FieldByName('dc_cond_div').AsString;
        CouponRec.ProductDiv    := FieldByName('product_div').AsString;
        CouponRec.TeeBoxProdDiv := FieldByName('teebox_product_div').AsString;
        CouponRec.UseYN         := FieldByName('use_yn').AsString;
        CouponRec.EventName     := FieldByName('event_nm').AsString;
        if (ApplyCouponDiscount(ATableNo, sErrMsg) = 0) then
          raise Exception.Create(sErrMsg);
        Next;
      end;
    finally
      Close;
      Free;
    end;
    Result := True;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('ReCalcCouponDiscount.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.DoPaymentPAYCO(const AIsApproval, AIsSaleMode: Boolean; var AErrMsg: string): Boolean;
var
  SaleItemDataSet, PaymentDataSet: TDataSet;
  SI: TPaycoNewSendInfo;
  RI: TPaycoNewRecvInfo;
  sGoodsName, sGoodsList: string;
  nIndex, nPaycoAmt, nVatAmt: Integer;
begin
  AErrMsg := '';
  Result := False;
  if AIsSaleMode then
  begin
    SaleItemDataSet := QRSaleItem;
    PaymentDataSet := QRPayment;
  end else
  begin
    SaleItemDataSet := MDSaleItemList;
    PaymentDataSet := MDPaymentList;
  end;
  Screen.Cursor := crSQLWait;
  SaleManager.ReceiptInfo.PaycoReady := True;
  try
    try
      if AIsApproval then
      begin
        nPaycoAmt := SaleManager.ReceiptInfo.UnPaidTotal;
        SI.TerminalID :=  SaleManager.StoreInfo.CreditTID
      end
      else
      begin
        nPaycoAmt := PaymentDataSet.FieldByName('approve_amt').AsInteger;
        SI.OrgAgreeNo := PaymentDataSet.FieldByName('approve_no').AsString;
        SI.OrgAgreeDate := PaymentDataSet.FieldByName('trade_date').AsString;
        SI.TerminalID := PaymentDataSet.FieldByName('tid').AsString;
      end;
      nVatAmt := (nPaycoAmt - Trunc(nPaycoAmt / 1.1));
      SI.BizNo := SaleManager.StoreInfo.BizNo;
      SI.SerialNo := SaleManager.StoreInfo.CreditTID;
      SI.VanName := SaleManager.StoreInfo.VANCode;
      SI.Approval := AIsApproval;
      SI.PayAmt := nPaycoAmt;
      SI.TaxAmt := nVatAmt;
      SI.DutyAmt := (SI.PayAmt - nVatAmt);
      SI.FreeAmt := 0;
      SI.TipAmt := 0;
      SI.PointAmt := 0;
      SI.CouponAmt := 0;
      SI.ServiceType := '';
      SI.ApprovalAmount := (SI.PayAmt - SI.PointAmt - SI.CouponAmt);
      sGoodsName := '';
      sGoodsList := '';
      nIndex     := 0;
      with SaleItemDataSet do
      try
        DisableControls;
        First;
        while not Eof do
        begin
          if (nIndex = 0) then
            sGoodsName := '상품' + IntToStr(Succ(nIndex))
          else
            sGoodsList := sGoodsList + _SOH;
          sGoodsList := sGoodsList + '001' + _SOH + '상품' + IntToStr(Succ(nIndex)) + _SOH +
            IntToStr(FieldByName('calc_charge_amt').AsInteger) + _SOH + IntToStr(FieldByName('order_qty').AsInteger);
          sGoodsList := sGoodsList + _SOH + CRC_YES;
          Inc(nIndex);
          Next;
        end;
      finally
        EnableControls;
      end;
      PaycoModule.GoodsName := sGoodsName;
      PaycoModule.GoodsList := sGoodsList;
      RI := PaycoModule.ExecPayProc(SI);
      if not RI.Result then
        raise Exception.Create(RI.Msg);
      if AIsSaleMode then
      begin
        if AIsApproval then
        begin
          SaleManager.PayLog(AIsApproval, False, CPM_PAYCO_CARD, RI.RevCardNo, RI.AgreeNo, nPaycoAmt);
          SaleManager.ReceiptInfo.CardPayAmt := (SaleManager.ReceiptInfo.CardPayAmt + nPaycoAmt);
        end
        else
          SaleManager.ReceiptInfo.CardPayAmt := (SaleManager.ReceiptInfo.CardPayAmt - nPaycoAmt);
        UpdatePayment(
          Global.TableInfo.ActiveTableNo,
          AIsApproval, //Approval
          AIsSaleMode, //실시간 판매상태 여부(거래내역 조회 시에는 False)
          False, //ADeleteExists
          CPM_PAYCO_CARD, //APayMethod
          SaleManager.StoreInfo.VANCode, //AVan
          SaleManager.StoreInfo.PaycoTID, //ATid
          CRC_YES, //AInternetYN
          RI.RevCardNo, //ACreditCardNo
          RI.AgreeNo, //AApproveNo
          SI.OrgAgreeNo, //AOrgApproveNo,
          SI.OrgAgreeDate, //AOrgApproveDate,
          RI.TradeNo, //ATradeNo
          RI.TransDateTime, //ATradeDate
          RI.ApprovalCompanyCode, //AIssuerCode
          RI.ApprovalCompanyName, //AISsuerName
          '', //ABuyerDiv
          RI.BuyCompanyCode, //ABuyerCode
          RI.BuyCompanyName, //ABuyerName
          StrToIntDef(RI.HalbuMonth, 0), //AInstMonth
          Trunc(SI.PayAmt), //AApproveAmt
          nVatAmt, //AVat
          0, //AServiceAmt;
          0, //카드사 프로모션 코드
          0, //카드사 프로모션 할인 금액
          ''); //카드사 프로모션 구분(P: 카드사 즉시할인 등)
      end;
      Result := True;
    except
      on E: Exception do
      begin
        AErrMsg := E.Message;
        UpdateLog(Global.LogFile, Format('DoPaymentPAYCO(%s).Exception = %s', [BoolToStr(AIsApproval), AErrMsg]));
      end;
    end;
  finally
    SaleManager.ReceiptInfo.PaycoReady := False;
    Screen.Cursor := crDefault;
  end;
end;
//주차관제 정기권 등록
function TClientDM.AddParking(const AVender: Integer; const APurchaseCode, ACarNo, AMemberName, AWeekInfo: string;
  const AStartDate, AEndDate: TDateTime; var AErrMsg: string): Boolean;
var
  sWeekInfo, sQuery: string;
begin
  Result := False;
  AErrMsg := '';
  try
    case AVender of
      CPV_HANIL: //한일테크닉스
      begin
        sWeekInfo := '';
        sWeekInfo := sWeekInfo + IIF(Copy(AWeekInfo, 7, 1) = '1', '일', '');
        sWeekInfo := sWeekInfo + IIF(Copy(AWeekInfo, 1, 1) = '1', '월', '');
        sWeekInfo := sWeekInfo + IIF(Copy(AWeekInfo, 2, 1) = '1', '화', '');
        sWeekInfo := sWeekInfo + IIF(Copy(AWeekInfo, 3, 1) = '1', '수', '');
        sWeekInfo := sWeekInfo + IIF(Copy(AWeekInfo, 4, 1) = '1', '목', '');
        sWeekInfo := sWeekInfo + IIF(Copy(AWeekInfo, 5, 1) = '1', '금', '');
        sWeekInfo := sWeekInfo + IIF(Copy(AWeekInfo, 6, 1) = '1', '토', '');
        with TUniQuery.Create(nil) do
        try
          Screen.Cursor := crSQLWait;
          Connection := conParking;
          if not conParking.Connected then
            conParking.Connected := True;
          sQuery := Format(
            'INSERT INTO fix_car(no, car_num, name, start_day, end_day, gate_sel, week, nouse) VALUES (%s, %s, %s, %s, %s, %s, %s, %s);', [
              QuotedStr(APurchaseCode),
              QuotedStr(ACarNo),
              QuotedStr(AMemberName),
              QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss', AStartDate)),
              QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss', AEndDate)),
              QuotedStr('123456789abc'),
              QuotedStr(sWeekInfo),
              QuotedStr('F')]);
          WriteToFile(Global.LogDir + 'AddParking.sql', sQuery, True);
          SQL.Add('INSERT INTO fix_car(no, car_num, name, start_day, end_day, gate_sel, week, nouse)');
          SQL.Add('VALUES (:no, :car_num, :name, :start_day, :end_day, :gate_sel, :week, :nouse);');
          Params.ParamByName('no').AsString := APurchaseCode;
          Params.ParamByName('car_num').AsString := ACarNo;
          Params.ParamByName('name').AsString := AMemberName;
          Params.ParamByName('start_day').AsDateTime := AStartDate;
          Params.ParamByName('end_day').AsDateTime := AEndDate;
          Params.ParamByName('gate_sel').AsString := '123456789abc';
          Params.ParamByName('week').AsString := sWeekInfo;
          Params.ParamByName('nouse').AsString := 'F';
          Prepared := True;
          ExecSQL;
          Result := True;
        finally
          Screen.Cursor := crDefault;
          Close;
          Free;
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('AddParking.Exception = %s', [E.Message]));
    end;
  end;
end;
//주차관제 정기권 삭제
function TClientDM.DeleteParking(const AVender: Integer; const APurchaseCode: string; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := '';
  try
    case AVender of
      CPV_HANIL: //한일테크닉스
        with TUniQuery.Create(nil) do
        try
          Screen.Cursor := crSQLWait;
          Connection := conParking;
          SQL.Add('DELETE FROM fix_car WHERE no = :no;');
          Params.ParamByName('no').AsString := APurchaseCode;
          Prepared := True;
          ExecSQL;
          Result := True;
//          UpdateLog(Global.LogFile, Format('DeleteParking = 정기권번호: %s', [APurchaseCode]));
        finally
          Screen.Cursor := crDefault;
          Close;
          Free;
        end;
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('DeleteParking.Exception = %s', [E.Message]));
    end;
  end;
end;
//주차관제 회원정보 수정
function TClientDM.UpdateParkingMember(const AVender: Integer; const APurchaseCode, ACarNo, AMemberName, AEndDay: string; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := '';
  try
    case AVender of
      CPV_HANIL: //한일테크닉스
        with TUniQuery.Create(nil) do
        try
          Screen.Cursor := crSQLWait;
          Connection := conParking;
          SQL.Add('UPDATE fix_car SET car_num=:car_num, name=:name, end_day=:end_day WHERE no=:no;');
          Params.ParamByName('car_num').AsString := ACarNo;
          Params.ParamByName('name').AsString := AMemberName;
          Params.ParamByName('end_day').AsString := AEndDay;
          Params.ParamByName('no').AsString := APurchaseCode;
          Prepared := True;
          ExecSQL;
          Result := True;
        finally
          Screen.Cursor := crDefault;
          Close;
          Free;
        end;
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('UpdateParkingMember.Exception = %s', [E.Message]));
    end;
  end;
end;
//제휴사 회원 할인 - 일일타석상품 할인금액 추출
function TClientDM.GetAffiliateAmt(const ATableNo: Integer; var AErrMsg: string): Integer;
begin
  Result := 0;
  AErrMsg := '';
  with TABSQuery.Create(nil) do
  try
    Screen.Cursor := crSQLWait;
    try
      DatabaseName := adbLocal.DatabaseName;
      SQL.Add('SELECT * FROM TBSaleItem');
      SQL.Add(Format('WHERE table_no = %d AND product_div = %s AND teebox_prod_div = %s', [ATableNo, QuotedStr(CPD_TEEBOX), QuotedStr(CTP_DAILY)]));
      SQL.Add('ORDER BY product_amt DESC;');
      SQL.SaveToFile(Global.LogDir + 'GetAffiliateAmt.sql');
      Open;
      First;
      if (RecordCount = 0) then
        raise Exception.Create('제휴사 회원 할인을 적용할 일일타석 상품이 없습니다!');
      Result := FieldByName('product_amt').AsInteger;
    except
      on E: Exception do
      begin
        AErrMsg := E.Message;
        UpdateLog(Global.LogFile, Format('GetAffiliateAmt.Exception = %s', [E.Message]));
      end;
    end;
  finally
    Screen.Cursor := crDefault;
    Close;
    Free;
  end;
end;
function TClientDM.SetAirConOnOff(const ATeeBoxNo, AUseCmd: Integer; var AErrMsg: string): Boolean;
var
  TC: TIdTCPClient;
  JO: TJSONObject;
  SS: TStringStream;
  sAPI, sBuffer: AnsiString;
begin
  //ATeeBoxNo 값이 -1 이면 전체 타석
  if (ATeeBoxNo <> -1) then
    sAPI := 'K414_TeeBoxHeat'
  else
    sAPI := 'K450_TeeBoxHeatAll';
  Result := False;
  AErrMsg := '';
  TC := TIdTCPClient.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    JO := TJSONObject.Create;
    JO.AddPair(TJSONPair.Create('api', sAPI));
    JO.AddPair(TJSONPair.Create('store_cd', SaleManager.StoreInfo.StoreCode));
    JO.AddPair(TJSONPair.Create('user_id', Global.ClientConfig.ClientId)); //SaleManager.UserInfo.UserId
    if (ATeeBoxNo <> -1) then
    begin
      JO.AddPair(TJSONPair.Create('teebox_no', IntToStr(ATeeBoxNo)));
      JO.AddPair(TJSONPair.Create('heat_time', IntToStr(Global.AirConditioner.BaseMinutes)));
      JO.AddPair(TJSONPair.Create('heat_use', IntToStr(AUseCmd)));
    end;
    sBuffer := JO.ToString;
    SS := TStringStream.Create(sBuffer);
    try
      SS.SaveToFile(Global.LogDir + sAPI + '.Request.json');
      TC.Host := Global.TeeBoxADInfo.Host;
      TC.Port := Global.TeeBoxADInfo.APIPort;
      TC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      TC.Connect;
      TC.IOHandler.WriteLn(sBuffer, IndyTextEncoding_UTF8);
      sBuffer := TC.IOHandler.ReadLn(IndyTextEncoding_UTF8);
      SS.Clear;
      SS.WriteString(sBuffer);
      SS.SaveToFile(Global.LogDir + sAPI + '.Response.json');
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO);
      if Assigned(SS) then
        FreeAndNil(SS);
      TC.Disconnect;
      FreeAndNil(TC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('SetAirConOnOff(%d).Exception = %s', [ATeeBoxNo, E.Message]));
    end;
  end;
end;
function TClientDM.DoAffiliateProcess(const AOwnerID: Integer; var AErrMsg: string): Boolean;
var
  PM: TPluginMessage;
  JO: TJSONObject;
  nUserId, nCouponId: Integer;
  sErrMsg: string;
begin
  Result := False;
  try
    if not (Global.WelbeingClub.Enabled or
            Global.RefreshClub.Enabled or
            Global.RefreshGolf.Enabled or
            Global.IKozen.Enabled or
            Global.Smartix.Enabled) then
      raise Exception.Create('제휴사 회원 연동설정이 되어 있지 않습니다!');
    if AffiliateRec.PartnerCode.IsEmpty then
      raise Exception.Create('주문 내역에 등록된 제휴사 상품이 없습니다!');
    PM := TPluginMessage.Create(nil);
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, AOwnerID);
    try
      if AffiliateRec.Applied then
      begin
        //취소 요청
        AffiliateRec.PartnerName := GetAffiliateName(AffiliateRec.PartnerCode, '제휴사');
        if (XGMsgBox(AOwnerID, mtConfirmation, '확인',
            AffiliateRec.PartnerName + ' 회원 할인이 이미 적용되어 있습니다!' + _CRLF +
            '취소 처리를 하시겠습니까?', ['예', '아니오']) <> mrOK) then
          Exit;
        PM.AddParams(CPP_APPROVAL_YN, False);
        PM.AddParams(CPP_AFFILIATE_CODE, AffiliateRec.PartnerCode);
        if (PluginManager.OpenModal('XGAffiliate' + CPL_EXTENSION, PM) = mrOK) then
        begin
          //웰빙클럽
          if (AffiliateRec.PartnerCode = GCD_WBCLUB_CODE) then
          begin
            if not ApplyWelbeingClub(False, AffiliateRec.MemberCode, AffiliateRec.MemberName, AffiliateRec.MemberTelNo, sErrMsg) then
              raise Exception.Create(sErrMsg);
          end
          //리프레쉬클럽,리프레쉬골프,아이코젠 등등
          else
            raise Exception.Create(AffiliateRec.PartnerName + ' 회원 할인 취소는 지원되지 않습니다!');
          AffiliateRec.Clear;
        end;
      end
      else
      begin
        //승인 요청
        AffiliateRec.ApprovalAmt := GetAffiliateAmt(Global.TableInfo.ActiveTableNo, sErrMsg);
        if (AffiliateRec.ApprovalAmt = 0) then
          raise Exception.Create(sErrMsg);
        PM.AddParams(CPP_APPROVAL_YN, True);
        PM.AddParams(CPP_AFFILIATE_CODE, '');
        if (PluginManager.OpenModal('XGAffiliate' + CPL_EXTENSION, PM) = mrOK) then
        begin
          SaleManager.ReceiptInfo.AffiliateAmt := AffiliateRec.ApprovalAmt;
          if (AffiliateRec.PartnerCode = GCD_WBCLUB_CODE) then //웰빙클럽
          begin
            if Global.WelbeingClub.SelectEvent then //종목선택 승인으로 설정된 경우
            begin
              if not ApplyWelbeingClub(True, AffiliateRec.MemberCode, AffiliateRec.ItemCode, AffiliateRec.MemberName, AffiliateRec.MemberTelNo, sErrMsg) then
                raise Exception.Create(sErrMsg);
            end
            else //자동 승인
            begin
              if not ApplyWelbeingClub(True, AffiliateRec.MemberCode, AffiliateRec.MemberName, AffiliateRec.MemberTelNo, sErrMsg) then
                raise Exception.Create(sErrMsg);
            end;
          end
          else if (AffiliateRec.PartnerCode = GCD_RFCLUB_CODE) then //리프레쉬클럽
          begin
            if not ApplyRefreshClub(AffiliateRec.ReadData, False, sErrMsg) then
              raise Exception.Create(sErrMsg);
          end
          else if (AffiliateRec.PartnerCode = GCD_RFGOLF_CODE) then //리프레쉬골프
          begin
            nCouponId := GetRefreshGolfCoupon(AffiliateRec.ReadData, False, sErrMsg);
            if (nCouponId = 0) then
              raise Exception.Create(sErrMsg);
            JO := TJSONObject.ParseJSONValue(AffiliateRec.ReadData) as TJSONObject;
            try
              nUserId := StrToIntDef(JO.GetValue('user_id').Value, 0);
              if not ApplyRefreshGolf(nUserId, nCouponId, False, sErrMsg) then
                raise Exception.Create(sErrMsg);
            finally
              FreeAndNilJSONObject(JO);
            end;
          end
          else if (AffiliateRec.PartnerCode = GCD_IKOZEN_CODE) then //아이코젠
          begin
            if not ApplyIKozen(AffiliateRec.MemberCode, AffiliateRec.IKozenExecId, AffiliateRec.IKozenExecTime, AffiliateRec.MemberName, sErrMsg) then
              raise Exception.Create(sErrMsg);
          end
          else if (AffiliateRec.PartnerCode = GCD_SMARTIX_CODE) then //스마틱스
          begin
            if not ApplySmartix(AffiliateRec.MemberCode, sErrMsg) then
              raise Exception.Create(sErrMsg);
          end
          else
            raise Exception.Create(AffiliateRec.PartnerCode + '은(는) 처리할 수 않는 제휴사 코드입니다!');
          AffiliateRec.PartnerName := GetAffiliateName(AffiliateRec.PartnerCode, '제휴사');
          AffiliateRec.Applied := True;
        end;
      end;
      Result := True;
    finally
      FreeAndNil(PM);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('DoAffiliateProcess.Exception = %s', [E.Message]));
    end;
  end;
end;
//제휴사 회원 할인 - 웰빙클럽 연동: 승인 및 취소
function TClientDM.ApplyWelbeingClub(const AIsApproval: Boolean; const ACardNo: string; var AErrMsg: string): Boolean;
var
  sMemberName, sMemberTelNo: string;
begin
  Result := ApplyWelbeingClub(AIsApproval, ACardNo, '', sMemberName, sMemberTelNo, AErrMsg);
end;
function TClientDM.ApplyWelbeingClub(const AIsApproval: Boolean; const ACardNo: string; var AMemberName, AMemberTelNo, AErrMsg: string): Boolean;
begin
  Result := ApplyWelbeingClub(AIsApproval, ACardNo, '', AMemberName, AMemberTelNo, AErrMsg);
end;
function TClientDM.ApplyWelbeingClub(const AIsApproval: Boolean; const ACardNo, AOrderCode: string; var AMemberName, AMemberTelNo, AErrMsg: string): Boolean;
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO1, JO2: TJSONObject;
  SL: TStringList;
  RS: TStringStream;
  RBS: RawByteString;
  sUrl, sToken, sStoreCode, sResCode, sResMsg: string;
begin
  Result := False;
  AMemberName := '';
  AMemberTelNo := '';
  AErrMsg := '';
  JO1 := nil;
  JO2 := nil;
  try
    if not Global.WelbeingClub.Enabled then
      raise Exception.Create('웰빙클럽 사용 설정이 되어 있지 않습니다!');
    Screen.Cursor := crSQLWait;
    SL := TStringList.Create;
    RS := TStringStream.Create;
    SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    HC := TIdHTTP.Create(nil);
    try
      sUrl := Global.WelbeingClub.Host + IIF(AIsApproval, IIF(Global.WelbeingClub.SelectEvent, GCD_WBCLUB_APPROVAL_SELECT_URI, GCD_WBCLUB_APPROVAL_URI), GCD_WBCLUB_CANCEL_URI);
      sToken := Global.WelbeingClub.ApiToken; //GCD_WBCLUB_TEST_API_TOKEN;
      sStoreCode := Global.WelbeingClub.StoreCode; //GCD_WBCLUB_TEST_STORE_CODE;
      UpdateLog(Global.LogFile,
        Format('ApplyWelbeingClub.Request(%s) = url: %s, api_token: %s, sisul_code: %s, card_number: %s, ord_cd: %s',
          [IIF(AIsApproval, 'Approval', 'Cancel'), sUrl, sToken, sStoreCode, ACardNo, AOrderCode]));
      HC.Request.Accept := 'application/json';
      HC.Request.ContentType := 'application/x-www-form-urlencoded';
      HC.Request.Method := 'POST';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.HTTPOptions := (HC.HTTPOptions - [idHTTP.hoForceEncodeParams]); //자동 인코딩 방지
      SL.Add(TIdURI.ParamsEncode('api_token=' + sToken));
      SL.Add(TIdURI.ParamsEncode('sisul_code=' + sStoreCode));
      SL.Add(TIdURI.ParamsEncode('card_number=' + ACardNo));
      if AIsApproval and
         Global.WelbeingClub.SelectEvent then
      begin
        SL.Add(TIdURI.ParamsEncode('ord_cd=' + AOrderCode));
        SL.Add(TIdURI.ParamsEncode('gubun_cd=SPT')); //시설구분(SPT: 스포츠, CUL: 컬처)
      end;
      HC.Post(sUrl, SL, RS);
      RS.SaveToFile(Global.LogDir + Format('ApplyWelbeingClub(%s).Response.json', [IIF(AIsApproval, 'Approval', 'Cancel')]));
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO1 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO1.GetValue('code').Value;
      sResMsg := JO1.GetValue('msg').Value;
      AErrMsg := Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]);
      if not ((sResCode = '0') or (sResCode = '1')) then
        raise Exception.Create(AErrMsg);
      if not (JO1.FindValue('data') is TJSONNull) then
      begin
        JO2 := JO1.GetValue('data') as TJSONObject;
        AMemberName := JO2.GetValue('username').Value;
        AMemberTelNo := JO2.GetValue('usertel').Value;
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JO1);
      FreeAndNil(RS);
      FreeAndNil(SL);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('ApplyWelbeingClub(%s).Exception = %s', [IIF(AIsApproval, 'Approval', 'Cancel'), E.Message]));
    end;
  end
end;
//제휴사 회원 할인 - 리프레쉬클럽 연동: 승인
function TClientDM.ApplyRefreshClub(const AQRData: string; const ATestMode: Boolean; var AErrMsg: string): Boolean;
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO: TJSONObject;
  SS, RS: TStringStream;
  RBS: RawByteString;
  sUrl, sToken, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  try
    if not Global.RefreshClub.Enabled then
      raise Exception.Create('리프레쉬/클럽 사용 설정이 되어 있지 않습니다!');
    Screen.Cursor := crSQLWait;
    SS := TStringStream.Create(AQRData, TEncoding.UTF8);
    RS := TStringStream.Create;
    HC := TIdHTTP.Create(nil);
    JO := nil;
    try
      SS.SaveToFile(Global.LogDir + 'ApplyRefreshClub.Request.json');
      sUrl := IIF(ATestMode, GCD_RFCLUB_TEST_HOST, Global.RefreshClub.Host);
      sToken := IIF(ATestMode, GCD_RFCLUB_TEST_API_TOKEN, Global.RefreshClub.ApiToken);
      HC.Request.ContentType := 'application/json';
      HC.Request.CustomHeaders.Values['Authorization'] := 'AK ' + sToken;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.Request.Method := 'POST';
      if not ATestMode then
      begin
        SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
        SSL.SSLOptions.Method := sslvSSLv23;
        SSL.SSLOptions.Mode := sslmClient;
        HC.IOHandler := SSL;
      end;
      HC.Post(sUrl, SS, RS);
      RS.SaveToFile(Global.LogDir + 'ApplyRefreshClub.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO.GetValue('code').Value;
      sResMsg := JO.GetValue('message').Value;
      AErrMsg := Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]);
      if (sResCode <> '0000') then
        raise Exception.Create(AErrMsg);
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO);
      FreeAndNil(RS);
      FreeAndNil(SS);
      if Assigned(SSL) then
        FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('ApplyRefreshClub.Exception = %s', [E.Message]));
    end;
  end
end;
//제휴사 회원 할인 - 리프레쉬골프 연동: 승인
function TClientDM.ApplyRefreshGolf(const AUserId, ACouponId: Integer; const ATestMode: Boolean; var AErrMsg: string): Boolean;
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO1, JO2: TJSONObject;
  SS, RS: TStringStream;
  RBS: RawByteString;
  sUrl, sToken, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  try
    if not Global.RefreshGolf.Enabled then
      raise Exception.Create('리프레쉬/골프 사용 설정이 되어 있지 않습니다!');
    Screen.Cursor := crSQLWait;
    JO2 := nil;
    JO1 := TJSONObject.Create;
    JO1.AddPair(TJSONPair.Create('user_id',      TJSONNumber.Create(AUserId)));
    JO1.AddPair(TJSONPair.Create('operation_id', TJSONNumber.Create(StrToIntDef(Global.RefreshGolf.StoreCode, 0))));
    JO1.AddPair(TJSONPair.Create('coupon_id',    TJSONNumber.Create(ACouponId)));
    SS := TStringStream.Create(JO1.ToString, TEncoding.UTF8);
    RS := TStringStream.Create;
    HC := TIdHTTP.Create(nil);
    try
      sUrl := IIF(ATestMode, GCD_RFGOLF_TEST_HOST, Global.RefreshGolf.Host);
      sToken := IIF(ATestMode, GCD_RFGOLF_TEST_API_TOKEN, Global.RefreshGolf.ApiToken);
//      UpdateLog(Global.LogFile,
//        Format('ApplyRefreshGolf.Request() : url=%s, api_key=%s, user_id=%s, coupon_id=%s, operation_id=%s',
//          [sUrl, sToken, AUserId, ACouponId, Global.RefreshGolf.StoreCode]));
      HC.Request.Accept := 'application/json';
      HC.Request.ContentType := 'application/json';
      HC.Request.CustomHeaders.Values['Authorization'] := 'AK ' + sToken;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.Request.Method := 'POST';
      if not ATestMode then
      begin
        SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
        SSL.SSLOptions.Method := sslvSSLv23;
        SSL.SSLOptions.Mode := sslmClient;
        HC.IOHandler := SSL;
      end;
      HC.Post(sUrl, SS, RS);
      RS.SaveToFile(Global.LogDir + 'ApplyRefreshGolf.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO2.GetValue('code').Value;
      sResMsg := JO2.GetValue('message').Value;
      AErrMsg := Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]);
      if (sResCode <> '0000') then
        raise Exception.Create(AErrMsg);
      AErrMsg := '[' + JO2.GetValue('code').Value + '] ' + JO2.GetValue('message').Value + _CRLF +
                 '[' + IIF(StrToIntDef(JO2.GetValue('used').Value, 0) = 0, 'JOY', '쿠폰') + '] ' + JO2.GetValue('used').Value + _CRLF +
                 '[잔량] ' + JO2.GetValue('remained').Value;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JO1);
      FreeAndNil(RS);
      if Assigned(SS) then
        FreeAndNil(SS);
      if Assigned(SSL) then
        FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('ApplyRefreshGolf.Exception = %s', [E.Message]));
    end;
  end
end;
function TClientDM.GetRefreshGolfCoupon(const AQRData: string; const ATestMode: Boolean; var AErrMsg: string): Integer;
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO1, JO2: TJSONObject;
  JV2: TJSONValue;
  RS: TStringStream;
  RBS: RawByteString;
  sUrl, sToken, sResCode, sResMsg: string;
  I, nCount: Integer;
begin
  Result := 0;
  AErrMsg := '';
  try
    if not Global.RefreshGolf.Enabled then
      raise Exception.Create('리프레쉬/골프 사용 설정이 되어 있지 않습니다!');
    Screen.Cursor := crSQLWait;
    JO1 := nil;
    JO2 := nil;
    JV2 := nil;
    RS := TStringStream.Create;
    HC := TIdHTTP.Create(nil);
    try
      JO1 := TJSONObject.ParseJSONValue(AQRData) as TJSONObject;
      sToken := IIF(ATestMode, GCD_RFGOLF_TEST_API_TOKEN, Global.RefreshGolf.ApiToken);
      sUrl := IIF(ATestMode, GCD_RFGOLF_TEST_HOST, Global.RefreshGolf.Host) +
        Format('?user_id=%s&club_id=%s&created_at=%s',
          [JO1.GetValue('user_id').Value, JO1.GetValue('club_id').Value, JO1.GetValue('created_at').Value]);
      HC.Request.ContentType := 'application/x-www-form-urlencoded';
      HC.Request.CustomHeaders.Values['Authorization'] := 'AK ' + sToken;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.Request.Method := 'GET';
      if not ATestMode then
      begin
        SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
        SSL.SSLOptions.Method := sslvSSLv23;
        SSL.SSLOptions.Mode := sslmClient;
        HC.IOHandler := SSL;
      end;
      HC.Get(sUrl, RS);
      RS.SaveToFile(Global.LogDir + 'GetRefreshGolfCoupon.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO2 := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := JO2.GetValue('code').Value;
      sResMsg := JO2.GetValue('message').Value;
      AErrMsg  := Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]);
      if (sResCode <> '0000') then
        raise Exception.Create(AErrMsg);
      if not (JO2.FindValue('coupons') is TJSONNull) then
      begin
        JV2 := JO2.Get('coupons').JsonValue;
        nCount := (JV2 as TJSONArray).Count;
        if (nCount = 0) then
          raise Exception.Create('Error Message');
        with MDRefreshClubCoupon do
        try
          DisableControls;
          ClearMemData(MDRefreshClubCoupon);
          for I := 0 to Pred(nCount) do
          begin
            Append;
            FieldValues['coupon_id'] := StrToIntDef((JV2 as TJSONArray).Items[I].P['coupon_id'].Value, 0);
            FieldValues['subtitle'] := (JV2 as TJSONArray).Items[I].P['subtitle'].Value;
            FieldValues['valid_period_end'] := (JV2 as TJSONArray).Items[I].P['valid_period_end'].Value;
            FieldValues['pass_count'] := StrToIntDef((JV2 as TJSONArray).Items[I].P['pass_count'].Value, 0);
            Post;
          end;
        finally
          First;
          EnableControls;
        end;
        with TXGRefreshClubCouponForm.Create(nil) do
        try
          if (ShowModal = mrOk) then
            Result := MDRefreshClubCoupon.FieldByName('coupon_id').AsInteger;
        finally
          Free;
        end;
      end;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JV2);
      FreeAndNilJSONObject(JO2);
      FreeAndNilJSONObject(JO1);
      FreeAndNil(RS);
      if Assigned(SSL) then
        FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetRefreshGolfCoupon.Exception = %s', [E.Message]));
    end;
  end
end;
function TClientDM.ApplyIKozen(const AMemberNo, AExecId, AExecTime: string; var AMemberName, AErrMsg: string): Boolean;
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO: TJSONObject;
  SS, RS: TStringStream;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sStoreName: string;
begin
  Result := False;
  sStoreName := '';
  AMemberName := '';
  AErrMsg := '';
  try
    if not Global.IKozen.Enabled then
      raise Exception.Create('아이코젠 사용 설정이 되어 있지 않습니다!');
    Screen.Cursor := crSQLWait;
    JO := nil;
    RS := TStringStream.Create;
    HC := TIdHTTP.Create(nil);
    SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    try
      sUrl := Format('%s?MID=%s&SISUL_CODE=%s&EXECID=%s&EXPT=%s', [Global.IKozen.Host, AMemberNo, Global.IKozen.StoreCode, AExecId, AExecTime]);
      HC.Request.CustomHeaders.Clear;
      HC.Request.ContentType := 'application/x-www-form-urlencoded';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects:=False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.Request.Method := 'GET';
      HC.Get(sUrl, RS);
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      SS := TStringStream.Create(JO.ToString, TEncoding.UTF8);
      SS.SaveToFile(Global.LogDir + 'ApplyIKozen.Response.json');
      sResCode := JO.GetValue('enter_ok').Value;
      sResMsg := JO.GetValue('msg').Value;
      sStoreName := JO.GetValue('sisul_name').Value;
      AMemberName := JO.GetValue('member_name').Value;
      if (sResCode <> '1') then
        raise Exception.Create(Format('ResultCode=%s, MemberName=%s, StoreName=%s, Message=%s', [sResCode, AMemberName, sStoreName, sResMsg]));
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JO);
      FreeAndNil(RS);
      if Assigned(SS) then
        FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('ApplyIKozen.Exception = %s', [E.Message]));
    end;
  end
end;
function TClientDM.ExtractIKozenQRCode(const AReadData: string; var AMemberCode, AStoreCode, AExecId, AExecTime, AErrMsg: string): Boolean;
var
  sBuffer, sHeader: string;
  nPos: Integer;
begin
  Result := False;
  sBuffer := AReadData; //IK_1041911_1452_1_1617860670
  AMemberCode := '';
  AStoreCode := '';
  AExecId := '';
  AExecTime := '';
  AErrMsg := '';
  try
    sHeader := Copy(sBuffer, 1, 3);
    if not ((sHeader = 'IK_') or (sHeader = 'AK_')) then
      raise Exception.Create('유효한 아이코젠 멤버십 바코드가 아닙니다.');
    sBuffer := Copy(sBuffer, 4, Length(sBuffer) - 3); //1041911_1452_1_1617860670
    nPos := Pos('_', sBuffer); //8
    if (nPos > 0) then
    begin
      AMemberCode := Copy(sBuffer, 1, Pred(nPos)); //1041911
      sBuffer := Copy(sBuffer, Succ(nPos), Length(sBuffer) - nPos); //1452_1_1617860670
      nPos := Pos('_', sBuffer); //5
      if (nPos > 0) then
      begin
        AStoreCode := Copy(sBuffer, 1, Pred(nPos)); //1452
        sBuffer := Copy(sBuffer, Succ(nPos), Length(sBuffer) - nPos); //1_1617860670;
        nPos := Pos('_', sBuffer); //2
        if (nPos > 0) then
        begin
          AExecId := Copy(sBuffer, 1, 1);
          AExecTime := Copy(sBuffer, Succ(nPos), Length(sBuffer) - nPos); //1617860670;
        end;
      end;
    end;
    if AMemberCode.IsEmpty or AStoreCode.IsEmpty or AExecId.IsEmpty or AExecTime.IsEmpty then
      raise Exception.Create('유효한 아이코젠 멤버십 바코드가 아닙니다.');
    Result := True;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('ExtractIKozenQRCode(%s).Exception = %s', [AReadData, AErrMsg]));
    end;
  end;
end;
function TClientDM.ApplySmartix(const AMemberNo: string; var AErrMsg: string): Boolean;
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO: TJSONObject;
  JOArr: TJSONArray;
  SS, RS: TStringStream;
  RBS: RawByteString;
  sToken, sUrl, sResCode, sResMsg: string;
  sJson: AnsiString;
  bHttpError: Boolean;
begin
  Result := False;
  bHttpError := True;
  AErrMsg := '';
  try
    if not Global.Smartix.Enabled then
      raise Exception.Create('스마틱스 사용 설정이 되어 있지 않습니다!');
    Screen.Cursor := crSQLWait;
    JO := nil;
    SS := TStringStream.Create;
    RS := TStringStream.Create;
    HC := TIdHTTP.Create(nil);
    SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    try
      sUrl := Format('%s?rsSeqInspect=%s&clientCompSeq=%s', [Global.Smartix.Host, AMemberNo, Global.Smartix.clientCompSeq]);
      sToken := 'eyJhbGciOiJIUzUxMiJ9.eyJqdGkiOiIzMzQ2OGUzNy04ODQ4LTQxYjgtYWU2Ny05MjQyZWVkYTBjYjkiLCJjb21wX3NlcSI6IjE4NDIiLCJjaGFubmVsX3Nl'+
                'cSI6IjAiLCJ1c2VyX3NlcSI6IjE0NDciLCJ1c2VyX2F1dGgiOlsiU0lURV9VU0VSIl0sImlhdCI6MTcwNDM1Mzk1Niwic3ViIjoiVENNIiwiaXNzIjoiU01BUl'+
                'RJWCJ9.8Fw9AsdHsOOiSzRfoVMK390rW8MejTvvX0Q7Fm3StJ__ZLVCkPnatgfIQGByJ0ohFDZ6W2PsJhruVpLqMtYQVA';
      HC.Request.CustomHeaders.Clear;
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + sToken;
      HC.Request.ContentType := 'application/json';
      HC.Request.Accept := '*/*';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      //HC.HandleRedirects:=False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.Request.Method := 'PATCH';
      HC.Patch(sUrl, SS, RS);
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JOArr := TJSONObject.ParseJSONValue(String(RBS)) as TJSONArray;
      JO := JOArr.Get(0) as TJSONObject;
      {
      SS := TStringStream.Create(JO.ToString, TEncoding.UTF8);
      SS.SaveToFile(Global.LogDir + 'ApplyIKozen.Response.json');
      }
      sResCode := JO.GetValue('code').Value;
      sResMsg := JO.GetValue('message').Value;
      if (sResCode <> '100') then
      begin
        bHttpError := False;
        raise Exception.Create(Format('ResultCode=%s, Message=%s', [sResCode, sResMsg]));
      end;
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(JOArr);
      FreeAndNil(RS);
      if Assigned(SS) then
        FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      if bHttpError = True then
        AErrMsg := '등록되지 않은 티켓번호 입니다. / ' + E.Message
      else
        AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('ApplySmartix.Exception = %s', [E.Message]));
    end;
  end
end;
function TClientDM.GetWeatherInfo: Boolean;
var
  sErrMsg: string;
begin
  Result := GetWeatherInfo(sErrMsg);
end;
function TClientDM.GetWeatherInfo(var AErrMsg: string): Boolean;
  function GetWeatherIconIndex(const AWeatherId: Integer; const ADaytime: Boolean; var ACondition: string): Integer;
  begin
    Result := 0;
    ACondition := '확인불가';
    case AWeatherId of
      200..232:
      begin
        Result := 7; //11d
        ACondition := '뇌우';
      end;
      300..321:
      begin
        Result := 5; //9d
        ACondition := '약한 비';
      end;
      500..504:
      begin
        Result := 6; //10d
        ACondition := '비';
      end;
      511:
      begin
        Result := 5; //9d
        ACondition := '진눈깨비';
      end;
      520..531:
      begin
        Result := 5; //9d
        ACondition := '소나기';
      end;
      600..622:
      begin
        Result := 8; //13d
        ACondition := '눈';
      end;
      701..721, 741:
      begin
        Result := 9; //50d
        ACondition := '안개';
      end;
      731, 751, 761:
      begin
        Result := 9; //50d
        ACondition := '안개';
      end;
      762:
      begin
        Result := 9; //50d
        ACondition := '화산재';
      end;
      771:
      begin
        Result := 10; //51d
        ACondition := '돌풍';
      end;
      781:
      begin
        Result := 10; //51d
        ACondition := '폭풍';
      end;
      800:
      begin
        Result := 1; //01d
        ACondition := '맑음';
      end;
      801:
      begin
        Result := 2; //02d
        ACondition := '대체로 맑음';
      end;
      802:
      begin
        Result := 3; //03d
        ACondition := '대체로 흐림';
      end;
      803..804:
      begin
        Result := 4; //04d
        ACondition := '흐림';
      end;
    end;
    Result := (Result * 2) + IIF(ADaytime, 0, 1);
  end;
var
  PM: TPluginMessage;
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO, RO: TJSONObject;
  JV, RV: TJSONValue;
  RS: TStringStream;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg, sCondition, sTemper, sPrecipit, sHumidity, sWindSpeed: string;
  I, nCount, nWeatherId, nIconIdx: Integer;
  dDateTime: TDateTime;
  nUnixTime: Int64;
  bDayTime: Boolean;
begin
  Result := False;
  AErrMsg := '';
  try
    if not Global.WeatherInfo.Enabled then
      raise Exception.Create('날씨 정보를 사용하기 위한 설정이 올바르지 않습니다.');
    Screen.Cursor := crHourGlass;
    SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    RS := TStringStream.Create;
    HC := TIdHTTP.Create(nil);
    JO := nil;
    RO := nil;
    JV := nil;
    RV := nil;
    try
      HC.Request.CustomHeaders.Clear;
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects:=False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.Request.UserAgent := 'Mozilla/5.0';
      HC.Request.Method := 'GET';
      (*
      https://api.openweathermap.org/data/2.5/onecall?lat=37.48&lon=126.89&exclude=minutely,hourly&lang=kr&units=metric&appid=2e89859998241a328872d857ec55221e
      Temper: string; //온도
      Precipit: string; //강수확률
      Humidity: string; //습도
      WindSpeed: string; //풍속
      WeatherId: Integer; //아이콘
      *)
      sUrl := Format('%s/data/2.5/onecall?lat=%s&lon=%s&exclude=minutely&lang=kr&units=metric&appid=%s',
                [ExcludeTrailingPathDelimiter(Global.WeatherInfo.Host), Global.WeatherInfo.Latitude, Global.WeatherInfo.Longitude, Global.WeatherInfo.ApiKey]);
      HC.Get(sUrl, RS);
      RS.SaveToFile(Global.LogDir + 'GetWeatherInfo.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      JO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      if (JO.FindValue('cod') <> nil) then
      begin
        sResCode := JO.GetValue('cod').Value;
        sResMsg := JO.GetValue('message').Value;
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      end;
      Global.WeatherInfo.WeatherId := -1; //현재(초기화)
      Global.WeatherInfo.Temper := '';
      Global.WeatherInfo.Humidity := '';
      Global.WeatherInfo.WindSpeed := '';
      Global.WeatherInfo.Precipit := '';
      (*
      //현재날씨
      RO := JO.GetValue('current') as TJSONObject;
      Global.WeatherInfo.Temper := IntToStr(Round(StrToFloatDef(RO.GetValue('temp').Value, 0))); //(현재)기온
      Global.WeatherInfo.Humidity := RO.GetValue('humidity').Value; //(현재)습도
      Global.WeatherInfo.WindSpeed := IntToStr(Round(StrToFloatDef(RO.GetValue('wind_speed').Value, 0))); //(현재)풍속
      Global.WeatherInfo.Precipit := ''; //(현재)강수확률
      JV := RO.Get('weather').JsonValue;
      nCount := (JV as TJSONArray).Count;
      for I := 0 to Pred(nCount) do
      begin
        Global.WeatherInfo.WeatherId := StrToIntDef((JV as TJSONArray).Items[I].P['id'].Value, 0); //날씨상태
        Global.WeatherInfo.DayTime := (Pos('d', (JV as TJSONArray).Items[I].P['icon'].Value) <> 0); //낮 시간 여부
        Global.WeatherInfo.IconIndex := GetWeatherIconIndex(Global.WeatherInfo.WeatherId, Global.WeatherInfo.DayTime, sCondition);
        Global.WeatherInfo.Condition := sCondition;
        Break;
      end;
      *)
      //금일예보
      ClearMemData(MDWeatherHour);
      with MDWeatherHour do
      try
        DisableControls;
        JV := JO.Get('hourly').JsonValue;
        nCount := (JV as TJSONArray).Count;
        for I := 0 to Pred(nCount) do
        begin
          RO := (JV as TJSONArray).Items[I] as TJSONObject;
          nUnixTime := StrToIntDef(RO.GetValue('dt').Value, 0);
          dDateTime := UnixToDateTime(nUnixTime);
          if (dDateTime < Now) then
            Continue;
          sTemper := IntToStr(Round(StrToFloatDef(RO.GetValue('temp').Value, 0)));
          sHumidity := RO.GetValue('humidity').Value ;
          sWindSpeed := IntToStr(Round(StrToFloatDef(RO.GetValue('wind_speed').Value, 0)));
          sPrecipit := IntToStr(Round(StrToFloatDef(RO.GetValue('pop').Value, 0) * 100));
          RV := RO.Get('weather').JsonValue;
          nWeatherId := StrToIntDef((RV as TJSONArray).Items[0].P['id'].Value, 0);
          bDayTime := (Pos('d', (RV as TJSONArray).Items[0].P['icon'].Value) <> 0);
          nIconIdx := GetWeatherIconIndex(nWeatherId, bDayTime, sCondition);
          //현재날씨
          if (Global.WeatherInfo.WeatherId = -1) then
          begin
            Global.WeatherInfo.WeatherId := nWeatherId; //날씨상태
            Global.WeatherInfo.DayTime := bDayTime; //낮시간 여부
            Global.WeatherInfo.IconIndex := GetWeatherIconIndex(nWeatherId, True, sCondition); //날씨 아이콘 인덱스
            Global.WeatherInfo.Condition := sCondition; //상태
            Global.WeatherInfo.Temper := sTemper; //기온
            Global.WeatherInfo.Humidity := sHumidity; //습도
            Global.WeatherInfo.WindSpeed := sWindSpeed; //풍속
            Global.WeatherInfo.Precipit := sPrecipit; //강수확률
            UpdateLog(Global.LogFile, Format('GetWeatherInfo.Current = WeatherId: %d, IconIndex: %d, Condition: %s', [nWeatherId, Global.WeatherInfo.IconIndex, sCondition]));
          end;
          Append;
          FieldValues['datetime'] := dDateTime;
          FieldValues['weather_id'] := nWeatherId;
          FieldValues['icon_idx'] := nIconIdx;
          FieldValues['temper'] := sTemper;
          FieldValues['precipit'] := sPrecipit;
          FieldValues['humidity'] := sHumidity;
          FieldValues['wind_speed'] := sWindSpeed;
          FieldValues['condition'] := sCondition;
          TBlobField(FieldByName('icon')).Assign(imcWeather.Items[nIconIdx].Picture);
          Post;
        end;
      finally
        First;
        EnableControls;
      end;
      //주간예보
      ClearMemData(MDWeatherDay);
      with MDWeatherDay do
      try
        DisableControls;
        JV := JO.Get('daily').JsonValue;
        nCount := (JV as TJSONArray).Count;
        for I := 0 to Pred(nCount) do
        begin
          RO := (JV as TJSONArray).Items[I] as TJSONObject;
          nUnixTime := StrToIntDef(RO.GetValue('dt').Value, 0);
          dDateTime := UnixToDateTime(nUnixTime);
          if (dDateTime < Now) then
            Continue;
          sHumidity := RO.GetValue('humidity').Value;
          sWindSpeed := IntToStr(Round(StrToFloatDef(RO.GetValue('wind_speed').Value, 0)));
          sPrecipit := IntToStr(Round(StrToFloatDef(RO.GetValue('pop').Value, 0) * 100));
          RV := RO.Get('weather').JsonValue;
          if ((RV as TJSONArray).Count > 0) then
          begin
            nWeatherId := StrToIntDef((RV as TJSONArray).Items[0].P['id'].Value, 0);
            nIconIdx := GetWeatherIconIndex(nWeatherId, True, sCondition);
          end;
          RO := RO.GetValue('temp') as TJSONObject;
          sTemper := IntToStr(Round(StrToFloatDef(RO.GetValue('min').Value, 0))) + ' / ' + IntToStr(Round(StrToFloatDef(RO.GetValue('max').Value, 0)));
          Append;
          FieldValues['datetime'] := dDateTime;
          FieldValues['weather_id'] := nWeatherId;
          FieldValues['icon_idx'] := nIconIdx;
          FieldValues['temper'] := sTemper;
          FieldValues['precipit'] := sPrecipit;
          FieldValues['humidity'] := sHumidity;
          FieldValues['wind_speed'] := sWindSpeed;
          FieldValues['condition'] := sCondition;
          TBlobField(FieldByName('icon')).Assign(imcWeather.Items[nIconIdx].Picture);
          Post;
        end;
      finally
        First;
        EnableControls;
      end;
      Result := True;
      PM := TPluginMessage.Create(nil);
      try
        PM.Command := CPC_WEATHER_REFRESH;
        PM.PluginMessageToID(Global.SubMonitorId);
        PM.PluginMessageToID(Global.TeeBoxViewId);
      finally
        FreeAndNil(PM);
      end;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(RO);
      FreeAndNilJSONObject(RV);
      FreeAndNilJSONObject(JV);
      FreeAndNilJSONObject(JO);
      FreeAndNil(RS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('GetWeatherInfo.Exception = %s', [AErrMsg]));
    end;
  end;
end;
{ 지문 인식 관련 }
procedure TClientDM.FingerPrintClearUserList;
begin
  with Global.DeviceConfig.FingerPrintScanner do
  begin
    if (not Enabled) or
       (not DeviceType in [CFT_NITGEN, CFT_UC]) then
      Exit;
    case DeviceType of
      CFT_NITGEN:
        TNBioBSPHelper(Scanner).ClearUserList;
      CFT_UC:
        TUCBioBSPHelper(Scanner).ClearUserList;
    end;
  end;
end;
function TClientDM.FingerPrintCapture(var ATextFIR, AErrMsg: string): Boolean;
begin
  Result := False;
  ATextFIR := '';
  AErrMsg := '';
  with Global.DeviceConfig.FingerPrintScanner do
  try
    if not Enabled then
      Exit;
    case DeviceType of
      CFT_NITGEN:
        with TNBioBSPHelper(Scanner) do
        begin
          Result := Capture;
          AErrMsg := ErrorMessage;
          if Result then
            ATextFIR := TextFIR;
        end;
      CFT_UC:
        with TUCBioBSPHelper(Scanner) do
        begin
          Result := Capture;
          AErrMsg := ErrorMessage;
          if Result then
            ATextFIR := TextFIR;
        end
      else
        raise Exception.Create(Format('Unknown Device Type %d', [DeviceType]));
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('FingerPrintClearUserList.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.FingerPrintAddUser(const ATextFIR: string; const AMemberSeq: Integer; var AErrMsg: string): Boolean;
begin
  Result := False;
  AErrMsg := '';
  with Global.DeviceConfig.FingerPrintScanner do
  try
    if not Enabled then
      Exit;
    case DeviceType of
      CFT_NITGEN:
        Result := TNBioBSPHelper(Scanner).AddUser(ATextFIR, AMemberSeq, AErrMsg);
      CFT_UC:
        Result := TUCBioBSPHelper(Scanner).AddUser(ATextFIR, AMemberSeq, AErrMsg);
      else
        raise Exception.Create(Format('Unknown Device Type %d', [DeviceType]));
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('FingerPrintAddUser.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.FingerPrintRemoveUser(const AMemberSeq: Integer; var AErrMsg: string): Boolean;
begin
  Result := False;
  with Global.DeviceConfig.FingerPrintScanner do
  try
    if not Enabled then
      Exit;
    case DeviceType of
      CFT_NITGEN:
        Result := TNBioBSPHelper(Scanner).RemoveUser(AMemberSeq, AErrMsg);
      CFT_UC:
        Result := TUCBioBSPHelper(Scanner).RemoveUser(AMemberSeq, AErrMsg);
      else
        raise Exception.Create(Format('Unknown Device Type %d', [DeviceType]));
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('FingerPrintRemoveUser.Exception = %s', [E.Message]));
    end;
  end;
end;
function TClientDM.FingerPrintMatching(const ATextFIR: string; var AMemberSeq: Integer; var AErrMsg: string): Boolean;
begin
  Result := False;
  AMemberSeq := -1;
  with Global.DeviceConfig.FingerPrintScanner do
  try
    if not Enabled then
      Exit;
    case DeviceType of
      CFT_NITGEN:
        Result := TNBioBSPHelper(Scanner).Matching(ATextFIR, AMemberSeq, AErrMsg);
      CFT_UC:
        Result := TUCBioBSPHelper(Scanner).Matching(ATextFIR, AMemberSeq, AErrMsg);
      else
        raise Exception.Create(Format('Unknown Device Type %d', [DeviceType]));
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('FingerPrintMatching.Exception = %s', [E.Message]));
    end;
  end;
end;
{ 로컬 데이터베이스 }
procedure TClientDM.CreateField(ADataSet: TDataSet; const AFieldName: string;
  const AFieldKind: TFieldKind; const AFieldType: TFieldType; const AFieldSize: Integer);
begin
  case AFieldType of
    ftShortInt, ftSmallInt, ftInteger, ftLargeInt:
      with TIntegerField.Create(ADataSet) do
      begin
        FieldName := AFieldName;
        FieldKind := AFieldKind;
        DataSet := ADataSet;
      end;
    ftString:
      with TStringField.Create(ADataSet) do
      begin
        FieldName := AFieldName;
        FieldKind := AFieldKind;
        Size := AFieldSize;
        DataSet := ADataSet;
      end;
    ftBoolean:
      with TBooleanField.Create(ADataSet) do
      begin
        FieldName := AFieldName;
        FieldKind := AFieldKind;
        DataSet := ADataSet;
      end;
    ftFloat:
      with TFloatField.Create(ADataSet) do
      begin
        FieldName := AFieldName;
        FieldKind := AFieldKind;
        DataSet := ADataSet;
      end;
    ftMemo:
      with TMemoField.Create(ADataSet) do
      begin
        FieldName := AFieldName;
        FieldKind := AFieldKind;
        Size := 0;
        DataSet := ADataSet;
      end;
  end;
end;
procedure TClientDM.CreateFieldsReceipt(ADataSet: TDataSet);
begin
  if not ADataSet.Active then
    ADataSet.Open;
  try
    ADataSet.Close;
    ADataSet.Fields.Clear;
    for var I := 0 to Pred(ADataSet.FieldDefs.Count) do
      ADataSet.FieldDefs[I].CreateField(ADataSet);
    CreateField(ADataSet, 'calc_cancel_yn', fkCalculated, ftString, 4);
    CreateField(ADataSet, 'calc_sale_root_div', fkCalculated, ftString, 10);
    CreateField(ADataSet, 'calc_receipt_no', fkCalculated, ftString, 10);
    CreateField(ADataSet, 'calc_more_dc_amt', fkCalculated, ftInteger, 0);
    CreateField(ADataSet, 'calc_coupon_dc_amt', fkCalculated, ftInteger, 0);
    CreateField(ADataSet, 'calc_sale_dc_amt', fkCalculated, ftInteger, 0);
    CreateField(ADataSet, 'calc_sale_amt', fkCalculated, ftInteger, 0);
    ADataSet.OnCalcFields := OnReceiptCalcFields;
  finally
    ADataSet.Open;
  end;
end;
procedure TClientDM.CreateFieldsSaleItem(ADataSet: TDataSet);
begin
  if not ADataSet.Active then
    ADataSet.Open;
  try
    ADataSet.Close;
    ADataSet.Fields.Clear;
    for var I := 0 to Pred(ADataSet.FieldDefs.Count) do
      ADataSet.FieldDefs[I].CreateField(ADataSet);
    CreateField(ADataSet, 'calc_product_div', fkCalculated, ftString, 20);
    CreateField(ADataSet, 'calc_sell_subtotal', fkCalculated, ftInteger, 0);
    CreateField(ADataSet, 'calc_charge_amt', fkCalculated, ftInteger, 0);
    CreateField(ADataSet, 'calc_vat_subtotal', fkCalculated, ftInteger, 0);
    CreateField(ADataSet, 'calc_dc_amt', fkCalculated, ftInteger, 0);
    CreateField(ADataSet, 'calc_coupon_dc_amt', fkCalculated, ftInteger, 0);
    ADataSet.OnCalcFields := OnSaleItemCalcFields;
  finally
    ADataSet.Open;
  end;
end;
procedure TClientDM.CreateFieldsPayment(ADataSet: TDataSet);
begin
  if not ADataSet.Active then
    ADataSet.Open;
  try
    ADataSet.Close;
    ADataSet.Fields.Clear;
    for var I := 0 to Pred(ADataSet.FieldDefs.Count) do
      ADataSet.FieldDefs[I].CreateField(ADataSet);
    CreateField(ADataSet, 'calc_pay_method', fkCalculated, ftString, 20);
    CreateField(ADataSet, 'calc_approval_yn', fkCalculated, ftString, 4);
    CreateField(ADataSet, 'calc_cancel_count', fkCalculated, ftInteger, 0);
    ADataSet.OnCalcFields := OnPaymentCalcFields;
  finally
    ADataSet.Open;
  end;
end;
procedure TClientDM.CreateFieldsCoupon(ADataSet: TDataSet);
begin
  if not ADataSet.Active then
    ADataSet.Open;
  try
    ADataSet.Close;
    ADataSet.Fields.Clear;
    for var I := 0 to Pred(ADataSet.FieldDefs.Count) do
      ADataSet.FieldDefs[I].CreateField(ADataSet);
    CreateField(ADataSet, 'calc_dc_div', fkCalculated, ftString, 10);
    CreateField(ADataSet, 'calc_dc_cnt', fkCalculated, ftString, 10);
    CreateField(ADataSet, 'calc_product_div', fkCalculated, ftString, 10);
    CreateField(ADataSet, 'calc_teebox_product_div', fkCalculated, ftString, 10);
    CreateField(ADataSet, 'calc_use_yn', fkCalculated, ftString, 10);
    ADataSet.OnCalcFields := OnCouponCalcFields;
  finally
    ADataSet.Open;
  end;
end;
function TClientDM.PostStampSave(const AProductCd, AHpNo, ASaveCnt: string; var AErrMsg: string): Boolean;
const
  CS_API = 'K614_StampSave';
var
  HC: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  JO, RO: TJSONObject;
  SS, RS: TStringStream;
  RBS: RawByteString;
  sUrl, sResCode, sResMsg: string;
begin
  Result := False;
  AErrMsg := '';
  JO := TJSONObject.Create;
  RO := nil;
  RS := TStringStream.Create;
  SS := nil;
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  HC := TIdHTTP.Create(nil);
  try
    Screen.Cursor := crSQLWait;
    JO.AddPair(TJSONPair.Create('store_cd', SaleManager.StoreInfo.StoreCode));
    JO.AddPair(TJSONPair.Create('product_cd', AProductCd));
    JO.AddPair(TJSONPair.Create('hp_no', AHpNo));
    JO.AddPair(TJSONPair.Create('save_cnt', ASaveCnt));
    SS := TStringStream.Create(JO.ToString, TEncoding.UTF8);
    SS.SaveToFile(Global.LogDir + CS_API + '.Request.json');
    try
      HC.Request.ContentType := 'application/json';
      HC.Request.CustomHeaders.Values['Authorization'] := 'Bearer ' + Global.ClientConfig.OAuthToken;
      HC.Request.Method := 'POST';
      SSL.SSLOptions.Method := sslvSSLv23;
      SSL.SSLOptions.Mode := sslmClient;
      HC.IOHandler := SSL;
      HC.HandleRedirects := False;
      HC.ConnectTimeout := Global.TeeBoxADInfo.APITimeout;
      HC.ReadTimeout := Global.TeeBoxADInfo.APITimeout;
      sUrl := Format('%s/wix/api/%s', [Global.ClientConfig.Host, CS_API]);
      HC.Post(sUrl, SS, RS);
      RS.SaveToFile(Global.LogDir + CS_API + '.Response.json');
      RBS := PAnsiChar(RS.Memory);
      SetCodePage(RBS, 65001, False);
      RO := TJSONObject.ParseJSONValue(String(RBS)) as TJSONObject;
      sResCode := RO.GetValue('result_cd').Value;
      sResMsg := RO.GetValue('result_msg').Value;
      if (sResCode <> CRC_SUCCESS) then
        raise Exception.Create(Format('ResultCode: %s, Message: %s', [sResCode, sResMsg]));
      Result := True;
    finally
      Screen.Cursor := crDefault;
      FreeAndNilJSONObject(RO);
      FreeAndNilJSONObject(JO);
      FreeAndNil(RS);
      if Assigned(SS) then
        FreeAndNil(SS);
      FreeAndNil(SSL);
      HC.Disconnect;
      FreeAndNil(HC);
    end;
  except
    on E: Exception do
    begin
      AErrMsg := E.Message;
      UpdateLog(Global.LogFile, Format('PostStampSave.Exception = %s', [E.Message]));
    end;
  end;
end;
end.

