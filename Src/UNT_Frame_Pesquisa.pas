unit UNT_Frame_Pesquisa;

interface

uses
  SysUtils, Classes, Controls, Forms,
  IWVCLBaseContainer, IWColor, IWContainer, IWRegion, Vcl.StdCtrls, Vcl.Buttons,
  IWHTMLContainer, IWHTML40Container;

type
  TIWFrame2 = class(TFrame)
    IWFrameRegion: TIWRegion;
    edtCodigo: TEdit;
    spbCodigo: TSpeedButton;
    edtNome: TEdit;
    spbNome: TSpeedButton;
    Label1: TLabel;
    Nome: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.