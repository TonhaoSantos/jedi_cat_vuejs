'strict'
const express = require('express')
const history = require('connect-history-api-fallback')
const serveStatic = require('serve-static')
const path = require('path')
const port = process.env.PORT || 8080

const app = express()

app.use(history())

app.use('/', serveStatic(path.join(__dirname, '/docs/.vuepress/dist')))

app.get('*', (req, res) => {
  // TODO remover este console depois
  console.log(req)

  res.sendFile(path.join(__dirname, '/dist', '/index.html'))
})

app.listen(port)

console.log('Server started ' + port)
