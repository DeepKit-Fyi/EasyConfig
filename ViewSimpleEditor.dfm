object frmSimpleEditor: TfrmSimpleEditor
  Left = 0
  Top = 0
  Caption = '绠€鍗曠紪杈戝櫒'
  ClientHeight = 300
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 450
    Height = 300
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnlContent: TPanel
      Left = 0
      Top = 0
      Width = 450
      Height = 250
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object lblConfigType: TLabel
        Left = 16
        Top = 16
        Width = 60
        Height = 13
        Caption = '閰嶇疆绫诲瀷锛?
      end
      object lblConfigName: TLabel
        Left = 16
        Top = 48
        Width = 60
        Height = 13
        Caption = '閰嶇疆鍚嶇О锛?
      end
      object cbbConfigType: TComboBox
        Left = 88
        Top = 13
        Width = 341
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        OnChange = cbbConfigTypeChange
      end
      object edtName: TEdit
        Left = 88
        Top = 45
        Width = 341
        Height = 21
        TabOrder = 1
      end
      object grpValue: TGroupBox
        Left = 16
        Top = 80
        Width = 417
        Height = 153
        Caption = '鍊?
        TabOrder = 2
        object pnlType: TPanel
          Left = 2
          Top = 15
          Width = 413
          Height = 136
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
        end
      end
    end
    object pnlButtons: TPanel
      Left = 0
      Top = 250
      Width = 450
      Height = 50
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object btnOK: TButton
        Left = 254
        Top = 14
        Width = 85
        Height = 25
        Caption = '纭畾'
        Default = True
        TabOrder = 0
        OnClick = btnOKClick
      end
      object btnCancel: TButton
        Left = 345
        Top = 14
        Width = 85
        Height = 25
        Cancel = True
        Caption = '鍙栨秷'
        ModalResult = 2
        TabOrder = 1
        OnClick = btnCancelClick
      end
    end
  end
end 