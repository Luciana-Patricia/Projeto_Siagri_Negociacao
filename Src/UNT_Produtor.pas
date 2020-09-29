unit unt_Produtor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  Datasnap.Provider, Data.DB, Datasnap.DBClient, UNT_Frame_Pesquisa,Data.SqlExpr,
  Vcl.ComCtrls, Vcl.Tabs, Vcl.Mask, Vcl.Grids, Vcl.DBGrids;

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
    PageControl1: TPageControl;
    tsDados: TTabSheet;
    tsLimite: TTabSheet;
    pnlDados: TPanel;
    Label1: TLabel;
    lblCPFCNPJ: TLabel;
    Label2: TLabel;
    edtCodigo: TEdit;
    edtCPFCNPJ: TEdit;
    rgTipoProdutor: TRadioGroup;
    edtNome: TEdit;
    pnlDadosLimite: TPanel;
    Label3: TLabel;
    edtCodDistribuidor: TEdit;
    spbCodigo: TSpeedButton;
    lblNomeDist: TLabel;
    edtNomeDistribuidor: TEdit;
    Label4: TLabel;
    spIncluirLimite: TSpeedButton;
    spbDeletarLimite: TSpeedButton;
    dbgridLimite: TDBGrid;
    dsLimite: TDataSource;
    cdsLimite: TClientDataSet;
    dspLimite: TDataSetProvider;
    cdsLimiteLICR_CODIGO: TIntegerField;
    cdsLimiteDIST_CNPJ: TStringField;
    cdsLimiteDIST_NOME: TStringField;
    cdsLimiteDIST_CODIGO: TIntegerField;
    cdsLimitePROR_CODIGO: TIntegerField;
    cdsLimiteLICR_VALOR_LIMITE: TFMTBCDField;
    edtCodLimite: TEdit;
    edtLimite: TEdit;
    edtCNPJDistribuidor: TEdit;
    cdsLimiteStatusDelta: TStringField;
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
    procedure spIncluirLimiteClick(Sender: TObject);
    procedure spbDeletarLimiteClick(Sender: TObject);
    procedure dbgridLimiteDblClick(Sender: TObject);
    procedure spbCodigoClick(Sender: TObject);
    procedure edtLimiteKeyPress(Sender: TObject; var Key: Char);
    procedure edtLimiteExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    bEditar : Boolean;
    procedure CarregaDados(Codigo: String);
    procedure CarregaDadosLimite;
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

  CarregaDadosLimite;
  PageControl1.ActivePage := tsDados;

end;

procedure TFRM_Produtor.CarregaDadosLimite;
begin
{Carrega limite de credito}
  cdsLimite.Close;
  DM_PRINCIPAL.sqlLimite.Close;
  DM_PRINCIPAL.sqlLimite.SQL.Clear;
  DM_PRINCIPAL.sqlLimite.SQL.Text :=
    'SELECT                     ' + sLineBreak +
    '    LC.LICR_CODIGO,        ' + sLineBreak +
    '    LC.DIST_CODIGO,        ' + sLineBreak +
    '    LC.PROR_CODIGO,        ' + sLineBreak +
    '    LC.LICR_VALOR_LIMITE,  ' + sLineBreak +
    '    D.DIST_CNPJ,           ' + sLineBreak +
    '    D.DIST_NOME            ' + sLineBreak +
    'FROM                       ' + sLineBreak +
    '    PSCN_LIMITE_CREDITO LC ' + sLineBreak +
    '        INNER JOIN PSCN_PRODUTOR R              '+ sLineBreak +
    '            ON LC.PROR_CODIGO = R.PROR_CODIGO   '+ sLineBreak +
    '        INNER JOIN PSCN_DISTRIBUIDOR D          '+ sLineBreak +
    '            ON LC.DIST_CODIGO = D.DIST_CODIGO   '+ sLineBreak +
    'WHERE                                           '+ sLineBreak +
    '    LC.PROR_CODIGO = ' + edtCodigo.Text;
  DM_PRINCIPAL.sqlLimite.Open;
  cdsLimite.Active := True;
end;

procedure TFRM_Produtor.dbgridLimiteDblClick(Sender: TObject);
begin
  if cdsLimite.Active then
  begin
    if cdsLimiteLICR_CODIGO.Value > 0  then
    begin
      edtCodLimite.Text        := cdsLimiteLICR_CODIGO.AsString;
      edtCodDistribuidor.Text  := cdsLimiteDIST_CODIGO.AsString;
      edtNomeDistribuidor.Text := cdsLimiteDIST_NOME.AsString;
      edtLimite.Text           := cdsLimiteLICR_VALOR_LIMITE.AsString; //formatfloat(',0.00', strtofloat(cdsLimiteLICR_VALOR_LIMITE.AsString));
      edtCNPJDistribuidor.Text := cdsLimiteDIST_CNPJ.AsString;
    end;
  end;
end;

procedure TFRM_Produtor.edtCPFCNPJExit(Sender: TObject);
begin
  if rgTipoProdutor.ItemIndex < 0 then
    rgTipoProdutor.ItemIndex := 0;

  if Trim(edtCPFCNPJ.Text) <> '' then
  begin
    if rgTipoProdutor.ItemIndex = 0 then
    begin
      if not DM_PRINCIPAL.ValidaCPF(edtCPFCNPJ.Text) then
      begin
        MessageDlg('CPF inválido.',mtError, [mbOK],0);
        edtCPFCNPJ.SetFocus;
      end
    end
    else
    begin
      if not DM_PRINCIPAL.ValidaCNPJ(edtCPFCNPJ.Text) then
      begin
        MessageDlg('CNPJ inválido.',mtError, [mbOK],0);
        edtCPFCNPJ.SetFocus;
      end
    end
  end;

end;

procedure TFRM_Produtor.edtCPFCNPJKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9', #8, #13]) then
    key := #0;
end;

procedure TFRM_Produtor.edtLimiteExit(Sender: TObject);
begin
  //edtLimite.text := formatfloat('#.##', strtofloat(edtLimite.text));
  if edtCodDistribuidor.Text = '' then
    edtLimite.Text := '0.00';
end;

procedure TFRM_Produtor.edtLimiteKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9', '.',#8, #13]) then
    key := #0;

end;

procedure TFRM_Produtor.FormCreate(Sender: TObject);
begin
  FormatSettings.DecimalSeparator := '.';
//  FormatSettings.ThousandSeparator := '.';

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
  tsLimite.Visible     := False;
  PageControl1.ActivePage := tsDados;
  LimparDados;
end;

procedure TFRM_Produtor.LimparDados;
begin
  edtCodigo.Clear;
  edtCPFCNPJ.Clear;
  edtNome.Clear;
  edtCNPJDistribuidor.Clear;
  edtNomeDistribuidor.Clear;
  edtCodLimite.Clear;
  edtCodDistribuidor.Clear;
  rgTipoProdutor.ItemIndex := -1;
  edtLimite.Clear;
  PageControl1.ActivePage := tsDados;
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
  cdsLimite.Cancel;
  spbNovo.Enabled      := True;
  spbPesquisar.Enabled := True;
  spbEditar.Enabled    := False;
  spbSalvar.Enabled    := False;
  spbCancelar.Enabled  := False;
  spbExcluir.Enabled   := False;
  spbSair.Enabled      := True;
  bEditar              := False;
  pnlDados.Enabled     := False;
  tsLimite.Visible     := False;

  LimparDados;
end;

procedure TFRM_Produtor.spbCodigoClick(Sender: TObject);
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

procedure TFRM_Produtor.spbDeletarLimiteClick(Sender: TObject);
begin
  if edtCodDistribuidor.Text = '' then
    exit;
  if cdsLimiteLICR_CODIGO.Value > 0 then
  begin
    DM_PRINCIPAL.sqlAux.Close;
    DM_PRINCIPAL.sqlAux.CommandText := 'DELETE FROM PSCN_LIMITE_CREDITO WHERE LICR_CODIGO = ' + cdsLimiteLICR_CODIGO.AsString;
    DM_PRINCIPAL.sqlAux.ExecSQL;
    CarregaDadosLimite;
  end;
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
  tsLimite.Visible     := True;
  pnlDadosLimite.Enabled  := True;
  PageControl1.ActivePage := tsDados;
end;

procedure TFRM_Produtor.spbExcluirClick(Sender: TObject);
begin
  if MessageDlg('Tem certeza que deseja excluir o produtor ' + edtNome.Text + '?',mtWarning,[mbYes, mbNo],0) = mrYes then
  begin
    if cdsLimite.RecordCount > 0  then
    begin
      if MessageDlg('Essa operação irá excluir os limites de créditos do produtor. Deseja continuar?', mtWarning, [mbYes,mbNo],0) = mrYes then
      begin
        DM_PRINCIPAL.sqlAux.Close;
        DM_PRINCIPAL.sqlAux.CommandText := 'DELETE FROM PSCN_LIMITE_CREDITO WHERE PROR_CODIGO = ' + cdsProdutorPROR_CODIGO.AsString;
        DM_PRINCIPAL.sqlAux.ExecSQL;
      end else
        Exit;
    end;
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
  tsLimite.Visible     := False;
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
  tsLimite.Visible     := False;

  LimparDados;
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
      cdsProdutorPROR_DATA_CADASTRO.AsDateTime := Now;
    end;

    iCodigo := cdsProdutorPROR_CODIGO.AsString;
    cdsProdutorPROR_CPF_CNPJ.AsString := edtCPFCNPJ.Text;
    cdsProdutorPROR_NOME.AsString     := edtNome.Text;
    cdsProdutor.Post;
    cdsProdutor.ApplyUpdates(-1);

    if bEditar then
    begin
      if cdsLimite.RecordCount > 0 then
      begin
        DM_PRINCIPAL.sqlAux.Close;
        DM_PRINCIPAL.sqlAux.SQL.Text := 'SELECT LICR_CODIGO FROM PSCN_LIMITE_CREDITO WHERE PROR_CODIGO = ' + edtCodigo.Text;
        DM_PRINCIPAL.sqlAux.Open;
        cdsLimite.First;
        while not cdsLimite.Eof do
        begin
          if DM_PRINCIPAL.sqlAux.Locate('LICR_CODIGO', cdsLimiteLICR_CODIGO.AsString, [loCaseInsensitive]) then
            DM_PRINCIPAL.GravaDados(cdsLimite,'PSCN_LIMITE_CREDITO',cdsLimiteLICR_CODIGO.AsString,'A')
          else
            DM_PRINCIPAL.GravaDados(cdsLimite,'PSCN_LIMITE_CREDITO',cdsLimiteLICR_CODIGO.AsString,'I');
          cdsLimite.Next;
        end;
      end;
    end;
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
  tsLimite.Visible     := True;
  pnlDadosLimite.Enabled  := False;
  PageControl1.ActivePage := tsDados;

  CarregaDados(iCodigo);
end;

procedure TFRM_Produtor.spIncluirLimiteClick(Sender: TObject);
begin
  if edtCodDistribuidor.Text = '' then
    exit;
  if cdsLimite.Locate('DIST_CODIGO',edtCodDistribuidor.Text,[loCaseInsensitive]) then
  //if edtCodLimite.Text = '' then
  begin
    cdsLimite.Edit;
  end
  else
  begin
    cdsLimite.Append;
    cdsLimiteLICR_CODIGO.AsInteger := DM_PRINCIPAL.GeraCodigo('PSCN_LIMITE_CREDITO','LICR_CODIGO');
  end;

  cdsLimiteDIST_CODIGO.AsString         := edtCodDistribuidor.Text;
  cdsLimiteLICR_VALOR_LIMITE.AsFloat    := StrToFloat(edtLimite.Text); //DM_PRINCIPAL.TextToCurr(edtLimite.Text);
  cdsLimitePROR_CODIGO.AsString         := edtCodigo.Text;
  cdsLimiteDIST_CNPJ.AsString           := edtCNPJDistribuidor.Text;
  cdsLimiteDIST_NOME.AsString           := edtNomeDistribuidor.Text;
  cdsLimite.Post;

  edtCodDistribuidor.Clear;
  edtCodLimite.Clear;
  edtNomeDistribuidor.Clear;
  edtCNPJDistribuidor.Clear;
  edtLimite.Clear;

end;

end.
