object dmTarefa: TdmTarefa
  OldCreateOrder = False
  Height = 295
  Width = 507
  object cdsTarefa: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 280
    Top = 128
  end
  object FDTransaction1: TFDTransaction
    Connection = FDConnection1
    Left = 96
    Top = 176
  end
  object FDConnection1: TFDConnection
    Left = 160
    Top = 72
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Transaction = FDTransaction1
    Left = 232
    Top = 192
  end
end
