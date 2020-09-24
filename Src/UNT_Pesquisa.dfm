object FRM_Pesquisa: TFRM_Pesquisa
  Left = 0
  Top = 0
  Caption = 'Pesquisa'
  ClientHeight = 315
  ClientWidth = 442
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inline IWFrame21: TIWFrame2
    Left = 0
    Top = 0
    Width = 442
    Height = 74
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 442
    inherited IWFrameRegion: TIWRegion
      Width = 442
      ExplicitWidth = 442
      ExplicitHeight = 74
      inherited spbCodigo: TSpeedButton
        OnClick = IWFrame21spbCodigoClick
      end
      inherited spbNome: TSpeedButton
        OnClick = IWFrame21spbNomeClick
      end
      inherited edtCodigo: TEdit
        OnKeyPress = IWFrame21edtCodigoKeyPress
      end
      inherited edtNome: TEdit
        OnKeyPress = IWFrame21edtNomeKeyPress
      end
    end
  end
  object pnlDados: TPanel
    Left = 0
    Top = 74
    Width = 442
    Height = 241
    Align = alClient
    TabOrder = 1
    object dbgPesquisa: TDBGrid
      Left = 1
      Top = 1
      Width = 440
      Height = 239
      Align = alClient
      DataSource = dsPesquisa
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDblClick = dbgPesquisaDblClick
      OnKeyPress = dbgPesquisaKeyPress
    end
  end
  object dsPesquisa: TDataSource
    DataSet = cdsPesquisa
    Left = 224
    Top = 186
  end
  object cdsPesquisa: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspPesquisa'
    Left = 272
    Top = 186
  end
  object sqlPesquisa: TSQLDataSet
    MaxBlobSize = -1
    Params = <>
    SQLConnection = DM_PRINCIPAL.DBEConexao
    Left = 384
    Top = 186
  end
  object dspPesquisa: TDataSetProvider
    DataSet = sqlPesquisa
    Left = 328
    Top = 186
  end
end
