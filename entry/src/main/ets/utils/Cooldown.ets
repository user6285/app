export class Cooldown {
  private lastTs: number = 0;

  constructor(private readonly intervalMs: number) {}

  allow(now: number): boolean {
    if (now - this.lastTs < this.intervalMs) {
      return false;
    }
    this.lastTs = now;
    return true;
  }
}
