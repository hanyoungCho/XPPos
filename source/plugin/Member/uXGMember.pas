(*******************************************************************************

  Project     : XGOLF 골프연습장 POS 시스템
  Title       : 회원 정보 (조회, 등록, 수정)
  Author      : 이선우
  Description :
  History     :
    Version   Date         Remark
    --------  ----------   -----------------------------------------------------
    1.0.0.0   2019-05-10   Initial Release.

  CopyrightⓒSolbiPOS Co., Ltd. 2008-2019 All rights reserved.

*******************************************************************************)
unit uXGMember;

interface

uses
  { Native }
  WinApi.Windows, WinApi.Messages, System.SysUtils, System.Classes, Vcl.Dialogs, Vcl.Forms,
  Vcl.Controls, Vcl.Buttons, Vcl.Menus, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  { Plugin System }
  uPluginManager, uPluginModule, uPluginMessages,
  { DevExpress }
  dxGDIPlusClasses, cxGraphics, cxControls, cxLookAndFeels, cxContainer, cxEdit, cxDropDownEdit,
  cxMaskEdit, cxCheckBox, cxButtons, cxLookAndFeelPainters, cxGroupBox, cxRadioGroup, cxTextEdit,
  cxImage, cxMemo,
  { TMS }
  AdvShapeButton,
  { Solbi VCL }
  cyEdit, cyMaskEdit, dxShellDialogs;

{$I ..\..\common\XGPOS.inc}

const
  LCN_FINGERPRINT_WIN_HEIGHT = 353;
  LCN_FINGERPRINT_WIN_WIDTH = 246;

type
  TXGMemberForm = class(TPluginModule)
    lblFormTitle: TLabel;
    lblPluginVersion: TLabel;
    panBody: TPanel;
    edtMemberName: TcxTextEdit;
    edtMemberNo: TcxTextEdit;
    edtCarNo: TcxTextEdit;
    rgpSexDiv: TcxRadioGroup;
    edtEmail: TcxTextEdit;
    edtMemberQRCode: TcxTextEdit;
    btnZipNo: TcxButton;
    edtAddress: TcxTextEdit;
    edtAddressDesc: TcxTextEdit;
    cbxCustomerCode: TcxComboBox;
    cbxGroupCode: TcxComboBox;
    btnOK: TAdvShapeButton;
    btnSearch: TcxButton;
    btnLoadPhoto: TcxButton;
    btnFaceDetect: TAdvShapeButton;
    cxLabel1: TLabel;
    cxLabel12: TLabel;
    cxLabel2: TLabel;
    cxLabel18: TLabel;
    cxLabel3: TLabel;
    cxLabel15: TLabel;
    cxLabel16: TLabel;
    cxLabel17: TLabel;
    cxLabel14: TLabel;
    cxLabel10: TLabel;
    cxLabel4: TLabel;
    cxLabel19: TLabel;
    cxLabel7: TLabel;
    cxLabel8: TLabel;
    Label2: TLabel;
    ckbUseRoadAddr: TcxCheckBox;
    edtZipNo: TcxMaskEdit;
    edtBirthMonth: TcxMaskEdit;
    edtBirthDay: TcxMaskEdit;
    edtBirthYear: TcxMaskEdit;
    btnCapturePhoto: TcxButton;
    Label3: TLabel;
    Label4: TLabel;
    edtFingerPrint: TcxTextEdit;
    btnEdit: TAdvShapeButton;
    btnSearchClear: TcxButton;
    Label5: TLabel;
    edtXGolfQRCode: TcxTextEdit;
    btnMemberProd: TAdvShapeButton;
    btnFingerPrint: TAdvShapeButton;
    btnFingerPrintClear: TcxButton;
    edtHpNo: TcxTextEdit;
    ckbSpecialYN: TcxCheckBox;
    btnCancel: TAdvShapeButton;
    Label7: TLabel;
    edtMemberCardUID: TcxTextEdit;
    btnMemberCardUIDClear: TcxButton;
    btnMemberQRClear: TcxButton;
    btnClearPhoto: TcxButton;
    btnSendQRCode: TcxButton;
    btnPrintQRCode: TcxButton;
    Label1: TLabel;
    panTeleReserved: TPanel;
    imgTeleReserved: TImage;
    lblTeleReserved: TLabel;
    btnShowMemberInfo: TcxButton;
    edtMemberSeq: TcxTextEdit;
    Label6: TLabel;
    edtWelfareCode: TcxTextEdit;
    lblSpectrumIntfYN: TLabel;
    edtSpectrumCustId: TcxTextEdit;
    btnXGolfQRCodeClear: TcxButton;
    mmoMemo: TcxMemo;
    ckbMemberCardUID: TcxCheckBox;
    ckbMemberQRCode: TcxCheckBox;
    ckbFingerPrint: TcxCheckBox;
    ckbXGolfQRCode: TcxCheckBox;
    ckbSpectrumIntfYN: TcxCheckBox;
    lblSpectrumCustId: TLabel;
    imgPhoto: TcxImage;
    dlgOpenFile: TdxOpenFileDialog;
    btnClose: TAdvShapeButton;
    procedure PluginModuleClose(Sender: TObject; var Action: TCloseAction);
    procedure PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
    procedure PluginModuleActivate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cbxCustomerCodePropertiesChange(Sender: TObject);
    procedure cbxGroupCodePropertiesChange(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnLoadPhotoClick(Sender: TObject);
    procedure btnZipNoClick(Sender: TObject);
    procedure btnCapturePhotoClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure btnSearchClearClick(Sender: TObject);
    procedure btnMemberProdClick(Sender: TObject);
    procedure btnFingerPrintClick(Sender: TObject);
    procedure PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtMemberNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnFingerPrintClearClick(Sender: TObject);
    procedure edtHpNoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PluginModuleDeactivate(Sender: TObject);
    procedure btnMemberQRClearClick(Sender: TObject);
    procedure btnMemberCardUIDClearClick(Sender: TObject);
    procedure btnClearPhotoClick(Sender: TObject);
    procedure btnSendQRCodeClick(Sender: TObject);
    procedure btnPrintQRCodeClick(Sender: TObject);
    procedure btnFaceDetectClick(Sender: TObject);
    procedure btnShowMemberInfoClick(Sender: TObject);
    procedure btnXGolfQRCodeClearClick(Sender: TObject);
    procedure edtMemberCardUIDPropertiesChange(Sender: TObject);
    procedure edtMemberQRCodePropertiesChange(Sender: TObject);
    procedure edtFingerPrintPropertiesChange(Sender: TObject);
    procedure edtXGolfQRCodePropertiesChange(Sender: TObject);
  private
    { Private declarations }
    FOwnerId: Integer;
    FDataMode: Integer;
    FMemberQRCode: string;
    FCustomerCode: string;
    FGroupCode: string;
    FCustomerCodes: TStringList;
    FGroupCodes: TStringList;
    FWorking: Boolean;

    procedure ProcessMessages(AMsg: TPluginMessage);
    procedure DoFingerPrintCapture;
    procedure DoFingerPrintMatching;
    procedure ShowFingerPrintMirror(const AShow: Boolean);
    procedure DoClearSelectedMember;
    procedure DoSearchMemberNew(const AMemberNo: string='');
    procedure DoSelectMember(ADataSet: TDataSet; const AMemberNo: string='');
    procedure SetReadOnly(const AReadOnly: Boolean);
    procedure SetDataMode(const ADataMode: Integer);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AMsg: TPluginMessage=nil); override;
    destructor Destroy; override;

    property DataMode: Integer read FDataMode write SetDataMode;
  end;

var
  XGMemberForm: TXGMemberForm;

implementation

uses
  { Native }
  DateUtils, ExtDlgs, Graphics, Jpeg, XQuery,
  { Project }
  uXGClientDM, uXGGlobal, uXGCommonLib, uXGSaleManager, uXGMemberPopup, uXGMsgBox, uXGZipCode,
  uLayeredForm, uNBioBSPHelper, uUCBioBSPHelper;

var
  FXQExistsMember: TxQuery;
  LF: TLayeredForm;

{$R *.dfm}

{ TXGMemberForm }

constructor TXGMemberForm.Create(AOwner: TComponent; AMsg: TPluginMessage);
begin
  inherited Create(AOwner, AMsg);

  LF := TLayeredForm.Create(nil);
  LF.Show;
  MakeRoundedControl(Self);
  SetDoubleBuffered(Self, True);

  FOwnerId := -1;
  lblPluginVersion.Caption := Format('PLUGIN Ver.%s', [GetModuleVersion(GetModuleName(HInstance))]);
  panTeleReserved.Visible := Global.TeeBoxTeleReserved;

  FXQExistsMember := TxQuery.Create(nil);
  with FXQExistsMember do
  begin
    AddDataSet(ClientDM.MDMember, 'M');
    SQL.Add('SELECT member_no FROM M WHERE M.member_nm = :member_nm;');
  end;

  FCustomerCodes := TStringList.Create;
  FGroupCodes := TStringList.Create;

  ClientDM.GetCodes(CCG_MEMBER_CUSTOMER, False, FCustomerCodes);
  cbxCustomerCode.Properties.Items := FCustomerCodes;
  cbxCustomerCode.Properties.OnChange := cbxCustomerCodePropertiesChange;
  if (cbxCustomerCode.Properties.Items.Count > 0) then
    cbxCustomerCode.ItemIndex := 0;

  ClientDM.GetCodes(CCG_MEMBER_GROUP, True, FGroupCodes);
  cbxGroupCode.Properties.Items := FGroupCodes;
  cbxGroupCode.Properties.OnChange := cbxGroupCodePropertiesChange;
  if (cbxGroupCode.Properties.Items.Count > 0) then
    cbxGroupCode.ItemIndex := 0;

  lblSpectrumIntfYN.Enabled := SaleManager.StoreInfo.SpectrumYN;
  lblSpectrumCustId.Enabled := SaleManager.StoreInfo.SpectrumYN;
  ckbSpectrumIntfYN.Enabled := SaleManager.StoreInfo.SpectrumYN;
  ckbSpectrumIntfYN.Checked := SaleManager.StoreInfo.SpectrumYN;
  edtSpectrumCustId.Enabled := SaleManager.StoreInfo.SpectrumYN;

  if Assigned(AMsg) then
    ProcessMessages(AMsg);
end;

destructor TXGMemberForm.Destroy;
begin
  inherited Destroy;
end;

procedure TXGMemberForm.PluginModuleClose(Sender: TObject; var Action: TCloseAction);
begin
  LF.Close;
  LF.Free;
  FXQExistsMember.Close;
  FXQExistsMember.Free;

  with TPluginMessage.Create(nil) do
  try
    Command := CPC_PRIVACY_AGREEMENT;
    AddParams(CPP_ACTIVE, False);
    PluginMessageToId(Global.SubMonitorId);
  finally
    Free;
  end;

  ClientDM.FreeCodes(FCustomerCodes);
  ClientDM.FreeCodes(FGroupCodes);

  Action := caFree;
end;

procedure TXGMemberForm.PluginModuleMessage(Sender: TObject; AMsg: TPluginMessage);
begin
  ProcessMessages(AMsg);
end;

procedure TXGMemberForm.ProcessMessages(AMsg: TPluginMessage);
var
  sValue, sErrMsg: string;
begin
  if (AMsg.Command = CPC_INIT) then
  begin
    FOwnerId := AMsg.ParamByInteger(CPP_OWNER_ID);
    DataMode := AMsg.ParamByInteger(CPP_DATA_MODE);
    SetReadOnly(DataMode = CDM_VIEW_ONLY);

    edtMemberName.Text := AMsg.ParamByString(CPP_MEMBER_NAME);
    edtHpNo.Text := AMsg.ParamByString(CPP_HP_NO);
    edtCarNo.Text := AMsg.ParamByString(CPP_CAR_NO);
//    DoSearchMember;
    DoSearchMemberNew;
  end;

  if (AMsg.Command = CPC_SEARCH_ADDR) then
  begin
    edtZipNo.Text := AMsg.ParamByString(CPP_ADDR_ZIPCODE);
    edtAddress.Text := AMsg.ParamByString(CPP_ADDR_ADDRESS);
  end;

  if (AMsg.Command = CPC_PHOTO_CAPTURED) then
    imgPhoto.Picture.Bitmap.Assign(TBitmap(AMsg.ParamByObject(CPP_PHOTO_BITMAP)));

  //멤버십 카드번호
  if (AMsg.Command = CPC_SEND_RFID_DATA) then
  begin
    sValue := AMsg.ParamByString(CPP_MEMBER_CARD_UID);
    if (DataMode = CDM_VIEW_ONLY) then
    begin
      if (edtMemberCardUID.Text <> '') and
         (XGMsgBox(Self.Handle, mtConfirmation, '회원 검색',
            '멤버십 카드번호가 인식 되었습니다!' + _CRLF +
            '회원 정보를 재검색 하시겠습니까?' + sErrMsg, ['예', '아니오']) <> mrOK) then
        Exit;

      if ClientDM.SearchMemberByCode(CMC_MEMBER_CARD_UID, sValue, sErrMsg) then
      begin
        edtMemberCardUID.Text := sValue;
        DoSelectMember(ClientDM.MDMemberSearch);
      end
      else
        XGMsgBox(Self.Handle, mtInformation, '알림',
          '일치하는 회원 정보가 없습니다!' + _CRLF + sErrMsg, ['확인'], 5);
    end
    else
    begin
      if (edtMemberCardUID.Text <> '') and
         (XGMsgBox(Self.Handle, mtConfirmation, '멤버십 카드번호 등록',
            '멤버십 카드번호가 인식 되었습니다!' + _CRLF +
            '인식한 카드번호로 변경 등록하시겠습니까?' + sErrMsg, ['예', '아니오']) <> mrOK) then
        Exit;

      edtMemberCardUID.Text := sValue;
    end;
  end;

  //연습장 회원 QR코드
  if (AMsg.Command = CPC_SEND_QRCODE_MEMBER) and
     (DataMode = CDM_VIEW_ONLY) then
  begin
    sValue := AMsg.ParamByString(CPP_QRCODE);
    if ClientDM.SearchMemberByCode(CMC_MEMBER_QRCODE, sValue, sErrMsg) then
    begin
      edtMemberQRCode.Text := sValue;
      DoSelectMember(ClientDM.MDMemberSearch);
      DoSearchMemberNew(SaleManager.MemberInfo.MemberNo);
    end
    else
      XGMsgBox(Self.Handle, mtInformation, '알림',
        '일치하는 회원 정보가 없습니다!' + _CRLF + sErrMsg, ['확인'], 5);
  end;

  //XGOLF QR코드
  if (AMsg.Command = CPC_SEND_QRCODE_XGOLF) then
  begin
    sValue := AMsg.ParamByString(CPP_QRCODE);
    if ClientDM.CheckXGolfMemberNew(CVT_XGOLF_QRCODE, sValue, sErrMsg) then
    begin
      if (DataMode = CDM_VIEW_ONLY) then
      begin
        if ClientDM.SearchMemberByCode(CMC_XGOLF_QRCODE, sValue, sErrMsg) then
          DoSelectMember(ClientDM.MDMemberSearch);
      end
      else
      begin
        if (edtXGolfQRCode.Text <> '') and
           (XGMsgBox(Self.Handle, mtConfirmation, '확인',
              'XGOLF QR코드가 인식 되었습니다!' + _CRLF + 'XGOLF QR코드를 변경 입력하시겠습니까?' + sErrMsg, ['예', '아니오']) <> mrOK) then
          Exit;

        edtXGolfQRCode.Text := sValue;
      end;
    end
    else
      XGMsgBox(Self.Handle, mtWarning, '알림', 'XGOLF 회원 인증에 실패하였습니다!' + _CRLF + sErrMsg, ['확인'], 5);
  end;

  //복지카드 인식
  if (AMsg.Command = CPC_SEND_WELFARE_CODE) then
  begin
    sValue := AMsg.ParamByString(CPP_WELFARE_CODE);
    if (DataMode in [CDM_NEW_DATA, CDM_EDIT_DATA]) then
    begin
      if (edtWelfareCode.Text <> '') and
         (XGMsgBox(Self.Handle, mtConfirmation, '확인',
            '직원 복지카드가 인식 되었습니다!' + _CRLF +
            '복지카드 번호를 변경 등록하시겠습니까?' + sErrMsg, ['예', '아니오']) <> mrOK) then
        Exit;

      edtWelfareCode.Text := sValue;
    end;
  end;

  //회원 보유상품 조회 화면에서 상품을 선택한 경우
  if (AMsg.Command = CPC_SEND_TEEBOX_PURCHASE_CD) then
  begin
    if AMsg.ParamByBoolean(CPP_TEEBOX_RESERVED) then
    begin
      DoSelectMember(ClientDM.MDMemberSearch);
      ModalResult := mrYes;
    end;
  end;
end;

procedure TXGMemberForm.PluginModuleActivate(Sender: TObject);
begin
  Global.DeviceConfig.BarcodeScanner.OwnerId := Self.PluginID;
  Global.DeviceConfig.RFIDReader.OwnerId := Self.PluginID;
  if Global.DeviceConfig.WelfareCardReader.Enabled then
    Global.DeviceConfig.WelfareCardReader.OwnerId := Self.PluginID;
end;

procedure TXGMemberForm.PluginModuleDeactivate(Sender: TObject);
begin
  Global.DeviceConfig.BarcodeScanner.OwnerId := 0;
  Global.DeviceConfig.RFIDReader.OwnerId := 0;
  if Global.DeviceConfig.WelfareCardReader.Enabled then
    Global.DeviceConfig.WelfareCardReader.OwnerId := 0;
end;

procedure TXGMemberForm.PluginModuleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_F8:
      if btnZipNo.Enabled then
        btnZipNo.Click;
    VK_F9:
      if btnSearchClear.Enabled then
        btnSearchClear.Click;
    VK_F10:
      if (DataMode = CDM_VIEW_ONLY) and
         ((edtMemberName.Text <> '') or
          (edtHpNo.Text <> '') or
          (edtCarNo.Text <> '')) then
        btnSearch.Click;
    VK_ESCAPE:
      btnClose.Click;
  end;
end;

procedure TXGMemberForm.edtHpNoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (DataMode = CDM_VIEW_ONLY) and
     (Key = VK_RETURN) then
    btnSearch.Click;
end;

procedure TXGMemberForm.edtMemberNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (DataMode = CDM_VIEW_ONLY) and
     (Key = VK_RETURN) then
    btnSearch.Click;
end;

procedure TXGMemberForm.edtMemberCardUIDPropertiesChange(Sender: TObject);
begin
  ckbMemberCardUID.Checked := (TcxTextEdit(Sender).Text <> '');
end;

procedure TXGMemberForm.edtMemberQRCodePropertiesChange(Sender: TObject);
begin
  ckbMemberQRCode.Checked := (TcxTextEdit(Sender).Text <> '');
end;

procedure TXGMemberForm.edtFingerPrintPropertiesChange(Sender: TObject);
begin
  ckbFingerPrint.Checked := (TcxTextEdit(Sender).Text <> '');
end;

procedure TXGMemberForm.edtXGolfQRCodePropertiesChange(Sender: TObject);
begin
  ckbXGolfQRCode.Checked := (TcxTextEdit(Sender).Text <> '');
end;

procedure TXGMemberForm.btnClearPhotoClick(Sender: TObject);
begin
  imgPhoto.Picture := nil;
end;

procedure TXGMemberForm.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TXGMemberForm.btnEditClick(Sender: TObject);
begin
  if (StrToIntDef(edtMemberSeq.Text, 0) > 0) then
  begin
    TAdvShapeButton(Sender).Enabled := False;
    DataMode := CDM_EDIT_DATA;
    if (rgpSexDiv.ItemIndex < 0) then
      rgpSexDiv.ItemIndex := 0;
    if (cbxCustomerCode.ItemIndex < 0) then
      cbxCustomerCode.ItemIndex := 0;
    if (cbxGroupCode.ItemIndex < 0) then
      cbxGroupCode.ItemIndex := 0;

    SetReadOnly(False);
  end;
end;

procedure TXGMemberForm.btnMemberCardUIDClearClick(Sender: TObject);
begin
  edtMemberCardUID.Text := '';
end;

procedure TXGMemberForm.btnMemberQRClearClick(Sender: TObject);
begin
  edtMemberQRCode.Text := '';
end;

procedure TXGMemberForm.btnFaceDetectClick(Sender: TObject);
begin
  XGMsgBox(Self.Handle, mtInformation, '알림', '준비 중인 기능입니다!', ['확인'], 5);
end;

procedure TXGMemberForm.btnFingerPrintClearClick(Sender: TObject);
begin
  edtFingerPrint.Text := '';
end;

procedure TXGMemberForm.btnFingerPrintClick(Sender: TObject);
begin
  if FWorking then
    Exit;

  FWorking := True;
  try
    if (not Global.DeviceConfig.FingerPrintScanner.Enabled) then
    begin
      XGMsgBox(Self.Handle, mtWarning, '알림', '지문인식기 설정이 되어 있지 않습니다!', ['확인'], 5);
      Exit;
    end;

    if (DataMode = CDM_VIEW_ONLY) then
      DoFingerPrintMatching
    else
      DoFingerPrintCapture;
  finally
    FWorking := False;
  end;
end;

procedure TXGMemberForm.btnLoadPhotoClick(Sender: TObject);
var
  JPG: TJPEGImage;
begin
  with dlgOpenFile do
  try
    Title := '사진 파일 불러오기';
    Options := [ofPathMustExist, ofFileMustExist];
    Filter  := 'JPEG Image File (*.jpg)|*.jpg';
    if Execute then
    begin
      JPG := TJPEGImage.Create;
      try
        imgPhoto.Picture.WICImage.LoadFromFile(FileName);
        if (imgPhoto.Picture.WICImage.ImageFormat <> TWICImageFormat.wifJpeg) then
        begin
          JPG.Assign(imgPhoto.Picture.WICImage);
          imgPhoto.Picture.Assign(JPG);
        end;
      finally
        JPG.Free;
      end;
    end;
  except
    on E: Exception do
    begin
      imgPhoto.Picture.Assign(nil);
      XGMsgBox(Self.Handle, mtError, '알림', '정상적인 이미지 파일이 아닙니다!' + _CRLF + E.Message, ['확인'], 5);
    end;
  end;
end;

procedure TXGMemberForm.btnMemberProdClick(Sender: TObject);
var
  PM: TPluginMessage;
  nTeeBoxCount, nAssignMin: Integer;
  sZoneCode, sErrMsg: string;
  bCouponUseOnly: Boolean;
begin
  if FWorking then
    Exit;

  FWorking := True;
  try
    try
      nTeeBoxCount := ClientDM.MDTeeBoxSelected.RecordCount;
      bCouponUseOnly := (nTeeBoxCount > 1);
      if (edtMemberNo.Text = '') then
        raise Exception.Create('검색된 회원이 없습니다!');
      if not ClientDM.GetTeeBoxProdMember(edtMemberNo.Text, '', sErrMsg) then
        raise Exception.Create('회원 보유상품을 조회할 수 없습니다!' + _CRLF + sErrMsg);
      if (ClientDM.MDTeeBoxProdMember.RecordCount = 0) then
        raise Exception.Create(edtMemberName.Text + ' 회원은 보유한 타석상품이 없습니다!');

      if not ClientDM.GetLockerProdMember(SaleManager.MemberInfo.MemberNo, sErrMsg) then
        XGMsgBox(Self.Handle, mtWarning, '알림',
          SaleManager.MemberInfo.MemberName + ' 회원의 라커 정보를 가져올 수 없습니다!' + sErrMsg, ['확인'], 5);

      PM := TPluginMessage.Create(nil);
      try
        PM.Command := CPC_INIT;
        PM.AddParams(CPP_OWNER_ID, Self.PluginID);
        PM.AddParams(CPP_TEEBOX_PROD_CHANGE, False);
        if (PluginManager.OpenModal('XGTeeBoxProdMember' + CPL_EXTENSION, PM) = mrOK) then
        begin
          if (ClientDM.QRSaleItem.RecordCount > 0) or
             (ClientDM.QRPayment.RecordCount > 0) or
             (ClientDM.QRCoupon.RecordCount > 0) then
           raise Exception.Create('처리되지 않은 주문내역이 있습니다!');

          if (nTeeBoxCount = 0) then
            raise Exception.Create('예약할 타석이 선택되지 않았습니다!');

          with ClientDM.MDTeeBoxProdMember do
          begin
            if (FieldByName('product_div').AsString = CTP_COUPON) then
            begin
               if (FieldByName('remain_cnt').AsInteger < nTeeBoxCount) then
                raise Exception.Create('잔여쿠폰 수가 부족하여 예약을 진행할 수 없습니다!');
            end else
            begin
              if bCouponUseOnly then
                raise Exception.Create('1개 이상 타석의 동시 예약은 쿠폰회원권으로만 가능합니다!');
            end;

            SaleManager.MemberInfo.PurchaseCode := FieldByName('purchase_cd').AsString;
            if (XGMsgBox(Self.Handle, mtConfirmation, '확인',
                  '선택한 상품으로 타석을 예약하시겠습니까?' + _CRLF +
                  '상품명 : ' + FieldByName('product_nm').AsString +
                  IIF(bCouponUseOnly, _CRLF+ '쿠폰차감 : ' + IntToStr(nTeeBoxCount), ''), ['예', '아니오']) <> mrOK) then
              Exit;

            //영업종료시각을 초과하는 경우
            nAssignMin := FieldByName('one_use_time').AsInteger;
            if (not SaleManager.StoreInfo.EndTimeIgnoreYN) and //영업 죵료시각 체크 여부
               (IncMinute(Now, nAssignMin) >= SaleManager.StoreInfo.StoreEndDateTime) and
               (XGMsgBox(Self.Handle, mtConfirmation, '확인',
                  '예약한 타석은 영업종료 시각을 초과하므로 조기 종료될 수 있습니다!' + _CRLF +
                  '그래도 예약을 진행하시겠습니까?', ['예', '아니오']) <> mrOK) then
              Exit;

            //VIP 회원권인 경우
            sZoneCode := FieldByName('zone_cd').AsString;
            if ((sZoneCode = CTZ_VIP) and (SaleManager.MemberInfo.VIPTeeBoxCount = 0)) or
               ((sZoneCode <> CTZ_VIP) and (SaleManager.MemberInfo.VIPTeeBoxCount > 0)) then
            begin
              XGMsgBox(Self.Handle, mtWarning, '알림',
                'VIP 회원권을 사용할 VIP 타석이 지정되지 않았습니다!', ['확인'], 5);
              Exit;
            end;

            PM.ClearParams;
            PM.Command := CPC_SEND_TEEBOX_PURCHASE_CD;
            PM.AddParams(CPP_PRODUCT_CD, FieldByName('product_cd').AsString);
            PM.AddParams(CPP_PRODUCT_DIV, FieldByName('product_div').AsString);
            PM.AddParams(CPP_PRODUCT_NAME, FieldByName('product_nm').AsString);
            PM.AddParams(CPP_PURCHASE_CD, FieldByName('purchase_cd').AsString);
            PM.AddParams(CPP_AVAIL_ZONE_CD, FieldByName('avail_zone_cd').AsString);
            PM.AddParams(CPP_ASSIGN_MIN, FieldByName('one_use_time').AsInteger);
            PM.AddParams(CPP_TEEBOX_RESERVED, True); //바로 예약 등록
            PM.PluginMessageToID(FOwnerId);
          end;

          ModalResult := mrOK;
        end;
      finally
        FreeAndNil(PM);
      end;
    except
      on E: Exception do
        XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
    end;
  finally
    FWorking := False;
  end;
end;

procedure TXGMemberForm.btnCapturePhotoClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_INIT;
    PM.AddParams(CPP_OWNER_ID, Self.PluginId);
    PluginManager.OpenModal('XGWebCam' + CPL_EXTENSION, PM);
  finally
    FreeAndNil(PM);
  end;
end;

procedure TXGMemberForm.btnSearchClearClick(Sender: TObject);
begin
  DoClearSelectedMember;
end;

procedure TXGMemberForm.btnSearchClick(Sender: TObject);
begin
  DoSearchMemberNew;
end;

procedure TXGMemberForm.btnOKClick(Sender: TObject);
var
  MS: TMemoryStream;
  sMemberNo, sMemberName, sHpNo, sCarNo, sErrMsg: string;
begin
  try
    sMemberNo := Trim(edtMemberNo.Text);
    if (DataMode = CDM_VIEW_ONLY) then
    begin
      if sMemberNo.IsEmpty then
      begin
        sMemberName := Trim(edtMemberName.Text);
        sHpNo := StringReplace(Trim(edtHpNo.Text), '-', '', [rfReplaceAll]);
        sCarNo := Trim(edtCarNo.Text);
      end;

      if not ClientDM.GetMemberSearch(sMemberNo, sMemberName, sHpNo, sCarNo, '', True, 0, sErrMsg) then
      begin
        XGMsgBox(Self.Handle, mtInformation, '알림', '일치하는 회원정보가 없습니다!', ['확인'], 5);
        Exit;
      end;

      DoSelectMember(ClientDM.MDMemberSearch, sMemberNo);
      ModalResult := mrYes;
      Exit;
    end;

    sMemberName := Trim(edtMemberName.Text);
    sHpNo := StringReplace(Trim(edtHpNo.Text), '-', '', [rfReplaceAll]);
    sCarNo := Trim(edtCarNo.Text);
    if (DataMode in [CDM_NEW_DATA, CDM_EDIT_DATA]) and
       (sMemberName.IsEmpty or ((not Global.IsSimpleMember) and sHpNo.IsEmpty)) then
    begin
      XGMsgBox(Self.Handle, mtWarning, '알림', '회원명과 휴대폰번호는 필수 입력 항목입니다!', ['확인'], 5);
      Exit;
    end;

    with FXQExistsMember do
    try
      ClientDM.MDMember.DisableControls;
      Close;
      sMemberName := Trim(edtMemberName.Text);
      Params.ParamValues['member_nm'] := sMemberName;
      Open;
      if (DataMode = CDM_NEW_DATA) and
         (RecordCount > 0) and
         Global.IsSimpleMember then
      begin
        XGMsgBox(Self.Handle, mtWarning, '알림',
          Format('동일한 성명의 회원(%s)이 존재합니다!', [sMemberName]), ['확인'], 5);
        Exit;
      end;
    finally
      ClientDM.MDMember.EnableControls;
    end;

    MemberRec.Clear;
    MemberRec.MemberSeq      := StrToIntDef(edtMemberSeq.Text, 0);
    MemberRec.MemberNo       := IIF(DataMode = CDM_NEW_DATA, '', sMemberNo);
    MemberRec.MemberName     := sMemberName;
    MemberRec.HpNo           := sHpNo;
    MemberRec.CarNo          := sCarNo;
    MemberRec.BirthDate      := Format('%.4d%.2d%.2d', [StrToIntDef(edtBirthYear.Text, 0), StrToIntDef(edtBirthMonth.Text, 0), StrToIntDef(edtBirthDay.Text, 0)]);
    MemberRec.SexDiv         := IntToStr(rgpSexDiv.Properties.Items[rgpSexDiv.ItemIndex].Tag);
    MemberRec.Email          := Trim(edtEmail.Text);
    MemberRec.MemberCardUID  := Trim(edtMemberCardUID.Text);
    MemberRec.XGolfNo        := edtXGolfQRCode.Text;
    MemberRec.WelfareCode    := edtWelfareCode.Text;
    MemberRec.EmployeeNo     := '';
    MemberRec.ZipNo          := Format('%.5d', [StrToIntDef(edtZipNo.Text, 0)]);
    MemberRec.Address1       := Trim(edtAddress.Text);
    MemberRec.Address2       := Trim(edtAddressDesc.Text);
    MemberRec.CustomerCode   := FCustomerCode;
    MemberRec.GroupCode      := FGroupCode;
    MemberRec.QrCode         := edtMemberQRCode.Text;
    MemberRec.FingerPrint1   := edtFingerPrint.Text;
    MemberRec.FingerPrint2   := '';
    MemberRec.SpecialYN      := ckbSpecialYN.Checked;
    MemberRec.SpectrumCustId := Trim(edtSpectrumCustId.Text);
    MemberRec.SpectrumIntfYN := ckbSpectrumIntfYN.Checked and (not MemberRec.SpectrumCustId.IsEmpty);
    MemberRec.Memo           := Trim(mmoMemo.Lines.Text);

    MS := TMemoryStream.Create;
    try
      imgPhoto.Picture.SaveToStream(MS);

      if ClientDM.PostMemberInfo(DataMode, MS, sErrMsg) then
      begin
        //회원정보 저장이 성공하면 SaleManager.MemberInfo 가 저장된 값으로 변경됨
        edtMemberSeq.Text := IntToStr(SaleManager.MemberInfo.MemberSeq);
        edtMemberNo.Text := SaleManager.MemberInfo.MemberNo;
        ClientDM.GetMemberList(sErrMsg); //회원 마스터 갱신
        XGMsgBox(Self.Handle, mtInformation, '알림', '등록 되었습니다!', ['확인'], 5);
        DataMode := CDM_VIEW_ONLY;

        if not ClientDM.MDMember.Locate('member_no', SaleManager.MemberInfo.MemberNo, []) then
          Self.Close;
      end
      else
        XGMsgBox(Self.Handle, mtWarning, '알림',
          '회원정보를 저장할 수 없습니다!' + _CRLF + sErrMsg, ['확인'], 5);
    finally
      MS.Free;
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
  end;
end;

procedure TXGMemberForm.btnSendQRCodeClick(Sender: TObject);
var
  sMemberNo, sHpNo, sErrMsg: string;
begin
  try
    sMemberNo := edtMemberNo.Text;
    sHpNo := edtHpNo.Text;
    if sMemberNo.IsEmpty then
      raise Exception.Create('QR코드를 수신할 회원이 선택되지 않았습니다!');
    if sHpNo.IsEmpty then
      raise Exception.Create('QR코드를 전송할 휴대폰 번호를 입력하여 주십시오!');

    if (XGMsgBox(Self.Handle, mtConfirmation, '알림', '회원의 휴대폰 번호로 QR코드를 전송하시겠습니까?', ['예', '아니오']) = mrOK) then
    begin
      if not ClientDM.SendMemberQrCode(sMemberNo, sErrMsg) then
        raise Exception.Create('QR코드 전송에 실패하였습니다!' + _CRLF + sErrMsg);

      XGMsgBox(Self.Handle, mtInformation, '알림', 'QR코드 전송을 완료하였습니다!', ['확인'], 5);
    end;
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
  end;
end;

procedure TXGMemberForm.btnShowMemberInfoClick(Sender: TObject);
var
  PM: TPluginMessage;
begin
  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_CLOSE;
    PM.PluginMessageToID(Global.WebViewId);
  finally
    FreeAndNil(PM);
  end;

  ShowPartnerCenter(Self.PluginID, Format('member/memberDetail?member_seq=%d', [SaleManager.MemberInfo.MemberSeq]));
end;

procedure TXGMemberForm.btnXGolfQRCodeClearClick(Sender: TObject);
begin
  edtXGolfQRCode.Text := '';
end;

procedure TXGMemberForm.btnPrintQRCodeClick(Sender: TObject);
var
  sQRCode, sErrMsg: string;
begin
  sQRCode := Trim(edtMemberQRCode.Text);
  try
    if sQRCode.IsEmpty then
      raise Exception.Create('해당 회원은 QR코드가 등록되어 있지 않습니다!');
    if not Global.ReceiptPrint.QRCodePrint(sQRCode, '회원QR코드', SaleManager.StoreInfo.StoreName, edtMemberName.Text, sErrMsg) then
      raise Exception.Create(sErrMsg);
  except
    on E: Exception do
      XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
  end;
end;

procedure TXGMemberForm.btnZipNoClick(Sender: TObject);
begin
  if FWorking then
    Exit;

  FWorking := True;
  with TXGZipCodeForm.Create(nil) do
  try
    UseRoadNameAddress := ckbUseRoadAddr.Checked;
    SearchValue := Trim(edtAddress.Text);
    if (ShowModal = mrOk) then
    begin
      edtZipNo.Text := ZipCodeValue;
      edtAddress.Text := AddressValue;
    end;
  finally
    Free;
    FWorking := False;
  end;
end;

procedure TXGMemberForm.cbxCustomerCodePropertiesChange(Sender: TObject);
begin
  with TcxComboBox(Sender) do
    if (ItemIndex < 0) then
      FCustomerCode := ''
    else
      FCustomerCode := TCodeRec(Properties.Items.Objects[ItemIndex]).Code;
end;

procedure TXGMemberForm.cbxGroupCodePropertiesChange(Sender: TObject);
begin
  with TcxComboBox(Sender) do
    if (ItemIndex < 0) then
      FGroupCode := ''
    else
      FGroupCode := TCodeRec(Properties.Items.Objects[ItemIndex]).Code;
end;

procedure TXGMemberForm.SetDataMode(const ADataMode: Integer);
var
  bExistMember: Boolean;
begin
  FDataMode := ADataMode;
  bExistMember := not SaleManager.MemberInfo.MemberNo.IsEmpty;

  case FDataMode of
    CDM_VIEW_ONLY:
    begin
      lblFormTitle.Caption := '회원정보 조회';
      btnFingerPrint.Text := '지문 검색';
      btnZipNo.Enabled := False;
      btnSearchClear.Visible := True;
      btnSearch.Visible := True;
      btnLoadPhoto.Enabled := False;
      btnClearPhoto.Enabled := False;
      btnCapturePhoto.Enabled := False;
      btnShowMemberInfo.Enabled := bExistMember;
      btnMemberProd.Enabled := bExistMember;
      btnEdit.Enabled := bExistMember;
      btnOK.Text := '회원 선택';
      btnFingerPrintClear.Enabled := False;
      btnMemberQRClear.Enabled := False;
      btnMemberCardUIDClear.Enabled := False;
      //btnFaceDetect.Enabled := (edtMemberNo.Text <> '') and Assigned(imgPhoto.Picture.Graphic);
      btnFaceDetect.Enabled := False;
      edtWelfareCode.Enabled := False; //복지카드
    end;

    CDM_EDIT_DATA:
    begin
      lblFormTitle.Caption := '회원정보 수정';
      btnFingerPrint.Text := '지문 등록';
      btnZipNo.Enabled := True;
      btnSearchClear.Visible := True;
      btnSearch.Visible := True;
      btnLoadPhoto.Enabled := True;
      btnClearPhoto.Enabled := True;
      btnCapturePhoto.Enabled := True;
      btnShowMemberInfo.Enabled := bExistMember;
      btnMemberProd.Enabled := False;
      btnEdit.Enabled := False;
      btnOK.Text := '저장';
      btnFingerPrintClear.Enabled := True;
      btnMemberQRClear.Enabled := True;
      btnMemberCardUIDClear.Enabled := True;
      btnFaceDetect.Enabled := False;
      edtWelfareCode.Enabled := True; //복지카드
    end;

    CDM_NEW_DATA:
    begin
      with TPluginMessage.Create(nil) do
      try
        Command := CPC_PRIVACY_AGREEMENT;
        AddParams(CPP_ACTIVE, True);
        PluginMessageToId(Global.SubMonitorId);
      finally
        Free;
      end;

      lblFormTitle.Caption := '신규 회원 등록';
      btnFingerPrint.Text := '지문 등록';
      btnZipNo.Enabled := True;
      btnSearchClear.Visible := False;
      btnSearch.Visible := False;
      btnLoadPhoto.Enabled := True;
      btnClearPhoto.Enabled := True;
      btnCapturePhoto.Enabled := True;
      btnShowMemberInfo.Enabled := False;
      btnMemberProd.Enabled := False;
      btnEdit.Enabled := False;
      btnOK.Enabled := True;
      btnOK.Text := '저장';
      rgpSexDiv.ItemIndex := 0;
      btnFingerPrintClear.Enabled := True;
      btnMemberQRClear.Enabled := True;
      btnMemberCardUIDClear.Enabled := True;
      btnFaceDetect.Enabled := False;
      edtWelfareCode.Enabled := True; //복지카드
    end;
  end;
end;

procedure TXGMemberForm.SetReadOnly(const AReadOnly: Boolean);
begin
  edtEmail.Properties.ReadOnly := AReadOnly;
  edtBirthYear.Properties.ReadOnly := AReadOnly;
  edtBirthMonth.Properties.ReadOnly := AReadOnly;
  edtBirthDay.Properties.ReadOnly := AReadOnly;
  rgpSexDiv.Properties.ReadOnly := AReadOnly;
  edtAddress.Properties.ReadOnly := AReadOnly;
  edtAddressDesc.Properties.ReadOnly := AReadOnly;
  ckbUseRoadAddr.Properties.ReadOnly := AReadOnly;
  ckbSpecialYN.Properties.ReadOnly := AReadOnly;
  cbxCustomerCode.Properties.ReadOnly := AReadOnly;
  cbxGroupCode.Properties.ReadOnly := AReadOnly;
  ckbSpectrumIntfYN.Properties.ReadOnly := AReadOnly;
  edtSpectrumCustId.Properties.ReadOnly := AReadOnly;
  edtWelfareCode.Properties.ReadOnly := AReadOnly;
  mmoMemo.Properties.ReadOnly := AReadOnly;
end;

procedure TXGMemberForm.DoClearSelectedMember;
begin
  edtMemberName.Text := '';
  edtMemberNo.Text := '';
  edtMemberSeq.Text := '';
  edtHpNo.Text := '';
  edtCarNo.Text := '';
  btnClearPhoto.Click;
  DataMode := CDM_VIEW_ONLY;
end;

procedure TXGMemberForm.DoSearchMemberNew(const AMemberNo: string);
var
  PM: TPluginMessage;
  MR: TModalResult;
  sMemberName, sHpNo, sCarNo, sZoneCode, sErrMsg: string;
  bCouponUseOnly, bMemberSelected, bTeeBoxProdSelected: Boolean;
  nTeeBoxCount, nAssignMin: Integer;
begin
  sMemberName := Trim(edtMemberName.Text);
  sHpNo := Trim(edtHpNo.Text);
  sCarNo := Trim(edtCarNo.Text);
  if not AMemberNo.IsEmpty then
  begin
    sMemberName := SaleManager.MemberInfo.MemberName;
    sHpNo := SaleManager.MemberInfo.HpNo;
    sCarNo := SaleManager.MemberInfo.CarNo;
  end;

  if FWorking or
     (sMemberName.IsEmpty and sHpNo.IsEmpty and sCarNo.IsEmpty) then
    Exit;

  FWorking := True;
  try

    try
      if not ClientDM.SearchMember(AMemberNo, sMemberName, sHpNo, sCarNo, True, sErrMsg) then
        raise Exception.Create(sErrMsg);

      nTeeBoxCount := ClientDM.MDTeeBoxSelected.RecordCount;
      bCouponUseOnly := (nTeeBoxCount > 1);
      bMemberSelected := False;
      bTeeBoxProdSelected := False;

      PM := TPluginMessage.Create(nil);
      PM.Command := CPC_INIT;
      PM.AddParams(CPP_OWNER_ID, Self.PluginID);
      PM.AddParams(CPP_MEMBER_NO, Format('회원명=%s*, 전화번호=%s*, 차량번호=%s*', [sMemberName, sHpNo, sCarNo]));
      PM.AddParams(CPP_TEEBOX_RESERVED, ClientDM.MDTeeBoxSelected.RecordCount > 0);
      PM.AddParams(CPP_TEEBOX_PROD_CHANGE, False);
      MR := PluginManager.OpenModal('XGMemberSearchList' + CPL_EXTENSION, PM);
      case MR of
        mrOk: //회원 선택
          bMemberSelected := True;

        mrYes: //회원+타석상품 선택
          begin
            bMemberSelected := True;
            bTeeBoxProdSelected := True;
          end;
      end;

      if bMemberSelected then
      begin
        btnMemberProd.Enabled := True;
        btnEdit.Enabled := True;
        btnOK.Enabled := True;

        DoSelectMember(ClientDM.MDMemberSearch);
        DataMode := CDM_VIEW_ONLY;
      end;

      if bTeeBoxProdSelected then
      begin
        if (ClientDM.QRSaleItem.RecordCount > 0) or
           (ClientDM.QRPayment.RecordCount > 0) or
           (ClientDM.QRCoupon.RecordCount > 0) then
         raise Exception.Create('처리되지 않은 주문내역이 있습니다!');

        if (nTeeBoxCount = 0) then
          raise Exception.Create('예약할 타석이 선택되지 않았습니다!');

        with ClientDM.MDTeeBoxProdMember do
        begin
          if (FieldByName('product_div').AsString = CTP_COUPON) then
          begin
             if (FieldByName('remain_cnt').AsInteger < nTeeBoxCount) then
              raise Exception.Create('잔여쿠폰 수가 부족하여 예약을 진행할 수 없습니다!');
          end else
          begin
            if bCouponUseOnly then
              raise Exception.Create('1개 이상 타석의 동시 예약은 쿠폰회원권으로만 가능합니다!');
          end;

          SaleManager.MemberInfo.PurchaseCode := FieldByName('purchase_cd').AsString;
          if (XGMsgBox(Self.Handle, mtConfirmation, '확인',
                '선택한 상품으로 타석을 예약하시겠습니까?' + _CRLF +
                '상품명 : ' + FieldByName('product_nm').AsString +
                IIF(bCouponUseOnly, _CRLF+ '쿠폰차감 : ' + IntToStr(nTeeBoxCount), ''), ['예', '아니오']) <> mrOK) then
            Exit;

          //영업종료시각을 초과하는 경우
          nAssignMin := FieldByName('one_use_time').AsInteger;
          if (not SaleManager.StoreInfo.EndTimeIgnoreYN) and //영업 종료시각 체크 여부
             (IncMinute(Now, nAssignMin) >= SaleManager.StoreInfo.StoreEndDateTime) and
             (XGMsgBox(Self.Handle, mtConfirmation, '확인',
                '예약한 타석은 영업종료 시각을 초과하므로 조기 종료될 수 있습니다!' + _CRLF +
                '그래도 예약을 진행하시겠습니까?', ['예', '아니오']) <> mrOK) then
            Exit;

          //VIP 회원권인 경우
          sZoneCode := FieldByName('zone_cd').AsString;
          if ((sZoneCode = CTZ_VIP) and (SaleManager.MemberInfo.VIPTeeBoxCount = 0)) or
             ((sZoneCode <> CTZ_VIP) and (SaleManager.MemberInfo.VIPTeeBoxCount > 0)) then
          begin
            XGMsgBox(Self.Handle, mtWarning, '알림',
              'VIP 회원권을 사용할 VIP 타석이 지정되지 않았습니다!', ['확인'], 5);
            Exit;
          end;

          PM.ClearParams;
          PM.Command := CPC_SEND_TEEBOX_PURCHASE_CD;
          PM.AddParams(CPP_PRODUCT_CD, FieldByName('product_cd').AsString);
          PM.AddParams(CPP_PRODUCT_DIV, FieldByName('product_div').AsString);
          PM.AddParams(CPP_PRODUCT_NAME, FieldByName('product_nm').AsString);
          PM.AddParams(CPP_PURCHASE_CD, FieldByName('purchase_cd').AsString);
          PM.AddParams(CPP_AVAIL_ZONE_CD, FieldByName('avail_zone_cd').AsString);
          PM.AddParams(CPP_ASSIGN_MIN, FieldByName('one_use_time').AsInteger);
          PM.AddParams(CPP_TEEBOX_RESERVED, True); //바로 예약 등록
          PM.PluginMessageToID(FOwnerId);
        end;

        ModalResult := mrOK;
      end;
    except
      on E: Exception do
      begin
        UpdateLog(Global.LogFile, Format('Member.DoSearchMemberNew.Exception = %s', [E.Message]));
        XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
      end;
    end;
  finally
    FWorking := False;
    if Assigned(PM) then
      FreeAndNil(PM);
  end;
end;

procedure TXGMemberForm.DoSelectMember(ADataSet: TDataSet; const AMemberNo: string);
var
  PM: TPluginMessage;
  MS: TMemoryStream;
  sHpNo: string;
begin
  try
    with ADataSet do
    begin
      if not AMemberNo.IsEmpty then
      begin
        First;
        if not Locate('member_no', AMemberNo, []) then
        begin
          DoClearSelectedMember;
          Exit;
        end;
      end;

      FMemberQRCode             := FieldByName('qr_cd').AsString;
      edtMemberName.Text        := FieldByName('member_nm').AsString;
      edtMemberNo.Text          := FieldByName('member_no').AsString;
      edtMemberSeq.Text         := IntToStr(FieldByName('member_seq').AsInteger);
      edtCarNo.Text             := FieldByName('car_no').AsString;
      edtEmail.Text             := FieldByName('email').AsString;
      edtBirthYear.Text         := Copy(FieldByName('birth_ymd').AsString, 1, 4);
      edtBirthMonth.Text        := Copy(FieldByName('birth_ymd').AsString, 5, 2);
      edtBirthDay.Text          := Copy(FieldByName('birth_ymd').AsString, 7, 2);
      rgpSexDiv.ItemIndex       := Pred(StrToIntDef(FieldByName('sex_div').AsString, 3));
      edtAddress.Text           := FieldByName('address').AsString;
      edtAddressDesc.Text       := FieldByName('address_desc').AsString;
      edtZipNo.Text             := FieldByName('zip_no').AsString;
      mmoMemo.Lines.Text        := FieldByName('memo').AsString;
      edtFingerPrint.Text       := FieldByName('fingerprint1').AsString;
      edtMemberCardUID.Text     := FieldByName('member_card_uid').AsString;
      edtMemberQRCode.Text      := FieldByName('qr_cd').AsString;
      edtXGolfQRCode.Text       := FieldByName('xg_user_key').AsString;
      ckbSpecialYN.Checked      := FieldByName('special_yn').AsBoolean;
      ckbSpectrumIntfYN.Checked := SaleManager.StoreInfo.SpectrumYN;
      edtSpectrumCustId.Text    := FieldByName('spectrum_cust_id').AsString;
      edtWelfareCode.Text       := FieldByName('welfare_cd').AsString;

      sHpNo := FieldByName('hp_no').AsString;
      if (Pos('-', sHpNo) > 0) then
        edtHpNo.Text := sHpNo
      else
        edtHpNo.Text := Copy(sHpNo, 1, 3) + '-' + Copy(sHpNo, 4, 4) + '-' + Copy(sHpNo, 8, 4);

      MS := TMemoryStream.Create;
      try
        TBlobField(FieldByName('photo')).SaveToStream(MS);
        MS.Position := 0;
        imgPhoto.Picture.Assign(nil);
        if (MS.Size > 32) then
        try
          imgPhoto.Picture.LoadFromStream(MS);
        except
        end;
      finally
        MS.Free;
      end;

      with cbxCustomerCode do
        ItemIndex := ClientDM.IndexOfCodes(FieldByName('customer_cd').AsString, Properties.Items);
      with cbxGroupCode do
        ItemIndex := ClientDM.IndexOfCodes(FieldByName('group_cd').AsString, Properties.Items);

      ClientDM.SetMemberInfo(ADataSet, True);
      SaleManager.MemberInfo.SpectrumIntfYN := ckbSpectrumIntfYN.Checked and (not SaleManager.MemberInfo.SpectrumCustId.IsEmpty);
    end;

    PM := TPluginMessage.Create(nil);
    try
      PM.Command := CPC_SEND_MEMBER_NO;
      PM.AddParams(CPP_MEMBER_NO, edtMemberNo.Text);
      PM.PluginMessageToID(Global.SaleFormId);

      PM.ClearParams;
      PM.Command := CPC_SEND_MEMBER_NO;
      PM.AddParams(CPP_MEMBER_NO, edtMemberNo.Text);
      PM.PluginMessageToID(Global.TeeBoxViewId);
    finally
      FreeAndNil(PM);
    end;
  except
    on E: Exception do
    begin
      UpdateLog(Global.LogFile, Format('Member.DoSelectMember.Exception = %s', [E.Message]));
      XGMsgBox(Self.Handle, mtError, '알림', E.Message, ['확인'], 5);
    end;
  end;
end;

procedure TXGMemberForm.DoFingerPrintCapture;
var
  bRetVal: Boolean;
  sErrMsg: string;
begin
  sErrMsg := '';
  edtFingerPrint.Text := '';
  with Global.DeviceConfig.FingerPrintScanner do
  try
    ShowFingerPrintMirror(True);
    try
      case DeviceType of
        CFT_NITGEN:
          with TNBioBSPHelper(Scanner) do
          begin
            bRetVal := Capture(0, sErrMsg);
            if not bRetVal then
              raise Exception.Create(sErrMsg);
            if (not Success) then
              raise Exception.Create(sErrMsg);

            edtFingerPrint.Text := TextFIR;
//            WriteToFile(Format(Global.LogDir + 'FIR'+ '_%s.txt', [Global.CurrentTime]), FIR);
//            WriteToFile(Format(Global.LogDir + 'TextFIR'+ '_%s.txt', [Global.CurrentTime]), TextFIR);
          end;

        CFT_UC:
          with TUCBioBSPHelper(Scanner) do
          begin
            bRetVal := Capture(0, sErrMsg);
            if not bRetVal then
              raise Exception.Create(sErrMsg);
            if (not Success) then
              raise Exception.Create(sErrMsg);

            edtFingerPrint.Text := TextFIR;
//            WriteToFile(Format(Global.LogDir + 'FIR_%s.txt', [Global.CurrentTime]), FIR);
//            WriteToFile(Format(Global.LogDir + 'TextFIR_%s.txt', [Global.CurrentTime]), TextFIR);
          end;
      end;
    finally
      ShowFingerPrintMirror(False);
    end;
  except
    on E: Exception do
    begin
      UpdateLog(Global.LogFile, Format('Member.DoFingerPrintCapture.Exception = %s', [E.Message]));
      XGMsgBox(Self.Handle, mtError, '알림', '지문 등록에 실패하였습니다!' + _CRLF + E.Message, ['확인'], 5);
    end;
  end;
end;

procedure TXGMemberForm.DoFingerPrintMatching;
var
  bRetVal: Boolean;
  sTextFIR, sErrMsg: string;
begin
  sTextFIR := '';
  sErrMsg := '';
  ClientDM.MDMemberFinger.CopyFromDataSet(ClientDM.MDMember);
  with Global.DeviceConfig.FingerPrintScanner do
  try
    ShowFingerPrintMirror(True);
    try
      case DeviceType of
        CFT_NITGEN:
          with TNBioBSPHelper(Scanner) do
          begin
            bRetVal := Matching(0, TDataSet(ClientDM.MDMemberFinger), 'fingerprint1', 'member_no', sErrMsg);
            if (not bRetVal) or
               (not Success) then
            begin
              DoClearSelectedMember;
              raise Exception.Create(sErrMsg);
            end;

            sTextFIR := TextFIR;
            DoSelectMember(ClientDM.MDMember, MatchValue);
          end;

        CFT_UC:
          with TUCBioBSPHelper(Scanner) do
          begin
            bRetVal := Matching(0, TDataSet(ClientDM.MDMemberFinger), 'fingerprint1', 'member_no', sErrMsg);
            if (not bRetVal) or
               (not Success) then
            begin
              DoClearSelectedMember;
              raise Exception.Create(sErrMsg);
            end;

            sTextFIR := TextFIR;
            DoSelectMember(ClientDM.MDMember, MatchValue);
          end;
      end;
    finally
      ShowFingerPrintMirror(False);
    end;
    DataMode := CDM_VIEW_ONLY;
  except
    on E: Exception do
    begin
      XGMsgBox(Self.Handle, mtError, '알림', '지문 검색에 실패하였습니다!' + _CRLF + E.Message, ['확인'], 5);
      ClientDM.ClearMemberInfo(Global.TeeBoxViewId);
      ClientDM.ClearMemberInfo(Global.SaleFormId);
    end;
  end;
end;

(*
procedure TXGMemberForm.DoFingerPrintMatching;
var
  bRetVal: Boolean;
  nMemberSeq, nTop, nLeft, nHeight, nWidth: Integer;
  sTextFIR, sErrMsg: string;
begin
  sTextFIR := '';
  sErrMsg := '';
  try
    ShowFingerPrintMirror(True);
    with Global.DeviceConfig.FingerPrintScanner do
    try
      if (not ClientDM.FingerPrintMatchedUser(sTextFIR, nMemberSeq, sErrMsg)) and
         (not sErrMsg.IsEmpty) then
        raise Exception.Create(sErrMsg);

      case DeviceType of
        CFT_NITGEN:
          with TNBioBSPHelper(Scanner) do
          begin
            bRetVal := Matching(0, TDataSet(ClientDM.MDMemberFinger), 'fingerprint1', 'member_no', sErrMsg);
            if (not bRetVal) or
               (not Success) then
            begin
              DoClearSelectedMember;
              raise Exception.Create(sErrMsg);
            end;

            sTextFIR := TextFIR;
            DoSelectMember(ClientDM.MDMember, MatchValue);
          end;

        CFT_UC:
          with TUCBioBSPHelper(Scanner) do
          begin
            bRetVal := Matching(0, TDataSet(ClientDM.MDMemberFinger), 'fingerprint1', 'member_no', sErrMsg);
            if (not bRetVal) or
               (not Success) then
            begin
              DoClearSelectedMember;
              raise Exception.Create(sErrMsg);
            end;

            sTextFIR := TextFIR;
            DoSelectMember(ClientDM.MDMember, MatchValue);
          end;
      end;
    finally
      ShowFingerPrintMirror(False);
    end;
    DataMode := CDM_VIEW_ONLY;
  except
    on E: Exception do
    begin
      XGMsgBox(Self.Handle, mtError, '알림', '지문 검색에 실패하였습니다!' + _CRLF + E.Message, ['확인'], 5);
      ClientDM.ClearMemberInfo(Global.TeeBoxViewId);
      ClientDM.ClearMemberInfo(Global.SaleFormId);
    end;
  end;
end;
*)

procedure TXGMemberForm.ShowFingerPrintMirror(const AShow: Boolean);
var
  PM: TPluginMessage;
begin
  if not Global.UseFingerPrintMirror then
    Exit;

  PM := TPluginMessage.Create(nil);
  try
    PM.Command := CPC_FINGERPRINT_PREVIEW;
    PM.AddParams(CPP_ACTIVE, AShow);
    if AShow then
    begin
      PM.AddParams(CPP_RECT_TOP, (Global.ScreenInfo.BaseHeight div 2) - (LCN_FINGERPRINT_WIN_HEIGHT DIV 2));
      PM.AddParams(CPP_RECT_LEFT, (Global.ScreenInfo.BaseWidth div 2) - (LCN_FINGERPRINT_WIN_WIDTH div 2));
      PM.AddParams(CPP_RECT_HEIGHT, LCN_FINGERPRINT_WIN_HEIGHT);
      PM.AddParams(CPP_RECT_WIDTH, LCN_FINGERPRINT_WIN_WIDTH);
    end;
    PM.PluginMessageToID(Global.SubMonitorId)
  finally
    FreeAndNil(PM);
  end;
end;

////////////////////////////////////////////////////////////////////////////////

function OpenPlugin(AMsg: TPluginMessage=nil): TPluginModule;
begin
  Result := TXGMemberForm.Create(Application, AMsg);
end;

exports
  OpenPlugin;
end.