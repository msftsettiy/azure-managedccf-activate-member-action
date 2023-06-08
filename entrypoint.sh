#!/bin/bash

echo "$CERTD" > /opt/ccf_sgx/bin/cert
echo "$KEYD" > /opt/ccf_sgx/bin/key

cd /opt/ccf_sgx/bin

# Replace the \n with literal \n character
awk '{printf "%s\\n", $0}' cert > member_cert
export MEMBER_CERT = $(cat member_cert)

# Replace the certificate placeholder in the proposal with the member certificate
perl -p -i -e 's/__MEMBER_CERTIFICATE__/$ENV{MEMBER_CERT}/g' set_member.json

# Add the member
curl ${CCF_URL}/gov/ack/update_state_digest -X POST -k --key key --cert cert > request.json
content=$(ccf_cose_sign1 --ccf-gov-msg-type ack --ccf-gov-msg-created_at `date -Is` --signing-key key --signing-cert cert --content set_member.json | curl ${CCF_URL}/gov/ack -k -H "content-type: application/cose" --data-binary @-)
proposal=$(echo "${content}" | jq '.proposal_id')
echo "proposal=$proposal" >> $GITHUB_OUTPUT