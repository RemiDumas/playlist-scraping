library(dplyr)
library(ggplot2)
library(purrr)
library(rvest)
library(stringr)
library(xml2)

#### Déclaration de variables globales ####
list_pages <- c("","1","2","3","4","5","6")

#### fonction get_playlist ####
## TODO: séparer la partie EXPORT de la partie STATS ##
get_playlist <- function(radio = "cherie") {
  ## TODO Faire un test et renvoyer une erreur si le nom de la radio n'est pas bon ##
  url <- paste0("https://onlineradiobox.com/fr/", radio, "/playlist/")
  
  songs <- tibble(artist = "", title = "")
  
  for (i in list_pages) {
    i <- "1"
    page <- read_html(paste0(url,
                             i)) %>%
      html_nodes(".playlist td a")
    loc <- page %>% as.character %>% str_locate("ajax")
    foo <-
      tibble(songs = page %>% as.character %>% str_sub(loc[, 2] + 3, str_length(.) -
                                                         4))
    foo <- foo %>% separate(songs, c("artist", "title"), sep = " - ")
    songs <- bind_rows(songs, foo)
  }
  
  
  songs <- songs[-1,] %>% mutate(
    artist = map_chr(.$artist, ~ str_to_title(.x)),
    title = map_chr(.$title, ~ str_to_title(.x))
  )
  
  song_count <- songs %>% count(title, artist) %>% arrange(desc(n))
  
  artist_count <- song_count %>% group_by(artist) %>%
    summarise(Passages = sum(n)) %>%
    arrange(desc(Passages))
  
  songs <- songs %>% distinct(artist, title)
  
  ntabs <- nrow(songs) %/% 199 + 1
  
  for (i in 1:ntabs) {
    if (i != ntabs) {
      assign(paste0("songs", i), songs[seq(1 + 199 * (i - 1), 199 * i), 1:2])
    } else {
      assign(paste0("songs", i), songs[seq(1 + 199 * (i - 1), nrow(songs)), 1:2])
    }
    
    write.csv2(get(paste0("songs", i)),
               paste0("playlists/songs-", radio, "_", i, ".csv"),
               row.names = F)
  }
  
  song_list <- paste0(song_count$artist, " - ", song_count$title)
  
  write.table(
    song_list,
    paste0("playlists/song_list-", radio, ".txt"),
    row.names = F,
    col.names = F,
    quote = F
  )
}

#### Appel de la fonction ####
## TODO: récupérer la liste des radios ##
get_playlist(radio = "cherie") #récuperer le nom sur le site, par exemple ouifmroinde, nrjfrance, capferret etc. 
get_playlist(radio = "capferret") #warning qui vient du str_detect surement ou du separate
get_playlist(radio ="ouifmroinde")
