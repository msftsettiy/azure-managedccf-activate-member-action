# Action for deployment of applications to CCF

This GitHub action is designed to automate deployment of an application to a CCF network.

---

## Pre-reqs

These action require 2 secrets to be stored in GitHub.

- NEWMEMBERCERT - The certificate of the new member.

- MEMBERCERT - The certificate that has access to the network, which will be used to sign the transactions for CCF.

- MEMBERKEY - The private key associated with the MEMBERCERT.

---

## Example workflow: Sample

```
on: [push]

jobs:
  ccf-add-member:
    runs-on: ubuntu-latest
    name: Add a member to a CCF network
    env:
      CCF_URL: '<your ccf endpoint>/'
    steps:
      - name: CCF add member
        uses: msftsettiy/azure-managedccf-add-member-action@v0.1.2-alpha
        id: add_member
        env:
          NEWMEMBERCERTD: ${{ secrets.NEWMEMBERCERT }}
          CERTD: ${{ secrets.MEMBERCERT }}
          KEYD: ${{ secrets.MEMBERKEY }}
```
