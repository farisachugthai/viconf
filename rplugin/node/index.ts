import { listManager, ExtensionContext, workspace } from 'coc.nvim';
// import Marketplace from './coc_tag';

export async function activate(context: ExtensionContext): Promise<void> {
  const { subscriptions } = context;
  const { nvim } = workspace;

  // subscriptions.push(listManager.registerList(new Marketplace(nvim)));
}
