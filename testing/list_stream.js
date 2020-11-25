const multichain = require('multinodejs');

const connection = multichain({
    port: 8572,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password'
});

const streamItemsPromise = connection.listStreamItems(['sensors', true]);

streamItemsPromise.then((streamItems) => {
    console.log(streamItems.length);
    if (streamItems.length) {
        console.log(Buffer.from(streamItems[0].data, 'hex').toString());
    }
}, (error) => console.error(error))
