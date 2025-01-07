library(plyr)
library(tuber)
library(tidyverse)

client_id <- "26615932509-r4hc38uc49imgf26ol6k4lb1icihv01f.apps.googleusercontent.com"
client_secret <- "65I_vrehIz-50THuVjr60ugk"

yt_oauth(app_id = client_id, app_secret = client_secret, token = '')


playlist <- tuber::get_playlist_items(filter = c(playlist_id = "PLrMXKWpIOj1kfvZfb8LadxY6MUojONvze"
                                                 ), part = "contentDetails", max_results = 500)

#Check the data for HayaWarz
playlist %>% dplyr::glimpse(78)

#Ids
playlist_ids = base::as.vector(playlist$contentDetails.videoId)
dplyr::glimpse(playlist_ids)


# Function to scrape stats for all vids
get_all_stats <- function(id) {
  tuber::get_stats(video_id = id)
} 

# Get stats and convert results to data frame 
VideosStats <- purrr::map_df(.x = playlist_ids, 
                                          .f = get_all_stats)

VideosStats %>% dplyr::glimpse(78)

#Export Data (nao sei o que significa)####
# export DataRaw
readr::write_csv(x = as.data.frame(hayaWarz), 
                 path = paste0("data/", 
                               base::noquote(lubridate::today()),
                               "-HayaWarzone.csv"))

# export DaveChappelleRaw
readr::write_csv(x = as.data.frame(HayaWarzoneStatsRaw), 
                 path = paste0("data/", 
                               base::noquote(lubridate::today()),
                               "-HayaWarzoneStatsRaw.csv"))

# verify
fs::dir_ls("data", regexp = "Dave")
# Exportar ####
write_csv(VideosStats,"VideoStats.csv")


