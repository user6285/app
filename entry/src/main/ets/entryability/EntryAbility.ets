import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';

export default class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        console.error(`[EntryAbility] loadContent failed: ${JSON.stringify(err)}`);
        return;
      }
      console.info('[EntryAbility] loadContent success');
    });
  }
}
