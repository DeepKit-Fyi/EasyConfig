object frmValidation: TfrmValidation
  Left = 0
  Top = 0
  Caption = #39564#35777#32467#26524
  ClientHeight = 361
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 13
  object lvValidation: TListView
    Left = 0
    Top = 0
    Width = 784
    Height = 320
    Align = alClient
    Columns = <>
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = lvValidationDblClick
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 320
    Width = 784
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnClose: TButton
      Left = 701
      Top = 8
      Width = 75
      Height = 25
      Caption = #20851#38381
      TabOrder = 0
      OnClick = btnCloseClick
    end
  end
end
