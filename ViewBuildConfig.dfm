object FrmBuildConfig: TFrmBuildConfig
  Left = 0
  Top = 0
  Caption = #37197#32622#29031#29256#32534#36753#22120
  ClientHeight = 616
  ClientWidth = 961
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Visible = True
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 0
    Top = 572
    Width = 961
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  object Splitter2: TSplitter
    Left = 917
    Top = 85
    Height = 487
    Align = alRight
  end
  object Splitter3: TSplitter
    Left = 300
    Top = 85
    Height = 487
  end
  object Splitter4: TSplitter
    Left = 0
    Top = 82
    Width = 961
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object pnlIni: TPanel
    Left = 0
    Top = 0
    Width = 961
    Height = 41
    Align = alTop
    Visible = True
    TabOrder = 0
    object btnAddText: TButton
      Left = 9
      Top = 7
      Width = 75
      Height = 25
      Caption = #28155#21152#25991#26412
      TabOrder = 0
      OnClick = btnAddTextClick
    end
    object btnAddNumber: TButton
      Left = 90
      Top = 7
      Width = 75
      Height = 25
      Caption = #28155#21152#25968#23383
      TabOrder = 1
      OnClick = btnAddNumberClick
    end
    object btnAddPath: TButton
      Left = 171
      Top = 7
      Width = 75
      Height = 25
      Caption = #28155#21152#36335#24452
      TabOrder = 2
      OnClick = btnAddPathClick
    end
    object btnAddBoolean: TButton
      Left = 252
      Top = 7
      Width = 75
      Height = 25
      Caption = #28155#21152#24067#23572
      TabOrder = 3
      OnClick = btnAddBooleanClick
    end
    object btnAddDate: TButton
      Left = 333
      Top = 7
      Width = 75
      Height = 25
      Caption = #28155#21152#26085#26399
      TabOrder = 4
      OnClick = btnAddDateClick
    end
    object btnAddColor: TButton
      Left = 414
      Top = 7
      Width = 75
      Height = 25
      Caption = #28155#21152#39068#33394
      TabOrder = 5
      OnClick = btnAddColorClick
    end
    object btnAddININetwork: TButton
      Left = 495
      Top = 7
      Width = 75
      Height = 25
      Caption = #28155#21152#32593#32476
      TabOrder = 6
      OnClick = btnAddININetworkClick
    end
    object btnAddINITime: TButton
      Left = 576
      Top = 7
      Width = 75
      Height = 25
      Caption = #28155#21152#26102#38388
      TabOrder = 7
      OnClick = btnAddINITimeClick
    end
    object btnAddINITemplate: TButton
      Left = 657
      Top = 7
      Width = 75
      Height = 25
      Caption = #28155#21152#27169#26495
      TabOrder = 8
      OnClick = btnAddINITemplateClick
    end
    object btnAddINIPlugin: TButton
      Left = 738
      Top = 7
      Width = 75
      Height = 25
      Caption = #28155#21152#25554#20214
      TabOrder = 9
      OnClick = btnAddINIPluginClick
    end
    object btnAddINILog: TButton
      Left = 819
      Top = 7
      Width = 75
      Height = 25
      Caption = #28155#21152#26085#24535
      TabOrder = 10
      OnClick = btnAddINILogClick
    end
  end
  object pnlJson: TPanel
    Left = 0
    Top = 41
    Width = 961
    Height = 41
    Align = alTop
    Visible = True
    TabOrder = 1
    object btnAddFont: TButton
      Left = 9
      Top = 8
      Width = 75
      Height = 25
      Caption = #28155#21152#23383#20307
      TabOrder = 0
      OnClick = btnAddFontClick
    end
    object btnAddColorComplex: TButton
      Left = 90
      Top = 8
      Width = 75
      Height = 25
      Caption = #28155#21152#39068#33394
      TabOrder = 1
      OnClick = btnAddColorComplexClick
    end
    object btnAddDatabase: TButton
      Left = 171
      Top = 8
      Width = 75
      Height = 25
      Caption = #28155#21152#25968#25454#24211
      TabOrder = 2
      OnClick = btnAddDatabaseClick
    end
    object btnAddList: TButton
      Left = 252
      Top = 8
      Width = 75
      Height = 25
      Caption = #28155#21152#21015#34920
      TabOrder = 3
      OnClick = btnAddListClick
    end
    object btnAddObject: TButton
      Left = 333
      Top = 8
      Width = 75
      Height = 25
      Caption = #28155#21152#23545#35937
      TabOrder = 4
      OnClick = btnAddObjectClick
    end
    object btnAddArray: TButton
      Left = 414
      Top = 8
      Width = 75
      Height = 25
      Caption = #28155#21152#25968#32452
      TabOrder = 5
      OnClick = btnAddArrayClick
    end
    object btnAddAPI: TButton
      Left = 495
      Top = 8
      Width = 75
      Height = 25
      Caption = #28155#21152#63009#80054
      TabOrder = 6
      OnClick = btnAddAPIClick
    end
    object btnAddRootNode: TButton
      Left = 576
      Top = 8
      Width = 75
      Height = 25
      Caption = #22686#21152#26681#33410#28857
      TabOrder = 7
      OnClick = btnAddRootNodeClick
    end
    object btnAddJsonSecurity: TButton
      Left = 657
      Top = 8
      Width = 75
      Height = 25
      Caption = #28155#21152#23433#20840
      TabOrder = 8
      OnClick = btnAddJsonSecurityClick
    end
    object btnAddJsonAI: TButton
      Left = 738
      Top = 8
      Width = 75
      Height = 25
      Caption = #28155#21152#20154#24037#26234#33021
      TabOrder = 9
      OnClick = btnAddJsonAIClick
    end
    object btnAddJsonModule: TButton
      Left = 819
      Top = 8
      Width = 75
      Height = 25
      Caption = #28155#21152#27169#22359
      TabOrder = 10
      OnClick = btnAddJsonModuleClick
    end
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 85
    Width = 300
    Height = 487
    Align = alLeft
    Visible = True
    TabOrder = 2
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 300
      Height = 485
      Align = alLeft
      TabOrder = 0
      object sgINI: TStringGrid
        Left = 1
        Top = 1
        Width = 298
        Height = 112
        Align = alTop
        ColCount = 3
        DefaultRowHeight = 24
        FixedCols = 0
        FixedRows = 1
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goRowSelect]
        PopupMenu = popupINI
        RowCount = 2
        TabOrder = 0
        OnDblClick = sgINIDblClick
        OnSelectCell = sgINISelectCell
        ColWidths = (
          100
          120
          200)        
      end
      object Panel2: TPanel
        Left = 1
        Top = 113
        Width = 300
        Height = 371
        Align = alLeft
        TabOrder = 1
        object Panel3: TPanel
          Left = 1
          Top = 1
          Width = 300
          Height = 369
          Align = alLeft
          TabOrder = 0
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
            Height = 323
            Align = alClient
            DragMode = dmAutomatic
            Indent = 19
            PopupMenu = popupJSON
            TabOrder = 0
            OnChange = tvJSONChange
            OnDblClick = tvJSONDblClick
            Items.NodeData = {
              0301000000280000000000000000000000FFFFFFFFFFFFFFFF00000000000000
              0005000000010400000000000000736F6D6500}
            Items.Data = {
              0300000001000000FFFFFFFFFFFFFFFFFFFFFFFF00000000000000000400736F
              6D65}
          end
          object pnlEditing: TPanel
            Left = 1
            Top = 4
            Width = 298
            Height = 41
            Align = alTop
            Visible = False
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
              OnClick = btnUpdateClick
            end
          end
        end
      end
    end
  end
  object pnlRigth: TPanel
    Left = 920
    Top = 85
    Width = 41
    Height = 487
    Align = alRight
    TabOrder = 3
    Visible = False
  end
  object pnlContent: TPanel
    Left = 303
    Top = 85
    Width = 614
    Height = 487
    Align = alClient
    Visible = True
    TabOrder = 4
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 612
      Height = 485
      ActivePage = tsINI
      Align = alClient
      TabOrder = 0
      object tsINI: TTabSheet
        Caption = 'INI'#20869#23481
        object Memo1: TMemo
          Left = 0
          Top = 0
          Width = 604
          Height = 455
          Align = alClient
          Lines.Strings = (
            '')
          ScrollBars = ssBoth
          TabOrder = 0
        end
      end
      object tsJSON: TTabSheet
        Caption = 'JSON'#20869#23481
        ImageIndex = 1
        object Memo2: TMemo
          Left = 0
          Top = 0
          Width = 604
          Height = 455
          Align = alClient
          Lines.Strings = (
            '')
          ScrollBars = ssBoth
          TabOrder = 0
        end
      end
      object tsEditor: TTabSheet
        Caption = #22797#26434#23646#24615#32534#36753#22120
        ImageIndex = 2
        object Panel4: TPanel
          Left = 0
          Top = 414
          Width = 604
          Height = 41
          Align = alBottom
          TabOrder = 0
          object btnSave: TButton
            AlignWithMargins = True
            Left = 184
            Top = 14
            Width = 91
            Height = 19
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 10
            Caption = #20445#23384#21040#25991#20214
            TabOrder = 0
            OnClick = btnSaveClick
          end
        end
        object pnlEditorContent: TPanel
          Left = 0
          Top = 0
          Width = 604
          Height = 414
          Align = alClient
          TabOrder = 1
        end
      end
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 575
    Width = 961
    Height = 41
    Align = alBottom
    Visible = True
    TabOrder = 5
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
      Text = ''
    end
    object btnClose: TButton
      AlignWithMargins = True
      Left = 897
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
      OnClick = btnCloseClick
    end
    object btnOpenConfig: TButton
      AlignWithMargins = True
      Left = 784
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
      OnClick = btnOpenConfigClick
    end
  end
  object dlgOpenFile: TOpenDialog
    DefaultExt = '*.ini'
    Filter = 'INI '#25991#20214'(*.ini)|*.ini|JSON '#25991#20214'(*.json)|*.json|'#25152#26377#25991#20214'(*.*)|*.*'
    Left = 496
    Top = 8
  end
  object dlgBrowseDir: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = [fdoPickFolders]
    Left = 552
    Top = 9
  end
  object dlgSelectColor: TColorDialog
    Left = 608
    Top = 8
  end
  object popupINI: TPopupMenu
    Left = 104
    Top = 152
    object N1: TMenuItem
      Caption = #26032#24314#23646#24615
      object N5: TMenuItem
        Caption = #25991#26412#23646#24615
        OnClick = btnAddTextClick
      end
      object N6: TMenuItem
        Caption = #25968#23383#23646#24615
        OnClick = btnAddNumberClick
      end
      object N7: TMenuItem
        Caption = #36335#24452#23646#24615
        OnClick = btnAddPathClick
      end
      object N8: TMenuItem
        Caption = #24067#23572#23646#24615
        OnClick = btnAddBooleanClick
      end
      object N9: TMenuItem
        Caption = #26085#26399#23646#24615
        OnClick = btnAddDateClick
      end
      object N10: TMenuItem
        Caption = #39068#33394#23646#24615
        OnClick = btnAddColorClick
      end
    end
    object N2: TMenuItem
      Caption = #32534#36753#23646#24615
      OnClick = EditINIPropertyClick
      Enabled = False
    end
    object N3: TMenuItem
      Caption = #20462#25913#23646#24615#21517#31216
      OnClick = RenameINIPropertyClick
      Enabled = False
    end
    object N4: TMenuItem
      Caption = #21024#38500#23646#24615
      OnClick = DeleteINIPropertyClick
      Enabled = False
    end
  end
  object popupJSON: TPopupMenu
    Left = 120
    Top = 256
    object MenuItem1: TMenuItem
      Caption = #26032#24314#23646#24615
      object MenuItem8: TMenuItem
        Caption = #23383#20307#23646#24615
        OnClick = btnAddFontClick
      end
      object MenuItem9: TMenuItem
        Caption = #39068#33394#23646#24615
        OnClick = btnAddColorComplexClick
      end
      object MenuItem10: TMenuItem
        Caption = #25968#25454#24211#23646#24615
        OnClick = btnAddDatabaseClick
      end
      object MenuItem11: TMenuItem
        Caption = #21015#34920#23646#24615
        OnClick = btnAddListClick
      end
      object MenuItem12: TMenuItem
        Caption = #23545#35937#23646#24615
        OnClick = btnAddObjectClick
      end
      object MenuItem13: TMenuItem
        Caption = #25968#32452#23646#24615
        OnClick = btnAddArrayClick
      end
    end
    object MenuItem2: TMenuItem
      Caption = #32534#36753#23646#24615
      OnClick = EditJSONPropertyClick
      Enabled = False
    end
    object MenuItem3: TMenuItem
      Caption = #20462#25913#23646#24615#21517#31216
      OnClick = RenameJSONPropertyClick
      Enabled = False
    end
    object MenuItem4: TMenuItem
      Caption = #21024#38500#23646#24615
      OnClick = DeleteJSONPropertyClick
      Enabled = False
    end
  end
end
