SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [MarketData].[PriceHistory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ItemKey] [nvarchar](50) NOT NULL,
	[Category] [nvarchar](100) NOT NULL,
	[Title] [nvarchar](200) NOT NULL,
	[Price] [bigint] NOT NULL,
	[ChangeValue] [decimal](18, 4) NULL,
	[HighPrice] [bigint] NULL,
	[LowPrice] [bigint] NULL,
	[UpdateDateTime] [datetime2](3) NOT NULL,
	[InsertDateTime] [datetime2](3) NOT NULL,
PRIMARY KEY CLUSTERED 
([ID] ASC)

WITH (PAD_INDEX = OFF,
       STATISTICS_NORECOMPUTE = OFF,
       IGNORE_DUP_KEY = OFF,
       ALLOW_ROW_LOCKS = ON,
       ALLOW_PAGE_LOCKS = ON, 
       OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [MarketData].[PriceHistory] 
ADD  DEFAULT (sysutcdatetime()) FOR [InsertDateTime]
GO


