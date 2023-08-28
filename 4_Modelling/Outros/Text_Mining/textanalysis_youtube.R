library(tidytext)
library(tidyverse)
library(igraph)
library(ggraph)
library(topicmodels)
library(vosonSML)

# Obtencao dos dados ####
#Inserindo chave de identificação
apikey <- "AIzaSyA5gVEkN88Gsch3PFFBdF9cSpBwiM2vUSc"
key <- Authenticate("youtube", apiKey = apikey)

#Selecionando os videos para extração
video <- c("E3Huy2cdih0")

youtube <- key %>% Collect(videoIDs = video,
                           maxComments = 5000,
                           verbose = FALSE)

video1 <- as.tibble(youtube)

video1 <- video1 %>% select(1,2,5,6,7,8,9,10,12)

# Palavras ####
video1_tokens <- video1 %>% unnest_tokens(word, Comment) %>%
  anti_join(stop_words)

sentiment_video1 <- video1 %>%
  unnest_tokens(word, Comment) %>%
  anti_join(stop_words) %>%
  inner_join(get_sentiments("bing"))

sentiment_video1 %>% dplyr::count(sentiment, sort = TRUE)
sentiment_video1 %>% dplyr::count(as.factor(value), sort = TRUE) #if the dictionary is afinn

# Bigrams ####
video1_bigrams <- video1 %>%
  unnest_tokens(bigram, Comment, token = "ngrams",n = 2)

video1_separated <- video1_bigrams %>%
  separate(bigram, c("word1","word2"), sep = " ") %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)

video1_separated %>% dplyr::count(word1, word2, sort = TRUE)

video1_united <- video1_separated %>%
  unite(bigram, word1, word2, sep = " ") #joining again the stop words

# Grafos ####
video1_counts <-video1_separated %>% dplyr::count(word1, word2, sort = TRUE) %>% na.omit()

video1_graph <- video1_counts %>%
  filter(n >= 20) %>%
  graph_from_data_frame()


set.seed(2017)
a <- grid::arrow(type = "closed", length = unit(.15,"inches"))

ggraph(video1_graph, layout = "fr") +
  geom_edge_link(aes(edge_alpha = n), show.legend = FALSE,
                 arrow = a, end_cap = circle(.07,'inches')) +
  geom_node_point(color = "lightblue", size = 5) +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
  theme_void()

# Topic Modelling ####
video1_dtm <- video1_tokens %>%
  dplyr::count(word, AuthorChannelID) %>%
  cast_dtm(AuthorChannelID, word,n) %>%
  as.matrix()

video1_dtm[1:4, 751:755]

lda_out <- LDA(video1_dtm,
               k = 4,
               method = "Gibbs",
               control = list(seed = 42)) %>%
  tidy(matrix = "beta")

lda_out %>% arrange(desc(beta))

lda_out %>%
  group_by(topic) %>%
  top_n(15, beta) %>%
  ungroup() %>%
  mutate(term2 = fct_reorder(term, beta)) %>%
  ggplot(aes(term2,beta,fill = as.factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~topic, scales = "free") + coord_flip()

  

