+++
title = 'The Joker Economy'
date = 2026-11-07T11:36:40-08:00
draft = false
description = 'What fourteen years of American mah jongg cards say about dragons, flowers, and jokers.'
cover.image = '/posts/2026-11-07-the-joker-economy.webp'
cover.hidden = false
keywords = ["mahjong", "joker", "statistics", "csv"]
tags = ["data-analysis", "mahjong", "programming"]
ShowToc = true
+++

## I Should Be Looking for a Job

The polite thing to do during a job search is network, polish the resume,
and answer recruiter email promptly. I have done some of that, I promise.
But I've also spent a healthy chunk of this fall learning American mah
jongg instead — and because I have never met a file format I didn't want
to parse, I ended up turning fourteen years of the National Mah Jongg
League's annual cards into statistics.

If you don't play, here's the short version: American mah jongg is its own
thing, distinct from the riichi and Hong Kong styles most of the world
plays. The National Mah Jongg League (NMJL) has been publishing an annual
card of winning hands since the 1930s, and the card is the game — when the
new one arrives each spring, the whole landscape of valid hands changes
and every player re-learns it. The card is copyrighted, and selling it is
the league's business, so this post reproduces no hands and no tile
patterns — aggregate statistics only. If you play, buy the real card from
[nationalmahjonggleague.org](https://www.nationalmahjonggleague.org/).
Consider that my good deed for the day.

The full analysis — both CSVs, the method, the caveats — lives in
[a gist](https://gist.github.com/chicks-net/23fa3bc125ab87aa2bd0f19ce56f0bc8),
which I'm keeping around as the permanent record for this little project.
This post is the guided tour. If you want to load the data into a
spreadsheet and make your own charts, the gist is your playground.

## The Headline Numbers

Fourteen consecutive years of cards, 2013 through 2026, 749 named hands in
total. Percentages are of each year's named hands as digitized (51 to 55
per year — there's a unit-of-analysis caveat later, and it matters):

| Year | Hands | Dragons | Winds | Flowers | Concealed | Req. joker | No joker |
| ---- | ----- | ------- | ----- | ------- | --------- | ---------- | -------- |
| 2013 | 52 | 28.8% | 15.4% | 42.3% | 26.9% | 7.7% | 13.5% |
| 2014 | 52 | 32.7% | 15.4% | 42.3% | 26.9% | 7.7% | 13.5% |
| 2015 | 51 | 31.4% | 15.7% | 47.1% | 25.5% | 7.8% | 13.7% |
| 2016 | 52 | 30.8% | 19.2% | 46.2% | 28.8% | 7.7% | 13.5% |
| 2017 | 52 | 28.8% | 13.5% | 40.4% | 26.9% | 7.7% | 13.5% |
| 2018 | 54 | 37.0% | 18.5% | 48.1% | 25.9% | 7.4% | 13.0% |
| 2019 | 53 | 32.1% | 17.0% | 45.3% | 26.4% | 7.5% | 13.2% |
| 2020 | 54 | 33.3% | 18.5% | 42.6% | 25.9% | 7.4% | 13.0% |
| 2021 | 54 | 33.3% | 20.4% | 44.4% | 22.2% | 7.4% | 11.1% |
| 2022 | 55 | 30.9% | 16.4% | 41.8% | 23.6% | 7.3% | 10.9% |
| 2023 | 55 | 32.7% | 16.4% | 45.5% | 23.6% | 5.5% | 10.9% |
| 2024 | 55 | 30.9% | 18.2% | 45.5% | 21.8% | 7.3% | 10.9% |
| 2025 | 55 | 38.2% | 18.2% | 49.1% | 23.6% | 5.5% | 10.9% |
| 2026 | 55 | 34.5% | 21.8% | 40.0% | 21.8% | 5.5% | 10.9% |

Pooled across all 749 hands: 32.4% use dragons, 17.5% use winds, and
44.4% use flowers; 25.0% are concealed; 6.9% require a joker; and 12.3%
cannot contain one. Expand the multi-option hands and you get 1,110
enumerated patterns — pattern-level percentages are in the CSV.

## What the Numbers Say

### Dragons, Winds, and Flowers

- **Dragons (29-38%)** never dip low because the year-hand section uses
  soap — the white dragon — as its zeros. That section is 100% dragons
  every year before the Winds & Dragons section and the scattered dragon
  kongs elsewhere even show up. The 2025 peak (38.2%) checks out against
  independent analysis of the printed card:
  [iLoveMahj](https://ilovemahj.com/2025-card-analysis) noted dragons were
  better represented in 2025 than 2024 (38.2% vs 30.9% here).
- **Winds (13-22%)** are the rarest of the three and live mostly in the
  Winds & Dragons section. 2026 is the windiest card of the series at
  21.8%, with winds in six of nine sections.
- **Flowers (40-49%)** are the workhorse. Pairs, pungs, and kongs of
  flowers appear across every section, which is why every mahj teacher
  tells you never to pass flowers in the Charleston. The numbers back up
  the advice.

### Hands That Require a Joker (5.5-7.8% per year)

Across all 14 years and 749 hands, not one hand prints a joker in its
pattern. The digitization's notation supports printed jokers — the token
`J` exists — and no NMJL card file from 2013 to 2026 uses it, not once.
Joker-requirement is always structural: any quint or sextet of a tile
with only four copies in the 152-tile set. That turns out to be exactly
the Quints section, every year — four hands (7.7%) through 2022, three
hands (5.5%) since 2023 when the section slimmed down. One 2026 nuance:
the new flower sextet hand (six of eight flowers) is the one super-group
hand that does not need a joker.

### Hands That Cannot Contain a Joker (10.9-13.7% per year)

Jokers may only substitute in groups of three or more identical tiles —
pungs, kongs, quints, sextets — so a hand with no such group can never
hold one. That is exactly the Singles & Pairs section, every year, no
exceptions: seven hands (~13.5%) through 2020, six (~11%) since 2021.
Note that *concealed* does not mean *no-joker*: concealed hands with
pungs happily use jokers in those groups.

Which leaves the economy this post is named after: roughly 7% of hands
force you to have jokers, ~12% forbid them, and the ~81% in between are
where joker strategy actually lives. Fourteen years of cards, and that
split barely wobbles.

## How I Counted

- Source: the card files (`am_card_nmjl_2013.jq` through
  `am_card_nmjl_2025.jq`, plus `am_card_nmjl_2026.majs`) in the
  [Riichi Advanced](https://github.com/EpicOrange/riichi_advanced)
  repository (AGPL-3.0), an open-source mahjong client that digitizes
  each year's named hands, point values, concealed flags, and tile
  patterns as playable rulesets. Fourteen years of card files sitting in
  a public repo — you can see how a person who parses things for a living
  might lose an afternoon to that. (And no, `.jq` is not the jq tool,
  though I enjoyed the coincidence.)
- Notation semantics verified against the engine's own parser
  (`lib/riichi_advanced/game/game_state/american.ex`): digits are
  literal tiles (`0` is soap, the white dragon); `X`-prefixed tokens are
  relative offsets (flexible numbers); `D` plus a suit letter is a suited
  dragon; `F` is flowers; `N/E/W/S` are winds; and `Z` is a wind wildcard
  (e.g. `ZZZZ` is a kong of any wind).
- Every hand was parsed, its `|` alternatives expanded, and each
  expanded variant validated to sum to exactly 14 tiles. Fifteen hands
  got flagged — see the quirks below.
- Joker-eligibility follows the engine's own logic: groups of three or
  more identical tiles are joker-usable; singles, pairs, and mixed
  groups (like NEWS) are tagged no-joker.

## Definitions

- **Hand** — one named hand in the digitization (a "hand family");
  multi-option hands count once ("NNNN EEE WWW SSSS or NNN EEEE WWWW
  SSS" is one hand with two patterns).
- **Uses dragons** — the pattern contains a dragon group or a
  soap-as-zero tile in at least one variant.
- **Requires joker** — every variant contains a group of five or more
  identical non-flower tiles, impossible to build from the four-copy
  tile supply without jokers (flowers excepted; there are eight).
- **No joker allowed** — no variant contains any group of three or more
  identical tiles.
- **Concealed** — flagged concealed in the digitization
  (`has_no_call_named`).

## Caveats

Every dataset has fine print. Mine has more than most, which is what
happens when the source is a fan transcription of a copyrighted card:

- **Unit of analysis.** The 51-55 "hands" per year are hand families as
  digitized. The printed 2025 card lists 71 lines, and fully expanded
  playable hands number 1,002 by iLoveMahj's count — percentages shift a
  few points depending on the unit. The main CSV includes pattern-level
  percentages (over the 73-104 enumerated patterns per year) so the unit
  effect is visible.
- **Unofficial digitization.** This is a fan transcription of a
  copyrighted card, itself unlicensed. Treat the numbers as derived data
  and cross-check anything that matters against the printed card.
- **`Z` means winds, not jokers.** In this notation `Z` is a wildcard
  wind. An early draft of this analysis misread those tokens as printed
  jokers; the corrected reading is what is documented here, and the
  zero-printed-joker finding reflects it. Read the parser, not just the
  data.
- **Cross-validation.** Against
  [iLoveMahj's 2025 card analysis](https://ilovemahj.com/2025-card-analysis):
  dragons up in 2025 vs 2024 (38.2% vs 30.9% here, matching their note);
  no flower/dragon/wind quints on the 2025 card (matching); flowers in
  52.2% of playable hands there vs 49.1% of hand families here
  (different units, same ballpark).

## Transcription Quirks

The 14-tile validation flagged fifteen hands across fourteen years. None
of them change the headline statistics, but as someone who has typoed a
config file or two in his life, I present them with sympathy:

- 2013 — a `33ea` typo in 13579 #4 (likely `333a`); Winds & Dragons
  #3/#4 ask for six of one suit (`111a 111a`, presumably two suits; the
  same hand family persists in 2015).
- 2014 — year hand #1 wants five Souths (wind-letter typo); 369 #3/#5
  put two kongs or pungs of the same tile in one suit (eight or six
  copies).
- 2016 — Quints #1 is missing spaces (`XX0aX1aX2a`); 369 #5 repeats the
  same-suit duplication quirk.
- 2021 — year hand #3 wants five 2s of one suit (suspected suit typo).
- 2022 — Consecutive Run #2 is 12 tiles (two short).
- 2026 — Consecutive Run #5's second option is 13 tiles (likely `XX1b`
  should read `XXX1b`).
- 2020 #2 and 2022 #1 — kongs of reds and greens together: legal hands,
  flagged only by the validator's conservative tile-pool check.

## Go Play With the Data

The [gist](https://gist.github.com/chicks-net/23fa3bc125ab87aa2bd0f19ce56f0bc8)
holds both CSVs:

- `nmjl_card_stats_2013_2026.csv` — per-year statistics, 21 columns. The
  `hand_*` columns are shares and counts of named hands; the `pattern_*`
  columns are shares of enumerated patterns; the `*_n` columns are
  counts.
- `nmjl_sections_2013_2026.csv` — per-section, per-year breakdown (135
  rows). Counts are hands in that section having each property. Section
  names are as they appear in the digitized files, including the
  rotating "gimmick" section (Seven Hands, Eleven Hands, Lucky 13,
  Addition Hands, Lucky Sevens — absent after 2024).

Credit where it is due: the data source is
[Riichi Advanced](https://github.com/EpicOrange/riichi_advanced)
(AGPL-3.0), an open-source mahjong client with digitized NMJL cards for
2013-2026. The cross-checks come from
[iLoveMahj's 2025 card analysis](https://ilovemahj.com/2025-card-analysis).
And the cards themselves belong to the
[National Mah Jongg League](https://www.nationalmahjonggleague.org/) —
buy yours, and whatever you do, don't pass your flowers in the
Charleston.

If a recruiter asks, this was professional development in data analysis.
