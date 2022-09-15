import { Injectable } from '@nestjs/common';
import { Account } from 'src/Authentication/domain/Entities/Account';
import { AccountsRepository } from 'src/Authentication/domain/repositories/accounts.repository';


@Injectable()
export class AccountsInMemoryRepository implements AccountsRepository {
    private accountsCollection: Record<string, Account> = {};

    createOrUpdate(account: Account): Promise<Account> {
        if (!this.accountsCollection[account.id]) {
            this.accountsCollection[account.id] = account;
        } else {
            this.accountsCollection[account.id] = account;
        }
        return Promise.resolve(account);
    }

    get(accountId: string): Promise<Account> {
        if (!this.accountsCollection[accountId])
            return Promise.reject(new Error('Account not found'));
        return Promise.resolve(this.accountsCollection[accountId]);
    }
}
