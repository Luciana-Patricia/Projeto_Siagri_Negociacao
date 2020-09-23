object DM_PRINCIPAL: TDM_PRINCIPAL
  OldCreateOrder = False
  Height = 226
  Width = 356
  object Conexao: TIBDatabase
    Connected = True
    DatabaseName = '127.0.0.1:D:\Projeto Siagri\Data\PSCNegociacao.fdb'
    Params.Strings = (
      'user_name=SYSDBA'
      'password=masterkey'
      'lc_ctype=WIN1252')
    LoginPrompt = False
    ServerType = 'IBServer'
    Left = 32
    Top = 16
  end
  object IBDataSet1: TIBDataSet
    Database = Conexao
    BufferChunks = 1000
    CachedUpdates = False
    SelectSQL.Strings = (
      'SELECT * FROM PSCN_PRODUTOR')
    ParamCheck = True
    UniDirectional = False
    Left = 104
    Top = 16
  end
end
