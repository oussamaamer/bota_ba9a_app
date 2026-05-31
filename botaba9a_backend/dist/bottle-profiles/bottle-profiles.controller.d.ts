import { BottleProfilesService } from './bottle-profiles.service';
import { AuthenticatedUser } from '../common/dto/api-response.dto';
import { Request } from 'express';
export declare class BottleProfilesController {
    private readonly bottleProfilesService;
    constructor(bottleProfilesService: BottleProfilesService);
    listProfiles(user: AuthenticatedUser, req: Request): Promise<any[]>;
}
