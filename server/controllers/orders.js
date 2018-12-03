const db = require('../utils/db')

const intId = (req, property) => parseInt(req.params[property], 10)

exports.getOrders = async (req, res) => {
  const orders = await db.getOrders()
  if (orders) {
    return res.json(orders)
  }
  return res.status(404).send()
}

exports.getOrder = async (req, res) => {
  const order = await db.getOrder(intId(req, 'orderId'))
  if (order) {
    return res.json(order)
  }
  return res.status(404).send()
}

exports.getTotalSales = async (req, res) => {
  const totalSales = await db.getTotalSales()
  if (totalSales) {
    return res.json({ total: totalSales })
  }
  res.status(404).send()
}

exports.getTotalProfit = async (req, res) => {
  const totalProfit = await db.getTotalProfit()
  if (totalProfit) {
    return res.json({ total: totalProfit })
  }
  res.status(404).send()
}

exports.getCardsSoldByCategory = async (req, res) => {
  const cardsSoldByCategory = await db.getCardsSoldByCategory()
  if (cardsSoldByCategory) {
    return res.json(cardsSoldByCategory)
  }
  return res.status(404).send()
}

exports.createOrder = async (req, res) => {
  const order = await db.createOrder(intId(req, 'userId'))
  if (order) {
    return res.json(order)
  }
  return res.status(404).send('User not found or user has no cart items')
}
