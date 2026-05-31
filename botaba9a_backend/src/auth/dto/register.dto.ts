import { IsEmail, IsString, MinLength, IsOptional, IsIn } from 'class-validator';

export class RegisterDto {
  @IsEmail({}, { message: 'Please provide a valid email address' })
  email!: string;

  @IsString()
  @MinLength(8, { message: 'Password must be at least 8 characters' })
  password!: string;

  @IsString({ message: 'Full name is required' })
  @MinLength(2, { message: 'Full name must be at least 2 characters' })
  full_name!: string;

  @IsOptional()
  @IsString()
  phone?: string;

  @IsOptional()
  @IsIn(['admin', 'client', 'technician', 'vendor'], {
    message: 'Role must be one of: admin, client, technician, vendor',
  })
  role?: string;

  @IsOptional()
  @IsString()
  business_name?: string;
}
