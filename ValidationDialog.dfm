object frmValidation: TfrmValidation
  Left = 0
  Top = 0
  Caption = #39564#35777#32467#26524
  ClientHeight = 461
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 784
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblTitle: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 764
      Height = 21
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alClient
      Caption = #37197#32622#39564#35777#38169#35823#65292#35831#26816#26597#24182#26356#27491#36825#20123#38382#39064#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 304
      ExplicitHeight = 18
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 420
    Width = 784
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnClose: TButton
      AlignWithMargins = True
      Left = 699
      Top = 6
      Width = 75
      Height = 25
      Margins.Left = 5
      Margins.Top = 6
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alRight
      Caption = #20851#38381
      TabOrder = 0
      OnClick = btnCloseClick
    end
    object btnFixAll: TButton
      AlignWithMargins = True
      Left = 10
      Top = 6
      Width = 120
      Height = 25
      Margins.Left = 10
      Margins.Top = 6
      Margins.Right = 5
      Margins.Bottom = 10
      Align = alLeft
      Caption = #33258#21160#20462#22797#25152#26377#38382#39064
      TabOrder = 1
      OnClick = btnFixAllClick
    end
    object btnHelp: TButton
      AlignWithMargins = True
      Left = 599
      Top = 6
      Width = 90
      Height = 25
      Margins.Left = 5
      Margins.Top = 6
      Margins.Right = 5
      Margins.Bottom = 10
      Align = alRight
      Caption = #26174#31034#24110#21161' >>'
      TabOrder = 2
      OnClick = btnHelpClick
    end
  end
  object pnlClient: TPanel
    Left = 0
    Top = 41
    Width = 784
    Height = 379
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object lvErrors: TListView
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 764
      Height = 239
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alClient
      Columns = <
        item
          Caption = #20005#37325#24615
          Width = 80
        end
        item
          Caption = #23646#24615#36335#24452
          Width = 200
        end
        item
          Caption = #23646#24615#21517#31216
          Width = 150
        end
        item
          Caption = #38169#35823#20449#24687
          Width = 300
        end
        item
          Caption = #21487#20462#22797
          Width = 60
          Alignment = taCenter
        end>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnDblClick = lvErrorsDblClick
      OnSelectItem = lvErrorsSelectItem
    end
    object splHelp: TSplitter
      Left = 0
      Top = 259
      Width = 784
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      Color = clBtnFace
      ParentColor = False
    end
    object pnlHelp: TPanel
      Left = 0
      Top = 262
      Width = 784
      Height = 117
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object lblFixSuggestion: TLabel
        AlignWithMargins = True
        Left = 10
        Top = 91
        Width = 684
        Height = 13
        Margins.Left = 10
        Margins.Top = 5
        Margins.Right = 10
        Margins.Bottom = 5
        Align = alBottom
        Caption = #20462#22797#24314#35758#65306
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 52
      end
      object memoHelp: TMemo
        AlignWithMargins = True
        Left = 10
        Top = 10
        Width = 764
        Height = 71
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 5
        Align = alClient
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object btnFixCurrent: TButton
        AlignWithMargins = True
        Left = 704
        Top = 86
        Width = 70
        Height = 25
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 6
        Align = alRight
        Caption = #20462#22797#38382#39064
        TabOrder = 1
        OnClick = btnFixCurrentClick
      end
    end
  end
  object ImageList: TImageList
    Left = 48
    Top = 120
  end
end
