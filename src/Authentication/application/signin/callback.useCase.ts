import { Inject, Injectable, Logger } from '@nestjs/common';
import { Account } from 'src/Authentication/domain/Entities/Account';
import { AcquireTokenRequest } from 'src/Authentication/domain/Services/auth.service';
import { AUTH_SYMBOLS } from 'src/Authentication/infrastructure/IoC/Symbols';
import { TeamsAuthenticationService } from 'src/Authentication/infrastructure/Services/authentication.service';

@Injectable()
export class CallbackUseCase {
  constructor(
    @Inject(AUTH_SYMBOLS.TEAMS_AUTH_SERVICE)
    private readonly teamsAuthService: TeamsAuthenticationService,
    @Inject(AUTH_SYMBOLS.ACCOUNT_REPOSITORY)
    private readonly accountInMemoryRepository
  ) {}

  async run(code: string) { 
    const tokenRequest: AcquireTokenRequest = {
      code: code,
      scopes: process.env.OAUTH_SCOPES.split(','),
      redirectUri: process.env.OAUTH_REDIRECT_URI
    };

    try {
      const response = await this.teamsAuthService.acquireTokenByCode(tokenRequest);

      Logger.log({response});

      if(response) {
        const account = new Account();
        account.accessToken = response.accessToken;
        account.expiresOn = response.expiresOn;
        account.id = response.id;
        account.tenantId = response.tenantId;
        account.userId = response.userId;
        account.username = response.username;
        
        return this.accountInMemoryRepository.createOrUpdate(account);
      }

      return {error: 'invalid response'};
    } catch (error) {
      Logger.error(error);
      return {error: 'invalid response'};
    }  
  }
}
