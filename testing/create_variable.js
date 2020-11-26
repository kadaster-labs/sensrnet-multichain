const multichain = require('multinodejs');

const connection = multichain({
    port: 8570,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password'
});

const variableData = { 'test': 1 };

const createVariablePromise = connection.create(['variable', 'test-variable-name', true, JSON.stringify(variableData)]);
createVariablePromise.then((data) => console.log(data), (error) => console.error(error));
