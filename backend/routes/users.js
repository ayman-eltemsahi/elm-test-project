const _ = require('lodash');
const express = require('express');
const router = express.Router();

const ALLOWED_KEYS = ['id', 'name', 'username', 'company'];

const users = [
  {
    id: 1000,
    name: 'John',
    username: 'john',
    company: 'Apple'
  },
  {
    id: 1001,
    name: 'Mark',
    username: 'mark',
    company: 'Microsoft'
  }
];


router.get('/', (req, res) => {
  res.send(users);
});

router.post('/:id', (req, res) => {
  const requestUserId = Number(req.params.id);
  const index = users.findIndex(user => user.id === requestUserId);
  if (index === -1) {
    return res.status(400).send('USER_NOT_FOUND');
  }

  _.merge(users[index], _.pick(req.body, ALLOWED_KEYS));

  res.send(users);
});

module.exports = router;
