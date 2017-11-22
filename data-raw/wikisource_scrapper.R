rm_accent <- function(x) {
  if (.Platform$OS.type == 'unix') {
    gsub("`", "", iconv(x, to = "ASCII//TRANSLIT"))
  } else {
    gsub("`", "", iconv(x, from = 'latin1', to="ASCII//TRANSLIT"))
  }
}

library(tidyverse)
library(magrittr)
library(stringr)
library(rvest)


extract_chapter_url <- function(wikisource_book_page, xpath_chapters){
  # First function: scrape chapters urls of a given book url
  # url example: https://pt.wikisource.org/wiki/A_escrava_Isaura

  book_html <- wikisource_book_page %>% read_html()

  chapters <- book_html %>%
    html_nodes(xpath = xpath_chapters)
  # extract chapter names and urls
  chapter_names <- chapters %>% html_text()
  chapter_urls <- chapters %>% html_attr("href")

  # extract chapter names and urls from table if it exists
  chapter_table <- book_html %>%
    html_nodes(xpath = '//*[@id="mw-content-text"]/div/table[3]') %>%
    html_nodes(css = "a")

  if (length(chapter_table) > 0){
    chapter_names_table <- chapter_table %>% html_text()
    chapter_urls_table <- chapter_table %>% html_attr("href")

    chapter_names <- c(chapter_names, chapter_names_table)
    chapter_urls <- c(chapter_urls, chapter_urls_table)
  }

  chapter_urls <- paste0("https://pt.wikisource.org", chapter_urls)
  # extract name of book
  book_name <- book_html %>%
    html_nodes(xpath  = '//*[@id="firstHeading"]') %>%
    html_text()

  # return as a dataframe
  data.frame(book_name, chapter_name = chapter_names, url = chapter_urls,
             stringsAsFactors = FALSE)
}




# ex <- "https://pt.wikisource.org/wiki/O_Corti%C3%A7o" %>% read_html()
#
# "https://pt.wikisource.org/wiki/O_Corti%C3%A7o" %>%
#   read_html() %>%
#   html_nodes(xpath = '//*[@id="mw-content-text"]/div/div/div/div/div[1]/div/span/a')
#
# "https://pt.wikisource.org/wiki/A_escrava_Isaura" %>%
#   read_html() %>%
#   html_nodes(xpath = '//*[@id="mw-content-text"]/div/ul/li')


#chp_ex <- "https://pt.wikisource.org/wiki/O_Corti%C3%A7o/I"

#extract_chapter_text(chp_ex, "B")

extract_chapter_text <- function(wikisource_chapter_page, xpath_type){

  if (xpath_type == 'A'){
    xpath_main <- '//*[@id="mw-content-text"]/div/p'
    xpath_b <- '//*[@id="mw-content-text"]/div/div/p'
  } else if(xpath_type == "B"){
    xpath_main <- '//*[@id="mw-content-text"]/div/div/p'
    xpath_b <- '//*[@id="mw-content-text"]/div/div/p'
  } else {
    stop("Choose A or B for xpath_type")
  }

  #xpath_b <- '//*[@id="mw-content-text"]/div/div/p'
  #xpath_c <- '//*[@id="mw-content-text"]/div/div'
  #xpath_main <- '//*[@id="mw-content-text"]/div/p'

  chp <- wikisource_chapter_page %>%
    read_html() %>%
    # xpath to extract chapter text
    html_nodes(xpath = xpath_main)# %>% html_text()# %>% str_split("[\n]") %>% unlist()

  if (length(chp) == 0){
    chp <- wikisource_chapter_page %>%
      read_html() %>%
      html_nodes(xpath = xpath_b) %>%
      html_text()
    # remove header
    chp <- chp[-1]
    # if object is still empty, use another xpath
    # if (length(chp) == 0){
    #   chp <- wikisource_chapter_page %>%
    #     read_html() %>%
    #     html_nodes(xpath = xpath_c) %>%
    #     html_text()
    # }
  } else{
    chp <- chp %>%
      html_text()
  }



  # remove empty lines
  chp <- chp[chp != ""]
  paragraph_number <- seq_along(chp)

  if (length(chp) == 0){
    paragraph_number <- NA_integer_
    chp <- NA_character_
  }

  data.frame(url = wikisource_chapter_page, paragraph_number, text = chp,
             stringsAsFactors = FALSE)
}

### function to extract text of a whole book
extract_book <- function(wikisource_book_page,
                         xpath_type,
                         xpath_chapters = '//*[@id="mw-content-text"]/div/ul/li/a'){
  df_chapters_urls <- extract_chapter_url(wikisource_book_page, xpath_chapters)
  # check if dataframe
  if(!inherits(df_chapters_urls, "data.frame")) {
    stop("Output of extract_url_chapters() not a dataframe")
  }
  df_chapters_text <- df_chapters_urls$url %>%
    map_df(extract_chapter_text, xpath_type  = xpath_type)

  df <- left_join(df_chapters_urls, df_chapters_text, by = "url")
  return(df)
}
