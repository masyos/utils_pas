(* SPDX-License-Identifier: MIT *)
(*
    Utils for Lazarus (Free Pascal) version 0.0.1

    Copyright 2022 YOSHIDA, Masahiro.

    https://github.com/masyos/utils_pas
 *)
 unit Utils.Coding;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  { Identify Rule }
  TIdentifyRule = (irPascal, irCamel, irSnake, irConstant, irChain);
  { Identify Option }
  TIdentifyOption = (ioBracketRemoval);
  { Identify Options }
  TIdentifyOptions = set of TIdentifyOption;

{ Text to Identify 
  @param  str   text string.
  @param  rule  identify rule.
  @param  opts  identify options.
  @return identify string.
}
function TextToIdentify(const str: string; rule: TIdentifyRule; opts: TIdentifyOptions = []): string;

implementation

function Proper(const s: string): string; inline;
begin
  Result := EmptyStr;
  if s = EmptyStr then Exit;
  Result := LowerCase(s);
  Result[1] := Upcase(s[1]);
end;

function IsUpperChar(const ch: Char): boolean; inline;
begin
  Result := ch in ['A'..'Z'];
end;

function IsIdentFirstChar(const ch: Char): boolean; inline;
begin
  Result := ch in ['A'..'Z', 'a'..'z', '_'];
end;

function IsIdentRestChar(const ch: Char): boolean; inline;
begin
  Result := ch in ['0'..'9', 'A'..'Z', 'a'..'z', '_'];
end;


function TextToWords(const s: string; opts: TIdentifyOptions): TStringList;
var
  idx, start, len: integer;
  lof: boolean;
  s1: string;
  ch: char;
begin
  Result := TStringList.Create;
  if s = EmptyStr then Exit;

  s1 := s;
  for idx := 1 to Length(s1) do begin
    if IsIdentFirstChar(s1[idx]) then
      break;
    s1[idx] := ' ';
  end;
  for idx := 1 to Length(s1) do begin
    if not IsIdentRestChar(s1[idx]) then
      s1[idx] := ' ';
  end;
  start := 0;
  len := 0;
  lof := false;
  for idx := 1 to Length(s1) do begin
    case s1[idx] of
      'A'..'Z': begin
        if lof then begin
          Result.add( Copy(s1, start, len) );
          start := 0;
          len := 0;
          lof := false;
        end;
        if start = 0 then start := idx;
        Inc(len);
      end;

      'a'..'z': begin
        if start = 0 then start := idx;
        Inc(len);
        lof := true;
      end;

      '0'..'9': begin
        if start = 0 then start := idx;
        Inc(len);
        lof := true;
      end;

      else begin
        if len > 0 then begin
          Result.add( Copy(s1, start, len) );
          start := 0;
          len := 0;
          lof := false;
        end;
      end;
    end;
  end;
  if len > 0 then
    Result.add( Copy(s1, start, len) );
end;


function TextToIdentify(const str: string; rule: TIdentifyRule;
  opts: TIdentifyOptions): string;
var
  sl: TStringList;
  idx: integer;
  idtop, wdtop: boolean;
begin
  Result := EmptyStr;
  if str = EmptyStr then Exit;

  sl := TextToWords(str, opts);
  if not Assigned(sl) then Exit;

  try
    case rule of
      irSnake,
      irConstant: sl.Delimiter := '_';
      irChain: sl.Delimiter := '-';
    end;

    for idx := 0 to sl.Count-1 do begin
      case rule of
        irPascal: sl.strings[idx] := Proper(sl.strings[idx]);
        irCamel: begin
          if idx <> 0 then
            sl.strings[idx] := Proper(sl.strings[idx])
          else
            sl.strings[idx] := LowerCase(sl.strings[idx]);
        end;
        irSnake: sl.strings[idx] := LowerCase(sl.strings[idx]);
        irConstant: sl.strings[idx] := UpperCase(sl.strings[idx]);
        irChain: sl.strings[idx] := LowerCase(sl.strings[idx]);
      end;
    end;

    case rule of
      irPascal,
      irCamel: begin
        for idx := 0 to sl.Count-1 do begin
          Result := Result + sl.strings[idx];
        end;
      end;

      irSnake,
      irConstant,
      irChain: Result := sl.DelimitedText;
    end;

  finally
    sl.Free;
  end;
end;

end.

