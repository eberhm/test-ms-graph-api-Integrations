import { Inject, Injectable, Logger } from '@nestjs/common';
import { Meeting } from '../../domain/Entities/Meeting';
import { MeetingRepository } from '../../domain/repositories/meeting.repository';
import { MEETING_SYMBOLS } from '../../infrastructure/IoC/Symbols';
import { UpdateMeetingDto } from './updateMeeting.dto';

@Injectable()
export class UpdatemeetingUseCase {
  constructor() {}

  async run(updateJobDto: UpdateMeetingDto) {
    //const meeting = await this.meetingRepository.update(<Meeting>meetingUpdated);
    //Logger.debug(`Response of UpdatemeetingUseCase: ${meeting}`);
    return;
  }
}
