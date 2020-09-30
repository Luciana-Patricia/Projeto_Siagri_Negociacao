unit UNT_Distribuidor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.Provider,
  Datasnap.DBClient, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Buttons, Vcl.ExtCtrls, Data.SqlExpr;

type
  TFRM_Distribuidor = class(TForm)
    Panel1: TPanel;
    spbNovo: TSpeedButton;
    spbPesquisar: TSpeedButton;
    PageControl1: TPageControl;
    tsDados: TTabSheet;
    pnlDados: TPanel;
    Label1: TLabel;
    lblCPFCNPJ: TLabel;
    Label2: TLabel;
    edtCodigo: TEdit;
    edtCNPJ: TEdit;
    edtNome: TEdit;
    Panel3: TPanel;
    spbSalvar: TSpeedButton;
    spbCancelar: TSpeedButton;
    spbExcluir: TSpeedButton;
    spbSair: TSpeedButton;
    spbEditar: TSpeedButton;
    Panel2: TPanel;
    cdsDistribuidor: TClientDataSet;
    dspDistribuidor: TDataSetProvider;
    cdsDistribuidorDIST_CODIGO: TIntegerField;
    cdsDistribuidorDIST_CNPJ: TStringField;
    cdsDistribuidorDIST_NOME: TStringField;
    cdsDistribuidorDIST_DATA_CADASTRO: TDateField;
    procedure spbNovoClick(Sender: TObject);
    procedure spbPesquisarClick(Sender: TObject);
    procedure CarregaDados(codigo: String);
    procedure spbEditarClick(Sender: TObject);
    procedure spbCancelarClick(Sender: TObject);
    procedure spbExcluirClick(Sender: TObject);
    procedure spbSairClick(Sender: TObject);
    procedure spbSalvarClick(Sender: TObject);
    procedure edtCNPJExit(Sender: TObject);
    procedure edtCNPJKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    bEditar :  Boolean;
    procedure LimparDados;
  public
    { Public declarations }
  end;

var
  FRM_Distribuidor: TFRM_Distribuidor;

implementation

{$R *.dfm}

uses UNT_DM_Principal, UNT_Pesquisa;

procedure TFRM_Distribuidor.CarregaDados(codigo: String);
begin
  cdsDistribuidor.Close;
  DM_PRINCIPAL.sqlDistribuidor.Close;
  DM_PRINCIPAL.sqlDistribuidor.SQL.Clear;
  DM_PRINCIPAL.sqlDistribuidor.SQL.Text :=
    'SELECT * FROM PSCN_DISTRIBUIDOR WHERE DIST_CODIGO = ' + Codigo;
  DM_PRINCIPAL.sqlDistribuidor.Open;
  cdsDistribuidor.Active := True;

  edtCodigo.Text := cdsDistribuidorDIST_CODIGO.AsString;
  edtCNPJ.Text   := cdsDistribuidorDIST_CNPJ.AsString;
  edtNome.Text   := cdsDistribuidorDIST_NOME.AsString;

  PageControl1.ActivePage := tsDados;

end;

procedure TFRM_Distribuidor.edtCNPJExit(Sender: TObject);
begin
  if not DM_PRINCIPAL.ValidaCNPJ(edtCNPJ.Text) then
  begin
    MessageDlg('CNPJ inválido.',mtError, [mbOK],0);
    edtCNPJ.SetFocus;
    exit;
  end;
  if (not bEditar) then
  begin
    FRM_Pesquisa.PesquisaGeral('D', 'CNPJ', edtCNPJ.Text);
    if FRM_Pesquisa.cdsPesquisa.RecordCount > 0 then
    begin
      MessageDlg('Esse CNPJ já está cadastrado para outro distribuidor.',mtInformation, [mbOK],0);
      edtCNPJ.SetFocus;
    end;
  end;


end;

procedure TFRM_Distribuidor.edtCNPJKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9', #8, #13]) then
    key := #0;
end;

procedure TFRM_Distribuidor.FormShow(Sender: TObject);
begin
  spbNovo.Enabled      := True;
  spbPesquisar.Enabled := True;
  spbEditar.Enabled    := False;
  spbSalvar.Enabled    := False;
  spbCancelar.Enabled  := False;
  spbExcluir.Enabled   := False;
  spbSair.Enabled      := True;
  bEditar              := False;
  pnlDados.Enabled     := False;
  PageControl1.ActivePage := tsDados;
  LimparDados;

end;

procedure TFRM_Distribuidor.LimparDados;
begin
  edtCodigo.Clear;
  edtCNPJ.Clear;
  edtNome.Clear;
  PageControl1.ActivePage := tsDados;
end;

procedure TFRM_Distribuidor.spbCancelarClick(Sender: TObject);
begin
  cdsDistribuidor.Cancel;
  spbNovo.Enabled      := True;
  spbPesquisar.Enabled := True;
  spbEditar.Enabled    := False;
  spbSalvar.Enabled    := False;
  spbCancelar.Enabled  := False;
  spbExcluir.Enabled   := False;
  spbSair.Enabled      := True;
  bEditar              := False;
  pnlDados.Enabled     := False;

  LimparDados;

end;

procedure TFRM_Distribuidor.spbEditarClick(Sender: TObject);
begin
  spbNovo.Enabled      := False;
  spbPesquisar.Enabled := False;
  spbEditar.Enabled    := False;
  spbSalvar.Enabled    := True;
  spbCancelar.Enabled  := True;
  spbExcluir.Enabled   := False;
  spbSair.Enabled      := False;
  bEditar              := True;
  pnlDados.Enabled     := True;
  PageControl1.ActivePage := tsDados;

end;

procedure TFRM_Distribuidor.spbExcluirClick(Sender: TObject);
begin
  if MessageDlg('Tem certeza que deseja excluir o distribuidor ' + edtNome.Text + '?',mtWarning,[mbYes, mbNo],0) = mrYes then
  begin
    cdsDistribuidor.Delete;
    cdsDistribuidor.ApplyUpdates(-1);
    LimparDados;
  end;
  spbNovo.Enabled      := True;
  spbPesquisar.Enabled := True;
  spbEditar.Enabled    := False;
  spbSalvar.Enabled    := False;
  spbCancelar.Enabled  := False;
  spbExcluir.Enabled   := False;
  spbSair.Enabled      := True;
  bEditar              := False;
  pnlDados.Enabled     := False;

end;

procedure TFRM_Distribuidor.spbNovoClick(Sender: TObject);
begin
  spbNovo.Enabled      := False;
  spbPesquisar.Enabled := False;
  spbEditar.Enabled    := False;
  spbSalvar.Enabled    := True;
  spbCancelar.Enabled  := True;
  spbExcluir.Enabled   := False;
  spbSair.Enabled      := False;
  bEditar              := False;
  pnlDados.Enabled     := True;

  LimparDados;
  cdsDistribuidor.Close;
  DM_PRINCIPAL.sqlDistribuidor.Close;
  DM_PRINCIPAL.sqlDistribuidor.SQL.Clear;
  DM_PRINCIPAL.sqlDistribuidor.SQL.Text :=
    'SELECT * FROM PSCN_DISTRIBUIDOR WHERE DIST_CODIGO = 0' ;
  DM_PRINCIPAL.sqlDistribuidor.Open;
  cdsDistribuidor.Active := True;

end;

procedure TFRM_Distribuidor.spbPesquisarClick(Sender: TObject);
begin
  spbNovo.Enabled      := False;
  spbPesquisar.Enabled := False;
  spbEditar.Enabled    := True;
  spbSalvar.Enabled    := False;
  spbCancelar.Enabled  := True;
  spbExcluir.Enabled   := True;
  spbSair.Enabled      := False;
  bEditar              := False;
  pnlDados.Enabled     := False;

  FRM_Pesquisa.PesquisaGeral('D');
  FRM_Pesquisa.ShowModal;
  if FRM_Pesquisa.Tag = 1 then
  begin
    if not (FRM_Pesquisa.cdsPesquisa.IsEmpty) then
      CarregaDados(FRM_Pesquisa.cdsPesquisa.FieldByName('codigo').AsString);
  end;

end;

procedure TFRM_Distribuidor.spbSairClick(Sender: TObject);
begin
  FRM_Distribuidor.Close;
end;

procedure TFRM_Distribuidor.spbSalvarClick(Sender: TObject);
var
  iCodigo : String;
  tTrans: TTransactionDesc;
begin
  try

    DM_PRINCIPAL.DBEConexao.StartTransaction(tTrans);

    if bEditar then
    begin
      cdsDistribuidor.Edit;
    end
    else
    begin
      cdsDistribuidor.Append;
      cdsDistribuidorDIST_CODIGO.AsInteger := DM_PRINCIPAL.GeraCodigo('PSCN_DISTRIBUIDOR', 'DIST_CODIGO');
      cdsDistribuidorDIST_DATA_CADASTRO.AsDateTime := Now;
    end;

    iCodigo := cdsDistribuidorDIST_CODIGO.AsString;
    cdsDistribuidorDIST_CNPJ.AsString := edtCNPJ.Text;
    cdsDistribuidorDIST_NOME.AsString     := edtNome.Text;
    cdsDistribuidor.Post;
    cdsDistribuidor.ApplyUpdates(-1);

    DM_PRINCIPAL.DBEConexao.Commit(tTrans);
    except on E: Exception do
    begin
      {Erro da transação}
      DM_PRINCIPAL.DBEConexao.Rollback(tTrans);
      MessageDlg(Format('Erro ao  salvar. %s',[e.message]) , mtinformation, [mbok], 0);
    end;
  end;

  spbNovo.Enabled      := True;
  spbPesquisar.Enabled := True;
  spbEditar.Enabled    := True;
  spbSalvar.Enabled    := False;
  spbCancelar.Enabled  := False;
  spbExcluir.Enabled   := False;
  spbSair.Enabled      := True;
  bEditar              := False;
  pnlDados.Enabled     := False;
  PageControl1.ActivePage := tsDados;

  CarregaDados(iCodigo);

end;

end.
