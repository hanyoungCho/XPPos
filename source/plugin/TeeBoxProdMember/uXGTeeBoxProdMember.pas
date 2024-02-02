(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 회원별 타석 상품 보유 현황
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2019-05-10   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2019 All rights reserved.

*******************************************************************************)
unit uXGTeeBoxProdMember;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons, StdCtrls, ExtCtrls, DB,
  Menus,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, dxDateRanges, cxCurrencyEdit,
  dxScrollbarAnnotations, cxDBData, cxCheckBox, cxLabel, cxButtons, cxGridLevel, cxGridTableView,
  cxGridCustomTableView, cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid,
  { TMS }
  AdvShapeButton;

{$I ..\..\common\XGPOS.inc}

type
  TXGTeeBoxProdMemberForm = class(TPluginModule)
    lblFormTitle: TLabel;
    panBody: TPanel;
    lblPluginVersion: TLabel;
    btnOK: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    panTeeBoxList: TPanel;
    G1: TcxGrid;
    V1: TcxGridDBTableView;
    V1today_yn: TcxGridDBColumn;
    V1calc_product_div: TcxGridDBColumn;
    V1product_nm: TcxGridDBColumn;
    V1product_amt: TcxGridDBColumn;
    V1start_day: TcxGridDBColumn;
    V1end_day: TcxGridDBColumn;
    V1day_start_time: TcxGridDBColumn;
    V1day_end_time: TcxGridDBColumn;
    V1one_use_time: TcxGridDBColumn;
    V1one_use_cnt: TcxGridDBColumn;
    V1remain_cnt: TcxGridDBColumn;
    L1: TcxGridLevel;
    Panel1: TPanel;
    btnV1Up: TcxButton;
    btnV1Down: TcxButton;
    btnV1PageUp: TcxButton;
    btnV1PageDown: TcxButton;
    lblMemberName: TLabel;
    btnParkingMemberUpdate: TAdvShapeButton;
    panLockerList: TPanel;
    G2: TcxGrid;
    V2: TcxGridDBTableView;
    L2: TcxGridLevel;
    Panel3: TPanel;
    btnV2Up: TcxButton;
    btnV2Down: TcxButton;
    V2product_nm: TcxGridDBColumn;
    V2purchase_amt: TcxGridDBColumn;
    V2start_day: TcxGridDBColumn;
    V2end_day: TcxGridDBColumn;
    V2locker_nm: TcxGridDBColumn;
    V2floor_nm: TcxGridDBColumn;
    V2zone_nm: TcxGridDBColumn;
    V2overdue_day: TcxGridDBColumn;
    V2calc_product_div: TcxGridDBColumn;
    V2calc_use_status: TcxGridDBColumn;
    Label1: TLabel;
    panTeleReserved: TPanel;
    imgTeleReserved: TImage;
    lblTeleReserved: TLabel;
    V2product_div: TcxGridDBColumn;
    btnClose: TAdvShapeButton;
    V1use_status: TcxGridDBColumn;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure btnCloseClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnV1UpClick(Sender: TObject);
    procedure btnV1DownClick(Sender: TObject);
    procedure btnV1PageUpClick(Sender: TObject);
    procedure btnV1PageDownClick(Sender: TObject);
    procedure OnGridViewCustomDrawColumnHeader(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridColumnHeaderViewInfo; var ADone: Boolean);
    procedure V1DblClick(Sender: TObject);
    procedure PluginModuleActivate(Sender: TObject);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnParkingMemberUpdateClick(Sender: TObject);
    procedure btnV2UpClick(Sender: TObject);
    procedure btnV2DownClick(Sender: TObject);
    procedure V1CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure V2CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
  private
    { Private declarations }
    FOwnerId: Integer;
    FProdChange: Boolean; //전환상품 선택 여부
    FWorking: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  { Native }
  Graphics, DateUtils,
  { DevExpress }
  dxCore, cxGridCommon,
  { Project }
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGSaleManager, uXGMsgBox, uLayeredForm;

const
  LCN_MSEC_PER_DAY = Int64(1000 * 60 * 60 * 24);

var
  LF: TLayeredForm;

{$R *.dfm}

{ TXGTeeBoxProdMemberForm }

constructor TXGTeeBoxProdMemberForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
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
  panBody.Color := $00FFFFFF;
  lblMemberName.Caption := Format('▶회원명: %s (%s)', [SaleManager.MemberInfo.MemberName, SaleManager.MemberInfo.MemberNo]);
  btnParkingMemberUpdate.Enabled := Global.ParkingServer.Enabled;
  panTeleReserved.Visible := Global.TeeBoxTeleReserved;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TXGTeeBoxProdMemberForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGTeeBoxProdMemberForm.PluginModuleActivate(Sender: TObject);
begin
  G1.SetFocus;
end;

procedure TXGTeeBoxProdMemberForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  Action := caFree;
end;

procedure TXGTeeBoxProdMemberForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGTeeBoxProdMemberForm.ProcessMessages(AMsg: TPluginMessage);
var
  sErrMsg: string;
begin
  if (AMsg.Command = CPC_INIT) then
  try
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
    FProdChange := AMsg.ParamByBoolean(CPP_TEEBOX_PROD_CHANGE);
    if not SaleManager.MemberInfo.MemberNo.IsEmpty then
    begin
      if not ClientDM.GetTeeBoxProdMember(SaleManager.MemberInfo.MemberNo, '', sErrMsg) then
        raise Exception.Create(SaleManager.MemberInfo.MemberName + ' 회원의 타석상품 정보를 가져올 수 없습니다!' + sErrMsg);

      if (ClientDM.MDTeeBoxProdMember.RecordCount = 0) then
        raise Exception.Create(SaleManager.MemberInfo.MemberName + ' 회원의 사용 가능한 타석상품이 없습니다!');

      if not SaleManager.MemberInfo.PurchaseCode.IsEmpty then
        ClientDM.MDTeeBoxProdMember.Locate('purchase_cd', SaleManager.MemberInfo.PurchaseCode, []);

      if not ClientDM.GetLockerProdMember(SaleManager.MemberInfo.MemberNo, sErrMsg) then
        XGMsgBox(Self.Handle, mtError, '알림', SaleManager.MemberInfo.MemberName + ' 회원의 라커 정보를 가져올 수 없습니다!' + sErrMsg, ['확인'], 5);
    end;
  except
    on E: Exception do
    begin
      btnOK.Enabled := False;
      XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
    end;
  end;
end;

procedure TXGTeeBoxProdMemberForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      btnOK.Click;
    VK_ESCAPE:
      btnCancel.Click;
  end;
end;

procedure TXGTeeBoxProdMemberForm.OnGridViewCustomDrawColumnHeader(Sender: TcxGridTableView; ACanvas: TcxCanvas;
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
      AViewInfo.LookAndFeelPainter.DrawSortingMark(ACanvas, TcxGridColumnHeaderSortingMarkViewInfo(AViewInfo.AreaViewInfos[I]).Bounds,
      AViewInfo.Column.SortOrder = soAscending);
    if AViewInfo.AreaViewInfos[I] is TcxGridColumnHeaderFilterButtonViewInfo then
      AViewInfo.LookAndFeelPainter.DrawFilterDropDownButton(ACanvas, AViewInfo.AreaViewInfos[I].Bounds,
      GridCellStateToButtonState(AViewInfo.AreaViewInfos[I].State), TcxGridColumnHeaderFilterButtonViewInfo(AViewInfo.AreaViewInfos[I]).Active);
  end;
  ADone := True;
end;

procedure TXGTeeBoxProdMemberForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGTeeBoxProdMemberForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGTeeBoxProdMemberForm.V1CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  dCurDate, dEndDate: TDateTime;
begin
  try
    dCurDate := StrToDateTime(Global.FormattedCurrentDate + ' 00:00:00', Global.FS);
    dEndDate := StrToDateTime(AViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('end_day').Index] + ' 00:00:00', Global.FS);
    //종료일자가 6일 이하로 남았거나 이용만료, 휴회중인 상품은 다른 색상으로 표시
    if (StrToIntDef(AViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('use_status').Index], 0) in [CPS_PRODUCT_CLOSE, CPS_PRODUCT_RECESS]) then //이용 만료 또는 휴회중
      ACanvas.Font.Color := CTC_IMMINENT //ACanvas.Font.Color := CTC_EXPIRED
    else if (StrToIntDef(AViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('use_status').Index], 0) in [CPS_PRODUCT_INUSE]) and
            ((DateTimeToMilliseconds(dEndDate) - DateTimeToMilliseconds(dCurDate)) div LCN_MSEC_PER_DAY < 7) then //이용 만료 임박
    begin
      ACanvas.Font.Color := CTC_IMMINENT;
      ACanvas.Font.Style := [fsBold];
    end;
  except
  end;
end;

procedure TXGTeeBoxProdMemberForm.V1DblClick(Sender: TObject);
begin
  btnOK.Click;
end;

procedure TXGTeeBoxProdMemberForm.V2CustomDrawCell(Sender: TcxCustomGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  dCurDate, dEndDate: TDateTime;
begin
  try
    if (AViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('product_div').Index] = CPD_LOCKER) then //보증금은 제외해야 하므로
    begin
      dCurDate := StrToDateTime(Global.FormattedCurrentDate + ' 00:00:00', Global.FS);
      dEndDate := StrToDateTime(AViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('end_day').Index] + ' 00:00:00', Global.FS);
      //종료일자가 6일 이하로 남았거나 이용만료, 휴회중인 상품은 다른 색상으로 표시
      if (StrToIntDef(AViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('use_status').Index], 0) in [CPS_LOCKER_MATURITY]) then //만기
        ACanvas.Font.Color := CTC_IMMINENT //ACanvas.Font.Color := CTC_EXPIRED
      else if (StrToIntDef(AViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('use_status').Index], 0) in [CPS_LOCKER_INUSE]) and
              ((DateTimeToMilliseconds(dEndDate) - DateTimeToMilliseconds(dCurDate)) div LCN_MSEC_PER_DAY < 7) then //만기일자 임박
      begin
        ACanvas.Font.Color := CTC_IMMINENT;
        ACanvas.Font.Style := [fsBold];
      end;
    end;
  except
  end;
end;

procedure TXGTeeBoxProdMemberForm.btnOKClick(Sender: TObject);
var
  bAccepted, bTodayYN: Boolean;
  sProdCode, sZoneCode, sAvailZoneCode, sProdDiv, sCurDate, sCurTime, sProdStartTime, sProdEndTime,
  sTeeBoxStartDateTime, sTeeBoxEndDateTime, sStartDate, sEndDate, sErrMsg: string;
  dTeeBoxStartDateTime, dTeeBoxEndDateTime, dProdStartDateTime, dProdEndDateTime: TDateTime;
  nRemainCnt, nUseStatus, nTeeBoxNo, nAssignMin: Integer;
begin
  if FWorking then
    Exit;

  FWorking := True;
  try
    try
      with ClientDM.MDTeeBoxProdMember do
      begin
        if (RecordCount = 0) then
          Exit;

        //VIP 회원권인 경우
        sZoneCode := FieldByName('zone_cd').AsString;
        if (sZoneCode = CTZ_VIP) and (SaleManager.MemberInfo.VIPTeeBoxCount = 0) then
          raise Exception.Create('VIP 회원권을 사용할 VIP 타석이 지정되지 않았습니다!');
        (*
        //VIP 회원권이 아닌데 VIP 타석을 선택한 경우
        if (sZoneCode <> CTZ_TEEBOX_VIP) and (SaleManager.MemberInfo.VIPTeeBoxCount <> 0) then
          raise Exception.Create('일반 회원권은 VIP 타석을 예약할 수 없습니다!');
        *)

        nUseStatus := FieldByName('use_status').AsInteger;
        if (nUseStatus in [CPS_PRODUCT_CLOSE, CPS_PRODUCT_RECESS]) then
        begin
          XGMsgBox(Self.Handle, mtWarning, '알림', '이용 만료가 되었거나 휴회 중인 상품은 선택할 수 없습니다!', ['확인'], 5);
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

        //전환상품 선택 모드가 아니면 당일 사용 불가상품 선택 불가(2020-03-10)
        if (not FProdChange) then
        begin
          bTodayYN := FieldByName('today_yn').AsBoolean;
          if (not bTodayYN) or
             (nUseStatus <> CPS_PRODUCT_INUSE) or
             ((sProdDiv = CTP_COUPON) and (nRemainCnt = 0)) or
             (sStartDate > sCurDate) or
             (sEndDate < sCurDate) then
          begin
            XGMsgBox(Self.Handle, mtConfirmation, '알림', '이용 조건에 맞지 않아 현재 사용할 수 없는 상품입니다!' + _CRLF +
              '[상품상태] ' + IIF(nUseStatus = CPS_PRODUCT_RECESS, '휴회 중', IIF(nUseStatus = CPS_PRODUCT_BEFORE, '이용 전', '사용 불가')) + _CRLF +
              IIF(bTodayYN, '', '[금일이용] 해당 없음' + _CRLF) +
              Format('[사용기간] %s ~ %s', [FormattedDateString(sStartDate), FormattedDateString(sEndDate)]) + _CRLF +
              IIF(sProdDiv = CTP_COUPON, Format('[잔여쿠폰] %d 매', [nRemainCnt]), ''),
              ['확인'], 10);
            Exit;
          end;
        end;

//        //올빼미 상품을 위한 상품시각 추적 로그
//        UpdateLog(Global.LogFile,
//          Format('TeeBoxProdMember.SelectProduct = 상품코드: %s, 배정시간: %d, 상품시작: %s, 상품종료: %s',
//            [sProdCode, nAssignMin, sProdStartTime, sProdEndTime, FormatDateTime('yyyy-mm-dd hh:nn', dProdStartDateTime), FormatDateTime('yyyy-mm-dd hh:nn', dProdEndDateTime)]));
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
            if sTeeBoxEndDateTime.IsEmpty then //빈 타석
            begin
              if (not SaleManager.StoreInfo.EndTimeIgnoreYN) and //영업 종료시각 체크 여부
                 (dProdStartDateTime > SaleManager.StoreInfo.StoreEndDateTime) then
              begin
                XGMsgBox(Self.Handle, mtConfirmation, '알림', '영업시간 내에 사용할 수 없는 상품입니다!' + _CRLF +
                  Format('[영업시간] %s ~ %s', [FormatDateTime('yyyy-mm-dd hh:nn', SaleManager.StoreInfo.StoreStartDateTime), FormatDateTime('yyyy-mm-dd hh:nn', SaleManager.StoreInfo.StoreEndDateTime)]) + _CRLF +
                  Format('[상품시간] %s ~ %s', [FormatDateTime('yyyy-mm-dd hh:nn', dProdStartDateTime), FormatDateTime('yyyy-mm-dd hh:nn', dProdEndDateTime)]),
                  ['확인'], 5);
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

              if (not SaleManager.StoreInfo.EndTimeIgnoreYN) and //영업 종료시각 체크 여부
                 (not Global.NoShowInfo.NoShowReserved) and //노쇼예약이 아닐 경우에만 예약시간 체크
                 ((dTeeBoxStartDateTime < SaleManager.StoreInfo.StoreStartDateTime) or (dTeeBoxStartDateTime > SaleManager.StoreInfo.StoreEndDateTime)) then
              begin
                XGMsgBox(Self.Handle, mtConfirmation, '알림', '영업시간 내에 사용할 수 없는 상품입니다!' + _CRLF +
                  Format('[영업시간] %s ~ %s', [FormatDateTime('yyyy-mm-dd hh:nn', SaleManager.StoreInfo.StoreStartDateTime), FormatDateTime('yyyy-mm-dd hh:nn', SaleManager.StoreInfo.StoreEndDateTime)]) + _CRLF +
                  Format('[예약시간] %s ~ %s', [FormatDateTime('yyyy-mm-dd hh:nn', dTeeBoxStartDateTime), FormatDateTime('yyyy-mm-dd hh:nn', dTeeBoxEndDateTime)]),
                  ['확인'], 5);
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
              XGMsgBox(Self.Handle, mtConfirmation, '알림', sErrMsg + _CRLF +
                '[주문시각 기준 타석예약 허용] ' + IIF(Global.ReserveAllowedOnOrderTime, '예', '아니오') + _CRLF +
                Format('[예약시간] %s ~ %s', [FormatDateTime('yyyy-mm-dd hh:nn', dTeeBoxStartDateTime), FormatDateTime('yyyy-mm-dd hh:nn', dTeeBoxEndDateTime)]),
                ['확인'], 5);
              bAccepted := False;
              Break;
            end;

            with ClientDM.MDTeeBoxProdMember do
            begin
              sAvailZoneCode := FieldByName('avail_zone_cd').AsString;
              if (not sZoneCode.IsEmpty) and
                 (Pos(sZoneCode, sAvailZoneCode) = 0) then
              begin
                XGMsgBox(Self.Handle, mtConfirmation, '알림', '선택한 상품은 현재 타석에 이용할 수 없는 상품입니다!' + _CRLF +
                  '[이용할 타석 구분] ' + ClientDM.GetZoneCodeNames(sZoneCode) + _CRLF +
                  '[보유한 상품 구분] ' + ClientDM.GetZoneCodeNames(sAvailZoneCode),
                  ['확인'], 5);
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

//            //올빼미 상품을 위한 상품시각 추적 로그
//            UpdateLog(Global.LogFile,
//              Format('TeeBoxProdMember.SelectTeeBox = 상품코드: %s, 배정시간: %d, 상품시작: %s, 상품종료: %s',
//                [sProdCode, nAssignMin, sProdStartTime, sProdEndTime, FormatDateTime('yyyy-mm-dd hh:nn', dTeeBoxStartDateTime), FormatDateTime('yyyy-mm-dd hh:nn', dTeeBoxEndDateTime)]));
          end;

          Next;
        end;
      finally
        EnableControls;
      end;

      if bAccepted then
        ModalResult := mrOK;
    finally
      FWorking := False;
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
  end;
end;

procedure TXGTeeBoxProdMemberForm.btnParkingMemberUpdateClick(Sender: TObject);
var
  sProdDiv, sPurchaseCode, sEndDay, sErrMsg: string;
begin
  try
    With ClientDM.MDTeeBoxProdMember do
    try
      if (RecordCount = 0) then
        Exit;

      DisableControls;
      sProdDiv := FieldByName('product_div').AsString;
      sPurchaseCode := FieldByName('purchase_cd').AsString;
      sEndDay := FieldByName('end_day').AsString;

      case XGMsgBox(Self.Handle, mtConfirmation, '확인',
            '회원의 전체 보유상품에 대해 회원정보 변경작업을 처리하시겠습니까?', ['전체상품', '선택상품']) of
        mrOK:
          begin
            First;
            while not Eof do
            begin
              if (sProdDiv = CTP_TERM) and { 기간권 }
                 (not ClientDM.UpdateParkingMember(Global.ParkingServer.Vendor, sPurchaseCode,
                        SaleManager.MemberInfo.CarNo, SaleManager.MemberInfo.MemberName, sEndDay, sErrMsg)) then
                XGMsgBox(Self.Handle, mtWarning, '알림', '주차권 회원정보 수정에 실패하였습니다!' + _CRLF + sErrMsg, ['확인']);

              Application.ProcessMessages;
              Next;
            end;
          end;
        mrCancel:
          if (sProdDiv = CTP_TERM) and { 기간권 }
             (not ClientDM.UpdateParkingMember(Global.ParkingServer.Vendor, sPurchaseCode,
                        SaleManager.MemberInfo.CarNo, SaleManager.MemberInfo.MemberName, sEndDay, sErrMsg)) then
            XGMsgBox(Self.Handle, mtWarning, '알림', '주차권 회원정보 수정에 실패하였습니다!' + _CRLF + sErrMsg, ['확인']);
      end;
    finally
      EnableControls;
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
  end;
end;

procedure TXGTeeBoxProdMemberForm.btnV1PageUpClick(Sender: TObject);
begin
  GridScrollPageUp(V1);
end;

procedure TXGTeeBoxProdMemberForm.btnV1UpClick(Sender: TObject);
begin
  GridScrollUp(V1);
end;

procedure TXGTeeBoxProdMemberForm.btnV1DownClick(Sender: TObject);
begin
  GridScrollDown(V1);
end;

procedure TXGTeeBoxProdMemberForm.btnV1PageDownClick(Sender: TObject);
begin
  GridScrollPageDown(V1);
end;

procedure TXGTeeBoxProdMemberForm.btnV2UpClick(Sender: TObject);
begin
  GridScrollUp(V2);
end;

procedure TXGTeeBoxProdMemberForm.btnV2DownClick(Sender: TObject);
begin
  GridScrollDown(V2);
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGTeeBoxProdMemberForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.