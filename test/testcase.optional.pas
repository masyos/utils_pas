unit TestCase.Optional;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry,
  Utils.Optional;

type

  { TTestCaseOptional }

  TTestCaseOptional = class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestOptional;
    procedure TestObjOptional;
    procedure TestObjOptReplace;
  end;

implementation

type

  { TWork }

  TWork = class
  private
    FValue: string;
  public
    IsCreate: boolean; static;

    constructor Create;
    destructor Destroy; override;
    property Value: string read FValue write FValue;
  end;


  { TValue }

  TValue = class
  private
    SValues: array of string; static;
    FIndex: integer;
    function GetValue: string;
    procedure SetValue(AValue: string);
  public
    const
      InitStr: string = '(empty)';
      FinalStr: string = '(unbound)';
    class function GetSValues(index: integer): string;
    constructor Create;
    destructor Destroy; override;
    property Index: integer read FIndex;
    property Value: string read GetValue write SetValue;
  end;

{ TValue }

function TValue.GetValue: string;
begin
  Result := SValues[FIndex];
end;

procedure TValue.SetValue(AValue: string);
begin
  SValues[FIndex] := AValue;
end;

class function TValue.GetSValues(index: integer): string;
begin
  Result := SValues[index];
end;

constructor TValue.Create;
begin
  SetLength(SValues, Length(SValues)+1);
  FIndex := Length(SValues)-1;
  SValues[FIndex] := InitStr;
end;

destructor TValue.Destroy;
begin
  SValues[FIndex] := FinalStr;
  inherited Destroy;
end;

{ TWork }

constructor TWork.Create;
begin
  IsCreate := true;
  FValue := EmptyStr;
end;

destructor TWork.Destroy;
begin
  inherited Destroy;
  IsCreate := false;
end;


procedure TTestCaseOptional.TestOptional;
var
  intopt: TIntegerOptional;
  i : integer;
begin
  intopt := TIntegerOptional.Create;
  try
    if intopt.HasValue then
      Fail('has not value!');

    try
      i := intopt.Value;
      Fail('not raise exception!');
    except
      on e: EOptionalError do begin end;      // ok.
      else Fail('unknown exception!');
    end;

    i := intopt.TryGetValue(16);
    if i <> 16 then
      Fail('value is not default!');

    intopt.Value := 10;
    if not intopt.HasValue then
      Fail('has value!');

    i := intopt.Value;
    if i <> 10 then
      Fail('value is not set.');

    i := intopt.TryGetValue(16);
    if i <> 10 then
      Fail('value is not set! (2)');

    intopt.Reset;
    if intopt.HasValue then
      Fail('has not value!');

  finally
    intopt.Free;
  end;
end;

procedure TTestCaseOptional.TestObjOptional;
const
  sval = 'Hello, world.';
var
  objopt: specialize TObjectOptional<TWork>;
  o: TWork;
begin
  objopt := specialize TObjectOptional<TWork>.Create;
  try
    if TWork.IsCreate then
      Fail('not create!');

    if objopt.HasValue then
      Fail('has not value!');

    try
      o := objopt.Value;
      Fail('not raise exception!');
    except
      on e: EOptionalError do begin end;      // ok.
      else Fail('unknown exception!');
    end;

    {
    i := objopt.TryGetValue(16);
    if i <> 16 then
      Fail('value is not default!');
    }

    o := TWork.Create;
    try
      if not TWork.IsCreate then
        Fail('create error!');

      o.Value := sval;
      objopt.Value := o;
      if not objopt.HasValue then
        Fail('has value!');

      if CompareStr(objopt.Value.Value, sval) <> 0 then
        Fail('value is not set.');

      objopt.Reset;
      if objopt.HasValue then
        Fail('has not value!');

      if TWork.IsCreate then
        Fail('free error!');
    finally
    end;

    o := TWork.Create;
    try
      if not TWork.IsCreate then
        Fail('create error!');
      o.Value := sval;
      objopt.Value := o;
    finally
    end;
  finally
    objopt.Free;
  end;

  if TWork.IsCreate then
    Fail('free error!');
end;

procedure TTestCaseOptional.TestObjOptReplace;
const
  sval1 = 'Hello, world.';
  sval2 = 'We are the world.';
var
  objopt: specialize TObjectOptional<TValue>;
  val1, val2: TValue;
begin
  objopt := specialize TObjectOptional<TValue>.Create;
  try
    val1 := TValue.Create;
    val2 := TValue.Create;

    val1.Value := sval1;
    val2.Value := sval2;
    objopt.Value := val1;
    if CompareStr(objopt.Value.Value, sval1) <> 0 then
      Fail('value is not set.');
    objopt.Value := val2;
    if CompareStr(objopt.Value.Value, sval2) <> 0 then
      Fail('value is not set.');
    if CompareStr(TValue.GetSValues(0), TValue.FinalStr) <> 0 then
      Fail('Reset miss.');
  finally
    objopt.Free;
  end;

end;

procedure TTestCaseOptional.SetUp;
begin

end;

procedure TTestCaseOptional.TearDown;
begin

end;

initialization
  TWork.IsCreate := false;

  RegisterTest(TTestCaseOptional);

end.

