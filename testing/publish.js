const { v4: uuidv4 } = require('uuid');
const multichain = require('multinodejs');

const connection = multichain({
    port: 8570,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password',
});

const sensor =  {
    "source":"1GmJ76BMsGE2niiLrib2BDdTmvF8HWVDSzJhX5",
    "aggregateId":"fc516a63-c78b-4af5-88a0-1c47ae2130d7",
    "sensorId":"fc516a63-c78b-4af5-88a0-1c47ae2130d7",
    "organizationId":"Kadaster",
    "name":"LightCell",
    "longitude":6.730474337621839,
    "latitude":53.40260808820527,
    "height":0,
    "baseObjectId":"non-empty",
    "aim":"",
    "description":"",
    "active":true,
    "theme":["Wheather"],
    "category":"Sensor",
    "typeName":"LightCell",
    "eventType":"SensorRegistered"
}

const publishPromise = connection.publish(['sensors', uuidv4(), Buffer.from(JSON.stringify(sensor)).toString('hex')]);
publishPromise.then((result) => console.log(result), (error) => console.error(error));
