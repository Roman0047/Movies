import BaseSchema from '@ioc:Adonis/Lucid/Schema'

export default class extends BaseSchema {
  protected tableName = 'movies'

  public async up () {
    this.schema.createTable(this.tableName, (table) => {
      table.increments('id').primary()
      table.string('name', 50).unique().notNullable()
      table.string('video').notNullable()
      table.string('image').nullable()
      table.text('description').nullable()
      table.timestamp('release_date').notNullable()
      table.json('countries').notNullable()
      table.integer('company_id').unsigned().references('id').inTable('companies')
      table.integer('type_id').unsigned().references('id').inTable('types')
      table.timestamps(true, true)
    })
  }

  public async down () {
    this.schema.dropTable(this.tableName)
  }
}
