import { Inject, Injectable, Logger } from '@nestjs/common';
import { AUTH_SYMBOLS } from 'src/Authentication/infrastructure/IoC/Symbols';
import { AuthenticationService, OAuthCodeURLParams } from "src/Authentication/domain/Services/auth.service";

@Injectable()
export class SignInUseCase {
  constructor(
    @Inject(AUTH_SYMBOLS.TEAMS_AUTH_SERVICE)
    private readonly teamsAuthService: AuthenticationService
  ) {}

  async run() {
    const urlParameters: OAuthCodeURLParams = {
      scopes: process.env.OAUTH_SCOPES.split(','),
      redirectUri: process.env.OAUTH_REDIRECT_URI
    };

    try {
      const url = await this.teamsAuthService.getAuthCodeUrl(urlParameters);
      return { url };
    }
    catch (error) {
      Logger.error(error);
      return error;
    }
  }
}
