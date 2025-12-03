object FrameObjectEditor: TFrameObjectEditor
  Left = 0
  Top = 0
  Width = 500
  Height = 350
  TabOrder = 0
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 400
    Height = 300
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object sgProperties: TStringGrid
      Left = 5
      Top = 5
      Width = 390
      Height = 250
      Align = alClient
      AlignWithMargins = True
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect, goEditing]
      TabOrder = 0
    end
    object pnlControls: TPanel
      Left = 0
      Top = 260
      Width = 400
      Height = 40
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object cmbPropertyType: TComboBox
        Left = 5
        Top = 10
        Width = 120
        Height = 21
        Style = csDropDownList
        TabOrder = 0
      end
      object btnAdd: TButton
        Left = 130
        Top = 8
        Width = 80
        Height = 25
        Caption = '添加属性'
        TabOrder = 1
      end
      object btnEdit: TButton
        Left = 215
        Top = 8
        Width = 80
        Height = 25
        Caption = '编辑属性'
        Enabled = False
        TabOrder = 2
      end
      object btnDelete: TButton
        Left = 300
        Top = 8
        Width = 80
        Height = 25
        Caption = '删除属性'
        Enabled = False
        TabOrder = 3
      end
    end
  end
end