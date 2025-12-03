object FrameKeyValueDictEditor: TFrameKeyValueDictEditor
  Left = 0
  Top = 0
  Width = 600
  Height = 550
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 550
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object grpKeyValueDict: TGroupBox
      Left = 16
      Top = 16
      Width = 568
      Height = 473
      Caption = #38190#20540#23545#23383#20856#35774#32622
      TabOrder = 0
      object lblName: TLabel
        Left = 24
        Top = 32
        Width = 36
        Height = 17
        Caption = #21517#31216':'
      end
      object lblDescription: TLabel
        Left = 24
        Top = 64
        Width = 36
        Height = 17
        Caption = #25551#36848':'
      end
      object lblValueType: TLabel
        Left = 264
        Top = 100
        Width = 72
        Height = 17
        Caption = #40664#35748#31867#22411':'
      end
      object edtName: TEdit
        Left = 96
        Top = 32
        Width = 201
        Height = 25
        TabOrder = 0
      end
      object memDescription: TMemo
        Left = 96
        Top = 64
        Width = 441
        Height = 33
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object sg: TStringGrid
        Left = 24
        Top = 128
        Width = 513
        Height = 305
        ColCount = 4
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goTabs, goRowSelect]
        TabOrder = 2
        OnSelectCell = sgSelectCell
      end
      object pnlGridButtons: TPanel
        Left = 400
        Top = 104
        Width = 137
        Height = 24
        BevelOuter = bvNone
        TabOrder = 3
        object btnAdd: TButton
          Left = 0
          Top = 0
          Width = 40
          Height = 24
          Caption = #28155#21152
          TabOrder = 0
          OnClick = btnAddClick
        end
        object btnDelete: TButton
          Left = 46
          Top = 0
          Width = 40
          Height = 24
          Caption = #21024#38500
          TabOrder = 1
          OnClick = btnDeleteClick
        end
        object btnClear: TButton
          Left = 92
          Top = 0
          Width = 45
          Height = 24
          Caption = #28165#31354
          TabOrder = 2
          OnClick = btnClearClick
        end
      end
      object chkKeyValueTypeCheck: TCheckBox
        Left = 24
        Top = 100
        Width = 145
        Height = 17
        Caption = #21551#29992#20540#31867#22411#26816#26597
        TabOrder = 4
        OnClick = chkKeyValueTypeCheckClick
      end
      object cbbValueType: TComboBox
        Left = 328
        Top = 100
        Width = 100
        Height = 25
        Style = csDropDownList
        TabOrder = 5
      end
    end
    object pnlButtons: TPanel
      Left = 0
      Top = 504
      Width = 600
      Height = 46
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object btnUpdate: TButton
        Left = 400
        Top = 10
        Width = 75
        Height = 25
        Caption = #20445#23384
        TabOrder = 0
        OnClick = btnUpdateClick
      end
      object btnCancel: TButton
        Left = 504
        Top = 10
        Width = 75
        Height = 25
        Caption = #21462#28040
        TabOrder = 1
        OnClick = btnCancelClick
      end
    end
  end
end