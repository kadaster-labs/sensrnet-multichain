const multichain = require('multinodejs');

const connection = multichain({
    port: 8572,
    host: '127.0.0.1',
    user: 'multichainrpc',
    pass: 'password'
});

const variableData = { 'addresses': ['1ZcUAQ2HA66XyYofXDLsWdegCaSVr31cmmDzfL'] };

const createVariablePromise = connection.create(['variable', 'fc516a63c78b4af588a01c47ae2130d7', true, JSON.stringify(variableData)]);
createVariablePromise.then((data) => console.log(data), (error) => console.error(error));
