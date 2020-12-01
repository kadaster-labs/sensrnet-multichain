const multichain = require('multinodejs');

const connection = multichain({
    port: 8572,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password'
});

const variableData = { 'addresses': ['1bKnNpZXN53h5yiR75Y67kwKqpkeWowufbNwdy'] };

const createVariablePromise = connection.create(['variable', 'test-var-1', true, JSON.stringify(variableData)]);
createVariablePromise.then((data) => console.log(data), (error) => console.error(error));
