---
type: page
layout: single
title: Home
weight: 1
---

### Base URL

https://cdn.jsdelivr.net/gh/altbdoor/d2-api-human@data/

### Weapons list

Choose between a simple, or a detailed list of weapons.

1.  A detailed list of weapons, with as many information as possible, including possible perks and stats. Useful to build a customized data set.
    - https://cdn.jsdelivr.net/gh/altbdoor/d2-api-human@data/weapons/all.json
    - [View sample usage](https://stackblitz.com/edit/typescript-at68mj?file=index.ts)
1.  A list of weapons with only the very basic information. Suitable for search and filter operations.
    - https://cdn.jsdelivr.net/gh/altbdoor/d2-api-human@data/weapons/all_lite.json
    - [View sample usage](https://stackblitz.com/edit/typescript-fj47qu?file=index.ts)

### Weapons by ID

Retrieve weapon information with the weapon hash or ID.

1.  As an example, the ID of [The Mountaintop](https://www.light.gg/db/items/3993415705/the-mountaintop/) is `3993415705`.
1.  https://cdn.jsdelivr.net/gh/altbdoor/d2-api-human@data/weapons/id/3993415705.json

### Weapons by name

Retrieve weapon information with the weapon name.

1.  As an example, the name of [Jötunn](https://www.light.gg/db/items/417164956/j%C3%B6tunn/).
1.  Convert the name to lowercase, `jötunn`.
1.  Convert all diacritics to ASCII, `jotunn`.
1.  Remove any characters that are not alphanumeric
    - Which is not really applicable to Jötunn, but it does to others like [21% Delirium](https://www.light.gg/db/items/1600633250/21-delirium/), which becomes `21delirium`. Notice the missing space, and percentage in `21delirium`.
5.  [https://cdn.jsdelivr.net/gh/altbdoor/d2-api-human@data/weapons/name/jotunn.json](https://cdn.jsdelivr.net/gh/altbdoor/d2-api-human@data/weapons/name/jotunn.json)
6.  Do note that some weapons start with `The`, like [The Messenger](https://www.light.gg/db/items/3658188704/the-messenger/), which will be `themessenger.json`.

### File regeneration

To note, the daily reset for Bungie is at 5:00 PM UTC time. We added a levy of **2 hours and 20 mins** to accommodate any possible downtimes. Hence, the JSON files will be regenerated every day, at 7.20 PM UTC time.

### File caching

All the JSON files are served from [jsDelivr](https://www.jsdelivr.com/) CDN, which to quote:

> Our caching logic and headers are optimized for production use and applies to all non-custom endpoints.
>
> - Branches - 12 hours.
>
> &mdash; https://github.com/jsdelivr/jsdelivr#caching

jsDelivr will cache the JSON files up to 12 hours. But for browsers, it might be up to seven days. To get a newer data from the browser cache, we can append a query parameter. Example:

```ts {hl_lines=["4"]}
const baseUrl = 'https://cdn.jsdelivr.net/gh/altbdoor/d2-api-human@data'
const currentDayInEpoch = Math.floor(Date.now() / 1000 / 86400)

fetch(`${baseUrl}/weapons/all_lite.json?ts=${currentDayInEpoch}`)
  .then((res) => res.json())
```

In the example above, the `currentDayInEpoch` is divided to get the number of days since [epoch](https://en.wikipedia.org/wiki/Unix_time).
