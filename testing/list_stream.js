const multichain = require('multinodejs');

const connection = multichain({
    port: 8570,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password'
});

const streamItemsPromise = connection.listStreamItems(['sensors', true, 10, 80]);

streamItemsPromise.then((streamItems) => {
    console.log(streamItems.length);
    for (const streamItem of streamItems) {
        console.log(JSON.parse(Buffer.from(streamItem.data, 'hex').toString()).aggregateId);
    }
}, (error) => console.error(error))
