/// <reference types="node" />
import * as child from 'child_process';

import { ExtensionContext } from 'coc.nvim';

// export declare function activate(context: ExtensionContext): Promise<ExtensionApi | undefined>;
export { getTagFiles, loadTags, activate }  from "./coc_tag"
