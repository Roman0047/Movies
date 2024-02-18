import Company from "App/Models/Company";
import {HttpContextContract} from "@ioc:Adonis/Core/HttpContext";
import {rules, schema} from "@ioc:Adonis/Core/Validator";

export default class CompaniesController {
  public async index({ request }: HttpContextContract) {
    const page = request.input('page', 1)
    const limit = request.input('limit')

    if (limit) {
      return await Company.query().paginate(page, limit);
    } else {
      return Company.query();
    }
  }

  public async store({ request, response }: HttpContextContract) {
    const newCompanySchema = schema.create({
      name: schema.string({ trim: true }, [
        rules.unique({ table: 'companies', column: 'name', caseInsensitive: true })
      ])
    })

    const messages = {
      'required': '{{field}} is required.',
      'name.unique': 'Company must be unique'
    }

    const payload = await request.validate({ schema: newCompanySchema, messages })

    const company = await Company.create(payload)
    response.status(201)
    return company
  }

  public async update({ params, request }: HttpContextContract) {
    const newCompanySchema = schema.create({
      name: schema.string({ trim: true }, [
        rules.unique({ table: 'companies', column: 'name', caseInsensitive: true })
      ])
    })

    const messages = {
      'required': '{{field}} is required.',
      'name.unique': 'Company must be unique'
    }

    const payload = await request.validate({ schema: newCompanySchema, messages })

    const company = await Company.findOrFail(params.id)
    company.merge(payload);
    return company.save()
  }

  public async destroy({ params, response }: HttpContextContract) {
    const company = await Company.findOrFail(params.id)
    try {
      await company.delete()
      return response.status(204)
    } catch (error) {
      if (error.code?.includes('ER_ROW_IS_REFERENCED')) {
        return response.badRequest({
          message: 'This company is used in some movies. You should remove this company from all movies first'
        })
      }
      return error
    }
  }
}
