program utils_test;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, Utils.Optional, Utils.Coding, GuiTestRunner,
  TestCase.Optional, TestCase.Coding;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

