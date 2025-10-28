# .github

## How to use reusable workflows

[GitHub workflows](https://docs.github.com/en/actions/how-tos/write-workflows) are installed in the `.github/workflows` directory of your repo. See example installations below.

### Documentation workflows

```yaml
name: Documentation Deployment

on:
  push:
    branches:
      - main

jobs:
  deploy-docs:
    uses: ./.github/workflows/deploy-<lang>-docs.yaml@main
    secrets: inherit
```
```
```

