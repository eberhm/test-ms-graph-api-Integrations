import * as crypto from 'crypto';

export type MeetingPrimitive = {
  jobId: string;
  userId: string;
  externalmeetingId?: string;
  redirectUrl?: string;
  metricsUrl?: string;
  previewUrl?: string;
};

export class Meeting {
  id: string;
  userId: string;
  redirectUrl: URL;
  metricsUrl: URL;
  previewUrl: URL;

  private constructor(meeting: MeetingPrimitive) {
    this.id = crypto.randomUUID();
    this.userId = meeting.userId;
    if (meeting.redirectUrl) {
      this.redirectUrl = new URL(meeting.redirectUrl);
    }
    if (meeting.metricsUrl) {
      this.metricsUrl = new URL(meeting.metricsUrl);
    }
    if (meeting.previewUrl) {
      this.previewUrl = new URL(meeting.previewUrl);
    }
  }

  public static createFromPrimitive(meetingPrimitive: MeetingPrimitive) {
    return new this(meetingPrimitive);
  }
}
