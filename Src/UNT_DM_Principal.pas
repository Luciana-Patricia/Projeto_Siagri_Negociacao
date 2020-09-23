unit UNT_DM_Principal;

interface

uses
  System.SysUtils, System.Classes, Data.DB, IBX.IBCustomDataSet, IBX.IBDatabase;

type
  TDM_PRINCIPAL = class(TDataModule)
    Conexao: TIBDatabase;
    IBDataSet1: TIBDataSet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM_PRINCIPAL: TDM_PRINCIPAL;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
