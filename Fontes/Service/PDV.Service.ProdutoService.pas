unit PDV.Service.ProdutoService;

interface

uses
  Data.DB,
  PDV.DAO.Produto;

type
  TDadosProduto =  class
  public
    Codigo: Integer;
    Descricao: string;
    PrecoVenda: Double;
  end;

  TProdutoService = class
  private
    FProdutoDAO: IProdutoDAO;
  public
    constructor Create(AProdutoDAO: IProdutoDAO);
    function PesquisarProdutoPorCodigo(ACodigo: Integer): TDadosProduto;
  end;

implementation

{ TProdutoService }

constructor TProdutoService.Create(AProdutoDAO: IProdutoDAO);
begin
  FProdutoDAO := AProdutoDAO;
end;

function TProdutoService.PesquisarProdutoPorCodigo(
  ACodigo: Integer): TDadosProduto;
var
  LDataSet: TDataSet;
begin
  LDataSet := FProdutoDAO.PesquisarProdutoPorCodigo(ACodigo);

  if LDataSet.IsEmpty then
    Exit(nil);

  Result := TDadosProduto.Create;
  Result.Codigo := LDataSet.FieldByName('CODIGO').AsInteger;
  Result.Descricao := LDataSet.FieldByName('DESCRICAO').AsString;
  Result.PrecoVenda := LDataSet.FieldByName('PRECO_VENDA').AsFloat;
end;

end.
