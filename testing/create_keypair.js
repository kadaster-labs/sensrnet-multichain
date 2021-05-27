const multichain = require('multinodejs');

const connection = multichain({
    port: 8570,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password',
});

async function createKeyPairs(count) {
    const keyPairs = await connection.createKeyPairs( { count} );
    console.log(keyPairs);
}

createKeyPairs().then();
