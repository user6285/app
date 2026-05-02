import media from '@ohos.multimedia.media';
import { Logger } from '../utils/Logger';

export class AudioService {
  private player?: media.AudioPlayer;
  private initialized = false;

  async init(rawFd: media.AVFileDescriptor): Promise<void> {
    this.player = await media.createAudioPlayer();
    this.player.fdSrc = rawFd;
    await this.player.prepare();
    this.initialized = true;
  }

  async playGunshot(): Promise<void> {
    if (!this.player || !this.initialized) {
      Logger.warn('AudioService', 'play ignored: not initialized');
      return;
    }
    await this.player.seek(0);
    await this.player.play();
  }
}
