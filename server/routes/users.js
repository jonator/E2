const usersController = require('../controllers/users')
const { catchErrors } = require('../handlers/errorHandlers')

function setupUserRoutes(router) {
  router.get('/authenticate/:email/:password', catchErrors(usersController.authenticateUser))

  router.get('/cartItems/', catchErrors(usersController.getCartItems))
  router.get('/cartItems/:userId', catchErrors(usersController.getCartItems))
  router.delete('/cartItems/:userId', catchErrors(usersController.deleteCartItems))
  router.delete('/cartItems/:userId/:cardId', catchErrors(usersController.deleteCartItem))
  router.post('/cartItems', catchErrors(usersController.createCartItem))
  router.put('/cartItems', catchErrors(usersController.updateCartItem))

  router.get('/:userId', catchErrors(usersController.getUser))
  router.get('/', catchErrors(usersController.getUsers))
  router.post('/', catchErrors(usersController.createUser))
}

module.exports = setupUserRoutes
