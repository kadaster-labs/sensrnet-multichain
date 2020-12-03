const multichain = require('multinodejs');

const connection = multichain({
    port: 8570,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password',
});

const newVariableValue = {'addresses': ['1bQ21WPWBfRnJbPHjFojkaf3u3xGXpwCw9fvQb']};

const variableValuePromise = connection.setvariablevalue(['test-var-1', JSON.stringify(newVariableValue)]);
variableValuePromise.then((result) => console.log(result), (error) => console.error(error));
