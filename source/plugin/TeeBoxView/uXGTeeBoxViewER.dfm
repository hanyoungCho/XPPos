object XGTeeBoxViewForm: TXGTeeBoxViewForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 768
  ClientWidth = 1366
  Color = 33023
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Noto Sans CJK KR Regular'
  Font.Style = []
  KeyPreview = True
  Position = poMainFormCenter
  Visible = True
  OnActivate = PluginModuleActivate
  OnClose = PluginModuleClose
  OnCloseQuery = PluginModuleCloseQuery
  OnDeactivate = PluginModuleDeactivate
  OnKeyDown = PluginModuleKeyDown
  OnShow = PluginModuleShow
  PluginGroup = 0
  InitHeight = 0
  InitWidth = 0
  EscCanClose = False
  OnMessage = PluginModuleMessage
  TextHeight = 22
  object panHeader: TPanel
    Left = 0
    Top = 0
    Width = 1366
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    Caption = #44596#44553' '#53440#49437' '#48176#51221' '#44288#47532
    Color = 3158064
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWhite
    Font.Height = -32
    Font.Name = 'Noto Sans CJK KR Bold'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object lblPOSInfo: TLabel
      Left = 209
      Top = 26
      Width = 230
      Height = 28
      AutoSize = False
      Caption = '|  '#44596#44553' '#48176#51221
      EllipsisPosition = epEndEllipsis
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
    end
    object lblPluginVersion: TLabel
      Left = 11
      Top = 10
      Width = 95
      Height = 13
      Caption = 'PLUGIN Ver.1.0.0.0'
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clSilver
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = False
    end
    object Panel9: TPanel
      Left = 1054
      Top = 0
      Width = 202
      Height = 65
      Align = alRight
      BevelOuter = bvNone
      Color = 3158064
      ParentBackground = False
      TabOrder = 0
      object ledPlayingCount: TLEDFontNum
        Left = 138
        Top = 22
        Width = 67
        Height = 37
        Thick = 3
        Space = 4
        Text = '000'
        BGColor = 3158064
        LightColor = 16777088
        DrawDarkColor = False
      end
      object ledWaitingCount: TLEDFontNum
        Left = 69
        Top = 22
        Width = 67
        Height = 37
        Thick = 3
        Space = 4
        Text = '000'
        BGColor = 3158064
        DrawDarkColor = False
      end
      object ledReadyCount: TLEDFontNum
        Left = 0
        Top = 22
        Width = 67
        Height = 37
        Thick = 3
        Space = 4
        Text = '000'
        BGColor = 3158064
        LightColor = 8454016
        DrawDarkColor = False
      end
      object Label15: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 196
        Height = 19
        Align = alTop
        Caption = '  '#51593#49884#44032#45733'       '#45824#44592#51473'        '#51060#50857#51473
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 188
      end
    end
    object panClock: TPanel
      AlignWithMargins = True
      Left = 9
      Top = 25
      Width = 192
      Height = 30
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      AutoSize = True
      BevelOuter = bvNone
      Color = 3158064
      ParentBackground = False
      TabOrder = 1
      object lblClockHours: TLabel
        Left = 130
        Top = 0
        Width = 26
        Height = 30
        Align = alLeft
        Alignment = taRightJustify
        AutoSize = False
        Caption = '99'
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clWhite
        Font.Height = -19
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        Transparent = False
        Layout = tlCenter
        ExplicitLeft = 144
      end
      object lblClockWeekday: TLabel
        Left = 98
        Top = 0
        Width = 32
        Height = 30
        Align = alLeft
        Alignment = taRightJustify
        AutoSize = False
        Caption = '('#50900')'
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clWhite
        Font.Height = -19
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        Transparent = False
        Layout = tlCenter
        ExplicitLeft = 103
        ExplicitTop = 1
      end
      object lblClockDate: TLabel
        Left = 0
        Top = 0
        Width = 98
        Height = 30
        Align = alLeft
        Alignment = taRightJustify
        Caption = '9999.99.99'
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clWhite
        Font.Height = -19
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        Transparent = False
        Layout = tlCenter
        ExplicitHeight = 28
      end
      object lblClockSepa: TLabel
        Left = 156
        Top = 0
        Width = 10
        Height = 30
        Align = alLeft
        Alignment = taCenter
        AutoSize = False
        Caption = ':'
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clWhite
        Font.Height = -19
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        Transparent = False
        Layout = tlCenter
        ExplicitLeft = 235
        ExplicitHeight = 41
      end
      object lblClockMins: TLabel
        Left = 166
        Top = 0
        Width = 26
        Height = 30
        Align = alLeft
        AutoSize = False
        Caption = '99'
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clWhite
        Font.Height = -19
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        Transparent = False
        Layout = tlCenter
        ExplicitLeft = 180
      end
    end
    object panHeaderTools: TPanel
      AlignWithMargins = True
      Left = 1261
      Top = 5
      Width = 100
      Height = 55
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alRight
      AutoSize = True
      BevelOuter = bvNone
      Color = 3158064
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWhite
      Font.Height = -32
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      Padding.Left = 3
      Padding.Top = 3
      Padding.Right = 3
      Padding.Bottom = 3
      ParentBackground = False
      ParentFont = False
      TabOrder = 2
      object btnHome: TAdvShapeButton
        Left = 3
        Top = 5
        Width = 44
        Height = 44
        Hint = #49884#51089' '#54868#47732
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Picture.Data = {
          89504E470D0A1A0A0000000D494844520000002C0000002C08060000001E845A
          01000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
          00097048597300000EC300000EC301C76FA8640000011F494441545847ED9741
          0EC15010865BC20DECEDDCA02B0937B1B2E110EA12DD49AC9C83C4CAD209ECDD
          A08DD43FE92C28C57B312F21FF97FC99198BBFA346A72F22848425D678475996
          638451553993C5717C96043E3D8429D491DA911D7CB69ABF06175A403EE450A2
          36E293E8673E2CD4E68E96C69F810D5BC386AD61C3D6B0616B9A56B36C99B4AA
          9C28A02156EA410AF8F41126927B107E355BC019BE0577BB0D757CA4160F58CF
          F000610575A576640D9F4CF3D748C3900F7CBDACD33412F2289A5795133934C3
          4F7994023E72B7F790CF892385CF52F3F7E0624FFF0C1FA8AD16614702DFAEF0
          D4452D4CF89B19FED6A939CC0CCBFCC81079C0C75A1D366C0D1BB6860D5BC386
          ADF9F66A9613C7062BF524057CC29C9A09215644D1153CE69CFFF6A641B60000
          000049454E44AE426082}
        PictureDown.Data = {
          89504E470D0A1A0A0000000D494844520000002C0000002C08060000001E845A
          01000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
          00097048597300000EC300000EC301C76FA86400000124494441545847ED974F
          6A83501087D5D27556EEB3E80DFCB30AB437C92A9B5E22F6123D42AF9104924D
          D53B749F0B0442B4BF890FC1362EDEE38D20FC3E18DE3C04F97C8C8E131042A6
          2534EB80AAAADEB0BC763B3BC230FC4C92E42C795DD771DBB61BA4CFB2B7E490
          A6E9DEE43D63C25B2C45B7B3E20AE11584BF6503E11CC247A42EC205843F4CDE
          1399753650581B0A6B43616D28AC8D76A75BA2D3ADEF57EC99BE356BC092F853
          124F4DD3381D4A966557930ED03EE1173CC00E71B20D1CDABBB9C7006DE10522
          47640E1123FE31BB1A1E13FE41940E21B57B41A8F1F0A513CAB274991282288A
          1ABC7437C935268E51611F70440263DF615F53F33425E1B171B02428AC0D85B5
          A1B03614D6C6776B964EF7854E27BFA7D2E9BC4FCD84904909825F0AA298134D
          4E178F0000000049454E44AE426082}
        PictureDisabled.Data = {
          89504E470D0A1A0A0000000D494844520000002C0000002C08060000001E845A
          01000000017352474200AECE1CE90000000467414D410000B18F0BFC61050000
          00097048597300000EC300000EC301C76FA86400000124494441545847ED974F
          6A83501087D5D27556EEB3E80DFCB30AB437C92A9B5E22F6123D42AF9104924D
          D53B749F0B0442B4BF890FC1362EDEE38D20FC3E18DE3C04F97C8C8E131042A6
          2534EB80AAAADEB0BC763B3BC230FC4C92E42C795DD771DBB61BA4CFB2B7E490
          A6E9DEE43D63C25B2C45B7B3E20AE11584BF6503E11CC247A42EC205843F4CDE
          1399753650581B0A6B43616D28AC8D76A75BA2D3ADEF57EC99BE356BC092F853
          124F4DD3381D4A966557930ED03EE1173CC00E71B20D1CDABBB9C7006DE10522
          47640E1123FE31BB1A1E13FE41940E21B57B41A8F1F0A513CAB274991282288A
          1ABC7437C935268E51611F70440263DF615F53F33425E1B171B02428AC0D85B5
          A1B03614D6C6776B964EF7854E27BFA7D2E9BC4FCD84904909825F0AA298134D
          4E178F0000000049454E44AE426082}
        ParentBackground = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabStop = True
        TabOrder = 0
        Version = '6.2.1.8'
        OnClick = btnHomeClick
      end
      object btnClose: TAdvShapeButton
        Left = 53
        Top = 5
        Width = 44
        Height = 44
        Hint = #54532#47196#44536#47016' '#51333#47308
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
  end
  object panTeeBox1: TPanel
    AlignWithMargins = True
    Left = 349
    Top = 224
    Width = 54
    Height = 126
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 1
    Margins.Bottom = 0
    BevelKind = bkFlat
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    Visible = False
    object _MemberLabel: TcxLabel
      Left = 0
      Top = 26
      Align = alTop
      AutoSize = False
      Caption = #44256#44061#47749
      ParentColor = False
      ParentFont = False
      Style.BorderStyle = ebsUltraFlat
      Style.Color = 30702
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = clWhite
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = []
      Style.LookAndFeel.Kind = lfUltraFlat
      Style.LookAndFeel.NativeStyle = False
      Style.IsFontAssigned = True
      StyleDisabled.Color = clBtnFace
      StyleDisabled.LookAndFeel.Kind = lfUltraFlat
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfUltraFlat
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfUltraFlat
      StyleHot.LookAndFeel.NativeStyle = False
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Height = 24
      Width = 50
      AnchorX = 25
      AnchorY = 38
    end
    object _RemainMinLabel: TcxLabel
      Left = 0
      Top = 50
      Align = alTop
      AutoSize = False
      Caption = '120'#48516
      ParentFont = False
      Style.BorderStyle = ebsUltraFlat
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = []
      Style.LookAndFeel.NativeStyle = False
      Style.IsFontAssigned = True
      StyleDisabled.Color = clBtnFace
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.NativeStyle = False
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Height = 24
      Width = 50
      AnchorX = 25
      AnchorY = 62
    end
    object _EndTimeLabel: TcxLabel
      Left = 0
      Top = 74
      Align = alTop
      AutoSize = False
      Caption = '10:35'
      ParentFont = False
      Style.BorderStyle = ebsUltraFlat
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = []
      Style.LookAndFeel.NativeStyle = False
      Style.IsFontAssigned = True
      StyleDisabled.Color = clBtnFace
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.NativeStyle = False
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Height = 24
      Width = 50
      AnchorX = 25
      AnchorY = 86
    end
    object lblReservedCnt1: TcxLabel
      Left = 0
      Top = 98
      Align = alClient
      AutoSize = False
      Caption = '10'
      ParentColor = False
      ParentFont = False
      Style.BorderStyle = ebsUltraFlat
      Style.Color = 16054762
      Style.Edges = []
      Style.Font.Charset = HANGEUL_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -15
      Style.Font.Name = 'Noto Sans CJK KR Regular'
      Style.Font.Style = []
      Style.LookAndFeel.NativeStyle = False
      Style.IsFontAssigned = True
      StyleDisabled.Color = clBtnFace
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.NativeStyle = False
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Height = 24
      Width = 50
      AnchorX = 25
      AnchorY = 110
    end
    object _TeeBoxButton: TPanel
      AlignWithMargins = True
      Left = 1
      Top = 1
      Width = 48
      Height = 24
      Margins.Left = 1
      Margins.Top = 1
      Margins.Right = 1
      Margins.Bottom = 1
      Align = alTop
      BevelOuter = bvNone
      Caption = '24'
      Color = 4575502
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = True
      object _LRLabel: TcxLabel
        Left = 0
        Top = 0
        Align = alLeft
        AutoSize = False
        Caption = 'L'
        ParentColor = False
        ParentFont = False
        Style.BorderStyle = ebsUltraFlat
        Style.Color = 11957550
        Style.Edges = []
        Style.Font.Charset = HANGEUL_CHARSET
        Style.Font.Color = clWhite
        Style.Font.Height = -12
        Style.Font.Name = 'Noto Sans CJK KR Regular'
        Style.Font.Style = [fsBold]
        Style.LookAndFeel.NativeStyle = False
        Style.IsFontAssigned = True
        StyleDisabled.Color = clBtnFace
        StyleDisabled.LookAndFeel.NativeStyle = False
        StyleFocused.LookAndFeel.NativeStyle = False
        StyleHot.LookAndFeel.NativeStyle = False
        Properties.Alignment.Horz = taCenter
        Properties.Alignment.Vert = taVCenter
        Height = 24
        Width = 15
        AnchorX = 8
        AnchorY = 12
      end
      object _VIPLabel: TcxLabel
        Left = 33
        Top = 0
        Align = alRight
        AutoSize = False
        Caption = 'V'
        ParentColor = False
        ParentFont = False
        Style.BorderStyle = ebsUltraFlat
        Style.Color = 3342579
        Style.Edges = []
        Style.Font.Charset = HANGEUL_CHARSET
        Style.Font.Color = clWhite
        Style.Font.Height = -12
        Style.Font.Name = 'Noto Sans CJK KR Regular'
        Style.Font.Style = [fsBold]
        Style.LookAndFeel.NativeStyle = False
        Style.IsFontAssigned = True
        StyleDisabled.Color = clBtnFace
        StyleDisabled.LookAndFeel.NativeStyle = False
        StyleFocused.LookAndFeel.NativeStyle = False
        StyleHot.LookAndFeel.NativeStyle = False
        Properties.Alignment.Horz = taCenter
        Properties.Alignment.Vert = taVCenter
        Height = 24
        Width = 15
        AnchorX = 41
        AnchorY = 12
      end
    end
  end
  object panBasePanel: TPanel
    Left = 0
    Top = 65
    Width = 1366
    Height = 703
    Align = alClient
    BevelOuter = bvNone
    Color = 33023
    ParentBackground = False
    TabOrder = 2
    object panTeeBoxFloor2: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 174
      Width = 1356
      Height = 18
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      Color = 33023
      ParentBackground = False
      TabOrder = 3
      object panFloorName2: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 24
        Height = 18
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 2
        Margins.Bottom = 0
        Align = alLeft
        BevelOuter = bvNone
        Color = 6052956
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
    end
    object panTeeBoxFloor3: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 151
      Width = 1356
      Height = 18
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      Color = 33023
      ParentBackground = False
      TabOrder = 4
      object panFloorName3: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 24
        Height = 18
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 2
        Margins.Bottom = 0
        Align = alLeft
        BevelOuter = bvNone
        Color = 6052956
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
    end
    object panTeeBoxFloor5: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 5
      Width = 1356
      Height = 118
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      Color = 33023
      ParentBackground = False
      TabOrder = 6
      object panFloorName5: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 24
        Height = 118
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 2
        Margins.Bottom = 0
        Align = alLeft
        BevelOuter = bvNone
        Color = 6052956
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
    end
    object panBody: TPanel
      Left = 0
      Top = 215
      Width = 1366
      Height = 425
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      BevelOuter = bvNone
      Color = 33023
      ParentBackground = False
      TabOrder = 0
      object Panel2: TPanel
        AlignWithMargins = True
        Left = 215
        Top = 5
        Width = 200
        Height = 420
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        BevelOuter = bvNone
        Color = clWhite
        Font.Charset = HANGEUL_CHARSET
        Font.Color = 8487297
        Font.Height = -16
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 200
          Height = 32
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 1
          Margins.Bottom = 0
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = ' '#8801#44592#48376#49884#44036'('#48516')'
          Color = 3158064
          Font.Charset = HANGEUL_CHARSET
          Font.Color = clWhite
          Font.Height = -16
          Font.Name = 'Noto Sans CJK KR Regular'
          Font.Style = []
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object trbPrepareMin: TcxTrackBar
          AlignWithMargins = True
          Left = 25
          Top = 76
          Position = 5
          Properties.AutoSize = False
          Properties.Frequency = 5
          Properties.Max = 60
          Properties.Orientation = tboVertical
          Properties.ReverseDirection = True
          Properties.SelectionColor = 3158064
          Properties.ShowChangeButtons = True
          Properties.ShowPositionHint = True
          Properties.ThumbColor = 6052956
          Properties.ThumbHeight = 20
          Properties.ThumbWidth = 10
          Properties.TickSize = 5
          Properties.TickType = tbttTicksAndNumbers
          Properties.TrackSize = 10
          Properties.OnChange = trbPrepareMinPropertiesChange
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 1
          Transparent = True
          Height = 189
          Width = 70
        end
        object Panel6: TPanel
          Left = 0
          Top = 32
          Width = 200
          Height = 41
          Align = alTop
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 3
          object Label7: TLabel
            Left = 7
            Top = 11
            Width = 28
            Height = 22
            Caption = #51456#48708
            Font.Charset = HANGEUL_CHARSET
            Font.Color = clBlack
            Font.Height = -15
            Font.Name = 'Noto Sans CJK KR Regular'
            Font.Style = []
            ParentFont = False
          end
          object Label1: TLabel
            Left = 100
            Top = 11
            Width = 28
            Height = 22
            Caption = #48176#51221
            Font.Charset = HANGEUL_CHARSET
            Font.Color = clBlack
            Font.Height = -15
            Font.Name = 'Noto Sans CJK KR Regular'
            Font.Style = []
            ParentFont = False
          end
          object edtPrepareMin: TcxSpinEdit
            Left = 39
            Top = 6
            ParentFont = False
            Properties.Alignment.Horz = taCenter
            Properties.ImmediatePost = True
            Properties.MaxValue = 60.000000000000000000
            Properties.UseLeftAlignmentOnEditing = False
            Properties.OnChange = edtPrepareMinPropertiesChange
            Style.Font.Charset = HANGEUL_CHARSET
            Style.Font.Color = 3487168
            Style.Font.Height = -16
            Style.Font.Name = 'Noto Sans CJK KR Regular'
            Style.Font.Style = [fsBold]
            Style.IsFontAssigned = True
            TabOrder = 0
            Value = 5
            Width = 50
          end
          object edtAssignMin: TcxSpinEdit
            Left = 132
            Top = 6
            ParentFont = False
            Properties.Alignment.Horz = taCenter
            Properties.ImmediatePost = True
            Properties.MaxValue = 900.000000000000000000
            Properties.UseLeftAlignmentOnEditing = False
            Properties.OnChange = edtAssignMinPropertiesChange
            Style.Font.Charset = HANGEUL_CHARSET
            Style.Font.Color = 3487168
            Style.Font.Height = -16
            Style.Font.Name = 'Noto Sans CJK KR Regular'
            Style.Font.Style = [fsBold]
            Style.IsFontAssigned = True
            TabOrder = 1
            Value = 60
            Width = 50
          end
        end
        object trbAssignMin: TcxTrackBar
          AlignWithMargins = True
          Left = 122
          Top = 76
          Position = 60
          Properties.AutoSize = False
          Properties.Frequency = 30
          Properties.Max = 300
          Properties.Orientation = tboVertical
          Properties.ReverseDirection = True
          Properties.SelectionColor = 3158064
          Properties.ShowChangeButtons = True
          Properties.ShowPositionHint = True
          Properties.ThumbColor = 6052956
          Properties.ThumbHeight = 20
          Properties.ThumbWidth = 10
          Properties.TickSize = 5
          Properties.TickType = tbttTicksAndNumbers
          Properties.TrackSize = 10
          Properties.OnChange = trbAssignMinPropertiesChange
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 2
          Transparent = True
          Height = 189
          Width = 70
        end
      end
      object panReservedInfoContainer: TPanel
        AlignWithMargins = True
        Left = 420
        Top = 5
        Width = 941
        Height = 420
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alClient
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 2
        object Bevel1: TBevel
          Left = 910
          Top = 32
          Width = 1
          Height = 330
          Align = alRight
          Shape = bsRightLine
          Style = bsRaised
          ExplicitLeft = 861
        end
        object G1: TcxGrid
          Left = 0
          Top = 32
          Width = 910
          Height = 330
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = cxcbsNone
          Font.Charset = HANGEUL_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Noto Sans CJK KR Regular'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          LookAndFeel.ScrollbarMode = sbmTouch
          RootLevelOptions.DetailFrameColor = clWhite
          object V1: TcxGridDBBandedTableView
            PopupMenu = pmnReserveList
            Navigator.Buttons.CustomButtons = <>
            ScrollbarAnnotations.CustomAnnotations = <>
            OnCustomDrawCell = V1CustomDrawCell
            DataController.DataSource = ClientDM.DSTeeBoxReserved2
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsCustomize.ColumnFiltering = False
            OptionsCustomize.ColumnGrouping = False
            OptionsCustomize.ColumnHidingOnGrouping = False
            OptionsCustomize.ColumnMoving = False
            OptionsCustomize.ColumnVertSizing = False
            OptionsData.CancelOnExit = False
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Editing = False
            OptionsData.Inserting = False
            OptionsSelection.CellSelect = False
            OptionsView.FocusRect = False
            OptionsView.NoDataToDisplayInfoText = '<'#51312#54924#54624' '#45936#51060#53552#44032' '#50630#49845#45768#45796'.>'
            OptionsView.ColumnAutoWidth = True
            OptionsView.GridLines = glHorizontal
            OptionsView.GroupByBox = False
            OptionsView.BandHeaders = False
            Styles.Header = ClientDM.StandStyleHeader
            Styles.Inactive = ClientDM.StandStyleSelection
            Styles.Selection = ClientDM.StandStyleSelection
            Styles.BandHeader = ClientDM.StandStyleBandHeader
            OnCustomDrawColumnHeader = OnGridCustomDrawColumnHeader
            Bands = <
              item
                Caption = #53440#49437' '#50696#50557' '#54788#54889
              end>
            object V1calc_play_yn: TcxGridDBBandedColumn
              Caption = #49345#53468
              DataBinding.FieldName = 'calc_play_yn'
              PropertiesClassName = 'TcxLabelProperties'
              Properties.Alignment.Horz = taCenter
              Properties.Alignment.Vert = taVCenter
              HeaderAlignmentHorz = taCenter
              Width = 80
              Position.BandIndex = 0
              Position.ColIndex = 1
              Position.RowIndex = 0
            end
            object V1TeeBoxmember_nm: TcxGridDBBandedColumn
              Caption = #44256#44061#47749
              DataBinding.FieldName = 'member_nm'
              PropertiesClassName = 'TcxLabelProperties'
              Properties.Alignment.Vert = taVCenter
              HeaderAlignmentHorz = taCenter
              Width = 150
              Position.BandIndex = 0
              Position.ColIndex = 2
              Position.RowIndex = 0
            end
            object V1reserve_root_div: TcxGridDBBandedColumn
              Caption = #50696#50557#50948#52824
              DataBinding.FieldName = 'calc_reserve_root_div'
              PropertiesClassName = 'TcxLabelProperties'
              Properties.Alignment.Horz = taCenter
              Properties.Alignment.Vert = taVCenter
              HeaderAlignmentHorz = taCenter
              Width = 120
              Position.BandIndex = 0
              Position.ColIndex = 3
              Position.RowIndex = 0
            end
            object V1calc_reserve_div: TcxGridDBBandedColumn
              Caption = #50696#50557#44396#48516
              DataBinding.FieldName = 'calc_reserve_div'
              PropertiesClassName = 'TcxLabelProperties'
              Properties.Alignment.Horz = taCenter
              Properties.Alignment.Vert = taVCenter
              HeaderAlignmentHorz = taCenter
              Width = 120
              Position.BandIndex = 0
              Position.ColIndex = 4
              Position.RowIndex = 0
            end
            object V1product_nm: TcxGridDBBandedColumn
              Caption = #53440#49437#49345#54408#47749
              DataBinding.FieldName = 'product_nm'
              PropertiesClassName = 'TcxLabelProperties'
              HeaderAlignmentHorz = taCenter
              Width = 150
              Position.BandIndex = 0
              Position.ColIndex = 5
              Position.RowIndex = 0
            end
            object V1floor_cd: TcxGridDBBandedColumn
              Caption = #52789
              DataBinding.FieldName = 'floor_cd'
              PropertiesClassName = 'TcxLabelProperties'
              Properties.Alignment.Horz = taCenter
              Properties.Alignment.Vert = taVCenter
              HeaderAlignmentHorz = taCenter
              Width = 70
              Position.BandIndex = 0
              Position.ColIndex = 6
              Position.RowIndex = 0
            end
            object V1teebox_nm: TcxGridDBBandedColumn
              Caption = #53440#49437
              DataBinding.FieldName = 'teebox_nm'
              PropertiesClassName = 'TcxLabelProperties'
              Properties.Alignment.Horz = taCenter
              Properties.Alignment.Vert = taVCenter
              HeaderAlignmentHorz = taCenter
              Width = 70
              Position.BandIndex = 0
              Position.ColIndex = 7
              Position.RowIndex = 0
            end
            object V1calc_reserve_time: TcxGridDBBandedColumn
              Caption = #50696#50557
              DataBinding.FieldName = 'calc_reserve_time'
              PropertiesClassName = 'TcxLabelProperties'
              Properties.Alignment.Horz = taCenter
              Properties.Alignment.Vert = taVCenter
              HeaderAlignmentHorz = taCenter
              Width = 70
              Position.BandIndex = 0
              Position.ColIndex = 8
              Position.RowIndex = 0
            end
            object V1start_time: TcxGridDBBandedColumn
              Caption = #49884#51089
              DataBinding.FieldName = 'calc_start_time'
              PropertiesClassName = 'TcxLabelProperties'
              Properties.Alignment.Horz = taCenter
              Properties.Alignment.Vert = taVCenter
              HeaderAlignmentHorz = taCenter
              Width = 70
              Position.BandIndex = 0
              Position.ColIndex = 9
              Position.RowIndex = 0
            end
            object V1end_time: TcxGridDBBandedColumn
              Caption = #51333#47308
              DataBinding.FieldName = 'calc_end_time'
              PropertiesClassName = 'TcxLabelProperties'
              Properties.Alignment.Horz = taCenter
              Properties.Alignment.Vert = taVCenter
              HeaderAlignmentHorz = taCenter
              Width = 70
              Position.BandIndex = 0
              Position.ColIndex = 10
              Position.RowIndex = 0
            end
            object V1prepare_min: TcxGridDBBandedColumn
              Caption = #51456#48708
              DataBinding.FieldName = 'prepare_min'
              PropertiesClassName = 'TcxLabelProperties'
              Properties.Alignment.Horz = taCenter
              Properties.Alignment.Vert = taVCenter
              HeaderAlignmentHorz = taCenter
              Width = 70
              Position.BandIndex = 0
              Position.ColIndex = 11
              Position.RowIndex = 0
            end
            object V1assign_min: TcxGridDBBandedColumn
              Caption = #48176#51221
              DataBinding.FieldName = 'assign_min'
              PropertiesClassName = 'TcxLabelProperties'
              Properties.Alignment.Horz = taCenter
              Properties.Alignment.Vert = taVCenter
              HeaderAlignmentHorz = taCenter
              Width = 70
              Position.BandIndex = 0
              Position.ColIndex = 12
              Position.RowIndex = 0
            end
            object V1calc_remain_min: TcxGridDBBandedColumn
              Caption = #51092#50668
              DataBinding.FieldName = 'calc_remain_min'
              PropertiesClassName = 'TcxLabelProperties'
              Properties.Alignment.Horz = taCenter
              Properties.Alignment.Vert = taVCenter
              HeaderAlignmentHorz = taCenter
              Position.BandIndex = 0
              Position.ColIndex = 13
              Position.RowIndex = 0
            end
            object V1teebox_no: TcxGridDBBandedColumn
              Caption = #53440#49437#48264#54840
              DataBinding.FieldName = 'teebox_no'
              MinWidth = 0
              Width = 0
              Position.BandIndex = 0
              Position.ColIndex = 0
              Position.RowIndex = 0
            end
            object V1play_yn: TcxGridDBBandedColumn
              DataBinding.FieldName = 'play_yn'
              MinWidth = 0
              Width = 0
              Position.BandIndex = 0
              Position.ColIndex = 14
              Position.RowIndex = 0
            end
            object V1receipt_no: TcxGridDBBandedColumn
              Caption = #50689#49688#51613#48264#54840
              DataBinding.FieldName = 'receipt_no'
              MinWidth = 0
              Width = 0
              Position.BandIndex = 0
              Position.ColIndex = 15
              Position.RowIndex = 0
            end
          end
          object L1: TcxGridLevel
            GridView = V1
          end
        end
        object panReservedTitle: TPanel
          Left = 0
          Top = 0
          Width = 941
          Height = 32
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 1
          Margins.Bottom = 0
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = ' '#8801#50696#50557' '#54788#54889' ('#51204#52404' '#48372#44592')'
          Color = 3158064
          Font.Charset = HANGEUL_CHARSET
          Font.Color = clWhite
          Font.Height = -16
          Font.Name = 'Noto Sans CJK KR Regular'
          Font.Style = []
          ParentBackground = False
          ParentFont = False
          TabOrder = 1
          object btnTeeBoxFilterClear: TcxButton
            AlignWithMargins = True
            Left = 859
            Top = 2
            Width = 80
            Height = 28
            Margins.Left = 0
            Margins.Top = 2
            Margins.Right = 2
            Margins.Bottom = 2
            Align = alRight
            Caption = #51204#52404' '#48372#44592
            Enabled = False
            LookAndFeel.Kind = lfUltraFlat
            LookAndFeel.NativeStyle = False
            TabOrder = 0
            Font.Charset = HANGEUL_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Noto Sans CJK KR Regular'
            Font.Style = []
            ParentFont = False
            OnClick = btnTeeBoxFilterClearClick
          end
          object btnSaleTeeBoxHoldCancel: TcxButton
            AlignWithMargins = True
            Left = 757
            Top = 2
            Width = 100
            Height = 28
            Margins.Left = 0
            Margins.Top = 2
            Margins.Right = 2
            Margins.Bottom = 2
            Align = alRight
            Caption = #51076#49884#50696#50557' '#52712#49548
            LookAndFeel.Kind = lfUltraFlat
            LookAndFeel.NativeStyle = False
            TabOrder = 2
            Font.Charset = HANGEUL_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Noto Sans CJK KR Regular'
            Font.Style = []
            ParentFont = False
            OnClick = btnSaleTeeBoxHoldCancelClick
          end
          object btnTeeBoxImmediateStart: TcxButton
            AlignWithMargins = True
            Left = 675
            Top = 2
            Width = 80
            Height = 28
            Margins.Left = 0
            Margins.Top = 2
            Margins.Right = 2
            Margins.Bottom = 2
            Align = alRight
            Caption = #51593#49884' '#48176#51221
            Enabled = False
            LookAndFeel.Kind = lfUltraFlat
            LookAndFeel.NativeStyle = False
            TabOrder = 1
            Font.Charset = HANGEUL_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Noto Sans CJK KR Regular'
            Font.Style = []
            ParentFont = False
            OnClick = btnTeeBoxImmediateStartClick
          end
        end
        object Panel5: TPanel
          Left = 911
          Top = 32
          Width = 30
          Height = 330
          Align = alRight
          BevelOuter = bvNone
          Color = clWhite
          Font.Charset = HANGEUL_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = #45208#45588#44256#46357
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 2
          object btnV1Up: TcxButton
            Left = 0
            Top = 82
            Width = 30
            Height = 82
            Align = alTop
            LookAndFeel.Kind = lfFlat
            LookAndFeel.NativeStyle = False
            OptionsImage.ImageIndex = 0
            OptionsImage.Images = ClientDM.imlGridArrow
            SpeedButtonOptions.CanBeFocused = False
            SpeedButtonOptions.Transparent = True
            TabOrder = 0
            Font.Charset = HANGEUL_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Noto Sans CJK KR Regular'
            Font.Style = []
            ParentFont = False
            OnClick = btnV1UpClick
          end
          object btnV1Down: TcxButton
            Left = 0
            Top = 164
            Width = 30
            Height = 82
            Align = alTop
            LookAndFeel.Kind = lfFlat
            LookAndFeel.NativeStyle = False
            OptionsImage.ImageIndex = 1
            OptionsImage.Images = ClientDM.imlGridArrow
            SpeedButtonOptions.CanBeFocused = False
            SpeedButtonOptions.Transparent = True
            TabOrder = 1
            Font.Charset = HANGEUL_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Noto Sans CJK KR Regular'
            Font.Style = []
            ParentFont = False
            OnClick = btnV1DownClick
          end
          object btnV1PageUp: TcxButton
            Left = 0
            Top = 0
            Width = 30
            Height = 82
            Align = alTop
            LookAndFeel.Kind = lfFlat
            LookAndFeel.NativeStyle = False
            OptionsImage.ImageIndex = 2
            OptionsImage.Images = ClientDM.imlGridArrow
            SpeedButtonOptions.CanBeFocused = False
            SpeedButtonOptions.Transparent = True
            TabOrder = 2
            Font.Charset = HANGEUL_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Noto Sans CJK KR Regular'
            Font.Style = []
            ParentFont = False
            OnClick = btnV1PageUpClick
          end
          object btnV1PageDown: TcxButton
            Left = 0
            Top = 246
            Width = 30
            Height = 84
            Align = alClient
            LookAndFeel.Kind = lfFlat
            LookAndFeel.NativeStyle = False
            OptionsImage.ImageIndex = 3
            OptionsImage.Images = ClientDM.imlGridArrow
            SpeedButtonOptions.CanBeFocused = False
            SpeedButtonOptions.Transparent = True
            TabOrder = 3
            Font.Charset = HANGEUL_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Noto Sans CJK KR Regular'
            Font.Style = []
            ParentFont = False
            OnClick = btnV1PageDownClick
          end
        end
        object panTeeBoxQuickView: TPanel
          Left = 0
          Top = 362
          Width = 941
          Height = 58
          Align = alBottom
          BevelOuter = bvNone
          Color = 33023
          ParentBackground = False
          TabOrder = 3
          object lblTeeBoxQuickTitle: TLabel
            AlignWithMargins = True
            Left = 0
            Top = 2
            Width = 39
            Height = 53
            Margins.Left = 0
            Margins.Top = 2
            Margins.Right = 0
            Align = alLeft
            Alignment = taCenter
            AutoSize = False
            Caption = #48736#47480#13#53440#49437
            Color = 3158064
            Font.Charset = HANGEUL_CHARSET
            Font.Color = clWhite
            Font.Height = -16
            Font.Name = 'Noto Sans CJK KR Regular'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            Transparent = False
            Layout = tlCenter
            ExplicitTop = 0
            ExplicitHeight = 58
          end
          object TemplateTeeBoxQuickPanel: TPanel
            AlignWithMargins = True
            Left = 42
            Top = 2
            Width = 64
            Height = 56
            Margins.Top = 2
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alLeft
            BevelOuter = bvNone
            Color = clWhite
            ParentBackground = False
            TabOrder = 0
            Visible = False
            object TemplateTeeBoxQuickTitleLabel: TLabel
              Left = 0
              Top = 0
              Width = 64
              Height = 22
              Align = alTop
              Alignment = taCenter
              AutoSize = False
              Caption = '1F-23'
              Color = 5525206
              Font.Charset = HANGEUL_CHARSET
              Font.Color = clWhite
              Font.Height = -15
              Font.Name = 'Noto Sans CJK KR Regular'
              Font.Style = []
              ParentColor = False
              ParentFont = False
              Transparent = False
              ExplicitWidth = 42
            end
            object TemplateTeeBoxQuickRemainLabel: TLabel
              Left = 0
              Top = 22
              Width = 64
              Height = 34
              Align = alClient
              Alignment = taCenter
              AutoSize = False
              Caption = '120 '#48516
              Layout = tlCenter
              ExplicitWidth = 41
              ExplicitHeight = 22
            end
          end
        end
      end
      object panTeeBoxSelectedContainer: TPanel
        AlignWithMargins = True
        Left = 5
        Top = 5
        Width = 205
        Height = 420
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alLeft
        BevelOuter = bvNone
        Color = 33023
        ParentBackground = False
        TabOrder = 0
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 205
          Height = 32
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 1
          Margins.Bottom = 0
          Align = alTop
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = ' '#8801#49440#53469#54620' '#53440#49437
          Color = 3158064
          Font.Charset = HANGEUL_CHARSET
          Font.Color = clWhite
          Font.Height = -16
          Font.Name = 'Noto Sans CJK KR Regular'
          Font.Style = []
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object panTeeBoxSelectedGrid: TPanel
          Left = 0
          Top = 32
          Width = 205
          Height = 332
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object Bevel2: TBevel
            Left = 174
            Top = 0
            Width = 1
            Height = 332
            Align = alRight
            Shape = bsRightLine
            Style = bsRaised
            ExplicitLeft = 861
            ExplicitTop = 32
            ExplicitHeight = 330
          end
          object G2: TcxGrid
            Left = 0
            Top = 0
            Width = 174
            Height = 332
            Align = alClient
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = cxcbsNone
            Font.Charset = HANGEUL_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Noto Sans CJK KR Regular'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            LookAndFeel.Kind = lfUltraFlat
            LookAndFeel.NativeStyle = True
            LookAndFeel.ScrollbarMode = sbmTouch
            RootLevelOptions.DetailFrameColor = clWhite
            object V2: TcxGridDBBandedTableView
              Navigator.Buttons.CustomButtons = <>
              ScrollbarAnnotations.CustomAnnotations = <>
              DataController.DataSource = ClientDM.DSTeeBoxSelected
              DataController.Summary.DefaultGroupSummaryItems = <>
              DataController.Summary.FooterSummaryItems = <
                item
                  Format = '0'
                  Kind = skCount
                  FieldName = 'RecId'
                  Column = V2teebox_nm
                end
                item
                  Format = '0'
                  Kind = skSum
                  FieldName = 'vip_cnt'
                  Column = V2vip_yn
                end>
              DataController.Summary.SummaryGroups = <>
              OptionsCustomize.ColumnFiltering = False
              OptionsCustomize.ColumnGrouping = False
              OptionsCustomize.ColumnHidingOnGrouping = False
              OptionsCustomize.ColumnMoving = False
              OptionsCustomize.ColumnVertSizing = False
              OptionsData.CancelOnExit = False
              OptionsData.Deleting = False
              OptionsData.DeletingConfirmation = False
              OptionsData.Editing = False
              OptionsData.Inserting = False
              OptionsSelection.CellSelect = False
              OptionsView.FocusRect = False
              OptionsView.NoDataToDisplayInfoText = ' '
              OptionsView.ColumnAutoWidth = True
              OptionsView.Footer = True
              OptionsView.GridLines = glHorizontal
              OptionsView.GroupByBox = False
              OptionsView.BandHeaders = False
              Styles.Header = ClientDM.StandStyleHeader
              Styles.Inactive = ClientDM.StandStyleSelection
              Styles.Selection = ClientDM.StandStyleSelection
              Styles.BandHeader = ClientDM.StandStyleBandHeader
              OnCustomDrawColumnHeader = OnGridCustomDrawColumnHeader
              Bands = <
                item
                  Caption = #49440#53469#54620' '#53440#49437' '#47785#47197
                end>
              object V2teebox_nm: TcxGridDBBandedColumn
                Caption = #53440#49437
                DataBinding.FieldName = 'teebox_nm'
                PropertiesClassName = 'TcxLabelProperties'
                Properties.Alignment.Horz = taCenter
                Properties.Alignment.Vert = taVCenter
                FooterAlignmentHorz = taCenter
                HeaderAlignmentHorz = taCenter
                Position.BandIndex = 0
                Position.ColIndex = 0
                Position.RowIndex = 0
              end
              object V2vip_yn: TcxGridDBBandedColumn
                Caption = 'VIP'#49437
                DataBinding.FieldName = 'vip_yn'
                DataBinding.IsNullValueType = True
                PropertiesClassName = 'TcxLabelProperties'
                Properties.Alignment.Horz = taCenter
                Properties.Alignment.Vert = taVCenter
                FooterAlignmentHorz = taCenter
                HeaderAlignmentHorz = taCenter
                Width = 80
                Position.BandIndex = 0
                Position.ColIndex = 1
                Position.RowIndex = 0
              end
            end
            object L2: TcxGridLevel
              GridView = V2
            end
          end
          object Panel7: TPanel
            Left = 175
            Top = 0
            Width = 30
            Height = 332
            Align = alRight
            BevelOuter = bvNone
            Color = clWhite
            Font.Charset = HANGEUL_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = #45208#45588#44256#46357
            Font.Style = [fsBold]
            ParentBackground = False
            ParentFont = False
            TabOrder = 1
            object btnV2Up: TcxButton
              Left = 0
              Top = 0
              Width = 30
              Height = 166
              Align = alTop
              LookAndFeel.Kind = lfFlat
              LookAndFeel.NativeStyle = False
              OptionsImage.ImageIndex = 0
              OptionsImage.Images = ClientDM.imlGridArrow
              SpeedButtonOptions.CanBeFocused = False
              SpeedButtonOptions.Transparent = True
              TabOrder = 0
              Font.Charset = HANGEUL_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Noto Sans CJK KR Regular'
              Font.Style = []
              ParentFont = False
              OnClick = btnV2UpClick
            end
            object btnV2Down: TcxButton
              Left = 0
              Top = 166
              Width = 30
              Height = 166
              Align = alClient
              LookAndFeel.Kind = lfFlat
              LookAndFeel.NativeStyle = False
              OptionsImage.ImageIndex = 1
              OptionsImage.Images = ClientDM.imlGridArrow
              SpeedButtonOptions.CanBeFocused = False
              SpeedButtonOptions.Transparent = True
              TabOrder = 1
              Font.Charset = HANGEUL_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Noto Sans CJK KR Regular'
              Font.Style = []
              ParentFont = False
              OnClick = btnV2DownClick
            end
          end
        end
        object Panel8: TPanel
          Left = 0
          Top = 364
          Width = 205
          Height = 56
          Align = alBottom
          BevelOuter = bvNone
          Color = 33023
          ParentBackground = False
          TabOrder = 2
          object btnTeeBoxDeleteHold: TcyAdvSpeedButton
            AlignWithMargins = True
            Left = 0
            Top = 6
            Width = 100
            Height = 50
            Margins.Left = 0
            Margins.Top = 6
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alLeft
            AllowAllUp = True
            Caption = #49440#53469' '#49325#51228
            Flat = True
            Font.Charset = HANGEUL_CHARSET
            Font.Color = 6856206
            Font.Height = -15
            Font.Name = 'Noto Sans CJK KR Regular'
            Font.Style = []
            ParentFont = False
            Transparent = False
            OnClick = btnTeeBoxDeleteHoldClick
            BordersNormal = <>
            BordersHot = <>
            BordersDown = <>
            BordersDisabled = <>
            ButtonNormal.Degrade.FromColor = clWhite
            ButtonNormal.Degrade.SpeedPercent = 90
            ButtonNormal.Degrade.ToColor = clWhite
            ButtonNormal.Font.Charset = HANGEUL_CHARSET
            ButtonNormal.Font.Color = 6856206
            ButtonNormal.Font.Height = -15
            ButtonNormal.Font.Name = 'Noto Sans CJK KR Regular'
            ButtonNormal.Font.Style = []
            ButtonNormal.UseDefaultFont = False
            ButtonNormal.Wallpaper.Transparent = False
            ButtonHot.Degrade.BalanceMode = bmReverseFromColor
            ButtonHot.Degrade.FromColor = clWhite
            ButtonHot.Degrade.SpeedPercent = 100
            ButtonHot.Degrade.ToColor = clWhite
            ButtonHot.Font.Charset = HANGEUL_CHARSET
            ButtonHot.Font.Color = 6856206
            ButtonHot.Font.Height = -15
            ButtonHot.Font.Name = 'Noto Sans CJK KR Regular'
            ButtonHot.Font.Style = []
            ButtonHot.UseDefaultFont = False
            ButtonHot.Wallpaper.Transparent = False
            ButtonDown.Degrade.FromColor = 6856206
            ButtonDown.Degrade.SpeedPercent = 100
            ButtonDown.Degrade.ToColor = 6856206
            ButtonDown.Font.Charset = HANGEUL_CHARSET
            ButtonDown.Font.Color = clWhite
            ButtonDown.Font.Height = -15
            ButtonDown.Font.Name = 'Noto Sans CJK KR Regular'
            ButtonDown.Font.Style = []
            ButtonDown.UseDefaultFont = False
            ButtonDown.Wallpaper.Transparent = False
            ButtonDisabled.Degrade.FromColor = clSilver
            ButtonDisabled.Degrade.SpeedPercent = 90
            ButtonDisabled.Degrade.ToColor = clSilver
            ButtonDisabled.Font.Charset = HANGEUL_CHARSET
            ButtonDisabled.Font.Color = 15790320
            ButtonDisabled.Font.Height = -15
            ButtonDisabled.Font.Name = 'Noto Sans CJK KR Regular'
            ButtonDisabled.Font.Style = []
            ButtonDisabled.UseDefaultFont = False
            ButtonDisabled.Wallpaper.Transparent = False
            Wallpaper.Transparent = False
          end
          object btnTeeBoxClearHold: TcyAdvSpeedButton
            AlignWithMargins = True
            Left = 105
            Top = 6
            Width = 100
            Height = 50
            Margins.Left = 5
            Margins.Top = 6
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alClient
            AllowAllUp = True
            Caption = #51204#52404' '#49325#51228#13#10'(ESC)'
            Flat = True
            Font.Charset = HANGEUL_CHARSET
            Font.Color = 6856206
            Font.Height = -15
            Font.Name = 'Noto Sans CJK KR Regular'
            Font.Style = []
            ParentFont = False
            Transparent = False
            OnClick = btnTeeBoxClearHoldClick
            BordersNormal = <>
            BordersHot = <>
            BordersDown = <>
            BordersDisabled = <>
            ButtonNormal.Degrade.FromColor = clWhite
            ButtonNormal.Degrade.SpeedPercent = 90
            ButtonNormal.Degrade.ToColor = clWhite
            ButtonNormal.Font.Charset = HANGEUL_CHARSET
            ButtonNormal.Font.Color = 6856206
            ButtonNormal.Font.Height = -15
            ButtonNormal.Font.Name = 'Noto Sans CJK KR Regular'
            ButtonNormal.Font.Style = []
            ButtonNormal.UseDefaultFont = False
            ButtonNormal.Wallpaper.Transparent = False
            ButtonHot.Degrade.BalanceMode = bmReverseFromColor
            ButtonHot.Degrade.FromColor = clWhite
            ButtonHot.Degrade.SpeedPercent = 100
            ButtonHot.Degrade.ToColor = clWhite
            ButtonHot.Font.Charset = HANGEUL_CHARSET
            ButtonHot.Font.Color = 6856206
            ButtonHot.Font.Height = -15
            ButtonHot.Font.Name = 'Noto Sans CJK KR Regular'
            ButtonHot.Font.Style = []
            ButtonHot.UseDefaultFont = False
            ButtonHot.Wallpaper.Transparent = False
            ButtonDown.Degrade.FromColor = 6856206
            ButtonDown.Degrade.SpeedPercent = 100
            ButtonDown.Degrade.ToColor = 6856206
            ButtonDown.Font.Charset = HANGEUL_CHARSET
            ButtonDown.Font.Color = clWhite
            ButtonDown.Font.Height = -15
            ButtonDown.Font.Name = 'Noto Sans CJK KR Regular'
            ButtonDown.Font.Style = []
            ButtonDown.UseDefaultFont = False
            ButtonDown.Wallpaper.Transparent = False
            ButtonDisabled.Degrade.FromColor = clSilver
            ButtonDisabled.Degrade.SpeedPercent = 90
            ButtonDisabled.Degrade.ToColor = clSilver
            ButtonDisabled.Font.Charset = HANGEUL_CHARSET
            ButtonDisabled.Font.Color = 15790320
            ButtonDisabled.Font.Height = -15
            ButtonDisabled.Font.Name = 'Noto Sans CJK KR Regular'
            ButtonDisabled.Font.Style = []
            ButtonDisabled.UseDefaultFont = False
            ButtonDisabled.Wallpaper.Transparent = False
            Wallpaper.Transparent = False
            WordWrap = True
            ExplicitLeft = 100
            ExplicitTop = 0
            ExplicitHeight = 56
          end
        end
      end
    end
    object panFooter: TPanel
      AlignWithMargins = True
      Left = 0
      Top = 640
      Width = 1366
      Height = 60
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Align = alBottom
      BevelOuter = bvNone
      Color = 33023
      ParentBackground = False
      TabOrder = 1
      object btnTeeBoxChangeReserved: TcyAdvSpeedButton
        Tag = 3001
        AlignWithMargins = True
        Left = 590
        Top = 5
        Width = 189
        Height = 52
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 5
        Align = alRight
        AllowAllUp = True
        Caption = #50696#50557#49884#44036' '#48320#44221#13#10'(F10)'
        Flat = True
        Font.Charset = HANGEUL_CHARSET
        Font.Color = 3487168
        Font.Height = -15
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        Transparent = False
        OnClick = btnTeeBoxChangeReservedClick
        BordersNormal = <>
        BordersHot = <>
        BordersDown = <>
        BordersDisabled = <>
        ButtonNormal.Degrade.FromColor = clWhite
        ButtonNormal.Degrade.SpeedPercent = 90
        ButtonNormal.Degrade.ToColor = clWhite
        ButtonNormal.Font.Charset = HANGEUL_CHARSET
        ButtonNormal.Font.Color = 3487168
        ButtonNormal.Font.Height = -15
        ButtonNormal.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonNormal.Font.Style = []
        ButtonNormal.Wallpaper.Transparent = False
        ButtonHot.Degrade.BalanceMode = bmReverseFromColor
        ButtonHot.Degrade.FromColor = clWhite
        ButtonHot.Degrade.SpeedPercent = 100
        ButtonHot.Degrade.ToColor = clWhite
        ButtonHot.Font.Charset = HANGEUL_CHARSET
        ButtonHot.Font.Color = 3487168
        ButtonHot.Font.Height = -15
        ButtonHot.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonHot.Font.Style = []
        ButtonHot.UseDefaultFont = False
        ButtonHot.Wallpaper.Transparent = False
        ButtonDown.Degrade.FromColor = 2302834
        ButtonDown.Degrade.SpeedPercent = 100
        ButtonDown.Degrade.ToColor = 2302834
        ButtonDown.Font.Charset = HANGEUL_CHARSET
        ButtonDown.Font.Color = clWhite
        ButtonDown.Font.Height = -15
        ButtonDown.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDown.Font.Style = []
        ButtonDown.UseDefaultFont = False
        ButtonDown.Wallpaper.Transparent = False
        ButtonDisabled.Degrade.FromColor = clSilver
        ButtonDisabled.Degrade.SpeedPercent = 90
        ButtonDisabled.Degrade.ToColor = clSilver
        ButtonDisabled.Font.Charset = HANGEUL_CHARSET
        ButtonDisabled.Font.Color = 14869218
        ButtonDisabled.Font.Height = -15
        ButtonDisabled.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDisabled.Font.Style = []
        ButtonDisabled.UseDefaultFont = False
        ButtonDisabled.Wallpaper.Transparent = False
        Wallpaper.Transparent = False
        WordWrap = True
        ExplicitLeft = 686
      end
      object btnTeeBoxPause: TcyAdvSpeedButton
        Tag = 3001
        AlignWithMargins = True
        Left = 784
        Top = 5
        Width = 189
        Height = 52
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 5
        Align = alRight
        AllowAllUp = True
        Caption = #51216#44160'/'#51116#44032#46041#13#10'(F11)'
        Flat = True
        Font.Charset = HANGEUL_CHARSET
        Font.Color = 3487168
        Font.Height = -15
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        Transparent = False
        OnClick = btnTeeBoxPauseClick
        BordersNormal = <>
        BordersHot = <>
        BordersDown = <>
        BordersDisabled = <>
        ButtonNormal.Degrade.FromColor = clWhite
        ButtonNormal.Degrade.SpeedPercent = 90
        ButtonNormal.Degrade.ToColor = clWhite
        ButtonNormal.Font.Charset = HANGEUL_CHARSET
        ButtonNormal.Font.Color = 3487168
        ButtonNormal.Font.Height = -15
        ButtonNormal.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonNormal.Font.Style = []
        ButtonNormal.Wallpaper.Transparent = False
        ButtonHot.Degrade.BalanceMode = bmReverseFromColor
        ButtonHot.Degrade.FromColor = clWhite
        ButtonHot.Degrade.SpeedPercent = 100
        ButtonHot.Degrade.ToColor = clWhite
        ButtonHot.Font.Charset = HANGEUL_CHARSET
        ButtonHot.Font.Color = 3487168
        ButtonHot.Font.Height = -15
        ButtonHot.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonHot.Font.Style = []
        ButtonHot.UseDefaultFont = False
        ButtonHot.Wallpaper.Transparent = False
        ButtonDown.Degrade.FromColor = 2302834
        ButtonDown.Degrade.SpeedPercent = 100
        ButtonDown.Degrade.ToColor = 2302834
        ButtonDown.Font.Charset = HANGEUL_CHARSET
        ButtonDown.Font.Color = clWhite
        ButtonDown.Font.Height = -15
        ButtonDown.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDown.Font.Style = []
        ButtonDown.UseDefaultFont = False
        ButtonDown.Wallpaper.Transparent = False
        ButtonDisabled.Degrade.FromColor = clSilver
        ButtonDisabled.Degrade.SpeedPercent = 90
        ButtonDisabled.Degrade.ToColor = clSilver
        ButtonDisabled.Font.Charset = HANGEUL_CHARSET
        ButtonDisabled.Font.Color = 14869218
        ButtonDisabled.Font.Height = -15
        ButtonDisabled.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDisabled.Font.Style = []
        ButtonDisabled.UseDefaultFont = False
        ButtonDisabled.Wallpaper.Transparent = False
        Wallpaper.Transparent = False
        WordWrap = True
        ExplicitLeft = 856
      end
      object btnTeeBoxStoppedAll: TcyAdvSpeedButton
        Tag = 3001
        AlignWithMargins = True
        Left = 1172
        Top = 5
        Width = 189
        Height = 52
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 5
        Align = alRight
        AllowAllUp = True
        Caption = #48380' '#54924#49688
        Flat = True
        Font.Charset = HANGEUL_CHARSET
        Font.Color = 3487168
        Font.Height = -15
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        Transparent = False
        OnClick = btnTeeBoxStoppedAllClick
        BordersNormal = <>
        BordersHot = <>
        BordersDown = <>
        BordersDisabled = <>
        ButtonNormal.Degrade.FromColor = clWhite
        ButtonNormal.Degrade.SpeedPercent = 90
        ButtonNormal.Degrade.ToColor = clWhite
        ButtonNormal.Font.Charset = HANGEUL_CHARSET
        ButtonNormal.Font.Color = 3487168
        ButtonNormal.Font.Height = -15
        ButtonNormal.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonNormal.Font.Style = []
        ButtonNormal.Wallpaper.Transparent = False
        ButtonHot.Degrade.BalanceMode = bmReverseFromColor
        ButtonHot.Degrade.FromColor = clWhite
        ButtonHot.Degrade.SpeedPercent = 100
        ButtonHot.Degrade.ToColor = clWhite
        ButtonHot.Font.Charset = HANGEUL_CHARSET
        ButtonHot.Font.Color = 3487168
        ButtonHot.Font.Height = -15
        ButtonHot.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonHot.Font.Style = []
        ButtonHot.UseDefaultFont = False
        ButtonHot.Wallpaper.Transparent = False
        ButtonDown.Degrade.FromColor = 2302834
        ButtonDown.Degrade.SpeedPercent = 100
        ButtonDown.Degrade.ToColor = 2302834
        ButtonDown.Font.Charset = HANGEUL_CHARSET
        ButtonDown.Font.Color = clWhite
        ButtonDown.Font.Height = -15
        ButtonDown.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDown.Font.Style = []
        ButtonDown.UseDefaultFont = False
        ButtonDown.Wallpaper.Transparent = False
        ButtonDisabled.Degrade.FromColor = clSilver
        ButtonDisabled.Degrade.SpeedPercent = 90
        ButtonDisabled.Degrade.ToColor = clSilver
        ButtonDisabled.Font.Charset = HANGEUL_CHARSET
        ButtonDisabled.Font.Color = 14869218
        ButtonDisabled.Font.Height = -15
        ButtonDisabled.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDisabled.Font.Style = []
        ButtonDisabled.UseDefaultFont = False
        ButtonDisabled.Wallpaper.Transparent = False
        Wallpaper.Transparent = False
        WordWrap = True
        ExplicitLeft = 1196
      end
      object btnTeeBoxCancelReserved: TcyAdvSpeedButton
        Tag = 3001
        AlignWithMargins = True
        Left = 202
        Top = 5
        Width = 189
        Height = 52
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 5
        Align = alRight
        AllowAllUp = True
        Caption = #50696#50557' '#52712#49548#13#10'(F8)'
        Flat = True
        Font.Charset = HANGEUL_CHARSET
        Font.Color = 3487168
        Font.Height = -15
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        Transparent = False
        OnClick = btnTeeBoxCancelReservedClick
        BordersNormal = <>
        BordersHot = <>
        BordersDown = <>
        BordersDisabled = <>
        ButtonNormal.Degrade.FromColor = clWhite
        ButtonNormal.Degrade.SpeedPercent = 90
        ButtonNormal.Degrade.ToColor = clWhite
        ButtonNormal.Font.Charset = HANGEUL_CHARSET
        ButtonNormal.Font.Color = 3487168
        ButtonNormal.Font.Height = -15
        ButtonNormal.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonNormal.Font.Style = []
        ButtonNormal.Wallpaper.Transparent = False
        ButtonHot.Degrade.BalanceMode = bmReverseFromColor
        ButtonHot.Degrade.FromColor = clWhite
        ButtonHot.Degrade.SpeedPercent = 100
        ButtonHot.Degrade.ToColor = clWhite
        ButtonHot.Font.Charset = HANGEUL_CHARSET
        ButtonHot.Font.Color = 3487168
        ButtonHot.Font.Height = -15
        ButtonHot.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonHot.Font.Style = []
        ButtonHot.UseDefaultFont = False
        ButtonHot.Wallpaper.Transparent = False
        ButtonDown.Degrade.FromColor = 2302834
        ButtonDown.Degrade.SpeedPercent = 100
        ButtonDown.Degrade.ToColor = 2302834
        ButtonDown.Font.Charset = HANGEUL_CHARSET
        ButtonDown.Font.Color = clWhite
        ButtonDown.Font.Height = -15
        ButtonDown.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDown.Font.Style = []
        ButtonDown.UseDefaultFont = False
        ButtonDown.Wallpaper.Transparent = False
        ButtonDisabled.Degrade.FromColor = clSilver
        ButtonDisabled.Degrade.SpeedPercent = 90
        ButtonDisabled.Degrade.ToColor = clSilver
        ButtonDisabled.Font.Charset = HANGEUL_CHARSET
        ButtonDisabled.Font.Color = 14869218
        ButtonDisabled.Font.Height = -15
        ButtonDisabled.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDisabled.Font.Style = []
        ButtonDisabled.UseDefaultFont = False
        ButtonDisabled.Wallpaper.Transparent = False
        Wallpaper.Transparent = False
        WordWrap = True
        ExplicitLeft = 346
      end
      object btnTeeBoxMove: TcyAdvSpeedButton
        Tag = 3001
        AlignWithMargins = True
        Left = 396
        Top = 5
        Width = 189
        Height = 52
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 5
        Align = alRight
        AllowAllUp = True
        Caption = #53440#49437' '#51060#46041#13#10'(F9)'
        Flat = True
        Font.Charset = HANGEUL_CHARSET
        Font.Color = 3487168
        Font.Height = -15
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        Transparent = False
        OnClick = btnTeeBoxMoveClick
        BordersNormal = <>
        BordersHot = <>
        BordersDown = <>
        BordersDisabled = <>
        ButtonNormal.Degrade.FromColor = clWhite
        ButtonNormal.Degrade.SpeedPercent = 90
        ButtonNormal.Degrade.ToColor = clWhite
        ButtonNormal.Font.Charset = HANGEUL_CHARSET
        ButtonNormal.Font.Color = 3487168
        ButtonNormal.Font.Height = -15
        ButtonNormal.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonNormal.Font.Style = []
        ButtonNormal.Wallpaper.Transparent = False
        ButtonHot.Degrade.BalanceMode = bmReverseFromColor
        ButtonHot.Degrade.FromColor = clWhite
        ButtonHot.Degrade.SpeedPercent = 100
        ButtonHot.Degrade.ToColor = clWhite
        ButtonHot.Font.Charset = HANGEUL_CHARSET
        ButtonHot.Font.Color = 3487168
        ButtonHot.Font.Height = -15
        ButtonHot.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonHot.Font.Style = []
        ButtonHot.UseDefaultFont = False
        ButtonHot.Wallpaper.Transparent = False
        ButtonDown.Degrade.FromColor = 2302834
        ButtonDown.Degrade.SpeedPercent = 100
        ButtonDown.Degrade.ToColor = 2302834
        ButtonDown.Font.Charset = HANGEUL_CHARSET
        ButtonDown.Font.Color = clWhite
        ButtonDown.Font.Height = -15
        ButtonDown.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDown.Font.Style = []
        ButtonDown.UseDefaultFont = False
        ButtonDown.Wallpaper.Transparent = False
        ButtonDisabled.Degrade.FromColor = clSilver
        ButtonDisabled.Degrade.SpeedPercent = 90
        ButtonDisabled.Degrade.ToColor = clSilver
        ButtonDisabled.Font.Charset = HANGEUL_CHARSET
        ButtonDisabled.Font.Color = 14869218
        ButtonDisabled.Font.Height = -15
        ButtonDisabled.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDisabled.Font.Style = []
        ButtonDisabled.UseDefaultFont = False
        ButtonDisabled.Wallpaper.Transparent = False
        Wallpaper.Transparent = False
        WordWrap = True
        ExplicitLeft = 516
      end
      object btnTeeBoxReserve: TcyAdvSpeedButton
        Tag = 3001
        AlignWithMargins = True
        Left = 5
        Top = 5
        Width = 192
        Height = 52
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Align = alClient
        AllowAllUp = True
        Caption = #53440#49437' '#50696#50557#13#10'(F1)'
        Flat = True
        Font.Charset = HANGEUL_CHARSET
        Font.Color = 3487168
        Font.Height = -15
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        Transparent = False
        OnClick = btnTeeBoxReserveClick
        BordersNormal = <>
        BordersHot = <>
        BordersDown = <>
        BordersDisabled = <>
        ButtonNormal.Degrade.FromColor = clWhite
        ButtonNormal.Degrade.SpeedPercent = 90
        ButtonNormal.Degrade.ToColor = clWhite
        ButtonNormal.Font.Charset = HANGEUL_CHARSET
        ButtonNormal.Font.Color = 3487168
        ButtonNormal.Font.Height = -15
        ButtonNormal.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonNormal.Font.Style = []
        ButtonNormal.Wallpaper.Transparent = False
        ButtonHot.Degrade.BalanceMode = bmReverseFromColor
        ButtonHot.Degrade.FromColor = clWhite
        ButtonHot.Degrade.SpeedPercent = 100
        ButtonHot.Degrade.ToColor = clWhite
        ButtonHot.Font.Charset = HANGEUL_CHARSET
        ButtonHot.Font.Color = 3487168
        ButtonHot.Font.Height = -15
        ButtonHot.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonHot.Font.Style = []
        ButtonHot.UseDefaultFont = False
        ButtonHot.Wallpaper.Transparent = False
        ButtonDown.Degrade.FromColor = 2302834
        ButtonDown.Degrade.SpeedPercent = 100
        ButtonDown.Degrade.ToColor = 2302834
        ButtonDown.Font.Charset = HANGEUL_CHARSET
        ButtonDown.Font.Color = clWhite
        ButtonDown.Font.Height = -15
        ButtonDown.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDown.Font.Style = []
        ButtonDown.UseDefaultFont = False
        ButtonDown.Wallpaper.Transparent = False
        ButtonDisabled.Degrade.FromColor = clSilver
        ButtonDisabled.Degrade.SpeedPercent = 90
        ButtonDisabled.Degrade.ToColor = clSilver
        ButtonDisabled.Font.Charset = HANGEUL_CHARSET
        ButtonDisabled.Font.Color = 14869218
        ButtonDisabled.Font.Height = -15
        ButtonDisabled.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDisabled.Font.Style = []
        ButtonDisabled.UseDefaultFont = False
        ButtonDisabled.Wallpaper.Transparent = False
        Wallpaper.Transparent = False
        WordWrap = True
        ExplicitWidth = 189
      end
      object btnTeeBoxClearance: TcyAdvSpeedButton
        Tag = 3001
        AlignWithMargins = True
        Left = 978
        Top = 5
        Width = 189
        Height = 52
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 5
        Align = alRight
        AllowAllUp = True
        Caption = #53440#49437' '#51221#47532
        Flat = True
        Font.Charset = HANGEUL_CHARSET
        Font.Color = 3487168
        Font.Height = -15
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        Transparent = False
        OnClick = btnTeeBoxClearanceClick
        BordersNormal = <>
        BordersHot = <>
        BordersDown = <>
        BordersDisabled = <>
        ButtonNormal.Degrade.FromColor = clWhite
        ButtonNormal.Degrade.SpeedPercent = 90
        ButtonNormal.Degrade.ToColor = clWhite
        ButtonNormal.Font.Charset = HANGEUL_CHARSET
        ButtonNormal.Font.Color = 3487168
        ButtonNormal.Font.Height = -15
        ButtonNormal.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonNormal.Font.Style = []
        ButtonNormal.Wallpaper.Transparent = False
        ButtonHot.Degrade.BalanceMode = bmReverseFromColor
        ButtonHot.Degrade.FromColor = clWhite
        ButtonHot.Degrade.SpeedPercent = 100
        ButtonHot.Degrade.ToColor = clWhite
        ButtonHot.Font.Charset = HANGEUL_CHARSET
        ButtonHot.Font.Color = 3487168
        ButtonHot.Font.Height = -15
        ButtonHot.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonHot.Font.Style = []
        ButtonHot.UseDefaultFont = False
        ButtonHot.Wallpaper.Transparent = False
        ButtonDown.Degrade.FromColor = 2302834
        ButtonDown.Degrade.SpeedPercent = 100
        ButtonDown.Degrade.ToColor = 2302834
        ButtonDown.Font.Charset = HANGEUL_CHARSET
        ButtonDown.Font.Color = clWhite
        ButtonDown.Font.Height = -15
        ButtonDown.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDown.Font.Style = []
        ButtonDown.UseDefaultFont = False
        ButtonDown.Wallpaper.Transparent = False
        ButtonDisabled.Degrade.FromColor = clSilver
        ButtonDisabled.Degrade.SpeedPercent = 90
        ButtonDisabled.Degrade.ToColor = clSilver
        ButtonDisabled.Font.Charset = HANGEUL_CHARSET
        ButtonDisabled.Font.Color = 14869218
        ButtonDisabled.Font.Height = -15
        ButtonDisabled.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDisabled.Font.Style = []
        ButtonDisabled.UseDefaultFont = False
        ButtonDisabled.Wallpaper.Transparent = False
        Wallpaper.Transparent = False
        WordWrap = True
        ExplicitLeft = 1026
      end
    end
    object panTeeBoxFloor1: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 197
      Width = 1356
      Height = 18
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      Color = 33023
      ParentBackground = False
      TabOrder = 2
      object panFloorName1: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 24
        Height = 18
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 2
        Margins.Bottom = 0
        Align = alLeft
        BevelOuter = bvNone
        Color = 6052956
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
    end
    object panTeeBoxFloor4: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 128
      Width = 1356
      Height = 18
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      Color = 33023
      ParentBackground = False
      TabOrder = 5
      object panFloorName4: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 24
        Height = 18
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 2
        Margins.Bottom = 0
        Align = alLeft
        BevelOuter = bvNone
        Color = 6052956
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
    end
  end
  object tmrClock: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrClockTimer
    Left = 200
    Top = 128
  end
  object pmnTeeBoxView: TAdvPopupMenu
    MenuAnimation = [maTopToBottom]
    OnPopup = pmnTeeBoxViewPopup
    Version = '2.7.1.9'
    UIStyle = tsCustom
    Left = 608
    Top = 160
    object mnuTeeBoxReserve: TMenuItem
      Caption = #44596#44553' '#53440#49437' '#48176#51221
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuTeeBoxPause: TMenuItem
      Caption = #51216#44160'/'#51116#44032#46041
    end
    object mnuTeeBoxStoppedAll: TMenuItem
      Caption = #48380' '#54924#49688
    end
  end
  object pmnReserveList: TAdvPopupMenu
    MenuAnimation = [maTopToBottom]
    OnClose = pmnReserveListClose
    OnPopup = pmnReserveListPopup
    Version = '2.7.1.9'
    UIStyle = tsCustom
    Left = 608
    Top = 392
    object mnuTeeBoxMove: TMenuItem
      Caption = #53440#49437' '#51060#46041
    end
    object mnuTeeBoxChangeReserved: TMenuItem
      Caption = #50696#50557#49884#44036' '#48320#44221
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mnuTeeBoxCancelReserved: TMenuItem
      Caption = #50696#50557' '#52712#49548
    end
  end
end
