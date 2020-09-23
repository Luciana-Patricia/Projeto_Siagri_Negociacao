program Projeto_PSCN;

uses
  Vcl.Forms,
  UNT_Principal in 'UNT_Principal.pas' {frm_Principal},
  UNT_Frame_Pesquisa in 'UNT_Frame_Pesquisa.pas' {IWFrame2: TFrame},
  UNT_Produtor in 'UNT_Produtor.pas' {FRM_Produtor},
  UNT_DM_Principal in 'UNT_DM_Principal.pas' {DM_PRINCIPAL: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_Principal, frm_Principal);
  Application.CreateForm(TFRM_Produtor, FRM_Produtor);
  Application.CreateForm(TDM_PRINCIPAL, DM_PRINCIPAL);
  Application.Run;
end.
