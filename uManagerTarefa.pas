unit uManagerTarefa;

interface

uses
  Classes, Objetos, Interfaces, Data.DB, Datasnap.DBClient;

Type

  TManagerTarefa = class(TInterfacedObject, ITarefa)
    private
      FInterfaceList: TInterfaceList;
      FClientDataSet: TClientDataSet;
    public
      procedure AddInterface(AITarefa: ITarefa);
      procedure RemoverInterface(AITarefa: ITarefa);
      procedure AddTarefa(Descricao: string; Status: Char);
      procedure AlterarTarefa(AID: Integer; Descricao: string; Status: Char);
      procedure DeletarTarefa(AID: Integer);
      function GetTarefas: TDataSet;
      function GetTotalTarefas: Integer;
      function GetMediaTarefasPendentes: Integer;
      function GetTarefasConcluidas7Dias: Integer;
      constructor Create;
      class function GetInstance(): TManagerTarefa;
  end;

  var
    ManagerTarefa: TManagerTarefa;

implementation

uses Data.Tarefa, SysUtils, System.DateUtils;

{ TControlador }

procedure TManagerTarefa.AddInterface(AITarefa: ITarefa);
begin
  if not Assigned(FInterfaceList) then
    Exit;

  if FInterfaceList.IndexOf(AITarefa) = -1 then
    FInterfaceList.Add(AITarefa);
end;

procedure TManagerTarefa.AddTarefa(Descricao: string; Status: Char);
var
  NewID: Integer;
begin
  try
    NewID := FClientDataSet.RecordCount + 1;
    FClientDataSet.Append;
    FClientDataSet.FieldByName('ID').AsInteger := NewID;
    FClientDataSet.FieldByName('Descricao').AsString := Descricao;
    FClientDataSet.FieldByName('Status').AsString := Status;
    FClientDataSet.FieldByName('DATA_CADASTRO').AsDateTime := Now;
    FClientDataSet.FieldByName('DATA_CONCLUSAO').Clear;

    FClientDataSet.Post;

    try
      dmTarefa.CriarTransacao;
      with dmTarefa.FDQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('insert into tarefa (descricao, status, DATA_CADASTRO, DATA_CONCLUSAO) values (:descricao, :status, DATA_CADASTRO, DATA_CONCLUSAO)');
        ParamByName('descricao').AsString := Descricao;
        ParamByName('status').AsString := Status;
        ParamByName('DATA_CADASTRO').AsDateTime := FClientDataSet.FieldByName('DATA_CADASTRO').AsDateTime;
        ParamByName('DATA_CONCLUSAO').Clear;
        ExecSQL;
        dmTarefa.AplicarTransacao;
        dmTarefa.AtualizarCDSTarefa;
      end;
    except
      on e: Exception do
        dmTarefa.DesfazerTransacao;
    end;
  finally

  end;
end;

procedure TManagerTarefa.AlterarTarefa(AID: Integer; Descricao: string; Status: Char);
begin
  try
    if FClientDataSet.Locate('ID', AID, []) then
    begin
      FClientDataSet.Edit;
      FClientDataSet.FieldByName('Descricao').AsString := Descricao;
      FClientDataSet.FieldByName('Status').AsString := Status;
      FClientDataSet.Post;

      try
        dmTarefa.CriarTransacao;
        with dmTarefa.FDQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('update tarefa set descricao = :descricao, status = :status, DATA_CONCLUSAO = :DATA_CONCLUSAO where id = :id');
          ParamByName('id').AsInteger := AID;
          ParamByName('descricao').AsString := Descricao;
          ParamByName('status').AsString := Status;

          if Status = 'c' then
            ParamByName('DATA_CONCLUSAO').AsDateTime := Now
          else
            ParamByName('DATA_CONCLUSAO').Clear;

          ExecSQL;
          dmTarefa.AplicarTransacao;
          dmTarefa.AtualizarCDSTarefa;
        end;
      except
        on e: Exception do
          dmTarefa.DesfazerTransacao;
      end;
    end;
  finally

  end;

end;

constructor TManagerTarefa.Create;
begin
  if not Assigned(FInterfaceList) then
    FInterfaceList := TInterfaceList.Create;

  if not Assigned(FInterfaceList) then
  begin
    FClientDataSet := TClientDataSet.Create(nil);
    FClientDataSet.FieldDefs.Add('ID', ftInteger);
    FClientDataSet.FieldDefs.Add('Descricao', ftString, 255);
    FClientDataSet.FieldDefs.Add('Status', ftString, 2); // p = Pendente; a = andamento; c = concluido
    FClientDataSet.FieldDefs.Add('DATA_CADASTRO', ftDateTime);
    FClientDataSet.FieldDefs.Add('DATA_CONCLUSAO', ftDateTime);
    FClientDataSet.CreateDataSet;
  end;


  try
    try
      with dmTarefa.FDQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from tarefa');;
        Open;

        First;
        while not Eof do
        begin
          if not FClientDataSet.Locate('ID', FieldByName('ID').AsInteger, []) then
          begin
            FClientDataSet.Append;
            FClientDataSet.FieldByName('ID').AsInteger := FieldByName('ID').AsInteger;
            FClientDataSet.FieldByName('Descricao').AsString := FieldByName('Descricao').AsString;
            FClientDataSet.FieldByName('Status').AsString := FieldByName('Status').AsString;

            if FieldByName('DATA_CADASTRO').AsDateTime > 0 then
              FClientDataSet.FieldByName('DATA_CADASTRO').AsDateTime := FieldByName('DATA_CADASTRO').AsDateTime
            else
              FClientDataSet.FieldByName('DATA_CADASTRO').clear;

            if FieldByName('DATA_CONCLUSAO').AsDateTime > 0 then
              FClientDataSet.FieldByName('DATA_CONCLUSAO').AsDateTime := FieldByName('DATA_CONCLUSAO').AsDateTime
            else
              FClientDataSet.FieldByName('DATA_CONCLUSAO').clear;

            FClientDataSet.Post;
          end;
          Next;
        end;
      end;
    except

    end;
  finally

  end;
end;

procedure TManagerTarefa.DeletarTarefa(AID: Integer);
begin
  try
    if FClientDataSet.Locate('ID', AID, []) then
    begin
      FClientDataSet.Delete;

      try
        dmTarefa.CriarTransacao;
        with dmTarefa.FDQuery1 do
        begin
          Close;
          SQL.Clear;
          SQL.Add('delete from tarefa where (id = :id)');
          ParamByName('id').AsInteger := AID;
          ExecSQL;
          dmTarefa.AplicarTransacao;
          dmTarefa.AtualizarCDSTarefa;
        end;
      except
        on e: Exception do
          dmTarefa.DesfazerTransacao;
      end;
    end;

  finally

  end;
end;

class function TManagerTarefa.GetInstance: TManagerTarefa;
begin
  if not Assigned(ManagerTarefa) then
    ManagerTarefa := TManagerTarefa.Create;

  Result := ManagerTarefa;
end;

function TManagerTarefa.GetMediaTarefasPendentes: Integer;
begin
  try
    try
      with dmTarefa.FDQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select AVG(id) from tarefa where status = ''p'' ');;
        Open;

        Result := RecordCount;
      end;
    except
      on e: Exception do
      begin
        dmTarefa.DesfazerTransacao;
        Result := 0;
      end;
    end;
  finally

  end;
end;

function TManagerTarefa.GetTarefas: TDataSet;
begin
  FClientDataSet.First;
  Result := FClientDataSet;
end;

function TManagerTarefa.GetTarefasConcluidas7Dias: Integer;
begin
  try
    try
      with dmTarefa.FDQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT COUNT(*) AS total_tarefas_concluidas FROM tarefa where status = ''c'' and DATA_CONCLUSAO BETWEEN :DataIni and :DataFim ');
        ParamByName('DataIni').AsDateTime := IncDay(now, -7);
        ParamByName('DataFim').AsDateTime := now;
        Open;

        Result := RecordCount;
      end;
    except
      on e: Exception do
        Result := 0;
    end;
  finally

  end;
end;

function TManagerTarefa.GetTotalTarefas: Integer;
begin
  try
    try
      with dmTarefa.FDQuery1 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('select * from tarefa');;
        Open;

        Result := RecordCount;
      end;
    except
      on e: Exception do
        Result := 0;
    end;
  finally

  end;
end;

procedure TManagerTarefa.RemoverInterface(AITarefa: ITarefa);
begin
  if not Assigned(FInterfaceList) then
    Exit;

  if FInterfaceList.IndexOf(AITarefa) > -1 then
    FInterfaceList.Remove(AITarefa);
end;

end.
