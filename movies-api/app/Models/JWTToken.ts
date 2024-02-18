import {BaseModel, BelongsTo, belongsTo, column} from "@ioc:Adonis/Lucid/Orm";
import User from "App/Models/User";

export default class JWTToken extends BaseModel {
  @column({ isPrimary: true })
  public id: number

  @column()
  public userId: number

  @column()
  public token: string

  @belongsTo(() => User)
  public user: BelongsTo<typeof User>
}
