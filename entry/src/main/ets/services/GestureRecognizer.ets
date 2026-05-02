import { AccSample } from '../model/AccSample';
import { GestureResult } from '../model/GestureResult';
import { Config } from '../constants/Config';
import { magnitude, movingAverage } from '../utils/MathUtil';

enum FireState {
  READY,
  PEAK,
}

export class GestureRecognizer {
  private state: FireState = FireState.READY;
  private peakTs: number = 0;
  private recent: number[] = [];

  feed(sample: AccSample): GestureResult {
    const mag = magnitude(sample);
    this.recent.push(mag);
    if (this.recent.length > Config.MOVING_AVG_SIZE) {
      this.recent.shift();
    }

    const smooth = movingAverage(this.recent);

    if (this.state === FireState.READY && smooth >= Config.FIRE_THRESHOLD) {
      this.state = FireState.PEAK;
      this.peakTs = sample.timestamp;
      return { isFire: false, score: smooth, timestamp: sample.timestamp, reason: 'peak_detected' };
    }

    if (this.state === FireState.PEAK) {
      const timedOut = sample.timestamp - this.peakTs > Config.WINDOW_MS;
      if (smooth <= Config.DROP_THRESHOLD) {
        this.state = FireState.READY;
        return { isFire: true, score: smooth, timestamp: sample.timestamp, reason: 'peak_drop_confirmed' };
      }
      if (timedOut) {
        this.state = FireState.READY;
        return { isFire: false, score: smooth, timestamp: sample.timestamp, reason: 'window_timeout' };
      }
    }

    return { isFire: false, score: smooth, timestamp: sample.timestamp, reason: 'tracking' };
  }
}
