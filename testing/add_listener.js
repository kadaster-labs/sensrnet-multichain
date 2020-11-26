const multichain = require('multinodejs');

const connection = multichain({
    port: 8570,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password'
});

const subscriptionPromise = connection.subscribe(['sensors']);
subscriptionPromise.then((success) => console.log(success), (error) => console.error(error))
