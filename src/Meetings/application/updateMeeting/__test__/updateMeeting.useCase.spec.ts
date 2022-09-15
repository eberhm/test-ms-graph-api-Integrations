/*import { Test, TestingModule } from '@nestjs/testing';
import { JobAdRepository } from '../../../domain/repositories/meeting.repository';
import { UpdateJobAdUseCase } from '../updateMeeting.useCase';
import { JOB_ADS_SYMBOLS } from '../../../infrastructure/IoC/Symbols';
import { UpdateMeetingDto } from '../updateMeeting.dto';
import { Meeting } from '../../../domain/Entities/Meeting';

describe('UpdateJobAdUseCase', () => {
  let useCase: UpdateJobAdUseCase;
  let repository: JobAdRepository;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UpdateJobAdUseCase,
        {
          provide: JOB_ADS_SYMBOLS.JOB_AD_REPOSITORY,
          useClass: JobAdInMemoryRepository,
        },
        {
          provide: JOB_ADS_SYMBOLS.PROVIDER_SERVICE_FACTORY,
          useClass: ProviderServiceFactory,
        },
      ],
    }).compile();

    useCase = module.get<UpdateJobAdUseCase>(UpdateJobAdUseCase);
    repository = module.get<JobAdInMemoryRepository>(
      JOB_ADS_SYMBOLS.JOB_AD_REPOSITORY,
    );
  });

  it('should have the use case defined', () => {
    expect(useCase).toBeDefined();
  });

  it('update the job ad', async () => {
    await repository.create(
      JobAd.createFromPrimitive({
        jobId: '1',
        userId: '1',
        externalJobAdId: 'ANY_EXTERNAL_JOB_ID',
        redirectUrl: 'https://www.google.com',
        status: Statuses.Booking,
        integrator: Integrators.TalentBait,
      }),
    );

    const jobAdPrimitive: UpdateJobAdDto = {
      externalJobAdId: 'ANY_EXTERNAL_JOB_ID',
      status: Statuses.Active,
      integrator: Integrators.TalentBait,
    };
    const result = await useCase.run(jobAdPrimitive);
    const validationData = await repository.getByExternalIdAndIntegrator(
      result.externalJobAdId,
      result.integrator,
    );
    expect(validationData.jobId).toBe(result.jobId);
    expect(validationData.userId).toBe(result.userId);
    expect(validationData).toStrictEqual(result);
  });
});*/
