import { IsString, ValidateNested } from 'class-validator';

export class UpdateMeetingContractBody {
  @IsString()
  startDate: URL;

  @IsString()
  endDate: URL;

  attendes: string[];
}

export class UpdateMeetingContract {
  @ValidateNested()
  body: UpdateMeetingContractBody;
}
