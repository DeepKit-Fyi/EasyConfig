object FrameDBEditor: TFrameDBEditor
  Left = 0
  Top = 0
  ClientHeight = 311
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object pnlDBEditor: TPanel
    Left = 0
    Top = 0
    Width = 434
    Height = 311
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 428
    ExplicitHeight = 294
    object lblDBType: TLabel
      Left = 16
      Top = 16
      Width = 68
      Height = 15
      Caption = #25968#25454#24211#31867#22411':'
    end
    object lblServer: TLabel
      Left = 16
      Top = 56
      Width = 68
      Height = 15
      Caption = #26381#21153#22120#22320#22336':'
    end
    object lblPort: TLabel
      Left = 16
      Top = 96
      Width = 42
      Height = 15
      Caption = #31471#21475#21495':'
    end
    object lblDatabase: TLabel
      Left = 16
      Top = 136
      Width = 68
      Height = 15
      Caption = #25968#25454#24211#21517#31216':'
    end
    object lblUsername: TLabel
      Left = 16
      Top = 176
      Width = 42
      Height = 15
      Caption = #29992#25143#21517':'
    end
    object lblPassword: TLabel
      Left = 16
      Top = 216
      Width = 29
      Height = 15
      Caption = #23494#30721':'
    end
    object cmbDBType: TComboBox
      Left = 96
      Top = 13
      Width = 145
      Height = 23
      Style = csDropDownList
      TabOrder = 0
      OnChange = cmbDBTypeChange
    end
    object edtServer: TEdit
      Left = 96
      Top = 53
      Width = 321
      Height = 23
      TabOrder = 1
      Text = 'localhost'
    end
    object edtPort: TEdit
      Left = 96
      Top = 93
      Width = 121
      Height = 23
      TabOrder = 2
      Text = '1433'
    end
    object edtDatabase: TEdit
      Left = 96
      Top = 133
      Width = 321
      Height = 23
      TabOrder = 3
    end
    object edtUsername: TEdit
      Left = 96
      Top = 173
      Width = 321
      Height = 23
      TabOrder = 4
    end
    object edtPassword: TEdit
      Left = 96
      Top = 213
      Width = 321
      Height = 23
      PasswordChar = '*'
      TabOrder = 5
    end
    object chkIntegratedSecurity: TCheckBox
      Left = 96
      Top = 248
      Width = 321
      Height = 17
      Caption = #20351#29992#38598#25104#23433#20840#24615'('#20165#23545'SQL Server'#26377#25928')'
      Checked = True
      State = cbChecked
      TabOrder = 6
      OnClick = chkIntegratedSecurityClick
    end
    object btnTestConnection: TButton
      Left = 96
      Top = 280
      Width = 105
      Height = 25
      Caption = #27979#35797#36830#25509
      TabOrder = 7
      OnClick = btnTestConnectionClick
    end
    object btnSave: TButton
      Left = 216
      Top = 280
      Width = 75
      Height = 25
      Caption = #20445#23384
      TabOrder = 8
      OnClick = btnSaveClick
    end
    object btnCancel: TButton
      Left = 304
      Top = 280
      Width = 75
      Height = 25
      Caption = #21462#28040
      TabOrder = 9
      OnClick = btnCancelClick
    end
  end
end
