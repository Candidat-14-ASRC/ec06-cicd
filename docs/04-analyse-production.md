# Analyse : passage vers une production reelle

Ce projet simule des environnements de recette et de production dans GitHub, sans mettre en
place une vraie infrastructure de production. Voici ce qu'il faudrait ajouter pour transformer
cette simulation en environnement de production reel.

## 1. Gestion des secrets
Aucun secret ne doit etre stocke dans le code : un secret commite reste dans l'historique Git
meme s'il est supprime ensuite, et peut fuiter via des forks, des logs ou des outils tiers.

Dans ce projet, `GITHUB_TOKEN` illustre deja le bon principe : un jeton ephemere, scope au job,
sans intervention humaine. En production reelle, il faudrait en plus :
- Un coffre de secrets dedie (HashiCorp Vault, AWS Secrets Manager, Azure Key Vault, GitHub
  Environments secrets avec acces restreint).
- Une rotation reguliere des identifiants.
- Le principe du moindre privilege pour chaque secret (un identifiant par usage, pas un
  identifiant partage).

## 2. Rollback
La strategie de promotion par digest (et non par reconstruction) rend le rollback simple et
fiable :
- Chaque image publiee est identifiee par un digest immuable (`sha256:...`), garanti unique
  et non falsifiable.
- Revenir a une version anterieure consiste a re-promouvoir un digest deja valide anterieurement
  (executer `03-promote.yml` en lui passant l'ancien digest), sans reconstruire quoi que ce soit.
- En production reelle, cela suppose de conserver un historique des digests promus (registre,
  changelog, ou tags immuables du type `production-simulee-2026-06-30`) pour pouvoir identifier
  rapidement la derniere version stable connue.

## 3. Sauvegarde / restauration
Elements a sauvegarder pour pouvoir reconstruire l'ensemble du systeme en cas de sinistre :
- Le depot GitHub lui-meme (code source, `Dockerfile`, `compose.yml`).
- Les workflows GitHub Actions (`.github/workflows/`).
- La documentation (`docs/`).
- Les images publiees dans GHCR (ou une politique de retention claire des tags/digests
  importants).
- La configuration des environnements GitHub (variables, regles de protection).
- Les preuves d'execution (resumes de runs, captures) pour l'audit.

Un test de restauration periodique (recreer l'environnement depuis zero a partir de ces
elements) est necessaire pour verifier que la sauvegarde est reellement exploitable.

## Elements complementaires (au moins deux, choisis parmi la liste imposee)

**Gestion des acces** : en production, l'acces au depot, aux environnements GitHub et au
registre GHCR devrait suivre le principe du moindre privilege, avec des roles distincts
(lecture, contribution, administration) et une revue reguliere des acces.

**Controle des vulnerabilites** : un scan automatique de l'image (ex: Trivy, Docker Scout)
devrait etre integre au pipeline CI, avec un seuil bloquant pour les vulnerabilites critiques,
afin d'empecher la publication d'une image vulnerable.
