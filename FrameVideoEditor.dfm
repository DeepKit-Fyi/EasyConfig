object FrameVideoEditor: TFrameVideoEditor
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
    object pnlCover: TPanel
      Left = 1
      Top = 1
      Width = 798
      Height = 48
      Align = alTop
      TabOrder = 0
      object lblCover: TLabel
        Left = 16
        Top = 16
        Width = 52
        Height = 15
        Caption = #23553#38754#22270#29255
      end
      object edtCover: TEdit
        Left = 88
        Top = 13
        Width = 577
        Height = 23
        TabOrder = 0
      end
      object btnBrowseCover: TButton
        Left = 683
        Top = 12
        Width = 98
        Height = 25
        Caption = #27983#35272'...'
        TabOrder = 1
        OnClick = btnBrowseCoverClick
      end
    end
    object pnlEnding: TPanel
      Left = 1
      Top = 49
      Width = 798
      Height = 48
      Align = alTop
      TabOrder = 1
      object lblEnding: TLabel
        Left = 16
        Top = 16
        Width = 52
        Height = 15
        Caption = #32467#23614#22270#29255
      end
      object edtEnding: TEdit
        Left = 88
        Top = 13
        Width = 577
        Height = 23
        TabOrder = 0
      end
      object btnBrowseEnding: TButton
        Left = 683
        Top = 12
        Width = 98
        Height = 25
        Caption = #27983#35272'...'
        TabOrder = 1
        OnClick = btnBrowseEndingClick
      end
    end
    object pnlDirectories: TPanel
      Left = 1
      Top = 97
      Width = 798
      Height = 96
      Align = alTop
      TabOrder = 2
      object lblBgDirectory: TLabel
        Left = 16
        Top = 16
        Width = 52
        Height = 15
        Caption = #32972#26223#30446#24405
      end
      object lblAudioDirectory: TLabel
        Left = 16
        Top = 56
        Width = 52
        Height = 15
        Caption = #38899#39057#30446#24405
      end
      object edtBgDirectory: TEdit
        Left = 88
        Top = 13
        Width = 577
        Height = 23
        TabOrder = 0
      end
      object btnBrowseBgDir: TButton
        Left = 683
        Top = 12
        Width = 98
        Height = 25
        Caption = #27983#35272'...'
        TabOrder = 1
        OnClick = btnBrowseBgDirClick
      end
      object edtAudioDirectory: TEdit
        Left = 88
        Top = 53
        Width = 577
        Height = 23
        TabOrder = 2
      end
      object btnBrowseAudioDir: TButton
        Left = 683
        Top = 52
        Width = 98
        Height = 25
        Caption = #27983#35272'...'
        TabOrder = 3
        OnClick = btnBrowseAudioDirClick
      end
    end
    object pnlSubtitle: TPanel
      Left = 1
      Top = 193
      Width = 798
      Height = 48
      Align = alTop
      TabOrder = 3
      object lblSubtitleFile: TLabel
        Left = 16
        Top = 16
        Width = 52
        Height = 15
        Caption = #23383#24149#25991#20214
      end
      object edtSubtitleFile: TEdit
        Left = 88
        Top = 13
        Width = 577
        Height = 23
        TabOrder = 0
      end
      object btnBrowseSubtitle: TButton
        Left = 683
        Top = 12
        Width = 98
        Height = 25
        Caption = #27983#35272'...'
        TabOrder = 1
        OnClick = btnBrowseSubtitleClick
      end
    end
    object pgcMain: TPageControl
      Left = 1
      Top = 241
      Width = 798
      Height = 317
      ActivePage = tabSettings
      Align = alClient
      TabOrder = 4
      object tabSettings: TTabSheet
        Caption = #23186#20307#35774#32622
        object pnlSettings: TPanel
          Left = 0
          Top = 0
          Width = 790
          Height = 287
          Align = alClient
          TabOrder = 0
          object lblResolution: TLabel
            Left = 16
            Top = 24
            Width = 39
            Height = 15
            Caption = #20998#36776#29575
          end
          object lblFormat: TLabel
            Left = 16
            Top = 72
            Width = 26
            Height = 15
            Caption = #26684#24335
          end
          object lblQuality: TLabel
            Left = 16
            Top = 120
            Width = 26
            Height = 15
            Caption = #36136#37327
          end
          object lblQualityValue: TLabel
            Left = 336
            Top = 120
            Width = 22
            Height = 15
            Caption = '80%'
          end
          object lblBitrate: TLabel
            Left = 16
            Top = 216
            Width = 52
            Height = 15
            Caption = #27604#29305#29575'(kbps)'
          end
          object cmbResolution: TComboBox
            Left = 88
            Top = 21
            Width = 233
            Height = 23
            Style = csDropDownList
            TabOrder = 0
          end
          object cmbFormat: TComboBox
            Left = 88
            Top = 69
            Width = 233
            Height = 23
            Style = csDropDownList
            TabOrder = 1
          end
          object trkQuality: TTrackBar
            Left = 88
            Top = 120
            Width = 233
            Height = 33
            Max = 100
            TabOrder = 2
            OnChange = trkQualityChange
          end
          object chkAutoAdjustBitrate: TCheckBox
            Left = 88
            Top = 176
            Width = 185
            Height = 17
            Caption = #33258#21160#35843#25972#27604#29305#29575
            TabOrder = 3
            OnClick = chkAutoAdjustBitrateClick
          end
          object edtBitrate: TEdit
            Left = 88
            Top = 213
            Width = 121
            Height = 23
            TabOrder = 4
            Text = '5000'
          end
        end
      end
      object tabClips: TTabSheet
        Caption = #29255#27573#31649#29702
        ImageIndex = 1
        object pnlClips: TPanel
          Left = 0
          Top = 0
          Width = 790
          Height = 287
          Align = alClient
          TabOrder = 0
          object lvClips: TListView
            Left = 16
            Top = 16
            Width = 765
            Height = 217
            Columns = <>
            GridLines = True
            ReadOnly = True
            RowSelect = True
            TabOrder = 0
            ViewStyle = vsReport
          end
          object btnAddClip: TButton
            Left = 16
            Top = 248
            Width = 97
            Height = 25
            Caption = #28155#21152#29255#27573
            TabOrder = 1
            OnClick = btnAddClipClick
          end
          object btnEditClip: TButton
            Left = 128
            Top = 248
            Width = 97
            Height = 25
            Caption = #32534#36753#29255#27573
            TabOrder = 2
            OnClick = btnEditClipClick
          end
          object btnDeleteClip: TButton
            Left = 240
            Top = 248
            Width = 97
            Height = 25
            Caption = #21024#38500#29255#27573
            TabOrder = 3
            OnClick = btnDeleteClipClick
          end
          object btnMoveUp: TButton
            Left = 576
            Top = 248
            Width = 97
            Height = 25
            Caption = #19978#31227
            TabOrder = 4
            OnClick = btnMoveUpClick
          end
          object btnMoveDown: TButton
            Left = 688
            Top = 248
            Width = 97
            Height = 25
            Caption = #19979#31227
            TabOrder = 5
            OnClick = btnMoveDownClick
          end
        end
      end
    end
  end
  object dlgOpenImage: TOpenPictureDialog
    Left = 408
    Top = 8
  end
  object dlgOpenSub: TOpenDialog
    Left = 472
    Top = 8
  end
  object dlgSelectDir: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Left = 536
    Top = 8
  end
end 