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
      Caption = '淇濆瓨'
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 233
      Top = 8
      Width = 75
      Height = 25
      Caption = '鍙栨秷'
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
      Caption = '瀛椾綋鍚嶇О'
    end
    object lblFontSize: TLabel
      Left = 16
      Top = 48
      Width = 48
      Height = 13
      Caption = '瀛椾綋澶у皬'
    end
    object lblFontStyle: TLabel
      Left = 16
      Top = 80
      Width = 48
      Height = 13
      Caption = '瀛椾綋鏍峰紡'
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
      Caption = '绮椾綋'
      TabOrder = 2
    end
    object chkItalic: TCheckBox
      Left = 183
      Top = 79
      Width = 97
      Height = 17
      Caption = '鏂滀綋'
      TabOrder = 3
    end
    object chkUnderline: TCheckBox
      Left = 286
      Top = 79
      Width = 97
      Height = 17
      Caption = '涓嬪垝绾?
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
      Caption = '淇濆瓨'
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 233
      Top = 8
      Width = 75
      Height = 25
      Caption = '鍙栨秷'
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
      Caption = '棰滆壊'
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
      Caption = '閫夋嫨棰滆壊'
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
      Caption = '淇濆瓨'
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 233
      Top = 8
      Width = 75
      Height = 25
      Caption = '鍙栨秷'
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
      Caption = '涓绘満'
    end
    object lblPort: TLabel
      Left = 16
      Top = 48
      Width = 48
      Height = 13
      Caption = '绔彛'
    end
    object lblUsername: TLabel
      Left = 16
      Top = 80
      Width = 48
      Height = 13
      Caption = '鐢ㄦ埛鍚?
    end
    object lblPassword: TLabel
      Left = 16
      Top = 112
      Width = 48
      Height = 13
      Caption = '瀵嗙爜'
    end
    object lblDatabase: TLabel
      Left = 16
      Top = 144
      Width = 48
      Height = 13
      Caption = '鏁版嵁搴?
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
      Caption = '淇濆瓨'
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 233
      Top = 8
      Width = 75
      Height = 25
      Caption = '鍙栨秷'
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
      Caption = '娣诲姞'
      TabOrder = 1
      OnClick = btnAddClick
    end
    object btnDelete: TButton
      Left = 97
      Top = 151
      Width = 75
      Height = 25
      Caption = '鍒犻櫎'
      TabOrder = 2
      OnClick = btnDeleteClick
    end
    object btnEdit: TButton
      Left = 178
      Top = 151
      Width = 75
      Height = 25
      Caption = '缂栬緫'
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
      Caption = '淇濆瓨'
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 233
      Top = 8
      Width = 75
      Height = 25
      Caption = '鍙栨秷'
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
      Caption = '娣诲姞'
      TabOrder = 1
      OnClick = btnAddClick
    end
    object btnDelete: TButton
      Left = 97
      Top = 151
      Width = 75
      Height = 25
      Caption = '鍒犻櫎'
      TabOrder = 2
      OnClick = btnDeleteClick
    end
    object btnEdit: TButton
      Left = 178
      Top = 151
      Width = 75
      Height = 25
      Caption = '缂栬緫'
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
      Caption = '淇濆瓨'
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 233
      Top = 8
      Width = 75
      Height = 25
      Caption = '鍙栨秷'
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
      Caption = '娣诲姞'
      TabOrder = 1
      OnClick = btnAddClick
    end
    object btnDelete: TButton
      Left = 97
      Top = 151
      Width = 75
      Height = 25
      Caption = '鍒犻櫎'
      TabOrder = 2
      OnClick = btnDeleteClick
    end
    object btnEdit: TButton
      Left = 178
      Top = 151
      Width = 75
      Height = 25
      Caption = '缂栬緫'
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
      Caption = '淇濆瓨'
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 233
      Top = 8
      Width = 75
      Height = 25
      Caption = '鍙栨秷'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
end 