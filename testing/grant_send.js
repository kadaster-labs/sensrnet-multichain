const config = require('./address.js');

const multichain = require('multichain-node');

const connection = multichain({
    port: 8002,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password'
});

const p = connection.grant({
    addresses: config.ADDRESS,
    permissions: 'send'
});

Promise.all([p]).then((r) => console.log(r), (e) => console.error(e))
