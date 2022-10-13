unit TestCase.Coding;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry,
  Utils.Coding;

type

  { TTestCaseCoding }

  TTestCaseCoding= class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;

    procedure TestIdentify(const rulename: string; rule: TIdentifyRule; const answer: array of string);
  published
    procedure TestIdentifyPascal;
    procedure TestIdentifyCamel;
    procedure TestIdentifySnake;
    procedure TestIdentifyConstant;
    procedure TestIdentifyChain;
  end;

implementation

const
  SourceTexts: array of string = (
    'hello, world.',
    'example01',
    'How many files ?',
    'PascalCase',
    'camelCase',
    'snake_case',
    'CONSTANT_CASE',
    'chain-case',
    '/wiki.content/get',
    '00.__file____line__',
    '01-23-45-67-89',
    '[EOF]'
  );

  PascalTexts: array of string = (
    'HelloWorld',
    'Example01',
    'HowManyFiles',
    'PascalCase',
    'CamelCase',
    'SnakeCase',
    'ConstantCase',
    'ChainCase',
    'WikiContentGet',
    'FileLine',
    '',
    'Eof'
  );

  CamelTexts: array of string = (
    'helloWorld',
    'example01',
    'howManyFiles',
    'pascalCase',
    'camelCase',
    'snakeCase',
    'constantCase',
    'chainCase',
    'wikiContentGet',
    'fileLine',
    '',
    'eof'
  );

  SnakeTexts: array of string = (
    'hello_world',
    'example01',
    'how_many_files',
    'pascal_case',
    'camel_case',
    'snake_case',
    'constant_case',
    'chain_case',
    'wiki_content_get',
    'file_line',
    '',
    'eof'
  );

  ConstantTexts: array of string = (
    'HELLO_WORLD',
    'EXAMPLE01',
    'HOW_MANY_FILES',
    'PASCAL_CASE',
    'CAMEL_CASE',
    'SNAKE_CASE',
    'CONSTANT_CASE',
    'CHAIN_CASE',
    'WIKI_CONTENT_GET',
    'FILE_LINE',
    '',
    'EOF'
  );

  ChainTexts: array of string = (
    'hello-world',
    'example01',
    'how-many-files',
    'pascal-case',
    'camel-case',
    'snake-case',
    'constant-case',
    'chain-case',
    'wiki-content-get',
    'file-line',
    '',
    'eof'
  );
{ TTestCaseCoding }

procedure TTestCaseCoding.SetUp;
begin
  inherited SetUp;
end;

procedure TTestCaseCoding.TearDown;
begin
  inherited TearDown;
end;

procedure TTestCaseCoding.TestIdentify(const rulename: string;
  rule: TIdentifyRule; const answer: array of string);
var
  ss, sd: string;
  idx: integer;
begin
  idx := 0;
  for ss in SourceTexts do begin
    sd := TextToIdentify(ss, rule);
    if CompareStr(answer[idx], sd) <> 0 then
      Fail(rulename + ' Identify Error: ' + ss + ' => ' + sd + ' :: ' + answer[idx]);
    Inc(idx);
  end;
end;

procedure TTestCaseCoding.TestIdentifyPascal;
begin
  TestIdentify('Pascal', irPascal, PascalTexts);
end;

procedure TTestCaseCoding.TestIdentifyCamel;
begin
  TestIdentify('Camel', irCamel, CamelTexts);
end;

procedure TTestCaseCoding.TestIdentifySnake;
begin
  TestIdentify('Snake', irSnake, SnakeTexts);
end;

procedure TTestCaseCoding.TestIdentifyConstant;
begin
  TestIdentify('Constant', irConstant, ConstantTexts);
end;

procedure TTestCaseCoding.TestIdentifyChain;
begin
  TestIdentify('Chain', irChain, ChainTexts);
end;




initialization

  RegisterTest(TTestCaseCoding);
end.

