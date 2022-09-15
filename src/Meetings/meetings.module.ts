import { Module } from '@nestjs/common';
import { MEETING_SYMBOLS } from './infrastructure/IoC/Symbols';
import { CreateMeetingUseCase } from './application/createMeeting/createMeeting.useCase';

@Module({
  imports: [],
  controllers: [],
  providers: [
    {
      provide: MEETING_SYMBOLS.CREATE_MEETING_USECASE,
      useClass: CreateMeetingUseCase,
    },
  ],
})
export class MeetingsModule {}
