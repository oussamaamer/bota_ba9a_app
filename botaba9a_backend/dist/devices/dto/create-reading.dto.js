"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CreateReadingDto = void 0;
const class_validator_1 = require("class-validator");
class CreateReadingDto {
}
exports.CreateReadingDto = CreateReadingDto;
__decorate([
    (0, class_validator_1.IsInt)({ message: 'Weight must be an integer (grams)' }),
    (0, class_validator_1.Min)(0, { message: 'Weight cannot be negative' }),
    __metadata("design:type", Number)
], CreateReadingDto.prototype, "weight_grams", void 0);
__decorate([
    (0, class_validator_1.IsOptional)(),
    (0, class_validator_1.IsIn)(['ble', 'wifi', 'sync', 'manual'], {
        message: 'Source must be one of: ble, wifi, sync, manual',
    }),
    __metadata("design:type", String)
], CreateReadingDto.prototype, "source", void 0);
__decorate([
    (0, class_validator_1.IsOptional)(),
    (0, class_validator_1.IsDateString)({}, { message: 'Invalid date format for recorded_at' }),
    __metadata("design:type", String)
], CreateReadingDto.prototype, "recorded_at", void 0);
//# sourceMappingURL=create-reading.dto.js.map