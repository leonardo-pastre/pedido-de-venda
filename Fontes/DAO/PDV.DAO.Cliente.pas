unit PDV.DAO.Cliente;

interface

uses
  Data.DB,
  FireDAC.Stan.Param,
  PDV.DAO.Conexao.FiredacConnection;

type
  IClienteDAO = interface
    function PesquisarClientePorCodigo(ACodigo: Integer): TDataSet;
  end;

  TClienteDAODatabase = class(TInterfacedObject, IClienteDAO)
  private
    FConexao: IFiredacConnection;
  public
    constructor Create(AConexao: IFiredacConnection);
    function PesquisarClientePorCodigo(ACodigo: Integer): TDataSet;
  end;

implementation

{ TClienteDAODatabase }

constructor TClienteDAODatabase.Create(AConexao: IFiredacConnection);
begin
  FConexao := AConexao;
end;

function TClienteDAODatabase.PesquisarClientePorCodigo(
  ACodigo: Integer): TDataSet;
begin
  FConexao.Query.Close;
  FConexao.Query.SQL.Clear;
  FConexao.Query.SQL.Add('SELECT');
  FConexao.Query.SQL.Add('  CODIGO,');
  FConexao.Query.SQL.Add('  NOME,');
  FConexao.Query.SQL.Add('  CIDADE,');
  FConexao.Query.SQL.Add('  UF');
  FConexao.Query.SQL.Add('FROM');
  FConexao.Query.SQL.Add('  CLIENTES');
  FConexao.Query.SQL.Add('WHERE');
  FConexao.Query.SQL.Add('  CODIGO = :CODIGO;');
  FConexao.Query.Params.ParamByName('CODIGO').AsInteger := ACodigo;
  FConexao.Query.Open;
  Result := FConexao.Query;
end;

end.
