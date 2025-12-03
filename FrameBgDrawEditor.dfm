object FrameBgDrawEditor: TFrameBgDrawEditor
  Left = 0
  Top = 0
  Width = 640
  Height = 480
  TabOrder = 0
  object pnlBackground: TPanel
    Left = 0
    Top = 0
    Width = 640
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblBackground: TLabel
      Left = 16
      Top = 16
      Width = 60
      Height = 13
      Caption = '背景图路径:'
    end
    object edtBackground: TEdit
      Left = 88
      Top = 13
      Width = 465
      Height = 21
      TabOrder = 0
      OnChange = EditModified
    end
    object btnBrowse: TButton
      Left = 559
      Top = 11
      Width = 75
      Height = 25
      Caption = '浏览...'
      TabOrder = 1
      OnClick = btnBrowseClick
    end
  end
  object pnlElements: TPanel
    Left = 0
    Top = 50
    Width = 640
    Height = 430
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblElements: TLabel
      Left = 16
      Top = 6
      Width = 48
      Height = 13
      Caption = '元素列表:'
    end
    object lstElements: TListBox
      Left = 16
      Top = 24
      Width = 217
      Height = 393
      ItemHeight = 13
      TabOrder = 0
      OnClick = lstElementsClick
    end
    object pnlElementButtons: TPanel
      Left = 239
      Top = 24
      Width = 98
      Height = 393
      BevelOuter = bvNone
      TabOrder = 1
      object btnAddElement: TButton
        Left = 0
        Top = 0
        Width = 98
        Height = 25
        Caption = '添加元素'
        TabOrder = 0
        OnClick = btnAddElementClick
      end
      object btnEditElement: TButton
        Left = 0
        Top = 31
        Width = 98
        Height = 25
        Caption = '编辑元素'
        Enabled = False
        TabOrder = 1
        OnClick = btnEditElementClick
      end
      object btnDeleteElement: TButton
        Left = 0
        Top = 62
        Width = 98
        Height = 25
        Caption = '删除元素'
        Enabled = False
        TabOrder = 2
        OnClick = btnDeleteElementClick
      end
      object btnMoveUp: TButton
        Left = 0
        Top = 124
        Width = 98
        Height = 25
        Caption = '上移'
        Enabled = False
        TabOrder = 3
        OnClick = btnMoveUpClick
      end
      object btnMoveDown: TButton
        Left = 0
        Top = 155
        Width = 98
        Height = 25
        Caption = '下移'
        Enabled = False
        TabOrder = 4
        OnClick = btnMoveDownClick
      end
    end
    object pnlElementDetails: TPanel
      Left = 343
      Top = 24
      Width = 281
      Height = 393
      BevelOuter = bvNone
      TabOrder = 2
      Visible = False
      object lblElementType: TLabel
        Left = 16
        Top = 16
        Width = 48
        Height = 13
        Caption = '元素类型:'
      end
      object lblElementName: TLabel
        Left = 16
        Top = 56
        Width = 48
        Height = 13
        Caption = '元素名称:'
      end
      object lblX: TLabel
        Left = 16
        Top = 96
        Width = 10
        Height = 13
        Caption = 'X:'
      end
      object lblY: TLabel
        Left = 112
        Top = 96
        Width = 10
        Height = 13
        Caption = 'Y:'
      end
      object lblScale: TLabel
        Left = 208
        Top = 96
        Width = 36
        Height = 13
        Caption = '缩放比:'
      end
      object lblAdditional: TLabel
        Left = 16
        Top = 136
        Width = 48
        Height = 13
        Caption = '文本内容:'
      end
      object cmbElementType: TComboBox
        Left = 80
        Top = 13
        Width = 145
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        OnChange = cmbElementTypeChange
      end
      object edtElementName: TEdit
        Left = 80
        Top = 53
        Width = 185
        Height = 21
        TabOrder = 1
      end
      object edtX: TEdit
        Left = 32
        Top = 93
        Width = 65
        Height = 21
        TabOrder = 2
      end
      object edtY: TEdit
        Left = 128
        Top = 93
        Width = 65
        Height = 21
        TabOrder = 3
      end
      object edtScale: TEdit
        Left = 248
        Top = 93
        Width = 25
        Height = 21
        TabOrder = 4
        Text = '1.0'
      end
      object memAdditional: TMemo
        Left = 16
        Top = 155
        Width = 257
        Height = 193
        TabOrder = 5
      end
      object btnSaveElement: TButton
        Left = 98
        Top = 354
        Width = 75
        Height = 25
        Caption = '保存'
        TabOrder = 6
        OnClick = btnSaveElementClick
      end
      object btnCancelElement: TButton
        Left = 179
        Top = 354
        Width = 75
        Height = 25
        Caption = '取消'
        TabOrder = 7
        OnClick = btnCancelElementClick
      end
    end
  end
  object dlgOpenPicture: TOpenDialog
    Left = 416
    Top = 8
  end
end 