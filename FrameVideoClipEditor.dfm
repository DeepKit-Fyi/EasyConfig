object FrameVideoClipEditor: TFrameVideoClipEditor
  Left = 0
  Top = 0
  Width = 640
  Height = 480
  TabOrder = 0
  object pnlBackground: TPanel
    Left = 0
    Top = 0
    Width = 640
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblBackground: TLabel
      Left = 16
      Top = 16
      Width = 60
      Height = 13
      Caption = '背景路径:'
    end
    object edtBackground: TEdit
      Left = 82
      Top = 13
      Width = 471
      Height = 21
      TabOrder = 0
      OnChange = EditModified
    end
    object btnBrowseBackground: TButton
      Left = 559
      Top = 11
      Width = 75
      Height = 25
      Caption = '浏览...'
      TabOrder = 1
      OnClick = btnBrowseBackgroundClick
    end
  end
  object pnlAudio: TPanel
    Left = 0
    Top = 50
    Width = 640
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblAudio: TLabel
      Left = 16
      Top = 16
      Width = 60
      Height = 13
      Caption = '音频路径:'
    end
    object edtAudio: TEdit
      Left = 82
      Top = 13
      Width = 471
      Height = 21
      TabOrder = 0
      OnChange = EditModified
    end
    object btnBrowseAudio: TButton
      Left = 559
      Top = 11
      Width = 75
      Height = 25
      Caption = '浏览...'
      TabOrder = 1
      OnClick = btnBrowseAudioClick
    end
  end
  object pnlClipSettings: TPanel
    Left = 0
    Top = 100
    Width = 640
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object lblDuration: TLabel
      Left = 16
      Top = 18
      Width = 60
      Height = 13
      Caption = '时长(秒):'
    end
    object lblFPS: TLabel
      Left = 213
      Top = 18
      Width = 32
      Height = 13
      Caption = '帧率:'
    end
    object edtDuration: TEdit
      Left = 82
      Top = 15
      Width = 85
      Height = 21
      TabOrder = 0
      Text = '10.00'
      OnChange = EditModified
    end
    object edtFPS: TEdit
      Left = 251
      Top = 15
      Width = 85
      Height = 21
      TabOrder = 1
      Text = '30.00'
      OnChange = EditModified
    end
  end
  object lblCaptions: TLabel
    Left = 16
    Top = 160
    Width = 48
    Height = 13
    Caption = '字幕列表:'
  end
  object lstCaptions: TListBox
    Left = 16
    Top = 180
    Width = 217
    Height = 290
    ItemHeight = 13
    TabOrder = 3
    OnClick = lstCaptionsClick
  end
  object pnlCaptionButtons: TPanel
    Left = 239
    Top = 180
    Width = 98
    Height = 290
    BevelOuter = bvNone
    TabOrder = 4
    object btnAddCaption: TButton
      Left = 0
      Top = 0
      Width = 98
      Height = 25
      Caption = '添加字幕'
      TabOrder = 0
      OnClick = btnAddCaptionClick
    end
    object btnEditCaption: TButton
      Left = 0
      Top = 31
      Width = 98
      Height = 25
      Caption = '编辑字幕'
      Enabled = False
      TabOrder = 1
      OnClick = btnEditCaptionClick
    end
    object btnDeleteCaption: TButton
      Left = 0
      Top = 62
      Width = 98
      Height = 25
      Caption = '删除字幕'
      Enabled = False
      TabOrder = 2
      OnClick = btnDeleteCaptionClick
    end
  end
  object pnlCaptionDetails: TPanel
    Left = 343
    Top = 180
    Width = 281
    Height = 290
    BevelOuter = bvNone
    TabOrder = 5
    Visible = False
    object lblCaptionText: TLabel
      Left = 8
      Top = 8
      Width = 60
      Height = 13
      Caption = '字幕文本:'
    end
    object lblStartTime: TLabel
      Left = 8
      Top = 48
      Width = 60
      Height = 13
      Caption = '开始时间:'
    end
    object lblCaptionDuration: TLabel
      Left = 143
      Top = 48
      Width = 60
      Height = 13
      Caption = '显示时长:'
    end
    object lblFontSettings: TLabel
      Left = 8
      Top = 88
      Width = 60
      Height = 13
      Caption = '字体设置:'
    end
    object lblFontSize: TLabel
      Left = 143
      Top = 88
      Width = 60
      Height = 13
      Caption = '字体大小:'
    end
    object lblFontColor: TLabel
      Left = 8
      Top = 128
      Width = 60
      Height = 13
      Caption = '字体颜色:'
    end
    object lblPosition: TLabel
      Left = 8
      Top = 168
      Width = 60
      Height = 13
      Caption = '位置设置:'
    end
    object lblCaptionX: TLabel
      Left = 39
      Top = 190
      Width = 12
      Height = 13
      Caption = 'X:'
    end
    object lblCaptionY: TLabel
      Left = 143
      Top = 190
      Width = 12
      Height = 13
      Caption = 'Y:'
    end
    object edtCaptionText: TEdit
      Left = 74
      Top = 5
      Width = 199
      Height = 21
      TabOrder = 0
    end
    object edtStartTime: TEdit
      Left = 74
      Top = 45
      Width = 60
      Height = 21
      TabOrder = 1
      Text = '0.00'
    end
    object edtCaptionDuration: TEdit
      Left = 209
      Top = 45
      Width = 60
      Height = 21
      TabOrder = 2
      Text = '3.00'
    end
    object edtFontName: TEdit
      Left = 74
      Top = 85
      Width = 60
      Height = 21
      TabOrder = 3
      Text = 'Arial'
    end
    object btnSelectFont: TButton
      Left = 66
      Top = 125
      Width = 75
      Height = 25
      Caption = '选择字体'
      TabOrder = 5
      OnClick = btnSelectFontClick
    end
    object edtFontSize: TEdit
      Left = 209
      Top = 85
      Width = 60
      Height = 21
      TabOrder = 4
      Text = '24'
    end
    object pnlFontColor: TPanel
      Left = 16
      Top = 146
      Width = 24
      Height = 16
      Color = clWhite
      ParentBackground = False
      TabOrder = 6
      OnClick = pnlFontColorClick
    end
    object edtCaptionX: TEdit
      Left = 57
      Top = 187
      Width = 60
      Height = 21
      TabOrder = 7
      Text = '10'
    end
    object edtCaptionY: TEdit
      Left = 161
      Top = 187
      Width = 60
      Height = 21
      TabOrder = 8
      Text = '10'
    end
    object btnSaveCaption: TButton
      Left = 102
      Top = 254
      Width = 75
      Height = 25
      Caption = '保存'
      TabOrder = 9
      OnClick = btnSaveCaptionClick
    end
    object btnCancelCaption: TButton
      Left = 183
      Top = 254
      Width = 75
      Height = 25
      Caption = '取消'
      TabOrder = 10
      OnClick = btnCancelCaptionClick
    end
  end
  object dlgOpenBackground: TOpenDialog
    Left = 472
    Top = 64
  end
  object dlgOpenAudio: TOpenDialog
    Left = 392
    Top = 64
  end
  object dlgFont: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 552
    Top = 64
  end
  object dlgColor: TColorDialog
    Left = 312
    Top = 64
  end
end 