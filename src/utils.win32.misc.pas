(* SPDX-License-Identifier: MIT *)
(*
    Utils for Lazarus (Free Pascal) version 0.0.1

    Copyright 2022 YOSHIDA, Masahiro.

    https://github.com/masyos/utils_pas
 *)
unit Utils.Win32.Misc;

{$mode ObjFPC}{$H+}

interface

uses
  LCLIntf, LCLType, Classes, SysUtils;

{ copy palette for windows. 
  @param Palette    source palette handle.
  @return           copy palette handle.
}
function CopyPalette(Palette: HPALETTE): HPALETTE; platform;

implementation

function CopyPalette(Palette: HPALETTE): HPALETTE;
const
  PALETTE_VER = $0300;
  MAX_PALETTE_COUNT = 256;
var
  pal: PLogPalette;
  count: integer;
begin
  Result := 0;
  GetMem(pal, SizeOf(TLogPalette) + SizeOf(TPaletteEntry) * MAX_PALETTE_COUNT);
  try
    pal^.palVersion := PALETTE_VER;
    pal^.palNumEntries:= MAX_PALETTE_COUNT;
    count := GetPaletteEntries(Palette, 0, MAX_PALETTE_COUNT, pal^.palPalEntry);
    if count > 0 then begin
      pal^.palNumEntries:=count;
      Result := CreatePalette(pal^);
    end;
  finally
    FreeMem(pal);
  end;
end;       



end.
