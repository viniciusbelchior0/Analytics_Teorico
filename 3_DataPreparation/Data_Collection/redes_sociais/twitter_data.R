#Collecting Twitter data
library(rtweet)
library(httpuv)
library(tidyverse)
library(tidytext)
library(igraph)
library(ggraph)
library(topicmodels)

shein <- search_tweets("shein", n=5000, include_rts = TRUE, lang = "pt")
names(shein)

#1. Analise Textual ####
stopwordpt <- stopwordslangs %>% filter(lang == "pt" & p>= 0.95) %>% select(word)

shein_clean <- shein %>% select(1:9,11:18,67,69,78:84)
shein_tokens <- shein_clean %>% unnest_tokens(word, text) %>% anti_join(stopwordpt, by = "word")

#1.2 - bigrams e grafos
shein_bigrams <- shein_clean %>%
  unnest_tokens(bigram, text, token = "ngrams",n = 2)

shein_separated <- shein_bigrams %>%
  separate(bigram, c("word1","word2"), sep = " ") %>%
  filter(!word1 %in% stopwordpt$word) %>%
  filter(!word2 %in% stopwordpt$word)

shein_separated %>% count(word1, word2, sort = TRUE)

shein_united <- shein_separated %>%
  unite(bigram, word1, word2, sep = " ")

shein_counts <-shein_separated %>% count(word1, word2, sort = TRUE) %>% na.omit()

shein_graph <- shein_counts %>%
  filter(n >= 50) %>%
  graph_from_data_frame()

set.seed(2017)
a <- grid::arrow(type = "closed", length = unit(.15,"inches"))

ggraph(shein_graph, layout = "fr") +
  geom_edge_link(aes(edge_alpha = n), show.legend = FALSE,
                 arrow = a, end_cap = circle(.07,'inches')) +
  geom_node_point(color = "lightblue", size = 5) +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
  theme_void()

#1.3 - Topic Modelling
shein_dtm <- shein_clean %>% unnest_tokens(word, text) %>% 
  anti_join(stopwordpt, by = "word") %>%
  count(word, user_id) %>%
  cast_dtm(user_id, word,n) %>%
  as.matrix()

shein_dtm[1:4, 751:755] #vendo a matriz

lda_out <- LDA(shein_dtm,
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
