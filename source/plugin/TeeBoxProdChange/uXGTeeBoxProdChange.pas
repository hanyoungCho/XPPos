(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 회원권 전환 등록
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2019-05-10   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2019 All rights reserved.

*******************************************************************************)
unit uXGTeeBoxProdChange;

interface

uses
  { Native }
  Windows, Messages, SysUtils, Classes, Dialogs, Forms, Controls, Buttons, StdCtrls, ExtCtrls,
  Menus, ComCtrls,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  cxContainer, cxEdit, cxButtons, cxMemo, cxLookAndFeels, cxLookAndFeelPainters, cxTextEdit,
  cxCurrencyEdit, cxLabel, cxGraphics, cxControls, dxCore, cxDateUtils, cxMaskEdit, cxDropDownEdit,
  cxCalendar,
  { TMS }
  AdvShapeButton,
  { Solbi VCL }
  cyBaseSpeedButton, cyAdvSpeedButton;

{$I ..\..\common\XGPOS.inc}

type
  TXGTeeBoxProdChangeForm = class(TPluginModule)
    lblFormTitle: TLabel;
    panBody: TPanel;
    lblPluginVersion: TLabel;
    cxLabel1: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label10: TLabel;
    Label8: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    btnSelectNewProd: TcxButton;
    btnSelectOldProd: TcxButton;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    lblOldProdName: TcxLabel;
    lblOldProdAmt: TcxLabel;
    lblOldStartDate: TcxLabel;
    lblOldPurcCoupon: TcxLabel;
    lblOldRemainCoupon: TcxLabel;
    lblNewProdName: TcxLabel;
    lblNewProdAmt: TcxLabel;
    lblNewPurcCount: TcxLabel;
    edtNewChargeAmt: TcxCurrencyEdit;
    Label6: TLabel;
    lblOldEndDate: TcxLabel;
    Label9: TLabel;
    mmoNewMemo: TcxMemo;
    panInput: TPanel;
    panNumPad: TPanel;
    btnOK: TAdvShapeButton;
    btnCancel: TAdvShapeButton;
    edtNewStartDate: TcxDateEdit;
    edtNewRemainCount: TcxCurrencyEdit;
    lblMemberSex: TcxLabel;
    Label18: TLabel;
    lblMemberHpNo: TcxLabel;
    btnMemberSearch: TcxButton;
    edtMemberName: TcxTextEdit;
    btnSearchClear: TcxButton;
    Label2: TLabel;
    edtNewEndDate: TcxDateEdit;
    btnClose: TAdvShapeButton;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure btnCloseClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OnCurrencyEditEnter(Sender: TObject);
    procedure btnSelectOldProdClick(Sender: TObject);
    procedure btnSelectNewProdClick(Sender: TObject);
    procedure btnMemberSearchClick(Sender: TObject);
    procedure btnSearchClearClick(Sender: TObject);
    procedure edtMemberNameEnter(Sender: TObject);
    procedure edtNewStartDatePropertiesEditValueChanged(Sender: TObject);
    procedure edtNewEndDatePropertiesEditValueChanged(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FOldPurcCode: string;
    FOldProdAmt: Integer;
    FOldRemainCoupon: Integer;
    FTeeBoxProdDiv: string;

    procedure ProcessMessages(AMsg: TPluginMessage);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;
  end;

implementation

uses
  Graphics, DB, DateUtils,
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGSaleManager, uXGMsgBox, uXGMemberPopup, uLayeredForm;

var
  LF: TLayeredForm;

{$R *.dfm}

{ TXGTeeBoxProdChangeForm }

constructor TXGTeeBoxProdChangeForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
var
  PM: TPluginMessage;
begin
  inherited Create(AOwner, AMsg);

  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  FOwnerId := -1;
  FTeeBoxProdDiv := '';
  FOldPurcCode := '';
  FOldProdAmt := 0;
  FOldRemainCoupon := 0;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);

  if Assigned(AMsg) then
    ProcessMessages(AMsg);

  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginId);
    PluginManager.OpenContainer('XGNumPad' + CPL_EXTENSION, panNumPad, PM);
  finally
    FreeAndNil(PM);
  end;
end;

destructor TXGTeeBoxProdChangeForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGTeeBoxProdChangeForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  Action := caFree;
end;

procedure TXGTeeBoxProdChangeForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGTeeBoxProdChangeForm.ProcessMessages(AMsg: TPluginMessage);
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
    edtMemberName.Text   := SaleManager.MemberInfo.MemberName;
    lblMemberSex.Caption := SaleManager.MemberInfo.GetSexDivDesc;
    mmoNewMemo.Text      := SaleManager.ReceiptInfo.SaleMemo;
  end;
end;

procedure TXGTeeBoxProdChangeForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    239: //CL
      if (ActiveControl is TCustomEdit) then
        TCustomEdit(ActiveControl).Clear;
    VK_F9:
      btnSearchClear.Click;
    VK_F10:
      btnMemberSearch.Click;
    VK_F11:
      btnSelectOldProd.Click;
    VK_F12:
      btnSelectNewProd.Click;
    VK_RETURN:
      btnOK.Click;
    VK_ESCAPE:
      btnCancel.Click;
  end;
end;

procedure TXGTeeBoxProdChangeForm.edtMemberNameEnter(Sender: TObject);
begin
  with TcxTextEdit(Sender) do
    SelStart := Length(Text) + 1;
end;

procedure TXGTeeBoxProdChangeForm.edtNewEndDatePropertiesEditValueChanged(Sender: TObject);
begin
  ChangeProdRec.EndDate := FormatDateTime('yyyy-mm-dd', TcxDateEdit(Sender).Date);
end;

procedure TXGTeeBoxProdChangeForm.edtNewStartDatePropertiesEditValueChanged(Sender: TObject);
begin
  with TcxDateEdit(Sender) do
  begin
    edtNewEndDate.Date      := IncMonth(Date, ChangeProdRec.UseMonth);
    ChangeProdRec.StartDate := FormatDateTime('yyyy-mm-dd', Date);
    ChangeProdRec.EndDate   := FormatDateTime('yyyy-mm-dd', edtNewEndDate.Date);
  end;
end;

procedure TXGTeeBoxProdChangeForm.OnCurrencyEditEnter(Sender: TObject);
begin
  with TcxCurrencyEdit(Sender) do
    SelStart := Length(Text) + 1;
end;

procedure TXGTeeBoxProdChangeForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TXGTeeBoxProdChangeForm.btnMemberSearchClick(Sender: TObject);
var
  PM: TPluginMessage;
  sMemberName, sMemberNo, sErrMsg: string;
begin
  sMemberName := Trim(edtMemberName.Text);
  sMemberNo   := SaleManager.MemberInfo.MemberNo;
  if sMemberName.IsEmpty then
  begin
    XGMsgBox(Self.Handle, mtWarning, '알림', '검색할 회원명을 입력하여 주십시오!', ['확인'], 5);
    edtMemberName.SetFocus;
    Exit;
  end;

  if ClientDM.SearchMember('', sMemberName, '', '', True, sErrMsg) then
  begin
    with TXGMemberPopupForm.Create(nil) do
    try
      if (ShowModal = mrOk) then
      begin
        ClientDM.SetMemberInfo(TDataSet(ClientDM.MDMemberSearch), True);
        edtMemberName.Text    := SaleManager.MemberInfo.MemberName;
        lblMemberHpNo.Caption := SaleManager.MemberInfo.HpNo;
        lblMemberSex.Caption  := SaleManager.MemberInfo.GetSexDivDesc;

        if (sMemberNo <> SaleManager.MemberInfo.MemberNo) then
        begin
          ChangeProdRec.Clear;
          FOldPurcCode               := '';
          FTeeBoxProdDiv             := '';
          lblOldProdName.Caption     := '';
          lblOldProdAmt.Caption      := '';
          lblOldStartDate.Caption    := '';
          lblOldEndDate.Caption      := '';
          lblOldPurcCoupon.Caption   := '';
          lblOldRemainCoupon.Caption := '';
          lblNewProdName.Caption     := '';
          lblNewProdAmt.Caption      := '';
          edtNewStartDate.Text       := '';
          edtNewEndDate.Text         := '';
          lblNewPurcCount.Caption    := '';
          edtNewRemainCount.Value    := 0;

          PM := TPluginMessage.Create(nil);
          try
            PM.Command := CPC_SEND_MEMBER_NO;
            PM.AddParams(CPP_MEMBER_NO, SaleManager.MemberInfo.MemberNo);
            PM.PluginMessageToID(Global.SaleFormId);

            PM.ClearParams;
            PM.Command := CPC_SEND_MEMBER_NO;
            PM.AddParams(CPP_MEMBER_NO, SaleManager.MemberInfo.MemberNo);
            PM.PluginMessageToID(Global.TeeBoxViewId);
          finally
            FreeAndNil(PM);
          end;
        end;
      end;
    finally
      Free;
    end;
  end
  else
    XGMsgBox(Self.Handle, mtError, '알림', sErrMsg, ['확인'], 5);
end;

procedure TXGTeeBoxProdChangeForm.btnOKClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  with ChangeProdRec do
  try
    StartDate   := FormatDateTime('yyyy-mm-dd', edtNewStartDate.Date);
    EndDate     := FormatDateTime('yyyy-mm-dd', edtNewEndDate.Date);
    CouponCount := Trunc(edtNewRemainCount.Value);
    SaleAmt     := Trunc(edtNewChargeAmt.Value);
    SaleManager.ReceiptInfo.SaleMemo := mmoNewMemo.Text;

    if SaleManager.MemberInfo.MemberNo.IsEmpty or
       ChangeProdRec.OldPurchaseCode.IsEmpty or
       ChangeProdRec.ProductCode.IsEmpty then
      raise Exception.Create('전환 정보가 정확하게 입력되지 않았습니다!');

    PM := TPluginMessage.Create(nil);
    try
      PM.Command := CPC_CHANGE_PROD_SALE;
      PM.AddParams(CPP_OWNER_ID, Self.PluginID);
      PM.PluginMessageToID(FOwnerId);
    finally
      FreeAndNil(PM);
    end;
    ModalResult := mrOK;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
  end;
end;

procedure TXGTeeBoxProdChangeForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGTeeBoxProdChangeForm.btnSelectOldProdClick(Sender: TObject);
var
  PM: TPluginMessage;
  sProdDiv, sErrMsg: string;
begin
  try
    if not ClientDM.GetTeeBoxProdMember(SaleManager.MemberInfo.MemberNo, '', sErrMsg) or
       (ClientDM.MDTeeBoxProdMember.RecordCount = 0) then
      raise Exception.Create('사용 가능한 보유 상품이 없습니다!' + _CRLF + sErrMsg);

    PM := TPluginMessage.Create(nil);
    try
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Self.PluginID);
      PM.AddParams(CPP_TEEBOX_PROD_CHANGE, True);
      if (PluginManager.OpenModal('XGTeeBoxProdMember' + CPL_EXTENSION, PM) = mrOK) then
      begin
        sProdDiv := FTeeBoxProdDiv;
        with ClientDM.MDTeeBoxProdMember do
        begin
          FTeeBoxProdDiv   := FieldByName('product_div').AsString;
          FOldPurcCode     := FieldByName('purchase_cd').AsString;
          FOldProdAmt      := FieldByName('product_amt').AsInteger;
          FOldRemainCoupon := FieldByName('remain_cnt').AsInteger;

          lblOldProdName.Caption     := FieldByName('product_nm').AsString;
          lblOldProdAmt.Caption      := FormatFloat('#,##0', FOldProdAmt);
          lblOldStartDate.Caption    := FieldByName('start_day').AsString;
          lblOldEndDate.Caption      := FieldByName('end_day').AsString;
          lblOldPurcCoupon.Caption   := IntToStr(FieldByName('coupon_cnt').AsInteger);
          lblOldRemainCoupon.Caption := IntToStr(FOldRemainCoupon);

          if (sProdDiv <> FTeeBoxProdDiv) then
          begin
            with ChangeProdRec do
            begin
              Clear;
              OldPurchaseCode := FOldPurcCode;
            end;

            lblNewProdName.Caption  := '';
            lblNewProdAmt.Caption   := '';
            edtNewStartDate.Text    := '';
            edtNewEndDate.Text      := '';
            lblNewPurcCount.Caption := '';
            edtNewRemainCount.Value := 0;
          end;
        end;
      end;
    finally
      FreeAndNil(PM);
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '회원 보유상품 조회', E.Message, ['확인'], 5);
  end;
end;

procedure TXGTeeBoxProdChangeForm.btnSearchClearClick(Sender: TObject);
begin
  edtMemberName.Text := '';
  lblMemberHpNo.Caption := '';
  lblMemberSex.Caption := '';
end;

procedure TXGTeeBoxProdChangeForm.btnSelectNewProdClick(Sender: TObject);
var
  PM: TPluginMessage;
  nRecCnt, nSexDiv, nNewProdAmt, nExpireDay: Integer;
  sErrMsg: string;
begin
  try
    if FOldPurcCode.IsEmpty then
      raise Exception.Create('회원이 보유한 타석 상품을 먼저 선택하여 주십시오!');

    if not ClientDM.OpenTeeBoxProdList(FTeeBoxProdDiv, '', False, nRecCnt, sErrMsg) then
      raise Exception.Create(sErrMsg);

    if (nRecCnt = 0) then
      raise Exception.Create('사용 가능한 타석 상품을 불러올 수 없습니다!');

    PM := TPluginMessage.Create(nil);
    try
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Self.PluginID);
      PM.AddParams(CPP_FORM_TITLE, '타석 상품 조회');
      if (PluginManager.OpenModal('XGTeeBoxProdList' + CPL_EXTENSION, PM) = mrOK) then
      begin
        with ClientDM.MDProdTeeBoxFiltered do
        begin
          //여성회원 전용 상품인 경우
          nSexDiv := FieldByName('sex_div').AsInteger;
          if not ((SaleManager.MemberInfo.SexDiv = CSD_SEX_ALL) or
                  (nSexDiv = CSD_SEX_ALL) or
                  ((nSexDiv = CSD_SEX_FEMALE) and (SaleManager.MemberInfo.SexDiv = CSD_SEX_FEMALE)) or
                  ((nSexDiv = CSD_SEX_MALE) and (SaleManager.MemberInfo.SexDiv = CSD_SEX_MALE))) then
            raise Exception.Create('회원의 성별로는 선택할 수 없는 상품입니다!');

          with ChangeProdRec do
          begin
            Clear;
            OldPurchaseCode := FOldPurcCode;
            ProductCode     := FieldByName('product_cd').AsString;
            ProductName     := FieldByName('product_nm').AsString;
            nNewProdAmt     := FieldByName('product_amt').AsInteger;
            nExpireDay      := FieldByName('expire_day').AsInteger;
            SaleAmt         := IIF(nNewProdAmt > FOldProdAmt, (nNewProdAmt - FOldProdAmt), nNewProdAmt);
            UseMonth        := FieldByName('use_month').AsInteger;
            StartDate       := Global.FormattedCurrentDate;
            EndDate         := FormatDateTime('yyyy-mm-dd', IIF(FTeeBoxProdDiv = CTP_COUPON, IncDay(Now, nExpireDay), IncMonth(Now, UseMonth)));
            CouponCount     := (FieldByName('use_cnt').AsInteger + + FOldRemainCoupon);

            lblNewProdName.Caption  := ProductName;
            lblNewProdAmt.Caption   := FormatFloat('#,##0', SaleAmt);
            edtNewStartDate.Text    := StartDate;
            edtNewEndDate.Text      := EndDate;
            lblNewPurcCount.Caption := IntToStr(CouponCount);
            edtNewRemainCount.Value := CouponCount;
            edtNewChargeAmt.Value   := SaleAmt;
            mmoNewMemo.SetFocus;
          end;
        end;
      end;
    finally
      FreeAndNil(PM);
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
  end;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGTeeBoxProdChangeForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.