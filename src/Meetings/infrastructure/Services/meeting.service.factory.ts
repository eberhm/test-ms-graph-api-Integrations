import { Injectable } from '@nestjs/common';
import { Meeting } from 'src/Meetings/domain/Entities/Meeting';
import { MeetingService } from 'src/Meetings/domain/Services/meeting.service';

@Injectable()
export class OnlineMeetingService implements MeetingService {
  updateMeeting(id: string): Promise<Meeting[]> {
    throw new Error('Method not implemented.');
  }
  createMeeting(meeting: Meeting): Promise<Meeting> {
    if (!meeting.userId) {
      return Promise.reject('User and job are mandatory');
    }

    //TODO: Real communication with MSTeams

    meeting.redirectUrl = new URL('https://google.com');

    return Promise.resolve(meeting);
  }

  getMeeting(jobId: string, userId: string): Promise<Array<Meeting>> {
    const meetings: Array<Meeting> = [];

    meetings.push(
      Meeting.createFromPrimitive({
        jobId: jobId,
        userId: userId,
        redirectUrl: 'https://www.google.com',
      }),
    );

    return Promise.resolve(meetings);
  }
}
