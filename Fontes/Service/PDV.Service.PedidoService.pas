unit PDV.Service.PedidoService;

interface

uses
  Data.DB,
  System.SysUtils,
  PDV.DAO.Pedido;

type
  PedidoNaoEncontradoException = class(Exception);

  TPedidoService = class
  private
    FPedidoDAO: IPedidoDAO;
  public
    constructor Create(APedidoDAO: IPedidoDAO);
    function CancelarPedido(ANumeroPedido: Integer): Boolean;
    function GravarPedido(ADadosPedido: TDadosPedido): Boolean;
    function PesquisarPedidoPorNumeroPedido(ANumeroPedido: Integer): TDadosPedido;
  end;

implementation

{ TPedidoService }

function TPedidoService.CancelarPedido(ANumeroPedido: Integer): Boolean;
var
  LDataSet: TDataSet;
begin
  Result := False;
  LDataSet := FPedidoDAO.PesquisarPedidoPorNumeroPedido(ANumeroPedido);

  if LDataSet.IsEmpty then
    raise PedidoNaoEncontradoException.Create(Format('Pedido %d n�o encontrado', [ANumeroPedido]));

  try
    Result := FPedidoDAO.CancelarPedido(ANumeroPedido);
  except
    raise;
  end;
end;

constructor TPedidoService.Create(APedidoDAO: IPedidoDAO);
begin
  FPedidoDAO := APedidoDAO;
end;

function TPedidoService.GravarPedido(ADadosPedido: TDadosPedido): Boolean;
begin
  Result := FPedidoDAO.GravarPedido(ADadosPedido);
end;

function TPedidoService.PesquisarPedidoPorNumeroPedido(
  ANumeroPedido: Integer): TDadosPedido;
var
  LDataSet: TDataSet;
  LPedido: TDadosPedido;
  LItem: TDadosItemPedido;
begin
  LDataSet := FPedidoDAO.PesquisarPedidoPorNumeroPedido(ANumeroPedido);

  if LDataSet.IsEmpty then
    Exit(nil);

  LPedido := TDadosPedido.Create;
  LPedido.NumeroPedido := LDataSet.FieldByName('NUMERO_PEDIDO').AsInteger;
  LPedido.DataEmissao := LDataSet.FieldByName('DATA_EMISSAO').AsDateTime;
  LPedido.ValorTotal := LDataSet.FieldByName('VALOR_TOTAL').AsFloat;
  LPedido.Cliente.Codigo := LDataSet.FieldByName('CODIGO_CLIENTE').AsInteger;
  LPedido.Cliente.Nome := LDataSet.FieldByName('NOME').AsString;
  LPedido.Cliente.Cidade := LDataSet.FieldByName('CIDADE').AsString;
  LPedido.Cliente.UF := LDataSet.FieldByName('UF').AsString;

  LDataSet := FPedidoDAO.PesquisarPedidoItens(ANumeroPedido);

  LDataSet.First;
  while not LDataSet.Eof do
  begin
    LItem := TDadosItemPedido.Create;
    LItem.CodigoProduto := LDataSet.FieldByName('CODIGO_PRODUTO').AsInteger;
    LItem.Descricao := LDataSet.FieldByName('DESCRICAO').AsString;
    LItem.Quantidade := LDataSet.FieldByName('QUANTIDADE').AsInteger;
    LItem.ValorUnitario := LDataSet.FieldByName('VALOR_UNITARIO').AsFloat;
    LItem.ValorTotal := LDataSet.FieldByName('VALOR_TOTAL').AsFloat;

    LPedido.Itens.Add(LItem);
    LDataSet.Next;
  end;

  Result := LPedido;
end;

end.
