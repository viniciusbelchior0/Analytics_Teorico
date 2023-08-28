library(tidyverse)
library(DescTools)
library(readxl)

#https://www.rdocumentation.org/packages/DescTools/versions/0.99.49/topics/Association%20measures
#https://rstudio-pubs-static.s3.amazonaws.com/558925_38b86f0530c9480fad4d029a4e4aea68.html
#https://medium.com/@nyablk97/contingency-tables-in-r-3a5219f5cd38



frota_munic <- read_xlsx("frota_munic.xlsx", sheet = "Sheet1" , col_names = TRUE)

# Comparacao por regiao
regioes <- frota_munic %>% select(UF, REGIAO, AUTOMOVEL, MOTOCICLETA) %>%
  group_by(REGIAO) %>% summarise(AUTOMOVEL = sum(AUTOMOVEL), 
                                 MOTOCICLETA = sum(MOTOCICLETA),
                                 TOTAL = AUTOMOVEL + MOTOCICLETA) %>%
                       mutate(P_AUTO = AUTOMOVEL/TOTAL, P_MOTO = MOTOCICLETA/TOTAL)

regioes_t <- regioes %>% select(1:3) %>% pivot_longer(cols = c(2,3),
                                                      names_to = "TIPO",
                                                      values_to = "TOTAL")

ggplot(regioes_t) +
  aes(x = REGIAO, fill = TIPO, weight = TOTAL) +
  geom_bar(position = "fill") +
  scale_fill_hue(direction = 1) +
  ggthemes::theme_fivethirtyeight()

TschuprowT(regioes_t$REGIAO, regioes_t$TIPO)
TschuprowT(regioes_t$REGIAO, regioes_t$TOTAL)
TschuprowT(regioes$REGIAO, regioes$P_MOTO)
TschuprowT(estados$UF, estados$P_AUTO)


# Comparacao por estado
estados <- frota_munic %>% select(UF, REGIAO, AUTOMOVEL, MOTOCICLETA) %>%
  group_by(UF) %>% summarise(AUTOMOVEL = sum(AUTOMOVEL), 
                                 MOTOCICLETA = sum(MOTOCICLETA),
                                 TOTAL = AUTOMOVEL + MOTOCICLETA) %>%
  mutate(P_AUTO = AUTOMOVEL/TOTAL, P_MOTO = MOTOCICLETA/TOTAL)


  

