# .github

A "special" repo for GitHub-oriented configuration and standardization of fermi-ad capabilities.

## Keep submodule up to date

If your repo includes a submodule and you want to ensure you always have the most recent version, you can use the `submodule-update` workflow. This is particularly useful for central sources of truth like our `interface-definitions` gRPC repository.

### How it works

The pipeline consists of two parts:
1. The Dispatcher (The Source): A workflow in the source repository that notifies downstream consumers when changes occur.
2. The Receiver (The Consumer): A workflow in your service repository that catches that notification and opens a Pull Request to update the submodule.

### Implementation Example

1. Set up the sispatcher (Source Repo)

Add this to the repository containing the source files (e.g., the proto definitions). It uses the official GitHub CLI to notify downstream repos.

```yaml
name: Notify of Updates
on:
  push:
    branches: [main]
    paths: ['proto/**'] # Only trigger if relevant files change

jobs:
  notify:
    strategy:
      matrix:
        repo: ['fermi-ad/grpc-reflection-catalog', 'fermi-ad/another-service']
    runs-on: ubuntu-latest
    steps:
      - name: Generate Token
        id: generate-token
        uses: actions/create-github-app-token@v1
        with:
          app-id: ${{ vars.ACTION_SETTINGS_APP_ID }}
          private-key: ${{ secrets.ACTION_SETTINGS_PRIVATE_KEY }}
          owner: ${{ github.repository_owner }}
      - name: Dispatch
        env:
          GH_TOKEN: ${{ steps.generate-token.outputs.token }}
        run: |
          gh api -X POST /repos/${{ matrix.repo }}/dispatches -f event_type='protos-updated'
```

2. Setup the Receiver (Consumer Repo)
   
Add this to your service repository to "listen" for the update and call our reusable workflow.

```yaml
name: Remote Interface Update

on:
  repository_dispatch:
    types: [protos-updated]
  workflow_dispatch: # Allows manual triggering from the Actions UI

jobs:
  update-interface:
    uses: fermi-ad/.github/.github/workflows/reusable-submodule-update.yaml@main
    with:
      submodule_name: 'interface-definitions'
      submodule_path: 'third_party/interface-definitions'
      pr_label: 'proto-update'
    secrets:
      APP_ID: ${{ vars.ACTION_SETTINGS_APP_ID }}
      APP_PRIVATE_KEY: ${{ secrets.ACTION_SETTINGS_PRIVATE_KEY }}
```

### Why use this approach?

- No Direct Pushes: All updates come in as Pull Requests, allowing CI tests to run before the code is merged.
- Official Tools Only: Uses the pre-installed GitHub CLI (gh) and standard git commands to avoid third-party security risks.
- Organized: Automated PRs are tagged with a specific label (default: dependencies) for easy filtering by the team.

### Terminology guide

submodule_name: The logical name used for PR titles (e.g., interface-definitions).
submodule_path: The actual file system path where the submodule is checked out in your repository.
