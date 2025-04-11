object FrameVideoClipEditor: TFrameVideoClipEditor
  Left = 0
  Top = 0
  Width = 800
  Height = 600
  TabOrder = 0
  object pnlToolbar: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 41
    Align = alTop
    TabOrder = 0
    object btnSave: TButton
      Left = 693
      Top = 8
      Width = 90
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #20445#23384
      TabOrder = 0
      OnClick = btnSaveClick
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 41
    Width = 800
    Height = 559
    Align = alClient
    TabOrder = 1
    object pnlBackground: TPanel
      Left = 1
      Top = 1
      Width = 798
      Height = 48
      Align = alTop
      TabOrder = 0
      object lblBackground: TLabel
        Left = 16
        Top = 16
        Width = 52
        Height = 15
        Caption = #32972#26223#22270#29255
      end
      object edtBackground: TEdit
        Left = 88
        Top = 13
        Width = 577
        Height = 23
        TabOrder = 0
      end
      object btnBrowseBackground: TButton
        Left = 683
        Top = 12
        Width = 98
        Height = 25
        Caption = #27983#35272'...'
        TabOrder = 1
        OnClick = btnBrowseBackgroundClick
      end
    end
    object pnlDuration: TPanel
      Left = 1
      Top = 49
      Width = 798
      Height = 48
      Align = alTop
      TabOrder = 1
      object lblDuration: TLabel
        Left = 16
        Top = 16
        Width = 52
        Height = 15
        Caption = #29255#27573#26102#38271
      end
      object lblFps: TLabel
        Left = 320
        Top = 16
        Width = 39
        Height = 15
        Caption = #24103#29575'FPS'
      end
      object edtDuration: TEdit
        Left = 88
        Top = 13
        Width = 121
        Height = 23
        TabOrder = 0
        Text = '10.0'
      end
      object edtFps: TEdit
        Left = 376
        Top = 13
        Width = 121
        Height = 23
        TabOrder = 1
        Text = '30'
      end
    end
    object pnlAudio: TPanel
      Left = 1
      Top = 97
      Width = 798
      Height = 48
      Align = alTop
      TabOrder = 2
      object lblAudio: TLabel
        Left = 16
        Top = 16
        Width = 52
        Height = 15
        Caption = #38899#39057#25991#20214
      end
      object edtAudio: TEdit
        Left = 88
        Top = 13
        Width = 577
        Height = 23
        TabOrder = 0
      end
      object btnBrowseAudio: TButton
        Left = 683
        Top = 12
        Width = 98
        Height = 25
        Caption = #27983#35272'...'
        TabOrder = 1
        OnClick = btnBrowseAudioClick
      end
    end
    object pnlCaptions: TPanel
      Left = 1
      Top = 145
      Width = 798
      Height = 361
      Align = alClient
      TabOrder = 3
      object lblCaptions: TLabel
        Left = 16
        Top = 16
        Width = 39
        Height = 15
        Caption = #23383#24149#34920
      end
      object lvCaptions: TListView
        Left = 16
        Top = 48
        Width = 765
        Height = 257
        Columns = <>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
      object btnAddCaption: TButton
        Left = 272
        Top = 317
        Width = 106
        Height = 25
        Caption = #28155#21152#23383#24149
        TabOrder = 1
        OnClick = btnAddCaptionClick
      end
      object btnEditCaption: TButton
        Left = 392
        Top = 317
        Width = 106
        Height = 25
        Caption = #32534#36753#23383#24149
        TabOrder = 2
        OnClick = btnEditCaptionClick
      end
      object btnDeleteCaption: TButton
        Left = 512
        Top = 317
        Width = 106
        Height = 25
        Caption = #21024#38500#23383#24149
        TabOrder = 3
        OnClick = btnDeleteCaptionClick
      end
    end
    object pnlCaptionEdit: TPanel
      Left = 1
      Top = 145
      Width = 798
      Height = 361
      Align = alClient
      TabOrder = 4
      Visible = False
      object lblCaptionText: TLabel
        Left = 16
        Top = 32
        Width = 52
        Height = 15
        Caption = #23383#24149#25991#23383
      end
      object lblStartTime: TLabel
        Left = 16
        Top = 80
        Width = 52
        Height = 15
        Caption = #24320#22987#26102#38388
      end
      object lblCaptionDuration: TLabel
        Left = 16
        Top = 128
        Width = 52
        Height = 15
        Caption = #26174#31034#26102#38388
      end
      object edtCaptionText: TEdit
        Left = 88
        Top = 29
        Width = 425
        Height = 23
        TabOrder = 0
      end
      object edtStartTime: TEdit
        Left = 88
        Top = 77
        Width = 121
        Height = 23
        TabOrder = 1
        Text = '0.0'
      end
      object edtCaptionDuration: TEdit
        Left = 88
        Top = 125
        Width = 121
        Height = 23
        TabOrder = 2
        Text = '5.0'
      end
      object btnFont: TButton
        Left = 88
        Top = 176
        Width = 121
        Height = 25
        Caption = #36873#25321#23383#20307
        TabOrder = 3
        OnClick = btnFontClick
      end
      object btnSaveCaption: TButton
        Left = 144
        Top = 232
        Width = 121
        Height = 25
        Caption = #20445#23384#23383#24149
        TabOrder = 4
        OnClick = btnSaveCaptionClick
      end
      object btnCancelCaption: TButton
        Left = 296
        Top = 232
        Width = 121
        Height = 25
        Caption = #21462#28040
        TabOrder = 5
        OnClick = btnCancelCaptionClick
      end
    end
  end
  object dlgOpenImage: TOpenPictureDialog
    Left = 408
    Top = 8
  end
  object dlgOpenAudio: TOpenDialog
    Left = 472
    Top = 8
  end
  object dlgFont: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Left = 536
    Top = 8
  end
end 