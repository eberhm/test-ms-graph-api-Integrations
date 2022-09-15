export interface HttpRequester {
  get<T>(url: URL): Promise<T>;
}
