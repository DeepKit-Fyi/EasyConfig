object FrameDateTimeRangeEditor: TFrameDateTimeRangeEditor
  Left = 0
  Top = 0
  Width = 600
  Height = 550
  TabOrder = 0
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 550
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object grpDateTimeRange: TGroupBox
      Left = 16
      Top = 16
      Width = 568
      Height = 473
      Caption = #26085#26399#26102#38388#33539#22260#35774#32622
      TabOrder = 0
      object lblStartDate: TLabel
        Left = 24
        Top = 104
        Width = 60
        Height = 17
        Caption = #24320#22987#26085#26399':'
      end
      object lblEndDate: TLabel
        Left = 24
        Top = 144
        Width = 60
        Height = 17
        Caption = #32467#26463#26085#26399':'
      end
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
      object lblDuration: TLabel
        Left = 24
        Top = 184
        Width = 60
        Height = 17
        Caption = #25345#32493#26102#38388':'
      end
      object lblRepeatInterval: TLabel
        Left = 297
        Top = 256
        Width = 48
        Height = 17
        Caption = #38388#38548#20540':'
      end
      object lblNotifyBefore: TLabel
        Left = 24
        Top = 312
        Width = 72
        Height = 17
        Caption = #25552#21069#25552#37266':'
      end
      object dtpStartDate: TDateTimePicker
        Left = 96
        Top = 104
        Width = 201
        Height = 25
        Date = 45218.000000000000000000
        Time = 0.819444444442398000
        TabOrder = 2
        OnChange = dtpStartDateChange
      end
      object dtpEndDate: TDateTimePicker
        Left = 96
        Top = 144
        Width = 201
        Height = 25
        Date = 45219.000000000000000000
        Time = 0.819444444442398000
        TabOrder = 3
        OnChange = dtpEndDateChange
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
      object chkUseTime: TCheckBox
        Left = 320
        Top = 104
        Width = 97
        Height = 17
        Caption = #21253#21547#26102#38388
        TabOrder = 4
        OnClick = chkUseTimeClick
      end
      object edtDuration: TEdit
        Left = 96
        Top = 184
        Width = 328
        Height = 25
        ReadOnly = True
        TabOrder = 5
      end
      object btnCalcDuration: TButton
        Left = 432
        Top = 184
        Width = 105
        Height = 25
        Caption = #35745#31639#25345#32493#26102#38388
        TabOrder = 6
        OnClick = btnCalcDurationClick
      end
      object chkRepeat: TCheckBox
        Left = 24
        Top = 224
        Width = 97
        Height = 17
        Caption = #37325#22797
        TabOrder = 7
        OnClick = chkRepeatClick
      end
      object cbbRepeatType: TComboBox
        Left = 96
        Top = 256
        Width = 185
        Height = 25
        Style = csDropDownList
        TabOrder = 8
      end
      object edtRepeatInterval: TEdit
        Left = 352
        Top = 256
        Width = 80
        Height = 25
        TabOrder = 9
        Text = '1'
      end
      object chkEnableNotification: TCheckBox
        Left = 24
        Top = 288
        Width = 97
        Height = 17
        Caption = #21551#29992#25552#37266
        TabOrder = 10
        OnClick = chkEnableNotificationClick
      end
      object edtNotifyBefore: TEdit
        Left = 96
        Top = 312
        Width = 80
        Height = 25
        TabOrder = 11
        Text = '15'
      end
      object cbbNotifyUnit: TComboBox
        Left = 192
        Top = 312
        Width = 145
        Height = 25
        Style = csDropDownList
        TabOrder = 12
      end
      object memExtraSettings: TMemo
        Left = 24
        Top = 352
        Width = 513
        Height = 105
        Lines.Strings = (
          #20854#20182#35774#32622#65306
          #36825#37324#21487#20197#28155#21152#33258#23450#20041#23646#24615#65292#36890#36807'key=value'#26684#24335#27599#34892#19968#20010)
        ScrollBars = ssVertical
        TabOrder = 13
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