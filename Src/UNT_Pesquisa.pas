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
  if not (valor = '') then
  begin
    cdsPesquisa.Filtered:= False;
    if cdsPesquisa.FieldByName(campo).DataType = ftInteger then
      cdsPesquisa.Filter := campo + '=' + Valor
    else
      cdsPesquisa.Filter := UpperCase(campo) + ' LIKE ' + #39 + UpperCase(valor) + '%' + #39;
    cdsPesquisa.Filtered := True;
  end;
end;

procedure TFRM_Pesquisa.PesquisaGeral(Tabela, Campo, Valor: String);
begin
  cdsPesquisa.Filter   := '';
  cdsPesquisa.Filtered := false;
  cdsPesquisa.Close;
  sqlPesquisa.Close;
  sqlPesquisa.CommandText := '';

  if (tabela = 'R') then
  begin
    sTela := 'R';
    sqlPesquisa.CommandText :=
        'SELECT ' +
        '    R.PROR_CODIGO "Codigo", R.PROR_CPF_CNPJ "CPF", R.PROR_NOME "Nome" ' +
        'FROM  '+
        '    PSCN_PRODUTOR R ';

  end
  else if (tabela = 'D') then
  begin
    sTela := 'D';
    sqlPesquisa.CommandText :=
        'SELECT ' +
        '    D.DIST_CODIGO "Codigo", D.DIST_CNPJ "CNPJ",  D.DIST_NOME  "Nome"' +
        'FROM  '+
        '    PSCN_DISTRIBUIDOR D ';

  end
  else if (tabela = 'P') then
  begin
    sTela := 'P';
    sqlPesquisa.CommandText :=
        'SELECT ' +
        '    P.PROD_CODIGO "Codigo", P.PROD_NOME "Nome" ' +
        'FROM  '+
        '    PSCN_PRODUTO P ';
  end
  else if (tabela = 'N') then
  begin
    sTela := 'N';
    sqlPesquisa.CommandText :=
        'SELECT                                 ' + sLineBreak +
        '    N.NEGO_CODIGO "Codigo",            ' + sLineBreak +
        '    N.NEGO_DATA_CADASTRO "Cadastro",   ' + sLineBreak +
        '    P.PROR_CPF_CNPJ "CPF",             ' + sLineBreak +
        '    P.PROR_NOME "Nome",                ' + sLineBreak +
        '    N.NEGO_STATUS "Status",            ' + sLineBreak +
        '    N.DIST_CODIGO "Cód. Distribuidor"  ' + sLineBreak +
        'FROM                                   ' + sLineBreak +
        '    PSCN_NEGOCIACAO N                  ' + sLineBreak +
        '        INNER JOIN PSCN_PRODUTOR P     ' + sLineBreak +
        '            ON N.PROR_CODIGO = P.PROR_CODIGO ' ;
  end
  else if (Tabela = 'PP') then
  begin
    sTela := 'PP';
    sqlPesquisa.CommandText :=
        'SELECT                                   ' + sLineBreak +
        '    PP.PRPE_CODIGO "Codigo",             ' + sLineBreak +
        '    PP.PROD_CODIGO "Cod.Prod." ,         ' + sLineBreak +
        '    P.PROD_NOME  "Nome",                 ' + sLineBreak +
        '    PP.PRPE_PRECO "Preço",               ' + sLineBreak +
        '    PP.DIST_CODIGO "Cod.Dist."           ' + sLineBreak +
        'FROM                                     ' + sLineBreak +
        '    PSCN_PRODUTO_PRECO PP                ' + sLineBreak +
        '        INNER JOIN PSCN_PRODUTO P        ' + sLineBreak +
        '            ON PP.PROD_CODIGO = P.PROD_CODIGO  ';
  end;

  if sqlPesquisa.CommandText = '' then
    FRM_Pesquisa.Close;

  sqlPesquisa.Open;
  cdsPesquisa.Active := True;

  if ((Campo <> '') and (valor <> '')) then
  begin
    Pesquisa(campo,valor);
  end;


end;

end.
