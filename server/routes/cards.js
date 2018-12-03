const cardsController = require('../controllers/cards')

function setupCardRoutes(router) {
  router.get('/', cardsController.getCards)
  router.post('/', cardsController.createCard)
  router.get('/:cardId', cardsController.getCard)
  router.put('/', cardsController.updateCard)
  router.delete('/:cardId', cardsController.deleteCard)
}

module.exports = setupCardRoutes
