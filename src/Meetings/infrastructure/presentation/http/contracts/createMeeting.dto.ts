import { IsString, ValidateNested } from 'class-validator';

export class CreateMeetingContractBody {
  @IsString()
  startDate: URL;

  @IsString()
  endDate: URL;

  attendes: string[];
}

export class CreateMeetingContract {
  @ValidateNested()
  body: CreateMeetingContractBody;
}
