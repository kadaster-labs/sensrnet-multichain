const multichain = require('multichain-node');

const connection = multichain({
    port: 8002,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password'
});

const p = connection.grant({
    addresses: '1aovvSqXZKN2Z3h7y4P81kmd6GBVbKUFQTJ7Fy',
    permissions: 'send'
});

Promise.all([p]).then((r) => console.log(r), (e) => console.error(e))
