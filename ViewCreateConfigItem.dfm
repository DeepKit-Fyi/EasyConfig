object CreateConfigItemForm: TCreateConfigItemForm
  Left = 0
  Top = 0
  Caption = '创建配置项'
  ClientHeight = 300
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
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
      object lblName: TLabel
        Left = 16
        Top = 16
        Width = 60
        Height = 13
        Caption = '配置名称：'
      end
      object lblType: TLabel
        Left = 16
        Top = 48
        Width = 60
        Height = 13
        Caption = '配置类型：'
      end
      object lblDescription: TLabel
        Left = 16
        Top = 80
        Width = 60
        Height = 13
        Caption = '配置描述：'
      end
      object edtName: TEdit
        Left = 88
        Top = 13
        Width = 341
        Height = 21
        TabOrder = 0
      end
      object cbbType: TComboBox
        Left = 88
        Top = 45
        Width = 341
        Height = 21
        Style = csDropDownList
        TabOrder = 1
        OnChange = cbbTypeChange
      end
      object edtDescription: TEdit
        Left = 88
        Top = 77
        Width = 341
        Height = 21
        TabOrder = 2
      end
      object grpOptions: TGroupBox
        Left = 16
        Top = 112
        Width = 417
        Height = 121
        Caption = '选项'
        TabOrder = 3
        object pnlOptions: TPanel
          Left = 2
          Top = 15
          Width = 413
          Height = 104
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
        Caption = '确定'
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
        Caption = '取消'
        ModalResult = 2
        TabOrder = 1
      end
    end
  end
end 