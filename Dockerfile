FROM circleci/ruby:2.4.1-node-browsers

RUN sudo apt-get -y update && \
    sudo apt-get -y install python-dev python-setuptools \
       # These are necessary for add-apt-respository
       software-properties-common python-software-properties && \

    # Setup Google Cloud SDK (latest)
    sudo mkdir -p /builder && \
    sudo wget -qO- https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz | sudo tar zxv -C /builder && \
    CLOUDSDK_PYTHON="python2.7" sudo /builder/google-cloud-sdk/install.sh --usage-reporting=false \
        --bash-completion=false \
        --disable-installation-options && \

    # Install additional components
    sudo /builder/google-cloud-sdk/bin/gcloud -q components install \
        alpha beta kubectl && \
    sudo /builder/google-cloud-sdk/bin/gcloud -q components update && \

    # install crcmod: https://cloud.google.com/storage/docs/gsutil/addlhelp/CRC32CandInstallingcrcmod
    sudo easy_install -U pip && \
    sudo pip install -U crcmod && \

    # TODO(jasonhall): These lines pin gcloud to a particular version.
    # /builder/google-cloud-sdk/bin/gcloud components update --version 137.0.0 && \
    # /builder/google-cloud-sdk/bin/gcloud config set component_manager/disable_update_check 1 && \
    # /builder/google-cloud-sdk/bin/gcloud -q components update && \

    # Clean up
    sudo rm -rf /var/lib/apt/lists/* && \
    sudo rm -rf ~/.config/gcloud

ENV PATH=/builder/google-cloud-sdk/bin/:$PATH