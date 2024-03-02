import Movie from "App/Models/Movie";
import {HttpContextContract} from "@ioc:Adonis/Core/HttpContext";
import {rules, schema} from "@ioc:Adonis/Core/Validator";
import Application from "@ioc:Adonis/Core/Application";
import Company from "App/Models/Company";
import { DateTime } from "luxon";
const nanoid = require('nanoid/async').nanoid

export default class MoviesController {
  public async index({ request }: HttpContextContract) {
    const page = request.input('page', 1)
    const limit = request.input('limit', 6)
    const { search, year, countries, genres, companies, types, director, currentMovie } = request.all()

    const dates = await Movie.query().select('release_date')
    const years = dates
      .map(item => item.serialize())
      .map(item => DateTime.fromISO(item.release_date).year)
      .filter((value, index, array) => array.indexOf(value) === index)

    const date = DateTime.fromISO(year);
    const movies = await Movie.query()
      .if(search, query => query.where('name', 'LIKE',  `%${search}%`))
      .if(year, query =>
        query.whereRaw(`release_date BETWEEN '${date}' and '${date.plus({ year: 1 })}'`)
      )
      .if(countries, query => query.whereJson('countries', countries))
      .if(companies, query => query.whereIn('company_id', companies))
      .if(types, query => query.whereIn('type_id', types))
      .if(currentMovie, query => query.whereNot('id', currentMovie))
      .whereHas('genres', query => {
        query.if(genres, query => query.whereIn('genres.id', genres))
      })
      .whereHas('directors', query => {
        query.if(director, query => query.whereIn('directors.id', [director]))
      })
      .preload('genres')
      .preload('directors')
      .preload('company')
      .preload('type')
      .withCount('ratings')
      .withCount('ratings', query =>
        query.avg('rating').as('rating')
      )
      .paginate(page, limit)

    const moviesData = movies.serialize()
    moviesData.meta.years = years

    return moviesData;
  }

  public async store({ request, response }: HttpContextContract) {
    const newMovieSchema = schema.create({
      video: schema.file({
        extnames: ['mp4', 'avi', 'webm'],
      }),
      image: schema.file.optional({
        size: '2mb',
        extnames: ['jpg', 'png', 'jpeg', 'webp'],
      }),
      name: schema.string({ trim: true }, [
        rules.unique({ table: 'movies', column: 'name', caseInsensitive: true })
      ]),
      description: schema.string.optional({ trim: true }),
      release_date: schema.date(),
      company: schema.string(),
      type: schema.string(),
      directors: schema.array().anyMembers(),
      genres: schema.array().anyMembers(),
      countries: schema.array().anyMembers(),
    })

    const messages = {
      'required': '{{field}} is required.',
      'name.unique': 'Movie name must be unique',
      'videoFile.required': 'Video file is required.',
      'directors.required': 'Director is required.',
      'genres.required': 'Genre is required.',
      'countries.required': 'Country is required.',
    }

    const payload = await request.validate({ schema: newMovieSchema, messages })

    payload.video.clientName = await nanoid()
    await payload.video.move(Application.tmpPath('uploads'))

    if (payload.image) {
      payload.image.clientName = await nanoid()
      await payload.image.move(Application.tmpPath('uploads'))
    }

    const movie = await Movie.create({
      ...payload,
      countries: JSON.stringify(payload.countries),
      video: payload.video.clientName,
      image: payload.image?.clientName,
    })

    const company = await Company.findOrFail(payload.company)
    await movie.related('company').associate(company)

    const type = await Company.findOrFail(payload.type)
    await movie.related('type').associate(type)

    await movie.related('genres').attach(payload.genres)
    await movie.related('directors').attach(payload.directors)

    movie.merge({ release_date: DateTime.fromISO(`${movie.release_date.toISO()}`) })

    response.status(201)
    return movie.save()
  }

  public async show({ params, auth }: HttpContextContract) {
    await auth.use("jwt").authenticate();
    const user = auth.use("jwt").user!

    return await Movie.query()
      .preload('genres')
      .preload('directors')
      .preload('company')
      .preload('type')
      .withCount('ratings')
      .withCount('ratings', query =>
        query.avg('rating').as('rating')
      )
      .if(user, query => {
        query.withCount('ratings', query =>
          query.whereIn('user_id', [user?.id]).avg('rating').as('user_rating')
        )
      })
      .where('id', params.id).firstOrFail()
  }

  public async update({ params, request }: HttpContextContract) {
    const newMovieSchema = schema.create({
      video: schema.file.optional({
        extnames: ['mp4', 'avi', 'webm'],
      }),
      image: schema.file.optional({
        size: '2mb',
        extnames: ['jpg', 'png', 'jpeg', 'webp'],
      }),
      name: schema.string({ trim: true }, [
        rules.unique({
          table: 'movies',
          column: 'name',
          caseInsensitive: true,
          whereNot: { id: params.id }
        })
      ]),
      description: schema.string.optional({ trim: true }),
      release_date: schema.date(),
      company: schema.string(),
      type: schema.string(),
      directors: schema.array().anyMembers(),
      genres: schema.array().anyMembers(),
      countries: schema.array().anyMembers(),
    })

    const messages = {
      'required': '{{field}} is required.',
      'name.unique': 'Movie name must be unique',
      'videoFile.required': 'Video file is required.',
      'directors.required': 'Director is required.',
      'genres.required': 'Genre is required.',
      'countries.required': 'Country is required.',
    }

    const payload = await request.validate({ schema: newMovieSchema, messages })

    if (payload.video) {
      payload.video.clientName = await nanoid()
      await payload.video.move(Application.tmpPath('uploads'))
    }

    if (payload.image) {
      payload.image.clientName = await nanoid()
      await payload.image.move(Application.tmpPath('uploads'))
    }

    const movie = await Movie.findOrFail(params.id)

    movie.merge({
      ...payload,
      release_date: DateTime.fromISO('2011-10-05T14:48:00.000Z'),
      countries: JSON.stringify(payload.countries),
      video: payload.video?.clientName,
      image: payload.image?.clientName,
    })

    const company = await Company.findOrFail(payload.company)
    await movie.related('company').associate(company)

    const type = await Company.findOrFail(payload.type)
    await movie.related('type').associate(type)

    await movie.related('genres').detach()
    await movie.related('genres').attach(payload.genres)
    await movie.related('directors').detach()
    await movie.related('directors').attach(payload.directors)

    return movie.save()
  }

  public async destroy({ params, response }: HttpContextContract) {
    const movie = await Movie.findOrFail(params.id)
    await movie.related('genres').detach()
    await movie.related('directors').detach()
    response.status(204)
    return movie.delete()
  }
}
