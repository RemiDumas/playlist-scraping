source("global.r")

#### fonction get_playlist ####
## TODO: séparer la partie EXPORT de la partie STATS ##
get_playlist <- function(radio = "cherie") {
  ## TODO Faire un test et renvoyer une erreur si le nom de la radio n'est pas bon ##
  url <- paste0("https://onlineradiobox.com/fr/", radio, "/playlist/")
  # creation des répertoires
  if(!dir.exists(paste0("playlists/",radio))) {
    dir.create(paste0("playlists/",radio))
  }
  chemin <- paste0("playlists/",radio)
  
  if (file.exists(paste0(chemin, "/songsbase-", radio, ".csv"))) {
    songsbase <- read.csv2(paste0(chemin, "/songsbase-", radio, ".csv"), stringsAsFactors = F)
  } else {
    songsbase <- tibble(
      artist = "",
      title = "",
      day = "1990-01-01",
      hour = "12:00"
    )
  }
  
  for (i in c("","1","2","3","4","5","6")) {
    # lecture de la page
    foo <- read_html(paste0(url, i)) %>% #TODO résoudre le bug de l'heure -2 .. surement l'entête qui croit que je suis pas en France
      html_node(".tablelist-schedule") %>% 
      html_table() %>%
      separate(X2, c("artist", "title"), sep = " - ", fill = "left") %>%
      mutate(
        artist = map_chr(.$artist, ~ str_to_title(.x)), 
        title = map_chr(.$title, ~ str_to_title(.x)),
        day = format(now(), format = '%Y-%m-%d') %>% as.Date() - ifelse(i == "", 0, as.numeric(i))
        ) %>% 
      select(artist, title, day , hour = X1) %>% 
      filter(complete.cases(.))  
    foo$day <- foo$day %>% as.character()
    agarder <- foo %>% count(artist) %>% filter(n < 5) %>% pull(artist)
    
    foo <- foo %>% filter(artist %in% agarder)
    
   #extraction des informations
    songsbase <- bind_rows(songsbase, foo)
    rm(foo, agarder)
  }
  
  songsbase <- songsbase %>% 
    filter(artist !="" & title != "" & hour != "En direct") %>% 
    distinct(artist, title, day, hour) %>% 
    arrange(desc(day), desc(hour))

  song_count <- songsbase %>% group_by(title, artist) %>%
    summarise(Passages = n()) %>%
    arrange(desc(Passages))
  
  artist_count <- song_count %>% group_by(artist) %>%
    summarise(Passages = sum(Passages)) %>%
    arrange(desc(Passages))
  
  #write.xlsx2(song_count, file = paste0(chemin,"/stats_",format(now(), format = '%Y-%m-%d'),".xlsx"), sheetName = "song_stats", apprend = F)
  #write.xlsx2(artist_count, file = paste0(chemin,"/stats_",format(now(), format = '%Y-%m-%d'),".xlsx"), sheetName = "artist_stats", apprend = T)
  
  write.csv2(songsbase, 
             paste0(chemin, "/songsbase-", radio, ".csv"),
             row.names = F)
  
  songs <- songsbase %>% distinct(artist, title)
  
  ntabs <- nrow(songs) %/% 199 + 1
  
  for (i in 1:ntabs) {
    if (i != ntabs) {
      assign(paste0("songs", i), songs[seq(1 + 199 * (i - 1), 199 * i), 1:2])
    } else {
      assign(paste0("songs", i), songs[seq(1 + 199 * (i - 1), nrow(songs)), 1:2])
    }
    
    write.csv2(get(paste0("songs", i)),
               paste0(chemin,"/songs-", radio, "_", i, ".csv"),
               row.names = F)
  }
  
  song_list <- paste0(song_count$artist, " - ", song_count$title)
  
  write.table(
    song_list,
    paste0(chemin,"/song_list-", radio, ".txt"),
    row.names = F,
    col.names = F,
    quote = F
  )
}

#### Appel de la fonction ####
## TODO: récupérer la liste des radios ##
get_playlist(radio = "cherie") #récuperer le nom sur le site, par exemple ouifmroinde, nrjfrance, capferret etc. 
get_playlist(radio = "capferret") #warning qui vient du str_detect surement ou du separate
get_playlist(radio = "ouifmroinde")

