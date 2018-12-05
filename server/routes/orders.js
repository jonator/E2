const ordersController = require('../controllers/orders')
const { catchErrors } = require('../handlers/errorHandlers')

function setupOrderRoutes(router) {
  // router.get('/', catchErrors(ordersController.getOrders))
  router.get('/', catchErrors(ordersController.getOrders))
  router.get('/totalSales', catchErrors(ordersController.getTotalSales))
  router.get('/totalProfit', catchErrors(ordersController.getTotalProfit))
  router.get('/cardsSoldByCategory', catchErrors(ordersController.getCardsSoldByCategory))
  router.get('/:orderId', catchErrors(ordersController.getOrder))
  router.post('/:userId', catchErrors(ordersController.createOrder))
}

module.exports = setupOrderRoutes
