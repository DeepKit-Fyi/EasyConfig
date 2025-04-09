object TFontEditor
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = '瀛椾綋缂栬緫鍣?
  ClientHeight = 381
  ClientWidth = 484
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 484
    Height = 381
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnlPreview: TPanel
      Left = 0
      Top = 265
      Width = 484
      Height = 116
      Align = alBottom
      BevelKind = bkTile
      BevelOuter = bvNone
      TabOrder = 0
      object lblPreview: TLabel
        Left = 24
        Top = 40
        Width = 433
        Height = 28
        Alignment = taCenter
        AutoSize = False
        Caption = '娆㈣繋浣跨敤瀛椾綋缂栬緫鍣?- Welcome to Font Editor - ABC123'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
    end
    object pnlSettings: TPanel
      Left = 0
      Top = 0
      Width = 484
      Height = 265
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object lblFontName: TLabel
        Left = 24
        Top = 24
        Width = 60
        Height = 13
        Caption = '瀛椾綋鍚嶇О锛?
      end
      object lblFontSize: TLabel
        Left = 24
        Top = 64
        Width = 60
        Height = 13
        Caption = '瀛椾綋澶у皬锛?
      end
      object lblFontStyle: TLabel
        Left = 24
        Top = 104
        Width = 60
        Height = 13
        Caption = '瀛椾綋鏍峰紡锛?
      end
      object lblFontColor: TLabel
        Left = 24
        Top = 152
        Width = 60
        Height = 13
        Caption = '瀛椾綋棰滆壊锛?
      end
      object edtFontName: TEdit
        Left = 96
        Top = 21
        Width = 257
        Height = 21
        TabOrder = 0
      end
      object edtFontSize: TEdit
        Left = 96
        Top = 61
        Width = 65
        Height = 21
        TabOrder = 1
        Text = '10'
      end
      object pnlColor: TPanel
        Left = 96
        Top = 149
        Width = 65
        Height = 25
        BevelOuter = bvLowered
        Color = clBlack
        ParentBackground = False
        TabOrder = 2
        OnClick = pnlColorClick
      end
      object chkBold: TCheckBox
        Left = 96
        Top = 104
        Width = 65
        Height = 17
        Caption = '绮椾綋'
        TabOrder = 3
        OnClick = chkBoldClick
      end
      object chkItalic: TCheckBox
        Left = 167
        Top = 104
        Width = 65
        Height = 17
        Caption = '鏂滀綋'
        TabOrder = 4
        OnClick = chkItalicClick
      end
      object chkUnderline: TCheckBox
        Left = 238
        Top = 104
        Width = 65
        Height = 17
        Caption = '涓嬪垝绾?
        TabOrder = 5
        OnClick = chkUnderlineClick
      end
      object chkStrikeout: TCheckBox
        Left = 309
        Top = 104
        Width = 65
        Height = 17
        Caption = '鍒犻櫎绾?
        TabOrder = 6
        OnClick = chkStrikeoutClick
      end
      object btnSelectFont: TButton
        Left = 376
        Top = 20
        Width = 89
        Height = 25
        Caption = '閫夋嫨瀛椾綋...'
        TabOrder = 7
        OnClick = btnSelectFontClick
      end
      object btnDefault: TButton
        Left = 96
        Top = 200
        Width = 89
        Height = 25
        Caption = '鎭㈠榛樿'
        TabOrder = 8
        OnClick = btnDefaultClick
      end
      object btnApply: TButton
        Left = 208
        Top = 200
        Width = 89
        Height = 25
        Caption = '搴旂敤鏇存敼'
        TabOrder = 9
        OnClick = btnApplyClick
      end
    end
  end
  object dlgFont: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [fdEffects, fdFixedPitchOnly]
    Left = 416
    Top = 64
  end
  object dlgColor: TColorDialog
    Left = 416
    Top = 120
  end
end 