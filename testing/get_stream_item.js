const multichain = require('multinodejs');

const connection = multichain({
    port: 8570,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password',
});

const streamItemPromise = connection.getStreamItem(['sensors', 'e1c566557b27057fce613f913e1f6b7e1534bc711d94fbec0a813fb5d873d937']);
streamItemPromise.then((item) => console.log(item), (error) => console.error(error))
