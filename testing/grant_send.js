const multichain = require('multinodejs');

const connection = multichain({
    port: 8570,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password'
});

const grantPromise = connection.grant(['1bKnNpZXN53h5yiR75Y67kwKqpkeWowufbNwdy', 'send']);
grantPromise.then((result) => console.log(result), (error) => console.error(error));
