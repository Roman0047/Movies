import type { HttpContextContract } from '@ioc:Adonis/Core/HttpContext'
import { AuthenticationException } from '@adonisjs/auth/build/standalone'

export default class AdminMiddleware {
  protected async check(auth: HttpContextContract['auth']) {
    if (auth.user && auth.user.role === 'admin') {
      return true
    }
    throw new AuthenticationException('Only the admin has access to this operation', 'E_UNAUTHORIZED_ACCESS')
  }

  public async handle (
    { auth }: HttpContextContract,
    next: () => Promise<void>
  ) {
    await this.check(auth)
    await next()
  }
}
