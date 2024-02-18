import {HttpContextContract} from "@ioc:Adonis/Core/HttpContext";
import {rules, schema} from "@ioc:Adonis/Core/Validator";
import Type from "App/Models/Type";

export default class TypesController {
  public async index({ request }: HttpContextContract) {
    const page = request.input('page', 1)
    const limit = request.input('limit')

    if (limit) {
      return await Type.query().paginate(page, limit);
    } else {
      return Type.query();
    }
  }

  public async store({ request, response }: HttpContextContract) {
    const newTypeSchema = schema.create({
      name: schema.string({ trim: true }, [
        rules.unique({ table: 'types', column: 'name', caseInsensitive: true })
      ])
    })

    const messages = {
      'required': '{{field}} is required.',
      'name.unique': 'Type must be unique'
    }

    const payload = await request.validate({ schema: newTypeSchema, messages })

    const type = await Type.create(payload)
    response.status(201)
    return type
  }

  public async update({ params, request }: HttpContextContract) {
    const newTypeSchema = schema.create({
      name: schema.string({ trim: true }, [
        rules.unique({ table: 'types', column: 'name', caseInsensitive: true })
      ])
    })

    const messages = {
      'required': '{{field}} is required.',
      'name.unique': 'Type must be unique'
    }

    const payload = await request.validate({ schema: newTypeSchema, messages })

    const type = await Type.findOrFail(params.id)
    type.merge(payload);
    return type.save()
  }

  public async destroy({ params, response }: HttpContextContract) {
    const type = await Type.findOrFail(params.id)
    try {
      await type.delete()
      return response.status(204)
    } catch (error) {
      if (error.code?.includes('ER_ROW_IS_REFERENCED')) {
        return response.badRequest({
          message: 'This type is used in some movies. You should remove this type from all movies first'
        })
      }
      return error
    }
  }
}
