unit PDV.Service.ClienteService;

interface

uses
  Data.DB,
  PDV.DAO.Cliente;

type
  TDadosCliente = class
  public
    Codigo: Integer;
    Nome: string;
    Cidade: string;
    UF: string;
  end;

  TClienteService = class
  private
    FClienteDAO: IClienteDAO;
  public
    constructor Create(AClienteDAO: IClienteDAO);
    function PesquisarClientePorCodigo(ACodigo: Integer): TDadosCliente;
  end;

implementation

{ TClienteService }

constructor TClienteService.Create(AClienteDAO: IClienteDAO);
begin
  FClienteDAO := AClienteDAO;
end;

function TClienteService.PesquisarClientePorCodigo(
  ACodigo: Integer): TDadosCliente;
var
  LDataSet: TDataSet;
begin
  LDataSet := FClienteDAO.PesquisarClientePorCodigo(ACodigo);

  if LDataSet.IsEmpty then
    Exit(nil);

  Result := TDadosCliente.Create;
  Result.Codigo := LDataSet.FieldByName('CODIGO').AsInteger;
  Result.Nome := LDataSet.FieldByName('NOME').AsString;
  Result.Cidade := LDataSet.FieldByName('CIDADE').AsString;
  Result.UF := LDataSet.FieldByName('UF').AsString;
end;

end.
