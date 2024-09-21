unit PDV.DAO.Pedido;

interface

uses
  Data.DB,
  System.SysUtils,
  FireDAC.Stan.Param,
  System.Generics.Collections,
  PDV.DAO.Conexao.FiredacConnection;

type
  TDadosItemPedido = class
  public
    CodigoProduto: Integer;
    Descricao: string;
    Quantidade: Integer;
    ValorUnitario: Double;
    ValorTotal: Double;
  end;

  TDadosCliente = class
  public
    Codigo: Integer;
    Nome: string;
    Cidade: string;
    UF: string;
  end;

  TDadosPedido = class
  public
    NumeroPedido: Integer;
    DataEmissao: TDateTime;
    ValorTotal: Double;
    Cliente: TDadosCliente;
    Itens: TList<TDadosItemPedido>;
    constructor Create;
    destructor Destroy; override;
  end;

  IPedidoDAO = interface
    function CancelarPedido(ANumeroPedido: Integer): Boolean;
    function GravarPedido(ADadosPedido: TDadosPedido): Boolean;
    function PesquisarPedidoPorNumeroPedido(ANumeroPedido: Integer): TDataSet;
    function PesquisarPedidoItens(ANumeroPedido: Integer): TDataSet;
  end;

  TPedidoDAODatabase = class(TInterfacedObject, IPedidoDAO)
  private
    FConexao: IFiredacConnection;
  public
    constructor Create(AConexao: IFiredacConnection);
    function CancelarPedido(ANumeroPedido: Integer): Boolean;
    function GravarPedido(ADadosPedido: TDadosPedido): Boolean;
    function PesquisarPedidoPorNumeroPedido(ANumeroPedido: Integer): TDataSet;
    function PesquisarPedidoItens(ANumeroPedido: Integer): TDataSet;
  end;

implementation

{ TPedidoDAODatabase }

function TPedidoDAODatabase.CancelarPedido(ANumeroPedido: Integer): Boolean;
begin
  FConexao.Query.Close;
  Result := FConexao.Query.ExecSQL('DELETE FROM PEDIDOS WHERE NUMERO_PEDIDO = :NUMERO_PEDIDO', [ANumeroPedido]) > 0;
end;

constructor TPedidoDAODatabase.Create(AConexao: IFiredacConnection);
begin
  FConexao := AConexao;
end;

function TPedidoDAODatabase.GravarPedido(ADadosPedido: TDadosPedido): Boolean;
var
  LItem: TDadosItemPedido;
begin
  Result := False;
  FConexao.StartTransaction;
  try
    FConexao.Query.Close;
    FConexao.Query.SQL.Clear;
    FConexao.Query.SQL.Add('SELECT IFNULL(MAX(NUMERO_PEDIDO), 0) + 1 AS NUMERO_PEDIDO FROM PEDIDOS;');
    FConexao.Query.Open;

    ADadosPedido.NumeroPedido := FConexao.Query.FieldByName('NUMERO_PEDIDO').AsInteger;

    FConexao.Query.Close;
    FConexao.Query.SQL.Clear;
    FConexao.Query.SQL.Add('INSERT INTO PEDIDOS (');
    FConexao.Query.SQL.Add('    NUMERO_PEDIDO,');
    FConexao.Query.SQL.Add('    DATA_EMISSAO,');
    FConexao.Query.SQL.Add('    CODIGO_CLIENTE,');
    FConexao.Query.SQL.Add('    VALOR_TOTAL');
    FConexao.Query.SQL.Add(') VALUES (');
    FConexao.Query.SQL.Add('    :NUMERO_PEDIDO,');
    FConexao.Query.SQL.Add('    :DATA_EMISSAO,');
    FConexao.Query.SQL.Add('    :CODIGO_CLIENTE,');
    FConexao.Query.SQL.Add('    :VALOR_TOTAL');
    FConexao.Query.SQL.Add(');');
    FConexao.Query.Params.ParamByName('NUMERO_PEDIDO').AsInteger := ADadosPedido.NumeroPedido;
    FConexao.Query.Params.ParamByName('DATA_EMISSAO').AsDateTime := ADadosPedido.DataEmissao;
    FConexao.Query.Params.ParamByName('CODIGO_CLIENTE').AsInteger := ADadosPedido.Cliente.Codigo;
    FConexao.Query.Params.ParamByName('VALOR_TOTAL').AsFloat := ADadosPedido.ValorTotal;
    FConexao.Query.ExecSQL;

    for LItem in ADadosPedido.Itens do
    begin
      FConexao.Query.Close;
      FConexao.Query.SQL.Clear;
      FConexao.Query.SQL.Add('INSERT INTO ITENS_PEDIDO (');
      FConexao.Query.SQL.Add('    NUMERO_PEDIDO,');
      FConexao.Query.SQL.Add('    CODIGO_PRODUTO,');
      FConexao.Query.SQL.Add('    QUANTIDADE,');
      FConexao.Query.SQL.Add('    VALOR_UNITARIO,');
      FConexao.Query.SQL.Add('    VALOR_TOTAL');
      FConexao.Query.SQL.Add(') VALUES (');
      FConexao.Query.SQL.Add('    :NUMERO_PEDIDO,');
      FConexao.Query.SQL.Add('    :CODIGO_PRODUTO,');
      FConexao.Query.SQL.Add('    :QUANTIDADE,');
      FConexao.Query.SQL.Add('    :VALOR_UNITARIO,');
      FConexao.Query.SQL.Add('    :VALOR_TOTAL');
      FConexao.Query.SQL.Add(');');
      FConexao.Query.Params.ParamByName('NUMERO_PEDIDO').AsInteger := ADadosPedido.NumeroPedido;
      FConexao.Query.Params.ParamByName('CODIGO_PRODUTO').AsInteger := LItem.CodigoProduto;
      FConexao.Query.Params.ParamByName('QUANTIDADE').AsInteger := LItem.Quantidade;
      FConexao.Query.Params.ParamByName('VALOR_UNITARIO').AsFloat := LItem.ValorUnitario;
      FConexao.Query.Params.ParamByName('VALOR_TOTAL').AsFloat := LItem.ValorTotal;
      FConexao.Query.ExecSQL;
    end;

    FConexao.Commit;
    Result := True;
  except
    on E: Exception do
    begin
      FConexao.Rollback;
    end;
  end;
end;

function TPedidoDAODatabase.PesquisarPedidoItens(
  ANumeroPedido: Integer): TDataSet;
begin
  FConexao.Query.Close;
  FConexao.Query.SQL.Clear;
  FConexao.Query.SQL.Add('SELECT');
  FConexao.Query.SQL.Add('  IP.ITEM,');
  FConexao.Query.SQL.Add('  IP.CODIGO_PRODUTO,');
  FConexao.Query.SQL.Add('  IP.QUANTIDADE,');
  FConexao.Query.SQL.Add('  IP.VALOR_UNITARIO,');
  FConexao.Query.SQL.Add('  IP.VALOR_TOTAL,');
  FConexao.Query.SQL.Add('  P.DESCRICAO');
  FConexao.Query.SQL.Add('FROM');
  FConexao.Query.SQL.Add('  ITENS_PEDIDO IP');
  FConexao.Query.SQL.Add('    INNER JOIN PRODUTOS P ON (P.CODIGO = IP.CODIGO_PRODUTO)');
  FConexao.Query.SQL.Add('WHERE');
  FConexao.Query.SQL.Add('  IP.NUMERO_PEDIDO = :NUMERO_PEDIDO');
  FConexao.Query.SQL.Add('ORDER BY IP.ITEM;');
  FConexao.Query.Params.ParamByName('NUMERO_PEDIDO').AsInteger := ANumeroPedido;
  FConexao.Query.Open;
  Result := FConexao.Query;
end;

function TPedidoDAODatabase.PesquisarPedidoPorNumeroPedido(
  ANumeroPedido: Integer): TDataSet;
begin
  FConexao.Query.Close;
  FConexao.Query.SQL.Clear;
  FConexao.Query.SQL.Add('SELECT');
  FConexao.Query.SQL.Add('  C.CODIGO AS CODIGO_CLIENTE,');
  FConexao.Query.SQL.Add('  C.NOME,');
  FConexao.Query.SQL.Add('  C.CIDADE,');
  FConexao.Query.SQL.Add('  C.UF,');
  FConexao.Query.SQL.Add('  P.NUMERO_PEDIDO,');
  FConexao.Query.SQL.Add('  P.DATA_EMISSAO,');
  FConexao.Query.SQL.Add('  P.VALOR_TOTAL');
  FConexao.Query.SQL.Add('FROM');
  FConexao.Query.SQL.Add('  PEDIDOS P');
  FConexao.Query.SQL.Add('  INNER JOIN CLIENTES C ON (C.CODIGO = P.CODIGO_CLIENTE)');
  FConexao.Query.SQL.Add('WHERE');
  FConexao.Query.SQL.Add('  P.NUMERO_PEDIDO = :NUMERO_PEDIDO');
  FConexao.Query.Params.ParamByName('NUMERO_PEDIDO').AsInteger := ANumeroPedido;
  FConexao.Query.Open;
  Result := FConexao.Query;
end;

{ TDadosPedido }

constructor TDadosPedido.Create;
begin
  Cliente := TDadosCliente.Create;
  Itens := TList<TDadosItemPedido>.Create;
end;

destructor TDadosPedido.Destroy;
begin
  Cliente.Free;
  Itens.Free;
  inherited;
end;

end.
