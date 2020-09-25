unit UNT_Pesquisa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.FMTBcd, Data.DB, Data.SqlExpr,
  UNT_Frame_Pesquisa, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  Datasnap.Provider;

type
  TFRM_Pesquisa = class(TForm)
    IWFrame21: TIWFrame2;
    pnlDados: TPanel;
    dbgPesquisa: TDBGrid;
    dsPesquisa: TDataSource;
    cdsPesquisa: TClientDataSet;
    sqlPesquisa: TSQLDataSet;
    dspPesquisa: TDataSetProvider;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure IWFrame21spbCodigoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IWFrame21spbNomeClick(Sender: TObject);
    procedure IWFrame21edtCodigoKeyPress(Sender: TObject; var Key: Char);
    procedure IWFrame21edtNomeKeyPress(Sender: TObject; var Key: Char);
    procedure dbgPesquisaDblClick(Sender: TObject);
    procedure dbgPesquisaKeyPress(Sender: TObject; var Key: Char);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    sTela : String;
    bSair: boolean;
  public
    { Public declarations }

    procedure PesquisaGeral(Tabela: String; Campo : String = ''; Valor: String = '');
    procedure Pesquisa(Campo : String = ''; Valor: String = '');
  end;

var
  FRM_Pesquisa: TFRM_Pesquisa;

implementation

{$R *.dfm}

uses UNT_DM_Principal;

{ TFRM_Pesquisa }

procedure TFRM_Pesquisa.dbgPesquisaDblClick(Sender: TObject);
begin
  cdsPesquisa.RecNo;
  Self.Tag := 1;
  bSair := True;
  Close;
end;

procedure TFRM_Pesquisa.dbgPesquisaKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    key := #0;
    Self.Tag := 1;
    bSair := True;
    Close;
  end;
end;

procedure TFRM_Pesquisa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  IWFrame21.edtCodigo.Clear;
  IWFrame21.edtNome.Clear;

end;

procedure TFRM_Pesquisa.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if bSair then
    CanClose := True
  else
  begin
    Self.Tag := 0;
    CanClose := True;
  end;
end;

procedure TFRM_Pesquisa.FormShow(Sender: TObject);
begin
  IWFrame21.edtCodigo.Clear;
  IWFrame21.edtNome.Clear;
  Self.Tag := 0;
end;

procedure TFRM_Pesquisa.IWFrame21edtCodigoKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
    Pesquisa('codigo',IWFrame21.edtCodigo.Text);
end;

procedure TFRM_Pesquisa.IWFrame21edtNomeKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
    Pesquisa('Nome',IWFrame21.edtNome.Text);
end;

procedure TFRM_Pesquisa.IWFrame21spbCodigoClick(Sender: TObject);
begin
  Pesquisa('codigo',IWFrame21.edtCodigo.Text);
end;

procedure TFRM_Pesquisa.IWFrame21spbNomeClick(Sender: TObject);
begin
  Pesquisa('Nome',IWFrame21.edtNome.Text);
end;

procedure TFRM_Pesquisa.Pesquisa(Campo, Valor: String);
begin
  cdsPesquisa.Filtered:= False;
  if cdsPesquisa.FieldByName(campo).DataType = ftInteger then
    cdsPesquisa.Filter := campo + '=' + IWFrame21.edtCodigo.Text
  else
    cdsPesquisa.Filter := UpperCase(campo) + ' LIKE ' + #39 + UpperCase(valor) + '%' + #39;
  cdsPesquisa.Filtered := True;

end;

procedure TFRM_Pesquisa.PesquisaGeral(Tabela, Campo, Valor: String);
begin
  cdsPesquisa.Close;
  sqlPesquisa.Close;
  sqlPesquisa.CommandText := '';

  if (tabela = 'R') then
  begin
    sTela := 'R';
    sqlPesquisa.CommandText :=
        'SELECT ' +
        '    R.PROR_CODIGO "Codigo", R.PROR_CPF_CNPJ "CPF / CNPJ", R.PROR_NOME "Nome" ' +
        'FROM  '+
        '    PSCN_PRODUTOR R ';

  end
  else if (tabela = 'L') then
  begin
    sTela := 'L';
    sqlPesquisa.CommandText :=
        'SELECT ' +
        '    D.DIST_CODIGO "Codigo", D.DIST_CNPJ "CNPJ",  D.DIST_NOME  "Nome"' +
        'FROM  '+
        '    PSCN_DISTRIBUIDOR D ';

  end;
  if sqlPesquisa.CommandText = '' then
    FRM_Pesquisa.Close;

  sqlPesquisa.Open;
  cdsPesquisa.Active := True;

end;

end.
