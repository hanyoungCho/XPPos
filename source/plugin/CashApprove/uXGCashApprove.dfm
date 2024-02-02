object XGCashApproveForm: TXGCashApproveForm
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
  OnActivate = PluginModuleActivate
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
    Caption = #54788#44552' '#44208#51228
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
    ExplicitLeft = 250
    ExplicitTop = 12
    ExplicitWidth = 300
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
  object panInput: TPanel
    Left = 519
    Top = 60
    Width = 281
    Height = 540
    Align = alClient
    BevelOuter = bvNone
    Color = 16119285
    ParentBackground = False
    TabOrder = 1
    object btnCashComplete: TcyAdvSpeedButton
      Tag = 1
      Left = 38
      Top = 390
      Width = 205
      Height = 40
      Caption = #54788#44552' '#44208#51228
      Flat = True
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = False
      OnClick = btnCashCompleteClick
      BordersNormal = <>
      BordersHot = <>
      BordersDown = <>
      BordersDisabled = <>
      ButtonNormal.Degrade.FromColor = 2130677
      ButtonNormal.Degrade.SpeedPercent = 90
      ButtonNormal.Degrade.ToColor = 2130677
      ButtonNormal.Font.Charset = HANGEUL_CHARSET
      ButtonNormal.Font.Color = clWhite
      ButtonNormal.Font.Height = -15
      ButtonNormal.Font.Name = 'Noto Sans CJK KR Regular'
      ButtonNormal.Font.Style = [fsBold]
      ButtonNormal.UseDefaultFont = False
      ButtonNormal.Wallpaper.Transparent = False
      ButtonHot.Degrade.BalanceMode = bmReverseFromColor
      ButtonHot.Degrade.FromColor = 7319033
      ButtonHot.Degrade.SpeedPercent = 100
      ButtonHot.Degrade.ToColor = 7319033
      ButtonHot.Font.Charset = HANGEUL_CHARSET
      ButtonHot.Font.Color = clWhite
      ButtonHot.Font.Height = -15
      ButtonHot.Font.Name = 'Noto Sans CJK KR Regular'
      ButtonHot.Font.Style = [fsBold]
      ButtonHot.UseDefaultFont = False
      ButtonHot.Wallpaper.Transparent = False
      ButtonDown.Degrade.FromColor = 612279
      ButtonDown.Degrade.SpeedPercent = 100
      ButtonDown.Degrade.ToColor = 612279
      ButtonDown.Font.Charset = HANGEUL_CHARSET
      ButtonDown.Font.Color = clWhite
      ButtonDown.Font.Height = -15
      ButtonDown.Font.Name = 'Noto Sans CJK KR Regular'
      ButtonDown.Font.Style = [fsBold]
      ButtonDown.UseDefaultFont = False
      ButtonDown.Wallpaper.Transparent = False
      ButtonDisabled.Degrade.FromColor = 15790320
      ButtonDisabled.Degrade.SpeedPercent = 90
      ButtonDisabled.Degrade.ToColor = 15790320
      ButtonDisabled.Font.Charset = HANGEUL_CHARSET
      ButtonDisabled.Font.Color = clSilver
      ButtonDisabled.Font.Height = -15
      ButtonDisabled.Font.Name = 'Noto Sans CJK KR Regular'
      ButtonDisabled.Font.Style = [fsBold]
      ButtonDisabled.UseDefaultFont = False
      ButtonDisabled.Wallpaper.Transparent = False
      Wallpaper.Transparent = False
      WordWrap = True
    end
    object btnCashReceipt: TcyAdvSpeedButton
      Tag = 1
      Left = 38
      Top = 344
      Width = 205
      Height = 40
      Caption = #54788#44552#50689#49688#51613' '#49849#51064' '#50836#52397
      Flat = True
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = False
      OnClick = btnCashReceiptClick
      BordersNormal = <>
      BordersHot = <>
      BordersDown = <>
      BordersDisabled = <>
      ButtonNormal.Degrade.FromColor = clWhite
      ButtonNormal.Degrade.SpeedPercent = 90
      ButtonNormal.Degrade.ToColor = clWhite
      ButtonNormal.Font.Charset = HANGEUL_CHARSET
      ButtonNormal.Font.Color = 2130677
      ButtonNormal.Font.Height = -15
      ButtonNormal.Font.Name = 'Noto Sans CJK KR Regular'
      ButtonNormal.Font.Style = [fsBold]
      ButtonNormal.UseDefaultFont = False
      ButtonNormal.Wallpaper.Transparent = False
      ButtonHot.Degrade.BalanceMode = bmReverseFromColor
      ButtonHot.Degrade.FromColor = 10403688
      ButtonHot.Degrade.SpeedPercent = 100
      ButtonHot.Degrade.ToColor = 10403688
      ButtonHot.Font.Charset = HANGEUL_CHARSET
      ButtonHot.Font.Color = clWhite
      ButtonHot.Font.Height = -15
      ButtonHot.Font.Name = 'Noto Sans CJK KR Regular'
      ButtonHot.Font.Style = [fsBold]
      ButtonHot.UseDefaultFont = False
      ButtonHot.Wallpaper.Transparent = False
      ButtonDown.Degrade.FromColor = 6856206
      ButtonDown.Degrade.SpeedPercent = 100
      ButtonDown.Degrade.ToColor = 6856206
      ButtonDown.Font.Charset = HANGEUL_CHARSET
      ButtonDown.Font.Color = clWhite
      ButtonDown.Font.Height = -15
      ButtonDown.Font.Name = 'Noto Sans CJK KR Regular'
      ButtonDown.Font.Style = [fsBold]
      ButtonDown.UseDefaultFont = False
      ButtonDown.Wallpaper.Transparent = False
      ButtonDisabled.Degrade.FromColor = 15790320
      ButtonDisabled.Degrade.SpeedPercent = 90
      ButtonDisabled.Degrade.ToColor = 15790320
      ButtonDisabled.Font.Charset = HANGEUL_CHARSET
      ButtonDisabled.Font.Color = clSilver
      ButtonDisabled.Font.Height = -15
      ButtonDisabled.Font.Name = 'Noto Sans CJK KR Regular'
      ButtonDisabled.Font.Style = [fsBold]
      ButtonDisabled.UseDefaultFont = False
      ButtonDisabled.Wallpaper.Transparent = False
      Wallpaper.Transparent = False
      WordWrap = True
    end
    object panNumPad: TPanel
      Left = 38
      Top = 91
      Width = 205
      Height = 222
      BevelOuter = bvNone
      Caption = 'XGNumPad'
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
    end
  end
  object panBody: TPanel
    Left = 0
    Top = 60
    Width = 519
    Height = 540
    Align = alLeft
    BevelOuter = bvNone
    Color = 16054762
    ParentBackground = False
    TabOrder = 0
    object cxLabel1: TLabel
      Left = 34
      Top = 62
      Width = 210
      Height = 30
      AutoSize = False
      Caption = #48155#51012' '#44552#50529'('#50896')'
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
      Left = 34
      Top = 132
      Width = 210
      Height = 30
      AutoSize = False
      Caption = #48120#44208#51228' '#44552#50529'('#50896')'
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
      Left = 34
      Top = 202
      Width = 210
      Height = 30
      AutoSize = False
      Caption = #44144#49828#47492#46024'('#50896')'
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
      Left = 34
      Top = 311
      Width = 80
      Height = 30
      AutoSize = False
      Caption = #54788#44552#50689#49688#51613
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object lblInputAmtTitle: TLabel
      Left = 274
      Top = 119
      Width = 205
      Height = 30
      Alignment = taCenter
      AutoSize = False
      Caption = #52572#51333' '#44208#51228' '#44552#50529
      Font.Charset = HANGEUL_CHARSET
      Font.Color = 4473924
      Font.Height = -21
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object Label5: TLabel
      Left = 454
      Top = 184
      Width = 30
      Height = 30
      Alignment = taCenter
      AutoSize = False
      Caption = #50896
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object Shape1: TShape
      Left = 274
      Top = 162
      Width = 205
      Height = 1
      Pen.Color = 11711154
      Pen.Style = psDot
    end
    object btnIndividual: TcyAdvSpeedButton
      Left = 134
      Top = 308
      Width = 55
      Height = 30
      GroupIndex = 2000
      Down = True
      Caption = #44060#51064
      Flat = True
      Font.Charset = HANGEUL_CHARSET
      Font.Color = 15790320
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = False
      BordersNormal = <
        item
          HighlightColor = 16119285
          ShadowColor = 16119285
        end>
      BordersHot = <
        item
          HighlightColor = 16119285
          ShadowColor = 16119285
        end>
      BordersDown = <
        item
          HighlightColor = 16119285
          ShadowColor = 16119285
          Style = bcLowered
        end>
      BordersDisabled = <
        item
          HighlightColor = 16119285
          ShadowColor = 16119285
        end>
      ButtonNormal.Degrade.FromColor = clSilver
      ButtonNormal.Degrade.SpeedPercent = 90
      ButtonNormal.Degrade.ToColor = clSilver
      ButtonNormal.Font.Charset = HANGEUL_CHARSET
      ButtonNormal.Font.Color = 15790320
      ButtonNormal.Font.Height = -15
      ButtonNormal.Font.Name = 'Noto Sans CJK KR Regular'
      ButtonNormal.Font.Style = [fsBold]
      ButtonNormal.Wallpaper.Transparent = False
      ButtonHot.Degrade.BalanceMode = bmReverseFromColor
      ButtonHot.Degrade.FromColor = clWhite
      ButtonHot.Degrade.SpeedPercent = 100
      ButtonHot.Degrade.ToColor = clWhite
      ButtonHot.Font.Charset = HANGEUL_CHARSET
      ButtonHot.Font.Color = clWhite
      ButtonHot.Font.Height = -15
      ButtonHot.Font.Name = 'Noto Sans CJK KR Regular'
      ButtonHot.Font.Style = [fsBold]
      ButtonHot.Wallpaper.Transparent = False
      ButtonDown.Degrade.FromColor = clWhite
      ButtonDown.Degrade.SpeedPercent = 100
      ButtonDown.Degrade.ToColor = clWhite
      ButtonDown.Font.Charset = HANGEUL_CHARSET
      ButtonDown.Font.Color = 2130677
      ButtonDown.Font.Height = -15
      ButtonDown.Font.Name = 'Noto Sans CJK KR Regular'
      ButtonDown.Font.Style = [fsBold]
      ButtonDown.UseDefaultFont = False
      ButtonDown.Wallpaper.Transparent = False
      ButtonDisabled.Degrade.FromColor = 15790320
      ButtonDisabled.Degrade.SpeedPercent = 90
      ButtonDisabled.Degrade.ToColor = 15790320
      ButtonDisabled.Font.Charset = HANGEUL_CHARSET
      ButtonDisabled.Font.Color = clSilver
      ButtonDisabled.Font.Height = -15
      ButtonDisabled.Font.Name = 'Noto Sans CJK KR Regular'
      ButtonDisabled.Font.Style = [fsBold]
      ButtonDisabled.UseDefaultFont = False
      ButtonDisabled.Wallpaper.Transparent = False
      Wallpaper.Transparent = False
    end
    object btnBiz: TcyAdvSpeedButton
      Left = 189
      Top = 308
      Width = 55
      Height = 30
      GroupIndex = 2000
      Caption = #49324#50629#51088
      Flat = True
      Font.Charset = HANGEUL_CHARSET
      Font.Color = 15790320
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = False
      BordersNormal = <
        item
          HighlightColor = 16119285
          ShadowColor = 16119285
        end>
      BordersHot = <
        item
          HighlightColor = 16119285
          ShadowColor = 16119285
        end>
      BordersDown = <
        item
          HighlightColor = 16119285
          ShadowColor = 16119285
          Style = bcLowered
        end>
      BordersDisabled = <
        item
          HighlightColor = 16119285
          ShadowColor = 16119285
        end>
      ButtonNormal.Degrade.FromColor = clSilver
      ButtonNormal.Degrade.SpeedPercent = 90
      ButtonNormal.Degrade.ToColor = clSilver
      ButtonNormal.Font.Charset = HANGEUL_CHARSET
      ButtonNormal.Font.Color = 15790320
      ButtonNormal.Font.Height = -15
      ButtonNormal.Font.Name = 'Noto Sans CJK KR Regular'
      ButtonNormal.Font.Style = [fsBold]
      ButtonNormal.Wallpaper.Transparent = False
      ButtonHot.Degrade.BalanceMode = bmReverseFromColor
      ButtonHot.Degrade.FromColor = clWhite
      ButtonHot.Degrade.SpeedPercent = 100
      ButtonHot.Degrade.ToColor = clWhite
      ButtonHot.Font.Charset = HANGEUL_CHARSET
      ButtonHot.Font.Color = clWhite
      ButtonHot.Font.Height = -15
      ButtonHot.Font.Name = 'Noto Sans CJK KR Regular'
      ButtonHot.Font.Style = [fsBold]
      ButtonHot.Wallpaper.Transparent = False
      ButtonDown.Degrade.FromColor = clWhite
      ButtonDown.Degrade.SpeedPercent = 100
      ButtonDown.Degrade.ToColor = clWhite
      ButtonDown.Font.Charset = HANGEUL_CHARSET
      ButtonDown.Font.Color = 2130677
      ButtonDown.Font.Height = -15
      ButtonDown.Font.Name = 'Noto Sans CJK KR Regular'
      ButtonDown.Font.Style = [fsBold]
      ButtonDown.UseDefaultFont = False
      ButtonDown.Wallpaper.Transparent = False
      ButtonDisabled.Degrade.FromColor = 15790320
      ButtonDisabled.Degrade.SpeedPercent = 90
      ButtonDisabled.Degrade.ToColor = 15790320
      ButtonDisabled.Font.Charset = HANGEUL_CHARSET
      ButtonDisabled.Font.Color = clSilver
      ButtonDisabled.Font.Height = -15
      ButtonDisabled.Font.Name = 'Noto Sans CJK KR Regular'
      ButtonDisabled.Font.Style = [fsBold]
      ButtonDisabled.UseDefaultFont = False
      ButtonDisabled.Wallpaper.Transparent = False
      Wallpaper.Transparent = False
    end
    object lblOrgApproveDate: TLabel
      Left = 274
      Top = 229
      Width = 78
      Height = 22
      Caption = #50896#44144#47000#51068#51088' :'
      Visible = False
    end
    object lblOrgApproveNo: TLabel
      Left = 274
      Top = 254
      Width = 78
      Height = 22
      Caption = #50896#49849#51064#48264#54840' :'
      Visible = False
    end
    object btnCheckCheque: TcyAdvSpeedButton
      Tag = 1
      Left = 274
      Top = 390
      Width = 210
      Height = 40
      Caption = #49688#54364' '#51312#54924
      Flat = True
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = False
      OnClick = btnCheckChequeClick
      BordersNormal = <>
      BordersHot = <>
      BordersDown = <>
      BordersDisabled = <>
      ButtonNormal.Degrade.FromColor = 2130677
      ButtonNormal.Degrade.SpeedPercent = 90
      ButtonNormal.Degrade.ToColor = 2130677
      ButtonNormal.Font.Charset = HANGEUL_CHARSET
      ButtonNormal.Font.Color = clWhite
      ButtonNormal.Font.Height = -15
      ButtonNormal.Font.Name = 'Noto Sans CJK KR Regular'
      ButtonNormal.Font.Style = [fsBold]
      ButtonNormal.UseDefaultFont = False
      ButtonNormal.Wallpaper.Transparent = False
      ButtonHot.Degrade.BalanceMode = bmReverseFromColor
      ButtonHot.Degrade.FromColor = 7319033
      ButtonHot.Degrade.SpeedPercent = 100
      ButtonHot.Degrade.ToColor = 7319033
      ButtonHot.Font.Charset = HANGEUL_CHARSET
      ButtonHot.Font.Color = clWhite
      ButtonHot.Font.Height = -15
      ButtonHot.Font.Name = 'Noto Sans CJK KR Regular'
      ButtonHot.Font.Style = [fsBold]
      ButtonHot.UseDefaultFont = False
      ButtonHot.Wallpaper.Transparent = False
      ButtonDown.Degrade.FromColor = 612279
      ButtonDown.Degrade.SpeedPercent = 100
      ButtonDown.Degrade.ToColor = 612279
      ButtonDown.Font.Charset = HANGEUL_CHARSET
      ButtonDown.Font.Color = clWhite
      ButtonDown.Font.Height = -15
      ButtonDown.Font.Name = 'Noto Sans CJK KR Regular'
      ButtonDown.Font.Style = [fsBold]
      ButtonDown.UseDefaultFont = False
      ButtonDown.Wallpaper.Transparent = False
      ButtonDisabled.Degrade.FromColor = 15790320
      ButtonDisabled.Degrade.SpeedPercent = 90
      ButtonDisabled.Degrade.ToColor = 15790320
      ButtonDisabled.Font.Charset = HANGEUL_CHARSET
      ButtonDisabled.Font.Color = clSilver
      ButtonDisabled.Font.Height = -15
      ButtonDisabled.Font.Name = 'Noto Sans CJK KR Regular'
      ButtonDisabled.Font.Style = [fsBold]
      ButtonDisabled.UseDefaultFont = False
      ButtonDisabled.Wallpaper.Transparent = False
      Wallpaper.Transparent = False
      WordWrap = True
    end
    object lblChargeTotal: TcxLabel
      Left = 34
      Top = 92
      AutoSize = False
      Caption = '0'
      Enabled = False
      ParentColor = False
      ParentFont = False
      Style.BorderStyle = ebsFlat
      Style.Color = clWhite
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = 16744448
      Style.Font.Height = -27
      Style.Font.Name = #47569#51008' '#44256#46357
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Height = 40
      Width = 210
      AnchorX = 139
      AnchorY = 112
    end
    object lblUnpaidTotal: TcxLabel
      Left = 34
      Top = 162
      AutoSize = False
      Caption = '0'
      Enabled = False
      ParentColor = False
      ParentFont = False
      Style.BorderStyle = ebsFlat
      Style.Color = clWhite
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = 16744448
      Style.Font.Height = -27
      Style.Font.Name = #47569#51008' '#44256#46357
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Height = 40
      Width = 210
      AnchorX = 139
      AnchorY = 182
    end
    object lblChangeTotal: TcxLabel
      Left = 34
      Top = 232
      AutoSize = False
      Caption = '0'
      Enabled = False
      ParentColor = False
      ParentFont = False
      Style.BorderStyle = ebsFlat
      Style.Color = clWhite
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = 16744448
      Style.Font.Height = -27
      Style.Font.Name = #47569#51008' '#44256#46357
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Height = 40
      Width = 210
      AnchorX = 139
      AnchorY = 252
    end
    object edtIdentNo: TcxTextEdit
      Left = 34
      Top = 344
      AutoSize = False
      ParentFont = False
      ParentShowHint = False
      Properties.Alignment.Horz = taCenter
      Properties.Nullstring = #49885#48324#48264#54840' '#51077#47141
      Properties.UseLeftAlignmentOnEditing = False
      Properties.UseNullString = True
      ShowHint = False
      Style.BorderStyle = ebsSingle
      Style.Color = clWhite
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = 8487297
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = [fsBold]
      Style.LookAndFeel.NativeStyle = False
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.Color = 16054762
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 3
      TextHint = #49885#48324#48264#54840' '#51077#47141
      OnEnter = OnTextEditEnter
      Height = 40
      Width = 210
    end
    object edtApproveNo: TcxTextEdit
      Left = 34
      Top = 390
      AutoSize = False
      Enabled = False
      ParentFont = False
      ParentShowHint = False
      Properties.Alignment.Horz = taCenter
      Properties.Nullstring = #49849#51064#48264#54840' '#51077#47141
      Properties.UseLeftAlignmentOnEditing = False
      Properties.UseNullString = True
      ShowHint = False
      Style.BorderStyle = ebsSingle
      Style.Color = clWhite
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = 8487297
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = [fsBold]
      Style.LookAndFeel.NativeStyle = False
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.Color = 16054762
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 4
      TextHint = #49849#51064#48264#54840' '#51077#47141
      OnEnter = OnTextEditEnter
      Height = 40
      Width = 210
    end
    object edtCashPayAmt: TcxCurrencyEdit
      Left = 256
      Top = 174
      AutoSize = False
      EditValue = 0.000000000000000000
      ParentFont = False
      Properties.Alignment.Horz = taRightJustify
      Properties.AssignedValues.MaxValue = True
      Properties.AssignedValues.MinValue = True
      Properties.AutoSelect = False
      Properties.DisplayFormat = ',0.'
      Properties.EditFormat = ',0.'
      Properties.Nullstring = '0'
      Properties.ReadOnly = False
      Properties.UseDisplayFormatWhenEditing = True
      Properties.UseLeftAlignmentOnEditing = False
      Properties.UseThousandSeparator = True
      Properties.ValidateOnEnter = False
      Properties.OnChange = edtCashPayAmtPropertiesChange
      Style.BorderStyle = ebsNone
      Style.Color = 16054762
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = 2631930
      Style.Font.Height = -32
      Style.Font.Name = 'Noto Sans CJK KR Bold'
      Style.Font.Style = [fsBold]
      Style.TextStyle = []
      Style.IsFontAssigned = True
      StyleDisabled.BorderColor = clWindowFrame
      StyleDisabled.Color = clWindow
      StyleDisabled.TextColor = 2631930
      StyleDisabled.TextStyle = []
      TabOrder = 2
      OnEnter = edtCashPayAmtEnter
      Height = 50
      Width = 200
    end
    object ckbManualApprove: TcxCheckBox
      Left = 274
      Top = 344
      AutoSize = False
      Caption = #54788#44552#50689#49688#51613' '#49688#44592' '#51077#47141
      ParentFont = False
      Properties.Glyph.SourceDPI = 96
      Properties.Glyph.Data = {
        424D362200000000000036000000280000004400000020000000010020000000
        000000000000C40E0000C40E0000000000000000000000000000000000000000
        00001F1F1F2B4F4F4F6D56565677565656775656567756565677565656775656
        5677565656775656567756565677565656775656567756565677565656775656
        56775656567756565677565656775656567756565677535353722D2D2D3E0101
        0101000000000000000000000000000000000000000000000000000000000000
        000000000000000000001F1F1F2B4F4F4F6D5656567756565677565656775656
        5677565656775656567756565677565656775656567756565677565656775656
        5677565656775656567756565677565656775656567756565677565656775353
        53722D2D2D3E0101010100000000000000000000000000000000000000000000
        000000000000000000001D1D1D286C6C6C95BBBBBBFFBCBCBCFFBBBBBBFFBBBB
        BBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBB
        BBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBB
        BBFFBBBBBBFFBBBBBBFFBABABAFFB9B9B9FF3939394F00000000000000000000
        0000000000000000000000000000000000001D1D1D286C6C6C95BBBBBBFFBCBC
        BCFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBB
        BBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBB
        BBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBABABAFFB9B9B9FF3939394F0000
        0000000000000000000000000000000000000000000002020203B9B9B9FFC6C6
        C6FFC9C9C9FFCCCCCCFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECE
        CEFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECE
        CEFFCECECEFFCECECEFFCECECEFFCECECEFFCDCDCDFFC9C9C9FFC1C1C1FFBBBB
        BBFFBABABAFF2727273600000000000000000000000000000000000000000202
        0203B9B9B9FFC6C6C6FFC9C9C9FFCCCCCCFFCECECEFFCECECEFFCECECEFFCECE
        CEFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECE
        CEFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCDCDCDFFC9C9
        C9FFC1C1C1FFBBBBBBFFBABABAFF272727360000000000000000000000000000
        0000000000005050506EC8C8C8FFDADADAFFDDDDDDFFDFDFDFFFDFDFDFFFDFDF
        DFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDF
        DFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDF
        DFFFDFDFDFFFDFDFDFFFDBDBDBFFC9C9C9FFBDBDBDFF7373739F000000000000
        00000000000000000000000000005050506EC8C8C8FFDADADAFFDDDDDDFFDFDF
        DFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDF
        DFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDF
        DFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDBDBDBFFC9C9C9FFBDBDBDFF7373
        739F00000000000000000000000000000000000000009C9C9CD7DDDDDDFFDEDE
        DEFFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0
        E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0
        E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFDADA
        DAFFC7C7C7FFBABABAFF0C0C0C10000000000000000000000000000000009C9C
        9CD7DDDDDDFFDEDEDEFFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0
        E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFD0D9D3FF7AB08EFFD0D9
        D3FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0
        E0FFE0E0E0FFDADADAFFC7C7C7FFBABABAFF0C0C0C1000000000000000000000
        000000000000B6B6B6FBE6E6E6FFE0E0E0FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1
        E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1
        E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1
        E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFCECECEFFBCBCBCFF2121212D0000
        0000000000000000000000000000B6B6B6FBE6E6E6FFE0E0E0FFE1E1E1FFE1E1
        E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1
        E1FF8FBB9FFF0E7E39FF137B42FF0E7E39FFAFCAB9FFE1E1E1FFE1E1E1FFE1E1
        E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFCECECEFFBCBC
        BCFF2121212D00000000000000000000000000000000B9B9B9FFE7E7E7FFE1E1
        E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1
        E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1
        E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1
        E1FFD0D0D0FFBCBCBCFF2121212D00000000000000000000000000000000B9B9
        B9FFE7E7E7FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1
        E1FFE1E1E1FFE1E1E1FFE1E1E1FF70AC87FF107E3CFF177D4BFF18784DFF1478
        44FF58A174FFDEDFDEFFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1
        E1FFE1E1E1FFE1E1E1FFD0D0D0FFBCBCBCFF2121212D00000000000000000000
        000000000000B9B9B9FFE8E8E8FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2
        E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2
        E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2
        E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFD1D1D1FFBDBDBDFF2121212D0000
        0000000000000000000000000000B9B9B9FFE8E8E8FFE2E2E2FFE2E2E2FFE2E2
        E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFBACFC2FF63A67CFF127E
        40FF188151FF1A8656FF1A8655FF187B4EFF127B40FF6AAA82FFE2E2E2FFE2E2
        E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFD1D1D1FFBDBD
        BDFF2121212D00000000000000000000000000000000B9B9B9FFE9E9E9FFE3E3
        E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3
        E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3
        E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3
        E3FFD2D2D2FFBDBDBDFF2121212D00000000000000000000000000000000B9B9
        B9FFE9E9E9FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3
        E3FF8EBB9FFF0E7E39FF157F47FF1A8354FF1A8857FF1B8B59FF1B8B59FF1A85
        55FF187A4DFF107C3DFF7CB291FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3
        E3FFE3E3E3FFE3E3E3FFD2D2D2FFBDBDBDFF2121212D00000000000000000000
        000000000000B9B9B9FFEAEAEAFFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4
        E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4
        E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4
        E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFD3D3D3FFBDBDBDFF2121212D0000
        0000000000000000000000000000B9B9B9FFEAEAEAFFE4E4E4FFE4E4E4FFE4E4
        E4FFE4E4E4FFE4E4E4FFE4E4E4FF70AD87FF107E3CFF18804DFF1B8756FF1C8B
        58FF1C8C59FF1C8C59FF1C8C59FF1C8C59FF1A8353FF177A4BFF0F7E3AFF9CC2
        AAFFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFD3D3D3FFBDBD
        BDFF2121212D00000000000000000000000000000000B9B9B9FFEBEBEBFFE5E5
        E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5
        E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5
        E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5
        E5FFD4D4D4FFBDBDBDFF2121212D00000000000000000000000000000000B9B9
        B9FFEBEBEBFFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFB9D0C2FF61A67AFF127F
        41FF198453FF1B8958FF1C8C5AFF1C8D5AFF1C8D5AFF1C8D5AFF1C8D5AFF1C8D
        5AFF1C8C59FF1A8153FF157A48FF0E7E38FFC9D8CFFFE5E5E5FFE5E5E5FFE5E5
        E5FFE5E5E5FFE5E5E5FFD4D4D4FFBDBDBDFF2121212D00000000000000000000
        000000000000B9B9B9FFEBEBEBFFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6
        E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6
        E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6
        E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFD5D5D5FFBDBDBDFF2121212D0000
        0000000000000000000000000000B9B9B9FFEBEBEBFFE6E6E6FFE6E6E6FFE6E6
        E6FF8CBB9EFF0E7E39FF158048FF1B8755FF1C8C59FF1C8E5AFF1C8E5AFF1C8E
        5AFF1C8E5AFF1C8E5AFF1C8E5AFF1C8E5AFF1C8E5AFF1B8B58FF198051FF137B
        43FF68A980FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFD5D5D5FFBDBD
        BDFF2121212D00000000000000000000000000000000B9B9B9FFEDEDEDFFE8E8
        E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8
        E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8
        E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8
        E8FFD7D7D7FFBDBDBDFF2121212D00000000000000000000000000000000B9B9
        B9FFEDEDEDFFE8E8E8FFE8E8E8FF70AE87FF107F3DFF18834FFF1B8957FF1C8E
        5AFF1C8F5BFF1C8F5BFF1C8F5BFF1C8F5BFF1D8F5CFF1D8F5CFF1E905CFF1C8F
        5BFF1C8F5BFF1C8F5BFF1B8A58FF197E50FF117D3FFF75B08BFFE8E8E8FFE8E8
        E8FFE8E8E8FFE8E8E8FFD7D7D7FFBDBDBDFF2121212D00000000000000000000
        000000000000B9B9B9FFEEEEEEFFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
        E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
        E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
        E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFD8D8D8FFBEBEBEFF2121212D0000
        0000000000000000000000000000B9B9B9FFEEEEEEFFE9E9E9FF97C1A6FF1384
        45FF1B8A58FF1C8C59FF1D8F5CFF1D905CFF1D905CFF1D905CFF1D905CFF2393
        60FF389D6FFF59AD87FF5BAE89FF279563FF1D905CFF1D905CFF1D905CFF1B88
        57FF187D4FFF107E3CFF8CBC9EFFE9E9E9FFE9E9E9FFE9E9E9FFD8D8D8FFBEBE
        BEFF2121212D00000000000000000000000000000000B9B9B9FFEEEEEEFFEAEA
        EAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEA
        EAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEA
        EAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEA
        EAFFD9D9D9FFBEBEBEFF2121212D00000000000000000000000000000000B9B9
        B9FFEEEEEEFFEAEAEAFF76B18CFF3C9B66FF5FB18CFF369D6EFF1D915CFF1D91
        5CFF1D915CFF1E915DFF2A9766FF3A9F71FF389965FF188442FF6FB893FF56AD
        85FF21935FFF1D915CFF1D915CFF1D905CFF1B8756FF177D4BFF0E7E39FFB4CF
        BEFFEAEAEAFFEAEAEAFFD9D9D9FFBEBEBEFF2121212D00000000000000000000
        000000000000B9B9B9FFEFEFEFFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEB
        EBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEB
        EBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEB
        EBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFD9D9D9FFBEBEBEFF2121212D0000
        0000000000000000000000000000B9B9B9FFEFEFEFFFEBEBEBFFD1DED6FF0E7E
        38FF54A77AFF6AB794FF309B6BFF1D925DFF219460FF309B6BFF3FA173FF218B
        4DFF6AAB82FF8BBC9DFF1F8848FF73BA99FF4BA87EFF1E925EFF1D925DFF1D92
        5DFF1D905CFF1A8555FF157D48FF59A375FFE5E8E6FFEBEBEBFFD9D9D9FFBEBE
        BEFF2121212D00000000000000000000000000000000B9B9B9FFF0F0F0FFECEC
        ECFFECECECFFECECECFFECECECFFECECECFFECECECFFECECECFFECECECFFECEC
        ECFFECECECFFECECECFFECECECFFECECECFFECECECFFECECECFFECECECFFECEC
        ECFFECECECFFECECECFFECECECFFECECECFFECECECFFECECECFFECECECFFECEC
        ECFFDADADAFFBEBEBEFF2121212D00000000000000000000000000000000B9B9
        B9FFF0F0F0FFECECECFFECECECFFC2D7CAFF0F7F39FF5FAE84FF66B692FF379F
        70FF379F70FF3C9E6CFF14823FFF7BB490FFECECECFFECECECFF76B28DFF2F92
        57FF73BC9BFF3FA375FF1E935EFF1E935EFF1E935EFF1D8F5BFF1B8354FF137E
        43FF6FAE86FFECECECFFDADADAFFBEBEBEFF2121212D00000000000000000000
        000000000000B9B9B9FFF1F1F1FFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDED
        EDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDED
        EDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDED
        EDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFDBDBDBFFBEBEBEFF2121212D0000
        0000000000000000000000000000B9B9B9FFF1F1F1FFEDEDEDFFEDEDEDFFEDED
        EDFFAECEBAFF12813CFF6DB690FF6EBB97FF2C935AFF0E7E38FFA4C9B2FFEDED
        EDFFEDEDEDFFEDEDEDFFEDEDEDFF6CAD85FF459F6CFF6DBA97FF349F6EFF1E95
        5EFF1E955EFF1E955EFF1D8F5AFF1A8352FF117E3EFF81B795FFDBDBDBFFBEBE
        BEFF2121212D00000000000000000000000000000000B9B9B9FFF2F2F2FFEEEE
        EEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEE
        EEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEE
        EEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEE
        EEFFDCDCDCFFBEBEBEFF2121212D00000000000000000000000000000000B9B9
        B9FFF2F2F2FFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFA0C7AEFF14823EFF1F89
        4AFF6FAE87FFE2E8E4FFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFDEE6
        E1FF0E7E38FF59AC80FF64B791FF299B67FF1E965FFF1E965FFF1E965FFF1C8D
        59FF19824FFF0F7E3AFF95BCA3FFBEBEBEFF2121212D00000000000000000000
        000000000000B9B9B9FFF3F3F3FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
        F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
        F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
        F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFDEDEDEFFBFBFBFFF2121212D0000
        0000000000000000000000000000B9B9B9FFF3F3F3FFF0F0F0FFF0F0F0FFF0F0
        F0FFF0F0F0FFF0F0F0FFE3E9E5FFC3D9CBFFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
        F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFB6D3C1FF12813CFF6BB791FF5AB2
        8AFF249964FF1F9760FF1F9760FF1F965FFF1C8B58FF18814CFF0E7E38FFA6B6
        ACFF2121212D00000000000000000000000000000000B9B9B9FFF4F4F4FFF1F1
        F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1
        F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1
        F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1
        F1FFDFDFDFFFBFBFBFFF2121212D00000000000000000000000000000000B9B9
        B9FFF4F4F4FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1
        F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1
        F1FFF1F1F1FF94C2A6FF1C8745FF73BD99FF4FAF82FF209961FF1F9960FF1F99
        60FF1E965EFF1C8956FF158146FF589970FF2121212D00000000000000000000
        000000000000B9B9B9FFF5F5F5FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2
        F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2
        F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2
        F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFE0E0E0FFBFBFBFFF2121212D0000
        0000000000000000000000000000B9B9B9FFF5F5F5FFF2F2F2FFF2F2F2FFF2F2
        F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2
        F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FF7FB794FF2B90
        54FF75C19DFF43AA7AFF1F9A61FF1F9A61FF1F9A61FF1E955EFF1B8856FF1280
        41FF17532D9E00000000000000000000000000000000B9B9B9FFF6F6F6FFF3F3
        F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3
        F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3
        F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3
        F3FFE1E1E1FFBFBFBFFF2121212D00000000000000000000000000000000B9B9
        B9FFF6F6F6FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3
        F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3
        F3FFF3F3F3FFF3F3F3FFF3F3F3FF70B088FF3F9D67FF70BF9BFF38A673FF209B
        62FF209B62FF209B62FF1E925DFF1B8754FF107F3DFF0636186D000000000000
        000000000000B9B9B9FFF6F6F6FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4
        F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4
        F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4
        F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFE2E2E2FFBFBFBFFF2121212D0000
        0000000000000000000000000000B9B9B9FFF6F6F6FFF4F4F4FFF4F4F4FFF4F4
        F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4
        F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFEFF2
        F0FF65AB80FF55AB7CFF68BC94FF2EA26CFF209C62FF209C62FF209B62FF1E91
        5BFF1A8650FF0F7E39FF04200E410000000000000000B9B9B9FFF7F7F7FFF4F4
        F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4
        F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4
        F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4
        F4FFE2E2E2FFC0C0C0FF2121212D00000000000000000000000000000000B9B9
        B9FFF7F7F7FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4
        F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4
        F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFC4DBCDFF11803AFF67B78EFF5DB8
        8EFF26A067FF209D63FF209D63FF209B62FF1D8F5AFF17844BFF095425AA0004
        020800000000A5A5A5E4F1F1F1FFF6F6F6FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5
        F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5
        F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5
        F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFE5E5E5FFBDBDBDFF1313131A0000
        0000000000000000000000000000A5A5A5E4F1F1F1FFF6F6F6FFF5F5F5FFF5F5
        F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5
        F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5
        F5FFF5F5F5FF9FC9AFFF1A8643FF72BF99FF53B487FF229E65FF219E64FF219E
        64FF209A62FF1D8D59FF148245FF08482091000000006666668DDCDCDCFFF9F9
        F9FFF7F7F7FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6
        F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6
        F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6
        F6FFDFDFDFFF8C8C8CC100000000000000000000000000000000000000006666
        668DDCDCDCFFF9F9F9FFF7F7F7FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6
        F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6
        F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FF85BC9AFF278E
        50FF76C39FFF47B07FFF219F64FF219F64FF219F64FF209860FF1D8C57FF1281
        3FFF052C14591A1A1A24BCBCBCFFECECECFFF9F9F9FFF8F8F8FFF7F7F7FFF7F7
        F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7
        F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7
        F7FFF7F7F7FFF7F7F7FFF8F8F8FFF0F0F0FFC2C2C2FF40404058000000000000
        00000000000000000000000000001A1A1A24BCBCBCFFECECECFFF9F9F9FFF8F8
        F8FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7
        F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7
        F7FFF7F7F7FFF7F7F7FFF7F7F7FF73B38BFF3A9B63FF73C39EFF3CAC78FF21A0
        65FF21A065FF27A369FF209B62FF1B9256FF0B602BC2000000004444445EBBBB
        BBFFD3D3D3FFE5E5E5FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
        E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
        E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE6E6E6FFD8D8D8FFBDBD
        BDFF5959597A0000000000000000000000000000000000000000000000000000
        00004444445EBBBBBBFFD3D3D3FFE5E5E5FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
        E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
        E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE6E6
        E6FF61A37AFF50AA78FF6BC098FF34A972FF32A871FF45B07EFF339C62FF0F80
        3AFF052C14590000000000000000040404064A4A4A667B7B7BAA888888BB8888
        88BB888888BB888888BB888888BB888888BB888888BB888888BB888888BB8888
        88BB888888BB888888BB888888BB888888BB888888BB888888BB888888BB8888
        88BB888888BB808080B1585858790C0C0C100000000000000000000000000000
        00000000000000000000000000000000000000000000040404064A4A4A667B7B
        7BAA888888BB888888BB888888BB888888BB888888BB888888BB888888BB8888
        88BB888888BB888888BB888888BB888888BB888888BB888888BB888888BB8888
        88BB888888BB888888BB888888BB808080B14C5E538F107F3AFF69B88FFF74C4
        9FFF49AC7BFF1B8947FF08482092020F071F0000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000052A1355178441FF3A9C64FF0F7F39FF05311664000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000010A05150635
        186C0002010400000000000000000000000000000000}
      Properties.GlyphCount = 2
      Properties.ImmediatePost = True
      Properties.NullStyle = nssUnchecked
      Properties.OnChange = ckbManualApprovePropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = []
      Style.HotTrack = False
      Style.LookAndFeel.Kind = lfUltraFlat
      Style.LookAndFeel.NativeStyle = False
      Style.TransparentBorder = False
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.Kind = lfUltraFlat
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfUltraFlat
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfUltraFlat
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 1
      Transparent = True
      Height = 40
      Width = 220
    end
    object ckbSelfCashIssued: TcxCheckBox
      Left = 274
      Top = 303
      AutoSize = False
      Caption = #54788#44552#50689#49688#51613' '#51088#51652' '#48156#44553' (F11)'
      ParentFont = False
      Properties.Glyph.SourceDPI = 96
      Properties.Glyph.Data = {
        424D362200000000000036000000280000004400000020000000010020000000
        000000000000C40E0000C40E0000000000000000000000000000000000000000
        00001F1F1F2B4F4F4F6D56565677565656775656567756565677565656775656
        5677565656775656567756565677565656775656567756565677565656775656
        56775656567756565677565656775656567756565677535353722D2D2D3E0101
        0101000000000000000000000000000000000000000000000000000000000000
        000000000000000000001F1F1F2B4F4F4F6D5656567756565677565656775656
        5677565656775656567756565677565656775656567756565677565656775656
        5677565656775656567756565677565656775656567756565677565656775353
        53722D2D2D3E0101010100000000000000000000000000000000000000000000
        000000000000000000001D1D1D286C6C6C95BBBBBBFFBCBCBCFFBBBBBBFFBBBB
        BBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBB
        BBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBB
        BBFFBBBBBBFFBBBBBBFFBABABAFFB9B9B9FF3939394F00000000000000000000
        0000000000000000000000000000000000001D1D1D286C6C6C95BBBBBBFFBCBC
        BCFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBB
        BBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBB
        BBFFBBBBBBFFBBBBBBFFBBBBBBFFBBBBBBFFBABABAFFB9B9B9FF3939394F0000
        0000000000000000000000000000000000000000000002020203B9B9B9FFC6C6
        C6FFC9C9C9FFCCCCCCFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECE
        CEFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECE
        CEFFCECECEFFCECECEFFCECECEFFCECECEFFCDCDCDFFC9C9C9FFC1C1C1FFBBBB
        BBFFBABABAFF2727273600000000000000000000000000000000000000000202
        0203B9B9B9FFC6C6C6FFC9C9C9FFCCCCCCFFCECECEFFCECECEFFCECECEFFCECE
        CEFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECE
        CEFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCECECEFFCDCDCDFFC9C9
        C9FFC1C1C1FFBBBBBBFFBABABAFF272727360000000000000000000000000000
        0000000000005050506EC8C8C8FFDADADAFFDDDDDDFFDFDFDFFFDFDFDFFFDFDF
        DFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDF
        DFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDF
        DFFFDFDFDFFFDFDFDFFFDBDBDBFFC9C9C9FFBDBDBDFF7373739F000000000000
        00000000000000000000000000005050506EC8C8C8FFDADADAFFDDDDDDFFDFDF
        DFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDF
        DFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDF
        DFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFDBDBDBFFC9C9C9FFBDBDBDFF7373
        739F00000000000000000000000000000000000000009C9C9CD7DDDDDDFFDEDE
        DEFFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0
        E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0
        E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFDADA
        DAFFC7C7C7FFBABABAFF0C0C0C10000000000000000000000000000000009C9C
        9CD7DDDDDDFFDEDEDEFFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0
        E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFD0D9D3FF7AB08EFFD0D9
        D3FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0
        E0FFE0E0E0FFDADADAFFC7C7C7FFBABABAFF0C0C0C1000000000000000000000
        000000000000B6B6B6FBE6E6E6FFE0E0E0FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1
        E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1
        E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1
        E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFCECECEFFBCBCBCFF2121212D0000
        0000000000000000000000000000B6B6B6FBE6E6E6FFE0E0E0FFE1E1E1FFE1E1
        E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1
        E1FF8FBB9FFF0E7E39FF137B42FF0E7E39FFAFCAB9FFE1E1E1FFE1E1E1FFE1E1
        E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFCECECEFFBCBC
        BCFF2121212D00000000000000000000000000000000B9B9B9FFE7E7E7FFE1E1
        E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1
        E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1
        E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1
        E1FFD0D0D0FFBCBCBCFF2121212D00000000000000000000000000000000B9B9
        B9FFE7E7E7FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1
        E1FFE1E1E1FFE1E1E1FFE1E1E1FF70AC87FF107E3CFF177D4BFF18784DFF1478
        44FF58A174FFDEDFDEFFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1
        E1FFE1E1E1FFE1E1E1FFD0D0D0FFBCBCBCFF2121212D00000000000000000000
        000000000000B9B9B9FFE8E8E8FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2
        E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2
        E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2
        E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFD1D1D1FFBDBDBDFF2121212D0000
        0000000000000000000000000000B9B9B9FFE8E8E8FFE2E2E2FFE2E2E2FFE2E2
        E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFBACFC2FF63A67CFF127E
        40FF188151FF1A8656FF1A8655FF187B4EFF127B40FF6AAA82FFE2E2E2FFE2E2
        E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFE2E2E2FFD1D1D1FFBDBD
        BDFF2121212D00000000000000000000000000000000B9B9B9FFE9E9E9FFE3E3
        E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3
        E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3
        E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3
        E3FFD2D2D2FFBDBDBDFF2121212D00000000000000000000000000000000B9B9
        B9FFE9E9E9FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3
        E3FF8EBB9FFF0E7E39FF157F47FF1A8354FF1A8857FF1B8B59FF1B8B59FF1A85
        55FF187A4DFF107C3DFF7CB291FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3E3FFE3E3
        E3FFE3E3E3FFE3E3E3FFD2D2D2FFBDBDBDFF2121212D00000000000000000000
        000000000000B9B9B9FFEAEAEAFFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4
        E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4
        E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4
        E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFD3D3D3FFBDBDBDFF2121212D0000
        0000000000000000000000000000B9B9B9FFEAEAEAFFE4E4E4FFE4E4E4FFE4E4
        E4FFE4E4E4FFE4E4E4FFE4E4E4FF70AD87FF107E3CFF18804DFF1B8756FF1C8B
        58FF1C8C59FF1C8C59FF1C8C59FF1C8C59FF1A8353FF177A4BFF0F7E3AFF9CC2
        AAFFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFE4E4E4FFD3D3D3FFBDBD
        BDFF2121212D00000000000000000000000000000000B9B9B9FFEBEBEBFFE5E5
        E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5
        E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5
        E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5
        E5FFD4D4D4FFBDBDBDFF2121212D00000000000000000000000000000000B9B9
        B9FFEBEBEBFFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFB9D0C2FF61A67AFF127F
        41FF198453FF1B8958FF1C8C5AFF1C8D5AFF1C8D5AFF1C8D5AFF1C8D5AFF1C8D
        5AFF1C8C59FF1A8153FF157A48FF0E7E38FFC9D8CFFFE5E5E5FFE5E5E5FFE5E5
        E5FFE5E5E5FFE5E5E5FFD4D4D4FFBDBDBDFF2121212D00000000000000000000
        000000000000B9B9B9FFEBEBEBFFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6
        E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6
        E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6
        E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFD5D5D5FFBDBDBDFF2121212D0000
        0000000000000000000000000000B9B9B9FFEBEBEBFFE6E6E6FFE6E6E6FFE6E6
        E6FF8CBB9EFF0E7E39FF158048FF1B8755FF1C8C59FF1C8E5AFF1C8E5AFF1C8E
        5AFF1C8E5AFF1C8E5AFF1C8E5AFF1C8E5AFF1C8E5AFF1B8B58FF198051FF137B
        43FF68A980FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFE6E6E6FFD5D5D5FFBDBD
        BDFF2121212D00000000000000000000000000000000B9B9B9FFEDEDEDFFE8E8
        E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8
        E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8
        E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8
        E8FFD7D7D7FFBDBDBDFF2121212D00000000000000000000000000000000B9B9
        B9FFEDEDEDFFE8E8E8FFE8E8E8FF70AE87FF107F3DFF18834FFF1B8957FF1C8E
        5AFF1C8F5BFF1C8F5BFF1C8F5BFF1C8F5BFF1D8F5CFF1D8F5CFF1E905CFF1C8F
        5BFF1C8F5BFF1C8F5BFF1B8A58FF197E50FF117D3FFF75B08BFFE8E8E8FFE8E8
        E8FFE8E8E8FFE8E8E8FFD7D7D7FFBDBDBDFF2121212D00000000000000000000
        000000000000B9B9B9FFEEEEEEFFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
        E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
        E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
        E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFD8D8D8FFBEBEBEFF2121212D0000
        0000000000000000000000000000B9B9B9FFEEEEEEFFE9E9E9FF97C1A6FF1384
        45FF1B8A58FF1C8C59FF1D8F5CFF1D905CFF1D905CFF1D905CFF1D905CFF2393
        60FF389D6FFF59AD87FF5BAE89FF279563FF1D905CFF1D905CFF1D905CFF1B88
        57FF187D4FFF107E3CFF8CBC9EFFE9E9E9FFE9E9E9FFE9E9E9FFD8D8D8FFBEBE
        BEFF2121212D00000000000000000000000000000000B9B9B9FFEEEEEEFFEAEA
        EAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEA
        EAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEA
        EAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEAEAFFEAEA
        EAFFD9D9D9FFBEBEBEFF2121212D00000000000000000000000000000000B9B9
        B9FFEEEEEEFFEAEAEAFF76B18CFF3C9B66FF5FB18CFF369D6EFF1D915CFF1D91
        5CFF1D915CFF1E915DFF2A9766FF3A9F71FF389965FF188442FF6FB893FF56AD
        85FF21935FFF1D915CFF1D915CFF1D905CFF1B8756FF177D4BFF0E7E39FFB4CF
        BEFFEAEAEAFFEAEAEAFFD9D9D9FFBEBEBEFF2121212D00000000000000000000
        000000000000B9B9B9FFEFEFEFFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEB
        EBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEB
        EBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEB
        EBFFEBEBEBFFEBEBEBFFEBEBEBFFEBEBEBFFD9D9D9FFBEBEBEFF2121212D0000
        0000000000000000000000000000B9B9B9FFEFEFEFFFEBEBEBFFD1DED6FF0E7E
        38FF54A77AFF6AB794FF309B6BFF1D925DFF219460FF309B6BFF3FA173FF218B
        4DFF6AAB82FF8BBC9DFF1F8848FF73BA99FF4BA87EFF1E925EFF1D925DFF1D92
        5DFF1D905CFF1A8555FF157D48FF59A375FFE5E8E6FFEBEBEBFFD9D9D9FFBEBE
        BEFF2121212D00000000000000000000000000000000B9B9B9FFF0F0F0FFECEC
        ECFFECECECFFECECECFFECECECFFECECECFFECECECFFECECECFFECECECFFECEC
        ECFFECECECFFECECECFFECECECFFECECECFFECECECFFECECECFFECECECFFECEC
        ECFFECECECFFECECECFFECECECFFECECECFFECECECFFECECECFFECECECFFECEC
        ECFFDADADAFFBEBEBEFF2121212D00000000000000000000000000000000B9B9
        B9FFF0F0F0FFECECECFFECECECFFC2D7CAFF0F7F39FF5FAE84FF66B692FF379F
        70FF379F70FF3C9E6CFF14823FFF7BB490FFECECECFFECECECFF76B28DFF2F92
        57FF73BC9BFF3FA375FF1E935EFF1E935EFF1E935EFF1D8F5BFF1B8354FF137E
        43FF6FAE86FFECECECFFDADADAFFBEBEBEFF2121212D00000000000000000000
        000000000000B9B9B9FFF1F1F1FFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDED
        EDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDED
        EDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDED
        EDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFDBDBDBFFBEBEBEFF2121212D0000
        0000000000000000000000000000B9B9B9FFF1F1F1FFEDEDEDFFEDEDEDFFEDED
        EDFFAECEBAFF12813CFF6DB690FF6EBB97FF2C935AFF0E7E38FFA4C9B2FFEDED
        EDFFEDEDEDFFEDEDEDFFEDEDEDFF6CAD85FF459F6CFF6DBA97FF349F6EFF1E95
        5EFF1E955EFF1E955EFF1D8F5AFF1A8352FF117E3EFF81B795FFDBDBDBFFBEBE
        BEFF2121212D00000000000000000000000000000000B9B9B9FFF2F2F2FFEEEE
        EEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEE
        EEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEE
        EEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEE
        EEFFDCDCDCFFBEBEBEFF2121212D00000000000000000000000000000000B9B9
        B9FFF2F2F2FFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFA0C7AEFF14823EFF1F89
        4AFF6FAE87FFE2E8E4FFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFEEEEEEFFDEE6
        E1FF0E7E38FF59AC80FF64B791FF299B67FF1E965FFF1E965FFF1E965FFF1C8D
        59FF19824FFF0F7E3AFF95BCA3FFBEBEBEFF2121212D00000000000000000000
        000000000000B9B9B9FFF3F3F3FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
        F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
        F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
        F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFDEDEDEFFBFBFBFFF2121212D0000
        0000000000000000000000000000B9B9B9FFF3F3F3FFF0F0F0FFF0F0F0FFF0F0
        F0FFF0F0F0FFF0F0F0FFE3E9E5FFC3D9CBFFF0F0F0FFF0F0F0FFF0F0F0FFF0F0
        F0FFF0F0F0FFF0F0F0FFF0F0F0FFF0F0F0FFB6D3C1FF12813CFF6BB791FF5AB2
        8AFF249964FF1F9760FF1F9760FF1F965FFF1C8B58FF18814CFF0E7E38FFA6B6
        ACFF2121212D00000000000000000000000000000000B9B9B9FFF4F4F4FFF1F1
        F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1
        F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1
        F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1
        F1FFDFDFDFFFBFBFBFFF2121212D00000000000000000000000000000000B9B9
        B9FFF4F4F4FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1
        F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1F1FFF1F1
        F1FFF1F1F1FF94C2A6FF1C8745FF73BD99FF4FAF82FF209961FF1F9960FF1F99
        60FF1E965EFF1C8956FF158146FF589970FF2121212D00000000000000000000
        000000000000B9B9B9FFF5F5F5FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2
        F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2
        F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2
        F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFE0E0E0FFBFBFBFFF2121212D0000
        0000000000000000000000000000B9B9B9FFF5F5F5FFF2F2F2FFF2F2F2FFF2F2
        F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2
        F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FF7FB794FF2B90
        54FF75C19DFF43AA7AFF1F9A61FF1F9A61FF1F9A61FF1E955EFF1B8856FF1280
        41FF17532D9E00000000000000000000000000000000B9B9B9FFF6F6F6FFF3F3
        F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3
        F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3
        F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3
        F3FFE1E1E1FFBFBFBFFF2121212D00000000000000000000000000000000B9B9
        B9FFF6F6F6FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3
        F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3
        F3FFF3F3F3FFF3F3F3FFF3F3F3FF70B088FF3F9D67FF70BF9BFF38A673FF209B
        62FF209B62FF209B62FF1E925DFF1B8754FF107F3DFF0636186D000000000000
        000000000000B9B9B9FFF6F6F6FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4
        F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4
        F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4
        F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFE2E2E2FFBFBFBFFF2121212D0000
        0000000000000000000000000000B9B9B9FFF6F6F6FFF4F4F4FFF4F4F4FFF4F4
        F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4
        F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFEFF2
        F0FF65AB80FF55AB7CFF68BC94FF2EA26CFF209C62FF209C62FF209B62FF1E91
        5BFF1A8650FF0F7E39FF04200E410000000000000000B9B9B9FFF7F7F7FFF4F4
        F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4
        F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4
        F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4
        F4FFE2E2E2FFC0C0C0FF2121212D00000000000000000000000000000000B9B9
        B9FFF7F7F7FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4
        F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4
        F4FFF4F4F4FFF4F4F4FFF4F4F4FFF4F4F4FFC4DBCDFF11803AFF67B78EFF5DB8
        8EFF26A067FF209D63FF209D63FF209B62FF1D8F5AFF17844BFF095425AA0004
        020800000000A5A5A5E4F1F1F1FFF6F6F6FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5
        F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5
        F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5
        F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFE5E5E5FFBDBDBDFF1313131A0000
        0000000000000000000000000000A5A5A5E4F1F1F1FFF6F6F6FFF5F5F5FFF5F5
        F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5
        F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5
        F5FFF5F5F5FF9FC9AFFF1A8643FF72BF99FF53B487FF229E65FF219E64FF219E
        64FF209A62FF1D8D59FF148245FF08482091000000006666668DDCDCDCFFF9F9
        F9FFF7F7F7FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6
        F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6
        F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6
        F6FFDFDFDFFF8C8C8CC100000000000000000000000000000000000000006666
        668DDCDCDCFFF9F9F9FFF7F7F7FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6
        F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6
        F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FF85BC9AFF278E
        50FF76C39FFF47B07FFF219F64FF219F64FF219F64FF209860FF1D8C57FF1281
        3FFF052C14591A1A1A24BCBCBCFFECECECFFF9F9F9FFF8F8F8FFF7F7F7FFF7F7
        F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7
        F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7
        F7FFF7F7F7FFF7F7F7FFF8F8F8FFF0F0F0FFC2C2C2FF40404058000000000000
        00000000000000000000000000001A1A1A24BCBCBCFFECECECFFF9F9F9FFF8F8
        F8FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7
        F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7
        F7FFF7F7F7FFF7F7F7FFF7F7F7FF73B38BFF3A9B63FF73C39EFF3CAC78FF21A0
        65FF21A065FF27A369FF209B62FF1B9256FF0B602BC2000000004444445EBBBB
        BBFFD3D3D3FFE5E5E5FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
        E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
        E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE6E6E6FFD8D8D8FFBDBD
        BDFF5959597A0000000000000000000000000000000000000000000000000000
        00004444445EBBBBBBFFD3D3D3FFE5E5E5FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
        E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
        E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE6E6
        E6FF61A37AFF50AA78FF6BC098FF34A972FF32A871FF45B07EFF339C62FF0F80
        3AFF052C14590000000000000000040404064A4A4A667B7B7BAA888888BB8888
        88BB888888BB888888BB888888BB888888BB888888BB888888BB888888BB8888
        88BB888888BB888888BB888888BB888888BB888888BB888888BB888888BB8888
        88BB888888BB808080B1585858790C0C0C100000000000000000000000000000
        00000000000000000000000000000000000000000000040404064A4A4A667B7B
        7BAA888888BB888888BB888888BB888888BB888888BB888888BB888888BB8888
        88BB888888BB888888BB888888BB888888BB888888BB888888BB888888BB8888
        88BB888888BB888888BB888888BB808080B14C5E538F107F3AFF69B88FFF74C4
        9FFF49AC7BFF1B8947FF08482092020F071F0000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000052A1355178441FF3A9C64FF0F7F39FF05311664000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000010A05150635
        186C0002010400000000000000000000000000000000}
      Properties.GlyphCount = 2
      Properties.ImmediatePost = True
      Properties.NullStyle = nssUnchecked
      Properties.OnChange = ckbSelfCashIssuedPropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = 33023
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = []
      Style.HotTrack = False
      Style.LookAndFeel.Kind = lfUltraFlat
      Style.LookAndFeel.NativeStyle = False
      Style.TransparentBorder = False
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.Kind = lfUltraFlat
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfUltraFlat
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfUltraFlat
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 0
      Transparent = True
      Height = 40
      Width = 220
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
