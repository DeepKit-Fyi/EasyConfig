object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = '配置编辑器测试'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlToolbar: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 41
    Align = alTop
    TabOrder = 0
    object btnNewBgDraw: TButton
      Left = 16
      Top = 8
      Width = 97
      Height = 25
      Caption = '新建背景画面'
      TabOrder = 0
      OnClick = btnNewBgDrawClick
    end
    object btnNewVideoClip: TButton
      Left = 119
      Top = 8
      Width = 97
      Height = 25
      Caption = '新建视频片段'
      TabOrder = 1
      OnClick = btnNewVideoClipClick
    end
    object btnNewVideo: TButton
      Left = 222
      Top = 8
      Width = 97
      Height = 25
      Caption = '新建完整视频'
      TabOrder = 2
      OnClick = btnNewVideoClick
    end
    object btnNewDateTimeRange: TButton
      Left = 325
      Top = 8
      Width = 97
      Height = 25
      Caption = '新建日期范围'
      TabOrder = 3
      OnClick = btnNewDateTimeRangeClick
    end
    object btnNewKeyValueDict: TButton
      Left = 428
      Top = 8
      Width = 97
      Height = 25
      Caption = '新建键值字典'
      TabOrder = 4
      OnClick = btnNewKeyValueDictClick
    end
    object btnNewUrlConfig: TButton
      Left = 531
      Top = 8
      Width = 97
      Height = 25
      Caption = '新建URL配置'
      TabOrder = 5
      OnClick = btnNewUrlConfigClick
    end
    object btnNewNetConfig: TButton
      Left = 16
      Top = 8
      Width = 97
      Height = 25
      Caption = '新建网络配置'
      TabOrder = 6
      OnClick = btnNewNetConfigClick
      Visible = False
    end
    object btnNewGeoLocation: TButton
      Left = 16
      Top = 8
      Width = 97
      Height = 25
      Caption = '新建地理位置'
      TabOrder = 7
      OnClick = btnNewGeoLocationClick
      Visible = False
    end
    object btnNewEncrypt: TButton
      Left = 16
      Top = 8
      Width = 97
      Height = 25
      Caption = '新建加密设置'
      TabOrder = 8
      OnClick = btnNewEncryptClick
      Visible = False
    end
  end
  object pgcMain: TPageControl
    Left = 0
    Top = 41
    Width = 800
    Height = 559
    ActivePage = tsConfigFile
    Align = alClient
    TabOrder = 1
    object tsConfigFile: TTabSheet
      Caption = '配置项'
      object splVert: TSplitter
        Left = 300
        Top = 0
        Height = 531
        ExplicitLeft = 401
        ExplicitTop = 264
        ExplicitHeight = 100
      end
      object memConfigJson: TMemo
        Left = 303
        Top = 0
        Width = 489
        Height = 531
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
      object pnlConfigEditor: TPanel
        Left = 0
        Top = 0
        Width = 300
        Height = 531
        Align = alLeft
        TabOrder = 1
        object lblSelectedItem: TLabel
          Left = 16
          Top = 16
          Width = 64
          Height = 13
          Caption = '当前选中: 无'
        end
        object lstConfigItems: TListBox
          Left = 16
          Top = 35
          Width = 265
          Height = 442
          ItemHeight = 13
          TabOrder = 0
          OnClick = lstConfigItemsClick
        end
        object pnlButtons: TPanel
          Left = 1
          Top = 490
          Width = 298
          Height = 40
          Align = alBottom
          TabOrder = 1
          object btnEditItem: TButton
            Left = 54
            Top = 7
            Width = 75
            Height = 25
            Caption = '编辑'
            TabOrder = 0
            OnClick = btnEditItemClick
          end
          object btnRemoveItem: TButton
            Left = 168
            Top = 7
            Width = 75
            Height = 25
            Caption = '删除'
            TabOrder = 1
            OnClick = btnRemoveItemClick
          end
        end
      end
      object btnLoadConfig: TButton
        Left = 424
        Top = 537
        Width = 105
        Height = 25
        Caption = '加载配置...'
        TabOrder = 2
        OnClick = btnLoadConfigClick
      end
      object btnSaveConfig: TButton
        Left = 568
        Top = 537
        Width = 105
        Height = 25
        Caption = '保存配置...'
        TabOrder = 3
        OnClick = btnSaveConfigClick
      end
    end
    object tsPropEditor: TTabSheet
      Caption = '属性编辑'
      ImageIndex = 1
      object pnlEditor: TPanel
        Left = 0
        Top = 0
        Width = 792
        Height = 531
        Align = alClient
        TabOrder = 0
      end
      object btnSave: TButton
        Left = 568
        Top = 537
        Width = 75
        Height = 25
        Caption = '保存'
        TabOrder = 1
        OnClick = btnSaveClick
      end
      object btnCancel: TButton
        Left = 664
        Top = 537
        Width = 75
        Height = 25
        Caption = '取消'
        TabOrder = 2
        OnClick = btnCancelClick
      end
    end
  end
  object dlgOpenConfig: TOpenDialog
    Left = 328
    Top = 64
  end
  object dlgSaveConfig: TSaveDialog
    Left = 432
    Top = 64
  end
end 