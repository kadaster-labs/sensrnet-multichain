const multichain = require('multichain-node');

const connection = multichain({
    port: 8002,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password'
});

connection.create({
    type: 'stream',
    name: 'sensors',
    open: true
}).then(() => {
    const p = connection.listStreams();
    Promise.all([p]).then((streams) => console.log(streams), (e) => console.error(e));
}, (e) => console.error(e))
