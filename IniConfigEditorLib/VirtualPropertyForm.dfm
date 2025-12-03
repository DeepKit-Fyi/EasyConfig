object VirtualPropertyForm: TVirtualPropertyForm
  Left = 0
  Top = 0
  Caption = #23646#24615#32534#36753#22120
  ClientHeight = 500
  ClientWidth = 350
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  object ButtonPanel: TPanel
    Left = 0
    Top = 459
    Width = 350
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object OKButton: TButton
      Left = 184
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #30830#23450
      Default = True
      TabOrder = 0
      OnClick = OKButtonClick
    end
    object CancelButton: TButton
      Left = 265
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #21462#28040
      ModalResult = 2
      TabOrder = 1
    end
  end
  object VirtualStringTree: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 350
    Height = 459
    Align = alClient
    Header.AutoSizeIndex = 1
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    TabOrder = 1
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnEditing = VirtualStringTreeEditing
    OnGetText = VirtualStringTreeGetText
    OnNewText = VirtualStringTreeNewText
  end
end 