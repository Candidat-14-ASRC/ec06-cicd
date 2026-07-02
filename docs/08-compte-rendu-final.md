## Ce que j'ai mis en place

J'ai mis en place une chaîne CI/CD complète pour publier un site statique via Docker et Nginx. Le pipeline est découpé en trois workflows GitHub Actions : un pour l'intégration continue (build et test), un pour la publication de l'image sur GHCR, et un pour la promotion manuelle vers un environnement de production simulé. L'image est construite une seule fois puis promue par digest, sans rebuild.

## Choix techniques et pourquoi

J'ai utilisé nginx:alpine comme image de base car elle est légère et rapide à télécharger. J'ai séparé le pipeline en trois workflows distincts (CI, publish, promote) pour bien isoler les responsabilités et garder chaque fichier lisible. Cela permet aussi de déclencher la promotion manuellement, sans relancer un build inutile. La promotion se fait par digest et non par tag, car un tag peut être réécrit alors qu'un digest identifie une image de façon unique et garantit qu'on déploie exactement l'artefact testé et validé en recette.

## Limites de mon approche

Docker Compose reste une orchestration légère : il ne gère pas le vrai load balancing, ni la haute disponibilité, ni le redémarrage automatique en cas de panne d'un nœud, contrairement à Kubernetes. Je n'ai pas mis en place de scan de vulnérabilités automatisé sur l'image. Il n'y a pas de vraie infrastructure de production, tout est simulé avec des environnements GitHub. La supervision et la journalisation ne sont pas mises en place non plus.

## Difficultés rencontrées et comment je les ai résolues

J'ai rencontré un problème avec GHCR car le nom du dépôt et de l'image doivent être en minuscules. Mon nom d'utilisateur ou de dépôt contenait des majuscules, ce qui faisait échouer le push de l'image avec une erreur. J'ai résolu ce problème en forçant le nom de l'image en minuscules dans le workflow, en utilisant une conversion avant de construire et pousser l'image vers GHCR.

## Ce que je changerais pour une vraie mise en production

Je mettrais en place une vraie gestion des secrets avec un coffre-fort dédié plutôt que de tout garder dans GitHub Secrets. Je prévoirais une stratégie de rollback claire en gardant un historique des digests validés pour pouvoir revenir en arrière rapidement. Je mettrais en place une vraie sauvegarde du dépôt, des workflows et des images publiées. J'ajouterais aussi un contrôle des vulnérabilités sur les images, une supervision, une journalisation centralisée, et une séparation stricte entre les environnements de recette et de production, avec une validation manuelle obligatoire avant tout déploiement en production.

## Preuves
Voir `docs/03-preuves.md` pour les liens et captures.
