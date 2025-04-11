object FrameBgDrawEditor: TFrameBgDrawEditor
  Left = 0
  Top = 0
  Width = 800
  Height = 600
  TabOrder = 0
  object splHorizontal: TSplitter
    Left = 0
    Top = 406
    Width = 800
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 430
    ExplicitWidth = 430
  end
  object pnlToolbar: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 41
    Align = alTop
    TabOrder = 0
    object btnAddText: TButton
      Left = 16
      Top = 6
      Width = 90
      Height = 25
      Caption = #28155#21152#25991#26412
      TabOrder = 0
      OnClick = btnAddTextClick
    end
    object btnAddImage: TButton
      Left = 112
      Top = 6
      Width = 90
      Height = 25
      Caption = #28155#21152#22270#29255
      TabOrder = 1
      OnClick = btnAddImageClick
    end
    object btnAddCaption: TButton
      Left = 208
      Top = 6
      Width = 90
      Height = 25
      Caption = #28155#21152#23383#24149
      TabOrder = 2
      OnClick = btnAddCaptionClick
    end
    object btnDelete: TButton
      Left = 304
      Top = 6
      Width = 90
      Height = 25
      Caption = #21024#38500#20803#32032
      TabOrder = 3
      OnClick = btnDeleteClick
    end
    object btnSave: TButton
      Left = 693
      Top = 6
      Width = 90
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #20445#23384
      TabOrder = 4
      OnClick = btnSaveClick
    end
  end
  object pnlBackground: TPanel
    Left = 0
    Top = 41
    Width = 800
    Height = 41
    Align = alTop
    TabOrder = 1
    object btnLoadBackground: TButton
      Left = 16
      Top = 6
      Width = 121
      Height = 25
      Caption = #21152#36733#32972#26223#22270#29255
      TabOrder = 0
      OnClick = btnLoadBackgroundClick
    end
  end
  object pnlCanvas: TPanel
    Left = 0
    Top = 82
    Width = 800
    Height = 324
    Align = alClient
    TabOrder = 2
  end
  object pnlProperties: TPanel
    Left = 0
    Top = 409
    Width = 800
    Height = 191
    Align = alBottom
    TabOrder = 3
    object lblElementProperties: TLabel
      Left = 16
      Top = 13
      Width = 72
      Height = 15
      Caption = #20803#32032#23646#24615#32534#36753
    end
    object pgProperties: TPageControl
      Left = 1
      Top = 32
      Width = 798
      Height = 158
      ActivePage = tsGeneral
      Align = alBottom
      MultiLine = True
      TabOrder = 0
      object tsGeneral: TTabSheet
        Caption = #36890#29992#23646#24615
        object lblName: TLabel
          Left = 16
          Top = 16
          Width = 52
          Height = 15
          Caption = #20803#32032#21517#31216
        end
        object lblPositionX: TLabel
          Left = 16
          Top = 53
          Width = 38
          Height = 15
          Caption = 'X'#22352#26631
        end
        object lblPositionY: TLabel
          Left = 202
          Top = 53
          Width = 38
          Height = 15
          Caption = 'Y'#22352#26631
        end
        object edtElementName: TEdit
          Left = 74
          Top = 13
          Width = 267
          Height = 23
          TabOrder = 0
          OnChange = edtElementNameChange
        end
        object edtPositionX: TEdit
          Left = 74
          Top = 50
          Width = 90
          Height = 23
          TabOrder = 1
          OnChange = edtPositionXChange
        end
        object edtPositionY: TEdit
          Left = 250
          Top = 50
          Width = 90
          Height = 23
          TabOrder = 2
          OnChange = edtPositionYChange
        end
        object chkVisible: TCheckBox
          Left = 74
          Top = 88
          Width = 97
          Height = 17
          Caption = #21487#35265
          Checked = True
          State = cbChecked
          TabOrder = 3
          OnClick = chkVisibleClick
        end
      end
      object tsTextProps: TTabSheet
        Caption = #25991#26412#23646#24615
        ImageIndex = 1
        object lblText: TLabel
          Left = 16
          Top = 16
          Width = 52
          Height = 15
          Caption = #25991#26412#20869#23481
        end
        object edtText: TEdit
          Left = 74
          Top = 13
          Width = 267
          Height = 23
          TabOrder = 0
          OnChange = edtTextChange
        end
        object btnFont: TButton
          Left = 74
          Top = 50
          Width = 121
          Height = 25
          Caption = #36873#25321#23383#20307
          TabOrder = 1
          OnClick = btnFontClick
        end
      end
      object tsImageProps: TTabSheet
        Caption = #22270#29255#23646#24615
        ImageIndex = 2
        object lblImagePath: TLabel
          Left = 16
          Top = 16
          Width = 52
          Height = 15
          Caption = #22270#29255#36335#24452
        end
        object lblScale: TLabel
          Left = 16
          Top = 53
          Width = 26
          Height = 15
          Caption = #32553#25918
        end
        object edtImagePath: TEdit
          Left = 74
          Top = 13
          Width = 267
          Height = 23
          ReadOnly = True
          TabOrder = 0
        end
        object btnBrowseImage: TButton
          Left = 347
          Top = 13
          Width = 75
          Height = 25
          Caption = #27983#35272'...'
          TabOrder = 1
          OnClick = btnBrowseImageClick
        end
        object edtScale: TEdit
          Left = 74
          Top = 50
          Width = 90
          Height = 23
          TabOrder = 2
          Text = '1.00'
          OnChange = edtScaleChange
        end
      end
      object tsCaptionProps: TTabSheet
        Caption = #23383#24149#23646#24615
        ImageIndex = 3
        object lblDuration: TLabel
          Left = 16
          Top = 16
          Width = 52
          Height = 15
          Caption = #26174#31034#26102#38271
        end
        object lblStartTime: TLabel
          Left = 16
          Top = 53
          Width = 52
          Height = 15
          Caption = #24320#22987#26102#38388
        end
        object edtDuration: TEdit
          Left = 74
          Top = 13
          Width = 90
          Height = 23
          TabOrder = 0
          Text = '5.00'
          OnChange = edtDurationChange
        end
        object edtStartTime: TEdit
          Left = 74
          Top = 50
          Width = 90
          Height = 23
          TabOrder = 1
          Text = '0.00'
          OnChange = edtStartTimeChange
        end
      end
    end
  end
  object dlgOpenImage: TOpenPictureDialog
    Left = 440
    Top = 48
  end
  object dlgFont: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Left = 528
    Top = 48
  end
end 