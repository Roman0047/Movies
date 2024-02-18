import {HttpContextContract} from "@ioc:Adonis/Core/HttpContext";
import {rules, schema} from "@ioc:Adonis/Core/Validator";
import User from "App/Models/User";
import Application from "@ioc:Adonis/Core/Application";
const nanoid = require('nanoid/async').nanoid

export default class AuthController {
  public async register({ request, response, auth }: HttpContextContract) {
    const userSchema = schema.create({
      name: schema.string({ trim: true }),
      email: schema.string({ trim: true }, [
        rules.email(),
        rules.unique({ table: 'users', column: 'email', caseInsensitive: true })
      ]),
      password: schema.string({ trim: true }, [
        rules.minLength(8),
        rules.maxLength(16),
        rules.confirmed('repeatPassword')
      ]),
    })

    const messages = {
      'required': '{{field}} is required.',
      'email.email': 'Specify a valid email address.',
      'email.unique': 'User with this email already exists.',
      'password.minLength': 'Password must contain at least {{options.minLength}} characters',
      'password.maxLength': 'Password must not contain more than {{options.maxLength}} characters',
      'repeatPassword.confirmed': 'Password do not match'
    }

    const payload = await request.validate({ schema: userSchema, messages })
    let user = await User.create(payload)

    await auth.use("jwt").login(user)
    const token = await auth.use("jwt").generate(user)

    response.status(201)
    return user.merge({ accessToken: token.accessToken })
  }

  public async login({ request, auth, response }: HttpContextContract) {
    const userSchema = schema.create({
      email: schema.string({ trim: true }, [rules.email()]),
      password: schema.string({ trim: true }),
    })

    const messages = {
      'required': '{{field}} is required.',
      'email.email': 'Email is invalid.'
    }

    const { email, password } = await request.validate({ schema: userSchema, messages })

    try {
      const user = await auth.attempt(email, password)
      const token = await auth.use("jwt").generate(user)

      return user.merge({ accessToken: token.accessToken })
    } catch (error) {
      return response.badRequest({ message: 'Email or password is incorrect.' })
    }
  }

  public async logout({ auth }: HttpContextContract) {
    await auth.use('web').logout()
    return { message: 'Successfully logged out' }
  }

  public async getUser({ auth }: HttpContextContract) {
    await auth.use("jwt").authenticate();
    const user = auth.use("jwt").user!

    delete user.password;
    return user
  }

  public async updateUser({ auth, request }: HttpContextContract) {
    const { currentPassword, password, repeatPassword } = request.body()

    let fields: any = {
      image: schema.file.optional({
        size: '2mb',
        extnames: ['jpg', 'png', 'jpeg', 'webp'],
      }),
      name: schema.string({ trim: true }),
      email: schema.string({ trim: true }, [
        rules.email(),
        rules.unique({ table: 'users', column: 'email', caseInsensitive: true, whereNot: { id: auth.user?.id } })
      ]),
    }

    if (currentPassword || password || repeatPassword) {
      fields = {
        ...fields,
        currentPassword: schema.string({ trim: true }, [
          rules.password(auth.user?.password)
        ]),
        password: schema.string({ trim: true }, [
          rules.minLength(8),
          rules.maxLength(16),
          rules.confirmed('repeatPassword')
        ]),
      }
    }

    const userSchema = schema.create(fields)

    const messages = {
      'required': '{{field}} is required.',
      'email.email': 'Specify a valid email address.',
      'email.unique': 'User with this email already exists.',
      'password.minLength': 'Password must contain at least {{options.minLength}} characters',
      'password.maxLength': 'Password must not contain more than {{options.maxLength}} characters',
      'repeatPassword.confirmed': 'Password do not match'
    }

    const payload = await request.validate({ schema: userSchema, messages })
    delete payload.currentPassword

    if (payload.image) {
      payload.image.clientName = await nanoid()
      await payload.image.move(Application.tmpPath('uploads'))
    }

    const user = await User.findOrFail(auth.user?.id)
    user.merge(payload)
    if (payload.image) {
      user.merge({ image: payload.image.clientName })
    }

    return user.save()
  }
}
