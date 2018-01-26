unit unit2014;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StrUtils, ComCtrls, ExtCtrls;

  procedure _ExtractGameData2014(sSource, sUrl: String);
  procedure _CreateMemberList(S: String);
  procedure _CreateSubstTime(S: String);
  procedure _CreateCard(S: String);
  procedure _CreateFinalMemberList;
  procedure _CreateCoach(S: String);

implementation

uses
  HideUtils, Main;

procedure _CreateCard(S: String);
var
  i, iPos : Integer;
  sTmp, sName, sTime : String;
begin
  iPos := PosText('<td colspan="2"', S);
  repeat
    sTmp := CopyStrEx(S, '<td colspan="2"', '</td>', iPos);
    sName := RemoveHTMLTags(CopyStrToStr(sTmp, '<img'));
    sTime := RemoveHTMLTags(CopyStr(sTmp, '<span class', '</span>'));
    sTime := ExtractNumber(sTime);

    for i := 1 to 30 do
    begin
      if mlHome[i].sName = sName then
      begin
        if PosText('イエローカード', sTmp) > 0 then
          mlHome[i].sCard := '1'
        else if PosText('レッドカード', sTmp) > 0 then
        begin
          mlHome[i].sCard := '2';
          mlHome[i].sOut := sTime;
        end;
        Break;
      end
      else if mlAway[i].sName = sName then
      begin
        if PosText('イエローカード', sTmp) > 0 then
          mlAway[i].sCard := '1'
        else if PosText('レッドカード', sTmp) > 0 then
        begin
          mlAway[i].sCard := '2';
          mlAway[i].sOut := sTime;
        end;
        Break;
      end;
    end;
    iPos := PosTextEx('<td colspan="2"', S, iPos+1);
  until iPos = 0;
end;

procedure _CreateCoach(S: String);
var
  sl : TStringList;
  i, iPos : Integer;
begin
  sl := TStringList.Create;
  try
    iPos := 0;
    sl.Text := RemoveHTMLTags(S);
    //Home
    for i := 1 to 30 do
    begin
      if mlHome[i].sName = '' then
      begin
        iPos := i;
        Break;
      end;
    end;
    mlHome[iPos].sPos := 'Header';
    mlHome[iPos].sNum := '';
    mlHome[iPos].sName := 'Coach';
    mlHome[iPos].sOut := '';
    mlHome[iPos].sIn := '';
    mlHome[iPos].sCard := '0';
    mlHome[iPos+1].sPos := '';
    mlHome[iPos+1].sNum := '';
    mlHome[iPos+1].sName := sl[1];
    mlHome[iPos+1].sOut := '';
    mlHome[iPos+1].sIn := '';
    mlHome[iPos+1].sCard := '0';

    //Away
    for i := 1 to 30 do
    begin
      if mlAway[i].sName = '' then
      begin
        iPos := i;
        Break;
      end;
    end;
    mlAway[iPos].sPos := 'Header';
    mlAway[iPos].sNum := '';
    mlAway[iPos].sName := 'Coach';
    mlAway[iPos].sOut := '';
    mlAway[iPos].sIn := '';
    mlAway[iPos].sCard := '0';
    mlAway[iPos+1].sPos := '';
    mlAway[iPos+1].sNum := '';
    mlAway[iPos+1].sName := sl[3];
    mlAway[iPos+1].sOut := '';
    mlAway[iPos+1].sIn := '';
    mlAway[iPos+1].sCard := '0';

  finally
    sl.Free;
  end;
end;

procedure _CreateFinalMemberList;
var
  i : Integer;
  sTmp : String;
begin
  //Home
  sTmp := '';
  for i := 1 to 30 do
  begin
    if mlHome[i].sName <> '' then
    begin
      if i = 12 then
      begin
        sTmp := sTmp + 'Header$$Substitutes$$$%';
      end;
      sTmp := sTmp +
              mlHome[i].sPos + '$' +
              mlHome[i].sNum + '$' +
              ReplaceText(mlHome[i].sName, '　', '') + '$' +
              mlHome[i].sIn + '$' +
              mlHome[i].sOut + '$' +
              mlHome[i].sCard + '%';
    end;
  end;
  sGMD[28] := sTmp;
  //Away
  sTmp := '';
  for i := 1 to 30 do
  begin
    if mlAway[i].sName <> '' then
    begin
      if i = 12 then
      begin
        sTmp := sTmp + 'Header$$Substitutes$$$%';
      end;
      sTmp := sTmp +
              mlAway[i].sPos + '$' +
              mlAway[i].sNum + '$' +
              ReplaceText(mlAway[i].sName, '　', '') + '$' +
              mlAway[i].sIn + '$' +
              mlAway[i].sOut + '$' +
              mlAway[i].sCard + '%';
    end;
  end;
  sGMD[28] := sGMD[28] + '#' + sTmp;
end;

procedure _CreateMemberList(S: String);
var
  sl : TStringList;
  iPos, iCnt : Integer;
begin
  iCnt := 0;
  sl := TStringList.Create;
  try
    iPos := PosText('<tr>', S);
    repeat
      sl.Text := CopyStrEx(S, '<tr>', '</tr>', iPos);
      if PosText('<td class="bluecenter', sl.Text) > 0 then
      begin
        mlHome[iCnt].sPos := RemoveHTMLTags(sl[1]);
        mlHome[iCnt].sNum := RemoveHTMLTags(sl[2]);
        mlHome[iCnt].sName:= RemoveHTMLTags(sl[3]);
        mlHome[iCnt].sCard := '0';
        mlAway[iCnt].sPos := RemoveHTMLTags(sl[4]);
        mlAway[iCnt].sNum := RemoveHTMLTags(sl[5]);
        mlAway[iCnt].sName:= RemoveHTMLTags(sl[6]);
        mlAway[iCnt].sCard := '0';
      end;
      iCnt := iCnt + 1;
      iPos := PosTextEx('<tr>', S, iPos+1);
    until iPos = 0;
  finally
    sl.Free;
  end;
end;

procedure _CreateSubstTime(S: String);
var
  i, iPos : Integer;
  sTmp, sName, sTime : String;
begin
  iPos := PosText('<td colspan="2"', S);
  repeat
    sTmp := CopyStrEx(S, '<td colspan="2"', '</td>', iPos);
    sName := RemoveHTMLTags(CopyStrToStr(sTmp, '<span'));
    sTmp  := CopyStr(sTmp, '</em>', '</span>');
    sTime := ExtractNumber(sTmp, True, False);

    for i := 1 to 30 do
    begin
      if mlHome[i].sName = sName then
      begin
        if PosText('OUT', sTmp) > 0 then
          mlHome[i].sOut := sTime
        else
          mlHome[i].sIn := sTime;
        Break;
      end
      else if mlAway[i].sName = sName then
      begin
        if PosText('OUT', sTmp) > 0 then
          mlAway[i].sOut := sTime
        else
          mlAway[i].sIn := sTime;
        Break;
      end;
    end;
    iPos := PosTextEx('<td colspan="2"', S, iPos+1);
  until iPos = 0;
end;

procedure _ExtractGameData2014(sSource, sUrl: String);
var
  sl : TStringList;
  iPos : Integer;
  sTmp, sTmp2 : String;
begin
  sl := TStringList.Create;
  try
    //大会名
    sTmp := CopyStr(sSource, '<div class="premier_title">', '</a>');
    sTmp := CopyStr(sTmp, 'alt=', 'width=');
    sGMD[12] := RemoveRight(RemoveLeft(sTmp, 5), 2);

    //節
    sTmp := CopyStr(sSource, '<div class="topTitleTxt bottom10">', '</div>');
    sTmp := RemoveHTMLTags(sTmp);
    sl.CommaText := sTmp;
    sGMD[27] := sl[2];

    //日付
    sTmp := CopyStr(sSource, '<div class="topTitleTxtMatchPage2', '</div>');
    sTmp := RemoveHTMLTags(sTmp);
    sl.CommaText := sTmp;
    sGMD[1] := ConvertJapaneseDateToYYYMMDD(sl[0]);
    //時間
    sGMD[31] := LeftStr(sl[1], 5);
    //場所
    sGMD[2] := Trim(sl[2]);

    //Home
    iPos := PosText('<h5>', sSource);
    sTmp := CopyStr(sSource, '<h5>', '</h5>');
    sTmp2 := ExtractStringsFromAtoB(sTmp, '（', '）');
    sGMD[3] := Trim(CopyStrToEnd(sTmp, ' ')) + sTmp2;
    //Away
    sTmp := CopyStrEx(sSource, '<h5>', '</h5>', iPos+10);
    sTmp2 := ExtractStringsFromAtoB(sTmp, '（', '）');
    sGMD[4] := Trim(CopyStrToEnd(sTmp, ' ')) + sTmp2;

    //スコア
    sTmp := RemoveHTMLTags(CopyStr(sSource, '<div class="front">', '</div>'));
    sTmp := ReplaceText(sTmp, '　', '');
    SplitByString(sTmp, '前半', sl);
    sGMD[6] := sl[0];
    sGMD[7] := sl[1];
    sTmp := RemoveHTMLTags(CopyStr(sSource, '<div class="latter">', '</div>'));
    sTmp := ReplaceText(sTmp, '　', '');
    SplitByString(sTmp, '後半', sl);
    sGMD[8] := sl[0];
    sGMD[9] := sl[1];
    sGMD[10] := IntToStr(StrToIntDefEx(sGMD[6], 0) + StrToIntDefEx(sGMD[8], 0));
    sGMD[11] := IntToStr(StrToIntDefEx(sGMD[7], 0) + StrToIntDefEx(sGMD[9], 0));
    if StrToInt(sGMD[10]) > StrToInt(sGMD[11]) then
      sGMD[5] := '○'
    else if StrToInt(sGMD[10]) = StrToInt(sGMD[11]) then
      sGMD[5] := '△'
    else
      sGMD[5] := '●';
    //PKの有無
    iPos := PosText('<div class="front">', sSource);
    iPos := PosTextEx('<div class="front">', sSource, iPos+10);
    if iPos > 0 then
    begin
    	sTmp := CopyStrEx(sSource, '<div class="front">', '</div>', iPos);
      sTmp := RemoveHTMLTags(sTmp);
      sTmp := ReplaceText(sTmp, '　', '');
      sGMD[22] := RemoveRight(CopyStrToStr(sTmp, 'PK'), 1);
      sGMD[23] := RemoveLeft(CopyStrToEnd(sTmp, 'PK'), 2);
      sGMD[24] := '1';
    end;

    //得点者
    sTmp := CopyStr(sSource, '<td class="t_right">', '</td>');
    sTmp := ReplaceText(sTmp, '<br />', '%n%');
    sTmp := RemoveHTMLTags(sTmp);
    sTmp := RemoveRight(ReplaceText(sTmp, '分 ', ' '), 3);
    sGMD[13] := ReplaceText(sTmp, '　', '');
    sTmp := CopyStr(sSource, '<td class="t_left">', '</td>');
    sTmp := ReplaceText(sTmp, '<br />', '%n%');
    sTmp := RemoveHTMLTags(sTmp);
    sTmp := RemoveRight(ReplaceText(sTmp, '分 ', ' '), 3);
    sGMD[14] := ReplaceText(sTmp, '　', '');

    //出場選手
    sTmp := CopyStr(sSource, '<table width="100%"', '</table>');
    _CreateMemberList(sTmp);
    sTmp := CopyStr(sSource, '<th colspan="6" class="center">選手交代', '</table>');
    _CreateSubstTime(sTmp);
    sTmp := CopyStr(sSource, '<th colspan="6" class="center">警告・退場', '</table>');
    _CreateCard(sTmp);
    sTmp := CopyStr(sSource, '<td colspan="2" class="bluecenter">監督', '</tr>');
    _CreateCoach(sTmp);
    _CreateFinalMemberList;

    //登録ファイル
    sTmp := ReplaceText(sUrl, '_page', '_report');
    sGMD[26] := ReplaceText(sTmp, '.html', '.pdf') + ';';

    sGMD[15] := '$$';
    sGMD[24] := '0';
    sGMD[25] := '50';
    sGMD[29] := '$$$$$$$$$$$$$$$$$';
    sGMD[30]:= ';;;;;';

    sl.Clear;
    for iPos := 1 to 39 do
      sl.Add(sGMD[iPos]);

    slList.Add(sl.CommaText);

  finally
    sl.Free;
  end;
end;

end.
