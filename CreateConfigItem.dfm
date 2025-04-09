object CreateConfigItemForm: TCreateConfigItemForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #26032#24314#37197#32622#39033
  ClientHeight = 380
  ClientWidth = 550
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 15
  object pgcMain: TPageControl
    Left = 0
    Top = 0
    Width = 550
    Height = 330
    ActivePage = tsSimple
    Align = alClient
    TabOrder = 0
    OnChange = pgcMainChange
    object tsSimple: TTabSheet
      Caption = #31616#21333#23646#24615
      object lblName: TLabel
        Left = 16
        Top = 24
        Width = 55
        Height = 15
        Caption = #39033#30446#21517#31216':'
      end
      object lblValue: TLabel
        Left = 16
        Top = 72
        Width = 42
        Height = 15
        Caption = #21021#22987#20540':'
      end
      object lblSection: TLabel
        Left = 16
        Top = 120
        Width = 55
        Height = 15
        Caption = #25152#23646#33410#28857':'
      end
      object lblDescription: TLabel
        Left = 16
        Top = 168
        Width = 55
        Height = 15
        Caption = #35828#26126#20449#24687':'
      end
      object edtName: TEdit
        Left = 96
        Top = 21
        Width = 425
        Height = 23
        TabOrder = 0
      end
      object edtValue: TEdit
        Left = 96
        Top = 69
        Width = 425
        Height = 23
        TabOrder = 1
        TextHint = #35831#36755#20837#21021#22987#20540
      end
      object edtSection: TEdit
        Left = 96
        Top = 117
        Width = 425
        Height = 23
        TabOrder = 2
        TextHint = #22914#26524#19981#26159#33410#28857#65292#21017#25351#23450#25152#23646#33410
      end
      object edtDescription: TEdit
        Left = 96
        Top = 165
        Width = 425
        Height = 23
        TabOrder = 3
        TextHint = #21487#36873#35828#26126#20449#24687
      end
      object rgSimpleType: TRadioGroup
        Left = 16
        Top = 208
        Width = 505
        Height = 81
        Caption = #31867#22411
        Columns = 4
        ItemIndex = 0
        Items.Strings = (
          #33410
          #25991#26412
          #25972#25968
          #23567#25968
          #24067#23572#20540
          #26085#26399#26102#38388
          #39068#33394)
        TabOrder = 4
        OnClick = rgSimpleTypeClick
      end
    end
    object tsSpecial: TTabSheet
      Caption = #19987#39033#32534#36753#22120
      ImageIndex = 1
      object lblSpecialName: TLabel
        Left = 16
        Top = 24
        Width = 55
        Height = 15
        Caption = #39033#30446#21517#31216':'
      end
      object edtSpecialName: TEdit
        Left = 96
        Top = 21
        Width = 425
        Height = 23
        TabOrder = 0
      end
      object pnlSpecialParams: TPanel
        Left = 16
        Top = 64
        Width = 505
        Height = 137
        BevelOuter = bvLowered
        Caption = #36873#25321#19987#39033#32534#36753#22120#31867#22411
        TabOrder = 1
      end
      object rgSpecialType: TRadioGroup
        Left = 16
        Top = 216
        Width = 505
        Height = 73
        Caption = #19987#39033#32534#36753#22120#31867#22411
        Columns = 3
        ItemIndex = 0
        Items.Strings = (
          #23383#20307#32534#36753#22120
          #20301#32622#32534#36753#22120
          #32972#26223#32534#36753#22120
          #25968#25454#24211#36830#25509#32534#36753#22120
          #36335#24452#32534#36753#22120)
        TabOrder = 2
        OnClick = rgSpecialTypeClick
      end
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 330
    Width = 550
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnOK: TButton
      Left = 344
      Top = 12
      Width = 89
      Height = 25
      Caption = #30830#23450
      Default = True
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 439
      Top = 12
      Width = 89
      Height = 25
      Cancel = True
      Caption = #21462#28040
      ModalResult = 2
      TabOrder = 1
    end
  end
end
