{
//        1 日付
//          場所
//          ホーム
//          アウェイ
//        5 結果
//          H前半
//          A前半
//          H後半
//          A後半
//        10  H合計
//          A合計
//          大会名
//          H得点者
//          A得点者
//        15  観衆$気温$湿度
//          コメント
//          フォーメーション
//          H延長前半
//          A延長前半
//        20  H延長後半
//          A延長後半
//          H PK
//          A PK
//          延長のチェック
//        25  天気(Def='50')
//          登録ファイル
//          節
//          選手名(POS$NUM$NAME$IN$OUT$CARD%POS$NUM$NAME$IN$OUT$CARD%+ '#' + sPlayerA);
//          スタッツ
//        30  審判('主審;副審1;副審2;第四審;追加副審1;追加副審2')
//          時間
//          得点経過
//          PK戦
//          (空白)
//        35  (空白)
//          (空白)
//          (空白)
//          (空白)
//        39  (空白)
//        sn.Add(sm.CommaText);
}
unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StrUtils, ComCtrls, ExtCtrls, HideComboBox, IniFilesDX,
  Winapi.ShlObj;

type
  TfrmMain = class(TForm)
    btnOk: TButton;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    btnCancel: TButton;
    edtGameUrl: TLabeledEdit;
    edtAllUrl: TLabeledEdit;
    lblFilename: TLabel;
    lblInfo: TLabel;
    TabSheet2: TTabSheet;
    edtFromTo: TLabeledEdit;
    edtStart: TEdit;
    edtEnd: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    cmbYear: THideComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    btnWeb: TButton;
    TabSheet4: TTabSheet;
    edtPDF: TLabeledEdit;
    Label7: TLabel;
    edtPDFStart: TEdit;
    Label8: TLabel;
    edtPDFEnd: TEdit;
    Label9: TLabel;
    procedure btnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmbYearClick(Sender: TObject);
    procedure edtGameUrlClick(Sender: TObject);
    procedure btnWebClick(Sender: TObject);
    procedure cmbYearDropDown(Sender: TObject);
  private
    { Private 宣言 }
    procedure _Init;
    procedure _DownloadData(sUrl: String);
    procedure _DownloadPDF(sUrl: String);
    procedure _LoadSettings;
    procedure _SaveSettings;
    procedure _LoadCopmeList;
  public
    { Public 宣言 }
  end;

  TMemberList = record
    sPos, sNum, sName, sOut, sIn, sCard : String;
  end;

var
  frmMain: TfrmMain;
  slList : TStringList;
  sGMD : array[1..39] of String;
  mlHome : array[1..30] of TMemberList;
  mlAway : array[1..30] of TMemberList;

implementation

{$R *.dfm}

{ TfrmMain }

uses
  HideUtils,
  unit2014,
  unit2015,
  unit2016,
  unit2017,
  unitHighSchool2015,
  unitEmperor2015,
  unitEmperor2016,
  unitEastAsia2017,
  dp;

procedure TfrmMain.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.btnOkClick(Sender: TObject);
var
  i, iStart, iEnd : Integer;
  sUrl : String;
begin
  btnOk.Enabled := False;
  Case PageControl.ActivePageIndex of
    0..2 :
      begin
//        if lblFilename.Caption = '' then
//        begin
//          ShowMessage('入力ファイルが指定されていません。処理を中止します。');
//          Exit;
//        end;

        slList := TStringList.Create;
        try
          if Not IsDebugMode then
            slList.LoadFromFile(lblFilename.Caption, TEncoding.Unicode);
          Case PageControl.ActivePageIndex of
            0 :
              begin
                lblInfo.Caption := edtGameUrl.Text + 'を取得中...';
                Application.ProcessMessages;
                _DownloadData(Trim(edtGameUrl.Text));
              end;
            1 :
              begin
                if RightStr(edtAllUrl.Text, 1) <> '/' then
                  edtAllUrl.Text := edtAllUrl.Text + '/';

                for i := 1 to 47 do
                begin
                  lblInfo.Caption := 'm' + IntToStr(i) + '.html を取得中...';
                  Application.ProcessMessages;
                  _DownloadData(Trim(edtAllUrl.Text) + 'm' + IntToStr(i) + '.html');
                end;
              end;
            2 :
              begin
                if RightStr(edtFromTo.Text, 1) <> '/' then
                  edtFromTo.Text := edtFromTo.Text + '/';

                iStart := StrToIntDefEx(edtStart.Text, 0);
                iEnd := StrToIntDefEx(edtEnd.Text, 0);
                for i := iStart to iEnd do
                begin
                  lblInfo.Caption := 'm' + IntToStr(i) + '.html を取得中...';
                  Application.ProcessMessages;
                  _DownloadData(Trim(edtFromTo.Text) + 'm' + IntToStr(i) + '.html');
                end;
              end;
          end;
          if Not IsDebugMode then
            slList.SaveToFile(lblFilename.Caption, TEncoding.Unicode);
          lblInfo.Caption := '終了しました';
        finally
          slList.Free;
        end;
      end;
    3 :
      begin
        iStart := StrToIntDefEx(edtPDFStart.Text, 0);
        iEnd := StrToIntDefEx(edtPDFEnd.Text, 0);
        for i := iStart to iEnd do
        begin
          sUrl := Trim(Format(edtPDF.Text, [i]));
          lblInfo.Caption := sUrl + 'を取得中...';
          Application.ProcessMessages;
          _DownloadPDF(sUrl);
        end;
        lblInfo.Caption := '終了しました';
      end;
  End;
  btnOk.Enabled := True;
end;

procedure TfrmMain.btnWebClick(Sender: TObject);
var
  ini : TMemIniFile;
  s : String;
begin
  ini := TMemIniFile.Create(GetApplicationPath + 'plugin_JFA_CompeList.ini', TEncoding.UTF8);
  try
    s := ini.ReadString(cmbYear.Text, 'Web', '');
  finally
    ini.Free;
  end;
  ShellExecuteSimple(s);
end;

procedure TfrmMain.cmbYearClick(Sender: TObject);
var
  ini : TMemIniFile;
  s, sPDF : String;
begin
  ini := TMemIniFile.Create(GetApplicationPath + 'plugin_JFA_CompeList.ini', TEncoding.UTF8);
  try
    s := ini.ReadString(cmbYear.Text, 'Url', '');
    sPDF := ini.ReadString(cmbYear.Text, 'PDF', '');
    edtGameUrl.Text := s + 'm1.html';
    edtAllUrl.Text := s;
    edtFromTo.Text := s;
    edtPDF.Text := sPDF;
  finally
    ini.Free;
  end;
end;

procedure TfrmMain.cmbYearDropDown(Sender: TObject);
begin
  _LoadCopmeList;
end;

procedure TfrmMain.edtGameUrlClick(Sender: TObject);
var
  iStart, iEnd : Integer;
begin
  iStart := PosText('_page/m', edtGameUrl.Text);
  iEnd := PosText('.html', edtGameUrl.Text);
  edtGameUrl.SelStart := iStart + 6;
  edtGameUrl.SelLength := iEnd - iStart - 7;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  _SaveSettings;
  Release;
  frmMain := nil;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  _LoadSettings;
  lblFilename.Caption := ParamStr(1);
end;

procedure TfrmMain._DownloadData(sUrl: String);
var
  ini : TMemIniFile;
  sl : TStringList;
  sName, sDivStr : String;
begin
  _Init;
  sl := TStringList.Create;
  ini := TMemIniFile.Create(GetApplicationPath + 'plugin_JFA_CompeList.ini', TEncoding.UTF8);
  try
    sName   := ini.ReadString(cmbYear.Text, 'ProcedureType', '');
    sDivStr := ini.ReadString(cmbYear.Text, 'DivStr', '');
    DownloadHttpToStringList(sUrl, sl, TEncoding.UTF8);

    if sName = 'HighSchool2014' then
      _ExtractGameData2014(sl.Text, sUrl)
    else if sName = 'HighSchool2015' then
      _ExtractGameData2015HighSchool(sl.Text, sUrl, sDivStr)
//    else if sName = 'HighSchool2016' then
//      _ExtractGameData2016(sl.Text, sUrl)
//    else if sName = 'HighSchool2017' then
//      _ExtractGameData2017(sl.Text, sUrl)
    else if sName = 'Emperores2015' then
      _ExtractGameData2015EmperorsCup(sl.Text, sUrl)
    else if sName = 'Emperores2016' then
      _ExtractGameData2016EmperorsCup(sl.Text, sUrl)
    else if sName = 'EastAsia2017' then
      _ExtractGameData2017EastAsia(sl.Text, sUrl);
  finally
    sl.Free;
    ini.Free;
  end;
end;

procedure TfrmMain._DownloadPDF(sUrl: String);
begin
  DownloadFile(sUrl, GetSpecialFolderPath(CSIDL_DESKTOP));
end;

procedure TfrmMain._Init;
var
  i : Integer;
begin
  for i := 1 to 30 do
  begin
    mlHome[i].sPos := '';
    mlHome[i].sNum := '';
    mlHome[i].sName := '';
    mlHome[i].sOut := '';
    mlHome[i].sIn := '';
    mlHome[i].sCard := '';
    mlAway[i].sPos := '';
    mlAway[i].sNum := '';
    mlAway[i].sName := '';
    mlAway[i].sOut := '';
    mlAway[i].sIn := '';
    mlAway[i].sCard := '';
  end;

  for i := 1 to 39 do
    sGMD[i] := '';
end;

procedure TfrmMain._LoadCopmeList;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(GetApplicationPath + 'plugin_JFA_CompeList.ini', TEncoding.UTF8);
  try
    cmbYear.Items.Clear;
    ini.ReadSections(cmbYear.Items);
  finally
    ini.Free;
  end;
end;

procedure TfrmMain._LoadSettings;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    ini.ReadWindowPosition(Self.Name, Self);
  finally
    ini.Free;
  end;
end;

procedure TfrmMain._SaveSettings;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    ini.WriteWindowPosition(Self.Name, Self);
  finally
    ini.UpdateFile;
    ini.Free;
  end;
end;

end.
