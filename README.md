# Projet CICD EC06 - Catal-Log

Pipeline CI/CD : build, test, publication GHCR et promotion manuelle d'une image Docker Nginx
servant un site statique. Voir `docs/00-cadrage.md` pour le detail du sujet.

## Structure

```
site/                          Site statique (index.html, version.json)
Dockerfile                     Image Nginx
compose.yml + compose/         Orchestration legere (2 services)
.github/workflows/01-ci.yml            Build + test automatise
.github/workflows/02-publish-ghcr.yml  Publication GHCR + validation recette
.github/workflows/03-promote.yml       Promotion manuelle vers production-simulee
docs/                           Documentation, securite, preuves, compte rendu
```

## Mise en route : creer le depot GitHub et pousser le code

1. Cree un nouveau depot **prive ou public, individuel** sur github.com (Settings comptes >
   New repository). Ne coche aucune option d'initialisation (pas de README auto).

2. Depuis ce dossier, en local :
   ```bash
   cd cicd-catal-log
   git init
   git add .
   git commit -m "Init projet CICD EC06"
   git branch -M main
   git remote add origin https://github.com/<TON_USERNAME>/<NOM_DU_REPO>.git
   git push -u origin main
   ```

3. Verifie que le workflow `01-ci.yml` s'est declenche automatiquement dans l'onglet **Actions**
   du depot, et qu'il passe au vert.

## Configurer les environnements GitHub (recette / production-simulee)

1. Dans le depot GitHub : **Settings > Environments > New environment**.
2. Cree un environnement nomme exactement `recette`.
3. Cree un second environnement nomme exactement `production-simulee`.
4. Optionnel (recommande pour la note) : sur `production-simulee`, active **Required
   reviewers** et ajoute-toi comme reviewer, pour que la promotion demande une validation
   manuelle explicite avant de s'executer.

## Activer les permissions GHCR

Par defaut GitHub Actions peut publier dans GHCR avec `GITHUB_TOKEN`. Si le push echoue avec une
erreur de permission :
1. **Settings > Actions > General > Workflow permissions**, choisir "Read and write
   permissions".
2. Verifier que le package cree dans **Packages** (visible depuis la page du profil ou du
   depot) est bien lie a ce depot et, si besoin, le rendre visible.

## Deroulement normal du pipeline

1. Un push sur `main` declenche `01-ci.yml` (build + test) et `02-publish-ghcr.yml`
   (publication + validation recette). Le digest de l'image publiee apparait dans le resume du
   job `build-and-publish`.
2. Copier ce digest, puis aller dans **Actions > 03 - Promote to production-simulee > Run
   workflow**, coller le digest, lancer. Cela promeut le meme artefact vers
   `production-simulee` sans reconstruction.
3. Remplir `docs/03-preuves.md` avec les liens vers ces executions.
4. Completer `docs/08-compte-rendu-final.md` avec ton explication personnelle.

## Test en local (optionnel mais recommande)

```bash
docker build -t catal-log-site:local .
docker run -d -p 8080:80 catal-log-site:local
curl http://localhost:8080/
```

Ou avec Compose (site + reverse proxy) :
```bash
docker compose up --build
# site direct :        http://localhost:8080
# via le reverse proxy: http://localhost:8081
```

## Important avant le rendu

Le sujet exige un **travail individuel et compris** : avant de rendre, relis chaque workflow et
chaque fichier de doc, et assure-toi de pouvoir expliquer a l'oral pourquoi chaque etape existe
(build, test, tag/digest, environnements GitHub, promotion sans rebuild). Adapte les commentaires
et la documentation avec tes propres mots si besoin.
