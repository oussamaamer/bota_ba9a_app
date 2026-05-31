import { IsInt, Min, IsOptional, IsString, IsIn, IsDateString } from 'class-validator';

export class CreateReadingDto {
  @IsInt({ message: 'Weight must be an integer (grams)' })
  @Min(0, { message: 'Weight cannot be negative' })
  weight_grams!: number;

  @IsOptional()
  @IsIn(['ble', 'wifi', 'sync', 'manual'], {
    message: 'Source must be one of: ble, wifi, sync, manual',
  })
  source?: string;

  @IsOptional()
  @IsDateString({}, { message: 'Invalid date format for recorded_at' })
  recorded_at?: string;
}
