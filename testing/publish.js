const { v4: uuidv4 } = require('uuid');
const multichain = require('multichain-node');

const connection = multichain({
    port: 8003,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password'
});

const sensor = {
    'typeName': 'Sensor',
    'location': {
        'height': 0,
        'latitude': 52.384381040312455,
        'longitude': 6.287133353697078,
        'baseObjectId': 'non-empty'
    },
    'dataStreams': [],
    'active': true,
    'aim': null,
    'description': null,
    'documentationUrl': 'kadaster.nl',
    'manufacturer': 'Philips',
    'name': 'WasteContainers',
    'theme': ['SoilandUnderground'],
    'typeDetails': {
        'subType': 'WasteContainers'
    }
}

const p = connection.publish({
    stream: 'sensors',
    key: uuidv4(),
    data: Buffer.from(JSON.stringify(sensor)).toString('hex')
});

Promise.all([p]).then((r) => console.log(r), (e) => console.error(e));
