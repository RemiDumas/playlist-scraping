# Projet playlist-scraping
Scraping de playlists radio à partir des urls https://onlineradiobox.com/fr/'radio'/playlist/

## Conditions necessaires
- Un compte soundiiz https://soundiiz.com/
- Des comptes sur les plateformes de streaming musique (Apple, Spotify, Youtube, Deezer, etc ...)

## TODO
- compiler les TODO
- lister les radios accessibles manuellement
- lister les radios assessibles automatiquement
- appli shiny pour télecharger les fichiers générés et faire quelques stats
- appli shiny qui effectue un tâche CRON de récupération des playlists
- fichier global.r qui prend toutes les déclarations et charge les packages
- mise en ligne sur shinyapps.io
- corriger le bug des heures GMT au lieu de CEST
- créer un fichier csv des nouveautés

## Version

### v0.2.3
- chargement des packages dans un fichier global.r
- les fichiers exportés sont de la forme songs-'radio'_'yyyymmddhhmmss'-'n'.csv pour n'avoir que les mises à jour depuis le dernier scraping

### v0.2.2
- export de fichiers de statistiques de passages par artiste et par chanson

### v0.2.1
- tri par date et heure

### v0.2:
- créé un sous-répertoire du nom de la radio s'il n'existe pas
- lit le fichier songsbase_'radio' qui sauvegarde la liste des chansons sous la forme d'un tableau
  o artist CHR
  o title CHR
  o day CHR - yyyy-mm-dd
  o hour CHR - hh:mm
- initialise le fichier des chansons s'il n'existe pas
- supprime les doublons et le "En direct" (risque de doublons)
- supprime les jingles (en ne gardant que les morceaux passés moins de 5 fois par jour)

### v0.1:
- fonction get_playlist qui scrape à partir du nom de la radio
- export des fichiers csv songs-<radio>_n.csv qui regroupe par paquets de 199 morceaux en vue de créer les playlists avec un compte Soundiiz gratuit
- export d'un fichier texte songlist-<radio>.txt

