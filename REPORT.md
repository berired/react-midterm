# Midterm Report – React CI/CD Using Jenkins and Docker

Student: David Xander Wagan
Repository: https://github.com/berired/react-midterm

## Environment table
| Environment | Port | Final CI build | App version |
|---|---|---|---|
| dev | 8081 | 7 | 2.0 |
| test | 8082 | 7 | 2.0 |
| acceptance | 8083 | 7 | 2.0 |
| production | 8084 | 7 | 2.0 |

## CI build history
| Build | Notes |
|---|---|
| 1 | First manual build, passed |
| 2 | Manual build, passed |
| 3 | Triggered by SCM change, version 1.1, passed; deployed to all four environments |
| 4 | Intentional subtraction bug in `add`; tests failed, no artifact archived; deploying it was rejected at the Copy Artifact step |
| 5 | Fix restored; passed |
| 6 | Subtraction feature and tests (6 passing tests); passed |
| 7 | Version 2.0; deployed to dev first, then promoted unchanged to test, acceptance and production |

Poll SCM was set to `*/1 * * * *` (every minute) instead of `*/2` to speed up the demos.

## Screenshots
_Add the screenshots listed in the assignment here._

## Analysis
**Why should automated tests run before creating a release artifact?**
So a broken change never becomes a release. The CI script stops at the first failing step, so a failing test means no package is created or archived (build 4 produced no artifact).

**Why does deployment retrieve an artifact instead of rebuilding React?**
Rebuilding could produce a different result from what was tested (new dependency versions, different environment). Deploying the exact archived artifact means what was tested is what runs, and it is also faster.

**What is the purpose of CI_BUILD_NUMBER?**
It selects which archived CI build to deploy. It makes releases versioned and traceable: the same number is used to find the artifact, tag the Docker image and container labels, and appears in `release.json`. Promoting build 7 to every environment guarantees they run identical code.

**How does copying dependency files before source files improve Docker caching?**
Docker caches each layer and invalidates every layer after a changed one. `package*.json` changes rarely, so the `npm ci` layer stays cached when only source files change, and only the later `COPY . .`, test and build layers re-run.

**What does the final Nginx image exclude from the Node.js build stage?**
It contains only the compiled `dist` files. Node.js, npm, `node_modules`, the source code, test files and build tooling are left behind, which makes the image smaller and reduces its attack surface.

**Why is this workflow continuous delivery with manual deployment?**
Every change is automatically tested, built and packaged into a deployable artifact (continuous integration plus a release candidate), but deployment to each environment needs a person to choose the build and environment and start it. Continuous deployment would release automatically.
