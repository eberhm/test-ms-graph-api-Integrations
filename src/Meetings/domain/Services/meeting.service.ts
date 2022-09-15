import { Meeting } from '../Entities/Meeting';

export interface MeetingService {
  createMeeting(meeting: Meeting): Promise<Meeting>;
  updateMeeting(id: string): Promise<Array<Meeting>>;
}
