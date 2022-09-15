import { Module } from '@nestjs/common';
import { CallbackUseCase } from './application/signin/callback.useCase';
import { SignInUseCase } from './application/signin/singIn.useCase';
import { SignOutUseCase } from './application/signin/singOut.useCase';
import { AUTH_SYMBOLS } from './infrastructure/IoC/Symbols';
import { AuthController } from './infrastructure/presentation/http/auth.controller';
import { AccountsInMemoryRepository } from './infrastructure/repositories/accountsInMemory.repository';
import { TeamsAuthenticationService } from './infrastructure/Services/authentication.service';


@Module({
  imports: [],
  controllers: [AuthController],
  providers: [
    {
      provide: AUTH_SYMBOLS.SIGN_IN_USECASE,
      useClass: SignInUseCase,
    },
    {
      provide: AUTH_SYMBOLS.CALLBACK_USECASE,
      useClass: CallbackUseCase,
    },
    {
      provide: AUTH_SYMBOLS.SIGN_OUT_USECASE,
      useClass: SignOutUseCase,
    },
    {
      provide: AUTH_SYMBOLS.TEAMS_AUTH_SERVICE,
      useClass: TeamsAuthenticationService
    },
    {
      provide: AUTH_SYMBOLS.ACCOUNT_REPOSITORY,
      useClass: AccountsInMemoryRepository
    }

  ],
})
export class AuthenticationModule {}
