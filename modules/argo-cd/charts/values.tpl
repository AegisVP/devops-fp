argocd-apps:
  applications:
    django-app:
      namespace: argocd
      project: default
      source:
        repoURL: '${github_repo}'
        path: charts/django-app
        targetRevision: 'cd'
        helm:
          valueFiles:
            - values.yaml
          values: |
            config:
              POSTGRES_HOST: "${db_host}"
              POSTGRES_DB: "${db_name}"
              POSTGRES_USER: "${db_user}"
              POSTGRES_PASSWORD: "${db_pass}"
      destination:
        server: https://kubernetes.default.svc
        namespace: django
      syncPolicy:
        syncOptions:
          - CreateNamespace=true
        automated:
          prune: true
          selfHeal: true

  repositories:
    django-app:
      url: '${github_repo}'

  repoConfig:
    insecure: 'true'
    enableLfs: 'true'
