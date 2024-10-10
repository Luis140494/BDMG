unit Interfaces;

interface

uses Classes;

type
  ITarefa = interface
  ['{C8A603AE-6194-4EB7-91EB-712C52C1BA21}']
  procedure AddTarefa(Descricao: string; Status: Char);
  procedure AlterarTarefa(AID: Integer; Descricao: string; Status: Char);
  procedure DeletarTarefa(AID: Integer);
end;

implementation

end.
