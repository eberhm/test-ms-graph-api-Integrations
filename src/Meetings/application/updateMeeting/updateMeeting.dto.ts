export class UpdateMeetingDto {
  externalJobAdId: string;
  metricsUrl?: URL;
  previewUrl?: URL;

  constructor(
    metricsUrl?: URL,
    previewUrl?: URL,
  ) {
    this.metricsUrl = metricsUrl;
    this.previewUrl = previewUrl;
  }
}
