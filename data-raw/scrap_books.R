library(devtools)
source("data-raw/wikisource_scrapper.R")

# A escrava Isaura #
url <- "https://pt.wikisource.org/wiki/A_escrava_Isaura"
escrava_isaura <- extract_book(url, xpath_type = "A")
use_data(escrava_isaura, overwrite = TRUE)

# O Ateneu
url <- "https://pt.wikisource.org/wiki/O_Ateneu"
ateneu <- extract_book(url, xpath_type = "A")
use_data(ateneu, overwrite = TRUE)

# Memórias Póstumas de Bras Cubas
url <- "https://pt.wikisource.org/wiki/Mem%C3%B3rias_P%C3%B3stumas_de_Br%C3%A1s_Cubas"
system.time(memorias_postumas_bras_cubas <- extract_book(url, xpath_type = "B"))
use_data(memorias_postumas_bras_cubas, overwrite = TRUE)

# O Alienista
url <- "https://pt.wikisource.org/wiki/O_Alienista"
alienista <- extract_book(url, "B")
use_data(alienista, overwrite = TRUE)

# Memorias de um Sargento de Milicias
url <- "https://pt.wikisource.org/wiki/Mem%C3%B3rias_de_um_Sargento_de_Mil%C3%ADcias"
memorias_de_um_sargento_de_milicias <- extract_book(url, "B")
use_data(memorias_de_um_sargento_de_milicias, overwrite = TRUE)

