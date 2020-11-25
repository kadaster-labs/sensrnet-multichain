const multichain = require('multinodejs');

const connection = multichain({
    port: 8570,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password'
});

const permissionPromise = connection.listPermissions(['*', '1JEFewrhP93AWDvhVQTqCMTwcP3sWNTqEGUPqN']);
permissionPromise.then((result) => console.log(result), (error) => console.error(error));
