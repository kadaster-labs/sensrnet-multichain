let bs58 = require('bs58');
let crypto = require('crypto');
let elliptic = require('elliptic');


function hexToBytes(hex) {
    const bytes = [];
    for (let c = 0; c < hex.length; c += 2)
        bytes.push(parseInt(hex.substr(c, 2), 16));

    return bytes;
}

function getHash(bytes, method) {
    return crypto.createHash(method).update(Buffer.from(bytes)).digest('hex');
}

function addHash(origin, hash, step) {
    const interval = Math.floor(step / hash.length);
    for (let i = 0; i < hash.length; i++) {
        origin.splice(i * interval + i, 0, hash[i]);
    }

    return origin
}

const ADDRESS_PUBLIC_KEY_HASH_VERSION = '00f7391c';
const publicKeyHashVersionBytes = hexToBytes(ADDRESS_PUBLIC_KEY_HASH_VERSION);
console.log(`ADDRESS_PUBLIC_KEY_HASH_VERSION: ${ADDRESS_PUBLIC_KEY_HASH_VERSION}`);

const PRIVATE_KEY_VERSION = '80ea7b28';
let privateKeyVersionBytes = hexToBytes(PRIVATE_KEY_VERSION);
console.log(`PRIVATE_KEY_VERSION: ${PRIVATE_KEY_VERSION}`);

const ADDRESS_CHECKSUM_VALUE = '344cbb15';
const addressChecksumBytes = hexToBytes(ADDRESS_CHECKSUM_VALUE);
console.log(`ADDRESS_CHECKSUM_VALUE: ${ADDRESS_CHECKSUM_VALUE}`);

const keyPair = new elliptic.ec('secp256k1').genKeyPair();

const publicKey = keyPair.getPublic().encodeCompressed('hex');
let publicKeyBytes = hexToBytes(publicKey);

let publicKeyHash = getHash(publicKeyBytes, 'sha256');
publicKeyHash = getHash(hexToBytes(publicKeyHash), 'ripemd160');
publicKeyBytes = addHash(hexToBytes(publicKeyHash), publicKeyHashVersionBytes, 20);
publicKeyHash = getHash(publicKeyBytes, 'sha256');
publicKeyHash = getHash(hexToBytes(publicKeyHash), 'sha256');

publicKeyBytes.push(...hexToBytes(publicKeyHash).slice(0, 4).map((x, i) => x ^ addressChecksumBytes[i]));

const privateKey = keyPair.getPrivate('hex');
let privateKeyBytes = hexToBytes(privateKey);
privateKeyBytes.push(1);

privateKeyBytes = addHash(privateKeyBytes, privateKeyVersionBytes, 33);

let privateKeyBytesHash = getHash(privateKeyBytes, 'sha256');
privateKeyBytesHash = getHash(hexToBytes(privateKeyBytesHash), 'sha256');
privateKeyBytes.push(...hexToBytes(privateKeyBytesHash).slice(0, 4).map((x, i) => x ^ addressChecksumBytes[i]));

const address = bs58.encode(publicKeyBytes);
console.log(`Address: ${address}`);

const privateKeyEncoded = bs58.encode(privateKeyBytes);
console.log(`Private Key: ${privateKeyEncoded}`);
