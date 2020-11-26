const multichain = require('multinodejs');

const connection = multichain({
    port: 8570,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password'
});

const streamPromise = connection.create(['stream', 'organizations', true]);
streamPromise.then(() => {
    const listStreamsPromise = connection.listStreams();
    listStreamsPromise.then((streams) => console.log(streams), (error) => console.error(error));
}, (error) => console.error(error))
