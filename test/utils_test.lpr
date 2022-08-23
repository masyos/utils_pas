program utils_test;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, Utils.Optional, GuiTestRunner,
  TestCase.Optional;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

