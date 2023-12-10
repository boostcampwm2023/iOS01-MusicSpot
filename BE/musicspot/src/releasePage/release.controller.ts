import { Controller, Get, Render, Res } from '@nestjs/common';
import { Response } from 'express';
import * as fs from 'fs';
import { join } from 'path';
@Controller('release')
export class ReleaseController {
  @Get()
  sendReleasePage(@Res() res: Response) {
    res
      .status(200)
      .sendFile(join(__dirname, '..', '..', 'public', 'release.html'));
  }
}
