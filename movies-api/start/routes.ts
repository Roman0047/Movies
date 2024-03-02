import Route from '@ioc:Adonis/Core/Route'

Route.post('/register/', 'AuthController.register')
Route.post('/login/', 'AuthController.login')
Route.get('/profile/', 'AuthController.getUser')
Route.get('/comments/', 'CommentsController.index')
Route.get('/companies/', 'CompaniesController.index')
Route.get('/genres/', 'GenresController.index')
Route.get('/types/', 'TypesController.index')
Route.get('/directors/', 'DirectorsController.index')
Route.get('/directors/:id', 'DirectorsController.show')
Route.get('/movies/', 'MoviesController.index')
Route.get('/movies/:id', 'MoviesController.show')

Route.group(() => {
  Route.post('/logout/', 'AuthController.logout')
  Route.post('/profile/', 'AuthController.updateUser')
  Route.resource('/ratings/', 'RatingsController')

  Route.post('/comments/', 'CommentsController.store')
  Route.put('/comments/:id', 'CommentsController.update')
  Route.delete('/comments/:id', 'CommentsController.destroy')

  Route.group(() => {
    Route.post('/companies/', 'CompaniesController.store')
    Route.put('/companies/:id', 'CompaniesController.update')
    Route.delete('/companies/:id', 'CompaniesController.destroy')

    Route.post('/genres/', 'GenresController.store')
    Route.put('/genres/:id', 'GenresController.update')
    Route.delete('/genres/:id', 'GenresController.destroy')

    Route.post('/types/', 'TypesController.store')
    Route.put('/types/:id', 'TypesController.update')
    Route.delete('/types/:id', 'TypesController.destroy')

    Route.post('/directors/', 'DirectorsController.store')
    Route.put('/directors/:id', 'DirectorsController.update')
    Route.delete('/directors/:id', 'DirectorsController.destroy')

    Route.post('/movies/', 'MoviesController.store')
    Route.put('/movies/:id', 'MoviesController.update')
    Route.delete('/movies/:id', 'MoviesController.destroy')
  }).middleware('admin')
}).middleware('auth:jwt')
