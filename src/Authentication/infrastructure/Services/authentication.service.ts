import { AcquireTokenRequest, AuthenticationService, AuthResult, OAuthCodeURLParams } from "src/Authentication/domain/Services/auth.service";
import { ConfidentialClientApplication, Configuration, LogLevel } from "@azure/msal-node";
import { Injectable } from '@nestjs/common';

@Injectable()
export class TeamsAuthenticationService implements AuthenticationService {
  private credential: ConfidentialClientApplication;

  async acquireTokenByCode(tokenRequest: AcquireTokenRequest): Promise<AuthResult> {
    const response = await this.getCredentials().acquireTokenByCode(tokenRequest);

    console.log('my repsonse', response);

    const result: AuthResult = {
      accessToken: response.accessToken,
      expiresOn: response.expiresOn.toISOString(),
      id: response.account.homeAccountId,
      tenantId: response.account.tenantId,
      userId: response.account.localAccountId,
      username: response.account.username
    };

    return result;
  }

  async signOut(userId: string): Promise<void> {
    const msalClient = this.getCredentials();
    const accounts = await msalClient.getTokenCache().getAllAccounts();

    const userAccount = accounts.find(a => a.homeAccountId === userId);

    // Remove the account
    if (userAccount) {
      await msalClient
        .getTokenCache()
        .removeAccount(userAccount);
    }
  }

  getAuthCodeUrl(urlParameters: OAuthCodeURLParams): Promise<URL> {
    return this.getCredentials()
      .getAuthCodeUrl(urlParameters)
      .then((url) => new URL(url));
  }

  private getCredentials() {
    if (!this.credential) {
      this.credential = new ConfidentialClientApplication({
        auth: {
          clientId: process.env.OAUTH_CLIENT_ID,
          authority: process.env.OAUTH_AUTHORITY,
          clientSecret: process.env.OAUTH_CLIENT_SECRET
        },
        system: {
          loggerOptions: {
            loggerCallback(loglevel, message, containsPii) {
              console.log(message);
            },
            piiLoggingEnabled: false,
            logLevel: LogLevel.Verbose,
          }
        }
      }
      );
    }

    return this.credential;
  }

  /*
  getAuthenticationClient(): Promise<Client> {          
      const authProvider = new TokenCredentialAuthenticationProvider(this.credential, {
        scopes: process.env.OAUTH_SCOPES.split(','),
      });
        // Initialize Graph client
        const client = Client.init({ authProvider: authProvider.getAccessToken });
          // Implement an auth provider that gets a token
          // from the app's MSAL instance
        return Promise.resolve(client);
  }
  */

}
