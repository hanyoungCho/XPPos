object XGSaleTableForm: TXGSaleTableForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 768
  ClientWidth = 1366
  Color = clWhite
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Noto Sans CJK KR Regular'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  OnClose = PluginModuleClose
  OnCloseQuery = PluginModuleCloseQuery
  OnKeyDown = PluginModuleKeyDown
  PluginGroup = 0
  InitHeight = 0
  InitWidth = 0
  EscCanClose = False
  OnMessage = PluginModuleMessage
  TextHeight = 22
  object lblAlertMsg: TLabel
    Left = 0
    Top = 744
    Width = 1366
    Height = 24
    Align = alBottom
    Alignment = taCenter
    AutoSize = False
    Color = 6052956
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = 'Noto Sans CJK KR Regular'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = False
    Layout = tlCenter
    WordWrap = True
    ExplicitTop = 742
  end
  object panHeader: TPanel
    Left = 0
    Top = 0
    Width = 1366
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    Caption = #53580#51060#48660'/'#47352' '#44288#47532
    Color = 3158064
    DoubleBuffered = False
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWhite
    Font.Height = -32
    Font.Name = 'Noto Sans CJK KR Bold'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentDoubleBuffered = False
    ParentFont = False
    TabOrder = 0
    object lblPluginVersion: TLabel
      Left = 11
      Top = 8
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
    object lblGroupMode: TDRLabel
      AlignWithMargins = True
      Left = 1119
      Top = 3
      Width = 50
      Height = 59
      Align = alRight
      Alignment = taCenter
      AutoSize = False
      Caption = #45800#52404#13#10#51648#51221
      Color = 3158064
      Font.Charset = HANGEUL_CHARSET
      Font.Color = 7321599
      Font.Height = -19
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      Layout = tlCenter
      Visible = False
      HiColor = clBlue
      LoColor = clNavy
      Border = boSingle
      Ctl3D = False
      BlinkInterval = 300
      Blink = blNone
      Deep = 1
      ExplicitLeft = 1069
      ExplicitTop = 0
    end
    object panHeaderTools: TPanel
      AlignWithMargins = True
      Left = 1261
      Top = 5
      Width = 100
      Height = 55
      Margins.Left = 0
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
      TabOrder = 0
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
    object panClock: TPanel
      AlignWithMargins = True
      Left = 9
      Top = 23
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
        ExplicitLeft = 112
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
    object panScoreboard: TPanel
      Left = 1172
      Top = 0
      Width = 89
      Height = 65
      Align = alRight
      BevelOuter = bvNone
      Color = 3158064
      ParentBackground = False
      TabOrder = 2
      object ledStoreEndTime: TLEDFontNum
        Left = 1
        Top = 22
        Width = 88
        Height = 37
        Thick = 3
        Space = 4
        Text = '00:00'
        BGColor = 3158064
        LightColor = 5460991
        DrawDarkColor = False
      end
      object Label15: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 83
        Height = 19
        Align = alTop
        Alignment = taCenter
        Caption = #50689#50629#51333#47308
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 48
      end
    end
  end
  object panBasePanel: TPanel
    Left = 0
    Top = 65
    Width = 1366
    Height = 679
    Align = alClient
    BevelOuter = bvNone
    Color = 15790320
    ParentBackground = False
    TabOrder = 1
    object panRightMenu: TPanel
      Left = 1146
      Top = 0
      Width = 220
      Height = 679
      Align = alRight
      BevelOuter = bvNone
      Color = 16767897
      DoubleBuffered = False
      Padding.Left = 5
      Padding.Top = 5
      Padding.Right = 5
      Padding.Bottom = 5
      ParentBackground = False
      ParentDoubleBuffered = False
      TabOrder = 0
      object btnSalePos: TcyAdvSpeedButton
        Tag = 1
        AlignWithMargins = True
        Left = 5
        Top = 634
        Width = 210
        Height = 40
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alBottom
        Caption = #54032#47588' '#44288#47532' (F12)'
        Flat = True
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        Transparent = False
        OnClick = btnSalePosClick
        BordersNormal = <>
        BordersHot = <>
        BordersDown = <>
        BordersDisabled = <>
        ButtonNormal.Degrade.FromColor = 3487168
        ButtonNormal.Degrade.SpeedPercent = 90
        ButtonNormal.Degrade.ToColor = 3487168
        ButtonNormal.Font.Charset = HANGEUL_CHARSET
        ButtonNormal.Font.Color = clWhite
        ButtonNormal.Font.Height = -15
        ButtonNormal.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonNormal.Font.Style = []
        ButtonNormal.UseDefaultFont = False
        ButtonNormal.Wallpaper.Transparent = False
        ButtonHot.Degrade.BalanceMode = bmReverseFromColor
        ButtonHot.Degrade.FromColor = 3487168
        ButtonHot.Degrade.SpeedPercent = 100
        ButtonHot.Degrade.ToColor = 3487168
        ButtonHot.Font.Charset = HANGEUL_CHARSET
        ButtonHot.Font.Color = clWhite
        ButtonHot.Font.Height = -15
        ButtonHot.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonHot.Font.Style = []
        ButtonHot.UseDefaultFont = False
        ButtonHot.Wallpaper.Transparent = False
        ButtonDown.Degrade.FromColor = clWhite
        ButtonDown.Degrade.SpeedPercent = 100
        ButtonDown.Degrade.ToColor = clWhite
        ButtonDown.Font.Charset = HANGEUL_CHARSET
        ButtonDown.Font.Color = 3487168
        ButtonDown.Font.Height = -15
        ButtonDown.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDown.Font.Style = []
        ButtonDown.UseDefaultFont = False
        ButtonDown.Wallpaper.Transparent = False
        ButtonDisabled.Degrade.FromColor = 15790320
        ButtonDisabled.Degrade.SpeedPercent = 90
        ButtonDisabled.Degrade.ToColor = 15790320
        ButtonDisabled.Font.Charset = HANGEUL_CHARSET
        ButtonDisabled.Font.Color = clSilver
        ButtonDisabled.Font.Height = -15
        ButtonDisabled.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDisabled.Font.Style = []
        ButtonDisabled.UseDefaultFont = False
        ButtonDisabled.Wallpaper.Transparent = False
        Wallpaper.Transparent = False
        WordWrap = True
        ExplicitTop = 628
        ExplicitWidth = 204
      end
      object btnTableGroup: TcyAdvSpeedButton
        Tag = 1
        AlignWithMargins = True
        Left = 5
        Top = 499
        Width = 210
        Height = 40
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alBottom
        Caption = #45800#52404' '#51648#51221' (F9)'
        Flat = True
        Font.Charset = HANGEUL_CHARSET
        Font.Color = 3487168
        Font.Height = -15
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        Transparent = False
        OnClick = btnTableGroupClick
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
        ButtonNormal.UseDefaultFont = False
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
        ButtonDown.Degrade.FromColor = 3487168
        ButtonDown.Degrade.SpeedPercent = 100
        ButtonDown.Degrade.ToColor = 3487168
        ButtonDown.Font.Charset = HANGEUL_CHARSET
        ButtonDown.Font.Color = clWhite
        ButtonDown.Font.Height = -15
        ButtonDown.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDown.Font.Style = []
        ButtonDown.UseDefaultFont = False
        ButtonDown.Wallpaper.Transparent = False
        ButtonDisabled.Degrade.FromColor = 15790320
        ButtonDisabled.Degrade.SpeedPercent = 90
        ButtonDisabled.Degrade.ToColor = 15790320
        ButtonDisabled.Font.Charset = HANGEUL_CHARSET
        ButtonDisabled.Font.Color = clSilver
        ButtonDisabled.Font.Height = -15
        ButtonDisabled.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDisabled.Font.Style = []
        ButtonDisabled.UseDefaultFont = False
        ButtonDisabled.Wallpaper.Transparent = False
        Wallpaper.Transparent = False
        WordWrap = True
        ExplicitTop = 611
        ExplicitWidth = 204
      end
      object btnTableClear: TcyAdvSpeedButton
        Tag = 1
        AlignWithMargins = True
        Left = 5
        Top = 454
        Width = 210
        Height = 40
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alBottom
        Caption = #51221#47532' (F8)'
        Flat = True
        Font.Charset = HANGEUL_CHARSET
        Font.Color = 3487168
        Font.Height = -15
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        Transparent = False
        OnClick = btnTableClearClick
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
        ButtonNormal.UseDefaultFont = False
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
        ButtonDown.Degrade.FromColor = 3487168
        ButtonDown.Degrade.SpeedPercent = 100
        ButtonDown.Degrade.ToColor = 3487168
        ButtonDown.Font.Charset = HANGEUL_CHARSET
        ButtonDown.Font.Color = clWhite
        ButtonDown.Font.Height = -15
        ButtonDown.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDown.Font.Style = []
        ButtonDown.UseDefaultFont = False
        ButtonDown.Wallpaper.Transparent = False
        ButtonDisabled.Degrade.FromColor = 15790320
        ButtonDisabled.Degrade.SpeedPercent = 90
        ButtonDisabled.Degrade.ToColor = 15790320
        ButtonDisabled.Font.Charset = HANGEUL_CHARSET
        ButtonDisabled.Font.Color = clSilver
        ButtonDisabled.Font.Height = -15
        ButtonDisabled.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDisabled.Font.Style = []
        ButtonDisabled.UseDefaultFont = False
        ButtonDisabled.Wallpaper.Transparent = False
        Wallpaper.Transparent = False
        WordWrap = True
        ExplicitLeft = 3
      end
      object btnReceiptView: TcyAdvSpeedButton
        Tag = 1
        AlignWithMargins = True
        Left = 5
        Top = 544
        Width = 210
        Height = 40
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alBottom
        Caption = #44144#47000#45236#50669' '#51312#54924' (F10)'
        Flat = True
        Font.Charset = HANGEUL_CHARSET
        Font.Color = 3487168
        Font.Height = -15
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        Transparent = False
        OnClick = btnReceiptViewClick
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
        ButtonNormal.UseDefaultFont = False
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
        ButtonDown.Degrade.FromColor = 3487168
        ButtonDown.Degrade.SpeedPercent = 100
        ButtonDown.Degrade.ToColor = 3487168
        ButtonDown.Font.Charset = HANGEUL_CHARSET
        ButtonDown.Font.Color = clWhite
        ButtonDown.Font.Height = -15
        ButtonDown.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDown.Font.Style = []
        ButtonDown.UseDefaultFont = False
        ButtonDown.Wallpaper.Transparent = False
        ButtonDisabled.Degrade.FromColor = 15790320
        ButtonDisabled.Degrade.SpeedPercent = 90
        ButtonDisabled.Degrade.ToColor = 15790320
        ButtonDisabled.Font.Charset = HANGEUL_CHARSET
        ButtonDisabled.Font.Color = clSilver
        ButtonDisabled.Font.Height = -15
        ButtonDisabled.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDisabled.Font.Style = []
        ButtonDisabled.UseDefaultFont = False
        ButtonDisabled.Wallpaper.Transparent = False
        Wallpaper.Transparent = False
        WordWrap = True
        ExplicitLeft = -3
        ExplicitTop = 624
      end
      object btnPartnerCenter: TcyAdvSpeedButton
        Tag = 1
        AlignWithMargins = True
        Left = 5
        Top = 589
        Width = 210
        Height = 40
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alBottom
        Caption = #54028#53944#45320#49468#53552' (F11)'
        Flat = True
        Font.Charset = HANGEUL_CHARSET
        Font.Color = 3487168
        Font.Height = -15
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        Transparent = False
        OnClick = btnPartnerCenterClick
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
        ButtonNormal.UseDefaultFont = False
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
        ButtonDown.Degrade.FromColor = 3487168
        ButtonDown.Degrade.SpeedPercent = 100
        ButtonDown.Degrade.ToColor = 3487168
        ButtonDown.Font.Charset = HANGEUL_CHARSET
        ButtonDown.Font.Color = clWhite
        ButtonDown.Font.Height = -15
        ButtonDown.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDown.Font.Style = []
        ButtonDown.UseDefaultFont = False
        ButtonDown.Wallpaper.Transparent = False
        ButtonDisabled.Degrade.FromColor = 15790320
        ButtonDisabled.Degrade.SpeedPercent = 90
        ButtonDisabled.Degrade.ToColor = 15790320
        ButtonDisabled.Font.Charset = HANGEUL_CHARSET
        ButtonDisabled.Font.Color = clSilver
        ButtonDisabled.Font.Height = -15
        ButtonDisabled.Font.Name = 'Noto Sans CJK KR Regular'
        ButtonDisabled.Font.Style = []
        ButtonDisabled.UseDefaultFont = False
        ButtonDisabled.Wallpaper.Transparent = False
        Wallpaper.Transparent = False
        WordWrap = True
        ExplicitLeft = 3
        ExplicitTop = 632
      end
      object panTableMap: TPanel
        Left = 5
        Top = 5
        Width = 210
        Height = 412
        Align = alClient
        BevelOuter = bvNone
        Color = 16777183
        ParentBackground = False
        TabOrder = 0
        object TemplateMapButton: TcySpeedButton
          Left = 8
          Top = 8
          Width = 49
          Height = 33
          Visible = False
          MonochromeGlyphColor = clBlack
          Degrade.Balance = 0
          Degrade.FromColor = clYellow
          Degrade.SpeedPercent = 90
          Degrade.ToColor = 33023
          Wallpaper.Transparent = False
        end
        object lbxGroupList: TListBox
          AlignWithMargins = True
          Left = 5
          Top = 327
          Width = 200
          Height = 80
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alBottom
          ItemHeight = 22
          TabOrder = 0
          Visible = False
        end
      end
      object panTableMapToolbar: TPanel
        Left = 5
        Top = 417
        Width = 210
        Height = 32
        Align = alBottom
        AutoSize = True
        BevelOuter = bvNone
        Color = 16777183
        ParentBackground = False
        TabOrder = 1
        object btnResetTableMap: TcySpeedButton
          AlignWithMargins = True
          Left = 5
          Top = 0
          Width = 65
          Height = 27
          Margins.Left = 5
          Margins.Top = 0
          Margins.Bottom = 5
          Align = alLeft
          Caption = #52488#44592#54868
          Enabled = False
          Font.Charset = HANGEUL_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Noto Sans CJK KR Regular'
          Font.Style = []
          ParentFont = False
          OnClick = btnResetTableMapClick
          MonochromeGlyphColor = clGray
          Degrade.FromColor = clWhite
          Degrade.SpeedPercent = 90
          Degrade.ToColor = clSilver
          Wallpaper.Transparent = False
        end
        object btnEditTableMap: TcySpeedButton
          AlignWithMargins = True
          Left = 73
          Top = 0
          Width = 65
          Height = 27
          Margins.Left = 0
          Margins.Top = 0
          Margins.Bottom = 5
          Align = alLeft
          Caption = #49688#51221
          Font.Charset = HANGEUL_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Noto Sans CJK KR Regular'
          Font.Style = []
          ParentFont = False
          OnClick = btnEditTableMapClick
          MonochromeGlyphColor = clBlack
          Degrade.FromColor = clWhite
          Degrade.SpeedPercent = 90
          Degrade.ToColor = clSilver
          Wallpaper.Transparent = False
        end
        object btnSaveTableMap: TcySpeedButton
          AlignWithMargins = True
          Left = 141
          Top = 0
          Width = 64
          Height = 27
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          Caption = #51200#51109
          Enabled = False
          Font.Charset = HANGEUL_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Noto Sans CJK KR Regular'
          Font.Style = []
          ParentFont = False
          OnClick = btnSaveTableMapClick
          MonochromeGlyphColor = clGray
          Degrade.FromColor = clWhite
          Degrade.SpeedPercent = 90
          Degrade.ToColor = clSilver
          Wallpaper.Transparent = False
          ExplicitLeft = 147
          ExplicitTop = 3
          ExplicitWidth = 60
          ExplicitHeight = 26
        end
      end
    end
    object sbxTables: TScrollBox
      Left = 0
      Top = 0
      Width = 1146
      Height = 679
      HorzScrollBar.Visible = False
      VertScrollBar.Smooth = True
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      DoubleBuffered = True
      Color = clWhite
      ParentColor = False
      ParentDoubleBuffered = False
      TabOrder = 1
      OnMouseWheel = sbxTablesMouseWheel
    end
  end
  object WindowDesigner: TWindowDesigner
    DesignerColor = clLime
    PartSize = 6
    GridColor = clGray
    GridSizeX = 8
    GridSizeY = 8
    SizingPartColor = clBlue
    GuideLineColor = clAqua
    ShowGrid = True
    UseGuideLines = True
    SnapToGrid = True
    Left = 1232
    Top = 273
  end
  object tmrClock: TTimer
    Enabled = False
    OnTimer = tmrClockTimer
    Left = 72
    Top = 97
  end
end
