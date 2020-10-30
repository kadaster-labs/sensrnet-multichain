const multichain = require('multichain-node');

const connection = multichain({
    port: 8570,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password'
});

const p = connection.listStreamItems({
    stream: 'sensors',
    start: 0,
    verbose: true
});

Promise.all([p]).then((r) => {
    console.log(r);
    const data = r[0][0].data;
    console.log(Buffer.from(data, 'hex').toString());
}, (e) => console.error(e))
