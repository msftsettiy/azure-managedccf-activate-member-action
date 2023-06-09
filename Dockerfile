FROM mcr.microsoft.com/ccf/app/dev:4.0.1-sgx

RUN apt update && \
    apt install -y \
    python3.8 \
    python3-pip

RUN apt install -y perl

RUN apt install -y jq

RUN python3.8 -m pip install pip --upgrade

# Install CCF Python package to procure cose_signing
RUN pip install ccf==4.* || exit 1

COPY set_member.json /opt/ccf_sgx/bin/
COPY accept.json /opt/ccf_sgx/bin/
COPY entrypoint.sh actions/deploy/entrypoint.sh

RUN ["chmod", "+x", "/actions/deploy/entrypoint.sh"]
ENTRYPOINT ["/actions/deploy/entrypoint.sh"]
