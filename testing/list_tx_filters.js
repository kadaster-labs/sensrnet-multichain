const multichain = require('multinodejs');

const connection = multichain({
    port: 8570,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password'
});

const txFiltersPromise = connection.listTxFilters([]);

txFiltersPromise.then((txFilters) => {
    console.log(txFilters);
}, (error) => console.error(error))
