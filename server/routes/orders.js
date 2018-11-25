const ordersController = require('../controllers/orders')

function setupOrderRoutes(router) {
  router.get('/', ordersController.getOrders)
  router.get('/totalSales', ordersController.getTotalSales)
  router.get('/cardsSoldByCategory', ordersController.getCardsSoldByCategory)
  router.get('/:orderId', ordersController.getOrder)
}

module.exports = setupOrderRoutes
