import { Inject, Injectable, Logger } from '@nestjs/common';
import { MeetingRepository } from '../../domain/repositories/meeting.repository';
import { Meeting } from '../../domain/Entities/Meeting';
import { MEETING_SYMBOLS } from '../../infrastructure/IoC/Symbols';

@Injectable()
export class GetMeetingUseCase {
  constructor(
    @Inject(MEETING_SYMBOLS.MEETING_REPOSITORY)
    private MeetingRepository: MeetingRepository,
  ) {}

  async run(jobId: string, userId: string) {
    Logger.debug(`GetMeetingUseCase jobId: ${jobId}, userId: ${userId}`);

    //TODO: Call to user repository to know which integrations has this user active

    const Meetings = new Array<Meeting>();

    Logger.debug(`Response of GetMeetingUseCase: ${Meetings}`);
    return Meetings;
  }
}
