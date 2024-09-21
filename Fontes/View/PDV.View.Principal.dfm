object Principal: TPrincipal
  Left = 0
  Top = 0
  Caption = 'PDV'
  ClientHeight = 584
  ClientWidth = 892
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object DbgItens: TDBGrid
    Left = 8
    Top = 236
    Width = 697
    Height = 329
    DataSource = DtsItens
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnKeyDown = DbgItensKeyDown
    Columns = <
      item
        Expanded = False
        FieldName = 'CODIGO'
        Title.Caption = 'C'#243'digo'
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DESCRICAO'
        Title.Caption = 'Descri'#231#227'o'
        Width = 250
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'QUANTIDADE'
        Title.Caption = 'Quantidade'
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VALOR_UNITARIO'
        Title.Caption = 'Valor Unit'#225'rio'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VALOR_TOTAL_ITEM'
        Title.Caption = 'Valor Total'
        Width = 90
        Visible = True
      end>
  end
  object EdtValorTotal: TLabeledEdit
    Left = 711
    Top = 475
    Width = 170
    Height = 38
    EditLabel.Width = 35
    EditLabel.Height = 20
    EditLabel.Caption = 'Total'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -15
    EditLabel.Font.Name = 'Segoe UI'
    EditLabel.Font.Style = [fsBold]
    EditLabel.ParentFont = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
    Text = ''
  end
  object GrbCliente: TGroupBox
    Left = 8
    Top = 10
    Width = 697
    Height = 129
    Caption = 'Dados do Cliente: '
    TabOrder = 2
    object EdtCodigoCliente: TLabeledEdit
      Left = 14
      Top = 45
      Width = 89
      Height = 23
      EditLabel.Width = 79
      EditLabel.Height = 15
      EditLabel.Caption = 'C'#243'digo Cliente'
      NumbersOnly = True
      TabOrder = 0
      Text = ''
      OnExit = EdtCodigoClienteExit
      OnKeyDown = EdtCodigoClienteKeyDown
    end
    object EdtNomeCliente: TLabeledEdit
      Left = 141
      Top = 45
      Width = 459
      Height = 23
      EditLabel.Width = 33
      EditLabel.Height = 15
      EditLabel.Caption = 'Nome'
      ReadOnly = True
      TabOrder = 1
      Text = ''
    end
    object EdtCidadeCliente: TLabeledEdit
      Left = 14
      Top = 91
      Width = 499
      Height = 23
      EditLabel.Width = 37
      EditLabel.Height = 15
      EditLabel.Caption = 'Cidade'
      ReadOnly = True
      TabOrder = 2
      Text = ''
    end
    object EdtUFCliente: TLabeledEdit
      Left = 519
      Top = 91
      Width = 81
      Height = 23
      EditLabel.Width = 14
      EditLabel.Height = 15
      EditLabel.Caption = 'UF'
      ReadOnly = True
      TabOrder = 3
      Text = ''
    end
    object BtnPesquisarCliente: TBitBtn
      Left = 106
      Top = 45
      Width = 25
      Height = 23
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000075000000750000000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFF909090303030FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8E8E8E0101018F8F8FFFFFFFFFFFFF
        FFFFFFFFFFFFF9F9F9CCCCCCAFAFAFC1C1C1EFEFEFFFFFFFFFFFFFFFFFFF8E8E
        8E0101018E8E8EFFFFFFFFFFFFFFFFFFF6F6F67D7D7D14141400000000000000
        0000050505575757DFDFDF8E8E8E0101018E8E8EFFFFFFFFFFFFFFFFFFE9E9E9
        3232321010107F7F7FD1D1D1F7F7F7E5E5E5A3A3A32B2B2B0909090101018E8E
        8EFFFFFFFFFFFFFFFFFFFCFCFC3E3E3E202020DBDBDBFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFF8F8F85757570A0A0ADFDFDFFFFFFFFFFFFFFFFFFFA4A4A4020202
        CBCBCBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F8F82B2B2B5757
        57FFFFFFFFFFFFFFFFFF4343434E4E4EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFA3A3A3050505EFEFEFFFFFFFFFFFFF0D0D0D929292
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6E60000
        00BFBFBFFFFFFFFFFFFF010101A0A0A0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFF5F5F5000000B2B2B2FFFFFFFFFFFF181818848484
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD2D2D20000
        00CCCCCCFFFFFFFFFFFF5B5B5B2F2F2FFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFF7F7F7F141414F9F9F9FFFFFFFFFFFFCACACA010101
        8E8E8EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDBDBDB1010107D7D
        7DFFFFFFFFFFFFFFFFFFFFFFFF7676760505058E8E8EFEFEFEFFFFFFFFFFFFFF
        FFFFFFFFFFCBCBCB202020323232F6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFDFDFD
        7676760101012F2F2F8484849E9E9E9393934E4E4E0202023E3E3EE9E9E9FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCACACA5B5B5B1919190000000D
        0D0D424242A4A4A4FCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      TabOrder = 4
      OnClick = BtnPesquisarClienteClick
    end
  end
  object GrbProduto: TGroupBox
    Left = 8
    Top = 145
    Width = 697
    Height = 82
    Caption = 'Dados do Produto: '
    TabOrder = 3
    object EdtValorUnitario: TLabeledEdit
      Left = 493
      Top = 42
      Width = 107
      Height = 23
      EditLabel.Width = 71
      EditLabel.Height = 15
      EditLabel.Caption = 'Valor Unit'#225'rio'
      TabOrder = 0
      Text = ''
      OnKeyPress = EdtValorUnitarioKeyPress
    end
    object EdtQuantidade: TLabeledEdit
      Left = 413
      Top = 42
      Width = 74
      Height = 23
      EditLabel.Width = 62
      EditLabel.Height = 15
      EditLabel.Caption = 'Quantidade'
      NumbersOnly = True
      TabOrder = 1
      Text = ''
    end
    object EdtDescricaoProduto: TLabeledEdit
      Left = 141
      Top = 42
      Width = 266
      Height = 23
      EditLabel.Width = 114
      EditLabel.Height = 15
      EditLabel.Caption = 'Descri'#231#227'o do produto'
      ReadOnly = True
      TabOrder = 2
      Text = ''
    end
    object EdtCodigoProduto: TLabeledEdit
      Left = 14
      Top = 42
      Width = 89
      Height = 23
      EditLabel.Width = 85
      EditLabel.Height = 15
      EditLabel.Caption = 'C'#243'digo Produto'
      NumbersOnly = True
      TabOrder = 3
      Text = ''
      OnExit = EdtCodigoProdutoExit
      OnKeyDown = EdtCodigoProdutoKeyDown
    end
    object BtnPesquisarProduto: TBitBtn
      Left = 106
      Top = 42
      Width = 25
      Height = 23
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000075000000750000000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFF909090303030FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8E8E8E0101018F8F8FFFFFFFFFFFFF
        FFFFFFFFFFFFF9F9F9CCCCCCAFAFAFC1C1C1EFEFEFFFFFFFFFFFFFFFFFFF8E8E
        8E0101018E8E8EFFFFFFFFFFFFFFFFFFF6F6F67D7D7D14141400000000000000
        0000050505575757DFDFDF8E8E8E0101018E8E8EFFFFFFFFFFFFFFFFFFE9E9E9
        3232321010107F7F7FD1D1D1F7F7F7E5E5E5A3A3A32B2B2B0909090101018E8E
        8EFFFFFFFFFFFFFFFFFFFCFCFC3E3E3E202020DBDBDBFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFF8F8F85757570A0A0ADFDFDFFFFFFFFFFFFFFFFFFFA4A4A4020202
        CBCBCBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F8F82B2B2B5757
        57FFFFFFFFFFFFFFFFFF4343434E4E4EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFA3A3A3050505EFEFEFFFFFFFFFFFFF0D0D0D929292
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE6E6E60000
        00BFBFBFFFFFFFFFFFFF010101A0A0A0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFF5F5F5000000B2B2B2FFFFFFFFFFFF181818848484
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD2D2D20000
        00CCCCCCFFFFFFFFFFFF5B5B5B2F2F2FFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFF7F7F7F141414F9F9F9FFFFFFFFFFFFCACACA010101
        8E8E8EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDBDBDB1010107D7D
        7DFFFFFFFFFFFFFFFFFFFFFFFF7676760505058E8E8EFEFEFEFFFFFFFFFFFFFF
        FFFFFFFFFFCBCBCB202020323232F6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFDFDFD
        7676760101012F2F2F8484849E9E9E9393934E4E4E0202023E3E3EE9E9E9FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCACACA5B5B5B1919190000000D
        0D0D424242A4A4A4FCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      TabOrder = 4
      OnClick = BtnPesquisarProdutoClick
    end
    object BtnInserir: TBitBtn
      Left = 608
      Top = 42
      Width = 75
      Height = 23
      Caption = 'Inserir'
      TabOrder = 5
      OnClick = BtnInserirClick
    end
  end
  object BtnGravarPedido: TBitBtn
    Left = 711
    Top = 520
    Width = 170
    Height = 45
    Caption = 'GRAVAR PEDIDO'
    TabOrder = 4
    OnClick = BtnGravarPedidoClick
  end
  object BtnCarregarPedido: TBitBtn
    Left = 711
    Top = 69
    Width = 170
    Height = 45
    Caption = 'CARREGAR PEDIDO'
    TabOrder = 5
    OnClick = BtnCarregarPedidoClick
  end
  object BtnCancelarPedido: TBitBtn
    Left = 711
    Top = 120
    Width = 170
    Height = 45
    Caption = 'CANCELAR PEDIDO'
    TabOrder = 6
    OnClick = BtnCancelarPedidoClick
  end
  object BtnNovoPedido: TBitBtn
    Left = 711
    Top = 18
    Width = 170
    Height = 45
    Caption = 'NOVO PEDIDO'
    TabOrder = 7
    OnClick = BtnNovoPedidoClick
  end
  object DtsItens: TDataSource
    DataSet = CdsItens
    Left = 464
    Top = 432
  end
  object CdsItens: TClientDataSet
    PersistDataPacket.Data = {
      710000009619E0BD010000001800000004000000000003000000710006434F44
      49474F04000100000000000944455343524943414F0100490000000100055749
      4454480200020032000A5155414E54494441444504000100000000000E56414C
      4F525F554E49544152494F08000400000000000000}
    Active = True
    Aggregates = <
      item
        Visible = False
      end>
    AggregatesActive = True
    FieldDefs = <
      item
        Name = 'CODIGO'
        DataType = ftInteger
      end
      item
        Name = 'DESCRICAO'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'QUANTIDADE'
        DataType = ftInteger
      end
      item
        Name = 'VALOR_UNITARIO'
        DataType = ftFloat
      end
      item
        Name = 'VALOR_TOTAL_ITEM'
        DataType = ftFloat
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    AfterPost = CdsItensAfterPost
    OnCalcFields = CdsItensCalcFields
    Left = 464
    Top = 488
    object CdsItensCODIGO: TIntegerField
      FieldName = 'CODIGO'
    end
    object CdsItensDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 50
    end
    object CdsItensQUANTIDADE: TIntegerField
      FieldName = 'QUANTIDADE'
    end
    object CdsItensVALOR_UNITARIO: TFloatField
      FieldName = 'VALOR_UNITARIO'
      currency = True
    end
    object CdsItensVALOR_TOTAL_ITEM: TFloatField
      FieldKind = fkInternalCalc
      FieldName = 'VALOR_TOTAL_ITEM'
      currency = True
    end
    object CdsItensVALOR_TOTAL: TAggregateField
      FieldName = 'VALOR_TOTAL'
      Active = True
      DisplayName = ''
      Expression = 'SUM(VALOR_TOTAL_ITEM)'
    end
  end
end
