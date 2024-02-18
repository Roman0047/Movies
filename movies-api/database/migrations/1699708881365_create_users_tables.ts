import BaseSchema from '@ioc:Adonis/Lucid/Schema'
import Role from "Contracts/Enums/Role";

export default class extends BaseSchema {
  protected tableName = 'users'

  public async up () {
    this.schema.createTable(this.tableName, (table) => {
      table.increments('id').primary()
      table.string('name', 50).notNullable()
      table.string('image').nullable()
      table.string('role', 50).defaultTo(Role.USER).notNullable()
      table.string('email', 255).unique().notNullable()
      table.string('password', 180).notNullable()
      table.timestamps(true, true)
    })
  }

  public async down () {
    this.schema.dropTable(this.tableName)
  }
}
