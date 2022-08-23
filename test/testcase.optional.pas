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
  end;

implementation

type

  { TWork }

  TWork = class
  private
    FValue: string;
  public
    constructor Create;
    destructor Destroy; override;
    property Value: string read FValue write FValue;
  end;

{ TWork }

constructor TWork.Create;
begin
  FValue := EmptyStr;
end;

destructor TWork.Destroy;
begin
  inherited Destroy;
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
  o, o2 : TWork;
  s : string;
begin
  objopt := specialize TObjectOptional<TWork>.Create;
  try
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
      o.Value := sval;
      objopt.Value := o;
      if not objopt.HasValue then
        Fail('has value!');

      if CompareStr(objopt.Value.Value, sval) <> 0 then
        Fail('value is not set.');

      objopt.Reset;
      if objopt.HasValue then
        Fail('has not value!');
    finally
    end;
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

  RegisterTest(TTestCaseOptional);
end.

