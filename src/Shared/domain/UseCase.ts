export interface UseCase<Response> {
  run(...args: unknown[]): Promise<Response> | Response;
}
