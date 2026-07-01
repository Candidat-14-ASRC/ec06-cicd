# Preuves

A completer une fois le depot pousse sur GitHub et les workflows executes au moins une fois
chacun. Remplacer chaque `<...>` par le lien ou l'information reelle.

- Depot GitHub individuel : `<lien vers le depot>`
- Run reussi de `01-ci.yml` : `<lien vers l'execution>`
- Run reussi de `02-publish-ghcr.yml` (publication + validation recette) : `<lien>`
- Run reussi de `03-promote.yml` (promotion production simulee) : `<lien>`
- Image publiee dans GHCR : `<lien vers le package GHCR>`
- Tag utilise : `<ex: sha-abc1234>`
- Digest de l'image : `<ex: sha256:...>`
- Preuve de test HTTP automatise reussi : voir logs de l'etape "Test HTTP automatise" dans
  `01-ci.yml`.
- Preuve de validation recette simulee : voir logs de l'etape "Test de validation recette" dans
  `02-publish-ghcr.yml` (job `validate-recette`).
- Preuve de promotion sans rebuild : voir le resume `GITHUB_STEP_SUMMARY` du job `promote` dans
  `03-promote.yml`, qui affiche le digest promu et confirme l'absence de reconstruction.
- Test local avec Docker/Docker Compose : `<preuve ou justification si non realisable>`
- Utilisation ou non d'une VM personnelle : `<preuve ou justification>`

## Comment obtenir le digest a passer a 03-promote.yml
1. Lancer (ou attendre) une execution de `02-publish-ghcr.yml`.
2. Ouvrir le resume du job `build-and-publish` (`GITHUB_STEP_SUMMARY`) : le digest y est affiche.
3. Aller dans Actions > `03 - Promote to production-simulee` > "Run workflow", coller le digest
   dans le champ `digest`, puis lancer.
