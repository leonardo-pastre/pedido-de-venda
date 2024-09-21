unit PDV.DAO.Conexao.FiredacConnection;

interface

uses
  System.SysUtils, IniFiles,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, FireDAC.Comp.UI, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet;

type
  IFiredacConnection = interface
    function Query: TFDQuery;
    procedure StartTransaction;
    procedure Commit;
    procedure Rollback;
  end;

  TFiredacConnection = class(TInterfacedObject, IFiredacConnection)
  private
    FConnection: TFDConnection;
    FDLink: TFDPhysMySQLDriverLink;
    FQuery: TFDQuery;
  public
    constructor Create;
    destructor Destroy; override;
    function Query: TFDQuery;
    procedure StartTransaction;
    procedure Commit;
    procedure Rollback;
  end;

implementation

{ TFiredacConnection }

procedure TFiredacConnection.Commit;
begin
  FConnection.Commit;
end;

constructor TFiredacConnection.Create;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create('./config.ini');
  try
    FConnection := TFDConnection.Create(nil);
    try
      FConnection.Connected := False;
      FConnection.LoginPrompt := False;
      FConnection.DriverName := 'MySQL';
      FConnection.Params.UserName := Ini.ReadString('Database', 'Username', '');
      FConnection.Params.Password := Ini.ReadString('Database', 'Password', '');
      FConnection.Params.Values['Server'] := Ini.ReadString('Database', 'Server', '');
      FConnection.Params.Values['Database'] := Ini.ReadString('Database', 'DatabaseName', '');
      FConnection.Params.Values['Port'] := Ini.ReadString('Database', 'Port', '');

      FDLink := TFDPhysMySQLDriverLink.Create(nil);
      FDLink.VendorLib := Ini.ReadString('Database', 'PathLibBD', '');

      FConnection.Connected := True;

      FQuery := TFDQuery.Create(nil);
      FQuery.Connection := FConnection;
    except
      on E: Exception do
        raise Exception.Create('Erro ao criar a conexão com o banco de dados');
    end;
  finally
    Ini.Free;
  end;
end;

destructor TFiredacConnection.Destroy;
begin
  FDLink.Free;
  FQuery.Free;
  FConnection.Close;
  FConnection.Free;
  inherited;
end;

function TFiredacConnection.Query: TFDQuery;
begin
  Result := FQuery;
end;

procedure TFiredacConnection.Rollback;
begin
  FConnection.Rollback;
end;

procedure TFiredacConnection.StartTransaction;
begin
  FConnection.StartTransaction;
end;

end.
