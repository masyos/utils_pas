(* SPDX-License-Identifier: MIT *)
(*
    Utils for Lazarus (Free Pascal) version 0.0.1

    Copyright 2023 YOSHIDA, Masahiro.

    https://github.com/masyos/utils_pas
 *)
 unit utils.win32.region;

{$mode ObjFPC}{$H+}

interface

uses
  LCLIntf, LCLType, Classes, SysUtils, Graphics, windows;

type

  { TRegionEx }

  TRegionEx = class(TRegion)
  private
    procedure CombineRegionHandle(AValue: HRGN);
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddRoundRect(X1, Y1, X2, Y2, nWidthEllipse, nHeightEllipse: Integer);
    procedure AddPolygon(Points: PPoint; NumPts: Integer; FillMode: integer);
  end;



implementation


{ TRegionEx }

procedure TRegionEx.CombineRegionHandle(AValue: HRGN);
var
  lRGN: HRGN;
begin
  lRGN := Reference.Handle;
  CombineRgn(lRGN, lRGN, AValue, RGN_OR);
  Reference._lclHandle := lRGN;
end;

constructor TRegionEx.Create;
begin
  inherited Create;
end;

destructor TRegionEx.Destroy;
begin
  inherited Destroy;
end;


procedure TRegionEx.AddRoundRect(X1, Y1, X2, Y2, nWidthEllipse,
  nHeightEllipse: Integer);
var
  h: HRGN;
begin
  h := CreateRoundRectRgn(X1, Y1, X2, Y2, nWidthEllipse, nHeightEllipse);
  try
    CombineRegionHandle(h);
  finally
    DeleteObject(h);
  end;
end;

procedure TRegionEx.AddPolygon(Points: PPoint; NumPts: Integer;
  FillMode: integer);
var
  h: HRGN;
begin
  h := CreatePolygonRgn(Points, NumPts, FillMode);
  try
    CombineRegionHandle(h);
  finally
    DeleteObject(h);
  end;
end;

end.

