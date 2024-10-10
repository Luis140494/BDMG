program ProjetoBDMG;

uses
  Vcl.Forms,
  Form.Tarefa in 'Form.Tarefa.pas' {FrmTarefa},
  Data.Tarefa in 'Data.Tarefa.pas' {dmTarefa: TDataModule},
  Interfaces in 'Interfaces.pas',
  uManagerTarefa in 'uManagerTarefa.pas',
  uControladorTarefa in 'uControladorTarefa.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmTarefa, FrmTarefa);
  Application.Run;
end.
