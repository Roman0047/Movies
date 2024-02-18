import { validator } from '@ioc:Adonis/Core/Validator'
import Hash from "@ioc:Adonis/Core/Hash";

validator.rule('password', async (value, [password], options) => {
  if (typeof value !== 'string') {
    return
  }

  const isValidPassword = await Hash.verify(password || '', value)

  if (!isValidPassword) {
    options.errorReporter.report(
      options.pointer,
      'password',
      'Invalid current password',
      options.arrayExpressionPointer
    )
  }
}, () => ({ async: true }))
