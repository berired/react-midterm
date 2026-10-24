# React CI/CD with Jenkins and Docker

A Vite + React calculator (add and subtract) with Vitest tests, built and released by two Jenkins jobs running in Docker.

| Job | Trigger | Tasks |
|---|---|---|
| `React-CI` | Poll SCM on `*/main` | Install, test, build, archive `react-app-<n>.tar.gz` |
| `React-Deploy` | Build with Parameters | Copy the chosen CI artifact and serve it with Nginx (no React rebuild) |

## Repository layout
- `src/` – app, `calculator.js`, `calculator.test.js` (6 tests)
- `Dockerfile` – multi-stage build (Node build + tests, then Nginx); `package*.json` is copied before source for layer caching
- `Dockerfile.deploy` – serves an existing `site/` folder with Nginx; packaged inside each artifact
- `.dockerignore`
- `jenkins/` – job settings: `React-CI.config.xml`, `React-Deploy.config.xml`, the three shell scripts, and `Dockerfile.jenkins`

## Setup
1. Docker Desktop running in Linux container mode.
2. Build and start Jenkins (put `jenkins/Dockerfile.jenkins` in its own folder named `Dockerfile`):
   ```
   docker build -t jenkins-midterm .
   docker run -d --name jenkins-midterm --user root -p 8090:8080 -v jenkins_midterm_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock jenkins-midterm
   docker exec jenkins-midterm cat /var/jenkins_home/secrets/initialAdminPassword
   ```
3. Open http://localhost:8090, unlock, install suggested plugins, create an admin, and install the **Copy Artifact** plugin.
4. Verify Docker access: `docker exec jenkins-midterm docker version`.

## Jenkins job settings
**React-CI** (Freestyle): Git `https://github.com/berired/react-midterm.git`, branch `*/main`; Poll SCM `*/1 * * * *`; no concurrent builds; Permission to Copy Artifact: `React-Deploy`; Execute shell = `jenkins/ci-build.sh`; Archive `artifacts/react-app-*.tar.gz` (only if successful, fingerprint on).

**React-Deploy** (Freestyle, parameterized, SCM none, no triggers, no concurrent builds):
- Parameters: `TARGET_ENVIRONMENT` (choice: dev, test, acceptance, production), `CI_BUILD_NUMBER` (string, blank default)
- Step 1 Execute shell: `jenkins/deploy-validate.sh`
- Step 2 Copy artifacts: project `React-CI`, specific build `${CI_BUILD_NUMBER}`, filter `artifacts/react-app-${CI_BUILD_NUMBER}.tar.gz`, target `incoming`, flatten on, optional off
- Step 3 Execute shell: `jenkins/deploy.sh`

Exported configs: `jenkins/React-CI.config.xml`, `jenkins/React-Deploy.config.xml`.

## Environments
| Environment | Container | URL |
|---|---|---|
| dev | react-dev | http://localhost:8081 |
| test | react-test | http://localhost:8082 |
| acceptance | react-acceptance | http://localhost:8083 |
| production | react-production | http://localhost:8084 |

Each serves `/release.json` with the source CI build and Git commit.

## Local commands
```
npm ci
npm test
npm run build
npm run dev
```
