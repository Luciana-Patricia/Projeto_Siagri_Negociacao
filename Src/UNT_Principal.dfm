object frm_Principal: Tfrm_Principal
  Left = 0
  Top = 0
  Caption = 'PSCNegocia'#231#227'o'
  ClientHeight = 201
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Left = 152
    Top = 56
    object Cadastro1: TMenuItem
      Caption = '&Cadastro'
      object Produtor1: TMenuItem
        Caption = '&Produtor'
        OnClick = Produtor1Click
      end
      object Distribuidor1: TMenuItem
        Caption = '&Distribuidor'
      end
      object Produto1: TMenuItem
        Caption = '&Produto'
      end
    end
    object Manuteno1: TMenuItem
      Caption = 'Manuten'#231#227'o'
      object Negociao1: TMenuItem
        Caption = '&Negocia'#231#227'o'
      end
    end
  end
end
