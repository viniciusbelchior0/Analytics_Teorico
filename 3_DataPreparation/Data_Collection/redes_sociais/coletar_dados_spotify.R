devtools::install_github('charlie86/spotifyr')

library(tidyverse)
library(spotifyr)
Sys.setenv(SPOTIFY_CLIENT_ID = "f7813b4a7f954fea908f4f0319c53e51")
Sys.setenv(SPOTIFY_CLIENT_SECRET = "d2c9c94628e348898a56e1dbd026bef6")

dataframe <- get_artist_audio_features("Marcos Valle")

dataframe <- dataframe %>% select(1,36,7,9:19,22,26,30,32,37:39) %>%
  dplyr::mutate(duration_sec = duration_ms/1000) %>%
  select(1,2,3,17,18,22,4:15,19:21)

write.csv2(dataframe, "artista.csv")