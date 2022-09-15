/*import { Test, TestingModule } from '@nestjs/testing';
import { JobAdRepository } from '../../../domain/repositories/meeting.repository';
import { CreateJobAdUseCase } from '../createMeeting.useCase';
import { JOB_ADS_SYMBOLS } from '../../../infrastructure/IoC/Symbols';
import { ProviderServiceFactory } from '../../../infrastructure/Services/meeting.service.factory';
import { Integrators } from '../../../domain/Entities/Integrators';
import { JobAdInMemoryRepository } from '../../../infrastructure/repositories/jobAdInMemory.repository';
import { JobAdRelationInMemoryRepository } from '../../../infrastructure/repositories/jobAdRelationInMemory.repository';
import { JobAdRelationRepository } from '../../../domain/repositories/jobAdrelation.repository';

describe('CreateJobAdUseCase', () => {
  let createJobAdUseCase: CreateJobAdUseCase;
  let jobAdRepository: JobAdRepository;
  let jobAdRelationRepository: JobAdRelationRepository;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CreateJobAdUseCase,
        {
          provide: JOB_ADS_SYMBOLS.JOB_AD_REPOSITORY,
          useClass: JobAdInMemoryRepository,
        },
        {
          provide: JOB_ADS_SYMBOLS.JOB_AD_RELATION_REPOSITORY,
          useClass: JobAdRelationInMemoryRepository,
        },
        {
          provide: JOB_ADS_SYMBOLS.PROVIDER_SERVICE_FACTORY,
          useClass: ProviderServiceFactory,
        },
      ],
    }).compile();

    createJobAdUseCase = module.get<CreateJobAdUseCase>(CreateJobAdUseCase);
    jobAdRepository = module.get<JobAdInMemoryRepository>(
      JOB_ADS_SYMBOLS.JOB_AD_REPOSITORY,
    );
    jobAdRelationRepository = module.get<JobAdRelationInMemoryRepository>(
      JOB_ADS_SYMBOLS.JOB_AD_RELATION_REPOSITORY,
    );
  });

  it('should have the use case defined', () => {
    expect(createJobAdUseCase).toBeDefined();
  });

  it('creates the job ad', async () => {
    const ANY_USER_ID = 'userId';
    const ANY_JOB_ID = 'jobId';
    const result = await createJobAdUseCase.run(
      ANY_JOB_ID,
      ANY_USER_ID,
      Integrators.TalentBait,
    );
    const validationData = await jobAdRepository.getByExternalIdAndIntegrator(
      result.externalJobAdId,
      result.integrator,
    );
    const validationRelationData =
      await jobAdRelationRepository.getJobExternalAdId(
        result.jobId,
        result.integrator,
      );
    expect(validationData.jobId).toBe(result.jobId);
    expect(validationData.userId).toBe(result.userId);
    expect(validationRelationData).toBe(validationData.externalJobAdId);
    expect(validationData).toStrictEqual(result);
  });
});*/
