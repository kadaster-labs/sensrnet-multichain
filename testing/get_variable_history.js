const multichain = require('multinodejs');

const connection = multichain({
    port: 8570,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password',
});

const variableHistoryPromise = connection.getvariablehistory(['test-variable-name']);
variableHistoryPromise.then((variableHistory) => console.log(variableHistory), (error) => console.error(error));
