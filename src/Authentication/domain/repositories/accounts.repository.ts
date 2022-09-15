import { Account } from '../Entities/Account';

export interface AccountsRepository {
  createOrUpdate(account: Account): Promise<Account>;
  get(accountId: string): Promise<Account>;
}