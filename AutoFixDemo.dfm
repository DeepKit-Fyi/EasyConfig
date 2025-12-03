object ConfigFixDemoForm: TConfigFixDemoForm
  Left = 0
  Top = 0
  Caption = #37197#32622#39564#35777#19982#33258#21160#20462#22797#28436#31034
  ClientHeight = 561
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 542
    Width = 800
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 800
    Height = 542
    ActivePage = tsINI
    Align = alClient
    TabOrder = 1
    object tsINI: TTabSheet
      Caption = 'INI '#37197#32622
      object pnlINITop: TPanel
        Left = 0
        Top = 0
        Width = 792
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object btnValidateINI: TButton
          AlignWithMargins = True
          Left = 10
          Top = 5
          Width = 75
          Height = 30
          Margins.Left = 10
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 6
          Align = alLeft
          Caption = #39564#35777
          TabOrder = 0
          OnClick = btnValidateINIClick
        end
        object btnAddSampleData: TButton
          AlignWithMargins = True
          Left = 697
          Top = 5
          Width = 85
          Height = 30
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 10
          Margins.Bottom = 6
          Align = alRight
          Caption = #28155#21152#26679#20363#25968#25454
          TabOrder = 1
          OnClick = btnAddSampleDataClick
        end
        object btnResetINI: TButton
          AlignWithMargins = True
          Left = 602
          Top = 5
          Width = 85
          Height = 30
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 6
          Align = alRight
          Caption = #37325#32622'INI'
          TabOrder = 2
          OnClick = btnResetINIClick
        end
        object btnFixINI: TButton
          AlignWithMargins = True
          Left = 95
          Top = 5
          Width = 75
          Height = 30
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 6
          Align = alLeft
          Caption = #33258#21160#20462#22797
          TabOrder = 3
          OnClick = btnFixINIClick
        end
      end
      object pnlINIContent: TPanel
        Left = 0
        Top = 41
        Width = 792
        Height = 473
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object sgINI: TStringGrid
          AlignWithMargins = True
          Left = 10
          Top = 10
          Width = 772
          Height = 453
          Margins.Left = 10
          Margins.Top = 10
          Margins.Right = 10
          Margins.Bottom = 10
          Align = alClient
          DefaultColWidth = 120
          FixedCols = 0
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
          TabOrder = 0
        end
      end
    end
    object tsJSON: TTabSheet
      Caption = 'JSON '#37197#32622
      ImageIndex = 1
      object pnlJSONTop: TPanel
        Left = 0
        Top = 0
        Width = 792
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object btnValidateJSON: TButton
          AlignWithMargins = True
          Left = 10
          Top = 5
          Width = 75
          Height = 30
          Margins.Left = 10
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 6
          Align = alLeft
          Caption = #39564#35777
          TabOrder = 0
          OnClick = btnValidateJSONClick
        end
        object btnResetJSON: TButton
          AlignWithMargins = True
          Left = 602
          Top = 5
          Width = 85
          Height = 30
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 6
          Align = alRight
          Caption = #37325#32622'JSON'
          TabOrder = 1
          OnClick = btnResetJSONClick
        end
        object btnFixJSON: TButton
          AlignWithMargins = True
          Left = 95
          Top = 5
          Width = 75
          Height = 30
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 6
          Align = alLeft
          Caption = #33258#21160#20462#22797
          TabOrder = 2
          OnClick = btnFixJSONClick
        end
      end
      object pnlJSONContent: TPanel
        Left = 0
        Top = 41
        Width = 792
        Height = 473
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object memJSON: TMemo
          AlignWithMargins = True
          Left = 10
          Top = 10
          Width = 772
          Height = 453
          Margins.Left = 10
          Margins.Top = 10
          Margins.Right = 10
          Margins.Bottom = 10
          Align = alClient
          ScrollBars = ssBoth
          TabOrder = 0
          WantTabs = True
          WordWrap = False
        end
      end
    end
  end
end 