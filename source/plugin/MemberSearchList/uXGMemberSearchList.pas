(*******************************************************************************

  Project     : XGOLF ���������� POS �ý���
  Title       : ȸ�� ��� ��ȸ
  Author      : �̼���
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2019-05-10   Initial Release.

  Copyright��SolbiPOS Co., Ltd. 2008-2019 All rights reserved.

*******************************************************************************)
unit uXGMemberSearchList;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons, StdCtrls, ExtCtrls,
  DB, Menus,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges, cxDBData,
  dxScrollbarAnnotations, cxLabel, cxCheckBox, cxCurrencyEdit, cxButtons, cxGridLevel, cxClasses,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView, cxGrid, cxContainer,
  cxImage, cxDBEdit,
  { TMS }
  AdvShapeButton, AdvMenus;

{$I ..\..\common\XGPOS.inc}

type
  TXGMemberSearchListForm = class(TPluginModule)
    lblFormTitle: TLabel;
    lblPluginVersion: TLabel;
    panFooter: TPanel;
    btnSelectTeeBoxProd: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    panBody: TPanel;
    panMemberList: TPanel;
    G1: TcxGrid;
    V1: TcxGridDBTableView;
    V1member_nm: TcxGridDBColumn;
    V1hp_no: TcxGridDBColumn;
    V1car_no: TcxGridDBColumn;
    V1address: TcxGridDBColumn;
    L1: TcxGridLevel;
    Panel1: TPanel;
    btnV1Up: TcxButton;
    btnV1Down: TcxButton;
    btnV1PageUp: TcxButton;
    btnV1PageDown: TcxButton;
    panTeeBoxProdList: TPanel;
    G2: TcxGrid;
    V2: TcxGridDBTableView;
    V2today_yn: TcxGridDBColumn;
    V2calc_product_div: TcxGridDBColumn;
    V2product_nm: TcxGridDBColumn;
    V2product_amt: TcxGridDBColumn;
    V2start_day: TcxGridDBColumn;
    V2end_day: TcxGridDBColumn;
    V2day_start_time: TcxGridDBColumn;
    V2day_end_time: TcxGridDBColumn;
    V2one_use_time: TcxGridDBColumn;
    V2one_use_cnt: TcxGridDBColumn;
    V2remain_cnt: TcxGridDBColumn;
    L2: TcxGridLevel;
    Panel2: TPanel;
    btnV2Up: TcxButton;
    btnV2Down: TcxButton;
    panTeleReserved: TPanel;
    imgTeleReserved: TImage;
    lblTeleReserved: TLabel;
    panLockerList: TPanel;
    G3: TcxGrid;
    V3: TcxGridDBTableView;
    V3calc_product_div: TcxGridDBColumn;
    V3product_nm: TcxGridDBColumn;
    V3purchase_amt: TcxGridDBColumn;
    V3start_day: TcxGridDBColumn;
    V3end_day: TcxGridDBColumn;
    V3locker_nm: TcxGridDBColumn;
    V3floor_nm: TcxGridDBColumn;
    V3zone_nm: TcxGridDBColumn;
    V3overdue_day: TcxGridDBColumn;
    V3calc_use_status: TcxGridDBColumn;
    L3: TcxGridLevel;
    Panel3: TPanel;
    btnV3Up: TcxButton;
    btnV3Down: TcxButton;
    V3product_div: TcxGridDBColumn;
    panMemberDetail: TPanel;
    lblPhotoTitle: TLabel;
    imgPhoto: TcxDBImage;
    btnClose: TAdvShapeButton;
    panSearchInfo: TPanel;
    lblSearchValue: TLabel;
    panFacilityTicket: TPanel;
    G4: TcxGrid;
    V4: TcxGridDBTableView;
    L4: TcxGridLevel;
    Panel5: TPanel;
    btnV4Up: TcxButton;
    btnV4Down: TcxButton;
    btnSelectFacilityTicket: TAdvShapeButton;
    V4product_nm: TcxGridDBColumn;
    V4facility_div_nm: TcxGridDBColumn;
    V4access_control_nm: TcxGridDBColumn;
    V4product_amt: TcxGridDBColumn;
    V4start_day: TcxGridDBColumn;
    V4end_day: TcxGridDBColumn;
    V4remain_cnt: TcxGridDBColumn;
    V4calc_use_status: TcxGridDBColumn;
    btnSelectMember: TAdvShapeButton;
    V2use_status: TcxGridDBColumn;
    V3use_status: TcxGridDBColumn;
    V4use_status: TcxGridDBColumn;
    V4Popup: TAdvPopupMenu;
    V4FacilityPurchaseListMenu: TMenuItem;
    V4FacilityUseListenu: TMenuItem;
    V4FacilityAccessHistoryMenu: TMenuItem;
    V1Popup: TAdvPopupMenu;
    V1MemberSearchNameMenu: TMenuItem;
    V1MemberSearchHpNoMenu: TMenuItem;
    V2Popup: TAdvPopupMenu;
    V3Popup: TAdvPopupMenu;
    V2TeeBoxReservedListMenu: TMenuItem;
    V2TeeBoxPurchaseListMenu: TMenuItem;
    V3LockerPurchaseListMenu: TMenuItem;
    procedure PluginModuleShow(Sender: TObject);
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnSelectTeeBoxProdClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSelectMemberClick(Sender: TObject);
    procedure OnGridViewCustomDrawColumnHeader(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
    procedure V1DblClick(Sender: TObject);
    procedure V1FocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
    procedure V2DblClick(Sender: TObject);
    procedure btnV1PageUpClick(Sender: TObject);
    procedure btnV1PageDownClick(Sender: TObject);
    procedure btnV1UpClick(Sender: TObject);
    procedure btnV1DownClick(Sender: TObject);
    procedure btnV2UpClick(Sender: TObject);
    procedure btnV2DownClick(Sender: TObject);
    procedure V2CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure V3CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure btnSelectFacilityTicketClick(Sender: TObject);
    procedure btnV3UpClick(Sender: TObject);
    procedure btnV3DownClick(Sender: TObject);
    procedure btnV4UpClick(Sender: TObject);
    procedure btnV4DownClick(Sender: TObject);
    procedure V4CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure V1PopupPopup(Sender: TObject);
    procedure V2PopupPopup(Sender: TObject);
    procedure V3PopupPopup(Sender: TObject);
    procedure V4PopupPopup(Sender: TObject);
    procedure V1MemberSearchNameMenuClick(Sender: TObject);
    procedure V1MemberSearchHpNoMenuClick(Sender: TObject);
    procedure V4FacilityPurchaseListMenuClick(Sender: TObject);
    procedure V4FacilityUseListenuClick(Sender: TObject);
    procedure V4FacilityAccessHistoryMenuClick(Sender: TObject);
    procedure V2TeeBoxReservedListMenuClick(Sender: TObject);
    procedure V2TeeBoxPurchaseListMenuClick(Sender: TObject);
    procedure V3LockerPurchaseListMenuClick(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FWorking: Boolean;
    FProdChange: Boolean; //��ȯ��ǰ ���� ����
    FTeeBoxReserveMode: Boolean; //Ÿ����ǰ ���� ��� ��� ����

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure RefreshMemberProdList;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  { Native }
  Vcl.Graphics, System.DateUtils,
  { DeevExpress }
  dxCore, cxGridCommon,
  { Indy }
  IdURI,
  { Project }
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGSaleManager, uXGMsgBox, uLayeredForm;

const
  LCN_MSEC_PER_DAY = Int64(1000 * 60 * 60 * 24);

var
  LF: TLayeredForm;

{$R *.dfm}

{ XGMemberSearchListForm }

constructor TXGMemberSearchListForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  FOwnerId := -1;
  FWorking := False;
  FProdChange := False;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  panTeleReserved.Visible := Global.TeeBoxTeleReserved;
  panFacilityTicket.Visible := SaleManager.StoreInfo.FacilityProdYN;
  btnSelectFacilityTicket.Enabled := SaleManager.StoreInfo.FacilityProdYN;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TXGMemberSearchListForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGMemberSearchListForm.PluginModuleShow(Sender: TObject);
var
  nHeight: Integer;
begin
  nHeight := (panTeeBoxProdList.Height div 2);
  btnV2Up.Height := nHeight;
  btnV2Down.Height := nHeight;

  RefreshMemberProdList;
  if FTeeBoxReserveMode and
     (not SaleManager.MemberInfo.PurchaseCode.IsEmpty) then
    ClientDM.MDTeeBoxProdMember.Locate('purchase_cd', SaleManager.MemberInfo.PurchaseCode, []);
end;

procedure TXGMemberSearchListForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  Action := caFree;
end;

procedure TXGMemberSearchListForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      btnCancel.Click;
    VK_RETURN:
      btnSelectMember.Click;
  end;
end;

procedure TXGMemberSearchListForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGMemberSearchListForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
    lblSearchValue.Caption := '���˻�����: ' + AMsg.ParamByString(CPP_MEMBER_NO);
    FProdChange := AMsg.ParamByBoolean(CPP_TEEBOX_PROD_CHANGE);
    FTeeBoxReserveMode := AMsg.ParamByBoolean(CPP_TEEBOX_RESERVED);
    btnSelectTeeBoxProd.Enabled := FTeeBoxReserveMode;

    if FTeeBoxReserveMode then
      lblFormTitle.Caption := 'ȸ���� Ÿ����ǰ ���� ��Ȳ'
    else
      lblFormTitle.Caption := 'ȸ�� �˻� ���';
  end;
end;

procedure TXGMemberSearchListForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGMemberSearchListForm.btnSelectMemberClick(Sender: TObject);
begin
  if FWorking then
    Exit;

  FWorking := True;
  try
    with V1.DataController.DataSet do
    begin
      if (RecordCount = 0) then
        Exit;

      ModalResult := mrOK; //ȸ�� ����
    end;
  finally
    FWorking := False;
  end;
end;

procedure TXGMemberSearchListForm.btnSelectTeeBoxProdClick(Sender: TObject);
var
  bAccepted, bTodayYN: Boolean;
  sProdCode, sProdDiv, sZoneCode, sAvailZoneCode, sCurDate, sCurTime, sProdStartTime, sProdEndTime,
  sTeeBoxStartDateTime, sTeeBoxEndDateTime, sStartDate, sEndDate, sErrMsg: string;
  dTeeBoxStartDateTime, dTeeBoxEndDateTime, dProdStartDateTime, dProdEndDateTime: TDateTime;
  nRemainCnt, nUseStatus, nTeeBoxNo, nAssignMin: Integer;
begin
  if FWorking then
    Exit;

  FWorking := True;
  try
    with V2.DataController.DataSet do
    begin
      if (RecordCount = 0) then
        Exit;

      nUseStatus := FieldByName('use_status').AsInteger;
      if (nUseStatus <> CPS_PRODUCT_INUSE) then
      begin
        XGMsgBox(Self.Handle, mtError, '�˸�',
          Format('������ Ÿ�� ��ǰ�� ���� [%s] �����Դϴ�!', [FieldByName('calc_use_status').AsString]), ['Ȯ��'], 5);
        Exit;
      end;

      sCurDate := Global.FormattedCurrentDate;
      sCurTime := Copy(Global.FormattedCurrentTime, 1, 5); //hh:nn', Now)
      sProdCode := FieldByName('product_cd').AsString;
      sProdDiv := FieldByName('product_div').AsString;
      sProdStartTime := FieldByName('day_start_time').AsString;
      sProdEndtime := FieldByName('day_end_time').AsString;
      nAssignMin := FieldByName('one_use_time').AsInteger;
      sStartDate := FieldByName('start_day').AsString;
      sEndDate := FieldByName('end_day').AsString;
      nRemainCnt := FieldByName('remain_cnt').AsInteger;
      if SaleManager.StoreInfo.IsNextDay(sCurTime) then
      begin
        if (sProdStartTime > sProdEndTime) then
          dProdStartDateTime := StrToDateTime(Format('%s %s:00', [Global.FormattedLastDate, sProdStartTime]), Global.FS)
        else
          dProdStartDateTime := StrToDateTime(Format('%s %s:00', [Global.FormattedCurrentDate, sProdStartTime]), Global.FS);

        dProdEndDateTime := StrToDateTime(Format('%s %s:00', [Global.FormattedCurrentDate, sProdEndtime]), Global.FS);
      end
      else
      begin
        dProdStartDateTime := StrToDateTime(Format('%s %s:00', [Global.FormattedCurrentDate, sProdStartTime]), Global.FS);
        if (sProdStartTime > sProdEndTime) then
          dProdEndDateTime := StrToDateTime(Format('%s %s:00', [Global.FormattedNextDate, sProdEndtime]), Global.FS)
        else
          dProdEndDateTime := StrToDateTime(Format('%s %s:00', [Global.FormattedCurrentDate, sProdEndtime]), Global.FS);
      end;

      //��ȯ��ǰ ���� ��尡 �ƴϸ� ���� ��� �Ұ���ǰ ���� �Ұ�(2020-03-10)
      if (not FProdChange) then
      begin
        bTodayYN := FieldByName('today_yn').AsBoolean;
        if (not bTodayYN) or
           (nUseStatus <> CPS_PRODUCT_INUSE) or
           ((sProdDiv = CTP_COUPON) and (nRemainCnt = 0)) or
           (sStartDate > sCurDate) or
           (sEndDate < sCurDate) then
        begin
          XGMsgBox(Self.Handle, mtWarning, '�˸�', '�̿� ���ǿ� ���� �ʾ� ������ �̿��� �� ���� ��ǰ�Դϴ�!' + _CRLF +
            '[��ǰ����] ' + IIF(nUseStatus = CPS_PRODUCT_RECESS, '��ȸ ��', IIF(nUseStatus = CPS_PRODUCT_BEFORE, '�̿� ��', '��� �Ұ�')) + _CRLF +
            IIF(bTodayYN, '', '[�����̿�] �ش� ����' + _CRLF) +
            Format('[���Ⱓ] %s ~ %s', [FormattedDateString(sStartDate), FormattedDateString(sEndDate)]) + _CRLF +
            IIF(sProdDiv = CTP_COUPON, Format('[�ܿ�����] %d ��', [nRemainCnt]), ''),
            ['Ȯ��'], 10);
          Exit;
        end;
      end;
    end;

    bAccepted := True;
    with ClientDM.MDTeeBoxSelected do
    try
      DisableControls;
      First;
      while not Eof do
      begin
        nTeeBoxNo := FieldByName('teebox_no').AsInteger;
        sZoneCode := FieldByName('zone_cd').AsString;
        if ClientDM.MDTeeBoxStatus2.Locate('teebox_no', nTeeBoxNo, []) then
        begin
          sTeeBoxEndDateTime := ClientDM.MDTeeBoxStatus2.FieldByName('end_datetime').AsString;
          if sTeeBoxEndDateTime.IsEmpty then //�� Ÿ��
          begin
            if (not SaleManager.StoreInfo.EndTimeIgnoreYN) and //���� ����ð� üũ ����
               (dProdStartDateTime > SaleManager.StoreInfo.StoreEndDateTime) then
            begin
              XGMsgBox(Self.Handle, mtWarning, '�˸�', '�����ð� ���� �̿��� �� ���� ��ǰ�Դϴ�!' + _CRLF +
                Format('[�����ð�] %s ~ %s', [FormatDateTime('yyyy-mm-dd hh:nn', SaleManager.StoreInfo.StoreStartDateTime), FormatDateTime('yyyy-mm-dd hh:nn', SaleManager.StoreInfo.StoreEndDateTime)]) + _CRLF +
                Format('[��ǰ�ð�] %s ~ %s', [FormatDateTime('yyyy-mm-dd hh:nn', dProdStartDateTime), FormatDateTime('yyyy-mm-dd hh:nn', dProdEndDateTime)]),
                ['Ȯ��'], 5);
              bAccepted := False;
              Break;
            end;

            dTeeBoxStartDateTime := IncMinute(Now, Global.PrepareMin);
            dTeeBoxEndDateTime := IncMinute(dTeeBoxStartDateTime, nAssignMin);
          end
          else
          begin
            if Global.NoShowInfo.NoShowReserved then
            begin
              dTeeBoxStartDateTime := IncMinute(StrToDateTime(Global.NoShowInfo.ReserveDateTime, Global.FS), Global.NoShowInfo.PrepareMin);
              dTeeBoxEndDateTime := IncMinute(dTeeBoxStartDateTime, Global.NoShowInfo.AssignMin);
            end
            else
            begin
              dTeeBoxStartDateTime := IncMinute(StrToDateTime(sTeeBoxEndDateTime, Global.FS), Global.PrepareMin);
              dTeeBoxEndDateTime := IncMinute(dTeeBoxStartDateTime, nAssignMin);
            end;

            if (not SaleManager.StoreInfo.EndTimeIgnoreYN) and //���� ����ð� üũ ����
               (not Global.NoShowInfo.NoShowReserved) and //������ �ƴ� ��쿡�� ����ð� üũ
               ((dTeeBoxStartDateTime < SaleManager.StoreInfo.StoreStartDateTime) or
                (dTeeBoxStartDateTime > SaleManager.StoreInfo.StoreEndDateTime)) then
            begin
              XGMsgBox(Self.Handle, mtWarning, '�˸�', '�����ð� ���� �̿��� �� ���� ��ǰ�Դϴ�!' + _CRLF +
                Format('[�����ð�] %s ~ %s', [FormatDateTime('yyyy-mm-dd hh:nn', SaleManager.StoreInfo.StoreStartDateTime), FormatDateTime('yyyy-mm-dd hh:nn', SaleManager.StoreInfo.StoreEndDateTime)]) + _CRLF +
                Format('[����ð�] %s ~ %s', [FormatDateTime('yyyy-mm-dd hh:nn', dTeeBoxStartDateTime), FormatDateTime('yyyy-mm-dd hh:nn', dTeeBoxEndDateTime)]),
                ['Ȯ��'], 5);
              bAccepted := False;
              Break;
            end;
          end;

          if Global.ReserveAllowedOnOrderTime then
            sTeeBoxStartDateTime := Global.CurrentDateTime
          else
            sTeeBoxStartDateTime := FormatDateTime('yyyymmddhhnnss', dTeeBoxStartDateTime);

          if not ClientDM.CheckTeeBoxProdTime(sProdCode, sTeeBoxStartDateTime, nTeeBoxNo, nAssignMin, sErrMsg) then
          begin
            XGMsgBox(Self.Handle, mtWarning, '�˸�', sErrMsg + _CRLF +
              '[�ֹ��ð� ���� Ÿ������ ���] ' + IIF(Global.ReserveAllowedOnOrderTime, '��', '�ƴϿ�') + _CRLF +
              Format('[����ð�] %s ~ %s', [FormatDateTime('yyyy-mm-dd hh:nn', dTeeBoxStartDateTime), FormatDateTime('yyyy-mm-dd hh:nn', dTeeBoxEndDateTime)]),
              ['Ȯ��'], 5);
            bAccepted := False;
            Break;
          end;

          with ClientDM.MDTeeBoxProdMember do
          begin
            sAvailZoneCode := FieldByName('avail_zone_cd').AsString;
            if (not sZoneCode.IsEmpty) and
               (Pos(sZoneCode, sAvailZoneCode) = 0) then
            begin
              XGMsgBox(Self.Handle, mtWarning, '�˸�', '������ ��ǰ�� ���� Ÿ���� �̿��� �� ���� ��ǰ�Դϴ�!' + _CRLF +
                '[�̿��� Ÿ�� ����] ' + ClientDM.GetZoneCodeNames(sZoneCode) + _CRLF +
                '[������ ��ǰ ����] ' + ClientDM.GetZoneCodeNames(sAvailZoneCode),
                ['Ȯ��'], 5);
              bAccepted := False;
              Break;
            end;

            if (FieldByName('one_use_time').AsInteger <> nAssignMin) then
            begin
              Edit;
              FieldValues['one_use_time'] := nAssignMin;
              Post;
            end;
          end;
        end;

        Next;
      end;
    finally
      EnableControls;
    end;

    if bAccepted then
      ModalResult := mrYes; //Ÿ�� ��ǰ ����
  finally
    FWorking := False;
  end;
end;

procedure TXGMemberSearchListForm.btnSelectFacilityTicketClick(Sender: TObject);
var
  sPurchaseCode, sBarcode, sAccssName, sErrMsg: string;
  nUseStatus: Integer;
begin
  with ClientDM.MDFacilityProdMember do
  try
    if (RecordCount = 0) then
      Exit;

    nUseStatus := FieldByName('use_status').AsInteger;
    if (nUseStatus <> CPS_PRODUCT_INUSE) then
    begin
      XGMsgBox(Self.Handle, mtError, '�˸�',
        Format('������ �δ�ü� ��ǰ�� ���� [%s] �����Դϴ�!', [FieldByName('calc_use_status').AsString]), ['Ȯ��'], 5);
      Exit;
    end;

    if FieldByName('today_used_yn').AsBoolean and
       (FieldByName('facility_div').AsString = CTP_COUPON) then
      if (XGMsgBox(Self.Handle, mtConfirmation, '�߰� ��� ��� Ȯ��',
            '������ �δ�ü� ��ǰ�� ���� ��� ����� �Ǿ� �ֽ��ϴ�!' + _CRLF + '������ �����Ͽ� �߰��� ��� ����� �Ͻðڽ��ϱ�?',
            ['��', '�ƴϿ�']) <> mrOK) then
        Exit;

    sPurchaseCode := FieldByName('purchase_cd').AsString;
    if FieldByName('ticket_print_yn').AsBoolean then
    begin
      if not ClientDM.PostUseFacility(sPurchaseCode, sBarcode, sAccssName, sErrMsg) then
        raise Exception.Create(sErrMsg);
      with SaleManager.ReceiptInfo do
      try
        SetLength(FacilityList, 1);
        FacilityList[0].AccessBarcode := ''; //���Կ� ���ڵ�� �μ����� �ʱ� ���� ������ ����
        FacilityList[0].AccessControlName := sAccssName;
        FacilityList[0].ProdDiv := FieldByName('facility_div').AsString;
        FacilityList[0].ProdName := FieldByName('product_nm').AsString;
        FacilityList[0].UseStartDate := FieldByName('start_day').AsString;
        FacilityList[0].UseEndDate := FieldByName('end_day').AsString;
        FacilityList[0].RemainCount := FieldByName('remain_cnt').AsInteger;
        if not Global.ReceiptPrint.FacilityTicketPrint(True, sErrMsg) then
        begin
          XGMsgBox(Self.Handle, mtWarning, '�˸�', '�ü���ǰ ����ǥ�� ����� �� �����ϴ�!' + _CRLF + sErrMsg, ['Ȯ��'], 5);
          Exit;
        end;
      finally
        SetLength(SaleManager.ReceiptInfo.FacilityList, 0);
      end;
    end
    else
      if not ClientDM.PostUseFacility(sPurchaseCode, sErrMsg) then
        raise Exception.Create(sErrMsg);

    RefreshMemberProdList;
    XGMsgBox(Self.Handle, mtInformation, '�˸�', '�δ�ü� ��ǰ ��� ����� �Ϸ�Ǿ����ϴ�!', ['Ȯ��'], 5);
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', '�δ�ü� ��ǰ ��� ����� �Ϸ���� ���Ͽ����ϴ�!' + _CRLF + E.Message, ['Ȯ��'], 5);
  end;
end;

procedure TXGMemberSearchListForm.btnV1PageUpClick(Sender: TObject);
begin
  GridScrollPageUp(V1);
end;

procedure TXGMemberSearchListForm.btnV1UpClick(Sender: TObject);
begin
  GridScrollUp(V1);
end;

procedure TXGMemberSearchListForm.btnV1DownClick(Sender: TObject);
begin
  GridScrollDown(V1);
end;

procedure TXGMemberSearchListForm.btnV1PageDownClick(Sender: TObject);
begin
  GridScrollPageDown(V1);
end;

procedure TXGMemberSearchListForm.btnV2UpClick(Sender: TObject);
begin
  GridScrollUp(V2);
end;

procedure TXGMemberSearchListForm.btnV2DownClick(Sender: TObject);
begin
  GridScrollDown(V2);
end;

procedure TXGMemberSearchListForm.btnV3UpClick(Sender: TObject);
begin
  GridScrollUp(V3);
end;

procedure TXGMemberSearchListForm.btnV3DownClick(Sender: TObject);
begin
  GridScrollDown(V3);
end;

procedure TXGMemberSearchListForm.btnV4UpClick(Sender: TObject);
begin
  GridScrollUp(V4);
end;

procedure TXGMemberSearchListForm.btnV4DownClick(Sender: TObject);
begin
  GridScrollDown(V4);
end;

procedure TXGMemberSearchListForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGMemberSearchListForm.V1DblClick(Sender: TObject);
begin
  btnSelectMember.Click;
end;

procedure TXGMemberSearchListForm.V1FocusedRecordChanged(Sender: TcxCustomGridTableView;
  APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  RefreshMemberProdList;
end;

procedure TXGMemberSearchListForm.V2DblClick(Sender: TObject);
begin
  if FTeeBoxReserveMode then
    btnSelectTeeBoxProd.Click;
end;

procedure TXGMemberSearchListForm.V2CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  dCurDate, dEndDate: TDateTime;
begin
  try
    dCurDate := StrToDateTime(Global.FormattedCurrentDate + ' 00:00:00', Global.FS);
    dEndDate := StrToDateTime(AViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('end_day').Index] + ' 00:00:00', Global.FS);
    //�������ڰ� 6�� ���Ϸ� ���Ұų� �̿븸��, ��ȸ���� ��ǰ�� �ٸ� �������� ǥ��
    if (StrToIntDef(AViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('use_status').Index], 0) in [CPS_PRODUCT_CLOSE, CPS_PRODUCT_RECESS]) then //�̿� ���� �Ǵ� ��ȸ��
      ACanvas.Font.Color := CTC_IMMINENT //ACanvas.Font.Color := CTC_EXPIRED
    else if (StrToIntDef(AViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('use_status').Index], 0) in [CPS_PRODUCT_INUSE]) and
            ((DateTimeToMilliseconds(dEndDate) - DateTimeToMilliseconds(dCurDate)) div LCN_MSEC_PER_DAY < 7) then //�̿� ���� �ӹ�
    begin
      ACanvas.Font.Color := CTC_IMMINENT;
      ACanvas.Font.Style := [fsBold];
    end;
  except
  end;
end;

procedure TXGMemberSearchListForm.V3CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  dCurDate, dEndDate: TDateTime;
begin
  try
    if (AViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('product_div').Index] = CPD_LOCKER) then //�������� �����ؾ� �ϹǷ�
    begin
      dCurDate := StrToDateTime(Global.FormattedCurrentDate + ' 00:00:00', Global.FS);
      dEndDate := StrToDateTime(AViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('end_day').Index] + ' 00:00:00', Global.FS);
      //�������ڰ� 6�� ���Ϸ� ���Ұų� �̿븸��, ��ȸ���� ��ǰ�� �ٸ� �������� ǥ��
      if (StrToIntDef(AViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('use_status').Index], 0) in [CPS_LOCKER_MATURITY]) then //����
        ACanvas.Font.Color := CTC_IMMINENT //ACanvas.Font.Color := CTC_EXPIRED
      else if (StrToIntDef(AViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('use_status').Index], 0) in [CPS_LOCKER_INUSE]) and
              ((DateTimeToMilliseconds(dEndDate) - DateTimeToMilliseconds(dCurDate)) div LCN_MSEC_PER_DAY < 7) then //�������� �ӹ�
      begin
        ACanvas.Font.Color := CTC_IMMINENT;
        ACanvas.Font.Style := [fsBold];
      end;
    end;
  except
  end;
end;

procedure TXGMemberSearchListForm.V4CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  dCurDate, dEndDate: TDateTime;
begin
  try
    dCurDate := StrToDateTime(Global.FormattedCurrentDate + ' 00:00:00', Global.FS);
    dEndDate := StrToDateTime(AViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('end_day').Index] + ' 00:00:00', Global.FS);
    //�������ڰ� 6�� ���Ϸ� ���Ұų� �̿븸��, ��ȸ���� ��ǰ�� �ٸ� �������� ǥ��
    if (StrToIntDef(AViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('use_status').Index], 0) in [CPS_PRODUCT_CLOSE, CPS_PRODUCT_RECESS]) then //�̿� ���� �Ǵ� ��ȸ��
      ACanvas.Font.Color := CTC_IMMINENT //ACanvas.Font.Color := CTC_EXPIRED
    else if (StrToIntDef(AViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('use_status').Index], 0) in [CPS_PRODUCT_INUSE]) and
            ((DateTimeToMilliseconds(dEndDate) - DateTimeToMilliseconds(dCurDate)) div LCN_MSEC_PER_DAY < 7) then //�̿� ���� �ӹ�
    begin
      ACanvas.Font.Color := CTC_IMMINENT;
      ACanvas.Font.Style := [fsBold];
    end;
  except
  end;
end;

procedure TXGMemberSearchListForm.V1PopupPopup(Sender: TObject);
begin
  V1MemberSearchNameMenu.Enabled := (V1.DataController.DataSource.DataSet.RecordCount > 0);
  V1MemberSearchHpNoMenu.Enabled := (V1.DataController.DataSource.DataSet.RecordCount > 0);
end;

procedure TXGMemberSearchListForm.V1MemberSearchNameMenuClick(Sender: TObject);
var
  sUri, sMemberName, sTitle: string;
begin
  sMemberName := V1.DataController.DataSource.DataSet.FieldByName('member_nm').AsString;
  sTitle := Format('ȸ�� �˻� [%s]', [sMemberName]);
  // http://localhost:8080/loginPos?store_cd=T0002&id=wixnet&pw=12345678&s_member_nm=������&s_hp_no=&redirectUrl=/member/memberList
  sUri := Format('%s/loginPos?store_cd=%s&id=%s&pw=%s&s_member_nm=%s&s_hp_no=&redirectUrl=/member/memberList', [
      ExcludeTrailingBackslash(Global.BackOfficeUrl),
      SaleManager.StoreInfo.StoreCode,
      SaleManager.UserInfo.UserId,
      SaleManager.UserInfo.TerminalPwd,
      UTF8String(sMemberName)
    ]);
  ShowWebViewModal(Self.PluginId, sTitle, sUri, False);
end;

procedure TXGMemberSearchListForm.V1MemberSearchHpNoMenuClick(Sender: TObject);
var
  sUri, sHpNo, sTitle: string;
begin
  sHpNo := V1.DataController.DataSource.DataSet.FieldByName('hp_no').AsString;
  sTitle := Format('ȸ�� �˻� [%s]', [sHpNo]);
  // http://localhost:8080/loginPos?store_cd=T0002&id=wixnet&pw=12345678&s_member_nm=&s_hp_no=010-1234-5678&redirectUrl=/member/memberList
  sUri := Format('%s/loginPos?store_cd=%s&id=%s&pw=%s&s_member_nm=&s_hp_no=%s&redirectUrl=/member/memberList', [
      ExcludeTrailingBackslash(Global.BackOfficeUrl),
      SaleManager.StoreInfo.StoreCode,
      SaleManager.UserInfo.UserId,
      SaleManager.UserInfo.TerminalPwd,
      UTF8String(sHpNo)
    ]);
  ShowWebViewModal(Self.PluginId, sTitle, sUri, False);
end;

procedure TXGMemberSearchListForm.V2PopupPopup(Sender: TObject);
begin
  V2TeeBoxReservedListMenu.Enabled := (V1.DataController.DataSource.DataSet.RecordCount > 0);
  V2TeeBoxReservedListMenu.Enabled := (V1.DataController.DataSource.DataSet.RecordCount > 0);
end;

procedure TXGMemberSearchListForm.V2TeeBoxReservedListMenuClick(Sender: TObject);
var
  sUri, sMemberNo, sTitle, sTerm: string;
begin
  sMemberNo := V1.DataController.DataSource.DataSet.FieldByName('member_no').AsString;
  sTitle := Format('Ÿ����ǰ ���� ���� [%s]', [V1.DataController.DataSource.DataSet.FieldByName('member_nm').AsString]);
  sTerm := Format('%s - %s', [FormatDateTime('yyyy.mm.dd', Now - 7), FormatDateTime('yyyy.mm.dd', Now)]);
  // http://localhost:8080/loginPos?store_cd=T0002&id=wixnet&pw=12345678&s_member_nm=������&s_reg_date=2023.03.15 - 2023.03.22&redirectUrl=/seat/reserveList
  sUri := Format('%s/loginPos?store_cd=%s&id=%s&pw=%s&s_member_no=%s&s_reg_date=%s&redirectUrl=/seat/reserveList', [
      ExcludeTrailingBackslash(Global.BackOfficeUrl),
      SaleManager.StoreInfo.StoreCode,
      SaleManager.UserInfo.UserId,
      SaleManager.UserInfo.TerminalPwd,
      UTF8String(sMemberNo),
      TIdURI.ParamsEncode(sTerm)
    ]);
  ShowWebViewModal(Self.PluginId, sTitle, sUri, False);
end;

procedure TXGMemberSearchListForm.V2TeeBoxPurchaseListMenuClick(Sender: TObject);
var
  sUri, sMemberNo, sTitle, sTerm: string;
begin
  sMemberNo := V1.DataController.DataSource.DataSet.FieldByName('member_no').AsString;
  sTitle := Format('Ÿ����ǰ ���� ���� [%s]', [V1.DataController.DataSource.DataSet.FieldByName('member_nm').AsString]);
  sTerm := Format('%s - %s', [FormatDateTime('yyyy.mm.dd', IncMonth(Now, -1)), FormatDateTime('yyyy.mm.dd', Now)]);
  // http://localhost:8080/loginPos?store_cd=T0002&id=wixnet&pw=12345678&s_member_nm=������&s_purchase_date=2023.02.23 - 2023.03.22&redirectUrl=/seat/purchaseList
  sUri := Format('%s/loginPos?store_cd=%s&id=%s&pw=%s&s_member_no=%s&s_purchase_date=%s&redirectUrl=/seat/purchaseList', [
      ExcludeTrailingBackslash(Global.BackOfficeUrl),
      SaleManager.StoreInfo.StoreCode,
      SaleManager.UserInfo.UserId,
      SaleManager.UserInfo.TerminalPwd,
      UTF8String(sMemberNo),
      TIdURI.ParamsEncode(sTerm)
    ]);
  ShowWebViewModal(Self.PluginId, sTitle, sUri, False);
end;

procedure TXGMemberSearchListForm.V3PopupPopup(Sender: TObject);
begin
  V3LockerPurchaseListMenu.Enabled := (V1.DataController.DataSource.DataSet.RecordCount > 0);
end;

procedure TXGMemberSearchListForm.V3LockerPurchaseListMenuClick(Sender: TObject);
var
  sUri, sMemberNo, sTitle: string;
begin
  sMemberNo := V1.DataController.DataSource.DataSet.FieldByName('member_no').AsString;
  sTitle := Format('��Ŀ��ǰ ���� ���� [%s]', [V1.DataController.DataSource.DataSet.FieldByName('member_nm').AsString]);
  // http://localhost:8080/loginPos?store_cd=T0002&id=wixnet&pw=12345678&s_member_nm=������&redirectUrl=/locker/purchaseList
  sUri := Format('%s/loginPos?store_cd=%s&id=%s&pw=%s&s_member_no=%s&redirectUrl=/locker/purchaseList', [
      ExcludeTrailingBackslash(Global.BackOfficeUrl),
      SaleManager.StoreInfo.StoreCode,
      SaleManager.UserInfo.UserId,
      SaleManager.UserInfo.TerminalPwd,
      UTF8String(sMemberNo)
    ]);
  ShowWebViewModal(Self.PluginId, sTitle, sUri, False);
end;

procedure TXGMemberSearchListForm.V4PopupPopup(Sender: TObject);
begin
  V4FacilityPurchaseListMenu.Enabled := (V1.DataController.DataSource.DataSet.RecordCount > 0);
end;

procedure TXGMemberSearchListForm.V4FacilityPurchaseListMenuClick(Sender: TObject);
var
  sUri, sMemberNo, sTitle, sTerm: string;
begin
  sMemberNo := V1.DataController.DataSource.DataSet.FieldByName('member_no').AsString;
  sTitle := Format('�ü���ǰ ���� ���� [ȸ����: %s]', [V1.DataController.DataSource.DataSet.FieldByName('member_nm').AsString]);
  sTerm := Format('%s - %s', [FormatDateTime('yyyy.mm.dd', IncMonth(Now, -1)), FormatDateTime('yyyy.mm.dd', Now)]);
  // http://localhost:8080/loginPos?store_cd=T0002&id=wixnet&pw=12345678&s_member_nm=������&s_purchase_date=2023.02.23 - 2023.03.22&redirectUrl=/facility/facilityPurchaseList
  sUri := Format('%s/loginPos?store_cd=%s&id=%s&pw=%s&s_member_no=%s&s_purchase_date=%s&redirectUrl=/facility/facilityPurchaseList', [
      ExcludeTrailingBackslash(Global.BackOfficeUrl),
      SaleManager.StoreInfo.StoreCode,
      SaleManager.UserInfo.UserId,
      SaleManager.UserInfo.TerminalPwd,
      UTF8String(sMemberNo),
      TIdURI.ParamsEncode(sTerm)
    ]);
  ShowWebViewModal(Self.PluginId, sTitle, sUri, False);
end;

procedure TXGMemberSearchListForm.V4FacilityUseListenuClick(Sender: TObject);
var
  sUri, sMemberNo, sTitle, sTerm: string;
begin
  sMemberNo := V1.DataController.DataSource.DataSet.FieldByName('member_no').AsString;
  sTitle := Format('�ü� �̿� ���� [ȸ����: %s]', [V1.DataController.DataSource.DataSet.FieldByName('member_nm').AsString]);
  sTerm := Format('%s - %s', [FormatDateTime('yyyy.mm.dd', Now - 7), FormatDateTime('yyyy.mm.dd', Now)]);
  // http://localhost:8080/loginPos?store_cd=T0002&id=wixnet&pw=12345678&s_member_nm=������&s_use_date=2023.03.15 - 2023.03.22&redirectUrl=/facility/facilityUseList
  sUri := Format('%s/loginPos?store_cd=%s&id=%s&pw=%s&s_member_no=%s&s_use_date=%s&redirectUrl=/facility/facilityUseList', [
      ExcludeTrailingBackslash(Global.BackOfficeUrl),
      SaleManager.StoreInfo.StoreCode,
      SaleManager.UserInfo.UserId,
      SaleManager.UserInfo.TerminalPwd,
      UTF8String(sMemberNo),
      TIdURI.ParamsEncode(sTerm)
    ]);
  ShowWebViewModal(Self.PluginId, sTitle, sUri, False);
end;

procedure TXGMemberSearchListForm.V4FacilityAccessHistoryMenuClick(Sender: TObject);
var
  sUri, sMemberNo, sTitle, sTerm: string;
begin
  sMemberNo := V1.DataController.DataSource.DataSet.FieldByName('member_no').AsString;
  sTitle := Format('�ü� ���� ���� [ȸ����: %s]', [V1.DataController.DataSource.DataSet.FieldByName('member_nm').AsString]);
  sTerm := Format('%s - %s', [FormatDateTime('yyyy.mm.dd', Now - 7), FormatDateTime('yyyy.mm.dd', Now)]);
  // http://localhost:8080/loginPos?store_cd=T0002&id=wixnet&pw=12345678&s_member_nm=������&s_reg_date=2023.03.15 - 2023.03.22&redirectUrl=/facility/accessHistList
  sUri := Format('%s/loginPos?store_cd=%s&id=%s&pw=%s&s_member_no=%s&s_reg_date=%s&redirectUrl=/facility/accessHistList', [
      ExcludeTrailingBackslash(Global.BackOfficeUrl),
      SaleManager.StoreInfo.StoreCode,
      SaleManager.UserInfo.UserId,
      SaleManager.UserInfo.TerminalPwd,
      UTF8String(sMemberNo),
      TIdURI.ParamsEncode(sTerm)
    ]);
  ShowWebViewModal(Self.PluginId, sTitle, sUri, False);
end;

procedure TXGMemberSearchListForm.RefreshMemberProdList;
var
  sMemberNo, sMemberName, sErrMsg: string;
begin
  if FWorking then
    Exit;

  FWorking := True;
  try
    try
      with ClientDM.MDMemberSearch do
      begin
        sMemberNo := FieldByName('member_no').AsString;
        sMemberName := FieldByName('member_nm').AsString;
        UpdateLog(Global.LogFile, Format('ȸ���˻� : %s (%s)', [sMemberName, sMemberNo]));

        G1.Enabled := False;
        btnSelectTeeBoxProd.Enabled := False;
        if not ClientDM.GetTeeBoxProdMember(sMemberNo, '', sErrMsg) then
          raise Exception.Create(sMemberName + ' ȸ���� Ÿ�� ��ǰ ������ ������ �� �����ϴ�!' + sErrMsg);

        if not ClientDM.GetLockerProdMember(sMemberNo, sErrMsg) then
          XGMsgBox(Self.Handle, mtError, '�˸�', sMemberName + ' ȸ���� ��Ŀ ��ǰ ������ ������ �� �����ϴ�!' + sErrMsg, ['Ȯ��'], 5);

        if not ClientDM.GetFacilityProdMember(sMemberNo, sErrMsg) then
          XGMsgBox(Self.Handle, mtError, '�˸�', sMemberName + ' ȸ���� �δ�ü� ��ǰ ������ ������ �� �����ϴ�!' + sErrMsg, ['Ȯ��'], 5);

        btnSelectFacilityTicket.Enabled := (SaleManager.StoreInfo.FacilityProdYN and (ClientDM.MDFacilityProdMember.RecordCount > 0));

        (*
        MS := TMemoryStream.Create;
        try
          imgPhoto.Picture.Assign(nil);
          try
            TBlobField(FieldByName('photo')).SaveToStream(MS);
            MS.Position := 0;
            if (MS.Size > 32) then
            begin
              TBlobField(FieldByName('photo')).SaveToFile(Global.LogDir + sMemberNo + '.jpg');
              imgPhoto.Picture.LoadFromStream(MS);
            end;
          except
            on E: Exception do
              UpdateLog(Global.LogFile, Format('MemberSearchList.RefreshMemberProdList.Exception = %s', [E.Message]));
          end;
        finally
          MS.Free;
        end;
        *)
      end;

      btnSelectTeeBoxProd.Enabled := (FTeeBoxReserveMode and (V2.DataController.DataSet.RecordCount > 0));
    finally
      G1.Enabled := True;
      G1.SetFocus;
      FWorking := False;
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '�˸�', E.Message, ['Ȯ��'], 5);
  end;
end;

procedure TXGMemberSearchListForm.OnGridViewCustomDrawColumnHeader(Sender: TcxGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
var
  I: Integer;
begin
  AViewInfo.Borders := [];
  if AViewInfo.IsPressed then
  begin
    ACanvas.FillRect(AViewInfo.Bounds, clGreen);
    ACanvas.DrawComplexFrame(AViewInfo.Bounds, $00FFFFFF, $00FFFFFF, cxBordersAll, 1);
    ACanvas.DrawTexT(AViewInfo.Text, AViewInfo.TextBounds, cxAlignHCenter or cxAlignVCenter);

    ACanvas.ExcludeClipRect(AViewInfo.Bounds);
  end
  else
    ACanvas.FillRect(AViewInfo.Bounds, $00303030); //$00689F0E;

  ACanvas.DrawComplexFrame(AViewInfo.Bounds, $00FFFFFF, $00FFFFFF, cxBordersAll, 1);
  ACanvas.DrawTexT(AViewInfo.Text, AViewInfo.TextBounds, cxAlignHCenter or cxAlignVCenter);
  for I := 0 to Pred(AViewInfo.AreaViewInfoCount) do
  begin
    if AViewInfo.AreaViewInfos[I] is TcxGridColumnHeaderSortingMarkViewInfo then
      AViewInfo.LookAndFeelPainter.DrawSortingMark(ACanvas, TcxGridColumnHeaderSortingMarkViewInfo(AViewInfo.AreaViewInfos[I]).Bounds, AViewInfo.Column.SortOrder = soAscending);
    if AViewInfo.AreaViewInfos[I] is TcxGridColumnHeaderFilterButtonViewInfo then
      AViewInfo.LookAndFeelPainter.DrawFilterDropDownButton(ACanvas, AViewInfo.AreaViewInfos[I].Bounds, GridCellStateToButtonState(AViewInfo.AreaViewInfos[I].State), TcxGridColumnHeaderFilterButtonViewInfo(AViewInfo.AreaViewInfos[I]).Active);
  end;
  ADone := True;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGMemberSearchListForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.