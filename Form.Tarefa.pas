unit Form.Tarefa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, Data.Tarefa, Horse;

type
  TFrmTarefa = class(TForm)
    pnlGrid: TPanel;
    cxGridTarefaDBTableView: TcxGridDBTableView;
    cxGridTarefaLevel: TcxGridLevel;
    cxGridTarefa: TcxGrid;
    dsTarefa: TDataSource;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure IniciarServidor;
  end;

var
  FrmTarefa: TFrmTarefa;

implementation

uses Data.Tarefa, uControladorTarefa;

{$R *.dfm}

procedure TFrmTarefa.FormShow(Sender: TObject);
begin
  IniciarServidor;
  dmTarefa.AtualizarCDSTarefa;
end;

procedure TFrmTarefa.IniciarServidor;
begin
  THorse.Get('/tarefas', TTarefaController.GetTarefas);
  THorse.Get('/Total_tarefas', TTarefaController.GetTotalTarefas);
  THorse.Get('/Media_tarefas_pendentes', TTarefaController.GetMediaTarefasPendentes);
  THorse.Get('/tarefas_concluidas_7dias', TTarefaController.GetTarefasConcluidas7Dias);
  THorse.Post('/tarefas', TTarefaController.AddTarefa);
  THorse.PUT('/tarefas/:id', TTarefaController.AlterarTarefa);
  THorse.Delete('/tarefas/:id', TTarefaController.DeleteTarefa);

  THorse.Listen(8080);
end;

end.
