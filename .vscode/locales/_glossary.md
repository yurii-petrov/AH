# Ukrainian terminology glossary — Arkham Horror 3ed

Canonical EN → UA for game terms. Derived from the translations already in `locales/uk.po`
(the numbers below are how often each form actually occurs, so these are the project's real
conventions, not invented ones).

Use this whenever adding or editing a `msgstr` in `uk.po`, and as the knowledge base for any
translation work done outside the repo.

## Core game terms

| English | Ukrainian | Notes |
|---|---|---|
| doom | приреченість | `Розподілити приреченість` = spread doom |
| clue | зачіпка | not «підказка» in rules text — see the UI exception below |
| monster | монстр | |
| gate | ворота | `прорив воріт` = gate burst |
| terror | морок | |
| encounter | зустріч | |
| mythos | міт | `чаша міту` = mythos cup |
| headline | заголовок | |
| investigator | дослідник | |
| anomaly | аномалія | |
| codex | кодекс | |
| archive | архів | |
| neighborhood | район | |
| street | вулиця | |
| token | жетон | |
| deck | колода | |
| ally | союзник | |
| expansion | доповнення | |
| scenario | сценарій | |

## Known inconsistencies to fix on sight

These already differ between strings in `uk.po`. Pick the first form when touching the string.

| English | Use | Also present | Why |
|---|---|---|---|
| Ancient One | **стародавній** | древній | Two different roots in use; pick one and keep it. |
| Random | **Випадковий** | Рандом | «Рандом» is a slangy transliteration. |
| clue (button) | **Зачіпка** | Підказка | `objects/Tile4ActionButtons.d706d4.ttslua` hardcodes «Підказка» outside the `.po` pipeline. |

## Case conventions

Case differences between entries are **intentional, not inconsistencies**:

- **ALL CAPS** — button labels: `ЗМІНИТИ СЦЕНАРІЙ`, `ПОЧАТИ ГРУ`, `РОЗМІСТИТИ МОНСТРА`
- **Sentence case** — log lines, tooltips, body text: `Розмістіть на одну зачіпку менше…`

So `spawn monster` legitimately appears as both `РОЗМІСТИТИ МОНСТРА` (button) and
`Розмістити Монстра` (label). Do not "fix" these to match.

## Grammar notes

- Ukrainian needs the right case for the grammatical role — the glossary lists the nominative.
  `жетон приреченості` (genitive), `на зачіпку менше` (accusative).
- Plural forms after a numeral change: `%s успіхи` (2–4) vs `%s успіхів` (5+). Both exist in
  `uk.po` on purpose; check which numeral range the string covers before editing.
- `%s` placeholders must survive translation, in the same order as in `en.po`.

## Workflow

`locales/en.po` is the source of truth; `locales/uk.po` is the translation. Never hand-edit
`src/Global/i18n/data.ttslua` — it is generated. See `_translation-notes.md` for the `msgid`
naming convention, and the `add-string` skill for the exact commands.
