const multichain = require('multinodejs');

const connection = multichain({
    port: 8572,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password'
});

const subscribePromise = connection.subscribe(['sensors', true]);
subscribePromise.then((result) => console.log(result), (error) => console.error(error));
