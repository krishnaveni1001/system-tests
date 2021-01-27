# Mocked stubs
When the container starts up, it runs `socat` to forward any incoming traffic from port `80` to port `8080` where the mock service is listening. The stubs container picks up any configuration files from [here](wiremock)

## Build
docker build . -t gcr.io/awesomecstools/system-tests/service-stubs:latest

## Test
### Run the image
```bash
docker run \
  --network=system-tests_corenet \
  --rm \
  -p '3015:8080' \
  -v '/Users/cm/cargosphere/code/system-tests/service/stubs/wiremock:/home/wiremock' \
  gcr.io/awesomecstools/system-tests/service-stubs:latest \
  --verbose
```

### Curl the stub using a docker container
#### Carotrans
```bash
docker run \
  --network=system-tests_corenet \
  --link system-tests_stubs_1:api.carotrans.com \
  --rm \
  alpine:latest \
  wget \
  -qO - \
  --no-check-certificate\
  --post-data='{"data":"test"}' \
  'https://api.carotrans.com/v1/pricing/oceanrates'
```

#### IMS
```bash
docker run \
  --network=system-tests_corenet \
  --link system-tests_stubs_1:apps.imstransport.com \
  --rm \
  byrnedo/alpine-curl \
    'http://apps.imstransport.com/imsservice.php' \
    -d "<?xml version='1.0' encoding='UTF-8'?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"><soapenv:Body><getQuotesForCE xmlns=\"http://apps.imstransport.com/imsservice.php\"><clientkey xmlns=\"\">clientkey</clientkey><username xmlns=\"\">cargosphere</username><password xmlns=\"\">233|209|229|220|237|208|230|201|</password><MoveTypeId xmlns=\"\">1</MoveTypeId><Mode xmlns=\"\">ALL</Mode><LiveDropInd xmlns=\"\">L</LiveDropInd><LoadedEmptyInd xmlns=\"\">L</LoadedEmptyInd><ImportExport xmlns=\"\">X</ImportExport><ContainerSize xmlns=\"\">ALL</ContainerSize><ContainerType xmlns=\"\">DV/HC</ContainerType><P2 xmlns=\"\">Chapel Hill, NC</P2><Client2 xmlns=\"\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:nil=\"1\"/><HazardousInd xmlns=\"\">N</HazardousInd><ReeferInd xmlns=\"\">N</ReeferInd><OverweightInd xmlns=\"\">N</OverweightInd></getQuotesForCE></soapenv:Body></soapenv:Envelope>"
```

#### Vanguard
```bash
docker run \
  --network=system-tests_corenet \
  --link system-tests_stubs_1:apipp.vanguardlogistics.com \
  --rm \
  alpine:latest \
  wget \
  -qO - \
  --no-check-certificate \
  --post-data='{"requirePickup":true,"pickupDate":"28-Feb-2019","originCountry":"US","origin":"90815","requireDelivery":true,"destinationCountry":"CN","destination":"266001","requireFulfillment":false,"weight":"1000","weightUnit":"kgs","volume":"0.0283","volumeUnit":"cbm","numOfPackages":"1","dimensions":[{"length":"12","width":"12","height":"12","uom":"IN","weight":"1000","weightUnit":"kgs"}],"hazardous":false,"packageType":"BOX","additionalServices":{"customsClearanceImport":true,"customsClearanceExport":true,"aes":true,"ams":true,"palletization":true,"unStackable":true,"originTruckServices":{"isLiftGate":false,"isResidential":false,"isConstructionSiteFee":false,"isTradeShowFee":false},"destinationTruckServices":{"isLiftGate":false,"isResidential":false,"isConstructionSiteFee":false,"isTradeShowFee":false}}}' \
  'https://apipp.vanguardlogistics.com/appservicev2/api/adesso-api/get-quote'
```

## View the mapped stubs
http://proxy:3015/__admin

## Further reading
  * http://wiremock.org/docs/request-matching/
