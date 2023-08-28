library(gutenbergr)
library(tidyverse)
library(tidytext)
library(tidyr)
library(scales)
library(igraph)
library(ggraph)
library(widyr)

# Getting the data

morus <- gutenberg_download(c(2130))
hobbes <- gutenberg_download(c(3207))
machiavelli <- gutenberg_download(c(1232))

tidy_morus <- morus %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

tidy_hobbes <- hobbes %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

tidy_machiavelli <- machiavelli %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

# Most Common words for every author

tidy_morus %>% count(word, sort = TRUE)
tidy_hobbes %>% count(word, sort = TRUE)
tidy_machiavelli %>% count(word, sort = TRUE)

# Frequency Relation between Authors ####

#Talvez colocar o autor a ser relacionado em ultimo lugar
frequency <- bind_rows(mutate(tidy_morus, author = "Thomas Morus"),
                       mutate(tidy_hobbes, author = "Thomas Hobbes"),
                       mutate(tidy_machiavelli, author = "Nicolo Machiavelli")) %>%
  mutate(word = str_extract(word, "[a-z']+")) %>% 
  count(author, word) %>%
  group_by(author) %>%
  mutate(proportion = n/sum(n)) %>%
  select(-n) %>%
  spread(author, proportion) %>%
  gather(author, proportion, `Thomas Hobbes`:`Nicolo Machiavelli`)

#Graphic

ggplot(frequency, aes(x = proportion, y = `Thomas Morus`,
                     color = abs(`Thomas Morus` - proportion))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  scale_color_gradient(limits = c(0, 0.001),
                       low = "darkslategray4", high = "gray75") +
  facet_wrap(~author, ncol = 2) +
  theme(legend.position="none") +
  labs(y = "Thomas Morus", x = NULL)

# Correlation

cor.test(data = frequency[frequency$author == "Thomas Hobbes",],
         ~ proportion + `Thomas Morus` )

cor.test(data = frequency[frequency$author == "Nicolo Machiavelli",],
         ~ proportion + `Thomas Morus` )

# Sentiment Analysis ####

sentiment_morus <- morus %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  inner_join(get_sentiments("bing"))

sentiment_morus %>% count(sentiment, sort = TRUE)
sentiment_morus %>% count(as.factor(value), sort = TRUE) #if the dictionary is afinn

sentiment_hobbes <- hobbes %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  inner_join(get_sentiments("bing"))

sentiment_hobbes %>% count(sentiment, sort = TRUE)
sentiment_hobbes %>% count(as.factor(value), sort = TRUE) #if the dictionary is afinn

sentiment_machiavelli <- machiavelli %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>% 
  inner_join(get_sentiments("bing"))

sentiment_machiavelli %>% count(sentiment, sort = TRUE)
sentiment_machiavelli %>% count(as.factor(value), sort = TRUE) #if the dictionary is afinn

# TF-IDF ####

politics <- gutenberg_download(c(2130,3207,1232), meta_fields = "author")

politics_words <- politics %>% unnest_tokens(word, text) %>%
  count(author, word, sort = TRUE) %>%
  ungroup()

politics_words

#Plot politics
plot_politics <- politics_words %>%
  bind_tf_idf(word, author, n) %>%
  arrange(desc(tf_idf)) %>%
  mutate(word = factor(word, levels = rev(unique(word)))) %>%
  mutate(author = factor(author, levels = c("More, Thomas, Saint", "Hobbes, Thomas","Machiavelli, Niccolò")))

plot_politics %>%
  group_by(author) %>%
  top_n(15, tf_idf) %>%
  ungroup() %>%
  mutate(word = reorder(word, tf_idf)) %>%
  ggplot(aes(word, tf_idf, fill = author)) +
  geom_col(show.legend = FALSE) +
  labs(x = NULL, y = "tf-idf") +
  facet_wrap(~author, ncol = 2, scales = "free") +
  coord_flip()

# N-Grams and Correlation between words ####

machiavelli_bigrams <- machiavelli %>%
  unnest_tokens(bigram, text, token = "ngrams",n = 2)

machiavelli_separated <- machiavelli_bigrams %>%
  separate(bigram, c("word1","word2"), sep = " ")

machiavelli_filered <- machiavelli_separated %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)

machiavelli_bigram_counts <- machiavelli_filered %>%
  count(word1, word2, sort = TRUE)

machiavelli_bigram_counts

machiavelli_united <- machiavelli_filered %>%
  unite(bigram, word1, word2, sep = " ") #joining again the stop words

machiavelli_united

# Trigrams

hobbes_trigrams <- hobbes %>%
  unnest_tokens(trigram, text, token = "ngrams", n = 3) %>%
  separate(trigram, c("word1","word2","word3"), sep = " ") %>%
  filter(!word1 %in% stop_words$word,
         !word2 %in% stop_words$word,
         !word3 %in% stop_words$word) %>%
  count(word1, word2, word3, sort = TRUE)

hobbes_trigrams

# Bigrams TF-IDF

#base de dados diferente para fazer o grafico
politics <- gutenberg_download(c(2130,3207,1232), meta_fields = "author")

politics_bigrams <- politics %>% unnest_tokens(bigram,text, token = "ngrams", n = 2)

politics_bigrams <- politics_bigrams %>% 
  separate(bigram,c("word1","word2"), sep = " ") %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word) %>%
  unite(bigram, word1,word2, sep = " ")

politics_bigrams %>% count(bigram, sort = TRUE)

politics_bigrams_tfidf <- politics_bigrams %>%
  count(author, bigram) %>%
  bind_tf_idf(bigram, author, n) %>%
  arrange(desc(tf_idf))

politics_bigrams_tfidf

#most common bigrams per author chart
ptfidf <- politics_bigrams_tfidf[1:25,] # selecting only the highest 25 tf-idf

ggplot(ptfidf) +
  aes(x = bigram, fill = author, weight = tf_idf) +
  geom_bar() +
  scale_fill_hue() +
  coord_flip() +
  theme_light() +
  theme(legend.position = "none") +
  facet_wrap(vars(author), scales = "free")

# bigram with sentiment analysis: vc pode filtrar por palavras na base separada
# (word1, word2) e filtrar por palavra e fazer sentimentos

## Graphs
machiavelli_counts <- machiavelli_filered %>% count(word1, word2, sort = TRUE)
machiavelli_counts <- machiavelli_counts[2:2659,]

machiavelli_graph <- machiavelli_counts %>%
  filter(n > 5) %>%
  graph_from_data_frame()

machiavelli_graph

#Graph chart
set.seed(2017)

a <- grid::arrow(type = "closed", length = unit(.15,"inches"))

ggraph(machiavelli_graph, layout = "fr") +
  geom_edge_link(aes(edge_alpha = n), show.legend = FALSE,
                 arrow = a, end_cap = circle(.07,'inches')) +
  geom_node_point(color = "lightblue", size = 5) +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
  theme_void()

#Pairwise correlation between words - phi-coefficient * trava o PC

politics <- gutenberg_download(c(2130,3207,1232), meta_fields = "author")

politics_words <- politics %>%
  unnest_tokens(word, text) %>%
  filter(!word %in% stop_words$word)

politics_words

word_pairs <- politics_words %>%
  pairwise_count(word, author,sort = TRUE)

politics_words$gutenberg_id <- NULL
