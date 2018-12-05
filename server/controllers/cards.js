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
    `createCard @title = '${title}' , @url = '${imageUrl}' , @price = '${price}' , @cost = '${costToProduce}' , @category = '${category}'`
  )
  console.log({ dirtyCard })
  const newCard = formatCard(dirtyCard[0])
  if (newCard) {
    return res.json(newCard)
  }
  return res.status(404).send()
}

exports.getCards = async (req, res) => {
  const dirtyCards = await knex.exec('getAllCards')
  const cards = dirtyCards.map(formatCard)
  // const cards = await db.getCards()
  if (cards) {
    return res.json(cards)
  }
  return res.status(404).send()
}

exports.updateCard = async (req, res) => {
  const { cardId, title, imageUrl, price, costToProduce, category } = req.body
  const dirtyCard = await knex.exec(
    `updateCard @CardID = ${cardId} , @title = '${title}' , @url = '${imageUrl}' , @price = '${price}' , @cost = '${costToProduce}' , @category = '${category}'`
  )

  console.log({ dirtyCard })
  const newCard = formatCard(dirtyCard[0])
  // const newCard = await db.updateCard(req.body)
  if (newCard) {
    return res.json(newCard)
  }
  return res.status(404).send()
}

exports.deleteCard = async (req, res) => {
  const deletedCardId = await knex.exec(`deleteCard @CardID = '${intId(req, 'cardId')}'`)
  console.log({ deletedCardId })
  // const deletedCard = await db.deleteCard(intId(req, 'cardId'))
  if (deletedCardId) {
    return res.send()
  }
  return res.status(404).send()
}

exports.getCard = async (req, res) => {
  const dirtyCard = await knex.exec(`getSingleCard @CardID = '${intId(req, 'cardId')}'`)
  const card = formatCard(dirtyCard[0])
  // const card = await db.getCard(intId(req, 'cardId'))
  if (card) {
    return res.json(card)
  }
  return res.status(404).send()
}
