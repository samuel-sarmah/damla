# Öz Su — Bottled Water Delivery (TRNC)

A Rails 8 app for a bottled-water delivery business operating across the six
districts of Northern Cyprus (TRNC). Customers browse the catalog, check
delivery coverage on an interactive map, and place orders by web or WhatsApp.
Staff manage orders through a small internal panel.

## Features

- **Product catalog** — 0.5L–19L bottles, translatable names, deposit handling
  for refillable jugs
- **Delivery-zone check** — Leaflet map of the 6 districts with live coverage
  status and a per-district form fallback
- **Order placement** — public and staff order forms with an optional map pin
  (`geo_lat`/`geo_lng`) as a driver aid on top of the required free-text address
- **WhatsApp ordering** — prefilled WhatsApp messages with a prebuilt message
  template
- **Staff panel** — cookie-session auth, password reset, and CRUD for orders
- **Localization** — English and Turkish (Mobility), locale-scoped public routes

## Stack

- Ruby on Rails 8.1, PostgreSQL
- Hotwire (Turbo + Stimulus) via importmap
- Tailwind CSS (`tailwindcss-rails`)
- Leaflet 1.9.4 (vendored at `vendor/javascript/leaflet.js`, pinned in
  `config/importmap.rb`)
- Redcarpet for markdown trust pages
- Phonelib for E.164 phone handling

## Setup

```sh
bin/setup        # installs gems, sets up the database, seeds it
bin/rails server # http://localhost:3000
```

Assets (CSS/JS) are compiled and watched automatically by the `Procfile.dev`
entrypoint.

### Seeding

`bin/rails db:seed` (idempotent) creates:

- 5 products with English/Turkish names
- 6 delivery zones with per-district delivery days
- A staff user `staff@ozsu.example`

## Configuration

| Variable | Purpose |
| --- | --- |
| `STAFF_SEED_PASSWORD` | Initial password for the seeded staff user (defaults to `changeme123` — change in production) |
| `WHATSAPP_BUSINESS_NUMBER` | Number used for WhatsApp order links (defaults to a placeholder) |
| `RAILS_MASTER_KEY` | Rails credentials key (production) |

## Staff panel

Routes are **not** locale-scoped and live under `/staff`:

- `/staff/session` — sign in
- `/staff/passwords` — reset password
- `/staff/delivery_orders` — list, create, view, update orders

## Localization

Public routes require a locale segment (`/:locale`, currently `tr|en`). Add a
locale by updating `I18n.available_locales`, the `locale` route constraint, and
the `config/locales/*.yml` files.

## Linting

```sh
bundle exec rubocop
```

## Deployment

Deployment is set up for Render (`render.yaml`), with a `Dockerfile`,
`Procfile.dev` for local asset watching, and Thruster for HTTP asset
caching/compression in production.
