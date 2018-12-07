const db = require('../utils/db')
const knex = require('../knex')

const intId = (req, property) => parseInt(req.params[property], 10)
const decodeImage = url => url.replace('AlexLovesBrianna', '?')

const formatUser = user => ({
  userId: user.UserID,
  firstName: user.FirstName,
  lastName: user.LastName,
  email: user.Email,
  isAdmin: user.IsAdmin,
})

const formatCard = card => ({
  cardId: card.CardID,
  title: card.Title,
  imageUrl: decodeImage(card.ImageURL),
  price: card.Price,
  costToProduce: card.CostToProduce,
  category: card.Category,
})

const formatOrderLines = orderLines =>
  orderLines.map(orderLine => ({
    orderLineId: orderLine.OrderLineID,
    card: formatCard(orderLine),
    quantity: orderLine.Quantity,
  }))

const formatOrder = order => ({
  orderId: order.OrderID,
  user: formatUser(order),
  orderLines: formatOrderLines(order.orderLines),
  orderDate: order.OrderDate,
})

const formatDIRTYOrders = dirtyOrders => {
  const consolidatedOrders = dirtyOrders.reduce((arr, order) => {
    const { OrderLineID, CardID, Title, ImageURL, Price, CostToProduce, Category, Quantity, ...rest } = order
    rest.orderLines = [
      {
        OrderLineID,
        CardID,
        Title,
        ImageURL,
        Price,
        CostToProduce,
        Category,
        Quantity,
      },
    ]
    const sameOrderIndex = arr.findIndex(o => o.OrderID === order.OrderID)
    if (sameOrderIndex < 0) {
      arr.push(rest)
    } else {
      arr[sameOrderIndex].orderLines.push(rest.orderLines[0])
    }
    return arr
  }, [])
  return consolidatedOrders.map(formatOrder)
}

exports.getOrders = async (req, res) => {
  const dirtyOrders = await knex.exec(`getAllOrders`)

  const orders = formatDIRTYOrders(dirtyOrders)

  // const orders = await db.getOrders()
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
  const totalSales = (await knex.exec('totalSales'))[0]
  if (totalSales) {
    const dollars = totalSales
    return res.json(dollars)
  }
  res.status(404).send()
}

exports.getTotalProfit = async (req, res) => {
  const totalProfit = (await knex.exec('totalProfit'))[0]
  if (totalProfit) {
    const dollars = totalProfit
    return res.json(dollars)
  }
  res.status(404).send()
}

const formatCat = cat => ({
  category: cat.Category,
  quantity: cat.Quantity,
})

exports.getCardsSoldByCategory = async (req, res) => {
  const dirtyCardsSoldByCategory = await knex.exec('cardsSoldByCategory')
  const cardsSoldByCategory = dirtyCardsSoldByCategory.map(formatCat)
  if (cardsSoldByCategory) {
    return res.json(cardsSoldByCategory)
  }
  return res.status(404).send()
}

exports.createOrder = async (req, res) => {
  const dirtyOrders = await knex.exec(`createOrder @UserId = ${intId(req, 'userId')}`)
  const order = formatDIRTYOrders(dirtyOrders)[0]
  // const order = await db.createOrder(intId(req, 'userId'))
  if (order) {
    return res.json(order)
  }
  return res.status(400).send('User has no cart items')
}
