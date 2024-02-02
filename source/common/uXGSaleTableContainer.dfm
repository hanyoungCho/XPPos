object XGSaleTableContainer: TXGSaleTableContainer
  Left = 0
  Top = 0
  Width = 260
  Height = 340
  BevelOuter = bvNone
  Color = 16758639
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Noto Sans CJK KR Regular'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object TitlePanel: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 5
    Width = 250
    Height = 50
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 1
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Noto Sans CJK KR Regular'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    OnClick = OnBaseClick
    object panTableInfo: TPanel
      Left = 60
      Top = 0
      Width = 190
      Height = 50
      Align = alClient
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object TableNameLabel: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 0
        Width = 124
        Height = 23
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alClient
        AutoSize = False
        Caption = #53580#51060#48660#47749
        EllipsisPosition = epEndEllipsis
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clBlack
        Font.Height = -15
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = []
        ParentFont = False
        Transparent = True
        OnClick = OnBaseClick
        ExplicitWidth = 132
        ExplicitHeight = 26
      end
      object GroupNoLabel: TLabel
        Left = 130
        Top = 0
        Width = 60
        Height = 23
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alRight
        Alignment = taCenter
        AutoSize = False
        Caption = 'G-0'
        Color = 16758639
        Font.Charset = HANGEUL_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = 'Noto Sans CJK KR Regular'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = False
        Layout = tlCenter
        OnClick = OnBaseClick
        ExplicitLeft = 131
      end
      object TableInfoPanel: TPanel
        Left = 0
        Top = 23
        Width = 190
        Height = 27
        Align = alBottom
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object ElapsedTimeLabel: TLabel
          AlignWithMargins = True
          Left = 53
          Top = 0
          Width = 77
          Height = 27
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alClient
          AutoSize = False
          Caption = #44221#44284#49884#44036
          EllipsisPosition = epEndEllipsis
          Font.Charset = HANGEUL_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Noto Sans CJK KR Regular'
          Font.Style = []
          ParentFont = False
          Transparent = True
          Layout = tlCenter
          OnClick = OnBaseClick
          ExplicitTop = 1
          ExplicitWidth = 85
          ExplicitHeight = 25
        end
        object EnteredTimeLabel: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 0
          Width = 50
          Height = 27
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          AutoSize = False
          Caption = #51077#51109
          EllipsisPosition = epEndEllipsis
          Font.Charset = HANGEUL_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Noto Sans CJK KR Regular'
          Font.Style = []
          ParentFont = False
          Transparent = True
          Layout = tlCenter
          OnClick = OnBaseClick
          ExplicitTop = 1
          ExplicitHeight = 16
        end
        object GuestCountEdit: TcxSpinEdit
          Left = 130
          Top = 0
          Align = alRight
          AutoSize = False
          ParentFont = False
          Properties.Alignment.Horz = taCenter
          Properties.MaxValue = 999.000000000000000000
          Properties.MinValue = 1.000000000000000000
          Properties.SpinButtons.Position = sbpHorzLeftRight
          Properties.UseLeftAlignmentOnEditing = False
          Properties.OnChange = GuestCountEditPropertiesChange
          Style.Font.Charset = HANGEUL_CHARSET
          Style.Font.Color = clBlack
          Style.Font.Height = -15
          Style.Font.Name = 'Noto Sans CJK KR Regular'
          Style.Font.Style = []
          Style.IsFontAssigned = True
          TabOrder = 0
          Value = 1
          Height = 27
          Width = 60
        end
      end
    end
    object TableNoPanel: TPanel
      Left = 0
      Top = 0
      Width = 60
      Height = 50
      Cursor = crHandPoint
      Align = alLeft
      BevelOuter = bvNone
      Caption = '11'
      Color = clSilver
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWhite
      Font.Height = -27
      Font.Name = 'Noto Sans CJK KR Bold'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 1
      OnClick = OnBaseClick
    end
  end
  object MemoControl: TMemo
    AlignWithMargins = True
    Left = 5
    Top = 265
    Width = 250
    Height = 70
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alBottom
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Ctl3D = True
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clBlack
    Font.Height = -15
    Font.Name = 'Noto Sans CJK KR Regular'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 1
    OnMouseDown = MemoControlMouseDown
  end
  object Grid: TcxGrid
    AlignWithMargins = True
    Left = 5
    Top = 61
    Width = 250
    Height = 204
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 0
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
    TabOrder = 2
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = False
    LookAndFeel.ScrollbarMode = sbmTouch
    LookAndFeel.ScrollMode = scmSmooth
    object GridView: TcxGridDBBandedTableView
      OnMouseDown = GridViewMouseDown
      Navigator.Buttons.CustomButtons = <>
      ScrollbarAnnotations.CustomAnnotations = <>
      DataController.DataSource = DataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0'
          Kind = skSum
          FieldName = 'calc_charge_amt'
          Column = GridViewcalc_charge_amt
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnFiltering = False
      OptionsCustomize.ColumnGrouping = False
      OptionsCustomize.ColumnHidingOnGrouping = False
      OptionsCustomize.ColumnMoving = False
      OptionsCustomize.ColumnSorting = False
      OptionsCustomize.ColumnVertSizing = False
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.CellSelect = False
      OptionsSelection.ShowCheckBoxesDynamically = True
      OptionsView.FocusRect = False
      OptionsView.NoDataToDisplayInfoText = '<'#51452#47928#54620' '#45236#50669#51060' '#50630#49845#45768#45796'.>'
      OptionsView.ScrollBars = ssVertical
      OptionsView.ColumnAutoWidth = True
      OptionsView.Footer = True
      OptionsView.GridLines = glNone
      OptionsView.GroupByBox = False
      Styles.Selection = ClientDM.StandStyleSelection2
      Bands = <
        item
          Caption = #48155#51008' '#44552#50529
        end>
      object GridViewproduct_nm: TcxGridDBBandedColumn
        Caption = #49345#54408#47749
        DataBinding.FieldName = 'product_nm'
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Vert = taVCenter
        Width = 200
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object GridVieworder_qty: TcxGridDBBandedColumn
        Caption = #49688#47049
        DataBinding.FieldName = 'order_qty'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.;-,0.'
        HeaderAlignmentHorz = taCenter
        Width = 50
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object GridViewcalc_charge_amt: TcxGridDBBandedColumn
        Caption = #51452#47928#44552#50529
        DataBinding.FieldName = 'calc_charge_amt'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.;-,0.'
        HeaderAlignmentHorz = taCenter
        MinWidth = 0
        Width = 100
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
    end
    object GridLevel: TcxGridLevel
      GridView = GridView
    end
  end
  object DataSource: TDataSource
    Left = 120
    Top = 280
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 56
    Top = 280
  end
end
