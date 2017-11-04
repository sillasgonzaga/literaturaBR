library(tidyverse)
library(magrittr)
library(stringr)
library(abjutils)

ateneu <- read_lines("txt/o_ateneu.txt")

df <- as.data.frame(ateneu, stringsAsFactors = FALSE)

# o ateneu possui 12 capitulos, indicados por numeros romanos
capitulos <- as.character(as.roman(1:12))
ind_capitulos <- which(ateneu %in% capitulos)
vetor_capitulo <- if_else(ateneu %in% capitulos, ateneu, NA_character_)
vetor_capitulo[1] <- "I"
# repor elementos sem capitulo pela pagina anterior
for (i in seq_along(vetor_capitulo)){
  if (is.na(vetor_capitulo[i])) {
    vetor_capitulo[i] <- vetor_capitulo[i - 1]
  }
}


# extrair vetor de paginas (93 paginas)
ateneu[1] <- "\f1"

ind_paginas <- which(grepl("[\f]" ,ateneu))
vetor_pagina <- if_else(grepl("[\f]" ,ateneu), ateneu, NA_character_)
if_else(is.na(vetor_pagina), lag(vetor_pagina), vetor_pagina)

# repor elementos sem pagina pela pagina anterior
for (i in seq_along(vetor_pagina)){
  if (is.na(vetor_pagina[i])) {
    vetor_pagina[i] <- vetor_pagina[i - 1]
  }
}
vetor_pagina %<>% str_replace_all("[\f]", "")

# montar dataframe
df <- tibble(
  pagina = vetor_pagina,
  capitulo = vetor_capitulo,
  texto = ateneu
)
# filtrar fora começos de págino e capítulo
df <- df[-c(ind_paginas, ind_capitulos), ]
# remover primeiras linhas (cabeçalho)
df <- df[-(1:7), ]
# remover linhas vazias
df <- df[df$texto != "", ]
# remover acentos
df$texto %<>% rm_accent()
# salvar dataframe
write_rds(df, "raw-data/o_ateneu.Rds")
