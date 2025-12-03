object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 821
  ClientWidth = 912
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Splitter2: TSplitter
    Left = 0
    Top = 777
    Width = 912
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitLeft = 188
    ExplicitTop = 44
    ExplicitWidth = 736
  end
  object Splitter3: TSplitter
    Left = 724
    Top = 44
    Height = 733
    Align = alRight
    ExplicitLeft = 9
    ExplicitTop = 9
    ExplicitHeight = 737
  end
  object Splitter4: TSplitter
    Left = 0
    Top = 41
    Width = 912
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitLeft = 185
    ExplicitWidth = 739
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 912
    Height = 41
    Align = alTop
    TabOrder = 0
    ExplicitLeft = 128
    ExplicitTop = 22
    ExplicitWidth = 185
  end
  object pnlClient: TPanel
    Left = 185
    Top = 44
    Width = 539
    Height = 733
    Align = alClient
    TabOrder = 1
    ExplicitLeft = 368
    ExplicitTop = 182
    ExplicitWidth = 185
    ExplicitHeight = 41
    object Splitter1: TSplitter
      Left = 1
      Top = 1
      Height = 731
      ExplicitLeft = 400
      ExplicitTop = 736
      ExplicitHeight = 100
    end
    object PageControl1: TPageControl
      Left = 4
      Top = 1
      Width = 534
      Height = 731
      ActivePage = TabSheet2
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = 'TabSheet1'
        object ValueListEditor1: TValueListEditor
          Left = 0
          Top = 0
          Width = 526
          Height = 701
          Align = alClient
          TabOrder = 0
          ExplicitLeft = 200
          ExplicitTop = 248
          ExplicitWidth = 306
          ExplicitHeight = 300
          ColWidths = (
            150
            370)
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'TabSheet2'
        ImageIndex = 1
      end
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 780
    Width = 912
    Height = 41
    Align = alBottom
    TabOrder = 2
    ExplicitLeft = 376
    ExplicitTop = 190
    ExplicitWidth = 185
    object Edit1: TEdit
      Left = 80
      Top = 6
      Width = 345
      Height = 23
      TabOrder = 0
      Text = 'Edit1'
    end
    object btnRead: TButton
      Left = 528
      Top = 8
      Width = 75
      Height = 25
      Caption = 'btnRead'
      TabOrder = 1
      OnClick = btnReadClick
    end
  end
  object pnlRigth: TPanel
    Left = 727
    Top = 44
    Width = 185
    Height = 733
    Align = alRight
    TabOrder = 3
    ExplicitLeft = 679
    ExplicitTop = 35
    ExplicitHeight = 739
    object Splitter5: TSplitter
      Left = 1
      Top = 306
      Width = 183
      Height = 3
      Cursor = crVSplit
      Align = alTop
    end
    object Memo1: TMemo
      Left = 1
      Top = 1
      Width = 183
      Height = 305
      Align = alTop
      Lines.Strings = (
        'Memo1')
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object Memo2: TMemo
      Left = 1
      Top = 309
      Width = 183
      Height = 423
      Align = alClient
      Lines.Strings = (
        'Memo1')
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 44
    Width = 185
    Height = 733
    Align = alLeft
    TabOrder = 4
    ExplicitLeft = 392
    ExplicitTop = 206
    ExplicitHeight = 41
  end
end
