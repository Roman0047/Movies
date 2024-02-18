declare module '@ioc:Adonis/Core/Validator' {
  interface Rules {
    password(password?: string): Rule
  }
}
