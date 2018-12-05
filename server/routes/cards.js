const cardsController = require('../controllers/cards')
const { catchErrors } = require('../handlers/errorHandlers')

function setupCardRoutes(router) {
  router.get('/', catchErrors(cardsController.getCards))
  router.post('/', catchErrors(cardsController.createCard))
  router.get('/categories', catchErrors(cardsController.getCategories))
  router.get('/:cardId', catchErrors(cardsController.getCard))
  router.put('/', catchErrors(cardsController.updateCard))
  router.delete('/:cardId', catchErrors(cardsController.deleteCard))
}
module.exports = setupCardRoutes
