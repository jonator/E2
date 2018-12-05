const generate = require('./generate')
module.exports = db => {
  /* Initialize the database with some information */
  const users = Array.from({ length: 9 }, () => generate.user())
  users.push(generate.user({ userId: 1, isAdmin: true }))
  const cards = generate.cards(10)
  const orders = users.map((user, index) => {
    const { password, ...safeUser } = user //eslint-disable-line
    return {
      orderId: generate.id(),
      user: safeUser,
      orderLines: generate.orderLines([cards[index], cards[(index % 2) + 1], cards[(index % 3) + 1]]),
      orderDate: generate.orderDate(),
    }
  })
  const cartItems = users.map((user, index) => ({
    userId: user.userId,
    cardId: cards[index].cardId,
    quantity: index,
  }))
  db.users = users
  db.cards = cards
  db.orders = orders
  db.cartItems = cartItems
}
