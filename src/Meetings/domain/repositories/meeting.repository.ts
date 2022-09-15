import { Meeting } from '../Entities/Meeting';

export interface MeetingRepository {
  create(meeting: Meeting): Promise<Meeting>;
  update(meeting: Meeting): Promise<Meeting>;
}
