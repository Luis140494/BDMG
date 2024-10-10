unit Data.Tarefa;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TdmTarefa = class(TDataModule)
    cdsTarefa: TClientDataSet;
    FDTransaction1: TFDTransaction;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AtualizarCDSTarefa;
    procedure CriarTransacao;
    procedure AplicarTransacao;
    procedure DesfazerTransacao;
  end;

var
  dmTarefa: TdmTarefa;

implementation

uses uManagerTarefa;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmTarefa }

procedure TdmTarefa.AplicarTransacao();
begin
  if FDTransaction1.Active then
    FDTransaction1.Commit;
end;

procedure TdmTarefa.AtualizarCDSTarefa;
begin
  cdsTarefa.CloneCursor(TManagerTarefa.GetInstance.GetTarefas);
end;

procedure TdmTarefa.CriarTransacao();
begin
  if FDTransaction1.Active then
  begin
    FDTransaction1.Commit;
  end;
  FDTransaction1.StartTransaction;
end;

procedure TdmTarefa.DesfazerTransacao();
begin
  if FDTransaction1.Active then
    FDTransaction1.Rollback;
end;

end.
