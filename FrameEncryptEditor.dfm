object FrameEncryptEditor: TFrameEncryptEditor
  Left = 0
  Top = 0
  Width = 740
  Height = 500
  TabOrder = 0
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 740
    Height = 500
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object grpEncrypt: TGroupBox
      Left = 8
      Top = 8
      Width = 724
      Height = 484
      Align = alClient
      Caption = '加密/安全设置'
      Padding.Left = 8
      Padding.Top = 8
      Padding.Right = 8
      Padding.Bottom = 8
      TabOrder = 0
      object lblName: TLabel
        Left = 16
        Top = 24
        Width = 24
        Height = 13
        Caption = '名称:'
      end
      object lblDescription: TLabel
        Left = 16
        Top = 51
        Width = 24
        Height = 13
        Caption = '描述:'
      end
      object edtName: TEdit
        Left = 64
        Top = 21
        Width = 641
        Height = 21
        TabOrder = 0
      end
      object memDescription: TMemo
        Left = 64
        Top = 48
        Width = 641
        Height = 48
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object pcEncrypt: TPageControl
        Left = 10
        Top = 102
        Width = 704
        Height = 322
        ActivePage = tsAlgorithm
        Align = alBottom
        TabOrder = 2
        object tsAlgorithm: TTabSheet
          Caption = '算法设置'
          object pnlAlgorithm: TPanel
            Left = 0
            Top = 0
            Width = 696
            Height = 294
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object lblEncryptionType: TLabel
              Left = 16
              Top = 16
              Width = 48
              Height = 13
              Caption = '加密类型:'
            end
            object lblAlgorithm: TLabel
              Left = 16
              Top = 43
              Width = 24
              Height = 13
              Caption = '算法:'
            end
            object lblKeySize: TLabel
              Left = 16
              Top = 70
              Width = 48
              Height = 13
              Caption = '密钥大小:'
            end
            object lblMode: TLabel
              Left = 16
              Top = 97
              Width = 24
              Height = 13
              Caption = '模式:'
            end
            object lblPadding: TLabel
              Left = 16
              Top = 124
              Width = 48
              Height = 13
              Caption = '填充方式:'
            end
            object lblIV: TLabel
              Left = 16
              Top = 178
              Width = 26
              Height = 13
              Caption = 'IV值:'
            end
            object cbbEncryptionType: TComboBox
              Left = 80
              Top = 13
              Width = 145
              Height = 21
              Style = csDropDownList
              TabOrder = 0
              OnChange = cbbEncryptionTypeChange
            end
            object cbbAlgorithm: TComboBox
              Left = 80
              Top = 40
              Width = 145
              Height = 21
              Style = csDropDownList
              TabOrder = 1
            end
            object cbbKeySize: TComboBox
              Left = 80
              Top = 67
              Width = 145
              Height = 21
              Style = csDropDownList
              TabOrder = 2
            end
            object cbbMode: TComboBox
              Left = 80
              Top = 94
              Width = 145
              Height = 21
              Style = csDropDownList
              TabOrder = 3
            end
            object cbbPadding: TComboBox
              Left = 80
              Top = 121
              Width = 145
              Height = 21
              Style = csDropDownList
              TabOrder = 4
            end
            object chkUseIV: TCheckBox
              Left = 16
              Top = 151
              Width = 65
              Height = 17
              Caption = '使用IV'
              TabOrder = 5
              OnClick = chkUseIVClick
            end
            object chkDefaultIV: TCheckBox
              Left = 88
              Top = 151
              Width = 97
              Height = 17
              Caption = '使用默认IV'
              TabOrder = 6
              OnClick = chkDefaultIVClick
            end
            object edtIV: TEdit
              Left = 80
              Top = 175
              Width = 321
              Height = 21
              TabOrder = 7
            end
            object btnGenerateIV: TButton
              Left = 407
              Top = 173
              Width = 75
              Height = 25
              Caption = '生成IV'
              TabOrder = 8
              OnClick = btnGenerateIVClick
            end
          end
        end
        object tsKeys: TTabSheet
          Caption = '密钥管理'
          ImageIndex = 1
          object pnlKeys: TPanel
            Left = 0
            Top = 0
            Width = 696
            Height = 294
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object lblKeyFormat: TLabel
              Left = 16
              Top = 16
              Width = 48
              Height = 13
              Caption = '密钥格式:'
            end
            object lblPrivateKey: TLabel
              Left = 16
              Top = 43
              Width = 60
              Height = 13
              Caption = '私钥文件:'
            end
            object lblPublicKey: TLabel
              Left = 16
              Top = 70
              Width = 60
              Height = 13
              Caption = '公钥文件:'
            end
            object lblPassword: TLabel
              Left = 16
              Top = 124
              Width = 24
              Height = 13
              Caption = '密码:'
            end
            object lblSalt: TLabel
              Left = 16
              Top = 151
              Width = 12
              Height = 13
              Caption = '盐:'
            end
            object lblIterations: TLabel
              Left = 16
              Top = 178
              Width = 48
              Height = 13
              Caption = '迭代次数:'
            end
            object lblKeyDerivation: TLabel
              Left = 16
              Top = 205
              Width = 72
              Height = 13
              Caption = '密钥派生函数:'
            end
            object cbbKeyFormat: TComboBox
              Left = 96
              Top = 13
              Width = 145
              Height = 21
              Style = csDropDownList
              TabOrder = 0
            end
            object edtPrivateKeyFile: TEdit
              Left = 96
              Top = 40
              Width = 321
              Height = 21
              TabOrder = 1
            end
            object btnBrowsePrivateKey: TButton
              Left = 423
              Top = 38
              Width = 75
              Height = 25
              Caption = '浏览...'
              TabOrder = 2
              OnClick = btnBrowsePrivateKeyClick
            end
            object edtPublicKeyFile: TEdit
              Left = 96
              Top = 67
              Width = 321
              Height = 21
              TabOrder = 3
            end
            object btnBrowsePublicKey: TButton
              Left = 423
              Top = 65
              Width = 75
              Height = 25
              Caption = '浏览...'
              TabOrder = 4
              OnClick = btnBrowsePublicKeyClick
            end
            object chkGenerateKeyPair: TCheckBox
              Left = 16
              Top = 94
              Width = 121
              Height = 17
              Caption = '自动生成密钥对'
              TabOrder = 5
              OnClick = chkGenerateKeyPairClick
            end
            object edtPassword: TEdit
              Left = 96
              Top = 121
              Width = 321
              Height = 21
              PasswordChar = '*'
              TabOrder = 6
            end
            object chkShowPassword: TCheckBox
              Left = 423
              Top = 123
              Width = 75
              Height = 17
              Caption = '显示密码'
              TabOrder = 7
              OnClick = chkShowPasswordClick
            end
            object btnGeneratePassword: TButton
              Left = 504
              Top = 119
              Width = 75
              Height = 25
              Caption = '生成密码'
              TabOrder = 8
              OnClick = btnGeneratePasswordClick
            end
            object edtSalt: TEdit
              Left = 96
              Top = 148
              Width = 321
              Height = 21
              TabOrder = 9
            end
            object btnGenerateSalt: TButton
              Left = 423
              Top = 146
              Width = 75
              Height = 25
              Caption = '生成盐值'
              TabOrder = 10
              OnClick = btnGenerateSaltClick
            end
            object edtIterations: TEdit
              Left = 96
              Top = 175
              Width = 321
              Height = 21
              TabOrder = 11
            end
            object cbbKeyDerivation: TComboBox
              Left = 96
              Top = 202
              Width = 145
              Height = 21
              Style = csDropDownList
              TabOrder = 12
            end
          end
        end
        object tsCertificate: TTabSheet
          Caption = '证书设置'
          ImageIndex = 2
          object pnlCertificate: TPanel
            Left = 0
            Top = 0
            Width = 696
            Height = 294
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object lblCertificateFile: TLabel
              Left = 16
              Top = 16
              Width = 48
              Height = 13
              Caption = '证书文件:'
            end
            object lblCertificatePassword: TLabel
              Left = 16
              Top = 43
              Width = 48
              Height = 13
              Caption = '证书密码:'
            end
            object lblCertificateAuth: TLabel
              Left = 16
              Top = 70
              Width = 60
              Height = 13
              Caption = '证书颁发者:'
            end
            object lblCertificateStore: TLabel
              Left = 16
              Top = 97
              Width = 60
              Height = 13
              Caption = '证书存储位:'
            end
            object edtCertificateFile: TEdit
              Left = 96
              Top = 13
              Width = 321
              Height = 21
              TabOrder = 0
            end
            object btnBrowseCertificate: TButton
              Left = 423
              Top = 11
              Width = 75
              Height = 25
              Caption = '浏览...'
              TabOrder = 1
              OnClick = btnBrowseCertificateClick
            end
            object edtCertificatePassword: TEdit
              Left = 96
              Top = 40
              Width = 321
              Height = 21
              PasswordChar = '*'
              TabOrder = 2
            end
            object chkShowCertPassword: TCheckBox
              Left = 423
              Top = 42
              Width = 75
              Height = 17
              Caption = '显示密码'
              TabOrder = 3
              OnClick = chkShowCertPasswordClick
            end
            object cbbCertificateAuth: TComboBox
              Left = 96
              Top = 67
              Width = 145
              Height = 21
              Style = csDropDownList
              TabOrder = 4
            end
            object cbbCertificateStore: TComboBox
              Left = 96
              Top = 94
              Width = 145
              Height = 21
              Style = csDropDownList
              TabOrder = 5
            end
            object chkVerifyCertificate: TCheckBox
              Left = 16
              Top = 121
              Width = 121
              Height = 17
              Caption = '验证证书'
              TabOrder = 6
            end
          end
        end
      end
      object pnlButtons: TPanel
        Left = 10
        Top = 424
        Width = 704
        Height = 50
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 3
        object btnUpdate: TButton
          Left = 434
          Top = 16
          Width = 75
          Height = 25
          Caption = '更新'
          TabOrder = 0
          OnClick = btnUpdateClick
        end
        object btnCancel: TButton
          Left = 522
          Top = 16
          Width = 75
          Height = 25
          Caption = '取消'
          TabOrder = 1
          OnClick = btnCancelClick
        end
        object btnTest: TButton
          Left = 610
          Top = 16
          Width = 75
          Height = 25
          Caption = '测试'
          TabOrder = 2
          OnClick = btnTestClick
        end
        object btnGenerate: TButton
          Left = 16
          Top = 16
          Width = 105
          Height = 25
          Caption = '生成密钥'
          TabOrder = 3
          OnClick = btnGenerateClick
        end
      end
    end
  end
  object dlgOpenKey: TOpenDialog
    Left = 456
    Top = 248
  end
  object dlgOpenCert: TOpenDialog
    Left = 528
    Top = 248
  end
end 