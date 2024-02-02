object XGPrepareForm: TXGPrepareForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 300
  ClientWidth = 600
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
    Width = 600
    Height = 60
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = #47560#49828#53552' '#49688#49888
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
  object lblPluginVersion: TLabel
    Left = 8
    Top = 8
    Width = 56
    Height = 13
    Caption = 'Ver.1.0.0.0'
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
    Width = 600
    Height = 240
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object pgbProgress: TUbuntuProgress
      Left = 145
      Top = 67
      Width = 310
      Height = 18
      ColorSet = csOriginal
      ProgressDividers = False
      BackgroundDividers = True
      MarqueeWidth = 30
      Max = 100
      Mode = pmNormal
      Position = 50
      Shadow = False
      Speed = msMedium
      Step = 1
      Visible = True
    end
    object lblProgress: TLabel
      Left = 145
      Top = 92
      Width = 310
      Height = 22
      Alignment = taCenter
      AutoSize = False
      Caption = #47560#49828#53552' '#49688#49888'...'
    end
    object btnCancel: TAdvShapeButton
      Tag = 101
      Left = 252
      Top = 154
      Width = 96
      Height = 50
      Font.Charset = HANGEUL_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
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
        C4000000017352474200AECE1CE900000122494441547801ED9CB109845000C5
        546E802BDC7F412DDCE00E44B40B08129B587D786220C1F68FEBB2FC869ED70C
        4CAF9103EF063EA787EF7C1E3B0806B67587F40708AE095100B2236C05102413
        A2006447D80A2048264401C88EB01540904C8802901D612B8020991005203BC2
        56004132210A407684AD008264421480EC085B0104C9842800D911B602089209
        5100B2236C05102413A2006447D80A2048264401C88EB01540904C8802901D61
        2B8020991005203BC256004132210A407684AD008264421480EC085B0104C984
        2800D911B6020892095100B2236C05102413A2006447D80A2048264401C88EB0
        1540904C8802901D612B8020991005203BC256004132210A407684AD00826442
        5CB7A51CB777D0CB6DCF1BE80F78DEE9AD2FFE010B9408051EA65ACC00000000
        49454E44AE426082}
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
      ParentBackground = False
      ParentFont = False
      TabStop = True
      TabOrder = 0
      Text = #52712' '#49548
      Version = '6.2.1.8'
      OnClick = btnCancelClick
    end
  end
  object tmrRunOnce: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrRunOnceTimer
    Left = 64
    Top = 96
  end
end
