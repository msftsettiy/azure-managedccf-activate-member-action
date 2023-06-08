# Action for deployment of applications to CCF

This GitHub action is designed to automate deployment of an application to a CCF network.

---

## Pre-reqs

These action require 2 secrets to be stored in GitHub.

- MEMBERCERT - The certificate that has access to the network, which will be used to sign the transactions for CCF.

- MEMBERKEY - The private key associated with the MEMBERCERT.

---

## Example workflow: Sample

```
on: [push]

jobs:
  ccf-deploy:
    runs-on: ubuntu-latest
    name: Deploy CCF application
    env:
      CCF_URL: '<your ccf endpoint>/'
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: CCF deploy
        uses: msftsettiy/azure-managedccf-deploy-app-action@v0.1.0-alpha
        id: deploy
        env:
          CERTD: ${{ secrets.MEMBERCERT }}
          KEYD: ${{ secrets.MEMBERKEY }}
        with:
          application: '<path to your bundled application>'
      - name: Get the proposal id
        run: echo "The proposal id is ${{ steps.deploy.outputs.proposal }}"
```