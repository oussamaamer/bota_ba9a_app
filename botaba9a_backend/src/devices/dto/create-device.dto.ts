import { IsString, IsOptional, IsUUID } from 'class-validator';

export class CreateDeviceDto {
  @IsString({ message: 'ESP32 device ID is required' })
  esp32_id!: string;

  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsString()
  location?: string;

  @IsOptional()
  @IsUUID('4', { message: 'Invalid bottle profile ID' })
  bottle_profile_id?: string;
}
