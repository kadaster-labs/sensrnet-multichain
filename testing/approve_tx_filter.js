const multichain = require('multinodejs');

const connection = multichain({
    port: 8570,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password'
});

const approvePromise = connection.approveFrom(['1bQ21WPWBfRnJbPHjFojkaf3u3xGXpwCw9fvQb', 'validate-node-txfilter', true]);
approvePromise.then((data) => console.log(data), (error) => console.error(error))
