# Architecture et orchestration

## Schema (vue d'ensemble)

```
 Dev (push main)
      |
      v
+----------------+     +------------------------+     +---------------------+
| 01-ci.yml      | --> | 02-publish-ghcr.yml     | --> | 03-promote.yml       |
| build + test   |     | build + push GHCR       |     | workflow_dispatch    |
| (job unique)   |     | + validate (recette)    |     | pull par digest      |
+----------------+     +------------------------+     | retag prod-simulee   |
                                                        | test de fumee        |
                                                        +---------------------+
                                                                 |
                                                                 v
                                                        GHCR: ghcr.io/<owner>/<repo>
                                                        tags: sha-xxxxxxx, latest,
                                                              production-simulee
```

## Environnements GitHub
- `recette` : associe au job `validate-recette` de `02-publish-ghcr.yml`. Peut recevoir une
  regle de protection (ex: reviewer obligatoire) dans Settings > Environments.
- `production-simulee` : associe au job `promote` de `03-promote.yml`. A configurer avec une
  regle d'approbation manuelle pour materialiser la "promotion manuelle".

## Orchestration legere (Docker Compose)
`compose.yml` decrit deux services :
- `web` : le site Catal-Log (image construite depuis le `Dockerfile`).
- `edge` : un reverse proxy Nginx minimal, pour illustrer la coordination de plusieurs
  conteneurs (competence C13).

Docker Compose joue ici un role d'orchestration **legere**, limitee a un seul hote. Il ne
remplace pas un orchestrateur de production comme Kubernetes.

## Simulation de mise a l'echelle
Commande documentee (a executer sur un poste avec Docker installe) :

```
docker compose up --scale web=2
```

Compose cree deux instances du service `web` et les enregistre dans son DNS interne sous le
meme nom `web`. Le service `edge` (proxy_pass http://web:80) va donc voir ses requetes
distribuees en round-robin entre les deux replicas par la resolution DNS de Compose.

### Limites de cette simulation
- Pas de health-check actif cote `edge` : si un replica `web` tombe, `edge` continue de lui
  envoyer du trafic tant que Compose ne l'a pas retire du DNS.
- Pas de repartition de charge intelligente (round-robin DNS seulement, pas de ponderation,
  pas de sticky session, pas de circuit breaker).
- Un seul hote physique : aucune tolerance a la panne d'une machine.
- Pas de auto-scaling pilote par metriques (CPU, latence, nombre de requetes).
- Pas de gestion declarative de l'etat desire (contrairement aux Deployments Kubernetes).

### Lien avec la robustesse de la chaine CI/CD
Meme sans orchestrateur de production, la chaine CI/CD garantit :
- **Reproductibilite** : l'image est construite une seule fois a partir d'un `Dockerfile`
  versionne.
- **Promotion d'un artefact identifie** : le meme digest d'image passe de la recette a la
  production simulee sans reconstruction, ce qui elimine le risque de divergence entre ce qui a
  ete teste et ce qui est deploye.
- **Tracabilite** : chaque etape (build, test, publication, validation, promotion) est
  enregistree dans l'historique GitHub Actions et associee a un tag/digest precis.

## Comparaison rapide avec Kubernetes (bonus)
| Aspect | Docker Compose (ce projet) | Kubernetes (production reelle) |
|---|---|---|
| Perimetre | Un seul hote | Cluster multi-noeuds |
| Auto-healing | Non (restart policy locale uniquement) | Oui (reprogrammation des pods) |
| Scaling | Manuel, un seul hote | Horizontal Pod Autoscaler, multi-noeuds |
| Load balancing | Round-robin DNS basique | Service + kube-proxy, Ingress |
| Declaratif / etat desire | Partiel | Complet (reconciliation continue) |
