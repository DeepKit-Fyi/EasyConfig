object frmReferenceEditor: TfrmReferenceEditor
  Left = 0
  Top = 0
  Caption = '寮曠敤缂栬緫鍣?
  ClientHeight = 400
  ClientWidth = 600
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
    Width = 600
    Height = 400
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnlContent: TPanel
      Left = 0
      Top = 0
      Width = 600
      Height = 350
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object lblConfigName: TLabel
        Left = 16
        Top = 16
        Width = 60
        Height = 13
        Caption = '閰嶇疆鍚嶇О锛?
      end
      object lblReferenceType: TLabel
        Left = 16
        Top = 48
        Width = 72
        Height = 13
        Caption = '寮曠敤鑺傜偣绫诲瀷锛?
      end
      object lblReferencePath: TLabel
        Left = 16
        Top = 80
        Width = 72
        Height = 13
        Caption = '寮曠敤鑺傜偣璺緞锛?
      end
      object edtName: TEdit
        Left = 104
        Top = 13
        Width = 473
        Height = 21
        TabOrder = 0
      end
      object cbbReferenceType: TComboBox
        Left = 104
        Top = 45
        Width = 473
        Height = 21
        Style = csDropDownList
        TabOrder = 1
        OnChange = cbbReferenceTypeChange
      end
      object tvReferencePath: TTreeView
        Left = 104
        Top = 80
        Width = 473
        Height = 254
        Indent = 19
        TabOrder = 2
        OnChange = tvReferencePathChange
        OnDblClick = tvReferencePathDblClick
      end
    end
    object pnlButtons: TPanel
      Left = 0
      Top = 350
      Width = 600
      Height = 50
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object btnOK: TButton
        Left = 404
        Top = 14
        Width = 85
        Height = 25
        Caption = '纭畾'
        Default = True
        TabOrder = 0
        OnClick = btnOKClick
      end
      object btnCancel: TButton
        Left = 495
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