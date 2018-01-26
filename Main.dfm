object frmMain: TfrmMain
  Left = 336
  Top = 226
  BorderStyle = bsDialog
  Caption = 'JFA.jp'
  ClientHeight = 243
  ClientWidth = 508
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblFilename: TLabel
    Left = 80
    Top = 156
    Width = 420
    Height = 13
    AutoSize = False
  end
  object lblInfo: TLabel
    Left = 80
    Top = 184
    Width = 420
    Height = 13
    AutoSize = False
  end
  object Label3: TLabel
    Left = 12
    Top = 156
    Width = 62
    Height = 13
    Caption = #20837#21147#12501#12449#12452#12523':'
  end
  object Label4: TLabel
    Left = 12
    Top = 212
    Width = 52
    Height = 13
    Caption = #21462#24471#24180#24230':'
  end
  object Label5: TLabel
    Left = 12
    Top = 184
    Width = 28
    Height = 13
    Caption = #32076#36942':'
  end
  object btnOk: TButton
    Left = 339
    Top = 206
    Width = 75
    Height = 25
    Caption = #21462#24471
    TabOrder = 2
    OnClick = btnOkClick
  end
  object PageControl: TPageControl
    Left = 8
    Top = 8
    Width = 492
    Height = 137
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #19968#35430#21512#12398#12415
      object edtGameUrl: TLabeledEdit
        Left = 8
        Top = 36
        Width = 470
        Height = 21
        EditLabel.Width = 53
        EditLabel.Height = 13
        EditLabel.Caption = #35430#21512#12398'URL'
        TabOrder = 0
        OnClick = edtGameUrlClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = #12377#12409#12390#12398#35430#21512
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object edtAllUrl: TLabeledEdit
        Left = 8
        Top = 36
        Width = 470
        Height = 21
        EditLabel.Width = 217
        EditLabel.Height = 13
        EditLabel.Caption = #12505#12540#12473#12392#12394#12427'URL(m1.html '#12398#37096#20998#12434#38500#12356#12383'URL)'
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = #36899#32154#12375#12383#35430#21512
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 135
        Top = 80
        Width = 18
        Height = 13
        Caption = #12363#12425
      end
      object Label2: TLabel
        Left = 215
        Top = 80
        Width = 19
        Height = 13
        Caption = #12414#12391
      end
      object Label6: TLabel
        Left = 8
        Top = 76
        Width = 68
        Height = 13
        Caption = #12510#12483#12481#12490#12531#12496#12540':'
      end
      object edtFromTo: TLabeledEdit
        Left = 8
        Top = 36
        Width = 470
        Height = 21
        EditLabel.Width = 217
        EditLabel.Height = 13
        EditLabel.Caption = #12505#12540#12473#12392#12394#12427'URL(m1.html '#12398#37096#20998#12434#38500#12356#12383'URL)'
        TabOrder = 0
      end
      object edtStart: TEdit
        Left = 88
        Top = 72
        Width = 41
        Height = 21
        Alignment = taRightJustify
        NumbersOnly = True
        TabOrder = 1
      end
      object edtEnd: TEdit
        Left = 168
        Top = 72
        Width = 41
        Height = 21
        Alignment = taRightJustify
        NumbersOnly = True
        TabOrder = 2
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'PDF'#12398#21462#24471
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label7: TLabel
        Left = 8
        Top = 76
        Width = 68
        Height = 13
        Caption = #12510#12483#12481#12490#12531#12496#12540':'
      end
      object Label8: TLabel
        Left = 135
        Top = 80
        Width = 18
        Height = 13
        Caption = #12363#12425
      end
      object Label9: TLabel
        Left = 215
        Top = 80
        Width = 19
        Height = 13
        Caption = #12414#12391
      end
      object edtPDF: TLabeledEdit
        Left = 8
        Top = 36
        Width = 470
        Height = 21
        EditLabel.Width = 217
        EditLabel.Height = 13
        EditLabel.Caption = #12505#12540#12473#12392#12394#12427'URL(m1.html '#12398#37096#20998#12434#38500#12356#12383'URL)'
        TabOrder = 0
      end
      object edtPDFStart: TEdit
        Left = 88
        Top = 72
        Width = 41
        Height = 21
        Alignment = taRightJustify
        NumbersOnly = True
        TabOrder = 1
      end
      object edtPDFEnd: TEdit
        Left = 168
        Top = 72
        Width = 41
        Height = 21
        Alignment = taRightJustify
        NumbersOnly = True
        TabOrder = 2
      end
    end
  end
  object btnCancel: TButton
    Left = 425
    Top = 206
    Width = 75
    Height = 25
    Caption = #12461#12515#12531#12475#12523
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object cmbYear: THideComboBox
    Left = 80
    Top = 210
    Width = 161
    Height = 21
    AutoComplete = False
    Style = csDropDownList
    DropDownCount = 20
    TabOrder = 1
    OnClick = cmbYearClick
    OnDropDown = cmbYearDropDown
  end
  object btnWeb: TButton
    Left = 247
    Top = 210
    Width = 30
    Height = 22
    Caption = 'Web'
    TabOrder = 4
    OnClick = btnWebClick
  end
end
