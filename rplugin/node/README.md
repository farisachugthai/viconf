# README

At a certain point you may be wondering how many README's one
repository could reasonably have right?

```typescript

../../../../../../home/casey/.local/share/nvim/plugged/coc.nvim/lib/model/floatFactory.d.ts:14:43 - error TS2507: Type 'typeof EventEmitter' is not a constructor function type.

14 export default class FloatFactory extends EventEmitter implements Disposable {

```

What the hell is this error message?

Running `yarn build`, which invokes `tsc`, generates that and
another one similar error message about typeof EventEmitter
but the fact that it's being emitted by coc-nvim is a little
disconcerting.
