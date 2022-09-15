import { Controller, Inject, Query, Get } from '@nestjs/common';
import { AUTH_SYMBOLS } from '../../IoC/Symbols';

@Controller('/auth')
export class AuthController {
  constructor(
    @Inject(AUTH_SYMBOLS.SIGN_IN_USECASE)
    private readonly signInUseCase,
    @Inject(AUTH_SYMBOLS.CALLBACK_USECASE)
    private readonly callbackUseCase,
    @Inject(AUTH_SYMBOLS.SIGN_OUT_USECASE)
    private readonly signOutUseCase
  ) {}
  
  @Get('/signin')
  async signIn( ): Promise<any> {
    try {
      return await this.signInUseCase.run();
    } catch (error) {
      throw error;
    }
  }

  @Get('/callback')
  async callback(
    @Query() query: { code: string }
  ): Promise<any> {
    try {
      return await this.callbackUseCase.run(query.code);
    } catch (error) {
      throw error;
    }
  }

  @Get('/signout')
  async signout(
    @Query() query: { userId: string }
  ) {
    try {
      return await this.signOutUseCase.run(query.userId);
    } catch (error) {
      throw error;
    }
  }
}


