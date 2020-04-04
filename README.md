# Projet playlist-scraping
Scraping de playlists radio à partir des urls https://onlineradiobox.com/fr/'radio'/playlist/

Conditions necessaires:
- Un compte soundiiz https://soundiiz.com/
- Des comptes sur les plateformes de streaming musique (Apple, Spotify, Youtube, Deezer, etc ...)

TODO:
- compiler les TODO
- lister les radios accessibles manuellement
- lister les radios assessibles automatiquement
- appli shiny pour télecharger les fichiers générés et faire quelques stats

v0.2.1
- tri par date et heure

v0.2:
- créé un sous-répertoire du nom de la radio s'il n'existe pas
- lit le fichier songsbase_'radio' qui sauvegarde la liste des chansons sous la forme d'un tableau
  o artist CHR
  o title CHR
  o day CHR - yyyy-mm-dd
  o hour CHR - hh:mm
- initialise le fichier des chansons s'il n'existe pas
- supprime les doublons et le "En direct" (risque de doublons)
- supprime les jingles (en ne gardant que les morceaux passés moins de 5 fois par jour)

v0.1:
- fonction get_playlist qui scrape à partir du nom de la radio
- export des fichiers csv songs-<radio>_n.csv qui regroupe par paquets de 199 morceaux en vue de créer les playlists avec un compte Soundiiz gratuit
- export d'un fichier texte songlist-<radio>.txt

