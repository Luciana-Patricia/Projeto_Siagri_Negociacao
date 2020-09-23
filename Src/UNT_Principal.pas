unit UNT_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus;

type
  Tfrm_Principal = class(TForm)
    MainMenu1: TMainMenu;
    Cadastro1: TMenuItem;
    Manuteno1: TMenuItem;
    Produtor1: TMenuItem;
    Distribuidor1: TMenuItem;
    Produto1: TMenuItem;
    Negociao1: TMenuItem;
    procedure Produtor1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Principal: Tfrm_Principal;

implementation

{$R *.dfm}

uses UNT_Produtor;

procedure Tfrm_Principal.Produtor1Click(Sender: TObject);
begin
  if FRM_Produtor = nil then
    Application.CreateForm(TFRM_Produtor,FRM_Produtor);
  FRM_Produtor.ShowModal;

end;

end.
