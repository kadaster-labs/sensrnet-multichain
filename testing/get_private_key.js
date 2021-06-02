const multichain = require('multinodejs');

const connection = multichain({
    port: 8570,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password',
});

async function asyncDumpPrivateKey() {
    const addresses = await connection.getAddresses();
    for (const address of addresses) {
        const privateKey = await connection.dumpPrivKey({ address });
        console.log(`${address}: ${privateKey}`);
    }
}

asyncDumpPrivateKey().then();
