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
  /* pool: {
    afterCreate: function(connection, callback) {
      connection.query('SET time_zone = -06:00;', function(err) {
        callback(err, connection)
      })
    },
  }, */
})

knex.table = table => knex.withSchema('Project').table(table)
knex.exec = procedureName => knex.raw(`exec ${procedureName}`)
module.exports = knex
