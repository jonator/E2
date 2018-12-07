// const db = require('../utils/db')
const knex = require('../knex')

// get the specified id from the req.params
const intId = (req, property) => parseInt(req.params[property], 10)

const formatCard = card => ({
  cardId: card.CardID,
  title: card.Title,
  imageUrl: card.ImageURL,
  price: card.Price,
  costToProduce: card.CostToProduce,
  category: card.Category,
})

exports.createCard = async (req, res) => {
  // const newCard = await db.insertCard(req.body)
  const { title, imageUrl, price, costToProduce, category } = req.body
  const dirtyCard = await knex.exec(
    `createCard @title = '${title}' , @url = '${imageUrl}' , @price = ${price} , @cost = ${costToProduce} , @category = '${category}'`
  )
  if (!dirtyCard[0]) {
    return res.status(404).send()
  }
  const newCard = formatCard(dirtyCard[0])
  return res.json(newCard)
}

exports.getCards = async (req, res) => {
  const dirtyCards = await knex.exec('getAllCards')
  const cards = dirtyCards.map(formatCard)
  // const cards = await db.getCards()
  return res.json(cards)
}

exports.updateCard = async (req, res) => {
  const { cardId, title, imageUrl, price, costToProduce, category } = req.body
  const dirtyCard = await knex.exec(
    `updateCard @CardID = ${cardId} , @title = '${title}' , @url = '${imageUrl}' , @price = ${price}, @cost = ${costToProduce} , @category = '${category}'`
  )
  if (!dirtyCard[0]) {
    return res.status(404).send('Card not found')
  }
  const newCard = formatCard(dirtyCard[0])
  // const newCard = await db.updateCard(req.body)
  return res.json(newCard)
}

exports.deleteCard = async (req, res) => {
  const deletedCardId = await knex.exec(`deleteCard @CardID = '${intId(req, 'cardId')}'`)
  // const deletedCard = await db.deleteCard(intId(req, 'cardId'))
  if (deletedCardId[0].CardID) {
    return res.send('deleted')
  }
  return res.status(404).send('Card not found')
}

exports.getCard = async (req, res) => {
  const dirtyCard = await knex.exec(`getSingleCard @CardID = '${intId(req, 'cardId')}'`)
  if (!dirtyCard[0]) {
    return res.status(404).send('Card not found')
  }
  const card = formatCard(dirtyCard[0])
  // const card = await db.getCard(intId(req, 'cardId'))
  return res.json(card)
}

exports.getCategories = async (req, res) => {
  const dirtyCategories = await knex.exec('currentCategories')
  const categories = dirtyCategories.map(cat => cat.Category)
  if (categories) {
    return res.json(categories)
  }
}
