devtools::install_github('charlie86/spotifyr')

library(tidyverse)
library(spotifyr)
Sys.setenv(SPOTIFY_CLIENT_ID = "spotify_client_id")
Sys.setenv(SPOTIFY_CLIENT_SECRET = "spotify_client_secret")

dataframe <- get_artist_audio_features("Marcos Valle")

dataframe <- dataframe %>% select(1,36,7,9:19,22,26,30,32,37:39) %>%
  dplyr::mutate(duration_sec = duration_ms/1000) %>%
  select(1,2,3,17,18,22,4:15,19:21)

write.csv2(dataframe, "artista.csv")
