library(literaturaBR)
library(tidytext)
library(tidyverse)
library(stringr)
library(quanteda)
library(qdap)
library(forcats)
library(ggthemes)
theme_set(theme_bw())

# references:
# qdap package: https://rpubs.com/Custer/text
# quanteda package: https://cran.r-project.org/web/packages/quanteda/vignettes/quickstart.html


data("memorias_de_um_sargento_de_milicias")
data("memorias_postumas_bras_cubas")
data("alienista")
data("escrava_isaura")
data("ateneu")

df <- bind_rows(
  memorias_de_um_sargento_de_milicias %>% mutate(author = "Manuel Antonio de Almeira"),
  memorias_postumas_bras_cubas %>% mutate(author = "Machado de Assis"),
  alienista %>% mutate(author = "Machado de Assis"),
  ateneu %>% mutate(author = "Raul Pompeia"),
  escrava_isaura %>% mutate(author = "Bernardo Guimaraes")
)

dfm_literatura <- dfm(df$text, groups = df$book_name)
summary(dfm_literatura)

dfm_literatura_sem_sw <- dfm(df$text, groups = df$book_name, remove =  quanteda::stopwords("portuguese"))

(df_lexical <- textstat_lexdiv(dfm_literatura))

# construir corpus
df.corpus <- df %>%
  group_by(book_name) %>%
  summarise(text = paste0(text, sep = "", collapse = ". "))
meu_corpus <- corpus(df.corpus$text, docnames = df.corpus$book_name)

corpus_info <- summary(meu_corpus)
corpus_info


corpus_dfm <- dfm(meu_corpus, remove_punct = TRUE,
                  remove = quanteda::stopwords("portuguese"),
                  groups = df.corpus$book_name)
dfm_sort(corpus_dfm)[, 1:15]

dfm_select(corpus_dfm, "deus")
quanteda::kwic(meu_corpus, "paixão")

topfeatures(corpus_dfm, groups = df.corpus$book_name)

corpus_simil <- textstat_simil(dfm_weight(corpus_dfm, "relfreq"), margin = "documents", upper = TRUE, diag = FALSE)
lapply(as.list(simil), head)

corpus_dist <- textstat_simil(dfm_weight(corpus_dfm, "relfreq"), margin = "documents", upper = TRUE, diag = FALSE)
plot(hclust(corpus_dist))


## analise de sentimento
library(lexiconPT)
df.token <- df %>%
  unnest_tokens(term, text)

data("oplexicon_v3.0")
df.token <- df.token %>%
  inner_join(oplexicon_v3.0, by = "term")

df_chapter_number <- df.token %>%
  distinct(book_name, chapter_name) %>%
  group_by(book_name) %>%
  mutate(chapter_number_norm = row_number()/max(row_number()))

df.sentiment <- df.token %>%
  group_by(book_name, chapter_name) %>%
  summarise(polarity = sum(polarity, na.rm = TRUE)) %>%
  ungroup() %>%
  left_join(df_chapter_number) %>%
  arrange(book_name, chapter_number_norm)

df.sentiment %>%
  ggplot(aes(x = chapter_number_norm, y = polarity)) +
    geom_line() +
    facet_wrap(~ book_name, ncol = 5)
  #select(book_name, chapter_name, capitulo, polarity)

df.sentiment %>%
  group_by(book_name) %>%
  summarise(desvio = sd(polarity)) %>%
  mutate(book_name = fct_reorder(book_name, desvio)) %>%
  ggplot(aes(x = book_name, y = desvio)) +
    geom_col() +
    coord_flip()

# pacote qdap


# stats com pacote quanted
lexdiv <- textstat_lexdiv(corpus_dfm)
read <- textstat_readability(meu_corpus, measure = 'Flesch.Kincaid')
# keyness
key <- textstat_keyness(corpus_dfm, target = "O Alienista")
# plots
kwic(meu_corpus, "amor") %>% textplot_xray(scale = "relative")

