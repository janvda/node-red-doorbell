FROM nodered/node-red:1.2.6-12-minimal

######### Changing to root as below commands should be run as root #############
USER root

# installing sudo, sox and alsa-utils command
RUN set -ex && apk --no-cache add sudo sox alsa-utils 

# the following 2 command assure that node-red user belongs to the "host" audio group (gid = 63) of nuc-jan.
# this is needed to run commands like arecord, sox, aplay, alsamixer.
RUN addgroup -g 63    audio_host
RUN addgroup node-red audio_host

# following commands should assure that user node-red can use sudo without requiring to enter a password.
RUN echo "node-red ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

######### Changing back to node-red user #####################
USER node-red

# Copy package.json to the WORKDIR so npm builds all
# of your added nodes modules for Node-RED
COPY package.json /data/package.json
RUN  cd /data; npm install --unsafe-perm --no-update-notifier --no-fund --only=production 

# Copy _your_ Node-RED project files into place
# NOTE: This will only work if you DO NOT later mount /data as an external volume.
#       If you need to use an external volume for persistence then
#       copy your settings and flows files to that volume instead.
COPY settings.js /data/settings.js
COPY flow_cred.json /data/flows_cred.json
COPY flow.json /data/flows.json
