const multichain = require('multinodejs');

const connection = multichain({
    port: 8572,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password',
});

const addressesPromise = connection.getAddresses();
addressesPromise.then((addresses) => console.log(addresses), (error) => console.error(error));
