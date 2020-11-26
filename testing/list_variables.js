const multichain = require('multinodejs');

const connection = multichain({
    port: 8572,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password'
});

const variablesPromise = connection.listvariables(['*', true]);

variablesPromise.then((variables) => {
    console.log(variables);
}, (error) => console.error(error))
