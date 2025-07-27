controller:
  admin:
    username: admin
    password: admin123

  serviceType: LoadBalancer
  servicePort: 80
  service:
    port: 80
    targetPort: 8080

  serviceAccount:
    name: jenkins-sa
    create: false

  resources:
    limits:
      cpu: '1000m'
      memory: '2Gi'
    requests:
      cpu: '250m'
      memory: '512Mi'

  persistentVolume:
    enabled: true
    storageClass: 'ebs-sc'
    size: 10Gi

  numExecutors: 1

  installPlugins:
    - kubernetes:latest
    - workflow-aggregator:latest
    - git:latest
    - configuration-as-code:latest
    - credentials-binding:latest
    - github:latest
    - docker-plugin:latest
    - docker-workflow:latest
    - job-dsl:latest

  JCasC:
    configScripts:
      credentials: |
        credentials:
          system:
            domainCredentials:
              - credentials:
                  - usernamePassword:
                      scope: GLOBAL
                      id: github-token
                      username: ${github_login}
                      password: ${github_token}
                      description: GitHub PAT
      seed-job: |
        jobs:
          - script: >
              job('seed-job') {
                description('Job to generate pipeline for Django project')
                scm {
                  git {
                    remote {
                      url('${github_repo}')
                      credentials('github-token')
                    }
                    branches('*/${github_branch}')
                  }
                }
                steps {
                  dsl {
                    text('''
                      pipelineJob("django-fp-docker") {
                        properties {
                          pipelineTriggers {
                            triggers {
                              githubPush {}
                            }
                          }
                        }
                        definition {
                          cpsScm {
                            scriptPath("django/Jenkinsfile")
                            scm {
                              git {
                                remote {
                                  url("${github_repo}")
                                  credentials("github-token")
                                }
                                branches("*/${github_branch}")
                              }
                            }
                          }
                        }
                      }
                    ''')
                  }
                }
              }
