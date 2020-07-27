const multichain = require('multichain-node');

const connection = multichain({
    port: 8003,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password'
});

const p = connection.subscribe({
    addresses: '1bEyL5F3V7WWvNJd2rBVr2gAcgh1gU23PsRZzn'
});

Promise.all([p]).then((r) => console.log(r), (e) => console.error(e))
