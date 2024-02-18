import { DateTime } from 'luxon'
import {BaseModel, beforeSave, column, HasOne, hasOne} from '@ioc:Adonis/Lucid/Orm'
import Hash from "@ioc:Adonis/Core/Hash";
import Role from "Contracts/Enums/Role";
import JWTToken from "App/Models/JWTToken";

export default class User extends BaseModel {
  @column({ isPrimary: true })
  public id: number

  @column()
  public name: string

  @column()
  public image?: string

  @column()
  public email: string

  @column({ serializeAs: null })
  public password: string

  @column()
  public accessToken: string

  @column()
  public role: Role

  @column.dateTime({ autoCreate: true })
  public createdAt: DateTime

  @column.dateTime({ autoCreate: true, autoUpdate: true })
  public updatedAt: DateTime

  @hasOne(() => JWTToken)
  public jwt_token: HasOne<typeof JWTToken>

  @beforeSave()
  public static async hashPassword(user: User) {
    if (user.$dirty.password) {
      user.password = await Hash.make(user.password)
    }
  }
}
