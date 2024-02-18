import { DateTime } from 'luxon'
import {BaseModel, column, ManyToMany, manyToMany} from '@ioc:Adonis/Lucid/Orm'
import Movie from "App/Models/Movie";

export default class Director extends BaseModel {
  @column({ isPrimary: true })
  public id: number

  @column()
  public name: string

  @column()
  public image?: string

  @column()
  public bio: string

  @column()
  public rewards: string

  @column.dateTime({ autoCreate: true })
  public createdAt: DateTime

  @column.dateTime({ autoCreate: true, autoUpdate: true })
  public updatedAt: DateTime

  @manyToMany(() => Movie, { pivotTable: 'movies_directors' })
  public movies: ManyToMany<typeof Movie>
}
