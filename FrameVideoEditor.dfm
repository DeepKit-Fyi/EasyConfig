object FrameVideoEditor: TFrameVideoEditor
  Left = 0
  Top = 0
  Width = 640
  Height = 480
  object pgcMain: TPageControl
    Left = 0
    Top = 0
    Width = 640
    Height = 480
    ActivePage = tsCover
    Align = alClient
    TabOrder = 0
    object tsCover: TTabSheet
      Caption = '封面设置'
      object pnlCover: TPanel
        Left = 0
        Top = 0
        Width = 632
        Height = 50
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object lblCover: TLabel
          Left = 16
          Top = 16
          Width = 60
          Height = 13
          Caption = '封面图路径:'
        end
        object edtCover: TEdit
          Left = 82
          Top = 13
          Width = 471
          Height = 21
          TabOrder = 0
          OnChange = EditModified
        end
        object btnBrowseCover: TButton
          Left = 559
          Top = 11
          Width = 65
          Height = 25
          Caption = '浏览...'
          TabOrder = 1
          OnClick = btnBrowseCoverClick
        end
      end
      object pnlEnding: TPanel
        Left = 0
        Top = 50
        Width = 632
        Height = 50
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object lblEnding: TLabel
          Left = 16
          Top = 16
          Width = 60
          Height = 13
          Caption = '结尾图路径:'
        end
        object edtEnding: TEdit
          Left = 82
          Top = 13
          Width = 471
          Height = 21
          TabOrder = 0
          OnChange = EditModified
        end
        object btnBrowseEnding: TButton
          Left = 559
          Top = 11
          Width = 65
          Height = 25
          Caption = '浏览...'
          TabOrder = 1
          OnClick = btnBrowseEndingClick
        end
      end
    end
    object tsSettings: TTabSheet
      Caption = '全局设置'
      ImageIndex = 1
      object pnlSettings: TPanel
        Left = 0
        Top = 0
        Width = 632
        Height = 452
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object grpDirectories: TGroupBox
          Left = 16
          Top = 16
          Width = 601
          Height = 161
          Caption = '资源目录'
          TabOrder = 0
          object lblBgDir: TLabel
            Left = 16
            Top = 32
            Width = 60
            Height = 13
            Caption = '背景目录:'
          end
          object lblAudioDir: TLabel
            Left = 16
            Top = 72
            Width = 60
            Height = 13
            Caption = '音频目录:'
          end
          object lblSubtitleFile: TLabel
            Left = 16
            Top = 112
            Width = 60
            Height = 13
            Caption = '字幕文件:'
          end
          object edtBgDir: TEdit
            Left = 82
            Top = 29
            Width = 431
            Height = 21
            TabOrder = 0
            OnChange = EditModified
          end
          object btnBrowseBgDir: TButton
            Left = 519
            Top = 27
            Width = 65
            Height = 25
            Caption = '浏览...'
            TabOrder = 1
            OnClick = btnBrowseBgDirClick
          end
          object edtAudioDir: TEdit
            Left = 82
            Top = 69
            Width = 431
            Height = 21
            TabOrder = 2
            OnChange = EditModified
          end
          object btnBrowseAudioDir: TButton
            Left = 519
            Top = 67
            Width = 65
            Height = 25
            Caption = '浏览...'
            TabOrder = 3
            OnClick = btnBrowseAudioDirClick
          end
          object edtSubtitleFile: TEdit
            Left = 82
            Top = 109
            Width = 431
            Height = 21
            TabOrder = 4
            OnChange = EditModified
          end
          object btnBrowseSubtitle: TButton
            Left = 519
            Top = 107
            Width = 65
            Height = 25
            Caption = '浏览...'
            TabOrder = 5
            OnClick = btnBrowseSubtitleClick
          end
        end
        object grpMediaSettings: TGroupBox
          Left = 16
          Top = 192
          Width = 601
          Height = 137
          Caption = '媒体设置'
          TabOrder = 1
          object lblVideoWidth: TLabel
            Left = 16
            Top = 32
            Width = 60
            Height = 13
            Caption = '视频宽度:'
          end
          object lblVideoHeight: TLabel
            Left = 16
            Top = 72
            Width = 60
            Height = 13
            Caption = '视频高度:'
          end
          object lblVideoFPS: TLabel
            Left = 296
            Top = 32
            Width = 60
            Height = 13
            Caption = '视频帧率:'
          end
          object lblBitrate: TLabel
            Left = 296
            Top = 72
            Width = 60
            Height = 13
            Caption = '比特率(kbps):'
          end
          object edtVideoWidth: TEdit
            Left = 82
            Top = 29
            Width = 121
            Height = 21
            TabOrder = 0
            Text = '1920'
            OnChange = EditModified
          end
          object edtVideoHeight: TEdit
            Left = 82
            Top = 69
            Width = 121
            Height = 21
            TabOrder = 2
            Text = '1080'
            OnChange = EditModified
          end
          object edtVideoFPS: TEdit
            Left = 362
            Top = 29
            Width = 121
            Height = 21
            TabOrder = 1
            Text = '30'
            OnChange = EditModified
          end
          object edtBitrate: TEdit
            Left = 362
            Top = 69
            Width = 121
            Height = 21
            TabOrder = 3
            Text = '8000'
            OnChange = EditModified
          end
          object cbxHasAudio: TCheckBox
            Left = 16
            Top = 104
            Width = 97
            Height = 17
            Caption = '包含音频'
            Checked = True
            State = cbChecked
            TabOrder = 4
            OnClick = EditModified
          end
        end
      end
    end
    object tsClips: TTabSheet
      Caption = '片段管理'
      ImageIndex = 2
      object lblClips: TLabel
        Left = 16
        Top = 16
        Width = 60
        Height = 13
        Caption = '片段列表:'
      end
      object lstClips: TListBox
        Left = 16
        Top = 35
        Width = 217
        Height = 389
        ItemHeight = 13
        TabOrder = 0
        OnClick = lstClipsClick
      end
      object pnlClipButtons: TPanel
        Left = 239
        Top = 35
        Width = 98
        Height = 389
        BevelOuter = bvNone
        TabOrder = 1
        object btnAddClip: TButton
          Left = 0
          Top = 0
          Width = 98
          Height = 25
          Caption = '添加片段'
          TabOrder = 0
          OnClick = btnAddClipClick
        end
        object btnEditClip: TButton
          Left = 0
          Top = 31
          Width = 98
          Height = 25
          Caption = '编辑片段'
          Enabled = False
          TabOrder = 1
          OnClick = btnEditClipClick
        end
        object btnDeleteClip: TButton
          Left = 0
          Top = 62
          Width = 98
          Height = 25
          Caption = '删除片段'
          Enabled = False
          TabOrder = 2
          OnClick = btnDeleteClipClick
        end
        object btnMoveUp: TButton
          Left = 0
          Top = 124
          Width = 98
          Height = 25
          Caption = '上移'
          Enabled = False
          TabOrder = 3
          OnClick = btnMoveUpClick
        end
        object btnMoveDown: TButton
          Left = 0
          Top = 155
          Width = 98
          Height = 25
          Caption = '下移'
          Enabled = False
          TabOrder = 4
          OnClick = btnMoveDownClick
        end
      end
      object pnlClipDetails: TPanel
        Left = 343
        Top = 35
        Width = 281
        Height = 389
        BevelOuter = bvNone
        TabOrder = 2
        Visible = False
        object lblClipName: TLabel
          Left = 16
          Top = 16
          Width = 60
          Height = 13
          Caption = '片段名称:'
        end
        object lblClipBackground: TLabel
          Left = 16
          Top = 64
          Width = 60
          Height = 13
          Caption = '背景路径:'
        end
        object lblClipDuration: TLabel
          Left = 16
          Top = 112
          Width = 60
          Height = 13
          Caption = '时长(秒):'
        end
        object lblClipAudio: TLabel
          Left = 16
          Top = 160
          Width = 60
          Height = 13
          Caption = '音频路径:'
        end
        object edtClipName: TEdit
          Left = 82
          Top = 13
          Width = 185
          Height = 21
          TabOrder = 0
        end
        object edtClipBackground: TEdit
          Left = 16
          Top = 83
          Width = 251
          Height = 21
          TabOrder = 1
        end
        object btnBrowseClipBg: TButton
          Left = 192
          Top = 58
          Width = 75
          Height = 21
          Caption = '浏览...'
          TabOrder = 2
          OnClick = btnBrowseClipBgClick
        end
        object edtClipDuration: TEdit
          Left = 82
          Top = 109
          Width = 121
          Height = 21
          TabOrder = 3
          Text = '10.0'
        end
        object edtClipAudio: TEdit
          Left = 16
          Top = 179
          Width = 251
          Height = 21
          TabOrder = 4
        end
        object btnBrowseClipAudio: TButton
          Left = 192
          Top = 156
          Width = 75
          Height = 21
          Caption = '浏览...'
          TabOrder = 5
          OnClick = btnBrowseClipAudioClick
        end
        object btnSaveClip: TButton
          Left = 98
          Top = 264
          Width = 75
          Height = 25
          Caption = '保存'
          TabOrder = 6
          OnClick = btnSaveClipClick
        end
        object btnCancelClip: TButton
          Left = 192
          Top = 264
          Width = 75
          Height = 25
          Caption = '取消'
          TabOrder = 7
          OnClick = btnCancelClipClick
        end
      end
    end
  end
  object dlgOpenImage: TOpenDialog
    Left = 472
    Top = 64
  end
  object dlgOpenAudio: TOpenDialog
    Left = 392
    Top = 64
  end
  object dlgOpenSubtitle: TOpenDialog
    Left = 312
    Top = 64
  end
  object dlgSelectDir: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Left = 552
    Top = 64
  end
end 