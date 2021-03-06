program Projeto_PSCN;

uses
  Vcl.Forms,
  UNT_Principal in 'UNT_Principal.pas' {frm_Principal},
  UNT_Frame_Pesquisa in 'UNT_Frame_Pesquisa.pas' {IWFrame2: TFrame},
  UNT_Produtor in 'UNT_Produtor.pas' {FRM_Produtor},
  UNT_DM_Principal in 'UNT_DM_Principal.pas' {DM_PRINCIPAL: TDataModule},
  UNT_Pesquisa in 'UNT_Pesquisa.pas' {FRM_Pesquisa},
  UNT_Distribuidor in 'UNT_Distribuidor.pas' {FRM_Distribuidor},
  UNT_Produto in 'UNT_Produto.pas' {FRM_Produto},
  UNT_Negociacao in 'UNT_Negociacao.pas' {FRM_Negociacao},
  UNT_Relatório in 'UNT_Relatório.pas' {FRM_Relatorio};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_Principal, frm_Principal);
  Application.CreateForm(TDM_PRINCIPAL, DM_PRINCIPAL);
  Application.CreateForm(TFRM_Pesquisa, FRM_Pesquisa);
  Application.Run;
end.
