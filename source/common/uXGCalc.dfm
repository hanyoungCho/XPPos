object XGCalcForm: TXGCalcForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 500
  ClientWidth = 400
  Color = 16054762
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Noto Sans CJK KR Regular'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  TextHeight = 22
  object lblFormTitle: TLabel
    Left = 0
    Top = 0
    Width = 400
    Height = 60
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = #44228#49328#44592
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
  end
  object panBody: TPanel
    Left = 42
    Top = 91
    Width = 316
    Height = 386
    AutoSize = True
    BevelOuter = bvNone
    Color = 16054762
    ParentBackground = False
    TabOrder = 0
    object btn0: TcxButton
      Tag = 48
      Left = 0
      Top = 258
      Width = 60
      Height = 60
      Caption = '0'
      Colors.Default = clWhite
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 0
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -24
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = CalcButtonClick
    end
    object btn00: TcxButton
      Tag = 48
      Left = 64
      Top = 258
      Width = 60
      Height = 60
      HelpContext = 2
      Caption = '00'
      Colors.Default = clWhite
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 1
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -24
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = CalcButtonClick
    end
    object btn1: TcxButton
      Tag = 49
      Left = 0
      Top = 194
      Width = 60
      Height = 60
      Caption = '1'
      Colors.Default = clWhite
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 2
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -24
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = CalcButtonClick
    end
    object btn2: TcxButton
      Tag = 50
      Left = 64
      Top = 194
      Width = 60
      Height = 60
      Caption = '2'
      Colors.Default = clWhite
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 3
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -24
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = CalcButtonClick
    end
    object btn3: TcxButton
      Tag = 51
      Left = 128
      Top = 194
      Width = 60
      Height = 60
      Caption = '3'
      Colors.Default = clWhite
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 4
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -24
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = CalcButtonClick
    end
    object btn4: TcxButton
      Tag = 52
      Left = 0
      Top = 130
      Width = 60
      Height = 60
      Caption = '4'
      Colors.Default = clWhite
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 5
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -24
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = CalcButtonClick
    end
    object btn5: TcxButton
      Tag = 53
      Left = 64
      Top = 130
      Width = 60
      Height = 60
      Caption = '5'
      Colors.Default = clWhite
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 6
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -24
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = CalcButtonClick
    end
    object btn6: TcxButton
      Tag = 54
      Left = 128
      Top = 130
      Width = 60
      Height = 60
      Caption = '6'
      Colors.Default = clWhite
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 7
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -24
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = CalcButtonClick
    end
    object btn7: TcxButton
      Tag = 55
      Left = 0
      Top = 66
      Width = 60
      Height = 60
      Caption = '7'
      Colors.Default = clWhite
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 8
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -24
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = CalcButtonClick
    end
    object btn8: TcxButton
      Tag = 56
      Left = 64
      Top = 66
      Width = 60
      Height = 60
      Caption = '8'
      Colors.Default = clWhite
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 9
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -24
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = CalcButtonClick
    end
    object btn9: TcxButton
      Tag = 57
      Left = 128
      Top = 66
      Width = 60
      Height = 60
      Caption = '9'
      Colors.Default = clWhite
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 10
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clBlack
      Font.Height = -24
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = CalcButtonClick
    end
    object btnClear: TcxButton
      Tag = 67
      Left = 256
      Top = 66
      Width = 60
      Height = 60
      Caption = 'C'
      Colors.Default = clWhite
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 11
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clMaroon
      Font.Height = -24
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = CalcButtonClick
    end
    object btnComma: TcxButton
      Tag = 46
      Left = 128
      Top = 258
      Width = 60
      Height = 60
      Caption = '.'
      Colors.Default = clWhite
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 12
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clGray
      Font.Height = -24
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = CalcButtonClick
    end
    object btnDivide: TcxButton
      Tag = 47
      Left = 192
      Top = 258
      Width = 60
      Height = 60
      Caption = '/'
      Colors.Default = clWhite
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 13
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clGray
      Font.Height = -24
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = CalcButtonClick
    end
    object btnEqual: TcxButton
      Tag = 61
      Left = 256
      Top = 258
      Width = 60
      Height = 60
      Caption = '='
      Colors.Default = clWhite
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 14
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clGray
      Font.Height = -24
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = CalcButtonClick
    end
    object btnMinus: TcxButton
      Tag = 45
      Left = 192
      Top = 130
      Width = 60
      Height = 60
      Caption = #65293
      Colors.Default = clWhite
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 15
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clGray
      Font.Height = -24
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = CalcButtonClick
    end
    object btnMulti: TcxButton
      Tag = 42
      Left = 192
      Top = 66
      Width = 60
      Height = 60
      Caption = '*'
      Colors.Default = clWhite
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 16
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clGray
      Font.Height = -24
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = CalcButtonClick
    end
    object btnPercent: TcxButton
      Tag = 8
      Left = 256
      Top = 130
      Width = 60
      Height = 60
      Caption = 'BS'
      Colors.Default = clWhite
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 17
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clMaroon
      Font.Height = -24
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = CalcButtonClick
    end
    object btnPlus: TcxButton
      Tag = 43
      Left = 192
      Top = 194
      Width = 60
      Height = 60
      Caption = '+'
      Colors.Default = clWhite
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 18
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clGray
      Font.Height = -24
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = CalcButtonClick
    end
    object btnSign: TcxButton
      Tag = 35
      Left = 256
      Top = 194
      Width = 60
      Height = 60
      Caption = '+/-'
      Colors.Default = clWhite
      LookAndFeel.Kind = lfUltraFlat
      LookAndFeel.NativeStyle = False
      TabOrder = 19
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clGray
      Font.Height = -24
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = CalcButtonClick
    end
    object btnOK: TAdvShapeButton
      Tag = 106
      Left = 59
      Top = 336
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
      TabOrder = 20
      Text = #54869' '#51064
      Version = '6.2.1.8'
      OnClick = btnOKClick
    end
    object btnCancel: TAdvShapeButton
      Tag = 106
      Left = 161
      Top = 336
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
      TabOrder = 21
      Text = #52712' '#49548#13#10'(ESC)'
      Version = '6.2.1.8'
      OnClick = btnCloseClick
    end
    object lblCalcResult: TcxLabel
      Left = 0
      Top = 0
      AutoSize = False
      Caption = '0 '
      ParentColor = False
      ParentFont = False
      Style.BorderStyle = ebsSingle
      Style.Color = 3158064
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = clWhite
      Style.Font.Height = -37
      Style.Font.Name = 'Noto Sans CJK KR Bold'
      Style.Font.Style = [fsBold]
      Style.LookAndFeel.Kind = lfOffice11
      Style.LookAndFeel.NativeStyle = False
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.Kind = lfOffice11
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfOffice11
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfOffice11
      StyleHot.LookAndFeel.NativeStyle = False
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Height = 60
      Width = 316
      AnchorX = 316
      AnchorY = 30
    end
  end
  object btnClose: TAdvShapeButton
    Left = 348
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
    TabOrder = 1
    Version = '6.2.1.8'
    OnClick = btnCloseClick
  end
end
