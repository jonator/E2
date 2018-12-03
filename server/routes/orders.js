const ordersController = require('../controllers/orders')

function setupOrderRoutes(router) {
  router.get('/', ordersController.getOrders)
  router.get('/totalSales', ordersController.getTotalSales)
  router.get('/totalProfit', ordersController.getTotalProfit)
  router.get('/cardsSoldByCategory', ordersController.getCardsSoldByCategory)
  router.get('/:orderId', ordersController.getOrder)
  router.post('/:userId', ordersController.createOrder)
}

module.exports = setupOrderRoutes
