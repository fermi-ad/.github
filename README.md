# .github

## How to use reusable workflows

[GitHub workflows](https://docs.github.com/en/actions/how-tos/write-workflows) are installed in the `.github/workflows` directory of your repo. See example installations below.

### Documentation workflows

_Note_: Using this requires some setup in your repo. See the [docs](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site#publishing-with-a-custom-github-actions-workflow)

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

