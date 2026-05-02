import sensor from '@ohos.sensor';
import { AccSample } from '../model/AccSample';
import { Config } from '../constants/Config';

export type SensorCallback = (sample: AccSample) => void;

export class SensorService {
  private callback?: SensorCallback;
  private listening = false;

  start(cb: SensorCallback): void {
    if (this.listening) {
      return;
    }
    this.callback = cb;
    sensor.on(sensor.SensorId.ACCELEROMETER, (data) => {
      this.callback?.({
        x: data.x,
        y: data.y,
        z: data.z,
        timestamp: Date.now(),
      });
    }, {
      interval: Config.SAMPLE_INTERVAL_MS * 1000,
    });
    this.listening = true;
  }

  stop(): void {
    if (!this.listening) {
      return;
    }
    sensor.off(sensor.SensorId.ACCELEROMETER);
    this.listening = false;
  }
}
