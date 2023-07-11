#!/bin/bash

# CERTD and KEYD represents an active member identity in the Managed CCF instance
echo "$NEWMEMBERCERTD" > /opt/ccf_sgx/bin/newmembercert
echo "$CERTD" > /opt/ccf_sgx/bin/cert
echo "$KEYD" > /opt/ccf_sgx/bin/key

cd /opt/ccf_sgx/bin

# Generate a temp file name
temp_file=`cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32`

# Replace the '\n' with literal '\n' character
awk '{printf "%s\\n", $0}' newmembercert > $temp_file

# Replace the __MEMBER_CERTIFICATE__ placeholder in the proposal with the actual member certificate
export MEMBER_CERT=$(cat $temp_file)
perl -p -i -e 's/__MEMBER_CERTIFICATE__/$ENV{MEMBER_CERT}/g' set_member.json

# Add the member
echo "Adding the member."
content=$(ccf_cose_sign1 --ccf-gov-msg-type proposal --ccf-gov-msg-created_at `date -Is` --signing-key key --signing-cert cert --content set_member.json | curl ${CCF_URL}/gov/proposals -k -H "content-type: application/cose" --data-binary @-)
proposal_id=$(echo "${content}" | jq '.proposal_id')

# Vote on the proposal
content=$(ccf_cose_sign1 --ccf-gov-msg-type ballot --ccf-gov-msg-created_at `date -Is` --signing-key key --signing-cert cert --content accept.json --ccf-gov-msg-proposal_id $proposal_id| curl ${CCF_URL}/gov/proposals/$proposal_id/ballots -k -H "content-type: application/cose" --data-binary @-)
status=$(echo "${content}" | jq '.state')

[[ $status="Accepted" ]] || ( echo "Member could not be added."; exit 1 )

# Activate the member
echo "Activating the member."
curl ${CCF_URL}/gov/ack/update_state_digest -X POST -k --key key --cert cert > request.json
ccf_cose_sign1 --content request.json --signing-cert cert --signing-key key --ccf-gov-msg-type ack --ccf-gov-msg-created_at `date -Is`|curl ${CCF_URL}/gov/ack -k -H 'Content-Type: application/cose' --data-binary @-
