import common from '@ohos.app.ability.common';
import resourceManager from '@ohos.resourceManager';
import { SensorService } from '../services/SensorService';
import { GestureRecognizer } from '../services/GestureRecognizer';
import { AudioService } from '../services/AudioService';
import { Cooldown } from '../utils/Cooldown';
import { Config } from '../constants/Config';

@Entry
@Component
struct Index {
  private sensor = new SensorService();
  private recognizer = new GestureRecognizer();
  private audio = new AudioService();
  private cooldown = new Cooldown(Config.COOLDOWN_MS);

  @State running: boolean = false;
  @State scoreText: string = '0.00';
  @State lastEvent: string = '-';

  aboutToAppear(): void {
    this.prepareAudio();
  }

  private async prepareAudio(): Promise<void> {
    const ctx = getContext(this) as common.UIAbilityContext;
    const rm = ctx.resourceManager as resourceManager.ResourceManager;
    const fd = await rm.getRawFd('gunshot.wav');
    await this.audio.init(fd);
  }

  private startDetect(): void {
    this.sensor.start(async (sample) => {
      const result = this.recognizer.feed(sample);
      this.scoreText = result.score.toFixed(2);
      this.lastEvent = result.reason ?? '-';
      if (result.isFire && this.cooldown.allow(result.timestamp)) {
        await this.audio.playGunshot();
      }
    });
    this.running = true;
  }

  private stopDetect(): void {
    this.sensor.stop();
    this.running = false;
  }

  build() {
    Column({ space: 12 }) {
      Text('GT4 开火手势 Demo').fontSize(22).fontWeight(FontWeight.Bold)
      Text(`状态: ${this.running ? '检测中' : '已停止'}`)
      Text(`平滑加速度: ${this.scoreText}`)
      Text(`事件: ${this.lastEvent}`)

      Button(this.running ? '停止检测' : '开始检测')
        .onClick(() => {
          this.running ? this.stopDetect() : this.startDetect();
        })
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .justifyContent(FlexAlign.Center)
  }
}
