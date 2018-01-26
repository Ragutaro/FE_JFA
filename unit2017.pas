unit unit2017;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StrUtils, ComCtrls, ExtCtrls;

  procedure _ExtractGameData2017(sSource, sUrl: String);
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
    sTime := RemoveHTMLTags(CopyStr(sTmp, '<span class', '分'));
    sTime := ExtractNumber(sTime);

    for i := 1 to 30 do
    begin
      if mlHome[i].sName = sName then
      begin
        if PosText('tim_mem_ico_02', sTmp) > 0 then
          mlHome[i].sCard := '1'
        else if PosText('tim_mem_ico_01', sTmp) > 0 then
        begin
          mlHome[i].sCard := '2';
          mlHome[i].sOut := sTime;
        end;
        Break;
      end
      else if mlAway[i].sName = sName then
      begin
        if PosText('tim_mem_ico_02', sTmp) > 0 then
          mlAway[i].sCard := '1'
        else if PosText('tim_mem_ico_01', sTmp) > 0 then
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
  sTmp, sDiv : String;
begin
  sl := TStringList.Create;
  try
    sTmp := CopyStrToEnd(S, '<td class="separate" colspan="6"></td>');

    //Home
    sDiv := CopyStr(sTmp, '<td>', '</td>');
    sDiv := RemoveHTMLTags(sDiv);
    iPos := 0;
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
    mlHome[iPos+1].sName := sDiv;
    mlHome[iPos+1].sOut := '';
    mlHome[iPos+1].sIn := '';
    mlHome[iPos+1].sCard := '0';

    //Away
    iPos := PosText('<td>', sTmp);
    sDiv := CopyStrEx(sTmp, '<td>', '</td>', iPos+1);
    sDiv := RemoveHTMLTags(sDiv);
    iPos := 0;
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
    mlAway[iPos+1].sName := sDiv;
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
  iCnt := 1;
  sl := TStringList.Create;
  try
    iPos := PosText('<tr>', S);
    repeat
      sl.Text := CopyStrEx(S, '<tr>', '</tr>', iPos);
      if PosText('<td class="position">', sl.Text) > 0 then
      begin
        mlHome[iCnt].sPos := RemoveHTMLTags(sl[1]);
        mlHome[iCnt].sNum := RemoveHTMLTags(sl[2]);
        mlHome[iCnt].sName:= RemoveHTMLTags(sl[3]);
        mlHome[iCnt].sCard := '0';
        mlAway[iCnt].sPos := RemoveHTMLTags(sl[4]);
        mlAway[iCnt].sNum := RemoveHTMLTags(sl[5]);
        mlAway[iCnt].sName:= RemoveHTMLTags(sl[6]);
        mlAway[iCnt].sCard := '0';
        iCnt := iCnt + 1;
      end;
      iPos := PosTextEx('<tr>', S, iPos+1);
    until iPos = 0;
  finally
    sl.Free;
  end;
end;

procedure _CreateSubstTime(S: String);
var
  i, iPos, iNext : Integer;
  sTmp, sTmp2, sName, sTime : String;
begin
  iPos := PosText('<tr>', S);
  repeat
    sTmp := CopyStrEx(S, '<tr>', '</tr>', iPos);
    //Home
    sTmp2 := CopyStr(sTmp, '<td colspan="2">', '</td>');
    sName := RemoveHTMLTags(CopyStr(sTmp2, '<td colspan="2">', '<span'));
    sTime := CopyStrToEnd(sTmp2, '</span>');
    sTime := ExtractNumber(sTime, True, False);
    for i := 1 to 30 do
    begin
      if mlHome[i].sName = sName then
      begin
        if PosText('OUT', sTmp2) > 0 then
          mlHome[i].sOut := sTime
        else
          mlHome[i].sIn := sTime;
        Break;
      end;
    end;

    //Away
    iNext := PosText('<td colspan="2">', sTmp);
    sTmp2 := CopyStrEx(sTmp, '<td colspan="2">', '</td>', iNext+1);
    sName := RemoveHTMLTags(CopyStr(sTmp2, '<td colspan="2">', '<span'));
    sTime := CopyStrToEnd(sTmp2, '</span>');
    sTime := ExtractNumber(sTime, True, False);
    for i := 1 to 30 do
    begin
      if mlAway[i].sName = sName then
      begin
        if PosText('OUT', sTmp2) > 0 then
          mlAway[i].sOut := sTime
        else
          mlAway[i].sIn := sTime;
        Break;
      end;
    end;
    iPos := PosTextEx('<tr>', S, iPos+1);
  until iPos = 0;
end;

procedure _ExtractGameData2017(sSource, sUrl: String);
var
  sl : TStringList;
  iPos : Integer;
  sTmp, sTmp2 : String;
begin
  sl := TStringList.Create;
  try
    //大会名
    sTmp := CopyStr(sSource, '<a href="/match/alljapan_highschool_2017/">', '</a>');
    sGMD[12] := RemoveHTMLTags(sTmp);

    //節
    sTmp := CopyStr(sSource, '<div class="text-schedule">', '</div>');
    sTmp := RemoveHTMLTags(sTmp);
    sTmp := ReplaceText(sTmp, '　', ' ');
    sl.CommaText := sTmp;
    sTmp := RemoveStringFromAtoB(sl[0], '［', '］');
    sGMD[27] := sTmp;
    //日付
    sGMD[1] := ConvertJapaneseDateToYYYMMDD(sl[1]);
    //時間
    sGMD[31] := LeftStr(sl[2], 5);
    //場所
    sGMD[2] := Trim(sl[4]);

    //Home
    sTmp := CopyStr(sSource, '<span class="team-name">', '</span>');
    sTmp := RemoveHTMLTags(sTmp);
    sTmp2 := ExtractStringsFromAtoB(sTmp, '（', '）');
    sGMD[3] := RemoveLeft(CopyStrToEnd(sTmp, '　'), 1) + sTmp2;
    //Away
    sTmp := CopyStrNext(sSource, '<span class="team-name">', '</span>');
    sTmp := RemoveHTMLTags(sTmp);
    sTmp2 := ExtractStringsFromAtoB(sTmp, '（', '）');
    sGMD[4] := RemoveLeft(CopyStrToEnd(sTmp, '　'), 1) + sTmp2;

    //スコア
    sTmp := CopyStr(sSource, '<ul class="inner-score">', '</ul>');
    sTmp2 := CopyStr(sTmp, '<li>', '</li>');
    sTmp2 := RemoveHTMLTags(sTmp2);
    SplitByString(sTmp2, '前半', sl);
    sGMD[6] := Trim(sl[0]);
    sGMD[7] := Trim(sl[1]);
    sTmp2 := CopyStrNext(sTmp, '<li>', '</li>');
    sTmp2 := RemoveHTMLTags(sTmp2);
    SplitByString(sTmp2, '後半', sl);
    sGMD[8] := Trim(sl[0]);
    sGMD[9] := Trim(sl[1]);
    sGMD[10] := IntToStr(StrToIntDefEx(sGMD[6], 0) + StrToIntDefEx(sGMD[8], 0));
    sGMD[11] := IntToStr(StrToIntDefEx(sGMD[7], 0) + StrToIntDefEx(sGMD[9], 0));
    if StrToInt(sGMD[10]) > StrToInt(sGMD[11]) then
      sGMD[5] := '○'
    else if StrToInt(sGMD[10]) = StrToInt(sGMD[11]) then
      sGMD[5] := '△'
    else
      sGMD[5] := '●';
    //延長の有無
    sTmp := CopyStrNext(sSource, '<ul class="inner-score">', '</ul>');
    if sTmp <> '' then
    begin
      if ContainsText(sTmp, '延前') then
      begin
        sTmp2 := CopyStr(sTmp, '<li>', '</li>');
        sTmp2 := RemoveHTMLTags(sTmp2);
        SplitByString(sTmp2, '延前', sl);
        sGMD[18] := Trim(sl[0]);
        sGMD[19] := Trim(sl[1]);
        sTmp2 := CopyStrNext(sTmp, '<li>', '</li>');
        sTmp2 := RemoveHTMLTags(sTmp2);
        SplitByString(sTmp2, '延後', sl);
        sGMD[20] := Trim(sl[0]);
        sGMD[21] := Trim(sl[1]);
        sGMD[24] := '1';
      end
      else if ContainsText(sTmp, 'PK') then
      begin
        //PKの有無
        sTmp := RemoveHTMLTags(sTmp);
        sGMD[22] := Trim(RemoveRight(CopyStrToStr(sTmp, 'PK'), 1));
        sGMD[23] := Trim(RemoveLeft(CopyStrToEnd(sTmp, 'PK'), 2));
        sGMD[24] := '1';
      end;
    end;

    //得点者
    sTmp := CopyStr(sSource, '<div class="scorerLeft">', '</div>');
    sTmp := ReplaceText(sTmp, '<br />', '%n%');
    sTmp := RemoveHTMLTags(sTmp);
    sTmp := RemoveRight(ReplaceText(sTmp, '分 ', ' '), 3);
    sGMD[13] := ReplaceText(sTmp, '　', '');
    sTmp := CopyStr(sSource, '<div class="scorerRight">', '</div>');
    sTmp := ReplaceText(sTmp, '<br />', '%n%');
    sTmp := RemoveHTMLTags(sTmp);
    sTmp := RemoveRight(ReplaceText(sTmp, '分 ', ' '), 3);
    sGMD[14] := ReplaceText(sTmp, '　', '');

    //出場選手
    sTmp := CopyStr(sSource, '<table class="match-result">', '</table>');
    _CreateMemberList(sTmp);
    sTmp := CopyStr(sSource, '<td class="header" colspan="6">選手交代', '<td class="separate" colspan="6"></td>');
    _CreateSubstTime(sTmp);
    sTmp := CopyStr(sSource, '<td class="header" colspan="6">警告・退場', '</table>');
    _CreateCard(sTmp);
    sTmp := CopyStr(sSource, '<td class="header" colspan="6">控え選手</td>',
                              '<td class="header" colspan="6">選手交代</td>');
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

