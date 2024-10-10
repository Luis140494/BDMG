object FrmTarefa: TFrmTarefa
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Tarefa'
  ClientHeight = 517
  ClientWidth = 904
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlGrid: TPanel
    Left = 0
    Top = 0
    Width = 904
    Height = 517
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object cxGridTarefa: TcxGrid
      Left = 0
      Top = 0
      Width = 904
      Height = 517
      Align = alClient
      TabOrder = 0
      object cxGridTarefaDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = dsTarefa
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.GroupByBox = False
      end
      object cxGridTarefaLevel: TcxGridLevel
        GridView = cxGridTarefaDBTableView
      end
    end
  end
  object dsTarefa: TDataSource
    DataSet = dmTarefa.cdsTarefa
    Left = 624
    Top = 241
  end
end
