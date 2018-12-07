const db = require('../utils/db')
const knex = require('../knex')
// get the specified id from the req.params
const intId = (req, property) => parseInt(req.params[property], 10)
const toInt = string => parseInt(string, 10)
const decodeImage = url => url.replace('AlexLovesBrianna', '?')

exports.getUser = async (req, res) => {
  const userAndCart = await db.getUser(intId(req, 'userId'))
  if (!userAndCart) {
    return res.status(404).send()
  }

  return res.json(userAndCart)
}

exports.getUsers = async (req, res) => {
  const users = await db.getUsers()
  return res.json(users)
}

const formatUser = user => ({
  userId: user.UserID,
  firstName: user.FirstName,
  lastName: user.LastName,
  email: user.Email,
  isAdmin: user.IsAdmin,
})

exports.authenticateUser = async (req, res) => {
  const { email, password } = req.params
  const dirtyUser = await knex.exec(`authenticateUser @email = '${email}', @password = '${password}'`)
  if (!dirtyUser[0]) {
    return res.status(401).send('Invalid username/password supplied')
  }
  const user = formatUser(dirtyUser[0])
  // const user = await db.authenticateUser({ email, password })
  if (user) {
    return res.json(user)
  }
}

exports.createUser = async (req, res) => {
  const { firstName, lastName, email, password } = req.body
  try {
    const dirtyUser = await knex.exec(
      `createUser @FN = '${firstName}', @LN = '${lastName}', @Email = '${email}', @Password = '${password}'`
    )
    if (!dirtyUser[0]) {
      return res.status(500).send()
    }
    const createdUser = formatUser(dirtyUser[0])
    return res.json(createdUser)
    // const createdUser = await db.insertUser(req.body)
  } catch (err) {
    if (err.originalError.info.message.indexOf('Violation of UNIQUE KEY constraint') > -1) {
      return res.status(400).send('that email address already exists')
    }
  }
}

const formatCartItem = cartItem => ({
  card: {
    cardId: cartItem.CardID,
    title: cartItem.Title,
    imageUrl: decodeImage(cartItem.ImageURL),
    price: cartItem.Price,
    costToProduce: cartItem.CostToProduce,
    category: cartItem.Category,
  },
  quantity: cartItem.Quantity,
})

exports.getCartItems = async (req, res) => {
  const dirtyCartItems = await knex.exec(`getCart @UserID = ${intId(req, 'userId')}`)
  const cartItems = dirtyCartItems.map(formatCartItem)
  return res.json(cartItems)
}

exports.deleteCartItems = async (req, res) => {
  const cartItems = await db.deleteCartItemsByUser(intId(req, 'userId'))
  if (!cartItems) {
    return res.status(404)
  }
  return res.json(cartItems)
}

const formatCartItemSimple = cartItem => ({
  userId: cartItem.UserID,
  cardId: cartItem.CardID,
  quantity: cartItem.Quantity,
})

exports.createCartItem = async (req, res) => {
  const { userId, cardId, quantity } = req.body
  const dirtyCartItem = await knex.exec(
    `addToCart @UserID = '${userId}', @CardID = '${cardId}', @Quantity = ${toInt(quantity)}`
  )
  if (!dirtyCartItem[0]) {
    return res.status(404).send('User not found')
  }
  const cartItem = formatCartItemSimple(dirtyCartItem[0])

  // const cartItem = await db.insertCartItem(req.body)
  return res.json(cartItem)
}
exports.updateCartItem = async (req, res) => {
  const { userId, cardId, quantity } = req.body
  const dirtyCartItem = await knex.exec(
    `updateCartItem @UserID = '${userId}', @CardID = '${cardId}', @Quantity = ${toInt(quantity)}`
  )
  if (!dirtyCartItem[0]) {
    return res.status(404).send('User or Card not found')
  }
  const cartItem = formatCartItemSimple(dirtyCartItem[0])
  // const cartItem = await db.updateCartItem(req.body)
  return res.json(cartItem)
}
exports.deleteCartItem = async (req, res) => {
  const userId = intId(req, 'userId')
  const cardId = intId(req, 'cardId')
  const cartItemId = await knex.exec(`removeFromCart @UserID = '${userId}', @CardID = '${cardId}'`)
  // const cartItem = await db.deleteCartItem(intId(req, 'userId'), intId(req, 'cardId'))
  if (!cartItemId[0]) {
    return res.status(404).send('User or Card not found')
  }
  return res.send()
}
