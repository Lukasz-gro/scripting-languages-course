const sqlite3 = require('sqlite3');

const db = new sqlite3.Database('shop_database.db');

const populateDatabase = async () => {
    await db.get('SELECT COUNT(*) as count FROM users', (err, result) => {
        if (err) {
            console.error(err.message);
        } else {
            if (result.count === 0) {
                const initialUsers = [
                    { name: 'Lukasz' }
                ];

                const insertStatement = db.prepare('INSERT INTO users (name) VALUES (?)');

                initialUsers.forEach(user => {
                    insertStatement.run(user.name);
                });

                insertStatement.finalize();

                console.log('Database initialized with initial values.');
            } else {
                console.log('Database already contains data. Skipping initialization.');
            }
        }
    });

    await db.get('SELECT COUNT(*) as count FROM products', (err, result) => {
        if (err) {
            console.error(err.message);
        } else {
            console.log('Adding products');
            if (result.count === 0) {
                const initialProducts = [
                    { name: 'Banana', price: 10, category: 'Food' },
                    { name: 'Apple', price: 5, category: 'Food' },
                    { name: 'Orange', price: 12, category: 'Food' },
                    { name: 'Shoes', price: 250, category: 'Clothing' },
                ]

                const insertStatement = db.prepare('INSERT INTO products (name, price, category) VALUES (?, ?, ?)');
                initialProducts.forEach(product => {
                    insertStatement.run(product.name, product.price, product.category, (err) => {
                        if (err) {
                            console.error(err);
                        } else {
                            console.log('Ive inserted something');
                        }
                    });
                });
                insertStatement.finalize();
            }
        }
    });
    db.close();
};

populateDatabase();