(* SPDX-License-Identifier: MIT *)
(*
    Utils for Lazarus (Free Pascal) version 0.0.1

    Copyright 2022 YOSHIDA, Masahiro.

    https://github.com/masyos/utils_pas
 *)
unit Utils.Optional;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  EOptionalError = class(Exception);

  { TOptional }

  generic TOptional<T_> = class
  public
    type
      TValue = T_;
  protected
    FValue: T_;
    FHasValue: boolean;
    function GetValue: T_; inline;
    procedure SetValue(AValue: T_); inline;
  public
    { constructor: default. }
    constructor Create; overload;
    { constructor: set value.
        @param AValue   initialize value.
    }
    constructor Create(AValue: T_); overload;
    { destructor }
    destructor Destroy; override;

    { reset : Discard the value. }
    procedure Reset; virtual;
    { Attempts to obtain a value.
        @param  ADefVal Default value when no value is kept.
        @return value.
    }
    function TryGetValue(ADefVal: T_): T_; inline;

    { has value ? }
    property HasValue: boolean read FHasValue;
    { value
      If the value is not retained, exception EOptionalError is raised.
    }
    property Value: T_ read GetValue write SetValue;
  end;

  { optional for integer }
  TIntegerOptional = specialize TOptional<integer>;
  { optional for double }
  TDoubleOptional = specialize TOptional<double>;
  { optional for boolean }
  TBooleanOptional = specialize TOptional<boolean>;
  { optional for string }
  TStringOptional = specialize TOptional<string>;
  { optional for utf8string }
  TUtf8StringOptional = specialize TOptional<utf8string>;

  { TObjectOptional }
  { optional for TObject (Ownership with management.) }

  generic TObjectOptional<T_: class> = class(specialize TOptional<T_>)
  protected
    FOwnership: boolean;
  public
    { constructor: default. }
    constructor Create(AOwnership: boolean = true); overload;
    { constructor: set value.
        @param AValue   initialize value.
    }
    constructor Create(AValue: T_; AOwnership: boolean = true); overload;

    { reset : Discard the value. }
    procedure Reset; override;

    { ownership ? }
    property Ownership: boolean read FOwnership write FOwnership;
  end;



implementation



{ TOptional }

function TOptional.GetValue: T_;
begin
  if not FHasValue then
    raise EOptionalError.Create('It has no value.');
  Result := FValue;
end;

procedure TOptional.SetValue(AValue: T_);
begin
  FValue := AValue;
  FHasValue := true;
end;

constructor TOptional.Create;
begin
  FHasValue := false;
end;

constructor TOptional.Create(AValue: T_);
begin
  FValue := AValue;
  FHasValue := true;
end;

destructor TOptional.Destroy;
begin
  Reset;
  inherited Destroy;
end;

procedure TOptional.Reset;
begin
  FHasValue := false;
end;

function TOptional.TryGetValue(ADefVal: T_): T_;
begin
  if FHasValue then
    Result := FValue
  else
    Result := ADefVal;
end;

{ TObjectOptional }

constructor TObjectOptional.Create(AOwnership: boolean);
begin
  FOwnership := AOwnership;
  FHasValue := false;
end;

constructor TObjectOptional.Create(AValue: T_; AOwnership: boolean);
begin
  FOwnership := AOwnership;
  FValue := AValue;
  FHasValue := true;
end;

procedure TObjectOptional.Reset;
begin
  if FOwnership and FHasValue then
    FreeAndNil(FValue);
  inherited Reset;
end;


end.

