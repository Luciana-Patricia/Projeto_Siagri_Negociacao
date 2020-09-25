unit UNT_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

type
  Tfrm_Principal = class(TForm)
    MainMenu1: TMainMenu;
    Cadastro1: TMenuItem;
    Manuteno1: TMenuItem;
    Produtor1: TMenuItem;
    Distribuidor1: TMenuItem;
    Produto1: TMenuItem;
    Negociao1: TMenuItem;
    Image1: TImage;
    StatusBarPrincipal: TStatusBar;
    Timer1: TTimer;
    procedure Produtor1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private

  public
    { Public declarations }
  end;

var
  frm_Principal: Tfrm_Principal;

implementation

{$R *.dfm}

uses UNT_Produtor, UNT_DM_Principal, UNT_Pesquisa;


procedure Tfrm_Principal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(frm_Principal);
  FreeAndNil(FRM_Pesquisa);
  FreeAndNil(DM_PRINCIPAL);
  Application.Terminate;
end;

procedure Tfrm_Principal.FormShow(Sender: TObject);
begin
  if not DM_PRINCIPAL.Conexao.Connected then
    DM_PRINCIPAL.Conexao.Connected := True;
end;

procedure Tfrm_Principal.Produtor1Click(Sender: TObject);
begin
  if FRM_Produtor = nil then
    Application.CreateForm(TFRM_Produtor,FRM_Produtor);
  FRM_Produtor.ShowModal;

end;

procedure Tfrm_Principal.Timer1Timer(Sender: TObject);
begin
  StatusBarPrincipal.Panels[0].Text := FormatDateTime('DD/MM/YYYY hh:mm:ss', Now);
end;

end.
