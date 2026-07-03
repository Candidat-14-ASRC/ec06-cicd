# Fiche securite minimale

## Gestion des secrets
- Aucun secret (mot de passe, token, cle) n'est stocke en dur dans le code source ni dans les
  fichiers de workflow.
- L'authentification aupres de GHCR utilise `secrets.GITHUB_TOKEN`, genere automatiquement par
  GitHub Actions pour la duree du job et revoque a la fin de l'execution. Il n'est jamais visible
  ni copiable par un humain.
- Les workflows declarent des permissions minimales (`permissions: contents: read, packages:
  write`) plutot que d'utiliser les droits par defaut, pour limiter la portee du token en cas de
  compromission d'une action tierce.
- Si un secret specifique au projet etait necessaire (cle API externe, identifiants), il serait
  stocke dans **GitHub Secrets** (Settings > Secrets and variables > Actions) et injecte via
  `${{ secrets.NOM_DU_SECRET }}`, jamais commite.

## Controle des vulnerabilites (piste d'amelioration)
- L'image de base `nginx:1.27-alpine` est choisie pour reduire la surface d'attaque (peu de
  paquets installes).
- Amelioration possible : ajouter un scan d'image (ex: `docker/scout-action` ou `aquasecurity/
  trivy-action`) comme etape supplementaire du workflow `01-ci.yml`.

## Journalisation et preuves
- Chaque execution GitHub Actions conserve les logs des etapes (build, test, publication,
  promotion), consultables dans l'onglet Actions du depot.
- Les resumes (`GITHUB_STEP_SUMMARY`) enregistrent explicitement le tag et le digest publies,
  ainsi que la preuve de promotion sans rebuild.

## Gestion des acces
- Le depot GitHub est individuel : un seul proprietaire.
- Les environnements `recette` et `production-simulee` peuvent recevoir des regles de
  protection (reviewer obligatoire) dans Settings > Environments, ce qui simule un controle
  d'acces avant deploiement.

## Etat au rendu
- Aucun scan de vulnerabilites automatise n'a ete ajoute (piste d'amelioration identifiee
  ci-dessus, non implementee dans la version rendue).
- Les regles de protection des environnements suivent la configuration par defaut de GitHub
  (creation automatique de `recette` et `production-simulee` au premier usage par les
  workflows) ; l'ajout de reviewers obligatoires reste une amelioration possible non activee.
