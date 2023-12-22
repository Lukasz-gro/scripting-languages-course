const sqlite3 = require('sqlite3');

const db = new sqlite3.Database('shop_database.db');

const createSchemas = () => {
    db.run(`
    CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
    )
    `);
    
    db.run(`
    CREATE TABLE IF NOT EXISTS products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        price INTEGER,
        category TEXT
    )
    `);

    db.run(`
    CREATE TABLE IF NOT EXISTS orders (
        orderId INTEGER,
        userId INTEGER,
        productId INTEGER,
        quantity INTEGER
    )
    `);
};

createSchemas();