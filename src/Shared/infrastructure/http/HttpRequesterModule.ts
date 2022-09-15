import { Global, Module } from '@nestjs/common';
import { SHARED_SYMBOLS } from '../IoC/Symbols';
import { UndiciHttpRequester } from './UndiciHttpRequester';

const providers = [
  {
    provide: SHARED_SYMBOLS.HTTP_REQUESTER,
    useClass: UndiciHttpRequester,
  },
];

@Global()
@Module({
  providers,
  exports: providers,
})
export class HttpRequesterModule {}
