library(tidyverse)
library(magrittr)
library(stringr)
library(abjutils)

bras <- read_lines("txt/bras_cubas.txt")

# detectar capítulos: sintaxe CAPÍTULO x
# corrigir manualmente capitulo 154
bras[which(bras == "Os navios do Pireu")-1] <- "CA"

ind_capitulo <- grepl("CAPÍ|ITULO \\d", bras)
vetor_capitulo <- if_else(ind_capitulo, bras, NA_character_)

for (i in 2:length(vetor_capitulo)){
  if (is.na(vetor_capitulo[i])) {
    vetor_capitulo[i] <- vetor_capitulo[i - 1]
  }
}
vetor_capitulo %<>% str_replace_all("[\f]", "")

# marcar paginas
bras[1] <- "\f"
ind_paginas <- grepl("[\f]", bras)
ind_paginas_num <- 1:sum(ind_paginas)
ind_paginas_posicao <- which(ind_paginas)

vetor_paginas <- rep(NA, length(bras))
vetor_paginas[ind_paginas] <- ind_paginas_num

for (i in 1:length(vetor_paginas)){
  if (is.na(vetor_paginas[i])) {
    vetor_paginas[i] <- vetor_paginas[i - 1]
  }
}

# montar dataframe formatado
df <- tibble(
  pagina = vetor_paginas,
  capitulo = vetor_capitulo,
  texto = bras
)

df$capitulo <- as.numeric(str_extract(df$capitulo, "\\d+"))
# remover linha onde texto == capitulo
df <- df[!ind_capitulo, ]
# remover linhas vazias
df <- df[df$texto != "", ]
# remover cabeçalho do livro
df <- df[-(1:5), ]
# remover acentos
df$texto %<>% rm_accent()
# salvar dados




