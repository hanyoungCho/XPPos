object XGTeeBoxProdChangeForm: TXGTeeBoxProdChangeForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 600
  ClientWidth = 800
  Color = clWhite
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Noto Sans CJK KR Regular'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  OnClose = PluginModuleClose
  OnKeyDown = PluginModuleKeyDown
  PluginGroup = 0
  InitHeight = 0
  InitWidth = 0
  EscCanClose = False
  OnMessage = PluginModuleMessage
  TextHeight = 22
  object lblFormTitle: TLabel
    Left = 0
    Top = 0
    Width = 800
    Height = 60
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = #54924#50896#44428' '#51204#54872' '#46321#47197
    Color = 6856206
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWhite
    Font.Height = -21
    Font.Name = 'Noto Sans CJK KR Bold'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = False
    Layout = tlCenter
    ExplicitTop = 270
  end
  object lblPluginVersion: TLabel
    Left = 8
    Top = 8
    Width = 95
    Height = 13
    Caption = 'PLUGIN Ver.1.0.0.0'
    Color = clWhite
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clSilver
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object panBody: TPanel
    Left = 0
    Top = 60
    Width = 542
    Height = 540
    Align = alLeft
    BevelOuter = bvNone
    Color = 16054762
    ParentBackground = False
    TabOrder = 1
    object cxLabel1: TLabel
      Left = 18
      Top = 143
      Width = 100
      Height = 30
      Alignment = taRightJustify
      AutoSize = False
      Caption = #48372#50976#49345#54408#47749
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object Label1: TLabel
      Left = 18
      Top = 71
      Width = 100
      Height = 30
      Alignment = taRightJustify
      AutoSize = False
      Caption = #54924#50896#47749
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object Label3: TLabel
      Left = 18
      Top = 215
      Width = 100
      Height = 30
      Alignment = taRightJustify
      AutoSize = False
      Caption = #44396#47588'/'#51092#50668#53216#54256
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object Label4: TLabel
      Left = 283
      Top = 143
      Width = 80
      Height = 30
      Alignment = taRightJustify
      AutoSize = False
      Caption = #54032#47588#44552#50529
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object Label5: TLabel
      Left = 18
      Top = 179
      Width = 100
      Height = 30
      Alignment = taRightJustify
      AutoSize = False
      Caption = #51060#50857#49884#51089#51068
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object Label7: TLabel
      Left = 18
      Top = 302
      Width = 100
      Height = 30
      Alignment = taRightJustify
      AutoSize = False
      Caption = #51204#54872#49345#54408#47749
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object Label10: TLabel
      Left = 189
      Top = 215
      Width = 22
      Height = 30
      Alignment = taCenter
      AutoSize = False
      Caption = '/'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object Label8: TLabel
      Left = 18
      Top = 338
      Width = 100
      Height = 30
      Alignment = taRightJustify
      AutoSize = False
      Caption = #51060#50857#49884#51089#51068
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object Label11: TLabel
      Left = 18
      Top = 374
      Width = 100
      Height = 30
      Alignment = taRightJustify
      AutoSize = False
      Caption = #44396#47588'/'#51092#50668#53216#54256
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object Label12: TLabel
      Left = 190
      Top = 374
      Width = 22
      Height = 30
      Alignment = taCenter
      AutoSize = False
      Caption = '/'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object Label13: TLabel
      Left = 283
      Top = 302
      Width = 80
      Height = 30
      Alignment = taRightJustify
      AutoSize = False
      Caption = #54032#47588#44552#50529
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object Label14: TLabel
      Left = 214
      Top = 470
      Width = 150
      Height = 30
      Alignment = taRightJustify
      AutoSize = False
      Caption = #51204#54872#52264#50529'('#44208#51228#44552#50529')'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object Label15: TLabel
      Left = 18
      Top = 409
      Width = 100
      Height = 30
      Alignment = taRightJustify
      AutoSize = False
      Caption = #47700#47784
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object Label16: TLabel
      Left = 18
      Top = 266
      Width = 505
      Height = 30
      Alignment = taCenter
      AutoSize = False
      Caption = #51204#54872#54624' '#49345#54408
      Color = 6856206
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object Label17: TLabel
      Left = 18
      Top = 35
      Width = 505
      Height = 30
      Alignment = taCenter
      AutoSize = False
      Caption = #48372#50976#54620' '#49345#54408
      Color = 6856206
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object Label6: TLabel
      Left = 283
      Top = 179
      Width = 80
      Height = 30
      Alignment = taRightJustify
      AutoSize = False
      Caption = #51060#50857#51333#47308#51068
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object Label9: TLabel
      Left = 283
      Top = 338
      Width = 80
      Height = 30
      Alignment = taRightJustify
      AutoSize = False
      Caption = #51060#50857#51333#47308#51068
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object Label18: TLabel
      Left = 283
      Top = 71
      Width = 80
      Height = 30
      Alignment = taRightJustify
      AutoSize = False
      Caption = #51204#54868#48264#54840
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object Label2: TLabel
      Left = 18
      Top = 107
      Width = 100
      Height = 30
      Alignment = taRightJustify
      AutoSize = False
      Caption = #49457#48324
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object btnSelectNewProd: TcxButton
      Left = 367
      Top = 374
      Width = 156
      Height = 30
      Caption = #51204#54872#49345#54408' '#49440#53469'(F12)'
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 7
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      OnClick = btnSelectNewProdClick
    end
    object btnSelectOldProd: TcxButton
      Left = 367
      Top = 215
      Width = 156
      Height = 30
      Caption = #48372#50976#49345#54408' '#49440#53469'(F11)'
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 3
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      OnClick = btnSelectOldProdClick
    end
    object lblOldProdName: TcxLabel
      Left = 122
      Top = 143
      AutoSize = False
      ParentColor = False
      ParentFont = False
      Style.BorderColor = 6579300
      Style.BorderStyle = ebsUltraFlat
      Style.Color = clWhite
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = []
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = True
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = True
      Properties.Alignment.Horz = taLeftJustify
      Properties.Alignment.Vert = taVCenter
      Height = 30
      Width = 156
      AnchorY = 158
    end
    object lblOldProdAmt: TcxLabel
      Left = 367
      Top = 143
      AutoSize = False
      ParentColor = False
      ParentFont = False
      Style.BorderColor = 6579300
      Style.BorderStyle = ebsUltraFlat
      Style.Color = clWhite
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = []
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = True
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = True
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Height = 30
      Width = 156
      AnchorX = 445
      AnchorY = 158
    end
    object lblOldStartDate: TcxLabel
      Left = 122
      Top = 179
      AutoSize = False
      ParentColor = False
      ParentFont = False
      Style.BorderColor = 6579300
      Style.BorderStyle = ebsUltraFlat
      Style.Color = clWhite
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = []
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = True
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = True
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Height = 30
      Width = 156
      AnchorX = 200
      AnchorY = 194
    end
    object lblOldPurcCoupon: TcxLabel
      Left = 122
      Top = 215
      AutoSize = False
      ParentColor = False
      ParentFont = False
      Style.BorderColor = 6579300
      Style.BorderStyle = ebsUltraFlat
      Style.Color = clWhite
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = []
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = True
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = True
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Height = 30
      Width = 64
      AnchorX = 154
      AnchorY = 230
    end
    object lblOldRemainCoupon: TcxLabel
      Left = 214
      Top = 215
      AutoSize = False
      ParentColor = False
      ParentFont = False
      Style.BorderColor = 6579300
      Style.BorderStyle = ebsUltraFlat
      Style.Color = clWhite
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = []
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = True
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = True
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Height = 30
      Width = 64
      AnchorX = 246
      AnchorY = 230
    end
    object lblNewProdName: TcxLabel
      Left = 122
      Top = 302
      AutoSize = False
      ParentColor = False
      ParentFont = False
      Style.BorderColor = 6579300
      Style.BorderStyle = ebsUltraFlat
      Style.Color = clWhite
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = []
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = True
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = True
      Properties.Alignment.Horz = taLeftJustify
      Properties.Alignment.Vert = taVCenter
      Height = 30
      Width = 156
      AnchorY = 317
    end
    object lblNewProdAmt: TcxLabel
      Left = 367
      Top = 302
      AutoSize = False
      ParentColor = False
      ParentFont = False
      Style.BorderColor = 6579300
      Style.BorderStyle = ebsUltraFlat
      Style.Color = clWhite
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = []
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = True
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = True
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Height = 30
      Width = 156
      AnchorX = 445
      AnchorY = 317
    end
    object lblNewPurcCount: TcxLabel
      Left = 122
      Top = 374
      AutoSize = False
      ParentColor = False
      ParentFont = False
      Style.BorderColor = 6579300
      Style.BorderStyle = ebsUltraFlat
      Style.Color = clWhite
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = []
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = True
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = True
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Height = 30
      Width = 64
      AnchorX = 154
      AnchorY = 389
    end
    object edtNewChargeAmt: TcxCurrencyEdit
      Left = 368
      Top = 465
      AutoSize = False
      EditValue = 0.000000000000000000
      ParentFont = False
      Properties.Alignment.Horz = taCenter
      Properties.AutoSelect = False
      Properties.DisplayFormat = ',0;-,0'
      Properties.UseLeftAlignmentOnEditing = False
      Properties.UseThousandSeparator = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsUltraFlat
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -24
      Style.Font.Name = 'Noto Sans CJK KR Bold'
      Style.Font.Style = [fsBold]
      Style.HotTrack = False
      Style.LookAndFeel.NativeStyle = False
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 9
      OnEnter = OnCurrencyEditEnter
      Height = 40
      Width = 156
    end
    object lblOldEndDate: TcxLabel
      Left = 367
      Top = 179
      AutoSize = False
      ParentColor = False
      ParentFont = False
      Style.BorderColor = 6579300
      Style.BorderStyle = ebsUltraFlat
      Style.Color = clWhite
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = []
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = True
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = True
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Height = 30
      Width = 156
      AnchorX = 445
      AnchorY = 194
    end
    object mmoNewMemo: TcxMemo
      Left = 121
      Top = 410
      ParentFont = False
      Style.BorderStyle = ebsUltraFlat
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = []
      Style.HotTrack = False
      Style.LookAndFeel.NativeStyle = False
      Style.LookAndFeel.ScrollbarMode = sbmClassic
      Style.TransparentBorder = True
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleDisabled.LookAndFeel.ScrollbarMode = sbmClassic
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.ScrollbarMode = sbmClassic
      StyleHot.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.ScrollbarMode = sbmClassic
      TabOrder = 8
      Height = 49
      Width = 403
    end
    object edtNewStartDate: TcxDateEdit
      Left = 121
      Top = 337
      AutoSize = False
      ParentFont = False
      Properties.Alignment.Horz = taCenter
      Properties.AutoSelect = False
      Properties.DateOnError = deToday
      Properties.ImmediatePost = True
      Properties.SaveTime = False
      Properties.UseLeftAlignmentOnEditing = False
      Properties.OnEditValueChanged = edtNewStartDatePropertiesEditValueChanged
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsUltraFlat
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = []
      Style.HotTrack = False
      Style.LookAndFeel.NativeStyle = False
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 4
      Height = 32
      Width = 158
    end
    object edtNewRemainCount: TcxCurrencyEdit
      Left = 213
      Top = 373
      AutoSize = False
      EditValue = 0.000000000000000000
      ParentFont = False
      Properties.Alignment.Horz = taCenter
      Properties.AutoSelect = False
      Properties.DisplayFormat = ',0;-,0'
      Properties.UseLeftAlignmentOnEditing = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsUltraFlat
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = []
      Style.HotTrack = False
      Style.LookAndFeel.NativeStyle = False
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 6
      OnEnter = OnCurrencyEditEnter
      Height = 32
      Width = 66
    end
    object lblMemberSex: TcxLabel
      Left = 122
      Top = 107
      AutoSize = False
      ParentColor = False
      ParentFont = False
      Style.BorderColor = 6579300
      Style.BorderStyle = ebsUltraFlat
      Style.Color = clWhite
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = []
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = True
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = True
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Height = 30
      Width = 35
      AnchorX = 140
      AnchorY = 122
    end
    object lblMemberHpNo: TcxLabel
      Left = 367
      Top = 71
      AutoSize = False
      ParentColor = False
      ParentFont = False
      Style.BorderColor = 6579300
      Style.BorderStyle = ebsUltraFlat
      Style.Color = clWhite
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = []
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = True
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = True
      Properties.Alignment.Horz = taLeftJustify
      Properties.Alignment.Vert = taVCenter
      Height = 30
      Width = 156
      AnchorY = 86
    end
    object btnMemberSearch: TcxButton
      Left = 367
      Top = 107
      Width = 156
      Height = 30
      Caption = #54924#50896' '#51116#49440#53469'(F10)'
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 2
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      OnClick = btnMemberSearchClick
    end
    object edtMemberName: TcxTextEdit
      Left = 121
      Top = 70
      AutoSize = False
      ParentFont = False
      Properties.AutoSelect = False
      Style.BorderColor = 6579300
      Style.BorderStyle = ebsUltraFlat
      Style.Color = clWhite
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = []
      Style.LookAndFeel.Kind = lfUltraFlat
      Style.LookAndFeel.NativeStyle = False
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.Kind = lfUltraFlat
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfUltraFlat
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfUltraFlat
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 0
      OnEnter = edtMemberNameEnter
      Height = 32
      Width = 158
    end
    object btnSearchClear: TcxButton
      Left = 227
      Top = 107
      Width = 136
      Height = 30
      Caption = #44160#49353' '#52488#44592#54868'(F9)'
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 1
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      OnClick = btnSearchClearClick
    end
    object edtNewEndDate: TcxDateEdit
      Left = 366
      Top = 337
      AutoSize = False
      ParentFont = False
      Properties.Alignment.Horz = taCenter
      Properties.AutoSelect = False
      Properties.DateOnError = deToday
      Properties.ImmediatePost = True
      Properties.SaveTime = False
      Properties.UseLeftAlignmentOnEditing = False
      Properties.OnEditValueChanged = edtNewEndDatePropertiesEditValueChanged
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsUltraFlat
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = []
      Style.HotTrack = False
      Style.LookAndFeel.NativeStyle = False
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 5
      Height = 32
      Width = 158
    end
  end
  object panInput: TPanel
    Left = 542
    Top = 60
    Width = 258
    Height = 540
    Align = alClient
    BevelOuter = bvNone
    Color = 16119285
    ParentBackground = False
    TabOrder = 0
    object panNumPad: TPanel
      Left = 26
      Top = 111
      Width = 205
      Height = 222
      BevelOuter = bvNone
      Caption = 'XGNumPad'
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
    end
    object btnOK: TAdvShapeButton
      Tag = 106
      Left = 33
      Top = 378
      Width = 96
      Height = 50
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      Picture.Data = {
        89504E470D0A1A0A0000000D4948445200000060000000320806000000A3DEDE
        C4000000017352474200AECE1CE9000000D3494441547801EDDCE10D40300005
        61C406ECBFA09A81B0C427715DE0DABBBCBF9DC7715C538719581FF2B6EFEC02
        7F069F634CCB9F057CE1ED05C0150A50006C00E35B4001B0018C6F0105C00630
        BE0514001BC0F81650006C00E35B4001B0018C6F0105C00630BE0514001BC0F8
        1650006C00E35B4001B0018C6F0105C00630BE0514001BC0F81650006C00E35B
        4001B0018C6F0105C00630BE0514001BC0F81650006C00E35B4001B0018C6F01
        05C00630BE0514001BC0F81650006C00E35B4001B0018C6F0138C0FB5FD0F36F
        4DC718B801F63709EE8DF8FEEE0000000049454E44AE426082}
      PictureHot.Data = {
        89504E470D0A1A0A0000000D4948445200000060000000320806000000A3DEDE
        C4000000017352474200AECE1CE900000121494441547801ED9CB109845000C5
        546E9C5BC58D2CDDC8556E0B6F0705C1369DB1C96FFCF08A40C26F1DFFFB7E0C
        9DD70C4CAF91035F063EB787E5B7DDD7BE8281F53B5F945E80209B1005203BC2
        56004132210A407684AD008264421480EC085B0104C9842800D911B602089209
        5100B2236C05102413A2006447D80A2048264401C88EB01540904C8802901D61
        2B8020991005203BC256004132210A407684AD008264421480EC085B0104C984
        2800D911B6020892095100B2236C05102413A2006447D80A2048264401C88EB0
        1540904C8802901D612B8020991005203BC256004132210A407684AD00826442
        1480EC085B0104C9842800D911B6020892095100B2236C05102413A2006447D8
        0A204826C4D8FF8248CFF35B2FE079C74838012B8E0AE7244406720000000049
        454E44AE426082}
      PictureDown.Data = {
        89504E470D0A1A0A0000000D4948445200000060000000320806000000A3DEDE
        C4000000017352474200AECE1CE900000121494441547801ED9CB109845000C5
        546E92DBC791AC1CC97D6E016F0705C1369DB1C96FFCF08A40C26F1DFFFB7E0C
        9DD70C4CAF91035F063EB787EFB6DCD7BE8281DFBC5E945E80209B1005203BC2
        56004132210A407684AD008264421480EC085B0104C9842800D911B602089209
        5100B2236C05102413A2006447D80A2048264401C88EB01540904C8802901D61
        2B8020991005203BC256004132210A407684AD008264421480EC085B0104C984
        2800D911B6020892095100B2236C05102413A2006447D80A2048264401C88EB0
        1540904C8802901D612B8020991005203BC256004132210A407684AD00826442
        1480EC085B0104C9842800D911B6020892095100B2236C05102413A2006447D8
        0A204826C4D8FF8248CFF35B2FE079C74838012D0F0AE78AE63E9F0000000049
        454E44AE426082}
      PictureDisabled.Data = {
        89504E470D0A1A0A0000000D4948445200000060000000320806000000A3DEDE
        C4000000017352474200AECE1CE9000000D0494441547801EDDC510D803000C4
        50209801FF5A9808F00041C523A133D0ADCDFD6EBECEF39E3ACCC0FA928F31D8
        05FE0CDEB76D5AFE2CE00B6F2F00AE508002600318DF020A800D607C0B280036
        80F12DA000D800C6B78002600318DF020A800D607C0B28003680F12DA000D800
        C6B78002600318DF020A800D607C0B28003680F12DA000D800C6B78002600318
        DF020A800D607C0B28003680F12DA000D800C6B78002600318DF020A800D607C
        0B28003680F12DA000D800C6B78002600318DF020A800D607C0BC001E63E6CB2
        051ECF510AE7B46DD92A0000000049454E44AE426082}
      ParentBackground = False
      ParentFont = False
      TabStop = True
      TabOrder = 1
      Text = #51204#54872' '#46321#47197
      Version = '6.2.1.8'
      OnClick = btnOKClick
    end
    object btnCancel: TAdvShapeButton
      Tag = 106
      Left = 135
      Top = 378
      Width = 96
      Height = 50
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      Picture.Data = {
        89504E470D0A1A0A0000000D4948445200000060000000320806000000A3DEDE
        C4000000017352474200AECE1CE9000000D3494441547801EDDCE10D40300005
        61C406ECBFA09A81B0C427715DE0DABBBCBF9DC7715C538719581FF2B6EFEC02
        7F069F634CCB9F057CE1ED05C0150A50006C00E35B4001B0018C6F0105C00630
        BE0514001BC0F81650006C00E35B4001B0018C6F0105C00630BE0514001BC0F8
        1650006C00E35B4001B0018C6F0105C00630BE0514001BC0F81650006C00E35B
        4001B0018C6F0105C00630BE0514001BC0F81650006C00E35B4001B0018C6F01
        05C00630BE0514001BC0F81650006C00E35B4001B0018C6F0138C0FB5FD0F36F
        4DC718B801F63709EE8DF8FEEE0000000049454E44AE426082}
      PictureHot.Data = {
        89504E470D0A1A0A0000000D4948445200000060000000320806000000A3DEDE
        C4000000017352474200AECE1CE900000121494441547801ED9CB109845000C5
        546E9C5BC58D2CDDC8556E0B6F0705C1369DB1C96FFCF08A40C26F1DFFFB7E0C
        9DD70C4CAF91035F063EB787E5B7DDD7BE8281F53B5F945E80209B1005203BC2
        56004132210A407684AD008264421480EC085B0104C9842800D911B602089209
        5100B2236C05102413A2006447D80A2048264401C88EB01540904C8802901D61
        2B8020991005203BC256004132210A407684AD008264421480EC085B0104C984
        2800D911B6020892095100B2236C05102413A2006447D80A2048264401C88EB0
        1540904C8802901D612B8020991005203BC256004132210A407684AD00826442
        1480EC085B0104C9842800D911B6020892095100B2236C05102413A2006447D8
        0A204826C4D8FF8248CFF35B2FE079C74838012B8E0AE7244406720000000049
        454E44AE426082}
      PictureDown.Data = {
        89504E470D0A1A0A0000000D4948445200000060000000320806000000A3DEDE
        C4000000017352474200AECE1CE900000121494441547801ED9CB109845000C5
        546E92DBC791AC1CC97D6E016F0705C1369DB1C96FFCF08A40C26F1DFFFB7E0C
        9DD70C4CAF91035F063EB787EFB6DCD7BE8281DFBC5E945E80209B1005203BC2
        56004132210A407684AD008264421480EC085B0104C9842800D911B602089209
        5100B2236C05102413A2006447D80A2048264401C88EB01540904C8802901D61
        2B8020991005203BC256004132210A407684AD008264421480EC085B0104C984
        2800D911B6020892095100B2236C05102413A2006447D80A2048264401C88EB0
        1540904C8802901D612B8020991005203BC256004132210A407684AD00826442
        1480EC085B0104C9842800D911B6020892095100B2236C05102413A2006447D8
        0A204826C4D8FF8248CFF35B2FE079C74838012D0F0AE78AE63E9F0000000049
        454E44AE426082}
      PictureDisabled.Data = {
        89504E470D0A1A0A0000000D4948445200000060000000320806000000A3DEDE
        C4000000017352474200AECE1CE9000000D0494441547801EDDC510D803000C4
        50209801FF5A9808F00041C523A133D0ADCDFD6EBECEF39E3ACCC0FA928F31D8
        05FE0CDEB76D5AFE2CE00B6F2F00AE508002600318DF020A800D607C0B280036
        80F12DA000D800C6B78002600318DF020A800D607C0B28003680F12DA000D800
        C6B78002600318DF020A800D607C0B28003680F12DA000D800C6B78002600318
        DF020A800D607C0B28003680F12DA000D800C6B78002600318DF020A800D607C
        0B28003680F12DA000D800C6B78002600318DF020A800D607C0BC001E63E6CB2
        051ECF510AE7B46DD92A0000000049454E44AE426082}
      ParentBackground = False
      ParentFont = False
      TabStop = True
      TabOrder = 2
      Text = #52712#49548
      Version = '6.2.1.8'
      OnClick = btnCancelClick
    end
  end
  object btnClose: TAdvShapeButton
    Left = 748
    Top = 8
    Width = 44
    Height = 44
    Hint = #45803#44592
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Picture.Data = {
      89504E470D0A1A0A0000000D494844520000002C0000002E0806000000534CFB
      0A000000017352474200AECE1CE90000018F494441545809ED98314EC3301486
      A34E2C5D18BAC05A31F7064CDDD839003B7760E534DC831B30541C8005092410
      227C2FB2A5627093DACFB187F7A45F2F72ECE7CF7F93DA4AD7599803E6803960
      0E34ED40DFF717E8B42424F5D7E81E6DB3E6A1C0359278475759C52283A9BB41
      2F48E20D2D235DC79B197C27555C7C9055A1A9B70F2BD3ECD0629C2CD283C12B
      F4847CA8415330841597371194E9CD143943AAD0C560FDB234A18BC36A42CF06
      AB013D3B6C0E7435D814E8EAB0C74037033B05BA39D811E85B80FD76CBE5709D
      BF29F849733340E1E6F22D942E7476B05CC8703C7002FDEC295D7E25AB3A9B7E
      D00889BB6E455378D23AA1EDFC6FD7CA2DE222DA7F66BF9CC392D40E4C2ACB04
      288415F02D523D3095841D9E5980C317B1AED311677FBD60CD404F81F53F6175
      E86360AB43A7C05683CE819D1D5A037636684DD8E2D0C02ED00EF9503BC850F0
      BFFFE94BBFA8A44CD12592AF31126AB01E869A21F483BF979C292ADBAC7CF75A
      27173930D0413F923FD1CD81AE6DDD02363CE9B5056834E68039600E98038303
      3F493A67D95E8D05550000000049454E44AE426082}
    PictureDown.Data = {
      89504E470D0A1A0A0000000D494844520000002C0000002E0806000000534CFB
      0A000000017352474200AECE1CE9000001F0494441545809ED963B4B043110C7
      6F7D81E2A39143B0B3B0B0142DF4A3FB0114D1AB045BD14AEC04517CAEFFBF26
      5E5892D93C660F8B04E692DBCCE3B7B32133A3511D3503350335033503FF3A03
      6DDBAE429686843431F6308FFBE23492021C6C637F1FF20599344D732FE9E7EC
      21C606EC8E208B904FC809E27C60F68E39EFD3E9C335B3A4DE019C6F4DB7CA57
      1D583A7C83103A38FA806F60F96CACF935D4A03DB0EFF07F81ECB6269E771281
      61FC0AAB53882A7400F60CF11EBD94CE43F10C5B3D0458C6FA18B2629E310B97
      08907CA64B60193B0A988A1AD0A5B049C0A5D01AB0C9C0B9D05AB059C0A9D09A
      B0D9C0B1D0DAB045C07DD043C016030BD0D7D8DB85B0DC72B02844DDB33FDAC2
      4FF4B526F8F05D79AEBA1A2C9D8A95CE8D2AAD51405EB0CF8AC8D91DEC0B5432
      6B9DAA001B676C4117AC6333D33FABA4DAD03A126E8BD885CB2EE35D47FC5F9C
      E1C06D700EDFAA0D93852F020EC0F2CC3E20807A9747E8EC2321C0FEB588D051
      EBF26C86B38063606D006DE864E014D821A093807360B5A1A3814B6035A1A380
      3560B5A07B81356135A0C57B18B07CA143886AD7E5F41EDDE2B2695F2A348BC0
      309A87B047E050EDBA02D03BBFA1C2BF3147620C73BEF91D823C855DE5EDE02B
      B2B8F02BAE43AE10E336CFD38CAD00DEEDF4664C50C3D50CD40CD40CD40CC464
      E01BB3722FA449863AB70000000049454E44AE426082}
    PictureDisabled.Data = {
      89504E470D0A1A0A0000000D494844520000002C0000002E0806000000534CFB
      0A000000017352474200AECE1CE9000001BE494441545809EDD80D4BC3301006
      E0D5293A50C4E1FFFF7FC218280C043FEAFB4A4F4AC95D2EC9150A2610324872
      797AEDD2D0DDAE979E819E819E819E814D67601CC76BD4AB3591D31A8F68EF72
      EB0CD6000438A0FF691A731E86E1DD1A5FD387356E30EF19959611F505EB7CA3
      4D965CE6184CCAD1930119EC6917584E219468B5E4C017CCFC9ACD0E4327B084
      F22E9A60F391201481F76878CBD84A697A3C14EC09D80F59406BB3604E8C44B7
      60697181A3D0ADD822702B3A025B0CAE454761ABC0A5E8486C35D88B8EC63681
      73E835B0CD6003FD86BE0754D985F83270EDB38C691509688DC9F6219BA9978B
      CC0BC3326008988114742896EBE4CE121CE32D8CB58CC784CC5FE9DE58EAB890
      0C27FE60CB059BCE1EF360CB8CCCFB5CBF13583E0667D4554E794D6005CBDD80
      07FDD31AE8EA47C2C0FE1D113126B57B343D1E55600F16D9FD2DD1E862700976
      0D7411B8061B8D76835BB091681738021B85CE8223B11168731F069617744495
      0B0B391B609FE64B25B54FDFCA4569AD099EA03226042B10057D2FFD5A2B99D3
      FA790AE3F72E5EF9058B7CAA032B3B109F2F17DE457E657AC51AFC78B3FD02B8
      DCC9ED63BBB067A067A067E01F67E007B51F1D7A0355AA530000000049454E44
      AE426082}
    ParentBackground = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabStop = True
    TabOrder = 2
    Version = '6.2.1.8'
    OnClick = btnCloseClick
  end
end
