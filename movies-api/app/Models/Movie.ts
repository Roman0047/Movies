import { DateTime } from 'luxon'
import {BaseModel, BelongsTo, belongsTo, column, ManyToMany, manyToMany, HasMany, computed} from '@ioc:Adonis/Lucid/Orm'
import Director from "App/Models/Director";
import Genre from "App/Models/Genre";
import Type from "App/Models/Type";
import Company from "App/Models/Company";
import {hasMany} from "@adonisjs/lucid/build/src/Orm/Decorators";
import Rating from "App/Models/Rating";

export default class Movie extends BaseModel {
  @column({ isPrimary: true })
  public id: number

  @column()
  public name: string

  @column()
  public video: string

  @column()
  public typeId: number

  @column()
  public companyId: number

  @column()
  public image: string

  @column()
  public description: string

  @column()
  public countries: string

  @column.dateTime()
  public release_date: DateTime

  @column.dateTime({ autoCreate: true })
  public createdAt: DateTime

  @column.dateTime({ autoCreate: true, autoUpdate: true })
  public updatedAt: DateTime

  @manyToMany(() => Director, { pivotTable: 'movies_directors' })
  public directors: ManyToMany<typeof Director>

  @manyToMany(() => Genre, { pivotTable: 'movies_genres' })
  public genres: ManyToMany<typeof Genre>

  @hasMany(() => Rating)
  public ratings: HasMany<typeof Rating>

  @belongsTo(() => Type)
  public type: BelongsTo<typeof Type>

  @belongsTo(() => Company)
  public company: BelongsTo<typeof Company>

  @computed()
  public get ratingsCount() {
    return this.$extras.ratings_count
  }

  @computed()
  public get rating() {
    return this.$extras.rating ? parseFloat(parseFloat(this.$extras.rating).toFixed(1)) : null
  }

  @computed()
  public get userRating() {
    return this.$extras.rating ? parseFloat(this.$extras.user_rating) : null
  }
}
