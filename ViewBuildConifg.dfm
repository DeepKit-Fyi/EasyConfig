object ViewBuildConfig: TViewBuildConfig
  Left = 0
  Top = 0
  ClientHeight = 461
  ClientWidth = 837
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 0
    Top = 417
    Width = 837
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitLeft = 257
    ExplicitTop = 85
    ExplicitWidth = 354
  end
  object Splitter2: TSplitter
    Left = 793
    Top = 85
    Height = 332
    Align = alRight
    ExplicitLeft = 400
    ExplicitTop = 160
    ExplicitHeight = 100
  end
  object Splitter3: TSplitter
    Left = 300
    Top = 85
    Height = 332
    ExplicitLeft = 392
    ExplicitTop = 152
    ExplicitHeight = 100
  end
  object Splitter4: TSplitter
    Left = 0
    Top = 82
    Width = 837
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitLeft = 266
    ExplicitWidth = 357
  end
  object pnlIni: TPanel
    Left = 0
    Top = 0
    Width = 837
    Height = 41
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 624
    object btnAddText: TButton
      Left = 9
      Top = 7
      Width = 75
      Height = 25
      Caption = #28155#21152#25991#26412
      TabOrder = 0
    end
    object btnAddNumber: TButton
      Left = 90
      Top = 7
      Width = 75
      Height = 25
      Caption = #28155#21152#25968#23383
      TabOrder = 1
    end
    object btnAddPath: TButton
      Left = 171
      Top = 7
      Width = 75
      Height = 25
      Caption = #28155#21152#36335#24452
      TabOrder = 2
    end
    object btnAddBoolean: TButton
      Left = 252
      Top = 7
      Width = 75
      Height = 25
      Caption = #28155#21152#24067#23572
      TabOrder = 3
    end
    object btnAddDate: TButton
      Left = 333
      Top = 7
      Width = 75
      Height = 25
      Caption = #28155#21152#26085#26399
      TabOrder = 4
    end
    object btnAddColor: TButton
      Left = 414
      Top = 7
      Width = 75
      Height = 25
      Caption = #28155#21152#39068#33394
      TabOrder = 5
    end
  end
  object pnlJson: TPanel
    Left = 0
    Top = 41
    Width = 837
    Height = 41
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 624
    object btnAddFont: TButton
      Left = 9
      Top = 8
      Width = 75
      Height = 25
      Caption = #28155#21152#23383#20307
      TabOrder = 0
    end
    object btnAddColorComplex: TButton
      Left = 90
      Top = 8
      Width = 75
      Height = 25
      Caption = #28155#21152#39068#33394
      TabOrder = 1
    end
    object btnAddDatabase: TButton
      Left = 171
      Top = 8
      Width = 75
      Height = 25
      Caption = #28155#21152#25968#25454#24211
      TabOrder = 2
    end
    object btnAddList: TButton
      Left = 252
      Top = 8
      Width = 75
      Height = 25
      Caption = #28155#21152#21015#34920
      TabOrder = 3
    end
    object btnAddObject: TButton
      Left = 333
      Top = 8
      Width = 75
      Height = 25
      Caption = #28155#21152#23545#35937
      TabOrder = 4
    end
    object btnAddArray: TButton
      Left = 414
      Top = 8
      Width = 75
      Height = 25
      Caption = #28155#21152#25968#32452
      TabOrder = 5
    end
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 85
    Width = 300
    Height = 332
    Align = alLeft
    TabOrder = 2
    ExplicitHeight = 312
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 300
      Height = 330
      Align = alLeft
      TabOrder = 0
      ExplicitHeight = 310
      object sgINI: TStringGrid
        Left = 1
        Top = 1
        Width = 298
        Height = 112
        Align = alTop
        ColCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goRowSelect]
        TabOrder = 0
        ColWidths = (
          105
          186)
      end
      object Panel2: TPanel
        Left = 1
        Top = 113
        Width = 300
        Height = 216
        Align = alLeft
        TabOrder = 1
        ExplicitHeight = 196
        object Panel3: TPanel
          Left = 1
          Top = 1
          Width = 300
          Height = 214
          Align = alLeft
          TabOrder = 0
          ExplicitHeight = 194
          object Splitter5: TSplitter
            Left = 1
            Top = 1
            Width = 298
            Height = 3
            Cursor = crVSplit
            Align = alTop
          end
          object tvJSON: TTreeView
            Left = 1
            Top = 45
            Width = 298
            Height = 168
            Align = alClient
            DragMode = dmAutomatic
            Indent = 19
            TabOrder = 0
          end
          object pnlEditing: TPanel
            Left = 1
            Top = 4
            Width = 298
            Height = 41
            Align = alTop
            TabOrder = 1
            object edtEditing: TEdit
              AlignWithMargins = True
              Left = 11
              Top = 11
              Width = 222
              Height = 19
              Margins.Left = 10
              Margins.Top = 10
              Margins.Right = 10
              Margins.Bottom = 10
              Align = alLeft
              TabOrder = 0
              Text = 'edtEditing'
              ExplicitHeight = 23
            end
            object btnUpdate: TButton
              AlignWithMargins = True
              Left = 224
              Top = 11
              Width = 63
              Height = 19
              Margins.Left = 10
              Margins.Top = 10
              Margins.Right = 10
              Margins.Bottom = 10
              Align = alRight
              Caption = #20445#23384#20462#25913
              TabOrder = 1
            end
          end
        end
      end
    end
  end
  object pnlRigth: TPanel
    Left = 796
    Top = 85
    Width = 41
    Height = 332
    Align = alRight
    TabOrder = 3
    ExplicitLeft = 583
    ExplicitHeight = 312
  end
  object pnlContent: TPanel
    Left = 303
    Top = 85
    Width = 490
    Height = 332
    Align = alClient
    TabOrder = 4
    ExplicitWidth = 277
    ExplicitHeight = 312
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 488
      Height = 330
      ActivePage = tsEditor
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 275
      ExplicitHeight = 310
      object tsINI: TTabSheet
        Caption = 'INI'#20869#23481
        object Memo1: TMemo
          Left = 0
          Top = 0
          Width = 480
          Height = 300
          Align = alClient
          Lines.Strings = (
            'Memo1')
          ScrollBars = ssBoth
          TabOrder = 0
          ExplicitWidth = 267
          ExplicitHeight = 280
        end
      end
      object tsJSON: TTabSheet
        Caption = 'JSON'#20869#23481
        ImageIndex = 1
        object Memo2: TMemo
          Left = 0
          Top = 0
          Width = 480
          Height = 300
          Align = alClient
          Lines.Strings = (
            'Memo1')
          ScrollBars = ssBoth
          TabOrder = 0
          ExplicitWidth = 267
          ExplicitHeight = 280
        end
      end
      object tsEditor: TTabSheet
        Caption = #22797#26434#23646#24615#32534#36753#22120
        ImageIndex = 2
        object Panel4: TPanel
          Left = 0
          Top = 259
          Width = 480
          Height = 41
          Align = alBottom
          TabOrder = 0
          ExplicitTop = 239
          ExplicitWidth = 267
          DesignSize = (
            480
            41)
          object btnSave: TButton
            AlignWithMargins = True
            Left = 368
            Top = 13
            Width = 91
            Height = 19
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 10
            Anchors = [akTop, akRight]
            Caption = #20445#23384#21040#25991#20214
            TabOrder = 0
          end
        end
        object pnlEditorContent: TPanel
          Left = 0
          Top = 0
          Width = 480
          Height = 259
          Align = alClient
          TabOrder = 1
          ExplicitLeft = -1
        end
      end
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 420
    Width = 837
    Height = 41
    Align = alBottom
    TabOrder = 5
    ExplicitTop = 400
    ExplicitWidth = 624
    object edtFileName: TEdit
      AlignWithMargins = True
      Left = 11
      Top = 11
      Width = 406
      Height = 19
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alLeft
      TabOrder = 0
      Text = 'edtFileName'
      ExplicitHeight = 23
    end
    object btnClose: TButton
      AlignWithMargins = True
      Left = 773
      Top = 11
      Width = 53
      Height = 19
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alRight
      Caption = #36864#20986
      TabOrder = 1
      ExplicitLeft = 560
    end
    object btnOpenConfig: TButton
      AlignWithMargins = True
      Left = 660
      Top = 11
      Width = 93
      Height = 19
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alRight
      Caption = #25171#24320#37197#32622#25991#20214
      TabOrder = 2
      ExplicitLeft = 447
    end
  end
  object dlgOpenFile: TOpenDialog
    DefaultExt = '*.ini'
    Filter = 'INI '#25991#20214'(*.ini)|*.ini|JSON '#25991#20214'(*.json)|*.json|'#25152#26377#25991#20214'(*.*)|*.*'
    Left = 320
    Top = 304
  end
  object dlgBrowseDir: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = [fdoPickFolders]
    Left = 320
    Top = 193
  end
  object dlgSelectColor: TColorDialog
    Left = 488
    Top = 304
  end
  object popupINI: TPopupMenu
    Left = 104
    Top = 152
    object N1: TMenuItem
      Caption = #26032#24314#23646#24615
      object N5: TMenuItem
        Caption = #25991#26412#23646#24615
      end
      object N6: TMenuItem
        Caption = #25968#23383#23646#24615
      end
      object N7: TMenuItem
        Caption = #36335#24452#23646#24615
      end
      object N8: TMenuItem
        Caption = #24067#23572#23646#24615
      end
      object N9: TMenuItem
        Caption = #26085#26399#23646#24615
      end
      object N10: TMenuItem
        Caption = #39068#33394#23646#24615
      end
    end
    object N2: TMenuItem
      Caption = #32534#36753#23646#24615
    end
    object N3: TMenuItem
      Caption = #20462#25913#23646#24615#21517#31216
    end
    object N4: TMenuItem
      Caption = #21024#38500#23646#24615
    end
  end
  object popupJSON: TPopupMenu
    Left = 120
    Top = 256
    object MenuItem1: TMenuItem
      Caption = #26032#24314#23646#24615
      object MenuItem8: TMenuItem
        Caption = #23383#20307#23646#24615
      end
      object MenuItem9: TMenuItem
        Caption = #39068#33394#23646#24615
      end
      object MenuItem10: TMenuItem
        Caption = #25968#25454#24211#23646#24615
      end
      object MenuItem11: TMenuItem
        Caption = #21015#34920#23646#24615
      end
      object MenuItem12: TMenuItem
        Caption = #23545#35937#23646#24615
      end
      object MenuItem13: TMenuItem
        Caption = #25968#32452#23646#24615
      end
    end
    object MenuItem2: TMenuItem
      Caption = #32534#36753#23646#24615
    end
    object MenuItem3: TMenuItem
      Caption = #20462#25913#23646#24615#21517#31216
    end
    object MenuItem4: TMenuItem
      Caption = #21024#38500#23646#24615
    end
  end
end
