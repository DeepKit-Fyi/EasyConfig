object TComplexEditorFrame: TComplexEditorFrame
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 41
    Align = alTop
    TabOrder = 0
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 199
    Width = 320
    Height = 41
    Align = alBottom
    TabOrder = 1
    object btnSave: TButton
      Left = 152
      Top = 8
      Width = 75
      Height = 25
      Caption = '保存'
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 233
      Top = 8
      Width = 75
      Height = 25
      Caption = '取消'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
end
object TFontEditorFrame: TFontEditorFrame
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 41
    Align = alTop
    TabOrder = 0
  end
  object pnlContent: TPanel
    Left = 0
    Top = 41
    Width = 320
    Height = 158
    Align = alClient
    TabOrder = 1
    object lblFontName: TLabel
      Left = 16
      Top = 16
      Width = 48
      Height = 13
      Caption = '字体名称'
    end
    object lblFontSize: TLabel
      Left = 16
      Top = 48
      Width = 48
      Height = 13
      Caption = '字体大小'
    end
    object lblFontStyle: TLabel
      Left = 16
      Top = 80
      Width = 48
      Height = 13
      Caption = '字体样式'
    end
    object cmbFontName: TComboBox
      Left = 80
      Top = 13
      Width = 225
      Height = 21
      Style = csDropDownList
      TabOrder = 0
    end
    object edtFontSize: TEdit
      Left = 80
      Top = 45
      Width = 225
      Height = 21
      TabOrder = 1
    end
    object chkBold: TCheckBox
      Left = 80
      Top = 79
      Width = 97
      Height = 17
      Caption = '粗体'
      TabOrder = 2
    end
    object chkItalic: TCheckBox
      Left = 183
      Top = 79
      Width = 97
      Height = 17
      Caption = '斜体'
      TabOrder = 3
    end
    object chkUnderline: TCheckBox
      Left = 286
      Top = 79
      Width = 97
      Height = 17
      Caption = '下划线'
      TabOrder = 4
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 199
    Width = 320
    Height = 41
    Align = alBottom
    TabOrder = 2
    object btnSave: TButton
      Left = 152
      Top = 8
      Width = 75
      Height = 25
      Caption = '保存'
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 233
      Top = 8
      Width = 75
      Height = 25
      Caption = '取消'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
end
object TColorEditorFrame: TColorEditorFrame
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 41
    Align = alTop
    TabOrder = 0
  end
  object pnlContent: TPanel
    Left = 0
    Top = 41
    Width = 320
    Height = 158
    Align = alClient
    TabOrder = 1
    object lblColor: TLabel
      Left = 16
      Top = 16
      Width = 48
      Height = 13
      Caption = '颜色'
    end
    object pnlColor: TPanel
      Left = 80
      Top = 13
      Width = 225
      Height = 25
      TabOrder = 0
    end
    object btnSelectColor: TButton
      Left = 80
      Top = 44
      Width = 225
      Height = 25
      Caption = '选择颜色'
      TabOrder = 1
      OnClick = btnSelectColorClick
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 199
    Width = 320
    Height = 41
    Align = alBottom
    TabOrder = 2
    object btnSave: TButton
      Left = 152
      Top = 8
      Width = 75
      Height = 25
      Caption = '保存'
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 233
      Top = 8
      Width = 75
      Height = 25
      Caption = '取消'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  object dlgColor: TColorDialog
    Left = 24
    Top = 192
  end
end
object TDatabaseEditorFrame: TDatabaseEditorFrame
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 41
    Align = alTop
    TabOrder = 0
  end
  object pnlContent: TPanel
    Left = 0
    Top = 41
    Width = 320
    Height = 158
    Align = alClient
    TabOrder = 1
    object lblHost: TLabel
      Left = 16
      Top = 16
      Width = 48
      Height = 13
      Caption = '主机'
    end
    object lblPort: TLabel
      Left = 16
      Top = 48
      Width = 48
      Height = 13
      Caption = '端口'
    end
    object lblUsername: TLabel
      Left = 16
      Top = 80
      Width = 48
      Height = 13
      Caption = '用户名'
    end
    object lblPassword: TLabel
      Left = 16
      Top = 112
      Width = 48
      Height = 13
      Caption = '密码'
    end
    object lblDatabase: TLabel
      Left = 16
      Top = 144
      Width = 48
      Height = 13
      Caption = '数据库'
    end
    object edtHost: TEdit
      Left = 80
      Top = 13
      Width = 225
      Height = 21
      TabOrder = 0
    end
    object edtPort: TEdit
      Left = 80
      Top = 45
      Width = 225
      Height = 21
      TabOrder = 1
    end
    object edtUsername: TEdit
      Left = 80
      Top = 77
      Width = 225
      Height = 21
      TabOrder = 2
    end
    object edtPassword: TEdit
      Left = 80
      Top = 109
      Width = 225
      Height = 21
      PasswordChar = '*'
      TabOrder = 3
    end
    object edtDatabase: TEdit
      Left = 80
      Top = 141
      Width = 225
      Height = 21
      TabOrder = 4
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 199
    Width = 320
    Height = 41
    Align = alBottom
    TabOrder = 2
    object btnSave: TButton
      Left = 152
      Top = 8
      Width = 75
      Height = 25
      Caption = '保存'
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 233
      Top = 8
      Width = 75
      Height = 25
      Caption = '取消'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
end
object TListEditorFrame: TListEditorFrame
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 41
    Align = alTop
    TabOrder = 0
  end
  object pnlContent: TPanel
    Left = 0
    Top = 41
    Width = 320
    Height = 158
    Align = alClient
    TabOrder = 1
    object lstItems: TListBox
      Left = 16
      Top = 13
      Width = 289
      Height = 132
      ItemHeight = 13
      TabOrder = 0
    end
    object btnAdd: TButton
      Left = 16
      Top = 151
      Width = 75
      Height = 25
      Caption = '添加'
      TabOrder = 1
      OnClick = btnAddClick
    end
    object btnDelete: TButton
      Left = 97
      Top = 151
      Width = 75
      Height = 25
      Caption = '删除'
      TabOrder = 2
      OnClick = btnDeleteClick
    end
    object btnEdit: TButton
      Left = 178
      Top = 151
      Width = 75
      Height = 25
      Caption = '编辑'
      TabOrder = 3
      OnClick = btnEditClick
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 199
    Width = 320
    Height = 41
    Align = alBottom
    TabOrder = 2
    object btnSave: TButton
      Left = 152
      Top = 8
      Width = 75
      Height = 25
      Caption = '保存'
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 233
      Top = 8
      Width = 75
      Height = 25
      Caption = '取消'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
end
object TObjectEditorFrame: TObjectEditorFrame
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 41
    Align = alTop
    TabOrder = 0
  end
  object pnlContent: TPanel
    Left = 0
    Top = 41
    Width = 320
    Height = 158
    Align = alClient
    TabOrder = 1
    object tvProperties: TTreeView
      Left = 16
      Top = 13
      Width = 289
      Height = 132
      Indent = 19
      TabOrder = 0
    end
    object btnAdd: TButton
      Left = 16
      Top = 151
      Width = 75
      Height = 25
      Caption = '添加'
      TabOrder = 1
      OnClick = btnAddClick
    end
    object btnDelete: TButton
      Left = 97
      Top = 151
      Width = 75
      Height = 25
      Caption = '删除'
      TabOrder = 2
      OnClick = btnDeleteClick
    end
    object btnEdit: TButton
      Left = 178
      Top = 151
      Width = 75
      Height = 25
      Caption = '编辑'
      TabOrder = 3
      OnClick = btnEditClick
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 199
    Width = 320
    Height = 41
    Align = alBottom
    TabOrder = 2
    object btnSave: TButton
      Left = 152
      Top = 8
      Width = 75
      Height = 25
      Caption = '保存'
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 233
      Top = 8
      Width = 75
      Height = 25
      Caption = '取消'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
end
object TArrayEditorFrame: TArrayEditorFrame
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 41
    Align = alTop
    TabOrder = 0
  end
  object pnlContent: TPanel
    Left = 0
    Top = 41
    Width = 320
    Height = 158
    Align = alClient
    TabOrder = 1
    object lstItems: TListBox
      Left = 16
      Top = 13
      Width = 289
      Height = 132
      ItemHeight = 13
      TabOrder = 0
    end
    object btnAdd: TButton
      Left = 16
      Top = 151
      Width = 75
      Height = 25
      Caption = '添加'
      TabOrder = 1
      OnClick = btnAddClick
    end
    object btnDelete: TButton
      Left = 97
      Top = 151
      Width = 75
      Height = 25
      Caption = '删除'
      TabOrder = 2
      OnClick = btnDeleteClick
    end
    object btnEdit: TButton
      Left = 178
      Top = 151
      Width = 75
      Height = 25
      Caption = '编辑'
      TabOrder = 3
      OnClick = btnEditClick
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 199
    Width = 320
    Height = 41
    Align = alBottom
    TabOrder = 2
    object btnSave: TButton
      Left = 152
      Top = 8
      Width = 75
      Height = 25
      Caption = '保存'
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 233
      Top = 8
      Width = 75
      Height = 25
      Caption = '取消'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
end 