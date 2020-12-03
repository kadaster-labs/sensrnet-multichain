const multichain = require('multinodejs');

const connection = multichain({
    port: 8570,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password'
});

const restrictions = {
    'for': ['sensors', 'organizations']
};

const smartFilter = `
function hexToString(hex) {
    let string = '';
    for (var i = 0; i < hex.length; i += 2) {
      string += String.fromCharCode(parseInt(hex.substr(i, 2), 16));
    }
    return string;
}

function filtertransaction() {
    const tx = getfiltertransaction();

    if (tx.vout && tx.vout.length && tx.vout[0].items && tx.vout[0].items.length && tx.vout[0].items[0].data) {
        for (const item of tx.vout[0].items) {
            const streamItem = JSON.parse(hexToString(item.data.toString()));
            if (!item.keys.includes(streamItem.aggregateId)) {
                return 'AggregateId and key do not match';
            }

            const variableName = streamItem.aggregateId.split('-').join('');
            const correspondingVariableValue = getvariablevalue(variableName);
            if (correspondingVariableValue) {
                const variableValue = JSON.parse(correspondingVariableValue);

                if (typeof variableValue.addresses == 'object') {
                    if (!item.publishers.some((publisher) => variableValue.addresses.includes(publisher))) {
                        return 'Only the aggregate creator may manipulate this aggregate.';
                    }
                }
            }
        }
    }
}`;

const txFilterPromise = connection.create(['txfilter', 'validate-address-txfilter', restrictions, smartFilter]);
txFilterPromise.then((data) => console.log(data), (error) => console.error(error))
