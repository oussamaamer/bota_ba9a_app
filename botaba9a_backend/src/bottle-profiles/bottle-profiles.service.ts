import { Injectable, Logger } from '@nestjs/common';
import { createAnonClient } from '../common/config/supabase.config';

@Injectable()
export class BottleProfilesService {
  private readonly logger = new Logger(BottleProfilesService.name);

  /**
   * List all bottle profiles visible to the user.
   * This includes public (system) profiles and the user's own custom profiles.
   */
  async listProfiles(userId: string, accessToken: string) {
    const supabase = createAnonClient(accessToken);

    const { data, error } = await supabase
      .from('bottle_profiles')
      .select('*')
      .or(`is_public.eq.true,created_by.eq.${userId}`)
      .order('name', { ascending: true });

    if (error) {
      this.logger.error(`List bottle profiles failed: ${error.message}`);
      return [];
    }

    return data || [];
  }
}
