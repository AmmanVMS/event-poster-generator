# Event Poster Generator

This is a poster generator for the Amman Valley MakerSpace.
It provides a form to input the name, title and other information for each event so everyone can generate their own poster easily.

Useful links:

- **[Generate a poster!](https://AmmanVMS.github.io/event-poster-generator/)**
- **[Join the discussion](https://ammanvalley.foss.wales/t/poster-generator/111)**

## Setup

```bash
# install dependencies
$ npm install

# serve with hot reload at localhost:3000
$ npm run dev

# build for production and launch server
$ npm run build
$ npm run start

# generate static project to `docs`
$ npm run generate
```

## Adapt To Your Own Events

1. Change `router.base` in `nuxt.config.js` to be the base of your server path
2. Change the form in `pages/index.vue`.
3. If you need auto-completion of the form, change `pages/data` and the logic with `trackZh` and `trackEn` in `pages/index.vue`.
4. If you are looking for a tool to generate QR code with different reference information in the URL, please check out [Ovilia/qr-baker](https://github.com/Ovilia/qr-baker/blob/main/index.js).

## Framework

This repo uses [NuxtJS](https://nuxtjs.org/).

For detailed explanation on how things work, check out the [documentation](https://nuxtjs.org).

## Research

- https://github.com/GunarakulanGunaretnam/auto-poster-generator - does placement on arbitrary posters - we need layouting
- https://github.com/Open-Source-Bazaar/osb-poster - heading markdown, formatting, QR-Code, picture - fits! https://kaiyuanshe.cn/coscon-poster/
- https://awesomeopensource.com/project/brentthorne/posterdown - unknown if usable. For conferences.
- https://github.com/patrick-kidger/mkposters - worth looking at - generates posters that can be printed
