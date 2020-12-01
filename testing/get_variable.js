const multichain = require('multinodejs');

const connection = multichain({
    port: 8570,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password',
});

const variablePromise = connection.getvariablevalue(['fc516a63c78b4af588a01c47ae2130d7']);
variablePromise.then((variable) => console.log(variable), (error) => console.error(error));
