const config = require('./address.js');

const multichain = require('multichain-node');

const connection = multichain({
    port: 8003,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password'
});

const p = connection.subscribe({
    addresses: config.ADDRESS
});

Promise.all([p]).then((r) => console.log(r), (e) => console.error(e))
