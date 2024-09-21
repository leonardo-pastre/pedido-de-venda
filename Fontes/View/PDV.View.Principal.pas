unit PDV.View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Mask, Vcl.ExtCtrls, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, System.UITypes,
  PDV.Service.ClienteService,
  PDV.Service.ProdutoService,
  PDV.Service.PedidoService,
  PDV.DAO.Cliente,
  PDV.DAO.Produto,
  PDV.DAO.Pedido,
  PDV.DAO.Conexao.FiredacConnection;

type
  TPrincipal = class(TForm)
    DbgItens: TDBGrid;
    DtsItens: TDataSource;
    CdsItens: TClientDataSet;
    CdsItensCODIGO: TIntegerField;
    CdsItensDESCRICAO: TStringField;
    CdsItensQUANTIDADE: TIntegerField;
    CdsItensVALOR_UNITARIO: TFloatField;
    CdsItensVALOR_TOTAL_ITEM: TFloatField;
    CdsItensVALOR_TOTAL: TAggregateField;
    EdtValorTotal: TLabeledEdit;
    GrbCliente: TGroupBox;
    EdtCodigoCliente: TLabeledEdit;
    EdtNomeCliente: TLabeledEdit;
    EdtCidadeCliente: TLabeledEdit;
    EdtUFCliente: TLabeledEdit;
    GrbProduto: TGroupBox;
    EdtValorUnitario: TLabeledEdit;
    EdtQuantidade: TLabeledEdit;
    EdtDescricaoProduto: TLabeledEdit;
    EdtCodigoProduto: TLabeledEdit;
    BtnPesquisarCliente: TBitBtn;
    BtnPesquisarProduto: TBitBtn;
    BtnInserir: TBitBtn;
    BtnGravarPedido: TBitBtn;
    BtnCarregarPedido: TBitBtn;
    BtnCancelarPedido: TBitBtn;
    BtnNovoPedido: TBitBtn;
    procedure EdtCodigoProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnInserirClick(Sender: TObject);
    procedure DbgItensKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CdsItensCalcFields(DataSet: TDataSet);
    procedure EdtCodigoClienteKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnPesquisarClienteClick(Sender: TObject);
    procedure BtnPesquisarProdutoClick(Sender: TObject);
    procedure EdtCodigoClienteExit(Sender: TObject);
    procedure EdtValorUnitarioKeyPress(Sender: TObject; var Key: Char);
    procedure EdtCodigoProdutoExit(Sender: TObject);
    procedure BtnGravarPedidoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnCarregarPedidoClick(Sender: TObject);
    procedure CdsItensAfterPost(DataSet: TDataSet);
    procedure BtnNovoPedidoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnCancelarPedidoClick(Sender: TObject);
  private
    IsNovoPedido: Boolean;
    FConexao:IFiredacConnection;
    FClienteService: TClienteService;
    FProdutoService: TProdutoService;
    FPedidoService: TPedidoService;
    FClienteDAO: TClienteDAODatabase;
    FProdutoDAO: TProdutoDAODatabase;
    FPedidoDAO: TPedidoDAODatabase;
    procedure AtualizarCampoValorTotal;
    procedure ConfigurarCamposPedido;
    procedure LimparDadosCliente;
    procedure LimparDadosProduto;
    procedure LimparTela;
  public

  end;

var
  Principal: TPrincipal;

implementation

{$R *.dfm}

procedure TPrincipal.AtualizarCampoValorTotal;
var
  ValorStr: string;
begin
  ValorStr := VarToStrDef(CdsItensVALOR_TOTAL.Value, '0');
  EdtValorTotal.Text := FormatFloat('###,##0.00', ValorStr.ToDouble);
end;

procedure TPrincipal.BtnCancelarPedidoClick(Sender: TObject);
var
  NumeroPedidoStr: string;
  NumeroPedido: Integer;
begin
  if not InputQuery('PDV', 'Informe o n�mero do pedido', NumeroPedidoStr) then
    Exit;

  if not TryStrToInt(NumeroPedidoStr, NumeroPedido) then
  begin
    ShowMessage('N�mero do pedido inv�lido');
    Exit;
  end;

  try
    if FPedidoService.CancelarPedido(NumeroPedido) then
    begin
      ShowMessage(Format('Pedido %d cancelado com sucesso', [NumeroPedido]));
      LimparTela;
    end;
  except
    on E: PedidoNaoEncontradoException do
      ShowMessage(E.Message);

    on E: Exception do
      ShowMessage('Erro ao excluir o pedido. Entre em contato com o suporte');
  end;
end;

procedure TPrincipal.BtnCarregarPedidoClick(Sender: TObject);
var
  NumeroPedidoStr: string;
  NumeroPedido: Integer;
  LDadosPedido: TDadosPedido;
  LItem: TDadosItemPedido;
begin
  if not InputQuery('PDV', 'Informe o n�mero do pedido', NumeroPedidoStr) then
    Exit;

  if not TryStrToInt(NumeroPedidoStr, NumeroPedido) then
  begin
    ShowMessage('N�mero do pedido inv�lido');
    Exit;
  end;

  LDadosPedido := FPedidoService.PesquisarPedidoPorNumeroPedido(NumeroPedido);

  if not Assigned(LDadosPedido) then
  begin
    ShowMessage(Format('Pedido %d n�o encontrado', [NumeroPedido]));
    Exit;
  end;

  EdtCodigoCliente.Text := LDadosPedido.Cliente.Codigo.ToString;
  EdtNomeCliente.Text := LDadosPedido.Cliente.Nome;
  EdtCidadeCliente.Text := LDadosPedido.Cliente.Cidade;
  EdtUFCliente.Text := LDadosPedido.Cliente.UF;

  CdsItens.EmptyDataSet;
  CdsItens.DisableControls;
  try
    for LItem in LDadosPedido.Itens do
    begin
      CdsItens.Append;
      CdsItensCODIGO.AsInteger := LItem.CodigoProduto;
      CdsItensDESCRICAO.AsString := LItem.Descricao;
      CdsItensQUANTIDADE.AsInteger := LItem.Quantidade;
      CdsItensVALOR_UNITARIO.AsFloat := LItem.ValorUnitario;
      CdsItens.Post;
    end;
  finally
    CdsItens.EnableControls;
  end;

  IsNovoPedido := False;
  ConfigurarCamposPedido;
end;

procedure TPrincipal.BtnGravarPedidoClick(Sender: TObject);
var
  LDadosPedido: PDV.DAO.Pedido.TDadosPedido;
  LItem: TDadosItemPedido;
begin
  if EdtCodigoCliente.Text = EmptyStr then
  begin
    ShowMessage('Informe os dados do cliente no pedido');
    EdtCodigoCliente.SetFocus;
    Exit;
  end;

  if CdsItens.IsEmpty then
  begin
    ShowMessage('Adicione pelo menos um produto ao pedido');
    EdtCodigoProduto.SetFocus;
    Exit;
  end;

  LDadosPedido := TDadosPedido.Create;
  LDadosPedido.DataEmissao := Now;
  LDadosPedido.Cliente.Codigo := StrToInt(EdtCodigoCliente.Text);
  LDadosPedido.Cliente.Nome := EdtNomeCliente.Text;
  LDadosPedido.Cliente.Cidade := EdtCidadeCliente.Text;
  LDadosPedido.Cliente.UF := EdtUFCliente.Text;
  LDadosPedido.ValorTotal := StrToFloat(EdtValorTotal.Text);

  CdsItens.First;
  while not CdsItens.Eof do
  begin
    LItem := TDadosItemPedido.Create;
    LItem.CodigoProduto := CdsItensCODIGO.AsInteger;
    LItem.Descricao := CdsItensDESCRICAO.AsString;
    LItem.Quantidade := CdsItensQUANTIDADE.AsInteger;
    LItem.ValorUnitario := CdsItensVALOR_UNITARIO.AsFloat;
    LItem.ValorTotal := CdsItensVALOR_TOTAL_ITEM.AsFloat;

    LDadosPedido.Itens.Add(LItem);
    CdsItens.Next;
  end;

  try
    if FPedidoService.GravarPedido(LDadosPedido) then
    begin
      ShowMessage('Pedido gravado com sucesso');
      LimparTela;
    end
    else
      ShowMessage('Erro ao gravar o pedido');
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao gravar o pedido. Entre em contato com o suporte');
    end;
  end;
end;

procedure TPrincipal.BtnInserirClick(Sender: TObject);
begin
  if BtnInserir.Caption = 'Alterar' then
  begin
    CdsItens.Edit;
    CdsItensCODIGO.AsString := EdtCodigoProduto.Text;
    CdsItensDESCRICAO.AsString := EdtDescricaoProduto.Text;
    CdsItensQUANTIDADE.AsString := EdtQuantidade.Text;
    CdsItensVALOR_UNITARIO.AsString := EdtValorUnitario.Text;
    CdsItens.Post;
  end
  else
  begin
    if CdsItens.Locate('CODIGO', EdtCodigoProduto.Text, []) then
    begin
      CdsItens.Edit;
      CdsItensQUANTIDADE.AsInteger := CdsItensQUANTIDADE.AsInteger + StrToInt(EdtQuantidade.Text);
      CdsItens.Post;
    end
    else
    begin
      CdsItens.Append;
      CdsItensCODIGO.AsString := EdtCodigoProduto.Text;
      CdsItensDESCRICAO.AsString := EdtDescricaoProduto.Text;
      CdsItensQUANTIDADE.AsString := EdtQuantidade.Text;
      CdsItensVALOR_UNITARIO.AsString := EdtValorUnitario.Text;
      CdsItens.Post;
    end;
  end;

  if BtnInserir.Caption = 'Alterar' then
  begin
    BtnInserir.Caption := 'Inserir';
    EdtCodigoProduto.ReadOnly := False;
  end;

  LimparDadosProduto;
end;

procedure TPrincipal.BtnNovoPedidoClick(Sender: TObject);
begin
  LimparTela;
  IsNovoPedido := True;
  ConfigurarCamposPedido;
end;

procedure TPrincipal.BtnPesquisarClienteClick(Sender: TObject);
var
  LDadosCliente: PDV.Service.ClienteService.TDadosCliente;
begin
  if EdtCodigoCliente.Text = EmptyStr then
  begin
    ShowMessage('Informe o c�digo do cliente para a pesquisa');
    Exit;
  end;

  LDadosCliente := FClienteService.PesquisarClientePorCodigo(StrToInt(EdtCodigoCliente.Text));

  if not Assigned(LDadosCliente) then
  begin
    ShowMessage('Cliente n�o encontrado');
    EdtCodigoCliente.Clear;
    Exit;
  end;

  EdtNomeCliente.Text := LDadosCliente.Nome;
  EdtCidadeCliente.Text := LDadosCliente.Cidade;
  EdtUFCliente.Text := LDadosCliente.UF;

  EdtCodigoProduto.SetFocus;
end;

procedure TPrincipal.BtnPesquisarProdutoClick(Sender: TObject);
var
  LDadosProduto: TDadosProduto;
begin
  if EdtCodigoProduto.Text = EmptyStr then
  begin
    ShowMessage('Informe o c�digo do produto para a pesquisa');
    Exit;
  end;

  LDadosProduto := FProdutoService.PesquisarProdutoPorCodigo(StrToInt(EdtCodigoProduto.Text));

  if not Assigned(LDadosProduto) then
  begin
    ShowMessage('Produto n�o encontrado');
    EdtCodigoProduto.Clear;
    Exit;
  end;

  EdtDescricaoProduto.Text := LDadosProduto.Descricao;
  EdtQuantidade.Text := '1';
  EdtValorUnitario.Text := LDadosProduto.PrecoVenda.ToString;
end;

procedure TPrincipal.CdsItensAfterPost(DataSet: TDataSet);
begin
  AtualizarCampoValorTotal;
end;

procedure TPrincipal.CdsItensCalcFields(DataSet: TDataSet);
begin
  CdsItensVALOR_TOTAL_ITEM.AsFloat := CdsItensQUANTIDADE.AsInteger * CdsItensVALOR_UNITARIO.AsFloat;
end;

procedure TPrincipal.ConfigurarCamposPedido;
begin
  GrbCliente.Enabled := IsNovoPedido;
  GrbProduto.Enabled := IsNovoPedido;
  EdtValorTotal.Enabled := IsNovoPedido;
  BtnGravarPedido.Enabled := IsNovoPedido;
  EdtCodigoProduto.ReadOnly := not IsNovoPedido;
end;

procedure TPrincipal.DbgItensKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (CdsItens.IsEmpty) or (not IsNovoPedido) then
    Exit;

  if (Key = VK_RETURN) then
  begin
    BtnInserir.Caption := 'Alterar';
    EdtCodigoProduto.Text := CdsItensCODIGO.AsString;
    EdtDescricaoProduto.Text := CdsItensDESCRICAO.AsString;
    EdtQuantidade.Text := CdsItensQUANTIDADE.AsString;
    EdtValorUnitario.Text := CdsItensVALOR_UNITARIO.AsString;

    EdtCodigoProduto.ReadOnly := True;
  end;

  if Key = VK_DELETE then
    if MessageDlg('Deseja excluir o item ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      CdsItens.Delete;
      AtualizarCampoValorTotal;
    end;
end;

procedure TPrincipal.EdtCodigoProdutoExit(Sender: TObject);
begin
  if EdtCodigoProduto.Text = EmptyStr then
  begin
    LimparDadosProduto;
  end;
end;

procedure TPrincipal.EdtCodigoProdutoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (EdtCodigoProduto.Text <> EmptyStr) then
  begin
    BtnPesquisarProduto.Click;
  end;
end;

procedure TPrincipal.EdtValorUnitarioKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', ',', #8]) then
  begin
    Key := #0;
  end;
end;

procedure TPrincipal.FormCreate(Sender: TObject);
begin
  IsNovoPedido := True;

  FConexao := TFiredacConnection.Create;
  FClienteDAO := TClienteDAODatabase.Create(FConexao);
  FProdutoDAO := TProdutoDAODatabase.Create(FConexao);
  FPedidoDAO := TPedidoDAODatabase.Create(FConexao);
  FClienteService := TClienteService.Create(FClienteDAO);
  FProdutoService := TProdutoService.Create(FProdutoDAO);
  FPedidoService := TPedidoService.Create(FPedidoDAO);
end;

procedure TPrincipal.FormShow(Sender: TObject);
begin
  EdtCodigoCliente.SetFocus;
  AtualizarCampoValorTotal;
end;

procedure TPrincipal.LimparDadosCliente;
begin
  EdtCodigoCliente.Clear;
  EdtNomeCliente.Clear;
  EdtCidadeCliente.Clear;
  EdtUFCliente.Clear;
end;

procedure TPrincipal.LimparDadosProduto;
begin
  EdtCodigoProduto.Clear;
  EdtDescricaoProduto.Clear;
  EdtQuantidade.Clear;
  EdtValorUnitario.Clear;
end;

procedure TPrincipal.LimparTela;
begin
  LimparDadosCliente;
  LimparDadosProduto;
  CdsItens.EmptyDataSet;
  AtualizarCampoValorTotal;
  BtnCarregarPedido.Visible := EdtCodigoCliente.Text = EmptyStr;
  BtnCancelarPedido.Visible := EdtCodigoCliente.Text = EmptyStr;
end;

procedure TPrincipal.EdtCodigoClienteExit(Sender: TObject);
begin
  if EdtCodigoCliente.Text = EmptyStr then
  begin
    LimparDadosCliente;
  end;

  BtnCarregarPedido.Visible := EdtCodigoCliente.Text = EmptyStr;
  BtnCancelarPedido.Visible := EdtCodigoCliente.Text = EmptyStr;
end;

procedure TPrincipal.EdtCodigoClienteKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (EdtCodigoCliente.Text <> EmptyStr) then
  begin
    BtnPesquisarCliente.Click;
  end;
end;

end.
