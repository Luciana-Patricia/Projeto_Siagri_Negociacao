unit UNT_Negociacao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.ComCtrls, Data.DB, Datasnap.Provider,
  Datasnap.DBClient, Data.FMTBcd, Data.SqlExpr;

type
  TFRM_Negociacao = class(TForm)
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
    Label2: TLabel;
    edtCodProdutor: TEdit;
    edtNomeProdutor: TEdit;
    tsItensNegociacao: TTabSheet;
    pnlDadosItensNegociacao: TPanel;
    Label3: TLabel;
    spbPesqProduto: TSpeedButton;
    lblNomeProduto: TLabel;
    Label4: TLabel;
    spIncluirProduto: TSpeedButton;
    spbDeletarItens: TSpeedButton;
    edtNomeProduto: TEdit;
    edtPreco: TEdit;
    edtCodProduto: TEdit;
    dbgridItensNegociacao: TDBGrid;
    edtCodDist: TEdit;
    edtNomeDist: TEdit;
    spbPesqDist: TSpeedButton;
    Label1: TLabel;
    spbPesqProdutor: TSpeedButton;
    edtCPFProdutor: TEdit;
    edtCNPJDist: TEdit;
    edtStatus: TEdit;
    Label5: TLabel;
    dtpDataCadastro: TDateTimePicker;
    lblData: TLabel;
    edtCodItensNegociacao: TEdit;
    Label6: TLabel;
    edtTotalItens: TEdit;
    cdsItensNegociacao: TClientDataSet;
    dspNegociacao: TDataSetProvider;
    dspItensNegociacao: TDataSetProvider;
    cdsItensNegociacaoITNE_CODIGO: TIntegerField;
    cdsItensNegociacaoNEGO_CODIGO: TIntegerField;
    cdsItensNegociacaoPRPE_CODIGO: TIntegerField;
    cdsItensNegociacaoPROD_CODIGO: TIntegerField;
    cdsItensNegociacaoDIST_CODIGO: TIntegerField;
    cdsItensNegociacaoPRPE_PRECO: TFMTBCDField;
    cdsItensNegociacaoStatusDelta: TStringField;
    dsItensNegociacao: TDataSource;
    edtCodigo: TEdit;
    Label7: TLabel;
    cdsItensNegociacaoPROD_NOME: TStringField;
    Label8: TLabel;
    edtLimite: TEdit;
    Label9: TLabel;
    edtLimiteDisponivel: TEdit;
    sqlLimite: TSQLQuery;
    cdsItensNegociacaoTotal_Itens: TAggregateField;
    sqlLimitePROR_CODIGO: TIntegerField;
    sqlLimiteDIST_CODIGO: TIntegerField;
    sqlLimiteLIMITE: TFMTBCDField;
    sqlLimiteLIMITE_UTILIZADO: TFMTBCDField;
    sqlLimiteLIMITE_DISPONIVEL: TFMTBCDField;
    cdsNegociacao: TClientDataSet;
    cdsNegociacaoNEGO_CODIGO: TIntegerField;
    cdsNegociacaoNEGO_DATA_CADASTRO: TDateField;
    cdsNegociacaoNEGO_DATA_PENDENTE: TDateField;
    cdsNegociacaoPROR_CODIGO: TIntegerField;
    cdsNegociacaoDIST_CODIGO: TIntegerField;
    cdsNegociacaoNEGO_TOTAL: TFMTBCDField;
    cdsNegociacaoStatusDelta: TStringField;
    edtCodigoPreco: TEdit;
    spbAprovarNegociacao: TSpeedButton;
    spbCancelarNegociacao: TSpeedButton;
    cdsNegociacaoNEGO_STATUS: TStringField;
    cdsNegociacaoPROR_NOME: TStringField;
    cdsNegociacaoDIST_NOME: TStringField;
    cdsNegociacaoNEGO_DATA_APROVACAO: TDateField;
    cdsNegociacaoNEGO_DATA_CONCLUIDA: TDateField;
    cdsNegociacaoNEGO_DATA_CANCELADA: TDateField;
    procedure spbNovoClick(Sender: TObject);
    procedure spbPesquisarClick(Sender: TObject);
    procedure spbEditarClick(Sender: TObject);
    procedure spbCancelarClick(Sender: TObject);
    procedure spbExcluirClick(Sender: TObject);
    procedure spbSairClick(Sender: TObject);
    procedure spbPesqProdutoClick(Sender: TObject);
    procedure spIncluirProdutoClick(Sender: TObject);
    procedure spbDeletarItensClick(Sender: TObject);
    procedure spbPesqProdutorClick(Sender: TObject);
    procedure spbPesqDistClick(Sender: TObject);
    procedure spbSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dbgridItensNegociacaoDblClick(Sender: TObject);
    procedure spbAprovarNegociacaoClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure spbCancelarNegociacaoClick(Sender: TObject);
  private
    { Private declarations }
    bEditar: Boolean;
    procedure LimparDados;
    procedure CarregaDados(codigo: String);
    procedure CarregaDadosItens;
    procedure CarregaLimite;
    procedure AtualizaCredito;
  public
    { Public declarations }
  end;

var
  FRM_Negociacao: TFRM_Negociacao;

implementation

{$R *.dfm}

uses UNT_DM_Principal, UNT_Pesquisa;

{ TFRM_Negociacao }

procedure TFRM_Negociacao.AtualizaCredito;
begin
  if (edtCodProdutor.Text <> '') and (edtCodDist.Text <> '') then
  begin
    sqlLimite.Close;
    sqlLimite.Params.ParamByName('Pror_codigo').Value := StrToInt(edtCodProdutor.Text);
    sqlLimite.Params.ParamByName('Dist_codigo').Value := StrToInt(edtCodDist.Text) ;
    sqlLimite.Open;
    if not sqlLimite.IsEmpty then
    begin
      edtLimite.Text := sqlLimiteLIMITE.AsString;
      edtLimiteDisponivel.Text := sqlLimiteLIMITE_DISPONIVEL.AsString;
      //spbSalvar.Enabled := True;
    end
    else
    begin
      MessageDlg('Informe o limite de crédito do produtor '+ edtNomeProdutor.Text + #13+ ' para o distribuidor  ' + edtNomeDist.Text + ' no cadastro do produtor.', mtInformation, [mbOK], 0);
      spbSalvar.Enabled := False;
    end;
  end;
end;

procedure TFRM_Negociacao.CarregaDados(codigo: String);
begin
  cdsNegociacao.Close;
  DM_PRINCIPAL.sqlNegociacao.Close;
  DM_PRINCIPAL.sqlNegociacao.SQL.Clear;
  DM_PRINCIPAL.sqlNegociacao.SQL.Text :=
    'SELECT                                       ' + sLineBreak +
    '    N.NEGO_CODIGO,                           ' + sLineBreak +
    '    N.NEGO_DATA_CADASTRO,                    ' + sLineBreak +
    '    N.NEGO_DATA_PENDENTE,                    ' + sLineBreak +
    '    N.PROR_CODIGO,                           ' + sLineBreak +
    '    N.DIST_CODIGO,                           ' + sLineBreak +
    '    N.NEGO_STATUS,                           ' + sLineBreak +
    '    N.NEGO_TOTAL,                            ' + sLineBreak +
    '    P.PROR_NOME,                             ' + sLineBreak +
    '    D.DIST_NOME,                             ' + sLineBreak +
    '    N.NEGO_DATA_APROVACAO,                   ' + sLineBreak +
    '    N.NEGO_DATA_CONCLUIDA,                   ' + sLineBreak +
    '    N.NEGO_DATA_CANCELADA                    ' + sLineBreak +

    'FROM                                         ' + sLineBreak +
    '    PSCN_NEGOCIACAO N                        ' + sLineBreak +
    '        INNER JOIN PSCN_PRODUTOR P           ' + sLineBreak +
    '            ON N.PROR_CODIGO = P.PROR_CODIGO ' + sLineBreak +
    '        INNER JOIN PSCN_DISTRIBUIDOR D       ' + sLineBreak +
    '            ON N.DIST_CODIGO = D.DIST_CODIGO ' + sLineBreak +
    'WHERE                                        ' + sLineBreak +
    '     N.NEGO_CODIGO = ' + codigo;
  DM_PRINCIPAL.sqlNegociacao.Open;
  cdsNegociacao.Active := True;

  edtCodigo.Text := cdsNegociacaoNEGO_CODIGO.AsString;
  edtCodProdutor.Text := cdsNegociacaoPROR_CODIGO.AsString;
  FRM_Pesquisa.PesquisaGeral('R', 'Codigo', cdsNegociacaoPROR_CODIGO.AsString);
  if not FRM_Pesquisa.cdsPesquisa.IsEmpty then
  begin
    edtCPFProdutor.Text := FRM_Pesquisa.cdsPesquisa.FieldByName('CPF').AsString;
    edtNomeProdutor.Text := FRM_Pesquisa.cdsPesquisa.FieldByName('Nome').AsString;
  end;

  edtCodDist.Text := cdsNegociacaoDIST_CODIGO.AsString;
  FRM_Pesquisa.PesquisaGeral('D', 'Codigo', cdsNegociacaoDIST_CODIGO.AsString);
  if not FRM_Pesquisa.cdsPesquisa.IsEmpty then
  begin
    edtCNPJDist.Text := FRM_Pesquisa.cdsPesquisa.FieldByName('CNPJ').AsString;
    edtNomeDist.Text := FRM_Pesquisa.cdsPesquisa.FieldByName('Nome').AsString;
  end;

  edtStatus.Text       := cdsNegociacaoNEGO_STATUS.AsString;
  dtpDataCadastro.Date := cdsNegociacaoNEGO_DATA_CADASTRO.AsDateTime;
  edtTotalItens.Text   := cdsNegociacaoNEGO_TOTAL.AsString;
  AtualizaCredito;
  CarregaDadosItens;

  spbAprovarNegociacao.Visible    := (edtStatus.Text = 'PENDENTE') or (edtStatus.Text = 'APROVADA');
  spbCancelarNegociacao.Visible   := spbAprovarNegociacao.Visible;
  spbCancelarNegociacao.Left      := spbAprovarNegociacao.Left + spbAprovarNegociacao.Width;
  spbCancelarNegociacao.Height    := spbAprovarNegociacao.Height;
  spbCancelarNegociacao.Top       := spbAprovarNegociacao.Top;
  spbEditar.Enabled               := (edtStatus.Text = 'PENDENTE');
  PageControl1.ActivePage := tsDados;

end;

procedure TFRM_Negociacao.CarregaDadosItens;
begin
  cdsItensNegociacao.Close;
  DM_PRINCIPAL.sqlItensNegociacao.Close;
  DM_PRINCIPAL.sqlItensNegociacao.SQL.Clear;
  DM_PRINCIPAL.sqlItensNegociacao.SQL.Text :=
    'SELECT                ' + sLineBreak +
    '    I.ITNE_CODIGO,    ' + sLineBreak +
    '    I.NEGO_CODIGO,    ' + sLineBreak +
    '    I.PRPE_CODIGO,    ' + sLineBreak +
    '    PP.PROD_CODIGO,   ' + sLineBreak +
    '    P.PROD_NOME,      ' + sLineBreak +
    '    PP.DIST_CODIGO,   ' + sLineBreak +
    '    PP.PRPE_PRECO     ' + sLineBreak +
    'FROM                  ' + sLineBreak +
    '    PSCN_ITENS_NEGOCIACAO I                       ' + sLineBreak +
    '        INNER JOIN PSCN_PRODUTO_PRECO PP          ' + sLineBreak +
    '            ON I.PRPE_CODIGO = PP.PRPE_CODIGO     ' + sLineBreak +
    '        INNER JOIN PSCN_PRODUTO P                 ' + sLineBreak +
    '            ON PP.PROD_CODIGO = P.PROD_CODIGO     ' + sLineBreak +
    'WHERE                                             ' + sLineBreak +
    '    I.NEGO_CODIGO = ' + edtCodigo.Text;
  DM_PRINCIPAL.sqlItensNegociacao.Open;
  cdsItensNegociacao.Active := True;
  if cdsItensNegociacaoTotal_Itens.AsString = '' then
    edtTotalItens.Text := '0.00'
  else
    edtTotalItens.Text := cdsItensNegociacaoTotal_Itens.AsString;
end;

procedure TFRM_Negociacao.CarregaLimite;
begin

end;

procedure TFRM_Negociacao.dbgridItensNegociacaoDblClick(Sender: TObject);
begin
  if cdsItensNegociacao.Active then
  begin
    if cdsItensNegociacaoITNE_CODIGO.Value > 0  then
    begin
      edtCodItensNegociacao.Text  := cdsItensNegociacaoITNE_CODIGO.AsString;
      edtCodigoPreco.Text         := cdsItensNegociacaoPRPE_CODIGO.AsString;
      edtPreco.Text               := cdsItensNegociacaoPRPE_PRECO.AsString; //formatfloat(',0.00', strtofloat(cdsLimiteLICR_VALOR_LIMITE.AsString));
      edtCodProduto.Text          := cdsItensNegociacaoPROD_CODIGO.AsString;
      edtNomeProduto.Text         := cdsItensNegociacaoPROD_NOME.AsString;
    end;
  end;
end;

procedure TFRM_Negociacao.FormShow(Sender: TObject);
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
  tsItensNegociacao.Visible       := False;
  pnlDadosItensNegociacao.Enabled := false;
  PageControl1.ActivePage         := tsDados;

  LimparDados;

end;

procedure TFRM_Negociacao.LimparDados;
begin
  edtCodigo.Clear;
  edtCodProdutor.Clear;
  edtCodigoPreco.Clear;
  edtCPFProdutor.Clear;
  edtNomeProdutor.Clear;
  edtCodDist.Clear;
  edtCNPJDist.Clear;
  edtNomeDist.Clear;
  edtStatus.Clear;
  dtpDataCadastro.DateTime := Now;
  edtCodItensNegociacao.Clear;
  edtCodProduto.Clear;
  edtNomeProduto.Clear;
  edtPreco.Clear;
  edtTotalItens.Clear;
  edtLimite.Clear;
  edtLimiteDisponivel.Clear;
  pnlDados.Enabled := False;
  pnlDadosItensNegociacao.Enabled;
  PageControl1.ActivePage := tsDados;
  spbAprovarNegociacao.Visible  := False;
  spbCancelarNegociacao.Visible := False;
end;

procedure TFRM_Negociacao.PageControl1Change(Sender: TObject);
begin
  if (PageControl1.ActivePage = tsItensNegociacao) then
    if not bEditar then
    begin
      MessageDlg('É necessário salvar a negociação para inserir os itens da negociação.', mtInformation, [mbOK],0);
    end;

end;

procedure TFRM_Negociacao.spbAprovarNegociacaoClick(Sender: TObject);
begin
  if edtStatus.Text = 'PENDENTE' then
  begin
    if (edtTotalItens.Text = '') or (edtTotalItens.Text = '0.00') then
    begin
      MessageDlg('Negociação não possui itens. Negociação incompleta para ser aprovada.', mtInformation, [mbOK], 0);
      spbAprovarNegociacao.Visible := False;
      Exit;
    end;
    if MessageDlg('Deseja aprovar essa negociação? Essa operação é irreversível.', mtWarning ,[mbYes, mbNo], 0) = mrYes then
    begin
    if (edtTotalItens.Text <> '') then
      if (StrToFloat(DM_PRINCIPAL.TrocaString(edtTotalItens.Text, ',','.')) > StrToFloat(DM_PRINCIPAL.TrocaString(edtLimiteDisponivel.Text, ',','.')))  then
      begin
        MessageDlg('Limite de crédito indisponível para aprovar a negociação.' + #13 + 'Não será possível prosseguir com a aprovação da negociação.' , mtInformation, [mbOK], 0);
        Exit;
      end;

      DM_PRINCIPAL.sqlExecuta.Close;
      DM_PRINCIPAL.sqlExecuta.SQL.Clear;
      DM_PRINCIPAL.sqlExecuta.SQL.Text :=
         'UPDATE PSCN_NEGOCIACAO SET             ' +
         '    NEGO_STATUS = ''APROVADA'',        ' +
         '    NEGO_DATA_APROVACAO = CURRENT_DATE ' +
         'WHERE                                  ' +
         '    NEGO_CODIGO = ' + edtCodigo.Text;
      DM_PRINCIPAL.sqlExecuta.ExecSQL;
      edtStatus.Text := 'APROVADA';
      spbEditar.Enabled := False;
    end;
  end
  else if edtStatus.Text = 'APROVADA' then
  begin
    if MessageDlg('Deseja concluir essa negociação? Essa operação é irreversível.', mtWarning ,[mbYes, mbNo], 0) = mrYes then
    begin
      DM_PRINCIPAL.sqlExecuta.Close;
      DM_PRINCIPAL.sqlExecuta.SQL.Clear;
      DM_PRINCIPAL.sqlExecuta.SQL.Text :=
         'UPDATE PSCN_NEGOCIACAO SET             ' +
         '    NEGO_STATUS = ''CONCLUIDA'',        ' +
         '    NEGO_DATA_CONCLUIDA = CURRENT_DATE ' +
         'WHERE                                  ' +
         '    NEGO_CODIGO = ' + edtCodigo.Text;
      DM_PRINCIPAL.sqlExecuta.ExecSQL;
      edtStatus.Text := 'CONCLUIDA';
      spbEditar.Enabled := False;
    end;
  end;
end;

procedure TFRM_Negociacao.spbCancelarClick(Sender: TObject);
begin
  cdsNegociacao.Cancel;
  cdsItensNegociacao.Cancel;
  spbNovo.Enabled                 := True;
  spbPesquisar.Enabled            := True;
  spbEditar.Enabled               := False;
  spbSalvar.Enabled               := False;
  spbCancelar.Enabled             := False;
  spbExcluir.Enabled              := False;
  spbSair.Enabled                 := True;
  bEditar                         := False;
  pnlDados.Enabled                := False;
  tsItensNegociacao.Visible       := False;
  pnlDadosItensNegociacao.Enabled := False;

  LimparDados;

end;

procedure TFRM_Negociacao.spbCancelarNegociacaoClick(Sender: TObject);
begin
  if (edtStatus.Text = 'PENDENTE') or (edtStatus.Text = 'APROVADA') then
  begin
    if MessageDlg('Deseja cancelar essa negociação? Essa operação é irreversível.', mtWarning ,[mbYes, mbNo], 0) = mrYes then
    begin
      DM_PRINCIPAL.sqlExecuta.Close;
      DM_PRINCIPAL.sqlExecuta.SQL.Clear;
      DM_PRINCIPAL.sqlExecuta.SQL.Text :=
         'UPDATE PSCN_NEGOCIACAO SET             ' +
         '    NEGO_STATUS = ''CANCELADA'',        ' +
         '    NEGO_DATA_CANCELADA = CURRENT_DATE ' +
         'WHERE                                  ' +
         '    NEGO_CODIGO = ' + edtCodigo.Text;
      DM_PRINCIPAL.sqlExecuta.ExecSQL;
      edtStatus.Text := 'CANCELADA';
      spbEditar.Enabled := False;
    end;
  end
  else if (edtStatus.Text = 'CONCLUIDA') then
    MessageDlg('Não será possível cancelar uma negociação concluida.', mtInformation, [mbOK],0) ;
end;

procedure TFRM_Negociacao.spbDeletarItensClick(Sender: TObject);
begin
  if edtCodProduto.Text = '' then
    exit;
  if cdsItensNegociacaoITNE_CODIGO.Value > 0 then
  begin
    DM_PRINCIPAL.sqlAux.Close;
    DM_PRINCIPAL.sqlAux.CommandText :=
      'DELETE FROM PSCN_ITENS_NEGOCIACAO WHERE ITNE_CODIGO = ' + cdsItensNegociacaoITNE_CODIGO.AsString;
    DM_PRINCIPAL.sqlAux.ExecSQL;
    CarregaDadosItens;
    edtCodProduto.Clear;
    edtCodigoPreco.Clear;
    edtCodItensNegociacao.Clear;
    edtNomeProduto.Clear;
    edtPreco.Clear;
  end;
end;

procedure TFRM_Negociacao.spbEditarClick(Sender: TObject);
begin
  spbNovo.Enabled                 := False;
  spbPesquisar.Enabled            := False;
  spbEditar.Enabled               := False;
  spbSalvar.Enabled               := True;
  spbCancelar.Enabled             := True;
  spbExcluir.Enabled              := False;
  spbSair.Enabled                 := False;
  bEditar                         := True;
  pnlDados.Enabled                := True;
  tsItensNegociacao.Visible       := True;
  pnlDadosItensNegociacao.Enabled := True;
  PageControl1.ActivePage         := tsDados;
  spbAprovarNegociacao.Visible    := False;
  spbCancelarNegociacao.Visible   := False;
end;

procedure TFRM_Negociacao.spbExcluirClick(Sender: TObject);
begin
  if MessageDlg('Tem certeza que deseja excluir a negociação ' + edtCodigo.Text + '?', mtWarning, [mbYes, mbNo], 0) = mrYes then
  begin
    if cdsNegociacao.RecordCount > 0 then
    begin
      if MessageDlg
        ('Essa operação irá excluir os itens da negociação. Deseja continuar?', mtWarning, [mbYes, mbNo], 0) = mrYes then
      begin
        DM_PRINCIPAL.sqlAux.Close;
        DM_PRINCIPAL.sqlAux.CommandText :=  'DELETE FROM PSCN_ITENS_NEGOCIACAO WHERE NEGO_CODIGO = ' +      cdsNegociacaoNEGO_CODIGO.AsString;
        DM_PRINCIPAL.sqlAux.ExecSQL;
      end
      else
        exit;
    end;
    cdsNegociacao.Delete;
    cdsNegociacao.ApplyUpdates(-1);
    LimparDados;
  end;
  spbNovo.Enabled                 := True;
  spbPesquisar.Enabled            := True;
  spbEditar.Enabled               := False;
  spbSalvar.Enabled               := False;
  spbCancelar.Enabled             := False;
  spbExcluir.Enabled              := False;
  spbSair.Enabled                 := True;
  bEditar                         := False;
  pnlDados.Enabled                := False;
  tsItensNegociacao.Visible       := False;
  pnlDadosItensNegociacao.Enabled := False;
end;

procedure TFRM_Negociacao.spbNovoClick(Sender: TObject);
begin
  LimparDados;
  spbNovo.Enabled           := False;
  spbPesquisar.Enabled      := False;
  spbEditar.Enabled         := False;
  spbSalvar.Enabled         := True;
  spbCancelar.Enabled       := True;
  spbExcluir.Enabled        := False;
  spbSair.Enabled           := False;
  bEditar                   := False;
  pnlDados.Enabled          := True;
  tsItensNegociacao.Visible := False;
  pnlDadosItensNegociacao.Enabled := False;

  cdsNegociacao.Close;
  DM_PRINCIPAL.sqlNegociacao.Close;
  DM_PRINCIPAL.sqlNegociacao.SQL.Clear;
  DM_PRINCIPAL.sqlNegociacao.SQL.Text :=
    'SELECT                                       ' + sLineBreak +
    '    N.NEGO_CODIGO,                           ' + sLineBreak +
    '    N.NEGO_DATA_CADASTRO,                    ' + sLineBreak +
    '    N.NEGO_DATA_PENDENTE,                    ' + sLineBreak +
    '    N.PROR_CODIGO,                           ' + sLineBreak +
    '    N.DIST_CODIGO,                           ' + sLineBreak +
    '    N.NEGO_STATUS,                           ' + sLineBreak +
    '    N.NEGO_TOTAL,                            ' + sLineBreak +
    '    N.DIST_CODIGO,                           ' + sLineBreak +
    '    P.PROR_NOME,                             ' + sLineBreak +
    '    D.DIST_NOME,                             ' + sLineBreak +
    '    N.NEGO_DATA_APROVACAO,                   ' + sLineBreak +
    '    N.NEGO_DATA_CONCLUIDA,                   ' + sLineBreak +
    '    N.NEGO_DATA_CANCELADA                    ' + sLineBreak +
    'FROM                                         ' + sLineBreak +
    '    PSCN_NEGOCIACAO N                        ' + sLineBreak +
    '        INNER JOIN PSCN_PRODUTOR P           ' + sLineBreak +
    '            ON N.PROR_CODIGO = P.PROR_CODIGO ' + sLineBreak +
    '        INNER JOIN PSCN_DISTRIBUIDOR D       ' + sLineBreak +
    '            ON N.DIST_CODIGO = D.DIST_CODIGO ' + sLineBreak +
    'WHERE                                        ' + sLineBreak +
    '     N.NEGO_CODIGO = 0                       ';
  DM_PRINCIPAL.sqlNegociacao.Open;
  cdsNegociacao.Active := True;

  edtTotalItens.Text := '0.00';
  edtStatus.Text     := 'PENDENTE';
end;

procedure TFRM_Negociacao.spbPesqDistClick(Sender: TObject);
begin
  FRM_Pesquisa.PesquisaGeral('D');
  FRM_Pesquisa.ShowModal;
  if FRM_Pesquisa.Tag = 1 then
  begin
    if not FRM_Pesquisa.cdsPesquisa.IsEmpty then
    begin
      edtCodDist.Text := FRM_Pesquisa.cdsPesquisa.FieldByName('Codigo').AsString;
      edtCNPJDist.Text := FRM_Pesquisa.cdsPesquisa.FieldByName('CNPJ').AsString;
      edtNomeDist.Text := FRM_Pesquisa.cdsPesquisa.FieldByName('Nome').AsString;
      AtualizaCredito;
    end;
  end;

end;

procedure TFRM_Negociacao.spbPesqProdutoClick(Sender: TObject);
begin
  FRM_Pesquisa.PesquisaGeral('PP','Cod.Dist.',edtCodDist.Text);
  FRM_Pesquisa.ShowModal;
  if FRM_Pesquisa.Tag = 1 then
  begin
    if not FRM_Pesquisa.cdsPesquisa.IsEmpty then
    begin
      edtCodigoPreco.Text := FRM_Pesquisa.cdsPesquisa.FieldByName('Codigo').AsString;
      edtCodProduto.Text  := FRM_Pesquisa.cdsPesquisa.FieldByName('Cod.Prod.').AsString;
      edtNomeProduto.Text := FRM_Pesquisa.cdsPesquisa.FieldByName('Nome').AsString;
      edtPreco.Text       := FRM_Pesquisa.cdsPesquisa.FieldByName('Preço').AsString;
    end;
  end;
end;

procedure TFRM_Negociacao.spbPesqProdutorClick(Sender: TObject);
begin
  FRM_Pesquisa.PesquisaGeral('R');
  FRM_Pesquisa.ShowModal;
  if FRM_Pesquisa.Tag = 1 then
  begin
    if not FRM_Pesquisa.cdsPesquisa.IsEmpty then
    begin
      edtCodProdutor.Text := FRM_Pesquisa.cdsPesquisa.FieldByName('Codigo').AsString;
      edtCPFProdutor.Text := FRM_Pesquisa.cdsPesquisa.FieldByName('CPF').AsString;
      edtNomeProdutor.Text := FRM_Pesquisa.cdsPesquisa.FieldByName('Nome').AsString;
      AtualizaCredito;
    end;
  end;
end;

procedure TFRM_Negociacao.spbPesquisarClick(Sender: TObject);
begin
  spbNovo.Enabled := False;
  spbPesquisar.Enabled := False;
  spbEditar.Enabled := True;
  spbSalvar.Enabled := False;
  spbCancelar.Enabled := True;
  spbExcluir.Enabled := True;
  spbSair.Enabled := False;
  bEditar := False;
  pnlDados.Enabled := False;
  pnlDadosItensNegociacao.Enabled := False;

  FRM_Pesquisa.PesquisaGeral('N');
  FRM_Pesquisa.ShowModal;
  if FRM_Pesquisa.Tag = 1 then
  begin
    if not(FRM_Pesquisa.cdsPesquisa.IsEmpty) then
      CarregaDados(FRM_Pesquisa.cdsPesquisa.FieldByName('codigo').AsString);
  end;

end;

procedure TFRM_Negociacao.spbSairClick(Sender: TObject);
begin
  FRM_Negociacao.Close;
end;

procedure TFRM_Negociacao.spbSalvarClick(Sender: TObject);
var
  iCodigo : String;
  iCodigoPreco : Integer;
  tTrans: TTransactionDesc;
begin
  if edtLimiteDisponivel.Text = '' then
  begin
    MessageDlg('Informe o limite de crédito do produtor '+ edtNomeProdutor.Text + #13+ ' para o distribuidor  ' + edtNomeDist.Text + ' no cadastro do produtor.', mtInformation, [mbOK], 0);
    exit;
  end;
  if (edtTotalItens.Text <> '') then
    if (StrToFloat(DM_PRINCIPAL.TrocaString(edtTotalItens.Text, ',','.')) > StrToFloat(DM_PRINCIPAL.TrocaString(edtLimiteDisponivel.Text, ',','.')))  then
    begin
      MessageDlg('O total dos itens da negociação ultrapassa o valor de crédito disponível para o cliente.' + #13 + 'Não será possível prosseguir com a negociação.' , mtInformation, [mbOK], 0);
      Exit;
    end;

  try

    DM_PRINCIPAL.DBEConexao.StartTransaction(tTrans);

    if bEditar then
    begin
      cdsNegociacao.Edit;
    end
    else
    begin
      cdsNegociacao.Append;
      cdsNegociacaoNEGO_CODIGO.AsInteger := DM_PRINCIPAL.GeraCodigo('PSCN_NEGOCIACAO', 'NEGO_CODIGO');
      cdsNegociacaoNEGO_DATA_CADASTRO.AsDateTime := Now;
      cdsNegociacaoNEGO_STATUS.AsString := 'PENDENTE';
    end;

    iCodigo := cdsNegociacaoNEGO_CODIGO.AsString;
    cdsNegociacaoNEGO_DATA_PENDENTE.AsDateTime := cdsNegociacaoNEGO_DATA_CADASTRO.AsDateTime;
    cdsNegociacaoPROR_CODIGO.AsString := edtCodProdutor.Text;
    cdsNegociacaoDIST_CODIGO.AsString := edtCodDist.Text;
    cdsNegociacaoNEGO_TOTAL.AsFloat   := strtoFloat(DM_PRINCIPAL.TrocaString(edtTotalItens.Text,',','.'));
    cdsNegociacao.Post;
    if bEditar then
      DM_PRINCIPAL.GravaDados(cdsNegociacao,'PSCN_NEGOCIACAO',iCodigo,'A')
    else
      DM_PRINCIPAL.GravaDados(cdsNegociacao,'PSCN_NEGOCIACAO',iCodigo,'I');
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
    if cdsItensNegociacao.RecordCount > 0 then
    begin
      DM_PRINCIPAL.sqlAux.Close;
      DM_PRINCIPAL.sqlAux.SQL.Text := 'SELECT ITNE_CODIGO, NEGO_CODIGO, PRPE_CODIGO FROM PSCN_ITENS_NEGOCIACAO WHERE NEGO_CODIGO = ' + edtCodigo.Text;
      DM_PRINCIPAL.sqlAux.Open;
      cdsItensNegociacao.First;
      while not cdsItensNegociacao.Eof do
      begin
        if DM_PRINCIPAL.sqlAux.Locate('PRPE_CODIGO', VarArrayOf([cdsItensNegociacaoPRPE_CODIGO.AsString]), [loCaseInsensitive]) then
          DM_PRINCIPAL.GravaDados(cdsItensNegociacao,'PSCN_ITENS_NEGOCIACAO',cdsItensNegociacaoITNE_CODIGO.AsString,'A')
        else
        begin
          iCodigoPreco := DM_PRINCIPAL.GeraCodigo('PSCN_ITENS_NEGOCIACAO','ITNE_CODIGO');
          DM_PRINCIPAL.GravaDados(cdsItensNegociacao,'PSCN_ITENS_NEGOCIACAO',IntToStr(iCodigoPreco),'I');
        end;
        cdsItensNegociacao.Next;
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
  tsItensNegociacao.Visible         := True;
  pnlDadosItensNegociacao.Enabled   := False;
  spbAprovarNegociacao.Visible      := False;
  spbCancelarNegociacao.Visible     := False;
  PageControl1.ActivePage := tsDados;

  CarregaDados(iCodigo);

end;

procedure TFRM_Negociacao.spIncluirProdutoClick(Sender: TObject);
begin
  if edtCodProduto.Text = '' then
    exit;
  if cdsItensNegociacao.Locate('PROD_CODIGO', edtCodProduto.Text,[loCaseInsensitive]) then
  begin
    MessageDlg('Produto já informado.', mtInformation, [mbOK], 0);
    Exit;
  end
  else
  begin
    cdsItensNegociacao.Append;
    cdsItensNegociacaoITNE_CODIGO.AsInteger := DM_PRINCIPAL.GeraCodigo('PSCN_ITENS_NEGOCIACAO', 'ITNE_CODIGO');
  end;

  cdsItensNegociacaoDIST_CODIGO.AsString := edtCodDist.Text;
  cdsItensNegociacaoNEGO_CODIGO.AsString := edtCodigo.Text;
  cdsItensNegociacaoPROD_CODIGO.AsString := edtCodProduto.Text;
  cdsItensNegociacaoPRPE_CODIGO.AsString := edtCodigoPreco.Text;
  cdsItensNegociacaoPROD_NOME.AsString   := edtNomeProduto.Text;
  cdsItensNegociacaoPRPE_PRECO.AsFloat   := StrToFloat(edtPreco.Text);  // DM_PRINCIPAL.TextToCurr(edtLimite.Text);
  cdsItensNegociacao.Post;

  edtTotalItens.Text := cdsItensNegociacaoTotal_Itens.AsString;
  edtCodProduto.Clear;
  edtCodigoPreco.Clear;
  edtCodItensNegociacao.Clear;
  edtNomeProduto.Clear;
  edtPreco.Clear;

end;

end.
