import {HttpContextContract} from "@ioc:Adonis/Core/HttpContext";
import {schema} from "@ioc:Adonis/Core/Validator";
import Rating from "App/Models/Rating";
import Movie from "App/Models/Movie";
import User from "App/Models/User";

export default class RatingsController {
  public async store({ request, response, auth }: HttpContextContract) {
    const movieId = request.input('movie')
    const newRatingSchema = schema.create({
      rating: schema.number()
    })
    const payload = await request.validate({ schema: newRatingSchema })

    const rating = await Rating.create(payload)

    const movie = await Movie.findOrFail(movieId)
    await rating.related('movie').associate(movie)

    const currentUser = await User.findOrFail(auth.user?.id)
    await rating.related('user').associate(currentUser)

    response.status(201)

    return await Movie.query()
      .where('id', movieId)
      .select('id')
      .withCount('ratings')
      .withCount('ratings', query =>
        query.avg('rating').as('rating')
      )
      .withCount('ratings', query =>
        query.whereIn('user_id', [auth.user?.id]).avg('rating').as('user_rating')
      )
      .firstOrFail()
  }

  public async update({ params, request, auth }: HttpContextContract) {
    const newRatingSchema = schema.create({
      rating: schema.number()
    })
    const payload = await request.validate({ schema: newRatingSchema })

    const rating = await Rating.query().where('movie_id', params.id).where('user_id', auth.user?.id).firstOrFail()
    rating.merge(payload)

    await rating.save()

    return await Movie.query()
      .where('id', params.id)
      .select('id')
      .withCount('ratings')
      .withCount('ratings', query =>
        query.avg('rating').as('rating')
      )
      .withCount('ratings', query =>
        query.whereIn('user_id', [auth.user?.id]).avg('rating').as('user_rating')
      )
      .firstOrFail()
  }
}
