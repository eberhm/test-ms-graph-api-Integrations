import { MeetingPrimitive } from '../../domain/Entities/Meeting';

export class CreateMeetingDto {
  MeetingPrimitive: MeetingPrimitive;

  constructor(MeetingPrimitive: MeetingPrimitive) {
    this.MeetingPrimitive = MeetingPrimitive;
  }
}
