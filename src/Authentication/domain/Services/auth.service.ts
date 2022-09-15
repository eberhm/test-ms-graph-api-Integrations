export type OAuthCodeURLParams = {
    scopes: string[];
    redirectUri: string;
};

export type AcquireTokenRequest = {
    scopes: string[];
    redirectUri: string;
    code: string
}

export type AuthResult = {
    id: string;
    userId: string;
    accessToken: string;
    expiresOn: string;
    tenantId: string;
    username: string;
}

export interface AuthenticationService {
    getAuthCodeUrl(urlParameters: OAuthCodeURLParams): Promise<URL>;
    acquireTokenByCode(tokenRequest: AcquireTokenRequest): Promise<AuthResult>;
    signOut(userId: string): Promise<void>;
}
