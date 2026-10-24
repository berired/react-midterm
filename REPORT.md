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

