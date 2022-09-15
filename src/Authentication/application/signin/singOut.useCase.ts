import { Inject, Injectable, Logger } from '@nestjs/common';
import { AuthenticationService } from 'src/Authentication/domain/Services/auth.service';
import { AUTH_SYMBOLS } from 'src/Authentication/infrastructure/IoC/Symbols';

@Injectable()
export class SignOutUseCase {
  constructor(
    @Inject(AUTH_SYMBOLS.TEAMS_AUTH_SERVICE)
    private readonly teamsAuthService: AuthenticationService
  ) {}

  async run(userId: string) {
    try {
      this.teamsAuthService.signOut(userId);

      return { result: 'OK' };
    } catch(error) {
      Logger.error(error);
      return error;
    }
  }
}
