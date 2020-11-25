const multichain = require('multinodejs');

const connection = multichain({
    port: 8570,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password',
});

const newVariableValue = {'new': 'value'};

const variableValuePromise = connection.setvariablevalue(['test-variable-name', JSON.stringify(newVariableValue)]);
variableValuePromise.then((result) => console.log(result), (error) => console.error(error));
