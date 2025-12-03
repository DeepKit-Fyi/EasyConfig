object frmErrorDialog: TfrmErrorDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #38169#35823
  ClientHeight = 200
  ClientWidth = 500
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 500
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblTitle: TLabel
      Left = 56
      Top = 16
      Width = 425
      Height = 19
      AutoSize = False
      Caption = #38169#35823#26631#39064
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object imgIcon: TImage
      Left = 16
      Top = 10
      Width = 32
      Height = 32
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 159
    Width = 500
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnOK: TButton
      Left = 407
      Top = 8
      Width = 75
      Height = 25
      Caption = #30830#23450
      Default = True
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnDetails: TButton
      Left = 16
      Top = 8
      Width = 121
      Height = 25
      Caption = #26174#31034#35814#32454#20449#24687' >>'
      TabOrder = 1
      OnClick = btnDetailsClick
    end
  end
  object pnlClient: TPanel
    Left = 0
    Top = 50
    Width = 500
    Height = 109
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object memMessage: TMemo
      Left = 0
      Top = 0
      Width = 500
      Height = 109
      Align = alClient
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object memDetails: TMemo
      Left = 0
      Top = 109
      Width = 500
      Height = 0
      Align = alBottom
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 1
    end
  end
end
