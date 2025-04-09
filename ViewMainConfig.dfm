object Form1: TForm1
  Left = 0
  Top = 0
  Caption = '配置管理工具'
  ClientHeight = 600
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object pnlMain: TPanel
    Left = 200
    Top = 40
    Width = 700
    Height = 520
    Align = alClient
    Caption = '主配置区域'
    TabOrder = 0
  end
  object Panel3: TPanel
    Left = 0
    Top = 560
    Width = 900
    Height = 40
    Align = alBottom
    Caption = '底部状态栏'
    TabOrder = 1
  end
  object Panel4: TPanel
    Left = 0
    Top = 40
    Width = 200
    Height = 520
    Align = alLeft
    Caption = '配置编辑器'
    TabOrder = 2
    Visible = True
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 40
    Align = alTop
    Caption = '顶部工具栏'
    TabOrder = 3
  end
end
