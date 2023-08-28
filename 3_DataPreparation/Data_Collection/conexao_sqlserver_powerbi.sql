/* Informacoes para acesso ao banco SQL Server
LAPTOP-9TGH0HK7\SQLEXPRESS
AdventureWorksDW2017
*/ 

/* Queries diretamente na hora de inserir no powerBI, sem necessidade de fazer ELT*/ 

/*dClientes*/

SELECT dc.[CustomerKey]
      ,dc.[GeographyKey]
      ,CONCAT(dc.[FirstName],dc.[LastName]) as NameCustomer
      ,dc.[BirthDate]
      ,dc.[MaritalStatus]
      ,dc.[Gender]
      ,dc.[EmailAddress]
      ,dc.[YearlyIncome]
      ,dc.[TotalChildren]
      ,dc.[NumberChildrenAtHome]
      ,dc.[EnglishEducation]
      ,dc.[EnglishOccupation]
      ,dc.[HouseOwnerFlag]
      ,dc.[NumberCarsOwned]
      ,dc.[AddressLine1]
      ,dc.[Phone]
      ,dc.[DateFirstPurchase]
      ,dc.[CommuteDistance]
	  ,dg.[City]
      ,dg.[StateProvinceCode]
      ,dg.[StateProvinceName]
      ,dg.[CountryRegionCode]
      ,dg.[EnglishCountryRegionName]
      ,dg.[PostalCode]
      ,dg.[IpAddressLocator]
	  ,dst.[SalesTerritoryRegion]
      ,dst.[SalesTerritoryCountry]
      ,dst.[SalesTerritoryGroup]
  FROM [AdventureWorksDW2017].[dbo].[DimCustomer] as dc
  LEFT JOIN [AdventureWorksDW2017].[dbo].[DimGeography] as dg
  ON (dc.[GeographyKey] = dg.[GeographyKey])
  LEFT JOIN [AdventureWorksDW2017].[dbo].[DimSalesTerritory] as dst
  ON (dg.[SalesTerritoryKey] = dst.[SalesTerritoryKey])

/*dProdutos*/

SELECT dp.[ProductKey]
      ,dp.[ModelName]
      ,dp.[ProductAlternateKey]
      ,dp.[ProductSubcategoryKey]
	  ,dpsc.[ProductCategoryKey]
      ,dp.[EnglishProductName]
      ,dp.[SafetyStockLevel]
      ,dp.[ReorderPoint]
      ,dp.[EnglishDescription]
      ,dp.[StartDate]
      ,dp.[EndDate]
      ,dp.[Status]
	  ,dpsc.[EnglishProductSubcategoryName]
	  ,dpc.[EnglishProductCategoryName]
  FROM [AdventureWorksDW2017].[dbo].[DimProduct] as dp
  LEFT JOIN [AdventureWorksDW2017].[dbo].[DimProductSubcategory] as dpsc
  ON (dp.[ProductSubcategoryKey] = dpsc.[ProductSubcategoryKey])
  LEFT JOIN [AdventureWorksDW2017].[dbo].[DimProductCategory] as dpc
  ON (dpsc.[ProductCategoryKey] = dpc.[ProductCategoryKey])

/*fCallCenter*/

SELECT [FactCallCenterID]
      ,[WageType]
      ,[Shift]
      ,[LevelOneOperators]
      ,[LevelTwoOperators]
      ,[TotalOperators]
      ,[Calls]
      ,[AutomaticResponses]
      ,[Orders]
      ,[IssuesRaised]
      ,[AverageTimePerIssue]
      ,[ServiceGrade]
      ,[Date]
  FROM [AdventureWorksDW2017].[dbo].[FactCallCenter]

/*fFinancas*/

SELECT [FinanceKey]
	  ,do.[OrganizationName]
	  ,do.[PercentageOfOwnership]
	  ,dcu.[CurrencyName]
      ,ddg.[DepartmentGroupName]
      ,dsc.[ScenarioName]
	  ,acc.[AccountDescription]
      ,acc.[AccountType]
      ,acc.[Operator]
      ,acc.[ValueType]
	  ,ff.[Amount]
	  ,ff.[Date]
  FROM [AdventureWorksDW2017].[dbo].[FactFinance] as ff
  LEFT JOIN [AdventureWorksDW2017].[dbo].[DimOrganization] as do
  ON (ff.[OrganizationKey] = do.[OrganizationKey])
  LEFT JOIN [AdventureWorksDW2017].[dbo].[DimDepartmentGroup] as ddg
  ON (ff.[DepartmentGroupKey] = ddg.[DepartmentGroupKey])
  LEFT JOIN [AdventureWorksDW2017].[dbo].[DimScenario] as dsc
  ON (ff.[ScenarioKey] = dsc.[ScenarioKey])
  LEFT JOIN [AdventureWorksDW2017].[dbo].[DimAccount] as acc
  ON (ff.[AccountKey] = acc.[AccountKey])
  LEFT JOIN [AdventureWorksDW2017].[dbo].[DimCurrency] as dcu
  ON (do.[CurrencyKey] = dcu.[CurrencyKey])
  WHERE NOT ScenarioName = 'Forecast'

/*fInternetSales*/
SELECT fis.[ProductKey]
      ,fis.[CustomerKey]
      ,dpro.[EnglishPromotionType]
      ,dpro.[EnglishPromotionCategory]
      ,dcu.[CurrencyName]
      ,dter.[SalesTerritoryRegion]
      ,dter.[SalesTerritoryCountry]
      ,dter.[SalesTerritoryGroup]
      ,dsr.[SalesReasonName]
      ,dsr.[SalesReasonReasonType]
      ,fis.[OrderQuantity]
      ,fis.[UnitPrice]
      ,fis.[UnitPriceDiscountPct]
      ,fis.[ProductStandardCost]
      ,fis.[TaxAmt]
      ,fis.[Freight]
	  ,(fis.[OrderQuantity]*(fis.[UnitPrice]*(1-fis.[UnitPriceDiscountPct])-fis.ProductStandardCost)-(fis.[TaxAmt] + fis.[Freight])) as Profit
      ,fis.[OrderDate]
  FROM [AdventureWorksDW2017].[dbo].[FactInternetSales] as fis
  LEFT JOIN [AdventureWorksDW2017].[dbo].[FactInternetSalesReason] as fir
  ON (fis.[SalesOrderNumber] = fir.[SalesOrderNumber])
  LEFT JOIN [AdventureWorksDW2017].[dbo].[DimPromotion] as dpro
  ON (fis.[PromotionKey] = dpro.[PromotionKey])
  LEFT JOIN [AdventureWorksDW2017].[dbo].[DimCurrency] as dcu
  ON (fis.[CurrencyKey] = dcu.[CurrencyKey])
  LEFT JOIN [AdventureWorksDW2017].[dbo].[DimSalesTerritory] as dter
  ON (fis.[SalesTerritoryKey] = dter.[SalesTerritoryKey])
  LEFT JOIN [AdventureWorksDW2017].[dbo].[DimSalesReason] as dsr
  ON (fir.[SalesReasonKey] = dsr.[SalesReasonKey])

/*fProductInventory*/

SELECT [ProductKey]
      ,[DateKey]
      ,[UnitCost]
      ,[UnitsIn]
      ,[UnitsOut]
      ,[UnitsBalance]
  FROM [AdventureWorksDW2017].[dbo].[FactProductInventory]
