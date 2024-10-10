unit uControladorTarefa;

interface

uses  Horse, System.JSON, uManagerTarefa, Data.DB, Datasnap.DBClient;

type
  TTarefaController = class
  private
    class procedure GetTotalTarefa(ARequest: THorseRequest;
      AResponse: THorseResponse; ANext: TProc); static;
    public
      class procedure AddTarefa(ARequest: THorseRequest; AResponse: THorseResponse; ANext: TProc);
      class procedure AlterarTarefa(ARequest: THorseRequest; AResponse: THorseResponse; ANext: TProc);
      class procedure GetTarefas(ARequest: THorseRequest; AResponse: THorseResponse; ANext: TProc);
      class procedure DeleteTarefa(ARequest: THorseRequest; AResponse: THorseResponse; ANext: TProc);
      class procedure GetTotalTarefas(ARequest: THorseRequest; AResponse: THorseResponse; ANext: TProc);
      class procedure GetMediaTarefasPendentes(ARequest: THorseRequest; AResponse: THorseResponse; ANext: TProc);
      class procedure GetTarefasConcluidas7Dias(ARequest: THorseRequest; AResponse: THorseResponse; ANext: TProc);
  end;

implementation

{ TTarefaController }

class procedure TTarefaController.AddTarefa(ARequest: THorseRequest;
  AResponse: THorseResponse; ANext: TProc);
var
  Descricao, Status: string;
begin
  Descricao := ARequest.Body.GetValue<string>('descricao', '');
  Status := ARequest.Body.GetValue<string>('status', '');
  TManagerTarefa.GetInstance.AddTarefa(Descricao, Status);
  AResponse.Send('Tarefa adicionada');
end;

class procedure TTarefaController.AlterarTarefa(ARequest: THorseRequest;
  AResponse: THorseResponse; ANext: TProc);
var
  ID: Integer;
  Descricao, Status: string;
begin
  ID := ARequest.Params['id'].ToInteger;
  Descricao := ARequest.Body.GetValue<string>('descricao', '');
  Status := ARequest.Body.GetValue<string>('status', '');
  TManagerTarefa.GetInstance.AlterarTarefa(ID, Descricao, Status);
  AResponse.Send('Tarefa Alterada');
end;

class procedure TTarefaController.DeleteTarefa(ARequest: THorseRequest;
  AResponse: THorseResponse; ANext: TProc);
var
  ID: Integer;
begin
  ID := ARequest.Params['id'].ToInteger;
  TManagerTarefa.GetInstance.DeleteTarefa(ID);
  AResponse.Send('Tarefa deletada');
end;

class procedure TTarefaController.GetTarefas(ARequest: THorseRequest;
  AResponse: THorseResponse; ANext: TProc);
var
  DataSet: TDataSet;
  JSON: TJSONArray;
begin
  DataSet := TManagerTarefa.GetInstance.GetTarefas;
  JSON := TJSONArray.Create;

  while not DataSet.Eof do
  begin
    JSON.AddElement(TJSONObject.Create
      .AddPair('id', DataSet.FieldByName('ID').AsInteger)
      .AddPair('descricao', DataSet.FieldByName('descricao').AsString)
      .AddPair('status', DataSet.FieldByName('status').AsString));
    DataSet.Next;
  end;

  AResponse.Send(JSON);
end;

class procedure TTarefaController.GetTotalTarefas(ARequest: THorseRequest;
  AResponse: THorseResponse; ANext: TProc);
var
  JSON: TJSONObject;
begin
  JSON := TJSONObject.Create.AddPair('Total_tarefas', TManagerTarefa.GetInstance.GetTotalTarefas);

  AResponse.Send(JSON);
end;

class procedure TTarefaController.GetMediaTarefasPendentes(
  ARequest: THorseRequest; AResponse: THorseResponse; ANext: TProc);
var
  JSON: TJSONObject;
begin
  JSON := TJSONObject.Create.AddPair('Media_tarefas_pendentes', TManagerTarefa.GetInstance.GetMediaTarefasPendentes);

  AResponse.Send(JSON);
end;

class procedure TTarefaController.GetTarefasConcluidas7Dias(
  ARequest: THorseRequest; AResponse: THorseResponse; ANext: TProc);
var
  JSON: TJSONObject;
begin
  JSON := TJSONObject.Create.AddPair('tarefas_concluidas_7dias', TManagerTarefa.GetInstance.GetTarefasConcluidas7Dias);

  AResponse.Send(JSON);
end;

end.
