const knex = require('knex')({
  client: 'mssql',
  connection: {
    host: 'wendte-cis560.database.windows.net',
    user: 'ksu',
    password: 'W3G04Th3A',
    database: 'CIS560',
    options: {
      encrypt: true,
    },
  },
})

knex.table = table => knex.withSchema('Project').table(table)
knex.exec = procedureName => knex.raw(`exec ${procedureName}`)
module.exports = knex
