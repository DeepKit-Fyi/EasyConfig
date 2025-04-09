object frmComplexEditor: TfrmComplexEditor
  Left = 0
  Top = 0
  Caption = '澶嶆潅缂栬緫鍣?
  ClientHeight = 400
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 400
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnlContent: TPanel
      Left = 0
      Top = 0
      Width = 600
      Height = 350
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object lblConfigName: TLabel
        Left = 16
        Top = 16
        Width = 60
        Height = 13
        Caption = '閰嶇疆鍚嶇О锛?
      end
      object lblConfigType: TLabel
        Left = 16
        Top = 48
        Width = 60
        Height = 13
        Caption = '閰嶇疆绫诲瀷锛?
      end
      object edtName: TEdit
        Left = 88
        Top = 13
        Width = 489
        Height = 21
        TabOrder = 0
      end
      object cbbConfigType: TComboBox
        Left = 88
        Top = 45
        Width = 489
        Height = 21
        Style = csDropDownList
        TabOrder = 1
        OnChange = cbbConfigTypeChange
      end
      object pnlEditor: TPanel
        Left = 16
        Top = 80
        Width = 561
        Height = 254
        BevelOuter = bvNone
        TabOrder = 2
        object nbkEditors: TNotebook
          Left = 0
          Top = 0
          Width = 561
          Height = 254
          Align = alClient
          TabOrder = 0
          object TPage
            Left = 0
            Top = 0
            Caption = 'pgEnumEditor'
            object pnlEnumEditor: TPanel
              Left = 0
              Top = 0
              Width = 561
              Height = 254
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 0
              object lblValues: TLabel
                Left = 0
                Top = 0
                Width = 60
                Height = 13
                Caption = '鍙€夊€煎垪琛?
              end
              object lstValues: TListBox
                Left = 0
                Top = 19
                Width = 561
                Height = 235
                Align = alBottom
                ItemHeight = 13
                TabOrder = 0
              end
            end
          end
          object TPage
            Left = 0
            Top = 0
            Caption = 'pgColorEditor'
            object pnlColorEditor: TPanel
              Left = 0
              Top = 0
              Width = 561
              Height = 254
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 0
              object lblColor: TLabel
                Left = 0
                Top = 0
                Width = 24
                Height = 13
                Caption = '棰滆壊'
              end
              object pnlColor: TPanel
                Left = 0
                Top = 19
                Width = 561
                Height = 235
                Align = alBottom
                BevelOuter = bvRaised
                TabOrder = 0
                object btnSelectColor: TButton
                  Left = 233
                  Top = 105
                  Width = 94
                  Height = 25
                  Caption = '閫夋嫨棰滆壊...'
                  TabOrder = 0
                  OnClick = btnSelectColorClick
                end
              end
            end
          end
          object TPage
            Left = 0
            Top = 0
            Caption = 'pgDateTimeEditor'
            object pnlDateTimeEditor: TPanel
              Left = 0
              Top = 0
              Width = 561
              Height = 254
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 0
              object lblDateTime: TLabel
                Left = 0
                Top = 0
                Width = 48
                Height = 13
                Caption = '鏃ユ湡鏃堕棿'
              end
              object dtpDateTime: TDateTimePicker
                Left = 0
                Top = 19
                Width = 561
                Height = 21
                Date = 45168.000000000000000000
                Time = 45168.000000000000000000
                TabOrder = 0
              end
            end
          end
          object TPage
            Left = 0
            Top = 0
            Caption = 'pgTimeSpanEditor'
            object pnlTimeSpanEditor: TPanel
              Left = 0
              Top = 0
              Width = 561
              Height = 254
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 0
              object lblDays: TLabel
                Left = 24
                Top = 24
                Width = 24
                Height = 13
                Caption = '澶╂暟'
              end
              object lblHours: TLabel
                Left = 24
                Top = 64
                Width = 24
                Height = 13
                Caption = '灏忔椂'
              end
              object lblMinutes: TLabel
                Left = 24
                Top = 104
                Width = 24
                Height = 13
                Caption = '鍒嗛挓'
              end
              object lblSeconds: TLabel
                Left = 24
                Top = 144
                Width = 24
                Height = 13
                Caption = '绉掓暟'
              end
              object edtDays: TEdit
                Left = 80
                Top = 21
                Width = 121
                Height = 21
                TabOrder = 0
                Text = '0'
              end
              object edtHours: TEdit
                Left = 80
                Top = 61
                Width = 121
                Height = 21
                TabOrder = 1
                Text = '0'
              end
              object edtMinutes: TEdit
                Left = 80
                Top = 101
                Width = 121
                Height = 21
                TabOrder = 2
                Text = '0'
              end
              object edtSeconds: TEdit
                Left = 80
                Top = 141
                Width = 121
                Height = 21
                TabOrder = 3
                Text = '0'
              end
            end
          end
          object TPage
            Left = 0
            Top = 0
            Caption = 'pgFileEditor'
            object pnlFileEditor: TPanel
              Left = 0
              Top = 0
              Width = 561
              Height = 254
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 0
              object lblFilePath: TLabel
                Left = 0
                Top = 0
                Width = 48
                Height = 13
                Caption = '鏂囦欢璺緞'
              end
              object edtFilePath: TEdit
                Left = 0
                Top = 19
                Width = 481
                Height = 21
                TabOrder = 0
              end
              object btnBrowseFile: TButton
                Left = 487
                Top = 19
                Width = 74
                Height = 21
                Caption = '娴忚...'
                TabOrder = 1
                OnClick = btnBrowseFileClick
              end
            end
          end
          object TPage
            Left = 0
            Top = 0
            Caption = 'pgPathEditor'
            object pnlPathEditor: TPanel
              Left = 0
              Top = 0
              Width = 561
              Height = 254
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 0
              object lblPath: TLabel
                Left = 0
                Top = 0
                Width = 48
                Height = 13
                Caption = '鐩綍璺緞'
              end
              object edtPath: TEdit
                Left = 0
                Top = 19
                Width = 481
                Height = 21
                TabOrder = 0
              end
              object btnBrowsePath: TButton
                Left = 487
                Top = 19
                Width = 74
                Height = 21
                Caption = '娴忚...'
                TabOrder = 1
                OnClick = btnBrowsePathClick
              end
            end
          end
        end
      end
    end
    object pnlButtons: TPanel
      Left = 0
      Top = 350
      Width = 600
      Height = 50
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object btnOK: TButton
        Left = 404
        Top = 14
        Width = 85
        Height = 25
        Caption = '纭畾'
        Default = True
        TabOrder = 0
        OnClick = btnOKClick
      end
      object btnCancel: TButton
        Left = 495
        Top = 14
        Width = 85
        Height = 25
        Cancel = True
        Caption = '鍙栨秷'
        ModalResult = 2
        TabOrder = 1
        OnClick = btnCancelClick
      end
    end
  end
  object dlgColor: TColorDialog
    Left = 304
    Top = 184
  end
  object dlgOpen: TOpenDialog
    Left = 352
    Top = 184
  end
  object dlgBrowseFolder: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = [fdoPickFolders]
    Left = 400
    Top = 184
  end
end 