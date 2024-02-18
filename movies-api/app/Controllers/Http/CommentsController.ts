import Comment from "App/Models/Comment";
import {HttpContextContract} from "@ioc:Adonis/Core/HttpContext";
import {schema} from "@ioc:Adonis/Core/Validator";
import Movie from "App/Models/Movie";
import User from "App/Models/User";

export default class CommentsController {
  public async index({ request }: HttpContextContract) {
    const movie = request.input('movie')
    return Comment.query().where('movie_id', movie).preload('user');
  }

  public async store({ request, response, auth }: HttpContextContract) {
    const movieId = request.input('movie')
    const newCommentSchema = schema.create({
      comment: schema.string({ trim: true })
    })
    const payload = await request.validate({ schema: newCommentSchema })

    const comment = await Comment.create(payload)

    const movie = await Movie.findOrFail(movieId)
    await comment.related('movie').associate(movie)

    const currentUser = await User.findOrFail(auth.user?.id)
    await comment.related('user').associate(currentUser)

    response.status(201)
    return comment
  }

  public async update({ params, request }: HttpContextContract) {
    const newCommentSchema = schema.create({
      comment: schema.string({ trim: true })
    })
    const payload = await request.validate({ schema: newCommentSchema })

    const comment = await Comment.findOrFail(params.id)
    comment.merge(payload)
    return comment.save()
  }

  public async destroy({ params, response }: HttpContextContract) {
    const comment = await Comment.findOrFail(params.id)
    response.status(204)
    return comment.delete()
  }
}
