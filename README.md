# node-red-doorbell

This service continuously listens for our doorbell ring sound.
If it hears a ring then it will post a message on the specified [slack](https://slack.com/) channel.

## Prerequisites

### Dockerfile

Following has been added to my docker file to enable audio utilities.

```
FROM nodered/node-red:1.2.5-12
USER root
...
RUN set -ex && apk --no-cache add sudo sox alsa-utils 
# the following 2 command assure that node-red user belongs to the "host" audio group (gid = 63) of nuc-jan.
# this is needed to run commands like arecord, sox, aplay, alsamixer.
RUN addgroup -g 63 audio_host
RUN addgroup node-red audio_host

USER node-red
...

```

### Node-RED `node-red-contrib-edge-impulse`

1. You must install Node-RED node:
   * https://github.com/janvda/node-red-contrib-edge-impulse

2. The edge impulse Webassembly module must be deployed in folder (for the deployment see instructions below)
   * `/data/ei-doorbell-1-deployment-wasm-1595836551780/edge-impulse-standalone`

## Environment Variables

It requires that following environment variables are set:

| environment variable | description |
| ------------- | ------------- |
| slack_token | token of your slack workspace.  It is something like `xoxb-260...AlnL0Q` |
| slack_channel_ring | ID of the channel where the ring event must be posted.  The ID is typically a string that looks like `C7MHSP2M7`. |

The flows also contain logic to upload recorded audio fragments to the set of training data or testing data of your [edge impulse dashboard](https://studio.edgeimpulse.com/) project.
If you want to make use of this optional feature then the below environment variables must be set.

| environment variable | description |
| ------------- | ------------- |
| EDGE_IMPULSE_APIKEY  | api key for your project. You can find this in your [edge impulse dashboard](https://studio.edgeimpulse.com/).  |
| DEVICE_NAME  | Unique identifier for your device - e.g. the MAC address. |
| DEVICE_TYPE  | type of device - e.g the model.|

## Deploying new version of edge impulse

1. Go to `Edge Impulse dashboard > Deployment` menu
   * under Create library : choose WebAssembly
   * choose optimization int8 or float32
   * select build => this will download your model as zip file.

2. Goto the downloads folder where the zip file is located (see step 1).  Unzip it and open terminal window within it.

3. Set DOCKER_HOST variable for terminal session so that it points to docker environment by using following alias

```
lan_setup
```

4. Copy the files to the respective folder through following 2 commands:

```
docker cp edge-impulse-standalone.js   nuc-jan_node-red2_1:/data/ei-doorbell-1-deployment-wasm-1595836551780
docker cp edge-impulse-standalone.wasm nuc-jan_node-red2_1:/data/ei-doorbell-1-deployment-wasm-1595836551780
```

5. You need to restart the node-red container (in portainer) to be sure it is using the new edge impulse

```
docker restart nuc-jan_node-red2_1
```

## developing / upgrading `node-red-contrib-edge-impulse` on my intel nuc

The https://github.com/janvda/node-red-contrib-edge-impulse repository is checked out in folder `/data` of my `node-red2` container on my intel nuc.

1. This `/data` folder is accessible via samba.  So I have mounted this samba share on my macbook.
2. Using visual studio code on my macbook I can edit the mounted samba share (=`/Volumes/node-red2/node-red-contrib-edge-impulse`) and push the changes to the github repository.
3. Note that the changes made to the repository in step 2 are not automatically used by the node-red flows.  For that it is necessary to reinstall the node and restart node-red by means of following commands on my macbook:

```
# run alias to set DOCKER_HOST variable
lan_setup

# start bash session in the node-red2 container
docker exec -it nuc-jan_node-red2_1 /bin/bash

# following commands are executed in the bash session in node-red2 container
cd /data
npm install ./node-red-contrib-edge-impulse/
exit

# following commands are again executed on macbook
docker restart nuc-jan_node-red2_1
docker logs    nuc-jan_node-red2_1  -f  --since 20m
```


## Relevant Edge Impulse Forum topics

* [Better ML models with the Spectrogram block](https://forum.edgeimpulse.com/t/better-ml-models-with-the-spectrogram-block/929) => see especially [my second response summarizing the first test results (2020-11-17)](https://forum.edgeimpulse.com/t/better-ml-models-with-the-spectrogram-block/929/2)
* [Strange MFE spectogram for 1000 Hz sine wave](https://forum.edgeimpulse.com/t/strange-mfe-spectogram-for-1000-hz-sine-wave/902)
* [MFE spectogram is limited to High Frequency of 8000Hz](https://forum.edgeimpulse.com/t/mfe-spectogram-is-limited-to-high-frequency-of-8000hz/903)
* [Getting error "RuntimeError: abort(OOM). Build with -s ASSERTIONS=1 for more info." when using WebAssembly build](https://forum.edgeimpulse.com/t/getting-error-runtimeerror-abort-oom-build-with-s-assertions-1-for-more-info-when-using-webassembly-build/895)
* [Mapping "Mel-fiterbank" to audacity Mel spectogram](https://forum.edgeimpulse.com/t/mapping-mel-fiterbank-to-audacity-mel-spectogram/894)
* [Recognize my doorbell](https://forum.edgeimpulse.com/t/recognize-my-doorbell/557)
* [Mapping audacity “Mel” to MFCC parameters](https://forum.edgeimpulse.com/t/mapping-audacity-mel-to-mfcc-parameters/567)
* [Deployed WebAssembly build gives different outcome compared to my edge impulse dashboard](https://forum.edgeimpulse.com/t/deployed-webassembly-build-gives-different-outcome-compared-to-my-edge-impulse-dashboard/599)
* [Audio Processing Block: Spectrogram and 2D Output](https://forum.edgeimpulse.com/t/audio-processing-block-spectrogram-and-2d-output/734)
* [Comparison MFCC versus MFE to recognize doorbell ring](https://forum.edgeimpulse.com/t/comparison-mfcc-versus-mfe-to-recognize-doorbell-ring/765)
