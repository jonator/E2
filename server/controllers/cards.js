const db = require('../utils/db')

// get the specified id from the req.params
const intId = (req, property) => parseInt(req.params[property], 10)

exports.createCard = async (req, res) => {
  const newCard = await db.insertCard(req.body)
  if (newCard) {
    return res.json(newCard)
  }
  return res.status(404).send()
}

exports.getCards = async (req, res) => {
  const cards = await db.getCards()
  if (cards) {
    return res.json(cards)
  }
  return res.status(404).send()
}

exports.updateCard = async (req, res) => {
  const newCard = await db.updateCard(req.body)
  if (newCard) {
    return res.json(newCard)
  }
  return res.status(404).send()
}
exports.deleteCard = async (req, res) => {
  const deletedCard = await db.deleteCard(intId(req, 'cardId'))
  if (deletedCard) {
    return res.send()
  }
  return res.status(404).send()
}

exports.getCard = async (req, res) => {
  const card = await db.getCard(intId(req, 'cardId'))
  if (card) {
    return res.json(card)
  }
  return res.status(404).send()
}
