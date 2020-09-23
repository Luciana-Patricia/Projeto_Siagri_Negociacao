unit unt_Produtor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons;

type
  TFRM_Produtor = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    spbNovo: TSpeedButton;
    spbPesquisar: TSpeedButton;
    spbSalvar: TSpeedButton;
    spbCancelar: TSpeedButton;
    spbExcluir: TSpeedButton;
    spbSair: TSpeedButton;
    Label1: TLabel;
    edtCodigo: TEdit;
    edtCPFCNPJ: TEdit;
    rgTipoProdutor: TRadioGroup;
    lblCPFCNPJ: TLabel;
    Label2: TLabel;
    edtNome: TEdit;
    spbEditar: TSpeedButton;
    procedure rgTipoProdutorClick(Sender: TObject);
    procedure spbNovoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure spbPesquisarClick(Sender: TObject);
    procedure spbEditarClick(Sender: TObject);
    procedure spbSalvarClick(Sender: TObject);
    procedure spbCancelarClick(Sender: TObject);
    procedure spbExcluirClick(Sender: TObject);
    procedure spbSairClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FRM_Produtor: TFRM_Produtor;

implementation

{$R *.dfm}

procedure TFRM_Produtor.FormShow(Sender: TObject);
begin
  spbNovo.Enabled      := True;
  spbPesquisar.Enabled := True;
  spbEditar.Enabled    := False;
  spbSalvar.Enabled    := False;
  spbCancelar.Enabled  := False;
  spbExcluir.Enabled   := False;
  spbSair.Enabled      := True;
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
  spbNovo.Enabled      := True;
  spbPesquisar.Enabled := True;
  spbEditar.Enabled    := False;
  spbSalvar.Enabled    := False;
  spbCancelar.Enabled  := False;
  spbExcluir.Enabled   := False;
  spbSair.Enabled      := True;
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
end;

procedure TFRM_Produtor.spbExcluirClick(Sender: TObject);
begin
  spbNovo.Enabled      := True;
  spbPesquisar.Enabled := True;
  spbEditar.Enabled    := False;
  spbSalvar.Enabled    := False;
  spbCancelar.Enabled  := False;
  spbExcluir.Enabled   := False;
  spbSair.Enabled      := True;

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

end;

procedure TFRM_Produtor.spbSairClick(Sender: TObject);
begin
  FRM_Produtor.Close;
end;

procedure TFRM_Produtor.spbSalvarClick(Sender: TObject);
begin
  spbNovo.Enabled      := True;
  spbPesquisar.Enabled := True;
  spbEditar.Enabled    := False;
  spbSalvar.Enabled    := False;
  spbCancelar.Enabled  := False;
  spbExcluir.Enabled   := False;
  spbSair.Enabled      := True;
end;

end.
