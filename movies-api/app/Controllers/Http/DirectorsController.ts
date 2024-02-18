import {HttpContextContract} from "@ioc:Adonis/Core/HttpContext";
import {rules, schema} from "@ioc:Adonis/Core/Validator";
import Director from "App/Models/Director";
import Application from "@ioc:Adonis/Core/Application";
const nanoid = require('nanoid/async').nanoid

export default class DirectorsController {
  public async index({ request }: HttpContextContract) {
    const page = request.input('page', 1)
    const limit = request.input('limit')

    if (limit) {
      return await Director.query().paginate(page, limit);
    } else {
      return Director.query();
    }
  }

  public async store({ request, response }: HttpContextContract) {
    const newDirectorSchema = schema.create({
      image: schema.file.optional({
        size: '2mb',
        extnames: ['jpg', 'png', 'jpeg', 'webp'],
      }),
      name: schema.string({ trim: true }, [
        rules.unique({ table: 'directors', column: 'name', caseInsensitive: true })
      ]),
      bio: schema.string.optional({ trim: true }),
      rewards: schema.string({ trim: true }),
    })

    const messages = {
      'required': '{{field}} is required.',
      'name.unique': 'Director name must be unique'
    }

    const payload = await request.validate({ schema: newDirectorSchema, messages })

    if (payload.image) {
      payload.image.clientName = await nanoid()
      await payload.image.move(Application.tmpPath('uploads'))
    }

    const director = await Director.create({
      ...payload,
      image: payload.image?.clientName
    })

    response.status(201)
    return director
  }

  public async show({ params }: HttpContextContract) {
    return Director.findOrFail(params.id)
  }

  public async update({ params, request }: HttpContextContract) {
    const newDirectorSchema = schema.create({
      image: schema.file.optional({
        size: '2mb',
        extnames: ['jpg', 'png', 'jpeg', 'webp'],
      }),
      name: schema.string({ trim: true }, [
        rules.unique({
          table: 'directors',
          column: 'name',
          caseInsensitive: true,
          whereNot: { id: params.id }
        })
      ]),
      bio: schema.string.optional({ trim: true }),
      rewards: schema.string({ trim: true }),
    })

    const messages = {
      'required': '{{field}} is required.',
      'name.unique': 'Director name must be unique'
    }

    const payload = await request.validate({ schema: newDirectorSchema, messages })

    if (payload.image) {
      payload.image.clientName = await nanoid()
      await payload.image.move(Application.tmpPath('uploads'))
    }

    const director = await Director.findOrFail(params.id)
    director.merge({
      ...payload,
      image: payload.image?.clientName
    });
    return director.save()
  }

  public async destroy({ params, response }: HttpContextContract) {
    const director = await Director.findOrFail(params.id)
    try {
      await director.delete()
      return response.status(204)
    } catch (error) {
      if (error.code?.includes('ER_ROW_IS_REFERENCED')) {
        return response.badRequest({
          message: 'This director is used in some movies. You should remove this director from all movies first'
        })
      }
      return error
    }
  }
}
