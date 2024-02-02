object DM: TDM
  Height = 275
  Width = 480
  object conLocalDB: TUniConnection
    ProviderName = 'MySQL'
    Port = 3306
    Database = 'xtouch'
    Options.LocalFailover = True
    PoolingOptions.Validate = True
    Username = 'xtouch'
    Server = 'localhost'
    LoginPrompt = False
    AfterConnect = conLocalDBAfterConnect
    BeforeConnect = conLocalDBBeforeConnect
    AfterDisconnect = conLocalDBAfterDisconnect
    OnError = conLocalDBError
    OnConnectionLost = conLocalDBConnectionLost
    Left = 48
    Top = 40
    EncryptedPassword = 'DEFF87FF8BFFBFFF8AFF9CFF97FFCCFFCCFFCFFFC6FF'
  end
  object UniMySQLProvider: TMySQLUniProvider
    Left = 48
    Top = 96
  end
end
