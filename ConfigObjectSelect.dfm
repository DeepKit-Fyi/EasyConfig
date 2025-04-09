object frmConfigObjectSelect: TfrmConfigObjectSelect
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #36873#25321#37197#32622#23545#35937#31867#22411
  ClientHeight = 427
  ClientWidth = 614
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object lblDescription: TLabel
    Left = 304
    Top = 96
    Width = 52
    Height = 15
    Caption = #35814#32454#35828#26126
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 386
    Width = 614
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 385
    ExplicitWidth = 598
    object btnOK: TButton
      Left = 439
      Top = 8
      Width = 75
      Height = 25
      Caption = #30830#23450
      Default = True
      Enabled = False
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 520
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = #21462#28040
      ModalResult = 2
      TabOrder = 1
    end
  end
  object lvObjectTypes: TListView
    Left = 8
    Top = 8
    Width = 289
    Height = 372
    Columns = <
      item
        Caption = #31867#22411#21517#31216
        Width = 120
      end
      item
        Caption = #35828#26126
        Width = 160
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    SmallImages = ilIcons
    TabOrder = 1
    ViewStyle = vsReport
    OnDblClick = lvObjectTypesDblClick
    OnSelectItem = lvObjectTypesSelectItem
  end
  object edtName: TLabeledEdit
    Left = 304
    Top = 40
    Width = 289
    Height = 23
    EditLabel.Width = 52
    EditLabel.Height = 15
    EditLabel.Caption = #23545#35937#21517#31216
    TabOrder = 2
    Text = ''
    OnChange = edtNameChange
  end
  object mmoDescription: TMemo
    Left = 304
    Top = 117
    Width = 289
    Height = 263
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object ilIcons: TImageList
    Left = 352
    Top = 208
  end
end 