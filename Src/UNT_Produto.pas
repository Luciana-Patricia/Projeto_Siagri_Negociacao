unit UNT_Produto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.Buttons, Vcl.ExtCtrls, Datasnap.Provider, Data.DB, Data.SqlExpr,
  Datasnap.DBClient;

type
  TFRM_Produto = class(TForm)
    Panel1: TPanel;
    spbNovo: TSpeedButton;
    spbPesquisar: TSpeedButton;
    Panel3: TPanel;
    spbSalvar: TSpeedButton;
    spbCancelar: TSpeedButton;
    spbExcluir: TSpeedButton;
    spbSair: TSpeedButton;
    spbEditar: TSpeedButton;
    PageControl1: TPageControl;
    tsDados: TTabSheet;
    pnlDados: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edtCodigo: TEdit;
    edtNome: TEdit;
    tsPreco: TTabSheet;
    pnlDadosPreco: TPanel;
    Label3: TLabel;
    spbCodigo: TSpeedButton;
    lblNomeDist: TLabel;
    Label4: TLabel;
    spIncluirPreco: TSpeedButton;
    spbDeletarPreco: TSpeedButton;
    edtCodDistribuidor: TEdit;
    edtNomeDistribuidor: TEdit;
    edtCodPreco: TEdit;
    edtPreco: TEdit;
    edtCNPJDistribuidor: TEdit;
    dbgridLimite: TDBGrid;
    cdsProduto: TClientDataSet;
    dspProduto: TDataSetProvider;
    cdsPreco: TClientDataSet;
    dspPreco: TDataSetProvider;
    cdsProdutoPROD_CODIGO: TIntegerField;
    cdsProdutoPROD_NOME: TStringField;
    cdsPrecoPRPE_CODIGO: TIntegerField;
    cdsPrecoPROD_CODIGO: TIntegerField;
    cdsPrecoDIST_CODIGO: TIntegerField;
    cdsPrecoDIST_CNPJ: TStringField;
    cdsPrecoDIST_NOME: TStringField;
    cdsPrecoStatusDelta: TStringField;
    dsPreco: TDataSource;
    cdsPrecoPRPE_PRECO: TFMTBCDField;
    procedure spbNovoClick(Sender: TObject);
    procedure spbPesquisarClick(Sender: TObject);
    procedure spbEditarClick(Sender: TObject);
    procedure spbCancelarClick(Sender: TObject);
    procedure spbExcluirClick(Sender: TObject);
    procedure spbSairClick(Sender: TObject);
    procedure spbSalvarClick(Sender: TObject);
    procedure spbCodigoClick(Sender: TObject);
    procedure spIncluirPrecoClick(Sender: TObject);
    procedure spbDeletarPrecoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dbgridLimiteDblClick(Sender: TObject);
    procedure edtPrecoExit(Sender: TObject);
    procedure edtPrecoKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    bEditar : Boolean;
    procedure LimparDados;
    procedure CarregaDados(codigo: String);
    procedure CarregaDadosPreco;
  public
    { Public declarations }
  end;

var
  FRM_Produto: TFRM_Produto;

implementation

{$R *.dfm}

uses UNT_DM_Principal, UNT_Pesquisa;

procedure TFRM_Produto.CarregaDados(codigo: String);
begin
  cdsProduto.Close;
  DM_PRINCIPAL.sqlProduto.Close;
  DM_PRINCIPAL.sqlProduto.SQL.Clear;
  DM_PRINCIPAL.sqlProduto.SQL.Text :=
    'SELECT * FROM PSCN_PRODUTO WHERE PROD_CODIGO = ' + Codigo;
  DM_PRINCIPAL.sqlProduto.Open;
  cdsProduto.Active := True;

  edtCodigo.Text := cdsProdutoPROD_CODIGO.AsString;
  edtNome.Text := cdsProdutoPROD_NOME.AsString;

  CarregaDadosPreco;
  PageControl1.ActivePage := tsDados;

end;

procedure TFRM_Produto.CarregaDadosPreco;
begin
  cdsPreco.Close;
  DM_PRINCIPAL.sqlPreco.Close;
  DM_PRINCIPAL.sqlPreco.SQL.Clear;
  DM_PRINCIPAL.sqlPreco.SQL.Text :=
      'SELECT                ' + sLineBreak +
      '    PP.PRPE_CODIGO,   ' + sLineBreak +
      '    PP.PROD_CODIGO,   ' + sLineBreak +
      '    PP.DIST_CODIGO,   ' + sLineBreak +
      '    PP.PRPE_PRECO,    ' + sLineBreak +
      '    D.DIST_CNPJ,      ' + sLineBreak +
      '    D.DIST_NOME       ' + sLineBreak +
      'FROM                  ' + sLineBreak +
      '    PSCN_PRODUTO_PRECO PP                         ' + sLineBreak +
      '        INNER JOIN PSCN_PRODUTO P                 ' + sLineBreak +
      '            ON PP.PROD_CODIGO = P.PROD_CODIGO     ' + sLineBreak +
      '        INNER JOIN PSCN_DISTRIBUIDOR D            ' + sLineBreak +
      '            ON PP.DIST_CODIGO = D.DIST_CODIGO     ' + sLineBreak +
      'WHERE                                             ' + sLineBreak +
      '    PP.PROD_CODIGO = ' + edtCodigo.Text;
  DM_PRINCIPAL.sqlPreco.Open;
  cdsPreco.Active := True;

end;

procedure TFRM_Produto.dbgridLimiteDblClick(Sender: TObject);
begin
  if cdsPreco.Active then
  begin
    if cdsPrecoPRPE_CODIGO.Value > 0  then
    begin
      edtCodPreco.Text         := cdsPrecoPRPE_CODIGO.AsString;
      edtCodDistribuidor.Text  := cdsPrecoDIST_CODIGO.AsString;
      edtNomeDistribuidor.Text := cdsPrecoDIST_NOME.AsString;
      edtPreco.Text            := cdsPrecoPRPE_PRECO.AsString; //formatfloat(',0.00', strtofloat(cdsLimiteLICR_VALOR_LIMITE.AsString));
      edtCNPJDistribuidor.Text := cdsPrecoDIST_CNPJ.AsString;
    end;
  end;

end;

procedure TFRM_Produto.edtPrecoExit(Sender: TObject);
begin
  if edtPreco.Text = '' then
    edtPreco.Text := '0.00';
end;

procedure TFRM_Produto.edtPrecoKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9', '.',#8, #13]) then
    key := #0;
end;

procedure TFRM_Produto.FormShow(Sender: TObject);
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
  tsPreco.Visible      := False;
  PageControl1.ActivePage := tsDados;
  LimparDados;

end;

procedure TFRM_Produto.LimparDados;
begin
  edtCodigo.Clear;
  edtNome.Clear;
  edtCNPJDistribuidor.Clear;
  edtNomeDistribuidor.Clear;
  edtCodPreco.Clear;
  edtCodDistribuidor.Clear;
  edtPreco.Clear;
  PageControl1.ActivePage := tsDados;

end;

procedure TFRM_Produto.spbCancelarClick(Sender: TObject);
begin
  cdsProduto.Cancel;
  cdsPreco.Cancel;
  spbNovo.Enabled      := True;
  spbPesquisar.Enabled := True;
  spbEditar.Enabled    := False;
  spbSalvar.Enabled    := False;
  spbCancelar.Enabled  := False;
  spbExcluir.Enabled   := False;
  spbSair.Enabled      := True;
  bEditar              := False;
  pnlDados.Enabled     := False;
  tsPreco.Visible     := False;

  LimparDados;
end;

procedure TFRM_Produto.spbCodigoClick(Sender: TObject);
begin
  FRM_Pesquisa.PesquisaGeral('D');
  FRM_Pesquisa.ShowModal;
  if FRM_Pesquisa.Tag = 1 then
  begin
    if not (FRM_Pesquisa.cdsPesquisa.IsEmpty) then
      edtCodDistribuidor.Text  := FRM_Pesquisa.cdsPesquisa.FieldByName('Codigo').AsString;
      edtNomeDistribuidor.Text := FRM_Pesquisa.cdsPesquisa.FieldByName('Nome').AsString;
      edtCNPJDistribuidor.Text := FRM_Pesquisa.cdsPesquisa.FieldByName('CNPJ').AsString;
  end;

end;

procedure TFRM_Produto.spbDeletarPrecoClick(Sender: TObject);
begin
  if edtCodDistribuidor.Text = '' then
    exit;
  if cdsPrecoPRPE_CODIGO.Value > 0 then
  begin
    DM_PRINCIPAL.sqlAux.Close;
    DM_PRINCIPAL.sqlAux.CommandText := 'DELETE FROM PSCN_PRODUTO_PRECO WHERE PRPE_CODIGO = ' + cdsPrecoPRPE_CODIGO.AsString;
    DM_PRINCIPAL.sqlAux.ExecSQL;
    CarregaDadosPreco;
    edtCNPJDistribuidor.clear;
    edtNomeDistribuidor.Clear;
    edtCodPreco.Clear;
    edtCodDistribuidor.Clear;
    edtPreco.Clear;
  end;
end;

procedure TFRM_Produto.spbEditarClick(Sender: TObject);
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
  tsPreco.Visible      := True;
  pnlDadosPreco.Enabled  := True;
  PageControl1.ActivePage := tsDados;

end;

procedure TFRM_Produto.spbExcluirClick(Sender: TObject);
begin
  if MessageDlg('Tem certeza que deseja excluir o produto ' + edtNome.Text + '?',mtWarning,[mbYes, mbNo],0) = mrYes then
  begin
    if cdsPreco.RecordCount > 0  then
    begin
      if MessageDlg('Essa operação irá excluir os preços dos produtos. Deseja continuar?', mtWarning, [mbYes,mbNo],0) = mrYes then
      begin
        DM_PRINCIPAL.sqlAux.Close;
        DM_PRINCIPAL.sqlAux.CommandText := 'DELETE FROM PSCN_PRODUTO_PRECO WHERE PROD_CODIGO = ' + cdsProdutoPROD_CODIGO.AsString;
        DM_PRINCIPAL.sqlAux.ExecSQL;
      end else
        Exit;
    end;
    cdsProduto.Delete;
    cdsProduto.ApplyUpdates(-1);
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
  tsPreco.Visible      := False;

end;

procedure TFRM_Produto.spbNovoClick(Sender: TObject);
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
  tsPreco.Visible      := False;

  LimparDados;
  cdsProduto.Close;
  DM_PRINCIPAL.sqlProduto.Close;
  DM_PRINCIPAL.sqlProduto.SQL.Clear;
  DM_PRINCIPAL.sqlProduto.SQL.Text :=
    'SELECT * FROM PSCN_PRODUTO WHERE PROD_CODIGO = 0 ' ;
  DM_PRINCIPAL.sqlProduto.Open;
  cdsProduto.Active := True;

end;

procedure TFRM_Produto.spbPesquisarClick(Sender: TObject);
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

  FRM_Pesquisa.PesquisaGeral('P');
  FRM_Pesquisa.ShowModal;
  if FRM_Pesquisa.Tag = 1 then
  begin
    if not (FRM_Pesquisa.cdsPesquisa.IsEmpty) then
      CarregaDados(FRM_Pesquisa.cdsPesquisa.FieldByName('codigo').AsString);
  end;

end;

procedure TFRM_Produto.spbSairClick(Sender: TObject);
begin
  FRM_Produto.Close;
end;

procedure TFRM_Produto.spbSalvarClick(Sender: TObject);
var
  iCodigo : String;
  iCodigoPreco : Integer;
  tTrans: TTransactionDesc;
begin
  try

    DM_PRINCIPAL.DBEConexao.StartTransaction(tTrans);

    if bEditar then
    begin
      cdsProduto.Edit;
    end
    else
    begin
      cdsProduto.Append;
      cdsProdutoPROD_CODIGO.AsInteger := DM_PRINCIPAL.GeraCodigo('PSCN_PRODUTO', 'PROD_CODIGO');
    end;

    iCodigo := cdsProdutoPROD_CODIGO.AsString;
    cdsProdutoPROD_NOME.AsString     := edtNome.Text;
    cdsProduto.Post;
    cdsProduto.ApplyUpdates(-1);
    DM_PRINCIPAL.DBEConexao.Commit(tTrans);
    except on E: Exception do
    begin
      {Erro da transação}
      DM_PRINCIPAL.DBEConexao.Rollback(tTrans);
      MessageDlg(Format('Erro ao  salvar. %s',[e.message]) , mtinformation, [mbok], 0);
    end;
  end;

  if bEditar then
  begin
    if cdsPreco.RecordCount > 0 then
    begin
      DM_PRINCIPAL.sqlAux.Close;
      DM_PRINCIPAL.sqlAux.SQL.Text := 'SELECT PRPE_CODIGO, PROD_CODIGO, DIST_CODIGO FROM PSCN_PRODUTO_PRECO WHERE PROD_CODIGO = ' + edtCodigo.Text;
      DM_PRINCIPAL.sqlAux.Open;
      cdsPreco.First;
      while not cdsPreco.Eof do
      begin
        if DM_PRINCIPAL.sqlAux.Locate('PROD_CODIGO;DIST_CODIGO', VarArrayOf([cdsPrecoPROD_CODIGO.AsString,cdsPrecoDIST_CODIGO.AsString]), [loCaseInsensitive]) then
          DM_PRINCIPAL.GravaDados(cdsPreco,'PSCN_PRODUTO_PRECO',cdsPrecoPRPE_CODIGO.AsString,'A')
        else
        begin
          iCodigoPreco := DM_PRINCIPAL.GeraCodigo('PSCN_PRODUTO_PRECO','PRPE_CODIGO');
          DM_PRINCIPAL.GravaDados(cdsPreco,'PSCN_PRODUTO_PRECO',IntToStr(iCodigoPreco),'I');
        end;
        cdsPreco.Next;
      end;
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
  tsPreco.Visible      := True;
  pnlDadosPreco.Enabled   := False;
  PageControl1.ActivePage := tsDados;

  CarregaDados(iCodigo);

end;

procedure TFRM_Produto.spIncluirPrecoClick(Sender: TObject);
begin
  if edtCodDistribuidor.Text = '' then
    exit;
  if cdsPreco.Locate('DIST_CODIGO',edtCodDistribuidor.Text,[loCaseInsensitive]) then
  begin
    cdsPreco.Edit;
  end
  else
  begin
    cdsPreco.Append;
    cdsPrecoPRPE_CODIGO.AsInteger := DM_PRINCIPAL.GeraCodigo('PSCN_PRODUTO_PRECO','PRPE_CODIGO');
  end;

  cdsPrecoDIST_CODIGO.AsString         := edtCodDistribuidor.Text;
  cdsPrecoPRPE_PRECO.AsFloat           := StrToFloat(edtPreco.Text); //DM_PRINCIPAL.TextToCurr(edtLimite.Text);
  cdsPrecoPROD_CODIGO.AsString         := edtCodigo.Text;
  cdsPrecoDIST_CNPJ.AsString           := edtCNPJDistribuidor.Text;
  cdsPrecoDIST_NOME.AsString           := edtNomeDistribuidor.Text;
  cdsPreco.Post;

  edtCodDistribuidor.Clear;
  edtCodPreco.Clear;
  edtNomeDistribuidor.Clear;
  edtCNPJDistribuidor.Clear;
  edtPreco.Clear;

end;

end.
