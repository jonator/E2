const db = require('../utils/db')
const knex = require('../knex')

const intId = (req, property) => parseInt(req.params[property], 10)

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
  imageUrl: card.ImageURL,
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
    // console.log(rest)
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
    /* console.log(sameOrderIndex)
    console.log(arr) */
    if (sameOrderIndex < 0) {
      arr.push(rest)
    } else {
      arr[sameOrderIndex].orderLines.push(rest.orderLines[0])
    }
    return arr
  }, [])
  // console.log(consolidatedOrders)
  return consolidatedOrders.map(formatOrder)
}

exports.getOrders = async (req, res) => {
  const dirtyOrders = await knex.exec(`getAllOrders`)
  // console.log(dirtyOrders)

  const orders = formatDIRTYOrders(dirtyOrders)

  // const orders = await db.getOrders()
  if (orders) {
    console.log(orders.length)
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
    return res.json(totalSales)
  }
  res.status(404).send()
}

exports.getTotalProfit = async (req, res) => {
  const totalProfit = (await knex.exec('totalProfit'))[0]
  if (totalProfit) {
    return res.json(totalProfit)
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
  const order = formatDIRTYOrders(dirtyOrders)
  // const order = await db.createOrder(intId(req, 'userId'))
  if (order) {
    return res.json(order)
  }
  return res.status(404).send('User not found or user has no cart items')
}
