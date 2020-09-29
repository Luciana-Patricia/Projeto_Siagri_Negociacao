object DM_PRINCIPAL: TDM_PRINCIPAL
  OldCreateOrder = False
  Height = 286
  Width = 490
  object Conexao: TIBDatabase
    Connected = True
    DatabaseName = '127.0.0.1:D:\Projeto_Siagri_Negociacao\Data\PSCNEGOCIACAO.FDB'
    Params.Strings = (
      'user_name=SYSDBA'
      'password=masterkey'
      'lc_ctype=WIN1252')
    LoginPrompt = False
    DefaultTransaction = IBTransaction
    ServerType = 'IBServer'
    Left = 32
    Top = 16
  end
  object DBEConexao: TSQLConnection
    ConnectionName = 'PSCN'
    DriverName = 'Firebird'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=Firebird'
      'DriverUnit=Data.DBXFirebird'
      
        'DriverPackageLoader=TDBXDynalinkDriverLoader,DbxCommonDriver200.' +
        'bpl'
      
        'DriverAssemblyLoader=Borland.Data.TDBXDynalinkDriverLoader,Borla' +
        'nd.Data.DbxCommonDriver,Version=20.0.0.0,Culture=neutral,PublicK' +
        'eyToken=91d62ebb5b0d1b1b'
      
        'MetaDataPackageLoader=TDBXFirebirdMetaDataCommandFactory,DbxFire' +
        'birdDriver200.bpl'
      
        'MetaDataAssemblyLoader=Borland.Data.TDBXFirebirdMetaDataCommandF' +
        'actory,Borland.Data.DbxFirebirdDriver,Version=20.0.0.0,Culture=n' +
        'eutral,PublicKeyToken=91d62ebb5b0d1b1b'
      'LibraryName=dbxfb.dll'
      'LibraryNameOsx=libsqlfb.dylib'
      'VendorLib=fbclient.dll'
      'VendorLibWin64=fbclient.dll'
      'VendorLibOsx=/Library/Frameworks/Firebird.framework/Firebird'
      'Database=D:\Projeto_Siagri_Negociacao\Data\PSCNEGOCIACAO.FDB'
      'User_Name=sysdba'
      'Password=masterkey'
      'Role=RoleName'
      'MaxBlobSize=-1'
      'LocaleCode=0000'
      'IsolationLevel=ReadCommitted'
      'SQLDialect=3'
      'CommitRetain=False'
      'WaitOnLocks=True'
      'TrimChar=False'
      'BlobSize=-1'
      'ErrorResourceFile='
      'RoleName=RoleName'
      'ServerCharSet='
      'Trim Char=False')
    Connected = True
    Left = 32
    Top = 72
  end
  object sqlProdutor: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'SELECT * FROM PSCN_PRODUTOR')
    SQLConnection = DBEConexao
    Left = 88
    Top = 72
  end
  object IBTransaction: TIBTransaction
    Active = True
    DefaultDatabase = Conexao
    Left = 88
    Top = 16
  end
  object ibsqlProdutor: TIBQuery
    Database = Conexao
    Transaction = IBTransaction
    BufferChunks = 1000
    CachedUpdates = True
    ParamCheck = True
    SQL.Strings = (
      'select * from PSCN_PRODUTOR')
    Left = 176
    Top = 16
    object ibsqlProdutorPROR_CODIGO: TIntegerField
      FieldName = 'PROR_CODIGO'
      Origin = '"PSCN_PRODUTOR"."PROR_CODIGO"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object ibsqlProdutorPROR_CPF_CNPJ: TIBStringField
      FieldName = 'PROR_CPF_CNPJ'
      Origin = '"PSCN_PRODUTOR"."PROR_CPF_CNPJ"'
      Size = 14
    end
    object ibsqlProdutorPROR_NOME: TIBStringField
      FieldName = 'PROR_NOME'
      Origin = '"PSCN_PRODUTOR"."PROR_NOME"'
      Size = 150
    end
    object ibsqlProdutorPROR_DATA_CADASTRO: TDateField
      FieldName = 'PROR_DATA_CADASTRO'
      Origin = '"PSCN_PRODUTOR"."PROR_DATA_CADASTRO"'
    end
  end
  object sqlAux: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = DBEConexao
    Left = 208
    Top = 72
  end
  object sqlLimite: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'SELECT'
      '    LC.LICR_CODIGO,'
      '    LC.DIST_CODIGO,'
      '    LC.PROR_CODIGO,'
      '    LC.LICR_VALOR_LIMITE,'
      '    D.DIST_CNPJ,'
      '    D.DIST_NOME'
      'FROM'
      '    PSCN_LIMITE_CREDITO LC'
      '        INNER JOIN PSCN_PRODUTOR R'
      '            ON LC.PROR_CODIGO = R.PROR_CODIGO'
      '        INNER JOIN PSCN_DISTRIBUIDOR D'
      '            ON LC.DIST_CODIGO = D.DIST_CODIGO'
      'WHERE'
      '    LC.LICR_CODIGO = 1'
      ''
      '')
    SQLConnection = DBEConexao
    Left = 152
    Top = 72
  end
  object sqlExecuta: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = DBEConexao
    Left = 256
    Top = 72
  end
  object sqlDistribuidor: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'SELECT * FROM PSCN_DISTRIBUIDOR WHERE 0=1')
    SQLConnection = DBEConexao
    Left = 88
    Top = 128
  end
  object sqlProduto: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'SELECT * FROM PSCN_PRODUTO WHERE PROD_CODIGO = 0')
    SQLConnection = DBEConexao
    Left = 152
    Top = 128
  end
  object sqlPreco: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      ''
      'SELECT'
      '    PP.PRPE_CODIGO,'
      '    PP.PROD_CODIGO,'
      '    PP.DIST_CODIGO,'
      '    PP.PRPE_PRECO,'
      '    D.DIST_CNPJ,'
      '    D.DIST_NOME'
      'FROM'
      '    PSCN_PRODUTO_PRECO PP'
      '        INNER JOIN PSCN_PRODUTO P'
      '            ON PP.PROD_CODIGO = P.PROD_CODIGO'
      '        INNER JOIN PSCN_DISTRIBUIDOR D'
      '            ON PP.DIST_CODIGO = D.DIST_CODIGO'
      'WHERE'
      '    PP.PROD_CODIGO = 0')
    SQLConnection = DBEConexao
    Left = 208
    Top = 128
  end
end
