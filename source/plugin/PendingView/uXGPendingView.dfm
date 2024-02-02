object XGPendingViewForm: TXGPendingViewForm
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
    Caption = #48372#47448' '#45236#50669' '#51312#54924
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
  object panBody: TPanel
    AlignWithMargins = True
    Left = 8
    Top = 65
    Width = 784
    Height = 530
    Margins.Left = 8
    Margins.Top = 5
    Margins.Right = 8
    Margins.Bottom = 5
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    object panToolbar: TPanel
      Left = 0
      Top = 462
      Width = 784
      Height = 68
      Align = alBottom
      BevelOuter = bvNone
      Color = 16054762
      ParentBackground = False
      TabOrder = 0
      object btnImport: TcyAdvSpeedButton
        Left = 403
        Top = 17
        Width = 100
        Height = 40
        AllowAllUp = True
        Caption = #48520#47084#50724#44592
        Flat = True
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = 'Noto Sans CJK KR Bold'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        OnClick = btnImportClick
        BordersNormal = <>
        BordersHot = <>
        BordersDown = <>
        BordersDisabled = <>
        ButtonNormal.Degrade.FromColor = 12623184
        ButtonNormal.Degrade.SpeedPercent = 90
        ButtonNormal.Degrade.ToColor = 12623184
        ButtonNormal.Font.Charset = HANGEUL_CHARSET
        ButtonNormal.Font.Color = clWhite
        ButtonNormal.Font.Height = -15
        ButtonNormal.Font.Name = 'Noto Sans CJK KR Bold'
        ButtonNormal.Font.Style = [fsBold]
        ButtonNormal.Wallpaper.Transparent = False
        ButtonHot.Degrade.BalanceMode = bmReverseFromColor
        ButtonHot.Degrade.FromColor = 14732969
        ButtonHot.Degrade.SpeedPercent = 100
        ButtonHot.Degrade.ToColor = 14732969
        ButtonHot.Font.Charset = HANGEUL_CHARSET
        ButtonHot.Font.Color = clWhite
        ButtonHot.Font.Height = -15
        ButtonHot.Font.Name = 'Noto Sans CJK KR Bold'
        ButtonHot.Font.Style = [fsBold]
        ButtonHot.Wallpaper.Transparent = False
        ButtonDown.Degrade.FromColor = 7165735
        ButtonDown.Degrade.SpeedPercent = 100
        ButtonDown.Degrade.ToColor = 7165735
        ButtonDown.Font.Charset = HANGEUL_CHARSET
        ButtonDown.Font.Color = clWhite
        ButtonDown.Font.Height = -15
        ButtonDown.Font.Name = 'Noto Sans CJK KR Bold'
        ButtonDown.Font.Style = [fsBold]
        ButtonDown.Wallpaper.Transparent = False
        ButtonDisabled.Degrade.FromColor = 15790320
        ButtonDisabled.Degrade.SpeedPercent = 90
        ButtonDisabled.Degrade.ToColor = 15790320
        ButtonDisabled.Font.Charset = HANGEUL_CHARSET
        ButtonDisabled.Font.Color = clWhite
        ButtonDisabled.Font.Height = -15
        ButtonDisabled.Font.Name = 'Noto Sans CJK KR Bold'
        ButtonDisabled.Font.Style = [fsBold]
        ButtonDisabled.Wallpaper.Transparent = False
        Wallpaper.Transparent = False
      end
      object btnDelete: TcyAdvSpeedButton
        Left = 297
        Top = 17
        Width = 100
        Height = 40
        AllowAllUp = True
        Caption = #49325' '#51228
        Flat = True
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = 'Noto Sans CJK KR Bold'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        OnClick = btnDeleteClick
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
        ButtonNormal.Font.Name = 'Noto Sans CJK KR Bold'
        ButtonNormal.Font.Style = [fsBold]
        ButtonNormal.Wallpaper.Transparent = False
        ButtonHot.Degrade.BalanceMode = bmReverseFromColor
        ButtonHot.Degrade.FromColor = 7319033
        ButtonHot.Degrade.SpeedPercent = 100
        ButtonHot.Degrade.ToColor = 7319033
        ButtonHot.Font.Charset = HANGEUL_CHARSET
        ButtonHot.Font.Color = clWhite
        ButtonHot.Font.Height = -15
        ButtonHot.Font.Name = 'Noto Sans CJK KR Bold'
        ButtonHot.Font.Style = [fsBold]
        ButtonHot.Wallpaper.Transparent = False
        ButtonDown.Degrade.FromColor = 612279
        ButtonDown.Degrade.SpeedPercent = 100
        ButtonDown.Degrade.ToColor = 612279
        ButtonDown.Font.Charset = HANGEUL_CHARSET
        ButtonDown.Font.Color = clWhite
        ButtonDown.Font.Height = -15
        ButtonDown.Font.Name = 'Noto Sans CJK KR Bold'
        ButtonDown.Font.Style = [fsBold]
        ButtonDown.Wallpaper.Transparent = False
        ButtonDisabled.Degrade.FromColor = 15790320
        ButtonDisabled.Degrade.SpeedPercent = 90
        ButtonDisabled.Degrade.ToColor = 15790320
        ButtonDisabled.Font.Charset = HANGEUL_CHARSET
        ButtonDisabled.Font.Color = clWhite
        ButtonDisabled.Font.Height = -15
        ButtonDisabled.Font.Name = 'Noto Sans CJK KR Bold'
        ButtonDisabled.Font.Style = [fsBold]
        ButtonDisabled.Wallpaper.Transparent = False
        Wallpaper.Transparent = False
      end
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 784
      Height = 116
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object G1: TcxGrid
        Left = 0
        Top = 0
        Width = 754
        Height = 116
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        LookAndFeel.NativeStyle = True
        LookAndFeel.ScrollbarMode = sbmTouch
        RootLevelOptions.DetailFrameColor = clWhite
        object V1: TcxGridDBBandedTableView
          Navigator.Buttons.CustomButtons = <>
          ScrollbarAnnotations.CustomAnnotations = <>
          DataController.DataSource = ClientDM.DSReceiptPend
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
              Caption = #50689#49688#51613' '#45236#50669
            end>
          object V1receipt_no: TcxGridDBBandedColumn
            Caption = #50689#49688#51613#48264#54840
            DataBinding.FieldName = 'receipt_no'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taLeftJustify
            Properties.Alignment.Vert = taVCenter
            Width = 190
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object V1pos_no: TcxGridDBBandedColumn
            Caption = 'POS'#48264#54840
            DataBinding.FieldName = 'pos_no'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 110
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object V1sale_time: TcxGridDBBandedColumn
            Caption = #44144#47000#49884#44033
            DataBinding.FieldName = 'sale_time'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 90
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object V1member_nm: TcxGridDBBandedColumn
            Caption = #54924#50896#47749
            DataBinding.FieldName = 'member_nm'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 100
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object V1hp_no: TcxGridDBBandedColumn
            Caption = #50672#46973#52376
            DataBinding.FieldName = 'hp_no'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 120
            Position.BandIndex = 0
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
          object V1total_amt: TcxGridDBBandedColumn
            Caption = #49345#54408#44552#50529
            DataBinding.FieldName = 'total_amt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.'
            HeaderAlignmentHorz = taCenter
            Width = 90
            Position.BandIndex = 0
            Position.ColIndex = 5
            Position.RowIndex = 0
          end
          object V1sale_amt: TcxGridDBBandedColumn
            Caption = #54032#47588#44552#50529
            DataBinding.FieldName = 'calc_charge_amt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.'
            HeaderAlignmentHorz = taCenter
            Width = 90
            Position.BandIndex = 0
            Position.ColIndex = 8
            Position.RowIndex = 0
          end
          object V1dc_amt: TcxGridDBBandedColumn
            Caption = #53216#54256#54624#51064
            DataBinding.FieldName = 'dc_amt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.'
            HeaderAlignmentHorz = taCenter
            Width = 90
            Position.BandIndex = 0
            Position.ColIndex = 6
            Position.RowIndex = 0
          end
          object V1direct_dc_amt: TcxGridDBBandedColumn
            Caption = #54408#47785#54624#51064
            DataBinding.FieldName = 'direct_dc_amt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.'
            HeaderAlignmentHorz = taCenter
            Width = 90
            Position.BandIndex = 0
            Position.ColIndex = 7
            Position.RowIndex = 0
          end
        end
        object L1: TcxGridLevel
          GridView = V1
        end
      end
      object Panel8: TPanel
        Left = 754
        Top = 0
        Width = 30
        Height = 116
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
          Top = 0
          Width = 30
          Height = 58
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
          Top = 58
          Width = 30
          Height = 58
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
          OnClick = btnV1DownClick
        end
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 116
      Width = 784
      Height = 116
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object G2: TcxGrid
        Left = 0
        Top = 0
        Width = 754
        Height = 116
        Align = alClient
        BevelInner = bvNone
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        LookAndFeel.NativeStyle = True
        LookAndFeel.ScrollbarMode = sbmTouch
        RootLevelOptions.DetailFrameColor = clWhite
        object V2: TcxGridDBBandedTableView
          Navigator.Buttons.CustomButtons = <>
          ScrollbarAnnotations.CustomAnnotations = <>
          DataController.DataSource = ClientDM.DSSaleItemPend
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
              Caption = #49345#54408' '#44396#47588' '#49345#49464' '#45236#50669
            end>
          object V2calc_product_div: TcxGridDBBandedColumn
            Caption = #44396#48516
            DataBinding.FieldName = 'calc_product_div'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 60
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object V2product_nm: TcxGridDBBandedColumn
            Caption = #49345#54408#47749
            DataBinding.FieldName = 'product_nm'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taLeftJustify
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 180
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object V2purchase_month: TcxGridDBBandedColumn
            Caption = #44060#50900#49688
            DataBinding.FieldName = 'purchase_month'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.'
            HeaderAlignmentHorz = taCenter
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object V2coupon_cnt: TcxGridDBBandedColumn
            Caption = #53216#54256#49688
            DataBinding.FieldName = 'coupon_cnt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.'
            HeaderAlignmentHorz = taCenter
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object V2locker_no: TcxGridDBBandedColumn
            Caption = #46972#52964
            DataBinding.FieldName = 'locker_no'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 60
            Position.BandIndex = 0
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
          object V2keep_amt: TcxGridDBBandedColumn
            Caption = #48372#51613#44552
            DataBinding.FieldName = 'keep_amt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.'
            HeaderAlignmentHorz = taCenter
            Width = 90
            Position.BandIndex = 0
            Position.ColIndex = 5
            Position.RowIndex = 0
          end
          object V2product_amt: TcxGridDBBandedColumn
            Caption = #45800#44032
            DataBinding.FieldName = 'product_amt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.'
            HeaderAlignmentHorz = taCenter
            Width = 90
            Position.BandIndex = 0
            Position.ColIndex = 6
            Position.RowIndex = 0
          end
          object V2order_qty: TcxGridDBBandedColumn
            Caption = #49688#47049
            DataBinding.FieldName = 'order_qty'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.'
            HeaderAlignmentHorz = taCenter
            Width = 60
            Position.BandIndex = 0
            Position.ColIndex = 7
            Position.RowIndex = 0
          end
          object V2coupon_dc_amt: TcxGridDBBandedColumn
            Caption = #53216#54256#54624#51064
            DataBinding.FieldName = 'calc_coupon_dc_amt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.'
            HeaderAlignmentHorz = taCenter
            Width = 100
            Position.BandIndex = 0
            Position.ColIndex = 8
            Position.RowIndex = 0
          end
          object V2dc_amt: TcxGridDBBandedColumn
            Caption = #54408#47785#54624#51064
            DataBinding.FieldName = 'dc_amt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.'
            HeaderAlignmentHorz = taCenter
            Width = 100
            Position.BandIndex = 0
            Position.ColIndex = 9
            Position.RowIndex = 0
          end
          object V2calc_charge_amt: TcxGridDBBandedColumn
            Caption = #54032#47588#44552#50529
            DataBinding.FieldName = 'calc_charge_amt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.'
            HeaderAlignmentHorz = taCenter
            Width = 100
            Position.BandIndex = 0
            Position.ColIndex = 10
            Position.RowIndex = 0
          end
        end
        object L2: TcxGridLevel
          GridView = V2
        end
      end
      object Panel5: TPanel
        Left = 754
        Top = 0
        Width = 30
        Height = 116
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
          Height = 58
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
          Top = 58
          Width = 30
          Height = 58
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
    object Panel3: TPanel
      Left = 0
      Top = 232
      Width = 784
      Height = 116
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
      object G3: TcxGrid
        Left = 0
        Top = 0
        Width = 754
        Height = 116
        Align = alClient
        BevelInner = bvNone
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        LookAndFeel.NativeStyle = True
        LookAndFeel.ScrollbarMode = sbmTouch
        RootLevelOptions.DetailFrameColor = clWhite
        object V3: TcxGridDBBandedTableView
          Navigator.Buttons.CustomButtons = <>
          ScrollbarAnnotations.CustomAnnotations = <>
          DataController.DataSource = ClientDM.DSCouponPend
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
              Caption = #54624#51064#53216#54256' '#49324#50857' '#45236#50669
            end>
          object V3coupon_nm: TcxGridDBBandedColumn
            Caption = #53216#54256#47749
            DataBinding.FieldName = 'coupon_nm'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taLeftJustify
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 200
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object V3calc_dc_div: TcxGridDBBandedColumn
            Caption = #44396#48516
            DataBinding.FieldName = 'calc_dc_div'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 80
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object V3calc_dc_cnt: TcxGridDBBandedColumn
            Caption = #53216#54256#44552#50529
            DataBinding.FieldName = 'calc_dc_cnt'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 100
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object V3start_day: TcxGridDBBandedColumn
            Caption = #49884#51089#51068
            DataBinding.FieldName = 'start_day'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 100
            Position.BandIndex = 0
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
          object V3expire_day: TcxGridDBBandedColumn
            Caption = #47564#47308#51068
            DataBinding.FieldName = 'expire_day'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 100
            Position.BandIndex = 0
            Position.ColIndex = 5
            Position.RowIndex = 0
          end
          object V3use_cnt: TcxGridDBBandedColumn
            Caption = #47588#49688
            DataBinding.FieldName = 'use_cnt'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 60
            Position.BandIndex = 0
            Position.ColIndex = 6
            Position.RowIndex = 0
          end
          object V3used_cnt: TcxGridDBBandedColumn
            Caption = #49324#50857
            DataBinding.FieldName = 'used_cnt'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 60
            Position.BandIndex = 0
            Position.ColIndex = 7
            Position.RowIndex = 0
          end
          object V3calc_product_div: TcxGridDBBandedColumn
            Caption = #49345#54408
            DataBinding.FieldName = 'calc_product_div'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object V3calc_teebox_product_div: TcxGridDBBandedColumn
            Caption = #54924#50896#44428
            DataBinding.FieldName = 'calc_teebox_product_div'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 100
            Position.BandIndex = 0
            Position.ColIndex = 8
            Position.RowIndex = 0
          end
          object V3calc_use_yn: TcxGridDBBandedColumn
            Caption = #49345#53468
            DataBinding.FieldName = 'calc_use_yn'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 80
            Position.BandIndex = 0
            Position.ColIndex = 9
            Position.RowIndex = 0
          end
        end
        object L3: TcxGridLevel
          GridView = V3
        end
      end
      object Panel6: TPanel
        Left = 754
        Top = 0
        Width = 30
        Height = 116
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
        object btnV3Up: TcxButton
          Left = 0
          Top = 0
          Width = 30
          Height = 58
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
          OnClick = btnV3UpClick
        end
        object btnV3Down: TcxButton
          Left = 0
          Top = 58
          Width = 30
          Height = 58
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
          OnClick = btnV3DownClick
        end
      end
    end
    object Panel4: TPanel
      Left = 0
      Top = 348
      Width = 784
      Height = 114
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 4
      object G4: TcxGrid
        Left = 0
        Top = 0
        Width = 754
        Height = 114
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        LookAndFeel.NativeStyle = True
        LookAndFeel.ScrollbarMode = sbmTouch
        RootLevelOptions.DetailFrameColor = clWhite
        object V4: TcxGridDBBandedTableView
          Navigator.Buttons.CustomButtons = <>
          ScrollbarAnnotations.CustomAnnotations = <>
          DataController.DataSource = ClientDM.DSPaymentPend
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
              Caption = #44208#51228' '#45236#50669
            end>
          object V4calc_approval_yn: TcxGridDBBandedColumn
            Caption = #44396#48516
            DataBinding.FieldName = 'calc_approval_yn'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 50
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object V4calc_pay_method: TcxGridDBBandedColumn
            Caption = #44208#51228#49688#45800
            DataBinding.FieldName = 'calc_pay_method'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taLeftJustify
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 90
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object V4credit_card_no: TcxGridDBBandedColumn
            Caption = #52852#46300#48264#54840'/'#49885#48324#48264#54840
            DataBinding.FieldName = 'credit_card_no'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taLeftJustify
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 150
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object V4inst_mon: TcxGridDBBandedColumn
            Caption = #54624#48512
            DataBinding.FieldName = 'inst_mon'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taCenter
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 60
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object V4approve_no: TcxGridDBBandedColumn
            Caption = #49849#51064#48264#54840
            DataBinding.FieldName = 'approve_no'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taLeftJustify
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 150
            Position.BandIndex = 0
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
          object V4issuer_nm: TcxGridDBBandedColumn
            Caption = #48156#44553#49324
            DataBinding.FieldName = 'issuer_nm'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taLeftJustify
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 150
            Position.BandIndex = 0
            Position.ColIndex = 5
            Position.RowIndex = 0
          end
          object V4buyer_nm: TcxGridDBBandedColumn
            Caption = #47588#51077#49324
            DataBinding.FieldName = 'buyer_nm'
            PropertiesClassName = 'TcxLabelProperties'
            Properties.Alignment.Horz = taLeftJustify
            Properties.Alignment.Vert = taVCenter
            HeaderAlignmentHorz = taCenter
            Width = 150
            Position.BandIndex = 0
            Position.ColIndex = 6
            Position.RowIndex = 0
          end
          object V4approve_amt: TcxGridDBBandedColumn
            Caption = #44208#51228#44552#50529
            DataBinding.FieldName = 'approve_amt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.'
            HeaderAlignmentHorz = taCenter
            Width = 100
            Position.BandIndex = 0
            Position.ColIndex = 7
            Position.RowIndex = 0
          end
          object V4calc_cancel_count: TcxGridDBBandedColumn
            DataBinding.FieldName = 'calc_cancel_count'
            HeaderAlignmentHorz = taCenter
            MinWidth = 0
            Width = 0
            Position.BandIndex = 0
            Position.ColIndex = 8
            Position.RowIndex = 0
          end
        end
        object L4: TcxGridLevel
          GridView = V4
        end
      end
      object Panel7: TPanel
        Left = 754
        Top = 0
        Width = 30
        Height = 114
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
        object btnV4Up: TcxButton
          Left = 0
          Top = 0
          Width = 30
          Height = 58
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
          OnClick = btnV4UpClick
        end
        object btnV4Down: TcxButton
          Left = 0
          Top = 58
          Width = 30
          Height = 56
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
          OnClick = btnV4DownClick
        end
      end
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
    TabOrder = 1
    Version = '6.2.1.8'
    OnClick = btnCloseClick
  end
end
