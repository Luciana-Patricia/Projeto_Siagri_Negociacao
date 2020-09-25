unit UNT_DM_Principal;

interface

uses
  System.SysUtils, System.Classes, Data.DB, IBX.IBCustomDataSet, IBX.IBDatabase,
  Data.DBXFirebird, Data.SqlExpr, Data.FMTBcd, IBX.IBQuery;

type
  TDM_PRINCIPAL = class(TDataModule)
    Conexao: TIBDatabase;
    DBEConexao: TSQLConnection;
    sqlProdutor: TSQLQuery;
    IBTransaction: TIBTransaction;
    ibsqlProdutor: TIBQuery;
    ibsqlProdutorPROR_CODIGO: TIntegerField;
    ibsqlProdutorPROR_CPF_CNPJ: TIBStringField;
    ibsqlProdutorPROR_NOME: TIBStringField;
    ibsqlProdutorPROR_DATA_CADASTRO: TDateField;
    sqlAux: TSQLQuery;
    sqlLimite: TSQLQuery;
  private
    { Private declarations }
    dbxTrans: TTransactionDesc;
  public
    { Public declarations }
    function GeraCodigo (sTabela, sCampo : String): Integer;
    function ValidaCPF(CPF: string): boolean;
    function ValidaCNPJ(CNPJ: string): boolean;
  end;

var
  DM_PRINCIPAL: TDM_PRINCIPAL;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDM_PRINCIPAL }
Const
  ordZero = ord('0');

function TDM_PRINCIPAL.GeraCodigo(sTabela, sCampo: String): Integer;
begin
  sqlAux.Close;
  sqlAux.CommandText := 'SELECT MAX('+sCampo+') +1 FROM ' + sTabela;
  sqlAux.Open;

  if sqlAux.IsEmpty then
  begin
    Result := 1
  end else
  begin
    Result := sqlAux.Fields[0].Value;
  end;

end;

function TDM_PRINCIPAL.ValidaCNPJ(CNPJ: string): boolean;
//var
//  soma, pos, resto: smallint;
var   dig13, dig14: string;
    sm, i, r, peso: integer;
begin
// length - retorna o tamanho da string do CNPJ (CNPJ é um número formado por 14 dígitos)
  if ((CNPJ = '00000000000000') or (CNPJ = '11111111111111') or
      (CNPJ = '22222222222222') or (CNPJ = '33333333333333') or
      (CNPJ = '44444444444444') or (CNPJ = '55555555555555') or
      (CNPJ = '66666666666666') or (CNPJ = '77777777777777') or
      (CNPJ = '88888888888888') or (CNPJ = '99999999999999') or
      (length(CNPJ) <> 14))  then
  begin
    Result := false;
    exit;
  end;

// "try" - protege o código para eventuais erros de conversão de tipo através da função "StrToInt"
  try
{ *-- Cálculo do 1o. Digito Verificador --* }
    sm := 0;
    peso := 2;
    for i := 12 downto 1 do
    begin
// StrToInt converte o i-ésimo caractere do CNPJ em um número
      sm := sm + (StrToInt(CNPJ[i]) * peso);
      peso := peso + 1;
      if (peso = 10)
         then peso := 2;
    end;
    r := sm mod 11;
    if ((r = 0) or (r = 1))
       then dig13 := '0'
    else str((11-r):1, dig13); // converte um número no respectivo caractere numérico

{ *-- Cálculo do 2o. Digito Verificador --* }
    sm := 0;
    peso := 2;
    for i := 13 downto 1 do
    begin
      sm := sm + (StrToInt(CNPJ[i]) * peso);
      peso := peso + 1;
      if (peso = 10)
         then peso := 2;
    end;
    r := sm mod 11;
    if ((r = 0) or (r = 1))
       then dig14 := '0'
    else str((11-r):1, dig14);

{ Verifica se os digitos calculados conferem com os digitos informados. }
    if ((dig13 = CNPJ[13]) and (dig14 = CNPJ[14]))
       then Result := true
    else Result := false;
  except
    Result := false
  end;
end;
(*  Result := False;

  if length(CNPJ) < 14 then
    exit;

    { Faz ''Módulo 11'' dos 12 primeiros dígitos }
  soma := 0;
  for pos := 12 downto 5 do { mult.: 2,3,..9 }
    soma := soma + (ord(CNPJ[pos]) - ordZero) * (14 - pos);

  for pos := 4 downto 1 do { mult.: 2,3,..5 }
    soma := soma + (ord(CNPJ[pos]) - ordZero) * (6 - pos);

  resto := 11 - soma mod 11;
  if resto > 9 then resto := 0;

  if resto <> ord(CNPJ[13]) - ordZero then
    exit; { primeiro DV errado }

    { Faz ''Módulo 11'' dos 13 primeiros dígitos }
  soma := 0;
  for pos := 13 downto 6 do { mult.: 2,3,..9 }
    soma := soma + (ord(CNPJ[pos]) - ordZero) * (15 - pos);

  for pos := 5 downto 1 do { mult.: 2,3,..5 }
    soma := soma + (ord(CNPJ[pos]) - ordZero) * (7 - pos);

  resto := 11 - soma mod 11;
  if resto > 9 then resto := 0;

  if resto <> ord(CNPJ[14]) - ordZero then
    exit; { segundo DV errado }

  Result := True;
end;             *)

function TDM_PRINCIPAL.ValidaCPF(CPF: string): boolean;
var
  soma, somaDig, pos, resto: smallint;
  iDigInvalido :boolean;
  iDig1Dupl, iDig2Dupl, iDig3Dupl, iDig4Dupl, iDig5Dupl: Integer;
  iDig6Dupl, iDig7Dupl, iDig8Dupl, iDig9Dupl, iDig0Dupl: Integer;
begin
  Result := False;

  if length(CPF) < 11 then
    exit;

  soma := 0;
  somaDig := 0;
  iDig1Dupl := 0;
  iDig2Dupl := 0;
  iDig3Dupl := 0;
  iDig4Dupl := 0;
  iDig5Dupl := 0;
  iDig6Dupl := 0;
  iDig7Dupl := 0;
  iDig8Dupl := 0;
  iDig9Dupl := 0;
  iDig0Dupl := 0;
  iDigInvalido := False;
  for pos := 1 to 9 do begin
    soma := soma + (ord(CPF[pos]) - ordZero) * (11 - pos);
    somaDig := somaDig + (ord(CPF[pos]) - ordZero);
    if (ord(CPF[pos]) - ordZero) = 1 then
      iDig1Dupl := iDig1Dupl + 1;
    if (ord(CPF[pos]) - ordZero) = 2 then
      iDig2Dupl := iDig2Dupl + 1;
    if (ord(CPF[pos]) - ordZero) = 3 then
      iDig3Dupl := iDig3Dupl + 1;
    if (ord(CPF[pos]) - ordZero) = 4 then
      iDig4Dupl := iDig4Dupl + 1;
    if (ord(CPF[pos]) - ordZero) = 5 then
      iDig5Dupl := iDig5Dupl + 1;
    if (ord(CPF[pos]) - ordZero) = 6 then
      iDig6Dupl := iDig6Dupl + 1;
    if (ord(CPF[pos]) - ordZero) = 7 then
      iDig7Dupl := iDig7Dupl + 1;
    if (ord(CPF[pos]) - ordZero) = 8 then
      iDig8Dupl := iDig8Dupl + 1;
    if (ord(CPF[pos]) - ordZero) = 9 then
      iDig9Dupl := iDig9Dupl + 1;
    if (ord(CPF[pos]) - ordZero) = 0 then
      iDig0Dupl := iDig0Dupl + 1;
  end;

  if (iDig1Dupl = 9) or (iDig2Dupl = 9) or (iDig3Dupl = 9) or (iDig4Dupl = 9) or (iDig5Dupl = 9)
  or (iDig6Dupl = 9) or (iDig7Dupl = 9) or (iDig8Dupl = 9) or (iDig9Dupl = 9) or (iDig0Dupl = 9)
  then
     exit;

  resto := 11 - soma mod 11;
  if resto > 9 then resto := 0;

  if resto <> ord(CPF[10]) - ordZero then
    exit; { primeiro DV errado }

  soma := soma + somaDig + 2 * resto;
  resto := 11 - soma mod 11;
  if resto > 9 then resto := 0;

  if resto <> ord(CPF[11]) - ordZero then
    exit; { segundo DV errado }

  Result := True; { tudo certo }

end;

end.
