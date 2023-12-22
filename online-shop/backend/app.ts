const express = require('express')
const cors = require('cors');
const sqlite3 = require('sqlite3');
const bodyParser = require('body-parser');

const db = new sqlite3.Database('shop_database.db');
const app = express()
const port = 3000

app.use(cors());
app.use(bodyParser.json());

app.get('/', (req, res) => {
  res.send('Hello World!');
})

app.get('/api/items', (req, res) => {
  let db_query = `SELECT * FROM products`;
  let predicates_array = [];
  if (req.query.category || req.query.name) {
    db_query += ` WHERE `
  }
  if (req.query.category && req.query.category !== 'All') {
    db_query += `category = ?`
    predicates_array.push(req.query.category);
  }
  if (req.query.name) {
    if (req.query.category && req.query.category !== 'All') {
      db_query += ' AND '
    }
    db_query += `name = ?`
    predicates_array.push(req.query.name);
  }

  db.all(db_query, predicates_array, (err, rows) => {
    if (err) {
      res.status(500).send('Error while fetching products');
    } else {
      res.send(rows);
    }
  });
})

app.get('/api/categories', (req, res) => {
  db.all(`SELECT DISTINCT category FROM products`, (err, rows) => {
    if (err) {
      res.status(500).send('Error while fetching categroies');
    } else {
      res.send(['All', ...(rows.map(row => row.category))]);
    }
  });
})

const insertOrder = (userId, order, res) => {
  const db_query = 'SELECT MAX(orderId) AS maxOrderId FROM orders';

  db.get(db_query, [], (err, row) => {
    const newOrderId = (row.maxOrderId || 0) + 1;
    console.log(`Maximum orderId: ${newOrderId}`);
    order.forEach(element => {
      const params = [newOrderId, userId, element.product.id, element.quantity]

      const insert_db_query = 'INSERT INTO orders (orderId, userId, productId, quantity) VALUES (?, ?, ?, ?)';
      db.run(insert_db_query, params, (err) => {
        console.log('Inserted item to orders');
      });
    });
  });
  res.send('All good');
};

app.post('/api/buy', (req, res) => {
  const payload = req.body;
  db.get('SELECT id FROM users WHERE name = (?)', [payload.username], (err, row) => {
    let userId = row.id;
    if (row) {
      insertOrder(userId, payload.order, res);
    } else {
      db.run('INSERT INTO users (name) VALUES (?)', [payload.username], function(err) {
        insertOrder(this.lastID, payload.order, res);
      });
    }
  });
})


app.get('/api/history', (req, res) => {
  const username = req.query.username;
  db.get('SELECT id FROM users WHERE name = (?)', [username], (err, row) => {
    let userId = row.id;
    const sql = `
      SELECT o.orderId, o.userId, p.id AS productId, p.name AS productName, p.price, p.category, o.quantity 
      FROM orders o 
      JOIN products p ON o.productId = p.id 
      WHERE o.userId = ? 
      `;
    db.all(sql, [userId], (err, rows) => {
      if (err) {
        console.error(err.message);
        return;
      }
      res.send(rows);
    });
  });
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})