object ViewMain: TViewMain
  Left = 0
  Top = 0
  Caption = #37197#32622#32534#36753#22120
  ClientHeight = 600
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = mnuMain
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 429
    Width = 900
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitLeft = 8
    ExplicitTop = 8
    ExplicitWidth = 250
  end
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 429
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnlTop: TPanel
      Left = 0
      Top = 0
      Width = 900
      Height = 41
      Align = alTop
      TabOrder = 0
      object btnOpen: TButton
        Left = 16
        Top = 8
        Width = 75
        Height = 25
        Caption = #25171#24320
        TabOrder = 0
        OnClick = btnOpenClick
      end
      object btnSave: TButton
        Left = 97
        Top = 8
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 1
        OnClick = btnSaveClick
      end
      object btnNew: TButton
        Left = 178
        Top = 8
        Width = 75
        Height = 25
        Caption = #26032#24314
        TabOrder = 2
        OnClick = btnNewClick
      end
      object btnDelete: TButton
        Left = 259
        Top = 8
        Width = 75
        Height = 25
        Caption = #21024#38500
        TabOrder = 3
        OnClick = btnDeleteClick
      end
      object btnRefresh: TButton
        Left = 340
        Top = 8
        Width = 75
        Height = 25
        Caption = #21047#26032
        TabOrder = 4
        OnClick = btnRefreshClick
      end
      object btnLoadTemplate: TButton
        Left = 421
        Top = 8
        Width = 75
        Height = 25
        Caption = #21152#36733#27169#26495
        TabOrder = 5
        OnClick = btnLoadTemplateClick
      end
    end
    object pnlLeft: TPanel
      Left = 0
      Top = 41
      Width = 250
      Height = 388
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object Splitter3: TSplitter
        Left = 0
        Top = 385
        Width = 250
        Height = 3
        Cursor = crVSplit
        Align = alBottom
        ExplicitTop = 311
        ExplicitWidth = 185
      end
      object tvConfig: TTreeView
        Left = 0
        Top = 0
        Width = 250
        Height = 385
        Align = alClient
        Indent = 19
        PopupMenu = pmTree
        TabOrder = 0
        OnChange = tvConfigChange
        OnDblClick = tvConfigDblClick
      end
    end
    object pnlClient: TPanel
      Left = 250
      Top = 41
      Width = 650
      Height = 388
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      object Splitter4: TSplitter
        Left = 0
        Top = 289
        Width = 650
        Height = 3
        Cursor = crVSplit
        Align = alTop
        ExplicitWidth = 185
      end
      object pcEditors: TPageControl
        Left = 0
        Top = 0
        Width = 650
        Height = 289
        ActivePage = tsWelcome
        Align = alTop
        TabOrder = 0
        OnChange = pcEditorsChange
        object tsWelcome: TTabSheet
          Caption = #27426#36814
          object Label1: TLabel
            Left = 24
            Top = 24
            Width = 200
            Height = 25
            Caption = #27426#36814#20351#29992#37197#32622#32534#36753#22120#65281
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -19
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object Label2: TLabel
            Left = 24
            Top = 72
            Width = 688
            Height = 17
            Caption = #35831#36873#25321#19968#20010#37197#32622#25991#20214#65292#25110#32773#21019#24314#19968#20010#26032#30340#37197#32622#25991#20214#12290#24744#21487#20197#36890#36807#33756#21333#25110#24037#20855#26639#19978#30340#25353#38062#25191#34892#25805#20316#12290
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
        end
        object TabSheet1: TTabSheet
          Caption = 'INI'#35774#32622
          ImageIndex = 1
          object IniValueListEditor: TValueListEditor
            Left = 0
            Top = 0
            Width = 642
            Height = 261
            Align = alClient
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goTabs, goAlwaysShowEditor, goThumbTracking]
            TabOrder = 0
            TitleCaptions.Strings = (
              #38190#21517
              #20540)
            OnDblClick = ValueListEditorDblClick
            OnDrawCell = ValueListEditorDrawCell
            OnValidate = ValueListEditorValidate
            ColWidths = (
              150
              483)
          end
        end
      end
    end
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 581
    Width = 900
    Height = 19
    Panels = <
      item
        Width = 200
      end
      item
        Width = 400
      end
      item
        Width = 50
      end>
  end
  object Panel2: TPanel
    Left = 0
    Top = 432
    Width = 900
    Height = 149
    Align = alBottom
    TabOrder = 2
    object splMain: TSplitter
      Left = 256
      Top = 1
      Height = 147
      ExplicitLeft = 200
      ExplicitTop = 40
      ExplicitHeight = 541
    end
    object FileListBox1: TFileListBox
      Left = 1
      Top = 1
      Width = 255
      Height = 147
      Align = alLeft
      ItemHeight = 13
      Mask = '*.ini'
      TabOrder = 0
      OnDblClick = FileListBox1DblClick
    end
    object meoDebug: TMemo
      Left = 259
      Top = 1
      Width = 640
      Height = 147
      Align = alClient
      ScrollBars = ssBoth
      TabOrder = 1
    end
  end
  object pmTree: TPopupMenu
    Left = 80
    Top = 296
    object pmTreeOpen: TMenuItem
      Caption = #25171#24320
      OnClick = pmTreeOpenClick
    end
    object pmTreeNew: TMenuItem
      Caption = #26032#24314
      OnClick = pmTreeNewClick
    end
    object pmTreeDelete: TMenuItem
      Caption = #21024#38500
      OnClick = pmTreeDeleteClick
    end
    object pmTreeRename: TMenuItem
      Caption = #37325#21629#21517
      OnClick = pmTreeRenameClick
    end
  end
  object pmEditor: TPopupMenu
    Left = 376
    Top = 336
    object pmEditorSave: TMenuItem
      Caption = #20445#23384
      OnClick = pmEditorSaveClick
    end
    object pmEditorClose: TMenuItem
      Caption = #20851#38381
      OnClick = pmEditorCloseClick
    end
    object pmEditorValidate: TMenuItem
      Caption = #39564#35777
      OnClick = pmEditorValidateClick
    end
  end
  object dlgOpen: TOpenDialog
    Filter = 'INI'#37197#32622#25991#20214' (*.ini)|*.ini|JSON'#37197#32622#25991#20214' (*.json)|*.json|'#25152#26377#25991#20214'(*.*)|*.*'
    Left = 448
    Top = 272
  end
  object dlgSave: TSaveDialog
    Filter = 'INI'#37197#32622#25991#20214' (*.ini)|*.ini|JSON'#37197#32622#25991#20214' (*.json)|*.json|'#25152#26377#25991#20214'(*.*)|*.*'
    Left = 448
    Top = 336
  end
  object ilIcons: TImageList
    Left = 376
    Top = 272
  end
  object mnuMain: TMainMenu
    Left = 80
    Top = 232
    object mnuFile: TMenuItem
      Caption = #25991#20214'(&F)'
      object mnuOpen: TMenuItem
        Caption = #25171#24320'(&O)...'
        ShortCut = 16463
        OnClick = mnuOpenClick
      end
      object mnuSave: TMenuItem
        Caption = #20445#23384'(&S)'
        ShortCut = 16467
        OnClick = mnuSaveClick
      end
      object mnuSaveAs: TMenuItem
        Caption = #21478#23384#20026'(&A)...'
        OnClick = mnuSaveAsClick
      end
      object mnuSep1: TMenuItem
        Caption = '-'
      end
      object mnuExit: TMenuItem
        Caption = #36864#20986'(&X)'
        OnClick = mnuExitClick
      end
    end
    object mnuEdit: TMenuItem
      Caption = #32534#36753'(&E)'
      object mnuCut: TMenuItem
        Caption = #21098#20999'(&T)'
        ShortCut = 16472
      end
      object mnuCopy: TMenuItem
        Caption = #22797#21046'(&C)'
        ShortCut = 16451
      end
      object mnuPaste: TMenuItem
        Caption = #31896#36148'(&P)'
        ShortCut = 16470
      end
    end
    object mnuTools: TMenuItem
      Caption = #24037#20855'(&T)'
      object mnuValidate: TMenuItem
        Caption = #39564#35777'(&V)'
        ShortCut = 16470
        OnClick = btnValidateClick
      end
      object mnuToolsUTF8Converter: TMenuItem
        Caption = 'UTF-8'#36716#25442#22120
        OnClick = mnuToolsUTF8ConverterClick
      end
    end
    object mnuHelp: TMenuItem
      Caption = #24110#21161'(&H)'
      object mnuAbout: TMenuItem
        Caption = #20851#20110'(&A)...'
        OnClick = mnuAboutClick
      end
    end
  end
end
