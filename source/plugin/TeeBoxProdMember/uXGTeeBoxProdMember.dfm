object XGTeeBoxProdMemberForm: TXGTeeBoxProdMemberForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 600
  ClientWidth = 800
  Color = 16054762
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
    Caption = #53440#49437' '#49345#54408'/'#46972#52964' '#48372#50976' '#54788#54889
    Color = 6856462
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWhite
    Font.Height = -21
    Font.Name = 'Noto Sans CJK KR Bold'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = False
    Layout = tlCenter
    ExplicitTop = 1
  end
  object lblPluginVersion: TLabel
    Left = 10
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
  object lblMemberName: TLabel
    Left = 8
    Top = 64
    Width = 450
    Height = 19
    AutoSize = False
    Caption = #9654#54924#50896#47749':'
    Color = clWhite
    EllipsisPosition = epEndEllipsis
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Noto Sans CJK KR Regular'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label1: TLabel
    Left = 488
    Top = 64
    Width = 304
    Height = 19
    Alignment = taRightJustify
    Caption = #9758' '#53440#49437#49345#54408' '#49440#53469': '#47560#50864#49828' '#45908#48660'-'#53364#47533' '#46608#45716' '#49440#53469' '#48260#53948' '#49324#50857
    Color = clWhite
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Noto Sans CJK KR Regular'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object panBody: TPanel
    Left = 0
    Top = 530
    Width = 800
    Height = 70
    Align = alBottom
    BevelOuter = bvNone
    Color = 16054762
    ParentBackground = False
    TabOrder = 2
    object btnOK: TAdvShapeButton
      Tag = 106
      Left = 250
      Top = 10
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
      TabOrder = 0
      Text = #53440#49437#49345#54408' '#49440#53469#13#10'(ENTER)'
      Version = '6.2.1.8'
      OnClick = btnOKClick
    end
    object btnCancel: TAdvShapeButton
      Tag = 106
      Left = 352
      Top = 10
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
      Text = #52712#49548#13#10'(ESC)'
      Version = '6.2.1.8'
      OnClick = btnCancelClick
    end
    object btnParkingMemberUpdate: TAdvShapeButton
      Tag = 106
      Left = 454
      Top = 10
      Width = 96
      Height = 50
      Enabled = False
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
      Text = #51452#52264#44428' '#54924#50896#13#10#51221#48372' '#49688#51221
      Version = '6.2.1.8'
      OnClick = btnParkingMemberUpdateClick
    end
  end
  object panTeeBoxList: TPanel
    Left = 8
    Top = 88
    Width = 784
    Height = 300
    BevelOuter = bvNone
    TabOrder = 0
    object G1: TcxGrid
      Left = 0
      Top = 0
      Width = 754
      Height = 300
      Align = alClient
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      LookAndFeel.NativeStyle = True
      object V1: TcxGridDBTableView
        OnDblClick = V1DblClick
        Navigator.Buttons.CustomButtons = <>
        ScrollbarAnnotations.CustomAnnotations = <>
        OnCustomDrawCell = V1CustomDrawCell
        DataController.DataSource = ClientDM.DSTeeBoxProdMember
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsCustomize.ColumnFiltering = False
        OptionsCustomize.ColumnGrouping = False
        OptionsCustomize.ColumnMoving = False
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsSelection.CellSelect = False
        OptionsView.NoDataToDisplayInfoText = '<'#51312#54924#54624' '#45936#51060#53552#44032' '#50630#49845#45768#45796'.>'
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        Styles.Header = ClientDM.StandStyleHeader
        Styles.Inactive = ClientDM.StandStyleSelection
        Styles.Selection = ClientDM.StandStyleSelection
        OnCustomDrawColumnHeader = OnGridViewCustomDrawColumnHeader
        object V1today_yn: TcxGridDBColumn
          Caption = #44032#45733
          DataBinding.FieldName = 'today_yn'
          PropertiesClassName = 'TcxCheckBoxProperties'
          Properties.Alignment = taCenter
          Properties.NullStyle = nssUnchecked
          HeaderAlignmentHorz = taCenter
          Width = 32
        end
        object V1calc_product_div: TcxGridDBColumn
          Caption = #44396#48516
          DataBinding.FieldName = 'calc_product_div'
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 41
        end
        object V1product_nm: TcxGridDBColumn
          Caption = #53440#49437' '#49345#54408#47749
          DataBinding.FieldName = 'product_nm'
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 131
        end
        object V1product_amt: TcxGridDBColumn
          Caption = #49345#54408#44032#44201
          DataBinding.FieldName = 'product_amt'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.;-,0.'
          HeaderAlignmentHorz = taCenter
          Width = 77
        end
        object V1start_day: TcxGridDBColumn
          Caption = #51060#50857#49884#51089#51068
          DataBinding.FieldName = 'start_day'
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 88
        end
        object V1end_day: TcxGridDBColumn
          Caption = #51060#50857#51333#47308#51068
          DataBinding.FieldName = 'end_day'
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 75
        end
        object V1day_start_time: TcxGridDBColumn
          Caption = #49884#51089#49884#44033
          DataBinding.FieldName = 'day_start_time'
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 67
        end
        object V1day_end_time: TcxGridDBColumn
          Caption = #51333#47308#49884#44033
          DataBinding.FieldName = 'day_end_time'
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 67
        end
        object V1one_use_time: TcxGridDBColumn
          Caption = #48176#51221'('#48516')'
          DataBinding.FieldName = 'one_use_time'
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 62
        end
        object V1one_use_cnt: TcxGridDBColumn
          Caption = #51068#54943#49688
          DataBinding.FieldName = 'one_use_cnt'
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 49
        end
        object V1remain_cnt: TcxGridDBColumn
          Caption = #51092#50668#53216#54256
          DataBinding.FieldName = 'remain_cnt'
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 63
        end
        object V1use_status: TcxGridDBColumn
          Caption = #49345#53468
          DataBinding.FieldName = 'use_status'
          MinWidth = 0
          Width = 0
        end
      end
      object L1: TcxGridLevel
        GridView = V1
      end
    end
    object Panel1: TPanel
      Left = 754
      Top = 0
      Width = 30
      Height = 300
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
      object btnV1Up: TcxButton
        Left = 0
        Top = 75
        Width = 30
        Height = 75
        Margins.Left = 1
        Margins.Top = 1
        Margins.Right = 1
        Margins.Bottom = 1
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
        Top = 150
        Width = 30
        Height = 75
        Margins.Left = 1
        Margins.Top = 1
        Margins.Right = 1
        Margins.Bottom = 1
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
        Height = 75
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
        Top = 225
        Width = 30
        Height = 75
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
  end
  object panLockerList: TPanel
    Left = 8
    Top = 391
    Width = 784
    Height = 136
    BevelOuter = bvNone
    TabOrder = 1
    object G2: TcxGrid
      Left = 0
      Top = 0
      Width = 754
      Height = 136
      Align = alClient
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Noto Sans CJK KR Regular'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      LookAndFeel.NativeStyle = True
      object V2: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        ScrollbarAnnotations.CustomAnnotations = <>
        OnCustomDrawCell = V2CustomDrawCell
        DataController.DataSource = ClientDM.DSLockerProdMember
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsCustomize.ColumnFiltering = False
        OptionsCustomize.ColumnGrouping = False
        OptionsCustomize.ColumnMoving = False
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsSelection.CellSelect = False
        OptionsView.NoDataToDisplayInfoText = '<'#51312#54924#54624' '#45936#51060#53552#44032' '#50630#49845#45768#45796'.>'
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        Styles.Header = ClientDM.StandStyleHeader
        Styles.Inactive = ClientDM.StandStyleSelection
        Styles.Selection = ClientDM.StandStyleSelection
        OnCustomDrawColumnHeader = OnGridViewCustomDrawColumnHeader
        object V2product_div: TcxGridDBColumn
          DataBinding.FieldName = 'product_div'
          MinWidth = 0
          Width = 0
        end
        object V2calc_product_div: TcxGridDBColumn
          Caption = #44396#48516
          DataBinding.FieldName = 'calc_product_div'
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          MinWidth = 60
          Options.HorzSizing = False
          Width = 60
        end
        object V2product_nm: TcxGridDBColumn
          Caption = #46972#52964' '#49345#54408#47749
          DataBinding.FieldName = 'product_nm'
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 173
        end
        object V2purchase_amt: TcxGridDBColumn
          Caption = #49345#54408#44032#44201
          DataBinding.FieldName = 'purchase_amt'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.;-,0.'
          HeaderAlignmentHorz = taCenter
          MinWidth = 80
          Options.HorzSizing = False
          Width = 80
        end
        object V2start_day: TcxGridDBColumn
          Caption = #51060#50857#49884#51089#51068
          DataBinding.FieldName = 'start_day'
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          MinWidth = 80
          Options.HorzSizing = False
          Width = 80
        end
        object V2end_day: TcxGridDBColumn
          Caption = #51060#50857#51333#47308#51068
          DataBinding.FieldName = 'end_day'
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          MinWidth = 80
          Options.HorzSizing = False
          Width = 80
        end
        object V2locker_nm: TcxGridDBColumn
          Caption = #46972#52964#48264#54840
          DataBinding.FieldName = 'locker_nm'
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          MinWidth = 60
          Options.HorzSizing = False
          Width = 60
        end
        object V2floor_nm: TcxGridDBColumn
          Caption = #52789
          DataBinding.FieldName = 'floor_nm'
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          MinWidth = 30
          Options.HorzSizing = False
          Width = 30
        end
        object V2zone_nm: TcxGridDBColumn
          Caption = #50948#52824
          DataBinding.FieldName = 'zone_nm'
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Width = 120
        end
        object V2overdue_day: TcxGridDBColumn
          Caption = #51092#50668#51068#49688
          DataBinding.FieldName = 'overdue_day'
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          MinWidth = 60
          Options.HorzSizing = False
          Width = 60
        end
        object V2calc_use_status: TcxGridDBColumn
          Caption = #49345#53468
          DataBinding.FieldName = 'calc_use_status'
          PropertiesClassName = 'TcxLabelProperties'
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          MinWidth = 60
          Options.HorzSizing = False
          Width = 60
        end
      end
      object L2: TcxGridLevel
        GridView = V2
      end
    end
    object Panel3: TPanel
      Left = 754
      Top = 0
      Width = 30
      Height = 136
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
        Height = 68
        Margins.Left = 1
        Margins.Top = 1
        Margins.Right = 1
        Margins.Bottom = 1
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
        Top = 68
        Width = 30
        Height = 68
        Margins.Left = 1
        Margins.Top = 1
        Margins.Right = 1
        Margins.Bottom = 1
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
  object panTeleReserved: TPanel
    Left = 660
    Top = 0
    Width = 80
    Height = 40
    BevelOuter = bvNone
    Color = 6856462
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = 'Noto Sans CJK KR Bold'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 3
    Visible = False
    object imgTeleReserved: TImage
      Left = 0
      Top = 0
      Width = 80
      Height = 40
      Picture.Data = {
        0B546478504E47496D61676589504E470D0A1A0A0000000D4948445200000050
        00000028080600000069607D01000000017352474200AECE1CE9000000046741
        4D410000B18F0BFC6105000000097048597300000EC300000EC301C76FA86400
        000126494441546843EDD4B14A03411485E13BEB33D85B8965ECACD427F0714C
        133B0B0B5B41C14791C44EBB08012B15C1C5462D2CEC24E399ECC64604774FE9
        FF41B8B337DDCFECA6B783CD1CE8AD6A277A22A0898026029A086822A0898026
        029A086822A0898026029A086822A0898026029A086822A0898026029A086822
        A0898026029A086822A0898026029A086822A08980A612F0B939A287A72A453C
        B60FE828E73CA972C4B9CE1FCD0A9DA434AE5471ACE355B34107F7BA82D3F20D
        AC15F158F376B1C65F4CD56CA8B7F7419FC08897D1604563BB4AE95473BDECF0
        ABD93CE77DCD8BD5C39BCF45C0A28DB8A788479A44FCE95DBF4BDDBC13DDBC49
        895796DF01975E47830D7D1CB7F47EEFA69476B45A6BFEF9B7EE14A99E479C69
        5EEBF6D5CB7811115F4938452C2519098F0000000049454E44AE426082}
    end
    object lblTeleReserved: TLabel
      Left = 10
      Top = 8
      Width = 60
      Height = 22
      Alignment = taCenter
      Caption = #51204#54868' '#50696#50557
      Transparent = True
      Layout = tlCenter
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
    TabOrder = 4
    Version = '6.2.1.8'
    OnClick = btnCloseClick
  end
end
