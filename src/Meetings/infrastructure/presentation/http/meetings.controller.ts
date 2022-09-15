import { Body, Controller, Inject, Param, Patch, Post } from '@nestjs/common';
import { MEETING_SYMBOLS } from '../../IoC/Symbols';
import { CreateMeetingContractBody } from './contracts/createMeeting.dto';
import { UpdateMeetingContractBody } from './contracts/updateMeeting.req';

@Controller('/meeting')
export class MeetingsController {
  constructor(
    @Inject(MEETING_SYMBOLS.CREATE_MEETING_USECASE)
    private readonly createMeetingUseCase,
    @Inject(MEETING_SYMBOLS.UPDATE_MEETING_USECASE)
    private readonly updateMeetingUseCase,
  ) {}

  @Post('/')
  async createMeeting(
    @Body() body: CreateMeetingContractBody,
  ): Promise<any> {
    try {
      // Handshake with the provider
      // Result handshake: campaignId
      // Creamos la primitiva
      //const inviteToApplyDTO = new CreateJobAdDto(body);

      await this.createMeetingUseCase.run(body);

      return;
    } catch (error) {
      throw error;
    }
  }

  @Patch('/:id')
  async updateMeeting(
    @Param() id: string,
    @Body() body: UpdateMeetingContractBody,
  ): Promise<any> {
    try {

      await this.updateMeetingUseCase.run(id, body);

      return;
    } catch (error) {
      throw error;
    }
  }
}
