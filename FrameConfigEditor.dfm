object frameConfigEditor: TframeConfigEditor
  Left = 0
  Top = 0
  Width = 640
  Height = 480
  TabOrder = 0
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 640
    Height = 480
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object tabControl: TTabControl
      Left = 0
      Top = 0
      Width = 640
      Height = 30
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      TabHeight = 25
      TabOrder = 0
      Tabs.Strings = (
        #32534#36753#22120
        #21407#22987#25968#25454)
      TabIndex = 0
      OnChange = tabControlChange
    end
    object pnlEditor: TPanel
      Left = 0
      Top = 30
      Width = 640
      Height = 410
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
    end
    object ButtonPanel: TPanel
      Left = 0
      Top = 440
      Width = 640
      Height = 40
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object btnSave: TButton
        Left = 560
        Top = 0
        Width = 80
        Height = 40
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alRight
        Caption = #20445#23384
        Enabled = False
        TabOrder = 0
        OnClick = btnSaveClick
      end
      object btnCancel: TButton
        Left = 0
        Top = 0
        Width = 80
        Height = 40
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alLeft
        Caption = #21462#28040
        Enabled = False
        TabOrder = 1
        OnClick = btnCancelClick
      end
    end
  end
end
