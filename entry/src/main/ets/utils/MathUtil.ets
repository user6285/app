import { AccSample } from '../model/AccSample';

export function magnitude(s: AccSample): number {
  return Math.sqrt(s.x * s.x + s.y * s.y + s.z * s.z);
}

export function movingAverage(values: number[]): number {
  if (values.length === 0) {
    return 0;
  }
  return values.reduce((a, b) => a + b, 0) / values.length;
}
