unit UNT_DM_Principal;

interface

uses
  System.SysUtils, System.Classes, Data.DB, IBX.IBCustomDataSet, IBX.IBDatabase,
  Data.DBXFirebird, Data.SqlExpr, Data.FMTBcd, IBX.IBQuery, Datasnap.DBClient, Vcl.Dialogs;

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
    sqlExecuta: TSQLQuery;
    sqlDistribuidor: TSQLQuery;
    sqlProduto: TSQLQuery;
    sqlPreco: TSQLQuery;
  private
    { Private declarations }
    dbxTrans: TTransactionDesc;
  public
    { Public declarations }
    function GeraCodigo (sTabela, sCampo : String): Integer;
    function GravaDados (cdsTabela: TClientDataSet;
                         sTabela: String;
                         keys: String;
                         operacao : String) : Boolean;
    function ValidaCPF(CPF: string): boolean;
    function ValidaCNPJ(CNPJ: string): boolean;
    function TextToCurr(Texto: String): Currency;
    function QtdString(StringALocalizar, StringTexto: ShortString): Byte;
    function TrocaString(texto,busca,troca : String) : String;
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

  if (sqlAux.IsEmpty) or (sqlAux.Fields[0].IsNull) then
  begin
    Result := 1
  end else
  begin
    Result := sqlAux.Fields[0].Value;
  end;

end;

function TDM_PRINCIPAL.GravaDados(cdsTabela: TClientDataSet ;sTabela, keys, operacao: String): Boolean;
var
  key, key1, key2: array of string;
  iqtdKey, i, iqtdCampos: Integer;
  skeys, sCampos, sWhere, sValue, sTexto : string;
begin
  try
    cdsTabela.ControlsDisabled;
    skeys := Keys;
    iqtdKey := QtdString(';', skeys) + 1;

    SetLength(Key1, iqtdKey);
    SetLength(key2, iqtdKey);
    SetLength(key, iqtdKey);

    //Identificado cada chave primaria

    if iqtdKey > 1 then
    begin
      for i := 0 to iqtdKey - 1 do
      begin
        if pos(';', skeys) > 0 then
        begin
          key[i] := copy(skeys, 1, pos(';', skeys) - 1);
          Delete(skeys, 1, pos(';', skeys));
        end
        else
          key[i] := skeys;
      end;
    end
    else
      key[0] := skeys;

    sCampos := '';
    sWhere  := '';
    sValue  := '';
    sTexto  := '';
    if operacao = 'A' then
    begin
      for I := 0 to cdsTabela.FieldCount - 1 do
      begin
        if cdsTabela.Fields.Fields[i].Tag = 1 then
          if sWhere = '' then
            sWhere :=  ' Where ' +  cdsTabela.Fields.Fields[i].FieldName + '=' + key[0]
          else
            sWhere := sWhere + 'and ' + cdsTabela.Fields.Fields[i].FieldName + '=' + key[1] ;
        if (cdsTabela.Fields.Fields[i].FieldName = 'StatusDelta') then Break;
        if sCampos = '' then
          sCampos := cdsTabela.Fields.Fields[i].FieldName + '=' +cdsTabela.Fields.Fields[i].AsString
        else
          sCampos := sCampos + ' , '+  cdsTabela.Fields.Fields[i].FieldName + '=' +cdsTabela.Fields.Fields[i].AsString;

      end;
      sqlExecuta.Close;
      sqlExecuta.SQL.Clear;
      sqlExecuta.SQL.Text := 'Update ' + sTabela + ' Set ' +  sCampos + sWhere;
      sqlExecuta.ExecSQL;
    end else if operacao  = 'E' then
    begin

    end else if operacao = 'I' then
    begin
      for I := 0 to cdsTabela.FieldCount - 1 do
      begin
        if (cdsTabela.Fields.Fields[i].FieldName = 'StatusDelta') then Break;

        if sCampos = '' then
          sCampos := cdsTabela.Fields.Fields[i].FieldName
        else
          sCampos := sCampos + ' , '+  cdsTabela.Fields.Fields[i].FieldName ;


        if sValue = '' then
          sValue :=  cdsTabela.Fields.Fields[i].AsString
        else
        begin
          if cdsTabela.Fields.Fields[i].IsNull then
            sValue := sValue + ', null '  ;
          if cdsTabela.Fields.Fields[i].DataType in [ftString, ftWideString] then
          begin
            sTexto := cdsTabela.Fields.Fields[i].AsString;
            sTexto := TrocaString(sTexto, '"', '´´');
            sTexto := TrocaString(sTexto, '''', '´');
            sTexto := TrocaString(sTexto, '`', '´');
            sValue := sValue + ', ' + quotedstr(sTexto) ;
          end
          else if cdsTabela.Fields.Fields[i].DataType in [ftDateTime, ftDate, ftTimeStamp] then
          begin
            if length(cdsTabela.Fields.Fields[i].AsString) > 10 then
              sValue := sValue + quotedstr(formatDateTime('mm/dd/yyyy hh:nn:ss', cdsTabela.Fields.Fields[i].asDateTime)) + ','
            else
              sValue := sValue + quotedstr(formatDateTime('mm/dd/yyyy', cdsTabela.Fields.Fields[i].asDateTime)) + ',';
          end
          else
            sValue := sValue + ', ' + cdsTabela.Fields.Fields[i].AsString ;
        end;

      end;
      sqlExecuta.Close;
      sqlExecuta.SQL.Clear;
      sqlExecuta.SQL.Text := 'INSERT INTO ' + sTabela + '( ' +  sCampos + ') VALUES (' + sValue + ')' ;
      sqlExecuta.ExecSQL;

    end;
    Result := True;
    cdsTabela.EnableControls;

  except on E: Exception do
    begin
      MessageDlg(Format('Erro ao gravar dados da tabela ' + sTabela + '. Erro %s.', [e.Message]), mtError, [mbOK],0);
      Result := False;
      cdsTabela.EnableControls;
    end;
  end;
end;

function TDM_PRINCIPAL.QtdString(StringALocalizar,  StringTexto: ShortString): Byte;
var
  P: Byte;
begin
  Result := 0;
  P := Pos(StringALocalizar, StringTexto);
  while P > 0 do
  begin
    Inc(Result);
    StringTexto := Copy(StringTexto, P + Length(StringALocalizar), 255);
    P := Pos(StringALocalizar, StringTexto);
  end;

end;

function TDM_PRINCIPAL.TextToCurr(Texto: String): Currency;
var
  i: Integer;
  TextoLimpo: String;
begin
   TextoLimpo := '';
   For i := 1 to Length(Texto) do
  begin
     if Texto[i] in ['0'..'9',','] then
         TextoLimpo := TextoLimpo + Texto[i];
  end;
  Result := StrToFloat(TextoLimpo);
end;

function TDM_PRINCIPAL.TrocaString(texto, busca, troca: String): String;
{ Substitui um caractere dentro da string}
var
  n: integer;
begin
  n := 1;
  while n <= length(texto) do
  begin
    if Copy(texto, n, 1) = Busca then
    begin
      Delete(texto, n, 1);
      Insert(Troca, texto, n);
    end;
    n := n + 1;
  end;
  Result := texto;

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
