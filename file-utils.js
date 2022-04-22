const fs = require('fs');

async function ensureDirExists(path) {
    try {
        await fs.promises.mkdir(path, { recursive: true });
    } catch (err) {
        // Ignore the error if the folder already exists
        if (err.code !== 'EEXIST') {
            throw err;
        }
    }
}

function fileExists(path) {
    return fs.existsSync(path);
}

function readFromFile(path) {
    const data = fs.readFileSync(path);
    return JSON.parse(data);
}

function writeToFile(path, json) {
    let data = JSON.stringify(json);
    return fs.writeFileSync(path, data);
}

module.exports = {
    ensureDirExists,
    fileExists,
    readFromFile,
    writeToFile,
};
