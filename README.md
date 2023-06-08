# Action for deployment of applications to CCF

This GitHub action is designed to automate the addition of a member to a Managed CCF instance.

---

## Pre-reqs

These action require 2 secrets to be stored in GitHub.

- NEWMEMBERCERT - The new member certificate being added to CCF.

- MEMBERCERT - The certificate that has access to the network, which will be used to sign the transactions for CCF.

- MEMBERKEY - The private key associated with the MEMBERCERT.

---

## Example workflow: Sample

```
on: [workflow_dispatch]

jobs:
  ccf-deploy:
    runs-on: ubuntu-latest
    name: Add a member and accept it.
    env:
      CCF_URL: ${{ vars.CCF_URL  }}
    steps:
      - name: CCF application deployment
        uses: msftsettiy/azure-managedccf-add-member-action@v0.1.0-alpha
        id: add_member
        env:
          NEWMEMBERD: ${{ secrets.NEWMEMBERCERT }}
          CERTD: ${{ secrets.MEMBERCERT }}
          KEYD: ${{ secrets.MEMBERKEY }}
      - name: Get the proposal id
        run: echo "The proposal id is ${{ steps.add_member.outputs.proposal }}"
      - name: Vote on the proposal
        uses: msftsettiy/azure-managedccf-submit-vote-action@v0.2.1-alpha
        id: vote
        env:
          CERTD: ${{ secrets.MEMBERCERT }}
          KEYD: ${{ secrets.MEMBERKEY }}
        with:
          proposal: ${{ steps.add_member.outputs.proposal }}
      - name: Get the status
        run: echo "The proposal id is ${{ steps.vote.outputs.status }}"
```