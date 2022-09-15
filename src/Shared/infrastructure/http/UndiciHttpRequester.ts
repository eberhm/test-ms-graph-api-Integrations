import { HttpRequester } from '../../domain/http/HttpRequester';
import { request } from 'undici';

export class UndiciHttpRequester implements HttpRequester {
  async get<T>(url: URL): Promise<T> {
    const { statusCode, headers, body } = await request(url);

    return {
      statusCode,
      headers,
      body,
    } as unknown as T;
  }
}
