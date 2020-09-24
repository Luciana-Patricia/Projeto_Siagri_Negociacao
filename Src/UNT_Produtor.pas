unit unt_Produtor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  Datasnap.Provider, Data.DB, Datasnap.DBClient, UNT_Frame_Pesquisa,Data.SqlExpr,
  Vcl.ComCtrls;

type
  TFRM_Produtor = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    spbNovo: TSpeedButton;
    spbPesquisar: TSpeedButton;
    spbSalvar: TSpeedButton;
    spbCancelar: TSpeedButton;
    spbExcluir: TSpeedButton;
    spbSair: TSpeedButton;
    spbEditar: TSpeedButton;
    cdsProdutor: TClientDataSet;
    dspProdutor: TDataSetProvider;
    cdsProdutorPROR_CODIGO: TIntegerField;
    cdsProdutorPROR_CPF_CNPJ: TStringField;
    cdsProdutorPROR_NOME: TStringField;
    cdsProdutorPROR_DATA_CADASTRO: TDateField;
    tbControl: TTabControl;
    pnlDados: TPanel;
    Label1: TLabel;
    lblCPFCNPJ: TLabel;
    Label2: TLabel;
    edtCodigo: TEdit;
    edtCPFCNPJ: TEdit;
    rgTipoProdutor: TRadioGroup;
    edtNome: TEdit;
    procedure rgTipoProdutorClick(Sender: TObject);
    procedure spbNovoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure spbPesquisarClick(Sender: TObject);
    procedure spbEditarClick(Sender: TObject);
    procedure spbSalvarClick(Sender: TObject);
    procedure spbCancelarClick(Sender: TObject);
    procedure spbExcluirClick(Sender: TObject);
    procedure spbSairClick(Sender: TObject);
    procedure edtCPFCNPJKeyPress(Sender: TObject; var Key: Char);
    procedure edtCPFCNPJExit(Sender: TObject);
  private
    { Private declarations }
    bEditar : Boolean;
    procedure CarregaDados(Codigo: String);
    procedure LimparDados;
  public
    { Public declarations }
  end;

var
  FRM_Produtor: TFRM_Produtor;

implementation

{$R *.dfm}

uses UNT_DM_Principal, UNT_Pesquisa;

procedure TFRM_Produtor.CarregaDados(Codigo: String);
begin
  cdsProdutor.Close;
  DM_PRINCIPAL.sqlProdutor.Close;
  DM_PRINCIPAL.sqlProdutor.SQL.Clear;
  DM_PRINCIPAL.sqlProdutor.SQL.Text :=
    'SELECT * FROM PSCN_PRODUTOR WHERE PROR_CODIGO = ' + Codigo;
  DM_PRINCIPAL.sqlProdutor.Open;
  cdsProdutor.Active := True;

  edtCodigo.Text := cdsProdutorPROR_CODIGO.AsString;
  if Length(cdsProdutorPROR_CPF_CNPJ.AsString) > 11 then
    rgTipoProdutor.ItemIndex := 1
  else
    rgTipoProdutor.ItemIndex := 0;

  edtCPFCNPJ.Text := cdsProdutorPROR_CPF_CNPJ.AsString;
  edtNome.Text := cdsProdutorPROR_NOME.AsString;

end;

procedure TFRM_Produtor.edtCPFCNPJExit(Sender: TObject);
begin
  if rgTipoProdutor.ItemIndex < 0 then
  begin
    MessageDlg('Escolha o tipo de pessoa', mtWarning,[mbOK],0);
    rgTipoProdutor.ItemIndex := 0;
    exit;
  end;
  if rgTipoProdutor.ItemIndex = 0 then
    DM_PRINCIPAL.ValidaCPF(edtCPFCNPJ.Text)
  else
    DM_PRINCIPAL.ValidaCNPJ(edtCPFCNPJ.Text);
end;

procedure TFRM_Produtor.edtCPFCNPJKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9', #8, #13]) then
    key := #0;
end;

procedure TFRM_Produtor.FormShow(Sender: TObject);
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
  LimparDados;
end;

procedure TFRM_Produtor.LimparDados;
begin
  edtCodigo.Clear;
  edtCPFCNPJ.Clear;
  edtNome.Clear;
  rgTipoProdutor.ItemIndex := -1;
end;

procedure TFRM_Produtor.rgTipoProdutorClick(Sender: TObject);
begin
  if rgTipoProdutor.ItemIndex = 0 then
  begin
    lblCPFCNPJ.Caption := 'CPF';

  end else
  begin
    lblCPFCNPJ.Caption := 'CNPJ';

  end;

end;

procedure TFRM_Produtor.spbCancelarClick(Sender: TObject);
begin
  cdsProdutor.Cancel;
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

procedure TFRM_Produtor.spbEditarClick(Sender: TObject);
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
end;

procedure TFRM_Produtor.spbExcluirClick(Sender: TObject);
begin
  if MessageDlg('Tem certeza que deseja excluir o produtor ' + edtNome.Text + '?',mtWarning,[mbYes, mbNo],0) = mrYes then
  begin
    cdsProdutor.Delete;
    cdsProdutor.ApplyUpdates(-1);
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

procedure TFRM_Produtor.spbNovoClick(Sender: TObject);
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

  cdsProdutor.Close;
  DM_PRINCIPAL.sqlProdutor.Close;
  DM_PRINCIPAL.sqlProdutor.SQL.Clear;
  DM_PRINCIPAL.sqlProdutor.SQL.Text :=
    'SELECT * FROM PSCN_PRODUTOR WHERE PROR_CODIGO = 0 ' ;
  DM_PRINCIPAL.sqlProdutor.Open;
  cdsProdutor.Active := True;
end;

procedure TFRM_Produtor.spbPesquisarClick(Sender: TObject);
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
  FRM_Pesquisa.PesquisaGeral('R');
  FRM_Pesquisa.ShowModal;
  if FRM_Pesquisa.Tag = 1 then
  begin
    if not (FRM_Pesquisa.cdsPesquisa.IsEmpty) then
      CarregaDados(FRM_Pesquisa.cdsPesquisa.FieldByName('codigo').AsString);
  end;
end;

procedure TFRM_Produtor.spbSairClick(Sender: TObject);
begin
  FRM_Produtor.Close;
end;

procedure TFRM_Produtor.spbSalvarClick(Sender: TObject);
var
  iCodigo : String;
  tTrans: TTransactionDesc;
begin

  try

    DM_PRINCIPAL.DBEConexao.StartTransaction(tTrans);

    if bEditar then
    begin
      cdsProdutor.Edit;
    end
    else
    begin
      cdsProdutor.Append;
      cdsProdutorPROR_CODIGO.AsInteger := DM_PRINCIPAL.GeraCodigo('PSCN_PRODUTOR', 'PROR_CODIGO');
    end;

    iCodigo := cdsProdutorPROR_CODIGO.AsString;
    cdsProdutorPROR_CPF_CNPJ.AsString := edtCPFCNPJ.Text;
    cdsProdutorPROR_NOME.AsString     := edtNome.Text;
    cdsProdutor.Post;
    cdsProdutor.ApplyUpdates(-1);
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

  CarregaDados(iCodigo);
end;

end.
