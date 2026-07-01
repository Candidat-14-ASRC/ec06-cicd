# Cadrage du projet

## Contexte
Catal-Log souhaite industrialiser la publication d'un petit site web statique afin d'eviter les
operations manuelles repetitives, fiabiliser les livraisons et conserver des preuves d'execution.

## Mission
Construire, tester, publier et promouvoir une image Docker Nginx contenant un site web statique
simple, via GitHub Actions et GitHub Container Registry (GHCR), avec simulation des environnements
recette et production dans GitHub.

## Perimetre couvert
- Versionnement dans un depot GitHub individuel.
- Controle automatique du projet (workflow `01-ci.yml`).
- Construction d'une image Docker a partir d'un `Dockerfile`.
- Test automatise du conteneur dans GitHub Actions.
- Publication de l'image dans GHCR, identifiee par un tag et un digest.
- Validation en recette simulee (environnement GitHub `recette`).
- Promotion manuelle vers une production simulee, sans rebuild (environnement GitHub `production-simulee`).
- Orchestration legere documentee via `compose.yml`.
- Documentation des choix, limites et preuves.

## Environnement technique
| Composant | Role |
|---|---|
| GitHub | Depot individuel, historique de commits, documentation, preuves |
| GitHub Actions | Controles, build Docker, tests, publication GHCR, promotion simulee |
| GitHub-hosted runners | Environnements temporaires d'execution |
| Dockerfile | Construction reproductible de l'image Nginx |
| GHCR | Publication de l'image, conservation des tags/digests |
| compose.yml | Orchestration legere, simulation de scaling |
| Environnements GitHub | `recette` et `production-simulee` |

## A completer par l'etudiant
- [ ] Nom exact du depot GitHub et lien.
- [ ] Date de debut / fin des 5 jours du module.
- [ ] Toute contrainte personnelle (VM disponible ou non, etc.) a documenter ici.
