import { Inject, Injectable, Logger } from '@nestjs/common';
import { MeetingRepository } from '../../domain/repositories/meeting.repository';
import { Meeting } from '../../domain/Entities/Meeting';
import { MEETING_SYMBOLS } from '../../infrastructure/IoC/Symbols';

@Injectable()
export class CreateMeetingUseCase {
  constructor(
    @Inject(MEETING_SYMBOLS.MEETING_REPOSITORY)
    private MeetingRepository: MeetingRepository,
  ) {}

  async run(jobId: string) {
    Logger.debug(`CreateMeetingUseCase jobId: ${jobId}`);
   /* let Meeting = Meeting.createFromPrimitive({
      jobId,
      userId,
      status: Statuses.Booking,
      integrator: integrator,
    });

    Meeting = await this.providerServiceFactory
      .getProviderService(integrator)
      .registerMeeting(Meeting);

    Meeting = await this.MeetingRepository.create(Meeting);

    await this.MeetingRelationRepository.registerExternalAdId(
      Meeting.jobId,
      Meeting.externalMeetingId,
      Meeting.integrator,
    );*/

    Logger.debug(`Response of CreateMeetingUseCase: ${Meeting}`);
    return Meeting;
  }
}
