library(tidyverse)
library(summarytools)
library(DataExplorer)
library(dataMaid)

dados <- read.csv("eleicoes_jaboticabal.csv")

#Opcao 1: summarytools
summarytools::view(dfSummary(dados))

#Opcao 2: DataExplorer
DataExplorer::create_report(dados)

#Opcao 3: dataMaid
dataMaid::makeDataReport(dados)