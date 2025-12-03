object ConfigSelector: TConfigSelector
  Left = 0
  Top = 0
  Caption = 'Config Selector'
  ClientHeight = 300
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 400
    Height = 259
    Align = alClient
    Columns = <
      item
        Caption = 'Name'
        Width = 150
      end
      item
        Caption = 'Type'
        Width = 100
      end
      item
        Caption = 'Path'
        Width = 150
      end>
    TabOrder = 0
    ViewStyle = vsReport
  end
  object Panel1: TPanel
    Left = 0
    Top = 259
    Width = 400
    Height = 41
    Align = alBottom
    TabOrder = 1
    object Button1: TButton
      Left = 232
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 313
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
end 