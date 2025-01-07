#Coletando dados do Youtube (comentários dos vídeos)
library(vosonSML)
library(tidyverse)

#Inserindo chave de identificação
apikey <- "AIzaSyA5gVEkN88Gsch3PFFBdF9cSpBwiM2vUSc"
key <- Authenticate("youtube", apiKey = apikey)

#Selecionando os videos para extração
video <- c("Oq4-p4ojf9g")

youtube <- key %>% Collect(videoIDs = video,
        maxComments = 10000,
        verbose = FALSE)

