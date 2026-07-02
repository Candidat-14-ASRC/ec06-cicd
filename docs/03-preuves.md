# Preuves

- Depot GitHub individuel : https://github.com/Candidat-14-ASRC/ec06-cicd
- Run reussi de `01-ci.yml` : commit `3ef439b` ("Init projet CICD EC06"), run #1, succes en 11s.
  Lien : https://github.com/Candidat-14-ASRC/ec06-cicd/actions/runs/28496706813
  (le run #2, sur le commit `a0a9e63` du fix GHCR, a egalement reussi en 14s : `01-ci.yml`
  n'etait pas concerne par le bug de casse, qui ne touchait que la publication GHCR).
- Run reussi de `02-publish-ghcr.yml` (publication + validation recette) : commit `a0a9e63`,
  run #2, succes en 29s.
  Lien : https://github.com/Candidat-14-ASRC/ec06-cicd/actions/runs/28498946127
  (le run #1 sur le commit `3ef439b` avait echoue : `invalid tag
  "ghcr.io/Candidat-14-ASRC/ec06-cicd:sha-3ef439b": repository name must be lowercase` -
  corrige en ajoutant une etape qui met le nom d'image en minuscules).
- Run reussi de `03-promote.yml` (promotion production simulee) : run #1, declenche
  manuellement par Candidat-14-ASRC, succes en 19s.
  Lien : https://github.com/Candidat-14-ASRC/ec06-cicd/actions/runs/28499122664
- Image publiee dans GHCR : https://github.com/Candidat-14-ASRC/ec06-cicd/pkgs/container/ec06-cicd
- Tag utilise : `sha-a0a9e63`
- Digest de l'image : `sha256:851bb3d807ea419b00a0f895a8517b68ea8fa3ae6215f9fb0e881fdb65c02499`
- Tag de promotion : `production-simulee` (meme digest que ci-dessus, republie sans rebuild)
- Preuve de test HTTP automatise reussi : voir logs de l'etape "Test HTTP automatise" dans le
  run #1 de `01-ci.yml`.
- Preuve de validation recette simulee : voir logs de l'etape "Test de validation recette" dans
  le job `validate-recette` du run #2 de `02-publish-ghcr.yml`.
- Preuve de promotion sans rebuild : resume du job `promote` du run #1 de `03-promote.yml`,
  qui affiche "Digest promu : sha256:851bb3d807ea419b00a0f895a8517b68ea8fa3ae6215f9fb0e881fdb65c02499",
  "Nouveau tag : production-simulee" et "Aucune reconstruction de l'image (meme digest source)".
- Test local avec Docker/Docker Compose : effectue en local (`docker build` + `docker run` +
  `curl`), reponse HTML et `version.json` conformes.
- Utilisation ou non d'une VM personnelle : pas de VM personnelle dediee. Le test local a ete
  fait directement sur le poste de travail via Docker Desktop (moteur `docker:desktop-linux`,
  visible dans les logs de build). C'est suffisant pour ce projet : Docker Desktop fournit deja
  un environnement Linux isole (via WSL2/Hyper-V) pour executer les conteneurs, ce qui repond au
  besoin de test local sans avoir a gerer une VM separee.

## Comment obtenir le digest a passer a 03-promote.yml
1. Lancer (ou attendre) une execution de `02-publish-ghcr.yml`.
2. Ouvrir le resume du job `build-and-publish` (`GITHUB_STEP_SUMMARY`) : le digest y est affiche.
3. Aller dans Actions > `03 - Promote to production-simulee` > "Run workflow", coller le digest
   dans le champ `digest`, puis lancer.
