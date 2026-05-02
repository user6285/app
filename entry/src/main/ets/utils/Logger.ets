export class Logger {
  static info(tag: string, msg: string): void {
    console.info(`[${tag}] ${msg}`);
  }

  static warn(tag: string, msg: string): void {
    console.warn(`[${tag}] ${msg}`);
  }
}
