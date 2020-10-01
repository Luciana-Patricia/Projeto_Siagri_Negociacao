unit UNT_Relatório;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Data.FMTBcd, Datasnap.Provider,
  Datasnap.DBClient, Data.DB, Data.SqlExpr, IWSystem;

type
  TFRM_Relatorio = class(TForm)
    Panel1: TPanel;
    spbNovo: TSpeedButton;
    Panel3: TPanel;
    spbFiltrar: TSpeedButton;
    spbCancelar: TSpeedButton;
    spbSair: TSpeedButton;
    PageControl1: TPageControl;
    tsFiltro: TTabSheet;
    pnlDados: TPanel;
    tsDados: TTabSheet;
    dbgridLimite: TDBGrid;
    Label2: TLabel;
    spbPesqDist: TSpeedButton;
    Label1: TLabel;
    spbPesqProdutor: TSpeedButton;
    edtCodProdutor: TEdit;
    edtNomeProdutor: TEdit;
    edtCodDist: TEdit;
    edtNomeDist: TEdit;
    edtCPFProdutor: TEdit;
    edtCNPJDist: TEdit;
    dsRelatorio: TDataSource;
    sqlRelatorio: TSQLQuery;
    cdsRelatorio: TClientDataSet;
    dspRelatorio: TDataSetProvider;
    rgFitroStatus: TRadioGroup;
    cdsRelatorioCODIGOCONTRATO: TIntegerField;
    cdsRelatorioDATACADASTRO: TDateField;
    cdsRelatorioCODPRODUTOR: TIntegerField;
    cdsRelatorioPRODUTOR: TStringField;
    cdsRelatorioCODDISTR: TIntegerField;
    cdsRelatorioDISTRIBUIDOR: TStringField;
    cdsRelatorioSTATUS: TStringField;
    cdsRelatorioTOTAL: TFMTBCDField;
    cdsRelatorioDATAPENDENTE: TDateField;
    cdsRelatorioDATAAPROVACAO: TStringField;
    cdsRelatorioDATACONCLUSÃO: TStringField;
    cdsRelatorioDATACANCELAMENTO: TStringField;
    procedure spbPesqProdutorClick(Sender: TObject);
    procedure spbPesqDistClick(Sender: TObject);
    procedure spbCancelarClick(Sender: TObject);
    procedure spbFiltrarClick(Sender: TObject);
    procedure spbSairClick(Sender: TObject);
    procedure spbNovoClick(Sender: TObject);
  private
    { Private declarations }
    procedure LimparDados;
    procedure ExportaExcel;
  public
    { Public declarations }
  end;

var
  FRM_Relatorio: TFRM_Relatorio;

implementation

{$R *.dfm}

uses UNT_Pesquisa, UNT_DM_Principal;

procedure TFRM_Relatorio.ExportaExcel;
var
  slLista : TStringList;
  sLinha : String;
  iCont  : Integer;
begin
  slLista := TStringList.Create;
  sLinha := '';
  for icont := 0 to cdsRelatorio.Fields.Count - 1  do
    sLinha := sLinha + cdsRelatorio.Fields.Fields[iCont].DisplayLabel+';';
  slLista.Add(sLinha);

  cdsRelatorio.First;
  while not cdsRelatorio.Eof do
  begin
    sLinha := '';
    for icont := 0 to cdsRelatorio.Fields.Count - 1  do
      sLinha := sLinha + cdsRelatorio.Fields.Fields[iCont].DisplayText+';';
    slLista.Add(sLinha);
    cdsRelatorio.Next;
  end;
  if FileExists(gsAppPath + 'negociacao.csv') then
    DeleteFile(gsAppPath + 'negociacao.csv') ;
  slLista.SaveToFile(gsAppPath + 'negociacao.csv');
  ShowMessage('Dados exportados com sucesso.' + gsAppPath + 'negociacao.csv');
end;

procedure TFRM_Relatorio.LimparDados;
begin
  edtCodProdutor.Clear;
  edtNomeProdutor.Clear;
  edtCPFProdutor.Clear;
  edtCodDist.Clear;
  edtCNPJDist.Clear;
  edtNomeDist.Clear;
end;

procedure TFRM_Relatorio.spbCancelarClick(Sender: TObject);
begin
  LimparDados;
  cdsRelatorio.Close;
end;

procedure TFRM_Relatorio.spbFiltrarClick(Sender: TObject);
var
  sFiltro : String;
begin
  sFiltro := '';
  cdsRelatorio.Close;
  sqlRelatorio.Close;
  sqlRelatorio.SQL.Clear;
  sqlRelatorio.SQL.Text :=
      'SELECT                                                      ' + sLineBreak +
      '    N.NEGO_CODIGO "CODIGO CONTRATO",                        ' + sLineBreak +
      '    N.NEGO_DATA_CADASTRO "DATA CADASTRO",                   ' + sLineBreak +
      '    N.PROR_CODIGO "COD. PRODUTOR",                          ' + sLineBreak +
      '    P.PROR_NOME "PRODUTOR",                                 ' + sLineBreak +
      '    N.DIST_CODIGO "COD. DISTR.",                            ' + sLineBreak +
      '    D.DIST_NOME "DISTRIBUIDOR",                             ' + sLineBreak +
      '    N.NEGO_STATUS "STATUS",                                 ' + sLineBreak +
      '    N.NEGO_TOTAL "TOTAL",                                   ' + sLineBreak +
      '    N.NEGO_DATA_PENDENTE "DATA PENDENTE",                   ' + sLineBreak +
      '    CASE WHEN N.NEGO_DATA_APROVACAO = ''12/30/1899''        ' + sLineBreak +
      '         THEN '' ''                                         ' + sLineBreak +
      '         ELSE N.NEGO_DATA_APROVACAO                         ' + sLineBreak +
      '    END     "DATA APROVACAO",                               ' + sLineBreak +
      '    CASE WHEN N.NEGO_DATA_CONCLUIDA = ''12/30/1899''        ' + sLineBreak +
      '         THEN '' ''                                         ' + sLineBreak +
      '         ELSE N.NEGO_DATA_CONCLUIDA                         ' + sLineBreak +
      '    END "DATA CONCLUSÃO",                                   ' + sLineBreak +
      '    CASE WHEN N.NEGO_DATA_CANCELADA = ''12/30/1899''        ' + sLineBreak +
      '         THEN '' ''                                         ' + sLineBreak +
      '         ELSE N.NEGO_DATA_CANCELADA                         ' + sLineBreak +
      '    END "DATA CANCELAMENTO"                                 ' + sLineBreak +
      'FROM                                                        ' + sLineBreak +
      '    PSCN_NEGOCIACAO N                                       ' + sLineBreak +
      '        INNER JOIN PSCN_PRODUTOR P                          ' + sLineBreak +
      '            ON N.PROR_CODIGO = P.PROR_CODIGO                ' + sLineBreak +
      '        INNER JOIN PSCN_DISTRIBUIDOR D                      ' + sLineBreak +
      '            ON N.DIST_CODIGO = D.DIST_CODIGO                ' + sLineBreak +
      'WHERE 0 = 0 ';
  if edtCodProdutor.Text <> '' then
    sFiltro := sfiltro + ' AND N.PROR_CODIGO = ' + edtCodProdutor.Text;

  if (edtCodDist.Text <> '') then
    sFiltro := sfiltro + ' AND N.DIST_CODIGO = ' + edtCodDist.Text;

  if rgFitroStatus.ItemIndex > 0 then
  begin
    case rgFitroStatus.ItemIndex of
      1: sFiltro := sfiltro + ' AND N.NEGO_STATUS = "PENDENTE" ';
      2: sFiltro := sfiltro + ' AND N.NEGO_STATUS = "APROVADA" ';
      3: sFiltro := sfiltro + ' AND N.NEGO_STATUS = "CONCLUIDA" ';
      4: sFiltro := sfiltro + ' AND N.NEGO_STATUS = "CANCELADA" ';
    end;
  end;

  sqlRelatorio.SQL.Text := sqlRelatorio.SQL.Text + sFiltro;
  sqlRelatorio.Open;
  cdsRelatorio.Active:= True;
  PageControl1.ActivePage := tsDados;

end;

procedure TFRM_Relatorio.spbNovoClick(Sender: TObject);
var
  steste : String;
begin
  steste := 'path: ' + gsAppPath + #13 +' name:' + gsAppName + #13 +' temp:' + gsTempPath + #13 + ' sys:' + GSystemPath;
 // ShowMessage( steste);
  spbFiltrarClick(self);
  ExportaExcel;
end;

procedure TFRM_Relatorio.spbPesqDistClick(Sender: TObject);
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
    end;
  end;

end;

procedure TFRM_Relatorio.spbPesqProdutorClick(Sender: TObject);
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
    end;
  end;

end;

procedure TFRM_Relatorio.spbSairClick(Sender: TObject);
begin
FRM_Relatorio.Close;
end;

end.
