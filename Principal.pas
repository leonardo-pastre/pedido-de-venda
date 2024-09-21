unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Mask, Vcl.ExtCtrls, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.Comp.UI, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, System.UITypes;

type
  TForm1 = class(TForm)
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
    FDConnection: TFDConnection;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink;
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
    FDQuery: TFDQuery;
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
    procedure AtualizarCampoValorTotal;
    procedure ConfigurarCamposPedido;
    procedure LimparDadosCliente;
    procedure LimparDadosProduto;
    procedure LimparTela;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.AtualizarCampoValorTotal;
var
  ValorStr: string;
begin
  ValorStr := VarToStrDef(CdsItensVALOR_TOTAL.Value, '0');
  EdtValorTotal.Text := FormatFloat('###,##0.00', ValorStr.ToDouble);
end;

procedure TForm1.BtnCancelarPedidoClick(Sender: TObject);
var
  NumeroPedidoStr: string;
  NumeroPedido: Integer;
begin
  if InputQuery('PDV', 'Informe o n�mero do pedido', NumeroPedidoStr) then
  begin
    if not TryStrToInt(NumeroPedidoStr, NumeroPedido) then
    begin
      ShowMessage('N�mero do pedido inv�lido');
      Exit;
    end;

    FDQuery.Close;
    FDQuery.SQL.Clear;
    FDQuery.SQL.Add('SELECT');
    FDQuery.SQL.Add('  P.NUMERO_PEDIDO');
    FDQuery.SQL.Add('FROM');
    FDQuery.SQL.Add('  PEDIDOS P');
    FDQuery.SQL.Add('WHERE');
    FDQuery.SQL.Add('  P.NUMERO_PEDIDO = :NUMERO_PEDIDO');
    FDQuery.Params.ParamByName('NUMERO_PEDIDO').AsInteger := NumeroPedido;
    FDQuery.Open;

    if FDQuery.IsEmpty then
    begin
      ShowMessage(Format('Pedido %d n�o encontrado', [NumeroPedido]));
      Exit;
    end;

    try
      FDQuery.Close;
      FDQuery.ExecSQL('DELETE FROM PEDIDOS WHERE NUMERO_PEDIDO = :NUMERO_PEDIDO', [NumeroPedido]);

      ShowMessage(Format('Pedido %d cancelado com sucesso', [NumeroPedido]));
      LimparTela;
    except
      on E: Exception do
        ShowMessage('Erro ao excluir o pedido. Entre em contato com o suporte');
    end;
  end;
end;

procedure TForm1.BtnCarregarPedidoClick(Sender: TObject);
var
  NumeroPedidoStr: string;
  NumeroPedido: Integer;
begin
  if InputQuery('PDV', 'Informe o n�mero do pedido', NumeroPedidoStr) then
  begin
    if not TryStrToInt(NumeroPedidoStr, NumeroPedido) then
    begin
      ShowMessage('N�mero do pedido inv�lido');
      Exit;
    end;

    FDQuery.Close;
    FDQuery.SQL.Clear;
    FDQuery.SQL.Add('SELECT');
    FDQuery.SQL.Add('  C.CODIGO AS CODIGO_CLIENTE,');
    FDQuery.SQL.Add('  C.NOME,');
    FDQuery.SQL.Add('  C.CIDADE,');
    FDQuery.SQL.Add('  C.UF,');
    FDQuery.SQL.Add('  P.NUMERO_PEDIDO,');
    FDQuery.SQL.Add('  P.DATA_EMISSAO');
    FDQuery.SQL.Add('FROM');
    FDQuery.SQL.Add('  PEDIDOS P');
    FDQuery.SQL.Add('  INNER JOIN CLIENTES C ON (C.CODIGO = P.CODIGO_CLIENTE)');
    FDQuery.SQL.Add('WHERE');
    FDQuery.SQL.Add('  P.NUMERO_PEDIDO = :NUMERO_PEDIDO');
    FDQuery.Params.ParamByName('NUMERO_PEDIDO').AsInteger := NumeroPedido;
    FDQuery.Open;

    if FDQuery.IsEmpty then
    begin
      ShowMessage(Format('Pedido %d n�o encontrado', [NumeroPedido]));
      Exit;
    end;

    EdtCodigoCliente.Text := FDQuery.FieldByName('CODIGO_CLIENTE').AsString;
    EdtNomeCliente.Text := FDQuery.FieldByName('NOME').AsString;
    EdtCidadeCliente.Text := FDQuery.FieldByName('CIDADE').AsString;
    EdtUFCliente.Text := FDQuery.FieldByName('UF').AsString;

    FDQuery.Close;
    FDQuery.SQL.Clear;
    FDQuery.SQL.Add('SELECT');
    FDQuery.SQL.Add('  IP.ITEM,');
    FDQuery.SQL.Add('  IP.CODIGO_PRODUTO,');
    FDQuery.SQL.Add('  IP.QUANTIDADE,');
    FDQuery.SQL.Add('  IP.VALOR_UNITARIO,');
    FDQuery.SQL.Add('  P.DESCRICAO');
    FDQuery.SQL.Add('FROM');
    FDQuery.SQL.Add('  ITENS_PEDIDO IP');
    FDQuery.SQL.Add('    INNER JOIN PRODUTOS P ON (P.CODIGO = IP.CODIGO_PRODUTO)');
    FDQuery.SQL.Add('WHERE');
    FDQuery.SQL.Add('  IP.NUMERO_PEDIDO = :NUMERO_PEDIDO');
    FDQuery.SQL.Add('ORDER BY IP.ITEM;');
    FDQuery.Params.ParamByName('NUMERO_PEDIDO').AsInteger := NumeroPedido;
    FDQuery.Open;

    CdsItens.EmptyDataSet;
    CdsItens.DisableControls;
    try
      FDQuery.First;
      while not FDQuery.Eof do
      begin
        CdsItens.Append;
        CdsItensCODIGO.AsInteger := FDQuery.FieldByName('CODIGO_PRODUTO').AsInteger;
        CdsItensDESCRICAO.AsString := FDQuery.FieldByName('DESCRICAO').AsString;
        CdsItensQUANTIDADE.AsInteger := FDQuery.FieldByName('QUANTIDADE').AsInteger;
        CdsItensVALOR_UNITARIO.AsFloat := FDQuery.FieldByName('VALOR_UNITARIO').AsFloat;
        CdsItens.Post;

        FDQuery.Next;
      end;
    finally
      CdsItens.EnableControls;
    end;

    IsNovoPedido := False;
    ConfigurarCamposPedido;
  end;
end;

procedure TForm1.BtnGravarPedidoClick(Sender: TObject);
var
  CodigoPedido: Integer;
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

  FDConnection.StartTransaction;
  try
    FDQuery.Close;
    FDQuery.SQL.Clear;
    FDQuery.SQL.Add('SELECT IFNULL(MAX(NUMERO_PEDIDO), 0) + 1 AS NUMERO_PEDIDO FROM PEDIDOS;');
    FDQuery.Open;

    CodigoPedido := FDQuery.FieldByName('NUMERO_PEDIDO').AsInteger;

    FDQuery.Close;
    FDQuery.SQL.Clear;
    FDQuery.SQL.Add('INSERT INTO PEDIDOS (');
    FDQuery.SQL.Add('    NUMERO_PEDIDO,');
    FDQuery.SQL.Add('    DATA_EMISSAO,');
    FDQuery.SQL.Add('    CODIGO_CLIENTE,');
    FDQuery.SQL.Add('    VALOR_TOTAL');
    FDQuery.SQL.Add(') VALUES (');
    FDQuery.SQL.Add('    :NUMERO_PEDIDO,');
    FDQuery.SQL.Add('    :DATA_EMISSAO,');
    FDQuery.SQL.Add('    :CODIGO_CLIENTE,');
    FDQuery.SQL.Add('    :VALOR_TOTAL');
    FDQuery.SQL.Add(');');
    FDQuery.Params.ParamByName('NUMERO_PEDIDO').AsInteger := CodigoPedido;
    FDQuery.Params.ParamByName('DATA_EMISSAO').AsDateTime := Now;
    FDQuery.Params.ParamByName('CODIGO_CLIENTE').AsInteger := StrToInt(EdtCodigoCliente.Text);
    FDQuery.Params.ParamByName('VALOR_TOTAL').AsFloat := StrToFloat(EdtValorTotal.Text);
    FDQuery.ExecSQL;

    CdsItens.First;
    while not CdsItens.Eof do
    begin
      FDQuery.Close;
      FDQuery.SQL.Clear;
      FDQuery.SQL.Add('INSERT INTO ITENS_PEDIDO (');
      FDQuery.SQL.Add('    NUMERO_PEDIDO,');
      FDQuery.SQL.Add('    CODIGO_PRODUTO,');
      FDQuery.SQL.Add('    QUANTIDADE,');
      FDQuery.SQL.Add('    VALOR_UNITARIO,');
      FDQuery.SQL.Add('    VALOR_TOTAL');
      FDQuery.SQL.Add(') VALUES (');
      FDQuery.SQL.Add('    :NUMERO_PEDIDO,');
      FDQuery.SQL.Add('    :CODIGO_PRODUTO,');
      FDQuery.SQL.Add('    :QUANTIDADE,');
      FDQuery.SQL.Add('    :VALOR_UNITARIO,');
      FDQuery.SQL.Add('    :VALOR_TOTAL');
      FDQuery.SQL.Add(');');
      FDQuery.Params.ParamByName('NUMERO_PEDIDO').AsInteger := CodigoPedido;
      FDQuery.Params.ParamByName('CODIGO_PRODUTO').AsInteger := CdsItensCODIGO.AsInteger;
      FDQuery.Params.ParamByName('QUANTIDADE').AsInteger := CdsItensQUANTIDADE.AsInteger;
      FDQuery.Params.ParamByName('VALOR_UNITARIO').AsFloat := CdsItensVALOR_UNITARIO.AsFloat;
      FDQuery.Params.ParamByName('VALOR_TOTAL').AsFloat := CdsItensVALOR_TOTAL_ITEM.AsFloat;
      FDQuery.ExecSQL;

      CdsItens.Next;
    end;

    FDConnection.Commit;
    ShowMessage('Pedido gravado com sucesso');
    LimparTela;
  except
    on E: Exception do
    begin
      FDConnection.Rollback;
      ShowMessage('Erro ao gravar o pedido. Entre em contato com o suporte');
    end;
  end;
end;

procedure TForm1.BtnInserirClick(Sender: TObject);
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

  //AtualizarCampoValorTotal;

  if BtnInserir.Caption = 'Alterar' then
  begin
    BtnInserir.Caption := 'Inserir';
    EdtCodigoProduto.ReadOnly := False;
  end;

  EdtCodigoProduto.Clear;
  EdtDescricaoProduto.Clear;
  EdtQuantidade.Clear;
  EdtValorUnitario.Clear;
end;

procedure TForm1.BtnNovoPedidoClick(Sender: TObject);
begin
  LimparTela;
  IsNovoPedido := True;
  ConfigurarCamposPedido;
end;

procedure TForm1.BtnPesquisarClienteClick(Sender: TObject);
begin
  if EdtCodigoCliente.Text = EmptyStr then
  begin
    ShowMessage('Informe o c�digo do cliente para a pesquisa');
    Exit;
  end;

  FDQuery.Close;
  FDQuery.SQL.Clear;
  FDQuery.SQL.Add('SELECT');
  FDQuery.SQL.Add('  CODIGO,');
  FDQuery.SQL.Add('  NOME,');
  FDQuery.SQL.Add('  CIDADE,');
  FDQuery.SQL.Add('  UF');
  FDQuery.SQL.Add('FROM');
  FDQuery.SQL.Add('  CLIENTES');
  FDQuery.SQL.Add('WHERE');
  FDQuery.SQL.Add('  CODIGO = :CODIGO;');
  FDQuery.Params.ParamByName('CODIGO').AsInteger := StrToInt(EdtCodigoCliente.Text);
  FDQuery.Open;

  if FDQuery.IsEmpty then
  begin
    ShowMessage('Cliente n�o encontrado');
    EdtCodigoCliente.Clear;
    Exit;
  end;

  EdtNomeCliente.Text := FDQuery.FieldByName('NOME').AsString;
  EdtCidadeCliente.Text := FDQuery.FieldByName('CIDADE').AsString;
  EdtUFCliente.Text := FDQuery.FieldByName('UF').AsString;

  EdtCodigoProduto.SetFocus;
end;

procedure TForm1.BtnPesquisarProdutoClick(Sender: TObject);
begin
  if EdtCodigoProduto.Text = EmptyStr then
  begin
    ShowMessage('Informe o c�digo do produto para a pesquisa');
    Exit;
  end;

  FDQuery.Close;
  FDQuery.SQL.Clear;
  FDQuery.SQL.Add('SELECT');
  FDQuery.SQL.Add('  CODIGO,');
  FDQuery.SQL.Add('  DESCRICAO,');
  FDQuery.SQL.Add('  PRECO_VENDA');
  FDQuery.SQL.Add('FROM');
  FDQuery.SQL.Add('  PRODUTOS');
  FDQuery.SQL.Add('WHERE');
  FDQuery.SQL.Add('  CODIGO = :CODIGO;');
  FDQuery.Params.ParamByName('CODIGO').AsInteger := StrToInt(EdtCodigoProduto.Text);
  FDQuery.Open;

  if FDQuery.IsEmpty then
  begin
    ShowMessage('Produto n�o encontrado');
    EdtCodigoProduto.Clear;
    Exit;
  end;

  EdtDescricaoProduto.Text := FDQuery.FieldByName('DESCRICAO').AsString;
  EdtQuantidade.Text := '1';
  EdtValorUnitario.Text := FDQuery.FieldByName('PRECO_VENDA').AsString;
end;

procedure TForm1.CdsItensAfterPost(DataSet: TDataSet);
begin
  AtualizarCampoValorTotal;
end;

procedure TForm1.CdsItensCalcFields(DataSet: TDataSet);
begin
  CdsItensVALOR_TOTAL_ITEM.AsFloat := CdsItensQUANTIDADE.AsInteger * CdsItensVALOR_UNITARIO.AsFloat;
end;

procedure TForm1.ConfigurarCamposPedido;
begin
  GrbCliente.Enabled := IsNovoPedido;
  GrbProduto.Enabled := IsNovoPedido;
  EdtValorTotal.Enabled := IsNovoPedido;
  BtnGravarPedido.Enabled := IsNovoPedido;
  EdtCodigoProduto.ReadOnly := not IsNovoPedido;
end;

procedure TForm1.DbgItensKeyDown(Sender: TObject; var Key: Word;
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

procedure TForm1.EdtCodigoProdutoExit(Sender: TObject);
begin
  if EdtCodigoProduto.Text = EmptyStr then
  begin
    LimparDadosProduto;
  end;
end;

procedure TForm1.EdtCodigoProdutoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (EdtCodigoProduto.Text <> EmptyStr) then
  begin
    BtnPesquisarProduto.Click;
  end;
end;

procedure TForm1.EdtValorUnitarioKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', ',', #8]) then
  begin
    Key := #0;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  IsNovoPedido := True;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  EdtCodigoCliente.SetFocus;
  AtualizarCampoValorTotal;
end;

procedure TForm1.LimparDadosCliente;
begin
  EdtCodigoCliente.Clear;
  EdtNomeCliente.Clear;
  EdtCidadeCliente.Clear;
  EdtUFCliente.Clear;
end;

procedure TForm1.LimparDadosProduto;
begin
  EdtCodigoProduto.Clear;
  EdtDescricaoProduto.Clear;
  EdtQuantidade.Clear;
  EdtValorUnitario.Clear;
end;

procedure TForm1.LimparTela;
begin
  LimparDadosCliente;
  LimparDadosProduto;
  CdsItens.EmptyDataSet;
  AtualizarCampoValorTotal;
  BtnCarregarPedido.Visible := EdtCodigoCliente.Text = EmptyStr;
  BtnCancelarPedido.Visible := EdtCodigoCliente.Text = EmptyStr;
end;

procedure TForm1.EdtCodigoClienteExit(Sender: TObject);
begin
  if EdtCodigoCliente.Text = EmptyStr then
  begin
    LimparDadosCliente;
  end;

  BtnCarregarPedido.Visible := EdtCodigoCliente.Text = EmptyStr;
  BtnCancelarPedido.Visible := EdtCodigoCliente.Text = EmptyStr;
end;

procedure TForm1.EdtCodigoClienteKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (EdtCodigoCliente.Text <> EmptyStr) then
  begin
    BtnPesquisarCliente.Click;
  end;
end;

end.
