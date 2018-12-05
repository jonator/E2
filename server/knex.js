const knex = require('knex')({
  client: 'mssql',
  connection: {
    host: process.env.databaseHost,
    user: 'ksu',
    password: process.env.databasePassword,
    database: 'CIS560',
    options: {
      encrypt: true,
    },
  },
})

knex.table = table => knex.withSchema('Project').table(table)
knex.exec = procedureName => knex.raw(`exec ${procedureName}`)
module.exports = knex
