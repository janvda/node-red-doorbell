# node-red-doorbell


## Environment Variables

It requires that following environment variables are set:

| environment variable | description |
| ------------- | ------------- |
| EDGE_IMPULSE_APIKEY  | api key for your project. You can find this in your [edge impulse dashboard](https://studio.edgeimpulse.com/)  |
| DEVICE_NAME  | Unique identifier for your device - e.g. the MAC address |
| DEVICE_TYPE  | type of device - e.g the model  |

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

## Relevant Edge Impulse Forum topics

* [Strange MFE spectogram for 1000 Hz sine wave](https://forum.edgeimpulse.com/t/strange-mfe-spectogram-for-1000-hz-sine-wave/902)
* [MFE spectogram is limited to High Frequency of 8000Hz](https://forum.edgeimpulse.com/t/mfe-spectogram-is-limited-to-high-frequency-of-8000hz/903)
* [Getting error "RuntimeError: abort(OOM). Build with -s ASSERTIONS=1 for more info." when using WebAssembly build](https://forum.edgeimpulse.com/t/getting-error-runtimeerror-abort-oom-build-with-s-assertions-1-for-more-info-when-using-webassembly-build/895)
* [Mapping "Mel-fiterbank" to audacity Mel spectogram](https://forum.edgeimpulse.com/t/mapping-mel-fiterbank-to-audacity-mel-spectogram/894)
* [Recognize my doorbell](https://forum.edgeimpulse.com/t/recognize-my-doorbell/557)
* [Mapping audacity “Mel” to MFCC parameters](https://forum.edgeimpulse.com/t/mapping-audacity-mel-to-mfcc-parameters/567)
* [Deployed WebAssembly build gives different outcome compared to my edge impulse dashboard](https://forum.edgeimpulse.com/t/deployed-webassembly-build-gives-different-outcome-compared-to-my-edge-impulse-dashboard/599)
* [Audio Processing Block: Spectrogram and 2D Output](https://forum.edgeimpulse.com/t/audio-processing-block-spectrogram-and-2d-output/734)
* [Comparison MFCC versus MFE to recognize doorbell ring](https://forum.edgeimpulse.com/t/comparison-mfcc-versus-mfe-to-recognize-doorbell-ring/765)
