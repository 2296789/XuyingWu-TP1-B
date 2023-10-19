--1. Une requête pour trouver le nombre de films qui ont été produits par un producteur dont vous connaissez l’identifiant (ID) entre les années 1990 et 2000. 
SELECT p.id AS id_realisateur, COUNT(f.id) AS nb_film
FROM producteur p
JOIN film f ON f.id_producteur = p.id
WHERE p.id = 2 AND annee_production BETWEEN 1990 AND 2000
/*commentaire: En 1, tu appelles ta colonne idRealisateur alors que c’est… un producteur. La jointure n’était pas nécessaire.*/

--2. Une requête pour trouver tous les producteurs qui ont produit un film de science-fiction en couleur, sans répétition. 
SELECT CONCAT(p.prenom, " ", p.nom) AS nom_producteur, COUNT(*) AS nb_film
FROM film f
JOIN producteur p ON f.id_producteur = p.id
JOIN genre_film g ON f.id_genre_film = g.id
WHERE couleur = 1 AND g.nom = "Science-Fiction"
GROUP BY nom_producteur
/*commentaire:En 2, tu devrais grouper par ID de producteur ou tout simplement utiliser DISTINCT.*/

--3. Une requête pour trouver le titre de tous les films qui n’ont pas été réalisés entre 2000 et 2010 dans lesquels joue un acteur dont vous connaissez le prénom et le nom de famille. Vous devez aussi afficher le nom du ou des rôle(s) qu’il y jouait. 
SELECT CONCAT(a.prenom, " ", a.nom) AS acteur, f.nom AS film, r.nom AS role, annee_production
FROM acteur a 
JOIN role r ON r.id_acteur = a.id
JOIN film f ON f.id = r.id_film
WHERE a.prenom = "Charles" AND a.nom = "Chaplin" AND annee_production < "2000" OR annee_production > "2010"

--4. Une requête pour trouver tous les textes et les notes des critiques rédigées en 2022 d’un film dont vous connaissez le titre. 
SELECT f.nom AS film, c.contenu AS critique, c.note_etoiles
FROM film f 
JOIN critique c ON c.id_film = f.id
WHERE date_redige BETWEEN "2022-01-01" AND "2022-12-31" AND f.nom = "Titanic"

--5. Une requête pour affichez le titre de tous les films et les textes de toutes les critiques de chacun des films accompagnés du nom de l’usager qui a rédigé la critique et du nom du réalisateur du film. Il faut aussi afficher les films pour lesquels il n’y a aucune critique de rédigée. 
SELECT f.nom AS film, CONCAT(r.prenom, " ", r.nom) AS realisateur, contenu AS critique, CONCAT(u.prenom, " ", u.nom) AS usager
FROM film f 
LEFT JOIN realisateur r ON r.id = f.id_realisateur
LEFT JOIN critique c ON c.id_film = f.id 
LEFT JOIN usager u ON u.id = c.id_usager

--6. Une requête qui affiche le nombre de critiques rédigées par chaque usager qui a rédigé plus de 2 critiques. Le résultat sera le prénom et le nom de l’usager, son courriel, suivi du nombre de critiques qu’il a rédigées. Le résultat sera ordonné par nombre de critiques descendant.
SELECT u.prenom, u.nom, courriel, COUNT(*) AS nb_critique
FROM usager u 
JOIN critique c  ON c.id_usager = u.id
GROUP BY u.id
HAVING nb_critique > 2
ORDER BY nb_critique DESC

--7. Une requête pour trouver la note maximale que chacun des films a reçu, accompagné du titre et de l’année de ces films, ainsi que du nom du producteur du film et le nom du genre du film. Les films qui n’ont pas reçu de notes doivent être inclus dans votre requête. Le résultat sera ordonné par note maximale descendante.
SELECT MAX(note_etoiles), f.nom AS film, annee_production, CONCAT(p.prenom, " ", p.nom) AS producteur, g.nom AS genre_film
FROM critique c 
RIGHT JOIN film f ON c.id_film = f.id
JOIN producteur p ON f.id_producteur = p.id
JOIN genre_film g ON f.id_genre_film = g.id
GROUP BY f.id
ORDER BY MAX(note_etoiles) DESC

--8. Une requête pour trouver le titre de chacun des films vus sur la plateforme Crave ou Netflix ainsi que le nombre de notes qu’il a reçues. Seulement les critiques du film mentionnant qu’il a été vu sur Crave ou Netflix seront comptées. 
SELECT f.nom AS film, COUNT(*) AS nb_critique
FROM film f
JOIN critique c ON c.id_film = f.id
JOIN plateforme p ON c.id_plateforme = p.id
WHERE p.nom = 'Netflix' OR p.nom = 'Crave' 
GROUP BY f.nom
/*commentaire:En 8, il faut grouper par ID de film.*/

--9. Une requête pour trouver le titre et la moyenne des notes de tous les films de science-fiction qui ont été critiqués au moins 2 fois en 2020, ordonnée par ordre descendant de moyenne. 
SELECT f.nom AS film, round(AVG(note_etoiles),1) AS moyen_note_etoiles
FROM film f 
JOIN critique c ON c.id_film = f.id
JOIN genre_film g ON f.id_genre_film = g.id
WHERE g.nom = "Science-Fiction" AND date_redige BETWEEN "2020-01-01" AND "2020-12-31"
GROUP BY f.id
HAVING COUNT(*) >= 2  
ORDER BY moyen_note_etoiles DESC

--10. Une requête pour trouver les usagers qui ont accordé dans leurs critiques une moyenne de notes plus grande que 4 aux films réalisés par Steven Spielberg, mais qui ont critiqué au moins deux fois des films réalisés par Steven Spielberg. Le résultat sera, pour chaque rangée, le nom de l’usager, la moyenne des notes qu’il a accordées aux films réalisés par Steven Spielberg, ainsi que le nombre de films réalisés par Steven Spielberg qui ont été critiquées par cet usager.
SELECT CONCAT(u.prenom, " ", u.nom) AS usager, round(AVG(note_etoiles),1) AS moyen_note_etoiles, COUNT(c.id_film) AS nb_critique
FROM film f 
JOIN critique c ON c.id_film = f.id
JOIN realisateur r ON r.id = f.id_realisateur
JOIN usager u ON u.id = c.id_usager
WHERE r.nom = "Spielberg" AND r.prenom = "Steven"
GROUP BY u.id
HAVING AVG(note_etoiles) > 4 AND nb_critique >= 2 
