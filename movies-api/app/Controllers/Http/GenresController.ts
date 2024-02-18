import Genre from "App/Models/Genre";
import {HttpContextContract} from "@ioc:Adonis/Core/HttpContext";
import {rules, schema} from "@ioc:Adonis/Core/Validator";

export default class GenresController {
  public async index({ request }: HttpContextContract) {
    const page = request.input('page', 1)
    const limit = request.input('limit')

    if (limit) {
      return await Genre.query().paginate(page, limit);
    } else {
      return Genre.query();
    }
  }

  public async store({ request, response }: HttpContextContract) {
    const newGenreSchema = schema.create({
      name: schema.string({ trim: true }, [
        rules.unique({ table: 'genres', column: 'name', caseInsensitive: true })
      ])
    })

    const messages = {
      'required': '{{field}} is required.',
      'name.unique': 'Genre must be unique'
    }

    const payload = await request.validate({ schema: newGenreSchema, messages })

    const genre = await Genre.create(payload)
    response.status(201)
    return genre
  }

  public async update({ params, request }: HttpContextContract) {
    const newGenreSchema = schema.create({
      name: schema.string({ trim: true }, [
        rules.unique({ table: 'genres', column: 'name', caseInsensitive: true })
      ])
    })

    const messages = {
      'required': '{{field}} is required.',
      'name.unique': 'Genre must be unique'
    }

    const payload = await request.validate({ schema: newGenreSchema, messages })

    const genre = await Genre.findOrFail(params.id)
    genre.merge(payload);
    return genre.save()
  }

  public async destroy({ params, response }: HttpContextContract) {
    const genre = await Genre.findOrFail(params.id)
    try {
      await genre.delete()
      return response.status(204)
    } catch (error) {
      if (error.code?.includes('ER_ROW_IS_REFERENCED')) {
        return response.badRequest({
          message: 'This genre is used in some movies. You should remove this genre from all movies first'
        })
      }
      return error
    }
  }
}
